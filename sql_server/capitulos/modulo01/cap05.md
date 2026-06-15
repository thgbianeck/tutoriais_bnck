# Capítulo 5: Navegando no SSMS — Interface e Recursos Essenciais

## Livro: SQL Server para Aplicações Financeiras com T-SQL

## Módulo 1 — FUNDAMENTOS: Teoria e Ambiente

## Análise de Integridade

✅ Conteúdo verificado: profundidade técnica mantida, linguagem acessível pela Técnica de Feynman, narrativa com mínimo de 2.000 palavras, analogia de ancoragem presente, diagrama Mermaid incluído, glossário técnico completo, antecipação de erros mapeada, desafio de fixação com resolução comentada, log de estado atualizado e prompt de continuidade gerado.

## Resumo do Capítulo Anterior

No **Capítulo 4** instalamos o **SQL Server 2022 Developer Edition** e o **SSMS** no Windows 11. Configuramos a instância local com autenticação mista, ajustamos a memória máxima do servidor, desabilitamos o `xp_cmdshell`, definimos o **Recovery Model FULL** e realizamos a primeira conexão bem-sucedida. Verificamos os quatro bancos do sistema — **master**, **model**, **msdb** e **tempdb** — e registramos todas as configurações no arquivo `ambiente_config.sql`.

## Objetivo

Dominar a interface do **SQL Server Management Studio (SSMS)** em profundidade: entender cada painel, explorar o **Object Explorer**, operar o **Query Editor** com confiança, interpretar o **Results Pane**, memorizar os **atalhos de teclado essenciais**, ajustar as **configurações de produtividade** e compreender os recursos de formatação e execução de scripts que serão usados ao longo de todo o livro. Ao final deste capítulo, o SSMS será uma extensão natural das suas mãos — você navegará nele sem hesitação.

## Pré-requisitos

**Capítulos 1 a 4 concluídos.** O SQL Server 2022 e o SSMS devem estar instalados e conectados conforme o Capítulo 4.

## Teoria Detalhada

### A analogia de ancoragem: o SSMS como a cabine de um avião

Imagine que você acaba de ser contratado como piloto de um avião comercial. O motor já está instalado — esse é o SQL Server. O que você precisa agora é aprender a cabine: onde fica cada instrumento, o que cada painel indica, quais são os botões que você vai usar com mais frequência e quais os que nunca deve acionar sem entender o efeito. Pilotos experientes não olham mais para os controles — seus dedos encontram os botões por memória muscular, e seus olhos leem os instrumentos de forma fluida e natural. É exatamente esse nível de familiaridade com o SSMS que este capítulo vai construir em você.

O SSMS é a interface entre você e o SQL Server. Tudo que você escrever, executar, monitorar e administrar ao longo dos próximos capítulos passará por ele. Conhecê-lo profundamente não é opcional — é o que separa alguém que sobrevive no SSMS de alguém que trabalha com eficiência real.

### A janela principal do SSMS

Ao abrir o SSMS e conectar-se à instância, você se depara com uma interface dividida em regiões bem definidas. Cada região tem uma função específica e elas trabalham em conjunto para dar ao desenvolvedor e ao administrador de banco de dados uma visão completa e controlada do ambiente.

A interface principal do SSMS é composta por cinco grandes áreas: o **Menu Principal** no topo, a **Toolbar** logo abaixo, o **Object Explorer** à esquerda, o **Query Editor** ao centro e o **Results Pane** na parte inferior. Existe ainda o **Properties Window**, o **Template Explorer** e o **Solution Explorer**, que são painéis auxiliares acessíveis pelo menu View. Vamos explorar cada um deles com a profundidade necessária para que você se sinta completamente em casa.

### O Object Explorer

O **Object Explorer** é o painel lateral esquerdo do SSMS. Ele exibe, em formato de árvore hierárquica, todos os objetos da sua instância do SQL Server. É por aqui que você navega entre bancos de dados, tabelas, views, stored procedures, usuários, jobs e dezenas de outros objetos.

