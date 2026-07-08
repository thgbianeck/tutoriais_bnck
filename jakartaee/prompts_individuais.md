# Prompts Individuais — Jakarta EE 11 com Java 21, Gradle, JUnit 5 e VS Code

Este documento contém os prompts detalhados para a geração de cada aula do curso, seguindo a estrutura e as regras definidas no `plano_mestre.txt`. Cada prompt instrui o Tutor Sênior a gerar uma aula completa, com teoria densa, analogias, diagramas Mermaid, aplicação prática no projeto TaskFlow, glossário, antecipação de erros, exercícios com resoluções e resumo, garantindo um mínimo de 2.000 palavras e o formato Markdown especificado.

---

## Módulo 1 — Fundamentos: Teoria, Ambiente e Primeiros Passos

### Aula 1: O que é Jakarta EE e como o ecossistema funciona

**Prompt:**
"Gere a **Aula 1: O que é Jakarta EE e como o ecossistema funciona**.
**Objetivo:** Entender o que é uma especificação, a diferença entre Java EE e Jakarta EE, o papel das APIs e do servidor de aplicações, e ter uma visão geral do projeto TaskFlow que será construído ao longo do curso.
**Pré-requisitos:** Nenhum. Este é o ponto de partida absoluto.
**Projeto Prático:** Nenhum código ainda. Esta aula é teórica e contextualiza tudo o que virá a seguir. O aluno deve criar a pasta raiz `taskflow/` e o arquivo `README.md` com uma descrição inicial do projeto.
**Log de Estado do Projeto:**
- **Objetivo:** Compreender o ecossistema Jakarta EE e criar a estrutura inicial do repositório.
- **Código Adicionado:** Nenhum código Java ainda. Apenas a criação da pasta `taskflow/` e do `README.md` com a descrição do projeto.
- **Estado Funcional:** ⏳ Projeto ainda sem código. Ambiente será configurado na Aula 2.
- **Próximas Etapas:** Aula 2 instalará o Java 21, o Gradle e o VS Code com as extensões necessárias.
**Instruções Específicas:**
- Explique com analogias do cotidiano o que é uma especificação versus uma implementação (use o exemplo de uma receita de bolo e diferentes padarias que a seguem).
- Conte a história do Java EE ao Jakarta EE de forma narrativa, explicando por que a transição para a Eclipse Foundation aconteceu.
- Apresente as principais APIs do Jakarta EE 11 que o curso abordará: Servlet, JSP, JPA e Bean Validation.
- Explique o papel do servidor de aplicações com uma analogia clara (use o exemplo de um gerente de hotel que recebe hóspedes e os direciona para os quartos certos).
- O diagrama Mermaid deve ilustrar a relação entre a especificação Jakarta EE, o servidor de aplicações GlassFish e a aplicação TaskFlow.
- Apresente o projeto TaskFlow com entusiasmo, descrevendo o que o aluno será capaz de construir ao final do curso.
- A seção de antecipação de erros deve cobrir a confusão comum entre Jakarta EE e Spring Framework, explicando que são coisas diferentes e que o curso foca no Jakarta EE.
- O exercício deve ser uma reflexão escrita: o aluno deve listar pelo menos três situações do cotidiano que se beneficiariam de uma aplicação web e descrever brevemente como o Jakarta EE poderia ser usado em cada uma."

---

### Aula 2: Configurando o ambiente de desenvolvimento no Windows 11

**Prompt:**
"Gere a **Aula 2: Configurando o ambiente de desenvolvimento no Windows 11**.
**Objetivo:** Instalar e verificar o Java 21, instalar e configurar o Gradle, configurar o VS Code com as extensões essenciais para desenvolvimento Jakarta EE e preparar o ambiente completo para o projeto TaskFlow.
**Pré-requisitos:** Aula 1 concluída. Conceitos de Jakarta EE, servidor de aplicações e projeto TaskFlow apresentados.
**Projeto Prático:** Ao final desta aula, o aluno terá o ambiente 100% funcional e será capaz de executar `java --version` e `gradle --version` no terminal do Windows 11 com sucesso.
**Log de Estado do Projeto:**
- **Objetivo:** Configurar o ambiente de desenvolvimento completo no Windows 11.
- **Código Adicionado:** Nenhum código Java ainda. O aluno instala ferramentas e configura o ambiente.
- **Estado Funcional:** ⏳ Ambiente configurado, aguardando criação do projeto Gradle na Aula 3.
- **Próximas Etapas:** Aula 3 criará a estrutura do projeto Gradle com as dependências do Jakarta EE 11.
**Instruções Específicas:**
- Instrua a instalação do Java 21 via o site oficial da Oracle ou via Adoptium, com prints descritivos de cada passo para Windows 11.
- Explique a configuração da variável de ambiente `JAVA_HOME` e a adição do Java ao `PATH` no Windows 11, passo a passo.
- Instrua a instalação do Gradle via o site oficial do Gradle, com configuração do `PATH` no Windows 11.
- Liste e explique as extensões essenciais do VS Code: Extension Pack for Java (Microsoft), Gradle for Java e XML.
- O diagrama Mermaid deve ilustrar as ferramentas instaladas e como elas se relacionam (Java → Gradle → VS Code → GlassFish).
- A seção de antecipação de erros deve cobrir os erros mais comuns: `java` não reconhecido no terminal (PATH mal configurado), versão errada do Java instalada e conflito entre múltiplas versões do Java.
- O exercício deve ser a verificação de cada ferramenta instalada: executar `java --version`, `gradle --version` e abrir o VS Code verificando que as extensões estão ativas, registrando os resultados em um arquivo `ambiente.txt`."

---

### Aula 3: Seu primeiro projeto Jakarta EE com Gradle

