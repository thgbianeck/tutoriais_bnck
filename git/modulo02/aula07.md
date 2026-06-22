# Aula 7: Branches: O Poder do Desenvolvimento Paralelo

## Resumo da Aula Anterior
Na Aula 6, demos um passo crucial na jornada do Git ao conectar nosso repositório local à plataforma GitHub. Aprendemos o conceito de **repositórios remotos**, criamos um repositório vazio no GitHub, adicionamos esse remoto ao nosso projeto local e utilizamos os comandos `git push` para enviar nossas mudanças e `git pull` para buscar e mesclar alterações do servidor. Agora, nosso projeto `barbershop-api` está seguro na nuvem e pronto para a colaboração.

## Objetivo
Compreender o que são **branches** no Git, a importância do desenvolvimento paralelo, como criar, listar, alternar e excluir branches, e aprofundar na filosofia de trabalho com branches para isolar funcionalidades e correções.

## Pré-requisitos
Repositório Git local conectado a um remoto (conforme Aula 6).

## Análise de Integridade
✅ Conteúdo verificado: profundidade técnica mantida, linguagem acessível, código funcional.

## Teoria Detalhada (Narrativa Densa)

Até agora, todo o nosso trabalho com o Git foi realizado em uma única linha de desenvolvimento, a branch `main` (ou `master` em repositórios mais antigos). No entanto, em projetos reais, especialmente em grandes aplicações com equipes de desenvolvimento, é raro que o trabalho progrida de forma linear. Novas funcionalidades precisam ser desenvolvidas, bugs precisam ser corrigidos, e experimentos precisam ser testados, muitas vezes simultaneamente, sem interferir na versão estável do código. É aqui que o conceito de **branches** (ramificações) se torna não apenas útil, mas essencial.

Uma **branch** no Git é, em sua essência, um ponteiro leve e móvel para um commit. Quando você cria uma branch, você está criando um novo caminho independente de desenvolvimento. Pense nisso como tirar uma cópia do seu projeto em um determinado ponto no tempo, onde você pode fazer alterações sem afetar a linha principal de código. Cada branch representa uma linha de trabalho separada, permitindo que você e sua equipe desenvolvam funcionalidades, corrijam bugs ou experimentem novas ideias em isolamento.

A analogia mais comum e eficaz para entender branches é a de uma **árvore com seus galhos**. A branch `main` (ou `master`) é o tronco principal da árvore, representando a versão estável e funcional do seu projeto. Quando você precisa desenvolver uma nova funcionalidade, você "cria um novo galho" a partir do tronco. Neste novo galho (branch), você pode trabalhar livremente, adicionar novos commits, e até mesmo cometer erros, sem que isso afete o tronco principal. Uma vez que a funcionalidade esteja completa e testada, você pode "mesclar" (integrar) esse galho de volta ao tronco, trazendo todas as suas mudanças para a linha principal do projeto.

### Por que usar Branches?

1.  **Isolamento:** Permite que você trabalhe em uma funcionalidade ou correção sem afetar a estabilidade da branch principal.
2.  **Colaboração:** Múltiplos desenvolvedores podem trabalhar em diferentes funcionalidades simultaneamente, cada um em sua própria branch.
3.  **Experimentação:** Facilita a experimentação com novas ideias ou abordagens, sem o risco de comprometer o código principal. Se a ideia não funcionar, basta descartar a branch.
4.  **Revisão de Código:** Branches são a base para processos de revisão de código (Pull Requests/Merge Requests), onde as mudanças são revisadas por outros membros da equipe antes de serem integradas à branch principal.

### O `HEAD` e o Ponteiro da Branch

No Git, o `HEAD` é um ponteiro especial que indica qual commit você está atualmente "olhando" ou trabalhando. Quando você alterna entre branches, o `HEAD` se move para apontar para o último commit daquela branch. O nome da branch que você está atualmente é a branch "ativa".

### Comandos Essenciais para Branches

1.  **`git branch`**:
    *   `git branch`: Lista todas as branches locais no seu repositório. A branch atual será destacada (geralmente com um asterisco `*`).
    *   `git branch <nome-da-branch>`: Cria uma nova branch com o nome especificado, apontando para o mesmo commit que a branch atual. **Importante:** Este comando apenas cria a branch, mas não alterna para ela.
    *   `git branch -d <nome-da-branch>`: Exclui a branch local especificada. Só é possível excluir uma branch se você não estiver nela e se ela já tiver sido mesclada em outra branch.
    *   `git branch -D <nome-da-branch>`: Força a exclusão da branch, mesmo que ela não tenha sido mesclada. Use com cautela, pois você pode perder commits.

