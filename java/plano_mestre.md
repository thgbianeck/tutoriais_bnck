# PASSO 1: O MAPA DA MINA (PLANEJAMENTO)

## Título do Livro: Dominando Java: Do Zero à Certificação e Grandes Aplicações

## Nome e Objetivo do Projeto Prático Incremental

Nosso projeto prático incremental será o desenvolvimento de um **Sistema de Gerenciamento de Biblioteca Digital**. Este sistema nos permitirá aplicar os conceitos de Java de forma prática, construindo uma aplicação que gerencia livros, usuários e empréstimos. O objetivo é criar uma aplicação robusta e escalável, que servirá como base para entender como grandes aplicações são construídas em Java, ao mesmo tempo em que abordamos os tópicos essenciais para a certificação. Este projeto será desenvolvido de forma **incremental** ao longo de todos os capítulos, garantindo a aplicação prática de cada novo conceito.

## Divisão em Partes (Módulos)

O curso será dividido em três partes principais, cada uma com um foco específico, garantindo uma progressão lógica do conhecimento, como os volumes de um livro:

### Parte I: Essencial (Fundamentos do Java)
Esta parte cobrirá os pilares da linguagem Java, desde a instalação e configuração do ambiente até os conceitos de programação orientada a objetos. É a base sólida para qualquer desenvolvedor Java.

### Parte II: Proficiente (Java Avançado e Aplicações)
Aqui, aprofundaremos em tópicos mais avançados de Java, como coleções, manipulação de arquivos, tratamento de exceções e introdução a APIs essenciais. Começaremos a construir as funcionalidades do nosso sistema de biblioteca.

### Parte III: Mestre (Grandes Aplicações, Certificação e Boas Práticas)
Nesta parte final, exploraremos tópicos cruciais para grandes aplicações, como concorrência, JDBC para conexão com bancos de dados (incluindo SQL Server), testes unitários, e padrões de projeto. Também abordaremos estratégias e tópicos específicos para a certificação Java.

## Sumário (Lista de Capítulos)

A seguir, o sumário detalhado dos capítulos previstos, com uma estimativa de duração e conteúdo. Cada capítulo terá aproximadamente 30 minutos de leitura e um **mínimo de 2.000 palavras**, garantindo profundidade e clareza, utilizando a **Técnica de Feynman** e **analogias do cotidiano** para facilitar a compreensão.

### Parte I: Essencial (Fundamentos do Java)

*   **Capítulo 1: Introdução ao Java e Configuração do Ambiente**
    *   O que é Java, sua história e por que é tão popular.
    *   JVM, JRE e JDK: Entendendo o ecossistema Java.
    *   Instalação do JDK (Java Development Kit) no **Windows 11**.
    *   Configuração do **IntelliJ IDEA** para desenvolvimento Java.
    *   Primeiro programa Java: "Olá, Mundo!".
    *   **Projeto Prático:** Configuração inicial do projeto no IntelliJ IDEA e criação da estrutura básica de pastas.
*   **Capítulo 2: Sintaxe Básica, Variáveis e Tipos de Dados**
    *   Estrutura de um programa Java.
    *   Comentários, identificadores e palavras-chave.
    *   Tipos de dados primitivos (int, double, boolean, char, etc.).
    *   Declaração e inicialização de variáveis.
    *   Operadores aritméticos, relacionais e lógicos.
    *   **Projeto Prático:** Criação de variáveis para armazenar informações básicas de um livro (título, autor, ano).
*   **Capítulo 3: Estruturas de Controle de Fluxo (Condicionais)**
    *   Instruções **if**, **else if** e **else**.
    *   Operador ternário.
    *   Instrução **switch**.
    *   **Projeto Prático:** Implementação de lógica para verificar a disponibilidade de um livro com base em um status.
*   **Capítulo 4: Estruturas de Controle de Fluxo (Laços de Repetição)**
    *   Laços **for**, **while** e **do-while**.
    *   Instruções **break** e **continue**.
    *   **Projeto Prático:** Iteração sobre uma lista de livros para exibir seus detalhes.
*   **Capítulo 5: Introdução à Programação Orientada a Objetos (POO)**
    *   Conceitos fundamentais de POO: Classes, Objetos, Atributos e Métodos.
    *   Criação de classes e instâncias de objetos.
    *   Construtores.
    *   **Projeto Prático:** Criação da classe **Livro** com atributos e métodos básicos (getters e setters).
*   **Capítulo 6: Pilares da POO: Encapsulamento e Herança**
    *   **Encapsulamento**: Modificadores de acesso (**public**, **private**, **protected**).
    *   **Herança**: Reutilização de código com **extends**.
    *   Classes e métodos **final**.
    *   **Projeto Prático:** Criação de uma classe **Usuario** e uma classe **LivroDigital** que herda de **Livro**.
*   **Capítulo 7: Pilares da POO: Polimorfismo e Abstração**
    *   **Polimorfismo**: Sobrescrita de métodos (**@Override**).
    *   Classes e métodos abstratos.
    *   Interfaces.
    *   **Projeto Prático:** Criação de uma interface **ItemBiblioteca** e implementação por **Livro** e **Usuario**.