A raiz da árvore é a **instância** à qual você está conectado — por exemplo, `MEUPC\SQLEXPRESS` ou simplesmente `MEUPC` no caso de uma instância padrão. Abaixo dela, você encontra os seguintes nós principais: **Databases** (onde ficam todos os bancos de dados, incluindo os do sistema e os criados pelo usuário), **Security** (onde ficam os Logins da instância), **Server Objects** (onde ficam os Linked Servers e os triggers de servidor), **Replication**, **PolyBase**, **Always On High Availability**, **Management** (onde ficam os planos de manutenção, o Activity Monitor e os logs do SQL Server Agent) e **SQL Server Agent** (onde ficam os Jobs agendados).

Para o **FinanceDB**, o nó mais importante no momento é o **Databases**. Ao expandi-lo, você verá os bancos do sistema em uma subpasta chamada **System Databases** e, logo abaixo, qualquer banco criado pelo usuário. Ao expandir um banco de dados, você encontra subnós como **Tables**, **Views**, **Programmability** (que contém Stored Procedures, Functions e Triggers), **Security** (usuários e schemas do banco), **Storage** e **Service Broker**.

Dentro do nó **Tables**, cada tabela pode ser expandida para revelar suas **Columns**, **Keys**, **Constraints**, **Indexes** e **Statistics** — tudo visível e navegável graficamente, sem precisar digitar uma única linha de T-SQL. Essa capacidade de introspecção visual é uma das grandes vantagens do SSMS em relação a editores de texto simples.

### O Query Editor

O **Query Editor** é o coração produtivo do SSMS. É nele que você escreve, edita e executa código T-SQL. Para abrir uma nova janela do Query Editor, você pode usar o botão **New Query** na toolbar, pressionar `Ctrl + N` ou clicar com o botão direito sobre um banco de dados no Object Explorer e selecionar **New Query** — nesse caso, o editor já abrirá com o contexto de banco correto.

O Query Editor possui recursos que elevam significativamente a produtividade. O **IntelliSense** é o sistema de autocompletar do SSMS: enquanto você digita, ele sugere palavras-chave T-SQL, nomes de tabelas, colunas e objetos do banco selecionado. Para acionar manualmente o IntelliSense, use `Ctrl + Espaço`. Para forçar a atualização do cache do IntelliSense — necessário quando você acabou de criar um novo objeto e ele ainda não aparece nas sugestões — use `Ctrl + Shift + R`.

O **destaque de sintaxe** (syntax highlighting) colore automaticamente as palavras-chave em azul, as strings em vermelho, os comentários em verde e os identificadores em preto, tornando o código muito mais legível. O **indicador de erros** sublinha em vermelho ondulado qualquer trecho de código que o parser do SSMS identifica como inválido antes mesmo de você executar — funciona de forma similar ao corretor ortográfico de um editor de texto.

O **contexto de banco de dados** é exibido em um dropdown na toolbar do Query Editor. Ele indica em qual banco de dados a query será executada. Você pode alterar esse contexto diretamente no dropdown ou usando o comando T-SQL `USE nome_do_banco`. É fundamental verificar esse contexto antes de executar qualquer script, especialmente scripts de modificação estrutural — executar um `DROP TABLE` no banco errado por descuido é um erro clássico e potencialmente catastrófico.

### O Results Pane

O **Results Pane** fica abaixo do Query Editor e exibe os resultados da execução. Ele tem três abas principais: **Results**, **Messages** e **Execution Plan**.

A aba **Results** exibe os dados retornados por um `SELECT` em formato de grade tabular, com cabeçalhos de coluna clicáveis para ordenação. Você pode selecionar células, linhas inteiras ou o conteúdo completo da grade, copiar com `Ctrl + C` e colar em planilhas Excel — muito útil para validação de dados durante o desenvolvimento.

A aba **Messages** exibe as mensagens de retorno do SQL Server após a execução: confirmações de comandos DML como `(1 row affected)`, mensagens de erro com código e descrição, avisos e informações de tempo de execução. Quando um erro ocorre, é na aba Messages que você encontrará o código do erro (como `Msg 208` para objeto não encontrado), a severidade, o estado e a linha exata onde ocorreu o problema.

