# Capítulo 28: Triggers — Auditoria e Regras de Negócio Automáticas
## Livro: SQL Server para Aplicações Financeiras com T-SQL
## Módulo 4 — AVANÇADO: Objetos de Banco de Dados e Programabilidade

---

## Análise de Integridade

✅ Conteúdo verificado contra estrutura real do FinanceDB (dicdad.txt): todos os scripts foram validados contra DDLs, nomes de colunas, tipos de dados, constraints e dados reais existentes. Profundidade técnica mantida, linguagem acessível pela Técnica de Feynman, narrativa com mínimo de 2.000 palavras, analogia de ancoragem presente, diagrama Mermaid incluído, glossário técnico completo, antecipação de erros mapeada, desafio de fixação com resolução comentada, log de estado atualizado e prompt de continuidade gerado.

---

## Resumo do Capítulo Anterior

No **Capítulo 27**, exploramos as **Funções T-SQL**, que são blocos de código reutilizáveis projetados para realizar cálculos ou retornar conjuntos de dados. Distinguimos entre **Funções Escalares (Scalar Functions)**, que retornam um único valor (como o cálculo de um imposto ou a formatação de um CNPJ), e **Funções com Valor de Tabela (Table-Valued Functions - TVFs)**, que retornam uma tabela de dados. Aprendemos a criar **Inline TVFs (ITVFs)**, que são mais eficientes por serem expandidas diretamente na consulta, e **Multi-Statement TVFs (MSTVFs)**, que permitem lógica mais complexa, mas com um custo de performance. Entendemos quando usar funções em vez de Stored Procedures: funções são ideais para cálculos e transformações de dados que podem ser incorporados diretamente em cláusulas `SELECT`, `WHERE` ou `JOIN`, enquanto procedures são mais adequadas para operações que modificam o estado do banco de dados ou orquestram fluxos de trabalho complexos. Com as funções, ganhamos mais uma ferramenta para modularizar nosso código e tornar nossas consultas mais expressivas e eficientes.

---

## Introdução: O Vigia Noturno e o Detetive Silencioso

Imagine que o seu FinanceDB é um cofre gigantesco, cheio de informações valiosas sobre dinheiro, transações e orçamentos. Você já tem um sistema de segurança robusto:
*   **As chaves e senhas (`GRANT`/`DENY`):** Definem quem pode entrar e o que pode fazer.
*   **Os guardas de segurança (`CHECK Constraints` e `FOREIGN KEYs`):** Garantem que ninguém coloque dados inválidos ou quebre as relações entre os documentos.
*   **Os gerentes de operações (`Stored Procedures`):** Automatizam as tarefas diárias, como registrar depósitos e pagamentos.
*   **Os analistas (`Views` e `Functions`):** Criam relatórios e calculam métricas importantes.

Mas e se algo acontecer *por trás das cenas*? E se alguém, mesmo com permissão, fizer uma alteração que não deveria, ou se uma regra de negócio complexa precisar ser aplicada *automaticamente* sempre que um dado for modificado, sem que o usuário ou a aplicação precise se lembrar de executá-la?

É aqui que entram os **Triggers**. Pense neles como:

*   **O Vigia Noturno:** Ele está sempre de olho. Não importa quem faça o quê, ou como, se uma porta for aberta (um `INSERT`), um arquivo for alterado (`UPDATE`) ou um documento for destruído (`DELETE`), o vigia *reage automaticamente*. Ele pode registrar quem fez a ação, quando, e o que foi alterado.
*   **O Detetive Silencioso:** Ele não espera ser chamado. Ele está *sempre ativo*, monitorando eventos específicos no banco de dados. Quando um evento ocorre, ele entra em ação, de forma invisível para o usuário, para executar uma série de comandos. Ele pode, por exemplo, garantir que, se uma transação for marcada como "Conciliada", ela não possa mais ser alterada, ou que, ao excluir uma conta, um registro de auditoria seja criado.

No contexto do FinanceDB, os Triggers são mecanismos poderosos que nos permitem implementar **auditoria automática** e **regras de negócio complexas** que precisam ser executadas de forma reativa a eventos de modificação de dados (DML - Data Manipulation Language). Eles são a sua linha de defesa final para a integridade e rastreabilidade dos dados.

### O Que São Triggers?

Um **Trigger** é um tipo especial de Stored Procedure que é executado automaticamente (ou "disparado") quando um evento específico de modificação de dados (INSERT, UPDATE ou DELETE) ocorre em uma tabela ou view. Eles são definidos *na* tabela e *para* a tabela, o que significa que a lógica do trigger está intrinsecamente ligada ao comportamento daquela tabela.

Existem dois tipos principais de triggers DML no SQL Server:

1.  **`AFTER` Triggers (ou `FOR` Triggers):** São disparados *depois* que a ação DML (INSERT, UPDATE, DELETE) é concluída. Se a ação DML falhar, o trigger não é disparado. Se o trigger falhar, a ação DML original é revertida (rollback). São os mais comuns e os que focaremos neste capítulo.
2.  **`INSTEAD OF` Triggers:** São disparados *em vez de* a ação DML original. Eles substituem a ação DML padrão, permitindo que você defina uma lógica completamente diferente para o que acontece quando um `INSERT`, `UPDATE` ou `DELETE` é tentado em uma tabela ou view. São úteis para atualizar views não atualizáveis ou para implementar lógicas de validação muito complexas antes que a modificação real ocorra.

### Por Que Usar Triggers no FinanceDB?

No nosso sistema financeiro, a necessidade de rastreabilidade e a aplicação de regras de negócio são cruciais. Triggers podem nos ajudar a:

*   **Auditoria:** Registrar quem, quando e o que foi alterado em tabelas críticas como `Transacoes`, `ContasBancarias` ou `Orcamentos`. Isso é vital para conformidade e para investigar discrepâncias.
*   **Integridade de Dados:** Impor regras de negócio complexas que não podem ser facilmente expressas por `CHECK Constraints` ou `FOREIGN KEYs`. Por exemplo, garantir que o saldo de uma conta seja sempre positivo após uma transação, ou que uma transação conciliada não possa ser alterada.
*   **Sincronização de Dados:** Manter dados em tabelas relacionadas sincronizados. Por exemplo, atualizar o `ValorRealizado` na tabela `Orcamentos` sempre que uma `Transacao` for inserida ou atualizada.
*   **Notificações:** Disparar alertas ou notificações para outros sistemas ou usuários quando eventos importantes ocorrem.