**Prompt:**
"Gere a **Aula 3: Seu primeiro projeto Jakarta EE com Gradle**.
**Objetivo:** Criar a estrutura completa do projeto Gradle para Jakarta EE 11, configurar o `build.gradle` com as dependências corretas, entender a estrutura de diretórios de uma aplicação web Java e gerar o primeiro arquivo WAR.
**Pré-requisitos:** Aula 2 concluída. Java 21, Gradle e VS Code configurados no Windows 11.
**Projeto Prático:** Criação da estrutura de diretórios do TaskFlow, do `build.gradle` e do `settings.gradle`, com geração do primeiro WAR vazio e funcional via `gradle war`.
**Log de Estado do Projeto:**
- **Objetivo:** Criar a estrutura base do projeto Gradle para o TaskFlow com Jakarta EE 11.
- **Código Adicionado:** Arquivos `build.gradle`, `settings.gradle`, `src/main/webapp/WEB-INF/web.xml` e a estrutura de diretórios completa do projeto.
- **Estado Funcional:** ✅ O comando `gradle war` gera o arquivo `taskflow.war` em `build/libs/` sem erros.
- **Próximas Etapas:** Aula 4 fará o deploy deste WAR no GlassFish 7 e explicará o ciclo de vida de uma aplicação web.
**Instruções Específicas:**
- Explique o que é o Gradle e por que ele é uma ferramenta de build, com analogia do cotidiano (use a analogia de uma receita de culinária que define ingredientes e etapas de preparo).
- Mostre a criação do projeto passo a passo: criação de pastas, arquivos `build.gradle` e `settings.gradle`.
- Explique cada linha do `build.gradle` comentando linha a linha: o plugin `war`, a dependência `jakarta.jakartaee-api:11.0.0` com escopo `compileOnly` e a configuração do nome do WAR.
- Explique a estrutura de diretórios `src/main/java`, `src/main/resources`, `src/main/webapp` e `src/test/java` com analogia de um prédio com andares especializados.
- Explique o `web.xml` mínimo necessário para uma aplicação Jakarta EE 11.
- O diagrama Mermaid deve ilustrar o processo de build do Gradle: fontes → compilação → empacotamento → WAR.
- A seção de antecipação de erros deve cobrir dependência com escopo errado (usar `implementation` em vez de `compileOnly` para a API Jakarta EE), versão incompatível do Gradle e erros de estrutura de diretórios.
- O exercício deve ser a adição de um segundo arquivo estático (uma página HTML simples) ao projeto e a verificação de que ele aparece dentro do WAR gerado."

---

### Aula 4: Entendendo o servidor de aplicações: GlassFish 7

**Prompt:**
"Gere a **Aula 4: Entendendo o servidor de aplicações: GlassFish 7**.
**Objetivo:** Entender o que é um servidor de aplicações, por que ele existe, como instalar e configurar o GlassFish 7 no Windows 11 e como fazer o deploy do WAR gerado na Aula 3.
**Pré-requisitos:** Aula 3 concluída. Projeto Gradle do TaskFlow criado e WAR gerado com sucesso.
**Projeto Prático:** Instalação do GlassFish 7, deploy do WAR do TaskFlow e verificação de que a aplicação está respondendo em `http://localhost:8080/taskflow`.
**Log de Estado do Projeto:**
- **Objetivo:** Fazer o deploy do TaskFlow no GlassFish 7 e verificar que a aplicação está no ar.
- **Código Adicionado:** Nenhum código Java novo. O WAR da Aula 3 é deployado no GlassFish 7.
- **Estado Funcional:** ✅ A aplicação TaskFlow está acessível em `http://localhost:8080/taskflow` (com uma página HTML estática por enquanto).
- **Próximas Etapas:** Aula 5 criará o primeiro Servlet para que o servidor passe a responder com conteúdo dinâmico.
**Instruções Específicas:**
- Explique o que é um servidor de aplicações com uma analogia clara: o servidor é como um gerente de restaurante que recebe os clientes (requisições HTTP), os encaminha para o garçom certo (Servlet) e devolve o pedido pronto (resposta HTTP).
- Instrua o download do GlassFish 7 no site oficial e a extração no Windows 11.
- Explique como iniciar o GlassFish via terminal: `asadmin start-domain` e como parar: `asadmin stop-domain`.
- Explique o console de administração do GlassFish em `http://localhost:4848` e como fazer o deploy de um WAR pela interface web.
- Explique também o deploy manual copiando o WAR para a pasta `domains/domain1/autodeploy/`.
- O diagrama Mermaid deve ilustrar o fluxo de uma requisição HTTP chegando ao GlassFish e sendo processada.
- A seção de antecipação de erros deve cobrir a porta 8080 já em uso por outro processo, erros de permissão no Windows 11 e o WAR não sendo deployado corretamente.
- O exercício deve ser o undeploy da aplicação pelo console de administração e o redeploy manual copiando o WAR para a pasta `autodeploy`, verificando os logs do GlassFish."

---

### Aula 5: Introdução aos Servlets: o coração do Jakarta EE Web

**Prompt:**
"Gere a **Aula 5: Introdução aos Servlets: o coração do Jakarta EE Web**.
**Objetivo:** Entender o que é um Servlet, compreender seu ciclo de vida completo (`init`, `service`, `destroy`), criar o primeiro Servlet com a anotação `@WebServlet` e fazer o servidor responder uma mensagem simples ao navegador.
**Pré-requisitos:** Aula 4 concluída. GlassFish 7 instalado e funcionando, TaskFlow deployado.
**Projeto Prático:** Criação do primeiro Servlet do TaskFlow, a classe `HelloServlet`, mapeada em `/hello`, que responde com uma mensagem HTML simples ao navegador.
**Log de Estado do Projeto:**
- **Objetivo:** Criar o primeiro Servlet funcional do projeto TaskFlow.
- **Código Adicionado:** Arquivo `src/main/java/com/taskflow/controller/HelloServlet.java` com a anotação `@WebServlet("/hello")` e o método `doGet` respondendo com `Hello, TaskFlow!` em HTML.
- **Estado Funcional:** ✅ Acessar `http://localhost:8080/taskflow/hello` exibe `Hello, TaskFlow!` no navegador.
- **Próximas Etapas:** Aula 6 aprofundará o protocolo HTTP, explicará GET e POST e introduzirá os primeiros testes com JUnit 5.
**Instruções Específicas:**
- Explique o que é um Servlet com a analogia de um funcionário de balcão: ele fica esperando os clientes (requisições), atende um de cada vez e devolve a resposta.
- Explique o ciclo de vida do Servlet em detalhes: quando `init` é chamado (apenas uma vez, ao carregar), quando `service` é chamado (a cada requisição) e quando `destroy` é chamado (ao descarregar).
- Mostre a criação da classe `HelloServlet` comentando cada linha: a herança de `HttpServlet`, a anotação `@WebServlet`, o método `doGet`, o uso de `PrintWriter` para escrever a resposta e o `setContentType`.
- Explique como o GlassFish mapeia a URL `/hello` para a classe `HelloServlet` através da anotação.
- O diagrama Mermaid deve ilustrar o ciclo de vida completo do Servlet: carregamento → `init` → múltiplas chamadas a `service` → `destroy`.
- A seção de antecipação de erros deve cobrir o erro 404 ao errar o mapeamento da URL, o esquecimento de herdar `HttpServlet` e o WAR não sendo redeployado após mudanças no código.
- O exercício deve ser a criação de um segundo Servlet mapeado em `/sobre` que responde com informações sobre o projeto TaskFlow em HTML."

