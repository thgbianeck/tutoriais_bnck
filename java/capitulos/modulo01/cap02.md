# Capítulo 2: Sintaxe Básica, Variáveis e Tipos de Dados

## Resumo da Aula Anterior
No Capítulo 1, "Introdução ao Java e Configuração do Ambiente", exploramos o que é Java, seu ecossistema (JDK, JRE, JVM) e configuramos nosso ambiente de desenvolvimento no Windows 11 com o IntelliJ IDEA. Criamos nosso primeiro programa "Olá, Mundo!" e estabelecemos a estrutura inicial do projeto "Sistema de Gerenciamento de Biblioteca Digital". Agora que temos as ferramentas prontas, é hora de começar a construir.

## Objetivo
Ao final deste capítulo, você terá uma compreensão sólida da estrutura básica de um programa Java, incluindo como usar comentários, identificadores e palavras-chave. Você dominará os tipos de dados primitivos em Java, aprenderá a declarar e inicializar variáveis, e saberá aplicar operadores aritméticos, relacionais e lógicos para manipular dados. Nosso projeto prático avançará com a criação de variáveis para armazenar informações essenciais de um livro.

## Pré-requisitos
Capítulo 1 concluído e ambiente de desenvolvimento Java configurado no IntelliJ IDEA.

## Análise de Integridade
✅ Conteúdo verificado: profundidade técnica mantida, linguagem acessível, código funcional.

## Teoria Detalhada (Narrativa Densa)

Imagine que você está aprendendo a falar um novo idioma. Antes de construir frases complexas ou escrever um livro, você precisa entender o alfabeto, as palavras básicas, como nomear coisas (substantivos) e como descrever suas características (adjetivos). Na programação Java, a **sintaxe básica**, as **variáveis** e os **tipos de dados** são o "alfabeto" e o "vocabulário" fundamental. Sem eles, é impossível expressar qualquer ideia ou instrução para o computador.

A **sintaxe** de uma linguagem de programação refere-se ao conjunto de regras que definem como as instruções devem ser escritas para que o compilador (o `javac` que vimos no Capítulo 1) possa entendê-las. Em Java, cada instrução geralmente termina com um ponto e vírgula (`;`), e blocos de código são delimitados por chaves (`{}`). A organização do código em classes e métodos é fundamental, e a indentação, embora não seja estritamente exigida pelo compilador, é crucial para a legibilidade e manutenção do código.

### Comentários: Anotações para Humanos

Assim como em um livro, onde notas de rodapé ou marginais podem explicar conceitos ou fornecer contexto, em Java, usamos **comentários** para adicionar explicações ao nosso código. Eles são ignorados pelo compilador, servindo exclusivamente para que outros desenvolvedores (ou você mesmo no futuro) possam entender a lógica por trás do que foi escrito. Existem três tipos de comentários em Java:

1.  **Comentário de linha única:** Começa com `//` e vai até o final da linha.
    ~~~java
    // Este é um comentário de linha única
    int idade = 30; // Declara e inicializa a variável idade
    ~~~
2.  **Comentário de múltiplas linhas:** Começa com `/*` e termina com `*/`. Pode abranger várias linhas.
    ~~~java
    /*
     * Este é um comentário
     * de múltiplas linhas.
     * Ele pode ser usado para blocos maiores de explicação.
     */
    ~~~
3.  **Comentário de documentação (Javadoc):** Começa com `/**` e termina com `*/`. É usado para gerar documentação HTML automaticamente a partir do código. É essencial para projetos maiores e para a certificação.
    ~~~java
    /**
     * Esta classe representa um livro simples.
     * Contém informações básicas como título e autor.
     */
    public class Livro {
        // ...
    }
    ~~~

### Identificadores e Palavras-Chave: Nomes e Regras

Em Java, precisamos dar nomes a classes, variáveis, métodos e outros elementos. Esses nomes são chamados de **identificadores**. Existem regras claras para criá-los:
*   Devem começar com uma letra, `_` (underscore) ou `$`.
*   Não podem começar com um número.
*   Podem conter letras, números, `_` e `$`.
*   São **case-sensitive** (maiúsculas e minúsculas fazem diferença: `nome` é diferente de `Nome`).
*   Não podem ser **palavras-chave** (também conhecidas como palavras reservadas).

