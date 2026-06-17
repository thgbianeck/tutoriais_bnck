# Capítulo 1: Introdução ao Java e Configuração do Ambiente

## Resumo da Aula Anterior
Este é o primeiro capítulo do nosso livro, portanto, não há conteúdo anterior para resumir. Estamos começando nossa jornada do zero.

## Objetivo
Ao final deste capítulo, você será capaz de entender o que é Java, seu ecossistema fundamental (JVM, JRE, JDK), e terá seu ambiente de desenvolvimento configurado no **Windows 11** com o **IntelliJ IDEA**. Além disso, você terá criado e executado seu primeiro programa Java, o clássico "Olá, Mundo!", e estabelecido a estrutura inicial do nosso projeto prático, o **Sistema de Gerenciamento de Biblioteca Digital**.

## Pré-requisitos
Nenhum. Este é o ponto de partida absoluto para sua jornada no Java.

## Análise de Integridade
✅ Conteúdo verificado: profundidade técnica mantida, linguagem acessível, código funcional.

## Teoria Detalhada (Narrativa Densa)

Imagine que você está prestes a construir um arranha-céu imponente, uma estrutura que precisa ser robusta, segura e capaz de abrigar milhares de pessoas e empresas. Para isso, você não começaria a empilhar tijolos aleatoriamente. Você precisaria de um projeto arquitetônico sólido, ferramentas adequadas e uma equipe de engenheiros experientes. No mundo da programação, construir grandes aplicações é muito parecido. E se o seu arranha-céu fosse o seu software, então **Java** seria o seu conjunto de ferramentas e o seu projeto arquitetônico.

Java é muito mais do que apenas uma linguagem de programação; é uma plataforma completa, um ecossistema vasto e poderoso que tem sido a espinha dorsal de inúmeras aplicações corporativas, sistemas Android, aplicações web e até mesmo sistemas embarcados por décadas. Lançado pela Sun Microsystems (hoje parte da Oracle) em 1995, Java foi projetado com um princípio fundamental em mente: **"Write Once, Run Anywhere" (Escreva uma vez, execute em qualquer lugar)**. Essa promessa revolucionária significava que um programa Java compilado em uma máquina poderia ser executado em qualquer outra máquina que tivesse uma Java Virtual Machine (JVM) instalada, independentemente do sistema operacional subjacente. Isso eliminou a necessidade de reescrever o código para diferentes plataformas, um desafio comum na época.

A popularidade do Java não se deve apenas à sua portabilidade. Ele é uma linguagem **orientada a objetos**, o que significa que ele organiza o código em "objetos" que representam entidades do mundo real, tornando o software mais modular, fácil de manter e escalável. Pense em um carro: ele é um objeto com atributos (cor, modelo, velocidade) e comportamentos (acelerar, frear). Em Java, você modela esses objetos e suas interações. Além disso, Java é uma linguagem **fortemente tipada**, o que ajuda a prevenir muitos erros comuns de programação em tempo de compilação, antes mesmo de o programa ser executado. Ele também possui um sistema robusto de **gerenciamento automático de memória** (o famoso Garbage Collector), que libera o desenvolvedor da tarefa manual de alocar e desalocar memória, reduzindo a chance de vazamentos de memória e outros problemas.

Para entender como Java funciona, precisamos desmistificar três componentes-chave do seu ecossistema: a **JVM (Java Virtual Machine)**, a **JRE (Java Runtime Environment)** e o **JDK (Java Development Kit)**.

A **JVM**, ou Máquina Virtual Java, é o coração da promessa "Write Once, Run Anywhere". Ela é um programa que atua como um interpretador e executor de código Java. Quando você escreve um código Java, ele é compilado para um formato intermediário chamado **bytecode** (arquivos .class), que não é específico de nenhuma máquina física. A JVM, por sua vez, é responsável por pegar esse bytecode e traduzi-lo para as instruções específicas do hardware e sistema operacional onde o programa está sendo executado. É como ter um tradutor universal que permite que seu livro (o bytecode) seja lido em qualquer país (sistema operacional). Cada sistema operacional (Windows, macOS, Linux) tem sua própria implementação da JVM, mas todas elas entendem o mesmo bytecode.

A **JRE**, ou Java Runtime Environment, é o ambiente de execução Java. Ela é composta pela JVM e por um conjunto de bibliotecas essenciais que os programas Java precisam para rodar. Se você é apenas um usuário que precisa executar aplicações Java, a JRE é tudo o que você precisa. Ela fornece o "motor" e o "combustível" para o seu programa.

