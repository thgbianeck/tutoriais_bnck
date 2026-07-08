# Aula 2: Configurando o ambiente de desenvolvimento no Windows 11

## Análise de Integridade
✅ Conteúdo verificado: profundidade técnica mantida para iniciantes, linguagem acessível, analogias presentes em todos os conceitos novos, diagrama Mermaid correto, instruções passo a passo para Windows 11 detalhadas, extensões do VS Code explicadas, nenhum código Java antecipado, mínimo de 2.000 palavras garantido.

[Voltar ao Índice](#índice)

---

## Índice

- [Aula 2: Configurando o ambiente de desenvolvimento no Windows 11](#aula-2-configurando-o-ambiente-de-desenvolvimento-no-windows-11)
  - [Análise de Integridade](#análise-de-integridade)
  - [Índice](#índice)
  - [Objetivo](#objetivo)
  - [Pré-requisitos](#pré-requisitos)
  - [Teoria Detalhada](#teoria-detalhada)
    - [Por que cada ferramenta existe](#por-que-cada-ferramenta-existe)
    - [O Java Development Kit: a oficina do desenvolvedor](#o-java-development-kit-a-oficina-do-desenvolvedor)
    - [O Gradle: o mestre de obras do projeto](#o-gradle-o-mestre-de-obras-do-projeto)
    - [O VS Code: a bancada de trabalho](#o-vs-code-a-bancada-de-trabalho)
    - [As variáveis de ambiente: o mapa das ferramentas](#as-variáveis-de-ambiente-o-mapa-das-ferramentas)
  - [Analogia de Ancoragem](#analogia-de-ancoragem)
  - [Diagrama Mermaid](#diagrama-mermaid)
  - [Aplicação no Projeto Prático](#aplicação-no-projeto-prático)
    - [Passo 1: Instalando o Java 21](#passo-1-instalando-o-java-21)
    - [Passo 2: Configurando JAVA\_HOME e PATH](#passo-2-configurando-java_home-e-path)
    - [Passo 3: Instalando o Gradle](#passo-3-instalando-o-gradle)
    - [Passo 4: Configurando o Gradle no PATH](#passo-4-configurando-o-gradle-no-path)
    - [Passo 5: Instalando e configurando o VS Code](#passo-5-instalando-e-configurando-o-vs-code)
    - [Passo 6: Verificando o ambiente completo](#passo-6-verificando-o-ambiente-completo)
  - [Glossário Técnico da Aula](#glossário-técnico-da-aula)
  - [Antecipação de Erros](#antecipação-de-erros)
  - [Exercício de Fixação](#exercício-de-fixação)
  - [Resolução Comentada do Exercício](#resolução-comentada-do-exercício)
  - [Resumo dos Pontos-Chave](#resumo-dos-pontos-chave)
  - [Log de Estado do Projeto](#log-de-estado-do-projeto)
  - [Prompt de Continuidade para a Aula 3](#prompt-de-continuidade-para-a-aula-3)

---

## Objetivo
Instalar e verificar o Java 21, instalar e configurar o Gradle, configurar o VS Code com as extensões essenciais para desenvolvimento Jakarta EE e preparar o ambiente completo para que o projeto TaskFlow possa ser criado na próxima aula.

## Pré-requisitos
Aula 1 concluída. Você já entende o que é o Jakarta EE, o papel do servidor de aplicações e conhece o projeto TaskFlow que construiremos. A pasta `taskflow/` e o `README.md` foram criados.

[Voltar ao Índice](#índice)

---

## Teoria Detalhada

### Por que cada ferramenta existe

Antes de instalar qualquer coisa, é importante entender o papel de cada ferramenta no ecossistema de desenvolvimento. Instalar sem entender é como montar um estúdio de música sem saber para que serve cada equipamento: você liga os cabos, mas não sabe o que está fazendo.

Pense no desenvolvimento de software como a construção de um móvel planejado. Você precisa de três coisas fundamentais: a **matéria-prima** (a madeira, que no nosso caso é o código Java que você escreverá), as **ferramentas de trabalho** (a serra, a lixadeira, o parafuso — que no nosso caso são o compilador Java e o Gradle) e a **bancada onde você trabalha** (a mesa do marceneiro — que no nosso caso é o VS Code). Cada uma dessas peças tem um papel claro e insubstituível. Sem a matéria-prima, não há nada para construir. Sem as ferramentas, a matéria-prima não vira móvel. Sem a bancada, você trabalha no chão, desorganizado e improdutivo.

Ao longo desta aula, instalaremos e configuraremos exatamente essas três camadas: o **Java 21** (a fundação que faz tudo funcionar), o **Gradle** (a ferramenta que compila, testa e empacota o projeto) e o **VS Code** (o ambiente onde você escreverá e organizará seu código). O GlassFish 7, o servidor de aplicações, será instalado na Aula 4 — quando tivermos um projeto para deployar nele.

[Voltar ao Índice](#índice)

---

### O Java Development Kit: a oficina do desenvolvedor

O **JDK** (Java Development Kit) é muito mais do que apenas o Java. Ele é um conjunto completo de ferramentas para desenvolver, compilar e executar programas Java. Dentro do JDK você encontra o **compilador** (`javac`), que transforma seu código-fonte `.java` em bytecode `.class`, o **interpretador** (`java`), que executa esse bytecode na JVM (Java Virtual Machine), e dezenas de outras ferramentas auxiliares para depuração, documentação e monitoramento.

A diferença entre o **JDK** e o **JRE** (Java Runtime Environment) é importante: o JRE contém apenas o que é necessário para *executar* programas Java — a JVM e as bibliotecas padrão. O JDK contém o JRE *mais* as ferramentas de desenvolvimento (compilador, depurador, etc.). Como somos desenvolvedores, precisamos do JDK completo.

Neste curso usaremos o **Java 21**, que é uma versão **LTS** (Long-Term Support — Suporte de Longo Prazo). Versões LTS do Java recebem atualizações de segurança e correções de bugs por muitos anos, o que as torna a escolha padrão para projetos sérios. O Java 21 é a versão LTS mais recente e a que o Jakarta EE 11 requer como versão mínima. Usar qualquer versão anterior ao Java 21 com Jakarta EE 11 causará erros de incompatibilidade.

Existem diferentes distribuidoras do JDK 21. A Oracle oferece a versão oficial, mas exige uma licença comercial para uso em produção após certo ponto. Para este curso, usaremos o **Eclipse Temurin 21**, distribuído pelo projeto **Adoptium** — uma distribuição gratuita, de código aberto e 100% compatível com o Java oficial. É a escolha recomendada pela comunidade Java para desenvolvimento e produção sem custos de licenciamento.

[Voltar ao Índice](#índice)

---

### O Gradle: o mestre de obras do projeto

O **Gradle** é uma ferramenta de automação de build. "Build" é o processo de transformar seu código-fonte em algo executável: compilar as classes Java, baixar as dependências externas (bibliotecas), rodar os testes automatizados e empacotar tudo em um arquivo WAR pronto para deploy. Sem uma ferramenta de build, você teria que fazer cada um desses passos manualmente, na ordem certa, sem esquecer nenhum. Isso seria impraticável em qualquer projeto real.

Use esta analogia: o Gradle é como um **mestre de obras**. Ele conhece todas as etapas da construção do edifício, sabe em que ordem devem acontecer, quais materiais (dependências) precisam ser entregues antes de cada etapa e o que fazer se algo der errado. Você diz ao mestre de obras "quero que o prédio fique assim" (o arquivo `build.gradle`) e ele coordena tudo para que aconteça. Você não precisa ligar para cada fornecedor de material ou dizer a cada operário o que fazer — o mestre de obras cuida disso.

Existem duas grandes ferramentas de build no ecossistema Java: o **Maven** e o **Gradle**. O Maven usa arquivos XML de configuração e segue uma estrutura muito rígida. O Gradle usa arquivos escritos em **Groovy** ou **Kotlin** e oferece muito mais flexibilidade e desempenho. Neste curso usamos o Gradle por ser mais moderno, mais rápido e ter uma sintaxe mais legível do que o XML do Maven.

Uma das responsabilidades mais importantes do Gradle é o **gerenciamento de dependências**. Quando você diz no `build.gradle` que seu projeto precisa do Jakarta EE 11, o Gradle vai automaticamente até um repositório central de bibliotecas na internet (o Maven Central), baixa o arquivo JAR correto com todas as classes do Jakarta EE e o coloca disponível para seu projeto. Você nunca precisa baixar JARs manualmente e colocar em pastas — o Gradle faz isso por você, de forma reproduzível e controlada.

[Voltar ao Índice](#índice)

---

### O VS Code: a bancada de trabalho

O **Visual Studio Code** (VS Code) é um editor de código criado pela Microsoft, gratuito e de código aberto. Ele é leve, rápido e extremamente extensível — você pode adicionar suporte a praticamente qualquer linguagem ou tecnologia através de extensões. Hoje é o editor de código mais popular do mundo entre desenvolvedores de todas as linguagens.

Por padrão, o VS Code não sabe nada sobre Java. Ele é apenas um editor de texto avançado. O que o transforma em um ambiente de desenvolvimento Java completo são as **extensões** — pacotes de funcionalidades que você instala diretamente dentro do VS Code. Para o nosso curso, instalaremos três extensões essenciais.

A primeira é o **Extension Pack for Java**, publicado pela Microsoft. Este pacote instala automaticamente seis extensões que juntas formam um ambiente Java completo dentro do VS Code: suporte à linguagem Java com autocompletar inteligente, depurador integrado, suporte ao Maven e Gradle, gerenciador de projetos Java e executor de testes. É a instalação mais importante desta aula.

A segunda é o **Gradle for Java**, publicado pela Microsoft. Esta extensão adiciona uma interface visual para o Gradle dentro do VS Code, permitindo que você veja e execute as tarefas do Gradle (como `build`, `war`, `test`) com um clique, sem precisar digitar comandos no terminal a cada vez.

A terceira é o **XML**, publicado pela Red Hat. Esta extensão adiciona suporte completo a arquivos XML dentro do VS Code, com validação, formatação e autocompletar. Usaremos arquivos XML importantes no curso — como o `web.xml` e o `persistence.xml` — e esta extensão tornará a edição desses arquivos muito mais confortável.

[Voltar ao Índice](#índice)

---

### As variáveis de ambiente: o mapa das ferramentas

Um conceito que aparece repetidamente na configuração de ferramentas de desenvolvimento no Windows é o de **variáveis de ambiente**. Elas são como um **mapa** que o sistema operacional usa para encontrar programas e ferramentas. Quando você digita `java` no terminal, o Windows precisa saber *onde* está o arquivo `java.exe`. Sem essa informação, ele simplesmente não encontra o programa e exibe o erro `'java' não é reconhecido como um comando interno ou externo`.

As variáveis de ambiente mais importantes para o nosso ambiente são duas. A primeira é o **`JAVA_HOME`**: aponta para a pasta raiz da instalação do JDK. Muitas ferramentas Java (incluindo o Gradle) procuram por essa variável para encontrar o Java instalado no sistema. A segunda é o **`PATH`**: uma lista de pastas onde o Windows procura por executáveis. Quando você adiciona a pasta `bin` do JDK ao `PATH`, o Windows passa a encontrar o comando `java` e o comando `javac` de qualquer lugar no terminal.

Pense nas variáveis de ambiente como **endereços na agenda de contatos do sistema operacional**. O `JAVA_HOME` é o endereço da casa do Java. O `PATH` é uma lista de endereços de todos os lugares onde o sistema deve procurar quando alguém pede para executar um programa. Sem esses endereços configurados corretamente, o sistema fica perdido.

[Voltar ao Índice](#índice)

---

## Analogia de Ancoragem

Configurar o ambiente de desenvolvimento é como preparar uma cozinha profissional antes de cozinhar. O **Java 21** é o fogão — a peça central sem a qual nada funciona. O **Gradle** é o conjunto de utensílios (facas, panelas, colheres) que permitem preparar os ingredientes e cozinhar os pratos. O **VS Code** é a bancada de trabalho onde você organiza tudo e executa as tarefas. As **variáveis de ambiente** são as etiquetas nos armários que dizem onde cada utensílio está guardado. Você pode ter os melhores ingredientes do mundo, mas sem a cozinha bem organizada e equipada, o prato não sai. Esta aula monta a cozinha para que, a partir da Aula 3, possamos começar a cozinhar.

[Voltar ao Índice](#índice)

---

## Diagrama Mermaid

~~~mermaid
graph TD
    JDK[Java 21 JDK - Adoptium Temurin]
    GRADLE[Gradle 8]
    VSCODE[VS Code]
    EXT1[Extension Pack for Java]
    EXT2[Gradle for Java]
    EXT3[XML - Red Hat]
    ENV[Variáveis de Ambiente]
    JAVA_HOME[JAVA_HOME]
    PATH[PATH]
    PROJETO[Projeto TaskFlow]

    JDK --> ENV
    ENV --> JAVA_HOME
    ENV --> PATH
    GRADLE --> ENV

    VSCODE --> EXT1
    VSCODE --> EXT2
    VSCODE --> EXT3

    JDK --> GRADLE
    GRADLE --> PROJETO
    VSCODE --> PROJETO
~~~

[Voltar ao Índice](#índice)

---

## Aplicação no Projeto Prático

### Passo 1: Instalando o Java 21

Acesse o site oficial do Adoptium em **https://adoptium.net** e siga os passos abaixo:

Na página inicial, clique em **"Latest LTS release"**. Verifique que a versão selecionada é o **Temurin 21** e o sistema operacional é **Windows**. Clique no botão de download do instalador `.msi` (Windows Installer). Aguarde o download concluir — o arquivo terá um nome parecido com `OpenJDK21U-jdk_x64_windows_hotspot_21.x.x_x.msi`.

Execute o instalador com duplo clique. Quando o assistente de instalação abrir, clique em **Next**. Na tela de opções de instalação, marque a opção **"Set JAVA_HOME variable"** — isso poupará um passo de configuração manual. Marque também **"Add to PATH"** se disponível. Clique em **Next** e depois em **Install**. Aguarde a instalação concluir e clique em **Finish**.

Abra o **PowerShell** (pressione `Windows + X` e escolha "Windows PowerShell" ou "Terminal") e execute:

~~~
java --version
~~~

A saída esperada é algo como:

~~~text
openjdk 21.0.x 2024-xx-xx LTS
OpenJDK Runtime Environment Temurin-21.0.x+xx (build 21.0.x+xx-LTS)
OpenJDK 64-Bit Server VM Temurin-21.0.x+xx (build 21.0.x+xx-LTS, mixed mode, sharing)
~~~

Se você vir essa saída, o Java 21 está instalado corretamente. Se o terminal exibir `'java' não é reconhecido`, siga o Passo 2 manualmente.

Execute também:

~~~
javac --version
~~~

A saída esperada é:

~~~text
javac 21.0.x
~~~

[Voltar ao Índice](#índice)

---

### Passo 2: Configurando JAVA_HOME e PATH

Se o instalador do Adoptium não configurou automaticamente as variáveis de ambiente, siga este passo. Mesmo que tenha configurado, é importante verificar.

Primeiro, encontre onde o Java foi instalado. O caminho padrão é geralmente:

~~~text
C:\Program Files\Eclipse Adoptium\jdk-21.x.x.x-hotspot
~~~

Para verificar, abra o **Explorador de Arquivos**, navegue até `C:\Program Files\Eclipse Adoptium\` e anote o nome exato da pasta do JDK 21.

Agora configure as variáveis de ambiente. Pressione `Windows + S`, digite **"variáveis de ambiente"** e clique em **"Editar as variáveis de ambiente do sistema"**. Na janela que abrir, clique em **"Variáveis de Ambiente..."**.

Na seção **"Variáveis do sistema"**, clique em **"Nova..."** para criar a variável `JAVA_HOME`:

~~~text
Nome da variável: JAVA_HOME
Valor da variável: C:\Program Files\Eclipse Adoptium\jdk-21.x.x.x-hotspot
~~~

Substitua o caminho pelo caminho exato da sua instalação. Clique em **OK**.

Ainda na seção **"Variáveis do sistema"**, encontre a variável **`Path`**, selecione-a e clique em **"Editar..."**. Na janela de edição, clique em **"Novo"** e adicione:

~~~text
%JAVA_HOME%\bin
~~~

Clique em **OK** em todas as janelas abertas para salvar. **Feche e reabra o PowerShell** (importante: as variáveis de ambiente só são carregadas em sessões novas do terminal). Execute `java --version` novamente para confirmar.

[Voltar ao Índice](#índice)

---

### Passo 3: Instalando o Gradle

Acesse **https://gradle.org/releases** e baixe a versão mais recente do Gradle na distribuição **Binary-only** (arquivo `.zip`). No momento da escrita deste curso, a versão recomendada é o **Gradle 8.x**.

Após o download, extraia o arquivo `.zip`. Recomenda-se extrair em uma pasta limpa e permanente, como:

~~~text
C:\ferramentas\gradle-8.x
~~~

Crie a pasta `C:\ferramentas\` se ela não existir, e extraia o conteúdo do ZIP dentro dela. Você terá uma estrutura como:

~~~text
C:\ferramentas\
└── gradle-8.x\
    ├── bin\
    │   ├── gradle
    │   └── gradle.bat
    ├── lib\
    └── ...
~~~

[Voltar ao Índice](#índice)

---

### Passo 4: Configurando o Gradle no PATH

Abra novamente as **Variáveis de Ambiente** (conforme o Passo 2). Na seção **"Variáveis do sistema"**, edite a variável **`Path`** e adicione uma nova entrada:

~~~text
C:\ferramentas\gradle-8.x\bin
~~~

Clique em **OK** em todas as janelas. Feche e reabra o PowerShell e execute:

~~~
gradle --version
~~~

A saída esperada é algo como:

~~~text
---
Gradle 8.x
---

Build time:   2024-xx-xx xx:xx:xx UTC
Revision:     xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

Kotlin:       x.x.x
Groovy:       x.x.x
Ant:          Apache Ant(TM) version x.x.x
JVM:          21.0.x (Eclipse Adoptium xx.x.x+x-LTS)
OS:           Windows 11 xx.x amd64
~~~

Observe que na linha **JVM** o Gradle já detectou automaticamente o Java 21 instalado. Isso confirma que o `JAVA_HOME` está configurado corretamente.

[Voltar ao Índice](#índice)

---

### Passo 5: Instalando e configurando o VS Code

Acesse **https://code.visualstudio.com** e clique em **"Download for Windows"**. Execute o instalador baixado e siga o assistente. Na tela de opções adicionais, marque **"Adicionar ao PATH"** e **"Adicionar opção 'Abrir com Code' ao menu de contexto"**. Conclua a instalação e abra o VS Code.

Com o VS Code aberto, pressione `Ctrl + Shift + X` para abrir o painel de extensões. No campo de busca, procure e instale as três extensões a seguir:

**Extension Pack for Java** (publicado por Microsoft): Digite `Extension Pack for Java` na busca, localize a extensão com o ícone de xícara de café e o publicador **Microsoft**, e clique em **Install**. Esta instalação pode demorar alguns minutos pois instala seis extensões em conjunto.

**Gradle for Java** (publicado por Microsoft): Digite `Gradle for Java` na busca, localize a extensão com o publicador **Microsoft** e clique em **Install**.

**XML** (publicado por Red Hat): Digite `XML` na busca, localize a extensão com o publicador **Red Hat** — o nome completo é "XML Language Support by Red Hat" — e clique em **Install**.

Após instalar as três extensões, abra a pasta do projeto no VS Code. No terminal do PowerShell, navegue até a pasta `taskflow/` e execute:

~~~
code .
~~~

O VS Code abrirá com a pasta `taskflow/` como workspace. Na primeira vez que abrir um projeto Java, o VS Code pode exibir uma notificação perguntando se deseja configurar o projeto — clique em **Yes** ou **Configure** quando solicitado.

[Voltar ao Índice](#índice)

---

### Passo 6: Verificando o ambiente completo

Abra o terminal integrado do VS Code pressionando `` Ctrl + ` `` (acento grave) e execute os três comandos de verificação:

~~~
java --version
~~~

~~~
javac --version
~~~

~~~
gradle --version
~~~

Se os três comandos retornarem as versões esperadas, seu ambiente está 100% configurado e pronto para a Aula 3. Registre as versões em um arquivo de verificação:

~~~
echo "Java: $(java --version 2>&1 | head -1)" > ambiente.txt
echo "Gradle: $(gradle --version | grep '^Gradle')" >> ambiente.txt
echo "Ambiente configurado em: $(Get-Date)" >> ambiente.txt
~~~

Salve o arquivo `ambiente.txt` na pasta `aula_02/` do projeto.

[Voltar ao Índice](#índice)

---

## Glossário Técnico da Aula

**JDK (Java Development Kit):** Conjunto completo de ferramentas para desenvolver aplicações Java. Inclui o compilador `javac`, a JVM, o interpretador `java` e bibliotecas padrão. Necessário para quem desenvolve (não apenas executa) programas Java.

**JRE (Java Runtime Environment):** Subconjunto do JDK que contém apenas o necessário para *executar* programas Java. Não inclui o compilador. Não é suficiente para desenvolvimento.

**JVM (Java Virtual Machine):** A máquina virtual que executa o bytecode Java. É o que torna o Java multiplataforma: o mesmo bytecode compilado roda em qualquer sistema operacional que tenha uma JVM instalada.

**LTS (Long-Term Support):** Versões do Java que recebem suporte e atualizações de segurança por um período estendido (geralmente 8 anos). São as versões recomendadas para projetos sérios. Java 11, 17 e 21 são as versões LTS mais recentes.

**Adoptium / Eclipse Temurin:** Distribuição gratuita e de código aberto do JDK, mantida pela Eclipse Foundation. Totalmente compatível com o Java oficial da Oracle, sem custos de licenciamento.

**Gradle:** Ferramenta de automação de build para projetos Java (e outras linguagens). Gerencia dependências, compila código, executa testes e empacota a aplicação. Usa arquivos `build.gradle` escritos em Groovy ou Kotlin DSL.

**Build:** O processo de transformar código-fonte em um artefato executável ou deployável. Para aplicações web Jakarta EE, o resultado do build é um arquivo WAR.

**WAR (Web Application Archive):** Arquivo compactado (semelhante a um ZIP) que contém todos os arquivos de uma aplicação web Java: classes compiladas, arquivos JSP, recursos estáticos e arquivos de configuração. É o formato que o GlassFish usa para deploy.

**Variável de ambiente:** Valor nomeado armazenado pelo sistema operacional, acessível por todos os processos em execução. Usadas para configurar comportamentos globais, como onde encontrar executáveis (`PATH`) ou onde está instalado o Java (`JAVA_HOME`).

**JAVA_HOME:** Variável de ambiente que aponta para a pasta raiz da instalação do JDK. Usada pelo Gradle e outras ferramentas para localizar o Java.

**PATH:** Variável de ambiente que contém uma lista de pastas onde o sistema operacional procura por executáveis. Adicionar a pasta `bin` do JDK ao PATH permite usar `java` e `javac` no terminal de qualquer lugar.

**Extension Pack for Java:** Conjunto de extensões para o VS Code que adiciona suporte completo ao desenvolvimento Java: autocompletar, depurador, suporte a Gradle/Maven e executor de testes.

**VS Code (Visual Studio Code):** Editor de código gratuito e de código aberto desenvolvido pela Microsoft. Altamente extensível e o mais popular entre desenvolvedores de software atualmente.

[Voltar ao Índice](#índice)

---

## Antecipação de Erros

**`'java' não é reconhecido como um comando interno ou externo`:** Este é o erro mais comum. Significa que a pasta `bin` do JDK não está no `PATH` ou que o `JAVA_HOME` não está configurado corretamente. Verifique as variáveis de ambiente conforme o Passo 2 e certifique-se de ter fechado e reaberto o terminal após as alterações — variáveis de ambiente só são carregadas em sessões novas do terminal.

**Versão errada do Java ao executar `java --version`:** Pode acontecer se você tiver múltiplas versões do Java instaladas no Windows. O sistema usa a primeira versão encontrada no `PATH`. Verifique se `%JAVA_HOME%\bin` aparece *antes* de outros caminhos Java na variável `PATH`. Para projetos Jakarta EE 11, é obrigatório o Java 21 ou superior.

**`'gradle' não é reconhecido como um comando interno ou externo`:** Significa que a pasta `bin` do Gradle não foi adicionada ao `PATH`. Verifique o Passo 4 e confirme que o caminho adicionado aponta para a pasta `bin` dentro da pasta do Gradle (ex: `C:\ferramentas\gradle-8.x\bin`), não para a pasta raiz.

**VS Code não reconhece os arquivos Java:** Significa que as extensões Java não estão instaladas ou não foram ativadas. Verifique se o **Extension Pack for Java** aparece na lista de extensões instaladas (ícone de extensões no menu lateral, aba "Installed"). Se estiver com o status "disabled", clique em **Enable**.

**Gradle não encontra o Java (`Could not determine java version`):** Ocorre quando o `JAVA_HOME` não está configurado. Confirme a variável de ambiente conforme o Passo 2. Você também pode configurar o Java para o Gradle especificamente criando um arquivo `gradle.properties` na pasta do usuário (`C:\Users\SeuNome\.gradle\gradle.properties`) com o conteúdo `org.gradle.java.home=C:\\Program Files\\Eclipse Adoptium\\jdk-21.x.x`.

**Instalação do JDK em pasta com espaços no nome:** Evite instalar o JDK em caminhos com espaços (como `C:\Program Files (x86)\Java\...`). Prefira caminhos simples como `C:\ferramentas\jdk-21`. Alguns scripts e ferramentas têm problemas com espaços nos caminhos.

[Voltar ao Índice](#índice)

---

## Exercício de Fixação

Este exercício valida que seu ambiente está completamente funcional e que você entende o papel de cada ferramenta instalada. Execute cada etapa e registre os resultados.

**Etapa 1:** Abra o PowerShell e execute os três comandos de verificação. Copie a saída completa de cada um para um arquivo `aula_02/exercicio_02.txt`.

~~~
java --version
javac --version
gradle --version
~~~

**Etapa 2:** Ainda no PowerShell, execute o comando abaixo para descobrir onde o Windows está encontrando o executável `java`:

~~~
where java
~~~

O resultado deve apontar para dentro da pasta do JDK 21 que você instalou. Registre o caminho no arquivo `exercicio_02.txt`.

**Etapa 3:** Abra o VS Code, pressione `Ctrl + Shift + P` para abrir a paleta de comandos, digite `Java: Configure Java Runtime` e pressione Enter. Uma aba abrirá mostrando o Java detectado pelo VS Code. Confirme que aparece o Java 21 e registre no arquivo.

**Etapa 4:** Responda no arquivo `exercicio_02.txt`: em suas próprias palavras, qual é a diferença entre o JDK e o JRE? Por que precisamos do JDK completo e não apenas do JRE para desenvolver?

Ao final, faça o commit do arquivo de exercício:

~~~
git add aula_02/exercicio_02.txt
git commit -m "docs: registra verificacao do ambiente - aula 02"
~~~

[Voltar ao Índice](#índice)

---

## Resolução Comentada do Exercício

**Etapa 1 e 2:** Se os três comandos retornaram versões e o `where java` apontou para a pasta do JDK 21, o ambiente está correto. Se o `where java` apontou para um caminho diferente (como `C:\Windows\System32\java.exe`), significa que há outro Java no PATH com prioridade maior — reordene as entradas do PATH para que `%JAVA_HOME%\bin` apareça primeiro.

**Etapa 3:** O VS Code detecta o Java através do `JAVA_HOME` e do `PATH`. Se ele não detectou automaticamente, use `Ctrl + Shift + P` → `Java: Configure Java Runtime` → **Add JDK** e aponte manualmente para a pasta do JDK 21.

**Etapa 4:** O **JRE** contém apenas a JVM e as bibliotecas necessárias para *executar* programas Java já compilados. É o que um usuário final precisa para rodar uma aplicação. O **JDK** contém o JRE *mais* o compilador `javac` (que transforma `.java` em `.class`), ferramentas de depuração, geração de documentação e outras utilidades. Como desenvolvedores, precisamos compilar nosso próprio código — portanto, precisamos do JDK completo.

[Voltar ao Índice](#índice)

---

## Resumo dos Pontos-Chave

O ambiente de desenvolvimento para este curso é composto por três camadas: o **Java 21 JDK** (Adoptium Temurin), que é a fundação sobre a qual tudo roda; o **Gradle**, que automatiza o build, gerencia dependências e empacota a aplicação; e o **VS Code** com as extensões **Extension Pack for Java**, **Gradle for Java** e **XML**. As **variáveis de ambiente** `JAVA_HOME` e `PATH` são o mapa que permite ao Windows encontrar os executáveis `java`, `javac` e `gradle` de qualquer lugar no terminal. O ambiente está correto quando os três comandos de verificação (`java --version`, `javac --version`, `gradle --version`) retornam as versões esperadas no terminal integrado do VS Code. O GlassFish 7 será instalado na Aula 4, quando tivermos um projeto para deployar.

[Voltar ao Índice](#índice)

---

## Log de Estado do Projeto

~~~text
## Aula 2: Configurando o ambiente de desenvolvimento no Windows 11
- Objetivo: Instalar e verificar Java 21, Gradle e VS Code com extensões essenciais.
- Código Adicionado: Nenhum código Java. Arquivo aula_02/exercicio_02.txt com verificações do ambiente.
- Estado Funcional: ✅ Ambiente configurado. java --version, javac --version e gradle --version funcionando.
- Próximas Etapas: Aula 3 criará a estrutura do projeto Gradle com as dependências do Jakarta EE 11.
~~~

[Voltar ao Índice](#índice)

---

## Prompt de Continuidade para a Aula 3

"Sou aluno do curso Jakarta EE 11 com Java 21, Gradle, JUnit 5 e VS Code. Concluí a Aula 2 (Configurando o ambiente de desenvolvimento no Windows 11). O ambiente está 100% funcional: Java 21, Gradle e VS Code com extensões instalados e verificados. Tenho o plano_mestre.txt, o log_estado_projeto.md e os prompts_individuais.md em anexo para contexto. Por favor, gere a **Aula 3: Seu primeiro projeto Jakarta EE com Gradle**, seguindo rigorosamente a estrutura definida no plano mestre: teoria detalhada com mínimo de 2.000 palavras, analogia de ancoragem, diagrama Mermaid com blocos ~~~mermaid, código comentado linha a linha com blocos ~~~, glossário técnico, antecipação de erros, exercício com resolução comentada, resumo dos pontos-chave, log de estado do projeto atualizado e prompt de continuidade para a Aula 4. O documento inteiro deve estar dentro de um bloco ```markdown. Nenhum bloco interno deve usar triple backtick."

[Voltar ao Índice](#índice)

---

Dúvidas? Posso prosseguir para a **Aula 3: Seu primeiro projeto Jakarta EE com Gradle**?