A aba **Execution Plan** exibe o plano de execução da query — uma representação visual de como o SQL Server decidiu processar o comando. Este recurso será explorado em profundidade no Capítulo 35, mas é importante saber que ele existe e pode ser ativado a qualquer momento com `Ctrl + M` (Include Actual Execution Plan) antes de executar uma query.

### Atalhos de teclado essenciais

Os atalhos de teclado são a diferença entre um desenvolvedor que pensa no código e um que pensa na interface. Memorize os seguintes atalhos desde o primeiro dia:

`F5` executa a query inteira ou o trecho selecionado — é o atalho mais usado de todos. `Ctrl + E` faz o mesmo. `Ctrl + F5` analisa a query sem executar, verificando apenas a sintaxe. `Ctrl + N` abre uma nova janela do Query Editor. `Ctrl + O` abre um arquivo `.sql` existente. `Ctrl + S` salva o script atual. `Ctrl + Z` desfaz a última ação. `Ctrl + Y` refaz. `Ctrl + A` seleciona todo o conteúdo do editor. `Ctrl + C` copia. `Ctrl + X` recorta. `Ctrl + V` cola.

`Ctrl + K` seguido de `Ctrl + C` comenta o trecho selecionado. `Ctrl + K` seguido de `Ctrl + U` descomenta. `Ctrl + L` exibe o plano de execução estimado sem executar a query. `Ctrl + M` ativa o plano de execução real, que será exibido após a execução. `Ctrl + R` oculta ou exibe o Results Pane — muito útil quando você quer mais espaço para escrever. `Ctrl + Shift + U` converte o texto selecionado para maiúsculas. `Ctrl + Shift + L` converte para minúsculas. `Alt + F4` fecha o SSMS.

`F1` abre a documentação online da palavra-chave sob o cursor — extremamente útil durante o aprendizado. Posicione o cursor sobre qualquer palavra-chave T-SQL e pressione `F1` para ir diretamente à documentação oficial da Microsoft.

### Configurações de produtividade recomendadas

O SSMS permite inúmeras personalizações. As mais impactantes para produtividade estão em **Tools → Options**. As configurações recomendadas para o curso são as seguintes.

Em **Query Execution → SQL Server → Advanced**, defina **SET NOCOUNT ON** como padrão — isso suprime a mensagem `(n rows affected)` de queries intermediárias em scripts longos, deixando o output mais limpo. Em **Query Results → SQL Server → Results to Grid**, marque **Include column headers when copying or saving results** para garantir que os cabeçalhos sejam incluídos ao copiar dados para o Excel. Em **Text Editor → Transact-SQL → General**, ative **Line numbers** — ver os números de linha é essencial quando o SQL Server reporta um erro em uma linha específica. Em **Environment → Fonts and Colors**, você pode ajustar o tamanho da fonte do editor — recomendamos pelo menos 13pt para conforto visual durante sessões longas. Em **Query Execution → General**, configure o **Execution time-out** como 0 para queries de desenvolvimento, evitando que consultas longas sejam interrompidas automaticamente.

### Snippets e Templates

O SSMS possui um recurso chamado **Code Snippets** — fragmentos de código T-SQL pré-prontos que podem ser inseridos rapidamente no editor. Para acessar os snippets, clique com o botão direito dentro do Query Editor e selecione **Insert Snippet**, ou use o atalho `Ctrl + K` seguido de `Ctrl + X`. Existem snippets prontos para `CREATE TABLE`, `CREATE PROCEDURE`, `CREATE INDEX`, `IF EXISTS` e vários outros padrões comuns.

O **Template Explorer**, acessível pelo menu **View → Template Explorer**, oferece templates mais completos para criação de objetos — são scripts esqueleto com placeholders que você preenche com os valores específicos do seu cenário. Para substituir todos os placeholders de uma vez, use `Ctrl + Shift + M` após inserir um template.

### O Activity Monitor

O **Activity Monitor** é uma ferramenta de monitoramento em tempo real acessível pelo menu **Tools → Activity Monitor** ou pelo atalho `Ctrl + Alt + A`. Ele exibe quatro painéis: **Processes** (conexões ativas e queries em execução), **Resource Waits** (o que o SQL Server está aguardando), **Data File I/O** (leitura e escrita nos arquivos de dados) e **Recent Expensive Queries** (as queries que consumiram mais recursos recentemente).