O **JDK**, ou Java Development Kit, é o kit de desenvolvimento Java. Ele inclui tudo o que a JRE oferece (JVM + bibliotecas), mas adiciona as ferramentas necessárias para **desenvolver** aplicações Java. As ferramentas mais importantes no JDK são o **compilador Java (javac)**, que transforma seu código-fonte (.java) em bytecode (.class), e o **debugger**, que ajuda a encontrar e corrigir erros no seu código. Em resumo, para desenvolver em Java, você precisa do JDK. Para apenas executar aplicações Java, a JRE é suficiente.

## Analogia de Ancoragem
Imagine que você está montando um novo computador. Você precisa do hardware (o sistema operacional, a CPU, a memória), que seria a **JVM** e o **JRE**. Mas para **criar** seus próprios programas e jogos para esse computador, você precisa de um kit de desenvolvimento de software, que inclui compiladores, depuradores e outras ferramentas. Esse kit é o **JDK**. O Java é como uma linguagem universal que você usa para escrever instruções, e o JDK te dá as ferramentas para transformar essas instruções em algo que o computador entenda e execute, não importa se ele é um Windows, um Mac ou um Linux.

## Diagrama Mermaid
O diagrama a seguir ilustra o fluxo de compilação e execução de um programa Java, mostrando como o código-fonte é transformado em bytecode e executado pela JVM.

~~~mermaid
graph TD
    A[Código Fonte .java] --> B(Compilador Javac)
    B --> C[Bytecode .class]
    C --> D(Java Virtual Machine - JVM)
    D --> E[Execução do Programa]
    D --> F["Bibliotecas de Runtime (JRE)"]
~~~

## Aplicação no Projeto Prático: Configuração do Ambiente e "Olá, Mundo!"

Nesta seção, vamos configurar nosso ambiente de desenvolvimento no **Windows 11** e criar o primeiro projeto no **IntelliJ IDEA**, que será a base para o nosso **Sistema de Gerenciamento de Biblioteca Digital**.

### 1. Instalação do JDK (Java Development Kit)

Para desenvolver em Java, precisamos do JDK. Como você está usando **Java 21+ (ou 25)**, vamos instalar a versão mais recente do OpenJDK.

1.  **Baixar o JDK:**
    *   Acesse o site oficial do OpenJDK ou da Oracle para baixar a versão mais recente do JDK para Windows x64. Recomendo o site do OpenJDK (por exemplo, através do Adoptium ou Oracle OpenJDK).
    *   Procure por uma versão LTS (Long Term Support) como o Java 21 ou a versão mais recente disponível (Java 25, se já tiver sido lançada e estiver estável).
    *   Baixe o instalador `.msi` ou o arquivo `.zip`. O instalador `.msi` é geralmente mais fácil de usar.

2.  **Instalar o JDK:**
    *   Se você baixou o `.msi`, execute-o e siga as instruções do instalador. Mantenha as opções padrão, que geralmente incluem a configuração das variáveis de ambiente.
    *   Se você baixou o `.zip`, descompacte-o em um diretório de sua escolha, por exemplo, `C:\Program Files\Java\jdk-21`.

3.  **Verificar a Instalação e Variáveis de Ambiente (se não configurado automaticamente):**
    *   Abra o Prompt de Comando ou PowerShell.
    *   Digite `java -version` e pressione Enter. Você deverá ver a versão do Java instalada (ex: `openjdk version "21.0.2"`).
    *   Digite `javac -version` e pressione Enter. Você deverá ver a versão do compilador Java (ex: `javac 21.0.2`).
    *   Se algum desses comandos não funcionar, você precisará configurar as variáveis de ambiente manualmente:
        *   **JAVA_HOME:** Crie uma nova variável de ambiente de sistema chamada `JAVA_HOME` e defina seu valor para o caminho da pasta raiz do seu JDK (ex: `C:\Program Files\Java\jdk-21`).
        *   **Path:** Edite a variável de ambiente de sistema `Path` e adicione `%JAVA_HOME%\bin` ao final da lista.
        *   Reinicie o Prompt de Comando/PowerShell para que as mudanças tenham efeito.

### 2. Instalação e Configuração do IntelliJ IDEA

Como você está utilizando o **IntelliJ IDEA**, vamos garantir que ele esteja pronto para nosso projeto.

