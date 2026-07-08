# PASSO 1: O MAPA DA MINA
## Planejamento Mestre — Jakarta EE 11 com Java 21, Gradle, JUnit 5 e VS Code
## Trilha: Desenvolvimento Web Jakarta EE + Domínio Completo da Plataforma

---

## Configuração do Ambiente Detectada

- **Sistema Operacional:** Windows 11
- **IDE/Editor:** VS Code
- **Versão Jakarta EE:** 11
- **Versão Java:** 21
- **Ferramenta de Build:** Gradle
- **Testes:** JUnit 5 com metodologia TDD
- **Arquitetura:** MVC (Model-View-Controller)
- **Público-alvo:** Iniciante absoluto em Jakarta EE, com experiência em engenharia
- **Foco:** Construção progressiva de uma aplicação web completa com Jakarta EE 11, partindo do zero, sem recursos avançados antecipados

---

## Filosofia e Metodologia do Curso

Este curso é estruturado sobre duas bases pedagógicas complementares: a **Metodologia ADDIE** e a **Taxonomia de Bloom**. A **Metodologia ADDIE** organiza o curso em cinco fases — **Análise** (identificar o que o aluno precisa aprender), **Design** (planejar a estrutura e os materiais), **Desenvolvimento** (criar o conteúdo detalhado e prático), **Implementação** (apresentar cada aula com confirmação do aluno) e **Avaliação** (validar a compreensão por meio de desafios e do projeto incremental). A **Taxonomia de Bloom** garante que cada aula evolua em complexidade cognitiva: partimos de **Lembrar** e **Compreender** (teoria e analogias), passamos por **Aplicar** e **Analisar** (projeto prático e exercícios) e chegamos a **Avaliar** e **Criar** (desafios e projeto final). Juntas, essas metodologias garantem que nenhum conceito seja apresentado sem que o anterior tenha sido solidamente construído.

A **Técnica de Feynman** permeia todas as aulas: cada conceito técnico novo é explicado como se o aluno nunca tivesse ouvido falar sobre ele, com analogias do cotidiano que ancoram o entendimento antes de qualquer formalização técnica. O resultado é uma narrativa densa, literária e profundamente conectada à prática. O princípio mais importante deste curso é que **nenhum conceito avançado aparece antes de seu tempo** — cada aula constrói exatamente sobre o que foi visto nas aulas anteriores, sem atalhos e sem saltos.

---

## Nome e Objetivo do Projeto Prático Incremental

**Nome do Projeto:** TaskFlow — Sistema de Gerenciamento de Tarefas

**Descrição:** Ao longo do curso, construiremos progressivamente uma aplicação web chamada **TaskFlow**. Ela simulará um sistema de gerenciamento de tarefas completo, com criação, listagem, edição e remoção de tarefas, validação de dados de entrada, persistência em banco de dados e interface web funcional. Cada aula adicionará uma camada funcional ao projeto, de modo que ao final o aluno terá uma aplicação Jakarta EE 11 real, funcional e organizada em arquitetura MVC — construída por ele mesmo, do zero, passo a passo.

**Por que este projeto?** O TaskFlow é simples o suficiente para não sobrecarregar o iniciante com regras de negócio complexas, mas completo o suficiente para cobrir todos os pilares fundamentais do Jakarta EE que este curso se propõe a ensinar: **Servlets**, **JSP**, **JSTL**, **JPA** e **Bean Validation**. O foco está sempre na ferramenta, não na complexidade do domínio.

---

## Divisão em Módulos

### Módulo 1 — FUNDAMENTOS: Teoria, Ambiente e Primeiros Passos (Aulas 1 a 6)
O aluno compreende o que é o Jakarta EE, como o ecossistema funciona, qual é o papel do servidor de aplicações e como configurar todo o ambiente de desenvolvimento. Ao final deste módulo, o aluno terá um ambiente 100% funcional e seu primeiro Servlet respondendo no navegador.

### Módulo 2 — ESSENCIAL: HTTP, MVC e a Estrutura do Projeto (Aulas 7 a 12)
O aluno aprende a lidar com requisições e respostas HTTP, entende a arquitetura MVC e estrutura o projeto TaskFlow com Servlets como Controllers, JSP como Views e POJOs como Models. Ao final, terá um CRUD completo funcionando em memória.

### Módulo 3 — PROFICIENTE: Persistência, Validação e Finalização (Aulas 13 a 18)
O aluno substitui o armazenamento em memória por um banco de dados real usando JPA, aplica Bean Validation para proteger as entradas do usuário, trata erros e finaliza a aplicação com deploy e revisão geral.

---

