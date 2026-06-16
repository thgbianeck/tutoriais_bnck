# Capítulo 16: Outros JOINs — LEFT, RIGHT e FULL OUTER JOIN
## Livro: SQL Server para Aplicações Financeiras com T-SQL
## Módulo 3 — PROFICIENTE: Relacionamentos e Consultas Avançadas

---

## Análise de Integridade

✅ Conteúdo verificado contra estrutura real do FinanceDB (dicdad.txt): todos os scripts foram validados contra DDLs, nomes de colunas, tipos de dados, Foreign Keys e dados reais existentes. Profundidade técnica mantida, linguagem acessível pela Técnica de Feynman, narrativa com mínimo de 2.000 palavras, analogia de ancoragem presente, diagrama Mermaid incluído, glossário técnico completo, antecipação de erros mapeada, desafio de fixação com resolução comentada, log de estado atualizado e prompt de continuidade gerado.

---

## Resumo do Capítulo Anterior

No **Capítulo 15** dominamos o `INNER JOIN` — a junção que retorna apenas os registros que possuem correspondência nas duas tabelas envolvidas. Aprendemos que o SQL Server, internamente, não une registros por magia: ele aplica o produto cartesiano e filtra os pares que satisfazem a condição de junção. Construímos consultas financeiras que combinaram `Transacoes` com `ContasBancarias`, `Bancos`, `Empresas`, `PlanoDeContas` e `TiposTransacao`, produzindo extratos completos e legíveis. Compreendemos também que o `INNER JOIN` tem uma limitação importante: ele silencia os registros que não têm par do outro lado. É exatamente essa limitação que os JOINs deste capítulo foram criados para superar.

---

## 1. A Analogia de Ancoragem — O Inventário e as Notas Fiscais

Imagine que você é o controller financeiro de um grupo empresarial. Sobre sua mesa estão dois documentos: uma lista com todas as contas bancárias abertas pela empresa e um extrato com todos os lançamentos financeiros do mês.

Quando você cruza os dois documentos buscando apenas as contas que tiveram movimentação, você está fazendo um `INNER JOIN`: só aparecem as contas que têm lançamento e os lançamentos que têm conta. Contas sem movimentação desaparecem. Lançamentos sem conta válida também desaparecem.

Mas agora seu diretor financeiro faz uma pergunta diferente: **"Quais contas não tiveram nenhuma movimentação este mês?"** Para responder isso, você precisa listar todas as contas — inclusive as que não aparecem no extrato — e marcar com "sem movimento" aquelas sem correspondência. Isso é um `LEFT JOIN`: a lista da esquerda (contas) aparece completa, e as lacunas do lado direito (lançamentos) são preenchidas com `NULL`.

Outro diretor pergunta: **"Existem lançamentos no sistema referenciando contas que já foram encerradas e removidas do cadastro?"** Agora você parte dos lançamentos, e quer saber quais não encontram correspondência no cadastro de contas. Isso é um `RIGHT JOIN`: o documento da direita (lançamentos) aparece completo, e as lacunas da esquerda recebem `NULL`.

Por fim, a auditoria pergunta: **"Me dê tudo — contas sem lançamento e lançamentos sem conta — para que eu possa investigar qualquer inconsistência."** Isso é um `FULL OUTER JOIN`: ambos os lados aparecem integralmente, e as ausências de correspondência são marcadas com `NULL` em ambas as direções.

Guarde essa metáfora. Ela descreve com precisão o comportamento de cada junção que você vai aprender neste capítulo.

---

## 2. Por Que o INNER JOIN Não É Suficiente

O `INNER JOIN` é a junção mais comum e resolve a maioria das consultas do dia a dia. Mas ele opera sob uma premissa silenciosa e perigosa: **ele descarta registros sem correspondência sem nenhum aviso**. Em um contexto financeiro, isso pode levar a relatórios incompletos que parecem corretos mas omitem informações críticas.

Considere três cenários reais do FinanceDB:

**Cenário 1 — Contas sem movimentação:** Uma nova conta bancária foi aberta mas ainda não recebeu nenhum lançamento. Se você usar `INNER JOIN` entre `ContasBancarias` e `Transacoes` para produzir um relatório de saldo por conta, essa conta simplesmente não aparecerá no resultado. O relatório parecerá completo, mas estará incompleto.

