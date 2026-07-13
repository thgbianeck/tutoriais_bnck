# Prompts Individuais — n8n do Zero ao Avançado

Este documento contém os prompts detalhados para a geração de cada aula do curso, seguindo a estrutura e as regras definidas no `plano_mestre.txt`. Cada prompt instrui o Tutor Sênior a gerar uma aula completa, com teoria densa, analogias, diagramas Mermaid, aplicação prática no projeto "Sistema de Automação de Notificações e Processamento de Dados Simples", glossário, antecipação de erros, exercícios com resoluções e resumo, garantindo um mínimo de 2.000 palavras e o formato Markdown especificado.

---

## Módulo 1 — Essencial (Fundamentos do n8n)

### Aula 1: Introdução ao n8n: O que é e Por Que Usar?

**Prompt:**
"Gere a **Aula 1: Introdução ao n8n: O que é e Por Que Usar?**.
**Objetivo:** Compreender o conceito de automação, o papel do n8n como ferramenta de automação de fluxo de trabalho e suas principais vantagens no cenário atual de integração de sistemas.
**Pré-requisitos:** Nenhum. Este é o ponto de partida absoluto.
**Projeto Prático:** Nenhum código ou workflow ainda. Esta aula é teórica e contextualiza tudo o que virá a seguir. O aluno deve criar a pasta raiz `automacao_n8n/` e o arquivo `README.md` com uma descrição inicial do projeto.
**Log de Estado do Projeto:**
- **Objetivo:** Compreender o conceito de automação e o papel do n8n, e criar a estrutura inicial do repositório.
- **Código Adicionado:** Nenhum workflow ainda. Apenas a criação da pasta `automacao_n8n/` e do `README.md` com a descrição do projeto.
- **Estado Funcional:** ⏳ Projeto ainda sem workflows. Ambiente será configurado na Aula 2.
- **Próximas Etapas:** Aula 2 abordará a instalação e configuração do n8n no Windows 11.
**Instruções Específicas:**
- Explique o conceito de **automação de fluxo de trabalho** com analogias do cotidiano (ex: uma linha de produção automatizada, um robô de cozinha que segue uma receita).
- Apresente o **n8n** como uma ferramenta de **automação de código aberto** e **low-code**, destacando sua flexibilidade e capacidade de conectar diferentes serviços.
- Compare o n8n com outras ferramentas de automação (ex: Zapier, Make.com), focando nas vantagens do n8n (código aberto, auto-hospedagem, maior controle).
- Explique os principais casos de uso do n8n: integração de APIs, automação de tarefas repetitivas, processamento de dados, notificações.
- O diagrama Mermaid deve ilustrar a ideia de um fluxo de trabalho automatizado, mostrando a conexão entre diferentes "caixas" de serviço (ex: um evento em um serviço A, processamento no n8n, ação em um serviço B).
- A seção de antecipação de erros deve cobrir a confusão comum entre "automação" e "programação tradicional", explicando que o n8n simplifica a automação sem eliminar a necessidade de lógica.
- O exercício deve ser uma reflexão escrita: o aluno deve listar pelo menos três tarefas repetitivas em seu dia a dia que poderiam ser automatizadas e descrever brevemente como a automação poderia beneficiá-lo."

---

### Aula 2: Instalação e Configuração do n8n no Windows 11

**Prompt:**
"Gere a **Aula 2: Instalação e Configuração do n8n no Windows 11**.
**Objetivo:** Instalar o n8n localmente no Windows 11, configurar o ambiente de trabalho e realizar o primeiro acesso à interface do usuário.
**Pré-requisitos:** Aula 1 concluída. Compreensão do que é o n8n e seus benefícios.
**Projeto Prático:** Ao final desta aula, o aluno terá o n8n instalado e rodando em seu computador, com acesso à interface web.
**Log de Estado do Projeto:**
- **Objetivo:** Instalar e configurar o n8n no Windows 11.
- **Código Adicionado:** Nenhum workflow ainda. O aluno instala a ferramenta e configura o ambiente.
- **Estado Funcional:** ✅ n8n instalado e acessível via navegador.
- **Próximas Etapas:** Aula 3 explorará a interface do n8n e seus componentes.
**Instruções Específicas:**
- Instrua a instalação do n8n no Windows 11, focando na opção mais simples para iniciantes (ex: **n8n Desktop App** ou **npm** se for mais adequado para a última versão). Forneça prints descritivos de cada passo.
- Explique a importância de ter o **Node.js** instalado (se a instalação via npm for escolhida) e como verificar sua versão (`node -v`).
- Detalhe como iniciar o n8n após a instalação e como acessar a interface web (geralmente `http://localhost:5678`).
- Explique brevemente o que é o **backend** do n8n e o **frontend** (a interface visual).
- O diagrama Mermaid deve ilustrar o processo de instalação: Download → Execução/Comando → Início do Servidor → Acesso ao Navegador.
- A seção de antecipação de erros deve cobrir os erros mais comuns: porta 5678 já em uso, Node.js não encontrado (se via npm), problemas de firewall.
- O exercício deve ser a verificação da instalação: iniciar o n8n, acessar a interface no navegador e criar um novo workflow vazio, registrando o sucesso em um arquivo `instalacao.txt`."

