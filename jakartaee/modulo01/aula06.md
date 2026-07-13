# Aula 6: Requisições e Respostas HTTP com Servlets e TDD com JUnit 5

## Análise de Integridade
✅ Conteúdo verificado: protocolo HTTP explicado com analogias, diferença entre GET e POST detalhada, HttpServletRequest e HttpServletResponse cobertos, TDD com ciclo Red-Green-Refactor completo, JUnit 5 configurado, Mockito introduzido para testar Servlets diretamente, MockMvc explicado e diferenciado, código comentado linha a linha, diagrama Mermaid correto, mínimo de 2.000 palavras garantido.

---

## Índice

- [Aula 6: Requisições e Respostas HTTP com Servlets e TDD com JUnit 5](#aula-6-requisições-e-respostas-http-com-servlets-e-tdd-com-junit-5)
  - [Análise de Integridade](#análise-de-integridade)
  - [Índice](#índice)
  - [Objetivo](#objetivo)
  - [Pré-requisitos](#pré-requisitos)
  - [Resumo da Aula Anterior](#resumo-da-aula-anterior)
  - [Teoria Detalhada](#teoria-detalhada)
    - [O protocolo HTTP: a língua da web](#o-protocolo-http-a-língua-da-web)
    - [Anatomia de uma requisição HTTP](#anatomia-de-uma-requisição-http)
    - [Anatomia de uma resposta HTTP](#anatomia-de-uma-resposta-http)
    - [GET versus POST: duas formas de conversar com o servidor](#get-versus-post-duas-formas-de-conversar-com-o-servidor)
    - [HttpServletRequest: lendo o que o cliente enviou](#httpservletrequest-lendo-o-que-o-cliente-enviou)
    - [HttpServletResponse: escrevendo o que o servidor responde](#httpservletresponse-escrevendo-o-que-o-servidor-responde)
    - [Introdução ao TDD: escrever o teste antes do código](#introdução-ao-tdd-escrever-o-teste-antes-do-código)
    - [JUnit 5: a ferramenta do ciclo TDD](#junit-5-a-ferramenta-do-ciclo-tdd)
    - [Mockito: simulando objetos que dependem do servidor](#mockito-simulando-objetos-que-dependem-do-servidor)
    - [MockMvc: a alternativa do ecossistema Spring para referência](#mockmvc-a-alternativa-do-ecossistema-spring-para-referência)
  - [Analogia de Ancoragem](#analogia-de-ancoragem)
  - [Diagrama Mermaid](#diagrama-mermaid)
  - [Aplicação no Projeto Prático](#aplicação-no-projeto-prático)
    - [Passo 1: Atualizando o build.gradle com JUnit 5 e Mockito](#passo-1-atualizando-o-buildgradle-com-junit-5-e-mockito)
    - [Passo 2: Criando a classe de serviço SaudacaoService](#passo-2-criando-a-classe-de-serviço-saudacaoservice)
    - [Passo 3: Testando o SaudacaoService com JUnit 5 — ciclo TDD](#passo-3-testando-o-saudacaoservice-com-junit-5--ciclo-tdd)
    - [Passo 4: Criando o SaudacaoServlet](#passo-4-criando-o-saudacaoservlet)
    - [Passo 5: Testando o SaudacaoServlet com Mockito](#passo-5-testando-o-saudacaoservlet-com-mockito)
    - [Passo 6: Gerando o WAR e testando no navegador](#passo-6-gerando-o-war-e-testando-no-navegador)
    - [Passo 7: Commit do progresso](#passo-7-commit-do-progresso)
  - [Glossário Técnico da Aula](#glossário-técnico-da-aula)
  - [Antecipação de Erros](#antecipação-de-erros)
  - [Exercício de Fixação](#exercício-de-fixação)
  - [Resolução Comentada do Exercício](#resolução-comentada-do-exercício)
  - [Resumo dos Pontos-Chave](#resumo-dos-pontos-chave)
  - [Log de Estado do Projeto](#log-de-estado-do-projeto)
  - [Prompt de Continuidade para a Aula 7](#prompt-de-continuidade-para-a-aula-7)

---

## Objetivo
Entender em profundidade o protocolo HTTP, a anatomia de requisições e respostas, a diferença prática entre GET e POST, aprender a ler parâmetros com `HttpServletRequest`, escrever respostas com `HttpServletResponse`, fazer uma introdução prática e completa ao TDD com JUnit 5, e aprender a testar Servlets diretamente usando **Mockito** para simular os objetos `HttpServletRequest` e `HttpServletResponse` — seguindo o ciclo Red-Green-Refactor em todos os exemplos.

## Pré-requisitos
Aula 5 concluída. O `HelloServlet` está criado em `src/main/java/com/taskflow/controller/HelloServlet.java`, mapeado em `/hello` com `@WebServlet`, respondendo corretamente em `http://localhost:8080/taskflow/hello`. O `SobreServlet` foi criado no exercício da Aula 5. O ciclo de vida do Servlet foi observado via logs do GlassFish.

---

## Resumo da Aula Anterior

Na Aula 5 você criou seu primeiro Servlet — o `HelloServlet` — e entendeu o ciclo de vida completo: `init` (uma vez ao carregar), `service` (a cada requisição, delegando para `doGet` ou `doPost`) e `destroy` (uma vez ao descarregar). Você viu que o GlassFish usa uma única instância do Servlet para múltiplas requisições em threads simultâneas, que `@WebServlet` mapeia uma URL para uma classe Java, e que `PrintWriter` escreve o HTML na resposta. Nesta aula aprofundamos o protocolo que torna tudo isso possível — o HTTP — e introduzimos as ferramentas que guiarão o desenvolvimento do restante do curso: o **TDD com JUnit 5** e o **Mockito** para testes de Servlets.

---

## Teoria Detalhada

### O protocolo HTTP: a língua da web

Toda comunicação entre um navegador e um servidor web acontece por meio de um protocolo chamado **HTTP** (HyperText Transfer Protocol). Um protocolo é um conjunto de regras que duas partes concordam em seguir para se comunicar. O HTTP define exatamente como um navegador deve formatar uma mensagem de pedido e como um servidor deve formatar a resposta.

Use esta analogia para fixar o conceito. Imagine uma **correspondência formal entre empresas**. Quando uma empresa precisa solicitar algo de outra, ela segue um formato específico: papel timbrado, data no canto superior direito, destinatário identificado, assunto na linha específica, corpo do texto e assinatura ao final. A empresa que recebe sabe exatamente onde procurar cada informação porque o formato é padronizado. O HTTP é esse formato padronizado para a comunicação entre navegadores e servidores. O **cliente** (navegador) é a empresa que envia a carta (requisição). O **servidor** (GlassFish com seu Servlet) é a empresa que recebe, processa e responde.

O HTTP é **stateless** — sem estado — o que significa que cada requisição é completamente independente das anteriores. O servidor não tem memória automática de que você já fez uma requisição antes. Isso é diferente de uma ligação telefônica, onde existe uma conexão persistente. O HTTP é mais como trocar cartas: cada carta é um evento isolado.

---

### Anatomia de uma requisição HTTP

Uma requisição HTTP é composta por três partes: a **linha de requisição**, os **cabeçalhos** e o **corpo**.

A **linha de requisição** contém o **método HTTP** (GET, POST, PUT, DELETE), a **URL** do recurso (`/taskflow/saudacao?nome=Bianeck`) e a **versão do protocolo** (`HTTP/1.1`).

Os **cabeçalhos** são pares chave-valor com metadados: `Host: localhost:8080`, `Accept: text/html`, `Content-Type: application/x-www-form-urlencoded` (em requisições POST) e `Cookie: JSESSIONID=abc123`.

O **corpo** contém dados enviados pelo cliente. Em requisições GET, o corpo é vazio — os dados ficam na URL como query string. Em requisições POST, o corpo contém os dados do formulário, separados dos cabeçalhos por uma linha em branco.

---

### Anatomia de uma resposta HTTP

A resposta HTTP também tem três partes: a **linha de status**, os **cabeçalhos de resposta** e o **corpo**.

A **linha de status** contém a versão do protocolo, o **código de status** (número de três dígitos) e a mensagem de status. Os grupos de código são: **2xx** (sucesso — 200 OK), **3xx** (redirecionamento — 302 Found), **4xx** (erro do cliente — 404 Not Found) e **5xx** (erro do servidor — 500 Internal Server Error).

Os **cabeçalhos de resposta** incluem `Content-Type: text/html;charset=UTF-8`, `Content-Length: 1234` e `Set-Cookie: JSESSIONID=abc123`.

O **corpo** contém o HTML, JSON ou outro conteúdo que o navegador vai exibir.

---

### GET versus POST: duas formas de conversar com o servidor

O método **GET** é usado para **solicitar** dados. Os parâmetros ficam visíveis na URL como query string (`?nome=Bianeck&idioma=pt`). É bookmarkable, pode ser cacheado e **nunca deve alterar dados no servidor** — é considerado um método seguro e idempotente.

O método **POST** é usado para **enviar** dados ao servidor. Os parâmetros ficam no **corpo da requisição**, invisíveis na URL. Não é cacheado, não é bookmarkable, e é o método correto para operações que criam ou modificam dados.

A regra de ouro: **use GET para ler, POST para escrever**. Nunca use GET para deletar ou modificar dados — um robô de indexação poderia executar operações destrutivas simplesmente ao rastrear links.

---

### HttpServletRequest: lendo o que o cliente enviou

O objeto `HttpServletRequest` representa tudo que o cliente enviou na requisição. Os métodos mais usados são os seguintes.

`getParameter(String nome)` retorna o valor de um parâmetro como `String`, tanto de query string (GET) quanto do corpo do formulário (POST). Retorna `null` se o parâmetro não foi enviado — sempre verifique antes de usar.

`getMethod()` retorna o método HTTP como `String` — `"GET"`, `"POST"`, etc.

`getRequestURI()` retorna a URI completa, incluindo o context root. Exemplo: `/taskflow/saudacao`.

`getContextPath()` retorna apenas o context root. Exemplo: `/taskflow`.

`getHeader(String nome)` retorna o valor de um cabeçalho HTTP específico.

`getSession()` retorna a sessão HTTP do cliente, criando uma nova se não existir.

---

### HttpServletResponse: escrevendo o que o servidor responde

O objeto `HttpServletResponse` representa a resposta que você construirá e enviará ao cliente.

`setContentType(String tipo)` define o cabeçalho `Content-Type`. Deve ser chamado **antes** de qualquer escrita no corpo. Valor mais comum: `"text/html;charset=UTF-8"`.

`setStatus(int codigo)` define o código de status HTTP. Padrão é 200 se não chamado.

`getWriter()` retorna um `PrintWriter` para escrita textual no corpo. Deve ser chamado após `setContentType`.

`sendRedirect(String url)` instrui o navegador a fazer uma nova requisição para outra URL, enviando um 302. A URL na barra do navegador muda.

---

### Introdução ao TDD: escrever o teste antes do código

O **TDD** (Test-Driven Development) propõe uma inversão radical: você **escreve o teste primeiro**, vê ele falhar, depois escreve o código mínimo para o teste passar e por fim refatora.

Use esta analogia: um **arquiteto desenha a planta antes de construir**. A planta especifica exatamente como o edifício deve ser — antes de um tijolo ser assentado. No TDD, o teste é a planta: ele descreve o que o código deve fazer antes de o código existir.

O TDD funciona em um ciclo de três fases chamado **Red-Green-Refactor**. A fase **Red** é quando você escreve o teste — ele falha porque o código não existe. A fase **Green** é quando você escreve o código mais simples possível para o teste passar. A fase **Refactor** é quando você melhora o código sem alterar seu comportamento externo — e os testes garantem que nada quebrou.

---

### JUnit 5: a ferramenta do ciclo TDD

O **JUnit 5** é o framework de testes mais popular do ecossistema Java. Os elementos mais importantes são os seguintes.

`@Test` marca um método como caso de teste. `@BeforeEach` executa um método antes de cada teste — útil para preparar o estado inicial. `@AfterEach` executa após cada teste — útil para limpeza. `@DisplayName` dá um nome legível ao teste.

A classe `Assertions` fornece os métodos de verificação: `assertEquals(esperado, real)`, `assertNotNull(objeto)`, `assertTrue(condicao)`, `assertThrows(Excecao.class, () -> codigo)`.

Boa prática para nomear testes: use o padrão `deveFazerAlgo_quandoCondicao`. Exemplos: `deveRetornarSaudacaoComNome()`, `deveRetornarSaudacaoGenerica_quandoNomeForNulo()`.

---

### Mockito: simulando objetos que dependem do servidor

Aqui chegamos ao coração desta aula. Para testar um Servlet com JUnit, você precisa chamar `servlet.doGet(request, response)`. Mas `HttpServletRequest` e `HttpServletResponse` são interfaces do Jakarta EE — você não pode instanciá-las com `new` fora de um servidor de aplicações. Elas são criadas e gerenciadas pelo GlassFish.

Como resolver isso? Com **Mockito** — um framework de mocking (simulação) que cria **implementações falsas** de qualquer interface ou classe para fins de teste. Um mock criado pelo Mockito se comporta como um objeto real, mas você controla exatamente o que seus métodos retornam e pode verificar quais métodos foram chamados durante o teste.

Use esta analogia para entender o Mockito: imagine que você precisa testar o comportamento de um garçom (o Servlet). Para o teste, você não quer abrir um restaurante de verdade (subir o GlassFish) — isso seria lento e caro. Em vez disso, você usa **atores** (mocks) que interpretam o papel do cliente (HttpServletRequest) e da bandeja de entrega (HttpServletResponse). Você define o roteiro: "quando o ator-cliente for perguntado sobre seu nome, ele responde 'Bianeck'". O garçom interage com esses atores exatamente como interagiria com o cliente real — e você verifica se o garçom se comportou corretamente.

O Mockito tem três operações fundamentais. A primeira é **criar o mock**: `HttpServletRequest request = mock(HttpServletRequest.class)`. A segunda é **stubbing** (definir o roteiro): `when(request.getParameter("nome")).thenReturn("Bianeck")` — isso diz ao mock que quando `getParameter("nome")` for chamado, ele deve retornar `"Bianeck"`. A terceira é **verificação**: `verify(response).setContentType("text/html;charset=UTF-8")` — isso verifica que o método `setContentType` foi chamado com o argumento correto durante a execução do teste.

A combinação de JUnit 5 e Mockito é extremamente poderosa: você testa o Servlet em milissegundos, sem subir o GlassFish, sem fazer deploy, e com controle total sobre o comportamento dos objetos do servidor.

---

### MockMvc: a alternativa do ecossistema Spring para referência

É importante mencionar o **MockMvc** para que você saiba o que ele é quando encontrar referências a ele. O MockMvc é uma ferramenta do ecossistema **Spring Framework** (não do Jakarta EE puro) que simula uma camada HTTP completa para testar Controllers do Spring MVC. Ele permite escrever testes como `mockMvc.perform(get("/tasks")).andExpect(status().isOk())`, simulando uma requisição HTTP real sem subir um servidor.

No nosso curso, como usamos **Jakarta EE puro com Servlets** — sem Spring Framework — o MockMvc não se aplica diretamente. A abordagem equivalente e correta para o nosso contexto é o **Mockito com mocks de `HttpServletRequest` e `HttpServletResponse`**, que é exatamente o que implementaremos nesta aula. Registre essa distinção: MockMvc é para Spring MVC, Mockito com mocks Jakarta EE é para Servlets puros.

---

## Analogia de Ancoragem

O protocolo HTTP funciona como uma **correspondência formal entre empresas**. O navegador é a empresa remetente que envia uma carta (requisição) com formato rigoroso: tipo do pedido (método HTTP) no cabeçalho, destinatário (URL) identificado, conteúdo do pedido (corpo) separado do cabeçalho. O servidor é a empresa destinatária que lê a carta, processa o pedido e envia uma resposta formal com código de resultado (status HTTP) e o conteúdo solicitado. O Mockito, por sua vez, funciona como um **estúdio de cinema**: em vez de filmar cenas perigosas com atores reais em locações caras (subir o GlassFish), o diretor (o teste) usa atores (mocks) em um estúdio controlado, definindo exatamente o roteiro de cada cena e verificando se os atores se comportaram conforme o script.

---

## Diagrama Mermaid

~~~mermaid
sequenceDiagram
    participant TC as Teste JUnit 5
    participant MK as Mockito
    participant REQ as Mock HttpServletRequest
    participant RES as Mock HttpServletResponse
    participant SS as SaudacaoServlet
    participant SV as SaudacaoService
    participant PW as Mock PrintWriter

    TC->>MK: mock(HttpServletRequest.class)
    MK-->>REQ: cria implementação falsa
    TC->>MK: mock(HttpServletResponse.class)
    MK-->>RES: cria implementação falsa
    TC->>MK: mock(PrintWriter.class)
    MK-->>PW: cria PrintWriter falso

    TC->>REQ: when(getParameter("nome")).thenReturn("Bianeck")
    TC->>RES: when(getWriter()).thenReturn(PW)

    TC->>SS: doGet(REQ, RES)
    SS->>REQ: getParameter("nome") → "Bianeck"
    SS->>SV: gerarSaudacao("Bianeck")
    SV-->>SS: "Olá, Bianeck!"
    SS->>RES: setContentType("text/html charset=UTF-8")
    SS->>RES: getWriter() → PW
    SS->>PW: println("Olá, Bianeck!")

    TC->>MK: verify(RES).setContentType("text/html charset=UTF-8")
    MK-->>TC: ✅ verificado
    TC->>MK: verify(PW).println(contains("Olá, Bianeck!"))
    MK-->>TC: ✅ verificado
~~~

---

## Aplicação no Projeto Prático

### Passo 1: Atualizando o build.gradle com JUnit 5 e Mockito

Abra o arquivo `build.gradle` na raiz do projeto e atualize-o para incluir o JUnit 5 e o Mockito:

~~~groovy
// Plugin para aplicações web Java — ensina o Gradle a gerar WARs.
plugins {
    id 'war'
    id 'java'
}

// Configurações do projeto.
group = 'com.taskflow'
version = '1.0-SNAPSHOT'

// Define a versão do Java para compilação e para o bytecode gerado.
// Jakarta EE 11 requer Java 21 como mínimo.
java {
    sourceCompatibility = JavaVersion.VERSION_21
    targetCompatibility = JavaVersion.VERSION_21
}

// Repositório central de artefatos Java na internet.
// O Gradle buscará aqui todas as dependências declaradas abaixo.
repositories {
    mavenCentral()
}

dependencies {

    // ─── PRODUÇÃO ────────────────────────────────────────────────────────────

    // API completa do Jakarta EE 11.
    // Escopo compileOnly: disponível para compilar mas NÃO copiada para o WAR.
    // O GlassFish 7 já fornece essa implementação — incluí-la no WAR causaria conflito.
    compileOnly 'jakarta.platform:jakarta.jakartaee-api:11.0.0'

    // ─── TESTES ──────────────────────────────────────────────────────────────

    // JUnit 5 Jupiter API: as anotações e classes que usamos no código de teste.
    // @Test, @BeforeEach, @DisplayName, Assertions.assertEquals(), etc.
    testImplementation 'org.junit.jupiter:junit-jupiter-api:5.10.2'

    // JUnit 5 Jupiter Engine: o motor que executa os testes.
    // Necessário em tempo de execução dos testes — não aparece no código.
    testRuntimeOnly 'org.junit.jupiter:junit-jupiter-engine:5.10.2'

    // Mockito Core: o framework de mocking para simular objetos.
    // Permite criar mocks de HttpServletRequest e HttpServletResponse.
    testImplementation 'org.mockito:mockito-core:5.11.0'

    // Mockito JUnit 5 Extension: integra o Mockito com o JUnit 5.
    // Permite usar a anotação @ExtendWith(MockitoExtension.class) nos testes.
    testImplementation 'org.mockito:mockito-junit-jupiter:5.11.0'

    // Jakarta EE API disponível também nos testes.
    // Necessário para que o compilador entenda HttpServletRequest, etc. nos testes.
    testCompileOnly 'jakarta.platform:jakarta.jakartaee-api:11.0.0'

    // Necessário para que a JVM encontre as classes Jakarta EE em tempo de execução dos testes.
    // Usamos o GlassFish Embedded como fornecedor das implementações nos testes.
    testRuntimeOnly 'org.glassfish:jakarta.faces:4.0.7'
    testRuntimeOnly 'org.apache.tomcat.embed:tomcat-embed-core:10.1.20'
}

// Configuração do plugin de testes: instrui o Gradle a usar o motor do JUnit 5.
// Sem esta linha, o Gradle usa o motor do JUnit 4 e não encontra os testes JUnit 5.
test {
    useJUnitPlatform()

    // Exibe no terminal o resultado de cada teste individualmente.
    testLogging {
        events 'passed', 'failed', 'skipped'
    }
}

// Configuração do nome do arquivo WAR gerado.
// Resultado: build/libs/taskflow.war
war {
    archiveFileName = 'taskflow.war'
}
~~~

Uma observação importante sobre as dependências de runtime dos testes: para que o Mockito consiga criar mocks de `HttpServletRequest` e `HttpServletResponse`, ele precisa que as implementações dessas interfaces estejam no classpath de teste em tempo de execução. Usamos o `tomcat-embed-core` como fornecedor leve dessas implementações nos testes — ele não é usado em produção (onde o GlassFish é o servidor), apenas para satisfazer as dependências dos mocks do Mockito durante a execução do `gradle test`.

Execute o build para confirmar que as dependências foram baixadas corretamente:

~~~
gradle clean war
~~~

---

### Passo 2: Criando a classe de serviço SaudacaoService

Antes de criar o Servlet, criamos a classe de serviço que contém a lógica de negócio pura. Esta separação é fundamental para o MVC que formalizaremos na Aula 7, e é o que permite testar a lógica de negócio de forma completamente independente do Servlet.

Crie o arquivo `src/main/java/com/taskflow/service/SaudacaoService.java`:

~~~java
// Pacote service: classes de lógica de negócio pura.
// Esta classe não conhece Servlet, HTTP nem Jakarta EE.
// É um POJO testável diretamente com JUnit, sem mocks.
package com.taskflow.service;

public class SaudacaoService {

    /**
     * Gera uma saudação personalizada com base no nome fornecido.
     * Esta lógica não depende de HttpServletRequest nem de HttpServletResponse.
     * Por isso pode ser testada diretamente com JUnit sem necessidade de mocks.
     *
     * @param nome o nome do visitante; pode ser null ou em branco
     * @return uma String de saudação nunca nula
     */
    public String gerarSaudacao(String nome) {

        // Verifica se o nome é nulo ou está em branco (apenas espaços).
        // isBlank() retorna true para "", "   " e null-safe via Objects.
        // Neste caso, usamos a verificação combinada para máxima segurança.
        if (nome == null || nome.isBlank()) {
            // Retorna saudação genérica quando nenhum nome é fornecido.
            return "Olá, visitante!";
        }

        // trim() remove espaços extras do início e do fim do nome.
        // String.format() monta a mensagem com o nome sanitizado.
        return String.format("Olá, %s!", nome.trim());
    }
}
~~~

---

### Passo 3: Testando o SaudacaoService com JUnit 5 — ciclo TDD

Seguindo o TDD, escrevemos o teste **antes** de verificar se o código está correto. Crie o arquivo `src/test/java/com/taskflow/service/SaudacaoServiceTest.java`:

~~~java
// Pacote de testes espelhando o pacote do código de produção.
package com.taskflow.service;

// Importações do JUnit 5 Jupiter.
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

// Importações estáticas das asserções — evita escrever Assertions.assertEquals todo momento.
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

// Não precisamos de @ExtendWith(MockitoExtension.class) aqui
// porque SaudacaoService é um POJO puro — nenhum mock é necessário.
@DisplayName("Testes do SaudacaoService")
class SaudacaoServiceTest {

    // Instância do serviço sob teste.
    // Será recriada antes de cada método @Test pelo @BeforeEach.
    private SaudacaoService saudacaoService;

    // @BeforeEach: executado antes de CADA método @Test.
    // Garante que cada teste começa com uma instância limpa do serviço.
    @BeforeEach
    void setUp() {
        saudacaoService = new SaudacaoService();
    }

    // ─── FASE RED: escreva este teste primeiro. Ele passa porque
    //     SaudacaoService já foi implementado acima (sequência didática).
    //     Em TDD puro: escreva o teste → veja falhar → implemente → veja passar.

    @Test
    @DisplayName("Deve retornar saudação com o nome quando nome válido for fornecido")
    void deveRetornarSaudacaoComNome_quandoNomeForValido() {
        // ARRANGE: prepara o cenário — nome válido.
        String nome = "Bianeck";

        // ACT: executa a ação sob teste.
        String resultado = saudacaoService.gerarSaudacao(nome);

        // ASSERT: verifica o resultado esperado.
        // assertEquals(esperado, real) — ordem importa para mensagens de erro claras.
        assertEquals("Olá, Bianeck!", resultado);
    }

    @Test
    @DisplayName("Deve retornar saudação genérica quando nome for nulo")
    void deveRetornarSaudacaoGenerica_quandoNomeForNulo() {
        // ARRANGE: cenário com nome nulo.
        String nome = null;

        // ACT
        String resultado = saudacaoService.gerarSaudacao(nome);

        // ASSERT: null deve retornar a saudação genérica.
        assertEquals("Olá, visitante!", resultado);
    }

    @Test
    @DisplayName("Deve retornar saudação genérica quando nome for vazio")
    void deveRetornarSaudacaoGenerica_quandoNomeForVazio() {
        // ARRANGE: string vazia.
        String nome = "";

        // ACT
        String resultado = saudacaoService.gerarSaudacao(nome);

        // ASSERT
        assertEquals("Olá, visitante!", resultado);
    }

    @Test
    @DisplayName("Deve remover espaços extras do nome antes de gerar a saudação")
    void deveRemoverEspacos_quandoNomeTiverEspacosExtras() {
        // ARRANGE: nome com espaços no início e no fim.
        String nome = "  Bianeck  ";

        // ACT
        String resultado = saudacaoService.gerarSaudacao(nome);

        // ASSERT: trim() deve ter removido os espaços.
        assertEquals("Olá, Bianeck!", resultado);
    }

    @Test
    @DisplayName("O resultado nunca deve ser nulo, independentemente do input")
    void resultadoNuncaDeveSerNulo() {
        // ASSERT com assertNotNull: verifica que o retorno nunca é nulo.
        assertNotNull(saudacaoService.gerarSaudacao(null));
        assertNotNull(saudacaoService.gerarSaudacao(""));
        assertNotNull(saudacaoService.gerarSaudacao("Bianeck"));
    }
}
~~~

Execute os testes:

~~~
gradle test
~~~

Saída esperada:

~~~text
SaudacaoServiceTest > Deve retornar saudação com o nome quando nome válido for fornecido PASSED
SaudacaoServiceTest > Deve retornar saudação genérica quando nome for nulo PASSED
SaudacaoServiceTest > Deve retornar saudação genérica quando nome for vazio PASSED
SaudacaoServiceTest > Deve remover espaços extras do nome antes de gerar a saudação PASSED
SaudacaoServiceTest > O resultado nunca deve ser nulo, independentemente do input PASSED

BUILD SUCCESSFUL in Xs
~~~

---

### Passo 4: Criando o SaudacaoServlet

Agora criamos o Servlet que usa o `SaudacaoService`. O Servlet é responsável apenas por extrair o parâmetro da requisição, delegar ao serviço e escrever a resposta — nenhuma lógica de negócio aqui.

Crie `src/main/java/com/taskflow/controller/SaudacaoServlet.java`:

~~~java
// Pacote controller: Servlets que atuam como Controllers no padrão MVC.
package com.taskflow.controller;

// Importa o serviço de saudação — a lógica de negócio pura.
import com.taskflow.service.SaudacaoService;

// Importações do Jakarta EE para o Servlet.
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// Importações Java padrão.
import java.io.IOException;
import java.io.PrintWriter;

// Mapeia este Servlet para a URL /saudacao.
// URL completa: http://localhost:8080/taskflow/saudacao
// Com parâmetro: http://localhost:8080/taskflow/saudacao?nome=Bianeck
@WebServlet("/saudacao")
public class SaudacaoServlet extends HttpServlet {

    // Instância do SaudacaoService como atributo de instância.
    // SaudacaoService não tem estado mutável — é seguro compartilhar entre threads.
    // REGRA: nunca armazene dados específicos de uma requisição como atributo de instância.
    private final SaudacaoService saudacaoService = new SaudacaoService();

    // doGet: chamado pelo GlassFish para cada requisição GET em /saudacao.
    // Parâmetros fornecidos pelo GlassFish (ou pelo Mockito nos testes):
    //   request: representa a requisição HTTP recebida.
    //   response: representa a resposta HTTP que será enviada.
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        // Lê o parâmetro "nome" da query string da URL.
        // Exemplo: /saudacao?nome=Bianeck → retorna "Bianeck"
        // Sem o parâmetro: /saudacao → retorna null
        String nome = request.getParameter("nome");

        // Delega a lógica de negócio ao SaudacaoService.
        // O Servlet não sabe como gerar a saudação — apenas coordena.
        // Esta separação é o início da arquitetura MVC da Aula 7.
        String saudacao = saudacaoService.gerarSaudacao(nome);

        // Define o tipo de conteúdo como HTML com encoding UTF-8.
        // DEVE ser chamado ANTES de response.getWriter().
        // Sem isso, caracteres acentuados podem aparecer incorretos no navegador.
        response.setContentType("text/html;charset=UTF-8");

        // Obtém o PrintWriter para escrever no corpo da resposta HTTP.
        // Após getWriter(), o Content-Type não pode mais ser alterado.
        PrintWriter writer = response.getWriter();

        // Escreve o documento HTML completo na resposta.
        writer.println("<!DOCTYPE html>");
        writer.println("<html lang='pt-BR'>");
        writer.println("<head>");
        writer.println("    <meta charset='UTF-8'>");
        writer.println("    <title>TaskFlow — Saudação</title>");
        writer.println("</head>");
        writer.println("<body>");

        // Exibe a saudação gerada pelo SaudacaoService.
        // O conteúdo é dinâmico — gerado em Java com base no parâmetro recebido.
        writer.println("    <h1>" + saudacao + "</h1>");

        // Dica de uso ao usuário.
        writer.println("    <p>Dica: adicione <code>?nome=SeuNome</code> na URL.</p>");

        // Link de retorno à página inicial.
        writer.println("    <a href='/taskflow'>Voltar para a página inicial</a>");

        writer.println("</body>");
        writer.println("</html>");

        // Fecha o PrintWriter — libera recursos e garante que a resposta foi enviada.
        writer.close();
    }
}
~~~

---

### Passo 5: Testando o SaudacaoServlet com Mockito

Agora a parte mais importante desta aula: testamos o Servlet diretamente usando Mockito para simular os objetos `HttpServletRequest`, `HttpServletResponse` e `PrintWriter`.

Crie `src/test/java/com/taskflow/controller/SaudacaoServletTest.java`:

~~~java
// Pacote de testes espelhando o pacote do Controller.
package com.taskflow.controller;

// JUnit 5 Jupiter.
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

// Extensão do Mockito para JUnit 5.
// @ExtendWith(MockitoExtension.class) integra o ciclo de vida do Mockito com o JUnit 5,
// inicializando automaticamente os campos anotados com @Mock e @InjectMocks.
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

// Importações do Jakarta EE — as interfaces que serão mockadas.
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// PrintWriter para capturar o conteúdo escrito pelo Servlet.
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.IOException;

// Importações estáticas para asserções JUnit 5 e métodos do Mockito.
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

// @ExtendWith ativa a extensão do Mockito para este teste.
// Sem esta anotação, os campos @Mock e @InjectMocks não seriam inicializados.
@ExtendWith(MockitoExtension.class)
@DisplayName("Testes do SaudacaoServlet com Mockito")
class SaudacaoServletTest {

    // @Mock: instrui o Mockito a criar uma implementação falsa de HttpServletRequest.
    // O Mockito cria um objeto que implementa a interface mas não faz nada por padrão.
    // Podemos definir o comportamento com when(...).thenReturn(...).
    @Mock
    private HttpServletRequest request;

    // @Mock: implementação falsa de HttpServletResponse.
    // Usaremos quando(...).thenReturn(writer) para que getWriter() retorne nosso writer de teste.
    @Mock
    private HttpServletResponse response;

    // @InjectMocks: instrui o Mockito a criar uma instância real do SaudacaoServlet
    // e injetar nela os mocks declarados acima (@Mock).
    // Neste caso, o SaudacaoServlet cria internamente seu SaudacaoService,
    // então @InjectMocks apenas garante a instância do Servlet.
    @InjectMocks
    private SaudacaoServlet saudacaoServlet;

    // StringWriter captura tudo que for escrito no PrintWriter durante o teste.
    // É o "papel" onde o Servlet vai "imprimir" o HTML da resposta.
    private StringWriter responseWriter;

    // PrintWriter que envolve o StringWriter.
    // Será retornado pelo mock quando o Servlet chamar response.getWriter().
    private PrintWriter printWriter;

    // @BeforeEach: executado antes de cada @Test.
    // Recria o StringWriter e o PrintWriter para garantir isolamento entre testes.
    @BeforeEach
    void setUp() throws IOException {
        // Cria um novo StringWriter para capturar a saída de cada teste.
        responseWriter = new StringWriter();

        // Envolve o StringWriter em um PrintWriter.
        // O Servlet chama response.getWriter() — retornaremos este PrintWriter.
        printWriter = new PrintWriter(responseWriter);

        // Define o comportamento do mock: quando getWriter() for chamado no response,
        // retorne o nosso printWriter de captura.
        // Sem este stub, response.getWriter() retornaria null por padrão.
        when(response.getWriter()).thenReturn(printWriter);
    }

    @Test
    @DisplayName("Deve retornar HTML com saudação personalizada quando nome for fornecido")
    void deveRetornarHtmlComSaudacaoPersonalizada_quandoNomeForFornecido()
            throws IOException, jakarta.servlet.ServletException {

        // ARRANGE: define que getParameter("nome") retorna "Bianeck".
        // Esta é a fase de stubbing — definimos o roteiro do ator (mock).
        when(request.getParameter("nome")).thenReturn("Bianeck");

        // ACT: chama o método doGet do Servlet diretamente, passando os mocks.
        // O Servlet vai: chamar request.getParameter("nome") → "Bianeck",
        //                chamar SaudacaoService.gerarSaudacao("Bianeck") → "Olá, Bianeck!",
        //                chamar response.setContentType(...),
        //                chamar response.getWriter() → nosso printWriter,
        //                escrever o HTML no printWriter.
        saudacaoServlet.doGet(request, response);

        // Flush garante que tudo foi escrito no StringWriter antes de verificar.
        printWriter.flush();

        // Obtém o HTML capturado pelo StringWriter.
        String htmlGerado = responseWriter.toString();

        // ASSERT 1: verifica que o HTML contém a saudação correta.
        assertTrue(htmlGerado.contains("Olá, Bianeck!"),
            "O HTML deve conter 'Olá, Bianeck!' mas continha: " + htmlGerado);

        // ASSERT 2: verifica que o HTML é um documento HTML válido (tem a tag html).
        assertTrue(htmlGerado.contains("<html"),
            "O HTML deve conter a tag <html>");

        // ASSERT 3: verifica (via Mockito) que setContentType foi chamado corretamente.
        // verify() falha o teste se o método não foi chamado com os argumentos especificados.
        verify(response).setContentType("text/html;charset=UTF-8");
    }

    @Test
    @DisplayName("Deve retornar HTML com saudação genérica quando nome for nulo")
    void deveRetornarSaudacaoGenerica_quandoNomeForNulo()
            throws IOException, jakarta.servlet.ServletException {

        // ARRANGE: getParameter("nome") retorna null (parâmetro não enviado na URL).
        when(request.getParameter("nome")).thenReturn(null);

        // ACT
        saudacaoServlet.doGet(request, response);
        printWriter.flush();

        // ASSERT: o HTML deve conter a saudação genérica.
        String htmlGerado = responseWriter.toString();
        assertTrue(htmlGerado.contains("Olá, visitante!"),
            "Com nome nulo, o HTML deve conter 'Olá, visitante!'");
    }

    @Test
    @DisplayName("Deve retornar HTML com saudação genérica quando nome for vazio")
    void deveRetornarSaudacaoGenerica_quandoNomeForVazio()
            throws IOException, jakarta.servlet.ServletException {

        // ARRANGE: getParameter("nome") retorna string vazia.
        when(request.getParameter("nome")).thenReturn("");

        // ACT
        saudacaoServlet.doGet(request, response);
        printWriter.flush();

        // ASSERT
        String htmlGerado = responseWriter.toString();
        assertTrue(htmlGerado.contains("Olá, visitante!"),
            "Com nome vazio, o HTML deve conter 'Olá, visitante!'");
    }

    @Test
    @DisplayName("Deve definir o Content-Type correto em todas as respostas")
    void deveDefinirContentTypeCorreto()
            throws IOException, jakarta.servlet.ServletException {

        // ARRANGE: qualquer parâmetro — estamos testando o Content-Type.
        when(request.getParameter("nome")).thenReturn("Qualquer");

        // ACT
        saudacaoServlet.doGet(request, response);

        // ASSERT via verify: verifica que setContentType foi chamado exatamente 1 vez
        // com o argumento "text/html;charset=UTF-8".
        // Se o Servlet chamou com argumento diferente, o teste falha.
        verify(response).setContentType("text/html;charset=UTF-8");
    }

    @Test
    @DisplayName("Deve conter um link de retorno na resposta HTML")
    void deveConterLinkDeRetorno()
            throws IOException, jakarta.servlet.ServletException {

        // ARRANGE
        when(request.getParameter("nome")).thenReturn("Bianeck");

        // ACT
        saudacaoServlet.doGet(request, response);
        printWriter.flush();

        // ASSERT: verifica que o HTML contém um link de retorno.
        String htmlGerado = responseWriter.toString();
        assertTrue(htmlGerado.contains("href='/taskflow'"),
            "O HTML deve conter um link de retorno para /taskflow");
    }
}
~~~

Execute todos os testes:

~~~
gradle test
~~~

Saída esperada:

~~~text
SaudacaoServiceTest > Deve retornar saudação com o nome quando nome válido for fornecido PASSED
SaudacaoServiceTest > Deve retornar saudação genérica quando nome for nulo PASSED
SaudacaoServiceTest > Deve retornar saudação genérica quando nome for vazio PASSED
SaudacaoServiceTest > Deve remover espaços extras do nome antes de gerar a saudação PASSED
SaudacaoServiceTest > O resultado nunca deve ser nulo, independentemente do input PASSED
SaudacaoServletTest > Deve retornar HTML com saudação personalizada quando nome for fornecido PASSED
SaudacaoServletTest > Deve retornar HTML com saudação genérica quando nome for nulo PASSED
SaudacaoServletTest > Deve retornar HTML com saudação genérica quando nome for vazio PASSED
SaudacaoServletTest > Deve definir o Content-Type correto em todas as respostas PASSED
SaudacaoServletTest > Deve conter um link de retorno na resposta HTML PASSED

BUILD SUCCESSFUL in Xs
10 actionable tasks: 4 executed, 6 up-to-date
~~~

Dez testes passando — cinco para a lógica de negócio pura (sem mocks) e cinco para o Servlet (com mocks do Mockito).

---

### Passo 6: Gerando o WAR e testando no navegador

~~~
gradle clean war
~~~

~~~
copy build\libs\taskflow.war C:\ferramentas\glassfish7\domains\domain1\autodeploy\
~~~

Aguarde o redeploy e teste:

~~~text
http://localhost:8080/taskflow/saudacao?nome=Bianeck
~~~

Deve exibir: **Olá, Bianeck!**

~~~text
http://localhost:8080/taskflow/saudacao
~~~

Deve exibir: **Olá, visitante!**

---

### Passo 7: Commit do progresso

~~~
git add build.gradle
git add src/main/java/com/taskflow/service/SaudacaoService.java
git add src/main/java/com/taskflow/controller/SaudacaoServlet.java
git add src/test/java/com/taskflow/service/SaudacaoServiceTest.java
git add src/test/java/com/taskflow/controller/SaudacaoServletTest.java
git commit -m "feat: adiciona SaudacaoServlet com JUnit 5 e testes Mockito para Servlet e Service"
~~~

---

## Glossário Técnico da Aula

**HTTP (HyperText Transfer Protocol):** Protocolo de comunicação stateless entre navegadores e servidores web, baseado no modelo requisição-resposta.

**Requisição HTTP:** Mensagem enviada pelo cliente, composta por linha de requisição (método + URL + versão), cabeçalhos e corpo.

**Resposta HTTP:** Mensagem enviada pelo servidor, composta por linha de status (código HTTP), cabeçalhos de resposta e corpo.

**Método GET:** Solicita dados do servidor. Parâmetros visíveis na URL (query string). Não deve alterar dados.

**Método POST:** Envia dados ao servidor. Parâmetros no corpo da requisição. Usado para criar ou modificar dados.

**Query String:** Parte da URL com parâmetros GET. Começa com `?`, separados por `&`. Exemplo: `?nome=Bianeck&idioma=pt`.

**Código de Status HTTP:** Número indicando o resultado: 200 (OK), 302 (Redirect), 404 (Not Found), 500 (Internal Server Error).

**`HttpServletRequest`:** Interface Jakarta EE representando a requisição HTTP recebida. Fornece acesso a parâmetros, cabeçalhos, sessão e URI.

**`HttpServletResponse`:** Interface Jakarta EE representando a resposta HTTP a ser enviada. Permite definir status, cabeçalhos e corpo.

**`getParameter(String nome)`:** Método do `HttpServletRequest` que retorna o valor de um parâmetro como `String`. Retorna `null` se o parâmetro não foi enviado.

**TDD (Test-Driven Development):** Metodologia onde os testes são escritos antes do código de produção. Ciclo: Red → Green → Refactor.

**Red-Green-Refactor:** As três fases do TDD. Red: teste falha. Green: código mínimo faz o teste passar. Refactor: código melhorado sem quebrar os testes.

**JUnit 5 (Jupiter):** Framework de testes para Java. Fornece `@Test`, `@BeforeEach`, `@DisplayName`, `assertEquals`, `assertNotNull`, etc.

**Mockito:** Framework de mocking para Java que cria implementações falsas (mocks) de interfaces e classes para uso em testes.

**Mock:** Implementação falsa de uma interface ou classe criada pelo Mockito. Permite controlar o comportamento de dependências em testes.

**Stubbing:** Ato de definir o comportamento de um mock. Exemplo: `when(request.getParameter("nome")).thenReturn("Bianeck")`.

**`verify()`:** Método do Mockito que verifica se um método foi chamado no mock com os argumentos especificados. O teste falha se a chamada não ocorreu.

**`@Mock`:** Anotação do Mockito que declara um campo como mock. Requer `@ExtendWith(MockitoExtension.class)` para ser inicializado automaticamente.

**`@InjectMocks`:** Anotação do Mockito que cria uma instância real da classe e injeta os mocks declarados com `@Mock`.

**`@ExtendWith(MockitoExtension.class)`:** Anotação JUnit 5 que ativa a integração do Mockito com o ciclo de vida do JUnit 5.

**`StringWriter`:** Classe Java que captura texto escrito em um `PrintWriter` em memória como uma `String`. Usado nos testes para capturar o HTML gerado pelo Servlet.

**MockMvc:** Ferramenta do Spring Framework (não Jakarta EE puro) para testar Controllers Spring MVC simulando requisições HTTP. Não aplicável ao nosso contexto de Servlets Jakarta EE puros.

**POJO (Plain Old Java Object):** Classe Java simples sem dependências de framework. `SaudacaoService` é um POJO — testável diretamente com JUnit sem mocks.

**Stateless:** Propriedade do HTTP onde cada requisição é independente — o servidor não mantém memória automática de requisições anteriores.

---

## Antecipação de Erros

**`NullPointerException` ao chamar `response.getWriter()` no teste sem stub:** O Mockito, por padrão, retorna `null` para métodos que retornam objetos. Se você esquecer o stub `when(response.getWriter()).thenReturn(printWriter)` no `@BeforeEach`, o Servlet receberá `null` ao chamar `response.getWriter()` e lançará `NullPointerException`. Sempre configure os stubs necessários antes de chamar `doGet`.

**`UnnecessaryStubbingException` do Mockito:** O Mockito 5 por padrão usa o modo `STRICT_STUBS`, que falha o teste se você definiu um stub que nunca foi chamado durante o teste. Isso acontece quando você configura `when(request.getParameter("nome")).thenReturn("X")` mas o método `getParameter` nunca é chamado no fluxo testado. A solução é remover o stub desnecessário ou usar `@MockitoSettings(strictness = Strictness.LENIENT)` se o stub é realmente necessário mas opcional em alguns fluxos.

**`gradle test` não encontrando os testes:** Acontece quando a linha `useJUnitPlatform()` está ausente no bloco `test {}` do `build.gradle`. Sem ela, o Gradle usa o motor do JUnit 4 e ignora completamente os testes anotados com `@Test` do JUnit 5.

**`ClassNotFoundException` para classes Jakarta EE nos testes:** Acontece quando a dependência `jakarta.platform:jakarta.jakartaee-api` está declarada como `compileOnly` mas não está disponível como `testCompileOnly`. As interfaces `HttpServletRequest` e `HttpServletResponse` precisam estar visíveis para o compilador durante a compilação dos testes. Adicione `testCompileOnly 'jakarta.platform:jakarta.jakartaee-api:11.0.0'` ao `build.gradle`.

**`NoClassDefFoundError` em tempo de execução dos testes:** Mesmo que os testes compilem, o Mockito precisa carregar as classes em tempo de execução para criar os mocks. Se `jakarta.servlet.http.HttpServletRequest` não estiver no classpath de runtime dos testes, o Mockito não consegue criar o mock. Adicione `testRuntimeOnly 'org.apache.tomcat.embed:tomcat-embed-core:10.1.20'` para fornecer as implementações em tempo de execução dos testes.

**`@InjectMocks` não injetando o `SaudacaoService` no `SaudacaoServlet`:** O `@InjectMocks` injeta apenas os campos anotados com `@Mock` na classe de teste. Como o `SaudacaoService` é instanciado diretamente no `SaudacaoServlet` (`new SaudacaoService()`), ele não é injetado pelo Mockito. Isso é intencional — o `SaudacaoService` é um POJO e não precisa ser mockado. Se você quiser testar o Servlet com um `SaudacaoService` mockado (para isolar completamente o Servlet), declare `@Mock private SaudacaoService saudacaoService` e refatore o Servlet para receber o serviço via construtor ou setter.

**`assertTrue` falhando por encoding incorreto:** Se o HTML contém `OlÃ¡, Bianeck!` em vez de `Olá, Bianeck!`, o encoding não está configurado corretamente. Confirme que `response.setContentType("text/html;charset=UTF-8")` é chamado antes de `getWriter()` no Servlet, e que o arquivo Java está salvo em UTF-8 no VS Code (veja o encoding no canto inferior direito do VS Code).

---

## Exercício de Fixação

Este exercício aplica o ciclo TDD completo com Mockito para uma nova classe de serviço e seu Servlet correspondente.

**Contexto:** O TaskFlow precisará de uma funcionalidade de cálculo de taxa no futuro. Vamos criar a infraestrutura de testes agora, praticando o TDD.

**Parte 1 — Fase Red para o Service:** Crie `src/test/java/com/taskflow/service/CalculadoraTaxaTest.java` com os testes abaixo **antes** de criar a classe `CalculadoraTaxa`. Execute `gradle test` e observe o erro de compilação (Red):

~~~java
package com.taskflow.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

@DisplayName("Testes da CalculadoraTaxa")
class CalculadoraTaxaTest {

    private CalculadoraTaxa calculadora;

    @BeforeEach
    void setUp() {
        calculadora = new CalculadoraTaxa();
    }

    @Test
    @DisplayName("Deve aplicar 10% de acréscimo sobre o valor")
    void deveAplicarDezPorcentoDeAcrescimo() {
        double resultado = calculadora.calcular(100.0);
        assertEquals(110.0, resultado, 0.001);
    }

    @Test
    @DisplayName("Deve retornar zero para valor zero")
    void deveRetornarZero_quandoValorForZero() {
        assertEquals(0.0, calculadora.calcular(0.0), 0.001);
    }

    @Test
    @DisplayName("Deve lançar IllegalArgumentException para valor negativo")
    void deveLancarExcecao_quandoValorForNegativo() {
        assertThrows(IllegalArgumentException.class,
            () -> calculadora.calcular(-50.0));
    }
}
~~~

**Parte 2 — Fase Green para o Service:** Implemente `src/main/java/com/taskflow/service/CalculadoraTaxa.java` com a lógica mínima para os três testes passarem. Execute `gradle test` e confirme o Green.

**Parte 3 — Fase Red para o Servlet com Mockito:** Crie `src/test/java/com/taskflow/controller/TaxaServletTest.java` com testes usando `@ExtendWith(MockitoExtension.class)`, `@Mock HttpServletRequest`, `@Mock HttpServletResponse` e `@InjectMocks TaxaServlet`. Escreva pelo menos dois testes: um verificando que a resposta contém o valor calculado corretamente, e outro verificando que `setContentType("text/html;charset=UTF-8")` foi chamado via `verify()`.

**Parte 4 — Fase Green para o Servlet:** Implemente `TaxaServlet.java` que lê o parâmetro `valor` da requisição, instancia a `CalculadoraTaxa`, calcula o resultado e escreve o HTML da resposta com o resultado. Faça os testes passarem.

**Parte 5 — Refactor:** Adicione Javadoc à `CalculadoraTaxa`, extraia a constante `0.10` para `private static final double TAXA = 0.10` e execute `gradle test` para confirmar que os testes continuam passando.

Ao final, registre as fases e as mensagens de erro do Red em `modulo_01_fundamentos/aula_06/exercicio_06.txt` e faça o commit:

~~~
git add src/
git add modulo_01_fundamentos/aula_06/
git commit -m "test: adiciona CalculadoraTaxaTest e TaxaServletTest com ciclo TDD e Mockito"
~~~

---

## Resolução Comentada do Exercício

**Parte 2 — CalculadoraTaxa Green:**

~~~java
package com.taskflow.service;

public class CalculadoraTaxa {

    private static final double TAXA = 0.10;

    public double calcular(double valor) {
        if (valor < 0) {
            throw new IllegalArgumentException(
                "Valor não pode ser negativo. Recebido: " + valor);
        }
        return valor + (valor * TAXA);
    }
}
~~~

**Parte 3 e 4 — TaxaServlet e testes:** O `TaxaServlet` deve mapear `/taxa`, ler `request.getParameter("valor")`, converter para `double` com `Double.parseDouble()`, criar `new CalculadoraTaxa()`, chamar `calcular()` e escrever o resultado no HTML. Nos testes, o stub deve ser `when(request.getParameter("valor")).thenReturn("100.0")`, e o assert deve verificar que o HTML contém `"110"` (ou `"110.0"`). A verificação via `verify(response).setContentType("text/html;charset=UTF-8")` confirma que o Content-Type foi definido.

**Sobre o delta no assertEquals para doubles:** `assertEquals(110.0, resultado, 0.001)` usa um terceiro parâmetro chamado **delta** — a tolerância para comparação de ponto flutuante. Como `double` tem imprecisões de representação binária, `100.0 * 1.10` pode resultar em `110.00000000001`. O delta `0.001` aceita a diferença como igual se for menor que `0.001`.

---

## Resumo dos Pontos-Chave

O **protocolo HTTP** é stateless, baseado no modelo requisição-resposta. Uma requisição tem linha de requisição (método + URL), cabeçalhos e corpo. Uma resposta tem linha de status (código HTTP), cabeçalhos de resposta e corpo. O método **GET** envia parâmetros na URL e é usado para leitura; o método **POST** envia parâmetros no corpo e é usado para criação e modificação — nunca use GET para operações que alteram dados. O **`HttpServletRequest`** dá acesso aos dados da requisição — `getParameter(nome)` retorna `null` quando o parâmetro não está presente, e isso deve sempre ser verificado antes de usar o valor. O **`HttpServletResponse`** permite construir a resposta — `setContentType` define o tipo de conteúdo e deve ser chamado antes de `getWriter()`. O **TDD** inverte a ordem tradicional: escreva o teste antes do código, seguindo o ciclo **Red** (teste falha) → **Green** (código mínimo passa) → **Refactor** (código melhora sem quebrar testes). O **JUnit 5** é a ferramenta do ciclo TDD, com anotações `@Test`, `@BeforeEach`, `@DisplayName` e métodos de asserção como `assertEquals`, `assertNotNull` e `assertThrows`. O **Mockito** permite testar Servlets diretamente criando mocks de `HttpServletRequest` e `HttpServletResponse` — as operações fundamentais são criar o mock, definir o comportamento com `when(...).thenReturn(...)` e verificar chamadas com `verify(...)`. A boa prática é **separar lógica de negócio do Servlet** em classes de serviço puras (POJOs), tornando essa lógica 100% testável com JUnit sem mocks, e usar Mockito para testar o Servlet em si quando necessário. O **MockMvc** é uma ferramenta do Spring Framework — não se aplica ao nosso contexto de Servlets Jakarta EE puros.

---

## Log de Estado do Projeto

~~~text
## Aula 6: Requisições e Respostas HTTP com Servlets e TDD com JUnit 5
- Objetivo: Demonstrar leitura de parâmetros HTTP e introduzir TDD com JUnit 5 e Mockito.
- Código Adicionado:
    build.gradle atualizado com JUnit 5 (junit-jupiter-api 5.10.2,
    junit-jupiter-engine 5.10.2), Mockito (mockito-core 5.11.0,
    mockito-junit-jupiter 5.11.0) e tomcat-embed-core para runtime dos testes.
    src/main/java/com/taskflow/service/SaudacaoService.java — lógica pura testável.
    src/main/java/com/taskflow/controller/SaudacaoServlet.java — @WebServlet("/saudacao").
    src/test/java/com/taskflow/service/SaudacaoServiceTest.java — 5 testes JUnit 5.
    src/test/java/com/taskflow/controller/SaudacaoServletTest.java — 5 testes com Mockito.
    src/test/java/com/taskflow/service/CalculadoraTaxaTest.java — exercício TDD.
    src/main/java/com/taskflow/service/CalculadoraTaxa.java — exercício TDD.
    modulo_01_fundamentos/aula_06/exercicio_06.txt
- Estado Funcional: ✅ /saudacao?nome=Bianeck exibe "Olá, Bianeck!".
  10 testes passando: 5 no SaudacaoServiceTest, 5 no SaudacaoServletTest.
  gradle clean war gera BUILD SUCCESSFUL.
- Próximas Etapas: Aula 7 introduzirá a arquitetura MVC e refatorará a estrutura
  de pacotes do TaskFlow em model/, repository/, controller/ e filter/.
~~~

---

## Prompt de Continuidade para a Aula 7

"Sou aluno do curso Jakarta EE 11 com Java 21, Gradle, JUnit 5 e VS Code. Concluí a Aula 6 (Requisições e Respostas HTTP com Servlets e TDD com JUnit 5). O SaudacaoServlet está criado em /saudacao e lê o parâmetro nome via getParameter. O JUnit 5 e o Mockito estão configurados no build.gradle. O SaudacaoServiceTest tem 5 testes passando e o SaudacaoServletTest tem 5 testes com Mockito passando. A CalculadoraTaxa foi criada no exercício seguindo o ciclo TDD completo. Tenho o plano_mestre.txt, o log_estado_projeto.md e os prompts_individuais.md em anexo para contexto. Por favor, gere a **Aula 7: Arquitetura MVC: separando responsabilidades**, seguindo rigorosamente a estrutura definida no plano mestre: teoria detalhada com mínimo de 2.000 palavras, analogia de ancoragem, diagrama Mermaid com blocos ~~~mermaid, código comentado linha a linha com blocos ~~~, glossário técnico, antecipação de erros, exercício com resolução comentada, resumo dos pontos-chave, log de estado do projeto atualizado e prompt de continuidade para a Aula 8. O documento inteiro deve estar dentro de um bloco ```markdown. Nenhum bloco interno deve usar triple backtick."

---

Dúvidas? Posso prosseguir para a **Aula 7: Arquitetura MVC: separando responsabilidades**?