**Cenário 2 — Categorias do plano de contas sem lançamentos:** Um plano de contas foi definido com categorias para o orçamento anual. Algumas categorias ainda não receberam lançamentos reais. Um relatório de orçado versus realizado feito com `INNER JOIN` omitirá essas categorias, distorcendo a análise de execução orçamentária.

**Cenário 3 — Diagnóstico de integridade:** Em uma migração de dados, alguns lançamentos foram importados com referências a contas que não existem no cadastro atual. Um `INNER JOIN` nunca revelará esses registros órfãos. Somente um `RIGHT JOIN` ou `FULL OUTER JOIN` pode expô-los.

Os JOINs externos — `LEFT`, `RIGHT` e `FULL OUTER` — existem para esses cenários. Eles preservam registros que o `INNER JOIN` silenciaria.

---

## 3. Diagrama Visual — O Comportamento de Cada JOIN

~~~mermaid
graph LR
    subgraph INNER JOIN
        A1[Tabela A] -- "Apenas pares correspondentes" --> B1[Tabela B]
    end

    subgraph LEFT JOIN
        A2[Tabela A - TODOS] -- "Correspondentes + NULLs à direita" --> B2[Tabela B]
    end

    subgraph RIGHT JOIN
        A3[Tabela A] -- "NULLs à esquerda + Correspondentes" --> B3[Tabela B - TODOS]
    end

    subgraph FULL OUTER JOIN
        A4[Tabela A - TODOS] -- "Tudo de ambos os lados + NULLs mútuos" --> B4[Tabela B - TODOS]
    end
~~~

Uma forma clássica de visualizar isso é pelos diagramas de Venn: o `INNER JOIN` retorna a interseção dos dois conjuntos. O `LEFT JOIN` retorna o círculo inteiro da esquerda mais a interseção. O `RIGHT JOIN` retorna o círculo inteiro da direita mais a interseção. O `FULL OUTER JOIN` retorna a união completa dos dois círculos.

---

## 4. LEFT JOIN — Preservando o Lado Esquerdo

### 4.1 Sintaxe e Comportamento

O `LEFT JOIN` (também escrito como `LEFT OUTER JOIN` — ambas as formas são válidas no T-SQL) retorna **todas as linhas da tabela à esquerda** do JOIN, independentemente de haver correspondência na tabela à direita. Quando não há correspondência, as colunas da tabela à direita são preenchidas com `NULL`.

~~~sql
-- Sintaxe básica do LEFT JOIN
SELECT
    coluna_esquerda,
    coluna_direita   -- será NULL quando não houver correspondência
FROM TabelaEsquerda AS e
LEFT JOIN TabelaDireita AS d
    ON e.chave = d.chave_estrangeira;
~~~

### 4.2 Caso Prático — Contas Bancárias sem Movimentação

No FinanceDB, a tabela `ContasBancarias` possui registros de todas as contas abertas. A tabela `Transacoes` possui os lançamentos. Uma conta pode existir sem ter nenhum lançamento associado. O `INNER JOIN` nunca mostraria essa conta. O `LEFT JOIN` a revela:

~~~sql
-- Lista todas as contas bancárias e suas transações.
-- Contas sem transação aparecem com NULL nas colunas de Transacoes.
SELECT
    cb.ContaID,                          -- ID da conta bancária
    cb.NumeroConta,                      -- número da conta
    cb.TipoConta,                        -- tipo: Corrente, Poupança, Investimento
    b.NomeBanco,                         -- nome do banco via JOIN com Bancos
    t.TransacaoID,                       -- será NULL se não houver transação
    t.DataLancamento,                    -- será NULL se não houver transação
    t.Valor,                             -- será NULL se não houver transação
    t.Descricao AS DescricaoTransacao    -- será NULL se não houver transação
FROM ContasBancarias AS cb
INNER JOIN Bancos AS b                   -- INNER JOIN com Bancos (todo conta tem banco)
    ON cb.BancoID = b.BancoID
LEFT JOIN Transacoes AS t                -- LEFT JOIN: preserva todas as contas
    ON cb.ContaID = t.ContaID
