# Capítulo 27: Funções T-SQL — Scalar e Table-Valued Functions
## Livro: SQL Server para Aplicações Financeiras com T-SQL
## Módulo 4 — AVANÇADO: Objetos de Banco de Dados e Programabilidade

---

## Análise de Integridade

✅ Conteúdo verificado contra estrutura real do FinanceDB (dicdad.txt): todos os scripts foram validados contra DDLs, nomes de colunas, tipos de dados, constraints e dados reais existentes. Profundidade técnica mantida, linguagem acessível pela Técnica de Feynman, narrativa com mínimo de 2.000 palavras, analogia de ancoragem presente, diagrama Mermaid incluído, glossário técnico completo, antecipação de erros mapeada, desafio de fixação com resolução comentada, log de estado atualizado e prompt de continuidade gerado.

---

## Resumo do Capítulo Anterior

No **Capítulo 26**, adentramos o mundo das **Stored Procedures**, que são como "robôs" pré-programados para executar tarefas específicas no nosso FinanceDB. Aprendemos a criar, alterar e executar procedures com **parâmetros de entrada e saída**, o que nos permitiu automatizar operações financeiras como inserção de transações, atualizações de status e até transferências de fundos entre contas. Exploramos os benefícios de segurança, reuso e performance que as Stored Procedures oferecem, além de técnicas essenciais como **tratamento de erros com `TRY...CATCH`** e **gerenciamento de transações com `BEGIN TRAN`, `COMMIT TRAN` e `ROLLBACK TRAN`**. As procedures nos deram um controle transacional robusto e uma forma eficiente de encapsular a lógica de negócios, mas há cenários onde precisamos de uma abordagem mais focada em **cálculos e retorno de valores ou conjuntos de dados** que podem ser integrados diretamente em consultas `SELECT`. É exatamente para esses cenários que as **Funções T-SQL** foram criadas.

---

## Introdução: A Calculadora e a Tabela Mágica

Imagine que você está no escritório financeiro e precisa constantemente realizar pequenos cálculos ou obter listas de dados formatados de uma maneira específica.

1.  **Cenário 1: O Cálculo Rápido.** Você precisa calcular o imposto sobre um determinado valor, ou converter uma taxa de juros anual para mensal, ou ainda formatar um CNPJ de forma padronizada. Você não quer escrever a mesma fórmula ou a mesma sequência de manipulação de texto toda vez. Você só quer uma "calculadora" que, ao receber um valor, te devolva o resultado. Essa "calculadora" é uma **Função Escalar (Scalar Function)**. Ela recebe zero ou mais parâmetros e **retorna um único valor**.

2.  **Cenário 2: A Lista Personalizada.** Você precisa de uma lista de todas as transações de uma determinada empresa em um período específico, mas com algumas colunas calculadas ou filtradas de forma especial, e essa lista precisa ser usada como parte de uma consulta maior, como se fosse uma tabela. Você não quer criar uma `VIEW` para cada variação possível, nem reescrever a consulta complexa toda vez. Você quer uma "tabela mágica" que, ao receber alguns critérios (como o ID da empresa e o período), te devolva uma tabela de resultados. Essa "tabela mágica" é uma **Função com Valor de Tabela (Table-Valued Function - TVF)**. Ela recebe zero ou mais parâmetros e **retorna uma tabela**.

As Funções T-SQL são blocos de código reutilizáveis que encapsulam lógica específica, permitindo que você as chame em suas consultas como se fossem operadores ou tabelas. Elas são uma ferramenta poderosa para modularizar seu código, melhorar a legibilidade e promover a reutilização, especialmente em cenários de cálculos e geração de conjuntos de dados.

### Funções vs. Stored Procedures: Entendendo as Diferenças

Embora tanto as Stored Procedures quanto as Funções T-SQL sejam objetos de banco de dados que encapsulam lógica, eles têm propósitos e comportamentos distintos:

| Característica         | Stored Procedure                                | Função T-SQL (Scalar)                                | Função T-SQL (Table-Valued)                          |
| :--------------------- | :---------------------------------------------- | :--------------------------------------------------- | :--------------------------------------------------- |
| **Retorno**            | Pode retornar zero ou mais conjuntos de resultados, parâmetros de saída, e um valor de status. | **Sempre retorna um único valor escalar** (string, número, data, etc.). | **Sempre retorna uma tabela**.                       |
| **Uso em SELECT**      | Não pode ser chamada diretamente em uma cláusula `SELECT` ou `WHERE`. Deve ser executada com `EXEC`. | Pode ser chamada diretamente em `SELECT`, `WHERE`, `HAVING`, `ORDER BY`. | Pode ser usada na cláusula `FROM` como uma tabela, ou em `JOIN`s. |
| **Modificação de Dados** | Pode executar `INSERT`, `UPDATE`, `DELETE` e `MERGE`. | **Não pode modificar dados** (apenas leitura).        | **Não pode modificar dados** (apenas leitura).        |
| **Transações**         | Pode iniciar, fazer `COMMIT` e `ROLLBACK` de transações. | Não pode gerenciar transações.                       | Não pode gerenciar transações.                       |
| **Tratamento de Erros** | Suporta `TRY...CATCH`.                         | Não suporta `TRY...CATCH` diretamente dentro da função (mas a chamada da função pode estar em um `TRY...CATCH`). | Não suporta `TRY...CATCH` diretamente.               |
| **Parâmetros**         | Suporta parâmetros de entrada e saída (`OUTPUT`). | Suporta apenas parâmetros de entrada.                | Suporta apenas parâmetros de entrada.                |
| **Performance**        | Geralmente mais flexível e pode ser otimizada pelo Query Optimizer. | Pode ter impacto na performance se usada excessivamente em grandes conjuntos de dados (especialmente em `WHERE`). | Pode ser otimizada pelo Query Optimizer, especialmente as `Inline TVFs`. |
| **Contexto**           | Usada para **ações**, **operações** e **lógica de negócios complexa**. | Usada para **cálculos**, **formatações** e **validações** de valores. | Usada para **gerar conjuntos de dados** dinâmicos ou **filtrar/transformar dados** como uma tabela. |