2.  **`git switch` (Recomendado a partir do Git 2.23) ou `git checkout` (Legado):**
    *   `git switch <nome-da-branch>`: Alterna para a branch especificada. Isso muda o seu **Working Directory** para refletir o estado dos arquivos daquela branch.
    *   `git switch -c <nome-da-branch>`: Cria uma nova branch E alterna para ela em uma única operação. É um atalho muito útil.
    *   `git checkout <nome-da-branch>`: Faz a mesma coisa que `git switch <nome-da-branch>`.
    *   `git checkout -b <nome-da-branch>`: Faz a mesma coisa que `git switch -c <nome-da-branch>`.

    **Nota:** Embora `git checkout` ainda funcione, o Git introduziu `git switch` e `git restore` para separar as responsabilidades de alternar branches/restaurar arquivos, tornando os comandos mais claros e menos ambíguos. Recomenda-se usar `git switch` para alternar branches.

### Fluxo de Trabalho Básico com Branches

1.  **Comece na `main`:** Certifique-se de que sua branch `main` esteja atualizada com o repositório remoto (`git pull origin main`).
2.  **Crie uma nova branch:** Para cada nova funcionalidade ou correção de bug, crie uma branch específica a partir da `main`. Ex: `git switch -c feature/nova-funcionalidade` ou `git switch -c bugfix/corrigir-erro-x`.
3.  **Desenvolva e commite:** Trabalhe na sua nova branch, fazendo commits regulares que descrevam suas mudanças.
4.  **Mescle de volta:** Quando a funcionalidade estiver completa e testada, mescle sua branch de volta para a `main` (veremos isso na próxima aula).
5.  **Exclua a branch:** Após a mesclagem, a branch de funcionalidade geralmente pode ser excluída.

## Diagrama Mermaid
~~~mermaid
graph TD
    A[main] --> B{git switch -c feature/login};
    B --> C[feature/login];
    C --> D[Desenvolvimento do Login];
    D --> E["Commit 1 (feat: rota login)"];
    E --> F["Commit 2 (feat: validação login)"];
    F --> G[git switch main];
    G --> H["main (sem mudanças do login)"];
    H --> I{git merge feature/login};
    I --> J["main (com login integrado)"];
    J --> K[git branch -d feature/login];
~~~

## Aplicação no Projeto Prático

Nosso projeto `barbershop-api` já possui a rota `/agendamentos` na branch `main`. Agora, vamos desenvolver uma nova funcionalidade de autenticação em uma branch separada.

1.  **Verifique a branch atual:**
    ~~~bash
    git branch
    ~~~
    Você deve estar na branch `main`.

2.  **Crie uma nova branch para a funcionalidade de autenticação e alterne para ela:**
    ~~~bash
    git switch -c feature/autenticacao
    ~~~
    Agora, `git branch` deve mostrar `* feature/autenticacao`.

3.  **Adicione um novo endpoint para login no `server.js`:**
    Abra o arquivo `server.js` no VS Code. Abaixo da rota `/status`, adicione o seguinte código:
    ~~~javascript
    // Rota para autenticação (login)
    app.post('/login', (req, res) => {
      // Lógica de autenticação virá aqui. Por enquanto, apenas um placeholder.
      res.status(200).json({ message: 'Endpoint de login (em construção)' });
    });
    ~~~

4.  **Adicione e commite essa mudança na branch `feature/autenticacao`:**
    ~~~bash
    git add server.js
    git commit -m "feat: adiciona rota inicial para login"
    ~~~

5.  **Alterne de volta para a branch `main`:**
    ~~~bash
    git switch main
    ~~~

6.  **Verifique o conteúdo de `server.js` na `main`:**
    Abra `server.js` novamente. Você notará que o endpoint `/login` que você acabou de adicionar na branch `feature/autenticacao` **não está presente** na branch `main`. Isso demonstra o isolamento do trabalho em branches.

