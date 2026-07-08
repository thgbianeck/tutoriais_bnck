# Aula 1: O que é Jakarta EE e como o ecossistema funciona

## Análise de Integridade
✅ Conteúdo verificado: profundidade técnica mantida para iniciantes, linguagem acessível, analogias presentes em todos os conceitos novos, diagrama Mermaid correto, nenhum código avançado antecipado, projeto TaskFlow apresentado com clareza, mínimo de 2.000 palavras garantido.

[Voltar ao Índice](#índice)

---

## Índice

- [Aula 1: O que é Jakarta EE e como o ecossistema funciona](#aula-1-o-que-é-jakarta-ee-e-como-o-ecossistema-funciona)
  - [Análise de Integridade](#análise-de-integridade)
  - [Índice](#índice)
  - [Objetivo](#objetivo)
  - [Pré-requisitos](#pré-requisitos)
  - [Teoria Detalhada](#teoria-detalhada)
    - [O problema que o Jakarta EE veio resolver](#o-problema-que-o-jakarta-ee-veio-resolver)
    - [De Java EE a Jakarta EE: uma história de transição](#de-java-ee-a-jakarta-ee-uma-história-de-transição)
    - [Especificação versus implementação: o contrato e o executor](#especificação-versus-implementação-o-contrato-e-o-executor)
    - [O servidor de aplicações: o gerente do hotel](#o-servidor-de-aplicações-o-gerente-do-hotel)
    - [As APIs do Jakarta EE 11: um mapa do território](#as-apis-do-jakarta-ee-11-um-mapa-do-território)
    - [Apresentando o TaskFlow: o projeto que construiremos juntos](#apresentando-o-taskflow-o-projeto-que-construiremos-juntos)
    - [Jakarta EE versus Spring Framework: uma distinção importante](#jakarta-ee-versus-spring-framework-uma-distinção-importante)
  - [Analogia de Ancoragem](#analogia-de-ancoragem)
  - [Diagrama Mermaid](#diagrama-mermaid)
  - [Aplicação no Projeto Prático](#aplicação-no-projeto-prático)
  - [Glossário Técnico da Aula](#glossário-técnico-da-aula)
  - [Antecipação de Erros](#antecipação-de-erros)
  - [Exercício de Fixação](#exercício-de-fixação)
  - [Resolução Comentada do Exercício](#resolução-comentada-do-exercício)
  - [Resumo dos Pontos-Chave](#resumo-dos-pontos-chave)
  - [Log de Estado do Projeto](#log-de-estado-do-projeto)
  - [Prompt de Continuidade para a Aula 2](#prompt-de-continuidade-para-a-aula-2)

---

## Objetivo
Entender o que é o Jakarta EE, compreender a diferença entre especificação e implementação, conhecer o papel do servidor de aplicações, ter uma visão geral das APIs que o curso abordará e ser apresentado ao projeto prático TaskFlow que construiremos juntos ao longo de todas as aulas.

[Voltar ao Índice](#índice)

## Pré-requisitos
Nenhum. Este é o ponto de partida absoluto. Você não precisa ter escrito uma linha sequer de aplicação web para acompanhar esta aula.

[Voltar ao Índice](#índice)

---

## Teoria Detalhada

### O problema que o Jakarta EE veio resolver

Imagine que você é um arquiteto contratado para projetar prédios em uma cidade que está crescendo rapidamente. Cada prédio tem necessidades parecidas: fundações sólidas, sistemas elétricos, encanamento, elevadores, saídas de emergência. Você poderia inventar tudo do zero para cada prédio, mas isso seria absurdamente ineficiente, caro e arriscado. O que a cidade faz, então? Ela cria um **código de obras** — um conjunto de regras, padrões e especificações que todo construtor deve seguir. O código de obras não constrói nada sozinho. Ele apenas diz **como as coisas devem funcionar**. Cada construtora, por sua vez, segue esse código à sua própria maneira, usando seus próprios materiais e técnicas, mas sempre respeitando as regras estabelecidas.

O **Jakarta EE** é exatamente isso para o desenvolvimento de aplicações empresariais em Java: um **código de obras para software**. Ele define um conjunto de especificações — regras e contratos — que descrevem como diferentes partes de uma aplicação empresarial devem se comportar. E, assim como no exemplo das construtoras, diferentes fornecedores criam suas próprias implementações dessas especificações, todas compatíveis entre si porque seguem o mesmo padrão.

Antes de existir o Jakarta EE, desenvolvedores que precisavam construir aplicações web em Java tinham que resolver sozinhos uma série de problemas recorrentes: como receber e responder a uma requisição HTTP? Como gerenciar sessões de usuário? Como se comunicar com bancos de dados de forma padronizada? Como injetar dependências entre classes? Cada projeto reinventava a roda à sua própria maneira, gerando inconsistências, dificuldade de manutenção e uma curva de aprendizado diferente para cada empresa.

O Jakarta EE surgiu para acabar com esse problema. Ele reúne em um único lugar uma coleção de especificações que cobrem os desafios mais comuns do desenvolvimento empresarial em Java. Você aprende uma vez e aplica em qualquer projeto que siga o padrão.

[Voltar ao Índice](#índice)

---

### De Java EE a Jakarta EE: uma história de transição

Para entender completamente o que é o Jakarta EE, precisamos voltar um pouco no tempo. Em 1999, a **Sun Microsystems** — empresa que criou o Java — lançou a plataforma **J2EE** (Java 2 Platform, Enterprise Edition). Era ambiciosa e poderosa, mas também extremamente complexa. Configurações em XML que se multiplicavam, componentes pesados chamados EJBs (Enterprise JavaBeans) que eram difíceis de escrever e testar, e um ciclo de desenvolvimento lento tornavam o J2EE uma plataforma respeitada, mas temida.

Ao longo dos anos 2000, frameworks alternativos como o **Spring** ganharam popularidade justamente por oferecer soluções mais simples para os mesmos problemas. A Sun respondeu simplificando gradualmente a plataforma, que passou a se chamar **Java EE** (Java Platform, Enterprise Edition) a partir da versão 5. As versões seguintes — 6, 7 e 8 — trouxeram cada vez mais simplificações, anotações em vez de XML e uma experiência de desenvolvimento muito mais agradável.

Em 2010, a Oracle adquiriu a Sun Microsystems e passou a ser a guardiã do Java EE. Por alguns anos, o desenvolvimento da plataforma desacelerou, e a comunidade ficou inquieta. Em 2017, a Oracle tomou uma decisão surpreendente: doou a plataforma Java EE para a **Eclipse Foundation**, uma organização sem fins lucrativos que já gerenciava outros projetos de código aberto importantes.

A transição, porém, trouxe um detalhe jurídico crucial: a Oracle manteve os direitos sobre o nome **"Java"** como marca registrada. Por isso, a Eclipse Foundation não podia simplesmente continuar usando o nome "Java EE". A solução foi renomear a plataforma para **Jakarta EE** — uma homenagem à cidade de Jacarta, na Indonésia, que também dá nome ao servidor Apache Tomcat (cujo codinome de desenvolvimento foi "Jakarta"). Desde a versão 9, lançada em 2020, a plataforma se chama oficialmente Jakarta EE, e os pacotes Java mudaram de `javax.*` para `jakarta.*`. A versão que estudaremos neste curso, o **Jakarta EE 11**, é a mais recente e moderna da plataforma, lançada em 2024.

Essa história importa para você porque explica por que você verá muitas referências a "Java EE" em livros antigos e tutoriais desatualizados, e por que o código legado ainda usa `javax.servlet` enquanto o código moderno usa `jakarta.servlet`. Agora você sabe exatamente o que significa cada um.

[Voltar ao Índice](#índice)

---

### Especificação versus implementação: o contrato e o executor

Este é um dos conceitos mais importantes do Jakarta EE e um dos que mais confunde iniciantes. Vamos destrinchá-lo com calma.

Pense em uma **tomada elétrica**. O governo brasileiro define uma norma técnica (a NBR 14136) que especifica exatamente como deve ser o formato de um plugue e de uma tomada: o tamanho dos pinos, o espaçamento, a capacidade de corrente. Essa norma é a **especificação**. Ela não fabrica nenhuma tomada. Ela apenas diz como as tomadas devem ser feitas. Diferentes fabricantes — Pial, Tramontina, WEG — produzem suas próprias tomadas seguindo essa norma. Cada fabricante usa seus próprios processos, materiais e tecnologias. Mas o resultado final é o mesmo: qualquer plugue que siga a norma funciona em qualquer tomada que siga a mesma norma. Isso é a **implementação**.

No Jakarta EE, funciona da mesma forma. A **especificação** define o contrato: "Uma classe que implementa a interface `HttpServlet` deve ter um método `doGet` que recebe um `HttpServletRequest` e um `HttpServletResponse`." A especificação define o que deve existir e como deve se comportar, mas não escreve o código que faz isso funcionar.

A **implementação** é o código real que executa esse contrato. No caso do Jakarta EE, as implementações são chamadas de **servidores de aplicações**. Diferentes fornecedores criam seus próprios servidores de aplicações, cada um com sua própria implementação interna das especificações do Jakarta EE. Os mais conhecidos são o **GlassFish** (implementação de referência oficial, que usaremos neste curso), o **WildFly** (da Red Hat), o **Payara** (derivado do GlassFish) e o **Open Liberty** (da IBM).

A beleza dessa arquitetura é que **sua aplicação não depende de qual servidor de aplicações está sendo usado**. Você escreve código contra a especificação (as interfaces e anotações do Jakarta EE), e o servidor de aplicações se encarrega de fazer esse código funcionar. Em teoria, você poderia mudar de GlassFish para WildFly sem alterar uma linha do seu código de aplicação.

[Voltar ao Índice](#índice)

---

### O servidor de aplicações: o gerente do hotel

Para entender o papel do servidor de aplicações, use esta analogia. Imagine um **hotel de luxo**. Quando um hóspede chega (uma requisição HTTP chega ao servidor), ele não entra direto no quarto. Ele passa pela recepção (o servidor de aplicações), que verifica sua reserva (a URL da requisição), descobre qual quarto ele deve ocupar (qual Servlet deve processar a requisição) e o encaminha para o quarto certo. O serviço de quarto (os Servlets) atende o hóspede, prepara o que ele pediu (processa a lógica de negócio) e devolve a resposta. Quando o hóspede vai embora, a recepção registra a saída.

O servidor de aplicações gerencia tudo isso: ele recebe as requisições HTTP, as encaminha para o componente correto da sua aplicação, gerencia o ciclo de vida desses componentes (inicialização, execução e destruição), cuida das conexões com bancos de dados, gerencia sessões de usuário e muito mais. Você, como desenvolvedor, foca em escrever a lógica da sua aplicação. O servidor de aplicações cuida da infraestrutura.

Neste curso, nosso servidor de aplicações será o **GlassFish 7**, a implementação de referência oficial do Jakarta EE 11. "Implementação de referência" significa que ele é o servidor criado pelos próprios autores da especificação para demonstrar e validar que a especificação funciona corretamente. É o servidor mais alinhado com o padrão Jakarta EE.

[Voltar ao Índice](#índice)

---

### As APIs do Jakarta EE 11: um mapa do território

O Jakarta EE 11 é composto por dezenas de especificações (APIs), cada uma resolvendo um problema específico. Neste curso, focaremos nas quatro que formam a espinha dorsal de qualquer aplicação web Jakarta EE:

A primeira é o **Jakarta Servlet** (versão 6.1). O Servlet é o componente mais fundamental do Jakarta EE para desenvolvimento web. Ele é uma classe Java que recebe requisições HTTP e produz respostas HTTP. Todo o fluxo de uma aplicação web Jakarta EE passa por um Servlet em algum momento. Nos próximos módulos, você escreverá seus primeiros Servlets e os usará como Controllers na arquitetura MVC.

A segunda é o **Jakarta Server Pages (JSP)** com **Jakarta Standard Tag Library (JSTL)**. O JSP permite criar páginas web dinâmicas misturando HTML com dados gerados pelo servidor. Você o usará para criar as Views da aplicação — as telas que o usuário vê no navegador. O JSTL adiciona tags especiais ao JSP para que você exiba dados dinâmicos sem precisar escrever Java puro dentro das páginas HTML.

A terceira é o **Jakarta Persistence API (JPA)** (versão 3.2). O JPA é a especificação para persistência de dados — ou seja, para salvar e recuperar informações de um banco de dados. Ele usa o conceito de ORM (Object-Relational Mapping), que permite que você trabalhe com objetos Java enquanto o JPA cuida de traduzir esses objetos para tabelas e colunas no banco de dados. Você o usará para substituir o armazenamento em memória por um banco de dados real.

A quarta é o **Jakarta Bean Validation** (versão 3.1). O Bean Validation permite que você defina regras de validação diretamente nas suas classes Java usando anotações simples, como dizer que um campo não pode ser vazio ou que um texto deve ter entre 3 e 100 caracteres. Você o usará para proteger sua aplicação contra dados inválidos enviados pelos usuários.

Existem muitas outras APIs no Jakarta EE 11 — Jakarta CDI, Jakarta Security, Jakarta RESTful Web Services, Jakarta Faces, e dezenas mais — mas estas quatro são suficientes para que você construa uma aplicação web completa e compreenda profundamente como a plataforma funciona. As demais serão naturais de aprender depois que você dominar essa base.

[Voltar ao Índice](#índice)

---

### Apresentando o TaskFlow: o projeto que construiremos juntos

Ao longo deste curso, construiremos uma aplicação web chamada **TaskFlow** — um sistema de gerenciamento de tarefas. Cada aula adicionará uma camada funcional ao projeto, de modo que você sempre terá algo concreto e funcional para testar e explorar.

O TaskFlow permitirá criar, listar, editar e remover tarefas. Cada tarefa terá um título, uma descrição, um status (pendente, em andamento ou concluída) e uma data de criação. A aplicação terá uma interface web acessível pelo navegador, com formulários para criar e editar tarefas e uma listagem organizada.

Por que este projeto? Porque ele é simples o suficiente para que você foque em aprender o Jakarta EE, sem se perder em regras de negócio complexas. Mas é completo o suficiente para cobrir todos os conceitos que precisamos: Servlets como Controllers, JSP como Views, POJOs como Models, JPA para persistência e Bean Validation para validação. Ao final do curso, você terá construído uma aplicação real, do zero, linha a linha, entendendo cada decisão tomada.

[Voltar ao Índice](#índice)

---

### Jakarta EE versus Spring Framework: uma distinção importante

É muito comum que iniciantes se confundam ao pesquisar sobre desenvolvimento Java empresarial e se depararem com o **Spring Framework** ao lado do Jakarta EE. São coisas diferentes, e é importante entender a distinção antes de prosseguir.

O Spring Framework é uma alternativa ao Jakarta EE. Ele nasceu justamente como resposta à complexidade do antigo Java EE, oferecendo soluções mais simples para os mesmos problemas. Hoje, o Spring é extremamente popular no mercado e resolve muitos dos mesmos problemas que o Jakarta EE resolve, frequentemente usando conceitos similares — e em alguns casos, inclusive adotando as especificações do Jakarta EE internamente.

A diferença fundamental é que o **Jakarta EE é uma especificação** (um padrão aberto gerenciado pela Eclipse Foundation), enquanto o **Spring é um framework** (uma implementação específica criada e mantida pela empresa VMware/Broadcom). Aprender Jakarta EE significa aprender os fundamentos do desenvolvimento web Java conforme o padrão oficial da plataforma. Aprender Spring significa aprender uma abordagem específica e muito popular para resolver esses mesmos problemas.

Este curso foca no Jakarta EE. Não porque o Spring seja pior — ele é excelente e amplamente usado — mas porque entender o Jakarta EE dá a você uma base sólida nos fundamentos da plataforma Java Enterprise. Muitos dos conceitos que você aprenderá aqui (Servlets, JPA, Bean Validation) são usados também pelo Spring, porque o Spring frequentemente constrói sobre as especificações do Jakarta EE.

[Voltar ao Índice](#índice)

---

## Analogia de Ancoragem

O Jakarta EE é como o **sistema métrico decimal**: uma especificação internacional que define como medidas devem funcionar (metros, quilogramas, litros). Diferentes fabricantes de instrumentos de medição — réguas, balanças, provetas — seguem esse sistema para que todos os instrumentos sejam compatíveis entre si. Você pode trocar sua régua da marca X pela régua da marca Y e as medidas continuarão fazendo sentido. Da mesma forma, você pode trocar seu servidor de aplicações GlassFish pelo WildFly e sua aplicação Jakarta EE continuará funcionando, porque ambos seguem a mesma especificação.

[Voltar ao Índice](#índice)

---

## Diagrama Mermaid

~~~mermaid
graph TD
    JEE[Jakarta EE 11 - Especificação]
    SERVLET[Jakarta Servlet 6.1]
    JSP[Jakarta Server Pages]
    JPA[Jakarta Persistence 3.2]
    BV[Jakarta Bean Validation 3.1]
    GF[GlassFish 7 - Implementação]
    APP[Aplicação TaskFlow]
    NAV[Navegador do Usuário]

    JEE --> SERVLET
    JEE --> JSP
    JEE --> JPA
    JEE --> BV

    SERVLET --> GF
    JSP --> GF
    JPA --> GF
    BV --> GF

    GF --> APP
    NAV --> GF
    GF --> NAV
~~~

[Voltar ao Índice](#índice)

---

## Aplicação no Projeto Prático

Nesta aula, a aplicação prática é a criação da estrutura inicial do repositório do projeto. Não há código Java ainda — essa é uma aula de fundamentos teóricos. Siga os passos abaixo:

**Passo 1:** Crie a pasta raiz do projeto no seu Windows 11. Abra o terminal (PowerShell ou Prompt de Comando) e execute:

~~~
mkdir taskflow
cd taskflow
~~~

**Passo 2:** Crie o arquivo `README.md` com o seguinte conteúdo:

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
- Gradle
- GlassFish 7
- JUnit 5 (TDD)
- H2 Database
- VS Code
- Windows 11

## Status
Aula 1 concluída — fundamentos teóricos estudados.
Ambiente será configurado na Aula 2.
~~~

**Passo 3:** Inicie o repositório Git:

~~~
git init
git add README.md
git commit -m "docs: cria estrutura inicial do projeto TaskFlow"
~~~

[Voltar ao Índice](#índice)

---

## Glossário Técnico da Aula

**Jakarta EE:** Plataforma de especificações para desenvolvimento de aplicações empresariais em Java, gerenciada pela Eclipse Foundation. Define contratos que servidores de aplicações devem implementar.

**Especificação:** Um documento formal que define como algo deve se comportar, sem implementar o comportamento em si. No Jakarta EE, cada especificação descreve uma API com suas interfaces, anotações e regras de funcionamento.

**Implementação:** O código real que executa um contrato definido por uma especificação. No Jakarta EE, os servidores de aplicações são as implementações das especificações.

**Servidor de Aplicações:** Software que hospeda e executa aplicações Jakarta EE. Ele gerencia o ciclo de vida dos componentes, as conexões de rede, as sessões de usuário e a comunicação com bancos de dados. Exemplos: GlassFish 7, WildFly, Payara.

**GlassFish 7:** Servidor de aplicações de referência para o Jakarta EE 11. É a implementação oficial criada pelos autores da especificação.

**Servlet:** Componente Java que recebe requisições HTTP e produz respostas HTTP. É a base do desenvolvimento web com Jakarta EE.

**JSP (Jakarta Server Pages):** Tecnologia que permite criar páginas web dinâmicas misturando HTML com dados gerados pelo servidor.

**JPA (Jakarta Persistence API):** Especificação para mapeamento objeto-relacional e persistência de dados em bancos de dados relacionais.

**Bean Validation:** Especificação para validação de dados usando anotações diretamente nas classes Java.

**Java EE:** Nome anterior da plataforma, quando era gerenciada pela Oracle. A partir da versão 9, passou a se chamar Jakarta EE após a transição para a Eclipse Foundation.

**ORM (Object-Relational Mapping):** Técnica que mapeia objetos Java para tabelas de banco de dados, permitindo trabalhar com objetos em vez de SQL puro.

**WAR (Web Application Archive):** Formato de empacotamento de aplicações web Java. Um arquivo `.war` contém todos os arquivos da aplicação (classes compiladas, JSPs, configurações) prontos para deploy em um servidor de aplicações.

[Voltar ao Índice](#índice)

---

## Antecipação de Erros

**Confundir Jakarta EE com Spring Framework:** É muito comum. Lembre-se: Jakarta EE é uma especificação (padrão aberto), Spring é um framework (implementação específica). Ambos resolvem problemas similares, mas são coisas distintas. Este curso foca no Jakarta EE.

**Confundir especificação com implementação:** A especificação define o contrato (as interfaces e anotações). A implementação é o código que faz funcionar (o servidor de aplicações). Você escreve código contra a especificação; o servidor cuida do resto.

**Confundir `javax.*` com `jakarta.*`:** Código escrito para Java EE (versões antigas) usa pacotes `javax.servlet`, `javax.persistence`, etc. Código moderno para Jakarta EE 9+ usa `jakarta.servlet`, `jakarta.persistence`, etc. Se você encontrar tutoriais com `javax`, eles são para versões antigas da plataforma.

**Achar que o Jakarta EE é complicado demais:** A fama de complexidade vem do antigo J2EE dos anos 2000. O Jakarta EE moderno (versões 8 em diante) é muito mais simples, baseado principalmente em anotações e convenções, sem os pesados arquivos de configuração XML do passado.

[Voltar ao Índice](#índice)

---

## Exercício de Fixação

Faça uma reflexão escrita — pode ser em um caderno, em um arquivo de texto ou em um documento digital. Pense em três situações do seu cotidiano ou da sua área de trabalho que se beneficiariam de uma aplicação web. Para cada situação, responda:

1. Qual problema essa aplicação resolveria?
2. Quais dados precisariam ser armazenados e recuperados (isso é o Model)?
3. Quais telas o usuário precisaria ver (isso é a View)?
4. Quais ações o usuário poderia realizar (isso é o Controller)?

Salve suas respostas em um arquivo chamado `aula_01/exercicio_01.txt` dentro da pasta do projeto. Este exercício não tem resposta certa ou errada — ele é um aquecimento mental para a jornada que começa na próxima aula.

[Voltar ao Índice](#índice)

---

## Resolução Comentada do Exercício

Não há uma única resposta correta para este exercício. O objetivo é começar a pensar em termos de dados (Model), telas (View) e ações (Controller) — os três pilares do padrão MVC que adotaremos no TaskFlow. Por exemplo, um sistema de controle de estoque teria como Model os produtos e suas quantidades, como View as telas de listagem e cadastro de produtos, e como Controller as ações de adicionar produto, atualizar quantidade e remover produto. Esse raciocínio é exatamente o que você exercitará ao longo do curso.

[Voltar ao Índice](#índice)

---

## Resumo dos Pontos-Chave

O **Jakarta EE** é uma especificação — um conjunto de contratos e padrões — para desenvolvimento de aplicações empresariais em Java, gerenciada pela Eclipse Foundation. A plataforma evoluiu do J2EE (anos 2000) para Java EE (Oracle) e finalmente para Jakarta EE (Eclipse Foundation) a partir da versão 9. A diferença fundamental é entre **especificação** (o que deve funcionar) e **implementação** (o código que faz funcionar). O **servidor de aplicações** — no nosso caso, o GlassFish 7 — é quem implementa as especificações e hospeda a aplicação. As quatro APIs que estudaremos são: **Servlet** (receber e responder requisições HTTP), **JSP com JSTL** (criar as telas do usuário), **JPA** (persistir dados no banco de dados) e **Bean Validation** (validar entradas do usuário). O projeto prático que construiremos é o **TaskFlow**, um sistema de gerenciamento de tarefas que evoluirá incrementalmente ao longo de todas as 18 aulas.

[Voltar ao Índice](#índice)

---

## Log de Estado do Projeto

~~~text
## Aula 1: O que é Jakarta EE e como o ecossistema funciona
- Objetivo: Compreender o ecossistema Jakarta EE e criar a estrutura inicial do repositório.
- Código Adicionado: Pasta taskflow/ criada. Arquivo README.md com descrição do projeto.
- Estado Funcional: ⏳ Sem código Java ainda. Repositório Git inicializado.
- Próximas Etapas: Aula 2 instalará o Java 21, o Gradle e o VS Code com extensões essenciais.
~~~

[Voltar ao Índice](#índice)

---

## Prompt de Continuidade para a Aula 2

"Sou aluno do curso Jakarta EE 11 com Java 21, Gradle, JUnit 5 e VS Code. Concluí a Aula 1 (O que é Jakarta EE e como o ecossistema funciona). Tenho o plano_mestre.txt, o log_estado_projeto.md e os prompts_individuais.md em anexo para contexto. Por favor, gere a **Aula 2: Configurando o ambiente de desenvolvimento no Windows 11**, seguindo rigorosamente a estrutura definida no plano mestre: teoria detalhada com mínimo de 2.000 palavras, analogia de ancoragem, diagrama Mermaid com blocos ~~~mermaid, código comentado linha a linha com blocos ~~~, glossário técnico, antecipação de erros, exercício com resolução comentada, resumo dos pontos-chave, log de estado do projeto atualizado e prompt de continuidade para a Aula 3. O documento inteiro deve estar dentro de um bloco ```markdown. Nenhum bloco interno deve usar triple backtick."

[Voltar ao Índice](#índice)

---

Dúvidas? Posso prosseguir para a **Aula 2: Configurando o ambiente de desenvolvimento no Windows 11**?