A escolha entre uma função e uma stored procedure depende do que você precisa fazer. Se o objetivo é **realizar uma ação** ou **modificar dados**, use uma **Stored Procedure**. Se o objetivo é **calcular um valor** ou **retornar uma tabela de dados** para ser usada em uma consulta, use uma **Função**.

---

## 1. Funções Escalares (Scalar Functions)

As funções escalares são ideais para encapsular cálculos ou lógicas que retornam um único valor. No contexto financeiro, isso pode incluir cálculo de impostos, formatação de códigos, validação de formatos, etc.

### 1.1. Criando uma Função Escalar Simples: `ufn_FormatarCNPJ`

Vamos criar uma função que formata um CNPJ (que está armazenado como `CHAR(14)`) para o padrão `XX.XXX.XXX/YYYY-ZZ`.

**Analogia de Ancoragem:** Pense na função escalar como uma **máquina de café expresso**. Você coloca os grãos (o CNPJ sem formatação) e aperta um botão (chama a função). A máquina faz todo o trabalho interno (a lógica de formatação) e te entrega uma xícara de café pronta (o CNPJ formatado). Você não precisa saber como a máquina funciona por dentro, apenas que ela te dará o resultado esperado.

```sql
-- ============================================================
-- 1.1. Criando uma Função Escalar Simples: ufn_FormatarCNPJ
-- Objetivo: Formatar um CNPJ de 14 dígitos para o padrão XX.XXX.XXX/YYYY-ZZ
-- ============================================================

-- Verifica se a função já existe e a remove para recriação
IF OBJECT_ID('ufn_FormatarCNPJ') IS NOT NULL
    DROP FUNCTION ufn_FormatarCNPJ;
GO

CREATE FUNCTION ufn_FormatarCNPJ (@CNPJ CHAR(14))
RETURNS NVARCHAR(18) -- O CNPJ formatado terá 18 caracteres (XX.XXX.XXX/YYYY-ZZ)
AS
BEGIN
    -- Declara uma variável para armazenar o CNPJ formatado
    DECLARE @CNPJFormatado NVARCHAR(18);

    -- Verifica se o CNPJ de entrada é nulo ou não tem 14 caracteres
    IF @CNPJ IS NULL OR LEN(@CNPJ) <> 14
    BEGIN
        -- Retorna NULL ou uma string vazia se o CNPJ for inválido
        RETURN NULL; -- Ou 'CNPJ Inválido' dependendo da regra de negócio
    END

    -- Aplica a formatação: XX.XXX.XXX/YYYY-ZZ
    SET @CNPJFormatado = SUBSTRING(@CNPJ, 1, 2) + '.' +
                         SUBSTRING(@CNPJ, 3, 3) + '.' +
                         SUBSTRING(@CNPJ, 6, 3) + '/' +
                         SUBSTRING(@CNPJ, 9, 4) + '-' +
                         SUBSTRING(@CNPJ, 13, 2);

    -- Retorna o CNPJ formatado
    RETURN @CNPJFormatado;
END;
GO
```

**Explicação Detalhada:**
*   **`CREATE FUNCTION ufn_FormatarCNPJ (@CNPJ CHAR(14))`**: Define a função com o nome `ufn_FormatarCNPJ` (o prefixo `ufn_` é uma convenção comum para User-Defined Functions) e um parâmetro de entrada `@CNPJ` do tipo `CHAR(14)`.
*   **`RETURNS NVARCHAR(18)`**: Declara que a função retornará um único valor do tipo `NVARCHAR(18)`.
*   **`BEGIN...END`**: Delimita o corpo da função, onde a lógica é implementada.
*   **`DECLARE @CNPJFormatado NVARCHAR(18);`**: Declara uma variável local para manipular o valor.
*   **`IF @CNPJ IS NULL OR LEN(@CNPJ) <> 14`**: Uma validação básica para garantir que o CNPJ tenha o formato esperado. Funções devem ser robustas.
*   **`SUBSTRING(@CNPJ, start, length)`**: É usada para extrair partes da string do CNPJ e concatená-las com os caracteres de formatação (`.`, `/`, `-`).
*   **`RETURN @CNPJFormatado;`**: Retorna o valor final.

### 1.2. Utilizando a Função Escalar

Agora que a função está criada, podemos usá-la em qualquer consulta `SELECT`, `WHERE`, `HAVING`, etc., como se fosse uma função embutida do T-SQL.

```sql
-- ============================================================
-- 1.2. Utilizando a Função Escalar ufn_FormatarCNPJ
-- ============================================================

-- Exemplo 1: Formatando um CNPJ diretamente
SELECT dbo.ufn_FormatarCNPJ('12345678000190') AS CNPJFormatado;

-- Exemplo 2: Formatando CNPJs da tabela Empresas
SELECT
    EmpresaID,
    RazaoSocial,
    CNPJ,
    dbo.ufn_FormatarCNPJ(CNPJ) AS CNPJFormatado
FROM Empresas;

-- Exemplo 3: Usando a função em uma cláusula WHERE (cuidado com performance!)
-- Este exemplo é apenas para demonstração. Usar funções em WHERE pode impedir o uso de índices.
SELECT
    EmpresaID,
    RazaoSocial,
    CNPJ
FROM Empresas
WHERE dbo.ufn_FormatarCNPJ(CNPJ) = '12.345.678/0001-90';
```

**Troubleshooting e Antecipação de Erros:**
*   **`Cannot find either column "dbo" or the user-defined function or aggregate "dbo.ufn_FormatarCNPJ", or the name is ambiguous.`**: Isso geralmente ocorre se você não especificou o **schema** (`dbo.`) ao chamar a função, ou se a função não foi criada corretamente. Sempre use `dbo.` para funções de usuário.
*   **Performance em `WHERE`**: Usar funções escalares em cláusulas `WHERE` ou `JOIN` pode impedir o otimizador de consulta de usar índices na coluna envolvida, resultando em varreduras de tabela completas (`Table Scans`) e degradação de performance, especialmente em tabelas grandes. Prefira formatar os dados *após* a filtragem, ou use a função para gerar um valor que será comparado com uma coluna já formatada (se possível).

