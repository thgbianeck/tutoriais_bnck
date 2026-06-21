# prompts_individuais.md

## MÓDULO 1 — ESSENCIAL: Fundamentos do Git Local

### Prompt para Aula 1: Introdução ao Git e Controle de Versão

~~~text
Gere a **Aula 1: Introdução ao Git e Controle de Versão**.
**Objetivo:** Entender o que é controle de versão, a importância do Git e instalar/configurar o ambiente.
**Pré-requisitos:** Nenhum. Este é o ponto de partida.
**Conteúdo Teórico:**
- Explique o conceito de controle de versão (VCS) e sua evolução (local, centralizado, distribuído).
- Apresente o Git como um VCS distribuído, destacando suas vantagens (velocidade, integridade de dados, suporte a trabalho offline).
- Utilize a Técnica de Feynman para explicar o Git como um "caderno mágico" que registra todas as alterações do seu projeto.
- Forneça uma analogia do cotidiano para controle de versão (ex: rascunhos de um documento, versões de um projeto arquitetônico).
- Detalhe o processo de instalação do Git no Windows 11, incluindo a verificação da instalação.
- Explique a configuração inicial do Git (nome de usuário e e-mail global) com os comandos `git config --global user.name` e `git config --global user.email`.
- Apresente a estrutura inicial da API Node.js para agendamento de barbearias, explicando que ela será a base do nosso projeto prático. Mostre o código completo de `server.js` e `package.json` para que o aluno possa copiar e criar o projeto.
**Diagrama Mermaid:** Crie um diagrama de fluxo (Graph TD) mostrando a evolução dos sistemas de controle de versão (Local -> Centralizado -> Distribuído).
**Aplicação no Projeto Prático:**
- Instruções para criar a pasta `barbershop-api`.
- Instruções para criar os arquivos `package.json` e `server.js` com o código fornecido.
- Instruções para instalar as dependências do Node.js (`npm install express`).
- Instruções para executar a API e verificar seu funcionamento.
- Instruções para inicializar o repositório Git na pasta do projeto com `git init`.
**Glossário Técnico:** Controle de Versão, Git, Repositório, Commit, Instalação, Configuração Global.
**Antecipação de Erros:** Erros comuns na instalação do Git, problemas de PATH no Windows, erros ao executar a API Node.js.
**Troubleshooting:** Como verificar a instalação do Git, como depurar erros de Node.js.
**Desafio de Fixação:** Instalar o Git, configurar usuário/e-mail, criar a pasta do projeto, copiar o código da API, instalar dependências, executar a API e inicializar o repositório Git.
**Resumo dos Pontos-Chave:** Definição de Git, instalação, configuração, estrutura inicial do projeto.
**Log de Estado do Projeto:**
- Objetivo: Instalar e configurar o Git, criar a estrutura inicial da API Node.js e inicializar o repositório Git.
- Código Adicionado: Arquivos `package.json` e `server.js` da API inicial.
- Estado Funcional: ✅ API Node.js funcionando, repositório Git inicializado.
- Próximas Etapas: Aula 2 abordará o **Working Directory**, **Staging Area** e o primeiro **commit**.
**Prompt de Continuidade:** "Dúvidas? Posso prosseguir para a próxima etapa?"
~~~

### Prompt para Aula 2: O Repositório Local: Inicializando e Acompanhando Mudanças

~~~text
Gere a **Aula 2: O Repositório Local: Inicializando e Acompanhando Mudanças**.
**Objetivo:** Inicializar um repositório Git, entender **Working Directory**, **Staging Area** e **Local Repository**, e usar **git add** e **git commit**.
**Pré-requisitos:** Git instalado e configurado, projeto `barbershop-api` criado e repositório Git inicializado.
**Conteúdo Teórico:**
- Explique os três estados principais do Git: **Working Directory** (diretório de trabalho), **Staging Area** (área de preparação/índice) e **Local Repository** (repositório local).
- Use a analogia de um "fotógrafo" para explicar esses estados: o **Working Directory** é a cena, a **Staging Area** é a seleção de fotos para o álbum, e o **Local Repository** é o álbum final.
- Detalhe o comando `git status` para verificar o estado dos arquivos.
- Explique o comando `git add <arquivo>` para adicionar arquivos à **Staging Area**.
- Explique o comando `git commit -m "mensagem"` para registrar as mudanças no **Local Repository**.
- Aborde a importância de mensagens de commit claras e descritivas.
**Diagrama Mermaid:** Crie um diagrama de fluxo (Graph TD) ilustrando os três estados do Git e a transição entre eles com `git add` e `git commit`.
**Aplicação no Projeto Prático:**
- Adicione um novo arquivo `README.md` ao projeto `barbershop-api` com uma descrição inicial.
- Use `git status` para ver o estado do `README.md`.
- Use `git add README.md` para adicionar o arquivo à **Staging Area**.
- Use `git status` novamente para observar a mudança.
- Crie o primeiro commit com `git commit -m "feat: inicializa projeto e adiciona README"`.
- Adicione os arquivos `package.json` e `server.js` ao **Staging Area** e faça um segundo commit.
**Glossário Técnico:** Working Directory, Staging Area, Local Repository, git status, git add, git commit, Mensagem de Commit.
**Antecipação de Erros:** Esquecer de adicionar arquivos, mensagens de commit vagas, tentar commitar sem arquivos na Staging Area.
**Troubleshooting:** Como verificar o que está na Staging Area, como corrigir uma mensagem de commit (breve menção a `git commit --amend`).
**Desafio de Fixação:** Criar um arquivo `.env` (vazio por enquanto), adicioná-lo à Staging Area e fazer um commit com uma mensagem apropriada.
**Resumo dos Pontos-Chave:** Os três estados do Git, como usar `git status`, `git add` e `git commit`.
**Log de Estado do Projeto:**
- Objetivo: Entender os estados do Git e realizar os primeiros commits no projeto `barbershop-api`.
- Código Adicionado: `README.md` e primeiro commit da API inicial.
- Estado Funcional: ✅ Repositório Git com histórico inicial.
- Próximas Etapas: Aula 3 abordará a visualização do histórico de commits com `git log`.
**Prompt de Continuidade:** "Dúvidas? Posso prosseguir para a próxima etapa?"
~~~

### Prompt para Aula 3: Entendendo o Histórico: Visualizando Commits

