# Aula 3: Seu primeiro projeto Jakarta EE com Gradle

## Análise de Integridade
✅ Conteúdo verificado: profundidade técnica mantida para iniciantes, linguagem acessível, analogias presentes em todos os conceitos novos, diagrama Mermaid correto, cada arquivo criado é explicado linha a linha, estrutura de diretórios detalhada, nenhum conceito avançado antecipado, mínimo de 2.000 palavras garantido.

[Voltar ao Índice](#índice)

---

## Índice

- [Aula 3: Seu primeiro projeto Jakarta EE com Gradle](#aula-3-seu-primeiro-projeto-jakarta-ee-com-gradle)
  - [Análise de Integridade](#análise-de-integridade)
  - [Índice](#índice)
  - [Objetivo](#objetivo)
  - [Pré-requisitos](#pré-requisitos)
  - [Teoria Detalhada](#teoria-detalhada)
    - [O que é um projeto Gradle e por que ele existe](#o-que-é-um-projeto-gradle-e-por-que-ele-existe)
    - [A anatomia de um projeto web Java](#a-anatomia-de-um-projeto-web-java)
    - [O arquivo build.gradle: a planta do projeto](#o-arquivo-buildgradle-a-planta-do-projeto)
    - [O arquivo settings.gradle: o nome da obra](#o-arquivo-settingsgradle-o-nome-da-obra)
    - [O arquivo web.xml: o guia de boas-vindas da aplicação](#o-arquivo-webxml-o-guia-de-boas-vindas-da-aplicação)
    - [Dependências e escopos: o que entra no WAR e o que não entra](#dependências-e-escopos-o-que-entra-no-war-e-o-que-não-entra)
    - [O arquivo WAR: a caixa de entrega da aplicação](#o-arquivo-war-a-caixa-de-entrega-da-aplicação)
  - [Analogia de Ancoragem](#analogia-de-ancoragem)
  - [Diagrama Mermaid](#diagrama-mermaid)
  - [Aplicação no Projeto Prático](#aplicação-no-projeto-prático)
    - [Passo 1: Criando a estrutura de diretórios](#passo-1-criando-a-estrutura-de-diretórios)
    - [Passo 2: Criando o arquivo settings.gradle](#passo-2-criando-o-arquivo-settingsgradle)
    - [Passo 3: Criando o arquivo build.gradle](#passo-3-criando-o-arquivo-buildgradle)
    - [Passo 4: Criando o arquivo web.xml](#passo-4-criando-o-arquivo-webxml)
    - [Passo 5: Criando uma página HTML estática](#passo-5-criando-uma-página-html-estática)
    - [Passo 6: Gerando o arquivo WAR](#passo-6-gerando-o-arquivo-war)
    - [Passo 7: Inspecionando o WAR gerado](#passo-7-inspecionando-o-war-gerado)
  - [Glossário Técnico da Aula](#glossário-técnico-da-aula)
  - [Antecipação de Erros](#antecipação-de-erros)
  - [Exercício de Fixação](#exercício-de-fixação)
  - [Resolução Comentada do Exercício](#resolução-comentada-do-exercício)
  - [Resumo dos Pontos-Chave](#resumo-dos-pontos-chave)
  - [Log de Estado do Projeto](#log-de-estado-do-projeto)
  - [Prompt de Continuidade para a Aula 4](#prompt-de-continuidade-para-a-aula-4)

---

## Objetivo
Criar a estrutura completa do projeto Gradle para o Jakarta EE 11, configurar o `build.gradle` com as dependências corretas, entender a anatomia de uma aplicação web Java, criar o `web.xml` mínimo necessário e gerar o primeiro arquivo WAR funcional com o comando `gradle war`.

[Voltar ao Índice](#índice)

## Pré-requisitos
Aula 2 concluída. Java 21, Gradle e VS Code com as extensões **Extension Pack for Java**, **Gradle for Java** e **XML** instalados e verificados. Os comandos `java --version`, `javac --version` e `gradle --version` retornam as versões esperadas no terminal.

[Voltar ao Índice](#índice)

---

## Teoria Detalhada

### O que é um projeto Gradle e por que ele existe

Quando você começa a desenvolver uma aplicação Java do zero, a primeira tentação é criar uma pasta, colocar um arquivo `.java` dentro e compilar manualmente com `javac`. Para um programa simples de algumas linhas, isso funciona. Mas imagine uma aplicação real com centenas de classes Java, dezenas de bibliotecas externas (JARs), arquivos de configuração, páginas web, recursos estáticos como imagens e folhas de estilo, e uma suíte de testes automatizados. Compilar e organizar tudo isso manualmente seria um pesadelo de produtividade — e qualquer novo desenvolvedor que entrasse no projeto teria que descobrir sozinho como montar o ambiente e executar a aplicação.

É exatamente para resolver esse problema que ferramentas de build como o **Gradle** existem. Um projeto Gradle é um projeto que possui um arquivo de configuração — o `build.gradle` — que descreve de forma declarativa tudo que o projeto precisa para ser construído: quais são suas dependências externas, como compilar o código, como rodar os testes, como empacotar o resultado final e como fazer o deploy. Com esse arquivo presente, qualquer desenvolvedor com o Gradle instalado pode executar um único comando e ter o projeto funcionando, independentemente do sistema operacional ou configuração local.

Pense no `build.gradle` como a **receita técnica de fabricação** de um produto industrial. Quando uma fábrica quer produzir um item, ela não improvisa: existe um documento que lista exatamente quais matérias-primas usar (dependências), em que proporções (versões), em que ordem aplicar os processos (tarefas de build) e qual deve ser o resultado final (o WAR). Qualquer operador que siga a receita obterá o mesmo produto. O Gradle é a fábrica, e o `build.gradle` é a receita.

[Voltar ao Índice](#índice)

---

### A anatomia de um projeto web Java

Uma aplicação web Java segue uma estrutura de diretórios padronizada que o Gradle e o servidor de aplicações entendem. Conhecer essa estrutura é fundamental porque, se um arquivo for colocado na pasta errada, a aplicação simplesmente não funcionará — e o erro pode ser difícil de diagnosticar para quem não conhece o padrão.

A estrutura segue a **convenção Maven**, que o Gradle também adota por padrão. "Convenção" aqui significa que o Gradle espera encontrar os arquivos em lugares específicos sem que você precise configurar nada — ele simplesmente os procura nos lugares certos por padrão. Essa ideia de "convenção sobre configuração" é muito poderosa: você escreve menos configuração porque o Gradle já sabe o que esperar.

A pasta `src/main/java/` é onde ficam todas as classes Java da aplicação — os Servlets, os Models, os Repositories, os Filters. Dentro dela, a estrutura de subpastas segue o pacote Java da aplicação. No nosso caso, usaremos o pacote `com.taskflow`, então as classes ficarão em `src/main/java/com/taskflow/`. Usar um pacote organizado em domínio reverso (como `com.taskflow`) é uma convenção do Java para evitar conflitos de nomes entre bibliotecas diferentes.

A pasta `src/main/resources/` é onde ficam arquivos de configuração que não são código Java mas que precisam estar disponíveis em tempo de execução — como arquivos de propriedades, arquivos XML de configuração de bibliotecas e, futuramente, o `persistence.xml` do JPA. O Gradle copia automaticamente tudo que está nessa pasta para o classpath da aplicação.

A pasta `src/main/webapp/` é o coração da aplicação web. Tudo que fica aqui é acessível diretamente pelo navegador ou pelo servidor. É onde ficam as páginas JSP, os arquivos HTML, as folhas de estilo CSS, os scripts JavaScript e a pasta especial `WEB-INF/`. A pasta `WEB-INF/` é protegida pelo servidor de aplicações — nenhum usuário pode acessá-la diretamente pelo navegador, o que a torna o lugar ideal para arquivos de configuração e páginas JSP que só devem ser acessadas internamente pelo servidor.

A pasta `src/test/java/` é onde ficam as classes de teste. O Gradle mantém os testes completamente separados do código de produção, e eles nunca são incluídos no WAR final. É uma separação limpa e importante.

[Voltar ao Índice](#índice)

---

### O arquivo build.gradle: a planta do projeto

O `build.gradle` é o arquivo mais importante de um projeto Gradle. Ele é escrito em uma linguagem chamada **Groovy DSL** (Domain Specific Language — Linguagem de Domínio Específico), que é uma sintaxe simplificada criada especificamente para configurar builds. Você não precisa aprender Groovy profundamente para usar o Gradle — a maioria das configurações segue padrões simples e repetíveis.

Todo `build.gradle` para uma aplicação web Jakarta EE precisa de três partes fundamentais. A primeira é a declaração dos **plugins**: o Gradle por si só não sabe o que é uma aplicação web Java. Você precisa adicionar o plugin `war`, que ensina o Gradle a entender a estrutura de uma aplicação web e a gerar o arquivo WAR. Também usaremos o plugin `java`, que adiciona suporte à compilação de código Java.

A segunda parte é a declaração das **dependências**: aqui você lista as bibliotecas externas que seu projeto precisa. No nosso caso, a principal dependência é a API do Jakarta EE 11 — um JAR que contém todas as interfaces e anotações que usaremos no código. Essa dependência tem um escopo especial chamado `compileOnly`, que veremos em detalhes a seguir.

A terceira parte são as **configurações**: aqui você ajusta o comportamento do Gradle e dos plugins, como o nome do arquivo WAR gerado, a versão do Java a ser usada na compilação e outras preferências do projeto.

[Voltar ao Índice](#índice)

---

### O arquivo settings.gradle: o nome da obra

O `settings.gradle` é um arquivo simples, mas obrigatório. Ele define o **nome do projeto Gradle** e, em projetos com múltiplos módulos, lista quais módulos fazem parte do projeto. Para o nosso caso — um projeto de módulo único — ele conterá apenas uma linha: o nome do projeto. Esse nome é usado pelo Gradle para nomear o arquivo WAR gerado e para identificar o projeto em logs e relatórios.

[Voltar ao Índice](#índice)

---

### O arquivo web.xml: o guia de boas-vindas da aplicação

O `web.xml` é o **descritor de implantação** (deployment descriptor) de uma aplicação web Java. Ele fica dentro da pasta `WEB-INF/` e contém configurações que o servidor de aplicações lê ao fazer o deploy da aplicação. Em versões antigas do Java EE, o `web.xml` era extremamente verboso e obrigatório para configurar praticamente tudo — Servlets, filtros, páginas de erro, configurações de segurança. No Jakarta EE moderno, a maioria dessas configurações pode ser feita com anotações diretamente no código Java, tornando o `web.xml` muito mais simples.

Mesmo assim, o `web.xml` ainda é necessário para algumas configurações que não podem ser feitas com anotações, como a definição de páginas de erro personalizadas (que faremos na Aula 17) e configurações de sessão. Mais importante: a presença do `web.xml` sinaliza ao Gradle (através do plugin `war`) que esta é uma aplicação web, e indica ao GlassFish qual versão da especificação Servlet a aplicação usa.

Para o Jakarta EE 11, o `web.xml` deve declarar a versão `6.1` do Servlet na tag raiz `<web-app>`. Isso garante que o GlassFish saiba que nossa aplicação usa os recursos mais modernos da especificação.

[Voltar ao Índice](#índice)

---

### Dependências e escopos: o que entra no WAR e o que não entra

Um conceito crítico que confunde muitos iniciantes é o de **escopo de dependência**. Quando você declara uma dependência no `build.gradle`, você também precisa dizer ao Gradle *quando* essa dependência é necessária. Existem três escopos principais que usaremos neste curso.

O escopo **`compileOnly`** significa que a dependência é necessária apenas para *compilar* o código — ela não deve ser incluída no WAR final. A API do Jakarta EE 11 (`jakarta.jakartaee-api`) usa esse escopo porque o servidor de aplicações (GlassFish 7) já possui toda a implementação dessas APIs internamente. Se você incluísse a API também no WAR, haveria dois JARs com as mesmas classes — um no WAR e outro no GlassFish — causando conflitos imprevisíveis. Você precisa da API para o compilador entender o que é um `@WebServlet` ou um `HttpServlet`, mas em tempo de execução quem fornece essas classes é o GlassFish.

O escopo **`implementation`** significa que a dependência é necessária tanto para compilar quanto para executar a aplicação, e ela *deve* ser incluída no WAR. Dependências com esse escopo ficam dentro da pasta `WEB-INF/lib/` do WAR. Usaremos esse escopo para bibliotecas que o servidor de aplicações não fornece, como o JSTL e o H2.

O escopo **`testImplementation`** significa que a dependência é necessária apenas para compilar e executar os testes — ela nunca entra no WAR de produção. O JUnit 5 usará esse escopo.

[Voltar ao Índice](#índice)

---

### O arquivo WAR: a caixa de entrega da aplicação

O **WAR** (Web Application Archive) é o formato de empacotamento de aplicações web Java. É essencialmente um arquivo ZIP com uma estrutura interna específica que o servidor de aplicações sabe como desempacotar e executar. Quando você executa `gradle war`, o Gradle compila todas as classes Java, copia os recursos, empacota as dependências com escopo `implementation` e monta tudo em um único arquivo `.war` dentro da pasta `build/libs/`.

A estrutura interna de um WAR é padronizada. Na raiz do WAR ficam os arquivos acessíveis diretamente pelo navegador: páginas HTML, arquivos JSP, imagens, CSS. Na pasta `WEB-INF/` ficam os arquivos protegidos: o `web.xml`, as classes Java compiladas (em `WEB-INF/classes/`) e as bibliotecas externas (em `WEB-INF/lib/`). O servidor de aplicações lê o `web.xml`, carrega as classes de `WEB-INF/classes/`, adiciona os JARs de `WEB-INF/lib/` ao classpath e então está pronto para receber requisições.

[Voltar ao Índice](#índice)

---

## Analogia de Ancoragem

Criar um projeto Gradle é como abrir uma empresa formal. O **`settings.gradle`** é o **contrato social** — define o nome e a identidade da empresa. O **`build.gradle`** é o **plano de negócios** — descreve o que a empresa produz, quais fornecedores contrata (dependências) e como o produto é fabricado (tarefas de build). A **estrutura de diretórios** é a **planta baixa do escritório** — cada departamento (código Java, recursos, testes, páginas web) tem sua sala definida. O **`web.xml`** é o **regulamento interno** — diz ao servidor de aplicações como a empresa funciona e quais regras seguir. O **arquivo WAR** é o **produto final embalado** — pronto para ser entregue ao cliente (o servidor de aplicações).

[Voltar ao Índice](#índice)

---

## Diagrama Mermaid

~~~mermaid
graph TD
    SRC[src/]
    MAIN[main/]
    TEST[test/]
    JAVA[java/com/taskflow/]
    RES[resources/]
    WEBAPP[webapp/]
    WEBINF[WEB-INF/]
    WEBXML[web.xml]
    VIEWS[views/]
    TESTJAVA[java/com/taskflow/]

    BUILD[build.gradle]
    SETTINGS[settings.gradle]
    GRADLE[Gradle - gradle war]

    WAR[taskflow.war]
    CLASSES[WEB-INF/classes/]
    LIB[WEB-INF/lib/]
    ROOTWEB[Arquivos web raiz]

    SRC --> MAIN
    SRC --> TEST
    MAIN --> JAVA
    MAIN --> RES
    MAIN --> WEBAPP
    WEBAPP --> WEBINF
    WEBAPP --> ROOTWEB
    WEBINF --> WEBXML
    WEBINF --> VIEWS
    TEST --> TESTJAVA

    BUILD --> GRADLE
    SETTINGS --> GRADLE
    JAVA --> GRADLE
    RES --> GRADLE
    WEBAPP --> GRADLE

    GRADLE --> WAR
    WAR --> CLASSES
    WAR --> LIB
    WAR --> ROOTWEB
~~~

[Voltar ao Índice](#índice)

---

## Aplicação no Projeto Prático

### Passo 1: Criando a estrutura de diretórios

Abra o terminal integrado do VS Code (`` Ctrl + ` ``) na pasta `taskflow/` e execute os comandos abaixo para criar toda a estrutura de diretórios do projeto de uma vez:

~~~
mkdir src\main\java\com\taskflow\controller
mkdir src\main\java\com\taskflow\model
mkdir src\main\java\com\taskflow\repository
mkdir src\main\java\com\taskflow\filter
mkdir src\main\resources\META-INF
mkdir src\main\webapp\WEB-INF
mkdir src\main\webapp\views\task
mkdir src\main\webapp\views\error
mkdir src\test\java\com\taskflow
mkdir modulo_01_fundamentos\aula_03
~~~

Após executar os comandos, a estrutura de pastas do projeto deve estar assim:

~~~text
taskflow/
├── README.md
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── taskflow/
│   │   │           ├── controller/
│   │   │           ├── model/
│   │   │           ├── repository/
│   │   │           └── filter/
│   │   ├── resources/
│   │   │   └── META-INF/
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       └── views/
│   │           ├── task/
│   │           └── error/
│   └── test/
│       └── java/
│           └── com/
│               └── taskflow/
└── modulo_01_fundamentos/
    └── aula_03/
~~~

[Voltar ao Índice](#índice)

---

### Passo 2: Criando o arquivo settings.gradle

Na raiz da pasta `taskflow/`, crie o arquivo `settings.gradle` com o seguinte conteúdo:

~~~
// Define o nome do projeto Gradle.
// Este nome será usado para nomear o arquivo WAR gerado: taskflow.war
rootProject.name = 'taskflow'
~~~

Este arquivo tem apenas uma responsabilidade: dizer ao Gradle qual é o nome do projeto. O nome `taskflow` fará com que o arquivo gerado pelo comando `gradle war` se chame `taskflow.war`.

[Voltar ao Índice](#índice)

---

### Passo 3: Criando o arquivo build.gradle

Na raiz da pasta `taskflow/`, crie o arquivo `build.gradle` com o seguinte conteúdo:

~~~
// ============================================================
// PLUGINS
// ============================================================

// O bloco 'plugins' declara quais plugins o Gradle deve carregar.
plugins {

    // O plugin 'java' adiciona suporte à compilação de código Java.
    // Ele ensina o Gradle a compilar arquivos .java e a rodar testes.
    id 'java'

    // O plugin 'war' adiciona suporte ao empacotamento de aplicações web.
    // Ele ensina o Gradle a gerar um arquivo .war no formato correto
    // para deploy em servidores de aplicações Jakarta EE.
    id 'war'
}

// ============================================================
// CONFIGURAÇÕES DO PROJETO
// ============================================================

// Define o grupo do projeto, seguindo a convenção de domínio reverso.
// Usado para identificar o projeto em repositórios de artefatos.
group = 'com.taskflow'

// Define a versão atual do projeto.
// '1.0-SNAPSHOT' indica que é uma versão em desenvolvimento.
version = '1.0-SNAPSHOT'

// ============================================================
// CONFIGURAÇÕES DO JAVA
// ============================================================

// O bloco 'java' configura como o código Java deve ser compilado.
java {

    // Define que o código-fonte usa recursos do Java 21.
    // O compilador rejeitará recursos de versões mais recentes.
    sourceCompatibility = JavaVersion.VERSION_21

    // Define que o bytecode gerado é compatível com a JVM do Java 21.
    // Importante para garantir que o GlassFish execute o código corretamente.
    targetCompatibility = JavaVersion.VERSION_21
}

// ============================================================
// REPOSITÓRIOS DE DEPENDÊNCIAS
// ============================================================

// O bloco 'repositories' diz ao Gradle onde buscar as dependências.
repositories {

    // mavenCentral() é o repositório central do Maven/Gradle.
    // É de onde a grande maioria das bibliotecas Java é baixada.
    // O Gradle vai até este repositório na internet para baixar os JARs
    // declarados no bloco 'dependencies' abaixo.
    mavenCentral()
}

// ============================================================
// DEPENDÊNCIAS DO PROJETO
// ============================================================

// O bloco 'dependencies' lista todas as bibliotecas externas que
// o projeto precisa para compilar, executar e testar.
dependencies {

    // DEPENDÊNCIA PRINCIPAL: Jakarta EE 11 API
    // Esta dependência fornece todas as interfaces e anotações do Jakarta EE:
    // @WebServlet, HttpServlet, HttpServletRequest, HttpServletResponse, etc.
    //
    // ESCOPO 'compileOnly': esta dependência é necessária APENAS para
    // compilar o código. Ela NÃO será incluída no arquivo WAR gerado.
    // Por quê? Porque o GlassFish 7 já possui a implementação completa
    // dessas APIs internamente. Incluir a API também no WAR causaria
    // conflitos de classes duplicadas em tempo de execução.
    compileOnly 'jakarta.platform:jakarta.jakartaee-api:11.0.0'

    // DEPENDÊNCIA DE TESTE: JUnit 5 (Jupiter)
    // O JUnit 5 é o framework de testes que usaremos com a metodologia TDD.
    //
    // ESCOPO 'testImplementation': esta dependência é necessária apenas
    // para compilar e executar os testes. Ela NUNCA entra no WAR de produção.
    testImplementation 'org.junit.jupiter:junit-jupiter:5.10.2'

    // Motor de execução do JUnit 5.
    // Necessário para que o Gradle consiga executar os testes JUnit 5.
    testRuntimeOnly 'org.junit.platform:junit-platform-launcher'
}

// ============================================================
// CONFIGURAÇÕES DE TESTE
// ============================================================

// O bloco 'test' configura como o Gradle deve executar os testes.
tasks.named('test') {

    // Diz ao Gradle que os testes usam a plataforma JUnit 5 (Jupiter).
    // Sem esta linha, o Gradle não encontraria os testes anotados com @Test.
    useJUnitPlatform()
}

// ============================================================
// CONFIGURAÇÕES DO WAR
// ============================================================

// O bloco 'war' configura como o arquivo WAR deve ser gerado.
war {

    // Define o nome do arquivo WAR gerado.
    // O resultado será: build/libs/taskflow.war
    // Este é o arquivo que faremos deploy no GlassFish 7 na Aula 4.
    archiveFileName = 'taskflow.war'
}
~~~

[Voltar ao Índice](#índice)

---

### Passo 4: Criando o arquivo web.xml

Dentro da pasta `src/main/webapp/WEB-INF/`, crie o arquivo `web.xml` com o seguinte conteúdo:

~~~xml
<?xml version="1.0" encoding="UTF-8"?>

<!--
    web.xml — Descritor de implantação da aplicação TaskFlow.

    Este arquivo é lido pelo GlassFish 7 ao fazer o deploy da aplicação.
    Ele contém configurações globais da aplicação web.

    O atributo 'version="6.1"' indica que usamos o Jakarta Servlet 6.1,
    que é a versão incluída no Jakarta EE 11.

    O atributo 'xmlns' declara o namespace XML do Jakarta EE 11.
    Sem este namespace correto, o GlassFish não reconhecerá o arquivo.
-->
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee
                             https://jakarta.ee/xml/ns/jakartaee/web-app_6_1.xsd"
         version="6.1">

    <!--
        display-name: o nome da aplicação exibido no console de administração
        do GlassFish. Não afeta o funcionamento, mas ajuda na identificação.
    -->
    <display-name>TaskFlow</display-name>

    <!--
        session-config: configura o comportamento das sessões HTTP.
        session-timeout: define em minutos quanto tempo uma sessão de usuário
        pode ficar inativa antes de ser encerrada automaticamente.
        30 minutos é um valor padrão razoável para aplicações web.
    -->
    <session-config>
        <session-timeout>30</session-timeout>
    </session-config>

</web-app>
~~~

[Voltar ao Índice](#índice)

---

### Passo 5: Criando uma página HTML estática

Para verificar que o projeto está corretamente configurado antes de gerar o WAR, vamos criar uma página HTML simples na raiz da pasta `webapp/`. Crie o arquivo `src/main/webapp/index.html`:

~~~html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <!-- Define a codificação de caracteres como UTF-8 para suporte a acentos -->
    <meta charset="UTF-8">

    <!-- Configura o viewport para responsividade básica -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Título da página exibido na aba do navegador -->
    <title>TaskFlow</title>
</head>
<body>

    <!-- Título principal da página -->
    <h1>TaskFlow está no ar!</h1>

    <!-- Mensagem de boas-vindas -->
    <p>O ambiente Jakarta EE 11 está configurado e funcionando corretamente.</p>
    <p>Os Servlets serão adicionados a partir da Aula 5.</p>

</body>
</html>
~~~

[Voltar ao Índice](#índice)

---

### Passo 6: Gerando o arquivo WAR

Com todos os arquivos criados, abra o terminal integrado do VS Code e execute o comando de build:

~~~
gradle war
~~~

O Gradle exibirá uma saída parecida com esta:

~~~text
> Task :compileJava NO-SOURCE
> Task :processResources NO-SOURCE
> Task :classes UP-TO-DATE
> Task :war

BUILD SUCCESSFUL in 3s
1 actionable task: 1 executed
~~~

A mensagem `BUILD SUCCESSFUL` confirma que o WAR foi gerado corretamente. O arquivo `taskflow.war` foi criado em `build/libs/taskflow.war`. Se aparecer `BUILD FAILED`, leia a mensagem de erro com atenção — ela geralmente indica exatamente qual linha do `build.gradle` tem um problema.

Você também pode usar o comando `gradle clean war` para limpar os artefatos anteriores antes de gerar um novo WAR. O `clean` apaga a pasta `build/` inteira, garantindo que o novo WAR seja gerado do zero sem arquivos antigos interferindo.

~~~
gradle clean war
~~~

[Voltar ao Índice](#índice)

---

### Passo 7: Inspecionando o WAR gerado

Um WAR é essencialmente um arquivo ZIP. Podemos inspecionar seu conteúdo para confirmar que a estrutura interna está correta. No terminal, execute:

~~~
jar tf build\libs\taskflow.war
~~~

A saída deve listar os arquivos dentro do WAR:

~~~text
META-INF/
META-INF/MANIFEST.MF
WEB-INF/
WEB-INF/web.xml
index.html
~~~

Essa saída confirma que o WAR contém o `web.xml` na pasta `WEB-INF/` e o `index.html` na raiz — exatamente a estrutura que o GlassFish espera. Na Aula 4, faremos o deploy deste WAR no GlassFish e acessaremos a página `index.html` pelo navegador.

Por fim, faça o commit do progresso:

~~~
git add .
git commit -m "feat: cria estrutura base do projeto Gradle com Jakarta EE 11"
~~~

[Voltar ao Índice](#índice)

---

## Glossário Técnico da Aula

**Gradle:** Ferramenta de automação de build que gerencia dependências, compila código Java, executa testes e empacota a aplicação em um arquivo WAR. Configurado através do arquivo `build.gradle`.

**`build.gradle`:** Arquivo de configuração principal do Gradle. Escrito em Groovy DSL, declara os plugins, as dependências e as configurações do projeto.

**`settings.gradle`:** Arquivo obrigatório que define o nome do projeto Gradle. Em projetos com múltiplos módulos, também lista os módulos que compõem o projeto.

**Plugin:** Extensão do Gradle que adiciona novas capacidades ao build. O plugin `java` adiciona suporte à compilação Java; o plugin `war` adiciona suporte ao empacotamento de aplicações web.

**Dependência:** Biblioteca externa (JAR) que o projeto precisa para compilar, executar ou testar. Declarada no bloco `dependencies` do `build.gradle`.

**`compileOnly`:** Escopo de dependência que indica que a biblioteca é necessária apenas para compilar o código, não sendo incluída no WAR final. Usado para a API do Jakarta EE, que o servidor de aplicações já fornece.

**`implementation`:** Escopo de dependência que indica que a biblioteca é necessária em tempo de compilação e em tempo de execução, sendo incluída em `WEB-INF/lib/` no WAR final.

**`testImplementation`:** Escopo de dependência usado exclusivamente para testes. A biblioteca nunca entra no WAR de produção.

**WAR (Web Application Archive):** Arquivo compactado no formato ZIP com estrutura padronizada para deploy de aplicações web Java em servidores de aplicações.

**`web.xml`:** Descritor de implantação de uma aplicação web Java. Arquivo XML lido pelo servidor de aplicações durante o deploy, contendo configurações globais da aplicação.

**Descritor de implantação:** Arquivo de configuração que descreve ao servidor de aplicações como a aplicação deve ser configurada e executada.

**`WEB-INF/`:** Pasta protegida dentro de um WAR. Nenhum usuário pode acessar seu conteúdo diretamente pelo navegador. Contém o `web.xml`, as classes compiladas (`classes/`) e as bibliotecas (`lib/`).

**Maven Central:** Repositório central de artefatos Java na internet. O Gradle baixa as dependências declaradas no `build.gradle` a partir deste repositório automaticamente.

**Classpath:** Lista de locais (pastas e JARs) onde a JVM procura classes Java em tempo de compilação e execução. O Gradle monta o classpath automaticamente com base nas dependências declaradas.

**Groovy DSL:** Linguagem usada nos arquivos `build.gradle`. É uma variante simplificada do Groovy, projetada especificamente para configurar builds de forma legível.

**`sourceCompatibility` / `targetCompatibility`:** Configurações do plugin `java` que definem a versão do Java usada no código-fonte e no bytecode gerado, respectivamente.

[Voltar ao Índice](#índice)

---

## Antecipação de Erros

**`BUILD FAILED: Could not resolve jakarta.platform:jakarta.jakartaee-api:11.0.0`:** O Gradle não conseguiu baixar a dependência do Jakarta EE. Verifique sua conexão com a internet e confirme que o bloco `repositories { mavenCentral() }` está presente no `build.gradle`. Na primeira execução, o Gradle precisa baixar o JAR do Maven Central — isso pode levar alguns segundos dependendo da velocidade da conexão.

**`BUILD FAILED: Execution failed for task ':war'. No web.xml`:** O Gradle não encontrou o arquivo `web.xml` na pasta `src/main/webapp/WEB-INF/`. Verifique se o arquivo foi criado exatamente nessa pasta. O caminho correto é `src/main/webapp/WEB-INF/web.xml` — qualquer variação no nome da pasta causará este erro.

**Dependência declarada com escopo `implementation` em vez de `compileOnly` para o Jakarta EE:** O WAR será gerado com o JAR da API Jakarta EE dentro de `WEB-INF/lib/`. Isso causará conflitos com as classes que o GlassFish já fornece internamente, podendo resultar em erros como `ClassCastException` ou comportamento imprevisível em tempo de execução. A API do Jakarta EE **sempre** deve usar o escopo `compileOnly`.

**`error: package jakarta.servlet does not exist` ao compilar:** Significa que a dependência `jakarta.platform:jakarta.jakartaee-api:11.0.0` não está sendo encontrada pelo compilador. Verifique se o nome exato da dependência está correto no `build.gradle` — um erro de digitação no `group`, `name` ou `version` impedirá o Gradle de encontrá-la.

**`settings.gradle` ausente:** O Gradle exibirá um aviso e usará o nome da pasta como nome do projeto. Embora não cause falha imediata, pode gerar um WAR com nome inesperado. Sempre crie o `settings.gradle` com `rootProject.name = 'taskflow'`.

**Pasta `src` criada com letra maiúscula (`Src`):** No Windows, o sistema de arquivos não distingue maiúsculas de minúsculas, então `src` e `Src` funcionam igualmente. Porém, no Linux e macOS (onde servidores de produção geralmente rodam), há distinção. Sempre use letras minúsculas nas pastas do projeto para garantir compatibilidade entre sistemas operacionais.

[Voltar ao Índice](#índice)

---

## Exercício de Fixação

Este exercício tem dois objetivos: verificar que você entendeu o papel de cada arquivo criado e praticar a modificação do `build.gradle`.

**Parte 1 — Inspeção do WAR:** Execute o comando `jar tf build\libs\taskflow.war` no terminal e responda no arquivo `modulo_01_fundamentos/aula_03/exercicio_03.txt`: quais arquivos estão dentro do WAR? A pasta `WEB-INF/lib/` existe? Por que não existe nenhum JAR dentro do WAR mesmo tendo declarado a dependência `jakarta.jakartaee-api`?

**Parte 2 — Adicionando um arquivo estático:** Crie um arquivo `src/main/webapp/sobre.html` com uma página HTML simples que descreva o projeto TaskFlow em duas ou três frases. Execute `gradle war` novamente e inspecione o WAR com `jar tf build\libs\taskflow.war`. O arquivo `sobre.html` aparece no WAR? Em que posição da estrutura interna ele aparece?

**Parte 3 — Reflexão sobre escopos:** No arquivo `exercicio_03.txt`, explique com suas próprias palavras a diferença entre os escopos `compileOnly` e `implementation`. Por que usar `implementation` para a API do Jakarta EE seria um problema?

Ao final, faça o commit:

~~~
git add modulo_01_fundamentos/aula_03/
git commit -m "docs: adiciona exercicio da aula 03"
~~~

[Voltar ao Índice](#índice)

---

## Resolução Comentada do Exercício

**Parte 1:** O WAR contém `META-INF/`, `META-INF/MANIFEST.MF`, `WEB-INF/`, `WEB-INF/web.xml` e `index.html`. A pasta `WEB-INF/lib/` **não existe** porque nenhuma dependência com escopo `implementation` foi declarada. A dependência `jakarta.jakartaee-api` usa escopo `compileOnly` — ela é usada apenas durante a compilação e não é copiada para dentro do WAR. Isso é correto e esperado: o GlassFish já possui essa implementação internamente.

**Parte 2:** Sim, o arquivo `sobre.html` aparece na raiz do WAR, junto com o `index.html`. Todo arquivo colocado diretamente em `src/main/webapp/` (fora da pasta `WEB-INF/`) é copiado para a raiz do WAR e fica acessível diretamente pelo navegador. Após o deploy no GlassFish (Aula 4), seria possível acessar `http://localhost:8080/taskflow/sobre.html` diretamente.

**Parte 3:** O escopo `compileOnly` significa que a biblioteca está disponível para o compilador Java ler e entender o código, mas não é copiada para o WAR. O escopo `implementation` significa que a biblioteca é copiada para `WEB-INF/lib/` dentro do WAR. Usar `implementation` para a API do Jakarta EE seria um problema porque o GlassFish já carrega sua própria implementação dessas classes ao iniciar. Ter duas versões das mesmas classes — uma no WAR e outra no GlassFish — cria ambiguidade para a JVM, que pode carregar a versão errada, causando erros como `ClassCastException` ou comportamento completamente imprevisível.

[Voltar ao Índice](#índice)

---

## Resumo dos Pontos-Chave

Um projeto Gradle para Jakarta EE é definido por dois arquivos de configuração na raiz: o **`settings.gradle`** (que define o nome do projeto) e o **`build.gradle`** (que define os plugins, dependências e configurações do build). A **estrutura de diretórios** segue a convenção Maven: código Java em `src/main/java/`, recursos em `src/main/resources/`, arquivos web em `src/main/webapp/` e testes em `src/test/java/`. O arquivo **`web.xml`** é o descritor de implantação da aplicação, obrigatoriamente em `src/main/webapp/WEB-INF/`, declarando a versão `6.1` do Servlet para Jakarta EE 11. A dependência da API Jakarta EE usa o escopo **`compileOnly`** porque o GlassFish já fornece a implementação — incluí-la no WAR causaria conflitos. O comando **`gradle war`** compila o código, processa os recursos e empacota tudo no arquivo `build/libs/taskflow.war`, pronto para deploy no GlassFish 7.

[Voltar ao Índice](#índice)

---

## Log de Estado do Projeto

~~~text
## Aula 3: Seu primeiro projeto Jakarta EE com Gradle
- Objetivo: Criar a estrutura base do projeto Gradle com Jakarta EE 11.
- Código Adicionado: settings.gradle, build.gradle, src/main/webapp/WEB-INF/web.xml,
  src/main/webapp/index.html e toda a estrutura de diretórios do projeto.
- Estado Funcional: ✅ gradle war gera build/libs/taskflow.war sem erros.
- Próximas Etapas: Aula 4 instalará o GlassFish 7 e fará o deploy do taskflow.war,
  tornando a aplicação acessível em http://localhost:8080/taskflow.
~~~

[Voltar ao Índice](#índice)

---

## Prompt de Continuidade para a Aula 4

"Sou aluno do curso Jakarta EE 11 com Java 21, Gradle, JUnit 5 e VS Code. Concluí a Aula 3 (Seu primeiro projeto Jakarta EE com Gradle). O projeto TaskFlow tem sua estrutura de diretórios completa, o build.gradle configurado com Jakarta EE 11, o web.xml criado e o comando gradle war gera o taskflow.war com sucesso. Tenho o plano_mestre.txt, o log_estado_projeto.md e os prompts_individuais.md em anexo para contexto. Por favor, gere a **Aula 4: Entendendo o servidor de aplicações: GlassFish 7**, seguindo rigorosamente a estrutura definida no plano mestre: teoria detalhada com mínimo de 2.000 palavras, analogia de ancoragem, diagrama Mermaid com blocos ~~~mermaid, código comentado linha a linha com blocos ~~~, glossário técnico, antecipação de erros, exercício com resolução comentada, resumo dos pontos-chave, log de estado do projeto atualizado e prompt de continuidade para a Aula 5. O documento inteiro deve estar dentro de um bloco ```markdown. Nenhum bloco interno deve usar triple backtick."

[Voltar ao Índice](#índice)

---

Dúvidas? Posso prosseguir para a **Aula 4: Entendendo o servidor de aplicações: GlassFish 7**?