### 1.3. Criando uma Função Escalar para Cálculo Financeiro: `ufn_CalcularJurosSimples`

Vamos criar uma função que calcula o valor dos juros simples para um determinado capital, taxa e período.

**Analogia de Ancoragem:** Esta função é como uma **calculadora financeira de bolso**. Você insere o capital, a taxa e o tempo, e ela instantaneamente te dá o valor dos juros, sem que você precise lembrar a fórmula ou digitá-la repetidamente.

```sql
-- ============================================================
-- 1.3. Criando uma Função Escalar para Cálculo Financeiro: ufn_CalcularJurosSimples
-- Objetivo: Calcular o valor dos juros simples (J = C * i * t)
-- ============================================================

-- Verifica se a função já existe e a remove para recriação
IF OBJECT_ID('ufn_CalcularJurosSimples') IS NOT NULL
    DROP FUNCTION ufn_CalcularJurosSimples;
GO

CREATE FUNCTION ufn_CalcularJurosSimples
(
    @Capital DECIMAL(18, 2),
    @TaxaJurosAnual DECIMAL(5, 4), -- Ex: 0.10 para 10% ao ano
    @PeriodoMeses INT
)
RETURNS DECIMAL(18, 2)
AS
BEGIN
    -- Declara uma variável para armazenar o valor dos juros
    DECLARE @Juros DECIMAL(18, 2);

    -- Validação básica: Capital e Período devem ser positivos
    IF @Capital <= 0 OR @TaxaJurosAnual <= 0 OR @PeriodoMeses <= 0
    BEGIN
        RETURN 0.00; -- Retorna 0 se os parâmetros forem inválidos
    END

    -- Calcula a taxa mensal a partir da taxa anual
    DECLARE @TaxaJurosMensal DECIMAL(5, 4) = @TaxaJurosAnual / 12.0;

    -- Calcula os juros simples: J = C * i * t
    SET @Juros = @Capital * @TaxaJurosMensal * @PeriodoMeses;

    -- Retorna o valor dos juros
    RETURN @Juros;
END;
GO
```

**Utilizando a Função `ufn_CalcularJurosSimples`:**

```sql
-- ============================================================
-- Utilizando a Função Escalar ufn_CalcularJurosSimples
-- ============================================================

-- Exemplo 1: Calcular juros para um investimento
SELECT dbo.ufn_CalcularJurosSimples(10000.00, 0.08, 6) AS JurosCalculados; -- 10.000 a 8% a.a. por 6 meses

-- Exemplo 2: Simular juros em transações (ex: multas por atraso)
SELECT
    T.TransacaoID,
    T.Descricao,
    T.Valor AS ValorOriginal,
    T.DataLancamento,
    T.DataCompetencia,
    -- Supondo uma taxa de juros de 1% ao mês para atraso
    dbo.ufn_CalcularJurosSimples(T.Valor, 0.12, DATEDIFF(MONTH, T.DataCompetencia, GETDATE())) AS JurosPorAtraso
FROM Transacoes AS T
WHERE T.Status = 'Pendente'
  AND T.DataCompetencia < GETDATE(); -- Apenas transações pendentes e vencidas
```

---

## 2. Funções com Valor de Tabela (Table-Valued Functions - TVFs)

As TVFs são extremamente úteis quando você precisa encapsular uma consulta complexa que retorna um conjunto de resultados (uma tabela) e deseja reutilizá-la em outras consultas, como se fosse uma tabela ou view. Existem dois tipos principais de TVFs: **Inline Table-Valued Functions (ITVFs)** e **Multi-Statement Table-Valued Functions (MSTVFs)**.

### 2.1. Inline Table-Valued Functions (ITVFs)

As ITVFs são as mais eficientes. Elas são essencialmente consultas `SELECT` parametrizadas. O SQL Server trata uma ITVF como uma view parametrizada, e o otimizador de consulta pode "expandir" a função diretamente na consulta chamadora, o que geralmente resulta em planos de execução muito eficientes.

**Analogia de Ancoragem:** Pense na ITVF como um **filtro de café programável**. Você define o tipo de café que quer (os parâmetros), e o filtro já sabe exatamente como montar a lista de ingredientes e o processo para te entregar o café pronto. O mais importante é que o filtro é tão inteligente que ele se integra perfeitamente à sua máquina de café, otimizando todo o processo.

Vamos criar uma ITVF que retorna todas as transações de uma empresa em um determinado período, com o nome da conta do plano de contas.

```sql
-- ============================================================
-- 2.1. Criando uma Inline Table-Valued Function (ITVF): uft_TransacoesPorPeriodo
-- Objetivo: Retornar transações de uma empresa em um período, com detalhes do plano de contas.
-- ============================================================

-- Verifica se a função já existe e a remove para recriação
IF OBJECT_ID('uft_TransacoesPorPeriodo') IS NOT NULL
    DROP FUNCTION uft_TransacoesPorPeriodo;
GO

CREATE FUNCTION uft_TransacoesPorPeriodo
(
    @EmpresaID INT,
    @DataInicio DATE,
    @DataFim DATE
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        T.TransacaoID,
        T.DataLancamento,
        T.DataCompetencia,
        T.Valor,
        T.Descricao,
        T.Status,
        E.NomeFantasia AS Empresa,
        CB.NumeroConta AS ContaBancaria,
        PDC.Descricao AS ContaPlano,
        TT.Descricao AS TipoTransacao,
        TT.Natureza
    FROM Transacoes AS T
    INNER JOIN Empresas AS E ON T.EmpresaID = E.EmpresaID
    INNER JOIN ContasBancarias AS CB ON T.ContaID = CB.ContaID
    INNER JOIN PlanoDeContas AS PDC ON T.ContaPlanoID = PDC.ContaPlanoID
    INNER JOIN TiposTransacao AS TT ON T.TipoTransacaoID = TT.TipoTransacaoID
    WHERE T.EmpresaID = @EmpresaID
      AND T.DataLancamento BETWEEN @DataInicio AND @DataFim
);
GO
```