---

### Aula 3: Explorando a Interface do n8n: Workflows, Nós e Conexões

**Prompt:**
"Gere a **Aula 3: Explorando a Interface do n8n: Workflows, Nós e Conexões**.
**Objetivo:** Familiarizar-se com a interface do usuário do n8n, identificar os principais elementos como a área de trabalho (canvas), o painel de nós, as configurações de workflow e o painel de execução.
**Pré-requisitos:** Aula 2 concluída. n8n instalado e funcionando.
**Projeto Prático:** Criação de um workflow vazio, adição de alguns nós de exemplo (sem configurá-los ainda) e exploração das opções de salvamento e carregamento de workflows.
**Log de Estado do Projeto:**
- **Objetivo:** Familiarizar-se com a interface do n8n e seus componentes.
- **Código Adicionado:** Nenhum workflow funcional ainda. Apenas a exploração da interface.
- **Estado Funcional:** ✅ O aluno consegue navegar pela interface, adicionar nós e entender a estrutura básica.
- **Próximas Etapas:** Aula 4 criará o primeiro workflow funcional "Hello World".
**Instruções Específicas:**
- Apresente a interface do n8n com a analogia de uma **mesa de trabalho** ou **quadro branco interativo**: onde você arrasta e conecta peças (nós) para construir um processo.
- Descreva cada área da interface:
    - **Canvas (Área de Trabalho):** Onde os nós são arrastados e conectados.
    - **Painel de Nós (Nodes Panel):** Onde você encontra todos os nós disponíveis.
    - **Painel de Propriedades do Nó:** Onde as configurações de um nó selecionado são ajustadas.
    - **Painel de Execução (Execution Panel):** Onde você vê o histórico de execuções e os dados que fluem.
    - **Barra Superior:** Opções de salvar, executar, ativar/desativar workflow.
- Explique o conceito de **nó** como uma "caixa de funcionalidade" e **conexão** como o "fluxo de dados" entre elas.
- Mostre como adicionar um nó arrastando-o do painel para o canvas e como conectá-los.
- O diagrama Mermaid deve ilustrar a interface principal do n8n, destacando as áreas mencionadas.
- A seção de antecipação de erros deve cobrir a dificuldade em encontrar nós específicos (usar a barra de pesquisa), e a confusão entre as configurações do nó e as configurações do workflow.
- O exercício deve ser a criação de um novo workflow, a adição de três nós aleatórios (ex: Start, Function, Log) e a conexão entre eles, salvando o workflow com um nome descritivo."

---

### Aula 4: Seu Primeiro Workflow: Hello World com o n8n

**Prompt:**
"Gere a **Aula 4: Seu Primeiro Workflow: Hello World com o n8n**.
**Objetivo:** Criar e executar um workflow simples no n8n para entender o fluxo de dados e a lógica de execução, utilizando nós básicos para exibir uma mensagem "Hello World".
**Pré-requisitos:** Aula 3 concluída. Familiaridade com a interface do n8n.
**Projeto Prático:** Criação de um workflow "Hello World" que, ao ser executado, exibe uma mensagem simples no painel de execução.
**Log de Estado do Projeto:**
- **Objetivo:** Criar e executar o primeiro workflow funcional no n8n.
- **Código Adicionado:** Workflow `hello_world.json` que exibe uma mensagem.
- **Estado Funcional:** ✅ O workflow "Hello World" é executado com sucesso e a mensagem é exibida.
- **Próximas Etapas:** Aula 5 aprofundará nos tipos de nós fundamentais: Triggers e Nodes de Operação.
**Instruções Específicas:**
- Explique o conceito de **workflow** como uma sequência de passos automatizados.
- Utilize o nó **Start** (ou **Manual Trigger**) como ponto de partida do workflow.
- Introduza o nó **Set** para definir um valor simples (ex: uma mensagem de texto "Hello, n8n World!").
- Mostre como conectar o nó **Start** ao nó **Set**.
- Explique como **executar** o workflow (botão "Execute Workflow") e como **visualizar os resultados** no painel de execução, inspecionando a saída de cada nó.
- O diagrama Mermaid deve ilustrar o workflow "Hello World": Start → Set (com a mensagem) → Resultado.
- A seção de antecipação de erros deve cobrir o esquecimento de conectar os nós, o erro de digitação na mensagem do nó Set e a dificuldade em interpretar a saída JSON no painel de execução.
- O exercício deve ser a modificação do workflow "Hello World" para que ele exiba uma mensagem personalizada, incluindo o nome do aluno (ex: "Olá, [Seu Nome]! Bem-vindo ao n8n!")."

