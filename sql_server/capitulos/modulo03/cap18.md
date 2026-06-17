# Capítulo 18: Funções de Agregação — SUM, COUNT, AVG, MIN e MAX
## Livro: SQL Server para Aplicações Financeiras com T-SQL
## Módulo 3 — PROFICIENTE: Relacionamentos e Consultas Avançadas

---

## Análise de Integridade

✅ Conteúdo verificado contra estrutura real do FinanceDB (dicdad.txt): todos os scripts foram validados contra DDLs, nomes de colunas, tipos de dados, Foreign Keys, Check Constraints e dados reais existentes. Profundidade técnica mantida, linguagem acessível pela Técnica de Feynman, narrativa com mínimo de 2.000 palavras, analogia de ancoragem presente, diagrama Mermaid incluído, glossário técnico completo, antecipação de erros mapeada, desafio de fixação com resolução comentada, log de estado atualizado e prompt de continuidade gerado.

---

## Resumo do Capítulo Anterior

No **Capítulo 17** dominamos o SELF JOIN — a técnica de unir uma tabela com ela mesma para navegar por estruturas hierárquicas. Aplicamos esse conhecimento diretamente na tabela `PlanoDeContas`, que possui o auto-relacionamento `ContaPaiID → ContaPlanoID`. Aprendemos a usar múltiplos aliases da mesma tabela para representar níveis distintos da hierarquia, a construir o caminho completo de uma conta contábil por concatenação, a usar `REPLICATE` para indentação visual e a combinar SELF JOIN com LEFT JOIN para preservar as contas raiz que não possuem pai. O FinanceDB tem agora três níveis hierárquicos navegáveis: grupos, subgrupos e contas analíticas. É sobre essas contas analíticas — os pontos de entrada de cada lançamento — que este capítulo incidirá, calculando totais, médias, contagens e valores extremos com as cinco funções de agregação fundamentais do T-SQL.

---

## Analogia de Ancoragem

Imagine que você é o contador de uma empresa e recebeu uma pilha com 300 extratos bancários impressos, um para cada transação do trimestre. Seu diretor financeiro chega e faz quatro perguntas em sequência: "Quanto entramos no total?", "Quantas transações fizemos?", "Qual foi o valor médio por operação?" e "Qual foi o maior e o menor lançamento?". Você poderia pegar uma calculadora e somar linha por linha — mas levaria horas. A alternativa inteligente é usar uma máquina de somar: você alimenta a pilha e ela devolve o resultado calculado automaticamente, sem que você precise ver cada folha individualmente.

As funções de agregação do T-SQL são exatamente essa máquina. Você define o conjunto de linhas que interessa — toda a tabela, um período, uma empresa, uma categoria — e delega o cálculo ao SQL Server. Ele varre as linhas selecionadas, aplica a operação matemática correspondente e devolve um único valor: o total, a contagem, a média, o máximo ou o mínimo. O que antes exigiria um laço em linguagem de programação se resolve em uma linha de SQL. E quando combinadas com GROUP BY, essas funções produzem não um único resultado, mas um resultado por grupo — um extrato por empresa, um total por categoria, uma média por mês.

---

## 18.1 — O Que São Funções de Agregação

Uma **função de agregação** recebe um conjunto de valores — uma coluna inteira ou um subconjunto filtrado dela — e produz um único valor de retorno. Esse comportamento é radicalmente diferente das funções escalares, que operam sobre um valor por vez. Enquanto `UPPER('receita')` transforma uma string, `SUM(Valor)` colapsa uma coluna inteira em um número.

O T-SQL oferece cinco funções de agregação fundamentais, todas relevantes para análise financeira:

`SUM` soma todos os valores não nulos da coluna. É a função mais usada em contextos financeiros — totais de receita, de despesa, de orçamento realizado.

`COUNT` conta linhas ou valores. Possui dois comportamentos distintos dependendo do argumento: `COUNT(*)` conta todas as linhas do conjunto, incluindo as que possuem NULL em qualquer coluna; `COUNT(coluna)` conta apenas as linhas onde aquela coluna específica não é NULL.

`AVG` calcula a média aritmética dos valores não nulos. Atenção crítica: ele ignora os NULLs no denominador, o que pode distorcer o resultado se NULLs representam "zero" no seu domínio de negócio.

`MIN` retorna o menor valor não nulo do conjunto. Funciona com números, datas e strings — neste último caso, usa ordem alfabética.

`MAX` retorna o maior valor não nulo. Mesma lógica do MIN, mas em sentido oposto.

Todas as cinco ignoram NULL por padrão — com a única exceção de `COUNT(*)`, que conta linhas independentemente de conteúdo. Esse comportamento tem implicações importantes que exploraremos ao longo do capítulo.

---

## 18.2 — Estrutura do FinanceDB Relevante para Este Capítulo

Antes de escrever qualquer query, convém revisar quais colunas e tabelas serão usadas com mais frequência neste capítulo.