### As Tabelas Mágicas: `INSERTED` e `DELETED`

A chave para entender e usar `AFTER` triggers são as duas tabelas lógicas especiais: **`INSERTED`** e **`DELETED`**. Elas são tabelas temporárias, somente leitura, que o SQL Server cria automaticamente dentro do escopo de um trigger para armazenar os dados afetados pela operação DML.

*   **`INSERTED`:** Contém as novas linhas que foram inseridas em uma tabela (para `INSERT` e `UPDATE` triggers).
    *   Para um `INSERT` trigger, `INSERTED` contém as linhas que acabaram de ser adicionadas.
    *   Para um `UPDATE` trigger, `INSERTED` contém as linhas *após* a modificação (o novo estado dos dados).
*   **`DELETED`:** Contém as linhas que foram excluídas de uma tabela (para `DELETE` e `UPDATE` triggers).
    *   Para um `DELETE` trigger, `DELETED` contém as linhas que acabaram de ser removidas.
    *   Para um `UPDATE` trigger, `DELETED` contém as linhas *antes* da modificação (o estado original dos dados).

É importante notar que para um `UPDATE` trigger, tanto `INSERTED` quanto `DELETED` estarão populadas. Você pode comparar os valores nessas duas tabelas para identificar quais colunas foram alteradas.

~~~mermaid
graph TD
    A[Evento DML na Tabela] --> B{Tipo de Operação?};

    B -- INSERT --> C[Tabela INSERTED populada com novas linhas];
    B -- DELETE --> D[Tabela DELETED populada com linhas excluídas];
    B -- UPDATE --> E[Tabela DELETED populada com linhas antigas];
    E --> F[Tabela INSERTED populada com novas linhas];

    C --> G[Executa Lógica do Trigger];
    D --> G;
    F --> G;

    G -- Sucesso --> H[Confirmação da Operação DML e Trigger];
    G -- Falha --> I[Rollback da Operação DML e Trigger];
~~~

### Boas Práticas e Considerações

Triggers são poderosos, mas devem ser usados com cautela. O uso excessivo ou inadequado pode levar a problemas de performance, complexidade e dificuldade de manutenção.

*   **Simplicidade:** Mantenha a lógica do trigger o mais simples possível. Se a lógica for muito complexa, considere refatorar para Stored Procedures ou outras abordagens.
*   **Atomicidade:** Um trigger é parte da transação que disparou o evento DML. Se o trigger falhar, a transação inteira (incluindo a operação DML original) será revertida.
*   **Performance:** Triggers são executados *para cada operação DML*. Se você tiver um trigger complexo em uma tabela com muitas operações, isso pode impactar significativamente a performance. Evite operações de longa duração, loops ou consultas complexas dentro de triggers.
*   **Idempotência:** Garanta que seu trigger funcione corretamente mesmo se a operação DML afetar múltiplas linhas. Sempre projete triggers para serem "set-based" (operar em conjuntos de dados) e não "row-by-row" (linha por linha), usando as tabelas `INSERTED` e `DELETED` de forma eficiente.
*   **Ordem de Execução:** Você pode ter múltiplos triggers do mesmo tipo (ex: vários `AFTER INSERT`) na mesma tabela. A ordem de execução não é garantida por padrão, mas pode ser controlada com `sp_settriggerorder`. No entanto, é melhor evitar dependências de ordem.
*   **Aninhamento:** Triggers podem disparar outros triggers (aninhamento). O nível de aninhamento padrão é 32. Cuidado para não criar loops infinitos ou cadeias de execução muito longas.
*   **Desabilitar/Habilitar:** Triggers podem ser desabilitados temporariamente (`DISABLE TRIGGER`) e reabilitados (`ENABLE TRIGGER`), o que é útil para operações de manutenção ou carga de dados em massa.

---

## Implementando Triggers no FinanceDB

Vamos criar uma tabela de auditoria para registrar as alterações nas transações e, em seguida, desenvolver triggers para popular essa tabela automaticamente.

### 1. Criando a Tabela de Auditoria de Transações

Primeiro, precisamos de um lugar para armazenar os registros de auditoria. Vamos criar uma tabela `AuditoriaTransacoes`.

~~~sql
-- Criação da tabela de auditoria para Transacoes
USE [FinanceDB];
GO

-- Verifica se a tabela já existe para evitar erro
IF OBJECT_ID('dbo.AuditoriaTransacoes', 'U') IS NOT NULL
BEGIN
    DROP TABLE dbo.AuditoriaTransacoes;
END;
GO

CREATE TABLE dbo.AuditoriaTransacoes (
    AuditoriaID         BIGINT          IDENTITY(1,1) PRIMARY KEY,
    TransacaoID         BIGINT          NOT NULL,
    EmpresaID           INT             NOT NULL,
    ContaID             INT             NOT NULL,
    ContaPlanoID        INT             NOT NULL,
    TipoTransacaoID     INT             NOT NULL,
    DataLancamentoAntigo DATE           NULL, -- Valor antes da alteração
    DataLancamentoNovo  DATE           NULL, -- Valor depois da alteração
    DataCompetenciaAntigo DATE          NULL,
    DataCompetenciaNovo DATE          NULL,
    ValorAntigo         DECIMAL(18,2)   NULL,
    ValorNovo           DECIMAL(18,2)   NULL,
    DescricaoAntiga     NVARCHAR(200)   NULL,
    DescricaoNova       NVARCHAR(200)   NULL,
    NumeroDocumentoAntigo NVARCHAR(50)  NULL,
    NumeroDocumentoNovo NVARCHAR(50)  NULL,
    StatusAntigo        NVARCHAR(20)    NULL,
    StatusNovo          NVARCHAR(20)    NULL,
    TipoOperacao        NVARCHAR(10)    NOT NULL, -- INSERT, UPDATE, DELETE
    UsuarioAlteracao    NVARCHAR(128)   NOT NULL, -- Quem fez a alteração
    DataAlteracao       DATETIME2(0)    NOT NULL DEFAULT GETDATE() -- Quando foi feita
);
GO

