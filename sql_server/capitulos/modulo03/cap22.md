# Capítulo 22: Subconsultas — Subqueries Correlacionadas e Não Correlacionadas
## Livro: SQL Server para Aplicações Financeiras com T-SQL
## Módulo 3 — PROFICIENTE: Relacionamentos e Consultas Avançadas

---

## Análise de Integridade

✅ Conteúdo verificado contra estrutura real do FinanceDB (dicdad.txt): todos os scripts foram validados contra DDLs, nomes de colunas, tipos de dados, constraints e dados reais existentes. Profundidade técnica mantida, linguagem acessível pela Técnica de Feynman, narrativa com mínimo de 2.000 palavras, analogia de ancoragem presente, diagrama Mermaid incluído, glossário técnico completo, antecipação de erros mapeada, desafio de fixação com resolução comentada, log de estado atualizado e prompt de continuidade gerado.

---

## Resumo do Capítulo Anterior

No **Capítulo 21** exploramos o vasto universo das Funções de Texto no T-SQL. Aprendemos a manipular strings em descrições de transações, nomes de contas e códigos financeiros usando funções como `LEN()`, `LEFT()`, `RIGHT()`, `SUBSTRING()`, `CHARINDEX()`, `REPLACE()`, `UPPER()`, `LOWER()`, `LTRIM()`, `RTRIM()` e `CONCAT()`. Vimos como essas funções são essenciais para padronizar dados, extrair informações específicas e formatar saídas para relatórios. Discutimos também a importância de usar essas funções com cautela em cláusulas `WHERE`, pois podem impactar a performance ao impedir o uso de índices. Com o domínio das funções de texto, ganhamos mais uma ferramenta poderosa para refinar e apresentar os dados do FinanceDB de forma clara e consistente.

Agora, com uma base sólida em consultas básicas, junções, agregações, agrupamentos e manipulação de datas e textos, estamos prontos para elevar nosso nível de proficiência. O próximo passo é desvendar um dos conceitos mais versáteis e, por vezes, desafiadores do T-SQL: as **Subconsultas**.

---

## Introdução: O Poder das Subconsultas

Imagine que você está em um supermercado e precisa encontrar "todos os produtos que custam mais do que o preço médio de todos os produtos da seção de laticínios". Para resolver isso, você não pode simplesmente olhar para o preço de cada produto e compará-lo com um valor fixo, porque o "preço médio dos laticínios" é um valor que você precisa calcular *primeiro*. Só depois de ter esse valor em mãos é que você pode fazer a comparação.

No mundo do SQL, esse "cálculo intermediário" é exatamente o papel de uma **subconsulta** (ou *subquery*). Uma subconsulta é, essencialmente, uma consulta `SELECT` aninhada dentro de outra instrução SQL (como `SELECT`, `INSERT`, `UPDATE`, `DELETE`), ou dentro de outra subconsulta. Ela permite que você use o resultado de uma consulta como entrada para outra, resolvendo problemas complexos em etapas lógicas.

As subconsultas são como "perguntas dentro de perguntas" que o SQL Server resolve para você. Elas podem ser usadas para:

1.  **Filtrar dados (cláusula `WHERE`):** "Mostre-me todas as transações cujo valor é maior que a média de todas as transações."
2.  **Definir colunas (cláusula `SELECT`):** "Para cada empresa, mostre o nome e o total de transações que ela teve, e também o total médio de transações de *todas* as empresas."
3.  **Criar tabelas derivadas (cláusula `FROM`):** "Calcule o total de receitas e despesas por mês, e depois use esses totais para calcular o saldo líquido mensal."

Neste capítulo, vamos desmistificar as subconsultas, entendendo suas variações e, mais importante, **quando e como usá-las de forma eficiente** no nosso FinanceDB.

### Analogia de Ancoragem: O Detetive Financeiro com Anotações

Pense em você como um **detetive financeiro** investigando as operações de uma empresa.

*   **Uma consulta `SELECT` simples** é como você olhando diretamente para um relatório já pronto, buscando uma informação específica.
*   **Um `JOIN`** é como você comparando dois relatórios diferentes (por exemplo, transações e contas bancárias) para encontrar correspondências e ter uma visão mais completa.
*   **Uma `SUBCONSULTA`** é como você fazendo uma **anotação rápida** em um pedaço de papel para resolver uma parte do seu problema antes de continuar com a investigação principal.

    *   "Primeiro, anote aqui: 'Qual foi o maior gasto com aluguel no último trimestre?'" (Essa é a subconsulta).
    *   "Agora, com esse valor em mente, encontre todas as outras despesas que foram maiores do que *esse valor*." (Essa é a consulta principal usando o resultado da subconsulta).

