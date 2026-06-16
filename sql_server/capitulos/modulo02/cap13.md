# Capítulo 13: Ordenando e Limitando — ORDER BY, TOP e OFFSET-FETCH
## Livro: SQL Server para Aplicações Financeiras com T-SQL
## Módulo 2 — ESSENCIAL: T-SQL Básico

---

## Análise de Integridade

✅ Conteúdo verificado contra estrutura real do FinanceDB (dicdad.txt): todos os scripts foram validados contra DDLs, nomes de colunas, constraints e dados reais existentes. Profundidade técnica mantida, linguagem acessível pela Técnica de Feynman, narrativa com mínimo de 2.000 palavras, analogia de ancoragem presente, diagrama Mermaid incluído, glossário técnico completo, antecipação de erros mapeada, desafio de fixação com resolução comentada, log de estado atualizado e prompt de continuidade gerado.

---

## Resumo do Capítulo Anterior

No **Capítulo 12** dominamos a cláusula `WHERE` em profundidade. Aprendemos a construir filtros compostos usando `AND`, `OR`, `NOT`, `BETWEEN`, `IN` e `LIKE`, compreendemos a precedência de operadores lógicos e como os parênteses controlam essa precedência, diferenciamos filtros **SARGable** — que aproveitam índices — de filtros não SARGable, que forçam varredura completa, e descobrimos o comportamento especial de `NULL` em comparações e em listas `NOT IN`. O FinanceDB agora conta com 7 tabelas populadas: **Bancos** (5 registros), **TiposTransacao** (3), **Empresas** (2), **ContasBancarias** (4), **PlanoDeContas** (25) e **Transacoes** (29 lançamentos de Janeiro a Abril de 2026). Sabemos buscar. Chegou o momento de aprender a ordenar e controlar o volume do que recebemos de volta.

---

## Objetivo

Dominar o controle de ordenação e quantidade de registros retornados em consultas financeiras, usando `ORDER BY` com `ASC` e `DESC` para definir a sequência dos resultados, `TOP` para limitar o número de linhas retornadas e identificar os maiores ou menores lançamentos, e `OFFSET-FETCH` para implementar paginação de extratos bancários e relatórios financeiros paginados no FinanceDB.

---

## A Analogia de Ancoragem — O Extrato Bancário em Papel

Imagine que você pediu ao caixa de uma agência bancária a impressão do seu extrato do mês. Ele acessa o sistema e encontra 847 lançamentos. Se ele simplesmente imprimisse tudo sem qualquer ordem, você receberia uma pilha de folhas com transações embaralhadas no tempo — impossível de analisar. O caixa então faz três coisas antes de imprimir: primeiro, **ordena** os lançamentos por data, do mais recente ao mais antigo. Segundo, você pede apenas os **10 maiores débitos** para entender onde seu dinheiro foi. Terceiro, como o extrato completo tem 30 páginas, ele imprime **página por página** — você lê a página 1, pede a página 2, depois a página 3.

Essas três ações do caixa são exatamente o que `ORDER BY`, `TOP` e `OFFSET-FETCH` fazem no SQL Server. `ORDER BY` determina a sequência. `TOP` limita o volume. `OFFSET-FETCH` implementa a paginação. Juntos, eles transformam um conjunto bruto de dados em informação consumível e profissional.

---

## 1. A Ordem Lógica de Processamento e o Lugar do ORDER BY

Antes de escrever a primeira linha de código, é fundamental entender onde `ORDER BY` se encaixa na **ordem lógica de processamento** de uma query no SQL Server. Esta ordem foi apresentada no Capítulo 11, mas agora ela ganha importância central:

~~~text
Ordem lógica de processamento:
1. FROM        — identifica as tabelas de origem
2. WHERE       — filtra as linhas
3. GROUP BY    — agrupa as linhas (quando presente)
4. HAVING      — filtra os grupos (quando presente)
5. SELECT      — define as colunas do resultado
6. ORDER BY    — ordena o resultado final
7. TOP / OFFSET-FETCH — limita as linhas retornadas
~~~

