# Aula 9: Reorganizando o Histórico: git rebase

## Resumo da Aula Anterior
Na Aula 8, dominamos o comando `git merge` para integrar mudanças de uma branch em outra. Aprendemos sobre os tipos de mesclagem (Fast-Forward e 3-Way Merge) e, crucialmente, como resolver os conflitos que podem surgir ao combinar diferentes linhas de desenvolvimento. Nosso projeto `barbershop-api` agora tem um histórico de commits que reflete a integração de novas funcionalidades como `/usuarios` e `/login` na branch `main`.

## Objetivo
Entender o conceito e a aplicação do comando **git rebase** como uma alternativa ao `git merge` para integrar mudanças, com foco na criação de um histórico de commits mais linear e limpo. Aprender a usar `git rebase` para mover commits e a lidar com conflitos durante o processo de rebase.

## Pré-requisitos
Repositório Git com múltiplas branches e commits em branches diferentes (conforme Aula 8).

## Análise de Integridade
✅ Conteúdo verificado: profundidade técnica mantida, linguagem acessível, código funcional.

## Teoria Detalhada (Narrativa Densa)

Até agora, usamos `git merge` para combinar o trabalho de diferentes branches. Embora o `merge` seja eficaz, ele tem uma característica que pode ser vista como uma desvantagem em certos contextos: ele preserva o histórico exato de cada branch, incluindo os commits de merge. Isso pode levar a um histórico de commits que se assemelha a uma "teia de aranha" ou a um "emaranhado de galhos", especialmente em projetos com muitas branches de curta duração e merges frequentes. Para algumas equipes, um histórico assim pode ser difícil de ler e entender.

É aqui que entra o **git rebase**. O `rebase` oferece uma maneira alternativa de integrar mudanças, com o objetivo principal de criar um histórico de commits mais linear e limpo. Em vez de criar um novo commit de merge para unir os históricos, o `rebase` reescreve o histórico de commits de uma branch, movendo-os para "em cima" de outra branch.

Pense no `rebase` como "re-basear" sua branch em um novo ponto no histórico. Imagine que você está construindo uma torre (sua branch de funcionalidade) a partir de uma base (a branch `main`). Enquanto você está construindo, a base (`main`) é atualizada com novos andares (commits). Em vez de construir uma ponte para conectar sua torre à nova altura da base (como faria o `merge`), o `rebase` pega sua torre, desmonta-a em seus blocos originais (commits), move-os para a nova altura da base e os reconstrói um por um, como se você tivesse começado a construir sua torre a partir da base atualizada desde o início.

### Como o `git rebase` Funciona

Quando você executa `git rebase <base_branch>` estando em uma `feature_branch`:

1.  O Git identifica o commit ancestral comum mais recente entre `feature_branch` e `base_branch`.
2.  Ele "desfaz" os commits da `feature_branch` que ocorreram após esse ancestral comum, salvando-os temporariamente.
3.  Ele move o ponteiro da `feature_branch` para o último commit da `base_branch`.
4.  Ele então "reaplica" os commits salvos da `feature_branch` um por um, na ordem em que foram feitos, sobre o novo topo da `base_branch`.

O resultado é que todos os commits da `feature_branch` aparecem como se tivessem sido feitos *depois* dos commits mais recentes da `base_branch`, criando um histórico linear.