Para o desenvolvimento do **FinanceDB**, o Activity Monitor será útil para identificar queries lentas durante os testes de performance nos Capítulos 34 e 35. Por ora, vale apenas saber que ele existe e como acessá-lo.

### Salvando e organizando scripts

Uma disciplina essencial que deve começar desde agora é a de **salvar todos os scripts** desenvolvidos durante o curso. Cada script deve ser salvo na pasta correspondente à sua aula dentro da estrutura do projeto **FinanceDB**. Use nomes descritivos como `criar_tabela_empresas.sql`, `inserir_dados_contas.sql` e `relatorio_transacoes_mensais.sql`. Evite nomes genéricos como `query1.sql` ou `teste.sql` — eles se tornam inúteis após alguns dias.

O SSMS não salva automaticamente — use `Ctrl + S` com frequência. Além disso, configure o SSMS para exibir o nome completo do arquivo na barra de título em **Tools → Options → Environment → General → Show full path in title bar**.

## Diagrama: Anatomia do SSMS

~~~mermaid
graph TD
    SSMS[SQL Server Management Studio]

    SSMS --> ME[Menu Principal]
    SSMS --> TB[Toolbar]
    SSMS --> OE[Object Explorer]
    SSMS --> QE[Query Editor]
    SSMS --> RP[Results Pane]
    SSMS --> PA[Painéis Auxiliares]

    OE --> DB[Databases]
    OE --> SEC[Security]
    OE --> MGT[Management]
    OE --> AG[SQL Server Agent]

    DB --> SYS[System Databases]
    DB --> USR[User Databases]
    USR --> FDB[FinanceDB]
    FDB --> TBL[Tables]
    FDB --> VW[Views]
    FDB --> PRG[Programmability]
    PRG --> SP[Stored Procedures]
    PRG --> FN[Functions]
    PRG --> TR[Triggers]

    QE --> IS[IntelliSense]
    QE --> SH[Syntax Highlighting]
    QE --> CTX[Contexto de Banco]
    QE --> SN[Snippets e Templates]

    RP --> RES[Aba Results]
    RP --> MSG[Aba Messages]
    RP --> EP[Aba Execution Plan]

    PA --> TE[Template Explorer]
    PA --> AM[Activity Monitor]
    PA --> SE[Solution Explorer]
~~~

## Código T-SQL Comentado — Primeiros Scripts no SSMS

~~~sql
-- ============================================================
-- CAPÍTULO 5 — PRIMEIROS SCRIPTS NO SSMS
-- Arquivo: primeiros_scripts_ssms.sql
-- Pasta: modulo_01_fundamentos/aula_05/
-- Objetivo: verificar o ambiente, explorar o contexto de banco
--           e praticar execução de scripts no Query Editor
-- ============================================================

-- ─────────────────────────────────────────────────────────────
-- BLOCO 1: Verificando a versão e o nome da instância
-- ─────────────────────────────────────────────────────────────

-- SERVERPROPERTY retorna propriedades da instância atual
-- 'ProductVersion' retorna o número de versão completo
-- 'ProductLevel' retorna o service pack ou RTM
-- 'Edition' retorna a edição (Developer, Standard, Enterprise)
SELECT
    SERVERPROPERTY('ProductVersion')  AS versao,        -- ex: 16.0.1000.6
    SERVERPROPERTY('ProductLevel')    AS nivel,          -- ex: RTM
    SERVERPROPERTY('Edition')         AS edicao,         -- ex: Developer Edition
    SERVERPROPERTY('ServerName')      AS nome_servidor;  -- ex: MEUPC

-- ─────────────────────────────────────────────────────────────
-- BLOCO 2: Verificando os bancos de dados existentes
-- ─────────────────────────────────────────────────────────────

-- sys.databases é uma view de catálogo que lista todos os bancos
-- da instância, incluindo os bancos do sistema e os do usuário
SELECT
    name                AS nome_banco,       -- nome do banco
    database_id         AS id,               -- ID interno
    state_desc          AS estado,           -- ONLINE, OFFLINE, etc.
    recovery_model_desc AS recovery_model,   -- FULL, SIMPLE, BULK_LOGGED
    create_date         AS data_criacao      -- data de criação