A tabela `Transacoes` é o coração das análises de agregação. Ela possui a coluna `Valor` do tipo `DECIMAL(18,2)` — o campo que será somado, calculado em média e comparado. Possui também `DataLancamento` do tipo `DATE`, `DataCompetencia` do tipo `DATE`, `Status` com valores possíveis `Pendente`, `Conciliado` e `Cancelado`, e as chaves estrangeiras `EmpresaID`, `ContaID`, `ContaPlanoID` e `TipoTransacaoID`, que permitem combinar a tabela com as demais via JOIN.

A tabela `TiposTransacao` tem a coluna `Natureza` do tipo `CHAR(1)` com valores `C` (Crédito) e `D` (Débito) — ela é o campo que diferencia receitas de despesas nas queries de apuração de resultado.

A tabela `PlanoDeContas` tem `Descricao` e `Tipo` (RECEITA ou DESPESA), permitindo agrupar transações por categoria contábil.

A tabela `Orcamentos` tem `ValorOrcado` e `ValorRealizado`, ambos `DECIMAL(18,2)`, usados para calcular desvios orçamentários.

---

## 18.3 — SUM: Somando o que Importa

~~~sql
-- Soma total de todos os lançamentos registrados no FinanceDB
-- Atenção: inclui receitas e despesas — é o volume bruto de movimentação
SELECT
    SUM(Valor) AS TotalMovimentado   -- soma de todos os valores da tabela
FROM
    Transacoes;
~~~

O resultado devolve um único número: o volume financeiro total transacionado. Mas esse número, sozinho, não diz muito — somar receitas e despesas produz um montante bruto sem significado gerencial. O próximo passo é separar por natureza.

~~~sql
-- Separando receitas de despesas usando JOIN com TiposTransacao
-- A natureza 'C' (Crédito) representa entradas; 'D' (Débito) representa saídas
SELECT
    tt.Natureza,                          -- C ou D
    tt.Descricao      AS TipoDescricao,   -- Receita Financeira / Despesa Financeira
    SUM(t.Valor)      AS TotalValor       -- soma por grupo de natureza
FROM
    Transacoes        AS t
    INNER JOIN TiposTransacao AS tt
        ON t.TipoTransacaoID = tt.TipoTransacaoID
WHERE
    t.Status <> 'Cancelado'               -- exclui lançamentos cancelados da apuração
GROUP BY
    tt.Natureza,
    tt.Descricao;
~~~

Este script apresenta um padrão que se repetirá em todo o capítulo: `SUM` combinado com `GROUP BY` para produzir um total por categoria. Aqui agrupamos por `Natureza` e `Descricao` da tabela `TiposTransacao` — o resultado é uma linha para créditos e outra para débitos, cada uma com seu total.

Repare na cláusula `WHERE t.Status <> 'Cancelado'`: em análises financeiras é fundamental excluir lançamentos cancelados antes de qualquer cálculo. Um lançamento cancelado não representou fluxo de caixa real e não deve contaminar os totais.

~~~sql
-- Apuração do resultado financeiro líquido: Receitas menos Despesas
-- Técnica: usar expressão CASE dentro do SUM para separar créditos e débitos
SELECT
    SUM(
        CASE
            WHEN tt.Natureza = 'C' THEN  t.Valor   -- créditos somam positivo
            WHEN tt.Natureza = 'D' THEN -t.Valor   -- débitos somam negativo
            ELSE 0
        END
    ) AS ResultadoLiquido                           -- positivo = superávit; negativo = déficit
FROM
    Transacoes        AS t
    INNER JOIN TiposTransacao AS tt
        ON t.TipoTransacaoID = tt.TipoTransacaoID
WHERE
    t.Status <> 'Cancelado';
~~~

A combinação `SUM + CASE` é um dos padrões mais poderosos e recorrentes em T-SQL financeiro. Ela permite tratar débitos como negativos diretamente dentro da função de agregação, produzindo o resultado líquido em uma única passagem pela tabela — sem subqueries, sem tabelas temporárias.

~~~sql
-- Total de receitas e despesas por empresa, com resultado líquido
-- Combina três tabelas: Transacoes, TiposTransacao e Empresas
SELECT
    e.RazaoSocial                AS Empresa,
    SUM(
        CASE WHEN tt.Natureza = 'C' THEN t.Valor ELSE 0 END
    )                            AS TotalReceitas,
    SUM(
        CASE WHEN tt.Natureza = 'D' THEN t.Valor ELSE 0 END
    )                            AS TotalDespesas,
    SUM(
        CASE
            WHEN tt.Natureza = 'C' THEN  t.Valor
            WHEN tt.Natureza = 'D' THEN -t.Valor
            ELSE 0
        END
    )                            AS ResultadoLiquido
FROM
    Transacoes        AS t
    INNER JOIN TiposTransacao AS tt
        ON t.TipoTransacaoID = tt.TipoTransacaoID
    INNER JOIN Empresas       AS e
        ON t.EmpresaID = e.EmpresaID
WHERE
    t.Status <> 'Cancelado'
GROUP BY
    e.EmpresaID,
    e.RazaoSocial                -- agrupa por empresa
ORDER BY
    ResultadoLiquido DESC;       -- empresas mais lucrativas primeiro
~~~

---

