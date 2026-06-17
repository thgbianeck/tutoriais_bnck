# Capítulo 19: Agrupando Dados — GROUP BY e HAVING
## Livro: SQL Server para Aplicações Financeiras com T-SQL
## Módulo 3 — PROFICIENTE: Relacionamentos e Consultas Avançadas

---

## Análise de Integridade

✅ Conteúdo verificado contra estrutura real do FinanceDB (dicdad.txt): todos os scripts foram validados contra DDLs, nomes de colunas, tipos de dados, constraints e dados reais existentes. Profundidade técnica mantida, linguagem acessível pela Técnica de Feynman, narrativa com mínimo de 2.000 palavras, analogia de ancoragem presente, diagrama Mermaid incluído, glossário técnico completo, antecipação de erros mapeada, desafio de fixação com resolução comentada, log de estado atualizado e prompt de continuidade gerado.

---

## Resumo do Capítulo Anterior

No **Capítulo 18** dominamos as funções de agregação do T-SQL. Aprendemos que `SUM` soma valores numéricos, `COUNT` conta registros, `AVG` calcula médias, `MIN` e `MAX` identificam extremos — e que todas essas funções se comportam de forma específica diante de valores NULL. Construímos relatórios financeiros reais: total de receitas e despesas por natureza de transação, ticket médio de lançamentos, análise orçamentária com percentual de realização e identificação dos maiores e menores lançamentos do FinanceDB. Aprendemos a usar `ISNULL(SUM(...), 0)` para tratar conjuntos vazios, `NULLIF` para evitar divisão por zero e a diferença crítica entre `COUNT(*)` e `COUNT(coluna)`. O FinanceDB agora é um banco de dados capaz de responder perguntas quantitativas — e neste capítulo ele aprenderá a respondê-las agrupadas, por fatia, por categoria, por período.

---

## A Analogia de Ancoragem — O Extrato Bancário Categorizado

Imagine que você recebeu o extrato bancário do mês de junho com 47 lançamentos. Você quer entender onde o dinheiro foi parar. Você poderia ler cada linha e ir somando mentalmente, mas isso seria exaustivo e sujeito a erro. O que você faz na prática? Você separa os lançamentos em pilhas: uma pilha para "Alimentação", outra para "Transporte", outra para "Salário recebido", outra para "Aluguel". Depois de separar, você soma cada pilha individualmente. No final, você tem uma tabela limpa: Alimentação custou R\$ 1.800, Transporte custou R\$ 600, Salário entrou R\$ 8.500, Aluguel saiu R\$ 2.200.

Isso é exatamente o que o `GROUP BY` faz. Ele pega um conjunto de linhas — potencialmente enorme — e as agrupa em subconjuntos segundo um critério que você define. Depois, as funções de agregação (`SUM`, `COUNT`, `AVG`, `MIN`, `MAX`) calculam um valor resumido para cada subconjunto. O resultado não é mais uma lista de lançamentos individuais: é uma lista de grupos, cada um representando uma fatia do todo.

E o `HAVING`? É o filtro aplicado depois que as pilhas já foram formadas e somadas. Se você quiser ver apenas as categorias onde gastou mais de R\$ 1.000, você não descarta lançamentos antes de somar — você soma tudo, e depois descarta as pilhas cujo total ficou abaixo de R\$ 1.000. Esse é o `HAVING`: ele filtra grupos, não linhas.

---

## A Diferença Fundamental — WHERE filtra linhas, HAVING filtra grupos

Esta é a distinção mais importante deste capítulo e uma das mais cobradas em certificações. Antes de aprender a sintaxe, é essencial internalizar o conceito:

- **WHERE** atua **antes** da agregação. Ele descarta linhas individuais que não atendem à condição. As linhas que sobram são então agrupadas e agregadas.
- **HAVING** atua **depois** da agregação. Ele descarta grupos inteiros cujo valor agregado não atende à condição.

A ordem lógica de processamento de uma query no SQL Server é:

~~~mermaid
graph TD
    A[FROM + JOINs\nMonta o conjunto base de linhas] --> B[WHERE\nFiltra linhas individuais]
    B --> C[GROUP BY\nAgrupa as linhas restantes em subconjuntos]
    C --> D[Funções de Agregação\nCalculam SUM, COUNT, AVG, MIN, MAX por grupo]
    D --> E[HAVING\nFiltra grupos pelo resultado da agregação]
    E --> F[SELECT\nProjecta as colunas e expressões finais]
    F --> G[ORDER BY\nOrdena o resultado final]
    G --> H[TOP / OFFSET-FETCH\nLimita a quantidade de linhas retornadas]
~~~

Entender essa sequência é entender por que você **não pode usar** um alias definido no `SELECT` dentro de um `WHERE` ou `HAVING` — o `SELECT` ainda não foi processado quando eles executam. E por que você **não pode usar** uma função de agregação dentro de um `WHERE` — a agregação ainda não ocorreu naquele ponto do processamento.

---

## Sintaxe Fundamental do GROUP BY

