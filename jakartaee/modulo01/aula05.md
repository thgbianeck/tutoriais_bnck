# Aula 5: Introdução aos Servlets: o coração do Jakarta EE Web

## Análise de Integridade
✅ Conteúdo verificado: profundidade técnica mantida para iniciantes, linguagem acessível, analogias presentes em todos os conceitos novos, ciclo de vida do Servlet explicado em detalhes, diagrama Mermaid correto, código comentado linha a linha, nenhum conceito avançado antecipado, mínimo de 2.000 palavras garantido.

---

## Índice

- [Aula 5: Introdução aos Servlets: o coração do Jakarta EE Web](#aula-5-introdução-aos-servlets-o-coração-do-jakarta-ee-web)
  - [Análise de Integridade](#análise-de-integridade)
  - [Índice](#índice)
  - [Objetivo](#objetivo)
  - [Pré-requisitos](#pré-requisitos)
  - [Resumo da Aula Anterior](#resumo-da-aula-anterior)
  - [Teoria Detalhada](#teoria-detalhada)
    - [O que é um Servlet e por que ele existe](#o-que-é-um-servlet-e-por-que-ele-existe)
    - [A hierarquia de classes: de Servlet a HttpServlet](#a-hierarquia-de-classes-de-servlet-a-httpservlet)
    - [O ciclo de vida do Servlet: nascimento, trabalho e morte](#o-ciclo-de-vida-do-servlet-nascimento-trabalho-e-morte)
    - [A anotação @WebServlet: registrando o Servlet no servidor](#a-anotação-webservlet-registrando-o-servlet-no-servidor)
    - [Como o GlassFish mapeia uma URL para um Servlet](#como-o-glassfish-mapeia-uma-url-para-um-servlet)
    - [Escrevendo a resposta HTTP: PrintWriter e setContentType](#escrevendo-a-resposta-http-printwriter-e-setcontenttype)
    - [O fluxo completo de uma requisição ao HelloServlet](#o-fluxo-completo-de-uma-requisição-ao-helloservlet)
  - [Analogia de Ancoragem](#analogia-de-ancoragem)
  - [Diagrama Mermaid](#diagrama-mermaid)
  - [Aplicação no Projeto Prático](#aplicação-no-projeto-prático)
    - [Passo 1: Criando o HelloServlet](#passo-1-criando-o-helloservlet)
    - [Passo 2: Gerando o WAR e fazendo o deploy](#passo-2-gerando-o-war-e-fazendo-o-deploy)
    - [Passo 3: Testando no navegador](#passo-3-testando-no-navegador)
    - [Passo 4: Commit do progresso](#passo-4-commit-do-progresso)
  - [Glossário Técnico da Aula](#glossário-técnico-da-aula)
  - [Antecipação de Erros](#antecipação-de-erros)
  - [Exercício de Fixação](#exercício-de-fixação)
  - [Resolução Comentada do Exercício](#resolução-comentada-do-exercício)
  - [Resumo dos Pontos-Chave](#resumo-dos-pontos-chave)
  - [Log de Estado do Projeto](#log-de-estado-do-projeto)
  - [Prompt de Continuidade para a Aula 6](#prompt-de-continuidade-para-a-aula-6)

---

## Objetivo
Entender o que é um Servlet, compreender em profundidade seu ciclo de vida completo (`init`, `service`, `destroy`), criar o primeiro Servlet do projeto TaskFlow com a anotação `@WebServlet`, entender como o GlassFish mapeia URLs para classes Java e fazer o servidor responder com conteúdo dinâmico gerado em Java ao navegador.

## Pré-requisitos
Aula 4 concluída. O GlassFish 7 está instalado em `C:\ferramentas\glassfish7\`, o domínio `domain1` inicia corretamente com `asadmin start-domain domain1` e o TaskFlow está deployado e acessível em `http://localhost:8080/taskflow` exibindo a página `index.html`.

---

## Resumo da Aula Anterior

Na Aula 4 você instalou o GlassFish 7, aprendeu sobre sua estrutura interna de domínios e instâncias, iniciou e parou o servidor via `asadmin`, fez o deploy do `taskflow.war` pelo console de administração em `http://localhost:4848` e pelo método `autodeploy`, e verificou que a aplicação responde em `http://localhost:8080/taskflow`. Até agora, a aplicação serve apenas arquivos estáticos — HTML sem nenhuma lógica Java. A partir desta aula, isso muda completamente.

---

## Teoria Detalhada

### O que é um Servlet e por que ele existe

Desde que a web surgiu, o desafio central do lado do servidor é sempre o mesmo: receber uma requisição de um usuário, processar alguma lógica e devolver uma resposta personalizada. Nos primeiros dias da web, essa lógica era feita com scripts CGI (Common Gateway Interface) — programas escritos em linguagens como Perl ou C que o servidor web executava para cada requisição. O problema do CGI era que cada requisição criava um novo processo do sistema operacional, o que era extremamente lento e consumia muitos recursos. Para mil usuários simultâneos, o servidor precisaria criar mil processos separados.

O Java trouxe uma solução muito mais eficiente: o **Servlet**. Em vez de criar um novo processo para cada requisição, o servidor de aplicações cria uma única instância da classe Servlet e a mantém em memória. Quando chegam múltiplas requisições simultâneas, o servidor cria **threads** leves — fluxos de execução dentro do mesmo processo — para atender cada uma delas. A mesma instância do Servlet atende todas as requisições, em threads separadas, sem o overhead de criar e destruir processos. Isso é dramaticamente mais eficiente.

Um **Servlet** é, em sua essência mais simples, uma **classe Java que sabe lidar com requisições HTTP**. Ele vive dentro do servidor de aplicações, aguarda requisições chegarem, as processa e produz respostas. O servidor de aplicações (no nosso caso, o GlassFish) é o responsável por criar o Servlet, mantê-lo em memória, chamar seus métodos no momento certo e eventualmente destruí-lo quando a aplicação for descarregada. Você, como desenvolvedor, escreve apenas a lógica de negócio — o que fazer quando uma requisição chega. O GlassFish cuida de todo o resto.

A especificação Jakarta Servlet (versão 6.1 no Jakarta EE 11) define exatamente como um Servlet deve se comportar: quais métodos deve ter, quando cada método é chamado, como acessar os dados da requisição e como escrever a resposta. Isso garante que seu código funcione da mesma forma no GlassFish, no WildFly ou em qualquer outro servidor que implemente a especificação.

---

### A hierarquia de classes: de Servlet a HttpServlet

A especificação Jakarta Servlet é organizada em uma hierarquia de interfaces e classes abstratas que você precisa conhecer para entender o que está herdando quando cria um Servlet.

No topo da hierarquia está a **interface `jakarta.servlet.Servlet`**. Ela define o contrato mais básico possível: qualquer componente que implemente essa interface e declare os métodos `init`, `service` e `destroy` é, tecnicamente, um Servlet. Essa interface é muito genérica — ela não sabe nada sobre HTTP, FTP ou qualquer protocolo específico. É apenas um contrato para "algo que recebe requisições e produz respostas".

Logo abaixo está a **classe abstrata `jakarta.servlet.GenericServlet`**, que implementa a interface `Servlet` e adiciona alguns comportamentos padrão, como acesso à configuração do Servlet e ao contexto da aplicação. Ainda não tem conhecimento sobre HTTP.

O que nos interessa diretamente é o próximo nível: a **classe abstrata `jakarta.servlet.http.HttpServlet`**. Ela herda de `GenericServlet` e adiciona todo o conhecimento sobre o protocolo HTTP. É ela que implementa o método `service` de forma inteligente: quando uma requisição chega, ela verifica o método HTTP da requisição (GET, POST, PUT, DELETE, etc.) e delega para o método correspondente: `doGet`, `doPost`, `doPut`, `doDelete`. Isso significa que você, ao criar seu próprio Servlet, apenas precisa **herdar de `HttpServlet`** e **sobrescrever os métodos** que interessam para a sua lógica — normalmente `doGet` e `doPost`.

Você nunca precisa chamar `service` diretamente. O GlassFish chama `service`, que por sua vez chama `doGet` ou `doPost` automaticamente dependendo do tipo da requisição. Sua responsabilidade é apenas implementar o que acontece dentro de `doGet` ou `doPost`.

---

### O ciclo de vida do Servlet: nascimento, trabalho e morte

O conceito mais importante desta aula é o **ciclo de vida do Servlet**. Entender quando cada método é chamado é fundamental para evitar erros sutis e para usar o Servlet de forma eficiente.

O ciclo de vida tem três fases bem definidas, cada uma com seu método correspondente.

A **primeira fase é a inicialização**, representada pelo método `init(ServletConfig config)`. Este método é chamado pelo GlassFish **uma única vez**, logo após o servidor criar a instância do Servlet — que geralmente acontece na primeira requisição para aquele Servlet, ou na inicialização da aplicação se você configurar `loadOnStartup`. O `init` é o lugar certo para fazer preparações que você quer fazer apenas uma vez: abrir conexões com banco de dados, carregar arquivos de configuração, inicializar caches. Se você não sobrescrever `init`, o `HttpServlet` tem uma implementação padrão que não faz nada — o que está correto para a maioria dos casos.

A **segunda fase é o atendimento de requisições**, representada pelo método `service`. Este método é chamado pelo GlassFish **para cada requisição que chega** ao Servlet. Como mencionado, você geralmente não sobrescreve `service` diretamente — sobrescreve `doGet`, `doPost`, etc. Esta fase dura enquanto a aplicação estiver no ar e recebendo requisições. Pode ser chamada milhares de vezes, por threads simultâneas, ao longo da vida do Servlet.

A **terceira fase é a destruição**, representada pelo método `destroy()`. Este método é chamado pelo GlassFish **uma única vez**, quando a aplicação está sendo descarregada — por exemplo, ao fazer undeploy, ao parar o servidor ou ao fazer redeploy. É o lugar certo para liberar recursos que foram alocados no `init`: fechar conexões com banco de dados, liberar caches, gravar logs de finalização.

Este ciclo é gerenciado inteiramente pelo servidor de aplicações. Você **nunca instancia um Servlet manualmente** com `new HelloServlet()`. O GlassFish controla quando o Servlet nasce e quando morre. Sua responsabilidade é apenas implementar o comportamento de cada fase.

Um detalhe crítico sobre **thread safety**: como o GlassFish usa **uma única instância** do Servlet para atender múltiplas requisições simultâneas em threads diferentes, você nunca deve guardar dados específicos de uma requisição como **atributos de instância** do Servlet. Se você fizer `this.nomeDoUsuario = request.getParameter("nome")`, duas requisições simultâneas poderão sobrescrever o mesmo atributo — causando bugs sutis e difíceis de reproduzir. Sempre use **variáveis locais** dentro dos métodos `doGet` e `doPost` para guardar dados específicos de uma requisição.

---

### A anotação @WebServlet: registrando o Servlet no servidor

Nos tempos do antigo Java EE, para registrar um Servlet você precisava configurá-lo manualmente no `web.xml` com várias linhas de XML: declarar o Servlet, dar um nome a ele, mapear o nome a uma URL. Era verboso e propenso a erros.

O Jakarta EE moderno simplificou isso drasticamente com a anotação **`@WebServlet`**. Você a coloca diretamente na classe Java do Servlet e o GlassFish a lê automaticamente ao fazer o deploy da aplicação. O parâmetro mais importante é o **`value`** (ou `urlPatterns`), que define qual URL (ou padrão de URL) deve ser mapeada para aquele Servlet.

Por exemplo, `@WebServlet("/hello")` diz ao GlassFish: "quando chegar uma requisição para `/hello` dentro da aplicação, encaminhe-a para esta classe". Com o context root `/taskflow`, a URL completa seria `http://localhost:8080/taskflow/hello`.

A anotação `@WebServlet` aceita vários parâmetros opcionais além do padrão de URL, como `name` (nome do Servlet), `loadOnStartup` (se deve ser inicializado junto com a aplicação, antes da primeira requisição) e `initParams` (parâmetros de inicialização). Para os propósitos desta aula, usaremos apenas o padrão de URL.

---

### Como o GlassFish mapeia uma URL para um Servlet

Quando o GlassFish faz o deploy de um WAR, ele realiza um processo chamado **scanning de anotações**: ele examina todos os arquivos `.class` dentro de `WEB-INF/classes/` procurando por classes anotadas com `@WebServlet`, `@WebFilter` e `@WebListener`. Para cada classe anotada com `@WebServlet`, ele registra internamente o mapeamento URL → classe.

Quando uma requisição HTTP chega — por exemplo, `GET /taskflow/hello` — o GlassFish primeiro identifica a aplicação pelo context root `/taskflow`. Depois, pega o caminho restante (`/hello`) e consulta o mapa de Servlets registrados para encontrar qual classe deve processar aquela requisição. Encontrando `HelloServlet`, ele verifica se já existe uma instância dela em memória. Se não, chama o construtor padrão (sem argumentos) para criar a instância e depois chama `init`. Se já existir, reutiliza a instância existente. Por fim, chama `service`, que delega para `doGet` (porque a requisição é do tipo GET).

Se nenhum Servlet estiver mapeado para a URL requisitada, o GlassFish retorna automaticamente um erro **HTTP 404 (Not Found)**. É por isso que errar o mapeamento na anotação é a causa mais comum de 404 ao desenvolver com Jakarta EE.

---

### Escrevendo a resposta HTTP: PrintWriter e setContentType

Dentro do método `doGet`, você tem acesso a dois objetos fundamentais: o `HttpServletRequest` (que representa a requisição que chegou) e o `HttpServletResponse` (que representa a resposta que você vai enviar de volta). Nesta aula, focaremos no `HttpServletResponse`.

A primeira coisa que você deve fazer ao escrever uma resposta é **definir o tipo de conteúdo** com `response.setContentType("text/html;charset=UTF-8")`. Esse método define o cabeçalho HTTP `Content-Type`, que diz ao navegador como interpretar o conteúdo que vai receber. `text/html` significa que o conteúdo é HTML. `charset=UTF-8` significa que o texto está codificado em UTF-8, o que garante que acentos e caracteres especiais do português sejam exibidos corretamente. Esta linha deve ser chamada **antes** de qualquer escrita no corpo da resposta.

Em seguida, você obtém um **`PrintWriter`** com `response.getWriter()`. O `PrintWriter` é um objeto de escrita de texto — funciona de forma muito similar ao `System.out` que você usa para imprimir no console, mas em vez de imprimir no terminal, ele escreve no corpo da resposta HTTP que será enviada ao navegador. Você usa `writer.println(...)` para escrever o conteúdo HTML linha a linha.

Uma boa prática é sempre fechar o `PrintWriter` ao final do método com `writer.close()`, sinalizando ao servidor que a resposta está completa. Embora o GlassFish feche automaticamente ao final do processamento, fechar explicitamente é uma boa prática de programação defensiva.

---

### O fluxo completo de uma requisição ao HelloServlet

Vamos traçar o caminho completo de uma requisição desde o navegador até a resposta, passo a passo, para consolidar tudo que foi explicado.

O usuário digita `http://localhost:8080/taskflow/hello` no navegador e pressiona Enter. O navegador cria uma requisição HTTP do tipo GET e a envia para o endereço `localhost` na porta `8080`. O GlassFish está escutando nessa porta e recebe a requisição. Ele identifica o context root `/taskflow` e encontra a aplicação TaskFlow. Pega o caminho restante `/hello` e consulta o mapa de Servlets — encontra que `HelloServlet` está mapeado para `/hello`. Verifica se existe uma instância de `HelloServlet` em memória. Na primeira requisição, não existe — ele cria uma instância chamando o construtor padrão e depois chama `init`. Chama `service` passando os objetos `request` e `response`. O `service` do `HttpServlet` verifica que o método HTTP é GET e chama `doGet`. Dentro do `doGet`, você define o `Content-Type`, obtém o `PrintWriter` e escreve o HTML da resposta. O GlassFish pega tudo que foi escrito no `PrintWriter`, monta a resposta HTTP completa com cabeçalhos e corpo, e a envia de volta ao navegador. O navegador recebe a resposta, interpreta o HTML e exibe a página.

Na segunda requisição para `/hello`, o GlassFish já tem a instância de `HelloServlet` em memória — ele pula a criação e o `init` e vai direto para `service`. Isso é significativamente mais rápido do que criar um novo objeto a cada requisição.

---

## Analogia de Ancoragem

Um Servlet é como um **funcionário de um balcão de atendimento**. Quando a empresa abre (deploy da aplicação), o funcionário chega ao trabalho e se prepara (`init`): organiza sua mesa, liga o computador, prepara os formulários. Durante todo o dia de trabalho, cada cliente que chega ao balcão é atendido por ele (`service` → `doGet` ou `doPost`): ele ouve o pedido, processa e entrega a resposta. O funcionário não muda — é sempre a mesma pessoa — mas ela atende um cliente após o outro. Quando a empresa fecha (undeploy), o funcionário finaliza o expediente (`destroy`): desliga o computador, guarda os materiais, deixa tudo em ordem para o dia seguinte. O gerente do restaurante (GlassFish) decide quando o funcionário começa, quando atende cada cliente e quando encerra o expediente — o funcionário apenas faz seu trabalho.

---

## Diagrama Mermaid

~~~mermaid
sequenceDiagram
    participant NAV as Navegador
    participant GF as GlassFish 7
    participant CONT as Container de Servlets
    participant HS as HelloServlet

    NAV->>GF: GET /taskflow/hello
    GF->>CONT: Identifica aplicação taskflow
    CONT->>CONT: Consulta mapa de Servlets para /hello

    alt Primeira requisição
        CONT->>HS: new HelloServlet()
        CONT->>HS: init()
    end

    CONT->>HS: service(request, response)
    HS->>HS: doGet(request, response)
    HS->>HS: response.setContentType()
    HS->>HS: writer.println(HTML)
    HS-->>CONT: resposta HTML pronta
    CONT-->>GF: resposta HTTP 200 OK
    GF-->>NAV: HTML renderizado no navegador
~~~

---

## Aplicação no Projeto Prático

### Passo 1: Criando o HelloServlet

Certifique-se de que o GlassFish está rodando (`asadmin start-domain domain1`). Abra o VS Code na pasta `taskflow/`. Crie o arquivo `src/main/java/com/taskflow/controller/HelloServlet.java` com o seguinte conteúdo:

~~~java
// Declara o pacote ao qual esta classe pertence.
// Convenção: domínio reverso + nome do projeto + camada (controller).
package com.taskflow.controller;

// Importa a anotação @WebServlet do Jakarta EE 11.
// Esta anotação é o que registra este Servlet no GlassFish.
import jakarta.servlet.annotation.WebServlet;

// Importa a classe base HttpServlet — todo Servlet HTTP deve herdar dela.
import jakarta.servlet.http.HttpServlet;

// Importa o objeto que representa a requisição HTTP recebida.
import jakarta.servlet.http.HttpServletRequest;

// Importa o objeto que representa a resposta HTTP que enviaremos.
import jakarta.servlet.http.HttpServletResponse;

// Importa a exceção que pode ser lançada ao trabalhar com I/O na resposta.
import java.io.IOException;

// Importa o PrintWriter, usado para escrever texto na resposta HTTP.
import java.io.PrintWriter;

// A anotação @WebServlet mapeia este Servlet para a URL "/hello".
// Com o context root "/taskflow", a URL completa será:
// http://localhost:8080/taskflow/hello
@WebServlet("/hello")

// A classe HelloServlet herda de HttpServlet.
// Herdar de HttpServlet é obrigatório para que o GlassFish reconheça
// esta classe como um Servlet HTTP e gerencie seu ciclo de vida.
public class HelloServlet extends HttpServlet {

    // O método doGet é chamado pelo GlassFish quando chega
    // uma requisição HTTP do tipo GET para a URL mapeada (/hello).
    // Parâmetros:
    //   request  — contém todos os dados da requisição (URL, parâmetros, cabeçalhos)
    //   response — é o objeto pelo qual escrevemos a resposta de volta ao navegador
    // Exceções declaradas:
    //   IOException — pode ocorrer ao escrever na resposta (I/O de rede)
    //   jakarta.servlet.ServletException — pode ocorrer em erros do Servlet
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, jakarta.servlet.ServletException {

        // Define o tipo de conteúdo da resposta como HTML com codificação UTF-8.
        // IMPORTANTE: esta linha deve ser chamada ANTES de response.getWriter().
        // O charset=UTF-8 garante que acentos e caracteres especiais sejam
        // exibidos corretamente no navegador.
        response.setContentType("text/html;charset=UTF-8");

        // Obtém o PrintWriter — o objeto que escreve no corpo da resposta HTTP.
        // Tudo que for escrito neste writer será enviado ao navegador como HTML.
        PrintWriter writer = response.getWriter();

        // Escreve o início do documento HTML na resposta.
        writer.println("<!DOCTYPE html>");
        writer.println("<html lang='pt-BR'>");
        writer.println("<head>");

        // Define o charset no meta tag como boa prática adicional.
        writer.println("    <meta charset='UTF-8'>");

        // Define o título da página exibido na aba do navegador.
        writer.println("    <title>TaskFlow — Hello Servlet</title>");
        writer.println("</head>");
        writer.println("<body>");

        // Escreve o conteúdo principal da página.
        // Este texto é gerado dinamicamente pelo Java — diferente do index.html
        // estático, este conteúdo poderia variar a cada requisição com base
        // em lógica de negócio, dados do banco, parâmetros da URL, etc.
        writer.println("    <h1>Hello, TaskFlow!</h1>");
        writer.println("    <p>Este é o primeiro Servlet do projeto TaskFlow.</p>");
        writer.println("    <p>O conteúdo desta página é gerado dinamicamente pelo Java.</p>");
        writer.println("    <a href='/taskflow'>Voltar para a página inicial</a>");

        // Fecha o documento HTML.
        writer.println("</body>");
        writer.println("</html>");

        // Fecha o PrintWriter, sinalizando que a resposta está completa.
        // Boa prática: sempre fechar explicitamente os recursos abertos.
        writer.close();
    }
}
~~~

---

### Passo 2: Gerando o WAR e fazendo o deploy

Com o arquivo salvo, gere o novo WAR no terminal integrado do VS Code:

~~~
gradle clean war
~~~

A saída esperada é:

~~~text
> Task :compileJava
> Task :processResources NO-SOURCE
> Task :classes
> Task :war

BUILD SUCCESSFUL in Xs
2 actionable tasks: 2 executed
~~~

Observe que desta vez a tarefa `:compileJava` aparece — ela compilou o `HelloServlet.java`. Agora copie o WAR para a pasta `autodeploy` do GlassFish:

~~~
copy build\libs\taskflow.war C:\ferramentas\glassfish7\domains\domain1\autodeploy\
~~~

Aguarde alguns segundos para o GlassFish detectar e processar o novo WAR. Você pode acompanhar o processo verificando o arquivo de log:

~~~
type C:\ferramentas\glassfish7\domains\domain1\logs\server.log
~~~

Procure por linhas que contenham `HelloServlet` ou `taskflow` com timestamps recentes. Uma linha como `Loading application taskflow at /taskflow` confirma que o redeploy foi concluído.

---

### Passo 3: Testando no navegador

Abra o navegador e acesse:

~~~text
http://localhost:8080/taskflow/hello
~~~

A página deve exibir:

~~~text
Hello, TaskFlow!
Este é o primeiro Servlet do projeto TaskFlow.
O conteúdo desta página é gerado dinamicamente pelo Java.
Voltar para a página inicial
~~~

Este é um momento importante: pela primeira vez, o conteúdo que aparece no navegador foi **gerado pelo seu código Java em tempo de execução**, não lido de um arquivo HTML estático. O GlassFish recebeu a requisição, instanciou o `HelloServlet`, chamou `doGet` e enviou o HTML que o Java gerou de volta ao navegador.

Verifique também que a página inicial continua funcionando:

~~~text
http://localhost:8080/taskflow
~~~

E tente acessar uma URL que não existe para ver o comportamento padrão do GlassFish com 404:

~~~text
http://localhost:8080/taskflow/nao-existe
~~~

---

### Passo 4: Commit do progresso

~~~
git add src/main/java/com/taskflow/controller/HelloServlet.java
git commit -m "feat: adiciona primeiro Servlet com @WebServlet mapeado em /hello"
~~~

---

## Glossário Técnico da Aula

**Servlet:** Classe Java que herda de `HttpServlet` e é gerenciada pelo servidor de aplicações para processar requisições HTTP e produzir respostas HTTP dinâmicas.

**`HttpServlet`:** Classe abstrata do Jakarta Servlet que implementa o protocolo HTTP. A classe base que todo Servlet HTTP deve herdar. Delega requisições GET para `doGet`, POST para `doPost`, etc.

**`@WebServlet`:** Anotação do Jakarta EE que registra uma classe como Servlet e define o mapeamento de URL. Substitui a configuração manual no `web.xml`.

**Ciclo de vida do Servlet:** As três fases que todo Servlet passa: inicialização (`init`), atendimento de requisições (`service` → `doGet`/`doPost`) e destruição (`destroy`).

**`init()`:** Método chamado pelo GlassFish uma única vez ao criar a instância do Servlet. Usado para inicializações que devem acontecer apenas uma vez.

**`service()`:** Método chamado pelo GlassFish para cada requisição que chega ao Servlet. Implementado pelo `HttpServlet` para delegar aos métodos `doGet`, `doPost`, etc.

**`doGet()`:** Método chamado pelo `service` quando a requisição HTTP é do tipo GET. É aqui que você implementa a lógica de resposta a requisições GET.

**`destroy()`:** Método chamado pelo GlassFish uma única vez ao descarregar o Servlet. Usado para liberar recursos alocados no `init`.

**`HttpServletRequest`:** Objeto que representa a requisição HTTP recebida. Contém todos os dados enviados pelo cliente: URL, parâmetros, cabeçalhos, corpo.

**`HttpServletResponse`:** Objeto que representa a resposta HTTP que será enviada ao cliente. Através dele você define o status, os cabeçalhos e o corpo da resposta.

**`setContentType()`:** Método do `HttpServletResponse` que define o cabeçalho `Content-Type` da resposta, informando ao navegador como interpretar o conteúdo recebido.

**`getWriter()`:** Método do `HttpServletResponse` que retorna um `PrintWriter` para escrever conteúdo textual no corpo da resposta HTTP.

**`PrintWriter`:** Classe Java para escrita de texto. No contexto de Servlets, é usado para escrever o HTML da resposta que será enviada ao navegador.

**Context Root:** O caminho base pelo qual uma aplicação web é acessada no servidor. Para o TaskFlow, é `/taskflow`. Todas as URLs da aplicação começam com este prefixo.

**URL Pattern:** O padrão de URL definido na anotação `@WebServlet` que determina quais requisições serão processadas por aquele Servlet. Exemplos: `/hello`, `/tasks`, `/tasks/*`.

**Thread Safety:** Propriedade de um código que funciona corretamente quando executado por múltiplas threads simultaneamente. No contexto de Servlets, significa não usar atributos de instância para guardar dados específicos de uma requisição.

**Scanning de Anotações:** Processo pelo qual o GlassFish examina todas as classes compiladas do WAR procurando por anotações Jakarta EE (`@WebServlet`, `@WebFilter`, etc.) durante o deploy.

---

## Antecipação de Erros

**HTTP 404 ao acessar `/taskflow/hello`:** O erro mais comum nesta aula. Causas possíveis em ordem de frequência: o WAR não foi redeployado após a compilação (copie o novo WAR para `autodeploy` e aguarde); o mapeamento na anotação tem um erro de digitação (verifique se é `"/hello"` e não `"/Hello"` ou `"hello"` sem a barra); a classe não está no pacote correto ou o arquivo está na pasta errada (confirme que o caminho é `src/main/java/com/taskflow/controller/HelloServlet.java`); o `gradle war` falhou silenciosamente (verifique a saída do terminal e garanta que `BUILD SUCCESSFUL` apareceu).

**`error: package jakarta.servlet does not exist` ao compilar:** O `build.gradle` não tem a dependência `jakarta.platform:jakarta.jakartaee-api:11.0.0` com escopo `compileOnly`, ou o arquivo `gradle.properties` não está apontando para o Java 21 corretamente. Verifique ambos os arquivos.

**A página exibe caracteres estranhos no lugar de acentos (ex: `Ã©` em vez de `é`):** O `setContentType` não foi chamado com `charset=UTF-8`, ou foi chamado após `getWriter()`. Garanta que `response.setContentType("text/html;charset=UTF-8")` é a primeira linha dentro do `doGet`, antes de qualquer chamada a `response.getWriter()`.

**`java.io.IOException` ou tela em branco no navegador:** O `PrintWriter` pode ter sido fechado antes de terminar de escrever. Verifique que `writer.close()` é a última instrução do método, após todos os `writer.println()`.

**Esquecer de herdar `HttpServlet`:** Se você esquecer `extends HttpServlet`, o GlassFish não reconhecerá a classe como um Servlet e simplesmente ignorará a anotação `@WebServlet`. O resultado é um 404 sem nenhuma mensagem de erro útil. Sempre verifique a declaração da classe.

**Atributos de instância em Servlets (bug de thread safety):** Se você declarar um campo como `private String resultado;` e atribuir dentro de `doGet`, duas requisições simultâneas podem sobrescrever o valor uma da outra. Sempre use variáveis locais dentro dos métodos `doGet` e `doPost` para dados específicos de uma requisição.

**WAR antigo sendo usado após modificações:** O GlassFish usa o WAR que está na pasta `autodeploy`. Se você modificar o código mas esquecer de executar `gradle war` e copiar o novo WAR, o GlassFish continuará usando a versão antiga. Sempre siga a sequência: modifica o código → `gradle clean war` → copia o WAR → aguarda o redeploy.

---

## Exercício de Fixação

Este exercício tem duas partes. A primeira consolida o que você aprendeu sobre Servlets criando um segundo. A segunda exercita a observação do ciclo de vida.

**Parte 1 — Criando o SobreServlet:** Crie um segundo Servlet no pacote `com.taskflow.controller` chamado `SobreServlet.java`, mapeado em `/sobre`. Ele deve responder a requisições GET com uma página HTML que exibe as seguintes informações sobre o projeto TaskFlow: nome do projeto, tecnologias usadas (Jakarta EE 11, Java 21, Gradle, GlassFish 7) e a aula atual (Aula 5). A página deve ter um link para voltar para `http://localhost:8080/taskflow/hello`. Gere o WAR, faça o deploy e verifique em `http://localhost:8080/taskflow/sobre`.

**Parte 2 — Observando o ciclo de vida:** Adicione ao `HelloServlet` as seguintes sobrecargas dos métodos de ciclo de vida, que imprimem mensagens no console do GlassFish:

~~~java
@Override
public void init() throws jakarta.servlet.ServletException {
    // Imprime no console do GlassFish quando o Servlet é inicializado.
    // Este método é chamado apenas UMA VEZ, na primeira requisição.
    System.out.println("[HelloServlet] init() chamado — Servlet inicializado.");
}

@Override
public void destroy() {
    // Imprime no console do GlassFish quando o Servlet é destruído.
    // Este método é chamado apenas UMA VEZ, ao descarregar a aplicação.
    System.out.println("[HelloServlet] destroy() chamado — Servlet destruído.");
}
~~~

Gere o WAR e faça o deploy. Acesse `http://localhost:8080/taskflow/hello` algumas vezes e abra o arquivo `server.log` do GlassFish para encontrar a mensagem de `init`. Depois faça o undeploy da aplicação pelo console de administração e procure no log a mensagem de `destroy`. Registre suas observações em `modulo_01_fundamentos/aula_05/exercicio_05.txt` respondendo: o `init` foi chamado uma ou múltiplas vezes durante os acessos? O `destroy` foi chamado ao fazer undeploy?

Ao final, faça o commit:

~~~
git add src/main/java/com/taskflow/controller/
git add modulo_01_fundamentos/aula_05/
git commit -m "feat: adiciona SobreServlet e observacao do ciclo de vida - aula 05"
~~~

---

## Resolução Comentada do Exercício

**Parte 1 — SobreServlet:** A estrutura do `SobreServlet` é praticamente idêntica ao `HelloServlet`: herda de `HttpServlet`, usa `@WebServlet("/sobre")`, implementa `doGet` com `setContentType`, obtém o `PrintWriter` e escreve HTML. A diferença está apenas no conteúdo HTML escrito. O ponto de atenção é o mapeamento: `/sobre` com barra no início — sem a barra, o GlassFish não mapeará corretamente e você receberá um 404.

**Parte 2 — Ciclo de vida:** O `init` deve aparecer **uma única vez** no log, na primeira requisição para `/hello`, mesmo que você acesse a URL cinco ou dez vezes em sequência. Isso demonstra que o GlassFish cria a instância e chama `init` apenas uma vez e depois reutiliza a mesma instância. O `destroy` deve aparecer **uma única vez** no log ao fazer o undeploy, confirmando que o GlassFish chama `destroy` ao encerrar o ciclo de vida do Servlet. Se você fizer redeploy (não undeploy), verá `destroy` seguido de `init` — porque o GlassFish destrói a instância antiga e cria uma nova.

---

## Resumo dos Pontos-Chave

Um **Servlet** é uma classe Java que herda de `HttpServlet` e processa requisições HTTP, sendo gerenciada inteiramente pelo servidor de aplicações. O **ciclo de vida** tem três fases: `init` (uma vez, ao criar a instância), `service` → `doGet`/`doPost` (para cada requisição) e `destroy` (uma vez, ao descarregar). A anotação **`@WebServlet`** registra o Servlet e define o mapeamento de URL, substituindo a configuração verbosa no `web.xml`. O GlassFish usa **uma única instância** do Servlet para atender múltiplas requisições em threads simultâneas — portanto, nunca use atributos de instância para dados específicos de uma requisição. Para escrever a resposta HTML, chame `response.setContentType("text/html;charset=UTF-8")` antes de `response.getWriter()` e use o `PrintWriter` retornado para escrever o conteúdo. O fluxo de desenvolvimento é sempre: modifica o código → `gradle clean war` → copia o WAR para `autodeploy` → aguarda o redeploy automático → testa no navegador.

---

## Log de Estado do Projeto

~~~text
## Aula 5: Introdução aos Servlets: o coração do Jakarta EE Web
- Objetivo: Criar o primeiro Servlet funcional do projeto TaskFlow.
- Código Adicionado:
    src/main/java/com/taskflow/controller/HelloServlet.java
    @WebServlet("/hello") com doGet respondendo Hello, TaskFlow! em HTML.
    SobreServlet.java adicionado no exercício (mapeado em /sobre).
    Métodos init() e destroy() adicionados ao HelloServlet no exercício.
- Estado Funcional: ✅ Acessar http://localhost:8080/taskflow/hello exibe
  "Hello, TaskFlow!" gerado dinamicamente pelo Java.
  http://localhost:8080/taskflow/sobre exibe informações do projeto.
- Próximas Etapas: Aula 6 aprofundará o protocolo HTTP, explicará a diferença
  entre GET e POST, ensinará a ler parâmetros da requisição e introduzirá
  os primeiros testes com JUnit 5 seguindo a metodologia TDD.
~~~

---

## Prompt de Continuidade para a Aula 6

"Sou aluno do curso Jakarta EE 11 com Java 21, Gradle, JUnit 5 e VS Code. Concluí a Aula 5 (Introdução aos Servlets: o coração do Jakarta EE Web). O HelloServlet está criado em src/main/java/com/taskflow/controller/HelloServlet.java, mapeado em /hello com @WebServlet, e responde corretamente em http://localhost:8080/taskflow/hello. O SobreServlet foi criado no exercício. O ciclo de vida do Servlet foi observado via logs do GlassFish. Tenho o plano_mestre.txt, o log_estado_projeto.md e os prompts_individuais.md em anexo para contexto. Por favor, gere a **Aula 6: Requisições e Respostas HTTP com Servlets e TDD com JUnit 5**, seguindo rigorosamente a estrutura definida no plano mestre: teoria detalhada com mínimo de 2.000 palavras, analogia de ancoragem, diagrama Mermaid com blocos ~~~mermaid, código comentado linha a linha com blocos ~~~, glossário técnico, antecipação de erros, exercício com resolução comentada, resumo dos pontos-chave, log de estado do projeto atualizado e prompt de continuidade para a Aula 7. O documento inteiro deve estar dentro de um bloco ```markdown. Nenhum bloco interno deve usar triple backtick."

---

Dúvidas? Posso prosseguir para a **Aula 6: Requisições e Respostas HTTP com Servlets e TDD com JUnit 5**?