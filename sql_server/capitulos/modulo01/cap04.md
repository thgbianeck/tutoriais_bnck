# Capítulo 4: Instalação e Configuração do Ambiente
## Livro: SQL Server para Aplicações Financeiras com T-SQL
## Módulo 1 — FUNDAMENTOS: Teoria e Ambiente

## Análise de Integridade

✅ Conteúdo verificado: profundidade técnica mantida, linguagem acessível pela Técnica de Feynman, narrativa com mínimo de 2.000 palavras, analogia de ancoragem presente, diagrama Mermaid incluído, glossário técnico completo, antecipação de erros mapeada, desafio de fixação com resolução comentada, log de estado atualizado e prompt de continuidade gerado.

## Resumo do Capítulo Anterior

No **Capítulo 3** mergulhamos na arquitetura interna do SQL Server. Aprendemos que o **SQLOS** é o sistema operacional interno que gerencia CPU, memória e I/O. Conhecemos o **Storage Engine**, responsável por armazenar e recuperar dados usando o **Buffer Pool** como cache em memória, o **Lock Manager** para controle de concorrência e o **Transaction Log** com o princípio de **Write-Ahead Logging** para garantir a Durabilidade do ACID. Entendemos o **Query Processor** composto pelo **Parser**, **Algebrizer** e **Query Optimizer**. Definimos que o **FinanceDB** usará o **Recovery Model FULL** e que os índices serão planejados para as colunas de filtro mais frequentes.

## Objetivo

Guiar o aluno na instalação completa do **SQL Server 2022** e do **SQL Server Management Studio (SSMS)** no Windows 11, configurar a instância local com as decisões de design tomadas no Capítulo 3, verificar o funcionamento do serviço no **Windows Services**, realizar a primeira conexão com sucesso e preparar o ambiente para os próximos capítulos. Ao final deste capítulo, o aluno terá um ambiente 100% funcional, pronto para receber o projeto **FinanceDB**.

## Pré-requisitos

**Capítulos 1, 2 e 3 concluídos.** É necessário compreender os conceitos de instância, Recovery Model, Buffer Pool e Transaction Log para tomar decisões conscientes durante a instalação.

## Teoria Detalhada

### A analogia de ancoragem: instalar o SQL Server é como montar uma fábrica

Imagine que você vai abrir uma fábrica de processamento de dados financeiros. Antes de qualquer produto ser fabricado, você precisa construir a infraestrutura: o galpão (o sistema operacional Windows 11), as máquinas (o SQL Server Engine), o painel de controle (o SSMS) e as conexões elétricas e hidráulicas que fazem tudo funcionar junto (os protocolos de rede e serviços do Windows). Cada decisão tomada durante a montagem da fábrica — onde colocar cada máquina, como dimensionar a capacidade elétrica, quem terá acesso às diferentes áreas — terá impacto direto na eficiência e segurança do que será produzido ali. Instalar o SQL Server é exatamente isso: montar a fábrica antes de começar a produção.

### O que é uma instância do SQL Server

Antes de iniciar a instalação, precisamos entender o conceito de **instância**. Uma **instância** é uma cópia em execução do SQL Server Engine, com seus próprios bancos de dados, configurações, serviços e alocação de memória. Um único servidor Windows pode hospedar múltiplas instâncias do SQL Server simultaneamente — cada uma com sua própria versão, configurações e conjunto de bancos de dados.

Existem dois tipos de instância: a **instância padrão** (Default Instance) e a **instância nomeada** (Named Instance). A instância padrão é identificada apenas pelo nome do servidor — por exemplo, `MEUPC` — e é a forma mais simples de conexão. A instância nomeada é identificada pelo nome do servidor seguido do nome da instância — por exemplo, `MEUPC\SQLSERVER2022` — e é útil quando você precisa rodar múltiplas versões do SQL Server na mesma máquina.

Para o nosso curso, instalaremos uma **instância padrão**, pois é o cenário mais comum em ambientes de desenvolvimento e o mais simples para aprendizado.