## Lista Completa de Aulas

### MÓDULO 1 — FUNDAMENTOS: Teoria, Ambiente e Primeiros Passos

| # | Título da Aula | Objetivo Principal |
|---|---|---|
| 1 | O que é Jakarta EE e como o ecossistema funciona | Entender o que é uma especificação, a diferença entre Java EE e Jakarta EE, o papel das APIs e do servidor de aplicações |
| 2 | Configurando o ambiente de desenvolvimento no Windows 11 | Instalar o Java 21, Gradle, VS Code com extensões e o servidor GlassFish 7 |
| 3 | Seu primeiro projeto Jakarta EE com Gradle | Criar a estrutura do projeto Gradle, configurar o `build.gradle` para Jakarta EE 11 e empacotar um WAR |
| 4 | Entendendo o servidor de aplicações: GlassFish 7 | Fazer o deploy do primeiro WAR no GlassFish 7 e entender o ciclo de vida de uma aplicação web |
| 5 | Introdução aos Servlets: o coração do Jakarta EE Web | Criar o primeiro Servlet com `@WebServlet`, entender o ciclo de vida e responder uma requisição HTTP simples |
| 6 | Requisições e Respostas HTTP com Servlets | Entender `HttpServletRequest` e `HttpServletResponse`, diferença entre GET e POST, leitura de parâmetros e introdução ao TDD com JUnit 5 |

### MÓDULO 2 — ESSENCIAL: HTTP, MVC e a Estrutura do Projeto

| # | Título da Aula | Objetivo Principal |
|---|---|---|
| 7 | Arquitetura MVC: separando responsabilidades | Entender o padrão MVC, o fluxo de uma requisição e refatorar o projeto para seguir a arquitetura corretamente |
| 8 | Jakarta Server Pages: criando as Views com JSP | Entender o que é JSP, sua sintaxe básica e criar as páginas de listagem e formulário do TaskFlow |
| 9 | JSTL: exibindo dados na View sem Java puro | Usar a Jakarta Standard Tag Library para iterar, condicionar e formatar dados nas páginas JSP |
| 10 | O Model: a entidade Task e o repositório em memória | Criar a classe `Task` como POJO e o `TaskRepository` com `ArrayList`, com CRUD completo e testes TDD |
| 11 | O Controller: conectando Model e View | Criar o `TaskServlet` como Controller central, rotear ações e passar dados para a View com `request.setAttribute` |
| 12 | Completando o CRUD: criar, listar, editar e remover | Implementar o fluxo completo de criação, edição e remoção, com o padrão PRG e testes TDD para cada operação |

### MÓDULO 3 — PROFICIENTE: Persistência, Validação e Finalização

| # | Título da Aula | Objetivo Principal |
|---|---|---|
| 13 | Filtros e Listeners: interceptando o ciclo da aplicação | Criar um filtro de log de requisições e um listener de inicialização da aplicação |
| 14 | Introdução ao Jakarta Persistence API: JPA e ORM | Entender o conceito de ORM, `EntityManager`, `persistence.xml` e mapear a entidade `Task` com anotações JPA |
| 15 | Substituindo o repositório em memória pelo JPA | Refatorar o `TaskRepository` para usar JPA com banco H2 e testar as operações com JUnit 5 |
| 16 | Jakarta Bean Validation: validando entradas do usuário | Aplicar `@NotBlank`, `@Size` e outras anotações, integrar a validação no Controller e exibir erros na View |
| 17 | Tratamento de erros e páginas personalizadas | Configurar páginas de erro no `web.xml`, tratar exceções no Controller e criar páginas 404 e 500 personalizadas |
| 18 | Finalizando o TaskFlow: build, deploy e revisão geral | Gerar o WAR final com Gradle, fazer o deploy no GlassFish 7 e revisar toda a arquitetura MVC construída |

---

## Estrutura de Progressão

~~~mermaid
graph TD
    M1[MÓDULO 1: Fundamentos e Ambiente]
    M2[MÓDULO 2: HTTP, MVC e CRUD em Memória]
    M3[MÓDULO 3: Persistência, Validação e Finalização]

    M1 --> M2
    M2 --> M3

    M1 --> A1[Aula 1: O que é Jakarta EE]
    M1 --> A2[Aula 2: Configuração do Ambiente]
    M1 --> A3[Aula 3: Projeto Gradle]
    M1 --> A4[Aula 4: GlassFish e Deploy]
    M1 --> A5[Aula 5: Primeiro Servlet]
    M1 --> A6[Aula 6: HTTP e TDD com JUnit 5]

    M2 --> A7[Aula 7: Arquitetura MVC]
    M2 --> A8[Aula 8: Views com JSP]
    M2 --> A9[Aula 9: JSTL na View]
    M2 --> A10[Aula 10: Model e Repository]
    M2 --> A11[Aula 11: Controller]
    M2 --> A12[Aula 12: CRUD Completo]

    M3 --> A13[Aula 13: Filters e Listeners]
    M3 --> A14[Aula 14: JPA e ORM]
    M3 --> A15[Aula 15: Repository com JPA]
    M3 --> A16[Aula 16: Bean Validation]
    M3 --> A17[Aula 17: Tratamento de Erros]
    M3 --> A18[Aula 18: Build, Deploy e Revisão]
