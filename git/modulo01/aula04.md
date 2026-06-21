# Aula 4: Desfazendo Mudanças Locais: Restore e Reset

## Resumo da Aula Anterior
Na Aula 3, exploramos o histórico de commits do nosso projeto `barbershop-api` usando o comando `git log` e suas diversas opções de formatação, como `--oneline`, `--graph`, `--decorate`, `-p` e `--stat`. Aprendemos a navegar por esse diário de bordo e a entender o que cada commit representa, identificando-os pelo seu SHA-1 único.

## Objetivo
Desfazer alterações no **Working Directory** e **Staging Area** com os comandos **git restore** e **git restore --staged**, e aprender a "voltar no tempo" no histórico de commits com o comando **git reset**, compreendendo suas diferentes variações e os riscos envolvidos.

## Pré-requisitos
Repositório Git com commits e alterações pendentes (conforme Aula 3).

## Análise de Integridade
✅ Conteúdo verificado: profundidade técnica mantida, linguagem acessível, código funcional.

## Teoria Detalhada (Narrativa Densa)

No processo de desenvolvimento de software, é inevitável cometer erros, experimentar ideias que não funcionam ou simplesmente mudar de ideia sobre uma implementação. A capacidade de desfazer mudanças é uma das características mais poderosas e libertadoras de um sistema de controle de versão como o Git. Sem essa funcionalidade, o medo de estragar o código seria constante, inibindo a experimentação e a inovação. O Git oferece ferramentas robustas para reverter ou descartar alterações em diferentes estágios do seu fluxo de trabalho local.

Pense na capacidade de desfazer mudanças como ter um **"controle de tempo"** para o seu projeto. Você pode voltar alguns segundos para desfazer uma digitação errada, ou voltar alguns minutos para descartar uma ideia que não deu certo, ou até mesmo voltar horas ou dias para um ponto de partida anterior. O Git nos dá essa flexibilidade, mas é crucial entender as ferramentas certas para cada situação, pois algumas delas podem ser destrutivas se usadas incorretamente.

### Desfazendo Mudanças no Working Directory e Staging Area com `git restore`

Historicamente, o comando `git checkout` era usado para muitas operações de "desfazer". No entanto, para maior clareza e segurança, o Git introduziu o comando `git restore` a partir da versão 2.23, que é a forma recomendada para descartar mudanças em arquivos.

1.  **`git restore <arquivo>`**: Este comando é usado para descartar as modificações feitas em um arquivo no seu **Working Directory**. Ele pega a versão mais recente do arquivo que está na **Staging Area** (ou no último commit, se o arquivo não estiver na Staging Area) e a sobrescreve no seu **Working Directory**. É como se você dissesse: "Esqueça as últimas edições que fiz neste arquivo, quero a versão que estava pronta para ser commitada ou a última versão commitada."
    *   **Cenário de uso:** Você fez várias alterações em `server.js`, mas percebeu que está indo na direção errada e quer voltar ao estado do último commit.

2.  **`git restore --staged <arquivo>`**: Este comando é usado para remover um arquivo da **Staging Area**. As modificações do arquivo ainda permanecerão no seu **Working Directory**, mas o Git não as considerará mais para o próximo commit. É como se você dissesse: "Eu adicionei este arquivo para ser commitado, mas mudei de ideia. Quero que ele volte para o estado de 'modificado' no meu Working Directory, sem ser incluído no próximo commit."
    *   **Cenário de uso:** Você adicionou `server.js` à Staging Area, mas depois percebeu que ainda precisa fazer mais algumas alterações antes de commitar.

### Voltando no Tempo no Histórico com `git reset`

O comando `git reset` é uma ferramenta poderosa para "voltar no tempo" no histórico de commits. Ele move o ponteiro `HEAD` (que aponta para o commit atual) para um commit anterior, efetivamente reescrevendo parte do histórico. No entanto, o `git reset` tem diferentes "modos" que determinam o que acontece com as mudanças no seu **Working Directory** e **Staging Area**.

Para entender `git reset`, precisamos entender `HEAD`. `HEAD` é um ponteiro que aponta para o commit atual na branch em que você está. Quando você faz um commit, `HEAD` avança para o novo commit. `HEAD~1` refere-se ao commit imediatamente anterior ao `HEAD`, `HEAD~2` ao commit dois antes, e assim por diante. Você também pode usar o SHA-1 completo ou abreviado de um commit específico.

