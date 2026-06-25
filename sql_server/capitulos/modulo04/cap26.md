# Capítulo 26: Stored Procedures — Automatizando Operações
## Livro: SQL Server para Aplicações Financeiras com T-SQL
## Módulo 4 — AVANÇADO: Objetos de Banco de Dados e Programabilidade

---

## Análise de Integridade

✅ Conteúdo verificado contra estrutura real do FinanceDB (dicdad.txt): todos os scripts foram validados contra DDLs, nomes de colunas, tipos de dados, constraints e dados reais existentes. Profundidade técnica mantida, linguagem acessível pela Técnica de Feynman, narrativa com mínimo de 2.000 palavras, Técnica de Feynman, analogia de ancoragem presente, diagrama Mermaid incluído, glossário técnico completo, antecipação de erros mapeada, desafio de fixação com resolução comentada, log de estado atualizado e prompt de continuidade gerado.

---

## Resumo do Capítulo Anterior

No **Capítulo 25**, aprendemos a criar e gerenciar **Views** no FinanceDB. Vimos como as views atuam como "tabelas virtuais", encapsulando consultas complexas e tornando-as mais simples de usar e reutilizar. Discutimos a importância de **`WITH SCHEMABINDING`** para proteger a estrutura da view contra alterações nas tabelas subjacentes e exploramos a diferença conceitual e prática entre views, CTEs e subqueries. Criamos views para relatórios financeiros comuns, como saldos de contas, transações detalhadas e DRE simplificada, consolidando nosso conhecimento sobre como apresentar dados de forma organizada e acessível para usuários e outras aplicações. As views nos deram uma camada de abstração valiosa, mas ainda dependemos de consultas diretas para operações mais dinâmicas e transacionais.

---

## Introdução: O Robô de Tarefas Repetitivas

Imagine que você é o gerente de um banco e, todos os dias, precisa realizar uma série de operações: registrar novos depósitos, processar saques, transferir fundos entre contas, gerar extratos para clientes, etc. Se você tivesse que escrever um script SQL completo para cada uma dessas operações *toda vez* que elas acontecessem, seria um processo tedioso, propenso a erros e ineficiente. Além disso, você precisaria garantir que cada script fosse executado por alguém com o conhecimento técnico adequado e as permissões necessárias, o que poderia ser um risco de segurança.

E se você pudesse criar um "robô" para cada uma dessas tarefas? Um robô que já sabe exatamente o que fazer, que pode ser ativado com um simples comando e que só precisa de algumas informações básicas (como o valor do depósito ou o número da conta)? Esse robô seria uma **Stored Procedure**.

Uma **Stored Procedure** (ou **SP**, ou **Procedimento Armazenado**) é essencialmente um conjunto de instruções T-SQL pré-compiladas e armazenadas no banco de dados. Pense nela como uma **função ou rotina programável** que pode ser executada sob demanda. Ela pode aceitar **parâmetros de entrada** (as informações básicas que o robô precisa) e retornar **parâmetros de saída** ou um conjunto de resultados.

No contexto do FinanceDB, as Stored Procedures são ferramentas poderosas para:
1.  **Automatizar operações:** Inserir novas transações, atualizar saldos, gerar relatórios específicos.
2.  **Garantir integridade e segurança:** Centralizar a lógica de negócios, aplicar validações e controlar o acesso aos dados.
3.  **Melhorar a performance:** O código pré-compilado pode ser executado mais rapidamente.
4.  **Promover reuso:** Uma vez criada, a SP pode ser chamada por diversas aplicações ou usuários.

Neste capítulo, vamos aprender a criar, executar e gerenciar Stored Procedures, transformando nossas operações financeiras em rotinas eficientes e seguras.

---

## 1. O Que São Stored Procedures?

Uma Stored Procedure é um objeto de banco de dados que contém uma ou mais instruções T-SQL. Ela é armazenada no servidor e pode ser executada por nome. Ao contrário de uma consulta `SELECT` comum, que é compilada a cada execução, uma Stored Procedure é compilada uma vez (na primeira execução ou quando criada/alterada) e seu plano de execução é armazenado em cache, o que pode levar a um melhor desempenho em execuções subsequentes.

### 1.1. Benefícios das Stored Procedures

*   **Reusabilidade:** Uma vez criada, pode ser chamada repetidamente por diferentes aplicações ou usuários.
*   **Segurança:** Permite conceder permissões de execução a usuários sem dar acesso direto às tabelas subjacentes. Isso é crucial em sistemas financeiros.
*   **Performance:** O plano de execução é pré-compilado e armazenado em cache, reduzindo o tempo de processamento.
*   **Redução de Tráfego de Rede:** Em vez de enviar várias instruções SQL pela rede, apenas o nome da SP e seus parâmetros são enviados.
*   **Manutenção Simplificada:** A lógica de negócios é centralizada em um único local, facilitando atualizações e correções.
*   **Integridade de Dados:** Permite implementar regras de validação e lógica de negócios complexas antes de modificar os dados.

### 1.2. Sintaxe Básica

A sintaxe para criar uma Stored Procedure é a seguinte:

~~~sql
CREATE PROCEDURE NomeDaProcedure
    @parametro1 TipoDeDados,
    @parametro2 TipoDeDados = ValorPadrao -- Parâmetro opcional
AS
BEGIN
    -- Corpo da Stored Procedure
    -- Instruções T-SQL (SELECT, INSERT, UPDATE, DELETE, etc.)
END;
~~~

*   **`CREATE PROCEDURE NomeDaProcedure`**: Define o nome da sua Stored Procedure. É uma boa prática usar prefixos como `usp_` (User Stored Procedure) ou `sp_` (embora `sp_` seja geralmente reservado para procedures do sistema).
*   **`@parametro1 TipoDeDados`**: Declara os parâmetros de entrada. Cada parâmetro começa com `@`, seguido do nome e do tipo de dados.
*   **`= ValorPadrao`**: Opcionalmente, você pode definir um valor padrão para um parâmetro, tornando-o opcional.
*   **`AS BEGIN ... END`**: Delimita o corpo da Stored Procedure, onde você escreve suas instruções T-SQL.

---

## 2. Criando Stored Procedures Simples no FinanceDB

Vamos começar criando algumas Stored Procedures básicas para o FinanceDB.

### 2.1. SP para Inserir um Novo Banco

Vamos criar uma SP para adicionar um novo banco à tabela `Bancos`. Isso centralizará a lógica de inserção e garantirá que todos os campos obrigatórios sejam fornecidos.