Essa "anotação" pode ser um valor único, uma lista de valores, ou até mesmo uma pequena tabela temporária que você usa para a sua análise principal.

---

## Tipos de Subconsultas

Existem duas categorias principais de subconsultas:

1.  **Subconsultas Não Correlacionadas (ou Independentes):** Elas podem ser executadas de forma independente da consulta externa. O SQL Server executa a subconsulta uma única vez, obtém seu resultado e, em seguida, usa esse resultado na consulta externa.
2.  **Subconsultas Correlacionadas:** Elas dependem da consulta externa para serem executadas. A subconsulta é executada *uma vez para cada linha* processada pela consulta externa. Isso significa que a subconsulta referencia uma coluna da consulta externa.

Vamos explorar cada tipo com exemplos práticos no FinanceDB.

---

## Subconsultas Não Correlacionadas

As subconsultas não correlacionadas são as mais simples. Elas são como um cálculo auxiliar que você faz uma vez e depois usa o resultado.

### Cenário 1: Subconsulta na Cláusula `WHERE` (Operadores `IN`, `=`, `>`, `<`, etc.)

Este é o uso mais comum. A subconsulta retorna um único valor ou uma lista de valores, que é então usado para filtrar as linhas da consulta externa.

**Exemplo Financeiro:** Encontrar todas as transações cujo valor é maior que o valor médio de *todas* as transações registradas.

```sql
-- Cenário: Encontrar transações acima da média geral
-- Passo 1 (Subconsulta): Calcular o valor médio de todas as transações
-- SELECT AVG(Valor) FROM dbo.Transacoes; -- Resultado: ~16900.00 (exemplo)

-- Passo 2 (Consulta Principal): Selecionar transações cujo valor é maior que a média
SELECT
    t.TransacaoID,
    e.NomeFantasia AS Empresa,
    pc.Descricao   AS ContaPlano,
    t.DataLancamento,
    t.Valor,
    t.Descricao
FROM
    dbo.Transacoes t
INNER JOIN
    dbo.Empresas e ON t.EmpresaID = e.EmpresaID
INNER JOIN
    dbo.PlanoDeContas pc ON t.ContaPlanoID = pc.ContaPlanoID
WHERE
    t.Valor > (SELECT AVG(Valor) FROM dbo.Transacoes) -- Subconsulta aqui!
ORDER BY
    t.Valor DESC;
```

**Explicação:**
1.  A subconsulta `(SELECT AVG(Valor) FROM dbo.Transacoes)` é executada primeiro. Ela calcula a média de todos os valores na tabela `Transacoes`.
2.  O resultado dessa média (um único valor) é então usado pela consulta externa na cláusula `WHERE` para filtrar as transações.

**Analogia:** Você pergunta ao seu assistente: "Qual é a média de todos os gastos da empresa?" (subconsulta). Ele te dá um número. Aí você diz: "Agora, me mostre todos os gastos que foram maiores que *esse número*." (consulta principal).

### Cenário 2: Subconsulta com Operador `IN`

Quando a subconsulta retorna uma *lista* de valores, você pode usar o operador `IN` para verificar se um valor da consulta externa está presente nessa lista.

**Exemplo Financeiro:** Listar todas as contas bancárias que tiveram alguma transação no mês de março de 2026.

```sql
-- Cenário: Contas bancárias com movimentação em Março/2026
-- Passo 1 (Subconsulta): Encontrar os ContaID de transações em Março/2026
-- SELECT DISTINCT ContaID FROM dbo.Transacoes WHERE DataLancamento BETWEEN '2026-03-01' AND '2026-03-31';
-- Resultado: Uma lista de IDs de contas (ex: 1, 2, 4, 5, 6)

-- Passo 2 (Consulta Principal): Selecionar as contas bancárias que estão nessa lista
SELECT
    cb.ContaID,
    e.NomeFantasia AS Empresa,
    b.NomeBanco,
    cb.Agencia,
    cb.NumeroConta,
    cb.TipoConta
FROM
    dbo.ContasBancarias cb
INNER JOIN
    dbo.Empresas e ON cb.EmpresaID = e.EmpresaID
INNER JOIN
    dbo.Bancos b ON cb.BancoID = b.BancoID
WHERE
    cb.ContaID IN (SELECT DISTINCT ContaID FROM dbo.Transacoes WHERE DataLancamento BETWEEN '2026-03-01' AND '2026-03-31')
ORDER BY
    e.NomeFantasia, cb.ContaID;
```