---

### Aula 6: Requisições e Respostas HTTP com Servlets e TDD com JUnit 5

**Prompt:**
"Gere a **Aula 6: Requisições e Respostas HTTP com Servlets e TDD com JUnit 5**.
**Objetivo:** Entender as classes `HttpServletRequest` e `HttpServletResponse`, compreender a diferença prática entre os métodos HTTP GET e POST, aprender a ler parâmetros de uma requisição e fazer uma introdução prática ao TDD com JUnit 5.
**Pré-requisitos:** Aula 5 concluída. Primeiro Servlet criado e funcionando.
**Projeto Prático:** Criação de um Servlet que lê o parâmetro `nome` de uma requisição GET e responde com uma saudação personalizada. Adição do JUnit 5 ao `build.gradle` e criação do primeiro teste unitário de lógica pura.
**Log de Estado do Projeto:**
- **Objetivo:** Demonstrar a leitura de parâmetros HTTP e introduzir TDD com JUnit 5 no projeto.
- **Código Adicionado:** Servlet `SaudacaoServlet.java` que lê o parâmetro `nome` via `request.getParameter("nome")`. Configuração do JUnit 5 no `build.gradle`. Classe de teste `SaudacaoServiceTest.java` testando a lógica de geração da saudação de forma isolada.
- **Estado Funcional:** ✅ Acessar `/saudacao?nome=Bianeck` exibe `Olá, Bianeck!`. Os testes JUnit passam com sucesso.
- **Próximas Etapas:** Aula 7 introduzirá a arquitetura MVC e refatorará o projeto para seguir o padrão corretamente.
**Instruções Específicas:**
- Explique o protocolo HTTP com a analogia de uma carta: o envelope (cabeçalho) e o conteúdo (corpo), o remetente (cliente) e o destinatário (servidor).
- Explique GET versus POST com exemplos práticos: GET é como perguntar algo (parâmetros na URL), POST é como enviar um formulário (parâmetros no corpo da requisição).
- Explique os métodos mais usados de `HttpServletRequest`: `getParameter`, `getMethod`, `getRequestURI`.
- Explique os métodos mais usados de `HttpServletResponse`: `setContentType`, `setStatus`, `getWriter`.
- Introduza o TDD com a metáfora do arquiteto que desenha a planta antes de construir: escreva o teste primeiro (ele falha), depois escreva o código (o teste passa).
- Mostre a configuração do JUnit 5 no `build.gradle` comentando cada linha.
- O diagrama Mermaid deve ilustrar o ciclo TDD: Red (teste falha) → Green (código passa) → Refactor (código limpo).
- A seção de antecipação de erros deve cobrir tentar testar o Servlet diretamente com JUnit (explicando por que isso é complexo e que no início testamos a lógica de negócio isolada), e o parâmetro retornando `null` quando não enviado.
- O exercício deve ser a criação de um teste para uma classe `CalculadoraTaxa` com o método `calcular(double valor)` que retorna o valor com 10% de acréscimo, seguindo o ciclo TDD completo."

---

## Módulo 2 — Essencial: HTTP, MVC e a Estrutura do Projeto

### Aula 7: Arquitetura MVC: separando responsabilidades

**Prompt:**
"Gere a **Aula 7: Arquitetura MVC: separando responsabilidades**.
**Objetivo:** Entender o padrão de arquitetura MVC (Model-View-Controller), compreender o fluxo completo de uma requisição dentro deste padrão e refatorar a estrutura do projeto TaskFlow para seguir o MVC corretamente.
**Pré-requisitos:** Aulas 1 a 6 concluídas. Conhecimento de Servlets, HTTP, parâmetros de requisição e TDD básico.
**Projeto Prático:** Refatoração da estrutura de pacotes do TaskFlow para o padrão MVC: criação dos pacotes `com.taskflow.model`, `com.taskflow.repository` e `com.taskflow.controller`. Criação da pasta `src/main/webapp/views/task/` para as futuras páginas JSP.
**Log de Estado do Projeto:**
- **Objetivo:** Organizar o projeto TaskFlow em uma estrutura MVC clara e coesa.
- **Código Adicionado:** Reorganização dos pacotes Java em `model`, `repository` e `controller`. Criação da estrutura de pastas `webapp/views/`. Remoção dos Servlets de exemplo das aulas anteriores.
- **Estado Funcional:** ✅ A estrutura do projeto está organizada em MVC. Ainda sem lógica de negócio implementada.
- **Próximas Etapas:** Aula 8 criará as Views com JSP, a camada visual do TaskFlow.
**Instruções Específicas:**
- Explique o MVC com a analogia de um restaurante: o cliente faz o pedido ao garçom (Controller), o garçom comunica à cozinha (Model), a cozinha prepara o prato e o garçom entrega ao cliente (View).
- Explique o papel de cada camada no contexto do Jakarta EE: Servlet como Controller, JSP como View e POJO como Model.
- Desenhe com clareza o fluxo de uma requisição MVC: navegador → Servlet (Controller) → Repository (Model) → Servlet (Controller) → JSP (View) → navegador.
- Explique por que separar responsabilidades é importante (manutenibilidade, testabilidade, organização em equipes).
- O diagrama Mermaid deve ilustrar o fluxo completo de uma requisição MVC no TaskFlow, com as camadas bem identificadas.
- A seção de antecipação de erros deve cobrir a tentação de colocar lógica de negócio no JSP ou de misturar Model e Controller no mesmo Servlet.
- O exercício deve ser um diagrama manual (em papel ou ferramenta de diagrama) que o aluno desenha mostrando como uma requisição de `criar nova tarefa` fluiria pelas três camadas do MVC no TaskFlow."