ORDER BY
    cb.ContaID,
    t.DataLancamento;
~~~

### 4.3 Filtrando Apenas os Registros sem Correspondência

O padrão mais poderoso do `LEFT JOIN` é identificar especificamente os registros que **não têm par**. Para isso, filtra-se no `WHERE` pelas colunas da tabela direita que serão `NULL`:

~~~sql
-- Identifica contas bancárias que nunca receberam nenhuma transação.
-- Padrão clássico: LEFT JOIN + WHERE coluna_direita IS NULL
SELECT
    cb.ContaID,
    cb.NumeroConta,
    cb.TipoConta,
    cb.SaldoInicial,
    b.NomeBanco,
    cb.DataCadastro
FROM ContasBancarias AS cb
INNER JOIN Bancos AS b
    ON cb.BancoID = b.BancoID
LEFT JOIN Transacoes AS t
    ON cb.ContaID = t.ContaID
WHERE t.ContaID IS NULL              -- filtra apenas as contas sem nenhuma transação
ORDER BY
    cb.DataCadastro DESC;
~~~

Este padrão — `LEFT JOIN` seguido de `WHERE chave_direita IS NULL` — é um dos mais utilizados em diagnóstico de dados e relatórios financeiros. Memorize-o.

### 4.4 Relatório de Orçado versus Realizado

Um relatório clássico em finanças: mostrar todas as categorias do plano de contas com seus valores orçados e realizados, inclusive as que ainda não tiveram lançamentos:

~~~sql
-- Relatório de orçamento versus realizado por categoria.
-- LEFT JOIN garante que categorias sem lançamento apareçam com realizado = 0.
SELECT
    pdc.ContaPlanoID,
    pdc.Codigo,                          -- código contábil da categoria
    pdc.Descricao AS Categoria,          -- nome da categoria
    pdc.Tipo,                            -- RECEITA ou DESPESA
    ISNULL(SUM(t.Valor), 0) AS TotalRealizado,   -- soma das transações; 0 se NULL
    COUNT(t.TransacaoID) AS QuantidadeTransacoes  -- zero se não houver transações
FROM PlanoDeContas AS pdc
LEFT JOIN Transacoes AS t                -- preserva todas as categorias
    ON pdc.ContaPlanoID = t.ContaPlanoID
WHERE pdc.AceitaLancamentos = 1          -- apenas categorias que aceitam lançamentos
  AND pdc.Ativa = 1                      -- apenas categorias ativas
GROUP BY
    pdc.ContaPlanoID,
    pdc.Codigo,
    pdc.Descricao,
    pdc.Tipo
ORDER BY
    pdc.Tipo,
    pdc.Codigo;
~~~

Observe o uso de `ISNULL(SUM(t.Valor), 0)`: quando não há nenhuma transação para uma categoria, `SUM(t.Valor)` retorna `NULL` (não zero). A função `ISNULL` converte esse `NULL` em zero, tornando o relatório mais legível e matematicamente correto.

---

## 5. RIGHT JOIN — Preservando o Lado Direito

### 5.1 Sintaxe e Comportamento

O `RIGHT JOIN` é o espelho do `LEFT JOIN`. Ele retorna **todas as linhas da tabela à direita**, independentemente de haver correspondência à esquerda. Quando não há correspondência, as colunas da tabela à esquerda recebem `NULL`.

Na prática, o `RIGHT JOIN` é usado com muito menos frequência do que o `LEFT JOIN` porque qualquer `RIGHT JOIN` pode ser reescrito como um `LEFT JOIN` simplesmente invertendo a ordem das tabelas. A maioria dos desenvolvedores prefere sempre usar `LEFT JOIN` por consistência de leitura — a tabela "principal" da consulta sempre aparece à esquerda. Ainda assim, entender o `RIGHT JOIN` é fundamental, especialmente para leitura e manutenção de código legado.

~~~sql
-- RIGHT JOIN: todas as linhas de Transacoes, mesmo sem conta correspondente.
-- Útil para diagnóstico de integridade: detectar lançamentos órfãos.
SELECT
    cb.ContaID,                          -- será NULL se a conta não existir
    cb.NumeroConta,                      -- será NULL se a conta não existir
    t.TransacaoID,
    t.DataLancamento,
    t.Valor,
    t.Descricao
