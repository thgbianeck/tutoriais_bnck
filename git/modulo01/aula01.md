# Aula 1: Introdução ao Git e Controle de Versão

## Resumo da Aula Anterior
Nenhum. Esta é a primeira aula.

## Objetivo
Entender o que é controle de versão, a importância do Git e instalar/configurar o ambiente para o nosso projeto prático.

## Pré-requisitos
Nenhum. Este é o ponto de partida.

## Análise de Integridade
✅ Conteúdo verificado: profundidade técnica mantida, linguagem acessível, código funcional.

## Teoria Detalhada (Narrativa Densa)

No vasto e dinâmico universo do desenvolvimento de software, a capacidade de gerenciar e rastrear as mudanças em um projeto é tão crucial quanto a própria escrita do código. Imagine um cenário onde múltiplos desenvolvedores trabalham simultaneamente em um mesmo projeto, cada um modificando diferentes partes do código. Sem um sistema robusto para coordenar essas alterações, o caos rapidamente se instalaria: versões seriam sobrescritas, bugs seriam introduzidos sem rastreamento e a colaboração se tornaria um pesadelo. É nesse contexto que os **Sistemas de Controle de Versão (VCS - Version Control Systems)** emergem como ferramentas indispensáveis, atuando como a espinha dorsal de qualquer projeto de software moderno.

Historicamente, o controle de versão evoluiu através de diferentes estágios, cada um buscando resolver as limitações do anterior. No início, tínhamos os **Sistemas de Controle de Versão Locais**. Pense em um desenvolvedor que, para não perder seu trabalho, criava cópias de segurança de seus arquivos em diferentes pastas, nomeando-as como "código_final", "código_final_final", "código_final_final_v2". Embora rudimentar, essa abordagem permitia um certo nível de rastreamento pessoal, mas era extremamente propensa a erros, ocupava muito espaço e era inviável para qualquer tipo de colaboração. A analogia aqui é a de um escritor que salva várias versões de seu manuscrito em seu próprio computador, sem compartilhar com ninguém.

A próxima evolução trouxe os **Sistemas de Controle de Versão Centralizados (CVCS - Centralized Version Control Systems)**. Ferramentas como CVS e Subversion (SVN) dominaram essa era. A ideia era simples: haveria um único servidor central que armazenaria todas as versões do código. Os desenvolvedores "checavam" os arquivos do servidor, faziam suas modificações localmente e depois "comitavam" (enviavam) suas alterações de volta para o servidor central. A grande vantagem era a colaboração facilitada, pois todos trabalhavam com uma base de código comum. No entanto, o CVCS possuía uma falha crítica: o servidor central era um **ponto único de falha**. Se o servidor ficasse offline, ninguém poderia commitar, ninguém poderia atualizar seu código, e o pior, se o servidor falhasse permanentemente e não houvesse backup, todo o histórico do projeto seria perdido. Imagine uma biblioteca central onde todos os livros são guardados. Se a biblioteca pegar fogo, todos os livros se perdem.

Foi para superar essas limitações que surgiram os **Sistemas de Controle de Versão Distribuídos (DVCS - Distributed Version Control Systems)**, e o **Git** é o exemplo mais proeminente e amplamente adotado dessa categoria. A principal diferença do Git é que, em vez de apenas fazer um "checkout" da última versão do código, cada desenvolvedor clona o **repositório completo**, incluindo todo o histórico de versões. Isso significa que cada cópia local do repositório é, na verdade, um backup completo do projeto. Se o servidor central (onde o repositório principal está hospedado, como o GitHub) falhar, qualquer desenvolvedor com uma cópia local pode restaurar o projeto inteiro. Além disso, o trabalho pode continuar offline, pois os commits são feitos localmente e sincronizados com o remoto posteriormente.

O Git, criado por Linus Torvalds (o mesmo criador do Linux) em 2005, revolucionou o controle de versão devido a várias de suas características fundamentais:

1.  **Velocidade:** O Git foi projetado para ser extremamente rápido. A maioria das operações (como commitar, comparar versões, navegar pelo histórico) é realizada localmente, sem a necessidade de comunicação com um servidor remoto, o que as torna quase instantâneas.
2.  **Integridade de Dados:** O Git utiliza um mecanismo de hashing (SHA-1) para garantir a integridade de cada commit. Cada alteração é rastreada por um identificador único, tornando praticamente impossível que o histórico seja corrompido ou que uma alteração passe despercebida.
3.  **Suporte a Trabalho Offline:** Como cada desenvolvedor tem uma cópia completa do repositório, é possível fazer commits, criar branches e realizar diversas operações sem estar conectado à internet. A sincronização com o repositório remoto ocorre apenas quando necessário.
4.  **Branching e Merging Poderosos:** O Git torna a criação e o gerenciamento de branches (ramificações do código) incrivelmente fácil e eficiente. Isso permite que desenvolvedores trabalhem em novas funcionalidades ou correções de bugs em isolamento, sem afetar a linha principal de desenvolvimento, e depois integrem essas mudanças de forma segura.

