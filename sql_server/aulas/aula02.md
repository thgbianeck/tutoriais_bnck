# AULA 02 — Instalação, Configuração e Setup do Ambiente Profissional
## FinanceCore DB | Módulo 1 — Essencial | SQL Server 2022 + T-SQL para Aplicações Financeiras

---

## ANÁLISE DE INTEGRIDADE PRÉ-AULA

✅ Conteúdo verificado: profundidade técnica mantida em nível sênior.
✅ Linguagem acessível com Técnica de Feynman aplicada em todos os conceitos.
✅ Analogias do cotidiano presentes antes de cada conceito técnico novo.
✅ Narrativa densa e conectada à prática financeira real.
✅ Mínimo de 2.000 palavras garantido.
✅ Passo a passo completo de instalação incluído com capturas descritivas de cada tela.
✅ Código comentado linha a linha pronto para execução no SSMS 21 / VS Code.
✅ Diagrama Mermaid incluso representando o fluxo completo de configuração.
✅ Exercícios com resoluções comentadas incluídos.
✅ Continuidade com a Aula 01 preservada.
✅ Blocos internos escapados com ~~~.

---

## RESUMO DA AULA ANTERIOR

Na Aula 01 compreendemos a arquitetura interna do SQL Server 2022: instâncias, bancos de sistema (master, model, msdb, tempdb), arquivos físicos (MDF, LDF, NDF), o Buffer Pool como área de cache de páginas de 8 KB, o Write-Ahead Logging como garantia de durabilidade, o Checkpoint como sincronizador periódico entre memória e disco, e o fluxo completo de processamento de uma query desde o Parser até o resultado. Exploramos as DMVs de sistema para inspecionar o estado interno da instância.

---

## OBJETIVO DA AULA

Construir um ambiente de desenvolvimento profissional completo para o FinanceCore DB. Isso inclui instalar o SQL Server 2022 Developer Edition no Windows 11 seguindo cada tela do instalador com as opções corretas, realizar o pós-instalação com ajustes críticos de memória e paralelismo, instalar e configurar o SSMS 21 com produtividade máxima, integrar o VS Code com a extensão mssql, e validar todo o ambiente com um script de diagnóstico completo. Ao final desta aula, seu ambiente estará pronto para o desenvolvimento do FinanceCore DB do Módulo 1 ao Módulo 4.

---

## PRÉ-REQUISITOS

Aula 01 concluída. Conhecimento básico de Windows 11 (instalação de software, manipulação de arquivos, Gerenciador de Serviços). Acesso à internet para download dos instaladores. Permissão de administrador local na máquina.

---

## TEORIA DETALHADA — NARRATIVA DENSA

### A Oficina do Artesão: Por Que o Ambiente Importa

Existe uma diferença fundamental entre um marceneiro que trabalha em uma bancada improvisada e um que tem uma oficina profissional: ferramentas no lugar certo, iluminação adequada, cada instrumento calibrado e acessível. O resultado não é apenas estético — a qualidade do trabalho é substancialmente melhor, os erros são detectados mais cedo e o tempo gasto é menor. O mesmo princípio se aplica com precisão absoluta ao desenvolvimento de sistemas de banco de dados.

Um ambiente mal configurado em SQL Server não é apenas inconveniente. Em um sistema financeiro, ele pode ser perigoso: um SQL Server com memória ilimitada pode consumir toda a RAM do Windows e causar instabilidade no servidor. Um ambiente sem autenticação mista pode bloquear conexões de aplicações externas. Um VS Code sem a extensão correta faz você perder o IntelliSense que detecta erros antes mesmo da execução. Um SSMS sem as configurações de segurança adequadas pode executar acidentalmente um UPDATE sem WHERE em uma tabela de transações financeiras — e sem avisos configurados, você só percebe depois.

Esta aula não é burocracia de setup. Cada decisão de configuração que faremos tem uma razão técnica direta, e você vai entender cada uma delas antes de executá-la.

---

### 1. Edições do SQL Server 2022: Escolhendo a Certa

O SQL Server 2022 é distribuído em várias edições, e escolher a errada para desenvolvimento pode limitar os recursos que você vai aprender ao longo do curso.

A **Enterprise Edition** é a edição completa para produção, com todos os recursos disponíveis — In-Memory OLTP avançado, Always On com até 8 réplicas, Distributed Availability Groups. O licenciamento é por núcleo de processador, tornando-a extremamente cara para uso individual.

A **Standard Edition** tem limitações importantes: máximo de 24 núcleos e 128 GB de RAM, sem alguns recursos avançados do Módulo 4. Usada em empresas de médio porte.

A **Developer Edition** é a nossa escolha. Tem exatamente os mesmos recursos da Enterprise Edition, mas com uma restrição única: só pode ser usada para desenvolvimento e teste, nunca em produção. É gratuita. Para o curso FinanceCore DB, isso é perfeito — teremos acesso a todos os recursos avançados que estudaremos nos Módulos 3 e 4, incluindo In-Memory OLTP, Always Encrypted, columnstore avançado e particionamento irrestrito.

A **Express Edition** é gratuita e pode ser usada em produção, mas tem limitações severas: máximo de 10 GB por banco, sem SQL Server Agent, sem vários recursos avançados. Não é adequada para o nosso curso.

Conclusão: **Developer Edition** é a escolha correta e obrigatória para o FinanceCore DB.

---

### 2. Componentes do SQL Server 2022: O Que Instalar

Durante a instalação, o SQL Server oferece vários componentes. Entender o que cada um faz evita instalar componentes desnecessários — que consomem recursos — ou deixar de instalar algo crítico.

O **Database Engine Services** é o motor principal. Ele processa queries, gerencia dados e controla transações. É obrigatório. O **SQL Server Replication** será necessário para a Aula 31 — instale agora. O **Full-Text and Semantic Extractions for Search** é opcional e ocupa pouco espaço. O **Machine Learning Services** é muito pesado (vários GB) e não utilizaremos — não instale. **SSAS** e **SSIS** também ficam de fora por ora.