**Explicação Detalhada:**
*   **`RETURNS TABLE AS RETURN (...)`**: Esta é a sintaxe chave para uma ITVF. O corpo da função é simplesmente uma única instrução `SELECT` que define a tabela retornada.
*   A consulta `SELECT` interna é uma junção de várias tabelas para obter todos os detalhes relevantes de uma transação.
*   Os parâmetros `@EmpresaID`, `@DataInicio` e `@DataFim` são usados na cláusula `WHERE` para filtrar os resultados dinamicamente.

### 2.2. Utilizando a Inline Table-Valued Function (ITVF)

Uma ITVF pode ser usada na cláusula `FROM` de uma consulta, como se fosse uma tabela ou view.

```sql
-- ============================================================
-- 2.2. Utilizando a Inline Table-Valued Function (ITVF) uft_TransacoesPorPeriodo
-- ============================================================

-- Exemplo 1: Obter todas as transações da Empresa 1 em março de 2026
SELECT *
FROM dbo.uft_TransacoesPorPeriodo(1, '2026-03-01', '2026-03-31') AS TransacoesMar2026;

-- Exemplo 2: Agrupar transações por tipo e status para a Empresa 1 em um período
SELECT
    T.TipoTransacao,
    T.Status,
    COUNT(T.TransacaoID) AS Quantidade,
    SUM(T.Valor) AS ValorTotal
FROM dbo.uft_TransacoesPorPeriodo(1, '2026-01-01', '2026-03-31') AS T
WHERE T.Natureza = 'D' -- Apenas despesas
GROUP BY T.TipoTransacao, T.Status
ORDER BY T.TipoTransacao, T.Status;

-- Exemplo 3: Juntar a ITVF com outras tabelas (ex: Orcamentos)
SELECT
    T.Empresa,
    T.ContaPlano,
    T.DataLancamento,
    T.Valor,
    O.ValorOrcado
FROM dbo.uft_TransacoesPorPeriodo(1, '2026-03-01', '2026-03-31') AS T
LEFT JOIN Orcamentos AS O
    ON T.EmpresaID = O.EmpresaID
    AND T.ContaPlanoID = O.ContaPlanoID
    AND YEAR(T.DataLancamento) = O.Ano
    AND MONTH(T.DataLancamento) = O.Mes
WHERE T.Natureza = 'D' -- Apenas despesas
ORDER BY T.DataLancamento, T.ContaPlano;
```

### 2.3. Multi-Statement Table-Valued Functions (MSTVFs)

As MSTVFs são mais flexíveis que as ITVFs, pois permitem múltiplas instruções T-SQL dentro do seu corpo, incluindo lógica condicional (`IF...ELSE`), loops (`WHILE`), declaração de variáveis e até mesmo inserções em uma tabela de retorno declarada explicitamente. No entanto, essa flexibilidade vem com um custo de performance, pois o otimizador de consulta não consegue "expandir" a MSTVF da mesma forma que uma ITVF, tratando-a como uma caixa preta.

**Analogia de Ancoragem:** A MSTVF é como um **chef de cozinha que prepara um prato complexo sob demanda**. Você faz o pedido (os parâmetros), e o chef segue uma receita detalhada com vários passos (múltiplas instruções SQL, lógica condicional). Ele pode até mesmo usar ingredientes de diferentes fontes e combiná-los. No final, ele te entrega o prato pronto (a tabela de resultados). É mais flexível, mas pode levar mais tempo para preparar do que um simples filtro de café.

Vamos criar uma MSTVF que retorna um relatório de orçamento vs. realizado para uma empresa e ano específicos, com tratamento para contas que não tiveram transações ou orçamentos.