---

### Aula 8: Jakarta Server Pages: criando as Views com JSP

**Prompt:**
"Gere a **Aula 8: Jakarta Server Pages: criando as Views com JSP**.
**Objetivo:** Entender o que é JSP, como o servidor de aplicações processa arquivos JSP, aprender a sintaxe básica (expressões EL, diretivas) e criar as primeiras páginas do TaskFlow: a listagem de tarefas e o formulário de criação.
**Pré-requisitos:** Aula 7 concluída. Estrutura MVC do projeto criada.
**Projeto Prático:** Criação dos arquivos `views/task/list.jsp` (listagem de tarefas) e `views/task/form.jsp` (formulário de criação), com HTML simples e Expression Language (EL) básica.
**Log de Estado do Projeto:**
- **Objetivo:** Criar as páginas JSP que formarão a View do TaskFlow.
- **Código Adicionado:** Arquivos `src/main/webapp/views/task/list.jsp` com uma tabela HTML para listar tarefas e `src/main/webapp/views/task/form.jsp` com um formulário HTML de criação de tarefa.
- **Estado Funcional:** ✅ As páginas JSP existem e podem ser acessadas diretamente, mas ainda sem dados reais (serão conectadas ao Controller nas próximas aulas).
- **Próximas Etapas:** Aula 9 adicionará JSTL para exibir dados dinâmicos nas Views sem Java puro.
**Instruções Específicas:**
- Explique o que é JSP com a analogia de um molde de bolo: o molde (JSP) define a forma, e o recheio (dados do Model) é inserido pelo servidor antes de servir ao cliente.
- Explique como o GlassFish transforma o JSP em um Servlet internamente (compilação transparente).
- Explique a Expression Language (EL): o que é `${variavel}` e como ela busca atributos do request, session e application.
- Mostre as diretivas JSP mais usadas: `<%@ page %>` e `<%@ taglib %>`.
- Explique por que NÃO devemos usar scriptlets `<% %>` nas Views (violação do MVC).
- Crie o `list.jsp` com uma tabela HTML simples e o `form.jsp` com campos `titulo`, `descricao` e `status`.
- O diagrama Mermaid deve ilustrar o processo de transformação do JSP em Servlet pelo GlassFish.
- A seção de antecipação de erros deve cobrir o erro de EL não funcionando (versão do `web.xml` incorreta), o acesso direto à pasta `WEB-INF` sendo bloqueado e a diferença entre EL e scriptlets.
- O exercício deve ser a criação de uma página `views/task/detail.jsp` que exibe os detalhes de uma tarefa individual usando EL, com campos `titulo`, `descricao` e `status`."

---

### Aula 9: JSTL: exibindo dados na View sem Java puro

**Prompt:**
"Gere a **Aula 9: JSTL: exibindo dados na View sem Java puro**.
**Objetivo:** Entender o que é a Jakarta Standard Tag Library (JSTL), configurá-la no projeto, e usar as tags `c:forEach`, `c:if` e `c:out` para exibir dados dinâmicos nas páginas JSP do TaskFlow sem usar Java puro.
**Pré-requisitos:** Aula 8 concluída. Páginas JSP `list.jsp` e `form.jsp` criadas.
**Projeto Prático:** Adição da dependência JSTL ao `build.gradle` e atualização do `list.jsp` para usar `c:forEach` iterando sobre uma lista de tarefas e `c:if` para exibir uma mensagem quando a lista estiver vazia.
**Log de Estado do Projeto:**
- **Objetivo:** Atualizar as Views para usar JSTL, eliminando qualquer Java puro das páginas JSP.
- **Código Adicionado:** Dependência JSTL adicionada ao `build.gradle`. Arquivo `list.jsp` atualizado com `<c:forEach>` e `<c:if>`. Arquivo `form.jsp` atualizado com `<c:out>` para exibir valores com escape seguro.
- **Estado Funcional:** ✅ As Views estão preparadas para receber e exibir dados dinâmicos de forma segura usando JSTL.
- **Próximas Etapas:** Aula 10 criará a entidade `Task` (Model) e o `TaskRepository` com CRUD em memória e testes TDD completos.
**Instruções Específicas:**
- Explique o que é JSTL com a analogia de eletrodomésticos: em vez de construir um motor do zero (Java puro no JSP), usamos um eletrodoméstico pronto (tag JSTL) que faz o trabalho de forma mais segura e limpa.
- Explique como adicionar a dependência JSTL ao `build.gradle` comentando cada linha.
- Explique a diretiva `<%@ taglib %>` necessária para usar JSTL no JSP.
- Demonstre `c:forEach` iterando sobre uma lista, `c:if` para condicionais simples e `c:out` para exibir valores com escape de caracteres especiais (proteção contra XSS básica).
- O diagrama Mermaid deve ilustrar o fluxo de dados: Controller coloca lista no request → JSP usa c:forEach para iterar → HTML é gerado e enviado ao navegador.
- A seção de antecipação de erros deve cobrir a tag JSTL não sendo reconhecida (URI da taglib incorreta), a JSTL não sendo incluída no WAR (dependência com escopo errado) e o `c:out` não escapando caracteres especiais se usado incorretamente.
- O exercício deve ser a criação de uma tag `c:choose` (equivalente ao switch) no `list.jsp` que exibe cores diferentes para tarefas com status `PENDENTE`, `EM_ANDAMENTO` e `CONCLUIDA`."

---

### Aula 10: O Model: a entidade Task e o repositório em memória