~~~text
Gere a **Aula 3: Entendendo o Histórico: Visualizando Commits**.
**Objetivo:** Visualizar o histórico de commits com **git log** e suas opções de formatação.
**Pré-requisitos:** Repositório Git com commits realizados.
**Conteúdo Teórico:**
- Explique a importância do histórico de commits para rastrear mudanças e entender a evolução do projeto.
- Apresente o comando `git log` e sua saída padrão (SHA-1, autor, data, mensagem).
- Detalhe as opções de formatação do `git log` para melhor legibilidade:
    - `git log --oneline`: Resumo de um commit por linha.
    - `git log --graph`: Visualização em grafo do histórico.
    - `git log --decorate`: Mostrar referências (HEAD, branches, tags).
    - `git log -p`: Mostrar as diferenças (patches) introduzidas por cada commit.
    - `git log --stat`: Mostrar estatísticas de arquivos modificados.
- Explique o conceito de SHA-1 como um identificador único para cada commit.
- Use a analogia de um "diário de bordo" para o `git log`, onde cada entrada é um commit detalhado.
**Diagrama Mermaid:** Crie um diagrama de sequência (Sequence Diagram) mostrando o fluxo de `git log` e suas opções, e como o usuário interage para obter diferentes visualizações.
**Aplicação no Projeto Prático:**
- Execute `git log` no projeto `barbershop-api`.
- Experimente as opções `git log --oneline`, `git log --graph --oneline --decorate`.
- Modifique o arquivo `server.js` (ex: adicione um novo `console.log`).
- Adicione a mudança à Staging Area e faça um novo commit (`git commit -m "feat: adiciona log de inicializacao"`).
- Use `git log -p -1` para ver o patch do último commit.
**Glossário Técnico:** Histórico de Commits, git log, SHA-1, --oneline, --graph, --decorate, -p, --stat.
**Antecipação de Erros:** Saída de `git log` muito longa, dificuldade em interpretar o SHA-1.
**Troubleshooting:** Como sair da visualização do `git log` (Q), como filtrar o histórico por autor ou data (breve menção).
**Desafio de Fixação:** Adicionar um novo endpoint `/status` à API que retorna `{"status": "ok"}`. Commitar essa mudança e usar `git log --stat` para ver as estatísticas do commit.
**Resumo dos Pontos-Chave:** Como navegar e interpretar o histórico de commits usando `git log` e suas opções.
**Log de Estado do Projeto:**
- Objetivo: Aprender a visualizar o histórico de commits de diversas formas.
- Código Adicionado: Novo endpoint `/status` na API.
- Estado Funcional: ✅ API com novo endpoint, histórico de commits explorado.
- Próximas Etapas: Aula 4 abordará como desfazer mudanças locais com `git restore` e `git reset`.
**Prompt de Continuidade:** "Dúvidas? Posso prosseguir para a próxima etapa?"
~~~

### Prompt para Aula 4: Desfazendo Mudanças Locais: Restore e Reset

~~~text
Gere a **Aula 4: Desfazendo Mudanças Locais: Restore e Reset**.
**Objetivo:** Desfazer alterações no **Working Directory** e **Staging Area** com **git restore** e voltar no tempo com **git reset**.
**Pré-requisitos:** Repositório Git com commits e alterações pendentes.
**Conteúdo Teórico:**
- Explique a importância de poder desfazer mudanças no Git, seja para corrigir erros ou abandonar alterações.
- Apresente o comando `git restore <arquivo>` para descartar mudanças no **Working Directory**.
- Explique `git restore --staged <arquivo>` para remover arquivos da **Staging Area** sem descartar as mudanças no **Working Directory**.
- Introduza o comando `git reset` e suas três variações principais:
    - `git reset --soft <commit>`: Move o HEAD, mas mantém as mudanças no **Staging Area** e **Working Directory**.
    - `git reset --mixed <commit>` (padrão): Move o HEAD e as mudanças vão para o **Working Directory**.
    - `git reset --hard <commit>`: Move o HEAD e descarta todas as mudanças no **Working Directory** e **Staging Area** (perigoso!).
- Use a analogia de um "controle de tempo" para explicar `git reset`: você pode voltar no tempo, mas com diferentes níveis de impacto nas suas ações futuras.
- Enfatize a cautela ao usar `git reset --hard`.
**Diagrama Mermaid:** Crie um diagrama de fluxo (Graph TD) mostrando os estados do Git e como `git restore`, `git restore --staged`, `git reset --soft`, `git reset --mixed` e `git reset --hard` afetam esses estados.
**Aplicação no Projeto Prático:**
- Modifique o arquivo `server.js` (ex: adicione um comentário).
- Use `git status` para ver a mudança.
- Use `git restore server.js` para descartar a mudança.
- Modifique `server.js` novamente e adicione-o à **Staging Area** com `git add server.js`.
- Use `git restore --staged server.js` para remover da **Staging Area**.
- Faça um novo commit na API (ex: `git commit -m "feat: adiciona rota de teste"`) e então use `git reset --soft HEAD~1` para desfazer o commit, mas manter as mudanças.
- Repita o processo com `git reset --mixed HEAD~1` e `git reset --hard HEAD~1` (com um commit de teste seguro).
**Glossário Técnico:** git restore, git reset, --soft, --mixed, --hard, HEAD, Desfazer Mudanças.
**Antecipação de Erros:** Perder trabalho com `git reset --hard`, confusão entre `restore` e `reset`.
**Troubleshooting:** Como recuperar um commit perdido (breve menção a `git reflog`).
**Desafio de Fixação:** Crie um novo arquivo `test.js`, adicione-o à Staging Area, e então use `git restore --staged test.js` para removê-lo. Em seguida, modifique `server.js`, mas descarte as mudanças usando `git restore server.js`.
**Resumo dos Pontos-Chave:** Comandos para desfazer mudanças no Working Directory, Staging Area e no histórico de commits.
**Log de Estado do Projeto:**
- Objetivo: Aprender a desfazer e reverter mudanças em diferentes estágios do repositório local.
- Código Adicionado: Nenhum código funcional novo, foco na manipulação do histórico.
- Estado Funcional: ✅ Repositório com histórico manipulado e compreendido.
- Próximas Etapas: Aula 5 abordará o uso do arquivo `.gitignore`.
**Prompt de Continuidade:** "Dúvidas? Posso prosseguir para a próxima etapa?"
~~~

### Prompt para Aula 5: Ignorando Arquivos: O .gitignore

~~~text
Gere a **Aula 5: Ignorando Arquivos: O .gitignore**.
**Objetivo:** Compreender e configurar o arquivo **.gitignore** para a API Node.js.
**Pré-requisitos:** Repositório Git com commits.
**Conteúdo Teórico:**
- Explique por que é necessário ignorar certos arquivos e pastas no Git (ex: arquivos gerados automaticamente, dependências, credenciais, logs).
- Apresente o arquivo `.gitignore` e como ele funciona (padrões de correspondência).
- Detalhe os padrões comuns para ignorar arquivos e pastas:
    - `node_modules/`: Ignorar a pasta de dependências do Node.js.
    - `*.log`: Ignorar todos os arquivos com extensão `.log`.
    - `.env`: Ignorar arquivos de variáveis de ambiente.
    - `dist/` ou `build/`: Ignorar pastas de build.