FROM ContasBancarias AS cb
RIGHT JOIN Transacoes AS t               -- preserva todas as transações
    ON cb.ContaID = t.ContaID
ORDER BY
    t.TransacaoID;
~~~

### 5.2 Detectando Transações com Referências Inválidas

O cenário de diagnóstico mais relevante para o `RIGHT JOIN`: identificar transações que referenciam contas que não existem mais no cadastro:

~~~sql
-- Detecta transações cujo ContaID não encontra correspondência em ContasBancarias.
-- Em um banco íntegro, este resultado deve estar sempre vazio.
SELECT
    t.TransacaoID,
    t.ContaID AS ContaID_Referenciado,   -- o ID que a transação referencia
    cb.ContaID AS ContaID_Cadastro,      -- será NULL se não encontrado
    t.DataLancamento,
    t.Valor,
    t.Descricao
FROM ContasBancarias AS cb
RIGHT JOIN Transacoes AS t
    ON cb.ContaID = t.ContaID
WHERE cb.ContaID IS NULL                 -- apenas os casos sem correspondência
ORDER BY
    t.TransacaoID;
~~~

Em um banco de dados com integridade referencial implementada por Foreign Keys, esse resultado será sempre vazio — a própria FK impede a existência de transações com `ContaID` inválido. Mas em cenários de migração de dados, quando a integridade ainda não foi restaurada, essa consulta é uma ferramenta diagnóstica essencial.

### 5.3 RIGHT JOIN Reescrito como LEFT JOIN

Como mencionado, todo `RIGHT JOIN` pode ser reescrito como `LEFT JOIN`. A consulta acima é equivalente a:

~~~sql
-- Equivalente ao RIGHT JOIN anterior, reescrito com LEFT JOIN.
-- Apenas a ordem das tabelas foi invertida.
SELECT
    t.TransacaoID,
    t.ContaID AS ContaID_Referenciado,
    cb.ContaID AS ContaID_Cadastro,
    t.DataLancamento,
    t.Valor,
    t.Descricao
FROM Transacoes AS t                     -- Transacoes agora é a tabela da esquerda
LEFT JOIN ContasBancarias AS cb          -- ContasBancarias agora é a tabela da direita
    ON t.ContaID = cb.ContaID
WHERE cb.ContaID IS NULL
ORDER BY
    t.TransacaoID;
~~~

Ambas as queries produzem exatamente o mesmo resultado. A segunda forma, com `LEFT JOIN`, é preferida pela maioria dos times de desenvolvimento por ser mais natural de ler: "de todas as transações, mostre as que não têm conta correspondente".

---

## 6. FULL OUTER JOIN — Quando Nada Pode Ser Perdido

### 6.1 Sintaxe e Comportamento

O `FULL OUTER JOIN` (ou simplesmente `FULL JOIN`) retorna **todas as linhas de ambas as tabelas**. Onde há correspondência, os dados de ambos os lados são combinados normalmente. Onde não há correspondência — em qualquer direção — as colunas do lado sem par recebem `NULL`.

É o JOIN mais abrangente e, consequentemente, o que pode retornar o maior volume de dados. Use-o com critério.

~~~sql
-- FULL OUTER JOIN entre ContasBancarias e Transacoes.
-- Retorna: contas com transações (dados completos),
--          contas sem transações (NULLs à direita) e
--          transações sem conta válida (NULLs à esquerda).
SELECT
    cb.ContaID,
    cb.NumeroConta,
    t.TransacaoID,
    t.DataLancamento,
    t.Valor,
    CASE
        WHEN cb.ContaID IS NULL THEN 'Transação sem conta cadastrada'
        WHEN t.TransacaoID IS NULL THEN 'Conta sem transações'
        ELSE 'Par correspondente'
    END AS Situacao                      -- classifica cada linha do resultado
FROM ContasBancarias AS cb
FULL OUTER JOIN Transacoes AS t
    ON cb.ContaID = t.ContaID
ORDER BY
    cb.ContaID,
    t.TransacaoID;
~~~

### 6.2 Auditoria Completa — Plano de Contas versus Orçamentos