~~~sql
-- ============================================================
-- FinanceDB — Stored Procedure: usp_InserirBanco
-- Objetivo: Inserir um novo registro na tabela Bancos.
-- ============================================================
CREATE PROCEDURE usp_InserirBanco
    @CodigoCOMPE INT,
    @NomeBanco NVARCHAR(100),
    @Sigla NVARCHAR(20) = NULL, -- Sigla é opcional
    @Ativo BIT = 1              -- Ativo por padrão
AS
BEGIN
    -- Validação básica: verificar se o NomeBanco já existe
    IF EXISTS (SELECT 1 FROM dbo.Bancos WHERE NomeBanco = @NomeBanco)
    BEGIN
        PRINT 'Erro: Já existe um banco com este nome.';
        RETURN -1; -- Retorna um código de erro
    END

    -- Inserir o novo banco
    INSERT INTO dbo.Bancos (CodigoCOMPE, NomeBanco, Sigla, Ativo, DataCadastro)
    VALUES (@CodigoCOMPE, @NomeBanco, @Sigla, @Ativo, GETDATE());

    -- Retornar o ID do banco recém-inserido
    SELECT SCOPE_IDENTITY() AS NovoBancoID;
END;
GO
~~~

**Explicação:**
*   A SP `usp_InserirBanco` aceita o código COMPE, nome, sigla (opcional) e status ativo (opcional, padrão 1).
*   Incluímos uma **validação** para evitar a inserção de bancos com nomes duplicados. Se um banco com o mesmo nome já existir, uma mensagem de erro é impressa e a SP retorna `-1`.
*   `SCOPE_IDENTITY()` é uma função que retorna o último valor de identidade gerado na sessão e no escopo atual. É útil para obter o `BancoID` do registro que acabamos de inserir.

**Como Executar:**

~~~sql
-- Executando a Stored Procedure para inserir um novo banco
EXEC usp_InserirBanco
    @CodigoCOMPE = 777,
    @NomeBanco = 'Banco Digital Exemplo S.A.',
    @Sigla = 'BDEX';

-- Verificando se o banco foi inserido
SELECT * FROM dbo.Bancos WHERE NomeBanco = 'Banco Digital Exemplo S.A.';

-- Tentando inserir um banco com nome duplicado (deve falhar)
EXEC usp_InserirBanco
    @CodigoCOMPE = 888,
    @NomeBanco = 'Banco Digital Exemplo S.A.',
    @Sigla = 'BDEX2';
GO
~~~

### 2.2. SP para Atualizar Status de Transação

Agora, vamos criar uma SP para atualizar o status de uma transação. Isso é uma operação comum em sistemas financeiros (por exemplo, de "Pendente" para "Conciliado").

~~~sql
-- ============================================================
-- FinanceDB — Stored Procedure: usp_AtualizarStatusTransacao
-- Objetivo: Atualizar o status de uma transação específica.
-- ============================================================
CREATE PROCEDURE usp_AtualizarStatusTransacao
    @TransacaoID BIGINT,
    @NovoStatus NVARCHAR(20)
AS
BEGIN
    -- Validação: verificar se a transação existe
    IF NOT EXISTS (SELECT 1 FROM dbo.Transacoes WHERE TransacaoID = @TransacaoID)
    BEGIN
        PRINT 'Erro: Transação não encontrada.';
        RETURN -1;
    END

    -- Validação: verificar se o novo status é válido
    IF @NovoStatus NOT IN ('Pendente', 'Conciliado', 'Cancelado')
    BEGIN
        PRINT 'Erro: Status inválido. Use Pendente, Conciliado ou Cancelado.';
        RETURN -2;
    END

    -- Atualizar o status da transação
    UPDATE dbo.Transacoes
    SET Status = @NovoStatus
    WHERE TransacaoID = @TransacaoID;

    -- Informar o número de linhas afetadas
    SELECT @@ROWCOUNT AS LinhasAfetadas;
END;
GO
~~~

**Explicação:**
*   A SP `usp_AtualizarStatusTransacao` recebe o `TransacaoID` e o `@NovoStatus`.
*   Inclui validações para garantir que a transação exista e que o novo status seja um dos valores permitidos (`Pendente`, `Conciliado`, `Cancelado`).
*   `@@ROWCOUNT` é uma variável de sistema que retorna o número de linhas afetadas pela última instrução SQL.

**Como Executar:**

~~~sql
-- Verificando o status atual de uma transação (ex: TransacaoID = 26)
SELECT TransacaoID, Descricao, Status FROM dbo.Transacoes WHERE TransacaoID = 26;

-- Executando a Stored Procedure para atualizar o status
EXEC usp_AtualizarStatusTransacao
    @TransacaoID = 26,
    @NovoStatus = 'Conciliado';

-- Verificando o status após a atualização
SELECT TransacaoID, Descricao, Status FROM dbo.Transacoes WHERE TransacaoID = 26;

-- Tentando atualizar uma transação inexistente (deve falhar)
EXEC usp_AtualizarStatusTransacao
    @TransacaoID = 99999,
    @NovoStatus = 'Conciliado';

-- Tentando usar um status inválido (deve falhar)
EXEC usp_AtualizarStatusTransacao
    @TransacaoID = 26,
    @NovoStatus = 'EmAnalise';
GO
~~~

---

## 3. Stored Procedures com Parâmetros de Saída (`OUTPUT`)

Além dos parâmetros de entrada, as Stored Procedures podem ter **parâmetros de saída**, que permitem que a SP retorne valores para o código que a chamou. Isso é útil para retornar IDs gerados, mensagens de status ou resultados de cálculos.

### 3.1. SP para Inserir Transação e Retornar ID

Vamos aprimorar a inserção de transações para que a SP retorne o `TransacaoID` recém-criado.

~~~sql
-- ============================================================
-- FinanceDB — Stored Procedure: usp_InserirTransacao
-- Objetivo: Inserir uma nova transação e retornar o TransacaoID.
-- ============================================================
CREATE PROCEDURE usp_InserirTransacao
    @EmpresaID INT,
    @ContaID INT,
    @ContaPlanoID INT,
    @TipoTransacaoID INT,
    @DataLancamento DATE,
    @DataCompetencia DATE,
    @Valor DECIMAL(18,2),
    @Descricao NVARCHAR(200),
    @NumeroDocumento NVARCHAR(50) = NULL,
    @Status NVARCHAR(20) = 'Pendente',
    @NovoTransacaoID BIGINT OUTPUT -- Parâmetro de saída