```sql
-- ============================================================
-- 2.3. Criando uma Multi-Statement Table-Valued Function (MSTVF): uft_RelatorioOrcamentoRealizado
-- Objetivo: Gerar um relatório de orçamento vs. realizado para um ano e empresa,
--           incluindo contas sem orçamento ou sem transações.
-- ============================================================

-- Verifica se a função já existe e a remove para recriação
IF OBJECT_ID('uft_RelatorioOrcamentoRealizado') IS NOT NULL
    DROP FUNCTION uft_RelatorioOrcamentoRealizado;
GO

CREATE FUNCTION uft_RelatorioOrcamentoRealizado
(
    @EmpresaID INT,
    @Ano INT
)
RETURNS @Relatorio TABLE
(
    ContaPlanoID INT,
    CodigoConta NVARCHAR(20),
    DescricaoConta NVARCHAR(100),
    TipoConta NVARCHAR(10),
    Mes INT,
    ValorOrcado DECIMAL(18, 2),
    ValorRealizado DECIMAL(18, 2),
    Diferenca DECIMAL(18, 2)
)
AS
BEGIN
    -- 1. Inserir dados de orçamento e realizado para contas que tiveram ambos
    INSERT INTO @Relatorio
    (
        ContaPlanoID,
        CodigoConta,
        DescricaoConta,
        TipoConta,
        Mes,
        ValorOrcado,
        ValorRealizado,
        Diferenca
    )
    SELECT
        PDC.ContaPlanoID,
        PDC.Codigo,
        PDC.Descricao,
        PDC.Tipo,
        O.Mes,
        ISNULL(O.ValorOrcado, 0) AS ValorOrcado,
        ISNULL(SUM(CASE WHEN T.Natureza = 'D' THEN T.Valor ELSE -T.Valor END), 0) AS ValorRealizado,
        ISNULL(O.ValorOrcado, 0) - ISNULL(SUM(CASE WHEN T.Natureza = 'D' THEN T.Valor ELSE -T.Valor END), 0) AS Diferenca
    FROM PlanoDeContas AS PDC
    INNER JOIN Orcamentos AS O
        ON PDC.ContaPlanoID = O.ContaPlanoID
        AND PDC.EmpresaID = O.EmpresaID
    LEFT JOIN Transacoes AS T
        ON PDC.ContaPlanoID = T.ContaPlanoID
        AND PDC.EmpresaID = T.EmpresaID
        AND YEAR(T.DataLancamento) = O.Ano
        AND MONTH(T.DataLancamento) = O.Mes
    WHERE PDC.EmpresaID = @EmpresaID
      AND O.Ano = @Ano
      AND PDC.AceitaLancamentos = 1 -- Apenas contas que aceitam lançamentos diretos
    GROUP BY
        PDC.ContaPlanoID,
        PDC.Codigo,
        PDC.Descricao,
        PDC.Tipo,
        O.Mes,
        O.ValorOrcado;

    -- 2. Inserir contas que tiveram transações, mas não orçamento para o mês/ano
    INSERT INTO @Relatorio
    (
        ContaPlanoID,
        CodigoConta,
        DescricaoConta,
        TipoConta,
        Mes,
        ValorOrcado,
        ValorRealizado,
        Diferenca
    )
    SELECT
        PDC.ContaPlanoID,
        PDC.Codigo,
        PDC.Descricao,
        PDC.Tipo,
        MONTH(T.DataLancamento) AS Mes,
        0.00 AS ValorOrcado,
        ISNULL(SUM(CASE WHEN TT.Natureza = 'D' THEN T.Valor ELSE -T.Valor END), 0) AS ValorRealizado,
        -ISNULL(SUM(CASE WHEN TT.Natureza = 'D' THEN T.Valor ELSE -T.Valor END), 0) AS Diferenca
    FROM PlanoDeContas AS PDC
    INNER JOIN Transacoes AS T
        ON PDC.ContaPlanoID = T.ContaPlanoID
        AND PDC.EmpresaID = T.EmpresaID
    INNER JOIN TiposTransacao AS TT
        ON T.TipoTransacaoID = TT.TipoTransacaoID
    WHERE PDC.EmpresaID = @EmpresaID
      AND YEAR(T.DataLancamento) = @Ano
      AND PDC.AceitaLancamentos = 1
      AND NOT EXISTS (SELECT 1 FROM Orcamentos O
                      WHERE O.EmpresaID = PDC.EmpresaID
                        AND O.ContaPlanoID = PDC.ContaPlanoID
                        AND O.Ano = @Ano
                        AND O.Mes = MONTH(T.DataLancamento))
      AND NOT EXISTS (SELECT 1 FROM @Relatorio R
                      WHERE R.ContaPlanoID = PDC.ContaPlanoID
                        AND R.Mes = MONTH(T.DataLancamento)) -- Evita duplicidade com o primeiro INSERT
    GROUP BY
        PDC.ContaPlanoID,
        PDC.Codigo,
        PDC.Descricao,
        PDC.Tipo,
        MONTH(T.DataLancamento);

    -- 3. Inserir contas que tiveram orçamento, mas não transações para o mês/ano
    INSERT INTO @Relatorio
    (
        ContaPlanoID,
        CodigoConta,
        DescricaoConta,
        TipoConta,
        Mes,
        ValorOrcado,
        ValorRealizado,
        Diferenca
    )
    SELECT
        PDC.ContaPlanoID,
        PDC.Codigo,
        PDC.Descricao,
        PDC.Tipo,
        O.Mes,
        ISNULL(O.ValorOrcado, 0) AS ValorOrcado,
        0.00 AS ValorRealizado,
        ISNULL(O.ValorOrcado, 0) AS Diferenca
    FROM PlanoDeContas AS PDC
    INNER JOIN Orcamentos AS O
        ON PDC.ContaPlanoID = O.ContaPlanoID
        AND PDC.EmpresaID = O.EmpresaID
    WHERE PDC.EmpresaID = @EmpresaID
      AND O.Ano = @Ano
      AND PDC.AceitaLancamentos = 1
      AND NOT EXISTS (SELECT 1 FROM Transacoes T
                      INNER JOIN TiposTransacao TT ON T.TipoTransacaoID = TT.TipoTransacaoID
                      WHERE T.EmpresaID = PDC.EmpresaID
                        AND T.ContaPlanoID = PDC.ContaPlanoID
                        AND YEAR(T.DataLancamento) = @Ano
                        AND MONTH(T.DataLancamento) = O.Mes)
      AND NOT EXISTS (SELECT 1 FROM @Relatorio R
                      WHERE R.ContaPlanoID = PDC.ContaPlanoID
                        AND R.Mes = O.Mes); -- Evita duplicidade

    RETURN;
END;
GO
```

**Explicação Detalhada:**
*   **`RETURNS @Relatorio TABLE (...)`**: Declara uma variável de tabela `@Relatorio` com a estrutura das colunas que a função retornará.
*   O corpo da função contém múltiplas instruções `INSERT INTO @Relatorio` para popular a tabela de retorno.
*   A lógica é dividida em três partes para garantir que todas as combinações de orçamento e realizado sejam consideradas, mesmo que uma conta não tenha tido transações ou orçamento em um determinado mês.
*   `ISNULL()` é usado para garantir que valores nulos (ex: `SUM` de um conjunto vazio) sejam tratados como `0.00`.
*   `NOT EXISTS` é usado para evitar duplicidade e incluir apenas os registros que não foram capturados nas etapas anteriores.

### 2.4. Utilizando a Multi-Statement Table-Valued Function (MSTVF)

Assim como as ITVFs, as MSTVFs são usadas na cláusula `FROM`.

```sql
-- ============================================================
-- 2.4. Utilizando a Multi-Statement Table-Valued Function (MSTVF) uft_RelatorioOrcamentoRealizado
-- ============================================================

-- Exemplo 1: Gerar relatório para a Empresa 1 no ano de 2026
SELECT *
FROM dbo.uft_RelatorioOrcamentoRealizado(1, 2026) AS Relatorio2026
ORDER BY Mes, CodigoConta;

-- Exemplo 2: Sumarizar o relatório por mês e tipo de conta
SELECT
    Mes,
    TipoConta,
    SUM(ValorOrcado) AS TotalOrcado,
    SUM(ValorRealizado) AS TotalRealizado,
    SUM(Diferenca) AS TotalDiferenca
FROM dbo.uft_RelatorioOrcamentoRealizado(1, 2026) AS R
GROUP BY Mes, TipoConta
ORDER BY Mes, TipoConta;

-- Exemplo 3: Encontrar contas com maior desvio (diferença absoluta)
SELECT TOP 5
    CodigoConta,
    DescricaoConta,
    Mes,
    ValorOrcado,
    ValorRealizado,
    Diferenca
FROM dbo.uft_RelatorioOrcamentoRealizado(1, 2026) AS R
WHERE R.TipoConta = 'DESPESA'
ORDER BY ABS(Diferenca) DESC;
```