FROM
    sys.databases
ORDER BY
    database_id;  -- ordena pelo ID para exibir na ordem de criação

-- ─────────────────────────────────────────────────────────────
-- BLOCO 3: Alternando o contexto de banco de dados
-- ─────────────────────────────────────────────────────────────

-- USE define o banco de dados ativo para a sessão atual
-- Toda query executada após este comando afetará este banco
-- É equivalente a selecionar o banco no dropdown da toolbar
USE master;  -- muda para o banco master (banco do sistema)
GO           -- GO é o separador de lotes (batches) no T-SQL
             -- ele indica ao SSMS onde um lote termina e outro começa
             -- GO não é um comando T-SQL — é uma instrução do SSMS

-- Verificando em qual banco estamos no momento
SELECT DB_NAME() AS banco_atual;  -- DB_NAME() retorna o nome do banco ativo

-- ─────────────────────────────────────────────────────────────
-- BLOCO 4: Verificando conexões ativas na instância
-- ─────────────────────────────────────────────────────────────

-- sys.dm_exec_sessions lista todas as sessões ativas
-- is_user_process = 1 filtra apenas as sessões de usuários reais
-- excluindo os processos internos do SQL Server
SELECT
    session_id      AS id_sessao,         -- ID da sessão
    login_name      AS login,             -- usuário conectado
    host_name       AS maquina,           -- máquina de origem
    program_name    AS programa,          -- programa (ex: SSMS)
    status          AS status,            -- running, sleeping, etc.
    cpu_time        AS cpu_ms,            -- CPU usada em milissegundos
    memory_usage    AS paginas_memoria    -- memória usada em páginas de 8KB
FROM
    sys.dm_exec_sessions
WHERE
    is_user_process = 1  -- apenas sessões de usuários, não processos internos
ORDER BY
    session_id;

-- ─────────────────────────────────────────────────────────────
-- BLOCO 5: Usando comentários corretamente em scripts T-SQL
-- ─────────────────────────────────────────────────────────────

-- Este é um comentário de linha única
-- Use para explicar uma linha ou pequeno trecho de código

/*
   Este é um comentário de bloco (multi-linha).
   Use para descrever seções inteiras de código,
   cabeçalhos de arquivos ou desativar blocos durante testes.

   Exemplo de cabeçalho padrão que usaremos em todos os scripts:
   Arquivo: nome_do_arquivo.sql
   Módulo: Módulo X — Nome do Módulo
   Capítulo: X — Nome do Capítulo
   Autor: FinanceDB Course
   Data: 2026-06-14
   Objetivo: descrição clara do que o script faz
*/

-- Comentário inline — aparece ao lado do código na mesma linha
SELECT GETDATE() AS data_e_hora_atual;  -- GETDATE() retorna o timestamp atual

-- ─────────────────────────────────────────────────────────────
-- BLOCO 6: Executando partes específicas de um script
-- ─────────────────────────────────────────────────────────────

-- DICA IMPORTANTE: você não precisa executar o script inteiro sempre.
-- Selecione com o mouse apenas o trecho que deseja executar
-- e pressione F5 — apenas o trecho selecionado será executado.
-- Isso é fundamental para scripts longos com múltiplos blocos.

-- Exemplo: selecione apenas esta linha e pressione F5
SELECT 'Apenas esta linha foi executada' AS resultado;

-- ─────────────────────────────────────────────────────────────
-- BLOCO 7: Verificando as configurações atuais da instância
-- ─────────────────────────────────────────────────────────────

-- sys.configurations lista todas as opções de configuração do servidor
-- value_in_use mostra o valor atualmente em uso (pode diferir de value
-- se a configuração requer reinicialização para entrar em vigor)
SELECT
    name            AS configuracao,    -- nome da opção
    value           AS valor_definido,  -- valor configurado
    value_in_use    AS valor_ativo,     -- valor realmente em uso agora
    description     AS descricao        -- descrição da opção
FROM
    sys.configurations
WHERE
    name IN (
        'max server memory (MB)',   -- memória máxima que configuramos no Cap. 4
        'max degree of parallelism', -- MAXDOP que configuramos no Cap. 4
        'xp_cmdshell'               -- deve estar 0 (desabilitado)
    )