## 18.4 — COUNT: Contando com Precisão

~~~sql
-- Quantas transações existem na tabela, independentemente de status ou valor
-- COUNT(*) conta linhas, não valores — NULLs não afetam o resultado
SELECT
    COUNT(*) AS TotalLancamentos
FROM
    Transacoes;
~~~

~~~sql
-- Comparando COUNT(*) com COUNT(coluna) para demonstrar o comportamento com NULL
-- NumeroDocumento é uma coluna que aceita NULL (documentos sem número)
SELECT
    COUNT(*)                AS TotalLinhas,           -- conta todas as linhas
    COUNT(NumeroDocumento)  AS ComNumeroDocumento,    -- conta apenas as não-NULL
    COUNT(*) - COUNT(NumeroDocumento)
                            AS SemNumeroDocumento      -- diferença = quantidade de NULLs
FROM
    Transacoes;
~~~

Este script é didaticamente valioso: ele demonstra na prática que `COUNT(*)` e `COUNT(coluna)` produzem resultados diferentes quando a coluna possui NULLs. Em `Transacoes`, a coluna `NumeroDocumento` é opcional — nem toda transação tem um número de documento associado. `COUNT(NumeroDocumento)` ignora as linhas onde esse campo é NULL, enquanto `COUNT(*)` as inclui.

~~~sql
-- Contagem de transações por status e por empresa
-- Permite identificar quantos lançamentos estão pendentes, conciliados ou cancelados
SELECT
    e.RazaoSocial      AS Empresa,
    t.Status,
    COUNT(*)           AS Quantidade,
    SUM(t.Valor)       AS ValorTotal
FROM
    Transacoes   AS t
    INNER JOIN Empresas AS e
        ON t.EmpresaID = e.EmpresaID
GROUP BY
    e.EmpresaID,
    e.RazaoSocial,
    t.Status
ORDER BY
    e.RazaoSocial,
    t.Status;
~~~

~~~sql
-- Contagem de lançamentos por categoria do plano de contas
-- Identifica quais categorias têm mais movimentação
SELECT
    pc.Descricao          AS Categoria,
    pc.Tipo               AS TipoCategoria,
    COUNT(t.TransacaoID)  AS QuantidadeLancamentos,
    SUM(t.Valor)          AS TotalLancado
FROM
    PlanoDeContas  AS pc
    LEFT JOIN Transacoes AS t
        ON pc.ContaPlanoID = t.ContaPlanoID
        AND t.Status <> 'Cancelado'       -- filtro no ON para preservar o LEFT JOIN
WHERE
    pc.AceitaLancamentos = 1              -- apenas contas analíticas
    AND pc.Ativa = 1
GROUP BY
    pc.ContaPlanoID,
    pc.Descricao,
    pc.Tipo
ORDER BY
    QuantidadeLancamentos DESC;
~~~

O uso de `LEFT JOIN` aqui é deliberado: queremos ver todas as contas analíticas ativas, mesmo aquelas que ainda não possuem lançamentos. Com `INNER JOIN`, as categorias sem transações desapareceriam do resultado — o que seria uma perda de informação gerencial importante.

---

## 18.5 — AVG: Calculando Médias com Cuidado

~~~sql
-- Valor médio por transação, separado por tipo
-- AVG ignora NULLs automaticamente — mas Valor não aceita NULL (NOT NULL na DDL)
SELECT
    tt.Descricao          AS TipoTransacao,
    COUNT(*)              AS Quantidade,
    AVG(t.Valor)          AS TicketMedio,
    MIN(t.Valor)          AS MenorValor,
    MAX(t.Valor)          AS MaiorValor
FROM
    Transacoes        AS t
    INNER JOIN TiposTransacao AS tt
        ON t.TipoTransacaoID = tt.TipoTransacaoID
WHERE
    t.Status <> 'Cancelado'
GROUP BY
    tt.TipoTransacaoID,
    tt.Descricao
ORDER BY
    TicketMedio DESC;
~~~

~~~sql
-- Média mensal de receitas: quanto a empresa recebe, em média, por mês?
-- YEAR e MONTH são funções de data — serão aprofundadas no Capítulo 20
SELECT
    YEAR(t.DataCompetencia)   AS Ano,
    MONTH(t.DataCompetencia)  AS Mes,
    COUNT(*)                  AS QuantidadeLancamentos,
    SUM(t.Valor)              AS TotalMes,
    AVG(t.Valor)              AS MediaPorLancamento
FROM
    Transacoes        AS t
    INNER JOIN TiposTransacao AS tt
        ON t.TipoTransacaoID = tt.TipoTransacaoID
WHERE
    tt.Natureza = 'C'                     -- apenas créditos (receitas)
    AND t.Status <> 'Cancelado'
GROUP BY
    YEAR(t.DataCompetencia),
    MONTH(t.DataCompetencia)
ORDER BY
    Ano,
    Mes;
~~~