As **palavras-chave** são termos que têm um significado especial para a linguagem Java e não podem ser usados como identificadores. Exemplos incluem `public`, `static`, `void`, `int`, `class`, `if`, `else`, `for`, `while`, `new`, `return`, entre muitas outras. O IntelliJ IDEA (e a maioria das IDEs) as destaca com cores diferentes, facilitando a identificação.

### Variáveis: Caixas para Guardar Informações

Pense em uma **variável** como uma caixa rotulada onde você pode armazenar um tipo específico de informação. O rótulo é o nome da variável, e o tipo de informação que a caixa pode guardar é o **tipo de dado**. Em Java, antes de usar uma variável, você precisa **declarar** qual o seu tipo e qual o seu nome. Opcionalmente, você pode **inicializá-la** (colocar um valor dentro da caixa) no momento da declaração ou posteriormente.

A sintaxe para declarar uma variável é: `tipo nomeDaVariavel;`
Para inicializar: `tipo nomeDaVariavel = valor;`

Exemplo:
~~~java
int quantidade = 10; // Declara uma variável 'quantidade' do tipo inteiro e atribui o valor 10
String tituloLivro = "O Senhor dos Anéis"; // Declara uma variável 'tituloLivro' do tipo String e atribui um texto
boolean disponivel = true; // Declara uma variável 'disponivel' do tipo booleano e atribui 'verdadeiro'
~~~

### Tipos de Dados Primitivos: Os Blocos Construtores Básicos

Java é uma linguagem **fortemente tipada**, o que significa que toda variável deve ter um tipo de dado definido. Isso ajuda o compilador a verificar erros e otimizar o código. Os tipos de dados primitivos são os mais básicos e eficientes em termos de memória. Existem oito tipos primitivos em Java, divididos em categorias:

1.  **Números Inteiros:** Armazenam números inteiros (sem casas decimais).
    *   **`byte`**: 8 bits, de -128 a 127. Útil para economizar memória em grandes arrays.
    *   **`short`**: 16 bits, de -32.768 a 32.767.
    *   **`int`**: 32 bits, de aproximadamente -2 bilhões a 2 bilhões. É o tipo mais comum para inteiros.
    *   **`long`**: 64 bits, um número muito grande. Use quando `int` não for suficiente. Para atribuir um literal `long`, adicione `L` ou `l` ao final do número (ex: `10000000000L`).

2.  **Números de Ponto Flutuante:** Armazenam números com casas decimais.
    *   **`float`**: 32 bits, precisão simples. Para atribuir um literal `float`, adicione `F` ou `f` ao final do número (ex: `3.14f`).
    *   **`double`**: 64 bits, precisão dupla. É o tipo padrão para números decimais em Java.

3.  **Caracteres:**
    *   **`char`**: 16 bits, armazena um único caractere Unicode. Literais `char` são definidos com aspas simples (ex: `'A'`, `'1'`, `'\u0041'`).

4.  **Booleano:**
    *   **`boolean`**: Armazena `true` (verdadeiro) ou `false` (falso). Essencial para lógica condicional.

**Exemplo de uso de tipos primitivos:**
~~~java
byte idadeMinima = 18;
short numeroPaginas = 350;
int anoPublicacao = 2023;
long totalVendas = 1234567890123L; // Sufixo L para long

float precoCapa = 49.99f; // Sufixo f para float
double avaliacaoMedia = 4.75;

char primeiraLetraTitulo = 'J';
boolean livroDisponivel = true;
~~~

### Operadores: Ações com Variáveis

Operadores são símbolos que realizam operações em variáveis e valores. Eles são a "gramática" que permite que as variáveis interajam.

1.  **Operadores Aritméticos:** Realizam cálculos matemáticos.
    *   `+` (adição)
    *   `-` (subtração)
    *   `*` (multiplicação)
    *   `/` (divisão)
    *   `%` (módulo - resto da divisão)
    *   `++` (incremento - adiciona 1)
    *   `--` (decremento - subtrai 1)

    Exemplo:
    ~~~java
    int a = 10;
    int b = 3;
    int soma = a + b; // 13
    int subtracao = a - b; // 7
    int multiplicacao = a * b; // 30
    int divisao = a / b; // 3 (divisão inteira)
    int resto = a % b; // 1
    a++; // a agora é 11
    b--; // b agora é 2
    ~~~