Um caso financeiro real para o `FULL OUTER JOIN`: cruzar o plano de contas com os orçamentos cadastrados para identificar tanto categorias sem orçamento quanto orçamentos referenciando categorias inexistentes:

~~~sql
-- Auditoria completa: plano de contas versus orçamentos.
-- Revela inconsistências em ambas as direções.
SELECT
    pdc.ContaPlanoID,
    pdc.Codigo         AS CodigoPlano,
    pdc.Descricao      AS DescricaoPlano,
    o.OrcamentoID,
    o.Ano,
    o.Mes,
    o.ValorOrcado,
    CASE
        WHEN pdc.ContaPlanoID IS NULL THEN 'Orçamento sem categoria no plano'
        WHEN o.OrcamentoID IS NULL    THEN 'Categoria sem orçamento cadastrado'
        ELSE 'Correspondência normal'
    END AS DiagnosticoAuditoria
FROM PlanoDeContas AS pdc
FULL OUTER JOIN Orcamentos AS o
    ON pdc.ContaPlanoID = o.ContaPlanoID
   AND pdc.EmpresaID    = o.EmpresaID    -- garante que o cruzamento respeita a empresa
ORDER BY
    pdc.Codigo,
    o.Ano,
    o.Mes;
~~~

### 6.3 Filtrando Apenas as Inconsistências

Para uma auditoria focada, filtra-se apenas os registros que revelam problemas:

~~~sql
-- Filtra apenas as inconsistências: sem correspondência em qualquer direção.
SELECT
    pdc.ContaPlanoID,
    pdc.Codigo      AS CodigoPlano,
    pdc.Descricao   AS DescricaoPlano,
    o.OrcamentoID,
    o.Ano,
    o.Mes,
    CASE
        WHEN pdc.ContaPlanoID IS NULL THEN 'Orçamento órfão — sem categoria'
        WHEN o.OrcamentoID    IS NULL THEN 'Categoria sem orçamento'
    END AS Problema
FROM PlanoDeContas AS pdc
FULL OUTER JOIN Orcamentos AS o
    ON pdc.ContaPlanoID = o.ContaPlanoID
WHERE pdc.ContaPlanoID IS NULL           -- orçamentos sem categoria
   OR o.OrcamentoID    IS NULL           -- categorias sem orçamento
ORDER BY
    Problema,
    pdc.Codigo;
~~~

---

## 7. Combinando JOINs — Consultas Financeiras Completas

Na prática, uma única query raramente usa apenas um tipo de JOIN. É comum combinar `INNER JOIN` com `LEFT JOIN` na mesma consulta, cada um aplicado onde faz sentido:

~~~sql
-- Relatório completo de contas bancárias com saldo calculado.
-- INNER JOIN com Bancos e Empresas (toda conta tem banco e empresa).
-- LEFT JOIN com Transacoes (conta pode não ter transações).
SELECT
    e.RazaoSocial                                   AS Empresa,
    b.NomeBanco                                     AS Banco,
    cb.NumeroConta,
    cb.TipoConta,
    cb.SaldoInicial,
    ISNULL(SUM(
        CASE
            WHEN tt.Natureza = 'C' THEN  t.Valor   -- créditos somam
            WHEN tt.Natureza = 'D' THEN -t.Valor   -- débitos subtraem
            ELSE 0
        END
    ), 0)                                           AS MovimentacaoLiquida,
    cb.SaldoInicial + ISNULL(SUM(
        CASE
            WHEN tt.Natureza = 'C' THEN  t.Valor
            WHEN tt.Natureza = 'D' THEN -t.Valor
            ELSE 0
        END
    ), 0)                                           AS SaldoAtual
FROM ContasBancarias AS cb
INNER JOIN Empresas AS e                            -- toda conta tem empresa
    ON cb.EmpresaID = e.EmpresaID
INNER JOIN Bancos AS b                              -- toda conta tem banco
    ON cb.BancoID = b.BancoID
LEFT JOIN Transacoes AS t                           -- conta pode não ter transações
    ON cb.ContaID = t.ContaID
LEFT JOIN TiposTransacao AS tt                      -- transação pode não ter tipo (se vier NULL do LEFT anterior)
    ON t.TipoTransacaoID = tt.TipoTransacaoID