Um alerta importante sobre `AVG`: quando a coluna pode conter NULL e o NULL semanticamente representa "zero" — por exemplo, um campo de desconto não preenchido que deveria ser interpretado como desconto zero — o `AVG` produzirá um resultado incorreto porque excluirá essas linhas do denominador. Nesses casos, a solução é usar `AVG(ISNULL(coluna, 0))`, que substitui os NULLs por zero antes do cálculo. Na tabela `Transacoes` esse problema não ocorre porque `Valor` é `NOT NULL` — mas é uma armadilha clássica em outras situações.

---

## 18.6 — MIN e MAX: Valores Extremos

~~~sql
-- Maior e menor lançamento de receita e despesa por empresa
SELECT
    e.RazaoSocial     AS Empresa,
    tt.Descricao      AS TipoTransacao,
    MIN(t.Valor)      AS MenorLancamento,
    MAX(t.Valor)      AS MaiorLancamento,
    MAX(t.Valor) - MIN(t.Valor)
                      AS AmplitudeValores   -- diferença entre extremos
FROM
    Transacoes        AS t
    INNER JOIN TiposTransacao AS tt
        ON t.TipoTransacaoID = tt.TipoTransacaoID
    INNER JOIN Empresas       AS e
        ON t.EmpresaID = e.EmpresaID
WHERE
    t.Status <> 'Cancelado'
GROUP BY
    e.EmpresaID,
    e.RazaoSocial,
    tt.TipoTransacaoID,
    tt.Descricao
ORDER BY
    e.RazaoSocial,
    tt.Descricao;
~~~

~~~sql
-- Data do primeiro e do último lançamento por conta bancária
-- MIN e MAX funcionam perfeitamente com colunas do tipo DATE
SELECT
    cb.Agencia                AS Agencia,
    cb.NumeroConta            AS NumeroConta,
    b.NomeBanco               AS Banco,
    MIN(t.DataLancamento)     AS PrimeiroLancamento,
    MAX(t.DataLancamento)     AS UltimoLancamento,
    COUNT(*)                  AS TotalLancamentos,
    SUM(t.Valor)              AS VolumeTotal
FROM
    ContasBancarias   AS cb
    INNER JOIN Bancos         AS b
        ON cb.BancoID = b.BancoID
    LEFT JOIN Transacoes      AS t
        ON cb.ContaID = t.ContaID
        AND t.Status <> 'Cancelado'
GROUP BY
    cb.ContaID,
    cb.Agencia,
    cb.NumeroConta,
    b.NomeBanco
ORDER BY
    TotalLancamentos DESC;
~~~

---

## 18.7 — Combinando as Cinco Funções: O Relatório Gerencial Completo

Este é o ponto onde as cinco funções se unem para produzir algo com valor gerencial real. O script abaixo é o "extrato executivo" do FinanceDB: uma visão consolidada por categoria do plano de contas com todos os indicadores financeiros em um único resultado.

~~~sql
-- Relatório gerencial completo por categoria do plano de contas
-- Combina SUM, COUNT, AVG, MIN e MAX em um único resultado por categoria
SELECT
    e.RazaoSocial             AS Empresa,
    pc.Codigo                 AS CodigoContabil,
    pc.Descricao              AS Categoria,
    pc.Tipo                   AS TipoCategoria,      -- RECEITA ou DESPESA
    COUNT(t.TransacaoID)      AS Lancamentos,        -- COUNT(coluna) ignora NULLs do LEFT JOIN
    ISNULL(SUM(t.Valor), 0)   AS TotalRealizado,     -- ISNULL para categorias sem lançamentos
    ISNULL(AVG(t.Valor), 0)   AS TicketMedio,
    ISNULL(MIN(t.Valor), 0)   AS MenorLancamento,
    ISNULL(MAX(t.Valor), 0)   AS MaiorLancamento
FROM
    PlanoDeContas  AS pc
    INNER JOIN Empresas       AS e
        ON pc.EmpresaID = e.EmpresaID
    LEFT JOIN Transacoes      AS t
        ON pc.ContaPlanoID = t.ContaPlanoID
        AND t.Status <> 'Cancelado'                  -- filtro no ON para preservar LEFT JOIN
WHERE
    pc.AceitaLancamentos = 1                         -- apenas contas analíticas
    AND pc.Ativa = 1
    AND e.Ativo = 1
GROUP BY
    e.EmpresaID,
    e.RazaoSocial,
    pc.ContaPlanoID,
    pc.Codigo,
    pc.Descricao,
    pc.Tipo
ORDER BY
    e.RazaoSocial,
    pc.Tipo DESC,                                    -- RECEITA antes de DESPESA
    TotalRealizado DESC;
~~~

Três detalhes merecem atenção neste script. Primeiro, usamos `COUNT(t.TransacaoID)` em vez de `COUNT(*)` — porque com LEFT JOIN, as linhas sem correspondência na tabela `Transacoes` terão `t.TransacaoID = NULL`, e `COUNT(coluna)` corretamente retornará zero para essas categorias, enquanto `COUNT(*)` retornaria 1. Segundo, envolvemos as funções de agregação com `ISNULL(..., 0)` para exibir zero em vez de NULL para categorias sem lançamentos. Terceiro, o filtro `t.Status <> 'Cancelado'` está no `ON` do LEFT JOIN, não no `WHERE` — se estivesse no WHERE, ele transformaria o LEFT JOIN em INNER JOIN ao eliminar as linhas onde `t.Status` é NULL (que são exatamente as categorias sem lançamentos).