- Use a analogia de uma "lista de exclusão" para o `.gitignore`, onde você informa ao Git o que ele não deve se preocupar em rastrear.
- Explique a importância de commitar o `.gitignore` para que todos os colaboradores sigam as mesmas regras.
**Diagrama Mermaid:** Crie um diagrama de fluxo (Graph TD) mostrando o processo de desenvolvimento, onde alguns arquivos são rastreados pelo Git e outros são ignorados pelo `.gitignore`.
**Aplicação no Projeto Prático:**
- Crie um arquivo `.gitignore` na raiz do projeto `barbershop-api`.
- Adicione os padrões `node_modules/`, `npm-debug.log`, `.env` e `*.log` ao `.gitignore`.
- Crie um arquivo `test.log` e um arquivo `.env` (com conteúdo `PORT=3000`).
- Execute `git status` e observe que `node_modules/`, `test.log` e `.env` não são mais rastreados.
- Adicione o `.gitignore` à Staging Area e faça um commit (`git commit -m "chore: adiciona .gitignore"`).
**Glossário Técnico:** .gitignore, Arquivos Ignorados, Padrões de Correspondência, node_modules, .env.
**Antecipação de Erros:** Arquivos importantes sendo ignorados acidentalmente, arquivos já rastreados não sendo ignorados após adicionar ao `.gitignore`.
**Troubleshooting:** Como forçar o Git a ignorar um arquivo já rastreado (`git rm --cached`), como verificar se um arquivo está sendo ignorado (`git check-ignore`).
**Desafio de Fixação:** Adicione um novo padrão ao `.gitignore` para ignorar todos os arquivos com extensão `.tmp`. Crie um arquivo `temp.tmp` e verifique se ele é ignorado. Commite a mudança no `.gitignore`.
**Resumo dos Pontos-Chave:** A função e a sintaxe do `.gitignore`, e como aplicá-lo em um projeto Node.js.
**Log de Estado do Projeto:**
- Objetivo: Configurar o arquivo `.gitignore` para gerenciar arquivos não rastreados.
- Código Adicionado: Arquivo `.gitignore` com padrões para Node.js.
- Estado Funcional: ✅ Repositório Git configurado para ignorar arquivos desnecessários.
- Próximas Etapas: Aula 6 abordará repositórios remotos e a conexão com o GitHub.
**Prompt de Continuidade:** "Dúvidas? Posso prosseguir para a próxima etapa?"
~~~

## MÓDULO 2 — PROFICIENTE: Colaboração e Repositórios Remotos

### Prompt para Aula 6: Repositórios Remotos: Conectando-se ao GitHub

~~~text
Gere a **Aula 6: Repositórios Remotos: Conectando-se ao GitHub**.
**Objetivo:** Entender repositórios remotos, criar um no GitHub e conectar o repositório local com **git remote add** e **git push**.
**Pré-requisitos:** Repositório Git local configurado, conta no GitHub.
**Conteúdo Teórico:**
- Explique o conceito de repositório remoto e sua importância para colaboração, backup e acesso de diferentes locais.
- Apresente o GitHub como a plataforma mais popular para hospedar repositórios Git.
- Detalhe o processo de criação de um novo repositório no GitHub (sem inicializar com README ou .gitignore, pois já temos localmente).
- Explique o comando `git remote add <nome> <url>` para adicionar um repositório remoto ao seu projeto local. Use `origin` como nome padrão.
- Explique o comando `git push -u <nome_remoto> <nome_branch>` para enviar commits do repositório local para o remoto. Detalhe a flag `-u` para configurar o upstream.
- Use a analogia de um "cofre na nuvem" para o repositório remoto, onde você guarda uma cópia segura e compartilhável do seu projeto.
**Diagrama Mermaid:** Crie um diagrama de fluxo (Graph TD) mostrando a interação entre o repositório local e o repositório remoto (GitHub) usando `git remote add` e `git push`.
**Aplicação no Projeto Prático:**
- Crie um novo repositório vazio no GitHub chamado `barbershop-api`.
- Adicione o repositório remoto ao projeto local com `git remote add origin <URL_DO_REPOSITORIO>`.
- Verifique a conexão com `git remote -v`.
- Envie o branch `main` (ou `master`) para o GitHub com `git push -u origin main`.
- Verifique o conteúdo do repositório no GitHub.
**Glossário Técnico:** Repositório Remoto, GitHub, git remote add, git push, origin, main/master, upstream.
**Antecipação de Erros:** Erros de autenticação no GitHub, URL do repositório remoto incorreta, tentar dar push sem commits locais.
**Troubleshooting:** Como configurar credenciais Git para o GitHub (Git Credential Manager), como remover um remoto (`git remote rm`).
**Desafio de Fixação:** Adicione um novo comentário em `server.js`, faça um commit e então envie essa mudança para o GitHub. Verifique no GitHub se a mudança foi aplicada.
**Resumo dos Pontos-Chave:** Como conectar um repositório local a um remoto e enviar mudanças para ele.
**Log de Estado do Projeto:**
- Objetivo: Conectar o repositório local da API ao GitHub e realizar o primeiro push.
- Código Adicionado: Nenhum código funcional novo, foco na configuração do repositório remoto.
- Estado Funcional: ✅ Repositório local sincronizado com o GitHub.
- Próximas Etapas: Aula 7 abordará como clonar e sincronizar repositórios com `git clone` e `git pull`.
**Prompt de Continuidade:** "Dúvidas? Posso prosseguir para a próxima etapa?"
~~~

### Prompt para Aula 7: Clonando e Sincronizando: git clone e git pull