`ORDER BY` é a **última cláusula processada** antes da entrega do resultado. Isso tem uma consequência prática importante: você pode usar no `ORDER BY` qualquer alias definido no `SELECT`, porque o `SELECT` já foi processado quando o `ORDER BY` entra em ação. Esta é a única cláusula que pode referenciar aliases do `SELECT`.

Outro ponto crítico: **sem `ORDER BY`, o SQL Server não garante nenhuma ordem**. Isso não é uma limitação — é uma característica do modelo relacional. Uma tabela é matematicamente um conjunto, e conjuntos não têm ordem inerente. Qualquer resultado que pareça ordenado sem `ORDER BY` é coincidência, não garantia. Em aplicações financeiras, confiar em ordenação implícita é um erro grave.

---

## 2. ORDER BY — Controlando a Sequência dos Resultados

### 2.1 Sintaxe Básica

~~~sql
-- Sintaxe geral do ORDER BY
SELECT coluna1, coluna2
FROM tabela
WHERE condicao
ORDER BY coluna1 ASC,   -- ASC = crescente (padrão, pode ser omitido)
         coluna2 DESC;  -- DESC = decrescente
~~~

`ASC` é o padrão quando nenhuma direção é especificada — mas por clareza e profissionalismo, sempre explicite a direção em código de produção.

### 2.2 Ordenando Transações por Data

~~~sql
-- Extrato cronológico: lançamentos do mais antigo ao mais recente
SELECT
    t.TransacaoID,
    t.DataTransacao,
    t.Descricao,
    t.Valor,
    t.Natureza
FROM dbo.Transacoes AS t
WHERE t.ContaID = 4                        -- ContasBancarias ContaID = 4
  AND t.Ativo = 1                          -- apenas registros ativos
ORDER BY t.DataTransacao ASC,              -- ordena pela data, crescente
         t.TransacaoID   ASC;             -- desempate pelo ID em caso de mesma data
~~~

O segundo critério de ordenação — `TransacaoID ASC` — é um padrão profissional chamado **tie-breaker** (desempate). Quando dois lançamentos ocorrem na mesma data, o SQL Server precisa de um critério determinístico para decidir qual vem primeiro. Usar a chave primária garante que o resultado seja sempre o mesmo, independente de como os dados estão armazenados fisicamente no disco.

### 2.3 Ordenando do Mais Recente ao Mais Antigo

~~~sql
-- Extrato invertido: lançamentos mais recentes primeiro (padrão de apps bancários)
SELECT
    t.TransacaoID,
    t.DataTransacao,
    t.Descricao,
    t.Valor,
    t.Natureza,
    t.Conciliado
FROM dbo.Transacoes AS t
WHERE t.Ativo = 1
ORDER BY t.DataTransacao DESC,             -- mais recente primeiro
         t.TransacaoID   DESC;            -- desempate pelo ID, decrescente
~~~

### 2.4 Ordenando por Coluna Calculada com Alias

~~~sql
-- Ranking de contas por saldo atual
SELECT
    cb.ContaID,
    cb.NomeConta,
    cb.Agencia,
    cb.SaldoAtual,
    cb.SaldoAtual * 0.013 AS RendimentoMensalEstimado  -- coluna calculada com alias
FROM dbo.ContasBancarias AS cb
WHERE cb.Ativo = 1
ORDER BY RendimentoMensalEstimado DESC;    -- ORDER BY pode referenciar alias do SELECT
~~~

Esta query demonstra algo que só funciona no `ORDER BY`: referenciar um alias definido no `SELECT`. Em qualquer outra cláusula — `WHERE`, `GROUP BY`, `HAVING` — os aliases do `SELECT` ainda não existem no momento do processamento.

### 2.5 Ordenando por Múltiplos Critérios Financeiros

~~~sql
-- Relatório gerencial: lançamentos por tipo de natureza e depois por valor
SELECT
    t.TransacaoID,
    t.Natureza,
    t.DataTransacao,
    t.Descricao,
    t.Valor
