# Aula 8: Jakarta Server Pages: criando as Views com JSP

## Análise de Integridade
✅ Conteúdo verificado: profundidade técnica mantida para iniciantes, linguagem acessível, analogia do molde de bolo aplicada consistentemente, JSP explicado desde o processamento interno pelo GlassFish, Expression Language detalhada, diretivas explicadas, scriptlets proibidos com justificativa clara, arquivos JSP criados e comentados linha a linha, coerência total com a estrutura MVC da Aula 7 e com a estratégia de testes estabelecida na Aula 6, diagrama Mermaid correto, mínimo de 2.000 palavras garantido.

---

## Índice

- [Aula 8: Jakarta Server Pages: criando as Views com JSP](#aula-8-jakarta-server-pages-criando-as-views-com-jsp)
  - [Análise de Integridade](#análise-de-integridade)
  - [Índice](#índice)
  - [Objetivo](#objetivo)
  - [Pré-requisitos](#pré-requisitos)
  - [Resumo da Aula Anterior](#resumo-da-aula-anterior)
  - [Teoria Detalhada](#teoria-detalhada)
    - [O que é JSP e por que ele existe](#o-que-é-jsp-e-por-que-ele-existe)
    - [Como o GlassFish processa um arquivo JSP](#como-o-glassfish-processa-um-arquivo-jsp)
    - [A diretiva page: configurando o JSP](#a-diretiva-page-configurando-o-jsp)
    - [A Expression Language: exibindo dados sem Java](#a-expression-language-exibindo-dados-sem-java)
    - [A diretiva taglib: preparando o terreno para o JSTL](#a-diretiva-taglib-preparando-o-terreno-para-o-jstl)
    - [Por que scriptlets são proibidos neste curso](#por-que-scriptlets-são-proibidos-neste-curso)
    - [A pasta WEB-INF e a proteção das Views](#a-pasta-web-inf-e-a-proteção-das-views)
    - [O caminho correto para os JSPs no TaskFlow](#o-caminho-correto-para-os-jsps-no-taskflow)
  - [Analogia de Ancoragem](#analogia-de-ancoragem)
  - [Diagrama Mermaid](#diagrama-mermaid)
  - [Aplicação no Projeto Prático](#aplicação-no-projeto-prático)
    - [Passo 1: Verificando a estrutura de pastas](#passo-1-verificando-a-estrutura-de-pastas)
    - [Passo 2: Criando o list.jsp](#passo-2-criando-o-listjsp)
    - [Passo 3: Criando o form.jsp](#passo-3-criando-o-formjsp)
    - [Passo 4: Atualizando o TaskServlet para encaminhar ao list.jsp](#passo-4-atualizando-o-taskservlet-para-encaminhar-ao-listjsp)
    - [Passo 5: Gerando o WAR e verificando no navegador](#passo-5-gerando-o-war-e-verificando-no-navegador)
    - [Passo 6: Commit do progresso](#passo-6-commit-do-progresso)
  - [Glossário Técnico da Aula](#glossário-técnico-da-aula)
  - [Antecipação de Erros](#antecipação-de-erros)
  - [Exercício de Fixação](#exercício-de-fixação)
  - [Resolução Comentada do Exercício](#resolução-comentada-do-exercício)
  - [Resumo dos Pontos-Chave](#resumo-dos-pontos-chave)
  - [Log de Estado do Projeto](#log-de-estado-do-projeto)
  - [Prompt de Continuidade para a Aula 9](#prompt-de-continuidade-para-a-aula-9)

---

## Objetivo
Entender o que é JSP, como o GlassFish processa arquivos JSP internamente, aprender a sintaxe das diretivas `<%@ page %>` e `<%@ taglib %>`, dominar a Expression Language (EL) para exibir dados dinâmicos sem Java puro, entender por que scriptlets são proibidos no padrão MVC, e criar os dois primeiros arquivos JSP do TaskFlow — o `list.jsp` (listagem de tarefas) e o `form.jsp` (formulário de criação) — conectando-os ao `TaskServlet` via `RequestDispatcher.forward`.

## Pré-requisitos
Aula 7 concluída. A estrutura de pacotes MVC está criada: `model/`, `repository/`, `controller/` e `filter/`. O `TaskServlet.java` existe como placeholder em `/tasks`. As pastas `WEB-INF/views/task/` e `WEB-INF/views/error/` estão criadas e vazias. Os Servlets de treinamento foram removidos. O `gradle clean test war` gera `BUILD SUCCESSFUL` com 13 testes passando.

---

## Resumo da Aula Anterior

Na Aula 7 você formalizou a arquitetura MVC e refatorou toda a estrutura do TaskFlow para segui-la. Você entendeu que o Model (POJOs) é testável com JUnit puro, o Controller (Servlets) é testável com Mockito, e a View (JSPs) é verificada manualmente — e que essa divisão é deliberada e tem impacto direto na qualidade dos testes. O `TaskServlet` existe como placeholder, respondendo com HTML temporário gerado por `PrintWriter`. A partir desta aula, o Controller para de gerar HTML — essa responsabilidade passa definitivamente para os arquivos JSP que você criará agora.

---

## Teoria Detalhada

### O que é JSP e por que ele existe

Nas aulas anteriores, você viu que um Servlet pode gerar HTML usando `PrintWriter`. O `SaudacaoServlet` fazia exatamente isso: `writer.println("<h1>Olá, " + nome + "</h1>")`. Isso funciona — mas rapidamente se torna um pesadelo de manutenção. Imagine uma página com cabeçalho, menu de navegação, tabela de dados, rodapé, folhas de estilo e scripts JavaScript. Escrever tudo isso como strings Java dentro de `println` é uma tortura para quem escreve e para quem tenta ler depois. Qualquer erro de digitação no HTML não é detectado pelo compilador Java — você só descobre quando a página renderiza incorretamente no navegador.

O **JSP** (Jakarta Server Pages) existe para inverter essa equação. Em vez de escrever HTML dentro de Java, você escreve Java — ou melhor, Expression Language — dentro de HTML. Um arquivo JSP parece e funciona como um arquivo HTML comum, com a diferença de que você pode embutir expressões dinâmicas diretamente no meio do markup: `<td>${task.titulo}</td>`. O resultado é um arquivo que um designer web consegue ler e editar sem precisar entender Java, e que um desenvolvedor Java consegue modificar sem precisar navegar por centenas de linhas de `println`.

Use esta analogia para fixar o conceito: um arquivo JSP é como um **molde de confeitaria**. O confeiteiro (o GlassFish) pega o molde (o arquivo JSP), injeta o recheio (os dados vindos do Controller via `request.setAttribute`) e produz o bolo final (o HTML que é enviado ao navegador). O molde define a estrutura — onde vai o topo, onde vai o recheio, onde vai a cobertura. O recheio muda a cada pedido, mas o molde permanece o mesmo. Você, como desenvolvedor, cria e mantém o molde. O GlassFish cuida de injetar o recheio correto em cada requisição.

O JSP foi introduzido ainda na era do Java EE como uma forma de separar a apresentação da lógica de negócio. Ao longo dos anos, evoluiu para incorporar a Expression Language (EL) e a JSTL — duas tecnologias que eliminaram praticamente toda a necessidade de Java puro nos arquivos de apresentação. No Jakarta EE 11, a versão atual do JSP é a **3.1**, que usa o namespace `jakarta.*` em vez do antigo `javax.*`.

---

### Como o GlassFish processa um arquivo JSP

Entender o que acontece nos bastidores quando o GlassFish recebe uma requisição para um JSP é importante para diagnosticar erros e para entender as limitações da tecnologia.

O processo tem três etapas distintas. A **primeira etapa é a tradução**: na primeira vez que um JSP é requisitado (ou quando é modificado), o GlassFish lê o arquivo `.jsp` e o transforma automaticamente em uma classe Java que herda de `HttpServlet`. Você nunca vê esse código — o GlassFish o gera e o armazena internamente. Todo o HTML do JSP se torna chamadas a `out.write(...)`, e as expressões EL se tornam código Java de acesso aos escopos do request, session e application.

A **segunda etapa é a compilação**: o GlassFish compila a classe Java gerada na etapa anterior, produzindo um arquivo `.class`. Se houver erros de sintaxe na EL ou nas diretivas JSP, eles aparecerão nesta etapa como erros de compilação — com uma mensagem de erro que inclui o número da linha do arquivo `.jsp` original.

A **terceira etapa é a execução**: o GlassFish executa o Servlet compilado (que era o JSP) para produzir o HTML final, que é enviado como resposta HTTP ao navegador. Das próximas vezes que a mesma requisição chegar, o GlassFish pula as etapas de tradução e compilação e vai direto para a execução — a menos que o arquivo `.jsp` tenha sido modificado.

Esta arquitetura tem uma consequência prática importante: a **primeira requisição para um JSP é sempre mais lenta** do que as subsequentes, porque inclui o tempo de tradução e compilação. Em produção, servidores de aplicações geralmente pré-compilam todos os JSPs durante o deploy para evitar esse atraso para o primeiro usuário. No nosso ambiente de desenvolvimento com GlassFish, esse overhead é imperceptível.

---

### A diretiva page: configurando o JSP

Uma **diretiva JSP** é uma instrução processada pelo GlassFish durante a fase de tradução — antes de qualquer conteúdo ser enviado ao navegador. Ela começa com `<%@` e termina com `%>`. A diretiva mais usada é a `page`, que configura parâmetros globais do arquivo JSP.

Os atributos mais importantes da diretiva `page` são os seguintes.

`contentType` define o tipo de conteúdo e o encoding da resposta, exatamente como `response.setContentType()` faz no Servlet. O valor padrão é `text/html;charset=ISO-8859-1` — que não suporta acentos corretamente. Sempre declare explicitamente `contentType="text/html;charset=UTF-8"` para suportar português e outros caracteres especiais.

`pageEncoding` define o encoding do próprio arquivo JSP — como o GlassFish deve interpretar os bytes do arquivo ao lê-lo. Deve ser igual ao encoding do `contentType`. Use sempre `UTF-8`.

`import` funciona como a instrução `import` do Java — permite importar classes Java para uso no JSP. No padrão deste curso, você não usará `import` porque não escreveremos Java diretamente nos JSPs. Se precisar de import, é um sinal de que você está colocando lógica de negócio na View — o que não deve acontecer.

`isELIgnored` controla se a Expression Language está ativa no arquivo. O padrão no `web.xml` com versão 6.1 é `false` (EL ativa). Nunca defina `isELIgnored="true"` nos nossos JSPs.

Exemplo de diretiva page completa que usaremos em todos os JSPs do TaskFlow:

~~~jsp
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
~~~

---

### A Expression Language: exibindo dados sem Java

A **Expression Language** (EL) é a tecnologia que permite exibir dados dinâmicos em arquivos JSP sem escrever código Java. Uma expressão EL tem a forma `${expressao}` e é avaliada pelo GlassFish em tempo de execução, sendo substituída pelo valor correspondente no HTML final enviado ao navegador.

A EL busca valores em quatro **escopos**, nesta ordem de prioridade: `pageScope` (válido apenas na página atual), `requestScope` (válido durante a requisição atual), `sessionScope` (válido durante a sessão do usuário) e `applicationScope` (válido durante toda a vida da aplicação). Quando você escreve `${tasks}`, a EL procura automaticamente nos quatro escopos nessa ordem e retorna o primeiro valor encontrado com o nome `tasks`. Como o Controller colocou a lista com `request.setAttribute("tasks", tasks)`, o valor é encontrado no `requestScope`.

Para acessar propriedades de um objeto, a EL usa a notação de ponto. Se `task` é um objeto Java com um método `getTitulo()`, você escreve simplesmente `${task.titulo}` — a EL chama o getter automaticamente. Isso é possível porque a EL segue a convenção JavaBeans: para acessar `${task.titulo}`, ela procura um método público `getTitulo()` na classe `Task`.

A EL também suporta operadores básicos: aritméticos (`${preco * 1.1}`), relacionais (`${task.status == 'CONCLUIDA'}`), lógicos (`${not empty tasks}`) e ternários (`${vazio ? 'Sim' : 'Não'}`). O operador `empty` é particularmente útil: `${empty tasks}` retorna `true` se `tasks` for `null`, uma coleção vazia ou uma string vazia.

Uma característica importante da EL é que ela **nunca lança NullPointerException**. Se `${task.titulo}` for nulo, a EL simplesmente exibe uma string vazia — sem erro. Isso é conveniente para a View, mas significa que você não pode usar a EL para detectar ausência de dados de forma confiável. Para lógica condicional mais robusta, use as tags JSTL que estudaremos na Aula 9.

---

### A diretiva taglib: preparando o terreno para o JSTL

A segunda diretiva importante é a `taglib`, que declara o uso de uma biblioteca de tags customizadas no arquivo JSP. A **JSTL** (Jakarta Standard Tag Library) — que estudaremos em profundidade na Aula 9 — é carregada via diretiva `taglib`.

A declaração tem dois atributos obrigatórios: `uri` (o identificador único da biblioteca de tags) e `prefix` (o prefixo que você usará antes de cada tag). Para a biblioteca core da JSTL, a declaração é:

~~~jsp
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
~~~

O `prefix="c"` significa que todas as tags dessa biblioteca serão usadas como `<c:forEach>`, `<c:if>`, `<c:out>`, etc. Você poderia usar qualquer prefixo, mas `c` é a convenção universal para a biblioteca core da JSTL — siga sempre essa convenção.

Já incluiremos a diretiva `taglib` nos JSPs desta aula, mesmo que ainda não usemos nenhuma tag JSTL. Isso porque na Aula 9 simplesmente começaremos a usar as tags sem precisar modificar os cabeçalhos dos arquivos. É uma prática de antecipação que acelera o fluxo das próximas aulas.

---

### Por que scriptlets são proibidos neste curso

Um **scriptlet** é um bloco de código Java embutido diretamente em um arquivo JSP, delimitado por `<% %>`. Exemplos: `<% String nome = request.getParameter("nome"); %>` ou `<% for (Task t : tasks) { %>`. O Jakarta EE permite scriptlets — eles existem desde os primeiros dias do JSP. Mas este curso os **proíbe categoricamente**, e é importante entender por quê.

Scriptlets violam o princípio de separação de responsabilidades que estabelecemos na Aula 7. Quando você coloca código Java no JSP, está misturando lógica de apresentação com lógica de negócio ou acesso a dados. O arquivo que deveria ser apenas um molde vira um híbrido confuso de HTML e Java que é difícil de ler, impossível de testar com JUnit e propenso a erros que o compilador não detecta.

Do ponto de vista dos testes — que estabelecemos como critério de qualidade desde a Aula 6 — scriptlets são o pior cenário possível: você não consegue testar lógica embutida em scriptlets com JUnit, Mockito ou qualquer outra ferramenta automatizada. A única forma de verificar o comportamento de um scriptlet é subir o servidor, fazer uma requisição e inspecionar o HTML retornado manualmente. Isso é lento, frágil e não escala.

A alternativa correta é sempre mover a lógica de negócio para o Model (testável com JUnit puro), mover a coordenação para o Controller (testável com Mockito) e deixar no JSP apenas Expression Language e tags JSTL para apresentação. Esta disciplina é o que separa código de qualidade de código espaguete.

---

### A pasta WEB-INF e a proteção das Views

Na Aula 7, você criou os JSPs dentro de `src/main/webapp/WEB-INF/views/task/`. A escolha de colocar os JSPs **dentro de `WEB-INF`** é deliberada e tem uma razão de segurança importante que você precisa entender.

A pasta `WEB-INF` é uma pasta especial dentro de um WAR que o servidor de aplicações **nunca serve diretamente** para requisições HTTP externas. Se um usuário tentar acessar `http://localhost:8080/taskflow/WEB-INF/views/task/list.jsp` diretamente no navegador, o GlassFish retornará um erro **HTTP 403 Forbidden** — sem nem abrir o arquivo. Isso é um comportamento garantido pela especificação do Jakarta Servlet.

Isso é exatamente o que queremos: os JSPs são componentes internos do servidor, não recursos públicos. Eles devem ser acessados **apenas via `RequestDispatcher.forward()`** a partir de um Servlet Controller — nunca diretamente pelo navegador. Ao colocar os JSPs dentro de `WEB-INF`, você garante fisicamente que o fluxo MVC seja respeitado: nenhum usuário pode pular o Controller e acessar uma View diretamente.

Se você colocasse os JSPs em `src/main/webapp/views/` (fora de `WEB-INF`), eles ficariam acessíveis pela URL diretamente, exibindo uma página sem dados ou com erros de EL — porque o Controller não foi executado para popular o request com os atributos necessários.

---

### O caminho correto para os JSPs no TaskFlow

Dado que os JSPs ficam dentro de `WEB-INF`, o caminho para o `RequestDispatcher.forward()` no Servlet precisa incluir `/WEB-INF/` no início. Veja como fica:

~~~java
// No TaskServlet, o forward para o list.jsp usa o caminho completo a partir da raiz do WAR.
// O GlassFish resolve este caminho internamente — não é uma URL acessível pelo navegador.
request.getRequestDispatcher("/WEB-INF/views/task/list.jsp")
       .forward(request, response);
~~~

O caminho começa com `/` (barra), que representa a raiz do WAR — equivalente a `src/main/webapp/` no projeto. Portanto `/WEB-INF/views/task/list.jsp` mapeia para `src/main/webapp/WEB-INF/views/task/list.jsp` no sistema de arquivos do projeto.

Este detalhe de caminho é uma das principais fontes de erros nesta aula, então registre bem: o `forward` usa o caminho dentro do WAR (começando com `/`), não o caminho do sistema de arquivos do projeto (que começaria com `src/main/webapp`).

---

## Analogia de Ancoragem

Um arquivo JSP funciona exatamente como um **molde de confeitaria numerado**. Uma confeitaria tem dezenas de moldes na prateleira — um para bolo redondo, um para bolo retangular, um para cupcakes. Cada molde define a forma (a estrutura HTML), mas não o sabor. Quando um cliente faz um pedido (uma requisição HTTP chega ao servidor), o gerente da confeitaria (o Controller — o `TaskServlet`) consulta o estoque (o `TaskRepository`), prepara o recheio (a lista de tarefas), e entrega o molde certo com o recheio certo para o confeiteiro (o GlassFish). O confeiteiro injeta o recheio no molde, produz o bolo final (o HTML completo) e entrega ao cliente (o navegador). O cliente nunca vai até a prateleira de moldes por conta própria — ele sempre passa pelo gerente. É por isso que os moldes ficam dentro de `WEB-INF`: na área restrita da cozinha, não no balcão de atendimento.

---

## Diagrama Mermaid

~~~mermaid
sequenceDiagram
    participant NAV as Navegador
    participant GF as GlassFish
    participant CTRL as TaskServlet (Controller)
    participant JSP as list.jsp (View)
    participant EL as Expression Language

    NAV->>GF: GET /taskflow/tasks
    GF->>CTRL: doGet(request, response)

    Note over CTRL: Lista vazia por enquanto
    Note over CTRL: request.setAttribute("tasks", listaVazia)
    Note over CTRL: request.setAttribute("mensagem", "Nenhuma tarefa")

    CTRL->>GF: forward("/WEB-INF/views/task/list.jsp")

    Note over GF: 1ª vez: traduz JSP → Servlet Java
    Note over GF: Compila o Servlet gerado
    GF->>JSP: executa o JSP compilado

    JSP->>EL: avalia ${tasks}
    EL-->>JSP: retorna lista do requestScope
    JSP->>EL: avalia ${empty tasks}
    EL-->>JSP: retorna true (lista vazia)

    Note over JSP: Gera HTML com tabela vazia
    Note over JSP: e mensagem "Nenhuma tarefa cadastrada"

    JSP-->>NAV: HTML completo da listagem

    Note over NAV,JSP: ── Próximas requisições ──
    Note over GF: JSP já compilado → executa direto
~~~

---

## Aplicação no Projeto Prático

### Passo 1: Verificando a estrutura de pastas

Confirme que as pastas necessárias existem antes de criar os arquivos JSP. No terminal do VS Code, execute:

~~~
dir src\main\webapp\WEB-INF\views\task
dir src\main\webapp\WEB-INF\views\error
~~~

Ambas as pastas devem existir (criadas na Aula 7). Se não existirem, crie-as:

~~~
mkdir src\main\webapp\WEB-INF\views\task
mkdir src\main\webapp\WEB-INF\views\error
~~~

A estrutura esperada neste momento é:

~~~text
src/main/webapp/
├── WEB-INF/
│   ├── web.xml
│   └── views/
│       ├── task/        ← JSPs serão criados aqui nesta aula
│       └── error/       ← JSPs de erro serão criados na Aula 17
└── index.html
~~~

---

### Passo 2: Criando o list.jsp

Crie o arquivo `src/main/webapp/WEB-INF/views/task/list.jsp`:

~~~jsp
<%-- Diretiva page: configura o encoding UTF-8 para suporte a acentos.
     contentType: define o Content-Type da resposta HTTP.
     pageEncoding: define como o GlassFish lê este arquivo .jsp. --%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<%-- Diretiva taglib: declara a biblioteca JSTL Core para uso nesta página.
     uri: identificador único da biblioteca no Jakarta EE 11.
     prefix: o prefixo "c" que usaremos antes de cada tag JSTL (c:forEach, c:if, etc.)
     Ainda não usamos tags JSTL nesta aula, mas já declaramos para a Aula 9. --%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TaskFlow — Lista de Tarefas</title>
    <style>
        /* Estilos inline mínimos para visualização durante o desenvolvimento.
           Em produção, esses estilos seriam movidos para um arquivo CSS externo. */
        body { font-family: Arial, sans-serif; max-width: 900px; margin: 40px auto; padding: 0 20px; }
        h1 { color: #333; border-bottom: 2px solid #007bff; padding-bottom: 10px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background-color: #007bff; color: white; padding: 10px; text-align: left; }
        td { padding: 8px 10px; border-bottom: 1px solid #ddd; }
        tr:hover { background-color: #f5f5f5; }
        .btn { display: inline-block; padding: 6px 12px; text-decoration: none;
               border-radius: 4px; font-size: 14px; }
        .btn-primary { background-color: #007bff; color: white; }
        .btn-warning { background-color: #ffc107; color: black; }
        .btn-danger  { background-color: #dc3545; color: white; }
        .mensagem-vazia { text-align: center; color: #888; padding: 40px; font-size: 18px; }
    </style>
</head>
<body>

    <h1>TaskFlow — Gerenciador de Tarefas</h1>

    <%-- Link para o formulário de criação.
         Usa o context root /taskflow + /tasks?action=criar.
         O Controller interpretará action=criar e encaminhará para o form.jsp.
         Por enquanto, este link levará a uma página ainda não implementada
         (será conectada na Aula 11 com o CRUD completo). --%>
    <a href="${pageContext.request.contextPath}/tasks?action=criar" class="btn btn-primary">
        + Nova Tarefa
    </a>

    <%-- ${pageContext.request.contextPath} retorna o context root da aplicação.
         No nosso caso: /taskflow. Isso evita hardcodar "/taskflow" nos links,
         tornando a aplicação portável caso o context root mude. --%>

    <%-- Exibição condicional da mensagem de feedback (sucesso ou erro).
         O Controller pode colocar uma mensagem no request via:
         request.setAttribute("mensagem", "Tarefa criada com sucesso!")
         A EL ${mensagem} exibe o valor se presente, ou string vazia se ausente.
         O atributo style="color:green" é temporário — na Aula 9 usaremos c:if. --%>
    <p style="color: green; font-weight: bold;">${mensagem}</p>

    <%-- Tabela de listagem de tarefas.
         Por enquanto, não há dados reais — o Model (TaskRepository) ainda não existe.
         Na Aula 10, criaremos Task.java e TaskRepository.java.
         Na Aula 11, o Controller buscará as tarefas e as passará para esta View.
         A partir daí, esta tabela exibirá dados reais.
         Por ora, exibimos a estrutura estática da tabela. --%>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Título</th>
                <th>Status</th>
                <th>Data de Criação</th>
                <th>Ações</th>
            </tr>
        </thead>
        <tbody>

            <%-- FASE ATUAL (placeholder): exibe uma única linha de exemplo estático.
                 FASE AULA 9+: esta linha será substituída por <c:forEach> iterando
                 sobre ${tasks}, exibindo uma linha por tarefa.
                 FASE AULA 11+: o Controller terá populado ${tasks} com dados reais
                 do TaskRepository antes de encaminhar para este JSP. --%>
            <tr>
                <td colspan="5" class="mensagem-vazia">
                    <%-- ${empty tasks} retorna true se tasks for null ou vazia.
                         Por enquanto tasks é sempre null/vazia (Model não existe ainda).
                         Na Aula 9, substituiremos por <c:if test="${empty tasks}">. --%>
                    Nenhuma tarefa cadastrada. Clique em "+ Nova Tarefa" para começar.
                </td>
            </tr>

        </tbody>
    </table>

    <hr>
    <%-- Rodapé com informação de desenvolvimento — será removido na Aula 18. --%>
    <p style="color: #aaa; font-size: 12px;">
        TaskFlow v1.0 | Aula 8 — Views com JSP |
        Context Root: ${pageContext.request.contextPath}
    </p>

</body>
</html>
~~~

---

### Passo 3: Criando o form.jsp

Crie o arquivo `src/main/webapp/WEB-INF/views/task/form.jsp`:

~~~jsp
<%-- Diretiva page: encoding UTF-8 obrigatório em todos os JSPs do TaskFlow. --%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<%-- Diretiva taglib: JSTL Core declarada antecipadamente para a Aula 9. --%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TaskFlow — Nova Tarefa</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 600px; margin: 40px auto; padding: 0 20px; }
        h1 { color: #333; border-bottom: 2px solid #007bff; padding-bottom: 10px; }
        .form-group { margin-bottom: 16px; }
        label { display: block; font-weight: bold; margin-bottom: 4px; color: #555; }
        input[type="text"], textarea, select {
            width: 100%; padding: 8px; border: 1px solid #ccc;
            border-radius: 4px; font-size: 14px; box-sizing: border-box;
        }
        textarea { height: 100px; resize: vertical; }
        .btn { padding: 10px 20px; border: none; border-radius: 4px;
               cursor: pointer; font-size: 14px; text-decoration: none; }
        .btn-primary { background-color: #007bff; color: white; }
        .btn-secondary { background-color: #6c757d; color: white; margin-left: 10px; }
        .erro { color: #dc3545; font-size: 13px; margin-top: 4px; }
        .lista-erros { background-color: #f8d7da; border: 1px solid #f5c6cb;
                       border-radius: 4px; padding: 10px 20px; margin-bottom: 16px; }
    </style>
</head>
<body>

    <h1>Nova Tarefa</h1>

    <%-- Área de exibição de erros de validação.
         O Controller colocará os erros via request.setAttribute("erros", listaDeErros).
         ${not empty erros} verifica se a lista de erros não está vazia.
         Na Aula 9, substituiremos por <c:if> e <c:forEach> para iterar os erros.
         Na Aula 16, implementaremos Bean Validation que preencherá esta seção. --%>
    <div class="lista-erros" style="display: ${not empty erros ? 'block' : 'none'}">
        <strong>Por favor, corrija os erros abaixo:</strong>
        <%-- FASE AULA 9+: <c:forEach items="${erros}" var="erro">
                               <p class="erro">${erro}</p>
                           </c:forEach> --%>
        <p class="erro">${erros}</p>
    </div>

    <%-- Formulário de criação de tarefa.
         action: envia o POST para o Controller em /tasks?action=salvar.
         method="post": os dados vão no corpo da requisição (não na URL).
         O Controller processará o POST e redirecionará para a listagem (padrão PRG).
         O padrão PRG (Post-Redirect-Get) será explicado em detalhes na Aula 12. --%>
    <form action="${pageContext.request.contextPath}/tasks?action=salvar" method="post">

        <%-- Campo: título da tarefa (obrigatório).
             name="titulo": o Controller lerá com request.getParameter("titulo").
             value="${param.titulo}": reexibe o valor digitado em caso de erro de validação.
             ${param.titulo} acessa os parâmetros da requisição diretamente via EL. --%>
        <div class="form-group">
            <label for="titulo">Título <span style="color:red">*</span></label>
            <input type="text"
                   id="titulo"
                   name="titulo"
                   value="${param.titulo}"
                   placeholder="Informe o título da tarefa"
                   maxlength="200">
        </div>

        <%-- Campo: descrição da tarefa (opcional).
             textarea não tem atributo value — o conteúdo fica entre as tags.
             ${param.descricao} reexibe a descrição digitada em caso de erro. --%>
        <div class="form-group">
            <label for="descricao">Descrição</label>
            <textarea id="descricao"
                      name="descricao"
                      placeholder="Descreva a tarefa (opcional)"
                      maxlength="1000">${param.descricao}</textarea>
        </div>

        <%-- Campo: status da tarefa (select com opções fixas).
             Os três status possíveis são: PENDENTE, EM_ANDAMENTO, CONCLUIDA.
             Na Aula 9, usaremos c:choose para marcar o option correto como selected
             quando o formulário for reexibido após um erro de validação. --%>
        <div class="form-group">
            <label for="status">Status</label>
            <select id="status" name="status">
                <option value="PENDENTE">Pendente</option>
                <option value="EM_ANDAMENTO">Em andamento</option>
                <option value="CONCLUIDA">Concluída</option>
            </select>
        </div>

        <%-- Botões de ação.
             "Salvar": submete o formulário via POST.
             "Cancelar": link GET de volta à listagem — sem submeter dados. --%>
        <div class="form-group">
            <button type="submit" class="btn btn-primary">Salvar</button>
            <a href="${pageContext.request.contextPath}/tasks" class="btn btn-secondary">
                Cancelar
            </a>
        </div>

    </form>

    <hr>
    <p style="color: #aaa; font-size: 12px;">
        TaskFlow v1.0 | Aula 8 — Views com JSP
    </p>

</body>
</html>
~~~

---

### Passo 4: Atualizando o TaskServlet para encaminhar ao list.jsp

Agora que o `list.jsp` existe, o `TaskServlet` deve parar de gerar HTML com `PrintWriter` e encaminhar para o JSP. Substitua o conteúdo de `src/main/java/com/taskflow/controller/TaskServlet.java`:

~~~java
// Pacote controller: camada responsável por receber requisições HTTP,
// coordenar o trabalho entre Model e View, e não fazer nada além disso.
package com.taskflow.controller;

// Importações do Jakarta EE.
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// Importação Java padrão.
import java.io.IOException;

// Mapeia este Servlet para a URL /tasks.
// Todas as requisições para /taskflow/tasks passam por aqui.
@WebServlet("/tasks")
public class TaskServlet extends HttpServlet {

    // Constantes para os caminhos dos JSPs.
    // Usar constantes evita erros de digitação e facilita refatoração futura.
    // Todos os caminhos começam com /WEB-INF/ — pasta protegida do servidor.
    private static final String VIEW_LIST = "/WEB-INF/views/task/list.jsp";
    private static final String VIEW_FORM = "/WEB-INF/views/task/form.jsp";

    // doGet: responde a requisições GET em /tasks.
    // FASE ATUAL (Aula 8): encaminha diretamente para o list.jsp.
    //   Não há dados ainda — o Model (TaskRepository) será criado na Aula 10.
    // FASE AULA 11 (completo): lerá o parâmetro "action", buscará tarefas
    //   no TaskRepository e encaminhará para o JSP correto com dados reais.
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lê o parâmetro "action" da URL para determinar o que fazer.
        // Exemplos de URL: /tasks (sem action → lista), /tasks?action=criar
        // Se "action" não for enviado, getParameter retorna null.
        // O operador || garante que null seja tratado como "listar".
        String action = request.getParameter("action");
        if (action == null) {
            action = "listar";
        }

        // Roteamento simples baseado no valor do parâmetro "action".
        // FASE ATUAL: apenas "listar" e "criar" estão implementados.
        // FASE AULA 11+: "detalhe", "editar", "remover" serão adicionados.
        switch (action) {
            case "criar":
                // Encaminha para o formulário de criação sem dados pré-preenchidos.
                encaminhar(request, response, VIEW_FORM);
                break;

            case "listar":
            default:
                // FASE ATUAL: encaminha para a listagem sem dados reais.
                // FASE AULA 11: chamará taskRepository.findAll() antes do forward.
                // request.setAttribute("tasks", taskRepository.findAll());
                encaminhar(request, response, VIEW_LIST);
                break;
        }
    }

    // doPost: responde a requisições POST em /tasks.
    // FASE ATUAL: ainda não implementado — será adicionado na Aula 12.
    // FASE AULA 12: processará a criação, edição e remoção de tarefas.
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Define o encoding da requisição para suportar acentos nos parâmetros POST.
        // Deve ser chamado ANTES de qualquer request.getParameter().
        request.setCharacterEncoding("UTF-8");

        // Por enquanto, redireciona de volta para a listagem.
        // Na Aula 12, este método processará os dados do formulário.
        response.sendRedirect(request.getContextPath() + "/tasks");
    }

    // Método auxiliar para encaminhar a requisição para um JSP.
    // Extrai o padrão repetitivo de obter o RequestDispatcher e chamar forward().
    // RequestDispatcher.forward() é interno ao servidor:
    //   - A URL no navegador NÃO muda (diferente do sendRedirect).
    //   - Os atributos do request são preservados (o JSP pode acessar via EL).
    //   - O JSP tem acesso ao mesmo request e response do Servlet.
    private void encaminhar(HttpServletRequest request,
                            HttpServletResponse response,
                            String caminhoJsp)
            throws ServletException, IOException {

        // Obtém o RequestDispatcher para o caminho do JSP especificado.
        // O caminho começa com / relativo à raiz do WAR (src/main/webapp/).
        RequestDispatcher dispatcher = request.getRequestDispatcher(caminhoJsp);

        // Encaminha a requisição e a resposta para o JSP.
        // A partir deste ponto, o JSP assume o controle da resposta.
        // NUNCA escreva no response depois de chamar forward() — causará IllegalStateException.
        dispatcher.forward(request, response);
    }
}
~~~

---

### Passo 5: Gerando o WAR e verificando no navegador

Execute o build completo — testes e WAR:

~~~
gradle clean test war
~~~

Confirme que todos os 13 testes continuam passando e que o WAR é gerado:

~~~text
BUILD SUCCESSFUL in Xs
~~~

Faça o deploy:

~~~
copy build\libs\taskflow.war C:\ferramentas\glassfish7\domains\domain1\autodeploy\
~~~

Aguarde o redeploy e teste as seguintes URLs:

~~~text
http://localhost:8080/taskflow/tasks
~~~

Deve exibir a página de listagem com a mensagem "Nenhuma tarefa cadastrada".

~~~text
http://localhost:8080/taskflow/tasks?action=criar
~~~

Deve exibir o formulário de nova tarefa com os campos Título, Descrição e Status.

~~~text
http://localhost:8080/taskflow/WEB-INF/views/task/list.jsp
~~~

Deve retornar **HTTP 403 Forbidden** — confirmando que os JSPs estão protegidos dentro de `WEB-INF`.

---

### Passo 6: Commit do progresso

~~~
git add src/main/webapp/WEB-INF/views/task/list.jsp
git add src/main/webapp/WEB-INF/views/task/form.jsp
git add src/main/java/com/taskflow/controller/TaskServlet.java
git commit -m "feat: adiciona Views JSP list.jsp e form.jsp e atualiza TaskServlet com forward"
~~~

---

## Glossário Técnico da Aula

**JSP (Jakarta Server Pages):** Tecnologia para criar Views dinâmicas em aplicações web Jakarta EE. Permite embutir expressões EL e tags JSTL em HTML, eliminando a necessidade de gerar HTML dentro de Servlets.

**Diretiva JSP:** Instrução processada pelo GlassFish durante a fase de tradução do JSP. Começa com `<%@` e termina com `%>`. As principais são `page`, `taglib` e `include`.

**Diretiva `page`:** Configura parâmetros globais do JSP: `contentType` (tipo de resposta e encoding), `pageEncoding` (encoding do arquivo), `import` (classes Java) e `isELIgnored` (ativa ou desativa EL).

**Diretiva `taglib`:** Declara o uso de uma biblioteca de tags no JSP. Requer `uri` (identificador da biblioteca) e `prefix` (prefixo usado antes de cada tag).

**Expression Language (EL):** Linguagem de expressão do Jakarta EE para exibir dados dinâmicos em JSPs sem Java puro. Usa a sintaxe `${expressao}`. Avaliada em tempo de execução pelo GlassFish.

**Escopos da EL:** As quatro áreas onde a EL busca valores: `pageScope`, `requestScope`, `sessionScope` e `applicationScope`. Busca na ordem do menor para o maior escopo.

**`${pageContext.request.contextPath}`:** Expressão EL que retorna o context root da aplicação. No TaskFlow: `/taskflow`. Evita hardcodar o context root nos links dos JSPs.

**`${param.nomeDoCampo}`:** Expressão EL que acessa diretamente os parâmetros da requisição HTTP. Equivale a `request.getParameter("nomeDoCampo")` no Java.

**`${empty variavel}`:** Operador EL que retorna `true` se a variável for `null`, uma coleção vazia ou uma string vazia. Muito usado para exibição condicional.

**Scriptlet:** Bloco de código Java embutido em JSP com `<% %>`. Proibido neste curso por violar o MVC e impossibilitar testes automatizados.

**`RequestDispatcher.forward()`:** Método que encaminha a requisição de um Servlet para outro recurso (geralmente um JSP) de forma interna ao servidor. A URL no navegador não muda e os atributos do request são preservados.

**`WEB-INF/`:** Pasta especial dentro do WAR que o servidor nunca serve diretamente ao navegador (retorna 403 Forbidden). JSPs colocados aqui só são acessíveis via `RequestDispatcher.forward()`, garantindo que o fluxo MVC seja respeitado.

**Tradução JSP:** Processo pelo qual o GlassFish converte um arquivo `.jsp` em uma classe Java equivalente a um `HttpServlet`. Ocorre na primeira requisição ou quando o arquivo é modificado.

**Compilação JSP:** Processo pelo qual o GlassFish compila a classe Java gerada na tradução em bytecode `.class`. Erros de sintaxe EL e de diretivas são detectados nesta fase.

**`switch (action)`:** Padrão de roteamento usado no `TaskServlet` para decidir qual ação executar com base no parâmetro `action` da URL. Será expandido com mais casos nas Aulas 11 e 12.

---

## Antecipação de Erros

**HTTP 404 ao acessar `/taskflow/tasks`:** O WAR não foi redeployado após a atualização do `TaskServlet`. Confirme que o novo WAR foi copiado para `autodeploy` e aguarde o redeploy completo. Verifique também se `@WebServlet("/tasks")` está presente na classe.

**`javax.servlet.ServletException: Servlet.init() for servlet TaskServlet threw exception`:** O `TaskServlet` tem um erro de compilação ou uma exceção no método `init`. Verifique o `server.log` do GlassFish para a mensagem de erro completa.

**EL não sendo avaliada — a página exibe literalmente `${tasks}` em vez do valor:** O atributo `isELIgnored` está definido como `true` na diretiva `page` ou o `web.xml` tem uma versão antiga (anterior a 2.4). Confirme que o `web.xml` declara `version="6.1"` com o namespace `https://jakarta.ee/xml/ns/jakartaee`.

**`javax.servlet.ServletException: PWC1232: Exceeded maximum depth for nested request dispatches`:** O `TaskServlet` está fazendo `forward` para si mesmo em vez de para o JSP — um loop infinito de forwards. Verifique o caminho passado ao `getRequestDispatcher`: deve ser `/WEB-INF/views/task/list.jsp`, não `/tasks`.

**`java.lang.IllegalStateException: Cannot forward after response has been committed`:** Você escreveu algo no `response` (com `getWriter()` ou `getOutputStream()`) antes de chamar `forward()`. O `forward()` deve ser sempre a última operação no método — nunca escreva no response depois dele.

**HTTP 403 ao tentar acessar `/tasks?action=criar` (em vez do formulário):** Não é erro — HTTP 403 ao acessar `WEB-INF` diretamente é o comportamento correto. Se aparecer 403 ao acessar `/tasks?action=criar`, verifique se o `doGet` do `TaskServlet` trata o caso `"criar"` no switch.

**Acentos incorretos no formulário (caracteres embaralhados):** O `request.setCharacterEncoding("UTF-8")` deve estar como primeira linha do `doPost` — antes de qualquer `request.getParameter()`. Se estiver depois, os parâmetros já foram decodificados com o encoding errado.

**`org.apache.jasper.JasperException: /WEB-INF/views/task/list.jsp (line: X)`:** Erro de sintaxe no JSP — provavelmente na EL ou em uma diretiva. O número da linha no erro aponta para a linha do arquivo `.jsp` original. Corrija a expressão EL ou a diretiva indicada.

---

## Exercício de Fixação

Este exercício cria a terceira View do TaskFlow seguindo os mesmos padrões estabelecidos nesta aula, e aprofunda o conhecimento de EL com o objeto implícito `${param}`.

**Parte 1 — Criando o detail.jsp:** Crie o arquivo `src/main/webapp/WEB-INF/views/task/detail.jsp`. Esta página exibirá os detalhes de uma tarefa individual. Use as expressões EL abaixo para exibir os campos — mesmo que por enquanto retornem strings vazias (o Model ainda não existe):

~~~jsp
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>TaskFlow — Detalhe da Tarefa</title>
</head>
<body>
    <h1>Detalhe da Tarefa</h1>
    <table border="1" cellpadding="8">
        <tr><th>ID</th><td>${task.id}</td></tr>
        <tr><th>Título</th><td>${task.titulo}</td></tr>
        <tr><th>Descrição</th><td>${task.descricao}</td></tr>
        <tr><th>Status</th><td>${task.status}</td></tr>
        <tr><th>Data de Criação</th><td>${task.dataCriacao}</td></tr>
    </table>
    <br>
    <a href="${pageContext.request.contextPath}/tasks">← Voltar para a lista</a>
</body>
</html>
~~~

**Parte 2 — Adicionando o roteamento no TaskServlet:** Adicione o caso `"detalhe"` ao `switch` do `doGet` do `TaskServlet`, de forma que quando `/tasks?action=detalhe&id=1` for acessado, o Controller encaminhe para o `detail.jsp`:

~~~java
case "detalhe":
    // Lê o id da URL como String.
    // Na Aula 11, converteremos para Long e buscaremos no TaskRepository.
    String id = request.getParameter("id");
    request.setAttribute("idSolicitado", id);
    encaminhar(request, response, "/WEB-INF/views/task/detail.jsp");
    break;
~~~

**Parte 3 — Verificando no navegador:** Gere o WAR e faça o deploy. Acesse `http://localhost:8080/taskflow/tasks?action=detalhe&id=1`. A página deve exibir a tabela com as células vazias (porque o Model ainda não existe). Confirme que `${pageContext.request.contextPath}` exibe `/taskflow` no link de voltar.

**Parte 4 — Reflexão:** Registre em `modulo_02_essencial/aula_08/exercicio_08.txt` as respostas para as seguintes perguntas: por que os JSPs ficam dentro de `WEB-INF` em vez de diretamente em `webapp/views/`? Qual é a diferença entre `${task.titulo}` e `${param.titulo}` — quando cada uma deve ser usada?

Ao final, faça o commit:

~~~
git add src/main/webapp/WEB-INF/views/task/detail.jsp
git add src/main/java/com/taskflow/controller/TaskServlet.java
git add modulo_02_essencial/aula_08/
git commit -m "feat: adiciona detail.jsp e roteamento action=detalhe no TaskServlet - aula 08"
~~~

---

## Resolução Comentada do Exercício

**Parte 2 — Roteamento:** O caso `"detalhe"` deve ser adicionado antes do `default` no switch. O `request.setAttribute("idSolicitado", id)` coloca o id no escopo do request para que o JSP possa acessá-lo via `${idSolicitado}` — embora o `detail.jsp` desta aula não o exiba, é boa prática passar os dados que o JSP pode precisar.

**Parte 3 — Verificação:** As células da tabela ficarão vazias porque `${task.id}`, `${task.titulo}`, etc. buscam um objeto chamado `task` no requestScope, sessionScope e applicationScope — e nenhum deles existe ainda. A EL não lança exceção nesses casos, simplesmente exibe string vazia. Esse comportamento silencioso é conveniente agora, mas na Aula 11 você garantirá que o Controller sempre coloca um objeto `task` no request antes de encaminhar para o `detail.jsp`.

**Parte 4 — Reflexão:** Os JSPs ficam dentro de `WEB-INF` porque o servidor garante que nenhuma requisição HTTP externa pode acessar diretamente arquivos dentro desta pasta — retornando sempre HTTP 403. Isso força o acesso via Controller (`RequestDispatcher.forward`), garantindo que o fluxo MVC seja sempre respeitado e que os dados necessários sejam sempre preparados antes da View ser executada. A diferença entre `${task.titulo}` e `${param.titulo}` é fundamental: `${task.titulo}` acessa a propriedade `titulo` de um objeto `task` que foi colocado no request via `request.setAttribute("task", objetoTask)` — usado para exibir dados vindos do Model. `${param.titulo}` acessa diretamente o parâmetro HTTP `titulo` da requisição (query string ou body do formulário) — usado para reexibir valores que o usuário digitou em um formulário quando a validação falha.

---

## Resumo dos Pontos-Chave

O **JSP** é a tecnologia de View do Jakarta EE que permite escrever HTML com expressões dinâmicas, invertendo o problema dos Servlets que geravam HTML via `PrintWriter`. O GlassFish processa JSPs em três etapas: **tradução** (JSP → classe Java), **compilação** (classe Java → bytecode) e **execução** (bytecode → HTML). A **diretiva `page`** configura parâmetros do JSP — sempre declare `contentType="text/html;charset=UTF-8"` e `pageEncoding="UTF-8"` para suporte a acentos. A **Expression Language** (`${expressao}`) exibe dados dinâmicos sem Java puro, buscando valores nos quatro escopos (page, request, session, application) em ordem. Os JSPs devem sempre ficar dentro de **`WEB-INF/`** para que só sejam acessíveis via `RequestDispatcher.forward()` — nunca diretamente pelo navegador. **Scriptlets `<% %>`** são proibidos porque violam o MVC e impossibilitam testes automatizados. O `TaskServlet` usa **`RequestDispatcher.forward()`** para encaminhar para os JSPs — a URL no navegador não muda e os atributos do request são preservados. O padrão de roteamento via parâmetro `action` (`/tasks?action=criar`, `/tasks?action=detalhe`) permite que um único Servlet Controller gerencie múltiplas ações relacionadas.

---

## Log de Estado do Projeto

~~~text
## Aula 8: Jakarta Server Pages: criando as Views com JSP
- Objetivo: Criar as páginas JSP que formarão a View do TaskFlow.
- Código Adicionado:
    src/main/webapp/WEB-INF/views/task/list.jsp — tabela de listagem com EL e estrutura HTML.
    src/main/webapp/WEB-INF/views/task/form.jsp — formulário de criação com campos titulo,
      descricao e status, usando ${param.*} para reexibição após erro.
    src/main/webapp/WEB-INF/views/task/detail.jsp — página de detalhe (exercício).
    src/main/java/com/taskflow/controller/TaskServlet.java — atualizado com forward()
      para list.jsp e form.jsp, método auxiliar encaminhar(), roteamento por action.
    modulo_02_essencial/aula_08/exercicio_08.txt
- Estado Funcional: ✅ /tasks exibe list.jsp com mensagem de lista vazia.
  /tasks?action=criar exibe form.jsp com o formulário de criação.
  /tasks?action=detalhe exibe detail.jsp com campos vazios (Model ainda não existe).
  /taskflow/WEB-INF/views/task/list.jsp retorna HTTP 403 (protegido corretamente).
  gradle clean test war gera BUILD SUCCESSFUL com 13 testes passando.
- Próximas Etapas: Aula 9 adicionará JSTL ao projeto, substituindo a linha
  placeholder da tabela por <c:forEach> iterando sobre ${tasks}, e adicionando
  <c:if> para exibição condicional da mensagem de lista vazia.
~~~

---

## Prompt de Continuidade para a Aula 9

"Sou aluno do curso Jakarta EE 11 com Java 21, Gradle, JUnit 5 e VS Code. Concluí a Aula 8 (Jakarta Server Pages: criando as Views com JSP). Os arquivos list.jsp, form.jsp e detail.jsp estão criados em src/main/webapp/WEB-INF/views/task/. O TaskServlet foi atualizado com RequestDispatcher.forward() para os JSPs e roteamento por parâmetro action. Acessar /tasks exibe o list.jsp. Acessar /tasks?action=criar exibe o form.jsp. Os JSPs estão dentro de WEB-INF e retornam 403 se acessados diretamente. O gradle clean test war gera BUILD SUCCESSFUL com 13 testes passando. Tenho o plano_mestre.txt, o log_estado_projeto.md e os prompts_individuais.md em anexo para contexto. Por favor, gere a **Aula 9: JSTL: exibindo dados na View sem Java puro**, seguindo rigorosamente a estrutura definida no plano mestre: teoria detalhada com mínimo de 2.000 palavras, analogia de ancoragem, diagrama Mermaid com blocos ~~~mermaid, código comentado linha a linha com blocos ~~~, glossário técnico, antecipação de erros, exercício com resolução comentada, resumo dos pontos-chave, log de estado do projeto atualizado e prompt de continuidade para a Aula 10. O documento inteiro deve estar dentro de um bloco ```markdown. Nenhum bloco interno deve usar triple backtick."

---

Dúvidas? Posso prosseguir para a **Aula 9: JSTL: exibindo dados na View sem Java puro**?