~~~mermaid
graph TD
    Windows11[Windows 11]
    InstanciaPadrao[Instância Padrão: MEUPC]
    SQLEngine[SQL Server 2022 Engine]
    SSMS[SQL Server Management Studio]
    FinanceDB[Banco de Dados: FinanceDB]
    SystemDBs[Bancos do Sistema: master, model, msdb, tempdb]
    Servicos[Serviços do Windows]
    SQLServer[SQL Server: MSSQLSERVER]
    SQLAgent[SQL Server Agent]
    SQLBrowser[SQL Server Browser]

    Windows11 --> InstanciaPadrao
    InstanciaPadrao --> SQLEngine
    SQLEngine --> FinanceDB
    SQLEngine --> SystemDBs
    InstanciaPadrao --> Servicos
    Servicos --> SQLServer
    Servicos --> SQLAgent
    Servicos --> SQLBrowser
    SSMS -->|Conecta via TDS| InstanciaPadrao
~~~

### Os bancos de dados do sistema

Quando você instala o SQL Server, quatro bancos de dados do sistema são criados automaticamente. Entender o papel de cada um é fundamental para qualquer desenvolvedor ou DBA.

O **master** é o banco de dados mais crítico de toda a instância. Ele armazena todas as informações de configuração da instância, a lista de todos os bancos de dados existentes, os logins de nível de servidor e as configurações de memória e rede. Se o **master** for corrompido sem backup, a instância inteira é perdida.

O **model** funciona como um template. Sempre que você cria um novo banco de dados com `CREATE DATABASE`, o SQL Server copia a estrutura do **model** como ponto de partida. Isso significa que qualquer objeto criado no **model** — tabelas, procedures, configurações — será replicado automaticamente em todos os novos bancos criados.

O **msdb** é o banco de dados do **SQL Server Agent**, o serviço responsável por agendamento de tarefas, backups automatizados, alertas e jobs. Ele também armazena o histórico de backups e restaurações — informação crítica para ambientes de produção.

O **tempdb** é o banco de dados temporário da instância, recriado do zero a cada reinicialização do serviço SQL Server. Ele armazena tabelas temporárias, variáveis de tabela, resultados intermediários de operações complexas e versões de linha usadas pelo controle de concorrência. O **tempdb** é um dos recursos mais disputados em ambientes de alta concorrência.

### Edições do SQL Server 2022

O SQL Server 2022 está disponível em diferentes edições, cada uma com capacidades e limitações distintas. Para o nosso curso, usaremos a **edição Developer**, que é gratuita, tem todas as funcionalidades da edição Enterprise e é licenciada exclusivamente para desenvolvimento e testes — não pode ser usada em produção.

A **edição Express** também é gratuita, mas tem limitações importantes: máximo de 10 GB por banco de dados, uso limitado de memória e CPU e sem o SQL Server Agent. A **edição Standard** é a opção de produção para empresas de médio porte. A **edição Enterprise** é a mais completa, sem limitações, voltada para ambientes de missão crítica.

## Passo a Passo: Instalação do SQL Server 2022 Developer

### Etapa 1 — Download do instalador

Acesse o site oficial da Microsoft para download do SQL Server 2022 Developer Edition. O endereço é `https://www.microsoft.com/pt-br/sql-server/sql-server-downloads`. Na página, localize a seção **"Edições gratuitas especializadas"** e clique em **"Baixar agora"** na coluna **Developer**. O arquivo baixado é um instalador leve chamado `SQL2022-SSEI-Dev.exe` com aproximadamente 5 MB — ele fará o download dos componentes durante a instalação.

### Etapa 2 — Iniciando a instalação

Execute o arquivo `SQL2022-SSEI-Dev.exe` como administrador (clique com o botão direito e selecione **Executar como administrador**). Na tela inicial, você verá três opções de tipo de instalação. Selecione **"Personalizado"** para ter controle total sobre os componentes instalados e as configurações aplicadas.