---

### Aula 5: Tipos de Nós Fundamentais: Triggers e Nodes de Operação

**Prompt:**
"Gere a **Aula 5: Tipos de Nós Fundamentais: Triggers e Nodes de Operação**.
**Objetivo:** Entender a diferença crucial entre nós de gatilho (Trigger Nodes) e nós de operação (Regular Nodes), e como usá-los para iniciar e processar dados em um workflow.
**Pré-requisitos:** Aula 4 concluída. Capacidade de criar e executar workflows simples.
**Projeto Prático:** Criação de dois workflows distintos: um com um **Manual Trigger** e outro com um **Cron Trigger**, ambos conectados a um nó de operação simples (ex: Set ou Log) para demonstrar a diferença de iniciação.
**Log de Estado do Projeto:**
- **Objetivo:** Compreender e aplicar a diferença entre nós de gatilho e nós de operação.
- **Código Adicionado:** Dois workflows: `manual_trigger_example.json` e `cron_trigger_example.json`.
- **Estado Funcional:** ✅ Os workflows são executados corretamente, demonstrando as diferentes formas de iniciar um fluxo.
- **Próximas Etapas:** Aula 6 abordará a manipulação de dados com o nó Function e expressões básicas.
**Instruções Específicas:**
- Explique a analogia de um **gatilho** (Trigger) como o **início de um evento** (ex: o despertador que toca, a campainha que toca) e um **nó de operação** como uma **ação** que acontece depois (ex: você levanta, você abre a porta).
- Descreva os principais tipos de **Trigger Nodes**:
    - **Manual Trigger:** Inicia o workflow manualmente.
    - **Webhook:** Inicia o workflow quando uma requisição HTTP é recebida.
    - **Cron:** Inicia o workflow em intervalos de tempo programados.
- Descreva os principais tipos de **Regular Nodes** (nós de operação):
    - **Set:** Define ou modifica dados.
    - **Function:** Executa código JavaScript personalizado.
    - **HTTP Request:** Faz requisições HTTP para APIs externas.
    - **If:** Adiciona lógica condicional.
- Mostre como configurar um **Cron Trigger** para executar a cada minuto (apenas para demonstração, com aviso para desativar depois).
- O diagrama Mermaid deve ilustrar a distinção entre Trigger Nodes (que iniciam o fluxo) e Regular Nodes (que processam os dados).
- A seção de antecipação de erros deve cobrir o erro de tentar usar um nó de operação como primeiro nó (o n8n exige um Trigger) e a confusão sobre como os dados fluem do Trigger para o primeiro nó de operação.
- O exercício deve ser a criação de um workflow com um **Webhook Trigger** que, ao receber uma requisição, exibe uma mensagem simples no painel de execução (o aluno não precisa enviar uma requisição real ainda, apenas configurar o nó)."

---

## Módulo 2 — Proficiente (Prática e Integrações Básicas)

### Aula 6: Manipulando Dados: O Nó Function e Expressões Básicas

**Prompt:**
"Gere a **Aula 6: Manipulando Dados: O Nó Function e Expressões Básicas**.
**Objetivo:** Aprender a manipular dados dentro dos workflows usando o nó **Function** para executar código JavaScript personalizado e **expressões** para acessar e transformar dados de nós anteriores.
**Pré-requisitos:** Aula 5 concluída. Compreensão dos tipos de nós e do fluxo de execução.
**Projeto Prático:** Criação de um workflow que recebe um nome (via nó Set), usa o nó Function para adicionar um sobrenome e uma saudação, e exibe o resultado.
**Log de Estado do Projeto:**
- **Objetivo:** Manipular dados de forma programática usando o nó Function e expressões.
- **Código Adicionado:** Workflow `data_manipulation.json` com nós Set e Function.
- **Estado Funcional:** ✅ O workflow processa e transforma os dados conforme o esperado.
- **Próximas Etapas:** Aula 7 abordará a conexão com serviços externos usando o nó HTTP Request.
**Instruções Específicas:**
- Explique o nó **Function** com a analogia de um **mini-programador** dentro do seu workflow: ele pode fazer qualquer coisa que o JavaScript permite com os dados que chegam.
- Mostre a estrutura básica do código JavaScript dentro do nó Function: `return items;` e como acessar os dados de entrada via `items[0].json.propertyName`.
- Introduza o conceito de **expressões** no n8n: `{{ $json.propertyName }}` ou `{{ $node["Node Name"].json.propertyName }}` para referenciar dados de nós anteriores.
- Demonstre como criar novos campos ou modificar campos existentes usando o nó Function.
- O diagrama Mermaid deve ilustrar o fluxo de dados: Entrada de Dados → Nó Function (processamento) → Saída de Dados.
- A seção de antecipação de erros deve cobrir erros de sintaxe JavaScript no nó Function, o acesso incorreto a propriedades JSON e a confusão entre o nó Set e o nó Function para manipulação de dados.
- O exercício deve ser a modificação do workflow para que ele receba dois números (via nó Set) e use o nó Function para calcular a soma e a multiplicação desses números, exibindo ambos os resultados."