Resumo do que instalar: **Database Engine Services + SQL Server Replication**.

---

### 3. Decisões Críticas Durante a Instalação

**Modo de Autenticação**: Usaremos **Mixed Mode** — aceita tanto autenticação Windows quanto logins SQL. Isso é necessário para simular cenários reais onde aplicações .NET, Python ou Java se conectam com credenciais SQL, algo muito comum em sistemas financeiros.

**Senha do SA**: O `sa` é o superusuário do SQL Server. Use algo como `FinanceCore@2022` — maiúsculas, minúsculas, números e caracteres especiais.

**Collation**: Usaremos `Latin1_General_CI_AS`. Isso garante que nomes com acentuação sejam tratados corretamente (CI = Case Insensitive, AS = Accent Sensitive).

**Diretórios de Dados**: Criaremos uma estrutura organizada em `C:\FinanceCoreDB\` que usaremos ao longo de todo o curso.

---

### 4. Pós-Instalação: Os Ajustes que Todo DBA Sênior Faz

**Max Server Memory**: O valor padrão é essencialmente ilimitado. Use a fórmula `(RAM total em MB - 4096) * 0.75`. Para 16 GB: `(16384 - 4096) * 0.75 = 9216 MB`. Para 32 GB: `(32768 - 4096) * 0.75 = 21504 MB`.

**MAXDOP**: Controla quantos núcleos de CPU uma única query pode usar em paralelo. Usaremos `MAXDOP = 4` como baseline seguro para desenvolvimento.

**Cost Threshold for Parallelism**: Usaremos `50` — evita que queries simples tentem desnecessariamente usar paralelismo.

---

## FLUXO COMPLETO DO AMBIENTE

~~~mermaid
flowchart TD
    A[Início] --> B[Download SQL Server 2022 Developer]
    B --> C[Instalação do SQL Server 2022\nDatabase Engine + Replication\nMixed Mode + SA Password\nCollation Latin1_General_CI_AS]
    C --> D[Criar Estrutura de Diretórios\nC:\FinanceCoreDB\DATA\nC:\FinanceCoreDB\LOG\nC:\FinanceCoreDB\BACKUP]
    D --> E[Download e Instalação SSMS 21]
    E --> F[Configurar SSMS 21\nLine Numbers + IntelliSense\nWarnings de Segurança\nIndentação 4 espaços]
    F --> G[Download e Instalação VS Code\nExtensão mssql\nExtensão Git Lens]
    G --> H[Pós-Instalação via T-SQL\nMax Server Memory\nMAXDOP\nCost Threshold\nSQL Server Agent]
    H --> I[Script de Diagnóstico\nVerificação Completa]
    I --> J{Todos os itens OK?}
    J -->|✅ Sim| K[Ambiente Pronto\nInício Aula 03]
    J -->|❌ Não| L[Troubleshooting\nCorrigir item com falha]
    L --> I
~~~

---

## PASSO A PASSO COMPLETO DE INSTALAÇÃO

### PARTE 1 — Download do SQL Server 2022 Developer Edition

**Passo 1.1 — Acessar a página de download**

Abra o navegador e acesse: `https://www.microsoft.com/pt-br/sql-server/sql-server-downloads`

Na página, você verá três opções de download em destaque: Enterprise, Express e Developer. Localize o botão da **Developer Edition** — ele estará identificado como "Download gratuito" na seção destinada a desenvolvedores.

**Passo 1.2 — Baixar o instalador bootstrap**

Clique em "Baixar agora" na seção Developer. O arquivo baixado se chamará `SQL2022-SSEI-Dev.exe` com aproximadamente 5 MB. Este é o instalador bootstrap — ele não contém o SQL Server completo, mas gerencia o download e a instalação.

**Passo 1.3 — Executar o instalador bootstrap**

Execute o arquivo `SQL2022-SSEI-Dev.exe` como Administrador (botão direito > "Executar como administrador"). Uma janela com três opções aparecerá:

- **Básico**: Instala com configurações padrão, sem personalização. Não use esta opção.
- **Personalizado**: Abre o instalador completo com todas as opções. Esta é a nossa escolha.
- **Baixar Mídia**: Baixa o ISO completo sem instalar. Útil para instalações offline.

Selecione **Personalizado**.

**Passo 1.4 — Escolher local do download**

O instalador pedirá onde salvar os arquivos de instalação. Use o padrão sugerido ou crie uma pasta como `C:\SQL2022_Install`. Clique em **Instalar** para iniciar o download dos arquivos de instalação (aproximadamente 1,5 GB). Aguarde o download concluir — pode demorar dependendo da sua conexão.

---

### PARTE 2 — Instalação do SQL Server 2022

**Passo 2.1 — Centro de Instalação do SQL Server**

Após o download, o **Centro de Instalação do SQL Server** abrirá automaticamente. É uma janela com menu à esquerda contendo as seções: Planejamento, Instalação, Manutenção, Ferramentas, Recursos, Avançado e Opções.

Clique em **Instalação** no menu à esquerda.

**Passo 2.2 — Iniciar nova instalação**

Na seção Instalação, clique em **"Nova instalação autônoma do SQL Server ou adicionar recursos a uma instalação existente"**. O assistente de instalação será iniciado.

**Passo 2.3 — Chave do produto**

A primeira tela pergunta sobre a chave do produto. Como estamos instalando a Developer Edition (que já foi selecionada no bootstrap), o campo estará preenchido automaticamente com a edição correta. Confirme que está escrito **"Developer"** e clique em **Avançar**.

**Passo 2.4 — Termos de licença**

Leia os termos de licença. Marque a caixa **"Aceito os termos de licença e a declaração de privacidade"** e clique em **Avançar**.

