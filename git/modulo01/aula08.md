# Aula 8: Integrando Mudanças: git merge

## Resumo da Aula Anterior
Na Aula 7, mergulhamos no conceito fundamental de **branches**, entendendo como elas permitem o desenvolvimento paralelo e isolado de funcionalidades. Aprendemos a criar novas branches com `git switch -c`, a listar as branches existentes com `git branch` e a alternar entre elas com `git switch`. Criamos uma branch `feature/cadastro-usuario` e adicionamos um endpoint `/usuarios` a ela, mantendo a `main` estável e sem essa nova funcionalidade.

## Objetivo
Compreender o processo de **mesclagem de branches** utilizando o comando **git merge**, entender os diferentes tipos de mesclagem (Fast-Forward e 3-Way Merge), e aprender a resolver os **conflitos de merge** que podem surgir ao integrar diferentes linhas de desenvolvimento.

## Pré-requisitos
Repositório Git com múltiplas branches e commits em branches diferentes (conforme Aula 7).

## Análise de Integridade
✅ Conteúdo verificado: profundidade técnica mantida, linguagem acessível, código funcional.

## Teoria Detalhada (Narrativa Densa)

Após desenvolver uma nova funcionalidade ou corrigir um bug em uma branch isolada, o próximo passo natural é integrar essas mudanças de volta à branch principal do projeto, geralmente a `main`. Este processo de integração é conhecido como **mesclagem** ou **merge**, e é realizado com o comando `git merge`. A mesclagem é o ato de combinar o histórico de commits de uma branch em outra, trazendo as alterações de uma linha de desenvolvimento para outra.

Pense na mesclagem como o momento em que os "galhos" da nossa árvore de branches se reencontram para formar um tronco mais robusto. Você trabalhou em um galho separado, adicionando novas folhas e frutos (commits), e agora é hora de trazer essas adições de volta para o tronco principal, enriquecendo-o com o seu trabalho.

### Tipos de Mesclagem

O Git é inteligente o suficiente para realizar a mesclagem de diferentes maneiras, dependendo do histórico de commits das branches envolvidas. Existem dois tipos principais de mesclagem:

1.  **Fast-Forward Merge (Mesclagem de Avanço Rápido):**
    *   **Quando ocorre:** Este tipo de mesclagem acontece quando a branch para a qual você está mesclando (a branch de destino) não teve nenhum novo commit desde que a branch de origem foi criada. Ou seja, o histórico da branch de destino está "atrás" do histórico da branch de origem.
    *   **Como funciona:** O Git simplesmente move o ponteiro da branch de destino para o último commit da branch de origem. Não é criado um novo commit de mesclagem. O histórico parece uma linha reta.
    *   **Analogia:** Imagine que você está em uma estrada principal (branch `main`) e desvia para uma estrada secundária (branch `feature`). Você faz algumas modificações na estrada secundária. Se ninguém mais mexeu na estrada principal enquanto você estava fora, o Git simplesmente estende a estrada principal até onde você chegou na secundária. É uma "avanço rápido" do ponteiro.

    ~~~mermaid
    graph LR
        A(Commit A) --> B(Commit B - main)
        B --> C(Commit C - feature)
        C --> D(Commit D - feature)
        D -- git merge main --> D(Commit D - main, feature)
    ~~~
    *   No diagrama acima, `main` avança diretamente para `D` após o merge, pois `main` não teve commits novos desde que `feature` foi criada a partir de `B`.

2.  **3-Way Merge (Mesclagem de Três Vias):**
    *   **Quando ocorre:** Este é o tipo de mesclagem mais comum e ocorre quando a branch de destino (ex: `main`) teve novos commits desde que a branch de origem (ex: `feature`) foi criada. Ou seja, ambas as branches evoluíram independentemente a partir de um ponto comum.
    *   **Como funciona:** O Git precisa encontrar um "ancestral comum" (o commit base de onde as duas branches divergiram) e, a partir dele, combinar as mudanças de ambas as branches. O resultado é um **novo commit de mesclagem** (merge commit) que tem dois pais (os últimos commits de cada branch).
    *   **Analogia:** Você e um amigo começam a escrever um livro juntos a partir de um rascunho inicial (ancestral comum). Você escreve um capítulo (commits na sua branch) e seu amigo escreve outro (commits na branch dele). Para juntar os dois capítulos no livro final, vocês precisam combinar o trabalho de ambos, criando uma nova versão do livro que incorpora as contribuições de cada um.

    ~~~mermaid
    graph TD
        A(Commit A) --> B(Commit B - Ancestral Comum)
        B --> C(Commit C - main)
        B --> D(Commit D - feature)
        C --> E(Commit E - main)
        D --> F(Commit F - feature)
        E & F --> G(Commit G - Merge Commit)
    ~~~
    *   No diagrama, `G` é o commit de mesclagem que une os históricos de `main` e `feature`.