### Etapa 3 — Centro de Instalação do SQL Server

Após o download dos arquivos de instalação, o **SQL Server Installation Center** será aberto. No menu lateral esquerdo, clique em **"Instalação"** e depois em **"Nova instalação autônoma do SQL Server ou adicionar recursos a uma instalação existente"**.

### Etapa 4 — Chave do produto

Na tela de chave do produto, selecione **"Developer"** no menu suspenso. Clique em **Avançar**.

### Etapa 5 — Termos de licença

Marque a opção **"Aceito os termos de licença e a Política de Privacidade"** e clique em **Avançar**.

### Etapa 6 — Atualizações do Microsoft Update

Recomenda-se marcar a opção **"Usar o Microsoft Update para verificar atualizações"** para manter o SQL Server atualizado com patches de segurança. Clique em **Avançar**.

### Etapa 7 — Seleção de recursos

Esta é a tela mais importante da instalação. Para o nosso curso, selecione os seguintes componentes:

**Database Engine Services** — obrigatório. É o núcleo do SQL Server, o motor de banco de dados que processa todas as queries T-SQL. Sem ele, nada funciona.

**SQL Server Replication** — opcional para o curso, mas recomendado para quem pretende trabalhar com ambientes de produção. Mantém cópias sincronizadas de dados entre servidores.

**Full-Text and Semantic Extractions for Search** — opcional. Permite buscas em texto livre dentro de colunas. Não é necessário para o curso, mas pode ser útil em cenários reais.

Deixe o diretório de instalação padrão em `C:\Program Files\Microsoft SQL Server\` ou defina um diretório alternativo se preferir. Clique em **Avançar**.

### Etapa 8 — Configuração da instância

Selecione **"Instância padrão"**. O **Nome da instância** será preenchido automaticamente como `MSSQLSERVER` e o **ID da instância** também como `MSSQLSERVER`. Clique em **Avançar**.

### Etapa 9 — Configuração do servidor (contas de serviço)

Nesta tela você define as contas do Windows sob as quais os serviços do SQL Server serão executados. Use as configurações padrão sugeridas pelo instalador: **NT Service\MSSQLSERVER** para o SQL Server Database Engine e **NT Service\SQLSERVERAGENT** para o SQL Server Agent. O tipo de inicialização do **SQL Server Database Engine** deve estar como **Automático**. O **SQL Server Agent** pode permanecer como **Manual** por enquanto — você o configurará quando precisar de agendamento de tarefas. Clique em **Avançar**.

### Etapa 10 — Configuração do Mecanismo de Banco de Dados

Esta é a tela de configuração mais crítica para o **FinanceDB**. Ela possui três abas importantes.

Na aba **"Configuração do Servidor"**, selecione o modo de autenticação. Escolha **"Modo Misto (Autenticação do SQL Server e do Windows)"**. Esse modo permite que você se conecte tanto com sua conta do Windows quanto com o login `sa` (System Administrator) do SQL Server. Defina uma senha forte para a conta `sa` — anote essa senha em local seguro, pois ela é a chave mestra da instância. Em ambientes de produção, a conta `sa` deve ser desabilitada após a configuração, mas para desenvolvimento local ela é conveniente.

Ainda nessa aba, clique em **"Adicionar usuário atual"** para adicionar sua conta do Windows como administrador do SQL Server. Isso garantirá acesso total à instância com sua conta do Windows sem precisar usar a conta `sa`.

Na aba **"Diretórios de Dados"**, você pode configurar onde os arquivos de dados (MDF/NDF) e de log (LDF) serão armazenados. Em um ambiente de produção, conforme aprendemos no Capítulo 3, recomenda-se colocar os arquivos de dados e de log em discos físicos separados. Em ambiente de desenvolvimento local, os caminhos padrão são suficientes.

Na aba **"TempDB"**, o instalador configurará automaticamente um arquivo de dados do tempdb por núcleo de CPU, até o máximo de 8 arquivos. Em máquinas de desenvolvimento, a configuração padrão é adequada.

Clique em **Avançar** e depois em **Instalar**. O processo levará entre 10 e 20 minutos dependendo da velocidade do computador.

## Passo a Passo: Instalação do SSMS

### Download do SSMS

O SSMS não é instalado junto com o SQL Server — ele é uma ferramenta separada e recebe atualizações independentes. Acesse `https://aka.ms/ssmsfullsetup` para baixar sempre a versão mais recente. O arquivo de instalação é o `SSMS-Setup-PTB.exe` com aproximadamente 600 MB.