2.  **Operadores de Atribuição:** Atribuem valores a variáveis.
    *   `=` (atribuição simples)
    *   `+=`, `-=`, `*=`, `/=`, `%=` (atribuição composta)

    Exemplo:
    ~~~java
    int x = 5;
    x += 3; // Equivalente a x = x + 3; x agora é 8
    x *= 2; // Equivalente a x = x * 2; x agora é 16
    ~~~

3.  **Operadores Relacionais:** Comparam dois valores e retornam um `boolean` (`true` ou `false`).
    *   `==` (igual a)
    *   `!=` (diferente de)
    *   `>` (maior que)
    *   `<` (menor que)
    *   `>=` (maior ou igual a)
    *   `<=` (menor ou igual a)

    Exemplo:
    ~~~java
    int idade = 20;
    boolean maiorDeIdade = (idade >= 18); // true
    boolean ehVinte = (idade == 20); // true
    ~~~

4.  **Operadores Lógicos:** Combinam expressões booleanas e retornam um `boolean`.
    *   `&&` (AND lógico - verdadeiro se ambos forem verdadeiros)
    *   `||` (OR lógico - verdadeiro se pelo menos um for verdadeiro)
    *   `!` (NOT lógico - inverte o valor booleano)

    Exemplo:
    ~~~java
    boolean temCarteira = true;
    boolean temCarro = false;
    boolean podeDirigir = temCarteira && temCarro; // false
    boolean podeAlugar = temCarteira || temCarro; // true
    boolean naoTemCarteira = !temCarteira; // false
    ~~~

## Analogia de Ancoragem
Pense nos tipos de dados como diferentes tipos de contêineres em um armazém. Você tem contêineres pequenos para itens leves (como um `byte`), contêineres médios para caixas (como um `int`), e contêineres gigantes para cargas pesadas (como um `long`). Você também tem contêineres especiais para líquidos (`float`/`double`), para documentos únicos (`char`) e para etiquetas de "sim" ou "não" (`boolean`). As variáveis são as etiquetas que você cola nesses contêineres para saber o que está dentro. Os operadores são as máquinas (empilhadeiras, guindastes) que você usa para mover, combinar ou comparar o conteúdo desses contêineres.

## Diagrama Mermaid
O diagrama a seguir ilustra a declaração e atribuição de valores a variáveis, mostrando como os tipos de dados primitivos são armazenados.

~~~mermaid
graph TD
    subgraph Memória do Programa
        A[int anoPublicacao = 2023]
        B[String tituloLivro = Java Essencial]
        C[boolean disponivel = true]
        D[double preco = 59.90]
    end

    A --> |Armazena inteiro| MemoriaInt(Espaço de Memória para int)
    B --> |Armazena texto| MemoriaString(Espaço de Memória para String)
    C --> |Armazena booleano| MemoriaBoolean(Espaço de Memória para boolean)
    D --> |Armazena decimal| MemoriaDouble(Espaço de Memória para double)
~~~

## Aplicação no Projeto Prático: Sistema de Gerenciamento de Biblioteca Digital

Vamos agora aplicar o que aprendemos para começar a modelar as informações de um livro em nosso projeto. No IntelliJ IDEA, abra o projeto `BibliotecaDigital` que criamos no Capítulo 1.

Dentro da pasta `src/main/java/com/biblioteca`, vamos criar uma nova classe Java chamada `LivroSimples`. Esta classe não será um objeto completo ainda (isso virá no capítulo de Orientação a Objetos), mas servirá para demonstrar a declaração e uso de variáveis para representar as propriedades de um livro.

1.  **Crie a classe `LivroSimples`:**
    *   No painel "Project" do IntelliJ, clique com o botão direito na pasta `com.biblioteca`.
    *   Selecione `New -> Java Class`.
    *   Digite `LivroSimples` e pressione Enter.