---

## 18.8 — Apuração Orçamentária: Realizado vs. Planejado

A tabela `Orcamentos` armazena o valor planejado (`ValorOrcado`) e o valor efetivamente realizado (`ValorRealizado`) por empresa, conta do plano e período (ano e mês). Uma análise orçamentária clássica compara esses dois campos e calcula o desvio.

~~~sql
-- Análise de desvio orçamentário por categoria e período
-- Mostra quanto foi planejado, realizado e o percentual de execução
SELECT
    e.RazaoSocial             AS Empresa,
    pc.Descricao              AS Categoria,
    pc.Tipo                   AS TipoCategoria,
    o.Ano,
    o.Mes,
    SUM(o.ValorOrcado)        AS TotalOrcado,
    SUM(o.ValorRealizado)     AS TotalRealizado,
    SUM(o.ValorRealizado) - SUM(o.ValorOrcado)
                              AS Desvio,              -- positivo = acima do orçado
    CASE
        WHEN SUM(o.ValorOrcado) = 0 THEN NULL        -- evita divisão por zero
        ELSE ROUND(
            (SUM(o.ValorRealizado) / SUM(o.ValorOrcado)) * 100,
            2
        )
    END                       AS PercExecucao        -- percentual de execução orçamentária
FROM
    Orcamentos     AS o
    INNER JOIN Empresas       AS e
        ON o.EmpresaID = e.EmpresaID
    INNER JOIN PlanoDeContas  AS pc
        ON o.ContaPlanoID = pc.ContaPlanoID
GROUP BY
    e.EmpresaID,
    e.RazaoSocial,
    pc.ContaPlanoID,
    pc.Descricao,
    pc.Tipo,
    o.Ano,
    o.Mes
ORDER BY
    e.RazaoSocial,
    o.Ano,
    o.Mes,
    pc.Tipo DESC;
~~~

O padrão `CASE WHEN SUM(ValorOrcado) = 0 THEN NULL` é fundamental em cálculos financeiros para evitar o erro de divisão por zero — `Msg 8134, Level 16: Divide by zero error encountered`. Em vez de deixar a query falhar, tratamos o caso explicitamente e retornamos NULL, que é mais honesto que retornar zero ou um valor arbitrário.

---

## 18.9 — COUNT DISTINCT: Contando Valores Únicos

~~~sql
-- Quantas contas bancárias distintas receberam lançamentos?
-- Quantos meses distintos de movimentação existem?
SELECT
    COUNT(DISTINCT t.ContaID)                  AS ContasComMovimentacao,
    COUNT(DISTINCT t.EmpresaID)                AS EmpresasComMovimentacao,
    COUNT(DISTINCT t.ContaPlanoID)             AS CategoriasUtilizadas,
    COUNT(DISTINCT YEAR(t.DataCompetencia))    AS AnosDeMovimentacao,
    COUNT(*)                                   AS TotalLancamentos
FROM
    Transacoes AS t
WHERE
    t.Status <> 'Cancelado';
~~~

`COUNT(DISTINCT coluna)` é uma variação extremamente útil: ela conta quantos valores únicos existem em uma coluna dentro do conjunto filtrado. No exemplo acima, mesmo que uma conta bancária tenha 50 lançamentos, ela é contada apenas uma vez. Isso permite responder perguntas do tipo "quantas contas distintas foram movimentadas?" sem necessidade de subqueries.

---

## 18.10 — NULL e Funções de Agregação: O Comportamento Completo

Este é um dos tópicos que mais causa confusão em desenvolvedores iniciantes. Veja o comportamento de cada função diante de um conjunto que inclui NULL:

~~~sql
-- Demonstração do comportamento de cada função com NULL
-- Criamos um conjunto fictício usando VALUES para não depender de dados específicos
SELECT
    SUM(Valor)   AS ResultadoSUM,    -- ignora NULL: soma apenas os não-NULL
    COUNT(*)     AS ResultadoCOUNT_STAR,  -- conta TODAS as linhas, incluindo NULL
    COUNT(Valor) AS ResultadoCOUNT_COL,  -- ignora NULL: conta apenas não-NULL
    AVG(Valor)   AS ResultadoAVG,    -- ignora NULL: média sobre os não-NULL
    MIN(Valor)   AS ResultadoMIN,    -- ignora NULL
    MAX(Valor)   AS ResultadoMAX     -- ignora NULL
FROM (
    VALUES
        (1000.00),
        (2500.00),
        (NULL),           -- este NULL será ignorado por SUM, AVG, MIN, MAX e COUNT(col)
        (750.00)
) AS Teste(Valor);
-- SUM = 4250, COUNT(*) = 4, COUNT(Valor) = 3, AVG = 1416.67, MIN = 750, MAX = 2500
~~~

O ponto crítico: `AVG` sobre três valores (ignorando o NULL) produz 1416.67, não 1062.50 (que seria a média se o NULL fosse tratado como zero). Se no seu domínio de negócio um NULL representa zero, você deve usar `AVG(ISNULL(Valor, 0))` para obter o resultado correto.