## Glossário Técnico
**Branch:** Uma linha independente de desenvolvimento no Git.
**HEAD:** Um ponteiro que indica o commit atual em que você está trabalhando.
**git branch:** Comando para listar, criar ou excluir branches.
**git switch:** Comando para alternar entre branches (recomendado).
**git checkout:** Comando legado para alternar entre branches e restaurar arquivos.

## Antecipação de Erros
-   **Erro: `error: Your local changes to the following files would be overwritten by checkout:`**
    -   **Causa:** Você tem mudanças não commitadas ou não salvas no seu **Working Directory** e está tentando alternar para outra branch. O Git impede isso para evitar a perda de trabalho.
    -   **Solução:**
        1.  **Commite suas mudanças:** Se as mudanças são importantes, faça um commit na branch atual.
        2.  **Descarte suas mudanças:** Se você não precisa delas, use `git restore .` para descartar todas as alterações no **Working Directory**.
        3.  **Salve temporariamente:** Use `git stash` (veremos em aulas futuras) para guardar suas mudanças e restaurá-las depois.
-   **Erro: `error: pathspec 'nome-da-branch' did not match any file(s) known to git.`**
    -   **Causa:** Você tentou alternar para uma branch que não existe ou digitou o nome incorretamente.
    -   **Solução:** Verifique a lista de branches com `git branch` e use o nome correto.

## Troubleshooting
-   **Problema: Não consigo ver minhas branches remotas.**
    -   **Solução:** Use `git branch -r` para listar as branches remotas ou `git branch -a` para listar todas (locais e remotas). Se elas não aparecerem, pode ser que você precise buscar as informações do remoto: `git fetch origin`.

## Desafio de Fixação
1.  Crie uma nova branch chamada `feature/cadastro-usuario`.
2.  Alterne para essa nova branch.
3.  No arquivo `server.js`, adicione um novo endpoint `/usuarios` (POST) que retorna `{"message": "Endpoint de cadastro de usuário (em desenvolvimento)"}`.
4.  Adicione e commite essa mudança na branch `feature/cadastro-usuario`.
5.  Alterne de volta para a branch `main`.
6.  Verifique o conteúdo de `server.js` para confirmar que o endpoint `/usuarios` não está presente na `main`.

## Resoluções Comentadas
1.  ~~~bash
    git switch -c feature/cadastro-usuario
    ~~~
2.  Você já estará na branch `feature/cadastro-usuario`.
3.  Edite `server.js` e adicione, por exemplo, abaixo do endpoint `/login` (se você o adicionou na `feature/autenticacao`):
    ~~~javascript
    // Rota para cadastro de usuários
    app.post('/usuarios', (req, res) => {
      res.status(201).json({ message: 'Endpoint de cadastro de usuário (em desenvolvimento)' });
    });
    ~~~
4.  ~~~bash
    git add server.js
    git commit -m "feat: adiciona rota inicial para cadastro de usuarios"
    ~~~
5.  ~~~bash
    git switch main
    ~~~
6.  Abra `server.js` e confirme que o endpoint `/usuarios` não está lá.

## Resumo dos Pontos-Chave
-   Branches são fundamentais para o desenvolvimento paralelo e isolado.
-   `git switch -c` é a forma recomendada para criar e alternar para uma nova branch.
-   É crucial manter a branch `main` estável e desenvolver novas funcionalidades em branches separadas.
-   O `HEAD` aponta para o commit atual da branch ativa.

## Próximos Passos
Agora que sabemos como criar e trabalhar em branches separadas, o próximo passo lógico é aprender a integrar o trabalho de uma branch de volta à outra. Na Aula 8, exploraremos o comando `git merge`, que nos permite combinar o histórico de duas branches, e como resolver os inevitáveis **conflitos de merge**.

## Log de Estado do Projeto
-   **Objetivo:** Entender e utilizar branches para desenvolvimento paralelo.
-   **Código Adicionado:** Endpoint `/login` na branch `feature/autenticacao` e endpoint `/usuarios` na branch `feature/cadastro-usuario`.
-   **Estado Funcional:** ✅ Repositório com múltiplas branches, cada uma com seu desenvolvimento isolado.
-   **Próximas Etapas:** Aula 8 abordará a mesclagem de branches com `git merge` e resolução de conflitos.

---
Dúvidas? Posso prosseguir para a próxima etapa?