~~~text
Gere a **Aula 7: Clonando e Sincronizando: git clone e git pull**.
**Objetivo:** Clonar um repositório existente com **git clone** e obter as últimas mudanças do remoto com **git pull**.
**Pré-requisitos:** Repositório remoto no GitHub com o projeto `barbershop-api`.
**Conteúdo Teórico:**
- Explique o comando `git clone <url>` para criar uma cópia local completa de um repositório remoto. Detalhe que ele já configura o remoto `origin` e o branch `main/master`.
- Apresente o comando `git fetch` para baixar as últimas mudanças do repositório remoto, mas sem integrá-las ao seu **Working Directory**.
- Explique o comando `git pull` como uma combinação de `git fetch` e `git merge` (ou `git rebase`, dependendo da configuração).
- Use a analogia de "baixar um livro" para `git clone` (você pega uma cópia completa) e "atualizar seu livro" para `git pull` (você pega as últimas páginas adicionadas).
- Discuta a diferença entre `git fetch` e `git pull` e quando usar cada um.
**Diagrama Mermaid:** Crie um diagrama de fluxo (Graph TD) mostrando a interação entre o repositório remoto e um novo repositório local (clonado) usando `git clone`, e a atualização de um repositório local existente usando `git fetch` e `git pull`.
**Aplicação no Projeto Prático:**
- Crie uma nova pasta em outro local do seu sistema de arquivos (ex: `barbershop-api-clone`).
- Use `git clone <URL_DO_REPOSITORIO>` para clonar o projeto.
- Navegue para a pasta clonada e verifique o `git status` e `git log`.
- Volte para o repositório original (`barbershop-api`), faça uma pequena alteração em `server.js`, commite e dê `git push`.
- Volte para o repositório clonado (`barbershop-api-clone`) e use `git fetch` para ver as mudanças.
- Use `git pull` para integrar as mudanças no repositório clonado.
**Glossário Técnico:** git clone, git fetch, git pull, Repositório Clonado, Sincronização.
**Antecipação de Erros:** Tentar clonar um repositório privado sem autenticação, conflitos ao dar `git pull` (breve menção).
**Troubleshooting:** Como resolver problemas de autenticação ao clonar, como verificar a origem remota de um clone.
**Desafio de Fixação:** No repositório original, adicione um novo endpoint `/health` que retorna `{"status": "healthy"}`. Commite e dê `git push`. No repositório clonado, use `git pull` para obter essa mudança.
**Resumo dos Pontos-Chave:** Como obter uma cópia de um repositório remoto e como mantê-la atualizada.
**Log de Estado do Projeto:**
- Objetivo: Aprender a clonar repositórios e sincronizar mudanças com `git pull`.
- Código Adicionado: Novo endpoint `/health` na API.
- Estado Funcional: ✅ Repositórios local e clonado sincronizados.
- Próximas Etapas: Aula 8 abordará o conceito de branches para isolar o desenvolvimento.
**Prompt de Continuidade:** "Dúvidas? Posso prosseguir para a próxima etapa?"
~~~

### Prompt para Aula 8: Branches: Isolando o Desenvolvimento

~~~text
Gere a **Aula 8: Branches: Isolando o Desenvolvimento**.
**Objetivo:** Compreender branches, criar, listar e alternar entre elas com **git branch** e **git checkout**.
**Pré-requisitos:** Repositório Git local e remoto sincronizados.
**Conteúdo Teórico:**
- Explique o conceito de branches (ramificações) no Git como uma forma de isolar o desenvolvimento de novas funcionalidades ou correções de bugs sem afetar a linha principal de código.
- Use a analogia de "caminhos paralelos" para explicar branches, onde cada caminho permite desenvolver algo diferente sem interferir no caminho principal.
- Detalhe o comando `git branch` para listar branches existentes.
- Explique o comando `git branch <nome_da_branch>` para criar uma nova branch.
- Apresente o comando `git checkout <nome_da_branch>` para alternar entre branches.
- Explique `git checkout -b <nome_da_branch>` como um atalho para criar e alternar para uma nova branch.
- Discuta a importância de branches para o trabalho em equipe e para a organização do projeto.
**Diagrama Mermaid:** Crie um diagrama de fluxo (Graph TD) mostrando a branch `main` e a criação de uma nova branch a partir dela, com commits em ambas as branches.
**Aplicação no Projeto Prático:**
- No repositório `barbershop-api`, use `git branch` para ver as branches existentes.
- Crie uma nova branch para desenvolver uma funcionalidade de agendamento: `git branch feature/agendamento`.
- Alterne para a nova branch: `git checkout feature/agendamento`.
- Verifique a branch atual com `git branch`.
- Modifique `server.js` para adicionar um novo endpoint `/agendamentos` (que retorna um array vazio por enquanto).
- Faça um commit nessa nova branch: `git commit -m "feat: adiciona rota de agendamentos"`
- Alterne de volta para a branch `main` e observe que as mudanças não estão lá.
**Glossário Técnico:** Branch, git branch, git checkout, HEAD, main/master, feature branch.
**Antecipação de Erros:** Esquecer de alternar para a branch correta, fazer commits na branch errada.
**Troubleshooting:** Como ver o histórico de branches (`git log --all --decorate --oneline --graph`), como renomear uma branch (`git branch -m`).
**Desafio de Fixação:** Crie uma nova branch chamada `bugfix/erro-login` (mesmo que não tenhamos login ainda), adicione um comentário em `server.js` simulando uma correção, commite e então volte para a branch `main`.
**Resumo dos Pontos-Chave:** O que são branches, como criá-las, listá-las e alternar entre elas.
**Log de Estado do Projeto:**
- Objetivo: Entender e utilizar branches para isolar o desenvolvimento de funcionalidades.
- Código Adicionado: Novo endpoint `/agendamentos` na branch `feature/agendamento`.
- Estado Funcional: ✅ Repositório com múltiplas branches, desenvolvimento isolado.
- Próximas Etapas: Aula 9 abordará como integrar mudanças de branches com `git merge`.
**Prompt de Continuidade:** "Dúvidas? Posso prosseguir para a próxima etapa?"
~~~

### Prompt para Aula 9: Integrando Mudanças: git merge

