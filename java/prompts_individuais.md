# Prompts Individuais Detalhados para o Livro "Dominando Java: Do Zero à Certificação e Grandes Aplicações"

Este documento contém os prompts detalhados para a geração de cada capítulo do livro, seguindo a estrutura e as regras definidas no `plano_mestre.txt`. Cada prompt instrui o Tutor Sênior a gerar um capítulo completo, com teoria, analogias, diagramas, aplicação prática no projeto incremental, glossário, antecipação de erros, exercícios e resumo, garantindo um mínimo de 2.000 palavras e o formato Markdown especificado.

---

## Parte I: Essencial (Fundamentos do Java)

### Capítulo 1: Introdução ao Java e Configuração do Ambiente

**Prompt:**
"Gere o **Capítulo 1: Introdução ao Java e Configuração do Ambiente**.
**Objetivo:** Entender o que é Java, seu ecossistema, e configurar o ambiente de desenvolvimento no Windows 11 com IntelliJ IDEA, criando o primeiro programa "Olá, Mundo!".
**Pré-requisitos:** Nenhum. Este é o ponto de partida.
**Projeto Prático:** Configuração inicial do projeto no IntelliJ IDEA e criação da estrutura básica de pastas.
**Log de Estado do Projeto:**
- **Objetivo:** Configurar o ambiente de desenvolvimento Java e criar a estrutura inicial do projeto "Sistema de Gerenciamento de Biblioteca Digital".
- **Código Adicionado:** Projeto Maven/Gradle inicial no IntelliJ IDEA, com a classe `Main` contendo o "Olá, Mundo!". Estrutura de pastas `src/main/java/com/biblioteca`.
- **Estado Funcional:** ✅ Projeto compila e executa o "Olá, Mundo!".
- **Próximas Etapas:** Capítulo 2 abordará a sintaxe básica, variáveis e tipos de dados, aplicando-os na criação de informações básicas de um livro.
**Instruções Específicas:**
- Detalhe a instalação do JDK para Windows 11 (versão 21+ ou 25).
- Explique a configuração do IntelliJ IDEA, incluindo a criação de um projeto Maven/Gradle.
- O diagrama Mermaid deve ilustrar o fluxo de compilação e execução de um programa Java (código fonte -> bytecode -> JVM).
- O código prático deve ser o "Olá, Mundo!" e a estrutura inicial do projeto.
- A seção de antecipação de erros deve cobrir problemas comuns de PATH e configuração do IDE.
- O exercício deve ser a criação de um segundo programa simples e a verificação da versão do Java."

### Capítulo 2: Sintaxe Básica, Variáveis e Tipos de Dados

**Prompt:**
"Gere o **Capítulo 2: Sintaxe Básica, Variáveis e Tipos de Dados**.
**Objetivo:** Compreender a estrutura básica de um programa Java, identificadores, palavras-chave, tipos de dados primitivos e como declarar e usar variáveis e operadores.
**Pré-requisitos:** Capítulo 1 concluído e ambiente configurado.
**Projeto Prático:** Criação de variáveis para armazenar informações básicas de um livro (título, autor, ano de publicação, ISBN, disponível).
**Log de Estado do Projeto:**
- **Objetivo:** Implementar a declaração e uso de variáveis para representar as propriedades de um livro.
- **Código Adicionado:** Na classe `Main` ou em uma nova classe `LivroSimples`, declarar variáveis para título (`String`), autor (`String`), ano de publicação (`int`), ISBN (`String`) e status de disponibilidade (`boolean`).
- **Estado Funcional:** ✅ Variáveis declaradas e inicializadas, exibindo seus valores no console.
- **Próximas Etapas:** Capítulo 3 abordará estruturas condicionais para verificar a disponibilidade de um livro.
**Instruções Específicas:**
- Explique cada tipo de dado primitivo com exemplos.
- O diagrama Mermaid deve ilustrar a declaração e atribuição de valores a variáveis.
- O código prático deve declarar e inicializar variáveis de diferentes tipos para representar um livro e exibir seus valores.
- A seção de antecipação de erros deve abordar erros de tipo e convenções de nomenclatura.
- O exercício deve envolver a criação de variáveis para representar um usuário e a aplicação de operadores aritméticos."

### Capítulo 3: Estruturas de Controle de Fluxo (Condicionais)

**Prompt:**
"Gere o **Capítulo 3: Estruturas de Controle de Fluxo (Condicionais)**.
**Objetivo:** Aprender a usar instruções condicionais como **if**, **else if**, **else**, operador ternário e **switch** para controlar o fluxo de execução do programa.
**Pré-requisitos:** Capítulo 2 concluído.
**Projeto Prático:** Implementação de lógica para verificar a disponibilidade de um livro com base em um status booleano e exibir uma mensagem apropriada.
**Log de Estado do Projeto:**
- **Objetivo:** Adicionar lógica condicional para verificar e exibir o status de disponibilidade de um livro.
- **Código Adicionado:** Utilização de `if-else` e `switch` (se aplicável para um status mais complexo) para verificar a variável `disponivel` de um livro e imprimir mensagens como "Livro disponível" ou "Livro emprestado".
- **Estado Funcional:** ✅ O programa exibe corretamente o status de disponibilidade do livro.
- **Próximas Etapas:** Capítulo 4 abordará laços de repetição para processar múltiplos livros.
**Instruções Específicas:**
- Explique cada estrutura condicional com exemplos claros.
- O diagrama Mermaid deve ilustrar o fluxo de decisão de um `if-else` ou `switch`.
- O código prático deve aplicar condicionais para verificar a disponibilidade de um livro e, opcionalmente, o tipo de usuário (administrador, leitor).
- A seção de antecipação de erros deve cobrir erros de lógica e o uso incorreto de operadores de comparação.
- O exercício deve envolver a criação de uma lógica para determinar se um usuário é elegível para empréstimo com base em sua idade."