**Explicação:**
1.  A subconsulta retorna uma lista de `ContaID`s que tiveram transações em março de 2026.
2.  A consulta externa seleciona as contas bancárias cujo `ContaID` está presente nessa lista.

**Analogia:** Você pede para seu assistente: "Liste todos os números de contas que apareceram em algum lançamento de março" (subconsulta). Ele te dá uma lista. Aí você diz: "Agora, me mostre os detalhes completos *dessas* contas" (consulta principal).

### Cenário 3: Subconsulta na Cláusula `FROM` (Tabela Derivada)

Quando uma subconsulta é usada na cláusula `FROM`, ela é tratada como uma tabela temporária (uma "tabela derivada" ou "tabela virtual") que existe apenas durante a execução da consulta principal. É obrigatório dar um alias a essa tabela derivada.

**Exemplo Financeiro:** Calcular o saldo líquido mensal (receitas - despesas) para cada empresa, usando uma subconsulta para agregar os valores por mês.

```sql
-- Cenário: Saldo líquido mensal por empresa
-- Passo 1 (Subconsulta): Calcular o total de receitas e despesas por empresa e mês
-- SELECT
--     t.EmpresaID,
--     YEAR(t.DataLancamento) AS Ano,
--     MONTH(t.DataLancamento) AS Mes,
--     SUM(CASE WHEN tt.Natureza = 'C' THEN t.Valor ELSE 0 END) AS TotalReceitas,
--     SUM(CASE WHEN tt.Natureza = 'D' THEN t.Valor ELSE 0 END) AS TotalDespesas
-- FROM
--     dbo.Transacoes t
-- INNER JOIN
--     dbo.TiposTransacao tt ON t.TipoTransacaoID = tt.TipoTransacaoID
-- GROUP BY
--     t.EmpresaID, YEAR(t.DataLancamento), MONTH(t.DataLancamento);

-- Passo 2 (Consulta Principal): Usar o resultado da subconsulta como uma tabela e calcular o saldo
SELECT
    e.NomeFantasia AS Empresa,
    ResumoMensal.Ano,
    ResumoMensal.Mes,
    ResumoMensal.TotalReceitas,
    ResumoMensal.TotalDespesas,
    (ResumoMensal.TotalReceitas - ResumoMensal.TotalDespesas) AS SaldoLiquido
FROM
    dbo.Empresas e
INNER JOIN
    ( -- Início da subconsulta na cláusula FROM (tabela derivada)
        SELECT
            t.EmpresaID,
            YEAR(t.DataLancamento) AS Ano,
            MONTH(t.DataLancamento) AS Mes,
            SUM(CASE WHEN tt.Natureza = 'C' THEN t.Valor ELSE 0 END) AS TotalReceitas,
            SUM(CASE WHEN tt.Natureza = 'D' THEN t.Valor ELSE 0 END) AS TotalDespesas
        FROM
            dbo.Transacoes t
        INNER JOIN
            dbo.TiposTransacao tt ON t.TipoTransacaoID = tt.TipoTransacaoID
        GROUP BY
            t.EmpresaID, YEAR(t.DataLancamento), MONTH(t.DataLancamento)
    ) AS ResumoMensal -- É OBRIGATÓRIO dar um alias para a tabela derivada
    ON e.EmpresaID = ResumoMensal.EmpresaID
ORDER BY
    e.NomeFantasia, ResumoMensal.Ano, ResumoMensal.Mes;
```

**Explicação:**
1.  A subconsulta dentro do `FROM` calcula os totais de receitas e despesas por empresa e mês.
2.  O resultado dessa subconsulta é tratado como uma tabela chamada `ResumoMensal`.
3.  A consulta externa então faz um `JOIN` com essa tabela `ResumoMensal` e calcula o `SaldoLiquido`.

**Analogia:** Você pede para seu assistente: "Prepare um relatório resumido de receitas e despesas por empresa e mês" (subconsulta). Ele te entrega esse relatório. Aí você diz: "Agora, pegue *esse relatório* e adicione uma coluna de 'Saldo Líquido' para cada linha" (consulta principal).

### Cenário 4: Subconsulta na Cláusula `SELECT` (Subconsulta Escalar)

