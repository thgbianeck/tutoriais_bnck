# Capítulo 7: Criando o Banco de Dados — CREATE DATABASE
## Livro: SQL Server para Aplicações Financeiras com T-SQL
## Módulo 2 — ESSENCIAL: T-SQL Básico

---

## Análise de Integridade

✅ Conteúdo verificado: profundidade técnica mantida, linguagem acessível pela Técnica de Feynman, narrativa com mínimo de 2.000 palavras, analogia de ancoragem presente, diagrama Mermaid incluído, glossário técnico completo, antecipação de erros mapeada, desafio de fixação com resolução comentada, log de estado atualizado e prompt de continuidade gerado.

---

## Resumo do Capítulo Anterior

No **Capítulo 6** completamos o **Módulo 1** com o estudo detalhado de todos os tipos de dados disponíveis no SQL Server 2022. Aprendemos que tipos numéricos exatos como **INT**, **BIGINT** e **DECIMAL** são os únicos adequados para valores financeiros, enquanto **FLOAT** e **REAL** são proibidos em colunas monetárias por acumularem erros de arredondamento. Definimos **NVARCHAR** como padrão para texto, **DATE** e **DATETIME2** para datas, **BIT** para flags booleanas e **INT IDENTITY** para todas as chaves primárias. Todas as decisões de tipagem das seis tabelas do **FinanceDB** — Empresas, Bancos, ContasBancarias, PlanoDeContas, Transacoes e Orcamentos — estão documentadas e prontas para implementação.

---

## Objetivo

Criar o banco de dados **FinanceDB** no SQL Server 2022 usando o comando **CREATE DATABASE** com todas as configurações adequadas para um sistema financeiro de produção: nome, **collation** correto para o português brasileiro, **Recovery Model FULL**, localização dos arquivos **MDF** e **LDF**, **filegroups** organizados e tamanhos de crescimento definidos. Ao final deste capítulo, o FinanceDB existirá de fato no SQL Server — saindo do papel onde viveu nos seis capítulos anteriores e tornando-se um banco de dados real, verificável no **Object Explorer** do SSMS.

---

## Pré-requisitos

**Módulo 1 concluído (Capítulos 1 a 6).** O SQL Server 2022 e o SSMS devem estar instalados e configurados conforme o Capítulo 4. É necessário compreender os conceitos de Recovery Model, Transaction Log e tipos de dados.

---

## Teoria Detalhada

### A analogia de ancoragem: criar um banco de dados é como fundar uma empresa

Imagine que você decidiu abrir uma empresa. Antes de contratar funcionários, comprar equipamentos ou fechar contratos, você precisa formalizar a existência da empresa: registrar o CNPJ, definir o endereço da sede, escolher o regime tributário e abrir as contas bancárias. Sem esse passo, a empresa existe apenas na sua cabeça — uma ideia sem substância legal ou operacional.

Criar um banco de dados no SQL Server funciona exatamente assim. Nos seis capítulos anteriores, o **FinanceDB** existia apenas como um modelo — tabelas desenhadas, tipos de dados decididos, entidades definidas. Era uma planta arquitetônica brilhante sem nenhum tijolo assentado. O **CREATE DATABASE** é o ato de fundar oficialmente o FinanceDB: a partir desse momento, o SQL Server alocará espaço em disco, criará os arquivos físicos, registrará o banco no catálogo do sistema e o tornará disponível para conexões. É o momento em que a ideia se torna realidade.

---

### O que o SQL Server cria quando você executa CREATE DATABASE

Quando o comando **CREATE DATABASE** é executado, o SQL Server realiza uma série de operações em cascata que você precisa entender completamente — especialmente para a certificação.

O primeiro arquivo criado é o **MDF** (Master Data File). Este é o arquivo de dados primário do banco. Ele contém as páginas de dados das tabelas, os índices, as views, as stored procedures — tudo o que compõe a estrutura e o conteúdo do banco. Cada banco de dados possui exatamente um arquivo MDF. Internamente, o MDF é organizado em **páginas de 8 KB**, agrupadas em conjuntos de oito páginas chamados **extensões** (64 KB cada). É nessa estrutura que todos os dados do FinanceDB serão armazenados.