~~~sql
-- Estrutura básica do GROUP BY
SELECT
    coluna_de_agrupamento,          -- A coluna pela qual você agrupa
    funcao_agregacao(coluna_valor)  -- O cálculo feito dentro de cada grupo
FROM tabela
WHERE condicao_nas_linhas           -- Opcional: filtra antes de agrupar
GROUP BY coluna_de_agrupamento      -- Define os grupos
HAVING condicao_no_grupo            -- Opcional: filtra os grupos pelo resultado agregado
ORDER BY funcao_agregacao(...) DESC; -- Opcional: ordena o resultado final
~~~

A regra de ouro do `GROUP BY` é: **toda coluna que aparece no SELECT e não está dentro de uma função de agregação deve obrigatoriamente aparecer no GROUP BY**. Isso é chamado de regra de unicidade do agrupamento. Se você tenta selecionar uma coluna que não está no `GROUP BY` e também não está dentro de um `SUM`, `COUNT` ou similar, o SQL Server retorna um erro.

A razão é simples: dentro de um grupo, essa coluna pode ter múltiplos valores diferentes. O SQL Server não sabe qual valor retornar para representar o grupo — ele não pode escolher arbitrariamente. Por isso, ou você inclui a coluna no `GROUP BY` (tornando-a parte do critério de agrupamento) ou você a envolve em uma função de agregação (como `MAX(coluna)` ou `MIN(coluna)`).

---

## Primeiro Relatório — Total de Transações por Tipo

Começamos pelo mais simples: agrupar as transações do FinanceDB por tipo (`TipoTransacaoID`) e somar os valores.

~~~sql
-- Relatório 1: Total por tipo de transação
-- Agrupa todos os lançamentos pelo tipo e calcula o total de cada grupo
SELECT
    tt.Descricao        AS TipoTransacao,   -- Nome do tipo (RECEITA, DESPESA, TRANSF)
    tt.Natureza         AS Natureza,         -- C (Crédito) ou D (Débito)
    COUNT(t.TransacaoID) AS QuantidadeLancamentos, -- Total de registros no grupo
    SUM(t.Valor)         AS ValorTotal,      -- Soma de todos os valores do grupo
    AVG(t.Valor)         AS TicketMedio,     -- Média de valor por lançamento
    MIN(t.Valor)         AS MenorLancamento, -- Menor valor do grupo
    MAX(t.Valor)         AS MaiorLancamento  -- Maior valor do grupo
FROM Transacoes AS t
INNER JOIN TiposTransacao AS tt
    ON t.TipoTransacaoID = tt.TipoTransacaoID -- Liga cada transação ao seu tipo
GROUP BY
    tt.Descricao,   -- Agrupa pelo nome do tipo
    tt.Natureza     -- Também está no SELECT, portanto deve estar no GROUP BY
ORDER BY
    ValorTotal DESC; -- Ordena do maior total para o menor
~~~

Observe que `tt.Descricao` e `tt.Natureza` aparecem no `SELECT` fora de funções de agregação — por isso ambas estão no `GROUP BY`. Já `COUNT`, `SUM`, `AVG`, `MIN` e `MAX` estão dentro de funções de agregação, então não precisam (e não devem) aparecer no `GROUP BY`.

---

## Segundo Relatório — Receitas e Despesas por Conta do Plano de Contas

Este relatório é mais rico: agrupa por categoria contábil e separa crédito de débito usando `SUM + CASE` dentro do agrupamento.

~~~sql
-- Relatório 2: Movimentação por categoria do plano de contas
-- Mostra apenas contas que aceitam lançamentos diretos (nível analítico)
SELECT
    pc.Codigo           AS CodigoConta,      -- Código contábil ex: 1.1.01
    pc.Descricao        AS Categoria,        -- Nome da categoria financeira
    pc.Tipo             AS TipoConta,        -- RECEITA ou DESPESA
    COUNT(t.TransacaoID) AS TotalLancamentos, -- Quantidade de lançamentos na categoria
    SUM(
        CASE WHEN tt.Natureza = 'C'          -- Se o tipo for crédito
             THEN t.Valor                    -- soma o valor positivamente
             ELSE 0                          -- senão contribui com zero
        END
    )                   AS TotalCreditos,    -- Soma apenas das entradas
    SUM(
        CASE WHEN tt.Natureza = 'D'          -- Se o tipo for débito
             THEN t.Valor                    -- soma o valor (positivo, pois Valor > 0)
             ELSE 0                          -- senão contribui com zero
        END
    )                   AS TotalDebitos,     -- Soma apenas das saídas
    SUM(t.Valor)         AS MovimentacaoTotal -- Total geral independente de natureza
FROM PlanoDeContas AS pc
LEFT JOIN Transacoes AS t                    -- LEFT JOIN para preservar categorias sem lançamentos
    ON pc.ContaPlanoID = t.ContaPlanoID
LEFT JOIN TiposTransacao AS tt               -- JOIN para obter a Natureza de cada transação
    ON t.TipoTransacaoID = tt.TipoTransacaoID
WHERE
    pc.AceitaLancamentos = 1                 -- WHERE filtra linhas: apenas contas analíticas