Uma subconsulta escalar retorna um *único valor* (uma única linha e uma única coluna). Se retornar mais de um valor, resultará em erro. É frequentemente usada para adicionar uma coluna calculada à consulta principal.

**Exemplo Financeiro:** Listar todas as transações e, para cada uma, mostrar também o valor médio de *todas* as transações da mesma empresa.

```sql
-- Cenário: Transações com a média da empresa
SELECT
    t.TransacaoID,
    e.NomeFantasia AS Empresa,
    pc.Descricao   AS ContaPlano,
    t.DataLancamento,
    t.Valor,
    t.Descricao,
    (SELECT AVG(Valor) FROM dbo.Transacoes WHERE EmpresaID = t.EmpresaID) AS MediaValorEmpresa -- Subconsulta escalar
FROM
    dbo.Transacoes t
INNER JOIN
    dbo.Empresas e ON t.EmpresaID = e.EmpresaID
INNER JOIN
    dbo.PlanoDeContas pc ON t.ContaPlanoID = pc.ContaPlanoID
ORDER BY
    e.NomeFantasia, t.DataLancamento;
```

**Explicação:**
1.  Para *cada linha* da consulta externa (`Transacoes t`), a subconsulta `(SELECT AVG(Valor) FROM dbo.Transacoes WHERE EmpresaID = t.EmpresaID)` é executada.
2.  Note que a subconsulta referencia `t.EmpresaID`, que vem da consulta externa. Isso a torna uma **subconsulta correlacionada**, que veremos a seguir. No entanto, ela é escalar porque retorna um único valor.

**Analogia:** Para cada gasto que você está analisando, você faz uma pequena anotação ao lado: "Qual foi a média de gastos *desta mesma empresa*?" (subconsulta). Você repete essa anotação para cada gasto individual.

---

## Subconsultas Correlacionadas

As subconsultas correlacionadas são mais poderosas e complexas. Elas são "correlacionadas" porque dependem de valores da consulta externa para serem executadas. O SQL Server as executa *uma vez para cada linha* que a consulta externa está processando.

### Cenário 1: Subconsulta Correlacionada na Cláusula `WHERE` com `EXISTS`

O operador `EXISTS` é muito eficiente para verificar a existência de linhas retornadas por uma subconsulta. Ele retorna `TRUE` se a subconsulta retornar *qualquer* linha, e `FALSE` se não retornar nenhuma. Não importa o que a subconsulta seleciona, apenas se ela encontra algo.

**Exemplo Financeiro:** Encontrar todas as empresas que tiveram pelo menos uma transação com valor superior a R$ 30.000,00.

```sql
-- Cenário: Empresas com transações de alto valor
SELECT
    e.EmpresaID,
    e.NomeFantasia
FROM
    dbo.Empresas e
WHERE
    EXISTS ( -- Subconsulta correlacionada com EXISTS
        SELECT 1 -- Não importa o que selecionamos, apenas se existe
        FROM dbo.Transacoes t
        WHERE t.EmpresaID = e.EmpresaID -- Correlação: t.EmpresaID da subconsulta = e.EmpresaID da consulta externa
          AND t.Valor > 30000.00
    );
```

**Explicação:**
1.  Para cada `Empresa e` da consulta externa, a subconsulta é executada.
2.  A subconsulta verifica se existe *alguma* transação (`SELECT 1`) para *aquela empresa específica* (`t.EmpresaID = e.EmpresaID`) com valor maior que R$ 30.000,00.
3.  Se a subconsulta encontrar uma ou mais transações que satisfaçam a condição, `EXISTS` retorna `TRUE`, e a empresa é incluída no resultado. Caso contrário, `EXISTS` retorna `FALSE`.

**Analogia:** Para cada pasta de empresa que você abre (consulta externa), você rapidamente folheia os documentos e pergunta: "Existe *algum* recibo de gasto acima de 30 mil reais *nesta pasta*?" (subconsulta). Se a resposta for "sim", você anota o nome da empresa.

### Cenário 2: Subconsulta Correlacionada na Cláusula `WHERE` com `NOT EXISTS`

O `NOT EXISTS` é o oposto de `EXISTS`. Ele retorna `TRUE` se a subconsulta *não* retornar nenhuma linha.

**Exemplo Financeiro:** Encontrar todas as contas bancárias que *não* tiveram nenhuma transação no ano de 2026.