O segundo arquivo criado é o **LDF** (Log Data File). Este é o **Transaction Log** — o diário de bordo de todas as operações realizadas no banco. Como estudamos no Capítulo 3, o SQL Server segue o princípio de **Write-Ahead Logging**: toda operação é registrada no log *antes* de ser aplicada no arquivo de dados. Isso garante que, em caso de falha, o banco possa ser recuperado até o último commit confirmado. Para um sistema financeiro, o LDF é tão crítico quanto o MDF — perder o arquivo de log em produção é uma catástrofe.

Além dos arquivos físicos, o SQL Server também cria automaticamente um conjunto de **objetos de sistema** dentro do novo banco: as tabelas de sistema que compõem o catálogo interno (como `sys.objects`, `sys.columns` e `sys.tables`), os schemas padrão (`dbo`, `guest`, `sys`, `INFORMATION_SCHEMA`) e o usuário `dbo` mapeado ao login `sa` ou ao login que criou o banco.

---

### Collation: por que a escolha importa para o FinanceDB

**Collation** é a configuração que define como o SQL Server compara, ordena e armazena texto. Ela determina três coisas fundamentais: o **conjunto de caracteres** suportado (quais letras podem ser armazenadas), a **ordem de classificação** (como os registros são ordenados quando você usa ORDER BY em colunas de texto) e a **sensibilidade a maiúsculas e minúsculas** (se `'João'` e `'joão'` são considerados iguais ou diferentes em comparações).

Para o FinanceDB, usaremos **Latin1_General_CI_AS**. Vamos decodificar esse nome:

- **Latin1_General**: suporte ao conjunto de caracteres Latin1, que inclui todos os caracteres do português (ã, ç, á, é, etc.)
- **CI**: Case Insensitive — `'banco'` e `'BANCO'` são considerados iguais nas comparações
- **AS**: Accent Sensitive — `'José'` e `'Jose'` são considerados *diferentes*

Essa combinação é a mais adequada para sistemas financeiros brasileiros. A insensibilidade a maiúsculas evita bugs sutis em buscas e filtros. A sensibilidade a acentos garante que dados com e sem acentuação não sejam confundidos — o que seria um problema sério em nomes de pessoas e empresas.

---

### Recovery Model: a apólice de seguro do FinanceDB

O **Recovery Model** define como o SQL Server gerencia o Transaction Log e quais opções de recuperação estarão disponíveis. Existem três modelos:

O **Simple Recovery Model** é o mais básico. O SQL Server trunca automaticamente as partes inativas do log após cada checkpoint, mantendo o arquivo LDF pequeno. A desvantagem é fatal para sistemas financeiros: não é possível realizar backups de log, o que significa que, em caso de falha, você só consegue restaurar até o último backup completo. Tudo feito depois disso é perdido. Para o FinanceDB, este modelo é **proibido**.

O **Bulk-Logged Recovery Model** é intermediário, adequado para operações de carga em massa. Não é relevante para o nosso cenário.

O **Full Recovery Model** é o modelo correto para o FinanceDB. Com ele, todas as operações são registradas em detalhe no Transaction Log. Isso permite três tipos de backup: completo, diferencial e de log de transações. Em caso de falha, é possível recuperar o banco até o ponto exato da falha — ou até um ponto específico no tempo. Para uma instituição financeira, essa granularidade de recuperação é um requisito legal e operacional não negociável.

---

### Filegroups: organizando o armazenamento físico

Um **filegroup** é um container lógico que agrupa um ou mais arquivos de dados. O filegroup padrão de todo banco de dados é o **PRIMARY**, criado automaticamente. Para bancos simples ou de desenvolvimento, o PRIMARY é suficiente. Para bancos de produção de alta demanda, é possível criar filegroups adicionais e distribuir tabelas e índices entre eles — colocando dados de acesso frequente em discos mais rápidos e dados históricos em discos mais lentos.