---

## Diagrama Mermaid — Fluxo das Funções de Agregação

~~~mermaid
flowchart TD
    A[Tabela Transacoes\n30+ lançamentos] --> B{Filtros WHERE\nStatus != Cancelado}
    B --> C[Linhas Filtradas]
    C --> D{GROUP BY?}

    D -->|Não| E[Resultado Único\nAgregação Global]
    D -->|Sim| F[Grupos de Linhas\nPor Empresa / Categoria / Período]

    E --> G[SUM: Total geral]
    E --> H[COUNT: Volume total]
    E --> I[AVG: Ticket médio geral]
    E --> J[MIN: Menor lançamento]
    E --> K[MAX: Maior lançamento]

    F --> L[SUM por grupo\nTotal por categoria]
    F --> M[COUNT por grupo\nQtd por empresa]
    F --> N[AVG por grupo\nTicket médio mensal]
    F --> O[MIN por grupo\nMenor por conta]
    F --> P[MAX por grupo\nMaior por período]

    L --> Q[Relatório Gerencial\nCompleto por Categoria]
    M --> Q
    N --> Q
    O --> Q
    P --> Q

    Q --> R{HAVING\nFiltro sobre grupos}
    R -->|Grupo aprovado| S[Resultado Final]
    R -->|Grupo rejeitado| T[Eliminado do resultado]
~~~

---

## Glossário Técnico

**Função de Agregação:** função que recebe um conjunto de valores e retorna um único valor calculado sobre esse conjunto. Exemplos: SUM, COUNT, AVG, MIN, MAX.

**SUM:** soma todos os valores não nulos de uma expressão ou coluna dentro do conjunto de linhas.

**COUNT(*):** conta o número total de linhas no conjunto, independentemente de NULLs em qualquer coluna.

**COUNT(coluna):** conta o número de valores não nulos na coluna especificada dentro do conjunto.

**COUNT(DISTINCT coluna):** conta quantos valores distintos (únicos) e não nulos existem na coluna dentro do conjunto.

**AVG:** calcula a média aritmética dos valores não nulos. Denominador = número de linhas não nulas.

**MIN:** retorna o menor valor não nulo do conjunto. Aplicável a números, datas e strings.

**MAX:** retorna o maior valor não nulo do conjunto. Aplicável a números, datas e strings.

**NULL:** ausência de valor. Diferente de zero. A maioria das funções de agregação ignora NULLs — exceto COUNT(*).

**ISNULL(expr, substituto):** substitui NULL por um valor alternativo. Usado para tratar NULLs antes de agregar.

**GROUP BY:** cláusula que divide o conjunto de linhas em grupos com base nos valores das colunas especificadas. As funções de agregação são aplicadas a cada grupo separadamente.

**HAVING:** cláusula de filtro aplicada após o GROUP BY, sobre os resultados das funções de agregação. WHERE filtra linhas; HAVING filtra grupos.

**Ticket Médio:** valor médio por transação. Indicador financeiro calculado com AVG(Valor).

**Resultado Líquido:** diferença entre total de receitas e total de despesas. Positivo indica superávit; negativo indica déficit.

**Divisão por Zero:** erro gerado quando o denominador de uma divisão é zero. Prevenido com CASE WHEN denominador = 0 THEN NULL ou com NULLIF.

**NULLIF(a, b):** retorna NULL se a = b; caso contrário, retorna a. Alternativa ao CASE para evitar divisão por zero: `SUM(realizado) / NULLIF(SUM(orcado), 0)`.

---

## Antecipação de Erros e Troubleshooting

**Erro: "Column is invalid in the select list because it is not contained in either an aggregate function or the GROUP BY clause"**
Este é o erro mais comum ao aprender agregação. Ocorre quando você coloca no SELECT uma coluna que não é nem uma função de agregação nem está listada no GROUP BY. A regra é clara: toda coluna no SELECT de uma query com GROUP BY deve estar no GROUP BY ou dentro de uma função de agregação. Solução: adicione a coluna ao GROUP BY ou envolva-a com uma função de agregação adequada.

**Erro: "Divide by zero error encountered" (Msg 8134)**
Ocorre em expressões de divisão quando o denominador é zero. Em análises financeiras, acontece tipicamente ao calcular percentual de execução orçamentária quando `ValorOrcado = 0`. Solução: use `CASE WHEN denominador = 0 THEN NULL ELSE numerador / denominador END` ou a função `NULLIF`: `numerador / NULLIF(denominador, 0)`.

**Resultado incorreto: AVG retorna valor diferente do esperado**
Causa provável: a coluna possui NULLs que estão sendo ignorados no denominador. Se NULLs representam zero no seu domínio, use `AVG(ISNULL(coluna, 0))`. Para diagnóstico, compare `COUNT(*)` com `COUNT(coluna)` — se os valores diferem, há NULLs na coluna.