~~~

---

## Estrutura de Pastas do Projeto

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
│   │   │   └── com/
│   │   │       └── taskflow/
│   │   │           ├── model/
│   │   │           ├── repository/
│   │   │           ├── controller/
│   │   │           └── filter/
│   │   ├── resources/
│   │   │   └── META-INF/
│   │   │       └── persistence.xml
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   └── web.xml
│   │       └── views/
│   │           ├── task/
│   │           │   ├── list.jsp
│   │           │   ├── form.jsp
│   │           │   └── edit.jsp
│   │           └── error/
│   │               ├── 404.jsp
│   │               └── 500.jsp
│   └── test/
│       └── java/
│           └── com/
│               └── taskflow/
│                   ├── model/
│                   └── repository/
├── modulo_01_fundamentos/
│   ├── aula_01/
│   │   ├── README.md
│   │   └── exercicios/
│   ├── aula_02/
│   ├── aula_03/
│   ├── aula_04/
│   ├── aula_05/
│   └── aula_06/
├── modulo_02_essencial/
│   ├── aula_07/
│   │   ├── README.md
│   │   ├── codigo/
│   │   └── exercicios/
│   ├── aula_08/
│   ├── aula_09/
│   ├── aula_10/
│   ├── aula_11/
│   └── aula_12/
└── modulo_03_proficiente/
    ├── aula_13/
    ├── aula_14/
    ├── aula_15/
    ├── aula_16/
    ├── aula_17/
    └── aula_18/
        └── projeto_final/
            └── taskflow_completo.war
~~~

---

## Conteúdo do arquivo README.md

~~~text
# TaskFlow — Sistema de Gerenciamento de Tarefas

## Descrição
Projeto prático incremental desenvolvido ao longo do curso
"Jakarta EE 11 com Java 21, Gradle, JUnit 5 e VS Code".
O objetivo é construir, do zero, uma aplicação web completa
em arquitetura MVC usando os pilares fundamentais do Jakarta EE 11.

## Tecnologias
- Jakarta EE 11
- Java 21
- Gradle (build tool)
- GlassFish 7 (servidor de aplicações)
- JUnit 5 (testes com metodologia TDD)
- H2 Database (banco de dados em memória para JPA)
- VS Code (editor de código)
- Windows 11

## Estrutura
Cada módulo possui uma pasta com as aulas correspondentes.
Os arquivos Java contêm o código desenvolvido e comentado linha a linha.
A pasta exercicios/ contém os desafios de cada aula.
O arquivo log_estado_projeto.md registra o progresso do projeto.

## Como Executar
1. Certifique-se de ter o Java 21 e o Gradle instalados.
2. Na raiz do projeto, execute: gradle war
3. Copie o arquivo .war gerado em build/libs/ para a pasta
   deployments do GlassFish 7.
4. Acesse: http://localhost:8080/taskflow

## Módulos
- Módulo 1: Fundamentos e Ambiente (Aulas 1-6)
- Módulo 2: HTTP, MVC e CRUD em Memória (Aulas 7-12)
- Módulo 3: Persistência, Validação e Finalização (Aulas 13-18)
~~~

---

## Conteúdo do arquivo .gitignore

~~~text
# Gradle
.gradle/
build/
out/

# VS Code
.vscode/
*.code-workspace

# Java
*.class
*.jar
*.war
*.ear

# GlassFish
glassfish*/
domains/

# Windows
Thumbs.db
desktop.ini

# Logs
*.log
~~~

---

## Boas Práticas de Versionamento

Ao longo do curso, cada aula deve ser registrada no repositório com um **commit semântico**, seguindo o padrão **Conventional Commits**. Os padrões recomendados são: **feat:** para adição de nova estrutura ou funcionalidade, **fix:** para correção de um código com erro, **docs:** para atualização de README ou log, **test:** para adição ou correção de testes, e **chore:** para tarefas de configuração e organização. Exemplos práticos: `feat: cria estrutura base do projeto Gradle com Jakarta EE 11` na Aula 3, `feat: adiciona primeiro Servlet com @WebServlet` na Aula 5, `test: adiciona testes TDD para TaskRepository` na Aula 10. Ao final de cada módulo, recomenda-se criar uma **tag** de versão para marcar o marco atingido: `v1.0-fundamentos`, `v2.0-essencial` e `v3.0-proficiente`.