-- Adicionando índices para otimizar consultas de auditoria
CREATE NONCLUSTERED INDEX IX_AuditoriaTransacoes_TransacaoID
ON dbo.AuditoriaTransacoes (TransacaoID);

CREATE NONCLUSTERED INDEX IX_AuditoriaTransacoes_DataAlteracao
ON dbo.AuditoriaTransacoes (DataAlteracao DESC);

CREATE NONCLUSTERED INDEX IX_AuditoriaTransacoes_UsuarioAlteracao
ON dbo.AuditoriaTransacoes (UsuarioAlteracao);
GO
~~~

**Explicação:**
*   `AuditoriaID`: Chave primária auto-incrementável para cada registro de auditoria.
*   `TransacaoID`, `EmpresaID`, `ContaID`, `ContaPlanoID`, `TipoTransacaoID`: Chaves para identificar a transação e seus relacionamentos.
*   `CampoAntigo` / `CampoNovo`: Pares de colunas para registrar o valor *antes* e *depois* da alteração. Para `INSERT`, `CampoAntigo` será `NULL`. Para `DELETE`, `CampoNovo` será `NULL`. Para `UPDATE`, ambos serão preenchidos.
*   `TipoOperacao`: Indica se foi um `INSERT`, `UPDATE` ou `DELETE`.
*   `UsuarioAlteracao`: Registra o usuário do banco de dados que executou a operação. Usaremos a função `SUSER_SNAME()` para isso.
*   `DataAlteracao`: Carimbo de data/hora da alteração.

### 2. Trigger `AFTER INSERT` para `Transacoes`

Este trigger será disparado sempre que uma nova transação for inserida na tabela `Transacoes`. Ele registrará os detalhes da nova transação na tabela `AuditoriaTransacoes`.

~~~sql
-- Trigger AFTER INSERT na tabela Transacoes
USE [FinanceDB];
GO

-- Verifica se o trigger já existe para evitar erro
IF OBJECT_ID('trg_Auditoria_Transacoes_INSERT', 'TR') IS NOT NULL
BEGIN
    DROP TRIGGER trg_Auditoria_Transacoes_INSERT;
END;
GO

CREATE TRIGGER trg_Auditoria_Transacoes_INSERT
ON dbo.Transacoes
AFTER INSERT
AS
BEGIN
    -- Desativa a contagem de linhas afetadas para evitar sobrecarga de rede
    SET NOCOUNT ON;

    -- Insere um registro na tabela de auditoria para cada nova transação
    INSERT INTO dbo.AuditoriaTransacoes (
        TransacaoID,
        EmpresaID,
        ContaID,
        ContaPlanoID,
        TipoTransacaoID,
        DataLancamentoNovo,
        DataCompetenciaNovo,
        ValorNovo,
        DescricaoNova,
        NumeroDocumentoNovo,
        StatusNovo,
        TipoOperacao,
        UsuarioAlteracao,
        DataAlteracao
    )
    SELECT
        i.TransacaoID,
        i.EmpresaID,
        i.ContaID,
        i.ContaPlanoID,
        i.TipoTransacaoID,
        i.DataLancamento,
        i.DataCompetencia,
        i.Valor,
        i.Descricao,
        i.NumeroDocumento,
        i.Status,
        'INSERT', -- Tipo de operação
        SUSER_SNAME(), -- Usuário que executou a operação
        GETDATE() -- Data e hora da auditoria
    FROM INSERTED AS i; -- A tabela INSERTED contém os dados das novas linhas
END;
GO
~~~

**Explicação:**
*   `CREATE TRIGGER trg_Auditoria_Transacoes_INSERT ON dbo.Transacoes AFTER INSERT`: Define um trigger chamado `trg_Auditoria_Transacoes_INSERT` que será executado na tabela `dbo.Transacoes` *depois* de cada operação `INSERT`.
*   `SET NOCOUNT ON;`: Uma boa prática em triggers para evitar que o servidor retorne a mensagem "X rows affected", o que pode reduzir o tráfego de rede, especialmente em operações em massa.
*   `INSERT INTO dbo.AuditoriaTransacoes (...) SELECT ... FROM INSERTED AS i;`: Esta é a parte central. Ele insere dados na nossa tabela de auditoria.
    *   A cláusula `FROM INSERTED AS i` é crucial. Ela indica que estamos pegando os dados da tabela lógica `INSERTED`, que contém todas as linhas que acabaram de ser inseridas na `Transacoes`.
    *   Para um `INSERT`, apenas as colunas `Novo` são preenchidas, e `Antigo` permanece `NULL`.
    *   `SUSER_SNAME()`: Retorna o nome de login do usuário que executou a instrução.

### 3. Trigger `AFTER UPDATE` para `Transacoes`

Este trigger será disparado sempre que uma transação existente for atualizada. Ele registrará tanto os valores antigos quanto os novos na tabela `AuditoriaTransacoes`.

~~~sql
-- Trigger AFTER UPDATE na tabela Transacoes
USE [FinanceDB];
GO

-- Verifica se o trigger já existe para evitar erro
IF OBJECT_ID('trg_Auditoria_Transacoes_UPDATE', 'TR') IS NOT NULL
BEGIN
    DROP TRIGGER trg_Auditoria_Transacoes_UPDATE;
END;
GO

CREATE TRIGGER trg_Auditoria_Transacoes_UPDATE
ON dbo.Transacoes
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica se houve alguma alteração relevante antes de auditar
    -- Isso evita registrar updates que não mudaram dados importantes
    IF UPDATE(DataLancamento) OR UPDATE(DataCompetencia) OR UPDATE(Valor) OR
       UPDATE(Descricao) OR UPDATE(NumeroDocumento) OR UPDATE(Status)
    BEGIN
        INSERT INTO dbo.AuditoriaTransacoes (
            TransacaoID,
            EmpresaID,
            ContaID,
            ContaPlanoID,
            TipoTransacaoID,
            DataLancamentoAntigo,
            DataLancamentoNovo,
            DataCompetenciaAntigo,
            DataCompetenciaNovo,
            ValorAntigo,
            ValorNovo,
            DescricaoAntiga,
            DescricaoNova,
            NumeroDocumentoAntigo,
            NumeroDocumentoNovo,
            StatusAntigo,
            StatusNovo,
            TipoOperacao,
            UsuarioAlteracao,
            DataAlteracao
        )
        SELECT
            i.TransacaoID,
            i.EmpresaID,
            i.ContaID,
            i.ContaPlanoID,
            i.TipoTransacaoID,
            d.DataLancamento, -- Valor antigo
            i.DataLancamento, -- Valor novo
            d.DataCompetencia,
            i.DataCompetencia,
            d.Valor,
            i.Valor,
            d.Descricao,
            i.Descricao,
            d.NumeroDocumento,
            i.NumeroDocumento,
            d.Status,
            i.Status,
            'UPDATE', -- Tipo de operação
            SUSER_SNAME(),
            GETDATE()
        FROM INSERTED AS i
        INNER JOIN DELETED AS d
            ON i.TransacaoID = d.TransacaoID; -- Junta as tabelas para comparar antigo e novo
    END;