### Parte II: Proficiente (Java Avançado e Aplicações)

*   **Capítulo 8: Arrays e Coleções (Listas)**
    *   Arrays unidimensionais e multidimensionais.
    *   Introdução às Collections Framework.
    *   Interface **List** e sua implementação **ArrayList**.
    *   **Projeto Prático:** Gerenciamento de uma lista de livros na biblioteca usando **ArrayList**.
*   **Capítulo 9: Coleções (Sets e Maps)**
    *   Interface **Set** e sua implementação **HashSet**.
    *   Interface **Map** e sua implementação **HashMap**.
    *   **Projeto Prático:** Armazenamento de usuários por ID usando **HashMap** e garantia de livros únicos com **HashSet**.
*   **Capítulo 10: Manipulação de Strings e Datas**
    *   Classe **String**: Métodos comuns (concatenação, substring, replace, etc.).
    *   Classes **LocalDate**, **LocalTime** e **LocalDateTime** (API de Data e Hora).
    *   Formatação de datas.
    *   **Projeto Prático:** Adição de data de publicação aos livros e registro de data de empréstimo.
*   **Capítulo 11: Tratamento de Exceções**
    *   O que são exceções e por que são importantes.
    *   Blocos **try-catch-finally**.
    *   Exceções verificadas e não verificadas.
    *   Criação de exceções personalizadas.
    *   **Projeto Prático:** Tratamento de exceções para casos como "livro não encontrado" ou "usuário inválido".
*   **Capítulo 12: Entrada e Saída (I/O) de Dados**
    *   Leitura de entrada do usuário com **Scanner**.
    *   Introdução à manipulação de arquivos (leitura e escrita).
    *   Classes **File**, **FileReader**, **FileWriter**, **BufferedReader**, **BufferedWriter**.
    *   **Projeto Prático:** Salvar e carregar dados de livros e usuários em arquivos de texto simples.
*   **Capítulo 13: Introdução a Generics**
    *   O que são Generics e por que usá-los.
    *   Classes e métodos genéricos.
    *   Wildcards.
    *   **Projeto Prático:** Criação de uma classe genérica para gerenciar coleções de itens da biblioteca.
*   **Capítulo 14: Expressões Lambda e Stream API**
    *   Introdução às Expressões Lambda (Java 8+).
    *   Interface funcional.
    *   Introdução à Stream API para processamento de coleções.
    *   Operações intermediárias e terminais.
    *   **Projeto Prático:** Filtrar e ordenar livros na biblioteca usando Stream API.

### Parte III: Mestre (Grandes Aplicações, Certificação e Boas Práticas)

*   **Capítulo 15: Concorrência e Threads (Parte 1)**
    *   Conceitos de concorrência e paralelismo.
    *   Introdução a Threads.
    *   Criação e execução de Threads.
    *   **Projeto Prático:** Simulação de múltiplos usuários acessando a biblioteca simultaneamente.
*   **Capítulo 16: Concorrência e Threads (Parte 2) e Sincronização**
    *   Problemas de concorrência: Condições de corrida.
    *   Sincronização de Threads: Palavra-chave **synchronized**.
    *   Locks e semáforos (introdução).
    *   **Projeto Prático:** Garantir a integridade dos dados da biblioteca em um ambiente multi-threaded.
*   **Capítulo 17: Introdução a JDBC e Conexão com SQL Server**
    *   O que é JDBC (Java Database Connectivity).
    *   Configuração do driver JDBC para SQL Server.
    *   Estabelecendo conexão com o banco de dados.
    *   **Projeto Prático:** Conexão do nosso sistema de biblioteca a um banco de dados SQL Server.
*   **Capítulo 18: Operações CRUD com JDBC e SQL Server**
    *   Execução de comandos SQL (INSERT, SELECT, UPDATE, DELETE) via JDBC.
    *   PreparedStatement para evitar SQL Injection.
    *   Tratamento de resultados de consultas.
    *   **Projeto Prático:** Implementação das operações CRUD para livros e usuários no SQL Server.
*   **Capítulo 19: Testes Unitários com JUnit**
    *   Importância dos testes unitários.
    *   Introdução ao JUnit 5.
    *   Criação de testes para classes do projeto.
    *   **Projeto Prático:** Escrever testes unitários para as funcionalidades de gerenciamento de livros.
*   **Capítulo 20: Padrões de Projeto Essenciais (Singleton, Factory)**
    *   O que são padrões de projeto e sua importância.
    *   Padrão Singleton para garantir uma única instância.
    *   Padrão Factory para criação de objetos.
    *   **Projeto Prático:** Aplicação do padrão Singleton para a conexão com o banco de dados e Factory para criação de objetos de livro.
*   **Capítulo 21: Tópicos Avançados para Certificação e Boas Práticas**
    *   Revisão de tópicos chave para certificação Java.
    *   Boas práticas de código: Clean Code, SOLID (introdução).
    *   Ferramentas de build (Maven/Gradle - introdução).
    *   **Projeto Prático:** Refatoração de partes do código para aplicar boas práticas e preparar para a certificação.

## Estrutura de Progressão