### Instalação

Execute o instalador como administrador. Na tela inicial, verifique o caminho de instalação — o padrão `C:\Program Files (x86)\Microsoft SQL Server Management Studio 20\` é adequado. Clique em **Instalar**. O processo levará entre 5 e 10 minutos. Ao final, o instalador solicitará uma reinicialização do Windows — aceite para garantir que todos os componentes sejam registrados corretamente.

## Verificando os Serviços do Windows

Após a instalação e reinicialização, é fundamental verificar que os serviços do SQL Server estão em execução. Pressione `Windows + R`, digite `services.msc` e pressione `Enter`. Na janela de Serviços, localize os seguintes serviços:

**SQL Server (MSSQLSERVER)** deve estar com status **Em execução** e tipo de inicialização **Automático**. Este é o serviço principal — sem ele, nenhuma query pode ser executada.

**SQL Server Agent (MSSQLSERVER)** pode estar **Parado** com inicialização **Manual** por enquanto. Ele será necessário apenas quando você precisar de agendamento de tarefas (Capítulo 33).

**SQL Server Browser** pode estar **Parado**. Ele só é necessário quando você tiver múltiplas instâncias ou quando aplicações externas precisarem descobrir a instância automaticamente. Para desenvolvimento local, não é necessário.

~~~mermaid
graph LR
    Servicos[Windows Services]
    S1[SQL Server: MSSQLSERVER — Em execução ✅]
    S2[SQL Server Agent — Parado ⏸]
    S3[SQL Server Browser — Parado ⏸]

    Servicos --> S1
    Servicos --> S2
    Servicos --> S3
~~~

## Primeira Conexão com o SSMS

Abra o **SQL Server Management Studio** pelo menu Iniciar. A janela **"Conectar ao Servidor"** será exibida automaticamente. Preencha os campos da seguinte forma:

**Tipo de servidor:** Database Engine

**Nome do servidor:** digite um ponto final `.` ou `localhost` ou o nome do seu computador. O ponto final é um atalho que significa "a instância padrão nesta máquina local".

**Autenticação:** selecione **"Autenticação do Windows"** para usar sua conta do Windows — é a opção mais simples e segura para desenvolvimento local.

Clique em **Conectar**. Se a conexão for bem-sucedida, o **Object Explorer** no lado esquerdo exibirá a estrutura da instância com as pastas **Databases**, **Security**, **Server Objects**, **Replication** e **Management**.

~~~mermaid
graph TD
    SSMS[SSMS: Tela de Conexão]
    Config[Nome: localhost\nAutenticação: Windows]
    Conectar[Botão Conectar]
    ObjectExplorer[Object Explorer]
    Databases[Databases]
    SystemDBs[System Databases: master, model, msdb, tempdb]
    Security[Security]
    Management[Management]

    SSMS --> Config
    Config --> Conectar
    Conectar --> ObjectExplorer
    ObjectExplorer --> Databases
    Databases --> SystemDBs
    ObjectExplorer --> Security
    ObjectExplorer --> Management
~~~

## Verificando a Versão Instalada

Com o SSMS conectado, abra uma nova janela de query pressionando `Ctrl + N` ou clicando no botão **Nova Consulta** na barra de ferramentas. Digite o seguinte comando e pressione `F5` para executar:

~~~sql
-- Verificando a versão do SQL Server instalada
-- Este comando retorna informações completas sobre a versão,
-- edição e sistema operacional do servidor.
SELECT @@VERSION;
~~~

O resultado será uma string longa contendo a versão exata do SQL Server, o número de build, a edição (Developer Edition) e a versão do Windows. Confirme que a versão começa com `Microsoft SQL Server 2022`. Se o resultado aparecer no painel de resultados abaixo do editor, o ambiente está funcionando perfeitamente.

Execute também o segundo comando de verificação:

~~~sql
-- Verificando o nome da instância e configurações básicas
-- @@SERVERNAME retorna o nome do servidor e instância
-- @@SERVICENAME retorna o nome do serviço Windows
-- SERVERPROPERTY retorna propriedades específicas da instância
SELECT
    @@SERVERNAME        AS nome_servidor,        -- nome do servidor\instância
    @@SERVICENAME       AS nome_servico,          -- nome do serviço Windows
    SERVERPROPERTY('ProductVersion')  AS versao,  -- ex: 16.0.1000.6
    SERVERPROPERTY('Edition')         AS edicao,  -- Developer Edition (64-bit)
    SERVERPROPERTY('Collation')       AS collation; -- ordenação padrão da instância
~~~

## Configuração Pós-Instalação Recomendada

Com a instância instalada e funcionando, há algumas configurações pós-instalação que devem ser aplicadas antes de criar o **FinanceDB**. Execute o script abaixo em uma nova janela de query no SSMS:

~~~sql
-- ============================================================
-- CONFIGURAÇÕES PÓS-INSTALAÇÃO RECOMENDADAS
-- Executar conectado à instância padrão, no banco master
-- ============================================================

-- ETAPA 1: Configurar a memória máxima do SQL Server
-- Por padrão, o SQL Server pode consumir toda a memória RAM
-- disponível no servidor, deixando o sistema operacional sem
-- recursos. É uma boa prática reservar ao menos 2 GB para o SO.
-- Exemplo: se seu PC tem 16 GB, defina o máximo em 14 GB (14336 MB).
-- Ajuste o valor conforme a memória RAM do seu computador.

-- Habilitando opções avançadas de configuração
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;

-- Definindo memória máxima em MB (ajuste conforme seu hardware)
-- 14336 MB = 14 GB (reservando 2 GB para o Windows)
EXEC sp_configure 'max server memory (MB)', 14336;
RECONFIGURE;

-- ETAPA 2: Configurar o número máximo de grau de paralelismo (MAXDOP)
-- O MAXDOP controla quantas CPUs o SQL Server pode usar
-- para paralelizar uma única query. Em desenvolvimento,
-- o valor 0 (padrão, sem limite) é aceitável.
-- Em produção, recomenda-se definir conforme o número de núcleos.
-- Para desenvolvimento local, mantemos o padrão.
EXEC sp_configure 'max degree of parallelism', 0;
RECONFIGURE;

-- ETAPA 3: Desabilitando recursos desnecessários para desenvolvimento
-- O recurso 'xp_cmdshell' permite executar comandos do sistema
-- operacional via T-SQL. É um risco de segurança em produção.
-- Mantemos desabilitado por padrão.
EXEC sp_configure 'xp_cmdshell', 0;
RECONFIGURE;

-- ETAPA 4: Verificando as configurações aplicadas
-- Retorna todas as configurações da instância com os valores atuais
SELECT
    name         AS configuracao,  -- nome da configuração
    value        AS valor_definido, -- valor configurado por nós
    value_in_use AS valor_em_uso,   -- valor atualmente em uso
    description  AS descricao       -- descrição da configuração
FROM sys.configurations
WHERE name IN (
    'max server memory (MB)',
    'max degree of parallelism',
    'xp_cmdshell',
    'show advanced options'
)
ORDER BY name;
~~~

## Antecipação de Erros Comuns

**Erro: "O serviço SQL Server não pôde ser iniciado"**
Causa mais comum: porta 1433 bloqueada por outro processo ou pelo firewall do Windows. Solução: abra o **SQL Server Configuration Manager** (pesquise no menu Iniciar), expanda **SQL Server Network Configuration**, clique em **Protocols for MSSQLSERVER** e verifique se o protocolo **TCP/IP** está habilitado. Se não estiver, habilite-o e reinicie o serviço.

**Erro: "Não é possível conectar ao localhost"**
Causa: o serviço SQL Server está parado ou o nome do servidor está incorreto. Solução: abra `services.msc` e verifique se o serviço **SQL Server (MSSQLSERVER)** está em execução. Se não estiver, clique com o botão direito e selecione **Iniciar**.

**Erro: "Falha de login para o usuário 'sa'"**
Causa: a autenticação mista não foi habilitada durante a instalação, ou a senha digitada está incorreta. Solução: conecte com a autenticação do Windows (que foi configurada durante a instalação), expanda **Security > Logins** no Object Explorer, clique com o botão direito em **sa**, selecione **Propriedades**, vá na aba **Status** e verifique se o login está **Enabled** e se a opção **SQL Server and Windows Authentication mode** está selecionada em **Server Properties > Security**.

**Erro: "Setup account privileges" durante a instalação**
Causa: o instalador não foi executado como administrador. Solução: feche o instalador, clique com o botão direito no arquivo `.exe` e selecione **Executar como administrador**.

**Erro: ".NET Framework 4.7.2 ou superior é necessário"**
Causa: o SSMS requer o .NET Framework atualizado. Solução: acesse o Windows Update e instale todas as atualizações pendentes, ou baixe o .NET Framework diretamente em `https://dotnet.microsoft.com/download/dotnet-framework`.

