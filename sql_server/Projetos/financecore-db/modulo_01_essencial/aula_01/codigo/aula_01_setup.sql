-- ============================================================
-- FinanceCore DB — Aula 01
-- Script: aula_01_setup.sql
-- Objetivo: Validar o ambiente e explorar configurações da instância
-- Autor: FinanceCore DB
-- Data: Aula 01 — Módulo 1
-- ============================================================

-- -------------------------------------------------------
-- BLOCO 1: Validação da versão do SQL Server
-- Confirma que estamos na versão correta (2017 = versão 14.x)
-- -------------------------------------------------------

-- Exibe a versão completa do SQL Server instalado
SELECT @@VERSION AS VersaoCompleta;

-- Exibe apenas o número de versão principal
-- SQL Server 2017 retorna 14.x.x.x
SELECT SERVERPROPERTY('ProductVersion') AS NumeroVersao,
       SERVERPROPERTY('ProductLevel')   AS NivelServicoPack,
       SERVERPROPERTY('Edition')        AS Edicao;

-- -------------------------------------------------------
-- BLOCO 2: Configurações da instância
-- Explora as configurações do servidor que afetam o comportamento
-- do SQL Server e que precisamos conhecer para o FinanceCore DB
-- -------------------------------------------------------

-- Lista as configurações do servidor (sp_configure mostra todas as opções)
-- 'show advanced options' = 1 é necessário para ver opções avançadas
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;

-- Exibe as configurações mais relevantes para sistemas financeiros
EXEC sp_configure;

-- Configuração de memória máxima do servidor (em MB)
-- Em produção financeira, reservamos sempre ao menos 4 GB para o SO
-- e destinamos o restante ao SQL Server
SELECT name, value_in_use
FROM sys.configurations
WHERE name IN (
    'max server memory (MB)',   -- Memória máxima do Buffer Pool
    'min server memory (MB)',   -- Memória mínima garantida
    'max degree of parallelism',-- MAXDOP: paralelismo de queries
    'cost threshold for parallelism', -- Quando paralelismo é acionado
    'optimize for ad hoc workloads'   -- Otimização para workloads variados
);

-- -------------------------------------------------------
-- BLOCO 3: Informações sobre a instância atual
-- -------------------------------------------------------

-- Nome do servidor e da instância
SELECT
    SERVERPROPERTY('MachineName')    AS NomeMaquina,        -- Nome do Windows
    SERVERPROPERTY('ServerName')     AS NomeInstancia,      -- Nome completo da instância
    SERVERPROPERTY('InstanceName')   AS NomeInstanciaSQL,   -- NULL = instância padrão
    SERVERPROPERTY('IsClustered')    AS EhCluster,          -- 0 = standalone (nosso caso)
    SERVERPROPERTY('Collation')      AS Collation;          -- Conjunto de caracteres padrão

-- -------------------------------------------------------
-- BLOCO 4: Bancos de dados existentes na instância
-- Verifica os bancos de sistema que todo SQL Server possui
-- -------------------------------------------------------

-- Lista todos os bancos de dados com seu estado e modelo de recuperação
SELECT
    name                AS NomeBanco,
    database_id         AS ID,
    state_desc          AS Estado,          -- ONLINE, OFFLINE, RESTORING, etc.
    recovery_model_desc AS ModeloRecuperacao, -- SIMPLE, FULL, BULK_LOGGED
    create_date         AS DataCriacao,
    compatibility_level AS NivelCompatibilidade -- 140 = SQL Server 2017
FROM sys.databases
ORDER BY database_id;

-- -------------------------------------------------------
-- BLOCO 5: Verificação do Transaction Log e Checkpoints
-- -------------------------------------------------------

-- Verifica o status do log de transações de cada banco
-- log_reuse_wait_desc indica o que está impedindo a reutilização do log
DBCC SQLPERF(LOGSPACE);

-- -------------------------------------------------------
-- BLOCO 6: Informações sobre os arquivos físicos da instância
-- -------------------------------------------------------

-- Lista os arquivos físicos de cada banco de dados
-- Útil para confirmar onde os arquivos .mdf e .ldf estão salvos
SELECT
    DB_NAME(database_id) AS NomeBanco,
    name                 AS NomeLogico,
    physical_name        AS CaminhoFisico,
    type_desc            AS TipoArquivo,    -- ROWS (dados) ou LOG (log)
    size * 8 / 1024      AS TamanhoMB       -- Tamanho em MB (size está em páginas de 8KB)
FROM sys.master_files
ORDER BY database_id, type_desc;

-- -------------------------------------------------------
-- BLOCO 7: Mensagem de confirmação do ambiente
-- -------------------------------------------------------

-- PRINT envia mensagem para a aba Messages do SSMS
-- Útil para confirmações e diagnósticos durante desenvolvimento
PRINT '============================================';
PRINT 'Ambiente FinanceCore DB validado com sucesso';
PRINT 'SQL Server 2017 — Pronto para o Módulo 1';
PRINT '============================================';

-- Retorna a data e hora atual do servidor
-- Em sistemas financeiros, sempre use SYSDATETIME() para precisão máxima
-- em vez de GETDATE() (que retorna apenas milissegundos, não nanossegundos)
SELECT
    GETDATE()       AS DataHoraServidor_Padrao,
    SYSDATETIME()   AS DataHoraServidor_AltaPrecisao,
    GETUTCDATE()    AS DataHoraUTC;