### Capítulo 4: Estruturas de Controle de Fluxo (Laços de Repetição)

**Prompt:**
"Gere o **Capítulo 4: Estruturas de Controle de Fluxo (Laços de Repetição)**.
**Objetivo:** Dominar o uso de laços **for**, **while** e **do-while** para executar blocos de código repetidamente, e as instruções **break** e **continue**.
**Pré-requisitos:** Capítulo 3 concluído.
**Projeto Prático:** Iteração sobre uma coleção simulada de livros (usando um array simples) para exibir seus detalhes.
**Log de Estado do Projeto:**
- **Objetivo:** Utilizar laços de repetição para processar e exibir informações de múltiplos livros.
- **Código Adicionado:** Criação de um array de objetos `LivroSimples` (ou similar) e uso de um laço `for` ou `for-each` para iterar sobre ele, exibindo o título e autor de cada livro.
- **Estado Funcional:** ✅ O programa exibe os detalhes de todos os livros no array.
- **Próximas Etapas:** Capítulo 5 introduzirá a Programação Orientada a Objetos com a criação de classes e objetos.
**Instruções Específicas:**
- Explique cada tipo de laço com exemplos, incluindo **break** e **continue**.
- O diagrama Mermaid deve ilustrar o fluxo de um laço `for` ou `while`.
- O código prático deve criar um array de livros e usar um laço para imprimir os detalhes de cada um.
- A seção de antecipação de erros deve cobrir laços infinitos e erros de índice de array.
- O exercício deve envolver a contagem de livros disponíveis em um array e a busca por um livro específico."

### Capítulo 5: Introdução à Programação Orientada a Objetos (POO)

**Prompt:**
"Gere o **Capítulo 5: Introdução à Programação Orientada a Objetos (POO)**.
**Objetivo:** Entender os conceitos fundamentais de POO, incluindo classes, objetos, atributos, métodos e construtores, e como aplicá-los em Java.
**Pré-requisitos:** Capítulo 4 concluído.
**Projeto Prático:** Criação da classe **Livro** com atributos (título, autor, ISBN, anoPublicacao, disponivel) e métodos (getters, setters, exibirDetalhes).
**Log de Estado do Projeto:**
- **Objetivo:** Criar a classe `Livro` e instanciar objetos `Livro`, utilizando atributos e métodos.
- **Código Adicionado:** Definição da classe `Livro` com atributos privados e métodos públicos (getters e setters), além de um construtor. Instanciação de alguns objetos `Livro` na classe `Main` e chamada do método `exibirDetalhes`.
- **Estado Funcional:** ✅ Objetos `Livro` são criados e seus detalhes são exibidos corretamente.
- **Próximas Etapas:** Capítulo 6 abordará Encapsulamento e Herança para aprimorar a classe `Livro` e criar outras classes.
**Instruções Específicas:**
- Explique detalhadamente o que são classes, objetos, atributos e métodos.
- O diagrama Mermaid deve ilustrar a relação entre uma classe e seus objetos, e a estrutura de uma classe.
- O código prático deve definir a classe `Livro` com atributos e métodos, e demonstrar a criação de objetos.
- A seção de antecipação de erros deve cobrir erros de acesso a atributos privados e a diferença entre classe e objeto.
- O exercício deve envolver a criação de uma classe `Autor` com atributos e métodos, e a associação de um `Autor` a um `Livro`."

### Capítulo 6: Pilares da POO: Encapsulamento e Herança