**Prompt:**
"Gere a **Aula 10: O Model: a entidade Task e o repositório em memória**.
**Objetivo:** Criar a classe `Task` como POJO (Plain Old Java Object) representando uma tarefa, implementar o `TaskRepository` com `ArrayList` para armazenar tarefas em memória e escrever testes TDD completos para todas as operações do repositório.
**Pré-requisitos:** Aulas 1 a 9 concluídas. Estrutura MVC do projeto definida, Views com JSTL criadas.
**Projeto Prático:** Criação de `Task.java` no pacote `model`, criação de `TaskRepository.java` no pacote `repository` com métodos `save`, `findAll`, `findById`, `update` e `delete`, e testes TDD para cada método na classe `TaskRepositoryTest.java`.
**Log de Estado do Projeto:**
- **Objetivo:** Implementar a camada Model do TaskFlow com a entidade `Task` e o repositório em memória.
- **Código Adicionado:** `Task.java` com atributos `id` (Long), `titulo` (String), `descricao` (String), `status` (String) e `dataCriacao` (LocalDate). `TaskRepository.java` com CRUD completo. `TaskRepositoryTest.java` com testes para cada operação seguindo TDD.
- **Estado Funcional:** ✅ O repositório em memória funciona corretamente e todos os testes JUnit 5 passam.
- **Próximas Etapas:** Aula 11 criará o Controller (`TaskServlet`) conectando o Model às Views.
**Instruções Específicas:**
- Explique o que é um POJO com a analogia de uma ficha cadastral em papel: ela apenas armazena informações, sem lógica complexa.
- Crie a classe `Task` com todos os atributos, construtor, getters e setters, comentando cada elemento linha a linha.
- Explique o padrão Repository com a analogia de um armário de arquivos: você não precisa saber onde cada arquivo está guardado, apenas pede ao repositório e ele encontra.
- Implemente o `TaskRepository` com `ArrayList`, gerando IDs automaticamente com um contador simples, comentando linha a linha.
- Demonstre o ciclo TDD completo: escreva o teste `deveAdicionarTarefa()` (Red), implemente o método `save()` (Green), refatore (Refactor).
- O diagrama Mermaid deve ilustrar o ciclo de vida de uma `Task` passando pelo `TaskRepository`.
- A seção de antecipação de erros deve cobrir `NullPointerException` ao buscar por ID inexistente, a mutabilidade do `ArrayList` sendo compartilhada entre instâncias do repositório e a geração de IDs duplicados.
- O exercício deve ser a escrita de dois testes TDD adicionais: um que verifica que atualizar uma tarefa inexistente lança uma exceção (ou retorna false) e outro que verifica que a lista retornada por `findAll()` não é modificável externamente."

---

### Aula 11: O Controller: conectando Model e View

**Prompt:**
"Gere a **Aula 11: O Controller: conectando Model e View**.
**Objetivo:** Criar o `TaskServlet` como Controller central do TaskFlow, implementar o roteamento de ações via parâmetro de requisição, conectar o Controller ao `TaskRepository` e passar dados para a View usando `request.setAttribute` e `RequestDispatcher`.
**Pré-requisitos:** Aula 10 concluída. `Task.java` e `TaskRepository.java` criados e testados.
**Projeto Prático:** Criação de `TaskServlet.java` no pacote `controller`, mapeado em `/tasks`, com método `doGet` que lista todas as tarefas do repositório e encaminha para o `list.jsp`.
**Log de Estado do Projeto:**
- **Objetivo:** Implementar o Controller do TaskFlow conectando o Model às Views existentes.
- **Código Adicionado:** `TaskServlet.java` com `@WebServlet("/tasks")`, instância de `TaskRepository`, método `doGet` chamando `findAll()`, colocando a lista no request via `setAttribute("tasks", tasks)` e fazendo `forward` para `views/task/list.jsp`.
- **Estado Funcional:** ✅ Acessar `http://localhost:8080/taskflow/tasks` exibe a lista de tarefas (vazia por enquanto) usando o `list.jsp`.
- **Próximas Etapas:** Aula 12 implementará o CRUD completo: criar, editar e remover tarefas com o padrão PRG.
**Instruções Específicas:**
- Explique o papel do Controller com a analogia do maestro de uma orquestra: ele não toca nenhum instrumento, mas coordena quem toca o quê e quando.
- Explique `request.setAttribute` e `RequestDispatcher.forward` com a analogia de passar um bilhete para o próximo funcionário na fila de trabalho.
- Mostre a diferença entre `forward` (o servidor passa para o JSP internamente) e `redirect` (o servidor manda o navegador ir para outra URL).
- Implemente o `TaskServlet` com um padrão simples de roteamento usando o parâmetro `action` da URL.
- Explique como o `list.jsp` agora recebe a lista via `${tasks}` com JSTL `c:forEach`.
- O diagrama Mermaid deve ilustrar o fluxo completo: requisição GET /tasks → TaskServlet → TaskRepository.findAll() → request.setAttribute → forward → list.jsp → resposta HTML.
- A seção de antecipação de erros deve cobrir `NullPointerException` quando o atributo não é encontrado no request pelo JSP, o `forward` para um caminho JSP errado e a diferença entre `forward` e `redirect`.
- O exercício deve ser a adição de um segundo caminho ao `TaskServlet`: quando `action=detalhe` e um `id` são passados como parâmetros, o Controller busca a tarefa pelo ID e encaminha para o `detail.jsp`."

---

### Aula 12: Completando o CRUD: criar, editar e remover tarefas