## Troubleshooting

**O SSMS abre mas não mostra o Object Explorer**
Solução: no menu superior do SSMS, clique em **View > Object Explorer** ou pressione `F8` para abri-lo.

**A query foi executada mas não apareceu resultado**
Verifique se a aba **Results** está visível no painel inferior. Se não estiver, clique em **Query > Results To > Results to Grid** ou pressione `Ctrl + D`.

**O SQL Server Configuration Manager não aparece no menu Iniciar**
No Windows 11, pesquise por **"SQL Server 2022 Configuration Manager"** diretamente na barra de pesquisa. Alternativamente, execute `SQLServerManager16.msc` pelo `Windows + R`.

## Glossário Técnico

**Instância:** uma cópia independente e em execução do SQL Server Engine, com seus próprios bancos de dados, configurações e serviços. Múltiplas instâncias podem coexistir no mesmo servidor.

**Instância padrão (Default Instance):** instância identificada apenas pelo nome do servidor (`MEUPC`), sem sufixo de nome. Recomendada para ambientes com uma única versão do SQL Server.

**Instância nomeada (Named Instance):** instância identificada pelo nome do servidor seguido de um nome personalizado (`MEUPC\SQLDEV`). Necessária quando há múltiplas instâncias no mesmo servidor.

**MSSQLSERVER:** nome do serviço Windows que representa a instância padrão do SQL Server.