**Prompt:**
"Gere o **Capítulo 6: Pilares da POO: Encapsulamento e Herança**.
**Objetivo:** Aprofundar nos pilares da POO, compreendendo o encapsulamento (modificadores de acesso) e a herança (reutilização de código com **extends**), além de classes e métodos **final**.
**Pré-requisitos:** Capítulo 5 concluído.
**Projeto Prático:** Aprimoramento da classe **Livro** com encapsulamento adequado e criação de uma classe **LivroDigital** que herda de **Livro**, adicionando atributos específicos.
**Log de Estado do Projeto:**
- **Objetivo:** Aplicar encapsulamento na classe `Livro` e implementar herança com a classe `LivroDigital`.
- **Código Adicionado:** Modificadores de acesso (`private`, `public`) aplicados aos atributos e métodos de `Livro`. Criação da classe `LivroDigital` que estende `Livro`, adicionando atributos como `formato` (`String`) e `tamanhoArquivo` (`double`).
- **Estado Funcional:** ✅ Classes `Livro` e `LivroDigital` funcionam com encapsulamento e herança, permitindo a criação de objetos de ambos os tipos.
- **Próximas Etapas:** Capítulo 7 abordará Polimorfismo e Abstração para criar interfaces e classes abstratas.
**Instruções Específicas:**
- Explique os modificadores de acesso (`public`, `private`, `protected`, default) e a importância do encapsulamento.
- Detalhe o conceito de herança, a palavra-chave `extends` e a chamada ao construtor da superclasse.
- O diagrama Mermaid deve ilustrar a relação de herança entre `Livro` e `LivroDigital`.
- O código prático deve demonstrar o encapsulamento na classe `Livro` e a criação da classe `LivroDigital` com herança.
- A seção de antecipação de erros deve cobrir erros de acesso a membros privados e o uso incorreto de `super()`.
- O exercício deve envolver a criação de uma classe `UsuarioPremium` que herda de `Usuario` (se criada no exercício anterior), adicionando um atributo de data de expiração da assinatura."

### Capítulo 7: Pilares da POO: Polimorfismo e Abstração

**Prompt:**
"Gere o **Capítulo 7: Pilares da POO: Polimorfismo e Abstração**.
**Objetivo:** Compreender o polimorfismo (sobrescrita de métodos) e a abstração (classes e métodos abstratos, interfaces), e como eles contribuem para a flexibilidade e organização do código.
**Pré-requisitos:** Capítulo 6 concluído.
**Projeto Prático:** Criação de uma interface **ItemBiblioteca** com métodos comuns (ex: `exibirInformacoes()`) e implementação por **Livro** e **Usuario**.
**Log de Estado do Projeto:**
- **Objetivo:** Implementar polimorfismo e abstração através de uma interface `ItemBiblioteca` e a sobrescrita de métodos.
- **Código Adicionado:** Definição da interface `ItemBiblioteca` com o método `exibirInformacoes()`. As classes `Livro` e `Usuario` (ou `LivroDigital`) devem implementar esta interface, sobrescrevendo o método `exibirInformacoes()` para exibir informações específicas de cada tipo.
- **Estado Funcional:** ✅ Objetos de diferentes classes podem ser tratados como `ItemBiblioteca`, chamando o método `exibirInformacoes()` polimorficamente.
- **Próximas Etapas:** Capítulo 8 abordará Arrays e Coleções para gerenciar múltiplos itens da biblioteca.
**Instruções Específicas:**
- Explique o polimorfismo por sobrescrita e a palavra-chave `@Override`.
- Detalhe classes abstratas, métodos abstratos e interfaces, suas diferenças e quando usar cada um.
- O diagrama Mermaid deve ilustrar a interface `ItemBiblioteca` e suas implementações por `Livro` e `Usuario`.
- O código prático deve definir a interface `ItemBiblioteca` e fazer com que `Livro` e `Usuario` a implementem, sobrescrevendo o método `exibirInformacoes()`.
- A seção de antecipação de erros deve cobrir a impossibilidade de instanciar classes abstratas e a necessidade de implementar todos os métodos de uma interface.
- O exercício deve envolver a criação de uma classe abstrata `Publicacao` com um método abstrato `calcularPreco()` e fazer com que `Livro` a estenda."

---

## Parte II: Proficiente (Java Avançado e Aplicações)

### Capítulo 8: Arrays e Coleções (Listas)

**Prompt:**
"Gere o **Capítulo 8: Arrays e Coleções (Listas)**.
**Objetivo:** Compreender o uso de arrays para armazenar coleções de dados e introduzir o Java Collections Framework, focando na interface **List** e sua implementação **ArrayList**.
**Pré-requisitos:** Capítulo 7 concluído.
**Projeto Prático:** Gerenciamento de uma lista de livros na biblioteca usando **ArrayList**, adicionando, removendo e buscando livros.
**Log de Estado do Projeto:**
- **Objetivo:** Utilizar `ArrayList` para gerenciar uma coleção dinâmica de objetos `Livro`.
- **Código Adicionado:** Na classe `Main` (ou em uma nova classe `GerenciadorBiblioteca`), criar um `ArrayList<Livro>`, adicionar alguns livros, remover um livro e buscar um livro pelo título.
- **Estado Funcional:** ✅ A lista de livros é gerenciada dinamicamente, permitindo operações básicas de adição, remoção e busca.
- **Próximas Etapas:** Capítulo 9 abordará outras coleções como Sets e Maps.
**Instruções Específicas:**
- Explique arrays unidimensionais e multidimensionais, suas limitações.
- Introduza o Java Collections Framework, focando na interface `List` e na classe `ArrayList`, seus métodos principais.
- O diagrama Mermaid deve ilustrar as operações básicas de um `ArrayList` (add, remove, get).
- O código prático deve criar um `ArrayList` de `Livro` e demonstrar as operações de adicionar, remover e listar livros.
- A seção de antecipação de erros deve cobrir `IndexOutOfBoundsException` e a diferença entre arrays e `ArrayList`.
- O exercício deve envolver a criação de um `ArrayList` de `Usuario` e a implementação de uma função para listar todos os usuários."