~~~text
Gere a **Aula 9: Integrando Mudanças: git merge**.
**Objetivo:** Integrar mudanças de uma branch para outra com **git merge** e resolver conflitos básicos.
**Pré-requisitos:** Repositório Git com múltiplas branches e commits em branches diferentes.
**Conteúdo Teórico:**
- Explique o comando `git merge <nome_da_branch>` para combinar o histórico de uma branch em outra.
- Detalhe o processo de **Fast-Forward Merge** (quando não há commits na branch de destino desde a criação da branch de origem).
- Explique o que são **conflitos de merge** e como eles surgem (quando as mesmas linhas de código são alteradas em branches diferentes).
- Mostre como o Git indica os conflitos no arquivo e como resolvê-los manualmente (removendo os marcadores `<<<<<<<`, `=======`, `>>>>>>>`).
- Explique o processo de commitar a resolução do conflito.
- Use a analogia de "reunir caminhos" para `git merge`, onde você junta as diferentes linhas de desenvolvimento de volta em uma só.
**Diagrama Mermaid:** Crie um diagrama de fluxo (Graph TD) mostrando a branch `main` e uma `feature/agendamento` sendo mesclada de volta na `main`, ilustrando tanto um Fast-Forward Merge quanto um Merge Commit (com conflito).
**Aplicação no Projeto Prático:**
- Certifique-se de estar na branch `main`.
- Mescle a branch `feature/agendamento` na `main`: `git merge feature/agendamento`.
- Verifique se o endpoint `/agendamentos` está agora na branch `main`.
- Crie uma nova branch `feature/clientes` e adicione um endpoint `/clientes` em `server.js`. Commite.
- Volte para `main`, faça uma pequena alteração na mesma linha de `server.js` que você alterou na `feature/clientes` (ex: mude a porta da API). Commite.
- Tente mesclar `feature/clientes` na `main` e observe o conflito.
- Resolva o conflito manualmente no `server.js`, adicione o arquivo à Staging Area e faça um commit de merge.
**Glossário Técnico:** git merge, Fast-Forward Merge, Conflito de Merge, Merge Commit, Marcadores de Conflito.
**Antecipação de Erros:** Conflitos de merge inesperados, dificuldade em resolver conflitos.
**Troubleshooting:** Como abortar um merge (`git merge --abort`), como usar ferramentas de merge externas.
**Desafio de Fixação:** Crie uma nova branch `feature/servicos`, adicione um endpoint `/servicos` em `server.js`. Commite. Volte para `main`, adicione um comentário em `server.js` em uma linha diferente. Commite. Mescle `feature/servicos` na `main` (não deve haver conflito).
**Resumo dos Pontos-Chave:** Como integrar mudanças entre branches e como resolver conflitos de merge.
**Log de Estado do Projeto:**
- Objetivo: Aprender a mesclar branches e resolver conflitos de merge.
- Código Adicionado: Endpoints `/agendamentos` e `/clientes` (após resolução de conflito) na API.
- Estado Funcional: ✅ API com novas funcionalidades integradas, histórico de merges compreendido.
- Próximas Etapas: Aula 10 abordará um fluxo de trabalho básico com branches.
**Prompt de Continuidade:** "Dúvidas? Posso prosseguir para a próxima etapa?"
~~~

### Prompt para Aula 10: Fluxo de Trabalho Básico: Feature Branch Workflow

~~~text
Gere a **Aula 10: Fluxo de Trabalho Básico: Feature Branch Workflow**.
**Objetivo:** Implementar um fluxo de trabalho simples com branches de feature na API de Barbearias.
**Pré-requisitos:** Conhecimento de branches e merge.
**Conteúdo Teórico:**
- Explique o conceito de **Feature Branch Workflow** como um dos fluxos de trabalho mais comuns no Git para equipes.
- Detalhe os passos desse fluxo:
    1.  Manter a branch `main` sempre estável e pronta para produção.
    2.  Criar uma nova branch de feature para cada nova funcionalidade ou correção de bug.
    3.  Desenvolver e commitar na branch de feature.
    4.  Manter a branch de feature atualizada com a `main` (usando `git pull` ou `git rebase` - breve menção ao rebase).
    5.  Mesclar a branch de feature de volta na `main` após a conclusão e revisão.
    6.  Excluir a branch de feature (local e remota).
- Use a analogia de uma "linha de montagem" para o Feature Branch Workflow, onde cada estação (branch) trabalha em uma parte específica antes de integrar ao produto final.
- Discuta a importância de manter a `main` limpa e testada.
**Diagrama Mermaid:** Crie um diagrama de fluxo (Graph TD) ilustrando o Feature Branch Workflow completo, desde a criação da branch até o merge e exclusão.
**Aplicação no Projeto Prático:**
- Crie uma nova branch `feature/autenticacao` para implementar um sistema de autenticação básico.
- Alterne para essa branch.
- Adicione um novo endpoint `/login` em `server.js` (apenas um `console.log` por enquanto).
- Faça um commit na branch `feature/autenticacao`.
- Volte para `main`, faça um `git pull` para garantir que está atualizada.
- Mescle `feature/autenticacao` na `main`: `git merge feature/autenticacao`.
- Exclua a branch `feature/autenticacao` localmente: `git branch -d feature/autenticacao`.
- Envie as mudanças para o GitHub: `git push origin main`.
**Glossário Técnico:** Feature Branch Workflow, Branch de Feature, git branch -d, Fluxo de Trabalho.
**Antecipação de Erros:** Esquecer de excluir branches antigas, fazer commits diretamente na `main`.
**Troubleshooting:** Como forçar a exclusão de uma branch (`git branch -D`), como excluir uma branch remota (`git push origin --delete <branch>`).
**Desafio de Fixação:** Implemente uma nova funcionalidade "cadastro de usuário" usando o Feature Branch Workflow. Crie uma branch `feature/cadastro-usuario`, adicione um endpoint `/cadastro` em `server.js`, commite, mescle na `main` e exclua a branch.
**Resumo dos Pontos-Chave:** Os passos do Feature Branch Workflow e sua aplicação prática para organizar o desenvolvimento.
**Log de Estado do Projeto:**
- Objetivo: Aplicar o Feature Branch Workflow para desenvolver e integrar novas funcionalidades na API.
- Código Adicionado: Endpoints `/login` e `/cadastro` na API.
- Estado Funcional: ✅ API com novas funcionalidades integradas via Feature Branch Workflow.
- Próximas Etapas: Aula 11 abordará a reorganização do histórico com `git rebase`.
**Prompt de Continuidade:** "Dúvidas? Posso prosseguir para a próxima etapa?"
~~~

## MÓDULO 3 — AVANÇADO: Gerenciamento de Histórico e Boas Práticas

### Prompt para Aula 11: Reorganizando o Histórico: git rebase

~~~text
Gere a **Aula 11: Reorganizando o Histórico: git rebase**.
**Objetivo:** Entender e usar **git rebase** para um histórico de commits mais limpo.
**Pré-requisitos:** Conhecimento de branches e merge.
**Conteúdo Teórico:**
- Explique o que é `git rebase` e sua principal função: reescrever o histórico de commits para criar uma linha de desenvolvimento mais linear e limpa.
- Compare `git rebase` com `git merge`, destacando que `rebase` move a base de uma branch para o topo de outra, enquanto `merge` cria um novo commit de merge.
- Use a analogia de "reorganizar um diário" para `git rebase`, onde você pode editar, combinar ou reordenar entradas para que a história faça mais sentido.
- Detalhe os casos de uso comuns para `git rebase`:
    - Manter uma branch de feature atualizada com a `main` antes de um merge.
    - Limpar o histórico de uma branch antes de um Pull Request (squash de commits).