2.  **Adicione o código à classe `LivroSimples`:**
    ~~~java
    package com.biblioteca; // Declaração do pacote onde a classe está localizada

    // Definição da classe LivroSimples
    public class LivroSimples {

        // O método main é o ponto de entrada para testar esta classe
        public static void main(String[] args) {
            // --- Declaração e Inicialização de Variáveis para um Livro ---

            // Título do livro (String é um tipo de referência, não primitivo, mas muito comum)
            String titulo = "Dominando Java: Do Zero à Certificação";

            // Autor do livro
            String autor = "Bianeck";

            // Ano de publicação (tipo inteiro)
            int anoPublicacao = 2023;

            // Número de páginas (tipo inteiro)
            int numeroPaginas = 550;

            // ISBN (International Standard Book Number) - tipo String
            String isbn = "978-85-XXXX-YYY-Z";

            // Se o livro está disponível para empréstimo (tipo booleano)
            boolean disponivelParaEmprestimo = true;

            // Preço de capa do livro (tipo double para valores monetários)
            double precoCapa = 89.90;

            // --- Exibindo as informações do Livro no Console ---
            System.out.println("--- Detalhes do Livro ---");
            System.out.println("Título: " + titulo);
            System.out.println("Autor: " + autor);
            System.out.println("Ano de Publicação: " + anoPublicacao);
            System.out.println("Número de Páginas: " + numeroPaginas);
            System.out.println("ISBN: " + isbn);
            System.out.println("Disponível para Empréstimo: " + disponivelParaEmprestimo);
            System.out.println("Preço de Capa: R$ " + precoCapa);

            // --- Exemplo de Operadores Aritméticos e Lógicos ---
            int copiasVendidas = 1500;
            int copiasDisponiveis = 50;
            int totalCopias = copiasVendidas + copiasDisponiveis;
            System.out.println("\nTotal de Cópias (Vendidas + Disponíveis): " + totalCopias);

            boolean estoqueBaixo = (copiasDisponiveis < 100);
            System.out.println("Estoque Baixo? " + estoqueBaixo); // true ou false

            boolean livroPopular = (copiasVendidas > 1000 && disponivelParaEmprestimo);
            System.out.println("Livro Popular e Disponível? " + livroPopular); // true ou false
        }
    }
    ~~~

3.  **Execute a classe `LivroSimples`:**
    *   Clique no ícone de "Play" (triângulo verde) ao lado do método `main` na classe `LivroSimples`.
    *   Verifique a saída no console, que deverá exibir os detalhes do livro e os resultados das operações.

## Glossário Técnico da Aula
*   **Sintaxe:** O conjunto de regras que define como as instruções devem ser escritas em uma linguagem de programação.
*   **Comentário:** Texto no código ignorado pelo compilador, usado para documentação e explicação para humanos.
*   **Identificador:** Nome dado a variáveis, classes, métodos, etc., seguindo regras específicas.
*   **Palavra-chave (Keyword):** Termo reservado da linguagem com significado especial, não pode ser usado como identificador.
*   **Variável:** Um local nomeado na memória para armazenar um valor de um tipo de dado específico.
*   **Declaração de Variável:** O ato de definir o tipo e o nome de uma variável.
*   **Inicialização de Variável:** O ato de atribuir um valor inicial a uma variável.
*   **Tipo de Dado Primitivo:** Tipos de dados básicos em Java (int, double, boolean, char, byte, short, long, float).
*   **Operador Aritmético:** Símbolo para operações matemáticas (+, -, *, /, %, ++, --).
*   **Operador de Atribuição:** Símbolo para atribuir valores (=, +=, -=, etc.).
*   **Operador Relacional:** Símbolo para comparar valores (==, !=, >, <, >=, <=).
*   **Operador Lógico:** Símbolo para combinar expressões booleanas (&&, ||, !).

## Antecipação de Erros
*   **Erro de Tipo (Type Mismatch):** Tentar atribuir um valor de um tipo a uma variável de outro tipo incompatível (ex: `int numero = "texto";`). O compilador Java é rigoroso e detectará isso.
    *   **Como evitar:** Sempre verifique se o tipo do valor que você está atribuindo é compatível com o tipo da variável. Para números, Java pode fazer algumas conversões implícitas (ex: `int` para `double`), mas não o contrário sem uma conversão explícita (casting).