**Resultado incorreto: LEFT JOIN com filtro no WHERE anula o join**
Quando você usa LEFT JOIN e coloca um filtro sobre a tabela da direita no WHERE, as linhas sem correspondência (que teriam NULL) são eliminadas — transformando efetivamente o LEFT JOIN em INNER JOIN. A solução é mover o filtro para a cláusula ON. Exemplo incorreto: `LEFT JOIN Transacoes t ON ... WHERE t.Status <> 'Cancelado'`. Exemplo correto: `LEFT JOIN Transacoes t ON pc.ContaPlanoID = t.ContaPlanoID AND t.Status <> 'Cancelado'`.

**Resultado inesperado: COUNT(*) retorna 1 para categorias sem lançamentos em LEFT JOIN**
Ocorre quando você usa COUNT(*) com LEFT JOIN. As linhas sem correspondência produzem uma linha com NULLs, e COUNT(*) conta essa linha. Use COUNT(t.TransacaoID) — que ignora o NULL — para obter corretamente zero para categorias sem lançamentos.

**SUM retorna NULL em vez de zero**
Ocorre quando nenhuma linha do conjunto possui valor não nulo para a coluna somada. Envolva o SUM com ISNULL: `ISNULL(SUM(Valor), 0)`. Isso garante que o resultado seja zero em vez de NULL, o que é mais adequado para exibição em relatórios.

---

## Desafio de Fixação

**Enunciado:**

Você foi solicitado pelo diretor financeiro a produzir um relatório de performance financeira do FinanceDB com as seguintes características:

1. Mostre, por empresa e por tipo de transação (Natureza C ou D), o total lançado, a quantidade de lançamentos, o ticket médio, o maior e o menor lançamento — considerando apenas transações com status `Conciliado`.

2. Em seguida, construa uma segunda query que calcule o resultado líquido (receitas menos despesas) por empresa, mostrando também quantas categorias distintas do plano de contas foram utilizadas em transações conciliadas.

3. Por fim, construa uma query que mostre todas as categorias analíticas do plano de contas (AceitaLancamentos = 1) da Empresa 1, com o total realizado em transações conciliadas — mesmo para as categorias que ainda não possuem nenhum lançamento conciliado (essas devem aparecer com zero).

---

**Resolução Comentada:**

~~~sql
-- PARTE 1: Performance por empresa e natureza de transação
-- Filtro: apenas lançamentos com Status = 'Conciliado'
SELECT
    e.RazaoSocial             AS Empresa,
    tt.Natureza,              -- C = Crédito (Receita) / D = Débito (Despesa)
    tt.Descricao              AS TipoTransacao,
    COUNT(t.TransacaoID)      AS QuantidadeLancamentos,
    SUM(t.Valor)              AS TotalLancado,
    AVG(t.Valor)              AS TicketMedio,
    MIN(t.Valor)              AS MenorLancamento,
    MAX(t.Valor)              AS MaiorLancamento
FROM
    Transacoes        AS t
    INNER JOIN TiposTransacao AS tt
        ON t.TipoTransacaoID = tt.TipoTransacaoID
    INNER JOIN Empresas       AS e
        ON t.EmpresaID = e.EmpresaID
WHERE
    t.Status = 'Conciliado'   -- apenas conciliados
GROUP BY
    e.EmpresaID,
    e.RazaoSocial,
    tt.TipoTransacaoID,
    tt.Natureza,
    tt.Descricao
ORDER BY
    e.RazaoSocial,
    tt.Natureza;
~~~

~~~sql
-- PARTE 2: Resultado líquido por empresa + categorias distintas utilizadas
SELECT
    e.RazaoSocial                           AS Empresa,
    COUNT(DISTINCT t.ContaPlanoID)          AS CategoriasUtilizadas,  -- valores únicos
    SUM(
        CASE
            WHEN tt.Natureza = 'C' THEN  t.Valor
            WHEN tt.Natureza = 'D' THEN -t.Valor
            ELSE 0
        END
    )                                       AS ResultadoLiquido
FROM
    Transacoes        AS t
    INNER JOIN TiposTransacao AS tt
        ON t.TipoTransacaoID = tt.TipoTransacaoID
    INNER JOIN Empresas       AS e
        ON t.EmpresaID = e.EmpresaID
WHERE
    t.Status = 'Conciliado'
GROUP BY
    e.EmpresaID,
    e.RazaoSocial
ORDER BY
    ResultadoLiquido DESC;
~~~

~~~sql
-- PARTE 3: Todas as categorias analíticas da Empresa 1,
-- com total conciliado — inclusive as sem lançamentos (zero)
-- LEFT JOIN com filtro no ON para não anular o join
SELECT
    pc.Codigo                  AS CodigoContabil,
    pc.Descricao               AS Categoria,
    pc.Tipo                    AS TipoCategoria,
    COUNT(t.TransacaoID)       AS QuantidadeLancamentos,  -- zero para sem lançamentos
    ISNULL(SUM(t.Valor), 0)    AS TotalRealizado          -- zero em vez de NULL
FROM
    PlanoDeContas  AS pc
    LEFT JOIN Transacoes AS t
        ON pc.ContaPlanoID = t.ContaPlanoID
        AND t.Status = 'Conciliado'             -- no ON: preserva o LEFT JOIN
        AND t.EmpresaID = 1                     -- filtro de empresa também no ON