Cada capítulo construirá sobre o conhecimento adquirido no capítulo anterior. O projeto prático incremental será o fio condutor, onde cada novo conceito será imediatamente aplicado para adicionar funcionalidades ao nosso Sistema de Gerenciamento de Biblioteca Digital. Começaremos com a estrutura básica e, capítulo a capítulo, adicionaremos complexidade e recursos, culminando em uma aplicação funcional e bem estruturada. A progressão é desenhada para que o aluno, mesmo iniciante, se sinta confortável e confiante em cada etapa.

## Tempo Estimado

O tempo estimado para a conclusão deste curso, considerando a leitura de cada capítulo (30 minutos), a prática dos exercícios e a implementação do projeto, é de aproximadamente **8 a 12 semanas**, dedicando algumas horas por dia. Este é um curso intensivo, mas com uma abordagem didática que facilita o aprendizado.

---

## Boas Práticas de Versionamento (Repositório GitHub)

Ao longo do curso, cada capítulo deve ser registrado no repositório com um **commit semântico**, seguindo o padrão **Conventional Commits**. Os padrões recomendados são: **feat:** para adição de nova estrutura ou funcionalidade, **fix:** para correção de um script com erro, **docs:** para atualização de README ou log, e **chore:** para tarefas de configuração e organização. Exemplos práticos: `feat: configura ambiente e cria Olá Mundo` no Capítulo 1, `feat: implementa classe Livro` no Capítulo 5, e `docs: atualiza log_estado_projeto capítulo 12` após cada capítulo concluído. Ao final de cada módulo, recomenda-se criar uma **tag** de versão para marcar o marco atingido: `v1.0-essencial`, `v2.0-proficiente`, `v3.0-mestre`.

## Log de Estado Inicial do Projeto

~~~text
## Estado Inicial — Antes do Capítulo 1
- Projeto: Sistema de Gerenciamento de Biblioteca Digital
- Status: Aguardando início
- Código Base: Nenhum
- Módulo Atual: Parte I — Essencial (Fundamentos do Java)
- Próximas Etapas: Capítulo 1 apresentará o Java e a configuração do ambiente.
~~~

## Apêndice — Referências e Recursos

### Documentação Oficial

- **Documentação Oficial Java (Oracle):** <https://docs.oracle.com/en/java/javase/index.html>
- **Documentação OpenJDK:** <https://openjdk.org/install/>
- **IntelliJ IDEA Documentation:** <https://www.jetbrains.com/help/idea/>
- **Maven Documentation:** <https://maven.apache.org/guides/index.html>
- **Gradle Documentation:** <https://docs.gradle.org/>

### Certificações Relacionadas

- **Oracle Certified Professional (OCP) Java SE:** A certificação padrão da indústria para Java.
- **Oracle Certified Associate (OCA) Java SE:** Um passo inicial para a certificação OCP.
- **Recursos de estudo para certificação:** Diversos livros e cursos online específicos para a preparação.

### Livros Recomendados

- **"Effective Java"** — Joshua Bloch: Um guia essencial para escrever código Java de alta qualidade.
- **"Clean Code: A Handbook of Agile Software Craftsmanship"** — Robert C. Martin: Para aprender boas práticas de código.
- **"Head First Java"** — Kathy Sierra & Bert Bates: Uma abordagem visual e divertida para aprender Java.
- **"Java Concurrency in Practice"** — Brian Goetz et al.: Para aprofundar em concorrência.

### Comunidades e Fóruns

- **Stack Overflow — tag java:** <https://stackoverflow.com/questions/tagged/java>
- **Reddit r/java:** <https://www.reddit.com/r/java/>
- **Oracle Community (Java):** <https://community.oracle.com/tech/developers/categories/java>

### Ferramentas Recomendadas

- **IntelliJ IDEA (Ultimate Edition ou Community Edition):** A IDE principal do curso.
- **Git para Windows:** <https://git-scm.com/download/win>
- **Postman/Insomnia:** Para testar APIs (em capítulos futuros, se aplicável).
- **DB Browser for SQLite / DBeaver:** Para visualizar e gerenciar bancos de dados (se usarmos SQLite ou outros além de SQL Server).

---

## Instrução para o Aluno

Salve este planejamento como **plano_mestre.txt** na pasta raiz do seu projeto. Ele será sua bússola durante todo o curso — sempre que tiver dúvidas sobre onde estamos ou para onde vamos, consulte este arquivo. Ao iniciar cada nova sessão de estudo, anexe este arquivo para garantir que o contexto do curso seja preservado com precisão.

---

## ✅ Planejamento Concluído

O **Mapa da Mina** está pronto. Temos **21 capítulos** organizados em **3 partes**, cobrindo desde os fundamentos do Java até tópicos avançados para grandes aplicações e a preparação para certificação. O projeto prático incremental **Sistema de Gerenciamento de Biblioteca Digital** evoluirá em todos os capítulos, com boas práticas de versionamento com **Conventional Commits**, apêndice completo de referências e log de estado inicial registrado.

Dúvidas? Posso prosseguir para o **Capítulo 1: Introdução ao Java e Configuração do Ambiente**?