### Capítulo 9: Coleções (Sets e Maps)

**Prompt:**
"Gere o **Capítulo 9: Coleções (Sets e Maps)**.
**Objetivo:** Explorar as interfaces **Set** e **Map** do Java Collections Framework, compreendendo suas características e implementações como **HashSet** e **HashMap**.
**Pré-requisitos:** Capítulo 8 concluído.
**Projeto Prático:** Armazenamento de usuários por ID usando **HashMap** e garantia de livros únicos (sem duplicatas) com **HashSet**.
**Log de Estado do Projeto:**
- **Objetivo:** Utilizar `HashMap` para armazenar usuários por ID e `HashSet` para garantir a unicidade de livros.
- **Código Adicionado:** Na classe `GerenciadorBiblioteca`, criar um `HashMap<Integer, Usuario>` para armazenar usuários e um `HashSet<Livro>` para armazenar livros, garantindo que não haja duplicatas (requer `equals()` e `hashCode()` em `Livro`).
- **Estado Funcional:** ✅ Usuários são acessíveis por ID e a coleção de livros não permite duplicatas.
- **Próximas Etapas:** Capítulo 10 abordará manipulação de Strings e Datas.
**Instruções Específicas:**
- Explique as características de `Set` (elementos únicos) e `Map` (pares chave-valor).
- Detalhe as classes `HashSet` e `HashMap`, seus métodos e a importância de `equals()` e `hashCode()` para objetos personalizados.
- O diagrama Mermaid deve ilustrar a estrutura de um `HashMap` ou `HashSet`.
- O código prático deve demonstrar o uso de `HashMap` para usuários e `HashSet` para livros, incluindo a implementação de `equals()` e `hashCode()` na classe `Livro`.
- A seção de antecipação de erros deve cobrir a importância de `equals()` e `hashCode()` para o correto funcionamento de `Set` e `Map`.
- O exercício deve envolver a criação de um `LinkedHashMap` para manter a ordem de inserção de usuários."

### Capítulo 10: Manipulação de Strings e Datas

**Prompt:**
"Gere o **Capítulo 10: Manipulação de Strings e Datas**.
**Objetivo:** Aprender a manipular objetos **String** e utilizar a API de Data e Hora do Java (classes **LocalDate**, **LocalTime**, **LocalDateTime**) para trabalhar com informações temporais.
**Pré-requisitos:** Capítulo 9 concluído.
**Projeto Prático:** Adição de data de publicação aos livros e registro de data de empréstimo e devolução, formatando-as para exibição.
**Log de Estado do Projeto:**
- **Objetivo:** Adicionar funcionalidade de manipulação de datas para livros e empréstimos.
- **Código Adicionado:** Adicionar atributos `LocalDate dataPublicacao` à classe `Livro` e `LocalDate dataEmprestimo`, `LocalDate dataDevolucaoPrevista` a uma nova classe `Emprestimo`. Implementar métodos para formatar e exibir essas datas.
- **Estado Funcional:** ✅ Livros e empréstimos podem ter datas associadas, que são exibidas em formatos legíveis.
- **Próximas Etapas:** Capítulo 11 abordará o tratamento de exceções.
**Instruções Específicas:**
- Explique os principais métodos da classe `String` (concatenação, `substring`, `replace`, `equals`, `equalsIgnoreCase`, etc.).
- Detalhe a API de Data e Hora (Java 8+): `LocalDate`, `LocalTime`, `LocalDateTime`, `Duration`, `Period`, e `DateTimeFormatter`.
- O diagrama Mermaid deve ilustrar o fluxo de criação e formatação de uma data.
- O código prático deve demonstrar a manipulação de strings (ex: formatar título) e o uso de `LocalDate` para datas de publicação e empréstimo, com formatação.
- A seção de antecipação de erros deve cobrir `NullPointerException` ao manipular strings e `DateTimeParseException` ao fazer parse de datas.
- O exercício deve envolver o cálculo da duração de um empréstimo e a verificação se um livro está atrasado."

### Capítulo 11: Tratamento de Exceções

**Prompt:**
"Gere o **Capítulo 11: Tratamento de Exceções**.
**Objetivo:** Compreender o que são exceções, como tratá-las usando blocos **try-catch-finally**, e a diferença entre exceções verificadas e não verificadas, incluindo a criação de exceções personalizadas.
**Pré-requisitos:** Capítulo 10 concluído.
**Projeto Prático:** Tratamento de exceções para casos como "livro não encontrado", "usuário inválido" ou "tentativa de empréstimo de livro indisponível".
**Log de Estado do Projeto:**
- **Objetivo:** Implementar tratamento de exceções para cenários de erro na biblioteca.
- **Código Adicionado:** Adicionar blocos `try-catch` em métodos como `buscarLivro()` ou `realizarEmprestimo()`. Criar exceções personalizadas como `LivroNaoEncontradoException` ou `LivroIndisponivelException`.
- **Estado Funcional:** ✅ O programa lida graciosamente com situações de erro, informando o usuário sem travar.
- **Próximas Etapas:** Capítulo 12 abordará Entrada e Saída (I/O) de dados.
**Instruções Específicas:**
- Explique a hierarquia de exceções em Java (`Throwable`, `Error`, `Exception`, `RuntimeException`).
- Detalhe o uso de `try-catch-finally`, `throws` e `throw`.
- O diagrama Mermaid deve ilustrar o fluxo de execução quando uma exceção é lançada e capturada.
- O código prático deve demonstrar o tratamento de exceções em métodos do `GerenciadorBiblioteca`, incluindo a criação e uso de exceções personalizadas.
- A seção de antecipação de erros deve cobrir a captura de exceções muito genéricas e a importância de tratar exceções específicas.
- O exercício deve envolver a criação de uma exceção `UsuarioNaoEncontradoException` e seu tratamento."