- **Alerta:** Enfatize a regra de ouro: **nunca faça rebase em commits que já foram enviados para um repositório remoto e compartilhados com outros**.
**Diagrama Mermaid:** Crie um diagrama de fluxo (Graph TD) mostrando a diferença visual entre `git merge` e `git rebase` ao integrar uma branch de feature na `main`.
**Aplicação no Projeto Prático:**
- Crie uma nova branch `feature/notificacoes`.
- Alterne para essa branch.
- Faça dois commits pequenos em `server.js` (ex: um para adicionar um `console.log` de notificação, outro para adicionar um endpoint `/notificacoes`).
- Volte para `main`, faça uma pequena alteração e commite (simulando que a `main` avançou).
- Volte para `feature/notificacoes`.
- Use `git rebase main` para mover a base da `feature/notificacoes` para o topo da `main`.
- Resolva quaisquer conflitos que possam surgir durante o rebase.
- Verifique o histórico com `git log --oneline --graph` para ver a linha linear.
- Mescle `feature/notificacoes` na `main` (deve ser um Fast-Forward Merge).
**Glossário Técnico:** git rebase, Reescrita de Histórico, Squash, Linearização, Fast-Forward Merge, Conflito de Rebase.
**Antecipação de Erros:** Conflitos complexos durante o rebase, rebase em commits públicos.
**Troubleshooting:** Como abortar um rebase (`git rebase --abort`), como continuar um rebase (`git rebase --continue`).
**Desafio de Fixação:** Crie uma branch `feature/relatorios`. Faça 3 commits pequenos nela. Em seguida, use `git rebase -i HEAD~3` para "squashar" (combinar) esses 3 commits em um único commit.
**Resumo dos Pontos-Chave:** O que é `git rebase`, como ele difere de `git merge`, e como usá-lo para um histórico limpo (com a devida cautela).
**Log de Estado do Projeto:**
- Objetivo: Aprender a usar `git rebase` para reorganizar e limpar o histórico de commits.
- Código Adicionado: Endpoint `/notificacoes` na API.
- Estado Funcional: ✅ API com histórico de commits linearizado, `git rebase` compreendido.
- Próximas Etapas: Aula 12 abordará o gerenciamento de tags e versões.
**Prompt de Continuidade:** "Dúvidas? Posso prosseguir para a próxima etapa?"
~~~

### Prompt para Aula 12: Gerenciando Tags e Versões

~~~text
Gere a **Aula 12: Gerenciando Tags e Versões**.
**Objetivo:** Criar e gerenciar tags leves e anotadas com **git tag** para marcar versões.
**Pré-requisitos:** Repositório Git com histórico de commits.
**Conteúdo Teórico:**
- Explique o conceito de **tags** no Git como "marcadores" para pontos específicos no histórico de commits, geralmente usados para marcar versões de lançamento (ex: v1.0, v2.0-beta).
- Use a analogia de "marcar um capítulo importante" em um livro para explicar tags, onde cada tag representa um marco significativo no desenvolvimento do projeto.
- Detalhe os dois tipos de tags:
    - **Tags Leves (Lightweight Tags):** Um ponteiro simples para um commit, como um branch que nunca se move. Criadas com `git tag <nome_da_tag>`.
    - **Tags Anotadas (Annotated Tags):** Objetos completos no banco de dados do Git, contendo o nome do tagueador, e-mail, data e uma mensagem de tagueamento. Criadas com `git tag -a <nome_da_tag> -m "mensagem"`.
- Explique o comando `git tag` para listar tags.
- Explique como visualizar detalhes de uma tag com `git show <nome_da_tag>`.
- Aborde como publicar tags em repositórios remotos com `git push origin <nome_da_tag>` ou `git push origin --tags`.
**Diagrama Mermaid:** Crie um diagrama de fluxo (Graph TD) mostrando a branch `main` com vários commits e a aplicação de tags leves e anotadas em commits específicos.
**Aplicação no Projeto Prático:**
- Certifique-se de estar na branch `main`.
- Crie uma tag leve para o estado atual da API: `git tag v0.1.0-alpha`.
- Crie uma tag anotada para um commit anterior (use `git log --oneline` para pegar um SHA-1): `git tag -a v0.0.1-initial -m "Versão inicial da API" <SHA-1_DO_COMMIT>`.
- Liste as tags com `git tag`.
- Visualize os detalhes da tag anotada com `git show v0.0.1-initial`.
- Envie as tags para o GitHub: `git push origin --tags`.
**Glossário Técnico:** Tag, Lightweight Tag, Annotated Tag, git tag, git show, git push --tags, Versão.
**Antecipação de Erros:** Esquecer de enviar tags para o remoto, criar tags com nomes inconsistentes.
**Troubleshooting:** Como excluir tags locais (`git tag -d`) e remotas (`git push origin --delete tag <nome_da_tag>`).
**Desafio de Fixação:** Adicione um novo endpoint `/versao` que retorna a versão atual da API (ex: "v0.1.0"). Commite essa mudança. Em seguida, crie uma tag anotada `v0.1.0` para este commit e envie-a para o GitHub.
**Resumo dos Pontos-Chave:** A importância das tags, como criar e gerenciar tags leves e anotadas, e como publicá-las.
**Log de Estado do Projeto:**
- Objetivo: Aprender a usar tags para marcar versões e pontos importantes no histórico do projeto.
- Código Adicionado: Novo endpoint `/versao` na API.
- Estado Funcional: ✅ API com tags de versão, tags publicadas no GitHub.
- Próximas Etapas: Aula 13 abordará o uso de `git stash` para salvar mudanças temporariamente.
**Prompt de Continuidade:** "Dúvidas? Posso prosseguir para a próxima etapa?"
~~~

### Prompt para Aula 13: Stash: Salvando Mudanças Temporariamente