---

## Log de Estado Inicial do Projeto

~~~text
## Estado Inicial — Antes da Aula 1
- Projeto: TaskFlow
- Status: Aguardando início
- Servidor: Não configurado
- Estrutura Gradle: Não criada
- Servlets: Nenhum
- Views JSP: Nenhuma
- Model e Repository: Nenhum
- Banco de Dados: Não configurado
- Testes: Nenhum
- Módulo Atual: Módulo 1 — Fundamentos e Ambiente
- Próximas Etapas: Aula 1 apresentará o Jakarta EE e o ecossistema
~~~

---

## Apêndice — Referências e Recursos

### Documentação Oficial

- **Jakarta EE 11 Specifications:** https://jakarta.ee/specifications/
- **GlassFish 7 Documentation:** https://glassfish.org/documentation
- **Jakarta Servlet 6.1:** https://jakarta.ee/specifications/servlet/6.1/
- **Jakarta Persistence 3.2:** https://jakarta.ee/specifications/persistence/3.2/
- **Jakarta Bean Validation 3.1:** https://jakarta.ee/specifications/bean-validation/3.1/
- **JUnit 5 User Guide:** https://junit.org/junit5/docs/current/user-guide/
- **Gradle User Manual:** https://docs.gradle.org/current/userguide/userguide.html

### Livros Recomendados

- **"Beginning Jakarta EE Web Development"** — Dimas Maryanto (Apress): introdução prática à plataforma
- **"Jakarta EE Cookbook"** — Elder Moraes (Packt): receitas práticas para aplicações empresariais
- **"Effective Java"** — Joshua Bloch (Addison-Wesley): boas práticas indispensáveis em Java

### Comunidades e Fóruns

- **Stack Overflow — tag jakarta-ee:** https://stackoverflow.com/questions/tagged/jakarta-ee
- **Reddit r/java:** https://www.reddit.com/r/java/
- **Jakarta EE Community:** https://jakarta.ee/connect/

### Ferramentas Recomendadas

- **VS Code:** editor principal do curso
- **Extension Pack for Java (Microsoft):** conjunto essencial de extensões Java para VS Code
- **GlassFish 7:** servidor de aplicações de referência para Jakarta EE 11
- **Git para Windows:** https://git-scm.com/download/win
- **H2 Database:** https://www.h2database.com/

---

## Tempo Estimado do Curso

| Módulo | Aulas | Tempo de Leitura Estimado |
|---|---|---|
| Módulo 1 — Fundamentos e Ambiente | 6 aulas | ~3 horas |
| Módulo 2 — HTTP, MVC e CRUD | 6 aulas | ~3 horas |
| Módulo 3 — Persistência, Validação e Finalização | 6 aulas | ~3 horas |
| **Total** | **18 aulas** | **~9 horas** |

Cada aula tem mínimo de 2.000 palavras e aproximadamente 30 minutos de leitura atenta com execução do código. O ritmo sugerido é de 3 aulas por semana, com prática entre as aulas, totalizando aproximadamente 6 semanas de curso.

---

## Instrução para o Aluno

Salve este planejamento como **plano_mestre.txt** na pasta raiz do seu projeto **TaskFlow**. Ele será sua bússola durante todo o curso — sempre que tiver dúvidas sobre onde estamos ou para onde vamos, consulte este arquivo. Ao iniciar cada nova sessão de estudo, anexe o **plano_mestre.txt**, o **log_estado_projeto.md** e o **prompts_individuais.md** para garantir que o contexto do curso seja preservado com precisão.

---

## ✅ Planejamento Concluído

O **Mapa da Mina** está pronto. Temos **18 aulas** organizadas em **3 módulos**, cobrindo desde a teoria do Jakarta EE e a configuração do ambiente até a persistência com JPA, validação com Bean Validation e o deploy final da aplicação. O projeto prático incremental **TaskFlow** evolui em todos os módulos, com estrutura de pastas organizada por módulo e aula, boas práticas de versionamento com **Conventional Commits**, apêndice completo de referências e log de estado inicial registrado. Confirme quando estiver pronto e iniciaremos a **Aula 1: O que é Jakarta EE e como o ecossistema funciona**.

---

Dúvidas? Posso prosseguir para a Aula 1?