*   **Convenções de Nomenclatura (CamelCase):** Não seguir as convenções pode levar a código difícil de ler e manter, embora não seja um erro de compilação.
    *   **Como evitar:** Use `camelCase` para variáveis e métodos (ex: `nomeDoUsuario`), `PascalCase` para classes (ex: `MinhaClasse`), e `UPPER_SNAKE_CASE` para constantes (ex: `MAX_VALOR`).
*   **Uso de `==` para Strings:** Em Java, `String` é um objeto (tipo de referência), não um primitivo. Usar `==` para comparar `String`s compara se elas são o *mesmo objeto* na memória, não se têm o *mesmo conteúdo*.
    *   **Como evitar:** Para comparar o conteúdo de `String`s, use o método `.equals()` (ex: `titulo.equals("Dominando Java")`). Isso será aprofundado em capítulos futuros.

## Troubleshooting
*   **Erros de Compilação no IntelliJ:** Se o IntelliJ sublinhar seu código em vermelho, passe o mouse sobre a área sublinhada. Ele geralmente mostrará uma mensagem de erro útil que indica o problema (ex: "incompatible types", "cannot find symbol").
*   **Saída Inesperada:** Se o programa compilar e rodar, mas a saída no console não for a esperada, revise a lógica dos seus operadores e a ordem das operações. Use `System.out.println()` para inspecionar o valor das variáveis em diferentes pontos do seu código.

## Desafio de Fixação
1.  Crie uma nova classe chamada `UsuarioSimples` no pacote `com.biblioteca`.
2.  Dentro do método `main` desta classe, declare as seguintes variáveis para representar um usuário:
    *   `nome` (String)
    *   `sobrenome` (String)
    *   `idade` (int)
    *   `email` (String)
    *   `ativo` (boolean)
    *   `saldoPontos` (double)
3.  Atribua valores a todas essas variáveis.
4.  Utilize operadores aritméticos para calcular a `idadeEmMeses` do usuário e o `saldoPontosAposBonus` (adicione 100.50 ao `saldoPontos` original).
5.  Utilize operadores relacionais e lógicos para criar uma variável `podeAcessarSistema` que seja `true` se o usuário for `ativo` E tiver `idade` maior ou igual a 18.
6.  Imprima todos os detalhes do usuário, incluindo `idadeEmMeses`, `saldoPontosAposBonus` e `podeAcessarSistema`, no console.

## Resoluções Comentadas
```java
package com.biblioteca;

public class UsuarioSimples {
    public static void main(String[] args) {
        // 1. Declaração e atribuição de variáveis para um usuário
        String nome = "Ana";
        String sobrenome = "Silva";
        int idade = 25;
        String email = "ana.silva@email.com";
        boolean ativo = true;
        double saldoPontos = 150.75;

        // 2. Cálculo com operadores aritméticos
        int idadeEmMeses = idade * 12;
        double saldoPontosAposBonus = saldoPontos + 100.50;

        // 3. Lógica com operadores relacionais e lógicos
        boolean podeAcessarSistema = ativo && (idade >= 18);

        // 4. Impressão dos detalhes do usuário
        System.out.println("--- Detalhes do Usuário ---");
        System.out.println("Nome Completo: " + nome + " " + sobrenome);
        System.out.println("Idade: " + idade + " anos");
        System.out.println("Idade em Meses: " + idadeEmMeses + " meses");
        System.out.println("Email: " + email);
        System.out.println("Ativo no Sistema: " + ativo);
        System.out.println("Saldo de Pontos: " + saldoPontos);
        System.out.println("Saldo de Pontos (após bônus): " + saldoPontosAposBonus);
        System.out.println("Pode Acessar o Sistema: " + podeAcessarSistema);
    }
}
```
**Explicação da Resolução:**
*   Declaramos variáveis com tipos apropriados para cada informação do usuário.
*   `idadeEmMeses` foi calculada usando o operador de multiplicação (`*`).
*   `saldoPontosAposBonus` foi calculada usando o operador de adição (`+`).
*   `podeAcessarSistema` combinou o operador lógico `&&` (AND) com o operador relacional `>=` (maior ou igual) para verificar duas condições simultaneamente.
*   `System.out.println()` foi usado para exibir cada informação de forma clara no console.