~~~text
Gere a **Aula 13: Stash: Salvando Mudanças Temporariamente**.
**Objetivo:** Utilizar **git stash** para guardar mudanças não commitadas e aplicá-las posteriormente.
**Pré-requisitos:** Repositório Git com alterações pendentes.
**Conteúdo Teórico:**
- Explique o cenário em que `git stash` é útil: quando você está trabalhando em algo, mas precisa mudar de branch ou lidar com uma tarefa urgente sem commitar o trabalho incompleto.
- Use a analogia de uma "gaveta de rascunhos" para `git stash`, onde você pode guardar seu trabalho temporariamente e pegá-lo de volta quando precisar.
- Detalhe o comando `git stash` (ou `git stash push`) para salvar as mudanças do **Working Directory** e **Staging Area**.
- Explique `git stash list` para ver a lista de stashes salvos.
- Apresente `git stash apply` para aplicar o stash mais recente (mantendo-o na lista).
- Explique `git stash pop` para aplicar o stash mais recente e removê-lo da lista.
- Aborde `git stash drop <stash_id>` para remover um stash específico.
- Mencione `git stash clear` para remover todos os stashes.
**Diagrama Mermaid:** Crie um diagrama de sequência (Sequence Diagram) mostrando o fluxo de trabalho com `git stash`: fazer mudanças, salvar stash, mudar de branch, voltar, aplicar stash.
**Aplicação no Projeto Prático:**
- Na branch `main`, faça algumas alterações em `server.js` (ex: adicione um novo `console.log` ou um comentário). Não commite.
- Use `git status` para ver as mudanças.
- Use `git stash` para salvar essas mudanças.
- Alterne para uma nova branch `bugfix/urgente`.
- Faça uma pequena alteração e um commit nessa branch.
- Volte para a branch `main`.
- Use `git stash list` para ver o stash salvo.
- Use `git stash pop` para aplicar as mudanças salvas.
- Resolva quaisquer conflitos que possam surgir ao aplicar o stash.
**Glossário Técnico:** git stash, Stash, git stash list, git stash apply, git stash pop, git stash drop, git stash clear.
**Antecipação de Erros:** Conflitos ao aplicar o stash, esquecer de aplicar o stash e perder trabalho.
**Troubleshooting:** Como resolver conflitos de stash, como inspecionar o conteúdo de um stash (`git stash show`).
**Desafio de Fixação:** Faça algumas alterações em `server.js` e adicione-as à Staging Area. Em seguida, use `git stash push -m "mudancas na rota principal"` para salvar o stash com uma mensagem. Alterne para outra branch, faça um commit, volte para `main` e aplique o stash.
**Resumo dos Pontos-Chave:** Como usar `git stash` para gerenciar mudanças temporárias e manter o fluxo de trabalho organizado.
**Log de Estado do Projeto:**
- Objetivo: Aprender a usar `git stash` para salvar e restaurar mudanças temporariamente.
- Código Adicionado: Nenhum código funcional novo, foco na manipulação de estado.
- Estado Funcional: ✅ Repositório com uso de `git stash` compreendido.
- Próximas Etapas: Aula 14 abordará boas práticas e convenções de commits.
**Prompt de Continuidade:** "Dúvidas? Posso prosseguir para a próxima etapa?"
~~~

### Prompt para Aula 14: Boas Práticas e Convenções de Commits

~~~text
Gere a **Aula 14: Boas Práticas e Convenções de Commits**.
**Objetivo:** Compreender a importância de mensagens de commit claras e seguir convenções de commits.
**Pré-requisitos:** Conhecimento de commits e histórico.
**Conteúdo Teórico:**
- Explique a importância de mensagens de commit claras, concisas e descritivas para a manutenção do projeto, revisão de código e entendimento do histórico.
- Use a analogia de "etiquetas de arquivo" para mensagens de commit, onde cada etiqueta deve descrever o conteúdo do arquivo de forma útil.
- Apresente as **boas práticas para mensagens de commit**:
    - Primeira linha concisa (até 50-72 caracteres), descrevendo o "o quê".
    - Linha em branco.
    - Corpo detalhado, explicando o "porquê" e "como".
    - Usar o imperativo ("Adiciona", "Corrige", "Remove").
- Introduza as **Convenções de Commits (Conventional Commits)** como um padrão para estruturar mensagens de commit, facilitando a automação e a leitura.
    - Formato: `<tipo>(<escopo>): <descrição>`
    - Tipos comuns: `feat` (nova funcionalidade), `fix` (correção de bug), `docs` (documentação), `chore` (tarefas de manutenção), `refactor` (refatoração), `style` (formatação), `test` (testes).
    - Escopo (opcional): Onde a mudança ocorreu (ex: `api`, `auth`, `agendamento`).
- Discuta os benefícios de seguir convenções: histórico legível, geração automática de changelogs, melhor comunicação em equipe.
**Diagrama Mermaid:** Crie um diagrama de fluxo (Graph TD) mostrando o processo de criação de um commit, desde a alteração do código até a mensagem de commit bem estruturada e seguindo convenções.
**Aplicação no Projeto Prático:**
- Revise os commits anteriores do projeto `barbershop-api` usando `git log --oneline`.
- Crie uma nova branch `refactor/rotas`.
- Alterne para essa branch.
- Refatore o arquivo `server.js` (ex: organize as rotas em um arquivo separado, ou apenas reorganize a ordem dos endpoints).
- Faça um commit usando uma mensagem que siga as Convenções de Commits: `refactor(rotas): organiza endpoints em server.js`.
- Mescle essa branch na `main` e exclua-a.
- Faça um novo commit na `main` para adicionar um comentário em `server.js` e use o tipo `docs`: `docs: adiciona comentario sobre inicializacao da api`.
**Glossário Técnico:** Mensagem de Commit, Boas Práticas de Commit, Conventional Commits, feat, fix, docs, chore, refactor, style, test.
**Antecipação de Erros:** Mensagens de commit vagas, não seguir as convenções em equipe.
**Troubleshooting:** Como alterar a última mensagem de commit (`git commit --amend`), como reescrever mensagens de commits anteriores (breve menção a `git rebase -i`).
**Desafio de Fixação:** Crie uma nova branch `test:adiciona-testes-status`. Adicione um `console.log` em `server.js` que simula um teste para o endpoint `/status`. Commite com a mensagem `test(status): adiciona log de teste para endpoint /status`. Mescle na `main` e exclua a branch.
**Resumo dos Pontos-Chave:** A importância de mensagens de commit claras e o uso de Convenções de Commits para um histórico de projeto organizado.
**Log de Estado do Projeto:**
- Objetivo: Aplicar boas práticas e convenções de commits para manter um histórico limpo e legível.
- Código Adicionado: Refatoração de rotas e adição de logs de teste na API.
- Estado Funcional: ✅ API com histórico de commits seguindo boas práticas.
- Próximas Etapas: Aula 15 abordará o uso de `git cherry-pick` para aplicar commits específicos.
**Prompt de Continuidade:** "Dúvidas? Posso prosseguir para a próxima etapa?"
~~~

### Prompt para Aula 15: Aplicando Commits Específicos: git cherry-pick