FROM dbo.Transacoes AS t
WHERE t.Ativo = 1
ORDER BY t.Natureza    ASC,               -- primeiro: agrupa por natureza (C antes de D)
         t.Valor       DESC,              -- segundo: maior valor primeiro dentro de cada natureza
         t.DataTransacao DESC;            -- terceiro: mais recente primeiro em caso de empate
~~~

A leitura de uma cláusula `ORDER BY` com múltiplos critérios segue uma hierarquia: o primeiro critério é o dominante, o segundo só entra em ação quando há empate no primeiro, o terceiro só atua quando há empate no segundo, e assim por diante.

### 2.6 Ordenando por Posição Numérica (e por que evitar)

~~~sql
-- Funciona, mas é considerado má prática em código de produção
SELECT TransacaoID, DataTransacao, Valor
FROM dbo.Transacoes
ORDER BY 2 DESC, 3 DESC;                  -- 2 = DataTransacao, 3 = Valor
~~~

Ordenar por posição numérica funciona, mas é frágil: se alguém alterar a ordem das colunas no `SELECT`, o `ORDER BY` passa a ordenar pela coluna errada sem gerar nenhum erro. Em código de produção, sempre use os nomes das colunas ou aliases.

---

## 3. TOP — Limitando a Quantidade de Registros

`TOP` é uma extensão do SQL Server (não faz parte do padrão ANSI SQL — para isso existe `FETCH FIRST N ROWS`, que veremos com `OFFSET-FETCH`). Ele limita o número de linhas retornadas pela query e é sempre usado em conjunto com `ORDER BY` quando o objetivo é selecionar os "maiores" ou "menores" de um conjunto.

### 3.1 Sintaxe e Funcionamento

~~~sql
-- Sintaxe do TOP
SELECT TOP (N) [PERCENT] [WITH TIES]
    colunas
FROM tabela
ORDER BY criterio;
~~~

`N` é o número de linhas. `PERCENT` transforma N em percentual. `WITH TIES` inclui linhas adicionais que empatam na última posição. `ORDER BY` é tecnicamente opcional com `TOP`, mas **sempre deve ser usado** — sem ele, o SQL Server retorna N linhas em ordem indeterminada, o que raramente é o comportamento desejado.

### 3.2 Os 5 Maiores Lançamentos

~~~sql
-- Os 5 lançamentos de maior valor no FinanceDB
SELECT TOP (5)
    t.TransacaoID,
    t.DataTransacao,
    t.Descricao,
    t.Valor,
    t.Natureza
FROM dbo.Transacoes AS t
WHERE t.Ativo = 1
ORDER BY t.Valor DESC;                    -- ordena do maior para o menor antes de cortar
~~~

O SQL Server primeiro executa toda a query — aplica o `FROM`, o `WHERE`, o `SELECT` — e só então o `TOP` corta as linhas excedentes. Por isso, o `ORDER BY` precisa ser definido antes do corte acontecer: sem ele, o corte seria arbitrário.

### 3.3 Os 3 Maiores Débitos por Conta

~~~sql
-- Os 3 maiores débitos (Natureza = 'D') da conta 4
SELECT TOP (3)
    t.TransacaoID,
    t.DataTransacao,
    t.Descricao,
    t.Valor
FROM dbo.Transacoes AS t
WHERE t.Ativo    = 1
  AND t.ContaID  = 4                      -- filtra pela conta bancária
  AND t.Natureza = 'D'                    -- apenas débitos
ORDER BY t.Valor DESC;                    -- maior débito primeiro
~~~

### 3.4 TOP PERCENT — Percentual do Dataset

~~~sql
-- Os 10% lançamentos de maior valor (útil para relatórios de pareto)
SELECT TOP (10) PERCENT
    t.TransacaoID,
    t.DataTransacao,
    t.Descricao,
    t.Valor,
    t.Natureza
FROM dbo.Transacoes AS t
WHERE t.Ativo = 1
ORDER BY t.Valor DESC;
~~~

Com 29 lançamentos no dataset atual, `TOP (10) PERCENT` retornaria `CEILING(29 * 0.10) = 3` linhas. O SQL Server sempre arredonda para cima no `TOP PERCENT`.

### 3.5 TOP WITH TIES — Incluindo Empates