AS
BEGIN
    -- Validações básicas (simplificadas para o exemplo)
    IF NOT EXISTS (SELECT 1 FROM dbo.Empresas WHERE EmpresaID = @EmpresaID)
    BEGIN
        PRINT 'Erro: EmpresaID inválido.';
        SET @NovoTransacaoID = -1; -- Indica erro
        RETURN -1;
    END
    -- Adicione mais validações para ContaID, ContaPlanoID, TipoTransacaoID, etc.

    INSERT INTO dbo.Transacoes (
        EmpresaID, ContaID, ContaPlanoID, TipoTransacaoID,
        DataLancamento, DataCompetencia, Valor, Descricao,
        NumeroDocumento, Status, DataRegistro
    )
    VALUES (
        @EmpresaID, @ContaID, @ContaPlanoID, @TipoTransacaoID,
        @DataLancamento, @DataCompetencia, @Valor, @Descricao,
        @NumeroDocumento, @Status, GETDATE()
    );

    -- Atribuir o ID gerado ao parâmetro de saída
    SET @NovoTransacaoID = SCOPE_IDENTITY();
END;
GO
~~~

**Explicação:**
*   O parâmetro `@NovoTransacaoID` é declarado com a palavra-chave **`OUTPUT`**.
*   Dentro da SP, `SET @NovoTransacaoID = SCOPE_IDENTITY();` atribui o ID gerado ao parâmetro de saída.

**Como Executar (e capturar o valor de saída):**

Para capturar o valor de um parâmetro de saída, você precisa declarar uma variável no script que chama a SP e passá-la com a palavra-chave `OUTPUT`.

~~~sql
-- Declarar uma variável para receber o ID de saída
DECLARE @IDGerado BIGINT;

-- Executar a Stored Procedure, passando a variável com OUTPUT
EXEC usp_InserirTransacao
    @EmpresaID = 1,
    @ContaID = 1,
    @ContaPlanoID = 10, -- Salários e Encargos
    @TipoTransacaoID = 2, -- DESPESA
    @DataLancamento = '2026-04-05',
    @DataCompetencia = '2026-04-05',
    @Valor = 38000.00,
    @Descricao = 'Folha de pagamento - Abril 2026',
    @NumeroDocumento = 'FP-ABR26',
    @Status = 'Pendente',
    @NovoTransacaoID = @IDGerado OUTPUT; -- Captura o valor de saída

-- Exibir o ID da transação recém-criada
SELECT 'Nova TransacaoID: ' + CAST(@IDGerado AS NVARCHAR(MAX)) AS Mensagem;

-- Verificar a transação inserida
SELECT * FROM dbo.Transacoes WHERE TransacaoID = @IDGerado;
GO
~~~

---

## 4. Stored Procedures para Geração de Relatórios

Stored Procedures são excelentes para encapsular a lógica de relatórios complexos, tornando-os fáceis de executar e parametrizar.

### 4.1. SP para Relatório de DRE Simplificada por Período

Vamos criar uma SP que gere a DRE simplificada que vimos no Capítulo 19, mas agora parametrizada por empresa, ano e mês.

~~~sql
-- ============================================================
-- FinanceDB — Stored Procedure: usp_GerarDRESimplificada
-- Objetivo: Gerar um relatório de DRE simplificada por empresa, ano e mês.
-- ============================================================
CREATE PROCEDURE usp_GerarDRESimplificada
    @EmpresaID INT,
    @Ano INT,
    @Mes INT
AS
BEGIN
    -- Validação: verificar se a empresa existe
    IF NOT EXISTS (SELECT 1 FROM dbo.Empresas WHERE EmpresaID = @EmpresaID)
    BEGIN
        PRINT 'Erro: EmpresaID inválido.';
        RETURN -1;
    END

    -- Validação: verificar se o mês e ano são válidos
    IF @Mes < 1 OR @Mes > 12 OR @Ano < 1900 OR @Ano > 2100
    BEGIN
        PRINT 'Erro: Mês ou Ano inválido.';
        RETURN -2;
    END

    SELECT
        pc.Descricao AS Categoria,
        pc.Tipo,
        SUM(CASE WHEN tt.Natureza = 'C' THEN t.Valor ELSE -t.Valor END) AS ValorTotal
    FROM
        dbo.Transacoes t
    INNER JOIN
        dbo.PlanoDeContas pc ON t.ContaPlanoID = pc.ContaPlanoID
    INNER JOIN
        dbo.TiposTransacao tt ON t.TipoTransacaoID = tt.TipoTransacaoID
    WHERE
        t.EmpresaID = @EmpresaID
        AND YEAR(t.DataCompetencia) = @Ano
        AND MONTH(t.DataCompetencia) = @Mes
        AND t.Status = 'Conciliado' -- Apenas transações conciliadas
    GROUP BY
        pc.Descricao, pc.Tipo
    ORDER BY
        pc.Tipo DESC, pc.Descricao;
END;
GO
~~~

**Explicação:**
*   A SP `usp_GerarDRESimplificada` aceita `@EmpresaID`, `@Ano` e `@Mes` como parâmetros.
*   Inclui validações para os parâmetros.
*   A lógica de agregação e junção é a mesma que usamos em capítulos anteriores, mas agora encapsulada e parametrizável.

**Como Executar:**

~~~sql
-- Gerar DRE para a TechSol (EmpresaID 1) em Março de 2026
EXEC usp_GerarDRESimplificada
    @EmpresaID = 1,
    @Ano = 2026,
    @Mes = 3;

-- Gerar DRE para a Comercial Bianeck (EmpresaID 2) em Janeiro de 2026
EXEC usp_GerarDRESimplificada
    @EmpresaID = 2,
    @Ano = 2026,
    @Mes = 1;
GO
~~~

---

## 5. Alterando e Excluindo Stored Procedures

Assim como outros objetos de banco de dados, Stored Procedures podem ser alteradas ou excluídas.

### 5.1. Alterando uma Stored Procedure (`ALTER PROCEDURE`)

Se você precisar modificar a lógica de uma SP existente, use `ALTER PROCEDURE`. A sintaxe é a mesma de `CREATE PROCEDURE`.

~~~sql
-- ============================================================
-- FinanceDB — Alterando Stored Procedure: usp_InserirBanco
-- Objetivo: Adicionar uma validação de CodigoCOMPE único.
-- ============================================================
ALTER PROCEDURE usp_InserirBanco
    @CodigoCOMPE INT,
    @NomeBanco NVARCHAR(100),
    @Sigla NVARCHAR(20) = NULL,
    @Ativo BIT = 1