**SQL Server Agent:** serviço do Windows responsável por executar jobs agendados, alertas e tarefas automáticas como backups.

**SQL Server Browser:** serviço que auxilia clientes a localizar instâncias nomeadas do SQL Server na rede.

**Banco master:** banco de dados do sistema que armazena todas as configurações e metadados da instância. Crítico para a operação — deve ter backup frequente.

**Banco model:** template usado como base para a criação de novos bancos de dados.

**Banco msdb:** armazena histórico de backups, jobs do SQL Server Agent e alertas.

**Banco tempdb:** banco temporário recriado a cada reinicialização. Armazena tabelas temporárias e resultados intermediários de operações.

**MAXDOP (Max Degree of Parallelism):** configuração que controla quantas CPUs o SQL Server pode usar para paralelizar a execução de uma única query.

**Max Server Memory:** configuração que define o limite máximo de RAM que o Buffer Pool do SQL Server pode consumir.

**TDS (Tabular Data Stream):** protocolo de comunicação proprietário da Microsoft usado entre o SSMS (ou qualquer cliente) e o SQL Server para transmissão de queries e resultados.

**sp_configure:** procedure do sistema usada para visualizar e alterar configurações da instância do SQL Server.

**RECONFIGURE:** comando T-SQL que aplica imediatamente as alterações feitas com `sp_configure`.