---

### Aula 7: Conectando com Serviços Externos: O Nó HTTP Request

**Prompt:**
"Gere a **Aula 7: Conectando com Serviços Externos: O Nó HTTP Request**.
**Objetivo:** Entender como o n8n pode interagir com APIs externas e outros serviços web usando o nó **HTTP Request** para enviar e receber dados.
**Pré-requisitos:** Aula 6 concluída. Capacidade de manipular dados básicos.
**Projeto Prático:** Criação de um workflow que faz uma requisição HTTP GET para uma API pública simples (ex: JSONPlaceholder para buscar posts ou uma API de clima) e exibe os dados recebidos.
**Log de Estado do Projeto:**
- **Objetivo:** Realizar requisições HTTP para serviços externos.
- **Código Adicionado:** Workflow `http_request_example.json` com nós HTTP Request e Set.
- **Estado Funcional:** ✅ O workflow faz a requisição e exibe os dados da API externa.
- **Próximas Etapas:** Aula 8 abordará a tomada de decisão com o nó IF e lógica condicional.
**Instruções Específicas:**
- Explique o nó **HTTP Request** com a analogia de um **carteiro** que envia e recebe correspondências (dados) para outros endereços (APIs).
- Revise brevemente os conceitos de **HTTP Methods** (GET, POST) e **URLs**.
- Mostre como configurar o nó HTTP Request:
    - **URL:** O endereço da API.
    - **Method:** O tipo de requisição (GET, POST, etc.).
    - **Headers:** Cabeçalhos da requisição (ex: `Content-Type`, `Authorization`).
    - **Query Parameters:** Parâmetros na URL.
    - **Body:** Corpo da requisição (para POST, PUT).
- Utilize uma API pública que não exija autenticação para o primeiro exemplo (ex: `https://jsonplaceholder.typicode.com/posts/1` ou uma API de clima simples).
- Explique como inspecionar a **resposta JSON** da API no painel de execução.
- O diagrama Mermaid deve ilustrar o fluxo: Trigger → HTTP Request (para API Externa) → Processamento da Resposta.
- A seção de antecipação de erros deve cobrir erros de URL, erros de rede, respostas inesperadas da API e a dificuldade em extrair dados específicos da resposta JSON.
- O exercício deve ser a modificação do workflow para que ele busque uma lista de posts (ex: `https://jsonplaceholder.typicode.com/posts`) e use o nó Set para extrair apenas o `title` e o `body` do primeiro post da lista."

---

### Aula 8: Tomada de Decisão: O Nó IF e Lógica Condicional

**Prompt:**
"Gere a **Aula 8: Tomada de Decisão: O Nó IF e Lógica Condicional**.
**Objetivo:** Implementar lógica condicional nos workflows usando o nó **IF** para direcionar o fluxo de dados com base em condições específicas.
**Pré-requisitos:** Aula 7 concluída. Capacidade de fazer requisições HTTP.
**Projeto Prático:** Criação de um workflow que recebe um número (via nó Set), usa o nó IF para verificar se o número é par ou ímpar, e envia mensagens diferentes para cada caso.
**Log de Estado do Projeto:**
- **Objetivo:** Adicionar lógica condicional aos workflows.
- **Código Adicionado:** Workflow `conditional_logic.json` com nós Set, IF e dois nós Set de saída.
- **Estado Funcional:** ✅ O workflow direciona o fluxo corretamente com base na condição.
- **Próximas Etapas:** Aula 9 abordará a iteração sobre dados com o nó Split In Batches e Loop.
**Instruções Específicas:**
- Explique o nó **IF** com a analogia de um **desvio de caminho** ou **encruzilhada**: dependendo de uma condição, o fluxo segue por um lado ou por outro.
- Mostre como configurar o nó IF:
    - **Value 1:** O valor a ser comparado (pode ser uma expressão).
    - **Operation:** O tipo de comparação (Equals, Not Equals, Greater Than, Contains, etc.).
    - **Value 2:** O valor com o qual comparar.