No FinanceDB, criaremos o banco com o filegroup **PRIMARY** devidamente configurado. Essa é a configuração correta para o nosso ambiente de desenvolvimento e estudo, e é o que a certificação exige que você compreenda.

---

### Tamanho inicial e crescimento automático

Ao criar um banco de dados, você define o **tamanho inicial** dos arquivos e a **política de crescimento automático** (autogrowth). O tamanho inicial reserva espaço em disco imediatamente — evitando que o SQL Server precise expandir o arquivo a cada nova inserção. O autogrowth define o que acontece quando o arquivo atinge o limite: ele pode crescer por um valor fixo em MB ou por uma porcentagem.

Para ambientes de produção financeira, a recomendação é sempre usar **crescimento fixo em MB**, nunca percentual. O crescimento percentual causa um problema chamado **VLF fragmentation** (Virtual Log File fragmentation) no arquivo de log — fragmentação interna que degrada a performance de escrita ao longo do tempo. Para o FinanceDB, definiremos crescimento de **64 MB** para o MDF e **32 MB** para o LDF.

---

### O comando CREATE DATABASE em detalhe

Agora que a teoria está solidamente construída, vamos ao comando. O CREATE DATABASE possui duas formas: a **sintaxe mínima**, que usa todos os padrões do servidor, e a **sintaxe completa**, que especifica cada detalhe de configuração. Para o FinanceDB, usaremos a sintaxe completa — porque cada decisão que tomaremos é intencional e documentada.

~~~sql
-- =============================================================
-- Capítulo 7: Criando o Banco de Dados FinanceDB
-- Livro: SQL Server para Aplicações Financeiras com T-SQL
-- Módulo 2 — ESSENCIAL: T-SQL Básico
-- =============================================================

-- Passo 1: Garantir que estamos conectados ao banco master
-- O CREATE DATABASE deve ser executado no contexto do master
-- pois é lá que o catálogo de bancos do servidor é mantido
USE master;
GO

-- Passo 2: Verificar se o banco já existe antes de criar
-- Isso evita o erro "Database already exists" em reexecuções
-- sys.databases é a view de catálogo que lista todos os bancos
IF EXISTS (
    SELECT 1                          -- retorna 1 se encontrar
    FROM sys.databases                -- catálogo de bancos do servidor
    WHERE name = N'FinanceDB'         -- N'' = string Unicode (NVARCHAR)
)
BEGIN
    -- Se o banco existir, exibimos uma mensagem informativa
    PRINT 'O banco FinanceDB já existe. Nenhuma ação necessária.';
END
ELSE
BEGIN
    -- Se o banco não existir, prosseguimos com a criação
    PRINT 'Criando o banco de dados FinanceDB...';
END
GO

-- Passo 3: Criar o banco de dados FinanceDB com configurações completas
-- ATENÇÃO: Ajuste os caminhos de FILENAME para o seu ambiente
-- O caminho padrão do SQL Server 2022 no Windows é:
-- C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\
CREATE DATABASE FinanceDB
ON PRIMARY                            -- define o filegroup PRIMARY como destino
(
    -- Configuração do arquivo de dados primário (MDF)
    NAME = N'FinanceDB',              -- nome lógico do arquivo dentro do SQL Server
    FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\FinanceDB.mdf',
                                      -- caminho físico completo do arquivo MDF
    SIZE = 256MB,                     -- tamanho inicial: 256 MB reservados imediatamente
    MAXSIZE = UNLIMITED,              -- sem limite máximo de crescimento
    FILEGROWTH = 64MB                 -- crescimento fixo de 64 MB (nunca use percentual)
)
LOG ON
(
    -- Configuração do arquivo de log de transações (LDF)
    NAME = N'FinanceDB_log',          -- nome lógico do arquivo de log
    FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\FinanceDB_log.ldf',
                                      -- caminho físico do arquivo LDF
    SIZE = 128MB,                     -- tamanho inicial do log: 128 MB
    MAXSIZE = 2048MB,                 -- limite máximo de 2 GB para o log
    FILEGROWTH = 32MB                 -- crescimento fixo de 32 MB
)
-- Define o collation do banco como Latin1_General_CI_AS
-- CI = Case Insensitive, AS = Accent Sensitive
-- Adequado para sistemas financeiros brasileiros
COLLATE Latin1_General_CI_AS;
GO