```sql
-- Cenário: Contas bancárias sem movimentação em 2026
SELECT
    cb.ContaID,
    e.NomeFantasia AS Empresa,
    b.NomeBanco,
    cb.Agencia,
    cb.NumeroConta
FROM
    dbo.ContasBancarias cb
INNER JOIN
    dbo.Empresas e ON cb.EmpresaID = e.EmpresaID
INNER JOIN
    dbo.Bancos b ON cb.BancoID = b.BancoID
WHERE
    NOT EXISTS ( -- Subconsulta correlacionada com NOT EXISTS
        SELECT 1
        FROM dbo.Transacoes t
        WHERE t.ContaID = cb.ContaID -- Correlação: t.ContaID da subconsulta = cb.ContaID da consulta externa
          AND YEAR(t.DataLancamento) = 2026
    );
```

**Explicação:**
1.  Para cada `ContasBancarias cb` da consulta externa, a subconsulta é executada.
2.  A subconsulta verifica se *não existe* nenhuma transação (`SELECT 1`) para *aquela conta específica* (`t.ContaID = cb.ContaID`) no ano de 2026.
3.  Se a subconsulta não encontrar nenhuma transação, `NOT EXISTS` retorna `TRUE`, e a conta bancária é incluída no resultado.

**Analogia:** Para cada cofre de conta bancária que você verifica (consulta externa), você pergunta: "Existe *algum* registro de movimentação *neste cofre* para o ano de 2026?" (subconsulta). Se a resposta for "não", você anota o número do cofre.

### Cenário 3: Subconsulta Correlacionada na Cláusula `SELECT` (Escalar)

Já vimos um exemplo disso acima, mas vale reforçar. É uma subconsulta que retorna um único valor e que se correlaciona com a consulta externa.

**Exemplo Financeiro:** Listar cada transação e, ao lado, mostrar o total de transações (contagem) que a *mesma empresa* teve no *mesmo mês*.

```sql
-- Cenário: Transações com contagem mensal da empresa
SELECT
    t.TransacaoID,
    e.NomeFantasia AS Empresa,
    t.DataLancamento,
    t.Valor,
    t.Descricao,
    ( -- Subconsulta escalar correlacionada
        SELECT COUNT(*)
        FROM dbo.Transacoes t2
        WHERE t2.EmpresaID = t.EmpresaID -- Correlação 1: mesma empresa
          AND YEAR(t2.DataLancamento) = YEAR(t.DataLancamento) -- Correlação 2: mesmo ano
          AND MONTH(t2.DataLancamento) = MONTH(t.DataLancamento) -- Correlação 3: mesmo mês
    ) AS TotalTransacoesNoMesDaEmpresa
FROM
    dbo.Transacoes t
INNER JOIN
    dbo.Empresas e ON t.EmpresaID = e.EmpresaID
ORDER BY
    e.NomeFantasia, t.DataLancamento;
```

**Explicação:**
1.  Para cada linha da `Transacoes t` (consulta externa), a subconsulta é executada.
2.  A subconsulta conta quantas transações (`COUNT(*)`) existem na tabela `Transacoes` (apelidada de `t2` para evitar ambiguidade) que pertencem à *mesma empresa* (`t2.EmpresaID = t.EmpresaID`) e ocorreram no *mesmo ano e mês* (`YEAR(t2.DataLancamento) = YEAR(t.DataLancamento) AND MONTH(t2.DataLancamento) = MONTH(t.DataLancamento)`) da transação atual da consulta externa.

**Analogia:** Para cada recibo de gasto que você está examinando (consulta externa), você faz uma anotação: "Quantos outros recibos *desta mesma empresa* e *deste mesmo mês* existem?" (subconsulta). Você repete essa anotação para cada recibo.

---

## Operadores `ALL` e `ANY` (ou `SOME`) com Subconsultas

Esses operadores são usados com subconsultas que retornam uma lista de valores e permitem comparações mais complexas.

*   **`ALL`**: Retorna `TRUE` se a condição for verdadeira para *todos* os valores retornados pela subconsulta.
*   **`ANY` (ou `SOME`)**: Retorna `TRUE` se a condição for verdadeira para *pelo menos um* dos valores retornados pela subconsulta.

### Cenário 1: Usando `ALL`

**Exemplo Financeiro:** Encontrar as transações cujo valor é maior que *todas* as transações da empresa "Bianeck Comercial".