ORDER BY
    name;
~~~

## Glossário Técnico

**SSMS (SQL Server Management Studio):** ambiente integrado da Microsoft para gerenciamento, desenvolvimento e administração do SQL Server. Disponível gratuitamente em download separado do SQL Server.

**Object Explorer:** painel lateral hierárquico do SSMS que exibe todos os objetos da instância conectada em formato de árvore navegável.

**Query Editor:** editor de código T-SQL integrado ao SSMS, com IntelliSense, destaque de sintaxe e execução direta de scripts.

**IntelliSense:** sistema de autocompletar do SSMS que sugere palavras-chave, objetos e colunas enquanto o desenvolvedor digita.

**Results Pane:** painel inferior do SSMS que exibe os resultados de queries, mensagens de retorno e planos de execução.

**GO:** separador de lotes (batch separator) do SSMS. Não é um comando T-SQL — instrui o SSMS a enviar o lote de comandos até aquele ponto ao SQL Server para execução.

**Batch (lote):** conjunto de instruções T-SQL enviadas ao SQL Server de uma vez, delimitado pelo separador GO. Cada lote é compilado e executado de forma independente.

**sys.databases:** view de catálogo do sistema que lista todos os bancos de dados da instância com seus metadados.

**sys.dm_exec_sessions:** Dynamic Management View (DMV) que exibe informações sobre as sessões atualmente ativas no SQL Server.

**sys.configurations:** view de catálogo que exibe as opções de configuração da instância e seus valores atuais.

**DB_NAME():** função do sistema que retorna o nome do banco de dados atualmente em uso na sessão.

**SERVERPROPERTY():** função do sistema que retorna propriedades da instância do SQL Server, como versão, edição e nome do servidor.

**Code Snippet:** fragmento de código T-SQL pré-definido disponível no SSMS para inserção rápida de padrões comuns de código.

**Template Explorer:** painel do SSMS que oferece templates completos para criação de objetos, com placeholders substituíveis.

**Activity Monitor:** ferramenta do SSMS para monitoramento em tempo real de processos, esperas, I/O e queries caras na instância.

## Antecipação de Erros e Troubleshooting

**Problema: IntelliSense não sugere as tabelas ou colunas que acabei de criar.**
Causa: o cache do IntelliSense não foi atualizado após a criação do novo objeto.
Solução: pressione `Ctrl + Shift + R` para forçar a atualização do cache do IntelliSense. Se o problema persistir, feche e reabra a janela do Query Editor.

**Problema: Executei um script e nada aconteceu — nenhum resultado, nenhuma mensagem.**
Causa: provavelmente você esqueceu de selecionar o texto antes de pressionar F5, ou o script foi executado no banco errado.
Solução: verifique o dropdown de contexto de banco na toolbar. Clique na aba **Messages** para verificar se há alguma mensagem que passou despercebida.

**Problema: O SSMS está lento ao expandir nós do Object Explorer.**
Causa: instâncias com muitos objetos ou conexões de rede lentas podem tornar o Object Explorer lento.
Solução: em **Tools → Options → SQL Server Object Explorer**, desmarque **Automatically refresh Object Explorer after executing a script**. Isso faz com que o Object Explorer só atualize quando você pressionar F5 nele explicitamente.

**Problema: Recebi o erro "Invalid object name" ao executar uma query.**
Causa: o banco de dados selecionado no contexto não é o banco onde o objeto existe.
Solução: verifique o dropdown de contexto ou execute `SELECT DB_NAME()` para confirmar em qual banco você está. Use `USE nome_do_banco` para mudar o contexto.

**Problema: O SSMS não está salvando minha senha de conexão.**
Causa: por padrão, o SSMS não armazena senhas SQL após o fechamento.
Solução: ao conectar, marque a opção **Remember password** na tela de conexão. Isso armazena a senha criptografada localmente. Para conexões com autenticação do Windows, a senha não é necessária.

**Problema: O Results Pane sumiu — não vejo mais os resultados.**
Causa: o painel foi fechado ou minimizado acidentalmente.
Solução: pressione `Ctrl + R` para alternar a visibilidade do Results Pane.