### Capítulo 12: Entrada e Saída (I/O) de Dados

**Prompt:**
"Gere o **Capítulo 12: Entrada e Saída (I/O) de Dados**.
**Objetivo:** Aprender a interagir com o usuário através da leitura de entrada e a manipular arquivos para leitura e escrita de dados, utilizando classes como **Scanner**, **File**, **FileReader**, **FileWriter**, **BufferedReader** e **BufferedWriter**.
**Pré-requisitos:** Capítulo 11 concluído.
**Projeto Prático:** Salvar e carregar dados de livros e usuários em arquivos de texto simples, permitindo a persistência dos dados da biblioteca entre as execuções do programa.
**Log de Estado do Projeto:**
- **Objetivo:** Implementar persistência de dados da biblioteca em arquivos de texto.
- **Código Adicionado:** Métodos na classe `GerenciadorBiblioteca` para `salvarLivros()` e `carregarLivros()` (e similar para usuários) usando `FileWriter`/`BufferedWriter` e `FileReader`/`BufferedReader`.
- **Estado Funcional:** ✅ Os dados de livros e usuários são salvos em arquivos e carregados corretamente ao iniciar o programa.
- **Próximas Etapas:** Capítulo 13 abordará Generics para criar código mais flexível.
**Instruções Específicas:**
- Explique a leitura de entrada do usuário com `Scanner`.
- Detalhe as classes `File`, `FileReader`, `FileWriter`, `BufferedReader`, `BufferedWriter` e o conceito de streams de I/O.
- O diagrama Mermaid deve ilustrar o fluxo de leitura e escrita de um arquivo.
- O código prático deve demonstrar a leitura de entrada do usuário para interagir com o sistema e a persistência de dados de livros e usuários em arquivos de texto.
- A seção de antecipação de erros deve cobrir `IOException` e `FileNotFoundException`.
- O exercício deve envolver a criação de um método para exportar a lista de livros para um arquivo CSV."

### Capítulo 13: Introdução a Generics

**Prompt:**
"Gere o **Capítulo 13: Introdução a Generics**.
**Objetivo:** Compreender o conceito de Generics em Java, sua importância para criar código mais seguro e reutilizável, e como usar classes, interfaces e métodos genéricos, incluindo wildcards.
**Pré-requisitos:** Capítulo 12 concluído.
**Projeto Prático:** Criação de uma classe genérica **Repositorio<T>** para gerenciar coleções de itens da biblioteca (Livro, Usuario), tornando o código mais flexível e menos propenso a erros de tipo.
**Log de Estado do Projeto:**
- **Objetivo:** Refatorar o gerenciamento de coleções usando Generics para maior flexibilidade e segurança de tipo.
- **Código Adicionado:** Criação da classe genérica `Repositorio<T>` com métodos como `adicionar(T item)`, `buscar(String id)`, `listarTodos()`. A classe `GerenciadorBiblioteca` passará a usar instâncias de `Repositorio<Livro>` e `Repositorio<Usuario>`.
- **Estado Funcional:** ✅ O gerenciamento de coleções é feito de forma genérica, com segurança de tipo em tempo de compilação.
- **Próximas Etapas:** Capítulo 14 abordará Expressões Lambda e Stream API.
**Instruções Específicas:**
- Explique a motivação para Generics (segurança de tipo, reutilização de código) e como eles funcionam.
- Detalhe classes genéricas, interfaces genéricas, métodos genéricos e wildcards (`? extends`, `? super`).
- O diagrama Mermaid deve ilustrar a estrutura de uma classe genérica `Repositorio<T>`.
- O código prático deve refatorar o `GerenciadorBiblioteca` para usar uma classe `Repositorio<T>` genérica para `Livro` e `Usuario`.
- A seção de antecipação de erros deve cobrir `ClassCastException` (evitada por Generics) e a impossibilidade de criar arrays de tipos genéricos.
- O exercício deve envolver a criação de um método genérico para imprimir elementos de qualquer lista."

### Capítulo 14: Expressões Lambda e Stream API