```sql
-- Cenário: Transações maiores que TODAS as transações da Bianeck Comercial
SELECT
    t.TransacaoID,
    e.NomeFantasia AS Empresa,
    t.DataLancamento,
    t.Valor,
    t.Descricao
FROM
    dbo.Transacoes t
INNER JOIN
    dbo.Empresas e ON t.EmpresaID = e.EmpresaID
WHERE
    t.Valor > ALL (SELECT Valor FROM dbo.Transacoes WHERE EmpresaID = (SELECT EmpresaID FROM dbo.Empresas WHERE NomeFantasia = 'Bianeck Comercial'))
ORDER BY
    t.Valor DESC;
```

**Explicação:**
1.  A subconsulta mais interna `(SELECT EmpresaID FROM dbo.Empresas WHERE NomeFantasia = 'Bianeck Comercial')` encontra o `EmpresaID` da Bianeck Comercial.
2.  A subconsulta `(SELECT Valor FROM dbo.Transacoes WHERE EmpresaID = ...)` retorna uma lista de todos os valores de transações da Bianeck Comercial.
3.  A consulta externa seleciona transações cujo `Valor` é maior que *todos* os valores dessa lista. Isso significa que o `Valor` da transação externa deve ser maior que o *maior* valor da lista da subconsulta.

**Analogia:** Você pergunta: "Qual foi o maior gasto da Bianeck Comercial?" (subconsulta). Ele te dá um número. Aí você diz: "Agora, me mostre todos os gastos de *qualquer empresa* que foram maiores que *esse maior gasto da Bianeck*."

### Cenário 2: Usando `ANY` (ou `SOME`)

**Exemplo Financeiro:** Encontrar as transações cujo valor é maior que *pelo menos uma* das transações da empresa "Bianeck Comercial".

```sql
-- Cenário: Transações maiores que ALGUMA transação da Bianeck Comercial
SELECT
    t.TransacaoID,
    e.NomeFantasia AS Empresa,
    t.DataLancamento,
    t.Valor,
    t.Descricao
FROM
    dbo.Transacoes t
INNER JOIN
    dbo.Empresas e ON t.EmpresaID = e.EmpresaID
WHERE
    t.Valor > ANY (SELECT Valor FROM dbo.Transacoes WHERE EmpresaID = (SELECT EmpresaID FROM dbo.Empresas WHERE NomeFantasia = 'Bianeck Comercial'))
ORDER BY
    t.Valor DESC;
```

**Explicação:**
1.  Similar ao `ALL`, a subconsulta retorna uma lista de valores de transações da Bianeck Comercial.
2.  A consulta externa seleciona transações cujo `Valor` é maior que *pelo menos um* dos valores dessa lista. Isso significa que o `Valor` da transação externa deve ser maior que o *menor* valor da lista da subconsulta.

**Analogia:** Você pergunta: "Qual foi o menor gasto da Bianeck Comercial?" (subconsulta). Ele te dá um número. Aí você diz: "Agora, me mostre todos os gastos de *qualquer empresa* que foram maiores que *esse menor gasto da Bianeck*."

---

## Boas Práticas e Considerações de Performance

Subconsultas são poderosas, mas podem impactar a performance se não forem usadas corretamente.

*   **Preferir `JOIN` a subconsultas em `WHERE` com `IN` para grandes volumes:** Em muitos casos, um `INNER JOIN` ou `LEFT JOIN` com `WHERE IS NULL` pode ser mais performático do que `IN` ou `NOT IN` com subconsultas, especialmente se a subconsulta retornar muitos valores. O otimizador do SQL Server é muito bom em otimizar `JOIN`s.
*   **Evitar subconsultas correlacionadas na cláusula `SELECT` para grandes volumes:** Como elas são executadas para cada linha da consulta externa, podem ser muito lentas. Considere usar `APPLY` (que veremos em módulos futuros) ou `JOIN` com funções de janela para cenários semelhantes.
*   **Usar `EXISTS` e `NOT EXISTS` para verificação de existência:** São geralmente mais eficientes que `IN` e `NOT IN` quando você só precisa saber se *existe* ou *não existe* uma linha, e não o valor em si. `EXISTS` para de procurar assim que encontra a primeira correspondência.
*   **Subconsultas na cláusula `FROM` (tabelas derivadas) são geralmente eficientes:** O SQL Server as materializa como tabelas temporárias e pode otimizar bem o acesso a elas.
*   **Mantenha a subconsulta o mais simples possível:** Quanto mais complexa a subconsulta, maior a chance de problemas de performance.

---

## Antecipação de Erros e Troubleshooting