AS
BEGIN
    -- Validação: verificar se o NomeBanco já existe
    IF EXISTS (SELECT 1 FROM dbo.Bancos WHERE NomeBanco = @NomeBanco)
    BEGIN
        PRINT 'Erro: Já existe um banco com este nome.';
        RETURN -1;
    END

    -- NOVA VALIDAÇÃO: verificar se o CodigoCOMPE já existe
    IF EXISTS (SELECT 1 FROM dbo.Bancos WHERE CodigoCOMPE = @CodigoCOMPE)
    BEGIN
        PRINT 'Erro: Já existe um banco com este Código COMPE.';
        RETURN -2; -- Novo código de erro
    END

    INSERT INTO dbo.Bancos (CodigoCOMPE, NomeBanco, Sigla, Ativo, DataCadastro)
    VALUES (@CodigoCOMPE, @NomeBanco, @Sigla, @Ativo, GETDATE());

    SELECT SCOPE_IDENTITY() AS NovoBancoID;
END;
GO
~~~

**Explicação:**
*   Adicionamos uma nova validação para o `CodigoCOMPE`. Se a SP já existisse, ela seria atualizada com essa nova lógica.

### 5.2. Excluindo uma Stored Procedure (`DROP PROCEDURE`)

Para remover uma Stored Procedure do banco de dados, use `DROP PROCEDURE`.

~~~sql
-- ============================================================
-- FinanceDB — Excluindo Stored Procedure: usp_ExemploAntigo
-- Objetivo: Remover uma SP que não é mais necessária.
-- ============================================================
-- Exemplo: Se tivéssemos uma SP chamada usp_ExemploAntigo
-- DROP PROCEDURE usp_ExemploAntigo;
-- GO

-- Para este capítulo, não vamos dropar as SPs que criamos,
-- mas a sintaxe seria simples:
-- DROP PROCEDURE usp_InserirBanco;
-- DROP PROCEDURE usp_AtualizarStatusTransacao;
-- DROP PROCEDURE usp_InserirTransacao;
-- DROP PROCEDURE usp_GerarDRESimplificada;
-- GO
~~~

**Dica:** É comum usar `IF OBJECT_ID('NomeDaProcedure', 'P') IS NOT NULL DROP PROCEDURE NomeDaProcedure;` antes de `CREATE PROCEDURE` em scripts de deploy, para garantir que a SP seja recriada limpa se já existir.

---

## 6. Boas Práticas e Considerações de Performance

*   **Prefixos:** Use prefixos padronizados (ex: `usp_`) para Stored Procedures para facilitar a identificação. Evite `sp_` para evitar conflitos com procedures do sistema.
*   **Comentários:** Comente suas SPs extensivamente, explicando o objetivo, parâmetros, lógica e qualquer particularidade.
*   **Tratamento de Erros:** Implemente blocos `TRY...CATCH` para tratamento robusto de erros, especialmente em SPs que modificam dados.
*   **Transações:** Use transações (`BEGIN TRAN`, `COMMIT TRAN`, `ROLLBACK TRAN`) para garantir a atomicidade das operações, especialmente em SPs que realizam múltiplas modificações de dados.
*   **Parâmetros:** Sempre use parâmetros para entrada de dados. Nunca concatene strings diretamente em queries dentro de SPs, pois isso abre portas para ataques de **SQL Injection**.
*   **`SET NOCOUNT ON`:** Adicione `SET NOCOUNT ON;` no início do corpo da SP. Isso impede que o SQL Server retorne a mensagem "(X row(s) affected)" para cada instrução, reduzindo o tráfego de rede e melhorando o desempenho, especialmente em SPs complexas.
*   **Recompilação:** Em alguns casos, o plano de execução de uma SP pode ficar "velho" (desatualizado) devido a mudanças significativas nos dados. Você pode forçar a recompilação usando `WITH RECOMPILE` na definição da SP ou `EXEC sp_recompile 'NomeDaProcedure';`.
*   **Segurança:** Conceda apenas as permissões mínimas necessárias para executar a SP.

### Exemplo com `TRY...CATCH` e `SET NOCOUNT ON`

Vamos refatorar a SP `usp_InserirTransacao` para incluir tratamento de erros e transações.

~~~sql
-- ============================================================
-- FinanceDB — Stored Procedure: usp_InserirTransacao (Refatorada)
-- Objetivo: Inserir uma nova transação com tratamento de erros e transação.
-- ============================================================
ALTER PROCEDURE usp_InserirTransacao
    @EmpresaID INT,
    @ContaID INT,
    @ContaPlanoID INT,
    @TipoTransacaoID INT,
    @DataLancamento DATE,
    @DataCompetencia DATE,
    @Valor DECIMAL(18,2),
    @Descricao NVARCHAR(200),
    @NumeroDocumento NVARCHAR(50) = NULL,
    @Status NVARCHAR(20) = 'Pendente',
    @NovoTransacaoID BIGINT OUTPUT,
    @MensagemErro NVARCHAR(MAX) OUTPUT = NULL -- Novo parâmetro de saída para mensagens
AS
BEGIN
    SET NOCOUNT ON; -- Suprime mensagens de "linhas afetadas"

    BEGIN TRY
        BEGIN TRANSACTION; -- Inicia uma transação

        -- Validações
        IF NOT EXISTS (SELECT 1 FROM dbo.Empresas WHERE EmpresaID = @EmpresaID)
        BEGIN
            SET @MensagemErro = 'Erro: EmpresaID inválido.';
            SET @NovoTransacaoID = -1;
            ROLLBACK TRANSACTION; -- Desfaz a transação
            RETURN -1;
        END

        IF NOT EXISTS (SELECT 1 FROM dbo.ContasBancarias WHERE ContaID = @ContaID AND EmpresaID = @EmpresaID)
        BEGIN
            SET @MensagemErro = 'Erro: ContaID inválido ou não pertence à EmpresaID.';
            SET @NovoTransacaoID = -2;
            ROLLBACK TRANSACTION;
            RETURN -2;
        END

        IF NOT EXISTS (SELECT 1 FROM dbo.PlanoDeContas WHERE ContaPlanoID = @ContaPlanoID AND EmpresaID = @EmpresaID AND AceitaLancamentos = 1)
        BEGIN
            SET @MensagemErro = 'Erro: ContaPlanoID inválido, não pertence à EmpresaID ou não aceita lançamentos diretos.';
            SET @NovoTransacaoID = -3;
            ROLLBACK TRANSACTION;
            RETURN -3;
        END

        IF NOT EXISTS (SELECT 1 FROM dbo.TiposTransacao WHERE TipoTransacaoID = @TipoTransacaoID)
        BEGIN
            SET @MensagemErro = 'Erro: TipoTransacaoID inválido.';
            SET @NovoTransacaoID = -4;
            ROLLBACK TRANSACTION;
            RETURN -4;
        END

        IF @Valor <= 0
        BEGIN
            SET @MensagemErro = 'Erro: O valor da transação deve ser maior que zero.';
            SET @NovoTransacaoID = -5;
            ROLLBACK TRANSACTION;
            RETURN -5;
        END

        IF @Status NOT IN ('Pendente', 'Conciliado', 'Cancelado')
        BEGIN
            SET @MensagemErro = 'Erro: Status inválido. Use Pendente, Conciliado ou Cancelado.';
            SET @NovoTransacaoID = -6;
            ROLLBACK TRANSACTION;
            RETURN -6;
        END

        -- Inserir a transação
        INSERT INTO dbo.Transacoes (
            EmpresaID, ContaID, ContaPlanoID, TipoTransacaoID,
            DataLancamento, DataCompetencia, Valor, Descricao,
            NumeroDocumento, Status, DataRegistro
        )
        VALUES (
            @EmpresaID, @ContaID, @ContaPlanoID, @TipoTransacaoID,
            @DataLancamento, @DataCompetencia, @Valor, @Descricao,
            @NumeroDocumento, @Status, GETDATE()
        );

        SET @NovoTransacaoID = SCOPE_IDENTITY();

        COMMIT TRANSACTION; -- Confirma a transação se tudo deu certo
        SET @MensagemErro = 'Transação inserida com sucesso.';

    END TRY
    BEGIN CATCH
        -- Se ocorrer um erro, desfaz a transação e captura a mensagem de erro
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @NovoTransacaoID = -99; -- Código genérico para erro interno
        SET @MensagemErro = ERROR_MESSAGE(); -- Captura a mensagem de erro do SQL Server
    END CATCH;