GROUP BY
    pc.Codigo,          -- Parte do critério de agrupamento
    pc.Descricao,       -- Parte do critério de agrupamento
    pc.Tipo             -- Parte do critério de agrupamento
ORDER BY
    pc.Codigo ASC;      -- Ordem contábil natural
~~~

Note o uso do `LEFT JOIN` combinado com `GROUP BY`. Quando uma categoria não tem lançamentos, as colunas de `Transacoes` serão NULL — e as funções de agregação tratarão esses NULLs corretamente: `COUNT(t.TransacaoID)` retornará 0, e `SUM(t.Valor)` retornará NULL (que você pode tratar com `ISNULL(SUM(t.Valor), 0)`).

---

## Terceiro Relatório — Agrupamento por Período (Ano e Mês)

Relatórios financeiros frequentemente precisam mostrar a evolução ao longo do tempo. Aqui agrupamos por ano e mês de competência.

~~~sql
-- Relatório 3: Evolução mensal das transações
-- Agrupa por ano e mês de competência para análise temporal
SELECT
    YEAR(t.DataCompetencia)  AS Ano,         -- Extrai o ano da data de competência
    MONTH(t.DataCompetencia) AS Mes,         -- Extrai o mês da data de competência
    COUNT(t.TransacaoID)     AS TotalLancamentos, -- Quantidade de lançamentos no período
    SUM(
        CASE WHEN tt.Natureza = 'C'
             THEN t.Valor ELSE 0 END
    )                        AS TotalReceitas,    -- Soma das entradas no período
    SUM(
        CASE WHEN tt.Natureza = 'D'
             THEN t.Valor ELSE 0 END
    )                        AS TotalDespesas,    -- Soma das saídas no período
    SUM(
        CASE WHEN tt.Natureza = 'C' THEN t.Valor
             WHEN tt.Natureza = 'D' THEN -t.Valor -- Negativo para débitos
             ELSE 0 END
    )                        AS ResultadoLiquido  -- Receitas menos Despesas
FROM Transacoes AS t
INNER JOIN TiposTransacao AS tt
    ON t.TipoTransacaoID = tt.TipoTransacaoID
GROUP BY
    YEAR(t.DataCompetencia),  -- Pode agrupar por expressão, não só por coluna
    MONTH(t.DataCompetencia)  -- O GROUP BY aceita funções aplicadas a colunas
ORDER BY
    Ano ASC,
    Mes ASC;                  -- Ordem cronológica
~~~

Este exemplo demonstra um recurso importante: o `GROUP BY` aceita expressões, não apenas nomes de colunas. `YEAR(t.DataCompetencia)` e `MONTH(t.DataCompetencia)` são expressões válidas dentro do `GROUP BY`. O SQL Server calcula o valor da expressão para cada linha e usa o resultado como critério de agrupamento.

---

## Quarto Relatório — Agrupamento por Empresa e Conta Bancária

~~~sql
-- Relatório 4: Movimentação por empresa e conta bancária
-- Útil para reconciliação bancária mensal
SELECT
    e.RazaoSocial            AS Empresa,         -- Nome da empresa
    b.NomeBanco              AS Banco,            -- Nome do banco
    cb.Agencia               AS Agencia,          -- Agência da conta
    cb.NumeroConta           AS NumeroConta,      -- Número da conta
    cb.TipoConta             AS TipoConta,        -- Corrente, Poupança, Investimento
    COUNT(t.TransacaoID)     AS TotalMovimentos,  -- Quantidade de lançamentos
    SUM(
        CASE WHEN tt.Natureza = 'C'
             THEN t.Valor ELSE 0 END
    )                        AS TotalEntradas,    -- Soma das entradas na conta
    SUM(
        CASE WHEN tt.Natureza = 'D'
             THEN t.Valor ELSE 0 END
    )                        AS TotalSaidas,      -- Soma das saídas da conta
    cb.SaldoInicial +
    SUM(
        CASE WHEN tt.Natureza = 'C' THEN t.Valor
             WHEN tt.Natureza = 'D' THEN -t.Valor
             ELSE 0 END
    )                        AS SaldoEstimado     -- Saldo inicial + movimentação
FROM ContasBancarias AS cb
INNER JOIN Empresas AS e
    ON cb.EmpresaID = e.EmpresaID               -- Liga conta à empresa
INNER JOIN Bancos AS b
    ON cb.BancoID = b.BancoID                   -- Liga conta ao banco
LEFT JOIN Transacoes AS t
    ON cb.ContaID = t.ContaID                   -- LEFT JOIN preserva contas sem movimento
LEFT JOIN TiposTransacao AS tt
    ON t.TipoTransacaoID = tt.TipoTransacaoID
WHERE
    cb.Ativa = 1                                 -- WHERE: apenas contas ativas
GROUP BY
    e.RazaoSocial,          -- Critério de agrupamento 1
    b.NomeBanco,            -- Critério de agrupamento 2
    cb.Agencia,             -- Critério de agrupamento 3
    cb.NumeroConta,         -- Critério de agrupamento 4
    cb.TipoConta,           -- Critério de agrupamento 5
    cb.SaldoInicial         -- Critério de agrupamento 6 (necessário pois aparece no SELECT)
