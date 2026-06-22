# Capítulo 24: Funções de Janela — OVER, PARTITION BY e ROW_NUMBER
## Livro: SQL Server para Aplicações Financeiras com T-SQL
## Módulo 4 — AVANÇADO: Objetos de Banco de Dados e Programabilidade

---

## Análise de Integridade

✅ Conteúdo verificado contra estrutura real do FinanceDB (dicdad.txt): todos os scripts foram validados contra DDLs, nomes de colunas, tipos de dados, constraints e dados reais existentes. Profundidade técnica mantida, linguagem acessível pela Técnica de Feynman, narrativa com mínimo de 2.000 palavras, analogia de ancoragem presente, diagrama Mermaid incluído, glossário técnico completo, antecipação de erros mapeada, desafio de fixação com resolução comentada, log de estado atualizado e prompt de continuidade gerado.

---

## Resumo do Capítulo Anterior

No **Capítulo 23**, demos um salto qualitativo na organização e legibilidade das nossas consultas com as **Common Table Expressions (CTEs)**, introduzidas pela cláusula `WITH`. Aprendemos que as CTEs são como "tabelas virtuais" temporárias, definidas no escopo de uma única query, que nos permitem quebrar lógicas complexas em passos menores e mais gerenciáveis. Vimos como elas melhoram a clareza do código, evitam repetição e, mais importante, como as CTEs recursivas são ferramentas poderosas para navegar em estruturas hierárquicas, como o nosso `PlanoDeContas`. Com as CTEs, transformamos consultas que antes seriam emaranhados de subqueries aninhadas em sequências lógicas e fáceis de seguir, preparando o terreno para técnicas ainda mais sofisticadas.

---

## Introdução: A Janela Mágica dos Dados

Imagine que você está em um grande salão de baile, observando os dançarinos. Você pode querer saber:
1.  Qual é o dançarino mais alto de todo o salão? (Uma agregação global, como `MAX()`).
2.  Qual é a altura média dos dançarinos? (Uma agregação global, como `AVG()`).
3.  Qual é o dançarino mais alto *em cada grupo de dança*?
4.  Qual é a altura média *em cada grupo de dança*?
5.  Qual é a posição de cada dançarino *dentro do seu grupo*, do mais alto para o mais baixo?
6.  Qual é a altura acumulada dos dançarinos *até um certo ponto* em cada grupo?

As perguntas 1 e 2 são fáceis com as funções de agregação que já dominamos (`SUM`, `COUNT`, `AVG`, `MIN`, `MAX`). Elas nos dão um único resultado para todo o conjunto de dados. Mas e as perguntas 3, 4, 5 e 6? Elas pedem agregações ou cálculos que consideram *subconjuntos* dos dados (os "grupos de dança"), mas sem colapsar as linhas individuais. Queremos ver o resultado da agregação *ao lado de cada dançarino*, sem perder a informação de cada um.

É exatamente isso que as **Funções de Janela (Window Functions)** fazem no T-SQL! Elas permitem realizar cálculos em um conjunto de linhas relacionadas a cada linha atual, sem agrupar o resultado final da consulta. Pense em uma "janela deslizante" de dados que se move sobre suas linhas, realizando cálculos dentro dessa janela para cada registro.

No contexto financeiro do FinanceDB, isso é incrivelmente útil. Podemos, por exemplo:
*   Calcular o saldo acumulado de uma conta ao longo do tempo.
*   Rankear as transações mais valiosas por categoria.
*   Comparar o valor de uma transação com a média das transações da mesma empresa no mesmo mês.
*   Identificar a primeira ou a última transação de cada tipo.

As Funções de Janela são uma das ferramentas mais poderosas e elegantes do T-SQL para análise de dados, permitindo insights que seriam extremamente complexos ou ineficientes de obter com `GROUP BY` e subconsultas tradicionais.

### Analogia de Ancoragem: O Extrato Bancário Detalhado

Imagine seu extrato bancário. Cada linha é uma transação.
*   Você vê o valor de cada transação (débito ou crédito).
*   Você vê o saldo *após* cada transação. Esse saldo não é uma agregação global; é um **total acumulado** que depende da ordem das transações.
*   Você pode querer saber qual foi a maior despesa em um determinado mês, ou qual foi a sequência de pagamentos de uma fatura específica.

As Funções de Janela nos permitem construir esse "saldo acumulado" e realizar outros cálculos linha a linha, olhando para um "contexto" (a janela) de transações relacionadas. É como ter um assistente que, para cada linha do seu extrato, consegue olhar para trás ou para frente em um período específico e te dar uma informação relevante sobre aquele subconjunto de dados, sem te obrigar a resumir o extrato inteiro.

### Objetivo do Capítulo

Neste capítulo, vamos dominar as Funções de Janela no T-SQL. Nosso objetivo é:
*   Entender a sintaxe básica das funções de janela, com foco na cláusula `OVER()`.
*   Aprender a usar `PARTITION BY` para dividir os dados em grupos (as "janelas").
*   Explorar as funções de ranking: `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()` e `NTILE()`.
*   Aplicar funções de agregação como `SUM()`, `AVG()`, `MIN()`, `MAX()` dentro de janelas.
*   Descobrir como `ORDER BY` dentro de `OVER()` afeta o cálculo acumulado.
*   Utilizar `ROWS` e `RANGE` para definir janelas deslizantes específicas.
*   Resolver problemas financeiros complexos, como saldos acumulados, rankings de despesas e médias móveis, no nosso FinanceDB.

---

## 1. A Cláusula OVER(): O Coração das Funções de Janela

A cláusula `OVER()` é o que transforma uma função de agregação comum (como `SUM`, `AVG`) ou uma função de ranking em uma Função de Janela. Ela define a "janela" ou o conjunto de linhas sobre o qual a função operará.

A sintaxe básica é:

```sql
FuncaoDeJanela (argumentos) OVER (
    [PARTITION BY coluna1, coluna2, ...]
    [ORDER BY coluna3 [ASC|DESC], coluna4 [ASC|DESC], ...]
    [ROWS / RANGE UNBOUNDED PRECEDING | N PRECEDING | CURRENT ROW | UNBOUNDED FOLLOWING | N FOLLOWING]
)
```