As três variações principais de `git reset` são:

1.  **`git reset --soft <commit>`**: Este é o modo mais "gentil". Ele move o ponteiro `HEAD` para o `<commit>` especificado, mas **mantém todas as mudanças** (tanto as que estavam na Staging Area quanto as do Working Directory) exatamente como estavam. As mudanças que foram "desfeitas" do histórico agora aparecem como se tivessem sido feitas no seu Working Directory e já estivessem na Staging Area, prontas para serem commitadas novamente.
    *   **Cenário de uso:** Você fez um commit, mas percebeu que a mensagem estava errada ou que esqueceu de incluir um arquivo importante. Você pode usar `--soft` para "descommitar" e refazer o commit com as correções.

2.  **`git reset --mixed <commit>` (modo padrão)**: Este é o modo mais comum e é o comportamento padrão se você não especificar `--soft` ou `--hard`. Ele move o ponteiro `HEAD` para o `<commit>` especificado e **move as mudanças que foram "desfeitas" do histórico para o seu Working Directory**. A Staging Area é limpa. É como se você dissesse: "Quero voltar para este commit, e todas as mudanças que vieram depois dele agora são apenas modificações não preparadas no meu Working Directory."
    *   **Cenário de uso:** Você fez alguns commits, mas percebeu que eles não deveriam ter sido feitos daquela forma. Você quer voltar para um commit anterior e começar de novo com as mesmas mudanças, mas sem elas na Staging Area.

3.  **`git reset --hard <commit>`**: Este é o modo mais **perigoso** e **destrutivo**. Ele move o ponteiro `HEAD` para o `<commit>` especificado e **descarta todas as mudanças** (tanto as que estavam na Staging Area quanto as do Working Directory) que ocorreram após esse commit. É como se você dissesse: "Quero que meu projeto volte exatamente para o estado deste commit, e quero apagar todas as modificações que fiz desde então." **Use com extrema cautela**, pois as mudanças descartadas com `--hard` são muito difíceis (e às vezes impossíveis) de recuperar.
    *   **Cenário de uso:** Você fez uma série de mudanças experimentais que deram completamente errado e você quer simplesmente apagar tudo e voltar para um estado limpo.

### Analogia de Ancoragem

Vamos usar a analogia do **"controle de tempo"** para explicar `git reset`:

*   **`git restore <arquivo>`**: É como usar o botão "desfazer" em um editor de texto para uma alteração específica. Você apaga o que acabou de digitar em um arquivo, mas o resto do documento permanece intocado.
*   **`git restore --staged <arquivo>`**: É como tirar um item da sua "cesta de compras" antes de ir para o caixa. O item ainda está na loja (seu Working Directory), mas não está mais na cesta (Staging Area) para ser comprado (commitado).
*   **`git reset --soft <commit>`**: Você volta no tempo para um ponto específico, mas todas as suas ações desde então (as mudanças no código) ainda estão lá, prontas para serem reavaliadas e talvez "re-commitadas". É como se você voltasse no tempo, mas ainda tivesse todas as suas anotações e rascunhos das coisas que fez.
*   **`git reset --mixed <commit>`**: Você volta no tempo, e todas as suas ações desde então ainda estão lá, mas agora estão "desorganizadas" no seu espaço de trabalho. Você precisa decidir o que fazer com elas novamente. É como voltar no tempo e ter todos os seus rascunhos espalhados pela mesa.
*   **`git reset --hard <commit>`**: Você volta no tempo e **apaga completamente** todas as suas ações desde então. É como se você voltasse no tempo e todas as suas anotações e rascunhos simplesmente desaparecessem.

## Diagrama Mermaid
~~~mermaid
graph TD
    A[Working Directory] -- Modificar Arquivo --> B{Arquivo Modificado};
    B -- "git restore <arquivo>" --> A;
    B -- "git add <arquivo>" --> C[Staging Area];
    C -- "git restore --staged <arquivo>" --> B;
    C -- "git commit" --> D["Local Repository (HEAD)"];

    subgraph Reset Operations
        D -- "git reset --soft <commit>" --> E["HEAD aponta para <commit>, mudanças na Staging Area"];
        D -- "git reset --mixed <commit> (padrão)" --> F["HEAD aponta para <commit>, mudanças no Working Directory"];
        D -- "git reset --hard <commit>" --> G["HEAD aponta para <commit>, todas as mudanças descartadas"];
    end
~~~