Para entender o Git de forma mais intuitiva, podemos usar a **Técnica de Feynman**. Imagine que o Git é um **"caderno mágico"** para o seu projeto de software. Cada vez que você faz uma alteração importante no seu código, você anota essa mudança no seu caderno. Mas não é um caderno comum; ele tem superpoderes:

*   **Ele registra tudo:** Cada linha que você escreve, cada palavra que você apaga, ele sabe. Nada se perde.
*   **Ele tem um índice perfeito:** Você pode voltar para qualquer página (versão) a qualquer momento e ver exatamente como o caderno estava naquele ponto.
*   **Você pode fazer cópias:** Se você quiser experimentar uma nova ideia sem estragar o caderno original, você pode fazer uma cópia exata e trabalhar nela. Se der certo, você pode colar as páginas de volta no original. Se der errado, você joga a cópia fora sem culpa.
*   **Ele é distribuído:** Não existe apenas um caderno. Cada pessoa que trabalha no projeto tem uma cópia completa do caderno mágico. Se o caderno principal sumir, qualquer um pode fornecer uma cópia completa.

Essa capacidade de registrar, rastrear e gerenciar versões de forma distribuída é o que torna o Git tão poderoso e essencial para o desenvolvimento de software, especialmente em "grandes aplicações" onde a colaboração e a robustez são fundamentais.

Nesta aula, nosso primeiro passo será instalar o Git em seu sistema operacional Windows 11 e realizar as configurações iniciais. Em seguida, vamos criar a estrutura básica do nosso projeto prático, uma API Node.js para agendamento de barbearias, que servirá como o "caderno" onde aplicaremos todos os conceitos do Git.

## Analogia de Ancoragem

Para entender o controle de versão, imagine que você está escrevendo um **livro muito importante** com vários coautores.

*   **Sem controle de versão:** Cada coautor salva sua própria versão do capítulo em seu computador. Quando tentam juntar tudo, percebem que um sobrescreveu o trabalho do outro, ou que as mudanças não se encaixam. É um caos, e ninguém sabe qual é a "versão final".
*   **Com controle de versão (Git):** Cada coautor tem uma cópia completa do livro. Quando um faz uma alteração em um capítulo, ele "registra" essa alteração (um **commit**) em sua cópia local. Quando está pronto para compartilhar, ele "envia" suas alterações para a "biblioteca principal" (o repositório remoto). Se outro coautor fez uma alteração diferente no mesmo capítulo, o sistema avisa e ajuda a combinar as mudanças de forma inteligente. Se algo der errado, você pode "voltar no tempo" para qualquer versão anterior do livro. É como ter um histórico detalhado de cada parágrafo, cada frase, e quem fez o quê, a qualquer momento.

## Diagrama Mermaid

~~~mermaid
graph TD
    A[VCS Local: Copias Manuais] --> B[VCS Centralizado: SVN, CVS]
    B --> C[VCS Distribuido: Git]
    C -- "Backup Completo" --> D[Desenvolvedor 1]
    C -- "Backup Completo" --> E[Desenvolvedor 2]
    C -- "Backup Completo" --> F[Desenvolvedor N]
~~~

## Aplicação no Projeto Prático

Nosso projeto prático será uma **API de Agendamento para Barbearias** desenvolvida em Node.js. Para começar, precisamos instalar o Git e configurar nosso ambiente.

### 1. Instalação do Git no Windows 11