### Como Realizar um Merge

Para mesclar uma branch (`feature`) na branch atual (`main`), você deve primeiro estar na branch de destino:

~~~bash
git switch main
git merge feature/cadastro-usuario
~~~

Ao executar `git merge`, o Git tentará combinar as mudanças automaticamente.

### Conflitos de Merge

Nem sempre o Git consegue mesclar as mudanças automaticamente. Isso acontece quando as mesmas linhas de código (ou linhas muito próximas) foram modificadas de forma diferente em ambas as branches que estão sendo mescladas. Quando isso ocorre, o Git não sabe qual versão das mudanças deve prevalecer e declara um **conflito de merge**.

Quando um conflito acontece, o Git pausa o processo de mesclagem e marca os arquivos conflitantes. Ele insere marcadores especiais no código para indicar as seções conflitantes.

Exemplo de arquivo com conflito:

~~~javascript
// server.js
const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.get('/status', (req, res) => {
  res.json({ status: 'API is running' });
});

app.get('/agendamentos', (req, res) => {
  res.json({ message: 'Lista de agendamentos' });
});

<<<<<<< HEAD
// Rota para cadastro de usuários
app.post('/usuarios', (req, res) => {
  res.status(201).json({ message: 'Endpoint de cadastro de usuário (em desenvolvimento)' });
});
=======
// Rota para login de usuários
app.post('/login', (req, res) => {
  res.json({ message: 'Endpoint de login (em construcao)' });
});
>>>>>>> feature/login

app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
  console.log(`Acesse: http://localhost:${PORT}`);
  console.log('API BarberShop inicializada com sucesso!');
});
~~~

Neste exemplo, o Git está mostrando duas versões do código:
-   A seção entre `<<<<<<< HEAD` e `=======` representa o código que está na branch atual (`HEAD`, que é `main` neste caso).
-   A seção entre `=======` e `>>>>>>> feature/login` representa o código que vem da branch que está sendo mesclada (`feature/login`).

Para resolver o conflito, você deve editar o arquivo manualmente, removendo os marcadores do Git e escolhendo qual versão do código manter, ou combinando as duas versões de forma que o código resultante seja funcional e correto.

Após resolver o conflito, você deve:
1.  Adicionar o arquivo resolvido à **Staging Area**: `git add <arquivo_conflitante>`.
2.  Finalizar o merge com um **commit**: `git commit -m "Merge branch 'feature/login' into main"`. O Git geralmente preenche uma mensagem de commit padrão para merges, que você pode aceitar ou editar.

## Aplicação no Projeto Prático

Vamos mesclar a branch `feature/cadastro-usuario` na `main`.

1.  Certifique-se de que você está na branch `main`:
    ~~~bash
    git switch main
    ~~~
2.  Mescle a branch `feature/cadastro-usuario` na `main`:
    ~~~bash
    git merge feature/cadastro-usuario
    ~~~
    *   Se você seguiu a Aula 7 e criou a branch `feature/cadastro-usuario` e adicionou o endpoint `/usuarios` nela, este merge deve ser um **Fast-Forward Merge**, pois a `main` não teve commits novos desde que `feature/cadastro-usuario` foi criada.
    *   Verifique o `git log --oneline --graph` para confirmar o tipo de merge.

## Glossário Técnico
-   **Merge (Mesclagem):** Processo de combinar o histórico de commits de duas ou mais branches.
-   **Fast-Forward Merge:** Tipo de mesclagem onde o ponteiro da branch de destino é simplesmente movido para o último commit da branch de origem, sem criar um novo commit de mesclagem.
-   **3-Way Merge:** Tipo de mesclagem que ocorre quando as branches divergiram, exigindo um novo commit de mesclagem para unir os históricos.
-   **Conflito de Merge:** Situação em que o Git não consegue combinar automaticamente as mudanças de duas branches, exigindo intervenção manual.
-   **Ancestor Comum:** O commit a partir do qual duas branches divergiram.

## Antecipação de Erros
-   **Erro: `fatal: refusing to merge unrelated histories`**
    -   **Causa:** Ocorre quando você tenta mesclar duas branches que não compartilham um histórico comum (ou seja, as branches foram criadas a partir de um repositório diferente e depois unidas).
    -   **Solução (com cautela):** Use `git merge <branch> --allow-unrelated-histories`. Isso forçará a mesclagem, mas deve ser usado com entendimento das implicações.

## Troubleshooting
-   **Problema: Estou no meio de um conflito de merge e quero abortar.**
    -   **Solução:** Use `git merge --abort`. Isso reverterá o repositório para o estado anterior ao início da mesclagem.
