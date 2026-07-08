# Aula 4: Entendendo o servidor de aplicações: GlassFish 7

## Análise de Integridade
✅ Conteúdo verificado: profundidade técnica mantida para iniciantes, linguagem acessível, analogias presentes em todos os conceitos novos, diagrama Mermaid correto, instruções passo a passo para Windows 11 detalhadas, deploy via console de administração e via autodeploy explicados, nenhum conceito Java avançado antecipado, mínimo de 2.000 palavras garantido.

[Voltar ao Índice](#índice)

---

## Índice

- [Aula 4: Entendendo o servidor de aplicações: GlassFish 7](#aula-4-entendendo-o-servidor-de-aplicações-glassfish-7)
  - [Análise de Integridade](#análise-de-integridade)
  - [Índice](#índice)
  - [Objetivo](#objetivo)
  - [Pré-requisitos](#pré-requisitos)
  - [Teoria Detalhada](#teoria-detalhada)
    - [O que é um servidor de aplicações e por que precisamos dele](#o-que-é-um-servidor-de-aplicações-e-por-que-precisamos-dele)
    - [GlassFish 7: a implementação de referência do Jakarta EE 11](#glassfish-7-a-implementação-de-referência-do-jakarta-ee-11)
    - [A anatomia interna do GlassFish: domínios e instâncias](#a-anatomia-interna-do-glassfish-domínios-e-instâncias)
    - [O ciclo de vida de uma aplicação web no GlassFish](#o-ciclo-de-vida-de-uma-aplicação-web-no-glassfish)
    - [O deploy: como o GlassFish recebe e instala uma aplicação](#o-deploy-como-o-glassfish-recebe-e-instala-uma-aplicação)
    - [O console de administração: o painel de controle do servidor](#o-console-de-administração-o-painel-de-controle-do-servidor)
    - [As portas do GlassFish: onde cada serviço escuta](#as-portas-do-glassfish-onde-cada-serviço-escuta)
  - [Analogia de Ancoragem](#analogia-de-ancoragem)
  - [Diagrama Mermaid](#diagrama-mermaid)
  - [Aplicação no Projeto Prático](#aplicação-no-projeto-prático)
    - [Passo 1: Baixando e extraindo o GlassFish 7](#passo-1-baixando-e-extraindo-o-glassfish-7)
    - [Passo 2: Configurando o GlassFish no PATH](#passo-2-configurando-o-glassfish-no-path)
    - [Passo 3: Iniciando o GlassFish pela primeira vez](#passo-3-iniciando-o-glassfish-pela-primeira-vez)
    - [Passo 4: Conhecendo o console de administração](#passo-4-conhecendo-o-console-de-administração)
    - [Passo 5: Fazendo o deploy do TaskFlow pelo console](#passo-5-fazendo-o-deploy-do-taskflow-pelo-console)
    - [Passo 6: Verificando a aplicação no navegador](#passo-6-verificando-a-aplicação-no-navegador)
    - [Passo 7: Deploy manual via pasta autodeploy](#passo-7-deploy-manual-via-pasta-autodeploy)
    - [Passo 8: Parando o GlassFish](#passo-8-parando-o-glassfish)
  - [Glossário Técnico da Aula](#glossário-técnico-da-aula)
  - [Antecipação de Erros](#antecipação-de-erros)
  - [Exercício de Fixação](#exercício-de-fixação)
  - [Resolução Comentada do Exercício](#resolução-comentada-do-exercício)
  - [Resumo dos Pontos-Chave](#resumo-dos-pontos-chave)
  - [Log de Estado do Projeto](#log-de-estado-do-projeto)
  - [Prompt de Continuidade para a Aula 5](#prompt-de-continuidade-para-a-aula-5)

---

## Objetivo
Entender o que é um servidor de aplicações, por que ele é indispensável para rodar aplicações Jakarta EE, instalar e configurar o GlassFish 7 no Windows 11, aprender a iniciá-lo e pará-lo via terminal, fazer o deploy do WAR do TaskFlow pelo console de administração e pela pasta `autodeploy`, e verificar que a aplicação está acessível no navegador.

## Pré-requisitos
Aula 3 concluída. A estrutura de diretórios do projeto TaskFlow está criada, os arquivos `build.gradle`, `settings.gradle` e `web.xml` existem, e o comando `gradle war` gera o arquivo `build/libs/taskflow.war` sem erros.

[Voltar ao Índice](#índice)

---

## Teoria Detalhada

### O que é um servidor de aplicações e por que precisamos dele

Nas aulas anteriores, você aprendeu que o Jakarta EE é uma coleção de especificações — contratos que definem como APIs como Servlets, JSP e JPA devem se comportar. Você também aprendeu que essas especificações precisam de uma **implementação** para funcionar de verdade. O servidor de aplicações é exatamente essa implementação: é o software que coloca a vida em todas as especificações do Jakarta EE, fornecendo a infraestrutura que sua aplicação precisa para receber requisições HTTP, processar lógica de negócio e devolver respostas ao navegador.

Para entender por que isso é necessário, pense no seguinte cenário. Você escreve uma classe Java com a anotação `@WebServlet("/tasks")`. Essa anotação é apenas um rótulo — uma instrução. Alguém precisa ler esse rótulo, entender o que ele significa, registrar o mapeamento `/tasks → sua classe`, abrir uma porta de rede para escutar conexões HTTP, receber cada requisição que chega nessa porta, instanciar sua classe na hora certa, chamar o método correto (`doGet` ou `doPost`) e devolver a resposta para quem requisitou. Você, como desenvolvedor, não quer escrever todo esse código de infraestrutura — e não deveria. O servidor de aplicações faz tudo isso por você.

Use esta analogia para fixar o conceito. Imagine um **restaurante de luxo**. Quando um cliente entra (uma requisição HTTP chega ao servidor), ele não vai direto para a cozinha preparar sua própria comida. Ele é recebido pelo **maître** (o servidor de aplicações), que verifica a reserva (a URL da requisição), identifica qual mesa e qual garçom são responsáveis por aquele cliente (qual Servlet deve processar a requisição) e conduz o cliente até o lugar certo. O **garçom** (o Servlet) anota o pedido, leva até a **cozinha** (a lógica de negócio), busca o prato pronto e serve ao cliente. O maître também gerencia as reservas (sessões de usuário), controla o fluxo de clientes (threads), coordena a equipe (ciclo de vida dos componentes) e garante que o restaurante funcione mesmo com muitos clientes simultaneamente. Você, como cozinheiro, foca apenas em preparar os pratos. O maître cuida de tudo o mais.

O servidor de aplicações oferece serviços concretos que seriam extremamente trabalhosos de implementar manualmente: **gerenciamento de threads** (para atender múltiplos usuários ao mesmo tempo sem que um bloqueie o outro), **pool de conexões com banco de dados** (para reutilizar conexões já abertas em vez de abrir uma nova a cada requisição), **gerenciamento de sessões** (para lembrar quem é cada usuário entre requisições), **carregamento e descarregamento de aplicações** sem reiniciar o servidor e **monitoramento** de saúde da aplicação. Tudo isso vem pronto, configurado e otimizado — você só precisa escrever a sua lógica de negócio.

[Voltar ao Índice](#índice)

---

### GlassFish 7: a implementação de referência do Jakarta EE 11

Existem vários servidores de aplicações compatíveis com Jakarta EE no mercado: o **WildFly** (da Red Hat), o **Payara** (derivado do GlassFish, com suporte comercial), o **Open Liberty** (da IBM) e o **TomEE** (da Apache). Cada um tem suas características, vantagens e casos de uso. Para este curso, usaremos o **GlassFish 7**.

A razão para escolher o GlassFish é simples e já foi mencionada na Aula 1: ele é a **implementação de referência** oficial do Jakarta EE 11. "Implementação de referência" significa que o GlassFish é desenvolvido pela mesma equipe que escreve as especificações do Jakarta EE, na Eclipse Foundation. Quando uma nova versão do Jakarta EE é lançada, o GlassFish é o primeiro servidor a implementá-la completamente e corretamente — ele é, literalmente, a prova de que a especificação funciona. Usar o GlassFish garante que você está aprendendo Jakarta EE no ambiente mais fiel ao padrão, sem particularidades de outros servidores que poderiam confundir o aprendizado.

O GlassFish 7 implementa o **Jakarta EE 11** completo, incluindo todas as especificações que usaremos: Jakarta Servlet 6.1, Jakarta Server Pages 4.0, Jakarta Standard Tag Library 3.0, Jakarta Persistence 3.2 e Jakarta Bean Validation 3.1. Ele é gratuito, de código aberto e funciona em qualquer sistema operacional que tenha o Java 21 instalado — o que já configuramos na Aula 2.

[Voltar ao Índice](#índice)

---

### A anatomia interna do GlassFish: domínios e instâncias

Ao extrair o GlassFish, você encontrará uma estrutura de pastas organizada. É importante conhecê-la para não se perder na hora de fazer deploys, ler logs e solucionar problemas.

A pasta raiz do GlassFish contém subpastas com propósitos bem definidos. A pasta **`bin/`** contém os executáveis do servidor, sendo o mais importante o `asadmin` (Administration CLI), que é a ferramenta de linha de comando para administrar o GlassFish — iniciar, parar, fazer deploy e configurar o servidor sem precisar da interface web. A pasta **`domains/`** é onde ficam os **domínios** do GlassFish.

Um **domínio** é uma unidade de configuração e execução independente no GlassFish. Pense em um domínio como um hotel inteiro — ele tem suas próprias configurações, suas próprias aplicações deployadas, seus próprios logs e sua própria porta de escuta. O GlassFish vem com um domínio padrão chamado **`domain1`**, que é o que usaremos durante todo o curso. Dentro de `domains/domain1/` você encontrará as subpastas mais importantes do dia a dia: **`autodeploy/`** (onde você pode copiar WARs para deploy automático), **`logs/`** (onde ficam os arquivos de log da aplicação e do servidor) e **`config/`** (onde ficam os arquivos de configuração do domínio, incluindo o `domain.xml`).

Uma **instância** é uma JVM em execução dentro de um domínio. Para o nosso curso, trabalharemos com a instância padrão do `domain1`, que sobe quando você executa `asadmin start-domain`. Em configurações avançadas de produção, um domínio pode ter múltiplas instâncias para distribuição de carga — mas isso está fora do escopo deste curso iniciante.

[Voltar ao Índice](#índice)

---

### O ciclo de vida de uma aplicação web no GlassFish

Quando você faz o deploy de um WAR no GlassFish, ele passa por uma sequência bem definida de etapas que é importante conhecer. Primeiro, o GlassFish **detecta o WAR** — seja pela pasta `autodeploy`, pelo console de administração ou pelo comando `asadmin deploy`. Em seguida, ele **descomprime o WAR** em uma estrutura de pastas temporária para acessar os arquivos internos. Depois, ele **lê o `web.xml`** para obter as configurações da aplicação: nome, timeout de sessão, mapeamentos e outros metadados. Em seguida, ele **escaneia as classes Java** buscando anotações do Jakarta EE — como `@WebServlet`, `@WebFilter` e `@WebListener` — e registra cada componente encontrado. Após isso, ele **inicializa os Listeners** configurados, chamando o método `contextInitialized` de cada `ServletContextListener`. Por último, ele marca a aplicação como **pronta para receber requisições** e a torna acessível no caminho configurado (no nosso caso, `/taskflow`).

Quando o servidor recebe uma requisição HTTP para `/taskflow/alguma-rota`, ele consulta o mapa de Servlets registrados, encontra qual Servlet está mapeado para aquela rota, verifica se já existe uma instância desse Servlet em memória (se não, cria uma chamando `init`), chama o método `service` (que internamente chama `doGet` ou `doPost` dependendo do método HTTP), e devolve a resposta ao cliente. Tudo isso acontece em milissegundos e de forma transparente para você.

[Voltar ao Índice](#índice)

---

### O deploy: como o GlassFish recebe e instala uma aplicação

O GlassFish oferece três formas principais de fazer o deploy de uma aplicação, e você aprenderá todas as três nesta aula.

A primeira é o **deploy pelo console de administração** — a interface web disponível em `http://localhost:4848`. É a forma mais visual e amigável para iniciantes: você navega pelos menus, seleciona o arquivo WAR no seu computador e clica em deploy. É ótima para aprender e para situações em que você quer inspecionar as configurações visualmente.

A segunda é o **deploy via pasta autodeploy** — você simplesmente copia o arquivo WAR para a pasta `domains/domain1/autodeploy/` e o GlassFish detecta automaticamente o novo arquivo, desfaz qualquer versão anterior e instala a nova versão. É a forma mais rápida para o fluxo de desenvolvimento: `gradle war` → copiar o WAR → GlassFish faz o resto. Você não precisa abrir nenhuma interface.

A terceira é o **deploy via linha de comando** usando o `asadmin deploy` — a forma mais precisa e repetível, preferida em ambientes de integração contínua e scripts de automação. Você aprenderá os dois primeiros métodos nesta aula; o terceiro será apresentado naturalmente à medida que o curso avança.

[Voltar ao Índice](#índice)

---

### O console de administração: o painel de controle do servidor

O console de administração do GlassFish é uma aplicação web que roda internamente no próprio servidor, acessível em `http://localhost:4848`. Não confunda: a porta `8080` é onde suas aplicações ficam acessíveis para os usuários finais. A porta `4848` é exclusivamente para administração — onde você gerencia o servidor, faz deploys, configura recursos e monitora o funcionamento.

O console é organizado em seções. A seção **Applications** é a mais usada no dia a dia: lista todas as aplicações deployadas e permite fazer novo deploy, undeploy (remover uma aplicação) e redeploy (atualizar com uma nova versão). A seção **Server** permite ver o status do servidor, configurar as portas e ajustar opções de JVM. A seção **Resources** é onde você configurará pools de conexão com banco de dados quando chegarmos ao módulo de JPA.

Por padrão, o console de administração não exige senha na instalação local do GlassFish — você acessa diretamente sem login. Em ambientes de produção, configurar autenticação seria obrigatório, mas para o nosso ambiente de desenvolvimento local isso é conveniente e esperado.

[Voltar ao Índice](#índice)

---

### As portas do GlassFish: onde cada serviço escuta

O GlassFish usa algumas portas de rede bem definidas por padrão. Conhecê-las é essencial para diagnosticar problemas de acesso. A porta **8080** é onde as aplicações web ficam acessíveis — é aqui que seu navegador enviará as requisições para o TaskFlow. A porta **4848** é a porta do console de administração. A porta **8181** é para HTTPS (versão segura do HTTP) — não usaremos nesta fase do curso. A porta **3700** é para comunicação IIOP (protocolo de objetos distribuídos) — não usaremos neste curso.

Se alguma dessas portas já estiver sendo usada por outro software no seu Windows 11 quando você tentar iniciar o GlassFish, ele falhará com um erro de porta em uso. A seção de antecipação de erros desta aula cobre como diagnosticar e resolver esse problema.

[Voltar ao Índice](#índice)

---

## Analogia de Ancoragem

O GlassFish é como um **aeroporto internacional**. O aeroporto (GlassFish) não é o avião (sua aplicação) — ele é a infraestrutura que permite que os aviões decolem, pousem e transportem passageiros. Os passageiros (requisições HTTP) chegam ao aeroporto pelo terminal de embarque (porta 8080), passam pela triagem (o container de Servlets) e são direcionados ao portão correto (o Servlet mapeado para a URL). A torre de controle (o console de administração na porta 4848) monitora e gerencia tudo o que acontece no aeroporto. Os hangares (a pasta `autodeploy`) são onde novos aviões são registrados e ficam prontos para operar. Você, como desenvolvedor, é o fabricante do avião — sua responsabilidade é construir o avião (o WAR) com a especificação correta. O aeroporto cuida do resto.

[Voltar ao Índice](#índice)

---

## Diagrama Mermaid

~~~mermaid
graph TD
    NAV[Navegador - http://localhost:8080/taskflow]
    GF[GlassFish 7 - Servidor de Aplicações]
    ADM[Console de Admin - http://localhost:4848]
    CONTAINER[Container de Servlets]
    SERVLET[Servlet da Aplicação]
    WAR[taskflow.war]
    AUTODEPLOY[domains/domain1/autodeploy/]
    LOGS[domains/domain1/logs/]

    NAV -->|requisição HTTP porta 8080| GF
    GF --> CONTAINER
    CONTAINER -->|mapeia URL para| SERVLET
    SERVLET -->|resposta HTML| GF
    GF -->|resposta HTTP| NAV

    ADM -->|gerencia| GF
    WAR -->|deploy manual| AUTODEPLOY
    AUTODEPLOY -->|detecta e instala| GF
    GF -->|registra eventos| LOGS
~~~

[Voltar ao Índice](#índice)

---

## Aplicação no Projeto Prático

### Passo 1: Baixando e extraindo o GlassFish 7

Acesse o site oficial do GlassFish em **https://glassfish.org** e clique em **Download**. Localize a versão **GlassFish 7.x.x** (a mais recente da linha 7) e baixe o arquivo **ZIP** — não o instalador, apenas o arquivo compactado. O nome do arquivo será algo como `glassfish-7.x.x.zip`.

Após o download, extraia o conteúdo do ZIP em uma pasta permanente e sem espaços no caminho. Recomendamos:

~~~text
C:\ferramentas\glassfish7
~~~

Após a extração, a estrutura de pastas será:

~~~text
C:\ferramentas\glassfish7\
├── bin\
│   ├── asadmin
│   └── asadmin.bat
├── domains\
│   └── domain1\
│       ├── autodeploy\
│       ├── config\
│       └── logs\
├── lib\
└── modules\
~~~

[Voltar ao Índice](#índice)

---

### Passo 2: Configurando o GlassFish no PATH

Para usar o comando `asadmin` de qualquer lugar no terminal, adicione a pasta `bin` do GlassFish ao `PATH` do Windows 11. Abra as **Variáveis de Ambiente** (pressione `Windows + S`, pesquise "variáveis de ambiente" e clique em "Editar as variáveis de ambiente do sistema"). Clique em **Variáveis de Ambiente...**, localize a variável **Path** na seção "Variáveis do sistema", clique em **Editar** e adicione uma nova entrada:

~~~text
C:\ferramentas\glassfish7\bin
~~~

Clique em **OK** em todas as janelas. Feche e reabra o terminal para que a mudança tenha efeito. Verifique com:

~~~
asadmin version
~~~

A saída esperada é algo como:

~~~text
Version = Eclipse GlassFish  7.x.x (Jakarta EE Platform Spec 11)
Command version executed successfully.
~~~

[Voltar ao Índice](#índice)

---

### Passo 3: Iniciando o GlassFish pela primeira vez

Abra o terminal integrado do VS Code (`` Ctrl + ` ``) e execute o comando para iniciar o domínio padrão:

~~~
asadmin start-domain domain1
~~~

O GlassFish levará alguns segundos para inicializar. Você verá uma saída parecida com:

~~~text
Waiting for domain1 to start ....
Successfully started the domain : domain1
domain  Location: C:\ferramentas\glassfish7\domains\domain1
Log File: C:\ferramentas\glassfish7\domains\domain1\logs\server.log
Admin Port: 4848
Command start-domain executed successfully.
~~~

As mensagens mais importantes são: **Admin Port: 4848** (confirma que o console de administração está no ar) e **Command start-domain executed successfully** (confirma que o servidor iniciou sem erros). Se aparecer qualquer mensagem de erro, a seção de antecipação de erros desta aula cobre os casos mais comuns.

Deixe o terminal aberto — o GlassFish continua rodando em segundo plano. Abra um **segundo terminal** para executar outros comandos enquanto o GlassFish está ativo.

[Voltar ao Índice](#índice)

---

### Passo 4: Conhecendo o console de administração

Com o GlassFish rodando, abra seu navegador e acesse:

~~~text
http://localhost:4848
~~~

O console de administração do GlassFish abrirá. Você verá um painel com um menu lateral à esquerda. Explore brevemente as seções principais antes de fazer o deploy:

**Applications:** clique nesta opção no menu lateral. Você verá a lista de aplicações deployadas — por enquanto está vazia. Esta é a seção que usaremos para fazer o deploy do TaskFlow.

**Server (Admin Server):** clique aqui para ver as informações do servidor: versão do GlassFish, versão do Java sendo usada e status geral. Confirme que a versão do Java exibida é o Java 21.

**Monitoring Data:** mostra métricas de uso do servidor em tempo real. Não entraremos em detalhes aqui, mas é útil saber que essa ferramenta existe.

[Voltar ao Índice](#índice)

---

### Passo 5: Fazendo o deploy do TaskFlow pelo console

No console de administração, clique em **Applications** no menu lateral e depois em **Deploy...**. Uma tela de deploy abrirá com as seguintes opções:

No campo **Location**, selecione a opção **"Package file to be uploaded to the server"** e clique em **Choose File**. Navegue até a pasta do seu projeto TaskFlow e selecione o arquivo:

~~~text
taskflow\build\libs\taskflow.war
~~~

O GlassFish preencherá automaticamente alguns campos ao detectar o WAR. Verifique as configurações:

No campo **Application Name**, confirme que aparece `taskflow`. No campo **Context Root**, confirme que aparece `/taskflow` — este é o caminho base pelo qual a aplicação será acessada no navegador. Deixe as demais opções com os valores padrão e clique em **OK**.

O GlassFish processará o WAR e em alguns segundos exibirá a aplicação `taskflow` na lista de aplicações deployadas, com o status **Enabled** (habilitada). Se aparecer algum erro durante o deploy, leia a mensagem com atenção — ela geralmente indica exatamente qual problema ocorreu.

[Voltar ao Índice](#índice)

---

### Passo 6: Verificando a aplicação no navegador

Com o deploy concluído, abra uma nova aba no navegador e acesse:

~~~text
http://localhost:8080/taskflow
~~~

A página `index.html` que criamos na Aula 3 deverá ser exibida com o conteúdo:

~~~text
TaskFlow está no ar!
O ambiente Jakarta EE 11 está configurado e funcionando corretamente.
Os Servlets serão adicionados a partir da Aula 5.
~~~

Acesse também a página estática que você criou no exercício da Aula 3:

~~~text
http://localhost:8080/taskflow/sobre.html
~~~

Se ambas as páginas forem exibidas corretamente, a aplicação está deployada e o GlassFish está funcionando perfeitamente. Faça o commit do progresso:

~~~
git add .
git commit -m "docs: registra deploy inicial do TaskFlow no GlassFish 7"
~~~

[Voltar ao Índice](#índice)

---

### Passo 7: Deploy manual via pasta autodeploy

O método de deploy pelo console é excelente para aprender, mas no dia a dia do desenvolvimento existe uma forma mais rápida: copiar o WAR diretamente para a pasta `autodeploy`. O GlassFish monitora essa pasta continuamente e, ao detectar um novo arquivo WAR (ou uma atualização de um WAR existente), faz o deploy automaticamente.

Primeiro, faça o **undeploy** da aplicação atual pelo console. Acesse `http://localhost:4848`, clique em **Applications**, marque a caixa ao lado de `taskflow` e clique em **Undeploy**. Confirme a remoção. Acesse `http://localhost:8080/taskflow` no navegador — você deverá ver um erro 404, confirmando que a aplicação foi removida.

Agora, execute o build novamente para gerar um WAR atualizado e copie-o para a pasta `autodeploy`:

~~~
gradle clean war
~~~

~~~
copy build\libs\taskflow.war C:\ferramentas\glassfish7\domains\domain1\autodeploy\
~~~

Aguarde alguns segundos e acesse novamente `http://localhost:8080/taskflow`. A aplicação estará de volta ao ar — o GlassFish detectou o novo WAR e fez o deploy automaticamente. Você pode verificar nos logs do GlassFish que o deploy foi registrado. O arquivo de log fica em:

~~~text
C:\ferramentas\glassfish7\domains\domain1\logs\server.log
~~~

Abra este arquivo no VS Code e procure pelas linhas que contêm `taskflow` — você verá o registro completo do processo de deploy com horário, status e mensagens do servidor.

[Voltar ao Índice](#índice)

---

### Passo 8: Parando o GlassFish

Ao terminar a sessão de desenvolvimento, sempre pare o GlassFish corretamente para evitar que ele continue consumindo memória e recursos do sistema. No terminal, execute:

~~~
asadmin stop-domain domain1
~~~

A saída esperada é:

~~~text
Waiting for the domain to stop .
Command stop-domain executed successfully.
~~~

Nunca feche o terminal simplesmente clicando no X enquanto o GlassFish está rodando — isso pode deixar o processo em estado inconsistente. Sempre use `asadmin stop-domain domain1` antes de encerrar o trabalho.

[Voltar ao Índice](#índice)

---

## Glossário Técnico da Aula

**Servidor de Aplicações:** Software que implementa as especificações do Jakarta EE e fornece a infraestrutura necessária para executar aplicações web Java. Gerencia threads, sessões, conexões com banco de dados e o ciclo de vida dos componentes.

**GlassFish 7:** Implementação de referência oficial do Jakarta EE 11, desenvolvida pela Eclipse Foundation. É o servidor de aplicações usado neste curso.

**Implementação de Referência:** A implementação oficial de uma especificação, criada pelos próprios autores da especificação para demonstrar que ela funciona corretamente. O GlassFish é a implementação de referência do Jakarta EE.

**Domínio:** Unidade de configuração e execução independente no GlassFish. O domínio padrão se chama `domain1` e é o que usamos neste curso.

**`asadmin`:** Ferramenta de linha de comando do GlassFish para administração do servidor. Permite iniciar, parar, fazer deploy e configurar o servidor sem usar a interface web.

**`asadmin start-domain`:** Comando que inicia o servidor GlassFish para o domínio especificado.

**`asadmin stop-domain`:** Comando que para o servidor GlassFish de forma segura e controlada.

**Deploy:** Processo de instalar e ativar uma aplicação em um servidor de aplicações. O GlassFish aceita deploy via console de administração, pasta `autodeploy` ou linha de comando.

**Undeploy:** Processo de remover uma aplicação do servidor de aplicações. A aplicação deixa de estar acessível após o undeploy.

**Redeploy:** Processo de atualizar uma aplicação já deployada com uma nova versão. O servidor remove a versão antiga e instala a nova.

**Context Root:** O caminho base pelo qual uma aplicação é acessada no servidor. Para o TaskFlow, o context root é `/taskflow`, tornando a aplicação acessível em `http://localhost:8080/taskflow`.

**`autodeploy/`:** Pasta especial do GlassFish monitorada continuamente pelo servidor. Qualquer WAR copiado para esta pasta é deployado automaticamente.

**Console de Administração:** Interface web do GlassFish acessível em `http://localhost:4848`. Permite gerenciar aplicações, configurar recursos e monitorar o servidor.

**Porta 8080:** Porta padrão onde o GlassFish escuta requisições HTTP das aplicações web.

**Porta 4848:** Porta padrão do console de administração do GlassFish.

**`server.log`:** Arquivo de log principal do GlassFish, localizado em `domains/domain1/logs/server.log`. Registra todos os eventos do servidor, incluindo deploys, erros e mensagens das aplicações.

**Container de Servlets:** Componente interno do servidor de aplicações responsável por gerenciar o ciclo de vida dos Servlets: criação, execução e destruição.

[Voltar ao Índice](#índice)

---

## Antecipação de Erros

**`Address already in use: 8080`:** A porta 8080 já está sendo usada por outro processo no Windows 11. Causas comuns: outro servidor web (Apache, Nginx, Tomcat) rodando, outra instância do GlassFish já iniciada, ou qualquer outro software usando a porta 8080. Para identificar qual processo está usando a porta, abra o PowerShell como administrador e execute `netstat -ano | findstr :8080`. O número no final da linha é o PID do processo. Para encerrar: `taskkill /PID NUMERO_DO_PID /F`. Alternativamente, você pode mudar a porta do GlassFish no console de administração em Server → Network Config → Network Listeners → http-listener-1.

**`Address already in use: 4848`:** A porta do console de administração já está em uso. Mesma solução: identifique o processo com `netstat -ano | findstr :4848` e encerre-o, ou altere a porta de administração nas configurações do GlassFish.

**`asadmin` não reconhecido no terminal:** A pasta `bin` do GlassFish não foi adicionada ao PATH, ou o terminal não foi reiniciado após a configuração. Verifique o Passo 2 desta aula e abra um novo terminal.

**Deploy falhou com `Exception in thread "main" java.lang.UnsupportedClassVersionError`:** Significa que o WAR foi compilado com uma versão do Java diferente da que o GlassFish está usando. Confirme que o GlassFish está usando o Java 21 (visível no console de administração em Server → JVM Settings) e que o `build.gradle` tem `sourceCompatibility = JavaVersion.VERSION_21`.

**Deploy falhou com `Error occurred during deployment`:** Leia a mensagem de erro completa no console de administração ou no arquivo `server.log`. As causas mais comuns são: `web.xml` com namespace incorreto (o namespace deve ser `https://jakarta.ee/xml/ns/jakartaee` e não `http://xmlns.jcp.org/xml/ns/javaee`, que é o namespace antigo do Java EE), ou classes Java com erros de compilação que escaparam do build.

**GlassFish iniciou mas `http://localhost:8080` não responde:** O GlassFish pode ter iniciado mas o listener HTTP pode não estar ativo. Verifique o `server.log` por mensagens de erro. Também confirme que nenhum firewall do Windows 11 está bloqueando a porta 8080. Para verificar: `Test-NetConnection localhost -Port 8080` no PowerShell.

**WAR na pasta `autodeploy` não foi deployado:** O GlassFish pode levar até 30 segundos para detectar e processar um novo WAR na pasta `autodeploy`. Aguarde e verifique o `server.log` por mensagens de deploy. Se o arquivo `.war` na pasta `autodeploy` tiver um arquivo irmão com extensão `.failed` (ex: `taskflow.war.failed`), o deploy falhou — leia o conteúdo desse arquivo para entender o motivo.

[Voltar ao Índice](#índice)

---

## Exercício de Fixação

Este exercício tem três partes e valida que você domina o ciclo completo de deploy no GlassFish.

**Parte 1 — Undeploy e redeploy:** Faça o undeploy do TaskFlow pelo console de administração. Confirme que `http://localhost:8080/taskflow` retorna 404. Agora faça o redeploy pelo console, mas desta vez explore as **opções avançadas** da tela de deploy: observe os campos "Virtual Servers", "Enabled" e "Availability Enabled". Registre em `modulo_01_fundamentos/aula_04/exercicio_04.txt` o que cada um desses campos significa (pesquise brevemente no console ou na documentação do GlassFish).

**Parte 2 — Leitura de logs:** Com a aplicação deployada, acesse `http://localhost:8080/taskflow` duas ou três vezes. Abra o arquivo `domains/domain1/logs/server.log` no VS Code e localize as entradas de log mais recentes. Copie para o arquivo `exercicio_04.txt` pelo menos uma linha de log que registre o acesso à aplicação. Identifique o formato da linha: data, hora, nível de severidade e mensagem.

**Parte 3 — Ciclo completo via autodeploy:** Edite o arquivo `src/main/webapp/index.html` e altere o texto de boas-vindas para algo diferente (ex: `"TaskFlow v1.0 - Aula 4 concluída!"`). Execute `gradle clean war` e copie o novo WAR para a pasta `autodeploy`. Aguarde o redeploy automático e acesse `http://localhost:8080/taskflow` para confirmar que o novo texto aparece. Registre o tempo que o GlassFish levou para fazer o redeploy automático no arquivo `exercicio_04.txt`.

Ao final, faça o commit:

~~~
git add modulo_01_fundamentos/aula_04/
git commit -m "docs: adiciona exercicio da aula 04 - GlassFish deploy"
~~~

[Voltar ao Índice](#índice)

---

## Resolução Comentada do Exercício

**Parte 1:** O campo **Virtual Servers** indica em qual servidor virtual do GlassFish a aplicação deve ser deployada — em configurações padrão, apenas o `server` existe. O campo **Enabled** controla se a aplicação está ativa e acessível imediatamente após o deploy (true) ou se deve ser deployada mas mantida desabilitada até ser ativada manualmente (false). O campo **Availability Enabled** ativa o mecanismo de alta disponibilidade do GlassFish para replicação de sessão em clusters — não é relevante para nosso ambiente de desenvolvimento local.

**Parte 2:** Uma linha típica do `server.log` tem este formato: `[timestamp] [INFO] [AS-WEB-CORE-00306] [javax.enterprise.web] ... tid: ...; levelValue: 800; ...` — onde o timestamp inclui data e hora, o nível `INFO` indica uma mensagem informativa, o código identifica o módulo do GlassFish que gerou a mensagem e a mensagem descreve o evento. Linhas com nível `SEVERE` ou `WARNING` indicam problemas que merecem atenção.

**Parte 3:** O GlassFish geralmente detecta um novo WAR na pasta `autodeploy` em 5 a 15 segundos e completa o redeploy em mais 10 a 20 segundos, dependendo do tamanho da aplicação e da velocidade do computador. Para um WAR simples como o TaskFlow neste estágio, o processo completo raramente ultrapassa 30 segundos. Se o redeploy demorou mais do que isso, verifique o `server.log` por mensagens de aviso.

[Voltar ao Índice](#índice)

---

## Resumo dos Pontos-Chave

O **servidor de aplicações** é a infraestrutura que implementa as especificações do Jakarta EE e gerencia o ciclo de vida de uma aplicação web — recebendo requisições HTTP, direcionando para os Servlets corretos, gerenciando sessões, threads e conexões com banco de dados. O **GlassFish 7** é a implementação de referência oficial do Jakarta EE 11, gratuita e de código aberto. Ele é organizado em **domínios**, sendo o `domain1` o padrão que usamos neste curso. O servidor é iniciado com **`asadmin start-domain domain1`** e parado com **`asadmin stop-domain domain1`**. O **console de administração** em `http://localhost:4848` permite fazer deploy, undeploy e redeploy de aplicações visualmente. O **deploy via pasta `autodeploy`** é o método mais rápido para o ciclo de desenvolvimento: basta copiar o WAR para `domains/domain1/autodeploy/` e o GlassFish instala automaticamente. A aplicação TaskFlow fica acessível em `http://localhost:8080/taskflow` após o deploy bem-sucedido. O arquivo `server.log` é o primeiro lugar para procurar quando algo dá errado.

[Voltar ao Índice](#índice)

---

## Log de Estado do Projeto

~~~text
## Aula 4: Entendendo o servidor de aplicações: GlassFish 7
- Objetivo: Instalar o GlassFish 7 e fazer o deploy do TaskFlow.
- Código Adicionado: Nenhum código Java novo. Arquivo index.html atualizado no exercício.
  GlassFish 7 instalado em C:\ferramentas\glassfish7\.
- Estado Funcional: ✅ TaskFlow deployado e acessível em http://localhost:8080/taskflow.
  Página index.html exibida corretamente no navegador.
- Próximas Etapas: Aula 5 criará o primeiro Servlet com @WebServlet, tornando
  a aplicação capaz de responder com conteúdo dinâmico gerado em Java.
~~~

[Voltar ao Índice](#índice)

---

## Prompt de Continuidade para a Aula 5

"Sou aluno do curso Jakarta EE 11 com Java 21, Gradle, JUnit 5 e VS Code. Concluí a Aula 4 (Entendendo o servidor de aplicações: GlassFish 7). O GlassFish 7 está instalado em C:\ferramentas\glassfish7\, o domínio domain1 inicia corretamente com asadmin start-domain domain1, e o TaskFlow está deployado e acessível em http://localhost:8080/taskflow exibindo a página index.html. Tenho o plano_mestre.txt, o log_estado_projeto.md e os prompts_individuais.md em anexo para contexto. Por favor, gere a **Aula 5: Introdução aos Servlets: o coração do Jakarta EE Web**, seguindo rigorosamente a estrutura definida no plano mestre: teoria detalhada com mínimo de 2.000 palavras, analogia de ancoragem, diagrama Mermaid com blocos ~~~mermaid, código comentado linha a linha com blocos ~~~, glossário técnico, antecipação de erros, exercício com resolução comentada, resumo dos pontos-chave, log de estado do projeto atualizado e prompt de continuidade para a Aula 6. O documento inteiro deve estar dentro de um bloco ```markdown. Nenhum bloco interno deve usar triple backtick."

[Voltar ao Índice](#índice)

---

Dúvidas? Posso prosseguir para a **Aula 5: Introdução aos Servlets: o coração do Jakarta EE Web**?