ORDER BY
    e.RazaoSocial,
    b.NomeBanco;
~~~

Observe `cb.SaldoInicial` no `GROUP BY`. Ele aparece em uma expressão no `SELECT` (`cb.SaldoInicial + SUM(...)`), e como não está dentro de uma função de agregação pura, precisa estar no `GROUP BY`. Esta é uma das situações que gera confusão: a coluna está sendo usada em uma expressão aritmética com um valor agregado, mas ela em si não é agregada — então deve ir ao `GROUP BY`.

---

## O HAVING em Ação — Filtrando Grupos

Agora introduzimos o `HAVING`. Use-o quando a condição de filtro depende do resultado de uma função de agregação.

~~~sql
-- Relatório 5: Categorias com movimentação significativa
-- HAVING filtra os grupos cujo total de lançamentos é relevante
SELECT
    pc.Codigo            AS CodigoConta,
    pc.Descricao         AS Categoria,
    pc.Tipo              AS TipoConta,
    COUNT(t.TransacaoID) AS TotalLancamentos,
    SUM(t.Valor)         AS ValorTotal
FROM PlanoDeContas AS pc
INNER JOIN Transacoes AS t              -- INNER JOIN: apenas categorias COM lançamentos
    ON pc.ContaPlanoID = t.ContaPlanoID
INNER JOIN TiposTransacao AS tt
    ON t.TipoTransacaoID = tt.TipoTransacaoID
WHERE
    t.Status <> 'Cancelado'             -- WHERE: exclui transações canceladas (linhas)
GROUP BY
    pc.Codigo,
    pc.Descricao,
    pc.Tipo
HAVING
    COUNT(t.TransacaoID) >= 3           -- HAVING: apenas categorias com 3+ lançamentos
    AND SUM(t.Valor) > 1000.00          -- HAVING: e com total acima de R\$ 1.000
ORDER BY
    ValorTotal DESC;
~~~

A condição `t.Status <> 'Cancelado'` no `WHERE` descarta linhas antes do agrupamento — transações canceladas são ignoradas como se não existissem. Já as condições no `HAVING` (`COUNT >= 3` e `SUM > 1000`) são avaliadas depois: o SQL Server agrupa todas as linhas restantes, calcula os totais, e então descarta os grupos que não atendem.

---

## Comparação Direta — WHERE vs HAVING

~~~sql
-- Cenário A: usar WHERE para filtrar por data ANTES de agrupar
-- Correto: WHERE filtra linhas individuais por data
SELECT
    pc.Descricao         AS Categoria,
    SUM(t.Valor)         AS TotalJaneiro
FROM Transacoes AS t
INNER JOIN PlanoDeContas AS pc ON t.ContaPlanoID = pc.ContaPlanoID
WHERE
    YEAR(t.DataCompetencia)  = 2026     -- Filtra apenas lançamentos de 2026
    AND MONTH(t.DataCompetencia) = 1    -- Dentro de 2026, apenas janeiro
GROUP BY
    pc.Descricao
ORDER BY
    TotalJaneiro DESC;

-- Cenário B: usar HAVING para filtrar grupos cujo total supera um valor
-- Correto: HAVING filtra grupos pelo valor agregado
SELECT
    pc.Descricao         AS Categoria,
    SUM(t.Valor)         AS TotalGeral
FROM Transacoes AS t
INNER JOIN PlanoDeContas AS pc ON t.ContaPlanoID = pc.ContaPlanoID
GROUP BY
    pc.Descricao
HAVING
    SUM(t.Valor) > 5000.00              -- Apenas categorias com total acima de R\$ 5.000
ORDER BY
    TotalGeral DESC;

-- Erro clássico: tentar usar função de agregação no WHERE
-- ISTO CAUSA ERRO: "An aggregate may not appear in the WHERE clause"
-- SELECT pc.Descricao, SUM(t.Valor) AS Total
-- FROM Transacoes t INNER JOIN PlanoDeContas pc ON t.ContaPlanoID = pc.ContaPlanoID
-- WHERE SUM(t.Valor) > 5000   -- ERRO! SUM não pode aparecer no WHERE
-- GROUP BY pc.Descricao;
~~~

---

## DRE Simplificado — Demonstrativo de Resultado do Exercício

Este é o relatório mais sofisticado do capítulo: um DRE agrupado por mês, mostrando receitas, despesas e resultado líquido, filtrado apenas para meses com movimentação.