## Aplicação no Projeto Prático

Vamos praticar esses comandos no nosso projeto `barbershop-api`.

1.  **Modifique o arquivo `server.js`:**
    Abra `server.js` no VS Code e adicione um comentário qualquer, por exemplo:
    ```javascript
    // Este é um comentário temporário para teste
    app.get('/status', (req, res) => {
      res.json({ status: 'ok', version: '1.0.0' });
    });
    ```
    Salve o arquivo.

2.  **Use `git status` para ver a mudança:**
    ~~~bash
    git status
    ~~~
    Você verá `server.js` listado como `Changes not staged for commit`.

3.  **Use `git restore server.js` para descartar a mudança:**
    ~~~bash
    git restore server.js
    ~~~
    Verifique `server.js` no VS Code; o comentário temporário terá desaparecido.
    Execute `git status` novamente. O Working Directory estará limpo.

4.  **Modifique `server.js` novamente e adicione-o à Staging Area:**
    Adicione outro comentário em `server.js`, salve.
    ~~~bash
    git add server.js
    ~~~
    Execute `git status`. Você verá `server.js` listado como `Changes to be committed`.

5.  **Use `git restore --staged server.js` para remover da Staging Area:**
    ~~~bash
    git restore --staged server.js
    ~~~
    Execute `git status`. Você verá `server.js` listado novamente como `Changes not staged for commit`. As mudanças ainda estão no seu Working Directory, mas não estão mais preparadas para o commit.

6.  **Praticando `git reset`:**
    Primeiro, vamos garantir que temos alguns commits para brincar. Se você não tem commits recentes, faça um agora:
    Modifique `server.js` (ex: adicione um `console.log` na rota `/status`).
    ~~~bash
    git add server.js
    git commit -m "feat: adiciona log na rota status para teste de reset"
    ~~~
    Agora, vamos obter o SHA-1 do commit anterior a este. Use `git log --oneline`. O commit anterior será `HEAD~1`.

    *   **`git reset --soft HEAD~1`**:
        ~~~bash
        git reset --soft HEAD~1
        ~~~
        Execute `git status`. Você verá as mudanças do commit desfeito na Staging Area (`Changes to be committed`). O commit foi removido do histórico, mas as mudanças foram preservadas e preparadas.

    *   **`git reset --mixed HEAD~1` (re-commitando o commit anterior para testar novamente):**
        Para testar `--mixed`, precisamos ter um commit para desfazer. Faça o commit novamente:
        ~~~bash
        git commit -m "feat: adiciona log na rota status para teste de reset"
        ~~~
        Agora, use `--mixed`:
        ~~~bash
        git reset --mixed HEAD~1
        ~~~
        Execute `git status`. Você verá as mudanças do commit desfeito no Working Directory (`Changes not staged for commit`). A Staging Area está limpa.

    *   **`git reset --hard HEAD~1` (CUIDADO!):**
        Para testar `--hard`, vamos criar um commit temporário que podemos perder sem problemas.
        Modifique `server.js` (ex: adicione um comentário `// Este sera apagado`).
        ~~~bash
        git add server.js
        git commit -m "chore: commit temporario para teste de reset --hard"
        ~~~
        Agora, use `--hard`. **Certifique-se de que você não se importa em perder as mudanças deste último commit.**
        ~~~bash
        git reset --hard HEAD~1
        ~~~
        Execute `git status`. O Working Directory estará limpo. Verifique `server.js` no VS Code; o comentário `// Este sera apagado` terá desaparecido completamente. O commit temporário foi apagado do histórico e suas mudanças foram descartadas.

## Glossário Técnico da Aula
-   **`git restore`:** Comando para descartar modificações no Working Directory.
-   **`git restore --staged`:** Comando para remover arquivos da Staging Area, mantendo as modificações no Working Directory.
-   **`git reset`:** Comando para mover o ponteiro HEAD para um commit anterior, reescrevendo o histórico.
-   **`HEAD`:** Ponteiro que indica o commit atual na branch em que você está.
-   **`HEAD~1`:** Refere-se ao commit imediatamente anterior ao HEAD.
-   **`--soft`:** Modo do `git reset` que move HEAD, mas mantém as mudanças na Staging Area e Working Directory.
-   **`--mixed`:** Modo padrão do `git reset` que move HEAD e as mudanças para o Working Directory (limpa a Staging Area).
-   **`--hard`:** Modo do `git reset` que move HEAD e descarta todas as mudanças no Working Directory e Staging Area (destrutivo).