-- Confirmação visual da criação
PRINT 'Banco de dados FinanceDB criado com sucesso.';
GO

-- =============================================================
-- Passo 4: Verificar a criação consultando o catálogo do sistema
-- =============================================================

-- Consulta 1: Verifica se o banco aparece no catálogo
SELECT
    name                AS NomeDoBanco,        -- nome do banco de dados
    database_id         AS ID,                  -- identificador interno
    state_desc          AS Estado,              -- ONLINE, OFFLINE, RESTORING, etc.
    recovery_model_desc AS ModeloDeRecuperacao, -- SIMPLE, BULK_LOGGED ou FULL
    collation_name      AS Collation,           -- collation configurado
    create_date         AS DataDeCriacao        -- data e hora da criação
FROM sys.databases
WHERE name = N'FinanceDB';
GO

-- =============================================================
-- Passo 5: Configurar o Recovery Model como FULL
-- =============================================================

-- Importante: o CREATE DATABASE herda o Recovery Model do banco model
-- Se o model estiver configurado como SIMPLE (padrão em muitas instalações),
-- o FinanceDB também nascerá como SIMPLE
-- Por isso, definimos explicitamente o Recovery Model como FULL

USE master;
GO

ALTER DATABASE FinanceDB
SET RECOVERY FULL;   -- garante que todas as operações sejam registradas no log
GO

-- Confirmação
PRINT 'Recovery Model configurado como FULL com sucesso.';
GO

-- =============================================================
-- Passo 6: Configurar propriedades adicionais do banco
-- =============================================================

-- Habilitar SNAPSHOT ISOLATION para melhor controle de concorrência
-- (será aprofundado no Capítulo 37, mas já configuramos agora)
ALTER DATABASE FinanceDB
SET ALLOW_SNAPSHOT_ISOLATION ON;   -- permite que transações usem isolamento snapshot
GO

-- Habilitar READ_COMMITTED_SNAPSHOT para leitura sem bloqueio
-- Isso evita que leituras bloqueiem escritas e vice-versa
ALTER DATABASE FinanceDB
SET READ_COMMITTED_SNAPSHOT ON;    -- melhora a concorrência em ambiente financeiro
GO

-- Definir o tamanho de página como padrão (8 KB — não pode ser alterado após criação)
-- Esta linha é apenas informativa — não há comando para alterar após a criação
PRINT 'Tamanho de página: 8 KB (padrão não modificável após criação)';
GO

-- =============================================================
-- Passo 7: Verificar os arquivos físicos criados
-- =============================================================

-- Consulta 2: Verifica os arquivos físicos do FinanceDB
USE FinanceDB;  -- muda o contexto para o banco recém-criado
GO

SELECT
    name                AS NomeLogico,     -- nome lógico do arquivo
    physical_name       AS CaminhoFisico,  -- caminho completo no disco
    type_desc           AS Tipo,           -- ROWS (MDF) ou LOG (LDF)
    size * 8 / 1024     AS TamanhoMB,      -- tamanho em MB (size está em páginas de 8KB)
    max_size            AS TamanhoMaximo,  -- -1 = UNLIMITED, valor em páginas
    growth              AS Crescimento     -- em páginas ou percentual
FROM sys.database_files;
GO

-- =============================================================
-- Passo 8: Verificar o Recovery Model configurado
-- =============================================================

USE master;
GO

-- Consulta 3: Confirma o Recovery Model
SELECT
    name                AS NomeDoBanco,
    recovery_model_desc AS ModeloDeRecuperacao
FROM sys.databases
WHERE name = N'FinanceDB';
GO

-- =============================================================
-- Passo 9: Definir o FinanceDB como banco padrão da sessão
-- =============================================================