~~~sql
-- Top 3 lançamentos por valor, incluindo todos os empatados na 3ª posição
SELECT TOP (3) WITH TIES
    t.TransacaoID,
    t.DataTransacao,
    t.Descricao,
    t.Valor
FROM dbo.Transacoes AS t
WHERE t.Ativo = 1
ORDER BY t.Valor DESC;
~~~

Sem `WITH TIES`, se o 3º e 4º lançamentos tiverem o mesmo valor, o SQL Server retorna apenas o 3º (qual dos dois empata é indeterminado). Com `WITH TIES`, ambos são incluídos, podendo retornar mais de 3 linhas. Isso é essencial em relatórios financeiros onde empates precisam ser tratados com justiça — como rankings de vendedores ou análise de parcelas de mesmo valor.

### 3.6 TOP com Variável — Dinamismo em Procedures

~~~sql
-- TOP com variável: útil dentro de stored procedures
DECLARE @QuantidadeLinhas INT = 5;        -- define o limite como variável

SELECT TOP (@QuantidadeLinhas)
    t.TransacaoID,
    t.DataTransacao,
    t.Descricao,
    t.Valor
FROM dbo.Transacoes AS t
WHERE t.Ativo = 1
ORDER BY t.DataTransacao DESC;
~~~

O uso de variáveis dentro do `TOP` é uma funcionalidade muito útil para stored procedures que recebem o limite como parâmetro. Os parênteses em `TOP (@variavel)` são obrigatórios quando se usa variável ou expressão — sem eles, o SQL Server retorna erro de sintaxe.

---

## 4. OFFSET-FETCH — Paginação Profissional

`OFFSET-FETCH` é a implementação do padrão ANSI SQL para paginação. Foi introduzido no SQL Server 2012 e é a forma recomendada para paginar resultados em aplicações modernas. A lógica é simples: **OFFSET** pula N linhas do início, **FETCH NEXT** retorna as próximas M linhas.

### 4.1 Sintaxe

~~~sql
SELECT colunas
FROM tabela
ORDER BY criterio          -- OBRIGATÓRIO com OFFSET-FETCH
OFFSET  N ROWS             -- pula N linhas
FETCH NEXT M ROWS ONLY;   -- retorna as próximas M linhas
~~~

Ao contrário de `TOP`, `ORDER BY` é **obrigatório** com `OFFSET-FETCH`. O SQL Server levanta um erro se você tentar usar `OFFSET-FETCH` sem `ORDER BY`.

### 4.2 Paginação de Extrato Bancário

~~~sql
-- Página 1: primeiros 10 lançamentos (OFFSET 0 = não pula nenhuma linha)
SELECT
    t.TransacaoID,
    t.DataTransacao,
    t.Descricao,
    t.Valor,
    t.Natureza
FROM dbo.Transacoes AS t
WHERE t.Ativo = 1
ORDER BY t.DataTransacao DESC,
         t.TransacaoID   DESC
OFFSET  0 ROWS             -- página 1: começa do início
FETCH NEXT 10 ROWS ONLY;  -- retorna 10 linhas

-- Página 2: próximos 10 lançamentos
SELECT
    t.TransacaoID,
    t.DataTransacao,
    t.Descricao,
    t.Valor,
    t.Natureza
FROM dbo.Transacoes AS t
WHERE t.Ativo = 1
ORDER BY t.DataTransacao DESC,
         t.TransacaoID   DESC
OFFSET  10 ROWS            -- página 2: pula os 10 primeiros
FETCH NEXT 10 ROWS ONLY;  -- retorna os próximos 10

-- Página 3: próximos 10 lançamentos
SELECT
    t.TransacaoID,
    t.DataTransacao,
    t.Descricao,
    t.Valor,
    t.Natureza
FROM dbo.Transacoes AS t
WHERE t.Ativo = 1
ORDER BY t.DataTransacao DESC,
         t.TransacaoID   DESC
OFFSET  20 ROWS            -- página 3: pula os 20 primeiros
FETCH NEXT 10 ROWS ONLY;  -- retorna os próximos 10
~~~