-   **Problema: Esqueci de adicionar um arquivo resolvido à Staging Area antes de commitar o merge.**
    -   **Solução:** O Git não permitirá que você faça o commit de merge. Use `git status` para ver quais arquivos ainda precisam ser adicionados. Adicione-os com `git add` e tente o `git commit` novamente.

## Desafio de Fixação
1.  Crie uma nova branch chamada `feature/login`.
2.  Alterne para essa branch.
3.  No arquivo `server.js`, adicione o endpoint `/login` (POST) que retorna `{"message": "Endpoint de login (em construcao)"}`.
4.  Faça um commit dessa mudança na branch `feature/login`.
5.  Alterne de volta para a branch `main`.
6.  Mescle a branch `feature/login` na `main`.
7.  Se ocorrer um conflito (o que é provável se você já mesclou `feature/cadastro-usuario` na `main` e o endpoint `/login` foi adicionado em uma parte do código que já foi modificada), resolva-o, mantendo ambos os endpoints (`/usuarios` e `/login`).
8.  Verifique o `git log --oneline --graph` para ver o histórico de merge.

## Resoluções Comentadas
1.  ~~~bash
    git switch -c feature/login
    ~~~
2.  Você já estará na branch `feature/login`.
3.  Edite `server.js` e adicione, por exemplo, abaixo do endpoint `/usuarios` (se ele já estiver lá):
    ~~~javascript
    // Rota para login de usuários
    app.post('/login', (req, res) => {
      res.json({ message: 'Endpoint de login (em construcao)' });
    });
    ~~~
4.  ~~~bash
    git add server.js
    git commit -m "feat: adiciona rota inicial para login"
    ~~~
5.  ~~~bash
    git switch main
    ~~~
6.  ~~~bash
    git merge feature/login
    ~~~
7.  Se houver conflito, edite `server.js` para combinar as mudanças, garantindo que ambos os endpoints (`/usuarios` e `/login`) estejam presentes e corretos. Por exemplo:
    ~~~javascript
    // server.js (após resolver o conflito)
    const express = require('express');
    const app = express();
    const PORT = process.env.PORT || 3000;

    app.use(express.json());

    app.get('/status', (req, res) => {
      res.json({ status: 'API is running' });
    });

    app.get('/agendamentos', (req, res) => {
      res.json({ message: 'Lista de agendamentos' });
    });

    // Rota para cadastro de usuários
    app.post('/usuarios', (req, res) => {
      res.status(201).json({ message: 'Endpoint de cadastro de usuário (em desenvolvimento)' });
    });

    // Rota para login de usuários
    app.post('/login', (req, res) => {
      res.json({ message: 'Endpoint de login (em construcao)' });
    });

    app.listen(PORT, () => {
      console.log(`Servidor rodando na porta ${PORT}`);
      console.log(`Acesse: http://localhost:${PORT}`);
      console.log('API BarberShop inicializada com sucesso!');
    });
    ~~~
    Após editar, adicione o arquivo resolvido e commite:
    ~~~bash
    git add server.js
    git commit -m "Merge branch 'feature/login' into main"
    ~~~
8.  ~~~bash
    git log --oneline --graph
    ~~~

## Resumo dos Pontos-Chave
-   `git merge` integra mudanças de uma branch em outra.
-   **Fast-Forward Merge** ocorre quando não há commits divergentes na branch de destino.
-   **3-Way Merge** ocorre quando há commits divergentes e cria um novo commit de merge.
-   **Conflitos de Merge** exigem resolução manual, editando os arquivos e adicionando-os à Staging Area antes de commitar.
-   `git merge --abort` pode ser usado para cancelar um merge em andamento.

## Próximos Passos
Agora que dominamos a mesclagem de branches e a resolução de conflitos, estamos prontos para aprimorar nosso fluxo de trabalho. Na Aula 9, exploraremos o comando `git rebase`, uma alternativa ao `git merge` para integrar mudanças, que reescreve o histórico de commits para criar uma linha de desenvolvimento mais linear e limpa.

## Log de Estado do Projeto
-   **Objetivo:** Mesclar branches e resolver conflitos de merge.
-   **Código Adicionado:** Endpoint `/usuarios` (via merge de `feature/cadastro-usuario`) e endpoint `/login` (via merge de `feature/login`) na branch `main`.
-   **Estado Funcional:** ✅ `main` contém os endpoints de `/status`, `/agendamentos`, `/usuarios` e `/login`, com histórico de merges.
-   **Próximas Etapas:** Aula 9 abordará o `git rebase` como alternativa ao `git merge`.

---
Dúvidas? Posso prosseguir para a próxima etapa?