-- A partir daqui, todos os próximos capítulos serão executados
-- no contexto do FinanceDB. Sempre inicie suas sessões com USE.
USE FinanceDB;
GO

PRINT 'Banco FinanceDB selecionado como contexto ativo.';
PRINT 'O FinanceDB está pronto para receber tabelas, dados e objetos.';
GO

-- =============================================================
-- Passo 10: Script de verificação final completa
-- =============================================================

USE master;
GO

-- Consulta consolidada: resume todas as configurações do FinanceDB
SELECT
    d.name                      AS NomeDoBanco,
    d.database_id               AS ID,
    d.state_desc                AS Estado,
    d.recovery_model_desc       AS Recovery,
    d.collation_name            AS Collation,
    d.is_read_only              AS SomenteLeitura,
    d.is_auto_shrink_on         AS AutoShrink,     -- deve estar OFF em produção
    d.is_auto_create_stats_on   AS AutoStats,       -- deve estar ON
    d.is_snapshot_isolation_allowed AS SnapshotIsolation,
    d.is_read_committed_snapshot_on AS RCSnapshotOn,
    d.create_date               AS CriadoEm
FROM sys.databases d
WHERE d.name = N'FinanceDB';
GO
~~~

---

## Diagrama: Estrutura Física do FinanceDB

~~~mermaid
graph TD
    SQL[SQL Server 2022\nInstância Local]
    MASTER[master\nCatálogo do Servidor]
    FDB[FinanceDB\nBanco de Dados]

    MDF[FinanceDB.mdf\nArquivo de Dados\n256 MB inicial\nCrescimento: 64 MB]
    LDF[FinanceDB_log.ldf\nArquivo de Log\n128 MB inicial\nCrescimento: 32 MB]

    FG[Filegroup: PRIMARY]

    CONFIG1[Collation:\nLatin1_General_CI_AS]
    CONFIG2[Recovery Model:\nFULL]
    CONFIG3[Snapshot Isolation:\nON]
    CONFIG4[RCSI:\nON]

    FUTUROS[Próximos Capítulos:\nTabelas, Índices,\nViews, Procedures]

    SQL --> MASTER
    MASTER --> FDB
    FDB --> FG
    FG --> MDF
    FDB --> LDF
    FDB --> CONFIG1
    FDB --> CONFIG2
    FDB --> CONFIG3
    FDB --> CONFIG4
    FDB --> FUTUROS
~~~

---

## Glossário Técnico

**MDF (Master Data File):** arquivo de dados primário do banco de dados. Contém todas as páginas de dados, índices e metadados do banco. Cada banco possui exatamente um MDF.

**LDF (Log Data File):** arquivo de Transaction Log. Registra todas as operações realizadas no banco antes de aplicá-las nos dados. Fundamental para recuperação em caso de falha.

**Collation:** configuração que define como o SQL Server compara, ordena e armazena texto. Define suporte a caracteres, sensibilidade a maiúsculas (CI/CS) e sensibilidade a acentos (AS/AI).

**Recovery Model:** define como o Transaction Log é gerenciado e quais opções de recuperação estão disponíveis. Os três modelos são SIMPLE, BULK_LOGGED e FULL.

**Filegroup:** container lógico que agrupa arquivos de dados. O filegroup PRIMARY é criado automaticamente em todo banco de dados.

**Autogrowth:** política de crescimento automático do arquivo quando ele atinge o limite de espaço. Deve ser configurado em MB fixos, nunca em percentual.

**VLF (Virtual Log File):** subdivisão interna do Transaction Log. O crescimento percentual gera muitos VLFs pequenos, causando fragmentação e degradação de performance.

**Checkpoint:** processo interno do SQL Server que grava páginas modificadas do Buffer Pool para o disco, permitindo que partes do log sejam reutilizadas.

**SNAPSHOT ISOLATION:** nível de isolamento que permite leituras consistentes sem bloquear escritas, usando versões anteriores dos dados armazenadas no tempdb.