- Explique as duas saídas do nó IF: **True** (se a condição for verdadeira) e **False** (se a condição for falsa).
- Demonstre como conectar nós diferentes a cada uma das saídas do IF.
- O diagrama Mermaid deve ilustrar o fluxo condicional: Entrada de Dados → Nó IF (Condição) → Saída True OU Saída False.
- A seção de antecipação de erros deve cobrir erros de lógica na condição (ex: usar `==` em vez de `===` em JavaScript, ou comparar tipos de dados diferentes), e o esquecimento de conectar nós a ambas as saídas do IF.
- O exercício deve ser a modificação do workflow para que ele receba uma string (ex: nome de um produto) e use o nó IF para verificar se a string contém a palavra "desconto". Se sim, uma mensagem "Produto com desconto!" é exibida; caso contrário, "Produto sem desconto."."

---

### Aula 9: Iterando sobre Dados: O Nó Split In Batches e Loop

**Prompt:**
"Gere a **Aula 9: Iterando sobre Dados: O Nó Split In Batches e Loop**.
**Objetivo:** Aprender a processar listas de itens individualmente ou em lotes usando nós como **Split In Batches** e entender o conceito de loop implícito no n8n.
**Pré-requisitos:** Aula 8 concluída. Capacidade de usar lógica condicional.
**Projeto Prático:** Criação de um workflow que recebe uma lista de nomes (via nó Set), usa o nó Split In Batches para processar cada nome individualmente e, para cada nome, gera uma mensagem personalizada.
**Log de Estado do Projeto:**
- **Objetivo:** Processar listas de dados de forma iterativa.
- **Código Adicionado:** Workflow `data_iteration.json` com nós Set, Split In Batches e Function.
- **Estado Funcional:** ✅ O workflow itera sobre a lista e processa cada item individualmente.
- **Próximas Etapas:** Aula 10 abordará o armazenamento de dados com o nó Write Binary File e integração com Google Sheets.
**Instruções Específicas:**
- Explique o conceito de **iteração** com a analogia de um **processo em linha de montagem**: cada item da lista passa por uma série de passos individualmente.
- Explique o **loop implícito** do n8n: muitos nós processam cada item de uma lista de entrada de forma automática, sem a necessidade de um nó de loop explícito.
- Introduza o nó **Split In Batches** com a analogia de uma **esteira transportadora** que separa itens em lotes menores ou individualmente para processamento.
- Mostre como configurar o nó Split In Batches para processar **um item por vez**.
- Demonstre como um nó subsequente (ex: Function ou Set) receberá cada item individualmente após o Split In Batches.
- O diagrama Mermaid deve ilustrar o fluxo: Lista de Itens → Split In Batches → Processamento Individual (Loop).
- A seção de antecipação de erros deve cobrir a confusão sobre quando usar Split In Batches (quando um nó subsequente não lida bem com listas) e a dificuldade em acessar o item atual dentro do loop.
- O exercício deve ser a modificação do workflow para que ele receba uma lista de produtos (cada um com nome e preço) e, para cada produto, use o nó Function para calcular o preço com 10% de desconto, exibindo o nome e o novo preço."

---

### Aula 10: Armazenando Dados: O Nó Write Binary File e Integração com Google Sheets (Exemplo)

**Prompt:**
"Gere a **Aula 10: Armazenando Dados: O Nó Write Binary File e Integração com Google Sheets (Exemplo)**.
**Objetivo:** Aprender a salvar dados processados em arquivos locais usando o nó **Write Binary File** e entender como o n8n pode se integrar a serviços de armazenamento em nuvem, como o Google Sheets, para persistir informações.
**Pré-requisitos:** Aula 9 concluída. Capacidade de iterar sobre dados.
**Projeto Prático:** Criação de um workflow que gera um texto simples (via nó Set), o salva em um arquivo `.txt` local usando o nó Write Binary File, e um segundo workflow que simula o envio de dados para uma planilha Google Sheets (sem a necessidade de configurar uma conta real, apenas mostrando o nó e suas opções).
**Log de Estado do Projeto:**
- **Objetivo:** Salvar dados processados em arquivos locais e entender a integração com serviços de armazenamento.
- **Código Adicionado:** Workflow `save_to_file.json` com nós Set e Write Binary File. Workflow `google_sheets_example.json` com nós Set e Google Sheets.
- **Estado Funcional:** ✅ O workflow salva o arquivo localmente. O workflow de Google Sheets demonstra a configuração.
- **Próximas Etapas:** Aula 11 abordará o agendamento e execução de workflows com Cron e Webhooks.
**Instruções Específicas:**
- Explique o nó **Write Binary File** com a analogia de um **escriturário** que pega informações e as anota em um documento físico.
- Mostre como configurar o nó Write Binary File:
    - **File Name:** O nome do arquivo a ser salvo.
    - **File Content:** O conteúdo do arquivo (pode ser uma expressão).
    - **File Type:** O tipo do arquivo (ex: `text/plain`).
    - **Destination:** O caminho onde o arquivo será salvo.