WHERE
    pc.EmpresaID = 1                            -- empresa 1 no plano de contas
    AND pc.AceitaLancamentos = 1               -- apenas contas analíticas
    AND pc.Ativa = 1
GROUP BY
    pc.ContaPlanoID,
    pc.Codigo,
    pc.Descricao,
    pc.Tipo
ORDER BY
    pc.Tipo DESC,
    TotalRealizado DESC;
~~~

---

## Resumo dos Pontos-Chave

Neste capítulo dominamos as cinco funções de agregação fundamentais do T-SQL e suas aplicações financeiras no FinanceDB. `SUM` calcula totais de receitas, despesas e volumes de movimentação — especialmente poderoso quando combinado com `CASE` para separar créditos e débitos em uma única passagem. `COUNT(*)` conta linhas sem considerar NULLs, enquanto `COUNT(coluna)` conta apenas os valores não nulos; a diferença entre os dois revela a quantidade de NULLs na coluna. `COUNT(DISTINCT)` conta valores únicos, respondendo perguntas sobre diversidade e abrangência. `AVG` calcula o ticket médio por transação, mas exige atenção ao comportamento com NULLs — que são ignorados no denominador, podendo distorcer resultados quando NULLs representam zero. `MIN` e `MAX` identificam os extremos do conjunto e funcionam com números, datas e strings.

Três padrões avançados foram estabelecidos e serão reutilizados nos próximos capítulos: `SUM + CASE` para cálculo de resultado líquido em uma única query, `ISNULL(SUM(...), 0)` para tratar o caso de conjuntos vazios, e o filtro no `ON` do LEFT JOIN para preservar categorias sem lançamentos. A prevenção da divisão por zero com `CASE WHEN ... = 0 THEN NULL` ou `NULLIF` é uma prática obrigatória em qualquer cálculo de percentual financeiro.

O Capítulo 19 dará o próximo passo natural: aprender a filtrar os grupos produzidos pelo GROUP BY usando a cláusula HAVING — que opera sobre resultados de agregação da mesma forma que o WHERE opera sobre linhas individuais.

---

## Log de Estado do Projeto

~~~text
## Estado — Após o Capítulo 18

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
Orcamentos:        registros de orçamento por conta e período

=== MÓDULOS CONCLUÍDOS ===
✅ Módulo 1 — Fundamentos: Teoria e Ambiente (Capítulos 1–6)
✅ Módulo 2 — Essencial: T-SQL Básico (Capítulos 7–14)

=== CAPÍTULOS DO MÓDULO 3 ===
✅ Capítulo 15: INNER JOIN
✅ Capítulo 16: LEFT JOIN, RIGHT JOIN e FULL OUTER JOIN
✅ Capítulo 17: SELF JOIN — Auto-relacionamento e hierarquias
✅ Capítulo 18: Funções de Agregação — SUM, COUNT, AVG, MIN e MAX
⬜ Capítulo 19: GROUP BY e HAVING
⬜ Capítulo 20: Funções de Data e Hora
⬜ Capítulo 21: Funções de Texto
⬜ Capítulo 22: Subconsultas

=== HABILIDADES ADQUIRIDAS NESTE CAPÍTULO ===
- SUM para totais de receitas, despesas e resultado líquido
- SUM + CASE para segregação crédito/débito em uma única query
- COUNT(*) vs COUNT(coluna): diferença crítica no tratamento de NULLs
- COUNT(DISTINCT) para valores únicos em conjuntos filtrados
- AVG e o risco de distorção por NULLs no denominador
- MIN e MAX com números, datas e categorias
- ISNULL(SUM(...), 0) para tratar conjuntos vazios
- Filtro no ON do LEFT JOIN para preservar categorias sem lançamentos
- Prevenção de divisão por zero com CASE e NULLIF
- Análise orçamentária: ValorOrcado vs ValorRealizado + percentual

=== PRÓXIMO ===
Capítulo 19: Agrupando Dados — GROUP BY e HAVING
Objetivo: produzir relatórios financeiros agrupados por categoria,
conta e período, filtrar grupos com HAVING e entender a diferença
fundamental entre WHERE e HAVING na ordem de processamento de uma query
~~~

---

~~~text
Por favor, gere o Capítulo 19: Agrupando Dados — GROUP BY e HAVING.
Objetivo: produzir relatórios financeiros agrupados por categoria,
conta bancária e período usando GROUP BY, filtrar grupos com HAVING
para exibir apenas categorias com total acima de um valor mínimo
ou quantidade de lançamentos relevante, e entender com precisão
a diferença entre WHERE (filtra linhas antes da agregação) e HAVING
(filtra grupos depois da agregação) na ordem lógica de processamento
de uma query no SQL Server. Aplicar esses conceitos em relatórios
reais do FinanceDB como DRE simplificado, ranking de categorias
e extrato por conta.
Pré-requisito: Capítulo 18 concluído.
~~~

---

Dúvidas? Posso prosseguir para o Capítulo 19?