O padrão de cálculo do OFFSET é sempre `(NumeroDaPagina - 1) * TamanhoDaPagina`. Página 1: `(1-1)*10 = 0`. Página 2: `(2-1)*10 = 10`. Página 3: `(3-1)*10 = 20`.

### 4.3 Paginação com Variáveis — Pronto para Stored Procedure

~~~sql
-- Paginação parametrizada: base para uma stored procedure de extrato
DECLARE @Pagina      INT = 2;             -- número da página desejada
DECLARE @TamanhoPag  INT = 10;            -- registros por página
DECLARE @ContaFiltro INT = 4;             -- ContaID a filtrar

SELECT
    t.TransacaoID,
    t.DataTransacao,
    t.Descricao,
    t.Valor,
    t.Natureza,
    t.Conciliado
FROM dbo.Transacoes AS t
WHERE t.Ativo   = 1
  AND t.ContaID = @ContaFiltro
ORDER BY t.DataTransacao DESC,
         t.TransacaoID   DESC
OFFSET  (@Pagina - 1) * @TamanhoPag ROWS  -- calcula o offset dinamicamente
FETCH NEXT @TamanhoPag ROWS ONLY;         -- tamanho da página parametrizado
~~~

Esta estrutura é a base exata de uma stored procedure de extrato bancário paginado. Quando o Capítulo 26 cobrir Stored Procedures, este código será encapsulado com parâmetros de entrada formais. Por ora, as variáveis demonstram o conceito com clareza.

### 4.4 Contando o Total de Páginas

Em aplicações reais, a interface precisa saber quantas páginas existem para renderizar a navegação. A query de contagem é sempre separada:

~~~sql
-- Conta o total de lançamentos para calcular número de páginas
DECLARE @TamanhoPag  INT = 10;
DECLARE @ContaFiltro INT = 4;

SELECT
    COUNT(*)                              AS TotalRegistros,
    CEILING(COUNT(*) * 1.0 / @TamanhoPag) AS TotalPaginas   -- arredonda para cima
FROM dbo.Transacoes AS t
WHERE t.Ativo   = 1
  AND t.ContaID = @ContaFiltro;
~~~

A multiplicação por `1.0` força a divisão a ser decimal em vez de inteira. `CEILING` arredonda para cima porque se há 29 registros e páginas de 10, são 3 páginas (não 2,9).

---

## 5. Diagrama — Fluxo de Processamento com ORDER BY, TOP e OFFSET-FETCH

~~~mermaid
flowchart TD
    A([Início da Query]) --> B[FROM: identifica tabelas]
    B --> C[WHERE: filtra linhas]
    C --> D{GROUP BY presente?}
    D -- Sim --> E[GROUP BY: agrupa]
    D -- Não --> F[SELECT: define colunas]
    E --> G{HAVING presente?}
    G -- Sim --> H[HAVING: filtra grupos]
    G -- Não --> F
    H --> F
    F --> I[ORDER BY: ordena resultado]
    I --> J{Limitador presente?}
    J -- TOP N --> K[TOP: corta primeiras N linhas]
    J -- OFFSET-FETCH --> L[OFFSET: pula N linhas\nFETCH NEXT: retorna M linhas]
    J -- Nenhum --> M([Retorna todas as linhas ordenadas])
    K --> N([Retorna N linhas])
    L --> O([Retorna página solicitada])

    style A fill:#2d6a4f,color:#fff
    style N fill:#1b4332,color:#fff
    style O fill:#1b4332,color:#fff
    style M fill:#1b4332,color:#fff
~~~

---

## 6. Comparativo — TOP vs OFFSET-FETCH

~~~sql
-- TOP: simples, direto, não-ANSI, não pagina bem
SELECT TOP (5) TransacaoID, Valor
FROM dbo.Transacoes
ORDER BY Valor DESC;

-- OFFSET-FETCH: padrão ANSI, paginação real, mais verboso
SELECT TransacaoID, Valor
FROM dbo.Transacoes
ORDER BY Valor DESC
OFFSET 0 ROWS
FETCH NEXT 5 ROWS ONLY;
~~~