- Introduza o nó **Google Sheets** como um exemplo de integração com serviços de armazenamento em nuvem. Explique a necessidade de **credenciais** para conectar a serviços externos.
- Mostre as opções básicas do nó Google Sheets (ex: Append Row, Get All Rows), explicando o que cada uma faz sem a necessidade de configurar uma conta real.
- O diagrama Mermaid deve ilustrar o fluxo: Geração de Dados → Nó Write Binary File (Salvar Localmente) E/OU Geração de Dados → Nó Google Sheets (Salvar em Nuvem).
- A seção de antecipação de erros deve cobrir erros de permissão de escrita no sistema de arquivos, o caminho do arquivo não existindo e a configuração incorreta de credenciais para serviços em nuvem.
- O exercício deve ser a modificação do workflow de salvar em arquivo para que ele salve um arquivo `.json` contendo uma lista de objetos (ex: lista de produtos com nome e preço) gerada por um nó Set."

---

## Módulo 3 — Mestre (Otimização e Boas Práticas)

### Aula 11: Agendamento e Execução de Workflows: Cron e Webhooks

**Prompt:**
"Gere a **Aula 11: Agendamento e Execução de Workflows: Cron e Webhooks**.
**Objetivo:** Configurar workflows para serem executados automaticamente em intervalos de tempo específicos usando o nó **Cron** e por eventos externos via requisições HTTP usando o nó **Webhook**.
**Pré-requisitos:** Aula 10 concluída. Capacidade de armazenar dados.
**Projeto Prático:** Criação de um workflow com um **Cron Trigger** que executa a cada 5 minutos (para demonstração) e envia uma mensagem de log. Criação de um segundo workflow com um **Webhook Trigger** que, ao receber uma requisição HTTP, processa um dado simples e envia uma resposta.
**Log de Estado do Projeto:**
- **Objetivo:** Configurar workflows para execução agendada e por eventos externos.
- **Código Adicionado:** Workflow `scheduled_workflow.json` com Cron Trigger. Workflow `webhook_workflow.json` com Webhook Trigger.
- **Estado Funcional:** ✅ O workflow agendado executa automaticamente. O workflow de webhook está pronto para receber requisições.
- **Próximas Etapas:** Aula 12 abordará o tratamento de erros e resiliência de workflows.
**Instruções Específicas:**
- Revise os conceitos de **Cron Trigger** e **Webhook Trigger** introduzidos na Aula 5, aprofundando nas suas configurações.
- Explique a sintaxe **Cron** para agendamento (minuto, hora, dia do mês, mês, dia da semana) com exemplos práticos (ex: `* * * * *` para cada minuto, `0 9 * * 1-5` para 9h de segunda a sexta).
- Mostre como configurar um **Webhook Trigger**:
    - **HTTP Method:** GET, POST, etc.
    - **Path:** O caminho da URL do webhook.
    - **Response Mode:** Como o webhook deve responder (ex: `Respond to Webhook`).
- Explique a **URL do Webhook** gerada pelo n8n e como ela é usada para disparar o workflow externamente.
- O diagrama Mermaid deve ilustrar os dois tipos de gatilho: Cron (Tempo) → Workflow E Webhook (Evento Externo) → Workflow.
- A seção de antecipação de erros deve cobrir erros na sintaxe Cron, o Webhook não respondendo (problemas de firewall ou URL incorreta) e a confusão sobre quando usar Cron versus Webhook.
- O exercício deve ser a modificação do workflow de Webhook para que ele receba um parâmetro `mensagem` via requisição POST e o exiba no painel de execução, respondendo com um status HTTP 200 e a mensagem "Mensagem recebida com sucesso!"."

---

### Aula 12: Tratamento de Erros e Resiliência de Workflows