**Prompt:**
"Gere a **Aula 12: Completando o CRUD: criar, editar e remover tarefas**.
**Objetivo:** Implementar o fluxo completo de criação (formulário → POST → Controller → Repository → redirect → listagem), edição (GET para buscar, POST para salvar) e remoção de tarefas no TaskFlow, aplicando o padrão PRG (Post-Redirect-Get) e escrevendo testes TDD para cada operação.
**Pré-requisitos:** Aula 11 concluída. `TaskServlet` conectado ao Model e View, listando tarefas.
**Projeto Prático:** Implementação completa do CRUD no `TaskServlet`: ações `criar`, `salvar`, `editar`, `atualizar` e `remover`, com formulários HTML correspondentes nos JSPs e testes TDD para a lógica de validação básica.
**Log de Estado do Projeto:**
- **Objetivo:** Concluir o CRUD completo do TaskFlow com persistência em memória.
- **Código Adicionado:** Métodos `doPost` no `TaskServlet` para criar, atualizar e remover tarefas. Formulário de edição `edit.jsp` pré-preenchido com dados da tarefa. Testes TDD para validação de campos obrigatórios na criação.
- **Estado Funcional:** ✅ O TaskFlow possui um CRUD completo funcional com armazenamento em memória. Todas as operações funcionam via navegador.
- **Próximas Etapas:** Aula 13 adicionará Filtros e Listeners para interceptar requisições e inicializar a aplicação.
**Instruções Específicas:**
- Explique o padrão PRG com a analogia de um formulário de papel: depois de entregar o formulário (POST), o atendente te pede para sentar e aguardar (redirect), evitando que você entregue o mesmo formulário duas vezes ao atualizar a página.
- Implemente o fluxo de criação completo: formulário GET → POST com `request.getParameter` → `TaskRepository.save()` → `response.sendRedirect("/tasks")`.
- Implemente o fluxo de edição: GET com `id` → busca no repositório → `setAttribute` → forward para `edit.jsp` → POST com dados atualizados → `TaskRepository.update()` → redirect.
- Implemente a remoção: GET com `id` e `action=remover` → `TaskRepository.delete()` → redirect.
- Escreva testes TDD para uma classe `TaskValidator` que valida se o título não está vazio.
- O diagrama Mermaid deve ilustrar o fluxo PRG completo para a operação de criação de tarefa.
- A seção de antecipação de erros deve cobrir o erro de formulário duplicado ao pressionar F5 após um POST (resolvido pelo PRG), a remoção acidental por link GET sem confirmação e o `id` chegando como `String` via parâmetro e precisando ser convertido para `Long`.
- O exercício deve ser a implementação de uma página de confirmação antes de remover uma tarefa: ao clicar em remover, o usuário é redirecionado para uma página de confirmação que exibe o título da tarefa e pede confirmação antes de efetivar a exclusão."

---

## Módulo 3 — Proficiente: Persistência, Validação e Finalização

### Aula 13: Filtros e Listeners: interceptando o ciclo da aplicação

**Prompt:**
"Gere a **Aula 13: Filtros e Listeners: interceptando o ciclo da aplicação**.
**Objetivo:** Entender o que são Filters no Jakarta EE, criar um filtro de log de requisições, entender o que são Listeners e quando usá-los, e criar um Listener de inicialização que popula o `TaskRepository` com dados iniciais.
**Pré-requisitos:** Aula 12 concluída. CRUD completo do TaskFlow funcionando em memória.
**Projeto Prático:** Criação de `LogFilter.java` no pacote `filter` com `@WebFilter("/*")` que registra no console a URL e o método HTTP de cada requisição, e criação de `AppStartupListener.java` com `@WebListener` que popula o repositório com três tarefas de exemplo ao iniciar a aplicação.
**Log de Estado do Projeto:**
- **Objetivo:** Adicionar comportamentos transversais ao TaskFlow via Filters e Listeners.
- **Código Adicionado:** `LogFilter.java` no pacote `filter` e `AppStartupListener.java` no pacote `filter` (ou `listener`). O repositório agora começa com dados de exemplo.
- **Estado Funcional:** ✅ Todas as requisições são logadas no console do GlassFish. A aplicação inicia com três tarefas de exemplo já cadastradas.
- **Próximas Etapas:** Aula 14 introduzirá o JPA para substituir o repositório em memória por um banco de dados real.
**Instruções Específicas:**
- Explique Filters com a analogia de um porteiro de condomínio: ele intercepta todas as pessoas que entram e saem, registra sua passagem e pode barrar ou liberar antes de chegarem ao destino.
- Explique o ciclo de um Filter: `init`, `doFilter` (onde a chain é chamada), `destroy`.
- Mostre a criação do `LogFilter` comentando cada linha: a anotação `@WebFilter`, a implementação de `Filter`, a chamada a `chain.doFilter` e o registro com `System.out.println`.
- Explique Listeners com a analogia de alarmes: eles ficam esperando um evento específico acontecer (aplicação iniciada, sessão criada) e disparam uma ação.
- Mostre o `AppStartupListener` implementando `ServletContextListener` e o método `contextInitialized` para popular o repositório.
- O diagrama Mermaid deve ilustrar a cadeia de filtros interceptando uma requisição antes e depois do Servlet.
- A seção de antecipação de erros deve cobrir o esquecimento de chamar `chain.doFilter` (bloqueando todas as requisições) e a tentação de colocar lógica de negócio complexa dentro de um Filter.
- O exercício deve ser a criação de um segundo Filter mapeado em `/tasks` que mede o tempo de processamento de cada requisição e registra no console quantos milissegundos a operação levou."

---

### Aula 14: Introdução ao Jakarta Persistence API: JPA e ORM

**Prompt:**
"Gere a **Aula 14: Introdução ao Jakarta Persistence API: JPA e ORM**.
**Objetivo:** Entender o conceito de ORM (Object-Relational Mapping), o papel do `EntityManager` e `EntityManagerFactory`, configurar o arquivo `persistence.xml` e mapear a entidade `Task` com anotações JPA conectando a um banco de dados H2 em memória.
**Pré-requisitos:** Aulas 1 a 13 concluídas. CRUD em memória funcionando. Esta aula é teórica e de configuração — nenhuma funcionalidade do TaskFlow muda ainda.
**Projeto Prático:** Adição das dependências JPA (EclipseLink como implementação) e H2 ao `build.gradle`, criação do arquivo `src/main/resources/META-INF/persistence.xml` e mapeamento da classe `Task` com anotações `@Entity`, `@Id` e `@GeneratedValue`.
**Log de Estado do Projeto:**
- **Objetivo:** Configurar o JPA no projeto e mapear a entidade `Task` para persistência em banco de dados.
- **Código Adicionado:** Dependências JPA e H2 no `build.gradle`. Arquivo `persistence.xml` configurado. Anotações `@Entity`, `@Table`, `@Id`, `@GeneratedValue`, `@Column` adicionadas à classe `Task.java`.
- **Estado Funcional:** ✅ O projeto compila com JPA configurado. O banco H2 é criado automaticamente. A funcionalidade ainda usa o repositório em memória (será substituído na Aula 15).
- **Próximas Etapas:** Aula 15 refatorará o `TaskRepository` para usar JPA de verdade.
**Instruções Específicas:**
- Explique ORM com a analogia de um tradutor automático: em vez de você falar japonês manualmente (SQL puro), o ORM traduz sua linguagem (Java) para o japonês (SQL) automaticamente.
- Explique a diferença entre JPA (especificação) e EclipseLink (implementação), reforçando o conceito da Aula 1.
- Explique o `EntityManager` com a analogia de um intermediário entre seu código Java e o banco de dados.
- Mostre o `persistence.xml` comentando cada propriedade: `persistence-unit name`, `provider`, `class`, `property` de URL do H2, usuário e `hibernate.hbm2ddl.auto` (use `create-drop` para desenvolvimento).
- Mostre cada anotação JPA na classe `Task` comentando linha a linha: `@Entity`, `@Table(name="tasks")`, `@Id`, `@GeneratedValue(strategy=GenerationType.AUTO)`, `@Column`.
- O diagrama Mermaid deve ilustrar a relação entre a entidade Java `Task`, o `EntityManager` e a tabela `tasks` no banco H2.
- A seção de antecipação de erros deve cobrir a ausência do arquivo `persistence.xml` na pasta correta (`META-INF`), a classe `Task` não estar listada no `persistence.xml` e o `@Id` não configurado corretamente.
- O exercício deve ser a leitura do log do GlassFish ao iniciar a aplicação para encontrar a instrução SQL `CREATE TABLE tasks` gerada automaticamente pelo JPA, registrando-a em um arquivo `aula14/exercicio.txt`."