## Desafio de Fixação

### Desafio 1 — Diagnóstico da instância

Conecte-se ao SQL Server pelo SSMS e execute uma única query que retorne em colunas separadas: o nome do servidor, a edição instalada, a versão do produto, a collation padrão da instância e a data e hora atual do servidor. Você deve usar apenas funções e propriedades nativas do SQL Server, sem consultar tabelas.

### Desafio 2 — Investigando os bancos do sistema

Execute uma query que liste todos os bancos de dados existentes na instância, mostrando o nome do banco, a data de criação, o tamanho em MB e o Recovery Model de cada um.

### Resolução Comentada

~~~sql
-- ============================================================
-- RESOLUÇÃO DO DESAFIO 1
-- Diagnóstico completo da instância com uma única query
-- ============================================================

SELECT
    @@SERVERNAME                              AS nome_servidor,
    -- @@SERVERNAME retorna MEUPC para instância padrão
    -- ou MEUPC\NOME para instância nomeada

    SERVERPROPERTY('Edition')                 AS edicao,
    -- Retorna 'Developer Edition (64-bit)'

    SERVERPROPERTY('ProductVersion')          AS versao_produto,
    -- Retorna o número de build exato: ex: 16.0.1000.6

    SERVERPROPERTY('Collation')               AS collation_instancia,
    -- Retorna a collation padrão da instância
    -- ex: SQL_Latin1_General_CP1_CI_AS
    -- CI = Case Insensitive, AS = Accent Sensitive

    GETDATE()                                 AS data_hora_servidor;
    -- GETDATE() retorna a data e hora atual do servidor SQL Server
    -- (não do computador cliente — importante em conexões remotas)

-- ============================================================
-- RESOLUÇÃO DO DESAFIO 2
-- Listando todos os bancos de dados com informações detalhadas
-- A view sys.databases expõe metadados de todos os bancos
-- A função sys.fn_virtualfilestats retorna tamanho de arquivos
-- Usamos sys.master_files para calcular o tamanho total
-- ============================================================

SELECT
    d.name                                    AS nome_banco,
    -- Nome do banco de dados

    d.create_date                             AS data_criacao,
    -- Data e hora de criação do banco de dados

    d.recovery_model_desc                     AS recovery_model,
    -- FULL, SIMPLE ou BULK_LOGGED
    -- Observe que master e tempdb usam SIMPLE por padrão
    -- O FinanceDB usará FULL (configurado na Aula 7)

    CAST(
        SUM(mf.size) * 8.0 / 1024 AS DECIMAL(10,2)
    )                                         AS tamanho_total_MB
    -- mf.size está em páginas de 8 KB
    -- Multiplicamos por 8 para converter para KB
    -- Dividimos por 1024 para converter para MB

FROM sys.databases d
-- sys.databases: view do sistema com um registro por banco de dados

INNER JOIN sys.master_files mf
-- sys.master_files: view do sistema com um registro por arquivo
-- (MDF, NDF e LDF) de cada banco de dados
    ON d.database_id = mf.database_id

GROUP BY
    d.name,
    d.create_date,
    d.recovery_model_desc
-- Agrupamos porque somamos os tamanhos de todos os arquivos
-- (dados + log) de cada banco

ORDER BY
    d.name;
-- Ordena alfabeticamente pelo nome do banco
~~~

## Resumo dos Pontos-Chave