## Antecipação de Erros
-   **Erro Comum 1: Perder trabalho com `git reset --hard`.**
    -   **Sintoma:** Suas modificações desapareceram e você não consegue encontrá-las.
    -   **Como evitar:** **NUNCA use `git reset --hard` em commits que você não tem certeza de que pode perder.** Sempre faça um backup ou use `git stash` se precisar descartar mudanças temporariamente.
-   **Erro Comum 2: Confusão entre `git restore` e `git reset`.**
    -   **Sintoma:** Usar o comando errado para a situação.
    -   **Como evitar:** Lembre-se que `git restore` é para arquivos no Working Directory/Staging Area. `git reset` é para mover o ponteiro `HEAD` e reescrever o histórico de commits.

## Troubleshooting
-   **Problema: Usei `git reset --hard` e perdi um commit importante! Há como recuperar?**
    -   **Solução:** O Git tem um "diário" de todas as operações que você fez no seu repositório local, chamado **reflog**. Use `git reflog` para ver uma lista de onde seu `HEAD` esteve. Você pode encontrar o SHA-1 do commit perdido e usar `git reset --hard <SHA-1_DO_COMMIT_PERDIDO>` para voltar a ele. **Isso só funciona se o commit ainda estiver no seu reflog e não tiver sido "coletado lixo" pelo Git.**
-   **Problema: `git restore` não funciona como esperado.**
    -   **Solução:** Verifique se você está especificando o arquivo corretamente. Lembre-se que `git restore` afeta o Working Directory, e `git restore --staged` afeta a Staging Area.

## Desafio de Fixação
1.  Modifique o arquivo `server.js` adicionando um novo endpoint `/hello` que retorna `{"message": "Hello, Git!"}`.
2.  Adicione `server.js` à Staging Area.
3.  Perceba que você não quer commitar essa mudança ainda. Use `git restore --staged server.js` para remover `server.js` da Staging Area.
4.  Agora, decida que você não quer mais o endpoint `/hello` e descarte as mudanças no `server.js` usando `git restore server.js`.
5.  Crie um novo commit com uma mensagem `chore: commit de teste para reset`.
6.  Use `git reset --soft HEAD~1` para desfazer esse commit, mas manter as mudanças na Staging Area.
7.  Faça um novo commit com a mensagem `chore: commit de teste final`.

## Resoluções Comentadas
1.  Adicione o endpoint `/hello` em `server.js`.
2.  ~~~bash
    git add server.js
    ~~~
3.  ~~~bash
    git restore --staged server.js
    ~~~
4.  ~~~bash
    git restore server.js
    ~~~
5.  Modifique `server.js` com qualquer coisa (ex: um comentário), adicione e commite:
    ~~~bash
    git add server.js
    git commit -m "chore: commit de teste para reset"
    ~~~
6.  ~~~bash
    git reset --soft HEAD~1
    ~~~
    (Verifique `git status` para ver as mudanças na Staging Area).
7.  ~~~bash
    git commit -m "chore: commit de teste final"
    ~~~

## Resumo dos Pontos-Chave
-   `git restore` é usado para descartar mudanças em arquivos no Working Directory ou na Staging Area.
-   `git reset` é usado para mover o ponteiro `HEAD` e reescrever o histórico de commits, com diferentes impactos nas mudanças locais (`--soft`, `--mixed`, `--hard`).
-   `git reset --hard` é destrutivo e deve ser usado com extrema cautela.
-   O `git reflog` pode ser uma "tábua de salvação" para recuperar commits perdidos.

## Próximos Passos
Compreender como desfazer mudanças é crucial. Na próxima aula, abordaremos como ignorar arquivos e pastas que não devem ser rastreados pelo Git, utilizando o arquivo `.gitignore`. Isso é fundamental para manter seu repositório limpo e focado apenas no código-fonte relevante.

## Log de Estado do Projeto
-   **Objetivo:** Aprender a desfazer e reverter mudanças em diferentes estágios do repositório local.
-   **Código Adicionado:** Nenhum código funcional novo, foco na manipulação do histórico.
-   **Estado Funcional:** ✅ Repositório com histórico manipulado e compreendido.
-   **Próximas Etapas:** Aula 5 abordará o uso do arquivo `.gitignore`.

---
Dúvidas? Posso prosseguir para a próxima etapa?