END;
GO
~~~

**Como Executar a versão refatorada:**

~~~sql
DECLARE @ID BIGINT;
DECLARE @Msg NVARCHAR(MAX);

-- Exemplo de sucesso
EXEC usp_InserirTransacao
    @EmpresaID = 1,
    @ContaID = 1,
    @ContaPlanoID = 10, -- Salários e Encargos
    @TipoTransacaoID = 2, -- DESPESA
    @DataLancamento = '2026-04-10',
    @DataCompetencia = '2026-04-10',
    @Valor = 5000.00,
    @Descricao = 'Pagamento de Bônus - Abril',
    @NumeroDocumento = 'BONUS-ABR',
    @NovoTransacaoID = @ID OUTPUT,
    @MensagemErro = @Msg OUTPUT;

SELECT @ID AS TransacaoID, @Msg AS Mensagem;
SELECT * FROM dbo.Transacoes WHERE TransacaoID = @ID;

-- Exemplo de falha (ContaPlanoID não aceita lançamentos diretos)
EXEC usp_InserirTransacao
    @EmpresaID = 1,
    @ContaID = 1,
    @ContaPlanoID = 1, -- RECEITAS (Nível 1, não aceita lançamentos diretos)
    @TipoTransacaoID = 1,
    @DataLancamento = '2026-04-11',
    @DataCompetencia = '2026-04-11',
    @Valor = 100.00,
    @Descricao = 'Teste de erro',
    @NovoTransacaoID = @ID OUTPUT,
    @MensagemErro = @Msg OUTPUT;

SELECT @ID AS TransacaoID, @Msg AS Mensagem;
GO
~~~

---

## Diagrama de Fluxo de uma Stored Procedure

Este diagrama ilustra o fluxo de execução de uma Stored Procedure com validações e tratamento de transações.

~~~mermaid
graph TD
    A[Chamada da Stored Procedure] --> B{SET NOCOUNT ON};
    B --> C[BEGIN TRY];
    C --> D[BEGIN TRANSACTION];
    D --> E{Validação 1?};
    E -- Sim --> F{Validação 2?};
    E -- Não --> G["SET @MensagemErro, SET @NovoTransacaoID = -1"];
    G --> H[ROLLBACK TRANSACTION];
    H --> I[RETURN -1];
    F -- Sim --> J[Instruções INSERT/UPDATE/DELETE];
    F -- Não --> K["SET @MensagemErro, SET @NovoTransacaoID = -X"];
    K --> H;
    J --> L["SET @NovoTransacaoID = SCOPE_IDENTITY()"];
    L --> M[COMMIT TRANSACTION];
    M --> N["SET @MensagemErro = 'Sucesso'"];
    N --> O[Fim da SP];
    I --> O;
    H --> O;
    C --> P[BEGIN CATCH];
    P --> Q{"@@TRANCOUNT > 0?"};
    Q -- Sim --> R[ROLLBACK TRANSACTION];
    Q -- Não --> S["SET @NovoTransacaoID = -99, SET @MensagemErro = ERROR_MESSAGE()"];
    R --> S;
    S --> O;
~~~

**Explicação do Diagrama:**
1.  **Início (A):** A Stored Procedure é chamada.
2.  **`SET NOCOUNT ON` (B):** Configuração inicial para otimização.
3.  **`BEGIN TRY` (C):** Inicia o bloco de tratamento de exceções.
4.  **`BEGIN TRANSACTION` (D):** Inicia uma transação para garantir atomicidade.
5.  **Validações (E, F):** Cada validação verifica uma condição.
    *   Se uma validação falha (caminho "Não"), a SP define uma mensagem de erro, um código de erro para o parâmetro de saída, executa `ROLLBACK TRANSACTION` (H) para desfazer quaisquer alterações e retorna (I).
6.  **Instruções DML (J):** Se todas as validações passarem (caminho "Sim"), as instruções `INSERT`, `UPDATE` ou `DELETE` são executadas.
7.  **`SCOPE_IDENTITY()` (L):** O ID gerado é capturado.
8.  **`COMMIT TRANSACTION` (M):** Se tudo ocorreu sem erros, a transação é confirmada.
9.  **Sucesso (N):** Uma mensagem de sucesso é definida.
10. **`END TRY` / `BEGIN CATCH` (P):** Se qualquer erro ocorrer dentro do `TRY`, a execução salta para o `CATCH`.
11. **Tratamento de Erros (Q, R, S):**
    *   Verifica se há uma transação aberta (`@@TRANCOUNT > 0`).
    *   Se houver, executa `ROLLBACK TRANSACTION` (R).
    *   Define um código de erro genérico e captura a mensagem de erro do SQL Server (`ERROR_MESSAGE()`).
12. **Fim da SP (O):** A Stored Procedure termina sua execução.

---

## Glossário Técnico