1.  **Baixar o IntelliJ IDEA:**
    *   Se você ainda não o tem, baixe a versão Community (gratuita) ou Ultimate (paga, com mais recursos) do site oficial da JetBrains: <https://www.jetbrains.com/idea/download/>.
    *   Execute o instalador e siga as instruções.

2.  **Criar um Novo Projeto Maven no IntelliJ IDEA:**
    *   Abra o IntelliJ IDEA.
    *   Na tela de boas-vindas, clique em **"New Project"**.
    *   No painel esquerdo, selecione **"Maven"** (ou "Gradle", ambos são excelentes para gerenciamento de projetos Java). Vamos usar Maven como padrão para este curso.
    *   No painel direito:
        *   **Name:** `BibliotecaDigital` (Este será o nome do nosso projeto).
        *   **Location:** Escolha um diretório onde deseja salvar o projeto (ex: `C:\ProjetosJava\BibliotecaDigital`).
        *   **Group ID:** `com.biblioteca` (Convenção de nomenclatura para pacotes Java, geralmente o domínio da sua organização invertido).
        *   **Artifact ID:** `BibliotecaDigital` (Nome do artefato gerado, geralmente o nome do projeto).
        *   **Version:** `1.0-SNAPSHOT` (Versão inicial do projeto).
        *   **JDK:** Certifique-se de que o **Java 21** (ou a versão que você instalou) esteja selecionado. Se não estiver, clique em "Add JDK" e navegue até o diretório de instalação do seu JDK.
    *   Clique em **"Create"**.

3.  **Estrutura do Projeto:**
    *   O IntelliJ criará a estrutura básica de um projeto Maven:
        ~~~text
        BibliotecaDigital/
        ├── .idea/
        ├── src/
        │   ├── main/
        │   │   ├── java/
        │   │   │   └── com/
        │   │   │       └── biblioteca/
        │   │   │           └── Main.java
        │   │   └── resources/
        │   └── test/
        │       ├── java/
        │       └── resources/
        ├── pom.xml
        └── .gitignore
        ~~~
    *   O arquivo `pom.xml` é o "Project Object Model" do Maven, onde configuramos dependências e plugins.
    *   A pasta `src/main/java/com/biblioteca` é onde nosso código-fonte Java principal residirá.

### 3. O Primeiro Programa: "Olá, Mundo!"

O IntelliJ já deve ter criado um arquivo `Main.java` dentro de `src/main/java/com/biblioteca`. Se não, crie-o: clique com o botão direito na pasta `com.biblioteca`, vá em `New -> Java Class`, e digite `Main`.

Agora, vamos adicionar o código do "Olá, Mundo!" a este arquivo:

~~~java
// Define o pacote ao qual esta classe pertence.
// Pacotes são usados para organizar classes e evitar conflitos de nomes.
package com.biblioteca;

// A classe Main é o ponto de entrada da nossa aplicação.
// Tudo em Java reside dentro de classes.
public class Main {

    // O método main é o método especial que a JVM procura para iniciar a execução do programa.
    // - public: O método pode ser acessado de qualquer lugar.
    // - static: O método pertence à classe, não a uma instância específica do objeto.
    //           Isso significa que podemos chamá-lo diretamente usando o nome da classe (Main.main()).
    // - void: O método não retorna nenhum valor.
    // - String[] args: É um array de Strings que pode receber argumentos de linha de comando
    //                  quando o programa é executado.
    public static void main(String[] args) {
        // System.out.println é um comando para imprimir texto no console.
        // - System: É uma classe final que fornece acesso a recursos do sistema.
        // - out: É um objeto PrintStream estático dentro da classe System, usado para saída padrão.
        // - println: É um método do objeto PrintStream que imprime uma String e adiciona uma nova linha.
        System.out.println("Olá, Mundo! Bem-vindo ao Sistema de Gerenciamento de Biblioteca Digital.");
    }
}
~~~

Para executar este programa:
1.  Clique no pequeno ícone de "Play" (geralmente um triângulo verde) que aparece ao lado da declaração do método `main` ou ao lado da classe `Main`.
2.  Selecione "Run 'Main.main()'".
3.  O console do IntelliJ (geralmente na parte inferior) deverá exibir a mensagem: `Olá, Mundo! Bem-vindo ao Sistema de Gerenciamento de Biblioteca Digital.`

Parabéns! Você configurou seu ambiente e executou seu primeiro programa Java.