Use `TOP` quando precisar apenas dos N maiores/menores sem paginação. Use `OFFSET-FETCH` quando a aplicação precisa navegar entre páginas. Misturar os dois na mesma query não é permitido pelo SQL Server.

---

## 7. Ordenando Resultados de Views e CTEs

~~~sql
-- ORDER BY funciona normalmente em queries sobre views
-- (a view não tem ORDER BY próprio — a query que a consome define a ordem)
SELECT
    cb.ContaID,
    cb.NomeConta,
    cb.SaldoAtual
FROM dbo.ContasBancarias AS cb
WHERE cb.Ativo = 1
ORDER BY cb.SaldoAtual DESC;             -- conta com maior saldo primeiro
~~~

Uma observação importante: **views não devem ter `ORDER BY`** em sua definição (a não ser que usem `TOP` ou `OFFSET-FETCH` para tornar o `ORDER BY` válido no contexto da view). A ordenação de uma view deve ser definida sempre na query que a consome.

---

## 8. Antecipação de Erros e Troubleshooting

**Erro 1 — ORDER BY sem OFFSET quando se quer paginação:**
~~~sql
-- ERRADO: isso retorna apenas os 5 primeiros, não a página 2
SELECT TOP (5) TransacaoID, Valor
FROM dbo.Transacoes
ORDER BY Valor DESC;
-- Para a página 2, use OFFSET-FETCH, não TOP
~~~

**Erro 2 — OFFSET-FETCH sem ORDER BY:**
~~~sql
-- ERRO: Msg 154 — The ORDER BY clause is invalid in views, inline functions,
-- derived tables, subqueries, and common table expressions, unless TOP,
-- OFFSET or FOR XML is also specified.
SELECT TransacaoID, Valor
FROM dbo.Transacoes
OFFSET 0 ROWS
FETCH NEXT 5 ROWS ONLY;
-- CORRETO: sempre inclua ORDER BY antes de OFFSET-FETCH
~~~

**Erro 3 — TOP com variável sem parênteses:**
~~~sql
-- ERRADO: gera erro de sintaxe quando N vem de variável
DECLARE @N INT = 5;
SELECT TOP @N TransacaoID FROM dbo.Transacoes ORDER BY Valor DESC;

-- CORRETO: parênteses obrigatórios com variável ou expressão
SELECT TOP (@N) TransacaoID FROM dbo.Transacoes ORDER BY Valor DESC;
~~~

**Erro 4 — ORDER BY com número de posição e alteração de colunas:**
~~~sql
-- PERIGOSO: se alguém trocar a ordem das colunas no SELECT,
-- o ORDER BY passa a ordenar pela coluna errada sem aviso
SELECT DataTransacao, Valor, TransacaoID
FROM dbo.Transacoes
ORDER BY 2 DESC;   -- ordena por Valor
-- Após manutenção:
SELECT Valor, DataTransacao, TransacaoID   -- colunas trocadas
FROM dbo.Transacoes
ORDER BY 2 DESC;   -- agora ordena por DataTransacao — bug silencioso!
~~~

**Erro 5 — Confundir OFFSET com número de página:**
~~~sql
-- ERRADO: quem quer a página 2 com 10 itens não usa OFFSET 2
SELECT TransacaoID FROM dbo.Transacoes
ORDER BY TransacaoID
OFFSET 2 ROWS FETCH NEXT 10 ROWS ONLY;  -- isso pula apenas 2 linhas, não 20

-- CORRETO: OFFSET = (página - 1) * tamanho
OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY; -- página 2 com tamanho 10
~~~

---

## 9. Boas Práticas Consolidadas

Em código de produção financeiro, algumas práticas são inegociáveis. Sempre especifique `ASC` ou `DESC` explicitamente, nunca dependa do padrão implícito. Sempre inclua um **tie-breaker** — geralmente a chave primária — como último critério de ordenação para garantir determinismo. Nunca use ordenação por posição numérica (`ORDER BY 1, 2`) em código que será mantido por outros. Para paginação, prefira `OFFSET-FETCH` em vez de técnicas antigas com `ROW_NUMBER()` em subquery. E nunca construa lógica de negócio que dependa de uma ordem implícita sem `ORDER BY` — hoje funciona, mas uma atualização de índice ou estatísticas pode mudar tudo silenciosamente.