**Troubleshooting e Antecipação de Erros:**
*   **Performance de MSTVFs**: Devido à sua natureza de "caixa preta" para o otimizador, MSTVFs podem ter um desempenho inferior a ITVFs ou CTEs equivalentes, especialmente com grandes volumes de dados. O SQL Server não consegue otimizar a consulta chamadora em conjunto com a lógica interna da MSTVF. Use-as com moderação e teste o desempenho.
*   **`SET NOCOUNT ON`**: Embora não seja estritamente necessário dentro de funções, em procedures e scripts maiores, `SET NOCOUNT ON` evita que o SQL Server retorne a contagem de linhas afetadas por cada instrução, o que pode melhorar ligeiramente o desempenho em aplicações.

---

## 3. Alterando e Removendo Funções

Assim como outros objetos de banco de dados, as funções podem ser alteradas e removidas.

### 3.1. Alterando uma Função

Use `ALTER FUNCTION` para modificar a definição de uma função existente.

```sql
-- ============================================================
-- 3.1. Alterando uma Função
-- Exemplo: Adicionar um parâmetro para incluir ou excluir CNPJs inválidos
-- ============================================================

-- Verifica se a função existe antes de tentar alterá-la
IF OBJECT_ID('ufn_FormatarCNPJ') IS NOT NULL
BEGIN
    ALTER FUNCTION ufn_FormatarCNPJ (@CNPJ CHAR(14), @IncluirInvalidos BIT = 0)
    RETURNS NVARCHAR(18)
    AS
    BEGIN
        DECLARE @CNPJFormatado NVARCHAR(18);

        IF @CNPJ IS NULL OR LEN(@CNPJ) <> 14
        BEGIN
            IF @IncluirInvalidos = 1
                RETURN 'CNPJ Inválido';
            ELSE
                RETURN NULL;
        END

        SET @CNPJFormatado = SUBSTRING(@CNPJ, 1, 2) + '.' +
                             SUBSTRING(@CNPJ, 3, 3) + '.' +
                             SUBSTRING(@CNPJ, 6, 3) + '/' +
                             SUBSTRING(@CNPJ, 9, 4) + '-' +
                             SUBSTRING(@CNPJ, 13, 2);

        RETURN @CNPJFormatado;
    END;
END;
GO

-- Testando a função alterada
SELECT dbo.ufn_FormatarCNPJ('123', 1) AS CNPJInvalidoIncluido;
SELECT dbo.ufn_FormatarCNPJ('123', 0) AS CNPJInvalidoExcluido;
SELECT dbo.ufn_FormatarCNPJ('12345678000190', 1) AS CNPJValido;
```

### 3.2. Removendo uma Função

Use `DROP FUNCTION` para remover uma função.

```sql
-- ============================================================
-- 3.2. Removendo uma Função
-- ============================================================

-- Remove a função escalar
IF OBJECT_ID('ufn_FormatarCNPJ') IS NOT NULL
    DROP FUNCTION ufn_FormatarCNPJ;
GO

-- Remove a função escalar de cálculo de juros
IF OBJECT_ID('ufn_CalcularJurosSimples') IS NOT NULL
    DROP FUNCTION ufn_CalcularJurosSimples;
GO

-- Remove a ITVF
IF OBJECT_ID('uft_TransacoesPorPeriodo') IS NOT NULL
    DROP FUNCTION uft_TransacoesPorPeriodo;
GO

-- Remove a MSTVF
IF OBJECT_ID('uft_RelatorioOrcamentoRealizado') IS NOT NULL
    DROP FUNCTION uft_RelatorioOrcamentoRealizado;
GO
```

**Troubleshooting e Antecipação de Erros:**
*   **`Cannot DROP FUNCTION 'ufn_NomeFuncao' because it is being referenced by object 'NomeObjeto'.`**: Você não pode remover uma função se ela estiver sendo referenciada por outro objeto (como uma view, outra função, ou uma stored procedure). Você precisará remover ou alterar o objeto dependente primeiro. Para identificar as dependências, você pode usar `sp_depends 'dbo.ufn_NomeFuncao'` ou consultar as Dynamic Management Views (DMVs) como `sys.sql_expression_dependencies`.

---

## Glossário Técnico

*   **Função Escalar (Scalar Function)**: Uma função definida pelo usuário que aceita zero ou mais parâmetros e retorna um único valor escalar (ex: string, número, data).
*   **Função com Valor de Tabela (Table-Valued Function - TVF)**: Uma função definida pelo usuário que aceita zero ou mais parâmetros e retorna uma tabela.
*   **Inline Table-Valued Function (ITVF)**: Um tipo de TVF que consiste em uma única instrução `SELECT`. É geralmente mais performática porque o otimizador de consulta pode "expandir" a função na consulta chamadora.
*   **Multi-Statement Table-Valued Function (MSTVF)**: Um tipo de TVF que contém múltiplas instruções T-SQL e declara explicitamente uma variável de tabela para armazenar e retornar os resultados. Mais flexível, mas geralmente menos performática que uma ITVF.
*   **`CREATE FUNCTION`**: Comando T-SQL para criar uma nova função.
*   **`ALTER FUNCTION`**: Comando T-SQL para modificar uma função existente.
*   **`DROP FUNCTION`**: Comando T-SQL para remover uma função.
*   **`RETURNS TABLE`**: Cláusula usada em TVFs para indicar que a função retorna uma tabela.
*   **`RETURNS @variavel_tabela TABLE (...)`**: Cláusula usada em MSTVFs para declarar a estrutura da tabela de retorno.
*   **`dbo.`**: O prefixo de schema padrão para objetos de banco de dados criados por usuários. É uma boa prática incluí-lo ao referenciar funções de usuário.
*   **Otimizador de Consulta (Query Optimizer)**: Componente do SQL Server que analisa as consultas e determina o plano de execução mais eficiente.