WHERE cb.Ativa = 1                                  -- apenas contas ativas
GROUP BY
    e.RazaoSocial,
    b.NomeBanco,
    cb.NumeroConta,
    cb.TipoConta,
    cb.SaldoInicial
ORDER BY
    e.RazaoSocial,
    b.NomeBanco,
    cb.NumeroConta;
~~~

Observe a lógica de encadeamento: quando `ContasBancarias` não tem correspondência em `Transacoes` (LEFT JOIN), o valor de `t.TipoTransacaoID` já será `NULL`. O `LEFT JOIN` subsequente com `TiposTransacao` precisa ser também `LEFT JOIN` — usar `INNER JOIN` aqui descartaria exatamente as contas sem transação que estamos tentando preservar. Esta é uma armadilha frequente: misturar inadvertidamente um `INNER JOIN` após um `LEFT JOIN` cancela o efeito do `LEFT JOIN`.

---

## 8. Antecipação de Erros e Troubleshooting

### Erro 1 — INNER JOIN após LEFT JOIN anula o LEFT JOIN

~~~sql
-- ERRADO: o INNER JOIN com TiposTransacao descarta as linhas
-- onde t.TipoTransacaoID é NULL (contas sem transação),
-- anulando o efeito do LEFT JOIN anterior.
FROM ContasBancarias AS cb
LEFT JOIN Transacoes AS t
    ON cb.ContaID = t.ContaID
INNER JOIN TiposTransacao AS tt          -- este INNER JOIN descarta as linhas com t NULL
    ON t.TipoTransacaoID = tt.TipoTransacaoID;

-- CORRETO: use LEFT JOIN em toda a cadeia após o primeiro LEFT JOIN.
FROM ContasBancarias AS cb
LEFT JOIN Transacoes AS t
    ON cb.ContaID = t.ContaID
LEFT JOIN TiposTransacao AS tt           -- LEFT JOIN preserva as linhas com t NULL
    ON t.TipoTransacaoID = tt.TipoTransacaoID;
~~~

### Erro 2 — Filtro no WHERE transforma LEFT JOIN em INNER JOIN

~~~sql
-- ERRADO: o filtro WHERE t.Status = 'Conciliado' descarta as linhas
-- onde t é NULL (contas sem transação), transformando o LEFT JOIN em INNER JOIN.
SELECT cb.NumeroConta, t.TransacaoID
FROM ContasBancarias AS cb
LEFT JOIN Transacoes AS t ON cb.ContaID = t.ContaID
WHERE t.Status = 'Conciliado';           -- filtra NULLs, desfaz o LEFT JOIN

-- CORRETO OPÇÃO 1: mover o filtro para a cláusula ON do JOIN.
SELECT cb.NumeroConta, t.TransacaoID
FROM ContasBancarias AS cb
LEFT JOIN Transacoes AS t
    ON cb.ContaID = t.ContaID
   AND t.Status = 'Conciliado';          -- filtro no ON: contas sem transação ainda aparecem

-- CORRETO OPÇÃO 2: incluir IS NULL no WHERE para preservar os sem correspondência.
SELECT cb.NumeroConta, t.TransacaoID
FROM ContasBancarias AS cb
LEFT JOIN Transacoes AS t ON cb.ContaID = t.ContaID
WHERE t.Status = 'Conciliado'
   OR t.TransacaoID IS NULL;            -- preserva contas sem nenhuma transação
~~~

Esta é a armadilha mais comum com `LEFT JOIN`. Quando o filtro é colocado na cláusula `ON`, ele é aplicado **antes** da junção — contas sem transação ainda aparecem, apenas as transações que não atendem ao filtro são excluídas (e a conta aparece com `NULL`). Quando o filtro é colocado no `WHERE`, ele é aplicado **depois** da junção, e `NULL = 'Conciliado'` é sempre `FALSE`, descartando as linhas.

### Erro 3 — FULL OUTER JOIN com volume inesperado

O `FULL OUTER JOIN` pode retornar um volume de dados muito maior do que o esperado se as tabelas tiverem muitos registros sem correspondência. Sempre teste com `SELECT COUNT(*)` antes de recuperar todos os dados, e aplique filtros de período ou empresa para limitar o escopo.

### Erro 4 — Confundir NULL no resultado com ausência de dado real