## Glossário Técnico da Aula
-   **Java:** Linguagem de programação e plataforma de desenvolvimento.
-   **JVM (Java Virtual Machine):** Máquina virtual que executa o bytecode Java, garantindo portabilidade.
-   **JRE (Java Runtime Environment):** Ambiente de execução que contém a JVM e bibliotecas essenciais.
-   **JDK (Java Development Kit):** Kit de desenvolvimento que inclui JRE, compilador (javac) e outras ferramentas.
-   **Bytecode:** Código intermediário gerado pelo compilador Java, executado pela JVM.
-   **IntelliJ IDEA:** Ambiente de Desenvolvimento Integrado (IDE) para Java.
-   **Maven:** Ferramenta de automação de build e gerenciamento de dependências para projetos Java.
-   **`javac`:** O compilador Java, que transforma `.java` em `.class`.
-   **`java`:** O comando para executar programas Java (bytecode).
-   **`main` método:** O ponto de entrada de um programa Java.
-   **`System.out.println()`:** Comando para imprimir texto no console.

## Antecipação de Erros
-   **"java" não é reconhecido como um comando interno ou externo:** Isso geralmente significa que a variável de ambiente `PATH` não está configurada corretamente para incluir o diretório `bin` do seu JDK. Verifique e ajuste as variáveis de ambiente.
-   **"javac" não é reconhecido:** Similar ao erro acima, indica problema na configuração do `PATH` ou `JAVA_HOME`.
-   **IntelliJ não encontra o JDK:** Ao criar um projeto, o IntelliJ pode não detectar automaticamente o JDK. Use a opção "Add JDK" e aponte para o diretório de instalação do seu JDK.
-   **Erros de compilação no "Olá, Mundo!":** Verifique se há erros de digitação (letras maiúsculas/minúsculas, ponto e vírgula, chaves). Java é case-sensitive.

## Troubleshooting
-   **Problemas de PATH:** No Windows 11, pesquise por "Variáveis de Ambiente" no menu Iniciar. Clique em "Editar as variáveis de ambiente do sistema". Na janela "Propriedades do Sistema", clique em "Variáveis de Ambiente...". Verifique as variáveis de sistema `JAVA_HOME` e `Path`.
-   **IntelliJ não compila/executa:**
    *   Verifique se o JDK correto está configurado para o projeto (`File -> Project Structure -> Project SDK`).
    *   Tente "Build -> Rebuild Project" ou "File -> Invalidate Caches / Restart...".
    *   Verifique o painel "Maven" (geralmente à direita) e clique no ícone de "Reload All Maven Projects".
-   **Mensagens de erro:** Leia as mensagens de erro no console do IntelliJ. Elas geralmente indicam a linha e o tipo de problema.

## Desafio de Fixação
1.  Crie um novo projeto Java no IntelliJ IDEA (pode ser um projeto simples, sem Maven/Gradle por enquanto).
2.  Dentro deste novo projeto, crie uma classe chamada `MinhaInformacao` e, dentro do método `main`, imprima seu nome completo e sua idade.
3.  Execute o programa e verifique a saída no console.
4.  Abra o Prompt de Comando/PowerShell e verifique novamente a versão do Java e do compilador (`java -version` e `javac -version`).

## Resoluções Comentadas
### Desafio de Fixação:
1.  **Crie um novo projeto Java no IntelliJ IDEA:**
    *   No IntelliJ, vá em `File -> New -> Project...`.
    *   Escolha `New Project`.
    *   **Name:** `MeuPrimeiroDesafio`
    *   **Location:** Escolha um diretório.
    *   **Language:** `Java`
    *   **Build system:** `IntelliJ` (para um projeto simples sem Maven/Gradle).
    *   **JDK:** Selecione seu JDK.
    *   Desmarque "Add sample code".
    *   Clique em "Create".
2.  **Crie a Classe `MinhaInformacao`:**
    *   No painel "Project" (geralmente à esquerda), clique com o botão direito na pasta `src`.
    *   Vá em `New -> Java Class`.
    *   Digite `MinhaInformacao` e pressione Enter.
    *   O IntelliJ criará o arquivo `MinhaInformacao.java`.