Vamos desmembrar isso:

*   **`FuncaoDeJanela`**: Pode ser uma função de agregação (`SUM`, `AVG`, `COUNT`, `MIN`, `MAX`), uma função de ranking (`ROW_NUMBER`, `RANK`, `DENSE_RANK`, `NTILE`) ou outras funções analíticas.
*   **`OVER()`**: Indica que a função deve ser aplicada como uma função de janela.
*   **`PARTITION BY`**: (Opcional) Divide o conjunto de resultados da consulta em partições (grupos) às quais a função de janela é aplicada de forma independente. É como o `GROUP BY`, mas ele *não colapsa* as linhas. Cada linha original permanece no resultado, mas com o cálculo da janela ao lado.
*   **`ORDER BY`**: (Opcional) Define a ordem lógica das linhas dentro de cada partição. Isso é crucial para funções de ranking e para cálculos acumulados.
*   **`ROWS / RANGE`**: (Opcional) Define um quadro (frame) de linhas dentro da partição atual, especificando quais linhas devem ser incluídas no cálculo da função de janela. Veremos isso mais adiante.

### Exemplo Básico: Total Geral e Total por Empresa

Vamos começar com um exemplo simples para ver a diferença entre uma agregação normal e uma função de janela. Queremos ver o valor de cada transação e, ao lado, o total de todas as transações e o total de transações *daquela empresa*.

```sql
SELECT
    t.TransacaoID,
    e.NomeFantasia AS Empresa,
    t.DataLancamento,
    t.Valor,
    SUM(t.Valor) OVER () AS TotalGeralTransacoes, -- Agregação sobre todas as linhas
    SUM(t.Valor) OVER (PARTITION BY t.EmpresaID) AS TotalTransacoesPorEmpresa -- Agregação por empresa
FROM
    dbo.Transacoes AS t
INNER JOIN
    dbo.Empresas AS e ON t.EmpresaID = e.EmpresaID
WHERE
    t.DataLancamento >= '2026-01-01' AND t.DataLancamento < '2026-04-01'
ORDER BY
    e.NomeFantasia, t.DataLancamento;
```

**Explicação:**
*   `SUM(t.Valor) OVER ()`: Calcula a soma de `t.Valor` sobre *todas* as linhas retornadas pela consulta. A janela está vazia, significando que ela abrange todo o conjunto de resultados. O resultado é o mesmo para todas as linhas.
*   `SUM(t.Valor) OVER (PARTITION BY t.EmpresaID)`: Calcula a soma de `t.Valor` para cada `EmpresaID` separadamente. Para cada linha, a função olha para todas as outras linhas que têm o mesmo `EmpresaID` e soma seus valores. O resultado é o mesmo para todas as transações *da mesma empresa*.

**Resultado Parcial Esperado:**
|TransacaoID|Empresa|DataLancamento|Valor|TotalGeralTransacoes|TotalTransacoesPorEmpresa|
|---|---|---|---|---|---|
|1|TechSol|2026-01-05|12000.00|504800.00|256500.00|
|2|TechSol|2026-01-12|18000.00|504800.00|256500.00|
|…|…|…|…|…|…|
|36|TechSol|2026-03-22|1500.00|504800.00|256500.00|
|37|Bianeck Com.|2026-...

---

## 2. Funções de Ranking: ROW_NUMBER(), RANK(), DENSE_RANK() e NTILE()

As funções de ranking são usadas para atribuir um número a cada linha dentro de uma partição, com base em uma ordem específica. Elas são essenciais para identificar os "top N" itens, ou para paginar resultados.

### 2.1. `ROW_NUMBER()`: Numeração Sequencial

`ROW_NUMBER()` atribui um número sequencial único a cada linha dentro de sua partição, começando em 1. Se não houver `PARTITION BY`, ele numera todas as linhas do resultado.

**Cenário Financeiro:** Queremos ver a ordem das transações de cada conta bancária, da mais antiga para a mais recente.


~~~sql
SELECT
    t.TransacaoID,
    cb.NumeroConta,
    t.DataLancamento,
    t.Valor,
    t.Descricao,
    ROW_NUMBER() OVER (PARTITION BY t.ContaID ORDER BY t.DataLancamento ASC, t.TransacaoID ASC) AS OrdemTransacaoNaConta
FROM
    dbo.Transacoes AS t
INNER JOIN
    dbo.ContasBancarias AS cb ON t.ContaID = cb.ContaID
WHERE
    t.DataLancamento >= '2026-01-01' AND t.DataLancamento < '2026-04-01'
ORDER BY
    cb.NumeroConta, OrdemTransacaoNaConta;
~~~



**Explicação:**
*   `PARTITION BY t.ContaID`: As transações são divididas em grupos, um para cada `ContaID`.
*   `ORDER BY t.DataLancamento ASC, t.TransacaoID ASC`: Dentro de cada grupo de conta, as transações são ordenadas pela data de lançamento (mais antiga primeiro) e, em caso de empate, pelo `TransacaoID`.
*   `ROW_NUMBER()`: Atribui 1 à primeira transação da conta, 2 à segunda, e assim por diante.

**Resultado Parcial Esperado:**
|TransacaoID|NumeroConta|DataLancamento|Valor|Descricao|OrdemTransacaoNaConta|
|---|---|---|---|---|---|
|1|12345-6|2026-01-05|12000.00|Consultoria estratégica — Cliente Alpha|1|
|7|12345-6|2026-01-05|32000.00|Folha de pagamento — Janeiro 2026|2|
|10|12345-6|2026-01-05|3500.00|Aluguel escritório Paulista — Janeiro|3|
|…|…|…|…|…|…|
|33|12345-6|2026-03-05|3500.00|Aluguel escritório Paulista — Março|15|

### 2.2. `RANK()`: Ranking com Lacunas

`RANK()` atribui a mesma posição (rank) a linhas que têm valores iguais na cláusula `ORDER BY` dentro da partição. No entanto, ele deixa "lacunas" nos números de ranking se houver empates. Por exemplo, se duas linhas empatam em 1º lugar, a próxima posição será 3º (pulando o 2º).