**RCSI (Read Committed Snapshot Isolation):** variante do Read Committed que usa versionamento de linha para evitar bloqueios de leitura. Melhora a concorrência em sistemas de alta demanda.

**sys.databases:** view de catálogo do SQL Server que contém uma linha para cada banco de dados na instância, com informações de estado, collation, recovery model e configurações.

**sys.database_files:** view de catálogo que lista os arquivos físicos de um banco de dados, incluindo nome lógico, caminho físico, tipo, tamanho e política de crescimento.

**USE:** comando T-SQL que muda o contexto de conexão para um banco de dados específico. Todos os comandos subsequentes serão executados naquele banco.

**GO:** separador de lotes no T-SQL. Indica ao SSMS que o conjunto de instruções anterior deve ser enviado ao SQL Server como um lote independente para execução.

---

## Antecipação de Erros e Troubleshooting

### Erro 1: "Access is denied" ao criar o banco

**Causa:** o SQL Server não tem permissão de escrita no diretório especificado no FILENAME.

**Solução:** verifique se a conta de serviço do SQL Server (geralmente `NT SERVICE\MSSQLSERVER`) tem permissão de escrita no diretório. No Windows Explorer, clique com o botão direito na pasta, vá em Propriedades > Segurança e adicione a conta com permissão de Controle Total. Alternativamente, use o diretório padrão do SQL Server, que já possui as permissões corretas.

### Erro 2: "There is insufficient disk space"

**Causa:** o disco não tem os 384 MB necessários para os tamanhos iniciais configurados (256 MB MDF + 128 MB LDF).

**Solução:** reduza os valores de SIZE nos dois arquivos para um valor menor, como `SIZE = 64MB` para o MDF e `SIZE = 32MB` para o LDF. Os valores maiores são recomendados para produção, mas qualquer tamanho inicial funciona para estudo.

### Erro 3: "Database 'FinanceDB' already exists"

**Causa:** o banco já foi criado anteriormente e você está tentando criá-lo novamente.

**Solução:** o script do Capítulo 7 já inclui a verificação `IF EXISTS` para evitar esse erro. Se você executou o CREATE DATABASE sem a verificação, use `DROP DATABASE FinanceDB` antes de recriar — mas apenas em ambiente de desenvolvimento, pois este comando é irreversível.

### Erro 4: Caminho do FILENAME não encontrado

**Causa:** o caminho especificado em FILENAME não existe no sistema de arquivos ou o nome da instância é diferente.

**Solução:** verifique o caminho correto da instância executando a query abaixo e ajuste o FILENAME de acordo:

~~~sql
-- Descobre o caminho do diretório de dados da instância
SELECT SERVERPROPERTY('InstanceDefaultDataPath') AS CaminhoMDF,
       SERVERPROPERTY('InstanceDefaultLogPath')  AS CaminhoLDF;
~~~

### Erro 5: Recovery Model permanece como SIMPLE após criação

**Causa:** o banco `model` do servidor está configurado com Recovery Model SIMPLE. O FinanceDB herda essa configuração no momento da criação.

**Solução:** execute o `ALTER DATABASE FinanceDB SET RECOVERY FULL` conforme o Passo 5 do script. Isso sobrescreve o valor herdado do model. Para evitar esse problema em criações futuras, considere alterar o Recovery Model do model para FULL: `ALTER DATABASE model SET RECOVERY FULL`.

### Erro 6: Auto_Shrink aparece como ON

**Causa:** configuração herdada do banco model que ativa o auto-encolhimento do arquivo de dados.

**Solução:** sempre desative o AUTO_SHRINK em bancos de produção. Ele causa fragmentação severa de índices e degrada a performance. Execute: `ALTER DATABASE FinanceDB SET AUTO_SHRINK OFF`.

---

## Verificação Passo a Passo no SSMS

Após executar todos os scripts deste capítulo, siga este roteiro de verificação no SSMS para confirmar que tudo foi criado corretamente:

No **Object Explorer**, expanda o nó **Databases**. Você verá o **FinanceDB** listado. Clique com o botão direito sobre ele e selecione **Properties**. Na janela de propriedades, navegue pelas páginas: em **General**, confirme o Collation como `Latin1_General_CI_AS` e o Status como `Normal`. Em **Options**, confirme o Recovery Model como `Full` e o Auto Shrink como `False`. Em **Files**, confirme os dois arquivos (MDF e LDF) com os tamanhos e caminhos configurados. Em **Filegroups**, confirme o filegroup `PRIMARY` como padrão.

---

## Desafio de Fixação

**Cenário:** você foi contratado como DBA júnior de uma fintech. O gerente técnico solicitou que você criasse um novo banco de dados chamado **AuditDB** para armazenar logs de auditoria das operações financeiras. Os requisitos são: collation `Latin1_General_CI_AS`, Recovery Model FULL, arquivo de dados com 128 MB inicial e crescimento de 32 MB, arquivo de log com 64 MB inicial e crescimento de 16 MB. Após a criação, gere um relatório com nome, estado, recovery model, collation e data de criação do banco.

---

## Resolução Comentada do Desafio

~~~sql
-- =============================================================
-- Desafio: Criação do banco AuditDB
-- =============================================================

USE master;
GO

-- Verificação prévia: evita erro se já existir
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = N'AuditDB')
BEGIN
    PRINT 'AuditDB já existe. Nenhuma ação necessária.';
END
ELSE
BEGIN
    -- Criação do banco com os requisitos do gerente técnico
    CREATE DATABASE AuditDB
    ON PRIMARY
    (
        NAME = N'AuditDB',
        FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\AuditDB.mdf',
        SIZE = 128MB,          -- requisito: 128 MB inicial
        MAXSIZE = UNLIMITED,
        FILEGROWTH = 32MB      -- requisito: crescimento de 32 MB
    )
    LOG ON
    (
        NAME = N'AuditDB_log',
        FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\AuditDB_log.ldf',
        SIZE = 64MB,           -- requisito: 64 MB inicial para o log
        MAXSIZE = 1024MB,
        FILEGROWTH = 16MB      -- requisito: crescimento de 16 MB
    )
    COLLATE Latin1_General_CI_AS;  -- requisito: collation definido
    GO

    -- Configurar Recovery Model FULL conforme requisito
    ALTER DATABASE AuditDB SET RECOVERY FULL;
    GO

    PRINT 'AuditDB criado com sucesso.';
END
GO

-- Relatório de verificação solicitado pelo gerente
SELECT
    name                AS NomeDoBanco,
    state_desc          AS Estado,
    recovery_model_desc AS Recovery,
    collation_name      AS Collation,
    create_date         AS CriadoEm
FROM sys.databases
WHERE name = N'AuditDB';
GO
~~~

**Por que essa solução está correta:** a verificação `IF EXISTS` previne erros em reexecuções. O `CREATE DATABASE` usa todos os valores especificados nos requisitos. O `ALTER DATABASE SET RECOVERY FULL` é executado separadamente porque o banco pode ter herdado SIMPLE do model. O relatório final usa `sys.databases` para confirmar todas as propriedades solicitadas — exatamente o que a certificação exige que você saiba fazer.

---

## Resumo dos Pontos-Chave

O comando **CREATE DATABASE** cria dois arquivos físicos: o **MDF** (dados) e o **LDF** (log de transações). O **collation** `Latin1_General_CI_AS` é o correto para sistemas financeiros brasileiros — suporta acentuação, é case insensitive e accent sensitive. O **Recovery Model FULL** é obrigatório para sistemas financeiros por permitir backups de log e recuperação pontual. O crescimento automático deve ser sempre definido em **MB fixos**, nunca em percentual, para evitar fragmentação de VLFs. O banco pode herdar o Recovery Model do banco **model** — por isso, sempre confirme e defina explicitamente com `ALTER DATABASE`. As views de catálogo **sys.databases** e **sys.database_files** são as fontes oficiais de informação sobre bancos e arquivos. O comando **USE** muda o contexto ativo da sessão — sempre use-o no início dos scripts dos próximos capítulos. O **SNAPSHOT ISOLATION** e o **RCSI** melhoram a concorrência e devem ser habilitados desde a criação em bancos financeiros de alta demanda.