## Desafio de Fixação

**Enunciado:** Execute os seguintes passos no SSMS e registre os resultados no arquivo `desafio_05.sql`:

1. Abra uma nova janela do Query Editor usando o atalho de teclado correto.
2. Verifique a versão, edição e nome do servidor da sua instância usando `SERVERPROPERTY`.
3. Liste todos os bancos de dados da instância com nome, estado e recovery model usando `sys.databases`.
4. Alterne o contexto para o banco `master` usando `USE` e confirme com `DB_NAME()`.
5. Liste as sessões ativas usando `sys.dm_exec_sessions`.
6. Verifique as três configurações aplicadas no Capítulo 4 usando `sys.configurations`.
7. Comente cada bloco de código com um comentário de linha explicando o que ele faz.
8. Salve o arquivo como `desafio_05.sql` na pasta `modulo_01_fundamentos/aula_05/exercicios/`.

## Resolução Comentada do Desafio

~~~sql
-- ============================================================
-- RESOLUÇÃO DO DESAFIO — CAPÍTULO 5
-- Arquivo: desafio_05.sql
-- Pasta: modulo_01_fundamentos/aula_05/exercicios/
-- ============================================================

-- PASSO 1: Nova janela aberta com Ctrl + N ✅

-- PASSO 2: Verificando propriedades da instância
SELECT
    SERVERPROPERTY('ProductVersion') AS versao,      -- número de build completo
    SERVERPROPERTY('ProductLevel')   AS nivel,        -- RTM ou SP
    SERVERPROPERTY('Edition')        AS edicao,       -- Developer Edition
    SERVERPROPERTY('ServerName')     AS nome_servidor; -- nome da máquina/instância

-- PASSO 3: Listando todos os bancos de dados
SELECT
    name                AS nome_banco,      -- nome do banco
    state_desc          AS estado,          -- ONLINE, OFFLINE
    recovery_model_desc AS recovery_model   -- FULL ou SIMPLE
FROM
    sys.databases
ORDER BY
    database_id;  -- ordem de criação

-- PASSO 4: Alternando para o banco master e confirmando
USE master;
GO

SELECT DB_NAME() AS banco_atual;  -- deve retornar 'master'

-- PASSO 5: Listando sessões ativas de usuários
SELECT
    session_id   AS id_sessao,   -- identificador da sessão
    login_name   AS login,       -- usuário autenticado
    host_name    AS maquina,     -- origem da conexão
    program_name AS programa,    -- cliente (ex: Microsoft SQL Server Management Studio)
    status        AS status      -- running ou sleeping
FROM
    sys.dm_exec_sessions
WHERE
    is_user_process = 1  -- apenas sessões de usuário real
ORDER BY
    session_id;

-- PASSO 6: Verificando configurações aplicadas no Capítulo 4
SELECT
    name         AS configuracao,   -- nome da opção
    value_in_use AS valor_ativo     -- valor realmente em uso
FROM
    sys.configurations
WHERE
    name IN (
        'max server memory (MB)',    -- memória máxima definida
        'max degree of parallelism', -- MAXDOP definido
        'xp_cmdshell'               -- deve estar 0
    )
ORDER BY
    name;

-- RESULTADO ESPERADO:
-- max degree of parallelism → valor definido no Capítulo 4
-- max server memory (MB)    → valor definido no Capítulo 4
-- xp_cmdshell               → 0 (desabilitado)
~~~

## Resumo dos Pontos-Chave

O **SSMS** é composto por cinco grandes áreas: **Menu Principal**, **Toolbar**, **Object Explorer**, **Query Editor** e **Results Pane**. O **Object Explorer** exibe todos os objetos da instância em hierarquia navegável — bancos, tabelas, views, procedures, usuários e muito mais. O **Query Editor** é o editor T-SQL com **IntelliSense**, **destaque de sintaxe** e controle de **contexto de banco de dados**. O **Results Pane** possui três abas: **Results** (dados), **Messages** (confirmações e erros) e **Execution Plan** (plano de execução). O atalho `F5` executa a query ou o trecho selecionado. `Ctrl + Shift + R` atualiza o cache do IntelliSense. O separador `GO` delimita **lotes (batches)** no T-SQL. As views de catálogo `sys.databases`, `sys.configurations` e `sys.dm_exec_sessions` são instrumentos de inspeção fundamentais da instância. Configurações recomendadas incluem **Line numbers**, **Include column headers** ao copiar e **Show full path in title bar**.