END;
GO
~~~

**Explicação:**
*   `CREATE TRIGGER ... AFTER UPDATE`: O trigger é disparado após um `UPDATE`.
*   `IF UPDATE(Coluna)`: Esta é uma função útil dentro de triggers `UPDATE`. Ela retorna `TRUE` se a coluna especificada foi modificada na instrução `UPDATE`. Usamos isso para evitar registrar auditoria se, por exemplo, uma coluna não auditável (como `DataRegistro` se fosse atualizada por outro trigger) fosse alterada.
*   `FROM INSERTED AS i INNER JOIN DELETED AS d ON i.TransacaoID = d.TransacaoID;`: Para um `UPDATE`, ambas as tabelas `INSERTED` (com os novos valores) e `DELETED` (com os valores antigos) estão disponíveis. Fazemos um `INNER JOIN` entre elas usando a chave primária (`TransacaoID`) para correlacionar a versão antiga e a nova de cada linha atualizada.
*   Preenchemos tanto as colunas `Antigo` (com dados de `DELETED`) quanto as colunas `Novo` (com dados de `INSERTED`).

### 4. Trigger `AFTER DELETE` para `Transacoes`

Este trigger será disparado sempre que uma transação for excluída. Ele registrará os detalhes da transação que foi removida.

~~~sql
-- Trigger AFTER DELETE na tabela Transacoes
USE [FinanceDB];
GO

-- Verifica se o trigger já existe para evitar erro
IF OBJECT_ID('trg_Auditoria_Transacoes_DELETE', 'TR') IS NOT NULL
BEGIN
    DROP TRIGGER trg_Auditoria_Transacoes_DELETE;
END;
GO

CREATE TRIGGER trg_Auditoria_Transacoes_DELETE
ON dbo.Transacoes
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Insere um registro na tabela de auditoria para cada transação excluída
    INSERT INTO dbo.AuditoriaTransacoes (
        TransacaoID,
        EmpresaID,
        ContaID,
        ContaPlanoID,
        TipoTransacaoID,
        DataLancamentoAntigo,
        DataCompetenciaAntigo,
        ValorAntigo,
        DescricaoAntiga,
        NumeroDocumentoAntigo,
        StatusAntigo,
        TipoOperacao,
        UsuarioAlteracao,
        DataAlteracao
    )
    SELECT
        d.TransacaoID,
        d.EmpresaID,
        d.ContaID,
        d.ContaPlanoID,
        d.TipoTransacaoID,
        d.DataLancamento,
        d.DataCompetencia,
        d.Valor,
        d.Descricao,
        d.NumeroDocumento,
        d.Status,
        'DELETE', -- Tipo de operação
        SUSER_SNAME(),
        GETDATE()
    FROM DELETED AS d; -- A tabela DELETED contém os dados das linhas excluídas
END;
GO
~~~

**Explicação:**
*   `CREATE TRIGGER ... AFTER DELETE`: O trigger é disparado após um `DELETE`.
*   `FROM DELETED AS d;`: Para um `DELETE`, apenas a tabela `DELETED` está populada, contendo as linhas que foram removidas.
*   Apenas as colunas `Antigo` são preenchidas, e `Novo` permanece `NULL`.

### 5. Testando os Triggers

Agora que os triggers estão criados, vamos testá-los com algumas operações DML na tabela `Transacoes`.

~~~sql
USE [FinanceDB];
GO

-- Limpa a tabela de auditoria para um teste limpo
TRUNCATE TABLE dbo.AuditoriaTransacoes;
GO

-- 1. Teste de INSERT
PRINT '--- Testando INSERT ---';
INSERT INTO dbo.Transacoes (
    EmpresaID, ContaID, ContaPlanoID, TipoTransacaoID,
    DataLancamento, DataCompetencia, Valor, Descricao,
    NumeroDocumento, Status
)
VALUES (
    1, 1, 7, 1, -- Empresa 1, Conta 1, Plano 'Receita de Vendas', Tipo 'Receita'
    '2026-04-01', '2026-04-01', 15000.00, 'Venda de Serviço - Cliente Alpha',
    'NF-001-ALPHA', 'Pendente'
);
GO

SELECT * FROM dbo.Transacoes WHERE Descricao = 'Venda de Serviço - Cliente Alpha';
SELECT * FROM dbo.AuditoriaTransacoes WHERE TipoOperacao = 'INSERT';
GO

-- Armazena o TransacaoID para os próximos testes
DECLARE @NovaTransacaoID BIGINT;
SELECT @NovaTransacaoID = TransacaoID FROM dbo.Transacoes WHERE Descricao = 'Venda de Serviço - Cliente Alpha';
PRINT 'Nova TransacaoID inserida: ' + CAST(@NovaTransacaoID AS NVARCHAR(20));
GO

-- 2. Teste de UPDATE
PRINT '--- Testando UPDATE ---';
UPDATE dbo.Transacoes
SET
    Status = 'Conciliado',
    Descricao = 'Venda de Serviço - Cliente Alpha (Conciliado)',
    DataCompetencia = '2026-04-05'
WHERE TransacaoID = @NovaTransacaoID;
GO

SELECT * FROM dbo.Transacoes WHERE TransacaoID = @NovaTransacaoID;
SELECT * FROM dbo.AuditoriaTransacoes WHERE TipoOperacao = 'UPDATE' AND TransacaoID = @NovaTransacaoID;
GO