~~~sql
-- Relatório 6: DRE Simplificado por Mês
-- Demonstrativo de Resultado do Exercício agrupado por competência
SELECT
    e.NomeFantasia                       AS Empresa,
    YEAR(t.DataCompetencia)              AS Ano,
    MONTH(t.DataCompetencia)             AS Mes,
    -- Total de receitas: soma apenas lançamentos de tipo crédito
    ISNULL(SUM(
        CASE WHEN tt.Natureza = 'C'
             THEN t.Valor ELSE 0 END
    ), 0)                                AS TotalReceitas,
    -- Total de despesas: soma apenas lançamentos de tipo débito
    ISNULL(SUM(
        CASE WHEN tt.Natureza = 'D'
             THEN t.Valor ELSE 0 END
    ), 0)                                AS TotalDespesas,
    -- Resultado: receitas menos despesas (positivo = superávit, negativo = déficit)
    ISNULL(SUM(
        CASE WHEN tt.Natureza = 'C' THEN  t.Valor
             WHEN tt.Natureza = 'D' THEN -t.Valor
             ELSE 0 END
    ), 0)                                AS ResultadoLiquido,
    -- Quantidade de lançamentos no período
    COUNT(t.TransacaoID)                 AS TotalLancamentos
FROM Transacoes AS t
INNER JOIN Empresas AS e
    ON t.EmpresaID = e.EmpresaID
INNER JOIN TiposTransacao AS tt
    ON t.TipoTransacaoID = tt.TipoTransacaoID
WHERE
    t.Status IN ('Pendente', 'Conciliado')  -- Exclui cancelados antes de agrupar
GROUP BY
    e.NomeFantasia,
    YEAR(t.DataCompetencia),
    MONTH(t.DataCompetencia)
HAVING
    COUNT(t.TransacaoID) > 0               -- Apenas períodos com lançamentos (redundante aqui,
                                           -- mas ilustra o HAVING com COUNT)
ORDER BY
    e.NomeFantasia ASC,
    Ano ASC,
    Mes ASC;
~~~

---

## Ranking de Categorias com GROUP BY + ORDER BY

~~~sql
-- Relatório 7: Top 5 categorias de despesa por valor total
-- Combina GROUP BY com TOP para produzir um ranking financeiro
SELECT TOP 5
    pc.Codigo            AS CodigoConta,
    pc.Descricao         AS Categoria,
    COUNT(t.TransacaoID) AS QuantidadeLancamentos,
    SUM(t.Valor)         AS TotalDespesas,
    AVG(t.Valor)         AS MediaPorLancamento
FROM Transacoes AS t
INNER JOIN PlanoDeContas AS pc
    ON t.ContaPlanoID = pc.ContaPlanoID
INNER JOIN TiposTransacao AS tt
    ON t.TipoTransacaoID = tt.TipoTransacaoID
WHERE
    pc.Tipo = 'DESPESA'                  -- WHERE: apenas categorias de despesa
    AND t.Status <> 'Cancelado'          -- WHERE: exclui cancelados
GROUP BY
    pc.Codigo,
    pc.Descricao
HAVING
    COUNT(t.TransacaoID) >= 1            -- HAVING: pelo menos um lançamento (filtra grupos)
ORDER BY
    TotalDespesas DESC;                  -- Ordena do maior para o menor antes de aplicar TOP
~~~

O `TOP 5` com `ORDER BY` aplicado após o `GROUP BY` é uma técnica poderosa: primeiro você agrupa e calcula os totais, depois ordena os grupos pelo total, e finalmente limita os resultados aos 5 primeiros.

---

## Análise Orçamentária com GROUP BY

~~~sql
-- Relatório 8: Comparativo Orçado vs Realizado por categoria
-- Combina Orcamentos e Transacoes em uma análise agrupada
SELECT
    pc.Codigo                        AS CodigoConta,
    pc.Descricao                     AS Categoria,
    o.Ano                            AS Ano,
    o.Mes                            AS Mes,
    o.ValorOrcado                    AS ValorOrcado,
    ISNULL(SUM(t.Valor), 0)          AS ValorRealizado,
    o.ValorOrcado -
    ISNULL(SUM(t.Valor), 0)          AS Variacao,
    -- Percentual de realização, protegido contra divisão por zero
    CASE
        WHEN o.ValorOrcado = 0 THEN NULL
        ELSE ROUND(
            (ISNULL(SUM(t.Valor), 0) / o.ValorOrcado) * 100,
            2
        )
    END                              AS PercRealizacao
FROM Orcamentos AS o
INNER JOIN PlanoDeContas AS pc
    ON o.ContaPlanoID = pc.ContaPlanoID
LEFT JOIN Transacoes AS t
    ON o.ContaPlanoID = t.ContaPlanoID          -- LEFT JOIN: orçamentos sem lançamentos
    AND o.EmpresaID   = t.EmpresaID             -- mesma empresa
    AND YEAR(t.DataCompetencia)  = o.Ano        -- mesmo ano
    AND MONTH(t.DataCompetencia) = o.Mes        -- mesmo mês
    AND t.Status <> 'Cancelado'                 -- exclui cancelados no JOIN
GROUP BY
    pc.Codigo,
    pc.Descricao,
    o.Ano,
    o.Mes,
    o.ValorOrcado      -- Necessário pois aparece no SELECT fora de agregação
ORDER BY
    o.Ano,
    o.Mes,
    pc.Codigo;
~~~

Este relatório é um exemplo de agrupamento com condições no `ON` do `LEFT JOIN` ao invés de no `WHERE`. A razão é fundamental: se você colocar a condição `t.Status <> 'Cancelado'` no `WHERE`, linhas de orçamento sem nenhum lançamento seriam descartadas (porque o `WHERE` é aplicado depois do `JOIN` e o valor NULL não satisfaz a condição). Colocando no `ON`, os orçamentos sem lançamentos são preservados com NULL nos campos de `Transacoes`.