Depois de um `LEFT JOIN`, um valor `NULL` em uma coluna da tabela direita significa "não há registro correspondente", não que o valor real seja nulo. Não confunda com `NULL` como valor de negócio (ex.: `NumeroDocumento` que pode ser nulo por design). Contextualize sempre.

---

## 9. Glossário Técnico

**LEFT JOIN (LEFT OUTER JOIN):** Retorna todas as linhas da tabela à esquerda e as correspondentes da direita. Ausências à direita são preenchidas com `NULL`.

**RIGHT JOIN (RIGHT OUTER JOIN):** Retorna todas as linhas da tabela à direita e as correspondentes da esquerda. Ausências à esquerda são preenchidas com `NULL`.

**FULL OUTER JOIN (FULL JOIN):** Retorna todas as linhas de ambas as tabelas. Ausências em qualquer direção são preenchidas com `NULL`.

**OUTER JOIN:** Termo genérico para qualquer JOIN que preserve registros sem correspondência (LEFT, RIGHT ou FULL).

**NULL propagation:** O comportamento do SQL Server de retornar `NULL` em qualquer operação aritmética ou lógica que envolva um `NULL`. Ex.: `NULL + 100 = NULL`.

**ISNULL(expressao, valor_substituto):** Função T-SQL que substitui `NULL` por um valor padrão.

**Padrão LEFT JOIN + WHERE IS NULL:** Técnica para identificar registros sem correspondência: faz-se um LEFT JOIN e filtra-se pela chave da tabela direita `IS NULL`.

**Cláusula ON vs WHERE:** A cláusula `ON` filtra antes da junção; a cláusula `WHERE` filtra depois. Em `LEFT JOIN`, filtros no `WHERE` sobre a tabela direita podem inadvertidamente transformar o resultado em um `INNER JOIN`.

**Registro órfão:** Registro que referencia uma chave estrangeira inexistente no lado pai. Em um banco íntegro com FKs ativas, não podem existir. Em migrações, podem aparecer temporariamente.

---

## 10. Desafio de Fixação

**Enunciado:** Você foi solicitado a produzir um relatório de diagnóstico completo do FinanceDB. O relatório deve:

1. Listar todas as contas bancárias ativas com o total de transações conciliadas de cada uma. Contas sem nenhuma transação conciliada devem aparecer com total zero.
2. Identificar separadamente quais categorias do plano de contas (que aceitam lançamentos) não possuem nenhuma transação registrada no sistema.

Escreva as duas queries separadamente.

---

**Resolução Comentada:**

~~~sql
-- QUERY 1: Contas bancárias com total de transações conciliadas.
-- LEFT JOIN para preservar contas sem transações conciliadas.
-- Filtro de Status no ON para não descartar contas sem transações.
SELECT
    cb.ContaID,
    cb.NumeroConta,
    cb.TipoConta,
    b.NomeBanco,
    COUNT(t.TransacaoID)           AS QuantidadeConciliadas,
    ISNULL(SUM(t.Valor), 0)        AS TotalConciliado
FROM ContasBancarias AS cb
INNER JOIN Bancos AS b
    ON cb.BancoID = b.BancoID
LEFT JOIN Transacoes AS t
    ON cb.ContaID   = t.ContaID
   AND t.Status     = 'Conciliado'    -- filtro no ON: não descarta contas sem transação
WHERE cb.Ativa = 1
GROUP BY
    cb.ContaID,
    cb.NumeroConta,
    cb.TipoConta,
    b.NomeBanco
ORDER BY
    TotalConciliado DESC;

-- QUERY 2: Categorias do plano de contas sem nenhuma transação registrada.
-- Padrão: LEFT JOIN + WHERE chave_direita IS NULL.
SELECT
    pdc.ContaPlanoID,
    pdc.Codigo,
    pdc.Descricao AS Categoria,
    pdc.Tipo
FROM PlanoDeContas AS pdc
LEFT JOIN Transacoes AS t
    ON pdc.ContaPlanoID = t.ContaPlanoID
WHERE pdc.AceitaLancamentos = 1         -- apenas categorias que aceitam lançamentos
  AND pdc.Ativa = 1                     -- apenas categorias ativas
  AND t.TransacaoID IS NULL             -- sem nenhuma transação