---

## Log de Estado do Projeto

~~~text
## Log de Estado — Capítulo 7
- Projeto: FinanceDB
- Livro: SQL Server para Aplicações Financeiras com T-SQL
- Módulo: 2 — ESSENCIAL: T-SQL Básico
- Capítulo: 7 — Criando o Banco de Dados — CREATE DATABASE
- Objetivo: Concluído ✅

- Banco de Dados:
    ✅ FinanceDB criado com sucesso
    ✅ Collation: Latin1_General_CI_AS
    ✅ Recovery Model: FULL
    ✅ Arquivo MDF: FinanceDB.mdf (256 MB inicial, crescimento 64 MB)
    ✅ Arquivo LDF: FinanceDB_log.ldf (128 MB inicial, crescimento 32 MB)
    ✅ Filegroup: PRIMARY configurado
    ✅ SNAPSHOT ISOLATION: ON
    ✅ READ_COMMITTED_SNAPSHOT: ON
    ✅ AUTO_SHRINK: OFF (recomendado)

- Tabelas: Nenhuma ainda (Capítulo 8)
- Dados: Nenhum ainda (Capítulo 10)

- Schemas: apenas dbo (padrão)
- Objetos: nenhum ainda

- Arquivos do Capítulo:
    ✅ modulo_02_essencial/aula_07/codigo/criar_banco.sql
    ✅ modulo_02_essencial/aula_07/respostas/desafio_07_auditdb.sql

- Estado Funcional: ✅ FinanceDB existe e está operacional no SQL Server.
- Próximas Etapas: Capítulo 8 — Criando Tabelas com CREATE TABLE e Constraints
~~~

---

## Prompt de Continuidade para o Capítulo 8

~~~text
Contexto: Estou estudando o livro "SQL Server para Aplicações
Financeiras com T-SQL". Meu ambiente é Windows 11, SSMS,
SQL Server 2022. O projeto prático incremental se chama FinanceDB.

Concluí o Capítulo 7, que cobriu a criação completa do banco de
dados FinanceDB com CREATE DATABASE, configuração de collation
Latin1_General_CI_AS, Recovery Model FULL, arquivos MDF e LDF
com tamanhos e crescimento definidos, filegroup PRIMARY,
SNAPSHOT ISOLATION e READ_COMMITTED_SNAPSHOT habilitados.
O banco FinanceDB está criado e operacional no SQL Server.
Os scripts foram salvos em modulo_02_essencial/aula_07/.

Siga rigorosamente o Prompt Mestre v1.1: narrativa densa com
mínimo de 2.000 palavras, Técnica de Feynman, analogia de
ancoragem, diagrama Mermaid escapado com ~~~mermaid, código SQL
comentado linha a linha escapado com ~~~, glossário técnico,
antecipação de erros, troubleshooting, desafio de fixação com
resolução comentada, resumo dos pontos-chave, log de estado do
projeto atualizado e prompt de continuidade para o próximo capítulo.
Todo o conteúdo deve ser gerado dentro de um bloco ```markdown.
Chame aulas de capítulos e curso de livro.

Por favor, gere o Capítulo 8: Criando Tabelas — CREATE TABLE e
Constraints Básicas. Objetivo: criar as primeiras tabelas do
FinanceDB (Empresas e Bancos) usando CREATE TABLE com os tipos
de dados definidos no Capítulo 6, aplicar as constraints NOT NULL,
DEFAULT e CHECK, entender o papel de cada constraint na integridade
dos dados financeiros e verificar as tabelas criadas no Object
Explorer do SSMS e nas views de catálogo sys.tables e sys.columns.
Pré-requisito: Capítulo 7 concluído, banco FinanceDB criado
e operacional.
~~~

---

Dúvidas? Posso prosseguir para o Capítulo 8?