3.  **Adicione o Código:**
    ~~~java
    // Definição da classe MinhaInformacao
    public class MinhaInformacao {
        // O método main é o ponto de entrada do programa
        public static void main(String[] args) {
            // Declaração de variáveis para armazenar nome e idade
            String nome = "Bianeck"; // Substitua pelo seu nome
            int idade = 30; // Substitua pela sua idade

            // Imprime o nome completo no console
            System.out.println("Meu nome é: " + nome);
            // Imprime a idade no console
            System.out.println("Minha idade é: " + idade + " anos.");
        }
    }
    ~~~
4.  **Execute o programa:** Clique no ícone de "Play" ao lado do método `main` na classe `MinhaInformacao`.
5.  **Verifique a saída:** O console deverá exibir seu nome e idade.
6.  **Verifique a versão do Java no Prompt de Comando/PowerShell:**
    ~~~text
    java -version
    javac -version
    ~~~
    Ambos os comandos devem retornar a versão do JDK que você instalou, confirmando que seu ambiente está configurado corretamente.

## Resumo dos Pontos-Chave
*   Java é uma linguagem de programação robusta, multiplataforma e orientada a objetos.
*   O ecossistema Java é composto por **JDK** (para desenvolvimento), **JRE** (para execução) e **JVM** (a máquina virtual que executa o bytecode).
*   A promessa "Write Once, Run Anywhere" é cumprida pela JVM, que traduz o bytecode para o sistema operacional específico.
*   A configuração do ambiente envolve a instalação do JDK e a configuração das variáveis de ambiente `JAVA_HOME` e `PATH`.
*   O **IntelliJ IDEA** é uma IDE poderosa que facilita o desenvolvimento Java, integrando ferramentas como compilador e debugger.
*   Projetos Java geralmente utilizam sistemas de build como **Maven** ou **Gradle** para gerenciar dependências e automatizar tarefas.
*   O método `main` é o ponto de entrada de qualquer aplicação Java.

## Próximos Passos
Na próxima aula, mergulharemos na **Sintaxe Básica, Variáveis e Tipos de Dados** do Java. Você aprenderá a declarar e usar diferentes tipos de variáveis, entenderá os operadores e começará a modelar as informações básicas de um livro para o nosso Sistema de Gerenciamento de Biblioteca Digital.

## Log de Estado do Projeto
-   **Objetivo:** Configurar o ambiente de desenvolvimento Java e criar a estrutura inicial do projeto "Sistema de Gerenciamento de Biblioteca Digital".
-   **Código Adicionado:** Projeto Maven inicial no IntelliJ IDEA, com a classe `Main` contendo o "Olá, Mundo!". Estrutura de pastas `src/main/java/com/biblioteca`.
-   **Estado Funcional:** ✅ Projeto compila e executa o "Olá, Mundo!".
-   **Próximas Etapas:** Capítulo 2 abordará a sintaxe básica, variáveis e tipos de dados, aplicando-os na criação de informações básicas de um livro.

## Prompt de Continuidade para a próxima aula
"Gere o **Capítulo 2: Sintaxe Básica, Variáveis e Tipos de Dados**.
**Objetivo:** Compreender a estrutura básica de um programa Java, identificadores, palavras-chave, tipos de dados primitivos e como declarar e usar variáveis e operadores.
**Pré-requisitos:** Capítulo 1 concluído e ambiente configurado.
**Projeto Prático:** Criação de variáveis para armazenar informações básicas de um livro (título, autor, ano de publicação, ISBN, disponível).
**Log de Estado do Projeto:**
-   **Objetivo:** Implementar a declaração e uso de variáveis para representar as propriedades de um livro.
-   **Código Adicionado:** Na classe `Main` ou em uma nova classe `LivroSimples`, declarar variáveis para título (`String`), autor (`String`), ano de publicação (`int`), ISBN (`String`) e status de disponibilidade (`boolean`).
-   **Estado Funcional:** ✅ Variáveis declaradas e inicializadas, exibindo seus valores no console.
-   **Próximas Etapas:** Capítulo 3 abordará estruturas condicionais para verificar a disponibilidade de um livro.
**Instruções Específicas:**
-   Explique cada tipo de dado primitivo com exemplos.
-   O diagrama Mermaid deve ilustrar a declaração e atribuição de valores a variáveis.
-   O código prático deve declarar e inicializar variáveis de diferentes tipos para representar um livro e exibir seus valores.
-   A seção de antecipação de erros deve abordar erros de tipo e convenções de nomenclatura.
-   O exercício deve envolver a criação de variáveis para representar um usuário e a aplicação de operadores aritméticos."

---
Dúvidas? Posso prosseguir para a próxima etapa?