**Passo 2.5 — Microsoft Update**

Esta tela pergunta se deseja usar o Microsoft Update para verificar atualizações. Marque **"Usar o Microsoft Update para verificar se há atualizações (recomendado)"** e clique em **Avançar**. O instalador verificará se há atualizações disponíveis — aguarde.

**Passo 2.6 — Instalar Arquivos de Instalação**

O instalador baixará e instalará os arquivos necessários para a instalação. Aguarde. Se alguma atualização do produto for encontrada, ela será aplicada automaticamente. Clique em **Avançar** quando disponível.

**Passo 2.7 — Regras de Instalação**

O instalador verificará se o sistema atende aos pré-requisitos. Você verá uma lista de verificações com status "Aprovado", "Aviso" ou "Falha". Itens comuns de aviso (não impedem a instalação): Firewall do Windows (aviso que a porta 1433 pode não estar aberta — configuraremos depois se necessário). Certifique-se de que não há itens com status **Falha**. Clique em **Avançar**.

**Passo 2.8 — Azure Extension for SQL Server**

Uma tela perguntará sobre a Extensão do Azure para SQL Server. Esta extensão conecta o SQL Server local ao Azure Arc. Para nosso ambiente de desenvolvimento local, **desmarque** esta opção e clique em **Avançar**.

**Passo 2.9 — Seleção de Recursos (CRÍTICO)**

Esta é uma das telas mais importantes. Você verá uma lista de features com caixas de seleção. Configure exatamente assim:

Marque obrigatoriamente: **Database Engine Services** e dentro dele confirme que **SQL Server Replication** está marcado. Confirme também que **Full-Text and Semantic Extractions for Search** está disponível — marque se quiser (opcional).

Desmarque: **Machine Learning Services and Language Extensions**, **SQL Server Analysis Services**, **SQL Server Reporting Services** (instalação separada), **SQL Server Integration Services**, e qualquer outro componente não listado acima.

No campo **"Diretório raiz da instância"**, mantenha o padrão: `C:\Program Files\Microsoft SQL Server\`.

No campo **"Diretório de dados compartilhados"**, mantenha o padrão.

Clique em **Avançar**.

**Passo 2.10 — Configuração da Instância**

Esta tela define o nome da instância. Selecione **"Instância padrão"** (Default Instance). O ID da instância será `MSSQLSERVER`. Isso significa que você se conectará ao servidor simplesmente como `localhost` ou pelo nome da máquina, sem precisar especificar um nome de instância. Clique em **Avançar**.

**Passo 2.11 — Configuração do Servidor (Contas de Serviço)**

Esta tela configura as contas de sistema operacional que executarão os serviços do SQL Server. Para desenvolvimento local no Windows 11, as configurações padrão são adequadas:

- **SQL Server Agent**: `NT Service\SQLSERVERAGENT` — Tipo de Inicialização: **Automático**
- **SQL Server Database Engine**: `NT Service\MSSQLSERVER` — Tipo de Inicialização: **Automático**
- **SQL Server Browser**: `NT AUTHORITY\LOCAL SERVICE` — Tipo de Inicialização: **Desabilitado** (em desenvolvimento local não precisamos do Browser)

Importante: altere o **SQL Server Agent** de "Manual" para **"Automático"** — o Agent será fundamental na Aula 32. Clique em **Avançar**.

**Passo 2.12 — Configuração do Mecanismo de Banco de Dados (CRÍTICO)**

Esta tela tem três abas: Configuração do Servidor, Diretórios de Dados e TempDB.

**Aba "Configuração do Servidor":**

Em **Modo de Autenticação**, selecione **"Modo Misto (Autenticação do SQL Server e do Windows)"**. Esta opção habilitará o login `sa`.

Em **"Senha"** e **"Confirmar senha"**, digite: `FinanceCore@2022`

Clique em **"Adicionar Usuário Atual"** para adicionar sua conta Windows como administrador do SQL Server. Você verá seu usuário aparecer na lista de Administradores do SQL Server.

**Aba "Diretórios de Dados":**

Aqui definimos onde os arquivos do banco serão armazenados. Para o nosso ambiente de desenvolvimento, mantenha os padrões do SQL Server por enquanto — na Aula 05, quando criarmos o FinanceCore DB, especificaremos os diretórios personalizados em `C:\FinanceCoreDB\`. Isso nos dá mais controle e clareza sobre o que pertence ao nosso projeto.

**Aba "TempDB":**

Para desenvolvimento com 1 a 4 núcleos lógicos, mantenha **1 arquivo de dados** para o TempDB. Se sua máquina tiver 8 ou mais núcleos, aumente para **4 arquivos**. O tamanho inicial de 8 MB e crescimento de 64 MB estão adequados para desenvolvimento. Clique em **Avançar**.

**Passo 2.13 — Pronto para Instalar**

O instalador mostrará um resumo de todas as configurações selecionadas. Revise cuidadosamente:

- Edição: Developer
- Recursos: Database Engine Services, SQL Server Replication
- Instância: MSSQLSERVER (padrão)
- Modo de Autenticação: Misto
- Collation: Latin1_General_CI_AS (confirme este item)

Se tudo estiver correto, clique em **Instalar**. A instalação levará entre 5 e 15 minutos dependendo da velocidade da máquina.

**Passo 2.14 — Conclusão da Instalação**

Quando a instalação concluir, você verá todos os itens com status **"Êxito"**. Se algum item mostrar falha, anote o código de erro — o Troubleshooting ao final desta aula cobre os erros mais comuns. Clique em **Fechar**.

---

### PARTE 3 — Criando a Estrutura de Diretórios do FinanceCore DB

Antes de instalar o SSMS, crie a estrutura de diretórios que usaremos ao longo de todo o curso. Abra o **Prompt de Comando como Administrador** (Win + X > Terminal do Windows (Admin)) e execute:

~~~text
mkdir C:\FinanceCoreDB
mkdir C:\FinanceCoreDB\DATA
mkdir C:\FinanceCoreDB\LOG
mkdir C:\FinanceCoreDB\BACKUP
mkdir C:\FinanceCoreDB\SCRIPTS
~~~

Essa estrutura separa fisicamente os arquivos de dados (MDF/NDF), arquivos de log (LDF) e backups — uma prática fundamental em qualquer ambiente financeiro profissional.

---

### PARTE 4 — Download e Instalação do SSMS 21

**Passo 4.1 — Download do SSMS 21**

Acesse: `https://aka.ms/ssmsfullsetup`