**Prompt:**
"Gere o **Capítulo 14: Expressões Lambda e Stream API**.
**Objetivo:** Introduzir as Expressões Lambda (Java 8+) para escrever código mais conciso e funcional, e a Stream API para processar coleções de dados de forma declarativa e eficiente.
**Pré-requisitos:** Capítulo 13 concluído.
**Projeto Prático:** Filtrar e ordenar livros na biblioteca por título, autor ou ano de publicação usando Stream API e Expressões Lambda.
**Log de Estado do Projeto:**
- **Objetivo:** Implementar funcionalidades de filtragem e ordenação de coleções usando Expressões Lambda e Stream API.
- **Código Adicionado:** Métodos na classe `GerenciadorBiblioteca` para `buscarLivrosPorAutor(String autor)` ou `listarLivrosDisponiveis()` usando `stream().filter().collect()`. Implementar ordenação de livros por título usando `stream().sorted().collect()`.
- **Estado Funcional:** ✅ O sistema pode filtrar e ordenar coleções de livros de forma eficiente e concisa.
- **Próximas Etapas:** Capítulo 15 abordará Concorrência e Threads.
**Instruções Específicas:**
- Explique o que são Expressões Lambda, interfaces funcionais e como usá-las.
- Detalhe a Stream API, suas operações intermediárias (`filter`, `map`, `sorted`) e terminais (`forEach`, `collect`, `count`).
- O diagrama Mermaid deve ilustrar o pipeline de uma Stream API (fonte -> operações intermediárias -> operação terminal).
- O código prático deve demonstrar o uso de Expressões Lambda e Stream API para filtrar e ordenar a lista de livros.
- A seção de antecipação de erros deve cobrir a confusão entre `Stream` e `Collection` e a natureza de consumo único de uma `Stream`.
- O exercício deve envolver a contagem de livros de um determinado autor usando Stream API."

---

## Parte III: Mestre (Grandes Aplicações, Certificação e Boas Práticas)

### Capítulo 15: Concorrência e Threads (Parte 1)

**Prompt:**
"Gere o **Capítulo 15: Concorrência e Threads (Parte 1)**.
**Objetivo:** Compreender os conceitos de concorrência e paralelismo, e como criar e executar Threads em Java para realizar tarefas simultaneamente.
**Pré-requisitos:** Capítulo 14 concluído.
**Projeto Prático:** Simulação de múltiplos usuários acessando a biblioteca simultaneamente para realizar operações de leitura (ex: buscar livros), introduzindo o conceito de tarefas em segundo plano.
**Log de Estado do Projeto:**
- **Objetivo:** Introduzir o uso de Threads para simular operações concorrentes na biblioteca.
- **Código Adicionado:** Criação de uma classe `TarefaSimulada` que implementa `Runnable` ou estende `Thread`, simulando a busca de um livro. Na classe `Main`, iniciar várias instâncias desta tarefa.
- **Estado Funcional:** ✅ Múltiplas tarefas são executadas em paralelo, demonstrando o conceito de concorrência.
- **Próximas Etapas:** Capítulo 16 abordará problemas de concorrência e sincronização.
**Instruções Específicas:**
- Explique a diferença entre concorrência e paralelismo.
- Detalhe como criar Threads (implementando `Runnable` ou estendendo `Thread`) e como iniciá-las (`start()`).
- O diagrama Mermaid deve ilustrar o ciclo de vida de uma Thread.
- O código prático deve demonstrar a criação e execução de múltiplas Threads para simular usuários da biblioteca.
- A seção de antecipação de erros deve cobrir a chamada direta a `run()` em vez de `start()` e a não determinismo da ordem de execução.
- O exercício deve envolver a criação de uma Thread para simular o empréstimo de um livro."

### Capítulo 16: Concorrência e Threads (Parte 2) e Sincronização

**Prompt:**
"Gere o **Capítulo 16: Concorrência e Threads (Parte 2) e Sincronização**.
**Objetivo:** Entender os problemas de concorrência, como condições de corrida, e aprender a usar a palavra-chave **synchronized** para sincronizar Threads e garantir a integridade dos dados.
**Pré-requisitos:** Capítulo 15 concluído.
**Projeto Prático:** Garantir a integridade dos dados da biblioteca (ex: contagem de livros disponíveis) em um ambiente multi-threaded, utilizando blocos ou métodos sincronizados.
**Log de Estado do Projeto:**
- **Objetivo:** Resolver problemas de concorrência garantindo a integridade dos dados da biblioteca.
- **Código Adicionado:** Identificar um recurso compartilhado (ex: um contador de livros disponíveis ou a lista de livros) e aplicar a palavra-chave `synchronized` a métodos ou blocos de código que acessam esse recurso.
- **Estado Funcional:** ✅ As operações concorrentes agora manipulam os dados compartilhados de forma segura, evitando condições de corrida.
- **Próximas Etapas:** Capítulo 17 abordará a conexão com bancos de dados usando JDBC.
**Instruções Específicas:**
- Explique o que são condições de corrida e por que elas ocorrem.
- Detalhe o uso da palavra-chave `synchronized` em métodos e blocos, e o conceito de monitores.
- O diagrama Mermaid deve ilustrar uma condição de corrida e como a sincronização a resolve.
- O código prático deve demonstrar um cenário de condição de corrida e sua resolução usando `synchronized` em operações como empréstimo/devolução de livros.
- A seção de antecipação de erros deve cobrir deadlocks e a importância de sincronizar apenas o código necessário.
- O exercício deve envolver a sincronização de uma operação de atualização de saldo de usuário em um ambiente multi-threaded."

### Capítulo 17: Introdução a JDBC e Conexão com SQL Server