## Resumo dos Pontos-Chave
*   A **sintaxe** Java define as regras de escrita do código, incluindo o uso de `;` e `{}`.
*   **Comentários** (`//`, `/* */`, `/** */`) são essenciais para documentar o código para humanos.
*   **Identificadores** são nomes dados a elementos do código, seguindo regras específicas e sendo *case-sensitive*.
*   **Palavras-chave** são termos reservados da linguagem.
*   **Variáveis** são "caixas" nomeadas para armazenar valores, e devem ser **declaradas** com um **tipo de dado**.
*   Os **tipos de dados primitivos** (`int`, `double`, `boolean`, `char`, `byte`, `short`, `long`, `float`) são os blocos construtores básicos para armazenar diferentes tipos de valores.
*   **Operadores** (`+`, `-`, `*`, `/`, `%`, `==`, `!=`, `>`, `<`, `&&`, `||`, `!`, etc.) permitem manipular e comparar valores e variáveis.

## Próximos Passos
No próximo capítulo, "Estruturas de Controle de Fluxo (Condicionais)", aprenderemos a tomar decisões em nossos programas. Você descobrirá como usar instruções **if**, **else if**, **else**, o operador ternário e a instrução **switch** para controlar o fluxo de execução do seu código. Aplicaremos esses conceitos para adicionar lógica de verificação de disponibilidade de livros ao nosso Sistema de Gerenciamento de Biblioteca Digital.

## Log de Estado do Projeto
-   **Objetivo:** Implementar a declaração e uso de variáveis para representar as propriedades de um livro.
-   **Código Adicionado:** Na classe `LivroSimples`, declarar variáveis para título (`String`), autor (`String`), ano de publicação (`int`), ISBN (`String`) e status de disponibilidade (`boolean`).
-   **Estado Funcional:** ✅ Variáveis declaradas e inicializadas, exibindo seus valores no console.
-   **Próximas Etapas:** Capítulo 3 abordará estruturas condicionais para verificar a disponibilidade de um livro.

## Prompt de Continuidade para a próxima aula
"Gere o **Capítulo 3: Estruturas de Controle de Fluxo (Condicionais)**.
**Objetivo:** Aprender a usar instruções condicionais como **if**, **else if**, **else**, operador ternário e **switch** para controlar o fluxo de execução do programa.
**Pré-requisitos:** Capítulo 2 concluído.
**Projeto Prático:** Implementação de lógica para verificar a disponibilidade de um livro com base em um status booleano e exibir uma mensagem apropriada.
**Log de Estado do Projeto:**
-   **Objetivo:** Adicionar lógica condicional para verificar e exibir o status de disponibilidade de um livro.
-   **Código Adicionado:** Utilização de `if-else` ou `switch` na classe `LivroSimples` (ou em uma nova classe de teste) para verificar a variável `disponivelParaEmprestimo` e imprimir mensagens diferentes.
-   **Estado Funcional:** ✅ Lógica condicional implementada e testada, exibindo mensagens corretas de disponibilidade.
-   **Próximas Etapas:** Capítulo 4 abordará estruturas de controle de fluxo (laços de repetição) para iterar sobre coleções de livros.
**Instruções Específicas:**
-   Explique cada tipo de estrutura condicional com exemplos claros.
-   O diagrama Mermaid deve ilustrar o fluxo de decisão de um `if-else` ou `switch`.
-   O código prático deve demonstrar a aplicação de condicionais para a lógica de disponibilidade do livro.
-   A seção de antecipação de erros deve cobrir a confusão entre `==` e `.equals()` para `String`s em condicionais, e a importância da ordem das condições em `if-else if`.
-   O exercício deve envolver a criação de uma lógica condicional para verificar se um usuário é maior de idade e se pode fazer empréstimos."

---
Dúvidas? Posso prosseguir para a próxima etapa?