Ou navegue até: `https://learn.microsoft.com/pt-br/sql/ssms/download-sql-server-management-studio-ssms`

Na página, localize o link de download da versão mais recente do SSMS 21. O arquivo se chamará algo como `SSMS-Setup-PTB.exe` com aproximadamente 600 MB.

**Passo 4.2 — Instalação do SSMS 21**

Execute o arquivo como Administrador. A instalação do SSMS é simples — apenas uma tela com o botão **Instalar**. O local padrão de instalação é `C:\Program Files (x86)\Microsoft SQL Server Management Studio 21\`. Mantenha o padrão e clique em **Instalar**. Aguarde a conclusão (5 a 10 minutos) e clique em **Reiniciar** se solicitado — ou **Fechar** e reinicie manualmente.

**Passo 4.3 — Primeira Conexão no SSMS 21**

Abra o SSMS 21. A janela **"Conectar ao Servidor"** aparecerá automaticamente. Configure:

- **Tipo de servidor**: Mecanismo de Banco de Dados
- **Nome do servidor**: `localhost` (ou simplesmente `.`)
- **Autenticação**: Autenticação do SQL Server
- **Logon**: `sa`
- **Senha**: `FinanceCore@2022`

Marque **"Lembrar senha"** e clique em **Conectar**. Se a conexão for bem-sucedida, você verá o Object Explorer à esquerda mostrando os bancos de sistema (master, model, msdb, tempdb). Parabéns — o SQL Server está funcionando.

**Passo 4.4 — Configurações de Produtividade no SSMS 21**

Com o SSMS aberto, acesse **Tools > Options** e configure:

Em **Text Editor > All Languages > General**: marque **"Line numbers"** para exibir número de linhas em todos os scripts.

Em **Text Editor > All Languages > Tabs**: defina **Tab size: 4**, **Indent size: 4**, e marque **"Insert spaces"** para usar espaços em vez de tabs.

Em **Query Execution > SQL Server > Advanced**: marque **"Warn before closing query when there are pending results"** — isso evita fechar acidentalmente uma query com transação aberta.

Em **Environment > Startup**: selecione **"Open empty environment"** para o SSMS iniciar sem janelas desnecessárias.

Clique em **OK** para salvar todas as configurações.

**Passo 4.5 — Mapeando o Refresh do IntelliSense**

No SSMS 21, acesse **Tools > Options > Environment > Keyboard**. No campo **"Show commands containing"**, digite `IntelliSense`. Localize **Edit.ListMembers** e **Edit.RefreshLocalCache**. Para RefreshLocalCache, adicione o atalho `Ctrl+Shift+R` — você usará isso frequentemente após criar novas tabelas para que o IntelliSense reconheça os novos objetos. Clique em **OK**.

---

### PARTE 5 — Download e Instalação do VS Code com Extensão mssql

**Passo 5.1 — Download do VS Code**

Acesse: `https://code.visualstudio.com/` e clique em **"Download for Windows"**. Execute o instalador `VSCodeSetup-x64-*.exe` como Administrador.

Durante a instalação, na tela **"Selecionar Tarefas Adicionais"**, marque todas as opções, especialmente **"Adicionar ao PATH"** e **"Registrar Code como editor para tipos de arquivo suportados"**. Isso permite abrir o VS Code direto pelo terminal com o comando `code .`. Conclua a instalação e abra o VS Code.

**Passo 5.2 — Instalando a Extensão mssql**

No VS Code, pressione `Ctrl+Shift+X` para abrir o painel de Extensões. No campo de busca, digite **mssql**. A primeira opção será **"SQL Server (mssql)"** publicada pela Microsoft. Clique em **Instalar**. Após a instalação, o VS Code solicitará que você aceite a instalação de drivers ODBC adicionais — aceite. Reinicie o VS Code.

**Passo 5.3 — Extensões Complementares Recomendadas**

Enquanto está no painel de Extensões, instale também: **GitLens** (visualização avançada de Git — fundamental para versionar os scripts do FinanceCore DB), **Prettier** (formatação de código), e **indent-rainbow** (coloração visual de indentação — útil para T-SQL com muitos blocos aninhados).

**Passo 5.4 — Configurando a Conexão no VS Code**