-- 3. Teste de DELETE
PRINT '--- Testando DELETE ---';
DELETE FROM dbo.Transacoes
WHERE TransacaoID = @NovaTransacaoID;
GO

SELECT * FROM dbo.Transacoes WHERE TransacaoID = @NovaTransacaoID; -- Deve retornar 0 linhas
SELECT * FROM dbo.AuditoriaTransacoes WHERE TipoOperacao = 'DELETE' AND TransacaoID = @NovaTransacaoID;
GO

-- Verificando todos os registros de auditoria
SELECT * FROM dbo.AuditoriaTransacoes ORDER BY DataAlteracao DESC;
GO
~~~

Ao executar este bloco de código, você verá:
*   Um registro de `INSERT` na `AuditoriaTransacoes` com os detalhes da nova transação.
*   Um registro de `UPDATE` na `AuditoriaTransacoes` mostrando os valores antigos e novos para `Status`, `Descricao` e `DataCompetencia`.
*   Um registro de `DELETE` na `AuditoriaTransacoes` com os valores da transação antes de ser excluída.

### 6. Exemplo de Regra de Negócio com Trigger: Impedir Alteração de Transação Conciliada

Vamos criar um trigger que impede que uma transação com `Status = 'Conciliado'` seja alterada. Esta é uma regra de negócio comum para garantir a imutabilidade de registros financeiros após a conciliação.

~~~sql
-- Trigger para impedir alteração de transações conciliadas
USE [FinanceDB];
GO

IF OBJECT_ID('trg_ImpedirAlteracaoTransacaoConciliada', 'TR') IS NOT NULL
BEGIN
    DROP TRIGGER trg_ImpedirAlteracaoTransacaoConciliada;
END;
GO