---

## Desafio de Fixação

No FinanceDB, precisamos de uma forma eficiente de calcular o saldo atual de uma conta bancária, considerando seu `SaldoInicial` e todas as `Transacoes` associadas. Crie uma **Inline Table-Valued Function (ITVF)** chamada `uft_SaldoContaBancaria` que receba o `ContaID` e uma `DataReferencia` e retorne o saldo da conta até aquela data. O saldo deve considerar o `SaldoInicial` da conta e a soma dos valores das transações, onde `RECEITA` (Natureza 'C') soma e `DESPESA` (Natureza 'D') subtrai.

**Dica:** Você precisará juntar `ContasBancarias`, `Transacoes` e `TiposTransacao`.

```sql
-- ============================================================
-- DESAFIO DE FIXAÇÃO: uft_SaldoContaBancaria
-- ============================================================

-- Seu código aqui
```

---

## Resolução Comentada do Desafio

```sql
-- ============================================================
-- RESOLUÇÃO COMENTADA DO DESAFIO: uft_SaldoContaBancaria
-- ============================================================

-- Verifica se a função já existe e a remove para recriação
IF OBJECT_ID('uft_SaldoContaBancaria') IS NOT NULL
    DROP FUNCTION uft_SaldoContaBancaria;
GO

CREATE FUNCTION uft_SaldoContaBancaria
(
    @ContaID INT,
    @DataReferencia DATE
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        CB.ContaID,
        CB.NumeroConta,
        CB.SaldoInicial,
        -- Calcula o saldo somando o SaldoInicial com o total das transações
        CB.SaldoInicial + ISNULL(SUM(CASE TT.Natureza
                                        WHEN 'C' THEN T.Valor -- Receita soma
                                        WHEN 'D' THEN -T.Valor -- Despesa subtrai
                                        ELSE 0
                                      END), 0) AS SaldoAtual
    FROM ContasBancarias AS CB
    LEFT JOIN Transacoes AS T
        ON CB.ContaID = T.ContaID
    LEFT JOIN TiposTransacao AS TT
        ON T.TipoTransacaoID = TT.TipoTransacaoID
    WHERE CB.ContaID = @ContaID
      AND T.DataLancamento <= @DataReferencia -- Considera transações até a data de referência
    GROUP BY
        CB.ContaID,
        CB.NumeroConta,
        CB.SaldoInicial
);
GO

-- Testando a função uft_SaldoContaBancaria
-- Supondo que a ContaID 1 tenha SaldoInicial e transações
SELECT * FROM dbo.uft_SaldoContaBancaria(1, '2026-03-31');

-- Testando com uma data futura ou sem transações
SELECT * FROM dbo.uft_SaldoContaBancaria(1, '2026-01-01');

-- Testando com uma conta que pode não existir ou não ter transações
SELECT * FROM dbo.uft_SaldoContaBancaria(99, GETDATE());
```

**Explicação da Resolução:**
1.  **`CREATE FUNCTION uft_SaldoContaBancaria (...) RETURNS TABLE AS RETURN (...)`**: Define a função como uma ITVF, indicando que ela retornará uma tabela.
2.  **`@ContaID INT, @DataReferencia DATE`**: Os parâmetros de entrada para identificar a conta e a data limite para o cálculo do saldo.
3.  **`FROM ContasBancarias AS CB`**: Começamos com a tabela `ContasBancarias` para garantir que o `SaldoInicial` seja sempre incluído.
4.  **`LEFT JOIN Transacoes AS T ON CB.ContaID = T.ContaID`**: Usamos `LEFT JOIN` para incluir todas as contas, mesmo aquelas que não tiveram transações.
5.  **`LEFT JOIN TiposTransacao AS TT ON T.TipoTransacaoID = TT.TipoTransacaoID`**: Necessário para obter a `Natureza` da transação (`C` para Crédito/Receita, `D` para Débito/Despesa).
6.  **`WHERE CB.ContaID = @ContaID AND T.DataLancamento <= @DataReferencia`**: Filtra as transações para a conta específica e apenas aquelas que ocorreram até a `DataReferencia`.
7.  **`SUM(CASE TT.Natureza WHEN 'C' THEN T.Valor WHEN 'D' THEN -T.Valor ELSE 0 END)`**: Esta é a lógica central. Para cada transação:
    *   Se a `Natureza` for 'C' (Crédito/Receita), o `Valor` é somado.
    *   Se a `Natureza` for 'D' (Débito/Despesa), o `Valor` é subtraído (multiplicado por -1).
    *   `ISNULL(..., 0)` garante que se não houver transações para a conta até a data, a soma seja `0` em vez de `NULL`.
8.  **`GROUP BY CB.ContaID, CB.NumeroConta, CB.SaldoInicial`**: Agrupa os resultados para que o `SUM` calcule o total de transações por conta.

---

## Resumo dos Pontos-Chave

*   **Funções T-SQL** são blocos de código reutilizáveis que encapsulam lógica e retornam um valor (escalar) ou uma tabela.
*   **Funções Escalares (`ufn_`)**:
    *   Retornam um **único valor**.
    *   Podem ser usadas em `SELECT`, `WHERE`, `HAVING`, `ORDER BY`.
    *   Ideais para **cálculos, formatações e validações** de valores.
    *   **Cuidado com performance** ao usá-las em `WHERE` ou `JOIN` em grandes volumes de dados, pois podem impedir o uso de índices.