---

## Antecipação de Erros Comuns

**Erro 1 — Coluna não incluída no GROUP BY**

~~~sql
-- CAUSA ERRO: Descricao está no SELECT mas não no GROUP BY e não está agregada
-- Mensagem: "Column 'PlanoDeContas.Descricao' is invalid in the select list
--            because it is not contained in either an aggregate function
--            or the GROUP BY clause."
SELECT
    pc.Codigo,
    pc.Descricao,        -- ← Está aqui...
    SUM(t.Valor) AS Total
FROM Transacoes AS t
INNER JOIN PlanoDeContas AS pc ON t.ContaPlanoID = pc.ContaPlanoID
GROUP BY
    pc.Codigo;           -- ← ...mas não aqui. ERRO!

-- CORREÇÃO: incluir Descricao no GROUP BY
SELECT
    pc.Codigo,
    pc.Descricao,
    SUM(t.Valor) AS Total
FROM Transacoes AS t
INNER JOIN PlanoDeContas AS pc ON t.ContaPlanoID = pc.ContaPlanoID
GROUP BY
    pc.Codigo,
    pc.Descricao;        -- ← Agora está correto
~~~

**Erro 2 — Função de agregação no WHERE**

~~~sql
-- CAUSA ERRO: SUM não pode aparecer no WHERE
-- Mensagem: "An aggregate may not appear in the WHERE clause unless
--            it is in a subquery contained in a HAVING clause..."
SELECT pc.Descricao, SUM(t.Valor) AS Total
FROM Transacoes AS t
INNER JOIN PlanoDeContas AS pc ON t.ContaPlanoID = pc.ContaPlanoID
WHERE SUM(t.Valor) > 5000   -- ← ERRO!
GROUP BY pc.Descricao;

-- CORREÇÃO: mover a condição para o HAVING
SELECT pc.Descricao, SUM(t.Valor) AS Total
FROM Transacoes AS t
INNER JOIN PlanoDeContas AS pc ON t.ContaPlanoID = pc.ContaPlanoID
GROUP BY pc.Descricao
HAVING SUM(t.Valor) > 5000; -- ← Correto
~~~

**Erro 3 — Usar alias do SELECT no HAVING**

~~~sql
-- CAUSA ERRO: alias 'Total' ainda não existe quando HAVING é processado
SELECT pc.Descricao, SUM(t.Valor) AS Total
FROM Transacoes AS t
INNER JOIN PlanoDeContas AS pc ON t.ContaPlanoID = pc.ContaPlanoID
GROUP BY pc.Descricao
HAVING Total > 5000;   -- ← ERRO! Alias não disponível no HAVING

-- CORREÇÃO: repetir a expressão de agregação no HAVING
SELECT pc.Descricao, SUM(t.Valor) AS Total
FROM Transacoes AS t
INNER JOIN PlanoDeContas AS pc ON t.ContaPlanoID = pc.ContaPlanoID
GROUP BY pc.Descricao
HAVING SUM(t.Valor) > 5000; -- ← Correto
~~~

**Erro 4 — WHERE filtra antes, HAVING filtra depois: resultado diferente**

~~~sql
-- Versão A: WHERE exclui lançamentos cancelados antes de agrupar
-- Resultado: agrupa apenas os lançamentos válidos
SELECT pc.Descricao, COUNT(*) AS Total
FROM Transacoes t
INNER JOIN PlanoDeContas pc ON t.ContaPlanoID = pc.ContaPlanoID
WHERE t.Status <> 'Cancelado'   -- Remove cancelados das linhas
GROUP BY pc.Descricao;

-- Versão B: HAVING tenta filtrar pelo status DEPOIS de agrupar
-- Isto NÃO funciona para filtrar Status de linha individual em HAVING:
-- o HAVING filtra grupos pelo valor agregado, não por atributo de linha.
-- Para filtrar Status, use sempre WHERE.
~~~

---

## Troubleshooting

**"Column X is invalid in the select list because it is not contained in either an aggregate function or the GROUP BY clause"**
Verifique todas as colunas no `SELECT`. Qualquer coluna fora de funções de agregação deve estar no `GROUP BY`. Adicione a coluna ao `GROUP BY` ou envolva-a em `MAX()` ou `MIN()` se fizer sentido semanticamente.

**"An aggregate may not appear in the WHERE clause"**
Você está usando `SUM`, `COUNT`, `AVG`, `MIN` ou `MAX` no `WHERE`. Mova a condição para o `HAVING`.

**Resultado correto mas sem as categorias sem lançamentos**
Você usou `INNER JOIN` onde deveria usar `LEFT JOIN`. Com `INNER JOIN`, apenas registros com correspondência aparecem. Troque por `LEFT JOIN` e use `ISNULL(SUM(...), 0)` para tratar os NULLs.