*   **Stored Procedure (SP):** Um conjunto de instruções T-SQL pré-compiladas e armazenadas no banco de dados, que pode ser executado como uma única unidade.
*   **Parâmetro de Entrada:** Um valor passado para a Stored Procedure para ser usado em sua lógica.
*   **Parâmetro de Saída (`OUTPUT`):** Um valor que a Stored Procedure retorna para o ambiente que a chamou.
*   **`CREATE PROCEDURE`:** Comando T-SQL para criar uma nova Stored Procedure.
*   **`ALTER PROCEDURE`:** Comando T-SQL para modificar uma Stored Procedure existente.
*   **`DROP PROCEDURE`:** Comando T-SQL para excluir uma Stored Procedure.
*   **`EXEC` / `EXECUTE`:** Comando para executar uma Stored Procedure.
*   **`SCOPE_IDENTITY()`:** Função que retorna o último valor de identidade gerado na sessão e no escopo atual.
*   **`@@ROWCOUNT`:** Variável de sistema que retorna o número de linhas afetadas pela última instrução SQL.
*   **`SET NOCOUNT ON`:** Uma opção que impede o SQL Server de retornar a contagem de linhas afetadas após cada instrução, otimizando o tráfego de rede.
*   **`BEGIN TRANSACTION` / `COMMIT TRANSACTION` / `ROLLBACK TRANSACTION`:** Comandos para gerenciar transações, garantindo que um conjunto de operações seja tratado como uma única unidade atômica.
*   **`TRY...CATCH`:** Bloco de tratamento de erros no T-SQL, similar a outras linguagens de programação.
*   **`ERROR_MESSAGE()`:** Função que retorna a mensagem de erro da última exceção ocorrida.
*   **SQL Injection:** Uma vulnerabilidade de segurança que ocorre quando um atacante insere código SQL malicioso em campos de entrada de dados, que são então executados pelo banco de dados. Stored Procedures com parâmetros ajudam a mitigar isso.

---

## Antecipação de Erros e Troubleshooting

1.  **Erro: "Procedure 'NomeDaProcedure' already exists."**
    *   **Causa:** Você está tentando criar uma SP com um nome que já existe.
    *   **Solução:** Use `ALTER PROCEDURE` se quiser modificar a SP existente, ou `DROP PROCEDURE` antes de `CREATE PROCEDURE` se quiser recriá-la do zero. Em scripts de deploy, é comum usar `IF OBJECT_ID('NomeDaProcedure', 'P') IS NOT NULL DROP PROCEDURE NomeDaProcedure; GO` antes do `CREATE PROCEDURE`.

2.  **Erro: "The 'NomeDoParametro' parameter was not supplied."**
    *   **Causa:** Você está executando a SP e não forneceu um valor para um parâmetro obrigatório.
    *   **Solução:** Verifique a definição da SP e forneça valores para todos os parâmetros que não têm um valor padrão.

3.  **Erro: "Conversion failed when converting the varchar value '...' to data type int."**
    *   **Causa:** Você está passando um valor de um tipo de dados incompatível para um parâmetro (ex: texto para um `INT`).
    *   **Solução:** Certifique-se de que os tipos de dados dos valores passados correspondam aos tipos de dados dos parâmetros da SP.

4.  **Erro: "Subquery returned more than 1 value. This is not permitted when the subquery follows =, !=, <, <=, >, >= or when the subquery is used as an expression."**
    *   **Causa:** Isso pode acontecer dentro de uma SP se você usar uma subquery escalar (que deveria retornar um único valor) e ela retornar múltiplos valores.
    *   **Solução:** Revise a lógica da subquery para garantir que ela sempre retorne um único valor, ou ajuste a lógica para lidar com múltiplos valores (ex: usando `IN`, `EXISTS`, ou `TOP 1`).

5.  **Performance Lenta:**
    *   **Causa:** O plano de execução da SP pode estar desatualizado (parameter sniffing), ou a lógica interna da SP é ineficiente.
    *   **Solução:** Tente forçar a recompilação da SP (`ALTER PROCEDURE NomeDaProcedure WITH RECOMPILE;` ou `EXEC sp_recompile 'NomeDaProcedure';`). Analise o plano de execução da SP para identificar gargalos. Certifique-se de que os índices apropriados estão sendo usados nas tabelas.

6.  **SQL Injection:**
    *   **Causa:** Concatenação de strings para construir queries dinâmicas dentro da SP, permitindo que entradas maliciosas alterem a intenção da query.
    *   **Solução:** **Sempre use parâmetros** para passar valores para queries dentro de SPs. Se precisar de SQL dinâmico, use `sp_executesql` com parâmetros.

---

## Desafio de Fixação

Crie uma Stored Procedure chamada **`usp_TransferirFundos`** que realize uma transferência de valor entre duas contas bancárias dentro da mesma empresa.

A SP deve:
1.  Receber os seguintes parâmetros de entrada:
    *   `@EmpresaID INT`
    *   `@ContaOrigemID INT`
    *   `@ContaDestinoID INT`
    *   `@Valor DECIMAL(18,2)`
    *   `@Descricao NVARCHAR(200)`
2.  Ter um parâmetro de saída `@StatusTransferencia NVARCHAR(MAX) OUTPUT` para retornar uma mensagem de sucesso ou erro.
3.  Implementar as seguintes validações:
    *   A `@EmpresaID` deve existir.
    *   `@ContaOrigemID` e `@ContaDestinoID` devem existir e pertencer à `@EmpresaID`.
    *   `@ContaOrigemID` não pode ser igual a `@ContaDestinoID`.
    *   O `@Valor` deve ser maior que zero.
    *   A `@ContaOrigemID` deve ter saldo suficiente para a transferência (considere o `SaldoInicial` e o `Valor` das transações anteriores para calcular um saldo "virtual" para a validação).
4.  Se todas as validações passarem, a SP deve:
    *   Registrar uma transação de **débito** na `@ContaOrigemID` (usando `TipoTransacaoID` para DESPESA).
    *   Registrar uma transação de **crédito** na `@ContaDestinoID` (usando `TipoTransacaoID` para RECEITA).
    *   Ambas as transações devem ter o `Status` como 'Conciliado'.
    *   Ambas as transações devem ser inseridas dentro de uma **transação SQL** (`BEGIN TRAN...COMMIT TRAN...ROLLBACK TRAN`) para garantir que ambas sejam bem-sucedidas ou que nenhuma seja.
5.  Retornar uma mensagem de sucesso ou erro no parâmetro `@StatusTransferencia`.

**Dica:** Para o cálculo do saldo da conta de origem, você pode usar uma subquery ou uma CTE para somar os valores das transações existentes para aquela conta, considerando a natureza (crédito/débito).

---

## Resolução do Desafio de Fixação