~~~text
Gere a **Aula 15: Aplicando Commits Específicos: git cherry-pick**.
**Objetivo:** Entender e usar **git cherry-pick** para aplicar commits específicos de uma branch em outra.
**Pré-requisitos:** Conhecimento de branches e commits.
**Conteúdo Teórico:**
- Explique o comando `git cherry-pick <SHA-1_DO_COMMIT>` e seu propósito: aplicar um commit específico de uma branch em outra, sem mesclar todo o histórico da branch de origem.
- Use a analogia de "selecionar uma cereja" para `git cherry-pick`, onde você escolhe um commit específico (a cereja) para levar para outro lugar, sem pegar o resto da árvore.
- Detalhe os cenários de uso para `git cherry-pick`:
    - Aplicar uma correção urgente de bug de uma branch de desenvolvimento para a branch de produção.
    - Trazer uma funcionalidade pequena de uma branch de feature para outra, sem mesclar a branch inteira.
    - Evitar um merge completo que traria commits indesejados.
- Explique que `cherry-pick` cria um novo commit com as mesmas mudanças, mas com um novo SHA-1.
- Aborde a possibilidade de conflitos durante o `cherry-pick` e como resolvê-los (similar aos conflitos de merge).
**Diagrama Mermaid:** Crie um diagrama de fluxo (Graph TD) mostrando duas branches (ex: `main` e `feature/bugfix`) e um commit específico sendo "cherry-picked" da `feature/bugfix` para a `main`.
**Aplicação no Projeto Prático:**
- Crie uma nova branch `feature/bugfix-login`.
- Alterne para essa branch.
- Faça um commit que simule uma correção de bug no endpoint `/login` (ex: adicione um `console.log` indicando "Bug de login corrigido").
- Volte para a branch `main`.
- Identifique o SHA-1 do commit de correção na branch `feature/bugfix-login` usando `git log --oneline feature/bugfix-login`.
- Use `git cherry-pick <SHA-1_DO_COMMIT>` para aplicar o commit na `main`.
- Verifique o histórico da `main` com `git log --oneline`.
- Crie uma nova branch `feature/nova-funcionalidade`.
- Faça um commit nessa branch (ex: "feat: adiciona nova funcionalidade X").
- Volte para `main` e use `git cherry-pick` para trazer apenas esse commit para a `main` (simulando uma funcionalidade que precisa ir para produção antes do resto da branch).
**Glossário Técnico:** git cherry-pick, Commit Específico, SHA-1, Conflito de Cherry-pick.
**Antecipação de Erros:** Conflitos ao aplicar o commit, aplicar o commit errado.
**Troubleshooting:** Como abortar um `cherry-pick` (`git cherry-pick --abort`), como resolver conflitos.
**Desafio de Fixação:** Crie uma branch `feature/hotfix-api`. Faça um commit nessa branch que simule uma correção crítica em `server.js` (ex: `fix: corrige erro de porta`). Volte para `main` e use `git cherry-pick` para aplicar essa correção na `main`.
**Resumo dos Pontos-Chave:** O que é `git cherry-pick`, quando usá-lo e como aplicar commits específicos entre branches.
**Log de Estado do Projeto:**
- Objetivo: Aprender a usar `git cherry-pick` para aplicar commits específicos.
- Código Adicionado: Correções e funcionalidades aplicadas via `cherry-pick` na API.
- Estado Funcional: ✅ API com commits específicos aplicados, `git cherry-pick` compreendido.
- Próximas Etapas: Aula 16 será a revisão final e apresentação dos próximos passos.
**Prompt de Continuidade:** "Dúvidas? Posso prosseguir para a próxima etapa?"
~~~

### Prompt para Aula 16: Revisão e Próximos Passos

~~~text
Gere a **Aula 16: Revisão e Próximos Passos**.
**Objetivo:** Revisar os principais conceitos e comandos aprendidos, com desafios e recursos adicionais.
**Pré-requisitos:** Todas as aulas anteriores concluídas.
**Conteúdo Teórico:**
- Faça um resumo abrangente de todos os conceitos e comandos aprendidos ao longo do curso, desde a instalação do Git até as boas práticas de commits e o `cherry-pick`.
- Relembre os três estados do Git (**Working Directory**, **Staging Area**, **Local Repository**).
- Reforce a importância de branches para o desenvolvimento isolado e colaborativo.
- Discuta a diferença entre `git merge` e `git rebase` e quando usar cada um.
- Reitere a importância do `.gitignore`, das boas práticas de commits e a utilidade do `git stash` e `git cherry-pick`.
- Use a analogia de um "mapa do tesouro" para o Git, onde você aprendeu a ler o mapa, navegar por diferentes caminhos, registrar suas descobertas e até mesmo transportar "tesouros" específicos entre eles.
- Apresente recursos adicionais para aprofundamento (documentação oficial, livros, comunidades).
**Diagrama Mermaid:** Crie um diagrama de fluxo (Graph TD) que seja um resumo visual de todo o fluxo de trabalho do Git aprendido, conectando os principais comandos e conceitos.
**Aplicação no Projeto Prático:**
- Proponha um desafio final integrado:
    - Crie uma nova branch `feature/integracao-pagamento`.
    - Simule a adição de um novo endpoint `/pagamento` em `server.js`.
    - Faça dois commits pequenos nessa branch (ex: "feat: adiciona rota pagamento" e "chore: configura variaveis de ambiente para pagamento").
    - Volte para `main`, faça uma pequena correção em `server.js` (ex: corrija um typo em um comentário) e commite.
    - Volte para `feature/integracao-pagamento`, use `git rebase main` para atualizar a branch.
    - Resolva qualquer conflito.
    - Mescle `feature/integracao-pagamento` na `main`.
    - Crie uma tag anotada `v1.0.0-final` para o último commit na `main`.
    - Envie todas as mudanças e a tag para o GitHub.
- Instruções para o aluno verificar o histórico completo no GitHub e no repositório local.
**Glossário Técnico:** Revisão de todos os termos-chave do curso.
**Antecipação de Erros:** Revisão dos erros mais comuns e suas soluções.
**Troubleshooting:** Revisão das principais técnicas de depuração e resolução de problemas no Git.
**Desafio de Fixação:** O desafio integrado acima.
**Resumo dos Pontos-Chave:** Todos os conceitos e comandos essenciais do Git.
**Log de Estado do Projeto:**
- Objetivo: Consolidar todo o conhecimento adquirido e aplicar em um desafio final.
- Código Adicionado: Endpoint `/pagamento` na API.
- Estado Funcional: ✅ API com todas as funcionalidades básicas integradas, repositório Git completo e tag de versão final.
- Próximas Etapas: Sugestões para continuar aprendendo Git (Pull Requests, GitFlow, GitHub Actions, etc.).
**Prompt de Continuidade:** "Dúvidas? Posso prosseguir para a próxima etapa?"
~~~

