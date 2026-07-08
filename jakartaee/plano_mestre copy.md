# Plano Mestre — Jakarta EE 11 com Java 21, Gradle, JUnit 5 e VS Code

## Resumo Executivo

Este plano cobre a jornada completa de aprendizado de **Jakarta EE 11** partindo do absoluto zero, com foco em clareza conceitual, progressão lógica e construção incremental de um projeto prático real. O curso foi desenhado para um profissional experiente em engenharia, mas iniciante em Jakarta EE, utilizando **Java 21**, **Gradle** como ferramenta de build, **JUnit 5** com metodologia **TDD**, arquitetura **MVC** e **VS Code** no **Windows 11**.

---

## Projeto Prático Incremental

**Nome:** TaskFlow — Sistema de Gerenciamento de Tarefas

**Descrição:** O TaskFlow é uma aplicação web construída com Jakarta EE 11 que permite criar, listar, editar e remover tarefas. Cada aula adiciona uma camada funcional ao projeto, partindo da configuração do ambiente até uma aplicação MVC completa com persistência de dados, validação e testes automatizados escritos no modelo TDD.

**Por que este projeto?** Ele é simples o suficiente para um iniciante compreender sem sobrecarga cognitiva, mas completo o suficiente para cobrir todos os pilares fundamentais do Jakarta EE: Servlets, JSP, CDI, JPA e Bean Validation.

---

## Estrutura de Módulos

### Módulo 1 — Essencial (Fundamentos)

Cobre os alicerces conceituais e práticos sem os quais nenhum desenvolvimento Jakarta EE faz sentido. O aluno sairá deste módulo capaz de configurar um ambiente funcional, entender o que é um servidor de aplicações e escrever seu primeiro Servlet.

### Módulo 2 — Proficiente (Prática MVC com Jakarta EE)

Cobre a construção efetiva da aplicação MVC, introduzindo Servlets como Controllers, JSP como Views e classes Java como Models. O aluno sairá deste módulo com um CRUD funcional na memória, com testes TDD e formulários HTML integrados.

### Módulo 3 — Mestre (Persistência, Validação e Finalização)

Cobre Jakarta Persistence API (JPA) para substituir o armazenamento em memória por um banco de dados real, Bean Validation para validar entradas do usuário e a finalização do projeto com deploy e boas práticas.

---

## Lista Completa de Aulas

### Módulo 1 — Essencial (Fundamentos)

**Aula 01 — O que é Jakarta EE e como o ecossistema funciona**
Conceito de especificação vs implementação, história do Java EE ao Jakarta EE, o papel do servidor de aplicações, visão geral das APIs que compõem o Jakarta EE 11 e introdução ao projeto TaskFlow.

**Aula 02 — Configurando o ambiente de desenvolvimento no Windows 11**
Instalação e verificação do Java 21, instalação e configuração do Gradle, configuração do VS Code com extensões essenciais para Java e Jakarta EE, estrutura de pastas do projeto e criação do repositório GitHub.

**Aula 03 — Entendendo o servidor de aplicações: GlassFish 7**
O que é um servidor de aplicações, por que precisamos dele, instalação e configuração do GlassFish 7 no Windows 11, deploy manual de uma aplicação vazia e entendimento dos logs de inicialização.

**Aula 04 — Seu primeiro projeto Jakarta EE com Gradle**
Criação do projeto Gradle do zero, configuração do `build.gradle` para Jakarta EE 11, estrutura de diretórios de uma aplicação web Java, criação do arquivo `web.xml` e empacotamento em WAR.

**Aula 05 — Introdução aos Servlets: o coração do Jakarta EE Web**
O que é um Servlet, o ciclo de vida completo (`init`, `service`, `destroy`), criação do primeiro Servlet com `@WebServlet`, como o servidor mapeia URLs para Servlets, e resposta HTTP simples ao navegador.

**Aula 06 — Requisições e Respostas HTTP com Servlets**
Entendendo `HttpServletRequest` e `HttpServletResponse`, diferença entre GET e POST, leitura de parâmetros da requisição, escrita de resposta HTML, introdução ao TDD com JUnit 5 e primeiros testes de lógica pura.

### Módulo 2 — Proficiente (Prática MVC com Jakarta EE)

**Aula 07 — Arquitetura MVC: separando responsabilidades**
O que é MVC, por que usar MVC, como o Jakarta EE implementa o padrão (Servlet = Controller, JSP = View, POJO = Model), diagrama de fluxo de uma requisição MVC e refatoração do projeto para seguir o padrão.

**Aula 08 — Jakarta Server Pages (JSP): criando as Views**
O que é JSP, como o servidor processa arquivos JSP, sintaxe básica (scriptlets, expressões, diretivas), uso de JSTL para exibir dados sem Java puro na View, e criação das páginas de listagem e formulário do TaskFlow.

**Aula 09 — O Model: criando a entidade Task e o repositório em memória**
Criação da classe `Task` como POJO, criação do `TaskRepository` com `ArrayList` em memória, métodos CRUD básicos (criar, listar, buscar por ID, atualizar, remover), e testes TDD completos para o repositório.