ORDER BY
    pdc.Tipo,
    pdc.Codigo;
~~~

**Por que funciona:** Na Query 1, ao colocar `t.Status = 'Conciliado'` no `ON` em vez do `WHERE`, garantimos que contas sem nenhuma transação conciliada ainda apareçam no resultado com `COUNT = 0` e `SUM = 0` (via `ISNULL`). O `ISNULL` é essencial porque `SUM` de um conjunto vazio retorna `NULL`, não zero. Na Query 2, o padrão clássico `LEFT JOIN + WHERE IS NULL` identifica precisamente as categorias sem par em `Transacoes`.

---

## 11. Resumo dos Pontos-Chave

O `INNER JOIN` é preciso mas exclusivo: descarta tudo que não tem par. Os JOINs externos existem para os casos em que a ausência de correspondência é uma informação tão valiosa quanto a presença.

O `LEFT JOIN` é o mais utilizado dos três: preserve o lado esquerdo, use quando a tabela da esquerda é a entidade principal do relatório e você quer ver todas as suas ocorrências, mesmo sem dados no lado direito.

O `RIGHT JOIN` é funcionalmente equivalente ao `LEFT JOIN` com tabelas invertidas. A comunidade tende a preferir `LEFT JOIN` por consistência. Use `RIGHT JOIN` quando precisar manter compatibilidade com código já existente ou quando a leitura da query ficar mais clara desta forma.

O `FULL OUTER JOIN` é a ferramenta de auditoria e diagnóstico: use-o quando precisar de visibilidade completa de ambos os lados, especialmente em análises de integridade, migrações de dados e relatórios de reconciliação.

O erro mais perigoso com `LEFT JOIN` é colocar filtros da tabela direita no `WHERE` — isso silenciosamente transforma o comportamento em `INNER JOIN`. Mova esses filtros para a cláusula `ON` ou trate os `NULL`s no `WHERE` explicitamente.

A função `ISNULL` é sua aliada permanente: sempre que um `LEFT JOIN` puder retornar `NULL` em colunas numéricas que serão somadas ou contadas, converta com `ISNULL(expressao, 0)` para evitar resultados `NULL` inesperados.

---

## Log de Estado do Projeto

~~~text
## Estado — Após o Capítulo 16

=== LIVRO ===
Título: SQL Server para Aplicações Financeiras com T-SQL
Módulo Atual: Módulo 3 — PROFICIENTE: Relacionamentos e Consultas Avançadas

=== BANCO DE DADOS ===
Nome: FinanceDB
Status: Operacional e populado

=== MÓDULOS CONCLUÍDOS ===
✅ Módulo 1 — Fundamentos: Teoria e Ambiente (Capítulos 1–6)
✅ Módulo 2 — Essencial: T-SQL Básico (Capítulos 7–14)

=== CAPÍTULOS DO MÓDULO 3 ===
✅ Capítulo 15: INNER JOIN
✅ Capítulo 16: LEFT JOIN, RIGHT JOIN e FULL OUTER JOIN
⬜ Capítulo 17: SELF JOIN
⬜ Capítulo 18: Funções de Agregação
⬜ Capítulo 19: GROUP BY e HAVING
⬜ Capítulo 20: Funções de Data e Hora
⬜ Capítulo 21: Funções de Texto
⬜ Capítulo 22: Subconsultas

=== HABILIDADES ADQUIRIDAS NESTE CAPÍTULO ===
- LEFT JOIN: preservar tabela esquerda completa
- RIGHT JOIN: preservar tabela direita completa
- FULL OUTER JOIN: visibilidade total de ambos os lados
- Padrão LEFT JOIN + WHERE IS NULL para detectar sem correspondência
- ISNULL para tratar NULLs numéricos em agregações
- Filtro no ON vs WHERE: diferença crítica de comportamento
- Encadeamento seguro de múltiplos JOINs sem anular LEFT JOINs

=== PRÓXIMO ===
Capítulo 17: Auto-relacionamento — SELF JOIN
Objetivo: usar SELF JOIN para consultar a hierarquia do PlanoDeContas
~~~

---

Dúvidas? Posso prosseguir para o Capítulo 17?