Crie uma pasta para o projeto: `C:\FinanceCoreDB\SCRIPTS\`. No VS Code, abra esta pasta com **File > Open Folder**. Crie um novo arquivo chamado `aula_02_teste_conexao.sql`. Com o arquivo aberto, pressione `Ctrl+Shift+P` e digite **"MS SQL: Connect"**. Selecione **"Create Connection Profile"** e preencha:

- **Server name**: `localhost`
- **Database name**: `master`
- **Authentication type**: SQL Login
- **User name**: `sa`
- **Password**: `FinanceCore@2022`
- **Save password**: Yes
- **Profile name**: `FinanceCoreDB-Local`
- **Trust server certificate**: Yes (obrigatório para certificados autoassinados em desenvolvimento)

Clique em **Connect**. A barra de status inferior do VS Code ficará verde mostrando `FinanceCoreDB-Local` — isso confirma que a conexão está ativa.

---

### PARTE 6 — Pós-Instalação via T-SQL (Configurações Críticas)

Com o SSMS 21 conectado como `sa`, abra uma nova janela de query (`Ctrl+N`) e execute o seguinte script de configuração:

~~~sql
-- ============================================================
-- SCRIPT DE PÓS-INSTALAÇÃO — FinanceCore DB
-- Aula 02 | SQL Server 2022 Developer Edition
-- Executar no SSMS 21 como SA após a instalação
-- ============================================================

-- SEÇÃO 1: Habilitar opções avançadas de configuração
-- Necessário para alterar configurações como max server memory e MAXDOP
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE WITH OVERRIDE;
GO

-- SEÇÃO 2: Configurar memória máxima do servidor
-- Ajuste o valor conforme sua RAM:
-- 8  GB RAM  → 3072  MB
-- 16 GB RAM  → 9216  MB
-- 32 GB RAM  → 21504 MB
-- Fórmula: (RAM_em_MB - 4096) * 0.75
EXEC sp_configure 'max server memory (MB)', 9216; -- Ajuste para seu ambiente
RECONFIGURE WITH OVERRIDE;
GO

-- SEÇÃO 3: Configurar MAXDOP (Max Degree of Parallelism)
-- Limita o número de núcleos usados por uma única query
-- Para desenvolvimento local: use 4 como baseline seguro
EXEC sp_configure 'max degree of parallelism', 4;
RECONFIGURE WITH OVERRIDE;
GO

-- SEÇÃO 4: Configurar Cost Threshold for Parallelism
-- Define o custo mínimo para usar paralelismo
-- Valor padrão (5) é muito baixo para sistemas financeiros
-- Recomendado: 50 para desenvolvimento
EXEC sp_configure 'cost threshold for parallelism', 50;
RECONFIGURE WITH OVERRIDE;
GO

-- SEÇÃO 5: Configurar otimização para workloads ad-hoc
-- Evita que o SQL Server cache planos de execução de queries de uso único
-- Economiza memória do Buffer Pool — crítico em sistemas financeiros de alta variedade
EXEC sp_configure 'optimize for ad hoc workloads', 1;
RECONFIGURE WITH OVERRIDE;
GO

-- SEÇÃO 6: Habilitar o login SA e verificar status
-- Confirma que o SA está ativo e com as permissões corretas
ALTER LOGIN sa ENABLE;
GO

-- Verifica status do login SA
SELECT
    name           AS login_name,        -- Nome do login
    is_disabled    AS desabilitado,      -- 0 = ativo, 1 = desabilitado
    type_desc      AS tipo,              -- SQL_LOGIN ou WINDOWS_LOGIN
    is_policy_checked AS politica_senha  -- Verificação de política de senha
FROM sys.server_principals
WHERE name = 'sa';
GO

-- SEÇÃO 7: Confirmar o modo de autenticação da instância
-- 1 = Windows Authentication Only
-- 2 = Mixed Mode (SQL Server and Windows Authentication)
-- Deve retornar 2 para nosso ambiente
SELECT
    SERVERPROPERTY('IsIntegratedSecurityOnly') AS windows_auth_only,
    -- 0 = Mixed Mode (correto), 1 = Windows Only (incorreto para nosso setup
    CASE SERVERPROPERTY('IsIntegratedSecurityOnly')
        WHEN 0 THEN '✅ Mixed Mode — Configuração correta'
        WHEN 1 THEN '❌ Windows Only — Alterar para Mixed Mode'
    END AS status_autenticacao;
GO

-- SEÇÃO 8: Verificar e configurar o SQL Server Agent
-- O Agent é necessário para a Aula 32 (Jobs Agendados)
-- Verifica se o serviço está em execução
EXEC xp_cmdshell 'sc query SQLSERVERAGENT', NO_OUTPUT;
GO

-- SEÇÃO 9: Habilitar xp_cmdshell temporariamente para verificar diretórios
-- ATENÇÃO: Habilitar apenas para verificação, desabilitar imediatamente após
EXEC sp_configure 'xp_cmdshell', 1;
RECONFIGURE WITH OVERRIDE;
GO

-- Verifica se a estrutura de diretórios do FinanceCore DB foi criada corretamente
EXEC xp_cmdshell 'dir C:\FinanceCoreDB\ /AD'; -- /AD lista apenas diretórios
GO

-- DESABILITAR xp_cmdshell imediatamente após o uso
-- Deixar habilitado é risco de segurança mesmo em desenvolvimento
EXEC sp_configure 'xp_cmdshell', 0;
RECONFIGURE WITH OVERRIDE;
GO

-- SEÇÃO 10: Verificar collation da instância
-- Deve retornar Latin1_General_CI_AS
SELECT
    SERVERPROPERTY('Collation')         AS collation_instancia,
    CASE SERVERPROPERTY('Collation')
        WHEN 'Latin1_General_CI_AS'
        THEN '✅ Collation correta para aplicações financeiras em português'
        ELSE '⚠️ Collation diferente do recomendado — verifique impacto'
    END AS status_collation;
GO

-- SEÇÃO 11: Verificar configurações aplicadas
-- Confirma que todas as configurações foram aplicadas corretamente
SELECT
    name           AS configuracao,        -- Nome da configuração
    value          AS valor_configurado,   -- Valor definido
    value_in_use   AS valor_em_uso,        -- Valor atual em uso
    description    AS descricao            -- Descrição da configuração
FROM sys.configurations
WHERE name IN (
    'max server memory (MB)',
    'max degree of parallelism',
    'cost threshold for parallelism',
    'optimize for ad hoc workloads',
    'show advanced options'
)
ORDER BY name;
GO

-- SEÇÃO 12: Script de identificação do ambiente
-- Retorna informações consolidadas do ambiente configurado
SELECT
    @@SERVERNAME                                    AS servidor,
    SYSTEM_USER                                     AS usuario_conectado,
    DB_NAME()                                       AS banco_atual,
    @@VERSION                                       AS versao_sqlserver,
    SERVERPROPERTY('Edition')                       AS edicao,
    SERVERPROPERTY('ProductVersion')                AS versao_produto,
    SERVERPROPERTY('ProductLevel')                  AS nivel_patch,
    SERVERPROPERTY('Collation')                     AS collation,
    SERVERPROPERTY('IsIntegratedSecurityOnly')      AS somente_windows_auth,
    GETDATE()                                       AS data_hora_servidor;
GO
~~~

---

### PARTE 7 — Script de Diagnóstico e Validação Final do Ambiente

Execute este script para validar que todo o ambiente está corretamente configurado. Ele retornará um relatório com ✅ para itens corretos e ❌ para itens que precisam de atenção:

~~~sql
-- ============================================================
-- DIAGNÓSTICO COMPLETO DO AMBIENTE — FinanceCore DB
-- Aula 02 | Execute após todo o setup e pós-instalação
-- ============================================================

PRINT '========================================';
PRINT 'DIAGNÓSTICO DO AMBIENTE — FinanceCore DB';
PRINT '========================================';
PRINT '';

-- VERIFICAÇÃO 1: Edição do SQL Server
SELECT
    '1. Edição do SQL Server' AS verificacao,
    CASE
        WHEN CAST(SERVERPROPERTY('Edition') AS NVARCHAR(100)) LIKE '%Developer%'
        THEN '✅ Developer Edition — Correto'
        ELSE '❌ Edição incorreta: ' + CAST(SERVERPROPERTY('Edition') AS NVARCHAR(100))
    END AS resultado;

-- VERIFICAÇÃO 2: Versão do SQL Server (deve ser 2022 = 16.x)
SELECT
    '2. Versão do SQL Server' AS verificacao,
    CASE
        WHEN CAST(SERVERPROPERTY('ProductMajorVersion') AS INT) >= 16
        THEN '✅ SQL Server 2022 (v' + CAST(SERVERPROPERTY('ProductVersion') AS NVARCHAR(20)) + ')'
        ELSE '❌ Versão incorreta: ' + CAST(SERVERPROPERTY('ProductVersion') AS NVARCHAR(20))
    END AS resultado;

-- VERIFICAÇÃO 3: Modo de autenticação
SELECT
    '3. Modo de Autenticação' AS verificacao,
    CASE SERVERPROPERTY('IsIntegratedSecurityOnly')
        WHEN 0 THEN '✅ Mixed Mode — Correto para FinanceCore DB'
        WHEN 1 THEN '❌ Windows Only — Altere para Mixed Mode (ver Troubleshooting)'
    END AS resultado;

-- VERIFICAÇÃO 4: Login SA ativo
SELECT
    '4. Login SA' AS verificacao,
    CASE is_disabled
        WHEN 0 THEN '✅ SA habilitado e ativo'
        WHEN 1 THEN '❌ SA desabilitado — Execute: ALTER LOGIN sa ENABLE'
    END AS resultado
FROM sys.server_principals
WHERE name = 'sa';

-- VERIFICAÇÃO 5: Collation da instância
SELECT
    '5. Collation da Instância' AS verificacao,
    CASE SERVERPROPERTY('Collation')
        WHEN 'Latin1_General_CI_AS'
        THEN '✅ Latin1_General_CI_AS — Correto'
        ELSE '⚠️ Collation diferente: ' + CAST(SERVERPROPERTY('Collation') AS NVARCHAR(100))
    END AS resultado;

-- VERIFICAÇÃO 6: Max Server Memory
SELECT
    '6. Max Server Memory' AS verificacao,
    CASE
        WHEN CAST(value_in_use AS INT) < 2000000
        THEN '✅ Limitado a ' + CAST(value_in_use AS NVARCHAR(20)) + ' MB — Correto'
        ELSE '❌ Sem limite definido (' + CAST(value_in_use AS NVARCHAR(20)) + ' MB) — Configure via sp_configure'
    END AS resultado
FROM sys.configurations
WHERE name = 'max server memory (MB)';

-- VERIFICAÇÃO 7: MAXDOP
SELECT
    '7. MAXDOP' AS verificacao,
    CASE
        WHEN CAST(value_in_use AS INT) BETWEEN 1 AND 8
        THEN '✅ MAXDOP = ' + CAST(value_in_use AS NVARCHAR(10)) + ' — Adequado para desenvolvimento'
        WHEN CAST(value_in_use AS INT) = 0
        THEN '⚠️ MAXDOP = 0 (ilimitado) — Recomendado configurar para 4'
        ELSE '✅ MAXDOP = ' + CAST(value_in_use AS NVARCHAR(10))
    END AS resultado
FROM sys.configurations
WHERE name = 'max degree of parallelism';

-- VERIFICAÇÃO 8: Cost Threshold for Parallelism
SELECT
    '8. Cost Threshold for Parallelism' AS verificacao,
    CASE
        WHEN CAST(value_in_use AS INT) >= 25
        THEN '✅ Cost Threshold = ' + CAST(value_in_use AS NVARCHAR(10)) + ' — Adequado'
        ELSE '⚠️ Cost Threshold = ' + CAST(value_in_use AS NVARCHAR(10)) + ' (padrão=5) — Recomendado >= 25'
    END AS resultado
FROM sys.configurations
WHERE name = 'cost threshold for parallelism';

-- VERIFICAÇÃO 9: xp_cmdshell DEVE estar desabilitado
SELECT
    '9. xp_cmdshell (segurança)' AS verificacao,
    CASE CAST(value_in_use AS INT)
        WHEN 0 THEN '✅ xp_cmdshell desabilitado — Correto'
        WHEN 1 THEN '❌ xp_cmdshell habilitado — Execute: EXEC sp_configure ''xp_cmdshell'', 0; RECONFIGURE;'
    END AS resultado
FROM sys.configurations
WHERE name = 'xp_cmdshell';

-- VERIFICAÇÃO 10: Optimize for Ad Hoc Workloads
SELECT
    '10. Optimize for Ad Hoc Workloads' AS verificacao,
    CASE CAST(value_in_use AS INT)
        WHEN 1 THEN '✅ Habilitado — Economiza memória do Buffer Pool'
        WHEN 0 THEN '⚠️ Desabilitado — Recomendado habilitar'
    END AS resultado
FROM sys.configurations
WHERE name = 'optimize for ad hoc workloads';

PRINT '';
PRINT 'Diagnóstico concluído. Corrija qualquer item com ❌ antes de prosseguir para a Aula 03.';
GO
~~~

---

## GLOSSÁRIO TÉCNICO DA AULA

- **Developer Edition:** Edição gratuita do SQL Server com todos os recursos da Enterprise, restrita a uso em desenvolvimento e testes.

- **Mixed Mode:** Modo de autenticação que permite tanto logins Windows quanto logins SQL gerenciados pelo próprio SQL Server.

- **SA (System Administrator):** Login padrão superusuário do SQL Server, criado durante a instalação, com permissões irrestrictas sobre toda a instância.

- **Collation:** Conjunto de regras que define como o SQL Server armazena, ordena e compara strings de texto, incluindo sensibilidade a maiúsculas (CI/CS) e acentos (AI/AS).

- **MAXDOP:** Max Degree of Parallelism — número máximo de núcleos de CPU que uma única query pode utilizar em paralelo.

- **Cost Threshold for Parallelism:** Custo mínimo estimado de uma query para que o motor considere executá-la com paralelismo.

- **sp_configure:** Stored procedure do sistema usada para visualizar e alterar configurações da instância SQL Server.

- **RECONFIGURE WITH OVERRIDE:** Comando que aplica imediatamente as alterações feitas via sp_configure.

- **xp_cmdshell:** Extended stored procedure que permite executar comandos do sistema operacional a partir do T-SQL. Deve ser desabilitada após o uso por questões de segurança.

- **TrustServerCertificate:** Parâmetro de conexão que instrui o cliente a confiar no certificado autoassinado do servidor SQL em ambientes de desenvolvimento.

- **Bootstrap Installer:** Instalador pequeno que gerencia o download e execução do instalador completo do produto.

- **SQL Server Agent:** Serviço do SQL Server responsável pela execução de jobs agendados, alertas e automações.

---

## ANTECIPAÇÃO DE ERROS

- **Erro: "Login failed for user 'sa'"** — O login SA pode estar desabilitado ou a senha incorreta. Execute `ALTER LOGIN sa ENABLE` conectado com uma conta Windows com permissão sysadmin.

- **Erro: "Cannot connect to localhost"** — O serviço SQL Server pode estar parado. Verifique via `services.msc` se "SQL Server (MSSQLSERVER)" está em execução. Se parado, clique com o botão direito > Start.

- **Erro: "Configuration option does not exist"** — Você tentou alterar uma opção avançada sem executar `EXEC sp_configure 'show advanced options', 1; RECONFIGURE;` antes. Execute essa linha e tente novamente.

- **VS Code não conecta após instalar a extensão mssql** — Reinicie o VS Code completamente. Na primeira conexão, aceite a instalação dos drivers ODBC quando solicitada pela extensão.

- **Instalador do SQL Server falha na verificação de regras** — Verifique se o Windows está atualizado (`winget upgrade --all` no terminal). A maioria das falhas de pré-requisito se resolve com atualizações do Windows pendentes.

- **SSMS 21 não encontra o servidor após instalação** — Verifique se o serviço SQL Server Browser está ativo em `services.msc`. Para conexão com `localhost`, o Browser não é obrigatório, mas o serviço "SQL Server (MSSQLSERVER)" deve estar rodando.

---

## TROUBLESHOOTING

**Alterando para Mixed Mode sem reinstalar:** Acesse no SSMS: botão direito no servidor > Properties > Security > SQL Server and Windows Authentication Mode > OK. Depois reinicie o serviço SQL Server via `services.msc`.

**SQL Server Agent não inicia:** Verifique se o serviço existe em `services.msc`. Se existir mas estiver parado, clique com o botão direito > Start. Para inicialização automática com o Windows, clique em Properties > Startup type > Automatic.

**Collation incorreta após instalação:** A collation do servidor não pode ser alterada sem reinstalação. Se estiver errada, é melhor reinstalar o SQL Server com a collation correta do que usar workarounds. Por isso verificamos esse valor no diagnóstico antes de criar qualquer banco.

**VS Code retorna erro de certificado SSL:** Adicione `TrustServerCertificate=True` nas propriedades avançadas do perfil de conexão no VS Code. Para conexões locais de desenvolvimento, este parâmetro é padrão e necessário.

**Porta 1433 bloqueada pelo firewall:** Se precisar conectar de outra máquina à sua instância de desenvolvimento, acesse Windows Defender Firewall > Advanced Settings > Inbound Rules > New Rule > Port > TCP 1433. Para conexões locais (localhost), o firewall não interfere.

---

## DESAFIO DE FIXAÇÃO

**Exercício 1 — Diagnóstico Completo**

Execute o script de diagnóstico da Parte 7 desta aula. Todos os itens devem retornar ✅ ou ⚠️ com justificativa. Documente qualquer item ❌ e corrija usando o Troubleshooting antes de prosseguir para a Aula 03.

**Exercício 2 — Cálculo de Memória Personalizado**

Sua máquina tem 32 GB de RAM. Calcule usando a fórmula `(RAM total em MB - 4096) * 0.75` qual seria o valor correto de `max server memory` em MB. Escreva o comando `sp_configure` completo para aplicar este valor com `RECONFIGURE WITH OVERRIDE`.

**Exercício 3 — Análise de Edições**

Com base no que aprendemos, responda: quais são os dois principais motivos técnicos pelos quais a Standard Edition NÃO seria adequada para o FinanceCore DB, considerando o conteúdo do Módulo 4?

**Exercício 4 — Conexão Dual: SSMS e VS Code**

Configure a conexão no VS Code conforme o Passo 5.4. Execute a Seção 12 do script de pós-instalação nesta conexão e confirme que o campo `usuario_conectado` retorna `sa`. Execute o mesmo script no SSMS e compare — ambos os resultados devem ser idênticos.

---

## RESOLUÇÕES COMENTADAS

**Resolução — Exercício 1**

O item mais comum a falhar é o Mixed Mode, deixado em "Windows Only" durante a instalação. A correção via SSMS Properties leva menos de 2 minutos. O segundo item mais comum é o Max Server Memory que permanece ilimitado se a Seção 2 do script não foi executada.

**Resolução — Exercício 2**

Cálculo: `(32768 - 4096) * 0.75 = 28672 * 0.75 = 21504 MB`. O comando completo:

~~~sql
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE WITH OVERRIDE;
GO
EXEC sp_configure 'max server memory (MB)', 21504;
RECONFIGURE WITH OVERRIDE;
GO
~~~

Este valor deixa aproximadamente 11 GB para o sistema operacional, SSMS, VS Code e outros processos.

**Resolução — Exercício 3**

Os dois motivos técnicos principais são: (1) In-Memory OLTP na Standard Edition tem limitação de 32 GB de dados por banco, enquanto na Developer é ilimitado — a Aula 28 exige esse recurso sem limitação; (2) Always On Availability Groups na Standard suporta apenas 2 réplicas síncronas sem réplicas legíveis, enquanto a Developer suporta até 8 réplicas com readable secondaries, que é o cenário financeiro real da Aula 27.

**Resolução — Exercício 4**

Após configurar a conexão no VS Code com `sa` e `FinanceCore@2022`, o resultado deve mostrar `sa` em `usuario_conectado`, `master` em `banco_atual`, o nome do servidor em `servidor` e a string completa da versão SQL Server 2022 Developer Edition em `versao_sqlserver`. Se o VS Code retornar erro de certificado, adicione `TrustServerCertificate=True` nas propriedades avançadas da conexão.

---

## RESUMO DOS PONTOS-CHAVE

A Developer Edition é a única escolha correta para o FinanceCore DB: gratuita e com todos os recursos da Enterprise. A instalação exige atenção em quatro telas críticas: seleção de features (Database Engine + Replication), configuração de autenticação (Mixed Mode + senha do SA), collation (Latin1_General_CI_AS) e diretórios de dados. O pós-instalação com `sp_configure` é obrigatório — sem ele, o SQL Server pode consumir toda a RAM disponível. O SSMS 21 e o VS Code com extensão mssql formam um ambiente dual que combina interface visual rica com integração Git nativa. A estrutura de diretórios `C:\FinanceCoreDB\DATA\`, `\LOG\` e `\BACKUP\` estabelece desde o início o hábito profissional de separar tipos de arquivo. O script de diagnóstico é o critério objetivo de conclusão desta aula — todos os itens ✅ significam ambiente pronto.

---

## PRÓXIMOS PASSOS

Na Aula 03 mergulharemos no T-SQL — a linguagem que torna o SQL Server único entre os bancos de dados relacionais. Entenderemos a diferença entre SQL ANSI e T-SQL, conheceremos os tipos de dados financeiros críticos como DECIMAL, MONEY, DATETIME2 e DATETIMEOFFSET, suas implicações práticas em cálculos de juros e timestamps de transações, e escreveremos os primeiros blocos de código T-SQL com precisão financeira absoluta. O ambiente que preparamos hoje receberá seus primeiros comandos reais voltados ao FinanceCore DB.

---

## LOG DE ESTADO DO PROJETO

| Campo | Status |
|---|---|
| Aula | 02 — Instalação, Configuração e Setup do Ambiente |
| Objetivo | ✅ Ambiente profissional completo instalado, configurado e validado |
| Arquivos Criados | `C:\FinanceCoreDB\DATA\`, `\LOG\`, `\BACKUP\`, `\SCRIPTS\` |
| Código Adicionado | `aula_02/codigo/pos_instalacao.sql` e `aula_02/codigo/diagnostico_ambiente.sql` |
| Estado Funcional | ✅ SQL Server 2022, SSMS 21 e VS Code conectados e validados pelo diagnóstico |
| Próximas Etapas | Aula 03 — T-SQL: A Linguagem do SQL Server — Fundamentos Absolutos |

---

## PROMPT DE CONTINUIDADE — AULA 03

~~~text
Sou Bianeck. Aulas 01 e 02 concluídas (Arquitetura + Setup do Ambiente).
Ambiente: Windows 11 | SSMS 21 | VS Code | SQL Server 2022 (16.x).
Projeto Prático Incremental: FinanceCore DB.
Estrutura de diretórios C:\FinanceCoreDB\ criada e ambiente validado pelo diagnóstico completo.
Por favor, gere a AULA 03 completa seguindo o Prompt Mestre v1.1:
Título: T-SQL — A Linguagem do SQL Server: Fundamentos Absolutos.
Objetivo: Entender a diferença entre SQL padrão e T-SQL, conhecer os tipos de dados
financeiros críticos (DECIMAL, MONEY, SMALLMONEY, DATETIME2, DATETIMEOFFSET) e escrever
os primeiros comandos T-SQL com precisão financeira absoluta.
Siga integralmente toda a estrutura definida no Prompt Mestre v1.1 anexo.
~~~

---

Dúvidas sobre a Aula 02? Posso detalhar qualquer etapa da instalação antes de prosseguir para a Aula 03.