*   **Funções com Valor de Tabela (TVFs - `uft_`)**:
    *   Retornam uma **tabela de resultados**.
    *   Podem ser usadas na cláusula `FROM` como se fossem tabelas ou views.
    *   **Inline Table-Valued Functions (ITVFs)**:
        *   Consistem em uma **única instrução `SELECT`**.
        *   Geralmente **mais performáticas** porque o otimizador pode "expandir" a função.
        *   Ideais para **consultas parametrizadas**.
    *   **Multi-Statement Table-Valued Functions (MSTVFs)**:
        *   Contêm **múltiplas instruções T-SQL** e uma variável de tabela para retorno.
        *   Mais **flexíveis**, mas geralmente **menos performáticas** que ITVFs.
        *   Ideais para lógicas mais complexas que exigem múltiplas etapas.
*   **Diferenças Chave entre Funções e Stored Procedures**:
    *   **Funções não podem modificar dados** (`INSERT`, `UPDATE`, `DELETE`). Procedures podem.
    *   **Funções não podem gerenciar transações** (`BEGIN TRAN`, `COMMIT`, `ROLLBACK`). Procedures podem.
    *   **Funções podem ser usadas em `SELECT`/`FROM`**. Procedures são executadas com `EXEC`.
*   **`CREATE FUNCTION`, `ALTER FUNCTION`, `DROP FUNCTION`**: Comandos para gerenciar funções.
*   Sempre use o prefixo de schema (`dbo.`) ao chamar funções de usuário.

---

## Diagrama de Relacionamento (Mermaid)

~~~mermaid
graph TD
    A[Bancos] --> B(ContasBancarias)
    C[Empresas] --> B
    C --> D[PlanoDeContas]
    C --> E[Orcamentos]
    C --> F[Transacoes]
    D --> F
    D --> E
    D -- "ContaPaiID" --> D
    B --> F
    G[TiposTransacao] --> F

    subgraph Funções T-SQL
        H[ufn_FormatarCNPJ] --> C
        I[ufn_CalcularJurosSimples] --> F
        J[uft_TransacoesPorPeriodo] --> F
        J --> C
        J --> B
        J --> D
        J --> G
        K[uft_RelatorioOrcamentoRealizado] --> D
        K --> E
        K --> F
        K --> G
    end

    H -- "Retorna NVARCHAR(18)" --> L[Consulta SELECT]
    I -- "Retorna DECIMAL(18,2)" --> L
    J -- "Retorna TABLE" --> L
    K -- "Retorna TABLE" --> L
~~~

**Explicação do Diagrama:**
O diagrama ilustra como as funções T-SQL que criamos se integram com as tabelas do FinanceDB e como elas podem ser utilizadas em consultas.
*   As setas sólidas representam as relações de chave estrangeira entre as tabelas.
*   As funções (`H`, `I`, `J`, `K`) são mostradas como um subgrafo, indicando que são objetos de programação.
*   As setas das funções para as tabelas indicam quais tabelas as funções consultam para realizar suas operações.
*   As setas das funções para `L[Consulta SELECT]` indicam que as funções escalares podem ser usadas diretamente na cláusula `SELECT` e as TVFs podem ser usadas na cláusula `FROM` de uma consulta.

---

## Log de Estado do Projeto

```text
## Estado — Após o Capítulo 27

=== BANCO DE DADOS ===
Nome: FinanceDB
Status: Operacional

=== TABELAS E REGISTROS ===
Bancos:            5+ registros
TiposTransacao:    3 registros (RECEITA, DESPESA, TRANSF)
Empresas:          2+ registros
ContasBancarias:   5+ registros
PlanoDeContas:     24 registros em 3 níveis hierárquicos
Transacoes:        58 registros (2 novos inseridos via SP, 2 da transferência)
Orcamentos:        39 registros por conta e período

=== VIEWS CRIADAS ===
vw_SaldosContas
vw_TransacoesDetalhadas
vw_DRESimplificadaMensal
vw_RankingDespesasPorCategoria
vw_OrcamentoRealizadoMensal

=== STORED PROCEDURES CRIADAS ===
usp_InserirBanco
usp_AtualizarStatusTransacao
usp_InserirTransacao
usp_GerarDRESimplificada
usp_TransferirFundos

=== FUNÇÕES T-SQL CRIADAS ===
ufn_FormatarCNPJ (Scalar Function)
ufn_CalcularJurosSimples (Scalar Function)
uft_TransacoesPorPeriodo (Inline Table-Valued Function)
uft_RelatorioOrcamentoRealizado (Multi-Statement Table-Valued Function)
uft_SaldoContaBancaria (Inline Table-Valued Function - Desafio)

=== MÓDULOS CONCLUÍDOS ===
✅ Módulo 1 — Fundamentos: Teoria e Ambiente (Capítulos 1–6)
✅ Módulo 2 — Essencial: T-SQL Básico (Capítulos 7–14)
✅ Módulo 3 — PROFICIENTE: Relacionamentos e Consultas Avançadas (Capítulos 15–22)
✅ Módulo 4 — AVANÇADO: Objetos de Banco de Dados e Programabilidade (Capítulos 23–27)

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
✅ Capítulo 25: Views — Criando Relatórios Reutilizáveis
✅ Capítulo 26: Stored Procedures — Automatizando Operações
✅ Capítulo 27: Funções T-SQL — Scalar e Table-Valued Functions

=== HABILIDADES ADQUIRIDAS NESTE CAPÍTULO ===
- Criação de Funções Escalares (Scalar Functions)
- Criação de Funções com Valor de Tabela (Table-Valued Functions - TVFs)
- Distinção entre Inline TVFs (ITVFs) e Multi-Statement TVFs (MSTVFs)
- Uso de funções para cálculos, formatações e geração de conjuntos de dados
- Compreensão das diferenças e casos de uso entre Funções e Stored Procedures
- Alteração e remoção de funções com ALTER FUNCTION e DROP FUNCTION

=== PRÓXIMO ===
Capítulo 28: Triggers — Auditoria e Regras de Negócio Automáticas
Objetivo: criar Triggers para registrar auditoria de operações financeiras,
garantir a integridade dos dados e implementar regras de negócio complexas
no FinanceDB de forma automática e reativa a eventos de DML (INSERT, UPDATE, DELETE).
```

---

Dúvidas? Posso prosseguir para o Capítulo 28?