**Aula 10 — O Controller: conectando Model e View com Servlets**
Criação do `TaskServlet` como Controller central, roteamento de ações via parâmetro de requisição, conexão entre Controller e Repository, passagem de dados para a View via `request.setAttribute`, e testes de integração simples.

**Aula 11 — Criando e listando tarefas: fluxo completo MVC**
Implementação do fluxo completo de criação de uma tarefa (formulário → POST → Controller → Repository → redirect → listagem), entendimento do padrão PRG (Post-Redirect-Get) e testes TDD do fluxo de criação.

**Aula 12 — Editando e removendo tarefas: completando o CRUD**
Implementação da edição (GET para buscar, POST para salvar) e remoção de tarefas, formulários de edição pré-preenchidos, confirmação de exclusão e testes TDD para editar e remover.

**Aula 13 — Filtros e Listeners: interceptando requisições**
O que são Filters no Jakarta EE, criando um filtro de log de requisições, o que são Listeners e quando usá-los, criação de um listener de inicialização da aplicação e testes de comportamento.

### Módulo 3 — Mestre (Persistência, Validação e Finalização)

**Aula 14 — Introdução ao Jakarta Persistence API (JPA)**
O que é ORM e por que usar, conceito de entidade, `EntityManager` e `EntityManagerFactory`, configuração do `persistence.xml`, mapeamento da entidade `Task` com anotações JPA e conexão com banco H2 em memória.

**Aula 15 — Substituindo o repositório em memória pelo JPA**
Refatoração do `TaskRepository` para usar JPA, operações básicas com `EntityManager` (persist, find, merge, remove), JPQL para listagem de todas as tarefas e testes de integração com banco H2.

**Aula 16 — Jakarta Bean Validation: validando entradas do usuário**
O que é Bean Validation, anotações básicas (`@NotNull`, `@NotBlank`, `@Size`), integração da validação no Controller, exibição de mensagens de erro na View JSP e testes TDD para as regras de validação.

**Aula 17 — Tratamento de erros e páginas de erro personalizadas**
Configuração de páginas de erro no `web.xml`, tratamento de exceções no Controller, criação de página 404 e 500 personalizadas, boas práticas de log com `java.util.logging` e testes de cenários de erro.

**Aula 18 — Finalizando o TaskFlow: empacotamento, deploy e revisão geral**
Revisão completa da arquitetura MVC implementada, build final com Gradle gerando o WAR, deploy no GlassFish 7, checklist de qualidade do projeto, estrutura final do repositório GitHub e próximos passos de evolução.

---

## Estrutura de Progressão

~~~mermaid
graph TD
    A[Aula 01 - O que é Jakarta EE] --> B[Aula 02 - Ambiente]
    B --> C[Aula 03 - GlassFish]
    C --> D[Aula 04 - Projeto Gradle]
    D --> E[Aula 05 - Primeiro Servlet]
    E --> F[Aula 06 - HTTP com Servlets + TDD]
    F --> G[Aula 07 - Arquitetura MVC]
    G --> H[Aula 08 - JSP: Views]
    H --> I[Aula 09 - Model + Repository]
    I --> J[Aula 10 - Controller]
    J --> K[Aula 11 - Criar e Listar]
    K --> L[Aula 12 - Editar e Remover]
    L --> M[Aula 13 - Filters e Listeners]
    M --> N[Aula 14 - JPA: Introdução]
    N --> O[Aula 15 - JPA: Repository]
    O --> P[Aula 16 - Bean Validation]
    P --> Q[Aula 17 - Erros e Log]
    Q --> R[Aula 18 - Deploy e Finalização]
~~~

---

## Tempo Estimado

| Módulo | Aulas | Tempo de Leitura Estimado |
|---|---|---|
| Módulo 1 — Essencial | 6 aulas | ~3 horas |
| Módulo 2 — Proficiente | 7 aulas | ~3,5 horas |
| Módulo 3 — Mestre | 5 aulas | ~2,5 horas |
| **Total** | **18 aulas** | **~9 horas** |

Cada aula tem mínimo de 2.000 palavras e ~30 minutos de leitura atenta com execução do código.

---

## Estrutura do Repositório GitHub

~~~text
taskflow/
├── README.md
├── plano_mestre.txt
├── log_estado_projeto.md
├── prompts_individuais.md
├── .gitignore
├── build.gradle
├── settings.gradle
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/taskflow/
│   │   │       ├── model/
│   │   │       ├── repository/
│   │   │       ├── controller/
│   │   │       └── filter/
│   │   ├── resources/
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   └── web.xml
│   │       └── views/
│   └── test/
│       └── java/
│           └── com/taskflow/
├── aula_01/
│   ├── README.md
│   └── exercicios/
├── aula_02/
│   ├── README.md
│   └── exercicios/
└── ...
~~~

---

## Instruções para o Aluno

1. Salve este documento como **plano_mestre.txt** na raiz do seu projeto.
2. Sempre que iniciar uma nova sessão de estudo, anexe o **plano_mestre.txt**, o **log_estado_projeto.md** e o **prompts_individuais.md** ao chat para manter o contexto completo.
3. Confirme que está pronto para iniciar quando quiser começar a **Aula 01**.

---

Dúvidas? Posso prosseguir para a **Aula 01 — O que é Jakarta EE e como o ecossistema funciona**?