1.  **Baixar o instalador:** Acesse o site oficial do Git: [https://git-scm.com/download/win](https://git-scm.com/download/win). O download deve começar automaticamente.
2.  **Executar o instalador:** Abra o arquivo `.exe` baixado.
3.  **Configurações do instalador:**
    *   Clique em **"Next"** em todas as telas, aceitando as configurações padrão. As configurações padrão do Git para Windows são geralmente adequadas para a maioria dos usuários e para o nosso curso.
    *   Se houver uma opção para escolher o editor de texto padrão, você pode selecionar **VS Code** (se já o tiver instalado), o que facilitará a escrita de mensagens de commit posteriormente. Caso contrário, mantenha o padrão (Vim) ou escolha outro de sua preferência.
    *   Continue clicando em **"Next"** até a instalação ser concluída.
4.  **Verificar a instalação:** Abra o **Prompt de Comando** (CMD) ou o **PowerShell** (você pode pesquisar por "cmd" ou "powershell" no menu Iniciar do Windows). Digite o seguinte comando e pressione Enter:
    ~~~bash
    git --version
    ~~~
    Você deverá ver a versão do Git instalada (ex: `git version 2.45.1.windows.1`). Isso confirma que o Git foi instalado corretamente e está acessível no seu PATH.

### 2. Configuração Inicial do Git

Após a instalação, precisamos informar ao Git quem você é. Essas informações serão anexadas a cada commit que você fizer, identificando o autor da mudança.

1.  **Configurar seu nome de usuário:** No mesmo Prompt de Comando ou PowerShell, digite:
    ~~~bash
    git config --global user.name "Seu Nome Completo"
    ~~~
    Substitua `"Seu Nome Completo"` pelo seu nome.
2.  **Configurar seu e-mail:** Em seguida, digite:
    ~~~bash
    git config --global user.email "seu.email@exemplo.com"
    ~~~
    Substitua `"seu.email@exemplo.com"` pelo seu endereço de e-mail.

    A flag `--global` garante que essas configurações sejam aplicadas a todos os seus repositórios Git no seu computador.

### 3. Criando a Estrutura Inicial da API Node.js

Agora, vamos criar a base do nosso projeto `barbershop-api`.

1.  **Criar a pasta do projeto:** Abra o Prompt de Comando ou PowerShell e navegue até o diretório onde você deseja criar seu projeto (ex: `C:\Users\SeuUsuario\Documents\Projetos`).
    ~~~bash
    mkdir barbershop-api
    cd barbershop-api
    ~~~
2.  **Inicializar o projeto Node.js:**
    ~~~bash
    npm init -y
    ~~~
    Este comando cria um arquivo `package.json` com configurações padrão para o seu projeto Node.js.
3.  **Instalar Express.js:** O Express.js é um framework web para Node.js que usaremos para criar nossa API.
    ~~~bash
    npm install express
    ~~~
4.  **Criar o arquivo `server.js`:** Crie um arquivo chamado `server.js` dentro da pasta `barbershop-api` com o seguinte conteúdo:
    ~~~javascript
    // server.js
    const express = require('express'); // Importa o módulo express
    const app = express(); // Cria uma instância do aplicativo express
    const PORT = process.env.PORT || 3000; // Define a porta do servidor, usando a variável de ambiente PORT ou 3000 como padrão

    // Middleware para parsear JSON no corpo das requisições
    app.use(express.json());

    // Rota principal (root)
    app.get('/', (req, res) => {
      res.send('Bem-vindo à BarberShop API!'); // Envia uma resposta de texto simples
    });

    // Rota de exemplo para agendamentos
    app.get('/agendamentos', (req, res) => {
      // Por enquanto, apenas um array vazio. Futuramente, virá do banco de dados.
      const agendamentos = [];
      res.json(agendamentos); // Envia uma resposta JSON
    });

    // Inicia o servidor
    app.listen(PORT, () => {
      console.log(`Servidor rodando na porta ${PORT}`); // Loga uma mensagem quando o servidor inicia
      console.log(`Acesse: http://localhost:${PORT}`); // Informa o endereço para acessar a API
    });
    ~~~
5.  **Executar a API:** No Prompt de Comando ou PowerShell, dentro da pasta `barbershop-api`, execute:
    ~~~bash
    node server.js
    ~~~
    Você deverá ver a mensagem `Servidor rodando na porta 3000` e `Acesse: http://localhost:3000`. Abra seu navegador e acesse `http://localhost:3000`. Você verá a mensagem "Bem-vindo à BarberShop API!". Acesse `http://localhost:3000/agendamentos` e verá um array JSON vazio `[]`.

### 4. Inicializar o Repositório Git no Projeto

Agora que temos nosso projeto base, vamos inicializar o Git nele.

1.  **Inicializar o repositório Git:** No Prompt de Comando ou PowerShell, certifique-se de estar dentro da pasta `barbershop-api`. Digite:
    ~~~bash
    git init
    ~~~
    Você verá uma mensagem como `Initialized empty Git repository in C:/Users/SeuUsuario/Documents/Projetos/barbershop-api/.git/`. Isso cria uma pasta oculta `.git` dentro do seu projeto, que é onde o Git armazenará todo o histórico e metadados do seu repositório.

Parabéns! Você instalou o Git, configurou seu ambiente e criou a estrutura inicial do nosso projeto prático, além de inicializar seu primeiro repositório Git.

## Glossário Técnico da Aula
-   **Controle de Versão (VCS):** Sistema que registra mudanças em um conjunto de arquivos ao longo do tempo, permitindo recuperar versões anteriores.
-   **Git:** Sistema de Controle de Versão Distribuído (DVCS) popular, rápido e eficiente.
-   **Repositório:** Onde o Git armazena todo o histórico do projeto, incluindo arquivos e metadados.
-   **Commit:** Um "instantâneo" das mudanças em um determinado momento no tempo, registrado no histórico do Git.
-   **Instalação:** Processo de configurar um software em um sistema operacional.
-   **Configuração Global:** Definições do Git que se aplicam a todos os repositórios no seu computador.

## Antecipação de Erros
-   **Erro Comum 1: `git` não é reconhecido como um comando interno ou externo:** Isso geralmente significa que o Git não foi adicionado corretamente ao PATH do sistema durante a instalação.
    -   **Como evitar:** Certifique-se de que a opção "Git from the command line and also from 3rd-party software" esteja selecionada durante a instalação. Se já instalou, pode ser necessário reiniciar o terminal ou adicionar manualmente o caminho do Git ao PATH do Windows.
-   **Erro Comum 2: `npm` não é reconhecido:** Indica que o Node.js não está instalado ou não está no PATH.
    -   **Como evitar:** Instale o Node.js a partir do site oficial ([https://nodejs.org/](https://nodejs.org/)) e verifique se a opção de adicionar ao PATH está marcada.
-   **Erro Comum 3: Erro ao executar `node server.js`:** Pode ser devido a erros de sintaxe no `server.js` ou dependências não instaladas.
    -   **Como evitar:** Verifique se o código `server.js` foi copiado corretamente e se `npm install express` foi executado com sucesso.

## Troubleshooting
-   **Problema: `git --version` não funciona.**
    -   **Solução:** Reinicie o Prompt de Comando/PowerShell. Se ainda não funcionar, verifique as variáveis de ambiente do Windows para garantir que o caminho para a pasta `bin` do Git (geralmente `C:\Program Files\Git\cmd` e `C:\Program Files\Git\usr\bin`) esteja no seu PATH. Se não estiver, adicione-o manualmente.
-   **Problema: A API Node.js não inicia ou dá erro.**
    -   **Solução:** Verifique o terminal onde você executou `node server.js` para mensagens de erro. Erros de sintaxe são comuns. Certifique-se de que você está na pasta `barbershop-api` ao executar `node server.js` e que `npm install express` foi executado com sucesso.

## Desafio de Fixação
1.  Verifique novamente a versão do Git instalada (`git --version`).
2.  Altere seu nome de usuário e e-mail no Git para informações fictícias (ex: "Desenvolvedor Teste", "teste@teste.com") e depois volte para suas informações reais. Use `git config --global user.name "Novo Nome"` e `git config --global user.email "novo@email.com"`.
3.  Crie um novo arquivo vazio chamado `test.txt` dentro da pasta `barbershop-api`.
4.  Execute `git status` e observe o que o Git informa sobre o `test.txt`.

## Resoluções Comentadas
1.  `git --version` (apenas para confirmar a instalação).
2.  `git config --global user.name "Desenvolvedor Teste"`
    `git config --global user.email "teste@teste.com"`
    `git config --global user.name "Seu Nome Real"`
    `git config --global user.email "seu.email.real@exemplo.com"`
3.  `type nul > test.txt` (no Prompt de Comando) ou `New-Item test.txt` (no PowerShell) para criar o arquivo vazio.
4.  `git status` mostrará `test.txt` como um arquivo não rastreado (`Untracked files`).

## Resumo dos Pontos-Chave
-   O controle de versão é essencial para gerenciar mudanças em projetos de software.
-   O Git é um Sistema de Controle de Versão Distribuído, rápido e robusto.
-   A instalação do Git no Windows é direta, e a configuração inicial de nome e e-mail é fundamental.
-   Nosso projeto `barbershop-api` será a base para aplicar os conceitos do Git.
-   `git init` transforma uma pasta em um repositório Git.

## Próximos Passos
Na próxima aula, aprenderemos sobre os três estados do Git (**Working Directory**, **Staging Area** e **Local Repository**) e como usar os comandos `git add` e `git commit` para registrar nossas primeiras mudanças no projeto `barbershop-api`.

## Log de Estado do Projeto
-   **Objetivo:** Instalar e configurar o Git, criar a estrutura inicial da API Node.js e inicializar o repositório Git.
-   **Código Adicionado:** Arquivos `package.json` e `server.js` da API inicial.
-   **Estado Funcional:** ✅ API Node.js funcionando, repositório Git inicializado.
-   **Próximas Etapas:** Aula 2 abordará o **Working Directory**, **Staging Area** e o primeiro **commit**.

---
Dúvidas? Posso prosseguir para a próxima etapa?