**Prompt:**
"Gere o **Capítulo 17: Introdução a JDBC e Conexão com SQL Server**.
**Objetivo:** Compreender o que é JDBC (Java Database Connectivity), como configurar o driver para SQL Server e estabelecer uma conexão com o banco de dados.
**Pré-requisitos:** Capítulo 16 concluído. Conhecimento básico de SQL é útil, mas não obrigatório.
**Projeto Prático:** Configuração do ambiente para conectar o Sistema de Gerenciamento de Biblioteca Digital a um banco de dados SQL Server, criando a classe de conexão.
**Log de Estado do Projeto:**
- **Objetivo:** Estabelecer uma conexão funcional com um banco de dados SQL Server a partir da aplicação Java.
- **Código Adicionado:** Adicionar a dependência do driver JDBC para SQL Server (Maven/Gradle). Criar uma classe `ConexaoBD` com um método estático para obter uma `Connection` com o SQL Server, utilizando as credenciais fornecidas.
- **Estado Funcional:** ✅ A aplicação consegue se conectar com sucesso ao banco de dados SQL Server.
- **Próximas Etapas:** Capítulo 18 abordará operações CRUD com JDBC.
**Instruções Específicas:**
- Explique a arquitetura JDBC e seus componentes (Driver Manager, Driver, Connection, Statement, ResultSet).
- Detalhe a adição da dependência do driver JDBC para SQL Server no `pom.xml` (Maven) ou `build.gradle` (Gradle).
- Explique como obter uma `Connection` usando `DriverManager.getConnection()`.
- O diagrama Mermaid deve ilustrar o fluxo de conexão JDBC.
- O código prático deve demonstrar a configuração do driver e a obtenção de uma conexão com o SQL Server.
- A seção de antecipação de erros deve cobrir `ClassNotFoundException` (driver não encontrado) e `SQLException` (problemas de conexão, credenciais).
- O exercício deve envolver a criação de uma tabela simples no SQL Server (ex: `Livros`) e a verificação da conexão."

### Capítulo 18: Operações CRUD com JDBC e SQL Server

**Prompt:**
"Gere o **Capítulo 18: Operações CRUD com JDBC e SQL Server**.
**Objetivo:** Aprender a realizar operações CRUD (Create, Read, Update, Delete) em um banco de dados SQL Server usando JDBC, incluindo o uso de **PreparedStatement** para segurança e eficiência.
**Pré-requisitos:** Capítulo 17 concluído e conexão com SQL Server estabelecida.
**Projeto Prático:** Implementação das operações CRUD para a tabela de livros no SQL Server, permitindo adicionar, listar, atualizar e remover livros do banco de dados.
**Log de Estado do Projeto:**
- **Objetivo:** Implementar as operações CRUD para a entidade `Livro` no banco de dados SQL Server.
- **Código Adicionado:** Na classe `GerenciadorBiblioteca` (ou em uma nova classe `LivroDAO`), implementar métodos como `adicionarLivro(Livro livro)`, `buscarTodosLivros()`, `atualizarLivro(Livro livro)` e `removerLivro(int id)`. Utilizar `PreparedStatement` para todas as operações.
- **Estado Funcional:** ✅ A aplicação pode interagir completamente com a tabela `Livros` no SQL Server, realizando todas as operações CRUD.
- **Próximas Etapas:** Capítulo 19 abordará Testes Unitários com JUnit.
**Instruções Específicas:**
- Explique o que são operações CRUD e sua importância.
- Detalhe o uso de `Statement` vs. `PreparedStatement`, focando nos benefícios de segurança (SQL Injection) e performance do `PreparedStatement`.
- Explique como executar `INSERT`, `SELECT`, `UPDATE`, `DELETE` e como processar um `ResultSet`.
- O diagrama Mermaid deve ilustrar o fluxo de uma operação `SELECT` com JDBC.
- O código prático deve demonstrar a implementação de métodos CRUD para a entidade `Livro` usando `PreparedStatement`.
- A seção de antecipação de erros deve cobrir `SQLException` (erros de SQL) e o fechamento correto de recursos (`Connection`, `Statement`, `ResultSet`).
- O exercício deve envolver a implementação das operações CRUD para a entidade `Usuario` no SQL Server."

### Capítulo 19: Testes Unitários com JUnit