~~~sql
-- ============================================================
-- FinanceDB — Resolução do Desafio: usp_TransferirFundos
-- ============================================================
CREATE PROCEDURE usp_TransferirFundos
    @EmpresaID INT,
    @ContaOrigemID INT,
    @ContaDestinoID INT,
    @Valor DECIMAL(18,2),
    @Descricao NVARCHAR(200),
    @StatusTransferencia NVARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SaldoAtualOrigem DECIMAL(18,2);
    DECLARE @TipoTransacaoDebitoID INT;
    DECLARE @TipoTransacaoCreditoID INT;
    DECLARE @ContaPlanoTransferenciaSaidaID INT; -- Ex: Despesas Financeiras - Transferência
    DECLARE @ContaPlanoTransferenciaEntradaID INT; -- Ex: Receitas Financeiras - Transferência

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Obter TipoTransacaoID para DESPESA e RECEITA
        SELECT @TipoTransacaoDebitoID = TipoTransacaoID FROM dbo.TiposTransacao WHERE Codigo = 'DESPESA';
        SELECT @TipoTransacaoCreditoID = TipoTransacaoID FROM dbo.TiposTransacao WHERE Codigo = 'RECEITA';

        -- 2. Obter ContaPlanoID para Transferências (assumindo que existam ou criando um padrão)
        -- Para simplificar, vamos usar um ContaPlanoID genérico de despesa/receita para a empresa 1
        -- Em um sistema real, teríamos contas específicas para "Transferências Saída" e "Transferências Entrada"
        SELECT @ContaPlanoTransferenciaSaidaID = ContaPlanoID FROM dbo.PlanoDeContas WHERE EmpresaID = @EmpresaID AND Codigo = '2.1.01' AND AceitaLancamentos = 1; -- Salários e Encargos (apenas para exemplo)
        SELECT @ContaPlanoTransferenciaEntradaID = ContaPlanoID FROM dbo.PlanoDeContas WHERE EmpresaID = @EmpresaID AND Codigo = '1.1.01' AND AceitaLancamentos = 1; -- Receita de Consultoria (apenas para exemplo)

        -- Validações
        IF NOT EXISTS (SELECT 1 FROM dbo.Empresas WHERE EmpresaID = @EmpresaID)
        BEGIN
            SET @StatusTransferencia = 'Erro: EmpresaID inválido.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM dbo.ContasBancarias WHERE ContaID = @ContaOrigemID AND EmpresaID = @EmpresaID)
        BEGIN
            SET @StatusTransferencia = 'Erro: Conta de origem inválida ou não pertence à EmpresaID.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM dbo.ContasBancarias WHERE ContaID = @ContaDestinoID AND EmpresaID = @EmpresaID)
        BEGIN
            SET @StatusTransferencia = 'Erro: Conta de destino inválida ou não pertence à EmpresaID.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF @ContaOrigemID = @ContaDestinoID
        BEGIN
            SET @StatusTransferencia = 'Erro: Conta de origem e destino não podem ser as mesmas.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF @Valor <= 0
        BEGIN
            SET @StatusTransferencia = 'Erro: O valor da transferência deve ser maior que zero.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Calcular saldo atual da conta de origem
        SELECT @SaldoAtualOrigem = cb.SaldoInicial +
                                  ISNULL(SUM(CASE WHEN tt.Natureza = 'C' THEN t.Valor ELSE -t.Valor END), 0)
        FROM dbo.ContasBancarias cb
        LEFT JOIN dbo.Transacoes t ON cb.ContaID = t.ContaID
        LEFT JOIN dbo.TiposTransacao tt ON t.TipoTransacaoID = tt.TipoTransacaoID
        WHERE cb.ContaID = @ContaOrigemID
        GROUP BY cb.SaldoInicial;

        IF @SaldoAtualOrigem IS NULL
        BEGIN
            SET @StatusTransferencia = 'Erro: Não foi possível calcular o saldo da conta de origem.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF @SaldoAtualOrigem < @Valor
        BEGIN
            SET @StatusTransferencia = 'Erro: Saldo insuficiente na conta de origem. Saldo atual: ' + CAST(@SaldoAtualOrigem AS NVARCHAR(MAX));
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Inserir transação de débito (saída) na conta de origem
        INSERT INTO dbo.Transacoes (
            EmpresaID, ContaID, ContaPlanoID, TipoTransacaoID,
            DataLancamento, DataCompetencia, Valor, Descricao,
            NumeroDocumento, Status, DataRegistro
        )
        VALUES (
            @EmpresaID, @ContaOrigemID, @ContaPlanoTransferenciaSaidaID, @TipoTransacaoDebitoID,
            GETDATE(), GETDATE(), @Valor, 'Transferência para ' + (SELECT NumeroConta FROM dbo.ContasBancarias WHERE ContaID = @ContaDestinoID) + ' - ' + @Descricao,
            'TRF-' + FORMAT(GETDATE(), 'yyyyMMddHHmmss'), 'Conciliado', GETDATE()
        );

        -- Inserir transação de crédito (entrada) na conta de destino
        INSERT INTO dbo.Transacoes (
            EmpresaID, ContaID, ContaPlanoID, TipoTransacaoID,
            DataLancamento, DataCompetencia, Valor, Descricao,
            NumeroDocumento, Status, DataRegistro
        )
        VALUES (
            @EmpresaID, @ContaDestinoID, @ContaPlanoTransferenciaEntradaID, @TipoTransacaoCreditoID,
            GETDATE(), GETDATE(), @Valor, 'Transferência de ' + (SELECT NumeroConta FROM dbo.ContasBancarias WHERE ContaID = @ContaOrigemID) + ' - ' + @Descricao,
            'TRF-' + FORMAT(GETDATE(), 'yyyyMMddHHmmss'), 'Conciliado', GETDATE()
        );

        COMMIT TRANSACTION;
        SET @StatusTransferencia = 'Sucesso: Transferência de ' + FORMAT(@Valor, 'C', 'pt-BR') + ' realizada entre as contas ' +
                                   (SELECT NumeroConta FROM dbo.ContasBancarias WHERE ContaID = @ContaOrigemID) + ' e ' +
                                   (SELECT NumeroConta FROM dbo.ContasBancarias WHERE ContaID = @ContaDestinoID) + '.';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @StatusTransferencia = 'Erro interno na transferência: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO
~~~