Uma **instância** do SQL Server é uma cópia independente do Engine com seus próprios bancos, configurações e serviços. Para o curso, usamos uma **instância padrão** com a **edição Developer**, gratuita e com todos os recursos da edição Enterprise. Os quatro **bancos do sistema** são **master** (configurações da instância), **model** (template para novos bancos), **msdb** (histórico de backups e jobs) e **tempdb** (dados temporários, recriado a cada reinicialização). Após a instalação, configuramos a **memória máxima** do servidor para reservar ao menos 2 GB para o Windows. O **SSMS** é instalado separadamente e se conecta à instância via protocolo **TDS**. A view `sys.databases` e a função `SERVERPROPERTY` são as ferramentas nativas para inspecionar o estado da instância. O ambiente está pronto para receber o **FinanceDB** a partir do Capítulo 7.

## Próximos Passos

No próximo capítulo, dominaremos a interface do **SSMS** em profundidade: exploraremos o **Object Explorer**, o **Query Editor**, o **Results Pane**, os atalhos de teclado essenciais, as configurações de produtividade e os recursos de formatação e execução de scripts que usaremos ao longo de todo o curso.

## Log de Estado do Projeto

~~~text
## Log de Estado — Capítulo 4
- Projeto: FinanceDB
- Módulo: 1 — Fundamentos e Teoria
- Capítulo: 4 — Instalação e Configuração do Ambiente
- Objetivo: Concluído ✅
- Banco de Dados: Não criado (Capítulo 7)
- Tabelas: Não criadas (Capítulos 8 e 9)
- Dados: Nenhum
- Entregável do Capítulo: ambiente_config.sql com verificações
  da instância e configurações pós-instalação aplicadas
- Configurações Aplicadas:
    ✅ SQL Server 2022 Developer Edition instalado
    ✅ SSMS instalado e conectado
    ✅ Autenticação mista habilitada
    ✅ Memória máxima configurada
    ✅ MAXDOP configurado
    ✅ xp_cmdshell desabilitado
    ✅ Primeira conexão realizada com sucesso
    ✅ Bancos do sistema verificados
- Estado Funcional: ✅ Ambiente 100% operacional.
- Próximas Etapas: Capítulo 5 — Navegando no SSMS
~~~

## Prompt de Continuidade para o Capítulo 5

~~~text
Contexto: Estou estudando o livro "SQL Server para Aplicações
Financeiras com T-SQL". Meu ambiente é Windows 11, SSMS,
SQL Server 2022. O projeto prático incremental se chama FinanceDB.

Concluí o Capítulo 4, que cobriu a instalação completa do
SQL Server 2022 Developer Edition e do SSMS no Windows 11,
a configuração pós-instalação (memória máxima, MAXDOP,
xp_cmdshell desabilitado), a verificação dos serviços no
Windows Services e a primeira conexão bem-sucedida via SSMS.
O arquivo ambiente_config.sql foi criado em
modulo_01_fundamentos/aula_04/ com todos os scripts de
verificação e configuração da instância.

Siga rigorosamente o Prompt Mestre v1.1: narrativa densa com
mínimo de 2.000 palavras, Técnica de Feynman, analogia de
ancoragem, diagrama Mermaid escapado com ~~~mermaid, código SQL
comentado linha a linha escapado com ~~~, glossário técnico,
antecipação de erros, troubleshooting, desafio de fixação com
resolução comentada, resumo dos pontos-chave, log de estado do
projeto atualizado e prompt de continuidade para o próximo capítulo.
Todo o conteúdo deve ser gerado dentro de um bloco ```markdown.
Chame aulas de capítulos e curso de livro.

Por favor, gere o Capítulo 5: Navegando no SSMS — Interface e
Recursos Essenciais. Objetivo: dominar a interface do SSMS,
explorar o Object Explorer, o Query Editor, o Results Pane,
os atalhos essenciais de teclado, as configurações recomendadas
para produtividade e os recursos de formatação e execução de
scripts que serão usados ao longo de todo o livro.
Pré-requisito: Capítulos 1 a 4 concluídos, ambiente instalado
e funcionando.
~~~

Dúvidas? Posso prosseguir para o Capítulo 5?