**Prompt:**
"Gere o **Capítulo 19: Testes Unitários com JUnit**.
**Objetivo:** Compreender a importância dos testes unitários no desenvolvimento de software e aprender a escrever e executar testes com o framework JUnit 5.
**Pré-requisitos:** Capítulo 18 concluído.
**Projeto Prático:** Escrever testes unitários para as funcionalidades de gerenciamento de livros (adição, busca, remoção) na classe `GerenciadorBiblioteca` ou `LivroDAO`.
**Log de Estado do Projeto:**
- **Objetivo:** Garantir a correção das funcionalidades da biblioteca através de testes unitários.
- **Código Adicionado:** Adicionar a dependência do JUnit 5 (Maven/Gradle). Criar uma classe de teste `GerenciadorBibliotecaTest` (ou `LivroDAOTest`) com métodos anotados com `@Test`, `@BeforeEach`, `@AfterEach` para testar as operações CRUD de livros.
- **Estado Funcional:** ✅ Os testes unitários são executados com sucesso, validando as funcionalidades principais da biblioteca.
- **Próximas Etapas:** Capítulo 20 abordará Padrões de Projeto.
**Instruções Específicas:**
- Explique o que são testes unitários, seus benefícios e o ciclo de vida de um teste.
- Detalhe a adição da dependência do JUnit 5 e as principais anotações (`@Test`, `@BeforeEach`, `@AfterEach`, `@DisplayName`, `Assertions`).
- O diagrama Mermaid deve ilustrar o fluxo de execução de um teste unitário.
- O código prático deve demonstrar a criação de uma classe de teste para as operações de gerenciamento de livros, com exemplos de asserções.
- A seção de antecipação de erros deve cobrir a escrita de testes que dependem de estado externo e a importância de testes isolados.
- O exercício deve envolver a escrita de testes unitários para a classe `Usuario` ou `UsuarioDAO`."

### Capítulo 20: Padrões de Projeto Essenciais (Singleton, Factory)

**Prompt:**
"Gere o **Capítulo 20: Padrões de Projeto Essenciais (Singleton, Factory)**.
**Objetivo:** Introduzir o conceito de Padrões de Projeto, compreendendo sua importância para resolver problemas comuns de design de software, e aplicar os padrões Singleton e Factory.
**Pré-requisitos:** Capítulo 19 concluído.
**Projeto Prático:** Aplicação do padrão **Singleton** para a classe de conexão com o banco de dados (`ConexaoBD`) e do padrão **Factory** para a criação de objetos `Livro` ou `Usuario`.
**Log de Estado do Projeto:**
- **Objetivo:** Melhorar o design da aplicação utilizando os padrões Singleton e Factory.
- **Código Adicionado:** Refatorar a classe `ConexaoBD` para implementar o padrão Singleton, garantindo uma única instância de conexão. Criar uma `LivroFactory` (ou `UsuarioFactory`) para encapsular a lógica de criação de objetos `Livro`.
- **Estado Funcional:** ✅ A aplicação utiliza os padrões Singleton e Factory, resultando em um código mais organizado e flexível.
- **Próximas Etapas:** Capítulo 21 abordará Tópicos Avançados para Certificação e Boas Práticas.
**Instruções Específicas:**
- Explique o que são Padrões de Projeto, sua origem e benefícios.
- Detalhe o padrão Singleton (garantir uma única instância) e o padrão Factory (encapsular a criação de objetos), com exemplos de implementação.
- O diagrama Mermaid deve ilustrar a estrutura do padrão Singleton e do padrão Factory.
- O código prático deve demonstrar a aplicação do Singleton na classe de conexão e do Factory para a criação de objetos.
- A seção de antecipação de erros deve cobrir a má utilização do Singleton (tornando-o um "anti-padrão") e a complexidade desnecessária ao usar Factory para objetos simples.
- O exercício deve envolver a aplicação do padrão Factory para a criação de objetos `Usuario`."

### Capítulo 21: Tópicos Avançados para Certificação e Boas Práticas

**Prompt:**
"Gere o **Capítulo 21: Tópicos Avançados para Certificação e Boas Práticas**.
**Objetivo:** Revisar tópicos cruciais para a certificação Java, introduzir conceitos de boas práticas de código (Clean Code, SOLID) e apresentar brevemente ferramentas de build (Maven/Gradle).
**Pré-requisitos:** Todos os capítulos anteriores concluídos.
**Projeto Prático:** Refatoração de partes do código do Sistema de Gerenciamento de Biblioteca Digital para aplicar princípios de Clean Code e SOLID (introdução), e uma breve revisão da estrutura do projeto Maven/Gradle.
**Log de Estado do Projeto:**
- **Objetivo:** Consolidar o conhecimento, aplicar boas práticas e revisar tópicos para certificação.
- **Código Adicionado:** Refatorar métodos existentes para torná-los mais legíveis e coesos. Adicionar comentários de documentação (Javadoc). Revisar a estrutura do `pom.xml` ou `build.gradle`.
- **Estado Funcional:** ✅ O projeto está mais robusto, legível e preparado para futuras expansões, com o aluno familiarizado com os tópicos de certificação.
- **Próximas Etapas:** Conclusão do curso e orientações para a certificação.
**Instruções Específicas:**
- Faça uma revisão dos principais tópicos abordados no curso que são relevantes para a certificação Java.
- Introduza os princípios de Clean Code (nomes significativos, funções pequenas, comentários bons) e os princípios SOLID (SRP, OCP, LSP, ISP, DIP - breve introdução).
- Apresente brevemente o papel de ferramentas de build como Maven e Gradle.
- O diagrama Mermaid pode ilustrar um dos princípios SOLID ou o ciclo de build do Maven/Gradle.
- O código prático deve envolver a refatoração de um método existente para aplicar princípios de Clean Code e a adição de Javadoc.
- A seção de antecipação de erros deve cobrir a tentação de ignorar boas práticas e a importância da manutenção do código.
- O exercício deve envolver a identificação de oportunidades de refatoração em outras partes do código do projeto."