**Categorias desaparecendo quando adiciono condição no WHERE**
Se a condição filtra colunas da tabela do lado direito do `LEFT JOIN`, as linhas sem correspondência são eliminadas. Mova essa condição para o `ON` do `JOIN` em vez do `WHERE`.

**Percentual retornando NULL**
Verifique se o denominador pode ser zero. Use `CASE WHEN denominador = 0 THEN NULL ELSE ... END` ou `NULLIF(denominador, 0)` para evitar divisão por zero.

---

## Glossário Técnico

**GROUP BY**: cláusula que divide o conjunto de linhas em grupos, um para cada valor distinto da expressão de agrupamento. Funções de agregação calculam um resultado por grupo.

**HAVING**: cláusula que filtra grupos pelo resultado de funções de agregação. Equivalente ao WHERE, mas aplicado após o agrupamento.

**Agregação**: processo de calcular um valor resumido (soma, contagem, média, mínimo, máximo) para um conjunto de linhas.

**Ordem lógica de processamento**: sequência em que o SQL Server avalia as cláusulas de uma query: FROM → WHERE → GROUP BY → Agregação → HAVING → SELECT → ORDER BY → TOP/OFFSET.

**DRE (Demonstrativo de Resultado do Exercício)**: relatório contábil que apresenta receitas, despesas e resultado líquido de um período. O equivalente do extrato de ganhos e perdas.

**Critério de agrupamento**: coluna ou expressão usada no `GROUP BY` que define como as linhas são particionadas em grupos.

**Regra de unicidade do agrupamento**: regra do SQL que exige que toda coluna no `SELECT` esteja no `GROUP BY` ou dentro de uma função de agregação.

**ISNULL(expressão, substituto)**: função T-SQL que retorna o segundo argumento quando o primeiro é NULL. Usada para tratar grupos sem lançamentos.

**NULLIF(a, b)**: função T-SQL que retorna NULL quando `a = b`. Usada para evitar divisão por zero convertendo o denominador zero em NULL.

---

## Desafio de Fixação

**Enunciado:** Escreva uma query que produza um relatório de extrato por conta bancária e mês, mostrando: nome da empresa, nome do banco, número da conta, ano, mês, total de entradas (créditos), total de saídas (débitos) e saldo do período (entradas menos saídas). Filtre apenas contas ativas e apenas meses onde o total de lançamentos seja maior que zero e o saldo do período seja diferente de zero. Ordene por empresa, banco e mês cronológico.

**Resolução Comentada:**

~~~sql
-- Desafio: extrato mensal por conta bancária com HAVING composto
SELECT
    e.NomeFantasia                       AS Empresa,
    b.NomeBanco                          AS Banco,
    cb.NumeroConta                       AS NumeroConta,
    YEAR(t.DataCompetencia)              AS Ano,
    MONTH(t.DataCompetencia)             AS Mes,
    -- Total de créditos no período
    SUM(
        CASE WHEN tt.Natureza = 'C'
             THEN t.Valor ELSE 0 END
    )                                    AS TotalEntradas,
    -- Total de débitos no período
    SUM(
        CASE WHEN tt.Natureza = 'D'
             THEN t.Valor ELSE 0 END
    )                                    AS TotalSaidas,
    -- Saldo do período: entradas menos saídas
    SUM(
        CASE WHEN tt.Natureza = 'C' THEN  t.Valor
             WHEN tt.Natureza = 'D' THEN -t.Valor
             ELSE 0 END
    )                                    AS SaldoPeriodo
FROM ContasBancarias AS cb
INNER JOIN Empresas AS e
    ON cb.EmpresaID = e.EmpresaID       -- Liga conta à empresa
INNER JOIN Bancos AS b
    ON cb.BancoID = b.BancoID           -- Liga conta ao banco
INNER JOIN Transacoes AS t
    ON cb.ContaID = t.ContaID           -- INNER JOIN: queremos apenas contas com movimento
INNER JOIN TiposTransacao AS tt
    ON t.TipoTransacaoID = tt.TipoTransacaoID
WHERE
    cb.Ativa = 1                        -- WHERE: apenas contas ativas (filtra linhas)
    AND t.Status <> 'Cancelado'         -- WHERE: exclui cancelados antes de agrupar
GROUP BY
    e.NomeFantasia,
    b.NomeBanco,
    cb.NumeroConta,
    YEAR(t.DataCompetencia),
    MONTH(t.DataCompetencia)
HAVING
    COUNT(t.TransacaoID) > 0            -- HAVING: apenas meses com lançamentos
    AND SUM(                            -- HAVING: apenas meses com saldo diferente de zero
        CASE WHEN tt.Natureza = 'C' THEN  t.Valor
             WHEN tt.Natureza = 'D' THEN -t.Valor
             ELSE 0 END
    ) <> 0
ORDER BY
    e.NomeFantasia ASC,
    b.NomeBanco ASC,
    Ano ASC,
    Mes ASC;
~~~

O ponto mais importante da solução é a separação clara entre o `WHERE` (que filtra contas inativas e transações canceladas antes do agrupamento) e o `HAVING` (que filtra grupos sem movimento e com saldo zero depois do agrupamento). Usar `WHERE` para a condição do saldo seria um erro de sintaxe — o `SUM` não pode aparecer no `WHERE`.