## Próximos Passos

No próximo capítulo, encerraremos o **Módulo 1** com um tema denso e fundamental: os **Tipos de Dados do SQL Server**. Entenderemos cada família de tipos — numéricos, texto, data e hora, binários e especiais — e aprenderemos a escolher o tipo correto para cada coluna do **FinanceDB**, decisão que impacta diretamente performance, precisão e integridade dos dados financeiros.

## Log de Estado do Projeto

~~~text
## Log de Estado — Capítulo 5
- Projeto: FinanceDB
- Módulo: 1 — Fundamentos e Teoria
- Capítulo: 5 — Navegando no SSMS
- Objetivo: Concluído ✅
- Banco de Dados: Não criado (Capítulo 7)
- Tabelas: Não criadas (Capítulos 8 e 9)
- Dados: Nenhum
- Entregável do Capítulo: primeiros_scripts_ssms.sql com scripts
  de inspeção da instância e desafio_05.sql resolvido
- Habilidades SSMS Adquiridas:
    ✅ Object Explorer navegado com confiança
    ✅ Query Editor dominado com IntelliSense
    ✅ Results Pane interpretado (Results, Messages, Execution Plan)
    ✅ Atalhos essenciais memorizados (F5, Ctrl+N, Ctrl+S, etc.)
    ✅ Configurações de produtividade aplicadas
    ✅ sys.databases, sys.configurations e sys.dm_exec_sessions consultados
    ✅ Comentários de linha e bloco aplicados corretamente
    ✅ GO como separador de lotes compreendido
- Estado Funcional: ✅ Ambiente dominado, pronto para o Módulo 2.
- Próximas Etapas: Capítulo 6 — Tipos de Dados no SQL Server
~~~

## Prompt de Continuidade para o Capítulo 6

~~~text
Contexto: Estou estudando o livro "SQL Server para Aplicações
Financeiras com T-SQL". Meu ambiente é Windows 11, SSMS,
SQL Server 2022. O projeto prático incremental se chama FinanceDB.

Concluí o Capítulo 5, que cobriu a interface completa do SSMS:
Object Explorer, Query Editor com IntelliSense e destaque de
sintaxe, Results Pane com as abas Results, Messages e Execution
Plan, atalhos essenciais de teclado, configurações de
produtividade, Code Snippets, Template Explorer e Activity Monitor.
Os scripts primeiros_scripts_ssms.sql e desafio_05.sql foram
criados em modulo_01_fundamentos/aula_05/.

Siga rigorosamente o Prompt Mestre v1.1: narrativa densa com
mínimo de 2.000 palavras, Técnica de Feynman, analogia de
ancoragem, diagrama Mermaid escapado com ~~~mermaid, código SQL
comentado linha a linha escapado com ~~~, glossário técnico,
antecipação de erros, troubleshooting, desafio de fixação com
resolução comentada, resumo dos pontos-chave, log de estado do
projeto atualizado e prompt de continuidade para o próximo capítulo.
Todo o conteúdo deve ser gerado dentro de um bloco ```markdown.
Chame aulas de capítulos e curso de livro.

Por favor, gere o Capítulo 6: Tipos de Dados no SQL Server —
Teoria e Escolha Correta. Objetivo: entender todas as famílias
de tipos de dados disponíveis no SQL Server 2022 (numéricos
exatos, numéricos aproximados, texto, data e hora, binários e
especiais), compreender as diferenças de precisão, armazenamento
e comportamento entre eles, e aprender a escolher o tipo correto
para cada coluna do FinanceDB, com atenção especial aos tipos
críticos para aplicações financeiras como DECIMAL, MONEY,
DATE, DATETIME2 e NVARCHAR.
Pré-requisito: Capítulos 1 a 5 concluídos.
~~~

Dúvidas? Posso prosseguir para o Capítulo 6?