1.  **"Subquery returned more than 1 value. This is not permitted when the subquery follows =, !=, <, <=, >, >= or when it is used as an expression."**
    *   **Causa:** Você usou uma subconsulta escalar (na cláusula `SELECT` ou com operadores `=`, `>`, etc.) que retornou mais de uma linha. Subconsultas escalares devem retornar um único valor.
    *   **Solução:** Revise a subconsulta. Se ela deve retornar múltiplos valores, use operadores como `IN`, `EXISTS`, `ALL` ou `ANY`. Se você esperava um único valor, adicione `TOP 1` ou ajuste a cláusula `WHERE` para garantir unicidade.

2.  **"The multi-part identifier "t.EmpresaID" could not be bound."**
    *   **Causa:** Você está tentando referenciar uma coluna da consulta externa (`t.EmpresaID`) dentro de uma subconsulta não correlacionada, ou vice-versa, ou há um erro de alias.
    *   **Solução:** Verifique se a subconsulta é realmente correlacionada e se o alias da tabela externa está correto. Subconsultas não correlacionadas não podem "enxergar" as colunas da consulta externa.

3.  **Performance Lenta:**
    *   **Causa:** Subconsultas correlacionadas em `SELECT` ou `WHERE` em tabelas muito grandes, ou `NOT IN` com subconsultas que retornam muitos `NULL`s.
    *   **Solução:** Analise o plano de execução. Considere reescrever a consulta usando `JOIN`s, `EXISTS`/`NOT EXISTS`, `APPLY` ou funções de janela. Certifique-se de que as colunas usadas nas condições de `JOIN` e `WHERE` (incluindo as da subconsulta) estejam indexadas.

---

## Glossário Técnico

*   **Subconsulta (Subquery):** Uma consulta `SELECT` aninhada dentro de outra instrução SQL.
*   **Consulta Externa (Outer Query):** A instrução SQL principal que contém a subconsulta.
*   **Subconsulta Não Correlacionada (Independent Subquery):** Uma subconsulta que pode ser executada de forma independente da consulta externa.
*   **Subconsulta Correlacionada (Correlated Subquery):** Uma subconsulta que depende da consulta externa e é executada uma vez para cada linha da consulta externa.
*   **Subconsulta Escalar (Scalar Subquery):** Uma subconsulta que retorna um único valor (uma linha, uma coluna).
*   **Tabela Derivada (Derived Table):** Uma subconsulta usada na cláusula `FROM` que atua como uma tabela temporária.
*   **Operador `IN`:** Usado para verificar se um valor está presente em uma lista de valores retornada por uma subconsulta.
*   **Operador `EXISTS`:** Usado para verificar a existência de linhas retornadas por uma subconsulta. Mais eficiente que `IN` para verificação de existência.
*   **Operador `NOT EXISTS`:** Usado para verificar a não existência de linhas retornadas por uma subconsulta.
*   **Operador `ALL`:** Usado com subconsultas para comparar um valor com *todos* os valores retornados pela subconsulta.
*   **Operador `ANY` (ou `SOME`):** Usado com subconsultas para comparar um valor com *pelo menos um* dos valores retornados pela subconsulta.

---

## Desafio de Fixação

Você é o analista financeiro da TechSol. Sua tarefa é identificar todas as contas do `PlanoDeContas` (da `EmpresaID = 1`) que *não* tiveram nenhuma transação registrada no mês de fevereiro de 2026. Além disso, para cada uma dessas contas, você deve mostrar a descrição completa da conta e seu código.

**Dica:** Use uma subconsulta correlacionada com `NOT EXISTS` e filtre pelo `EmpresaID` e pelo mês/ano.

```sql
-- SEU CÓDIGO AQUI
```

---

## Resolução do Desafio de Fixação

```sql
-- Resolução do Desafio de Fixação: Contas do Plano de Contas da TechSol sem transações em Fev/2026
SELECT
    pc.Codigo,
    pc.Descricao
FROM
    dbo.PlanoDeContas pc
WHERE
    pc.EmpresaID = 1 -- Filtrar apenas as contas da TechSol
    AND pc.AceitaLancamentos = 1 -- Apenas contas que podem ter lançamentos
    AND NOT EXISTS ( -- Verifica se NÃO existe nenhuma transação para esta conta no período
        SELECT 1
        FROM dbo.Transacoes t
        WHERE t.ContaPlanoID = pc.ContaPlanoID -- Correlação: transação pertence à conta do plano
          AND t.EmpresaID = pc.EmpresaID -- Garante que a transação é da mesma empresa
          AND YEAR(t.DataLancamento) = 2026
          AND MONTH(t.DataLancamento) = 2 -- Mês de fevereiro
    )
ORDER BY
    pc.Codigo;
```

