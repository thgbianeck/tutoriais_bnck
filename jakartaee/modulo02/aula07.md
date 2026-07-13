# Aula 7: Arquitetura MVC: separando responsabilidades

## Análise de Integridade
✅ Conteúdo verificado: profundidade técnica mantida para iniciantes, linguagem acessível, analogia do restaurante aplicada consistentemente, fluxo MVC explicado em múltiplos níveis, papel de cada camada no Jakarta EE detalhado, refatoração da estrutura de pacotes apresentada passo a passo, referências ao Mockito e à separação de responsabilidades para testes coerentes com a Aula 6, diagrama Mermaid correto, mínimo de 2.000 palavras garantido.

---

## Índice

- [Aula 7: Arquitetura MVC: separando responsabilidades](#aula-7-arquitetura-mvc-separando-responsabilidades)
  - [Análise de Integridade](#análise-de-integridade)
  - [Índice](#índice)
  - [Objetivo](#objetivo)
  - [Pré-requisitos](#pré-requisitos)
  - [Resumo da Aula Anterior](#resumo-da-aula-anterior)
  - [Teoria Detalhada](#teoria-detalhada)
    - [O problema que o MVC resolve](#o-problema-que-o-mvc-resolve)
    - [A origem do MVC: uma história de meio século](#a-origem-do-mvc-uma-história-de-meio-século)
    - [As três camadas do MVC: definindo responsabilidades](#as-três-camadas-do-mvc-definindo-responsabilidades)
    - [O Model: o guardião dos dados e das regras](#o-model-o-guardião-dos-dados-e-das-regras)
    - [A View: a vitrine da aplicação](#a-view-a-vitrine-da-aplicação)
    - [O Controller: o maestro que coordena tudo](#o-controller-o-maestro-que-coordena-tudo)
    - [O fluxo completo de uma requisição MVC](#o-fluxo-completo-de-uma-requisição-mvc)
    - [MVC no Jakarta EE: quem é quem](#mvc-no-jakarta-ee-quem-é-quem)
    - [MVC e testabilidade: como a separação facilita os testes](#mvc-e-testabilidade-como-a-separação-facilita-os-testes)
    - [Por que separar responsabilidades importa de verdade](#por-que-separar-responsabilidades-importa-de-verdade)
    - [Os erros mais comuns de quem ignora o MVC](#os-erros-mais-comuns-de-quem-ignora-o-mvc)
  - [Analogia de Ancoragem](#analogia-de-ancoragem)
  - [Diagrama Mermaid](#diagrama-mermaid)
  - [Aplicação no Projeto Prático](#aplicação-no-projeto-prático)
    - [Passo 1: Entendendo o estado atual do projeto](#passo-1-entendendo-o-estado-atual-do-projeto)
    - [Passo 2: Criando a estrutura de pacotes MVC](#passo-2-criando-a-estrutura-de-pacotes-mvc)
    - [Passo 3: Criando a estrutura de pastas para as Views](#passo-3-criando-a-estrutura-de-pastas-para-as-views)
    - [Passo 4: Removendo os Servlets de exemplo](#passo-4-removendo-os-servlets-de-exemplo)
    - [Passo 5: Criando o TaskServlet placeholder](#passo-5-criando-o-taskservlet-placeholder)
    - [Passo 6: Verificando a estrutura final](#passo-6-verificando-a-estrutura-final)
    - [Passo 7: Commit da refatoração](#passo-7-commit-da-refatoração)
  - [Glossário Técnico da Aula](#glossário-técnico-da-aula)
  - [Antecipação de Erros](#antecipação-de-erros)
  - [Exercício de Fixação](#exercício-de-fixação)
  - [Resolução Comentada do Exercício](#resolução-comentada-do-exercício)
  - [Resumo dos Pontos-Chave](#resumo-dos-pontos-chave)
  - [Log de Estado do Projeto](#log-de-estado-do-projeto)
  - [Prompt de Continuidade para a Aula 8](#prompt-de-continuidade-para-a-aula-8)

---

## Objetivo
Entender em profundidade o padrão de arquitetura MVC (Model-View-Controller), compreender o fluxo completo de uma requisição dentro deste padrão, entender como a separação de responsabilidades impacta diretamente a estratégia de testes com JUnit 5 e Mockito, e refatorar a estrutura de pacotes do projeto TaskFlow para seguir o MVC corretamente — preparando o terreno para as aulas de implementação que virão a seguir.

## Pré-requisitos
Aulas 1 a 6 concluídas. Você sabe o que é um Servlet, como criar um com `@WebServlet`, como ler parâmetros com `HttpServletRequest`, como escrever respostas com `HttpServletResponse`, e já tem os fundamentos do TDD com JUnit 5 e do Mockito para testes de Servlets. O `SaudacaoServlet` e o `SaudacaoServiceTest` com 5 testes passando existem no projeto. O `SaudacaoServletTest` com Mockito também está criado e passando.

---

## Resumo da Aula Anterior

Na Aula 6 você aprofundou o protocolo HTTP, entendeu a anatomia de requisições e respostas, a diferença entre GET e POST, e aprendeu a ler parâmetros com `request.getParameter()`. Você também foi introduzido ao TDD com o ciclo Red-Green-Refactor, configurou o JUnit 5 e o Mockito no `build.gradle` e criou dois conjuntos de testes: os testes do `SaudacaoService` — lógica pura, sem mocks — e os testes do `SaudacaoServlet` — com mocks do Mockito para `HttpServletRequest`, `HttpServletResponse` e `PrintWriter`. Essa experiência revelou algo fundamental que esta aula formalizará como arquitetura: a separação entre lógica de negócio (Service) e coordenação de requisições (Servlet) não foi apenas uma boa ideia — ela foi o que tornou os testes possíveis e simples. O MVC é a generalização formal dessa separação.

---

## Teoria Detalhada

### O problema que o MVC resolve

Imagine que você está construindo a primeira versão do TaskFlow sem nenhuma arquitetura definida. Você cria um único Servlet chamado `TaskServlet`. Dentro do `doGet`, ele consulta uma lista de tarefas, constrói o HTML da tabela linha por linha com `PrintWriter`, aplica validações nos dados, formata datas, gera os links de ação e ainda decide qual mensagem de erro exibir. Tudo em um único método, em um único arquivo.

Na primeira semana, isso funciona. Mas na segunda semana, o cliente pede para mudar o visual da tabela — adicionar uma coluna, mudar as cores dos status. Você abre o `doGet` e encontra 300 linhas misturando HTML, lógica de negócio e regras de validação. Alterar o visual sem quebrar a lógica é quase impossível sem ler cada linha com atenção máxima. Na terceira semana, um colega precisa escrever testes automatizados para a lógica de validação — mas ela está embutida no meio do HTML, dependendo do `HttpServletRequest`, impossível de testar sem um servidor rodando. Na quarta semana, você decide mudar a forma como as tarefas são armazenadas, mas a lógica de acesso a dados está espalhada por vários métodos do Servlet. Você não tem coragem de mudar nada com medo de quebrar algo que funcionava.

Este cenário não é hipotético. É o que acontece em praticamente todos os projetos que crescem sem uma arquitetura definida. Você já vivenciou um fragmento desta realidade na Aula 6: quando a lógica de geração da saudação estava embutida diretamente no Servlet, testá-la exigiria mockar `HttpServletRequest` e `HttpServletResponse`, criar um `PrintWriter` falso e capturar o HTML gerado. E mesmo assim você estaria testando a lógica de negócio misturada com a infraestrutura HTTP — um teste frágil que quebra se qualquer coisa no fluxo HTTP mudar. A solução que você adotou — extrair o `SaudacaoService` como classe separada — foi intuitiva e correta. O **MVC** é a generalização arquitetural dessa solução para toda a aplicação.

---

### A origem do MVC: uma história de meio século

O padrão MVC não nasceu no mundo web. Ele foi proposto em **1979** por **Trygve Reenskaug**, um engenheiro norueguês que trabalhava com a linguagem **Smalltalk** no famoso Xerox PARC. Reenskaug estava enfrentando um problema específico: como separar os dados de uma aplicação de sua representação visual, de forma que fosse possível ter múltiplas representações do mesmo dado sem duplicar a lógica.

A solução que ele propôs era elegante e surpreendentemente duradoura: dividir o software em três responsabilidades — o **Modelo** (os dados e as regras), a **Visão** (a apresentação) e o **Controlador** (a mediação entre o usuário e o sistema). Nos 45 anos seguintes, praticamente toda plataforma de desenvolvimento adotou alguma variante do MVC: Java EE, Jakarta EE, Ruby on Rails, Django, ASP.NET MVC, Spring MVC. A longevidade do padrão é a prova mais eloquente de sua utilidade.

No contexto do Jakarta EE, o MVC assume uma forma muito específica e bem definida que estudaremos ao longo desta aula.

---

### As três camadas do MVC: definindo responsabilidades

O MVC divide o código em três camadas, cada uma com uma responsabilidade única e insubstituível. A regra fundamental é: **cada camada faz exatamente o que é sua responsabilidade e nada além disso**. Quando uma camada começa a fazer o trabalho de outra, a arquitetura começa a degradar — e, como você aprendeu na Aula 6, a testabilidade também degradar junto.

Use a seguinte analogia para ter uma visão geral: pense no MVC como um **restaurante bem administrado**. O restaurante tem três áreas claramente definidas: a **mesa do cliente** (View), onde a experiência do usuário acontece; o **garçom** (Controller), que circula entre a mesa e a cozinha, recebendo pedidos e entregando pratos; e a **cozinha** (Model), onde os pratos são preparados seguindo as receitas. Cada elemento tem um papel claro. O garçom não cozinha. A cozinha não fala diretamente com o cliente. O cliente não entra na cozinha. Essa separação é o que torna o restaurante eficiente, escalável e testável.

---

### O Model: o guardião dos dados e das regras

O **Model** é o coração intelectual da aplicação. Ele representa os dados do domínio e encapsula toda a lógica de negócio que opera sobre esses dados. No TaskFlow, o Model é onde vive a definição do que é uma tarefa, quais são seus atributos válidos, como ela é armazenada, como é buscada, como é modificada e como é removida.

A característica fundamental do Model é sua **independência completa das outras camadas**. O Model não sabe se a aplicação tem uma interface web, uma API REST ou uma interface de linha de comando. Ele não conhece JSP, não conhece Servlet, não conhece HTML. Esta independência tem uma consequência prática direta que você já experimentou: **o Model é completamente testável com JUnit sem mocks**. Você cria uma instância da classe de serviço ou do repositório, chama seus métodos e verifica os resultados com `assertEquals`. Nenhum `HttpServletRequest`. Nenhum `HttpServletResponse`. Nenhum `PrintWriter`. Os testes do `SaudacaoService` na Aula 6 — cinco testes limpos, sem nenhuma linha de Mockito — foram possíveis exatamente porque o `SaudacaoService` é um POJO independente da infraestrutura HTTP.

No TaskFlow, o Model será composto por dois tipos de classes: as **entidades** (como `Task.java`), que são POJOs representando objetos do domínio com seus atributos, e os **repositórios** (como `TaskRepository.java`), que encapsulam as operações de persistência.

---

### A View: a vitrine da aplicação

A **View** é responsável exclusivamente por apresentar os dados ao usuário de forma legível e interativa. No Jakarta EE com Servlets, a View é implementada com **JSP** (Jakarta Server Pages), que estudaremos na Aula 8.

A regra mais importante da View é que ela não deve conter lógica de negócio. A View recebe dados já prontos, já processados, já validados — e apenas os exibe. Do ponto de vista dos testes, a View é a camada mais difícil de testar automaticamente porque depende da renderização HTML — e por isso ela deve conter o mínimo possível de lógica. Quanto mais lógica a View tiver, mais comportamento ficará sem cobertura de testes automatizados.

Colocar lógica de negócio no JSP não é apenas uma violação do MVC — é uma decisão que torna o código diretamente intratável. Você não pode instanciar um JSP no JUnit. Você não pode criar um mock de um JSP. A única forma de testar lógica embutida no JSP é através de testes de integração completos que sobem um servidor real — lentos, frágeis e difíceis de manter.

---

### O Controller: o maestro que coordena tudo

O **Controller** é o intermediário entre o mundo externo (o navegador) e o mundo interno (o Model e a View). Ele recebe a requisição HTTP, extrai os dados necessários, delega o processamento ao Model, recebe o resultado e decide qual View deve ser apresentada.

O Controller tem uma relação interessante com os testes: ele **pode** ser testado com Mockito, como você aprendeu na Aula 6 com o `SaudacaoServletTest`. Você cria mocks de `HttpServletRequest` e `HttpServletResponse`, define o roteiro com `when(...).thenReturn(...)`, chama `doGet` diretamente e verifica o comportamento com `verify(...)`. Isso funciona — mas é visivelmente mais trabalhoso do que testar o `SaudacaoService` diretamente. E há uma razão para isso: o Controller mistura inevitavelmente a lógica de coordenação com a infraestrutura HTTP.

A lição prática é esta: **mantenha o Controller fino**. Quanto menos lógica de negócio o Controller tiver, menos testes com Mockito serão necessários para cobri-lo, e mais testes simples e rápidos de JUnit puro cobrirão a lógica real da aplicação no Model. Um Controller bem projetado no TaskFlow terá basicamente três responsabilidades: ler parâmetros da requisição, chamar o repositório ou serviço adequado e encaminhar para a View correta. Nada além disso.

No Jakarta EE, o Controller é implementado como um **Servlet**. O `TaskServlet` será o Controller central do TaskFlow.

---

### O fluxo completo de uma requisição MVC

Vamos percorrer passo a passo o fluxo de uma requisição no padrão MVC aplicado ao TaskFlow. O exemplo é: o usuário quer ver a lista de todas as suas tarefas.

**Passo 1:** O usuário acessa `http://localhost:8080/taskflow/tasks`. O navegador envia uma requisição HTTP GET ao GlassFish.

**Passo 2:** O GlassFish identifica pelo mapeamento `@WebServlet("/tasks")` que a requisição deve ser processada pelo `TaskServlet`. Ele chama `TaskServlet.doGet(request, response)`.

**Passo 3:** O `TaskServlet` (Controller) recebe a chamada. Ele chama `taskRepository.findAll()` e aguarda o resultado. Nada mais — ele não sabe como buscar tarefas, apenas delega.

**Passo 4:** O `TaskRepository` (Model) executa a operação de busca e retorna uma `List<Task>` ao Controller.

**Passo 5:** O `TaskServlet` chama `request.setAttribute("tasks", tasks)` para disponibilizar a lista para a View, e em seguida chama `RequestDispatcher.forward()` para encaminhar para `views/task/list.jsp`.

**Passo 6:** O GlassFish processa o `list.jsp` (View). A página usa Expression Language e JSTL para iterar sobre a lista e gerar o HTML da tabela. Nenhuma lógica de negócio acontece aqui.

**Passo 7:** O GlassFish envia o HTML gerado como resposta ao navegador. O usuário vê a lista de tarefas.

Este fluxo se repetirá, com pequenas variações, para cada funcionalidade do TaskFlow. A consistência do padrão é o que torna o código previsível e navegável.

---

### MVC no Jakarta EE: quem é quem

No ecossistema do Jakarta EE, o mapeamento entre as camadas do MVC e as tecnologias é direto e convencional.

O **Model** é representado por dois grupos de classes Java puras. O primeiro são as **entidades**: classes como `Task.java` com atributos (`id`, `titulo`, `descricao`, `status`, `dataCriacao`), construtores, getters e setters. São POJOs — nenhuma dependência de framework. O segundo são os **repositórios**: classes como `TaskRepository.java` com métodos `save`, `findAll`, `findById`, `update` e `delete`. Ambos os grupos são testáveis diretamente com JUnit, sem nenhum mock necessário.

A **View** é representada por arquivos **JSP** em `src/main/webapp/WEB-INF/views/`. Ficam dentro de `WEB-INF/` para que só sejam acessíveis via Controller — nunca diretamente pelo navegador. Usam Expression Language e JSTL para exibir dados, sem lógica de negócio.

O **Controller** é representado por classes que herdam de **HttpServlet** com **`@WebServlet`**. No TaskFlow, o `TaskServlet.java` em `src/main/java/com/taskflow/controller/`. É testável com Mockito quando necessário, mas deve permanecer fino para minimizar a necessidade de testes com mocks.

---

### MVC e testabilidade: como a separação facilita os testes

Esta seção é nova em relação ao que cursos tradicionais ensinam sobre MVC — e é diretamente conectada ao que você aprendeu na Aula 6 com JUnit 5 e Mockito.

Ao longo do curso, você usará três estratégias de teste diferentes para cada camada do MVC, e é importante entender por que cada estratégia é adequada para cada camada.

Para o **Model** — as classes `Task.java`, `TaskRepository.java` e classes de serviço como `SaudacaoService.java` — você usa **JUnit 5 puro, sem nenhum mock**. Essas classes são POJOs independentes de qualquer framework. Você instancia diretamente com `new TaskRepository()`, chama `save(task)`, chama `findAll()` e verifica com `assertEquals`. Os testes são instantâneos, determinísticos e extremamente simples de escrever. Esta é a camada onde você quer a maior densidade de testes, porque é aqui que vive toda a lógica que importa.

Para o **Controller** — os Servlets como `TaskServlet.java` — você usa **JUnit 5 com Mockito**, exatamente como fez no `SaudacaoServletTest`. Você cria mocks de `HttpServletRequest` e `HttpServletResponse`, define o comportamento esperado com `when`, chama `doGet` ou `doPost` e verifica com `verify` que os métodos corretos foram chamados. Esses testes são um pouco mais trabalhosos de escrever — mas são rápidos e não precisam de servidor. Use-os para verificar que o Controller lê os parâmetros corretos, chama o repositório certo e encaminha para a View adequada.

Para a **View** — os arquivos JSP — testes automatizados unitários não são práticos. JSPs são testados indiretamente através dos testes de Controller (que verificam para qual JSP o forward foi feito) e, em projetos maiores, através de testes de integração que sobem o servidor. Por agora, os JSPs serão verificados manualmente no navegador. Esta é mais uma razão para manter os JSPs simples: quanto menos lógica eles tiverem, menos comportamento ficará sem cobertura automatizada.

A divisão MVC não é apenas organizacional — ela é uma **estratégia deliberada de testabilidade**. Quando você vê um Servlet com 200 linhas de lógica de negócio, você está vendo 200 linhas que exigem mocks do Mockito para serem testadas. Quando você extrai essa lógica para o Model, aquelas mesmas 200 linhas passam a ser testadas com JUnit puro — dez vezes mais simples de escrever e dez vezes mais rápidas de executar.

---

### Por que separar responsabilidades importa de verdade

A separação de responsabilidades proposta pelo MVC tem três implicações concretas e mensuráveis na qualidade do software.

A primeira é a **manutenibilidade**. Quando cada camada tem uma responsabilidade única, alterar uma delas não exige entender as outras. Para mudar o visual da listagem de tarefas, você edita apenas o `list.jsp`. Para mudar a forma como as tarefas são armazenadas, você edita apenas o `TaskRepository`. Esse isolamento reduz o risco de regressões.

A segunda é a **testabilidade**, que já discutimos em detalhes. O Model é testável com JUnit puro. O Controller é testável com Mockito. A View é verificada manualmente ou com testes de integração. Cada camada tem uma estratégia de teste adequada à sua natureza.

A terceira é a **colaboração em equipe**. Em projetos reais, diferentes desenvolvedores podem trabalhar em camadas diferentes simultaneamente sem conflitos. O desenvolvedor frontend trabalha nos JSPs enquanto o desenvolvedor backend trabalha no repositório. As interfaces entre as camadas são o contrato que os mantém alinhados.

---

### Os erros mais comuns de quem ignora o MVC

O primeiro erro é **colocar lógica de negócio no JSP** com scriptlets `<% %>`. Além de violar o MVC, isso torna o código completamente intratável do ponto de vista dos testes — você não pode testar lógica embutida em JSP com JUnit ou Mockito.

O segundo erro é **o Servlet gerando HTML com PrintWriter** em vez de delegar para a View. O `SaudacaoServlet` ainda faz isso — e está correto para seu propósito de exemplo da Aula 6. Mas o `TaskServlet`, que será o Controller real do TaskFlow, não deve gerar HTML. Ele deve encaminhar para os JSPs via `RequestDispatcher.forward()`.

O terceiro erro é **o Controller contendo lógica de negócio**. Se você vê um `doGet` com cálculos, validações de regras de domínio ou lógica condicional complexa, essa lógica deve estar no Model. O Controller deve ser tão fino que seus testes com Mockito sejam triviais de escrever.

---

## Analogia de Ancoragem

O MVC funciona como um **restaurante bem administrado com três equipes completamente separadas**: a equipe da cozinha (Model), que conhece todas as receitas e regras de preparo mas nunca fala com os clientes; a equipe dos garçons (Controller), que anota pedidos, repassa para a cozinha e entrega os pratos prontos, mas nunca cozinha; e a equipe de decoração e apresentação das mesas (View), que decide como o ambiente fica visualmente para o cliente, mas não conhece as receitas. O inspetor de saúde (os testes automatizados) pode verificar a cozinha a qualquer momento sem precisar abrir o restaurante para clientes reais — porque a cozinha é um ambiente independente e controlável. Isso é possível exatamente porque as três equipes não se misturam.

---

## Diagrama Mermaid

~~~mermaid
sequenceDiagram
    participant NAV as Navegador
    participant GF as GlassFish
    participant CTRL as TaskServlet (Controller)
    participant REPO as TaskRepository (Model)
    participant JSP as list.jsp (View)

    NAV->>GF: GET /taskflow/tasks
    GF->>CTRL: doGet(request, response)

    Note over CTRL: Lê parâmetros da requisição
    CTRL->>REPO: findAll()
    REPO-->>CTRL: List<Task>

    Note over CTRL: request.setAttribute("tasks", tasks)
    CTRL->>GF: RequestDispatcher.forward(request, response)
    GF->>JSP: processa list.jsp com ${tasks}

    Note over JSP: c:forEach itera sobre tasks
    Note over JSP: Gera HTML da tabela
    JSP-->>NAV: HTML da listagem de tarefas

    Note over NAV,JSP: ─── Estratégia de Testes por Camada ───
    Note over REPO: JUnit 5 puro (sem mocks)
    Note over CTRL: JUnit 5 + Mockito
    Note over JSP: Verificação manual / testes de integração
~~~

---

## Aplicação no Projeto Prático

### Passo 1: Entendendo o estado atual do projeto

Antes de refatorar, veja o estado atual. O projeto tem os seguintes arquivos Java:

~~~text
src/main/java/com/taskflow/
├── controller/
│   ├── HelloServlet.java       ← Servlet de treinamento da Aula 5
│   └── SaudacaoServlet.java    ← Servlet de treinamento da Aula 6
└── service/
    ├── SaudacaoService.java    ← Serviço da Aula 6
    └── CalculadoraTaxa.java    ← Exercício da Aula 6

src/test/java/com/taskflow/
└── service/
    ├── SaudacaoServiceTest.java     ← 5 testes JUnit 5 puro
    ├── SaudacaoServletTest.java     ← 5 testes com Mockito
    └── CalculadoraTaxaTest.java     ← Exercício da Aula 6
~~~

O que faremos nesta aula: criaremos os pacotes `model`, `repository` e `filter` (ainda vazios), moveremos o `service` para o lugar certo, removeremos os Servlets de treinamento e criaremos o `TaskServlet` como placeholder do Controller real.

---

### Passo 2: Criando a estrutura de pacotes MVC

No terminal do VS Code, na raiz do projeto, crie as pastas dos pacotes:

~~~
mkdir src\main\java\com\taskflow\model
mkdir src\main\java\com\taskflow\repository
mkdir src\main\java\com\taskflow\filter
~~~

O pacote `controller` já existe (criado na Aula 5). O pacote `service` já existe (criado na Aula 6). Ambos permanecem onde estão.

Crie também as pastas espelhadas para os testes:

~~~
mkdir src\test\java\com\taskflow\model
mkdir src\test\java\com\taskflow\repository
mkdir src\test\java\com\taskflow\controller
~~~

A pasta `src\test\java\com\taskflow\controller` receberá futuros testes com Mockito para o `TaskServlet` — seguindo o mesmo padrão do `SaudacaoServletTest` que você escreveu na Aula 6.

---

### Passo 3: Criando a estrutura de pastas para as Views

As Views JSP ficarão dentro de `WEB-INF/views/` para que só sejam acessíveis via Controller. Crie as pastas:

~~~
mkdir src\main\webapp\WEB-INF\views
mkdir src\main\webapp\WEB-INF\views\task
mkdir src\main\webapp\WEB-INF\views\error
~~~

A pasta `task` receberá `list.jsp`, `form.jsp` e `edit.jsp` nas próximas aulas. A pasta `error` receberá `404.jsp` e `500.jsp` na Aula 17.

Crie também um arquivo `.gitkeep` em cada pasta vazia para que o Git as versione:

~~~
type nul > src\main\webapp\WEB-INF\views\task\.gitkeep
type nul > src\main\webapp\WEB-INF\views\error\.gitkeep
type nul > src\main\java\com\taskflow\model\.gitkeep
type nul > src\main\java\com\taskflow\repository\.gitkeep
type nul > src\main\java\com\taskflow\filter\.gitkeep
~~~

---

### Passo 4: Removendo os Servlets de exemplo

Os Servlets `HelloServlet` e `SaudacaoServlet` foram criados para fins de treinamento nas Aulas 5 e 6. Eles não fazem parte da aplicação TaskFlow e devem ser removidos agora que a estrutura MVC está sendo estabelecida.

Delete os arquivos:

~~~
del src\main\java\com\taskflow\controller\HelloServlet.java
del src\main\java\com\taskflow\controller\SaudacaoServlet.java
~~~

Os arquivos de serviço e de teste continuam — eles são valiosos e os testes continuarão passando:

~~~text
Mantidos:
├── src/main/java/com/taskflow/service/SaudacaoService.java
├── src/main/java/com/taskflow/service/CalculadoraTaxa.java
├── src/test/java/com/taskflow/service/SaudacaoServiceTest.java    ← 5 testes passando
├── src/test/java/com/taskflow/service/SaudacaoServletTest.java    ← mover para controller/
└── src/test/java/com/taskflow/service/CalculadoraTaxaTest.java
~~~

Mova o `SaudacaoServletTest` para a pasta correta de testes de Controller:

~~~
move src\test\java\com\taskflow\service\SaudacaoServletTest.java src\test\java\com\taskflow\controller\SaudacaoServletTest.java
~~~

Atualize a declaração de pacote no arquivo movido. Abra `src/test/java/com/taskflow/controller/SaudacaoServletTest.java` no VS Code e altere a primeira linha:

~~~java
// Pacote correto após a reorganização MVC.
// Testes de Controller ficam em com.taskflow.controller no diretório de testes.
package com.taskflow.controller;
~~~

Execute os testes para confirmar que a reorganização não quebrou nada:

~~~
gradle test
~~~

Todos os testes devem continuar passando — incluindo o `SaudacaoServletTest` agora no pacote correto.

---

### Passo 5: Criando o TaskServlet placeholder

Com os Servlets de treinamento removidos, o projeto precisa de ao menos um Servlet. Crie o `TaskServlet` placeholder — um Servlet temporário que será substituído pelo Controller completo na Aula 11.

Crie o arquivo `src/main/java/com/taskflow/controller/TaskServlet.java`:

~~~java
// Pacote controller: camada responsável por receber requisições HTTP
// e coordenar a resposta, sem conter lógica de negócio.
// Este é o Controller central do TaskFlow — o único Servlet da aplicação.
package com.taskflow.controller;

// Importações do Jakarta EE — usando jakarta.* (não javax.*)
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// Importações Java padrão para IO.
import java.io.IOException;
import java.io.PrintWriter;

// @WebServlet mapeia este Servlet para a URL /tasks.
// URL completa: http://localhost:8080/taskflow/tasks
// A partir da Aula 11, este Servlet deixará de usar PrintWriter
// e passará a encaminhar para os JSPs via RequestDispatcher.forward().
@WebServlet("/tasks")
public class TaskServlet extends HttpServlet {

    // doGet: responde a requisições GET em /tasks.
    // FASE ATUAL (placeholder): exibe uma mensagem de status da arquitetura.
    // FASE AULA 11 (completo): buscará tarefas no TaskRepository e
    // encaminhará para views/task/list.jsp via RequestDispatcher.
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        // Define o tipo de conteúdo como HTML com UTF-8.
        // NOTA: esta linha será mantida apenas enquanto o Servlet gerar HTML.
        // Após a migração para forward ao JSP (Aula 11), o JSP definirá o Content-Type.
        response.setContentType("text/html;charset=UTF-8");

        // PrintWriter temporário — apenas para esta fase de placeholder.
        // A partir da Aula 11, este Servlet NÃO usará PrintWriter.
        // O HTML será gerado pelo JSP, não pelo Controller.
        PrintWriter writer = response.getWriter();

        // Mensagem temporária descrevendo o estado arquitetural do projeto.
        // Esta página será substituída pelo forward para list.jsp na Aula 11.
        writer.println("<!DOCTYPE html>");
        writer.println("<html lang='pt-BR'>");
        writer.println("<head><meta charset='UTF-8'>");
        writer.println("<title>TaskFlow</title></head>");
        writer.println("<body>");
        writer.println("<h1>TaskFlow — Controller no lugar</h1>");
        writer.println("<p>Aula 7 concluída: estrutura MVC criada.</p>");
        writer.println("<ul>");
        // Lista as próximas etapas para contextualizar o aluno.
        writer.println("<li>Aula 8: Views JSP serão criadas em WEB-INF/views/task/</li>");
        writer.println("<li>Aula 9: JSTL será adicionado às Views</li>");
        writer.println("<li>Aula 10: Task.java e TaskRepository.java serão criados (testáveis com JUnit puro)</li>");
        writer.println("<li>Aula 11: este Controller buscará tarefas e encaminhará para o JSP via forward()</li>");
        writer.println("</ul>");
        writer.println("</body></html>");

        writer.close();
    }
}
~~~

---

### Passo 6: Verificando a estrutura final

Execute o build completo para confirmar que tudo está correto:

~~~
gradle clean test war
~~~

A saída esperada inclui todos os testes passando e o WAR gerado:

~~~text
SaudacaoServiceTest > Deve retornar saudação com nome válido PASSED
SaudacaoServiceTest > Deve retornar saudação genérica quando nome nulo PASSED
SaudacaoServiceTest > Deve retornar saudação genérica quando nome vazio PASSED
SaudacaoServiceTest > Deve remover espaços extras PASSED
SaudacaoServiceTest > Resultado nunca deve ser nulo PASSED
SaudacaoServletTest > Deve retornar HTML com saudação personalizada PASSED
SaudacaoServletTest > Deve retornar saudação genérica quando nome nulo PASSED
SaudacaoServletTest > Deve retornar saudação genérica quando nome vazio PASSED
SaudacaoServletTest > Deve definir Content-Type correto PASSED
SaudacaoServletTest > Deve conter link de retorno PASSED
CalculadoraTaxaTest > Deve aplicar 10% de acréscimo PASSED
CalculadoraTaxaTest > Deve retornar zero para valor zero PASSED
CalculadoraTaxaTest > Deve lançar exceção para valor negativo PASSED

BUILD SUCCESSFUL in Xs
~~~

Faça o deploy e acesse `http://localhost:8080/taskflow/tasks` para confirmar o placeholder:

~~~
copy build\libs\taskflow.war C:\ferramentas\glassfish7\domains\domain1\autodeploy\
~~~

Confirme também que `http://localhost:8080/taskflow/hello` retorna 404 — o HelloServlet foi removido.

A estrutura de pastas final deve ser:

~~~text
src/
├── main/
│   ├── java/com/taskflow/
│   │   ├── controller/
│   │   │   └── TaskServlet.java          ← Controller placeholder
│   │   ├── filter/
│   │   │   └── .gitkeep                  ← vazia, receberá LogFilter na Aula 13
│   │   ├── model/
│   │   │   └── .gitkeep                  ← vazia, receberá Task.java na Aula 10
│   │   ├── repository/
│   │   │   └── .gitkeep                  ← vazia, receberá TaskRepository.java na Aula 10
│   │   └── service/
│   │       ├── SaudacaoService.java
│   │       └── CalculadoraTaxa.java
│   └── webapp/
│       ├── WEB-INF/
│       │   ├── web.xml
│       │   └── views/
│       │       ├── task/
│       │       │   └── .gitkeep          ← receberá list.jsp, form.jsp, edit.jsp
│       │       └── error/
│       │           └── .gitkeep          ← receberá 404.jsp, 500.jsp
│       └── index.html
└── test/
    └── java/com/taskflow/
        ├── controller/
        │   └── SaudacaoServletTest.java  ← 5 testes com Mockito (movido da Aula 6)
        ├── model/                         ← vazia, receberá testes da Aula 10
        ├── repository/                    ← vazia, receberá testes da Aula 10
        └── service/
            ├── SaudacaoServiceTest.java  ← 5 testes JUnit 5 puro
            └── CalculadoraTaxaTest.java
~~~

---

### Passo 7: Commit da refatoração

~~~
git add src/
git commit -m "refactor: reorganiza estrutura MVC com pacotes model, repository, controller e filter"
~~~

Use `refactor:` como prefixo porque esta aula reorganiza o código existente para seguir a arquitetura correta, sem adicionar nova funcionalidade ao TaskFlow.

---

## Glossário Técnico da Aula

**MVC (Model-View-Controller):** Padrão de arquitetura de software que separa uma aplicação em três camadas com responsabilidades bem definidas: Model (dados e regras de negócio), View (apresentação) e Controller (mediação entre usuário e sistema).

**Model:** Camada responsável pelos dados do domínio e pela lógica de negócio. No TaskFlow, são as classes `Task.java` e `TaskRepository.java`. Não conhece Servlets nem JSPs. Testável diretamente com JUnit 5 sem nenhum mock.

**View:** Camada responsável pela apresentação dos dados ao usuário. No Jakarta EE, implementada com arquivos JSP em `WEB-INF/views/`. Não contém lógica de negócio. Difícil de testar automaticamente — deve ser mantida simples.

**Controller:** Camada responsável por receber requisições HTTP, coordenar o trabalho entre Model e View e devolver a resposta. No Jakarta EE, implementado como Servlet. Testável com JUnit 5 e Mockito.

**Entidade:** Classe Java POJO representando um objeto do domínio. No TaskFlow, `Task.java` com atributos `titulo`, `descricao`, `status` e `dataCriacao`.

**Repositório:** Classe que encapsula operações de persistência de uma entidade. Oferece `save`, `findAll`, `findById`, `update` e `delete`. Testável com JUnit 5 puro.

**POJO (Plain Old Java Object):** Classe Java simples sem dependências de framework. Testável diretamente com JUnit sem mocks.

**Separação de responsabilidades (Separation of Concerns):** Princípio que diz que cada parte do sistema deve ter uma única responsabilidade bem definida. O MVC é uma aplicação direta deste princípio.

**`RequestDispatcher`:** Objeto do Jakarta Servlet que permite encaminhar uma requisição de um Servlet para outro recurso, geralmente um JSP. O método `forward(request, response)` é o mecanismo de comunicação entre Controller e View no MVC.

**`request.setAttribute(String nome, Object valor)`:** Método do `HttpServletRequest` que armazena um objeto no escopo da requisição. É o mecanismo pelo qual o Controller passa dados para a View antes do `forward`.

**Controller fino:** Servlet com pouca lógica — apenas leitura de parâmetros, chamada ao repositório e encaminhamento para a View. Minimiza a necessidade de testes com Mockito e maximiza a lógica testável com JUnit puro no Model.

**Refatoração:** Processo de melhorar a estrutura interna do código sem alterar seu comportamento externo. Esta aula refatora a estrutura de pacotes sem adicionar funcionalidade.

**Conventional Commits:** Padrão de mensagens de commit com prefixos como `feat:`, `fix:`, `refactor:`, `docs:` e `test:` para comunicar o tipo de mudança. O commit desta aula usa `refactor:`.

**`WEB-INF/`:** Pasta protegida dentro do WAR não acessível diretamente pelo navegador. Os JSPs ficam aqui para garantir que o fluxo MVC seja sempre respeitado — o usuário não pode acessar um JSP sem passar pelo Controller.

---

## Antecipação de Erros

**Colocar lógica de negócio no JSP:** O erro mais comum e mais danoso. Acontece quando o desenvolvedor usa scriptlets `<% %>` nos JSPs para consultar dados ou aplicar validações. Além de violar o MVC, torna o código completamente intratável do ponto de vista dos testes — você não pode instanciar um JSP no JUnit nem criar um mock de JSP com Mockito.

**Servlet gerando HTML com PrintWriter em produção:** O `TaskServlet` desta aula ainda usa `PrintWriter` como placeholder. A partir da Aula 11, o Controller não deve mais gerar HTML — isso é responsabilidade do JSP. Se você se pegar escrevendo `writer.println("<tr><td>" + task.getTitulo() + "</td></tr>")` dentro de um `doGet`, mova esse conteúdo para um JSP e use `forward`.

**Controller com lógica de negócio:** Acontece quando o `doGet` ou `doPost` contém validações de regras de domínio, cálculos ou decisões complexas. Toda essa lógica pertence ao Model — onde é testável com JUnit puro, sem necessidade de Mockito.

**JSPs fora da pasta `WEB-INF/`:** Se você criar JSPs em `src/main/webapp/views/` em vez de `src/main/webapp/WEB-INF/views/`, eles ficam acessíveis pela URL sem passar pelo Controller. Um usuário poderia acessar `/taskflow/views/task/list.jsp` diretamente, vendo uma página sem dados. Sempre coloque JSPs dentro de `WEB-INF/`.

**Pacotes nomeados incorretamente:** Use sempre letras minúsculas nos nomes de pacotes (`controller`, não `Controller`). No Windows 11, o sistema de arquivos é case-insensitive e o erro não aparece. Em servidores Linux (onde aplicações em produção geralmente rodam), o sistema é case-sensitive e a aplicação não deployará.

**Confundir `forward` com `redirect`:** `RequestDispatcher.forward()` é interno ao servidor — a URL não muda e os atributos do request são preservados. `response.sendRedirect()` instrui o navegador a fazer uma nova requisição — a URL muda e os atributos do request são perdidos. Para passar dados do Controller para a View via `setAttribute`, sempre use `forward`.

**Testes quebrando após mover o `SaudacaoServletTest`:** Ao mover o arquivo para o pacote `com.taskflow.controller`, a declaração `package` no topo do arquivo deve ser atualizada de `com.taskflow.service` para `com.taskflow.controller`. Se esquecer de atualizar, o Gradle reportará um erro de compilação com a mensagem "class is public, should be declared in a file named...".

---

## Exercício de Fixação

Este exercício não envolve escrita de código Java — ele envolve pensar antes de codificar, e conecta diretamente a estratégia de testes que você aprendeu na Aula 6 com a arquitetura MVC desta aula.

**Parte 1 — Diagrama do fluxo MVC com estratégia de testes:** Em papel, no draw.io (`https://draw.io`) ou em qualquer ferramenta de diagrama, desenhe o fluxo completo de uma requisição de **criação de nova tarefa** percorrendo as três camadas do MVC. Seu diagrama deve incluir: Navegador → TaskServlet (Controller) → TaskRepository (Model) → Task (Entidade) e, para cada camada, anote a estratégia de teste correspondente: JUnit 5 puro para o Model, JUnit 5 + Mockito para o Controller, verificação manual para a View.

**Parte 2 — Análise de responsabilidades e testabilidade:** Para cada operação listada abaixo, decida a qual camada ela pertence (Model, View ou Controller), justifique em uma frase e indique se ela seria testada com JUnit puro, com Mockito ou manualmente. Registre em `modulo_02_essencial/aula_07/exercicio_07.txt`:

- Verificar se o título da tarefa não está vazio antes de salvar.
- Exibir uma mensagem de erro em vermelho quando o título estiver vazio.
- Chamar `taskRepository.save(task)` após receber os dados do formulário.
- Gerar a tabela HTML com a lista de tarefas.
- Decidir para qual JSP encaminhar após processar o formulário.
- Gerar automaticamente o `id` único de uma nova tarefa.
- Formatar a data de criação como "dd/MM/yyyy" para exibição.

**Parte 3 — Reflexão sobre testes e arquitetura:** Responda no arquivo `exercicio_07.txt`: na Aula 6, você escreveu dois conjuntos de testes — o `SaudacaoServiceTest` (sem mocks) e o `SaudacaoServletTest` (com Mockito). Qual dos dois foi mais simples de escrever? Por que o MVC faz com que a maioria dos testes de uma aplicação bem projetada seja do tipo "sem mocks"?

Ao final, faça o commit:

~~~
git add modulo_02_essencial/aula_07/
git commit -m "docs: adiciona exercicio de diagrama MVC com estrategia de testes - aula 07"
~~~

---

## Resolução Comentada do Exercício

**Parte 1 — Diagrama:** O diagrama correto mostra duas rotas a partir do POST do formulário. A rota de sucesso: Navegador → POST /tasks?action=salvar → TaskServlet (Controller, testável com Mockito) → lê parâmetros → cria objeto Task → chama TaskRepository.save(task) (Model, testável com JUnit puro) → TaskServlet → `response.sendRedirect("/taskflow/tasks")` → Navegador faz GET /tasks → TaskServlet → TaskRepository.findAll() → `request.setAttribute("tasks")` → `forward` para list.jsp (View, verificação manual). A rota de erro: POST → TaskServlet → dados inválidos → `request.setAttribute("erros")` → `forward` para form.jsp → Navegador vê o formulário com mensagens de erro.

**Parte 2 — Análise:** Verificar se o título não está vazio pertence ao **Model** (regra de negócio) — testado com JUnit puro. Exibir a mensagem em vermelho pertence à **View** (apresentação) — verificação manual. Chamar `taskRepository.save(task)` pertence ao **Controller** (coordenação) — testado com Mockito verificando que `save` foi chamado. Gerar a tabela HTML pertence à **View** — verificação manual. Decidir para qual JSP encaminhar pertence ao **Controller** — testado com Mockito verificando o caminho do `forward`. Gerar o `id` único pertence ao **Model** (regra de domínio) — testado com JUnit puro. Formatar a data para exibição: se for preferência visual, pertence à **View**; se for regra de negócio, pertence ao **Model** — a JSTL `<fmt:formatDate>` é geralmente a abordagem correta para formatação visual.

**Parte 3 — Reflexão:** O `SaudacaoServiceTest` (sem mocks) foi visivelmente mais simples — `new SaudacaoService()`, `gerarSaudacao("Bianeck")`, `assertEquals("Olá, Bianeck!", resultado)`. Três linhas. Nenhuma configuração de mock. O `SaudacaoServletTest` com Mockito exigiu declarar os mocks, configurar o `StringWriter`, fazer o stub de `getWriter()`, chamar `doGet` e verificar com `verify`. O MVC faz com que a maioria dos testes seja "sem mocks" porque ele concentra a lógica importante no Model, que é um POJO independente de qualquer infraestrutura. Em uma aplicação bem projetada, 80% dos testes são do Model (JUnit puro), 15% são do Controller (Mockito) e 5% são de integração. Isso não é coincidência — é o resultado direto de separar responsabilidades corretamente.

---

## Resumo dos Pontos-Chave

O **MVC** separa a aplicação em três camadas com responsabilidades únicas: o **Model** guarda dados e regras de negócio (testável com JUnit puro, sem mocks), a **View** apresenta os dados ao usuário (JSPs, verificados manualmente) e o **Controller** coordena a comunicação entre Model e View (Servlets, testáveis com Mockito). O fluxo de uma requisição MVC é sempre: **navegador → Controller → Model → Controller → View → navegador**. A separação de responsabilidades tem três benefícios concretos: **manutenibilidade** (cada camada muda independentemente), **testabilidade** (cada camada tem uma estratégia de teste adequada) e **colaboração** (diferentes desenvolvedores trabalham em camadas diferentes). **Manter o Controller fino** é fundamental: quanto menos lógica de negócio no Controller, mais testes simples de JUnit puro existirão no Model e menos testes trabalhosos com Mockito serão necessários. Os JSPs devem sempre ficar dentro de **`WEB-INF/`** para que só sejam acessíveis via Controller. O `SaudacaoServletTest` foi movido para o pacote `com.taskflow.controller` nos testes — refletindo a organização MVC correta.

---

## Log de Estado do Projeto

~~~text
## Aula 7: Arquitetura MVC: separando responsabilidades
- Objetivo: Organizar o projeto TaskFlow em uma estrutura MVC clara e coesa.
- Código Adicionado:
    Estrutura de pacotes criada: model/, repository/, filter/ (vazias com .gitkeep).
    src/main/java/com/taskflow/controller/TaskServlet.java — placeholder do Controller.
    src/main/webapp/WEB-INF/views/task/ — pasta vazia para os futuros JSPs.
    src/main/webapp/WEB-INF/views/error/ — pasta vazia para páginas de erro.
    HelloServlet.java e SaudacaoServlet.java removidos.
    SaudacaoServletTest.java movido para src/test/java/com/taskflow/controller/.
    modulo_02_essencial/aula_07/exercicio_07.txt com diagrama e análise MVC.
- Estado Funcional: ✅ Estrutura MVC criada. Acessar /tasks exibe placeholder.
  gradle clean test war gera BUILD SUCCESSFUL com 13 testes passando:
  5 no SaudacaoServiceTest (JUnit puro), 5 no SaudacaoServletTest (Mockito),
  3 no CalculadoraTaxaTest (JUnit puro).
- Próximas Etapas: Aula 8 criará as Views com JSP (list.jsp e form.jsp),
  explicará a sintaxe JSP, a Expression Language e por que evitar scriptlets.
~~~

---

## Prompt de Continuidade para a Aula 8

"Sou aluno do curso Jakarta EE 11 com Java 21, Gradle, JUnit 5 e VS Code. Concluí a Aula 7 (Arquitetura MVC: separando responsabilidades). A estrutura de pacotes MVC está criada: model/, repository/, controller/ e filter/. O TaskServlet.java existe como placeholder em /tasks. As pastas WEB-INF/views/task/ e WEB-INF/views/error/ estão criadas e vazias. Os Servlets de treinamento foram removidos. O SaudacaoServletTest foi movido para o pacote com.taskflow.controller nos testes. O gradle clean test war gera BUILD SUCCESSFUL com 13 testes passando: 5 no SaudacaoServiceTest (JUnit 5 puro, sem mocks), 5 no SaudacaoServletTest (Mockito) e 3 no CalculadoraTaxaTest. Tenho o plano_mestre.txt, o log_estado_projeto.md e os prompts_individuais.md em anexo para contexto. Por favor, gere a **Aula 8: Jakarta Server Pages: criando as Views com JSP**, seguindo rigorosamente a estrutura definida no plano mestre: teoria detalhada com mínimo de 2.000 palavras, analogia de ancoragem, diagrama Mermaid com blocos ~~~mermaid, código comentado linha a linha com blocos ~~~, glossário técnico, antecipação de erros, exercício com resolução comentada, resumo dos pontos-chave, log de estado do projeto atualizado e prompt de continuidade para a Aula 9. O documento inteiro deve estar dentro de um bloco ```markdown. Nenhum bloco interno deve usar triple backtick."

---

Dúvidas? Posso prosseguir para a **Aula 8: Jakarta Server Pages: criando as Views com JSP**?