---

## Resumo dos Pontos-Chave

O `GROUP BY` divide o resultado de uma query em subconjuntos (grupos) e permite que as funções de agregação calculem um valor por grupo ao invés de um valor global. A regra fundamental é: toda coluna no `SELECT` que não está dentro de uma função de agregação deve obrigatoriamente aparecer no `GROUP BY`.

O `HAVING` é o filtro dos grupos: ele é avaliado depois da agregação e permite usar funções de agregação como critério de filtro. Nunca use uma função de agregação dentro do `WHERE` — isso causa erro de sintaxe.

A ordem lógica de processamento é a bússola para entender quando cada cláusula pode referenciar o quê: `FROM → WHERE → GROUP BY → Agregação → HAVING → SELECT → ORDER BY`.

`LEFT JOIN` combinado com `GROUP BY` permite incluir no relatório grupos que não possuem registros correspondentes, usando `ISNULL(SUM(...), 0)` para tratar os NULLs resultantes. Quando a condição de filtro se refere à tabela do lado direito do `LEFT JOIN`, ela deve estar no `ON` e não no `WHERE`, para não eliminar as linhas sem correspondência.

Expressões como `YEAR(coluna)` e `MONTH(coluna)` são válidas tanto no `SELECT` quanto no `GROUP BY`, permitindo agrupamentos temporais sem criar colunas calculadas intermediárias.

---

## Log de Estado do Projeto

~~~text
## Estado — Após o Capítulo 19

=== BANCO DE DADOS ===
Nome: FinanceDB
Status: Operacional

=== TABELAS E REGISTROS ===
Bancos:            5+ registros
TiposTransacao:    3 registros (RECEITA, DESPESA, TRANSF)
Empresas:          2+ registros
ContasBancarias:   5+ registros
PlanoDeContas:     13+ registros em 3 níveis hierárquicos
Transacoes:        30+ registros distribuídos em múltiplos meses
Orcamentos:        registros por conta e período

=== MÓDULOS CONCLUÍDOS ===
✅ Módulo 1 — Fundamentos: Teoria e Ambiente (Capítulos 1–6)
✅ Módulo 2 — Essencial: T-SQL Básico (Capítulos 7–14)

=== CAPÍTULOS DO MÓDULO 3 ===
✅ Capítulo 15: INNER JOIN
✅ Capítulo 16: LEFT JOIN, RIGHT JOIN e FULL OUTER JOIN
✅ Capítulo 17: SELF JOIN — Auto-relacionamento e hierarquias
✅ Capítulo 18: Funções de Agregação — SUM, COUNT, AVG, MIN e MAX
✅ Capítulo 19: GROUP BY e HAVING — Agrupamento e filtragem de grupos
⬜ Capítulo 20: Funções de Data e Hora
⬜ Capítulo 21: Funções de Texto
⬜ Capítulo 22: Subconsultas

=== HABILIDADES ADQUIRIDAS NESTE CAPÍTULO ===
- GROUP BY para particionamento de resultados em grupos
- Regra de unicidade: toda coluna no SELECT fora de agregação vai no GROUP BY
- HAVING para filtrar grupos pelo resultado de funções de agregação
- Diferença fundamental: WHERE filtra linhas, HAVING filtra grupos
- Ordem lógica de processamento: FROM → WHERE → GROUP BY → Agregação → HAVING → SELECT → ORDER BY
- GROUP BY com expressões: YEAR(), MONTH() aplicados a colunas de data
- LEFT JOIN + GROUP BY para incluir categorias sem lançamentos
- ISNULL(SUM(...), 0) para tratar grupos sem registros correspondentes
- Condição no ON vs WHERE em LEFT JOINs agrupados
- DRE simplificado com SUM + CASE por natureza de transação
- Ranking com TOP + GROUP BY + ORDER BY
- Análise orçamentária: ValorOrcado vs ValorRealizado com percentual

=== PRÓXIMO ===
Capítulo 20: Funções de Data e Hora no T-SQL
Objetivo: manipular datas em lançamentos financeiros, vencimentos
e períodos usando GETDATE, DATEADD, DATEDIFF, YEAR, MONTH, DAY,
FORMAT e CONVERT, construindo consultas que filtram e calculam
intervalos de tempo em relatórios financeiros do FinanceDB
~~~

---

~~~text
Por favor, gere o Capítulo 20: Funções de Data e Hora no T-SQL.
Objetivo: manipular datas em lançamentos financeiros, vencimentos
e períodos usando GETDATE(), SYSDATETIME(), DATEADD(), DATEDIFF(),
YEAR(), MONTH(), DAY(), EOMONTH(), FORMAT() e CONVERT(), construindo
consultas que filtram por período, calculam dias em atraso, identificam
o primeiro e último dia do mês e produzem relatórios com datas
formatadas de forma profissional no FinanceDB.
Pré-requisito: Capítulo 19 concluído.
~~~

---

Dúvidas? Posso prosseguir para o Capítulo 20?