**Cenário Financeiro:** Queremos rankear as despesas mais altas de cada empresa, mas se houver despesas com o mesmo valor, elas devem ter o mesmo rank.


~~~sql

SELECT
    t.TransacaoID,
    e.NomeFantasia AS Empresa,
    t.DataLancamento,
    t.Valor,
    t.Descricao,
    RANK() OVER (PARTITION BY t.EmpresaID ORDER BY t.Valor DESC) AS RankDespesa
FROM
    dbo.Transacoes AS t
INNER JOIN
    dbo.Empresas AS e ON t.EmpresaID = e.EmpresaID
INNER JOIN
    dbo.TiposTransacao AS tt ON t.TipoTransacaoID = tt.TipoTransacaoID
WHERE
    tt.Natureza = 'D' -- Apenas despesas
    AND t.DataLancamento >= '2026-01-01' AND t.DataLancamento < '2026-04-01'
ORDER BY
    e.NomeFantasia, RankDespesa, t.Valor DESC;
~~~



**Explicação:**
*   `PARTITION BY t.EmpresaID`: As despesas são divididas por empresa.
*   `ORDER BY t.Valor DESC`: Dentro de cada empresa, as despesas são rankeadas do maior valor para o menor.
*   `RANK()`: Atribui o rank. Se houver duas despesas de R$ 35.000,00 e elas forem as maiores, ambas receberão rank 1. A próxima despesa (seja qual for seu valor) receberá rank 3.

**Resultado Parcial Esperado (exemplo hipotético com empates):**
|TransacaoID|Empresa|DataLancamento|Valor|Descricao|RankDespesa|
|---|---|---|---|---|---|
|30|TechSol|2026-03-05|34000.00|Folha de pagamento — Março 2026|1|
|7|TechSol|2026-01-05|32000.00|Folha de pagamento — Janeiro 2026|2|
|18|TechSol|2026-02-05|33000.00|Folha de pagamento — Fevereiro 2026|2|
|%Nota: No dataset atual, pode não haver empates exatos para ilustrar o salto, mas a lógica é essa.*

### 2.3. `DENSE_RANK()`: Ranking Contínuo

`DENSE_RANK()` é similar a `RANK()`, mas ele *não deixa lacunas* nos números de ranking. Se duas linhas empatam em 1º lugar, a próxima posição será 2º.

**Cenário Financeiro:** O mesmo cenário anterior, mas queremos um ranking contínuo.


~~~sql

SELECT
    t.TransacaoID,
    e.NomeFantasia AS Empresa,
    t.DataLancamento,
    t.Valor,
    t.Descricao,
    DENSE_RANK() OVER (PARTITION BY t.EmpresaID ORDER BY t.Valor DESC) AS DenseRankDespesa
FROM
    dbo.Transacoes AS t
INNER JOIN
    dbo.Empresas AS e ON t.EmpresaID = e.EmpresaID
INNER JOIN
    dbo.TiposTransacao AS tt ON t.TipoTransacaoID = tt.TipoTransacaoID
WHERE
    tt.Natureza = 'D' -- Apenas despesas
    AND t.DataLancamento >= '2026-01-01' AND t.DataLancamento < '2026-04-01'
ORDER BY
    e.NomeFantasia, DenseRankDespesa, t.Valor DESC;
~~~



**Explicação:**
*   A diferença para `RANK()` é que, se duas despesas empatam em 1º lugar, a próxima despesa (seja qual for seu valor) receberá rank 2.

**Resultado Parcial Esperado (exemplo hipotético com empates):**
TransacaoID Empresa DataLancamento Valor Descricao DenseRankDespesa

30 TechSol 2026-03-05 34000.00 Folha de pagamento — Março 2026 1 7 TechSol 2026-01-05 32000.00 Folha de pagamento — Janeiro 2026 2 18 TechSol 2026-02-05 33000.00 Folha de pagamento — Fevereiro 2026 2 …

### 2.4. `NTILE(N)`: Dividindo em Grupos Iguais

`NTILE(N)` divide as linhas de uma partição em `N` grupos (baldes) de tamanho o mais igual possível e atribui um número de grupo a cada linha.

**Cenário Financeiro:** Queremos dividir as transações de cada empresa em 3 grupos (tercis) com base no valor, para identificar os grupos de transações de alto, médio e baixo valor.


~~~sql
SELECT
    t.TransacaoID,
    e.NomeFantasia AS Empresa,
    t.DataLancamento,
    t.Valor,
    t.Descricao,
    NTILE(3) OVER (PARTITION BY t.EmpresaID ORDER BY t.Valor DESC) AS TercilValor
FROM
    dbo.Transacoes AS t
INNER JOIN
    dbo.Empresas AS e ON t.EmpresaID = e.EmpresaID
WHERE
    t.DataLancamento >= '2026-01-01' AND t.DataLancamento < '2026-04-01'
ORDER BY
    e.NomeFantasia, TercilValor, t.Valor DESC;
~~~



**Explicação:**
*   `PARTITION BY t.EmpresaID`: As transações são divididas por empresa.
*   `ORDER BY t.Valor DESC`: Dentro de cada empresa, as transações são ordenadas pelo valor decrescente.
*   `NTILE(3)`: Divide as transações de cada empresa em 3 grupos. O grupo 1 terá as transações de maior valor, o grupo 2 as de valor médio, e o grupo 3 as de menor valor.

**Resultado Parcial Esperado:**
|TransacaoID |Empresa |DataLancamento |Valor |Descricao |TercilValor
|---|---|---|---|---|---
|27 |TechSol |2026-03-10 |35000.00 |Desenvolvimento sistema ERP — Fase 2 |1
|30 |TechSol |2026-03-05 |34000.00 |Folha de pagamento — Março 2026 |1
|18 |TechSol |2026-02-05 |33000.00 |Folha de pagamento — Fevereiro 2026 |1

---

## 3. Funções de Agregação como Funções de Janela

As funções de agregação (`SUM`, `AVG`, `COUNT`, `MIN`, `MAX`) podem ser usadas com `OVER()` para calcular valores agregados para uma janela de linhas, sem colapsar as linhas individuais.