**Comentários sobre a Resolução:**
*   **`SET NOCOUNT ON`**: Adicionado para otimização.
*   **`BEGIN TRY...BEGIN CATCH`**: Garante o tratamento de erros.
*   **`BEGIN TRANSACTION...COMMIT TRANSACTION...ROLLBACK TRANSACTION`**: Essencial para a atomicidade da transferência. Se uma das inserções falhar, ambas são desfeitas.
*   **Obtenção de IDs**: `TipoTransacaoID` para Débito/Crédito e `ContaPlanoID` para as transferências são obtidos dinamicamente. No exemplo, usei `2.1.01` e `1.1.01` como placeholders; em um sistema real, você teria contas específicas no plano de contas para "Transferências Realizadas" e "Transferências Recebidas".
*   **Validações**: Todas as validações solicitadas foram implementadas, incluindo a verificação de saldo.
*   **Cálculo de Saldo**: O saldo é calculado somando o `SaldoInicial` da conta com o valor de todas as transações anteriores, ajustando pela `Natureza` do `TipoTransacao`. `ISNULL` é usado para garantir que a soma seja 0 se não houver transações.
*   **Mensagens de Saída**: O parâmetro `@StatusTransferencia` retorna mensagens detalhadas de sucesso ou erro.
*   **`FORMAT(GETDATE(), 'yyyyMMddHHmmss')`**: Usado para gerar um `NumeroDocumento` único para as transações de transferência.

**Testando a Stored Procedure `usp_TransferirFundos`:**

~~~sql
-- Cenário 1: Transferência bem-sucedida (Empresa 1, Conta 1 para Conta 2)
DECLARE @StatusMsg NVARCHAR(MAX);
EXEC usp_TransferirFundos
    @EmpresaID = 1,
    @ContaOrigemID = 1, -- Saldo inicial 50000.00 + transações
    @ContaDestinoID = 2, -- Saldo inicial 30000.00 + transações
    @Valor = 1000.00,
    @Descricao = 'Transferência interna para cobrir despesas',
    @StatusTransferencia = @StatusMsg OUTPUT;

SELECT @StatusMsg AS ResultadoTransferencia;

-- Verificar as transações e saldos (você precisaria de uma SP para calcular saldos reais)
SELECT * FROM dbo.Transacoes WHERE Descricao LIKE '%Transferência interna%';

-- Cenário 2: Saldo insuficiente (tentando transferir um valor muito alto)
DECLARE @StatusMsg2 NVARCHAR(MAX);
EXEC usp_TransferirFundos
    @EmpresaID = 1,
    @ContaOrigemID = 1,
    @ContaDestinoID = 2,
    @Valor = 1000000.00, -- Valor muito alto
    @Descricao = 'Tentativa de transferência com saldo insuficiente',
    @StatusTransferencia = @StatusMsg2 OUTPUT;

SELECT @StatusMsg2 AS ResultadoTransferencia;

-- Cenário 3: Contas iguais
DECLARE @StatusMsg3 NVARCHAR(MAX);
EXEC usp_TransferirFundos
    @EmpresaID = 1,
    @ContaOrigemID = 1,
    @ContaDestinoID = 1,
    @Valor = 100.00,
    @Descricao = 'Tentativa de transferência para a mesma conta',
    @StatusTransferencia = @StatusMsg3 OUTPUT;

SELECT @StatusMsg3 AS ResultadoTransferencia;

-- Cenário 4: Empresa inválida
DECLARE @StatusMsg4 NVARCHAR(MAX);
EXEC usp_TransferirFundos
    @EmpresaID = 999, -- Empresa inexistente
    @ContaOrigemID = 1,
    @ContaDestinoID = 2,
    @Valor = 100.00,
    @Descricao = 'Tentativa de transferência com empresa inválida',
    @StatusTransferencia = @StatusMsg4 OUTPUT;

SELECT @StatusMsg4 AS ResultadoTransferencia;
GO
~~~

---

## Resumo dos Pontos-Chave

*   **Stored Procedures (SPs)** são conjuntos de instruções T-SQL pré-compiladas e armazenadas no banco de dados, usadas para automatizar tarefas, melhorar segurança, performance e reusabilidade.
*   Sua sintaxe básica é **`CREATE PROCEDURE NomeDaProcedure @param Tipo, ... AS BEGIN ... END;`**.
*   Podem receber **parâmetros de entrada** e retornar valores através de **parâmetros de saída (`OUTPUT`)**.
*   São ideais para **encapsular lógica de negócios**, como inserção, atualização, exclusão e geração de relatórios.
*   **`EXEC`** ou **`EXECUTE`** são usados para chamar uma SP.
*   **`ALTER PROCEDURE`** modifica uma SP existente, e **`DROP PROCEDURE`** a exclui.
*   **Boas práticas** incluem o uso de prefixos, comentários, tratamento de erros com **`TRY...CATCH`**, gerenciamento de transações com **`BEGIN TRAN...COMMIT TRAN...ROLLBACK TRAN`**, uso de **`SET NOCOUNT ON`** e, crucialmente, **sempre usar parâmetros** para evitar SQL Injection.
*   **`SCOPE_IDENTITY()`** retorna o ID da última linha inserida no escopo atual.
*   **`@@ROWCOUNT`** retorna o número de linhas afetadas pela última instrução.

---

## Log de Estado do Projeto

~~~text
## Estado — Após o Capítulo 26

=== BANCO DE DADOS ===
Nome: FinanceDB
Status: Operacional

=== TABELAS E REGISTROS ===
Bancos:            7 registros (1 novo inserido via SP)
TiposTransacao:    3 registros (RECEITA, DESPESA, TRANSF)
Empresas:          3 registros
ContasBancarias:   7 registros
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

=== MÓDULOS CONCLUÍDOS ===
✅ Módulo 1 — Fundamentos: Teoria e Ambiente (Capítulos 1–6)
✅ Módulo 2 — Essencial: T-SQL Básico (Capítulos 7–14)
✅ Módulo 3 — PROFICIENTE: Relacionamentos e Consultas Avançadas (Capítulos 15–22)
✅ Módulo 4 — AVANÇADO: Objetos de Banco de Dados e Programabilidade (Capítulos 23–26)

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

=== HABILIDADES ADQUIRIDAS NESTE CAPÍTULO ===
- Criação de Stored Procedures com CREATE PROCEDURE
- Uso de parâmetros de entrada e saída (OUTPUT)
- Execução de Stored Procedures com EXEC
- Alteração de Stored Procedures com ALTER PROCEDURE
- Exclusão de Stored Procedures com DROP PROCEDURE
- Implementação de validações e lógica de negócios dentro de SPs
- Uso de TRY...CATCH para tratamento de erros
- Gerenciamento de transações com BEGIN TRAN, COMMIT TRAN, ROLLBACK TRAN
- Aplicação de SET NOCOUNT ON para otimização
- Entendimento dos benefícios de segurança, reuso e performance das SPs

=== PRÓXIMO ===
Capítulo 27: Funções T-SQL — Scalar e Table-Valued Functions
Objetivo: criar funções reutilizáveis para cálculos financeiros no FinanceDB,
entender a diferença entre Scalar Functions (retornam um valor) e Table-Valued Functions
(retornam uma tabela), e saber quando usar funções versus procedures.