---

### Aula 15: Substituindo o repositório em memória pelo JPA

**Prompt:**
"Gere a **Aula 15: Substituindo o repositório em memória pelo JPA**.
**Objetivo:** Refatorar o `TaskRepository` para usar JPA com `EntityManager`, substituindo completamente o `ArrayList` em memória por operações reais no banco de dados H2, usando JPQL para listagem e testes de integração com JUnit 5.
**Pré-requisitos:** Aula 14 concluída. JPA configurado, entidade `Task` mapeada, banco H2 conectado.
**Projeto Prático:** Refatoração do `TaskRepository.java` para usar `EntityManager` nas operações `save` (persist), `findAll` (JPQL), `findById` (find), `update` (merge) e `delete` (remove). Criação de `TaskRepositoryJpaTest.java` com testes de integração.
**Log de Estado do Projeto:**
- **Objetivo:** Substituir o armazenamento em memória por persistência real com JPA e H2.
- **Código Adicionado:** `TaskRepository.java` refatorado para usar `EntityManager`. Testes de integração `TaskRepositoryJpaTest.java` verificando cada operação CRUD contra o banco H2.
- **Estado Funcional:** ✅ O TaskFlow agora persiste dados no banco H2. As tarefas sobrevivem entre requisições (mas reiniciam ao reiniciar o servidor, pois o H2 é em memória — comportamento esperado para esta aula).
- **Próximas Etapas:** Aula 16 adicionará Bean Validation para proteger as entradas do usuário.
**Instruções Específicas:**
- Explique o `EntityManager` com a analogia de um assistente pessoal que conhece todos os procedimentos do banco: você pede `save` e ele sabe exatamente qual SQL executar.
- Mostre como obter o `EntityManager` via `EntityManagerFactory` e `Persistence.createEntityManagerFactory`.
- Implemente cada operação comentando linha a linha: `persist` para salvar, `find` para buscar por ID, `merge` para atualizar, `remove` para deletar.
- Mostre a JPQL: `SELECT t FROM Task t` explicando que é SQL para objetos Java, não para tabelas.
- Explique o conceito de transação: `em.getTransaction().begin()` e `em.getTransaction().commit()`.
- O diagrama Mermaid deve ilustrar o fluxo completo: TaskServlet → TaskRepository → EntityManager → banco H2 → retorno de dados.
- A seção de antecipação de erros deve cobrir `EntityNotFoundException` ao buscar por ID inexistente, a entidade não sendo gerenciada (detached) ao tentar atualizar fora de uma transação e o fechamento correto do `EntityManager`.
- O exercício deve ser a escrita de um teste de integração que verifica que ao salvar uma tarefa com `save()`, ela pode ser recuperada com `findById()` retornando os mesmos dados, seguindo o ciclo TDD."

---

### Aula 16: Jakarta Bean Validation: validando entradas do usuário

**Prompt:**
"Gere a **Aula 16: Jakarta Bean Validation: validando entradas do usuário**.
**Objetivo:** Entender o que é Bean Validation, aplicar anotações `@NotBlank`, `@Size` e `@NotNull` na entidade `Task`, integrar a validação no Controller e exibir mensagens de erro claras na View JSP.
**Pré-requisitos:** Aula 15 concluída. `TaskRepository` usando JPA e H2. CRUD completo funcionando.
**Projeto Prático:** Adição das anotações Bean Validation à classe `Task`, criação de um `TaskValidator` no Controller que executa a validação antes de salvar, e atualização do `form.jsp` para exibir mensagens de erro ao lado de cada campo.
**Log de Estado do Projeto:**
- **Objetivo:** Proteger o TaskFlow de dados inválidos com Bean Validation integrado ao fluxo MVC.
- **Código Adicionado:** Anotações `@NotBlank` e `@Size` nos atributos `titulo` e `descricao` da classe `Task`. Lógica de validação no `TaskServlet` usando `Validator` do Jakarta Validation. Mensagens de erro exibidas no `form.jsp` via EL.
- **Estado Funcional:** ✅ Formulários com dados inválidos exibem mensagens de erro claras. Dados válidos são persistidos normalmente.
- **Próximas Etapas:** Aula 17 implementará tratamento de erros HTTP com páginas personalizadas.
**Instruções Específicas:**
- Explique Bean Validation com a analogia de um fiscal de aeroporto: antes de embarcar (persistir), ele confere se sua bagagem (dados) está dentro das regras.
- Explique as anotações mais comuns com exemplos: `@NotNull` (não pode ser nulo), `@NotBlank` (não pode ser vazio ou só espaços), `@Size(min, max)` (tamanho mínimo e máximo).
- Mostre como adicionar a dependência de Bean Validation ao `build.gradle`.
- Mostre a integração no Controller: como obter um `Validator`, chamar `validator.validate(task)` e iterar sobre os `ConstraintViolation` para montar mensagens de erro.
- Mostre como passar as mensagens de erro ao JSP via `request.setAttribute("erros", erros)` e exibi-las com `c:forEach`.
- O diagrama Mermaid deve ilustrar o fluxo de validação: POST → Controller → Validator → erros? → sim: volta ao form com erros | não: persiste e redireciona.
- A seção de antecipação de erros deve cobrir a validação passando mesmo com campos vazios (anotação `@NotBlank` versus `@NotEmpty`), mensagens de erro não aparecendo no JSP (atributo com nome diferente) e a validação não sendo executada (dependência mal configurada).
- O exercício deve ser a escrita de testes TDD para a lógica de validação: um teste que verifica que uma `Task` com título em branco falha na validação, e outro que verifica que uma `Task` válida passa com zero violações."