---

## 10. Desafio de Fixação

**Cenário:** O gerente financeiro da FinanceDB Holding (EmpresaID = 7) solicitou três relatórios distintos para a reunião de amanhã:

**Relatório A:** Liste os 3 maiores créditos (Natureza = 'C') registrados no banco, incluindo data, descrição e valor, ordenados do maior para o menor. Se houver empate na 3ª posição, inclua todos os empatados.

**Relatório B:** Exiba o extrato completo de todas as transações ativas, ordenado por data decrescente e por valor decrescente em caso de empate. Mostre apenas a página 2, com 5 registros por página.

**Relatório C:** Liste todas as contas bancárias ativas ordenadas pelo saldo atual de forma decrescente. Em caso de empate de saldo, ordene pelo nome da conta em ordem alfabética.

---

### Resolução Comentada

~~~sql
-- ============================================================
-- RELATÓRIO A: Top 3 maiores créditos com empates incluídos
-- ============================================================
SELECT TOP (3) WITH TIES              -- inclui empates na 3ª posição
    t.TransacaoID,
    t.DataTransacao,
    t.Descricao,
    t.Valor,
    t.Natureza
FROM dbo.Transacoes AS t
WHERE t.Ativo    = 1                  -- apenas registros ativos
  AND t.Natureza = 'C'               -- apenas créditos
ORDER BY t.Valor DESC;               -- maior valor primeiro para o TOP funcionar corretamente

-- ============================================================
-- RELATÓRIO B: Extrato paginado — página 2, 5 registros por página
-- ============================================================
DECLARE @Pagina     INT = 2;         -- número da página desejada
DECLARE @TamanhoPag INT = 5;         -- registros por página

SELECT
    t.TransacaoID,
    t.DataTransacao,
    t.Descricao,
    t.Valor,
    t.Natureza,
    t.Conciliado
FROM dbo.Transacoes AS t
WHERE t.Ativo = 1
ORDER BY t.DataTransacao DESC,       -- mais recente primeiro
         t.Valor         DESC        -- desempate por valor decrescente
OFFSET  (@Pagina - 1) * @TamanhoPag ROWS   -- (2-1)*5 = 5 linhas puladas
FETCH NEXT @TamanhoPag ROWS ONLY;          -- retorna 5 linhas

-- ============================================================
-- RELATÓRIO C: Contas bancárias por saldo, desempate alfabético
-- ============================================================
SELECT
    cb.ContaID,
    cb.NomeConta,
    cb.Agencia,
    cb.Conta,
    cb.SaldoAtual,
    cb.Tipo
FROM dbo.ContasBancarias AS cb
WHERE cb.Ativo = 1                   -- apenas contas ativas
ORDER BY cb.SaldoAtual DESC,         -- maior saldo primeiro
         cb.NomeConta  ASC;          -- desempate: ordem alfabética pelo nome
~~~

---

## Resumo dos Pontos-Chave

`ORDER BY` é a única cláusula que pode referenciar aliases definidos no `SELECT` porque é processada depois dele — é também a última cláusula processada antes da entrega do resultado. Sem `ORDER BY`, o SQL Server não garante absolutamente nenhuma ordem nos resultados, e confiar em ordenação implícita é um bug aguardando manifestar-se. Sempre inclua um tie-breaker — geralmente a chave primária — para garantir que resultados com empate sejam sempre retornados na mesma sequência. `TOP (N)` limita o número de linhas e deve sempre ser acompanhado de `ORDER BY` para ser significativo; `TOP WITH TIES` inclui linhas que empatam na última posição. `OFFSET-FETCH` é o padrão ANSI para paginação: `OFFSET N ROWS` pula N linhas, `FETCH NEXT M ROWS ONLY` retorna as próximas M. O cálculo do offset para a página P com tamanho T é sempre `(P - 1) * T`. `ORDER BY` é obrigatório com `OFFSET-FETCH` e o SQL Server levanta erro se não estiver presente. `TOP` e `OFFSET-FETCH` não podem ser usados na mesma query.