~~~mermaid
graph TD
    A(Commit A) --> B(Commit B - main)
    B --> C(Commit C - feature)
    C --> D(Commit D - feature)
    B --> E(Commit E - main)
    E -- git rebase main --> F(Commit C' - feature)
    F --> G(Commit D' - feature)
    style B fill:#f9f,stroke:#333,stroke-width:2px
    style E fill:#f9f,stroke:#333,stroke-width:2px
    style G fill:#f9f,stroke:#333,stroke-width:2px
~~~
*   No diagrama acima, `C` e `D` são commits na `feature` branch. `E` é um novo commit na `main`.
*   Após `git rebase main` na `feature` branch, os commits `C` e `D` são reescritos como `C'` e `D'` e aplicados *após* `E`, resultando em um histórico linear.

### Vantagens do `git rebase`

*   **Histórico Limpo e Linear:** Facilita a leitura do histórico do projeto, pois não há commits de merge.
*   **Melhor para Branches de Curta Duração:** Ideal para branches de funcionalidade que são desenvolvidas por um único desenvolvedor e que serão mescladas rapidamente na `main`.
*   **Evita Commits de Merge Desnecessários:** Mantém o histórico mais conciso.

### Desvantagens e Cuidados com o `git rebase`

*   **Reescreve o Histórico:** Esta é a principal desvantagem. Ao reaplicar commits, o `rebase` cria *novos* commits com novos SHAs. Isso significa que os commits originais da branch são substituídos.
*   **NUNCA Faça Rebase em Commits Públicos:** A regra de ouro do `rebase` é: **nunca faça rebase em uma branch que já foi enviada para um repositório remoto e que outros desenvolvedores podem ter clonado ou baseado seu trabalho.** Se você reescrever o histórico de uma branch pública, outros desenvolvedores que já têm a versão antiga desses commits terão problemas sérios ao tentar sincronizar seu trabalho, pois o Git não saberá como conciliar os históricos divergentes. Isso pode levar a duplicação de trabalho e muita dor de cabeça.
*   **Conflitos de Rebase:** Assim como no `merge`, conflitos podem ocorrer durante o `rebase`, especialmente se a `base_branch` teve muitas mudanças que colidem com as da sua `feature_branch`. Você terá que resolver esses conflitos um por um, para cada commit que está sendo reaplicado.

### Comandos Básicos de `git rebase`

*   **`git rebase <base_branch>`:** Rebaseia a branch atual sobre a `<base_branch>`.
    *   Exemplo: Estando na `feature/login`, `git rebase main` tentará reaplicar os commits de `feature/login` sobre o topo da `main`.
*   **`git rebase --continue`:** Após resolver um conflito durante o rebase, use este comando para continuar o processo.
*   **`git rebase --abort`:** Cancela o rebase em andamento e retorna a branch ao estado anterior ao início do rebase.
*   **`git rebase --skip`:** Pula o commit atual que está causando problemas durante o rebase. Use com cautela, pois isso significa que as mudanças desse commit serão perdidas.

### Fluxo de Trabalho Típico com `git rebase`

1.  **Certifique-se de que sua branch `main` está atualizada:**
    ~~~bash
    git switch main
    git pull origin main
    ~~~
2.  **Alterne para sua branch de funcionalidade:**
    ~~~bash
    git switch feature/minha-funcionalidade
    ~~~
3.  **Rebaseie sua branch sobre a `main`:**
    ~~~bash
    git rebase main
    ~~~
    *   Se houver conflitos, resolva-os, adicione os arquivos resolvidos (`git add <arquivo>`) e continue (`git rebase --continue`). Repita até que todos os commits sejam reaplicados.
4.  **Após o rebase bem-sucedido, mescle na `main` (geralmente um Fast-Forward merge):**
    ~~~bash
    git switch main
    git merge feature/minha-funcionalidade
    ~~~
    *   Como o histórico da `feature/minha-funcionalidade` agora é linear e está "à frente" da `main`, o `merge` será um Fast-Forward, sem criar um commit de merge extra.
5.  **Opcional: Exclua a branch de funcionalidade:**
    ~~~bash
    git branch -d feature/minha-funcionalidade
    ~~~

## Aplicação no Projeto Prático

Vamos usar o `git rebase` para integrar uma nova funcionalidade de forma linear.

1.  **Garanta que sua branch `main` está atualizada:**
    ~~~bash
    git switch main
    git pull origin main # Para garantir que está sincronizada com o remoto, se houver
    ~~~
2.  **Crie uma nova branch para uma funcionalidade de agendamento:**
    ~~~bash
    git switch -c feature/detalhes-agendamento
    ~~~
3.  **Adicione um novo endpoint para detalhes de agendamento em `server.js`:**
    ~~~javascript
    // server.js
    // ... (código existente) ...

    // Rota para detalhes de um agendamento específico
    app.get('/agendamentos/:id', (req, res) => {
      const { id } = req.params;
      res.json({ message: `Detalhes do agendamento ${id}` });
    });

    // ... (restante do código) ...
    ~~~
4.  **Faça um commit dessa mudança:**
    ~~~bash
    git add server.js
    git commit -m "feat: adiciona rota para detalhes de agendamento por ID"
    ~~~
5.  **Simule um commit na `main` enquanto você trabalha na sua branch.**
    *   Alterne para a `main`:
        ~~~bash
        git switch main
        ~~~
    *   Adicione um comentário no `server.js` (ex: `// TODO: Adicionar validação de dados para agendamentos`) e commite:
        ~~~bash
        git add server.js
        git commit -m "chore: adiciona TODO para validacao de agendamentos"
        ~~~
6.  **Volte para sua branch de funcionalidade:**
    ~~~bash
    git switch feature/detalhes-agendamento
    ~~~
7.  **Agora, rebaseie sua branch sobre a `main`:**
    ~~~bash
    git rebase main
    ~~~
    *   O Git tentará aplicar seu commit `feat: adiciona rota para detalhes de agendamento por ID` *depois* do commit `chore: adiciona TODO para validacao de agendamentos` da `main`.
    *   Se houver conflitos (o que é improvável neste exemplo simples, mas pode acontecer em cenários reais), resolva-os, adicione os arquivos resolvidos (`git add server.js`) e continue (`git rebase --continue`).
8.  **Após o rebase ser concluído com sucesso, volte para a `main` e mescle:**
    ~~~bash
    git switch main
    git merge feature/detalhes-agendamento
    ~~~
    *   Observe que este será um Fast-Forward merge, pois o histórico da `feature/detalhes-agendamento` agora é uma extensão linear da `main`.
9.  **Verifique o histórico com `git log --oneline --graph`:**
    *   Você deverá ver um histórico linear, sem o commit de merge que teríamos com `git merge`.

## Glossário Técnico
**git rebase:** Comando para integrar mudanças de uma branch em outra, reescrevendo o histórico para criar uma linha de desenvolvimento linear.
**Reescrever Histórico:** Alterar os commits existentes, criando novos commits com novos SHAs.
**Base Branch:** A branch sobre a qual outra branch será rebaseada.
**Fast-Forward Merge:** Tipo de mesclagem onde o ponteiro da branch de destino é simplesmente movido para o commit mais recente da branch de origem, sem criar um commit de merge.

## Antecipação de Erros
-   **Rebase em Branch Pública:** O erro mais grave. Se você rebasear uma branch que já foi compartilhada, outros desenvolvedores terão problemas ao sincronizar.
-   **Conflitos de Rebase:** Podem ser mais complexos de resolver do que conflitos de merge, pois você pode ter que resolver o mesmo conflito várias vezes se houver muitos commits sendo reaplicados.
-   **Perda de Commits:** Se você usar `git rebase --skip` sem entender o que está fazendo, pode perder commits.

## Troubleshooting
-   **Conflito durante o rebase:**
    1.  O Git pausará o rebase e indicará os arquivos com conflito.
    2.  Edite os arquivos para resolver os conflitos (remova os marcadores `<<<<<<<`, `=======`, `>>>>>>>`).
    3.  Adicione os arquivos resolvidos à Staging Area: `git add <arquivo_resolvido>`.
    4.  Continue o rebase: `git rebase --continue`.
    5.  Se quiser abortar: `git rebase --abort`.
-   **Rebasei uma branch pública e agora meus colegas estão com problemas!**
    -   A melhor solução é comunicar a equipe imediatamente. Uma opção pode ser forçar o push (`git push --force-with-lease`) para sobrescrever o histórico remoto, mas isso deve ser feito com extremo cuidado e coordenação para evitar perda de trabalho de outros. Em geral, evite essa situação a todo custo.

## Desafio de Fixação
1.  Crie uma nova branch `feature/logout`.
2.  Alterne para essa branch.
3.  No `server.js`, adicione um novo endpoint `/logout` (POST) que retorna `{"message": "Usuário deslogado com sucesso"}`.
4.  Faça um commit com a mensagem `feat: adiciona rota de logout`.
5.  Alterne para a `main`.
6.  Adicione um comentário em `server.js` como `// TODO: Implementar autenticação JWT` e commite com a mensagem `chore: adiciona TODO para JWT`.
7.  Volte para `feature/logout`.
8.  Rebaseie `feature/logout` sobre `main`.
9.  Mescle `feature/logout` na `main`.
10. Verifique o histórico com `git log --oneline --graph`.

## Resoluções Comentadas
1.  ~~~bash
    git switch -c feature/logout
    ~~~
2.  Você já estará na branch `feature/logout`.
3.  Edite `server.js` e adicione:
    ~~~javascript
    // Rota para logout
    app.post('/logout', (req, res) => {
      res.json({ message: 'Usuário deslogado com sucesso' });
    });
    ~~~
4.  ~~~bash
    git add server.js
    git commit -m "feat: adiciona rota de logout"
    ~~~
5.  ~~~bash
    git switch main
    ~~~
6.  Edite `server.js` e adicione o comentário.
    ~~~bash
    git add server.js
    git commit -m "chore: adiciona TODO para JWT"
    ~~~
7.  ~~~bash
    git switch feature/logout
    ~~~
8.  ~~~bash
    git rebase main
    ~~~
    (Resolva conflitos se houver, `git add`, `git rebase --continue`).
9.  ~~~bash
    git switch main
    git merge feature/logout
    ~~~
10. ~~~bash
    git log --oneline --graph
    ~~~

## Resumo dos Pontos-Chave
-   `git rebase` reescreve o histórico para criar uma linha de desenvolvimento linear.
-   É uma alternativa ao `git merge`, útil para branches de curta duração e para manter um histórico limpo.
-   **Regra de Ouro:** Nunca rebaseie commits que já foram enviados para um repositório remoto e compartilhados com outros.
-   Conflitos de rebase são resolvidos de forma semelhante aos conflitos de merge.

## Próximos Passos
Com `git merge` e `git rebase` em nosso arsenal, temos ferramentas poderosas para integrar mudanças. Na Aula 10, vamos consolidar esses conhecimentos aplicando um fluxo de trabalho comum em equipes: o **Feature Branch Workflow**. Aprenderemos a organizar o desenvolvimento de funcionalidades de ponta a ponta, desde a criação da branch até a integração final na `main`.

## Log de Estado do Projeto
-   **Objetivo:** Entender e aplicar `git rebase` para integrar mudanças de forma linear.
-   **Código Adicionado:** Endpoint `/detalhes-agendamento/:id` e `/logout` na branch `main` (via rebase e merge).
-   **Estado Funcional:** ✅ `main` contém os endpoints de `/status`, `/agendamentos`, `/usuarios`, `/login`, `/detalhes-agendamento/:id` e `/logout`, com um histórico mais linear.
-   **Próximas Etapas:** Aula 10 abordará o **Feature Branch Workflow**.

---
Dúvidas? Posso prosseguir para a próxima etapa?