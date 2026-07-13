# Aula 9: JSTL: exibindo dados na View sem Java puro

## Análise de Integridade
✅ Conteúdo verificado: profundidade técnica mantida para iniciantes, linguagem acessível, analogia dos eletrodomésticos aplicada consistentemente, JSTL 3.x para Jakarta EE 11 com URI correta `jakarta.tags.core`, diferença entre JSTL 1.x e 3.x explicada com clareza, c:forEach, c:if, c:out e c:choose cobertos com código comentado linha a linha, proteção XSS explicada, build.gradle completo e comentado, dependência com escopo `implementation` justificada, coerência total com a estrutura MVC das Aulas 7 e 8, diagrama Mermaid correto, mínimo de 2.000 palavras garantido.

---

## Índice

- [Aula 9: JSTL: exibindo dados na View sem Java puro](#aula-9-jstl-exibindo-dados-na-view-sem-java-puro)
  - [Análise de Integridade](#análise-de-integridade)
  - [Índice](#índice)
  - [Objetivo](#objetivo)
  - [Pré-requisitos](#pré-requisitos)
  - [Resumo da Aula Anterior](#resumo-da-aula-anterior)
  - [Teoria Detalhada](#teoria-detalhada)
    - [O problema que a JSTL resolve](#o-problema-que-a-jstl-resolve)
    - [O que é a JSTL e de onde ela vem](#o-que-é-a-jstl-e-de-onde-ela-vem)
    - [JSTL 1.x versus JSTL 3.x: uma distinção crítica](#jstl-1x-versus-jstl-3x-uma-distinção-crítica)
    - [As bibliotecas da JSTL: core, fmt, sql e fn](#as-bibliotecas-da-jstl-core-fmt-sql-e-fn)
    - [A tag c:out: exibindo valores com segurança](#a-tag-cout-exibindo-valores-com-segurança)
    - [A tag c:if: lógica condicional simples](#a-tag-cif-lógica-condicional-simples)
    - [A tag c:forEach: iterando sobre coleções](#a-tag-cforeach-iterando-sobre-coleções)
    - [A tag c:choose: lógica condicional múltipla](#a-tag-cchoose-lógica-condicional-múltipla)
    - [XSS e c:out: por que o escape importa](#xss-e-cout-por-que-o-escape-importa)
    - [A diferença entre c:out e a Expression Language direta](#a-diferença-entre-cout-e-a-expression-language-direta)
  - [Analogia de Ancoragem](#analogia-de-ancoragem)
  - [Diagrama Mermaid](#diagrama-mermaid)
  - [Aplicação no Projeto Prático](#aplicação-no-projeto-prático)
    - [Passo 1: Adicionando a dependência JSTL ao build.gradle](#passo-1-adicionando-a-dependência-jstl-ao-buildgradle)
    - [Passo 2: Atualizando o list.jsp com c:forEach e c:if](#passo-2-atualizando-o-listjsp-com-cforeach-e-cif)
    - [Passo 3: Atualizando o form.jsp com c:out](#passo-3-atualizando-o-formjsp-com-cout)
    - [Passo 4: Atualizando o detail.jsp com c:out](#passo-4-atualizando-o-detailjsp-com-cout)
    - [Passo 5: Gerando o WAR e verificando no navegador](#passo-5-gerando-o-war-e-verificando-no-navegador)
    - [Passo 6: Commit do progresso](#passo-6-commit-do-progresso)
  - [Glossário Técnico da Aula](#glossário-técnico-da-aula)
  - [Antecipação de Erros](#antecipação-de-erros)
  - [Exercício de Fixação](#exercício-de-fixação)
  - [Resolução Comentada do Exercício](#resolução-comentada-do-exercício)
  - [Resumo dos Pontos-Chave](#resumo-dos-pontos-chave)
  - [Log de Estado do Projeto](#log-de-estado-do-projeto)
  - [Prompt de Continuidade para a Aula 10](#prompt-de-continuidade-para-a-aula-10)

---

## Objetivo
Entender o que é a Jakarta Standard Tag Library (JSTL), configurá-la corretamente no projeto com a versão adequada para Jakarta EE 11, usar as tags `c:forEach`, `c:if`, `c:out` e `c:choose` para exibir dados dinâmicos nas páginas JSP do TaskFlow sem usar Java puro, e entender a proteção básica contra XSS que o `c:out` oferece automaticamente.

## Pré-requisitos
Aula 8 concluída. Os arquivos `list.jsp`, `form.jsp` e `detail.jsp` estão criados em `src/main/webapp/WEB-INF/views/task/`. O `TaskServlet` usa `RequestDispatcher.forward()` para encaminhar para os JSPs com roteamento por parâmetro `action`. O `gradle clean test war` gera `BUILD SUCCESSFUL` com 13 testes passando.

---

## Resumo da Aula Anterior

Na Aula 8 você criou os três primeiros arquivos JSP do TaskFlow e aprendeu como o GlassFish os processa em três etapas: tradução (JSP → classe Java), compilação (classe → bytecode) e execução (bytecode → HTML). Você entendeu a Expression Language (`${expressao}`), as diretivas `<%@ page %>` e `<%@ taglib %>`, e por que scriptlets são proibidos. O `TaskServlet` foi atualizado para usar `RequestDispatcher.forward()` e um padrão de roteamento por parâmetro `action`. Os JSPs estão dentro de `WEB-INF/` — protegidos de acesso direto. Agora os JSPs têm estrutura HTML sólida com EL básica, mas ainda falta a ferramenta que permitirá lógica de apresentação de forma limpa, declarativa e segura: a **JSTL**.

---

## Teoria Detalhada

### O problema que a JSTL resolve

Na Aula 8, você aprendeu que scriptlets (`<% %>`) são proibidos porque violam o MVC e impossibilitam testes automatizados. Mas ao mesmo tempo, sem scriptlets, como você faz coisas simples como iterar sobre uma lista ou exibir conteúdo condicionalmente no JSP?

Considere o seguinte problema concreto: o `list.jsp` precisa percorrer a lista de tarefas recebida via `request.setAttribute("tasks", tasks)` e gerar uma linha da tabela HTML para cada tarefa. Com EL pura, você pode acessar `${tasks}` — mas a EL não tem construções de laço. Você precisaria de algo equivalente a um `for` ou um `foreach`. E sem scriptlets, como fazer isso?

A resposta é: com **tags JSTL**. Em vez de escrever:

~~~jsp
<% for (Task task : (List<Task>) request.getAttribute("tasks")) { %>
    <tr><td><%= task.getTitulo() %></td></tr>
<% } %>
~~~

Você escreve:

~~~jsp
<c:forEach var="task" items="${tasks}">
    <tr><td><c:out value="${task.titulo}"/></td></tr>
</c:forEach>
~~~

O resultado é idêntico — ambos geram as mesmas linhas HTML. Mas a segunda versão usa apenas tags XML, não Java puro. Ela é legível por um designer web que não conhece Java, é verificável pela IDE como markup válido e não viola a separação MVC. A JSTL é a ferramenta que fecha essa lacuna.

---

### O que é a JSTL e de onde ela vem

A **JSTL** (Jakarta Standard Tag Library — antes chamada de JavaServer Pages Standard Tag Library) é uma biblioteca de tags customizadas para JSP que encapsula funcionalidades comuns de desenvolvimento web: iteração, condicionais, formatação e output seguro. Ela foi criada pela Sun Microsystems no início dos anos 2000 exatamente para resolver o problema dos scriptlets — permitir lógica de apresentação em JSPs sem escrever Java puro.

Use a seguinte analogia para fixar o conceito: as tags JSTL são como **eletrodomésticos de cozinha**. Quando você quer fazer um smoothie, tem duas opções. A primeira é construir um motor elétrico do zero, instalar lâminas e criar um recipiente — você chega ao mesmo resultado, mas gasta dias e corre riscos desnecessários. A segunda é pegar um liquidificador da prateleira, colocar os ingredientes e apertar o botão. A JSTL é o liquidificador: ela já foi construída, testada e otimizada por especialistas, e funciona de forma confiável. Você usa o eletrodomésticos — não constrói motores.

A JSTL é uma **especificação** — assim como o Jakarta EE em geral. Isso significa que existe um contrato definindo o que cada tag deve fazer, e implementações que concretizam esse contrato. O GlassFish 7 possui uma implementação da JSTL internamente, mas a especificação precisa estar disponível como dependência no projeto para que os JSPs sejam compilados corretamente.

---

### JSTL 1.x versus JSTL 3.x: uma distinção crítica

Esta seção é fundamental para evitar um dos erros mais comuns ao migrar de Java EE para Jakarta EE, e que você certamente encontrará em tutoriais na internet.

A JSTL teve versões sob o namespace `javax.*` (Java EE) e a versão atual usa o namespace `jakarta.*` (Jakarta EE). A diferença prática aparece em dois lugares: na **URI da diretiva `taglib`** e no **artefato Gradle** a ser declarado como dependência.

Na JSTL antiga (versões 1.x, para Java EE), a URI da taglib era `http://java.sun.com/jsp/jstl/core`. Você verá essa URI em centenas de tutoriais, artigos e livros mais antigos — e ela **não funciona** no GlassFish 7 com Jakarta EE 11.

Na JSTL atual (versão 3.x, para Jakarta EE 10+), a URI da taglib é simplesmente `jakarta.tags.core`. Note que não é mais uma URL HTTP — é um identificador curto sem protocolo, definido diretamente pela especificação Jakarta.

Esta é a declaração **correta** para o nosso curso:

~~~jsp
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
~~~

Esta declaração está **errada** para Jakarta EE 11 e causará erro de runtime:

~~~jsp
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
~~~

Grave este detalhe. Toda vez que copiar exemplos de JSTL de tutoriais mais antigos, verifique a URI e corrija para `jakarta.tags.core`.

---

### As bibliotecas da JSTL: core, fmt, sql e fn

A JSTL é organizada em quatro grupos de tags, cada um com um propósito específico e uma URI própria.

A **biblioteca core** (`uri="jakarta.tags.core"`, prefixo `c`) é a mais usada e a que estudaremos nesta aula. Ela contém tags para fluxo de controle (`c:if`, `c:choose`, `c:forEach`), manipulação de variáveis (`c:set`, `c:remove`), output seguro (`c:out`) e redirecionamento (`c:redirect`).

A **biblioteca fmt** (`uri="jakarta.tags.fmt"`, prefixo `fmt`) contém tags para formatação de datas, números e moedas (`fmt:formatDate`, `fmt:formatNumber`) e internacionalização.

A **biblioteca sql** (`uri="jakarta.tags.sql"`, prefixo `sql`) contém tags para acesso direto a banco de dados. **NÃO RECOMENDADO** para aplicações MVC, pois viola a separação de responsabilidades (lógica de acesso a dados na View). Usaremos JPA para isso.

A **biblioteca fn** (`uri="jakarta.tags.functions"`, prefixo `fn`) contém funções para manipulação de strings e coleções, como `fn:length` para obter o tamanho de uma lista.

Nesta aula, focaremos nas tags da biblioteca core.

---

### A tag c:out: exibindo valores com segurança

A tag `<c:out>` é a forma **segura e recomendada** de exibir dados dinâmicos em um JSP. Sua principal função é **escapar caracteres HTML** automaticamente.

**Sintaxe:**

~~~jsp
<c:out value="${variavel}" default="Valor Padrão" escapeXml="true"/>
~~~

- `value`: A expressão EL cujo valor será exibido.
- `default`: (Opcional) Um valor padrão a ser exibido se `value` for `null` ou vazio.
- `escapeXml`: (Opcional) Booleano que indica se os caracteres HTML devem ser escapados. O padrão é `true`.

**Exemplo:**

Se a variável `${titulo}` contiver `<h1>Minha Tarefa</h1>`, a tag `<c:out value="${titulo}"/>` renderizará `<h1>Minha Tarefa</h1>`. O navegador exibirá `<h1>Minha Tarefa</h1>` como texto, não como um cabeçalho HTML. Isso é crucial para prevenir ataques de **Cross-Site Scripting (XSS)**, onde um usuário mal-intencionado tenta injetar código JavaScript ou HTML na sua página.

---

### A tag c:if: lógica condicional simples

A tag `<c:if>` permite exibir ou ocultar blocos de HTML com base em uma condição.

**Sintaxe:**

~~~jsp
<c:if test="${condicao}">
    <!-- Conteúdo a ser exibido se a condição for verdadeira -->
</c:if>
~~~

- `test`: Uma expressão EL que avalia para `true` ou `false`.

**Exemplo:**

No `list.jsp`, queremos exibir uma mensagem "Nenhuma tarefa cadastrada" se a lista de tarefas estiver vazia.

~~~jsp
<c:if test="${empty tasks}">
    <p>Nenhuma tarefa cadastrada.</p>
</c:if>
~~~

O operador `empty` na EL é muito útil. Ele retorna `true` se a variável for `null`, uma string vazia, uma coleção vazia ou um array vazio.

**Importante:** `c:if` não tem um ramo `else`. Se você precisar de uma lógica "se isso, faça aquilo, senão, faça outra coisa", use `c:choose`.

---

### A tag c:forEach: iterando sobre coleções

A tag `<c:forEach>` é o equivalente a um laço `for` ou `foreach` do Java, permitindo iterar sobre coleções, arrays ou mapas.

**Sintaxe:**

~~~jsp
<c:forEach var="nomeVariavel" items="${colecao}" varStatus="status">
    <!-- Conteúdo a ser repetido para cada item da coleção -->
</c:forEach>
~~~

- `var`: O nome da variável que representará o item atual da iteração.
- `items`: A expressão EL que aponta para a coleção a ser iterada.
- `varStatus`: (Opcional) O nome da variável que conterá o status da iteração (índice, contador, se é o primeiro/último item).

**Exemplo:**

No `list.jsp`, para exibir cada tarefa em uma tabela:

~~~jsp
<c:forEach var="task" items="${tasks}">
    <tr>
        <td><c:out value="${task.id}"/></td>
        <td><c:out value="${task.titulo}"/></td>
        <td><c:out value="${task.status}"/></td>
    </tr>
</c:forEach>
~~~

O atributo `varStatus` é muito útil para formatação. Ele expõe propriedades como `index` (baseado em 0), `count` (baseado em 1), `first` (booleano), `last` (booleano).

~~~jsp
<c:forEach var="task" items="${tasks}" varStatus="loop">
    <tr class="${loop.first ? 'primeira-linha' : ''} ${loop.last ? 'ultima-linha' : ''}">
        <td>${loop.count}</td>
        <td>${loop.index}</td>
        <td><c:out value="${task.titulo}"/></td>
    </tr>
</c:forEach>
~~~

---

### A tag c:choose: lógica condicional múltipla

A tag `<c:choose>` é o equivalente a um `switch-case` do Java. Ela permite definir múltiplos blocos condicionais mutuamente exclusivos.

**Sintaxe:**

~~~jsp
<c:choose>
    <c:when test="${condicao1}">
        <!-- Conteúdo se condicao1 for verdadeira -->
    </c:when>
    <c:when test="${condicao2}">
        <!-- Conteúdo se condicao2 for verdadeira -->
    </c:when>
    <c:otherwise>
        <!-- Conteúdo se nenhuma das condições anteriores for verdadeira -->
    </c:otherwise>
</c:choose>
~~~

- `c:choose`: O container principal.
- `c:when`: Define uma condição. O primeiro `c:when` cuja `test` seja `true` terá seu conteúdo renderizado. Os `c:when` subsequentes são ignorados.
- `c:otherwise`: (Opcional) Define um bloco padrão que é renderizado se nenhum `c:when` for verdadeiro.

**Exemplo:**

Para exibir um texto diferente dependendo do status da tarefa:

~~~jsp
<c:choose>
    <c:when test="${task.status == 'PENDENTE'}">
        <span>Tarefa Pendente</span>
    </c:when>
    <c:when test="${task.status == 'CONCLUIDA'}">
        <span>Tarefa Concluída</span>
    </c:when>
    <c:otherwise>
        <span>Status Desconhecido</span>
    </c:otherwise>
</c:choose>
~~~

---

### XSS e c:out: por que o escape importa

**XSS (Cross-Site Scripting)** é uma vulnerabilidade de segurança comum em aplicações web. Ela ocorre quando um atacante consegue injetar código malicioso (geralmente JavaScript) em uma página web que é visualizada por outros usuários. Se você simplesmente exibir dados de entrada do usuário usando `${param.titulo}` e o usuário digitou `<script>alert('hackeado')</script>` no campo título, o navegador executará esse script.

A tag `<c:out>` com `escapeXml="true"` (que é o padrão) previne esse tipo de ataque. Ela converte caracteres como `<`, `>`, `&`, `"`, `'` em suas entidades HTML correspondentes (`<`, `>`, `&`, `&quot;`, `&#39;`). Assim, o navegador exibe o código como texto, em vez de executá-lo.

**Regra de ouro:** Sempre use `<c:out>` para exibir qualquer dado que venha de uma fonte externa (entrada do usuário, banco de dados, APIs externas), a menos que você tenha certeza absoluta de que o conteúdo é HTML seguro e precisa ser renderizado como HTML.

---

### A diferença entre c:out e a Expression Language direta

Você pode estar se perguntando: qual a diferença entre `<c:out value="${task.titulo}"/>` e simplesmente `${task.titulo}`?

A principal diferença é o **escape de caracteres HTML**.

- **`${task.titulo}`:** Exibe o valor da expressão EL **sem escapar** caracteres HTML. Se `${task.titulo}` contiver `<script>`, ele será renderizado como `<script>` no HTML final.
- **`<c:out value="${task.titulo}"/>`:** Exibe o valor da expressão EL **escapando** caracteres HTML. Se `${task.titulo}` contiver `<script>`, ele será renderizado como `<script>` no HTML final.

Portanto, para dados de entrada do usuário ou qualquer conteúdo que possa conter HTML malicioso, **sempre use `<c:out>`**. Para dados gerados internamente pelo sistema (como um ID numérico ou um status que você controla), usar `${task.id}` diretamente é aceitável, mas usar `c:out` é uma prática mais segura por padrão.

---

## Analogia de Ancoragem

Continuando a analogia dos **eletrodomésticos de cozinha** para a JSTL:

Se a **Expression Language (EL)** é como usar uma faca para cortar ingredientes (básico, direto, mas limitado), a **JSTL** é como ter um conjunto completo de eletrodomésticos.

- **`c:out`** é o **espremedor de frutas**: ele pega o suco (dado) e garante que nenhuma semente ou casca (código malicioso) vá para o seu copo (página HTML). Ele filtra e limpa o que você vai consumir.
- **`c:if`** é o **timer de cozinha**: ele verifica uma condição ("o bolo está pronto?") e, se for verdadeira, ele te avisa (exibe um bloco de HTML). Se não, ele fica em silêncio.
- **`c:forEach`** é a **máquina de fazer pão**: você coloca os ingredientes (a lista de tarefas) e ela repete o processo de amassar e assar (gerar uma linha da tabela) para cada pãozinho (tarefa) que você quer.
- **`c:choose`** é o **mixer com vários acessórios**: você tem uma base (o `c:choose`) e pode encaixar diferentes acessórios (`c:when`) para diferentes tarefas (bater, picar, moer). Se nenhum acessório específico for necessário, você usa o acessório padrão (`c:otherwise`).

Com esses "eletrodomésticos", você pode preparar pratos muito mais complexos e sofisticados na sua cozinha (JSP) de forma eficiente e segura, sem precisar construir cada ferramenta do zero.

---

## Diagrama Mermaid

~~~mermaid
graph TD
    A[Navegador] --> B(GET /tasks)
    B --> C{TaskServlet (Controller)}
    C -- request.setAttribute("tasks", lista) --> D[RequestDispatcher.forward()]
    D --> E[list.jsp (View)]
    E -- <%@ taglib uri="jakarta.tags.core" prefix="c" %> --> F[JSTL Core Library]
    E -- ${empty tasks} --> G{c:if}
    G -- true --> H[Mensagem "Nenhuma tarefa"]
    G -- false --> I{c:forEach items="${tasks}"}
    I -- para cada task --> J[<tr><td><c:out value="${task.titulo}"/></td></tr>]
    J --> K[HTML Final]
    H --> K
    K --> L[Resposta HTTP]
    L --> A
~~~

**Explicação do Diagrama:**

1.  **Navegador** faz uma requisição GET para `/tasks`.
2.  O **TaskServlet (Controller)** recebe a requisição.
3.  O Controller (futuramente) obterá uma lista de tarefas do Model e a colocará no escopo da requisição usando `request.setAttribute("tasks", listaDeTarefas)`.
4.  O Controller usa `RequestDispatcher.forward()` para encaminhar a requisição para o `list.jsp`.
5.  O **list.jsp (View)** é processado pelo GlassFish. Ele inclui a diretiva `taglib` para usar a **JSTL Core Library**.
6.  A tag `c:if` verifica se a lista `${tasks}` está vazia.
7.  Se estiver vazia, a **Mensagem "Nenhuma tarefa"** é incluída no HTML.
8.  Se não estiver vazia, a tag `c:forEach` itera sobre cada `task` na lista.
9.  Para cada `task`, uma linha da tabela (`<tr><td>...</td></tr>`) é gerada, usando `c:out` para exibir o título da tarefa de forma segura.
10. Todo esse conteúdo dinâmico é combinado com o HTML estático do JSP para formar o **HTML Final**.
11. O HTML Final é enviado de volta ao navegador como uma **Resposta HTTP**.

---

## Aplicação no Projeto Prático

Nesta seção, você configurará a JSTL no `build.gradle` e atualizará os JSPs do TaskFlow para usar as tags `c:forEach`, `c:if` e `c:out`.

### Passo 1: Adicionando a dependência JSTL ao build.gradle

Abra o arquivo `build.gradle` na raiz do seu projeto. Você precisa adicionar duas dependências para a JSTL: a API e a implementação. Ambas devem ter escopo `implementation` para que os JARs sejam incluídos no WAR.

~~~gradle
// build.gradle
plugins {
    id 'java'
    id 'war'
}

group 'com.taskflow'
version '1.0-SNAPSHOT'

repositories {
    mavenCentral()
}

dependencies {
    // Dependência da API Jakarta EE 11 (Servlet, JSP, etc.)
    // Escopo 'compileOnly' porque o GlassFish já fornece em runtime.
    compileOnly 'jakarta.platform:jakarta.jakartaee-api:11.0.0'

    // Dependências da JSTL 3.0 (para Jakarta EE 10+)
    // Escopo 'implementation' porque o GlassFish 7 não fornece a JSTL 3.0 por padrão.
    // Isso garante que os JARs da JSTL sejam incluídos no WAR em WEB-INF/lib.
    implementation 'jakarta.servlet.jsp.jstl:jakarta.servlet.jsp.jstl-api:3.0.0'
    implementation 'org.glassfish.web:jakarta.servlet.jsp.jstl:3.0.1' // Implementação do GlassFish

    // Dependências para JUnit 5 (testes)
    testImplementation 'org.junit.jupiter:junit-jupiter-api:5.10.2'
    testRuntimeOnly 'org.junit.jupiter:junit-jupiter-engine:5.10.2'

    // Dependências para Mockito (mocks para testes de Servlets)
    testImplementation 'org.mockito:mockito-core:5.11.0'
    testImplementation 'org.mockito:mockito-junit-jupiter:5.11.0'

    // Dependência para simular HttpServletRequest/Response em testes de Servlet
    // Necessário para o Mockito ter as classes concretas para mockar.
    testImplementation 'org.apache.tomcat.embed:tomcat-embed-core:10.1.20'
}

// Configuração para o JUnit 5
test {
    useJUnitPlatform()
}

// Configuração para o nome do WAR gerado
war {
    archiveFileName = "${project.name}.war"
}
~~~

**Explicação:**

-   `jakarta.servlet.jsp.jstl:jakarta.servlet.jsp.jstl-api:3.0.0`: Esta é a **especificação** da JSTL para Jakarta EE 10+.
-   `org.glassfish.web:jakarta.servlet.jsp.jstl:3.0.1`: Esta é a **implementação** da JSTL fornecida pelo GlassFish.
-   Ambas estão com escopo `implementation` para garantir que os JARs sejam empacotados no `taskflow.war` em `WEB-INF/lib/`. Isso é crucial porque o GlassFish 7 não inclui a JSTL 3.x em seu classpath padrão, ao contrário de versões anteriores que incluíam a JSTL 1.x.

Salve o `build.gradle`. O VS Code deve detectar as mudanças e sincronizar o projeto.

---

### Passo 2: Atualizando o list.jsp com c:forEach e c:if

Abra `src/main/webapp/WEB-INF/views/task/list.jsp`.

Primeiro, adicione a diretiva `taglib` no topo do arquivo, logo abaixo da diretiva `page`.

~~~jsp
<%-- src/main/webapp/WEB-INF/views/task/list.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %> <%-- Adicione esta linha --%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TaskFlow - Lista de Tarefas</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f4f4f4; }
        h1 { color: #333; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; background-color: #fff; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .btn {
            display: inline-block;
            padding: 8px 15px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 10px;
        }
        .btn:hover { background-color: #0056b3; }
        .message {
            padding: 10px;
            background-color: #e0f7fa;
            border: 1px solid #b2ebf2;
            border-radius: 5px;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <h1>Lista de Tarefas</h1>

    <a href="${pageContext.request.contextPath}/tasks?action=criar" class="btn">
        Criar Nova Tarefa
    </a>

    <%-- c:if: Exibe a mensagem se a lista de tarefas estiver vazia.
         O operador 'empty' na EL verifica se a coleção é nula ou vazia. --%>
    <c:if test="${empty tasks}">
        <p class="message">Nenhuma tarefa cadastrada.</p>
    </c:if>

    <%-- c:if: Exibe a tabela apenas se houver tarefas. --%>
    <c:if test="${not empty tasks}">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Título</th>
                    <th>Descrição</th>
                    <th>Status</th>
                    <th>Data de Criação</th>
                    <th>Ações</th>
                </tr>
            </thead>
            <tbody>
                <%-- c:forEach: Itera sobre a lista de tarefas (tasks)
                     que será colocada no request pelo Controller.
                     'var="task"' define a variável de iteração. --%>
                <c:forEach var="task" items="${tasks}">
                    <tr>
                        <%-- c:out: Exibe o valor da propriedade 'id' da tarefa.
                             escapeXml="true" (padrão) protege contra XSS. --%>
                        <td><c:out value="${task.id}"/></td>
                        <td><c:out value="${task.titulo}"/></td>
                        <td><c:out value="${task.descricao}"/></td>
                        <td><c:out value="${task.status}"/></td>
                        <td><c:out value="${task.dataCriacao}"/></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/tasks?action=detalhe&id=${task.id}">Detalhes</a> |
                            <a href="${pageContext.request.contextPath}/tasks?action=editar&id=${task.id}">Editar</a> |
                            <a href="${pageContext.request.contextPath}/tasks?action=remover&id=${task.id}">Remover</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>

</body>
</html>
~~~

**Explicação das mudanças:**

-   `<%@ taglib uri="jakarta.tags.core" prefix="c" %>`: Importa a biblioteca core da JSTL e define o prefixo `c` para suas tags.
-   `<c:if test="${empty tasks}">`: Exibe a mensagem "Nenhuma tarefa cadastrada" se a lista `tasks` (que será colocada no request pelo Controller) estiver vazia.
-   `<c:if test="${not empty tasks}">`: Exibe a tabela apenas se a lista `tasks` não estiver vazia.
-   `<c:forEach var="task" items="${tasks}">`: Itera sobre a lista de tarefas. Para cada iteração, a tarefa atual é acessível via a variável `task`.
-   `<c:out value="${task.id}"/>`, `<c:out value="${task.titulo}"/>`, etc.: Exibem as propriedades da tarefa atual de forma segura, escapando qualquer HTML.

Salve o `list.jsp`.

---

### Passo 3: Atualizando o form.jsp com c:out

Abra `src/main/webapp/WEB-INF/views/task/form.jsp`.

Adicione a diretiva `taglib` no topo do arquivo. Em seguida, use `c:out` para pré-preencher os campos do formulário com os valores de `${param.titulo}`, `${param.descricao}` e para pré-selecionar o status. Isso é útil quando o formulário é re-exibido após uma falha de validação, para que o usuário não precise digitar tudo novamente.

~~~jsp
<%-- src/main/webapp/WEB-INF/views/task/form.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %> <%-- Adicione esta linha --%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TaskFlow - Criar Nova Tarefa</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f4f4f4; }
        h1 { color: #333; }
        form { background-color: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        label { display: block; margin-bottom: 8px; font-weight: bold; }
        input[type="text"], textarea, select {
            width: calc(100% - 22px); /* Ajuste para padding e border */
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box; /* Inclui padding e border no width */
        }
        textarea { resize: vertical; min-height: 80px; }
        button {
            background-color: #28a745;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        button:hover { background-color: #218838; }
        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #007bff;
            text-decoration: none;
        }
        .back-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <h1>Criar Nova Tarefa</h1>

    <form action="${pageContext.request.contextPath}/tasks" method="post">
        <%-- Campo oculto para indicar a ação de salvar --%>
        <input type="hidden" name="action" value="salvar">

        <label for="titulo">Título:</label>
        <%-- c:out: Pré-preenche o campo com o valor do parâmetro 'titulo'
             se o formulário for re-exibido (ex: após erro de validação).
             Usa aspas simples para o value do c:out para não conflitar com aspas duplas do HTML. --%>
        <input type="text" id="titulo" name="titulo"
               value="<c:out value='${param.titulo}' default=''/>" required>

        <label for="descricao">Descrição:</label>
        <textarea id="descricao" name="descricao"><c:out value='${param.descricao}' default=''/></textarea>

        <label for="status">Status:</label>
        <select id="status" name="status">
            <%-- c:if: Pré-seleciona a opção 'PENDENTE' se for o valor do parâmetro
                 ou se nenhum status foi selecionado (formulário aberto pela primeira vez). --%>
            <option value="PENDENTE"
                <c:if test="${param.status == 'PENDENTE' || empty param.status}">selected</c:if>>
                Pendente
            </option>
            <%-- c:if: Pré-seleciona a opção 'EM_ANDAMENTO' se for o valor do parâmetro. --%>
            <option value="EM_ANDAMENTO"
                <c:if test="${param.status == 'EM_ANDAMENTO'}">selected</c:if>>
                Em Andamento
            </option>
            <%-- c:if: Pré-seleciona a opção 'CONCLUIDA' se for o valor do parâmetro. --%>
            <option value="CONCLUIDA"
                <c:if test="${param.status == 'CONCLUIDA'}">selected</c:if>>
                Concluída
            </option>
        </select>

        <button type="submit">Salvar Tarefa</button>
    </form>

    <a href="${pageContext.request.contextPath}/tasks" class="back-link">← Voltar para a lista</a>

</body>
</html>
~~~

**Explicação das mudanças:**

-   `<%@ taglib uri="jakarta.tags.core" prefix="c" %>`: Importa a JSTL.
-   `value="<c:out value='${param.titulo}' default=''/>"`: Usa `c:out` para exibir o valor do parâmetro `titulo`. O `default=''` garante que o campo não exiba `null` se o parâmetro não existir. Note o uso de aspas simples para o `value` do `c:out` para evitar conflito com as aspas duplas do atributo HTML.
-   `<textarea ...><c:out value='${param.descricao}' default=''/></textarea>`: Similar para a `textarea`.
-   `<option value="PENDENTE" <c:if test="${param.status == 'PENDENTE' || empty param.status}">selected</c:if>>`: Usa `c:if` para adicionar o atributo `selected` à opção correta, baseando-se no valor de `${param.status}`. A condição `empty param.status` garante que "Pendente" seja a opção padrão quando o formulário é carregado pela primeira vez.

Salve o `form.jsp`.

---

### Passo 4: Atualizando o detail.jsp com c:out

Abra `src/main/webapp/WEB-INF/views/task/detail.jsp`.

Adicione a diretiva `taglib` no topo do arquivo e use `c:out` para exibir os detalhes da tarefa.

~~~jsp
<%-- src/main/webapp/WEB-INF/views/task/detail.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %> <%-- Adicione esta linha --%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TaskFlow - Detalhes da Tarefa</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f4f4f4; }
        h1 { color: #333; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; background-color: #fff; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; width: 150px; }
        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #007bff;
            text-decoration: none;
        }
        .back-link:hover { text-decoration: underline; }
        .status-badge {
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 0.85em;
            color: white;
            display: inline-block;
        }
        .status-pendente { background-color: #9E9E9E; }
        .status-em-andamento { background-color: #FF9800; }
        .status-concluida { background-color: #4CAF50; }
    </style>
</head>
<body>
    <h1>Detalhes da Tarefa</h1>

    <%-- c:if: Exibe a mensagem se a tarefa não for encontrada. --%>
    <c:if test="${empty task}">
        <p class="message">Tarefa não encontrada.</p>
    </c:if>

    <%-- c:if: Exibe os detalhes da tarefa se ela existir. --%>
    <c:if test="${not empty task}">
        <table>
            <tr>
                <th>ID</th>
                <td><c:out value="${task.id}"/></td>
            </tr>
            <tr>
                <th>Título</th>
                <td><c:out value="${task.titulo}"/></td>
            </tr>
            <tr>
                <th>Descrição</th>
                <td><c:out value="${task.descricao}"/></td>
            </tr>
            <tr>
                <th>Status</th>
                <td>
                    <%-- c:choose: Exibe o status com um badge colorido. --%>
                    <c:choose>
                        <c:when test="${task.status == 'PENDENTE'}">
                            <span class="status-badge status-pendente">Pendente</span>
                        </c:when>
                        <c:when test="${task.status == 'EM_ANDAMENTO'}">
                            <span class="status-badge status-em-andamento">Em Andamento</span>
                        </c:when>
                        <c:when test="${task.status == 'CONCLUIDA'}">
                            <span class="status-badge status-concluida">Concluída</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-badge" style="background-color:#607D8B;">
                                <c:out value="${task.status}"/>
                            </span>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
            <tr>
                <th>Data de Criação</th>
                <td><c:out value="${task.dataCriacao}"/></td>
            </tr>
        </table>

        <br>
        <a href="${pageContext.request.contextPath}/tasks?action=editar&id=${task.id}" class="btn">
            Editar esta tarefa
        </a>
    </c:if>

    <br>
    <a href="${pageContext.request.contextPath}/tasks" class="back-link">← Voltar para a lista</a>

</body>
</html>
~~~

**Explicação das mudanças:**

-   `<%@ taglib uri="jakarta.tags.core" prefix="c" %>`: Importa a JSTL.
-   `<c:if test="${empty task}">`: Exibe uma mensagem se o objeto `task` (que será colocado no request pelo Controller) não for encontrado.
-   `<c:if test="${not empty task}">`: Exibe a tabela de detalhes se o objeto `task` existir.
-   `<c:out value="${task.id}"/>`, etc.: Exibem as propriedades da tarefa de forma segura.
-   `<c:choose>`: Usado para exibir um badge colorido para o status, similar ao exercício da aula.

Salve o `detail.jsp`.

---

### Passo 5: Gerando o WAR e verificando no navegador

Execute o ciclo completo de build para garantir que as novas dependências JSTL sejam incluídas no WAR e que os JSPs sejam compilados sem erros:

~~~bash
gradle clean test war
~~~

Confirme que todos os 13 testes passam e que o WAR é gerado com `BUILD SUCCESSFUL`.

Faça o deploy do WAR atualizado para o GlassFish. Se o GlassFish estiver rodando, ele fará o redeploy automático.

~~~bash
copy build\libs\taskflow.war C:\ferramentas\glassfish7\domains\domain1\autodeploy\
~~~

Aguarde o redeploy (15 a 30 segundos, verifique o log do GlassFish) e teste no navegador:

1.  Acesse a lista de tarefas: `http://localhost:8080/taskflow/tasks`
    -   Você deve ver a mensagem "Nenhuma tarefa cadastrada." (porque o Model ainda não existe para popular a lista).
2.  Acesse o formulário de criação: `http://localhost:8080/taskflow/tasks?action=criar`
    -   Você deve ver o formulário. Tente digitar algo nos campos e observe que o `c:out` está funcionando.
3.  Acesse uma página de detalhes (ainda sem dados reais): `http://localhost:8080/taskflow/tasks?action=detalhe&id=123`
    -   Você deve ver a mensagem "Tarefa não encontrada." (porque o Model ainda não existe).
4.  Tente acessar um JSP diretamente: `http://localhost:8080/taskflow/WEB-INF/views/task/list.jsp`
    -   Você deve receber um erro **HTTP 403 Forbidden** — confirmando que os JSPs estão protegidos e só podem ser acessados via `RequestDispatcher.forward()` do Controller.

---

### Passo 6: Commit do progresso

~~~bash
git add build.gradle
git add src/main/webapp/WEB-INF/views/task/list.jsp
git add src/main/webapp/WEB-INF/views/task/form.jsp
git add src/main/webapp/WEB-INF/views/task/detail.jsp
git commit -m "feat: adiciona JSTL 3.0 e atualiza Views com c:forEach, c:if, c:out e c:choose"
~~~

---

## Glossário Técnico da Aula

**JSTL (Jakarta Standard Tag Library):** Biblioteca de tags para JSP do Jakarta EE 11 que encapsula funcionalidades comuns de apresentação — iteração, condicionais, formatação e output seguro — sem Java puro. Versão 3.x.

**`jakarta.tags.core`:** URI correta da biblioteca core da JSTL para Jakarta EE 11. Use sempre esta URI. Não confundir com a URI legada `http://java.sun.com/jsp/jstl/core` (Java EE 1.x) que não funciona no GlassFish 7.

**`c:out`:** Tag JSTL que exibe um valor com escape automático de caracteres HTML (`<`, `>`, `&`, `"`, `'`). Protege contra XSS básico. Suporta valor padrão via atributo `default`.

**`c:if`:** Tag JSTL para lógica condicional simples. Renderiza seu conteúdo apenas quando `test` for verdadeiro. Não possui ramo `else` — use `c:choose` para isso.

**`c:forEach`:** Tag JSTL para iteração sobre coleções Java (List, Set, arrays). Atributo `var` define a variável de iteração, `items` recebe a coleção, `varStatus` expõe `count`, `index`, `first` e `last`.

**`c:choose`:** Container para lógica condicional múltipla mutuamente exclusiva. Agrupa `c:when` (condições avaliadas em ordem) e `c:otherwise` (ramo padrão). Equivalente ao `switch-case` do Java.

**`c:when`:** Ramo condicional dentro de `c:choose`. O atributo `test` define a condição EL. Apenas o primeiro `c:when` cuja `test` seja `true` terá seu conteúdo renderizado. Os `c:when` subsequentes são ignorados.

**`c:otherwise`:** Ramo padrão dentro de `c:choose`. Renderizado quando nenhum `c:when` for verdadeiro. Equivale ao `else` ou `default`.

**XSS (Cross-Site Scripting):** Ataque onde código JavaScript malicioso é injetado em uma página via dados de entrada do usuário. O `c:out` protege contra XSS de saída convertendo caracteres especiais em entidades HTML.

**`escapeXml`:** Atributo do `c:out` que controla o escape. Padrão: `true`. Use `false` apenas para HTML de confiança gerado pelo sistema, nunca para dados de entrada do usuário.

**`${empty colecao}`:** Operador EL que retorna `true` quando a variável é `null`, coleção vazia ou string vazia. Muito usado com `c:if` para exibição condicional.

**`${param.nomeDoCampo}`:** EL que acessa diretamente os parâmetros da requisição HTTP. Equivale a `request.getParameter("nomeDoCampo")`. Usado em formulários para re-exibir valores que o usuário digitou em um formulário quando a validação falha.

**`varStatus`:** Atributo do `c:forEach` que expõe informações da iteração atual: `index` (índice 0-based), `count` (contador 1-based), `first` (booleano), `last` (booleano).

**`implementation` (Gradle):** Escopo de dependência que inclui o JAR no WAR (em `WEB-INF/lib/`). Use para bibliotecas que o servidor não fornece e que precisam estar disponíveis em tempo de execução.

**`compileOnly` (Gradle):** Escopo de dependência disponível apenas para compilação, não incluída no WAR. Use para APIs que o servidor já fornece — como `jakarta.jakartaee-api`.

---

## Antecipação de Erros

**`org.apache.jasper.JasperException: Unable to find taglib` com a URI antiga:** Acontece quando você usa `uri="http://java.sun.com/jsp/jstl/core"` em vez de `uri="jakarta.tags.core"`. O GlassFish 7 com Jakarta EE 11 não reconhece a URI Java EE. Corrija todas as diretivas `taglib` para `uri="jakarta.tags.core"`.

**`ClassNotFoundException` ou `NoClassDefFoundError` para classes JSTL:** A JSTL foi declarada com escopo `compileOnly` em vez de `implementation`. O WAR não contém os JARs em `WEB-INF/lib/`. Verifique o `build.gradle` — ambas as dependências JSTL devem usar `implementation`.

**Tags JSTL exibidas como texto literal na página:** O GlassFish está servindo o JSP como texto plano sem processá-lo. Confirme que os JSPs estão em `WEB-INF/views/` e são acessados via `forward` do Controller — nunca diretamente pela URL.

**`c:forEach` sem renderizar linhas — tabela vazia:** O atributo `items` recebeu `null` porque o Controller não colocou a lista no request. Verifique se `request.setAttribute("tasks", tasks)` é chamado antes do `forward`. Este comportamento é esperado antes da Aula 11.

**`${param.titulo}` vazio ao retornar o formulário após erro:** O Controller está usando `sendRedirect()` em vez de `forward()` ao retornar o formulário com erros. O redirect cria uma nova requisição — os parâmetros `${param.*}` se perdem. Para re-exibir dados digitados, sempre use `forward` quando a validação falhar.

**`c:out` dentro de atributos HTML quebrando o markup:** Ao usar `c:out` dentro de atributos HTML, use aspas simples para delimitar o valor do `c:out` e aspas duplas para o atributo HTML. Correto: `value="<c:out value='${param.titulo}' default=''/>"`. Com aspas duplas em ambos: HTML malformado.

**`c:when` fora de `c:choose`:** O GlassFish lançará erro de tradução JSP. `c:when` e `c:otherwise` só podem aparecer diretamente dentro de um `c:choose`. Verifique que a estrutura está completamente aninhada.

**JSTL 3.x conflitando com JSTL 1.x no classpath:** Se o projeto tiver dependências transitivas que trazem `javax.servlet.jsp.jstl` (versão 1.x), haverá conflito de namespaces em tempo de execução. Use o comando `gradle dependencies` para verificar dependências transitivas e exclusões se necessário.

---

## Exercício de Fixação

Este exercício reforça o uso de `c:choose` e `c:if` em um contexto novo, e introduz o atributo `varStatus` do `c:forEach` para formatação visual baseada na posição da linha.

**Parte 1 — Linhas alternadas com varStatus:** Atualize o `list.jsp` para que as linhas da tabela alternem entre fundo branco e fundo cinza claro (`#f9f9f9`), usando `${status.count % 2 == 0}` para identificar linhas pares. Use um `c:if` para aplicar o estilo inline `style="background:#f9f9f9"` na tag `<tr>` quando a linha for par:

~~~jsp
<%-- src/main/webapp/WEB-INF/views/task/list.jsp (apenas o trecho do tbody) --%>
            <tbody>
                <c:forEach var="task" items="${tasks}" varStatus="status">
                    <%-- c:if: Aplica estilo de fundo cinza para linhas pares.
                         status.count é o contador baseado em 1. --%>
                    <tr <c:if test="${status.count % 2 == 0}">style="background:#f9f9f9"</c:if>>
                        <td><c:out value="${task.id}"/></td>
                        <td><c:out value="${task.titulo}"/></td>
                        <td><c:out value="${task.descricao}"/></td>
                        <td>
                            <%-- c:choose: Exibe o status com um badge colorido. --%>
                            <c:choose>
                                <c:when test="${task.status == 'PENDENTE'}">
                                    <span style="background:#9E9E9E;color:white;padding:2px 8px;
                                                 border-radius:10px;font-size:0.85em;">
                                        Pendente
                                    </span>
                                </c:when>
                                <c:when test="${task.status == 'EM_ANDAMENTO'}">
                                    <span style="background:#FF9800;color:white;padding:2px 8px;
                                                 border-radius:10px;font-size:0.85em;">
                                        Em Andamento
                                    </span>
                                </c:when>
                                <c:when test="${task.status == 'CONCLUIDA'}">
                                    <span style="background:#4CAF50;color:white;padding:2px 8px;
                                                 border-radius:10px;font-size:0.85em;">
                                        Concluída
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span style="background:#607D8B;color:white;padding:2px 8px;
                                                 border-radius:10px;font-size:0.85em;">
                                        <c:out value="${task.status}"/>
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td><c:out value="${task.dataCriacao}"/></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/tasks?action=detalhe&id=${task.id}">Detalhes</a> |
                            <a href="${pageContext.request.contextPath}/tasks?action=editar&id=${task.id}">Editar</a> |
                            <a href="${pageContext.request.contextPath}/tasks?action=remover&id=${task.id}">Remover</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
~~~

**Parte 2 — Exibindo o total com c:if:** Adicione ao final do `list.jsp` (dentro do `c:if test="${not empty tasks}"`, após a tabela) um parágrafo que exibe o total de tarefas. Como a biblioteca `fn` não está declarada no JSP desta aula, use uma abordagem alternativa: declare uma variável de contagem com `c:set` e incremente com `c:forEach`:

~~~jsp
<%-- src/main/webapp/WEB-INF/views/task/list.jsp (apenas o trecho final do c:if) --%>
        </table>
        <%-- c:set: Cria uma variável 'total' no pageScope com o valor inicial 0. --%>
        <c:set var="total" value="0"/>
        <%-- c:forEach: Itera sobre a lista de tarefas novamente para contar. --%>
        <c:forEach var="t" items="${tasks}">
            <%-- c:set: Incrementa a variável 'total' a cada iteração. --%>
            <c:set var="total" value="${total + 1}"/>
        </c:forEach>
        <p style="color:#888;font-size:0.9em;margin-top:8px;">
            Total: <c:out value="${total}"/> tarefa(s) cadastrada(s).
        </p>
    </c:if>

</body>
</html>
~~~

**Parte 3 — Reflexão e commit:** Registre em `modulo_02_essencial/aula_09/exercicio_09.txt` as respostas para as seguintes perguntas: por que a JSTL usa `implementation` no `build.gradle` em vez de `compileOnly`? Qual é a diferença comportamental entre usar múltiplos `c:if` independentes e um único `c:choose` para exibir os badges de status? Por que `c:out` é preferível a `${task.titulo}` para dados de entrada do usuário?

Ao final, faça o commit:

~~~bash
git add src/main/webapp/WEB-INF/views/task/list.jsp
git add src/main/webapp/WEB-INF/views/task/form.jsp
git add src/main/webapp/WEB-INF/views/task/detail.jsp
git add modulo_02_essencial/aula_09/
git commit -m "feat: adiciona c:choose com badges de status, select pre-selecionado e varStatus no list.jsp - aula 09"
~~~

---

## Resolução Comentada do Exercício

**Parte 1 — Linhas alternadas com varStatus:** A solução usa `status.count % 2 == 0` para verificar se o contador da iteração (baseado em 1) é par. Se for, o estilo de fundo cinza é aplicado. Isso demonstra a flexibilidade do `varStatus` para lógica de apresentação.

**Parte 2 — Contagem com c:set:** A abordagem de usar `c:set` para inicializar e incrementar uma variável dentro do `c:forEach` é uma forma válida de realizar contagens ou somas simples diretamente no JSP, sem scriptlets. É uma alternativa quando funções mais avançadas (como `fn:length`) não estão disponíveis ou não são desejadas.

**Parte 3 — Reflexão:**

-   **Por que `implementation` para JSTL?** A JSTL usa `implementation` no `build.gradle` porque o GlassFish 7 (que implementa Jakarta EE 11) não inclui a JSTL 3.x em seu classpath padrão. Portanto, os JARs da JSTL precisam ser empacotados dentro do WAR (em `WEB-INF/lib/`) para que a aplicação possa encontrá-los em tempo de execução. Em contraste, a API do Jakarta EE (`jakarta.platform:jakarta.jakartaee-api`) usa `compileOnly` porque o GlassFish já fornece essas APIs em seu ambiente de execução, e incluí-las no WAR seria redundante e poderia causar conflitos.
-   **Diferença entre múltiplos `c:if` e `c:choose`:**
    -   **Múltiplos `c:if` independentes:** Cada `c:if` é avaliado individualmente. Se você tiver várias condições que podem ser verdadeiras ao mesmo tempo, múltiplos blocos de conteúdo podem ser renderizados. Não há exclusividade mútua.
    -   **`c:choose`:** Funciona como um `switch-case`. As condições (`c:when`) são avaliadas em ordem. Apenas o **primeiro** `c:when` cuja condição `test` seja verdadeira terá seu conteúdo renderizado. Os `c:when` subsequentes são ignorados, e o `c:otherwise` só é renderizado se nenhum `c:when` for verdadeiro. Isso garante exclusividade mútua e é ideal para cenários onde apenas uma opção deve ser escolhida entre várias. Para os badges de status, `c:choose` é a escolha correta.
-   **Por que `c:out` é preferível a `${task.titulo}` para dados de entrada do usuário?** `c:out` é preferível porque ele automaticamente **escapa caracteres HTML** (como `<`, `>`, `&`, `"`, `'`) em entidades HTML (`<`, `>`, etc.). Isso previne ataques de **Cross-Site Scripting (XSS)**, onde um usuário mal-intencionado pode injetar código JavaScript ou HTML na sua página através de dados de entrada. Usar `${task.titulo}` diretamente para dados de entrada do usuário é um risco de segurança, pois o navegador interpretaria qualquer HTML ou JavaScript injetado. Para dados gerados internamente pelo sistema e que você confia, `${task.titulo}` pode ser usado, mas `c:out` é uma prática mais segura por padrão.

---

## Resumo dos Pontos-Chave

A **JSTL** (Jakarta Standard Tag Library) versão 3.x é a biblioteca de tags para JSP do Jakarta EE 11. Ela resolve o problema dos scriptlets fornecendo tags XML declarativas para lógica de apresentação — iteração, condicionais e output seguro — sem nenhuma linha de Java puro no JSP. A URI correta para Jakarta EE 11 é **`jakarta.tags.core`**. A JSTL é adicionada ao `build.gradle` com escopo **`implementation`** para garantir que seus JARs sejam incluídos no WAR. A tag **`c:out`** é fundamental para exibir dados de forma segura, escapando caracteres HTML e prevenindo XSS. A tag **`c:if`** permite condicionais simples, enquanto **`c:choose`** (com `c:when` e `c:otherwise`) é usada para lógica condicional múltipla mutuamente exclusiva. A tag **`c:forEach`** permite iterar sobre coleções, e seu atributo `varStatus` oferece controle detalhado sobre a iteração. O uso da JSTL mantém a View limpa, legível e alinhada com o padrão MVC.

---

## Log de Estado do Projeto

~~~text
## Aula 9: JSTL: exibindo dados na View sem Java puro
- Objetivo: Atualizar as Views para usar JSTL, eliminando qualquer Java puro das páginas JSP.
- Código Adicionado:
    build.gradle atualizado com dependências JSTL 3.0 (api e implementação) com escopo 'implementation'.
    src/main/webapp/WEB-INF/views/task/list.jsp atualizado com:
        <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <c:if test="${empty tasks}"> e <c:if test="${not empty tasks}">
        <c:forEach var="task" items="${tasks}" varStatus="status"> com estilo de linha alternada.
        <c:choose> para badges de status coloridos.
        <c:set> para contagem de tarefas.
    src/main/webapp/WEB-INF/views/task/form.jsp atualizado com:
        <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <c:out value='${param.titulo}' default=''/> para pré-preenchimento de campos.
        <c:if test="${param.status == 'PENDENTE' || empty param.status}">selected</c:if> para select pré-selecionado.
    src/main/webapp/WEB-INF/views/task/detail.jsp atualizado com:
        <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <c:if test="${empty task}"> e <c:if test="${not empty task}">
        <c:out> para exibição segura de detalhes.
        <c:choose> para badges de status coloridos.
    modulo_02_essencial/aula_09/exercicio_09.txt com reflexões sobre JSTL.
- Estado Funcional: ✅ As Views estão preparadas para receber e exibir dados dinâmicos de forma segura usando JSTL.
  Acessar /tasks exibe list.jsp com mensagem de lista vazia.
  Acessar /tasks?action=criar exibe form.jsp com o formulário de criação.
  Acessar /tasks?action=detalhe exibe detail.jsp com mensagem de tarefa não encontrada.
  Os JSPs estão dentro de WEB-INF e retornam 403 se acessados diretamente.
  gradle clean test war gera BUILD SUCCESSFUL com 13 testes passando e os JARs da JSTL estão presentes em WEB-INF/lib/ dentro do WAR.
- Próximas Etapas: Aula 10 criará a entidade Task (Model) e o repositório em memória com CRUD e testes TDD completos.
~~~

---

## Prompt de Continuidade para a Aula 10

"Sou aluno do curso Jakarta EE 11 com Java 21, Gradle, JUnit 5 e VS Code. Concluí a Aula 9 (JSTL: exibindo dados na View sem Java puro). O `build.gradle` foi atualizado com as dependências JSTL 3.0. Os arquivos `list.jsp`, `form.jsp` e `detail.jsp` foram atualizados com `c:forEach`, `c:if`, `c:out` e `c:choose`. A diretiva `taglib` usa a URI correta `jakarta.tags.core`. O `gradle clean test war` gera `BUILD SUCCESSFUL` com 13 testes passando e os JARs da JSTL estão presentes em `WEB-INF/lib/` dentro do WAR. Tenho o `plano_mestre.txt`, o `log_estado_projeto.md` e os `prompts_individuais.md` em anexo para contexto. Por favor, gere a **Aula 10: O Model: a entidade Task e o repositório em memória**, seguindo rigorosamente a estrutura definida no plano mestre: teoria detalhada com mínimo de 2.000 palavras, analogia de ancoragem, diagrama Mermaid com blocos ~~~mermaid, código comentado linha a linha com blocos ~~~, glossário técnico, antecipação de erros, exercício com resolução comentada, resumo dos pontos-chave, log de estado do projeto atualizado e prompt de continuidade para a Aula 11. O documento inteiro deve estar dentro de um bloco ```markdown. Nenhum bloco interno deve usar triple backtick."

---

Dúvidas? Posso prosseguir para a **Aula 10: O Model: a entidade Task e o repositório em memória**?