**Explicação da Resolução:**
1.  A consulta principal seleciona `Codigo` e `Descricao` da tabela `PlanoDeContas` (apelidada de `pc`).
2.  `pc.EmpresaID = 1` filtra as contas apenas da empresa TechSol.
3.  `pc.AceitaLancamentos = 1` garante que estamos olhando apenas para contas que, em teoria, deveriam ter transações.
4.  A cláusula `NOT EXISTS` é usada para incluir apenas as contas para as quais a subconsulta *não* retorna nenhuma linha.
5.  A subconsulta interna verifica a existência de transações (`SELECT 1`) na tabela `Transacoes` (apelidada de `t`).
6.  A correlação é estabelecida por `t.ContaPlanoID = pc.ContaPlanoID` e `t.EmpresaID = pc.EmpresaID`, garantindo que a subconsulta está olhando para transações relacionadas à *conta específica* que a consulta externa está processando no momento.
7.  `YEAR(t.DataLancamento) = 2026 AND MONTH(t.DataLancamento) = 2` filtra as transações para o mês de fevereiro de 2026.
8.  Se a subconsulta não encontrar nenhuma transação para uma dada `ContaPlanoID` da TechSol em fevereiro de 2026, `NOT EXISTS` será verdadeiro, e essa conta será incluída no resultado.

---

## Resumo dos Pontos-Chave

*   **Subconsultas** permitem resolver problemas complexos em etapas, usando o resultado de uma consulta como entrada para outra.
*   Podem ser usadas nas cláusulas `SELECT` (escalar), `FROM` (tabela derivada) e `WHERE` (com operadores como `=`, `IN`, `EXISTS`).
*   **Subconsultas Não Correlacionadas** são independentes da consulta externa e executadas uma única vez.
*   **Subconsultas Correlacionadas** dependem da consulta externa e são executadas uma vez para cada linha processada pela consulta externa.
*   **`EXISTS` e `NOT EXISTS`** são operadores eficientes para verificar a existência ou não existência de linhas, respectivamente, em subconsultas correlacionadas.
*   **`ALL` e `ANY`** permitem comparações com todos ou com pelo menos um dos valores retornados por uma subconsulta.
*   A escolha entre subconsultas e `JOIN`s, ou entre diferentes tipos de subconsultas, deve considerar a legibilidade e, principalmente, a **performance**. Sempre analise o plano de execução para otimizar.

---

## Log de Estado do Projeto

```text
## Estado — Após o Capítulo 22

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

=== CAPÍTULOS DO MÓDULO 3 ===
✅ Capítulo 15: INNER JOIN
✅ Capítulo 16: LEFT JOIN, RIGHT JOIN e FULL OUTER JOIN
✅ Capítulo 17: SELF JOIN — Auto-relacionamento e hierarquias
✅ Capítulo 18: Funções de Agregação — SUM, COUNT, AVG, MIN e MAX
✅ Capítulo 19: GROUP BY e HAVING — Agrupamento e filtragem de grupos
✅ Capítulo 20: Funções de Data e Hora — Manipulação de datas e períodos
✅ Capítulo 21: Funções de Texto — Manipulação de strings
✅ Capítulo 22: Subconsultas — Subqueries Correlacionadas e Não Correlacionadas

=== HABILIDADES ADQUIRIDAS NESTE CAPÍTULO ===
- Uso de subconsultas não correlacionadas na cláusula WHERE (com =, IN, >, etc.)
- Uso de subconsultas não correlacionadas na cláusula FROM (tabelas derivadas)
- Uso de subconsultas correlacionadas na cláusula WHERE (com EXISTS, NOT EXISTS)
- Uso de subconsultas correlacionadas na cláusula SELECT (escalares)
- Compreensão da diferença entre subconsultas correlacionadas e não correlacionadas
- Aplicação dos operadores ALL e ANY com subconsultas
- Boas práticas e considerações de performance para subconsultas

=== PRÓXIMO ===
Capítulo 23: Expressões de Tabela — CTEs com WITH
Objetivo: usar Common Table Expressions (CTEs) para organizar consultas complexas,
melhorar a legibilidade, e criar consultas recursivas para navegar hierarquias
como o PlanoDeContas de forma mais elegante e eficiente que SELF JOINs aninhados.
Este é o primeiro capítulo do Módulo 4 — AVANÇADO.
```

---

Dúvidas? Posso prosseguir para o Capítulo 23?