---

### Aula 17: Tratamento de erros e páginas personalizadas

**Prompt:**
"Gere a **Aula 17: Tratamento de erros e páginas personalizadas**.
**Objetivo:** Configurar páginas de erro personalizadas no `web.xml` para os códigos HTTP 404 e 500, tratar exceções no Controller de forma adequada, criar as páginas de erro em JSP e adicionar log básico com `java.util.logging`.
**Pré-requisitos:** Aula 16 concluída. Validação com Bean Validation funcionando no TaskFlow.
**Projeto Prático:** Configuração do `web.xml` com `<error-page>` para 404 e 500, criação de `error/404.jsp` e `error/500.jsp`, e adição de blocos `try-catch` no `TaskServlet` para capturar exceções e logar com `java.util.logging`.
**Log de Estado do Projeto:**
- **Objetivo:** Tornar o TaskFlow robusto contra erros com páginas personalizadas e tratamento adequado de exceções.
- **Código Adicionado:** Configuração de `<error-page>` no `web.xml`. Arquivos `views/error/404.jsp` e `views/error/500.jsp`. Blocos `try-catch` no `TaskServlet` com `Logger` do `java.util.logging`.
- **Estado Funcional:** ✅ Erros HTTP exibem páginas amigáveis. Exceções são capturadas e logadas. A aplicação não exibe stack traces para o usuário.
- **Próximas Etapas:** Aula 18 fará o build final, o deploy e a revisão completa do TaskFlow.
**Instruções Específicas:**
- Explique por que exibir stack traces para o usuário é um problema de segurança além de ser uma má experiência.
- Mostre a configuração de `<error-page>` no `web.xml` para os códigos 404 e 500, comentando cada tag.
- Crie páginas de erro amigáveis em JSP com uma mensagem clara e um link para voltar à listagem.
- Explique o `java.util.logging` com a analogia de um diário de bordo: cada evento importante é registrado com data, hora e nível de severidade.
- Mostre o uso de `Logger.getLogger(TaskServlet.class.getName())` e os níveis `INFO`, `WARNING` e `SEVERE`.
- Mostre blocos `try-catch` no Controller capturando exceções específicas e genéricas, logando e redirecionando para a página de erro 500.
- O diagrama Mermaid deve ilustrar o fluxo de tratamento de erro: exceção no Controller → catch → log → redirect para página de erro.
- A seção de antecipação de erros deve cobrir a página de erro 404 não sendo exibida (caminho errado no `web.xml`), capturar `Exception` genérica demais (ocultando erros importantes) e o log não aparecendo nos arquivos do GlassFish.
- O exercício deve ser a simulação deliberada de um erro: comentar uma linha crítica do `TaskServlet` para gerar uma exceção, verificar que a página 500 personalizada é exibida e encontrar o log do erro nos arquivos de log do GlassFish."

---

### Aula 18: Finalizando o TaskFlow: build, deploy e revisão geral

**Prompt:**
"Gere a **Aula 18: Finalizando o TaskFlow: build, deploy e revisão geral**.
**Objetivo:** Gerar o WAR final do TaskFlow com Gradle, fazer o deploy completo no GlassFish 7, revisar toda a arquitetura MVC construída ao longo do curso, verificar o checklist de qualidade da aplicação e apresentar os próximos passos de evolução.
**Pré-requisitos:** Todas as aulas anteriores concluídas. TaskFlow completo com CRUD, JPA, Bean Validation e tratamento de erros.
**Projeto Prático:** Execução do `gradle clean war`, deploy do WAR final no GlassFish 7, teste manual de todas as funcionalidades (criar, listar, editar, remover tarefas, validação, páginas de erro) e commit final do repositório com tag `v3.0-proficiente`.
**Log de Estado do Projeto:**
- **Objetivo:** Finalizar o TaskFlow e consolidar todo o conhecimento do curso.
- **Código Adicionado:** Nenhum código novo. Revisão, limpeza e documentação do código existente. Commit final com tag de versão.
- **Estado Funcional:** ✅ TaskFlow 100% funcional, deployado no GlassFish 7, com CRUD completo, persistência JPA/H2, validação com Bean Validation, tratamento de erros e testes TDD.
- **Próximas Etapas:** Sugestões de evolução: trocar H2 por PostgreSQL, adicionar autenticação com Jakarta Security, explorar Jakarta RESTful Web Services (JAX-RS) e Jakarta Faces (JSF).
**Instruções Específicas:**
- Faça uma revisão narrativa e densa de cada camada do TaskFlow: Model (Task + TaskRepository), View (JSPs com JSTL), Controller (TaskServlet), Filters e Listeners, JPA, Bean Validation e tratamento de erros.
- Mostre o fluxo completo de uma requisição do início ao fim, percorrendo todas as camadas construídas.
- Apresente um checklist de qualidade: todos os formulários validam? As páginas de erro estão configuradas? Os logs funcionam? Os testes passam?
- Mostre o comando `gradle clean war` e explique o que `clean` faz antes do `war`.
- Instrua o deploy final e a verificação de cada funcionalidade pelo navegador.
- Instrua o commit final com `git tag v3.0-proficiente`.
- O diagrama Mermaid deve ser o diagrama mais completo do curso: toda a arquitetura MVC do TaskFlow em uma visão única.
- A seção de antecipação de erros deve cobrir os problemas mais comuns no deploy final: WAR com classes desatualizadas (solução: `gradle clean`), conflito de versão de dependências e o GlassFish não recarregando o WAR automaticamente.
- O exercício final deve ser uma proposta de evolução escrita pelo aluno: escolher uma das sugestões de próximos passos, pesquisar brevemente sobre ela e escrever um parágrafo descrevendo o que precisaria ser modificado no TaskFlow para implementá-la."

---

Dúvidas? Posso prosseguir para a **Aula 1**?