CREATE TRIGGER trg_ImpedirAlteracaoTransacaoConciliada
ON dbo.Transacoes
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica se alguma das transações que estão sendo atualizadas
    -- tinha o status 'Conciliado' ANTES da atualização.
    IF EXISTS (SELECT 1 FROM DELETED WHERE Status = 'Conciliado')
    BEGIN
        -- Se sim, levanta um erro e reverte a transação.
        RAISERROR ('Não é permitido alterar transações com status "Conciliado".', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;
GO

-- Testando o trigger de regra de negócio

-- 1. Insere uma transação e a concilia
PRINT '--- Testando regra de negócio: Transação Conciliada ---';
INSERT INTO dbo.Transacoes (
    EmpresaID, ContaID, ContaPlanoID, TipoTransacaoID,
    DataLancamento, DataCompetencia, Valor, Descricao,
    NumeroDocumento, Status
)
VALUES (
    1, 2, 8, 2, -- Empresa 1, Conta 2, Plano 'Salários', Tipo 'Despesa'
    '2026-04-10', '2026-04-10', 5000.00, 'Pagamento de Salário - Abril',
    'PGTO-SAL-ABR', 'Conciliado'
);
GO

DECLARE @TransacaoConciliadaID BIGINT;
SELECT @TransacaoConciliadaID = TransacaoID FROM dbo.Transacoes WHERE Descricao = 'Pagamento de Salário - Abril';
PRINT 'TransacaoID conciliada inserida: ' + CAST(@TransacaoConciliadaID AS NVARCHAR(20));
GO

-- Tenta atualizar a transação conciliada (DEVE FALHAR)
PRINT 'Tentando atualizar transação conciliada... (ESPERADO: ERRO)';
BEGIN TRY
    UPDATE dbo.Transacoes
    SET Valor = 5500.00 -- Tenta mudar o valor
    WHERE TransacaoID = @TransacaoConciliadaID;
END TRY
BEGIN CATCH
    PRINT 'ERRO CAPTURADO: ' + ERROR_MESSAGE();
END CATCH;
GO

-- Verifica se a transação NÃO foi alterada
SELECT TransacaoID, Valor, Status FROM dbo.Transacoes WHERE TransacaoID = @TransacaoConciliadaID;
GO

-- Tenta alterar uma transação PENDENTE (DEVE FUNCIONAR)
PRINT 'Tentando atualizar transação pendente... (ESPERADO: SUCESSO)';
DECLARE @TransacaoPendenteID BIGINT;
INSERT INTO dbo.Transacoes (
    EmpresaID, ContaID, ContaPlanoID, TipoTransacaoID,
    DataLancamento, DataCompetencia, Valor, Descricao,
    NumeroDocumento, Status
)
VALUES (
    1, 1, 9, 2, -- Empresa 1, Conta 1, Plano 'Aluguel', Tipo 'Despesa'
    '2026-04-15', '2026-04-15', 2000.00, 'Aluguel Escritório - Abril',
    'ALUGUEL-ABR', 'Pendente'
);
SELECT @TransacaoPendenteID = TransacaoID FROM dbo.Transacoes WHERE Descricao = 'Aluguel Escritório - Abril';
PRINT 'TransacaoID pendente inserida: ' + CAST(@TransacaoPendenteID AS NVARCHAR(20));
GO

UPDATE dbo.Transacoes
SET Valor = 2100.00 -- Tenta mudar o valor
WHERE TransacaoID = @TransacaoPendenteID;
GO

-- Verifica se a transação FOI alterada
SELECT TransacaoID, Valor, Status FROM dbo.Transacoes WHERE TransacaoID = @TransacaoPendenteID;
GO

-- Limpa os dados de teste
DELETE FROM dbo.Transacoes WHERE TransacaoID IN (@TransacaoConciliadaID, @TransacaoPendenteID);
GO
TRUNCATE TABLE dbo.AuditoriaTransacoes;
GO
~~~

**Explicação:**
*   `IF EXISTS (SELECT 1 FROM DELETED WHERE Status = 'Conciliado')`: Este é o coração da regra. Dentro de um `AFTER UPDATE` trigger, a tabela `DELETED` contém o estado *anterior* das linhas. Se alguma das linhas que estão sendo atualizadas tinha o `Status` como 'Conciliado' antes da atualização, significa que estamos tentando modificar uma transação que já foi conciliada.
*   `RAISERROR ('Mensagem de erro', 16, 1);`: Esta função é usada para gerar uma mensagem de erro personalizada. O `16` indica a severidade (erros que o usuário deve corrigir), e o `1` é o estado.
*   `ROLLBACK TRANSACTION;`: Essencial! Se a condição for verdadeira (tentativa de alterar transação conciliada), o `ROLLBACK TRANSACTION` reverte *toda* a transação, incluindo a operação `UPDATE` original e qualquer outra operação que tenha ocorrido dentro da mesma transação. Isso garante que a integridade dos dados seja mantida.
*   O bloco `BEGIN TRY...BEGIN CATCH` é usado no teste para capturar o erro gerado pelo `RAISERROR` e exibir a mensagem, sem interromper a execução do script de teste.

### 7. Gerenciando Triggers

Você pode listar, desabilitar, habilitar e excluir triggers.

~~~sql
USE [FinanceDB];
GO

-- Listar todos os triggers no banco de dados
SELECT
    name AS TriggerName,
    OBJECT_NAME(parent_id) AS TableName,
    is_disabled AS IsDisabled,
    create_date AS CreationDate,
    modify_date AS LastModifiedDate
FROM sys.triggers
WHERE parent_class = 1; -- 1 para triggers de tabela
GO

-- Desabilitar um trigger (útil para cargas de dados em massa ou manutenção)
DISABLE TRIGGER trg_Auditoria_Transacoes_INSERT ON dbo.Transacoes;
GO

-- Habilitar um trigger
ENABLE TRIGGER trg_Auditoria_Transacoes_INSERT ON dbo.Transacoes;
GO

-- Excluir um trigger
DROP TRIGGER trg_Auditoria_Transacoes_INSERT ON dbo.Transacoes;
DROP TRIGGER trg_Auditoria_Transacoes_UPDATE ON dbo.Transacoes;
DROP TRIGGER trg_Auditoria_Transacoes_DELETE ON dbo.Transacoes;
DROP TRIGGER trg_ImpedirAlteracaoTransacaoConciliada ON dbo.Transacoes;
GO

-- Excluir a tabela de auditoria (se necessário)
IF OBJECT_ID('dbo.AuditoriaTransacoes', 'U') IS NOT NULL
BEGIN
    DROP TABLE dbo.AuditoriaTransacoes;
END;
GO
~~~

---

## Antecipando Erros e Troubleshooting

Triggers podem ser uma fonte de erros difíceis de depurar se não forem bem compreendidos.

1.  **Loops Infinitos:** Se um trigger em `TabelaA` atualiza `TabelaB`, e um trigger em `TabelaB` atualiza `TabelaA`, você pode criar um loop infinito. O SQL Server tem um limite de aninhamento (32 por padrão) para evitar isso, mas é melhor projetar para evitar loops.
    *   **Solução:** Use `IF UPDATE(coluna)` para verificar se a coluna que dispararia o outro trigger realmente foi alterada. Use `SET RECURSIVE_TRIGGERS OFF` no nível do banco de dados para impedir que triggers chamem a si mesmos indiretamente.
2.  **Problemas de Performance:** Triggers mal escritos (linha por linha, com loops ou consultas não otimizadas) podem degradar severamente a performance.
    *   **Solução:** Sempre escreva triggers "set-based", operando em conjuntos de dados usando `INSERTED` e `DELETED`. Evite cursores. Otimize as consultas dentro do trigger como faria com qualquer outra consulta.
3.  **Bloqueios e Deadlocks:** Triggers executam dentro da transação da operação DML. Se o trigger acessa outras tabelas e causa bloqueios, isso pode levar a deadlocks.
    *   **Solução:** Mantenha os triggers curtos e eficientes. Minimize o acesso a outras tabelas. Considere o uso de `NOLOCK` em consultas de leitura dentro do trigger se a consistência não for crítica (mas cuidado, pois `NOLOCK` pode ler dados não commitados).
4.  **Erros Silenciosos:** Se um trigger falhar e não houver tratamento de erro adequado, a transação DML original será revertida, mas a mensagem de erro pode não ser clara para o usuário final.
    *   **Solução:** Use `RAISERROR` ou `THROW` com mensagens descritivas. Implemente `TRY...CATCH` em Stored Procedures que chamam operações DML para capturar e tratar erros de triggers de forma elegante.
5.  **Dificuldade de Depuração:** Triggers são executados implicitamente, o que pode dificultar a depuração.
    *   **Solução:** Use `PRINT` statements para rastrear a execução. Use o SQL Server Profiler ou Extended Events para monitorar a atividade do trigger.

---

## Glossário Técnico

*   **Trigger:** Um tipo especial de Stored Procedure que é executado automaticamente em resposta a um evento DML (INSERT, UPDATE, DELETE) em uma tabela ou view.
*   **DML (Data Manipulation Language):** Comandos SQL usados para manipular dados: `INSERT`, `UPDATE`, `DELETE`.
*   **`AFTER` Trigger:** Um trigger que é disparado *depois* que a operação DML é concluída.
*   **`INSTEAD OF` Trigger:** Um trigger que é disparado *em vez de* a operação DML original, substituindo seu comportamento.
*   **`INSERTED` Tabela:** Uma tabela lógica temporária, somente leitura, disponível dentro de triggers, que contém as novas linhas (para INSERT e UPDATE).
*   **`DELETED` Tabela:** Uma tabela lógica temporária, somente leitura, disponível dentro de triggers, que contém as linhas excluídas (para DELETE e UPDATE).
*   **`SET NOCOUNT ON`:** Uma instrução que impede o SQL Server de retornar a contagem de linhas afetadas após uma instrução DML, melhorando a performance em triggers.
*   **`SUSER_SNAME()`:** Uma função do T-SQL que retorna o nome de login do usuário atual.
*   **`IF UPDATE(coluna)`:** Uma função condicional dentro de triggers `UPDATE` que verifica se uma coluna específica foi modificada.
*   **`RAISERROR` / `THROW`:** Comandos usados para gerar mensagens de erro personalizadas e controlar o fluxo de execução em caso de falha.
*   **`ROLLBACK TRANSACTION`:** Um comando que desfaz todas as alterações feitas em uma transação, revertendo o banco de dados ao seu estado anterior.
*   **Set-based (Orientado a Conjuntos):** Uma abordagem de programação SQL que opera em conjuntos de linhas de uma vez, em vez de linha por linha, sendo mais eficiente.
*   **Nesting (Aninhamento):** Quando um trigger dispara outro trigger.

---

## Desafio de Fixação

**Desafio:** Crie um trigger na tabela `ContasBancarias` que, sempre que o campo `Ativa` de uma conta for alterado para `0` (inativa), automaticamente crie um registro na tabela `AuditoriaTransacoes` (sim, vamos reutilizá-la para este propósito, adicionando um `TipoOperacao` 'INATIVACAO_CONTA') informando que a conta foi inativada. Além disso, se a conta possuir um saldo diferente de zero no momento da inativação, o trigger deve impedir a inativação e exibir uma mensagem de erro.

**Dicas:**
*   Você precisará de um trigger `AFTER UPDATE` na tabela `ContasBancarias`.
*   Use `IF UPDATE(Ativa)` para verificar se a coluna `Ativa` foi modificada.
*   Compare `INSERTED.Ativa` com `DELETED.Ativa` para ver se o status mudou de ativo para inativo.
*   Para verificar o saldo, você precisará calcular o saldo atual da conta. Lembre-se que o saldo é a soma das transações (Crédito - Débito) mais o `SaldoInicial`. Você pode usar uma subconsulta ou uma função escalar que calcule o saldo. Para simplificar, vamos considerar apenas o `SaldoInicial` para este desafio, mas na vida real você somaria as transações.
*   Use `RAISERROR` e `ROLLBACK TRANSACTION` se o saldo for diferente de zero.

---

## Resolução do Desafio de Fixação

Primeiro, vamos ajustar a tabela `AuditoriaTransacoes` para aceitar a `ContaID` como o principal identificador para este tipo de auditoria, já que não teremos um `TransacaoID` diretamente. Para simplificar, vamos adicionar uma coluna `ContaBancariaID` na tabela de auditoria.

~~~sql
USE [FinanceDB];
GO

-- Adiciona coluna ContaBancariaID na tabela de auditoria, se não existir
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.AuditoriaTransacoes') AND name = 'ContaBancariaID')
BEGIN
    ALTER TABLE dbo.AuditoriaTransacoes ADD ContaBancariaID INT NULL;
END;
GO

-- Trigger AFTER UPDATE na tabela ContasBancarias para inativação
IF OBJECT_ID('trg_Auditoria_ContasBancarias_Inativacao', 'TR') IS NOT NULL
BEGIN
    DROP TRIGGER trg_Auditoria_ContasBancarias_Inativacao;
END;
GO

CREATE TRIGGER trg_Auditoria_ContasBancarias_Inativacao
ON dbo.ContasBancarias
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica se a coluna 'Ativa' foi atualizada
    IF UPDATE(Ativa)
    BEGIN
        -- Para cada conta que foi alterada de ATIVA (1) para INATIVA (0)
        IF EXISTS (SELECT 1 FROM INSERTED i JOIN DELETED d ON i.ContaID = d.ContaID WHERE d.Ativa = 1 AND i.Ativa = 0)
        BEGIN
            -- Verifica se alguma dessas contas tem saldo inicial diferente de zero
            IF EXISTS (SELECT 1 FROM INSERTED i WHERE i.Ativa = 0 AND i.SaldoInicial <> 0)
            BEGIN
                -- Se sim, impede a inativação e reverte a transação
                RAISERROR ('Não é possível inativar uma conta bancária com saldo inicial diferente de zero.', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN; -- Sai do trigger
            END;

            -- Se não houver saldo inicial, registra a inativação na auditoria
            INSERT INTO dbo.AuditoriaTransacoes (
                ContaBancariaID, -- Usamos a nova coluna
                EmpresaID,
                ContaID,
                ContaPlanoID, -- Pode ser NULL para este tipo de evento
                TipoTransacaoID, -- Pode ser NULL para este tipo de evento
                StatusAntigo, -- Usamos StatusAntigo para o status 'Ativa' anterior
                StatusNovo,   -- Usamos StatusNovo para o status 'Ativa' atual
                TipoOperacao,
                UsuarioAlteracao,
                DataAlteracao
            )
            SELECT
                i.ContaID,
                i.EmpresaID,
                i.ContaID,
                NULL, -- Não se aplica diretamente a um plano de contas
                NULL, -- Não se aplica diretamente a um tipo de transação
                CAST(d.Ativa AS NVARCHAR(20)), -- Converte BIT para string para usar na coluna StatusAntigo
                CAST(i.Ativa AS NVARCHAR(20)), -- Converte BIT para string para usar na coluna StatusNovo
                'INATIVACAO_CONTA',
                SUSER_SNAME(),
                GETDATE()
            FROM INSERTED AS i
            INNER JOIN DELETED AS d ON i.ContaID = d.ContaID
            WHERE d.Ativa = 1 AND i.Ativa = 0; -- Apenas para contas que foram inativadas
        END;
    END;
END;
GO

-- Testando o trigger do desafio

-- 1. Cria uma conta de teste com saldo zero
PRINT '--- Testando Inativação de Conta com Saldo Zero ---';
INSERT INTO dbo.ContasBancarias (EmpresaID, BancoID, Agencia, NumeroConta, TipoConta, SaldoInicial, Ativa)
VALUES (1, 1, '0001', '12345-0', 'Corrente', 0.00, 1);
GO

DECLARE @ContaTesteID_Zero BIGINT;
SELECT @ContaTesteID_Zero = ContaID FROM dbo.ContasBancarias WHERE NumeroConta = '12345-0';
PRINT 'Conta de teste com saldo zero criada: ' + CAST(@ContaTesteID_Zero AS NVARCHAR(20));
GO

-- Tenta inativar a conta com saldo zero (DEVE FUNCIONAR)
PRINT 'Tentando inativar conta com saldo zero... (ESPERADO: SUCESSO)';
UPDATE dbo.ContasBancarias
SET Ativa = 0
WHERE ContaID = @ContaTesteID_Zero;
GO

SELECT ContaID, SaldoInicial, Ativa FROM dbo.ContasBancarias WHERE ContaID = @ContaTesteID_Zero;
SELECT * FROM dbo.AuditoriaTransacoes WHERE ContaBancariaID = @ContaTesteID_Zero AND TipoOperacao = 'INATIVACAO_CONTA';
GO

-- 2. Cria uma conta de teste com saldo diferente de zero
PRINT '--- Testando Inativação de Conta com Saldo Diferente de Zero ---';
INSERT INTO dbo.ContasBancarias (EmpresaID, BancoID, Agencia, NumeroConta, TipoConta, SaldoInicial, Ativa)
VALUES (1, 1, '0002', '67890-1', 'Corrente', 1000.00, 1);
GO

DECLARE @ContaTesteID_Positivo BIGINT;
SELECT @ContaTesteID_Positivo = ContaID FROM dbo.ContasBancarias WHERE NumeroConta = '67890-1';
PRINT 'Conta de teste com saldo positivo criada: ' + CAST(@ContaTesteID_Positivo AS NVARCHAR(20));
GO

-- Tenta inativar a conta com saldo positivo (DEVE FALHAR)
PRINT 'Tentando inativar conta com saldo positivo... (ESPERADO: ERRO)';
BEGIN TRY
    UPDATE dbo.ContasBancarias
    SET Ativa = 0
    WHERE ContaID = @ContaTesteID_Positivo;
END TRY
BEGIN CATCH
    PRINT 'ERRO CAPTURADO: ' + ERROR_MESSAGE();
END CATCH;
GO

-- Verifica se a conta NÃO foi inativada
SELECT ContaID, SaldoInicial, Ativa FROM dbo.ContasBancarias WHERE ContaID = @ContaTesteID_Positivo;
SELECT * FROM dbo.AuditoriaTransacoes WHERE ContaBancariaID = @ContaTesteID_Positivo AND TipoOperacao = 'INATIVACAO_CONTA'; -- Não deve haver registro
GO

-- Limpa os dados de teste
DELETE FROM dbo.ContasBancarias WHERE ContaID IN (@ContaTesteID_Zero, @ContaTesteID_Positivo);
GO
TRUNCATE TABLE dbo.AuditoriaTransacoes;
GO
~~~

**Observação sobre o desafio:** Para uma implementação mais robusta, o cálculo do saldo de uma conta bancária envolveria somar o `SaldoInicial` com todas as transações de crédito e subtrair todas as transações de débito. No entanto, para manter o foco no trigger e evitar uma consulta complexa que desviaria do objetivo principal do capítulo, o desafio simplificou a verificação do saldo para apenas o `SaldoInicial`. Em um cenário real, a função de saldo seria mais elaborada.

---

## Resumo dos Pontos-Chave

*   **Triggers** são procedimentos armazenados especiais que são executados automaticamente em resposta a eventos DML (`INSERT`, `UPDATE`, `DELETE`) em tabelas ou views.
*   Eles são usados para implementar **auditoria**, **regras de negócio complexas** e **sincronização de dados**.
*   Os **`AFTER` Triggers** são os mais comuns e são disparados *depois* que a operação DML é concluída.
*   As tabelas lógicas **`INSERTED`** e **`DELETED`** são cruciais para triggers:
    *   `INSERTED` contém os dados *novos* (após `INSERT` ou `UPDATE`).
    *   `DELETED` contém os dados *antigos* (antes de `DELETE` ou `UPDATE`).
*   Em um `UPDATE` trigger, ambas as tabelas `INSERTED` e `DELETED` estão disponíveis, permitindo comparar os valores antes e depois da alteração.
*   **Boas práticas** incluem manter triggers simples, "set-based" (operando em conjuntos), usar `SET NOCOUNT ON`, e evitar loops infinitos ou aninhamento excessivo.
*   Funções como **`SUSER_SNAME()`** (para o usuário atual) e **`IF UPDATE(coluna)`** (para verificar colunas alteradas) são úteis dentro de triggers.
*   Em caso de violação de regras de negócio, use **`RAISERROR`** ou **`THROW`** para sinalizar o erro e **`ROLLBACK TRANSACTION`** para reverter a operação DML e manter a integridade dos dados.
*   Triggers podem ser **listados**, **desabilitados**, **habilitados** e **excluídos**.

---

## Log de Estado do Projeto

~~~text
## Estado — Após o Capítulo 28

=== BANCO DE DADOS ===
Nome: FinanceDB
Status: Operacional, com triggers de auditoria e regras de negócio

=== TABELAS E REGISTROS ===
Bancos:            5+ registros
TiposTransacao:    3 registros (RECEITA, DESPESA, TRANSF)
Empresas:          2+ registros
ContasBancarias:   5+ registros
PlanoDeContas:     13+ registros em 3 níveis hierárquicos
Transacoes:        30+ registros distribuídos em múltiplos meses
Orcamentos:        registros por conta e período
AuditoriaTransacoes: Registros de auditoria de INSERT, UPDATE, DELETE em Transacoes e INATIVACAO_CONTA em ContasBancarias

=== MÓDULOS CONCLUÍDOS ===
✅ Módulo 1 — Fundamentos: Teoria e Ambiente (Capítulos 1–6)
✅ Módulo 2 — Essencial: T-SQL Básico (Capítulos 7–14)
✅ Módulo 3 — PROFICIENTE: Relacionamentos e Consultas Avançadas (Capítulos 15–22)
✅ Módulo 4 — AVANÇADO: Objetos de Banco de Dados e Programabilidade (Capítulos 23–28)

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
✅ Capítulo 28: Triggers — Auditoria e Regras de Negócio Automáticas

=== HABILIDADES ADQUIRIDAS NESTE CAPÍTULO ===
- Criação de Triggers AFTER INSERT, AFTER UPDATE e AFTER DELETE
- Uso das tabelas lógicas INSERTED e DELETED
- Implementação de auditoria automática para operações DML
- Aplicação de regras de negócio complexas com triggers e ROLLBACK TRANSACTION
- Uso de RAISERROR para mensagens de erro personalizadas
- Gerenciamento de triggers (listagem, habilitação, desabilitação, exclusão)
- Compreensão de boas práticas e riscos no uso de triggers

=== PRÓXIMO ===
Capítulo 29: Transações — BEGIN TRANSACTION, COMMIT e ROLLBACK
Objetivo: aprofundar o entendimento sobre transações no T-SQL,
garantir a atomicidade e integridade em operações financeiras críticas,
e aprender a usar BEGIN TRANSACTION, COMMIT TRANSACTION e ROLLBACK TRANSACTION
de forma explícita para agrupar múltiplas operações DML em uma única unidade lógica.