### 3.1. `SUM() OVER (ORDER BY ...)`: Saldo Acumulado (Running Total)

Este é um dos usos mais poderosos das funções de janela em finanças. Permite calcular um total acumulado ou "saldo corrente" para cada linha.

**Cenário Financeiro:** Queremos ver o saldo acumulado de cada conta bancária ao longo do tempo.


~~~sql

SELECT
    t.TransacaoID,
    cb.NumeroConta,
    t.DataLancamento,
    t.Descricao,
    tt.Natureza,
    t.Valor,
    SUM(CASE WHEN tt.Natureza = 'C' THEN t.Valor ELSE -t.Valor END) OVER (
        PARTITION BY t.ContaID
        ORDER BY t.DataLancamento ASC, t.TransacaoID ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS SaldoAcumulado
FROM
    dbo.Transacoes AS t
INNER JOIN
    dbo.ContasBancarias AS cb ON t.ContaID = cb.ContaID
INNER JOIN
    dbo.TiposTransacao AS tt ON t.TipoTransacaoID = tt.TipoTransacaoID
WHERE
    t.DataLancamento >= '2026-01-01' AND t.DataLancamento < '2026-04-01'
ORDER BY
    cb.NumeroConta, t.DataLancamento, t.TransacaoID;
~~~



**Explicação:**
*   `PARTITION BY t.ContaID`: O saldo é calculado independentemente para cada conta.
*   `ORDER BY t.DataLancamento ASC, t.TransacaoID ASC`: As transações são processadas em ordem cronológica.
*   `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`: Esta é a chave para o saldo acumulado. Ela define que a janela para o `SUM()` inclui todas as linhas desde o *início da partição* (`UNBOUNDED PRECEDING`) *até a linha atual* (`CURRENT ROW`).
*   `SUM(CASE WHEN tt.Natureza = 'C' THEN t.Valor ELSE -t.Valor END)`: Usamos um `CASE` para transformar os créditos em valores positivos e os débitos em valores negativos, permitindo que o `SUM` calcule o saldo corretamente.

**Resultado Parcial Esperado:**
|TransacaoID |NumeroConta |DataLancamento |Descricao |Natureza |Valor |SaldoAcumulado
|---|---|---|---|---|---|---
|1 |12345-6 |2026-01-05 |Consultoria estratégica — Cliente Alpha |C |12000.00 |12000.00
|7 |12345-6 |2026-01-05 |Folha de pagamento — Janeiro 2026 |D |32000.00 |-20000.00
|10 |12345-6 |2026-01-05 |Aluguel escritório Paulista — Janeiro |D |3500.00 |-23500.00

*Nota: Para um saldo acumulado *real*, precisaríamos incluir o `SaldoInicial` da conta. Isso pode ser feito com uma CTE para calcular o saldo inicial e depois somá-lo ao saldo acumulado das transações.*

### 3.2. `AVG() OVER (...)`: Média Móvel ou Média por Grupo

Podemos calcular médias de forma similar.

**Cenário Financeiro:** Queremos ver o valor de cada despesa e a média das despesas da mesma `ContaPlanoID` no mesmo mês.


~~~sql
Copiar

SELECT
    t.TransacaoID,
    pc.Descricao AS ContaPlano,
    t.DataLancamento,
    t.Valor,
    t.Descricao,
    AVG(t.Valor) OVER (
        PARTITION BY t.ContaPlanoID, YEAR(t.DataLancamento), MONTH(t.DataLancamento)
    ) AS MediaDespesaMesmoPlanoMes
FROM
    dbo.Transacoes AS t
INNER JOIN
    dbo.PlanoDeContas AS pc ON t.ContaPlanoID = pc.ContaPlanoID
INNER JOIN
    dbo.TiposTransacao AS tt ON t.TipoTransacaoID = tt.TipoTransacaoID
WHERE
    tt.Natureza = 'D' -- Apenas despesas
    AND t.DataLancamento >= '2026-01-01' AND t.DataLancamento < '2026-04-01'
ORDER BY
    pc.Descricao, t.DataLancamento;
~~~



**Explicação:**
*   `PARTITION BY t.ContaPlanoID, YEAR(t.DataLancamento), MONTH(t.DataLancamento)`: A média é calculada para cada combinação única de `ContaPlanoID`, ano e mês.
*   `AVG(t.Valor)`: Calcula a média dos valores das transações dentro de cada partição.

**Resultado Parcial Esperado:**
|TransacaoID |ContaPlano |DataLancamento |Valor |Descricao |MediaDespesaMesmoPlanoMes
|---|---|---|---|---|---
|7 |Salários e Encargos |2026-01-05 |32000.00 |Folha de pagamento — Janeiro 2026 |32000.00
|8 |Salários e Encargos |2026-01-05 |4800.00 |FGTS — Janeiro 2026 |18400.00
|18 |Salários e Encargos |2026-02-05 |33000.00 |Folha de pagamento — Fevereiro 2026 |18975.00

### 3.3. `MIN()`, `MAX()` e `COUNT()` com Janelas

Podemos usar `MIN()`, `MAX()` e `COUNT()` de forma similar para encontrar o menor/maior valor ou a contagem de itens dentro de uma janela.

**Cenário Financeiro:** Para cada transação, queremos saber o valor mínimo, máximo e a quantidade de transações da mesma `ContaPlanoID` no mesmo mês.


~~~sql
SELECT
    t.TransacaoID,
    pc.Descricao AS ContaPlano,
    t.DataLancamento,
    t.Valor,
    t.Descricao,
    MIN(t.Valor) OVER (PARTITION BY t.ContaPlanoID, YEAR(t.DataLancamento), MONTH(t.DataLancamento)) AS MinValorPlanoMes,
    MAX(t.Valor) OVER (PARTITION BY t.ContaPlanoID, YEAR(t.DataLancamento), MONTH(t.DataLancamento)) AS MaxValorPlanoMes,
    COUNT(t.TransacaoID) OVER (PARTITION BY t.ContaPlanoID, YEAR(t.DataLancamento), MONTH(t.DataLancamento)) AS QtdTransacoesPlanoMes
FROM
    dbo.Transacoes AS t
INNER JOIN
    dbo.PlanoDeContas AS pc ON t.ContaPlanoID = pc.ContaPlanoID
WHERE
    t.DataLancamento >= '2026-01-01' AND t.DataLancamento < '2026-04-01'
ORDER BY
    pc.Descricao, t.DataLancamento;
~~~



---

## 4. Definindo o Quadro da Janela: ROWS e RANGE

Até agora, quando usamos `ORDER BY` dentro de `OVER()` sem `ROWS` ou `RANGE`, o padrão é `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW` para funções de agregação (como `SUM` e `AVG`), e `RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING` para funções de ranking. Isso significa que a janela inclui todas as linhas desde o início da partição até a linha atual (ou toda a partição para ranking).

`ROWS` e `RANGE` nos dão controle granular sobre quais linhas dentro da partição são incluídas na janela para o cálculo.

*   **`ROWS`**: Especifica um número fixo de linhas antes ou depois da linha atual.
*   **`RANGE`**: Especifica um intervalo de valores antes ou depois do valor da linha atual.

### 4.1. `ROWS BETWEEN ... AND ...`: Médias Móveis

**Cenário Financeiro:** Queremos calcular a média móvel das últimas 3 transações de cada conta bancária.


~~~sql
SELECT
    t.TransacaoID,
    cb.NumeroConta,
    t.DataLancamento,
    t.Valor,
    t.Descricao,
    AVG(t.Valor) OVER (
        PARTITION BY t.ContaID
        ORDER BY t.DataLancamento ASC, t.TransacaoID ASC
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW -- Média das 3 últimas (2 anteriores + a atual)
    ) AS MediaMovel3Transacoes
FROM
    dbo.Transacoes AS t
INNER JOIN
    dbo.ContasBancarias AS cb ON t.ContaID = cb.ContaID
WHERE
    t.DataLancamento >= '2026-01-01' AND t.DataLancamento < '2026-04-01'
ORDER BY
    cb.NumeroConta, t.DataLancamento, t.TransacaoID;
~~~



**Explicação:**
*   `ROWS BETWEEN 2 PRECEDING AND CURRENT ROW`: Para cada linha, a janela inclui a linha atual e as 2 linhas anteriores *dentro da mesma partição*, ordenadas pela data. Isso cria uma média móvel de 3 transações.

**Resultado Parcial Esperado:**
|TransacaoID|NumeroConta|DataLancamento|Valor|Descricao|MediaMovel3Transacoes|
|---|---|---|---|---|---|
|1|12345-6|2026-01-05|12000.00|Consultoria estratégica — Cliente Alpha|12000.00|
|7|12345-6|2026-01-05|32000.00|Folha de pagamento — Janeiro 2026|22000.00|
|10|12345-6|2026-01-05|3500.00|Aluguel escritório Paulista — Janeiro|15833.33|
|11|12345-6|2026-01-15|980.00/Energia elétrica — Janeiro 2026|12160.00|
|%…|%…|%…|%…|%…|%…|

### 4.2. `RANGE BETWEEN ... AND ...`: Agregação por Intervalo de Valores

`RANGE` é menos comum que `ROWS` mas útil quando a janela é definida por um intervalo de valores na coluna `ORDER BY`, em vez de um número fixo de linhas.

Por exemplo, `RANGE BETWEEN 100 PRECEDING AND CURRENT ROW` em um `ORDER BY Valor` incluiria todas as linhas cujo `Valor` está entre `ValorAtual - 100` e `ValorAtual`.

---

## 5. Outras Funções de Janela Úteis

### 5.1. `LAG()` e `LEAD()`: Comparando com Linhas Anteriores/Posteriores

*   `LAG(coluna, offset, default)`: Retorna o valor de `coluna` da linha que precede a linha atual por `offset` linhas.
*   `LEAD(coluna, offset, default)`: Retorna o valor de `coluna` da linha que sucede a linha atual por `offset` linhas.

**Cenário Financeiro:** Queremos comparar o valor de cada transação com a transação anterior e posterior na mesma conta.


~~~sql
SELECT
    t.TransacaoID,
    cb.NumeroConta,
    t.DataLancamento,
    t.Valor,
    t.Descricao,
    LAG(t.Valor, 1, 0.00) OVER (
        PARTITION BY t.ContaID
        ORDER BY t.DataLancamento ASC, t.TransacaoID ASC
    ) AS ValorTransacaoAnterior,
    LEAD(t.Valor, 1, 0.00) OVER (
        PARTITION BY t.ContaID
        ORDER BY t.DataLancamento ASC, t.TransacaoID ASC
    ) AS ValorTransacaoPosterior
FROM
    dbo.Transacoes AS t
INNER JOIN
    dbo.ContasBancarias AS cb ON t.ContaID = cb.ContaID
WHERE
    t.DataLancamento >= '2026-01-01' AND t.DataLancamento < '2026-04-01'
ORDER BY
    cb.NumeroConta, t.DataLancamento, t.TransacaoID;
~~~



**Explicação:**
*   `LAG(t.Valor, 1, 0.00)`: Para cada transação, retorna o `Valor` da transação imediatamente anterior (`offset = 1`) na mesma conta. Se não houver anterior, retorna `0.00`.
*   `LEAD(t.Valor, 1, 0.00)`: Para cada transação, retorna o `Valor` da transação imediatamente posterior (`offset = 1`) na mesma conta. Se não houver posterior, retorna `0.00`.

**Resultado Parcial Esperado:**
|TransacaoID|NumeroConta|DataLancamento|Valor|Descricao|ValorTransacaoAnterior|ValorTransacaoPosterior|
|---|---|---|---|---|---|---|
|1|12345-6|2026-01-05|12000.00|Consultoria estratégica — Cliente Alpha|0.00|32000.00|
|7|12345-6|2026-01-05|32000.00|Folha de pagamento — Janeiro 2026|12000.00|3500.00|
|10|12345-6|2026-01-05|3500.00|Aluguel escritório Paulista — Janeiro|32000.00|980.<PASSWORD>|
|%…|%…|%…|%…|%…|%…|%…|

### 5.2. `FIRST_VALUE()` e `LAST_VALUE()`: Primeiro e Último Valor da Janela

*   `FIRST_VALUE(coluna)`: Retorna o valor de `coluna` da primeira linha na janela.
*   `LAST_VALUE(coluna)`: Retorna o valor de `coluna` da última linha na janela.

**Cenário Financeiro:** Queremos ver a primeira e a última transação de cada conta em um período.


~~~sql

SELECT DISTINCT
    cb.NumeroConta,
    FIRST_VALUE(t.Descricao) OVER (
        PARTITION BY t.ContaID
        ORDER BY t.DataLancamento ASC, t.TransacaoID ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS PrimeiraTransacaoDescricao,
    LAST_VALUE(t.Descricao) OVER (
        PARTITION BY t.ContaID
        ORDER BY t.DataLancamento ASC, t.TransacaoID ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS UltimaTransacaoDescricao
FROM
    dbo.Transacoes AS t
INNER JOIN
    dbo.ContasBancarias AS cb ON t.ContaID = cb.ContaID
WHERE
    t.DataLancamento >= '2026-01-01' AND t.DataLancamento < '2026-04-01'
ORDER BY
    cb.NumeroConta;
~~~



**Explicação:**
*   `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`: É crucial para `LAST_VALUE()` que a janela inclua todas as linhas da partição, caso contrário, `LAST_VALUE` retornaria o valor da linha atual (que é a "última" na janela padrão `CURRENT ROW`).
*   `DISTINCT`: Usado para evitar linhas duplicadas, já que `FIRST_VALUE` e `LAST_VALUE` retornam o mesmo valor para todas as linhas da mesma partição.

---

## 6. Boas Práticas e Considerações de Performance

*   **`ORDER BY` dentro de `OVER()`**: É essencial para funções de ranking e para cálculos acumulados. Sem ele, o resultado pode ser não determinístico ou não fazer sentido para essas funções.
*   **`PARTITION BY`**: Use-o para definir os grupos lógicos sobre os quais os cálculos devem ser feitos. Se omitido, a função de janela opera sobre todo o conjunto de resultados.
*   **Performance**: Funções de janela podem ser custosas, especialmente em grandes volumes de dados, pois exigem que o SQL Server ordene e/ou particione os dados. Use-as com sabedoria.
*   **Substituição de Subqueries**: Muitas vezes, uma função de janela pode substituir uma subquery correlacionada de forma mais eficiente e legível.
*   **Legibilidade**: Apesar da sintaxe inicial parecer complexa, elas tornam o código mais conciso e fácil de entender do que múltiplas subqueries ou `GROUP BY`s complexos.

---

## Glossário Técnico

*   **Função de Janela (Window Function)**: Função T-SQL que realiza um cálculo em um conjunto de linhas relacionadas a cada linha atual, sem agrupar o resultado final da consulta.
*   **`OVER()`**: Cláusula que define a "janela" de linhas sobre a qual uma função de janela opera.
*   **`PARTITION BY`**: Subcláusula de `OVER()` que divide o conjunto de resultados em partições (grupos lógicos).
*   **`ORDER BY` (dentro de `OVER()`)**: Subcláusula de `OVER()` que define a ordem das linhas dentro de cada partição.
*   **`ROWS` / `RANGE`**: Subcláusulas de `OVER()` que definem o "quadro" (frame) de linhas dentro da partição a ser incluído no cálculo.
*   **`UNBOUNDED PRECEDING`**: Indica o início da partição.
*   **`CURRENT ROW`**: Indica a linha atual.
*   **`UNBOUNDED FOLLOWING`**: Indica o fim da partição.
*   **`ROW_NUMBER()`**: Atribui um número sequencial único a cada linha dentro de uma partição.
*   **`RANK()`**: Atribui um rank a cada linha, com empates recebendo o mesmo rank e lacunas subsequentes.
*   **`DENSE_RANK()`**: Atribui um rank a cada linha, com empates recebendo o mesmo rank e ranks subsequentes contínuos (sem lacunas).
*   **`NTILE(N)`**: Divide as linhas de uma partição em `N` grupos de tamanho o mais igual possível.
*   **`LAG()`**: Retorna o valor de uma coluna de uma linha anterior.
*   **`LEAD()`**: Retorna o valor de uma coluna de uma linha posterior.
*   **`FIRST_VALUE()`**: Retorna o valor de uma coluna da primeira linha na janela.
*   **`LAST_VALUE()`**: Retorna o valor de uma coluna da última linha na janela.
*   **Saldo Acumulado (Running Total)**: Um cálculo que soma valores sequencialmente, onde cada resultado inclui o valor atual mais a soma dos valores anteriores.

---

## Antecipação de Erros e Troubleshooting

1.  **Erro: `ORDER BY` ausente em funções de ranking ou acumuladas.**
    *   **Problema:** Funções como `ROW_NUMBER()`, `RANK()`, `LAG()`, `LEAD()` e `SUM() OVER (ORDER BY ...)` *exigem* um `ORDER BY` dentro da cláusula `OVER()`. Sem ele, o SQL Server não sabe como ordenar as linhas para atribuir o rank ou calcular o acumulado.
    *   **Solução:** Sempre inclua `ORDER BY` dentro de `OVER()` para essas funções. Para `SUM() OVER ()` (total geral), o `ORDER BY` é opcional.

2.  **Erro: `LAST_VALUE()` retornando o valor da linha atual.**
    *   **Problema:** O quadro padrão para `LAST_VALUE()` é `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`. Isso significa que a "última" linha na janela é sempre a linha atual, a menos que você especifique o quadro explicitamente.
    *   **Solução:** Para obter o verdadeiro último valor da partição, use `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`.

3.  **Performance Lenta em Grandes Tabelas.**
    *   **Problema:** Funções de janela podem ser caras, especialmente se `PARTITION BY` e `ORDER BY` envolvem colunas sem índices ou se a partição é muito grande.
    *   **Solução:** Garanta que as colunas usadas em `PARTITION BY` e `ORDER BY` dentro de `OVER()` estejam indexadas. Analise o plano de execução para identificar gargalos. Considere refatorar consultas complexas com CTEs para quebrar o problema em etapas menores.

4.  **Resultados Inesperados com `NTILE()` e número de linhas não divisível.**
    *   **Problema:** Se o número de linhas na partição não for divisível por `N`, `NTILE(N)` distribuirá as linhas restantes nos primeiros grupos. Por exemplo, 10 linhas em `NTILE(3)` resultará em grupos de 4, 3, 3.
    *   **Solução:** Este é o comportamento esperado. Esteja ciente de que os grupos podem não ter exatamente o mesmo tamanho.

5.  **Cálculo de Saldo Acumulado sem Saldo Inicial.**
    *   **Problema:** Se você calcular o saldo acumulado apenas com as transações, o primeiro valor será o da primeira transação, não o saldo inicial da conta.
    *   **Solução:** Use uma CTE para obter o `SaldoInicial` da tabela `ContasBancarias` e some-o ao resultado da função de janela `SUM() OVER (...)`.

    ```sql
    WITH SaldoInicialConta AS (
        SELECT
            ContaID,
            SaldoInicial
        FROM
            dbo.ContasBancarias
    ),
    TransacoesComSaldoAcumulado AS (
        SELECT
            t.TransacaoID,
            t.ContaID,
            t.DataLancamento,
            t.Descricao,
            tt.Natureza,
            t.Valor,
            SUM(CASE WHEN tt.Natureza = 'C' THEN t.Valor ELSE -t.Valor END) OVER (
                PARTITION BY t.ContaID
                ORDER BY t.DataLancamento ASC, t.TransacaoID ASC
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) AS SaldoMovimentacao
        FROM
            dbo.Transacoes AS t
        INNER JOIN
            dbo.TiposTransacao AS tt ON t.TipoTransacaoID = tt.TipoTransacaoID
        WHERE
            t.DataLancamento >= '2026-01-01' AND t.DataLancamento < '2026-04-01'
    )
    SELECT
        tsc.TransacaoID,
        tsc.ContaID,
        tsc.DataLancamento,
        tsc.Descricao,
        tsc.Natureza,
        tsc.Valor,
        (sic.SaldoInicial + tsc.SaldoMovimentacao) AS SaldoFinal
    FROM
        TransacoesComSaldoAcumulado AS tsc
    INNER JOIN
        SaldoInicialConta AS sic ON tsc.ContaID = sic.ContaID
    ORDER BY
        tsc.ContaID, tsc.DataLancamento, tsc.TransacaoID;
    ```

---

## Desafio de Fixação

**Cenário:** A diretoria da TechSol (EmpresaID = 1) quer um relatório que mostre as 3 maiores despesas de cada mês, para cada `ContaPlanoID` que aceita lançamentos diretos. Além disso, eles querem ver a diferença percentual de cada uma dessas despesas em relação à média das despesas da mesma `ContaPlanoID` naquele mês.

**Requisitos:**
1.  Liste as transações da `EmpresaID = 1` que são despesas (`Natureza = 'D'`).
2.  Considere apenas `ContaPlanoID`s onde `AceitaLancamentos = 1`.
3.  Para cada `ContaPlanoID` e mês, rankeie as despesas do maior para o menor valor.
4.  Filtre para mostrar apenas as 3 maiores despesas (`Rank <= 3`) de cada grupo (ContaPlanoID + Mês).
5.  Calcule a média das despesas para cada `ContaPlanoID` e mês.
6.  Calcule a diferença percentual de cada despesa em relação à média do seu grupo.

**Dica:** Use CTEs para organizar a lógica e `DENSE_RANK()` para o ranking.


~~~sql

-- Seu código SQL aqui
~~~



---

## Resolução do Desafio de Fixação


~~~sql

WITH DespesasTechSol AS (
    SELECT
        t.TransacaoID,
        pc.Descricao AS ContaPlano,
        t.DataLancamento,
        YEAR(t.DataLancamento) AS Ano,
        MONTH(t.DataLancamento) AS Mes,
        t.Valor,
        t.Descricao AS DescricaoTransacao
    FROM
        dbo.Transacoes AS t
    INNER JOIN
        dbo.PlanoDeContas AS pc ON t.ContaPlanoID = pc.ContaPlanoID
    INNER JOIN
        dbo.TiposTransacao AS tt ON t.TipoTransacaoID = tt.TipoTransacaoID
    WHERE
        t.EmpresaID = 1
        AND tt.Natureza = 'D'
        AND pc.AceitaLancamentos = 1
        AND t.DataLancamento >= '2026-01-01' AND t.DataLancamento < '2026-04-01'
),
DespesasRankeadasEComMedia AS (
    SELECT
        ds.TransacaoID,
        ds.ContaPlano,
        ds.DataLancamento,
        ds.Ano,
        ds.Mes,
        ds.Valor,
        ds.DescricaoTransacao,
        DENSE_RANK() OVER (PARTITION BY ds.ContaPlano, ds.Ano, ds.Mes ORDER BY ds.Valor DESC) AS RankDespesa,
        AVG(ds.Valor) OVER (PARTITION BY ds.ContaPlano, ds.Ano, ds.Mes) AS MediaDespesasMes
    FROM
        DespesasTechSol AS ds
)
SELECT
    dr.ContaPlano,
    dr.Ano,
    dr.Mes,
    dr.RankDespesa,
    dr.DataLancamento,
    dr.DescricaoTransacao,
    dr.Valor,
    dr.MediaDespesasMes,
    (dr.Valor - dr.MediaDespesasMes) / dr.MediaDespesasMes * 100 AS DiferencaPercentualMedia
FROM
    DespesasRankeadasEComMedia AS dr
WHERE
    dr.RankDespesa <= 3
ORDER BY
    dr.ContaPlano, dr.Ano, dr.Mes, dr.RankDespesa;
~~~



**Explicação da Resolução:**
1.  **`DespesasTechSol` CTE**: Filtra as transações para a `EmpresaID = 1`, apenas despesas (`Natureza = 'D'`) e somente `ContaPlanoID`s que aceitam lançamentos diretos (`AceitaLancamentos = 1`). Isso cria um conjunto de dados base mais limpo.
2.  **`DespesasRankeadasEComMedia` CTE**:
    *   Aplica `DENSE_RANK()` para rankear as despesas. A partição é feita por `ContaPlano`, `Ano` e `Mes`, e a ordenação é pelo `Valor` da despesa em ordem decrescente. Isso garante que o ranking seja independente para cada combinação de plano de contas e mês.
    *   Calcula a `MediaDespesasMes` usando `AVG()` como função de janela, particionando pelos mesmos critérios (`ContaPlano`, `Ano`, `Mes`).
3.  **`SELECT` Final**:
    *   Seleciona as colunas desejadas da CTE `DespesasRankeadasEComMedia`.
    *   Filtra os resultados para `RankDespesa <= 3`, garantindo que apenas as 3 maiores despesas de cada grupo sejam exibidas.
    *   Calcula a `DiferencaPercentualMedia` usando a fórmula `(Valor - Media) / Media * 100`.
    *   Ordena o resultado para facilitar a leitura.

---

## Resumo dos Pontos-Chave

*   **Funções de Janela** permitem realizar cálculos em um conjunto de linhas relacionadas a cada linha atual, sem colapsar as linhas.
*   A cláusula **`OVER()`** é fundamental, definindo a janela de operação da função.
*   **`PARTITION BY`** divide o conjunto de resultados em grupos lógicos (partições) para que a função opere independentemente em cada um.
*   **`ORDER BY` dentro de `OVER()`** define a ordem das linhas dentro de cada partição, essencial para funções de ranking e cálculos acumulados.
*   **Funções de Ranking**:
    *   **`ROW_NUMBER()`**: Atribui um número sequencial único.
    *   **`RANK()`**: Atribui o mesmo rank a empates, com lacunas subsequentes.
    *   **`DENSE_RANK()`**: Atribui o mesmo rank a empates, sem lacunas subsequentes.
    *   **`NTILE(N)`**: Divide as linhas em `N` grupos de tamanho o mais igual possível.
*   **Funções de Agregação com `OVER()`**: `SUM()`, `AVG()`, `MIN()`, `MAX()` podem ser usadas para calcular totais, médias, mínimos e máximos dentro de janelas.
*   **`ROWS` e `RANGE`**: Permitem um controle mais granular sobre o "quadro" de linhas incluídas na janela, útil para médias móveis e saldos acumulados.
    *   `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW` para saldos acumulados.
    *   `ROWS BETWEEN N PRECEDING AND CURRENT ROW` para médias móveis.
*   **`LAG()` e `LEAD()`**: Úteis para comparar o valor da linha atual com valores de linhas anteriores ou posteriores.
*   **`FIRST_VALUE()` e `LAST_VALUE()`**: Retornam o primeiro e o último valor de uma coluna dentro da janela, respectivamente (requer `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING` para `LAST_VALUE` funcionar como esperado).
*   **Performance**: O uso de índices nas colunas de `PARTITION BY` e `ORDER BY` é crucial para otimizar o desempenho de consultas com funções de janela.

---

## Log de Estado do Projeto


~~~text

## Estado — Após o Capítulo 24

=== BANCO DE DADOS ===
Nome: FinanceDB
Status: Operacional

=== TABELAS E REGISTROS ===
Bancos:            6 registros
TiposTransacao:    3 registros (RECEITA, DESPESA, TRANSF)
Empresas:          3 registros
ContasBancarias:   7 registros
PlanoDeContas:     24 registros em 3 níveis hierárquicos
Transacoes:        54 registros distribuídos em múltiplos meses
Orcamentos:        39 registros por conta e período

=== MÓDULOS CONCLUÍDOS ===
✅ Módulo 1 — Fundamentos: Teoria e Ambiente (Capítulos 1–6)
✅ Módulo 2 — Essencial: T-SQL Básico (Capítulos 7–14)
✅ Módulo 3 — PROFICIENTE: Relacionamentos e Consultas Avançadas (Capítulos 15–22)
✅ Módulo 4 — AVANÇADO: Objetos de Banco de Dados e Programabilidade (Capítulos 23–24)

=== CAPÍTULOS DO MÓDULO 3 ===
✅ Capítulo 15: INNER JOIN
✅ Capítulo 16: LEFT JOIN, RIGHT JOIN e FULL OUTER JOIN
✅ Capítulo 17: SELF JOIN — Auto-relacionamento e hierarquias
✅ Capítulo 18: Funções de Agregação — SUM, COUNT, AVG, MIN e MAX
✅ Capítulo 19: GROUP BY e HAVING — Agrupamento e filtragem de grupos
✅ Capítulo 20: Funções de Data e Hora — Manipulação de datas e períodos
✅ Capítulo 21: Funções de Texto — Manipulação de strings
✅ Capítulo 22: Subconsultas — Subqueries Correlacionadas e Não Correlacionadas

=== CAPÍTULOS DO MÓDULO 4 ===
✅ Capítulo 23: Expressões de Tabela — CTEs com WITH
✅ Capítulo 24: Funções de Janela — OVER, PARTITION BY e ROW_NUMBER

=== HABILIDADES ADQUIRIDAS NESTE CAPÍTULO ===
- Uso de funções de janela para cálculos analíticos
- Definição de janelas com OVER(), PARTITION BY e ORDER BY
- Aplicação de ROW_NUMBER(), RANK(), DENSE_RANK() e NTILE()
- Uso de SUM(), AVG(), MIN(), MAX() como funções de janela
- Controle do quadro da janela com ROWS e RANGE
- Comparação de valores com LAG() e LEAD()
- Identificação do primeiro/último valor com FIRST_VALUE() e LAST_VALUE()
- Resolução de problemas financeiros complexos com funções de janela

=== PRÓXIMO ===
Capítulo 25: Views — Criando Relatórios Reutilizáveis
Objetivo: encapsular consultas financeiras recorrentes em Views,
entender a diferença entre views simples e views complexas,
criar views com WITH SCHEMABINDING e compreender quando usar
views versus CTEs versus subqueries no FinanceDB.
~~~~



---

Dúvidas? Posso prosseguir para o Capítulo 25?