**Prompt:**
"Gere a **Aula 12: Tratamento de Erros e Resiliência de Workflows**.
**Objetivo:** Implementar mecanismos para lidar com falhas e garantir a robustez dos workflows, utilizando o nó **Error Trigger** e estratégias de tratamento de erros.
**Pré-requisitos:** Aula 11 concluída. Capacidade de agendar e disparar workflows.
**Projeto Prático:** Criação de um workflow principal que simula um erro (ex: tentando acessar uma propriedade JSON inexistente) e um workflow secundário com um **Error Trigger** que captura esse erro e envia uma notificação simples (ex: logando a mensagem de erro).
**Log de Estado do Projeto:**
- **Objetivo:** Adicionar tratamento de erros para tornar os workflows mais robustos.
- **Código Adicionado:** Workflow `main_workflow_with_error.json` (simulando erro) e `error_handling_workflow.json` (com Error Trigger).
- **Estado Funcional:** ✅ O erro no workflow principal é capturado e tratado pelo workflow de tratamento de erros.
- **Próximas Etapas:** Aula 13 abordará boas práticas e organização de workflows.
**Instruções Específicas:**
- Explique a importância do **tratamento de erros** com a analogia de um **plano de contingência**: o que fazer quando algo inesperado acontece.
- Introduza o nó **Error Trigger** com a analogia de um **sistema de alarme** que dispara quando um problema é detectado em outro lugar.
- Mostre como configurar o Error Trigger para escutar erros de **todos os workflows** ou de **workflows específicos**.
- Demonstre como um workflow com Error Trigger pode acessar os detalhes do erro (mensagem, nó que falhou, workflow ID).
- Explique a diferença entre erros que **param o workflow** e erros que podem ser **tratados dentro do próprio fluxo** (ex: usando o nó IF para verificar se uma API retornou sucesso).
- O diagrama Mermaid deve ilustrar o fluxo: Workflow Principal (com erro) → Error Trigger (em outro workflow) → Ação de Tratamento de Erro.
- A seção de antecipação de erros deve cobrir o Error Trigger não sendo ativado (configuração incorreta), a dificuldade em reproduzir erros específicos para teste e a confusão sobre onde o tratamento de erro deve ser implementado (no próprio workflow ou em um workflow separado).
- O exercício deve ser a modificação do workflow de tratamento de erros para que, além de logar a mensagem, ele também use o nó Set para formatar uma mensagem de erro mais amigável e a exiba."

---

### Aula 13: Boas Práticas e Organização de Workflows

**Prompt:**
"Gere a **Aula 13: Boas Práticas e Organização de Workflows**.
**Objetivo:** Aprender a organizar, documentar e manter workflows de forma eficiente, garantindo clareza, escalabilidade e facilidade de manutenção.
**Pré-requisitos:** Aula 12 concluída. Compreensão do tratamento de erros.
**Projeto Prático:** Refatoração de um dos workflows existentes (ex: o workflow de manipulação de dados da Aula 6) aplicando boas práticas: renomear nós, adicionar descrições, usar grupos e cores para organização visual.
**Log de Estado do Projeto:**
- **Objetivo:** Aplicar boas práticas de organização e documentação em workflows.
- **Código Adicionado:** Workflow refatorado com nomes claros, descrições e organização visual.
- **Estado Funcional:** ✅ O workflow refatorado é mais legível e fácil de entender.
- **Próximas Etapas:** Aula 14 abordará variáveis de ambiente e credenciais seguras.
**Instruções Específicas:**
- Explique a importância da **organização** e **documentação** com a analogia de um **manual de instruções** bem escrito: facilita o entendimento e a manutenção por outras pessoas (ou por você mesmo no futuro).
- Apresente as seguintes boas práticas:
    - **Nomes de Nós Descritivos:** Usar nomes que indiquem a função do nó (ex: "Buscar Dados de Clientes" em vez de "HTTP Request").
    - **Descrições de Nós:** Adicionar descrições detalhadas para nós complexos.
    - **Grupos de Nós:** Agrupar nós relacionados visualmente para organizar seções do workflow.
    - **Cores de Nós:** Usar cores para categorizar nós ou destacar partes importantes.
    - **Comentários:** Adicionar nós de comentário para explicar lógicas complexas.
    - **Modularização:** Dividir workflows grandes em workflows menores e reutilizáveis (sub-workflows).
    - **Versionamento:** Salvar versões do workflow (o n8n tem um histórico de versões).
- O diagrama Mermaid deve ilustrar um workflow bem organizado, com grupos e nomes descritivos.
- A seção de antecipação de erros deve cobrir a dificuldade em manter a organização em workflows complexos e a tentação de pular a documentação.
- O exercício deve ser a criação de um novo workflow simples (ex: um que busca dados de uma API e os exibe) e a aplicação de todas as boas práticas de organização e documentação aprendidas na aula."

---

### Aula 14: Variáveis de Ambiente e Credenciais Seguras