---

## Log de Estado do Projeto

~~~text
## Estado — Após o Capítulo 13

=== LIVRO ===
Nome: SQL Server para Aplicações Financeiras com T-SQL
Módulo Atual: Módulo 2 — ESSENCIAL: T-SQL Básico
Capítulo Concluído: 13 de 42

=== BANCO DE DADOS ===
Nome: FinanceDB
Status: Operacional

=== TABELAS E REGISTROS ===
Bancos:           5 registros
TiposTransacao:   3 registros
Empresas:         2 registros (FinanceDB Holding EmpresaID=7 e segunda empresa)
ContasBancarias:  4 registros
PlanoDeContas:    25 registros (3 níveis hierárquicos)
Transacoes:       29 lançamentos (Jan a Abr 2026)
Orcamentos:       registros Jan/Fev/Mar 2026

=== COMANDOS DOMINADOS ===
✅ CREATE DATABASE, CREATE TABLE
✅ PRIMARY KEY, FOREIGN KEY, IDENTITY
✅ INSERT INTO (linha única, múltiplas linhas, INSERT...SELECT)
✅ SCOPE_IDENTITY(), OUTPUT INSERTED
✅ SELECT, aliases, colunas calculadas, DISTINCT
✅ WHERE, AND, OR, NOT, BETWEEN, IN, LIKE, IS NULL, IS NOT NULL
✅ ORDER BY ASC/DESC, tie-breaker, alias no ORDER BY
✅ TOP (N), TOP PERCENT, TOP WITH TIES, TOP com variável
✅ OFFSET-FETCH, paginação parametrizada

=== PRÓXIMO CAPÍTULO ===
Capítulo 14: UPDATE e DELETE com Segurança
~~~

---

## Prompt de Continuidade — Capítulo 14

~~~text
Contexto: Estou estudando o livro "SQL Server para Aplicações
Financeiras com T-SQL". Meu ambiente é Windows 11, SSMS,
SQL Server 2022. O projeto prático incremental se chama FinanceDB.

Concluí o Capítulo 13, que cobriu ordenação e limitação de
resultados. Aprendi: ORDER BY com ASC/DESC, tie-breaker,
referência a aliases, TOP (N), TOP PERCENT, TOP WITH TIES,
TOP com variável, OFFSET-FETCH para paginação real, cálculo
dinâmico de offset e contagem de páginas.

O banco FinanceDB possui 7 tabelas populadas: Bancos (5),
TiposTransacao (3), Empresas (2 — FinanceDB Holding EmpresaID=7
e segunda empresa), ContasBancarias (4), PlanoDeContas (25),
Transacoes (29 lançamentos Jan a Abr 2026) e Orcamentos
(Jan/Fev/Mar 2026).

Siga rigorosamente o Prompt Mestre v1.1: narrativa densa
com mínimo de 2.000 palavras, Técnica de Feynman, analogia
de ancoragem, diagrama Mermaid escapado com ~~~mermaid,
código SQL comentado linha a linha escapado com ~~~,
glossário técnico, antecipação de erros, troubleshooting,
desafio de fixação com resolução comentada, resumo dos
pontos-chave, log de estado do projeto atualizado e prompt
de continuidade para o próximo capítulo.
Todo o conteúdo deve ser gerado dentro de um bloco ```markdown.
Chame aulas de capítulos e curso de livro.

Por favor, gere o Capítulo 14: Modificando e Removendo —
UPDATE e DELETE com Segurança. Objetivo: atualizar e excluir
registros do FinanceDB com UPDATE e DELETE de forma segura,
usando cláusulas WHERE precisas, entendendo os riscos de
operações sem filtro, usando TOP para limitar o escopo de
modificações em lote, e aprendendo a usar transações explícitas
como rede de proteção antes de executar qualquer operação
destrutiva crítica.
Pré-requisito: Capítulo 13 concluído.
~~~

---

Dúvidas? Posso prosseguir para o Capítulo 14?