**Prompt:**
"Gere a **Aula 14: Variáveis de Ambiente e Credenciais Seguras**.
**Objetivo:** Gerenciar informações sensíveis (chaves de API, senhas) e configurações de ambiente de forma segura no n8n, utilizando **variáveis de ambiente** e o sistema de **credenciais** do n8n.
**Pré-requisitos:** Aula 13 concluída. Compreensão das boas práticas de organização.
**Projeto Prático:** Criação de uma **credencial** genérica no n8n para simular uma chave de API e a utilização dessa credencial em um nó HTTP Request. Demonstração de como usar uma **variável de ambiente** para configurar um valor (ex: URL base de uma API).
**Log de Estado do Projeto:**
- **Objetivo:** Gerenciar informações sensíveis e configurações de ambiente de forma segura.
- **Código Adicionado:** Workflow `secure_credentials.json` utilizando uma credencial e uma variável de ambiente.
- **Estado Funcional:** ✅ O workflow acessa informações sensíveis de forma segura.
- **Próximas Etapas:** Aula 15 abordará o deploy e monitoramento básico do n8n.
**Instruções Específicas:**
- Explique a importância da **segurança** e por que não devemos "hardcodar" (escrever diretamente no workflow) informações sensíveis, com a analogia de não deixar a chave de casa debaixo do tapete.
- Introduza o conceito de **Credenciais** no n8n: um local seguro para armazenar chaves de API, tokens e senhas, que podem ser reutilizadas em múltiplos nós e workflows.
- Mostre como criar uma nova credencial (ex: "Generic Credential") e como referenciá-la em um nó (ex: no nó HTTP Request para um cabeçalho de autenticação).
- Explique o conceito de **Variáveis de Ambiente** (Environment Variables) e como elas podem ser usadas para configurar o n8n ou fornecer valores dinâmicos para workflows (ex: `N8N_BASIC_AUTH_USER`, `N8N_HOST`).
- Mostre como usar uma variável de ambiente dentro de um nó via expressão (ex: `{{ $env.MY_API_URL }}`).
- O diagrama Mermaid deve ilustrar o fluxo: Workflow → Nó (usando Credencial) → Serviço Externo E Workflow → Nó (usando Variável de Ambiente) → Valor Configurado.
- A seção de antecipação de erros deve cobrir o erro de credencial não encontrada, a variável de ambiente não sendo carregada corretamente e a confusão sobre quando usar uma credencial versus uma variável de ambiente.
- O exercício deve ser a criação de um workflow que usa uma credencial para simular o envio de um e-mail (usando o nó Email Send, sem configurar um servidor real, apenas mostrando a configuração da credencial para o SMTP)."

---

### Aula 15: Deploy e Monitoramento Básico do n8n

**Prompt:**
"Gere a **Aula 15: Deploy e Monitoramento Básico do n8n**.
**Objetivo:** Entender as opções de deploy do n8n (local, nuvem, Docker), como monitorar a execução dos workflows e como garantir que a aplicação esteja sempre disponível e funcionando.
**Pré-requisitos:** Aula 14 concluída. Compreensão do gerenciamento seguro de credenciais.
**Projeto Prático:** Revisão final do projeto "Sistema de Automação de Notificações e Processamento de Dados Simples", com foco nas considerações para um deploy em produção. Exploração do painel de **Executions** e **Logs** do n8n para monitoramento.
**Log de Estado do Projeto:**
- **Objetivo:** Finalizar o projeto, entender as opções de deploy e monitoramento.
- **Código Adicionado:** Nenhum código novo. Revisão e considerações para deploy.
- **Estado Funcional:** ✅ O projeto está pronto para ser considerado para um ambiente de produção, com compreensão das ferramentas de monitoramento.
- **Próximas Etapas:** Sugestões de evolução: integração com mais serviços, criação de workflows mais complexos, uso de n8n em cluster.
**Instruções Específicas:**
- Explique as diferentes opções de **deploy** do n8n:
    - **Local:** Como estamos usando (para desenvolvimento).
    - **Docker:** A forma mais recomendada para produção (explique brevemente o que é Docker).
    - **Cloud:** Serviços como n8n Cloud, ou deploy em VMs na AWS, Azure, Google Cloud.
- Explique a importância do **monitoramento** com a analogia de um **painel de controle de avião**: você precisa saber o que está acontecendo para garantir que tudo funcione bem.
- Mostre o painel de **Executions** do n8n: como ver o histórico de execuções, o status (sucesso, falha), a duração e os dados de entrada/saída de cada nó.
- Explique como acessar os **logs** do n8n (seja no terminal ou em arquivos de log) para depurar problemas.
- Discuta brevemente a importância de **backups** dos workflows e das credenciais.
- O diagrama Mermaid deve ilustrar as opções de deploy: Local → Docker → Cloud.
- A seção de antecipação de erros deve cobrir o n8n parando de funcionar em produção (necessidade de monitoramento e reinício automático), problemas de performance em workflows complexos e a perda de dados por falta de backup.
- O exercício final deve ser uma proposta de deploy escrita pelo aluno: escolher uma das opções de deploy (Docker ou Cloud) e descrever brevemente os passos que seriam necessários para colocar o "Sistema de Automação de Notificações e Processamento de Dados Simples" em produção, incluindo como ele monitoraria o workflow após o deploy."