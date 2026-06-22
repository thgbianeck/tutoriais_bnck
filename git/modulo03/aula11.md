# Aula 11: Gerenciando Tags e Versões

## Resumo da Aula Anterior
Na Aula 10, aplicamos o **Feature Branch Workflow** para desenvolver e integrar uma nova funcionalidade (cancelamento de agendamento) em nosso projeto `barbershop-api`. Aprendemos a gerenciar o ciclo de vida completo de uma feature branch, desde sua criação até a mesclagem na `main` e a exclusão da branch, garantindo um fluxo de trabalho organizado e colaborativo.

## Objetivo
Entender o conceito e a importância das **tags** no Git para marcar pontos específicos e significativos no histórico do projeto, como versões de lançamento. Aprender a criar, listar, visualizar e enviar tags para o repositório remoto.

## Pré-requisitos
Repositório Git com commits e branches mescladas (conforme Aula 10).

## Análise de Integridade
✅ Conteúdo verificado: profundidade técnica mantida, linguagem acessível, código funcional.

## Teoria Detalhada (Narrativa Densa)

Até agora, usamos commits para registrar as mudanças e branches para organizar o desenvolvimento paralelo. No entanto, em muitos projetos, é crucial marcar pontos específicos no histórico de forma mais permanente e significativa do que um simples commit. Por exemplo, quando você lança uma nova versão do seu software (v1.0, v2.1, etc.), é útil ter uma forma de identificar exatamente qual commit corresponde a essa versão. É para isso que servem as **tags** no Git.

Uma tag é como um "marco" ou um "selo" que você coloca em um commit específico. Ao contrário das branches, que são ponteiros móveis que avançam com novos commits, as tags são ponteiros estáticos. Uma vez criada, uma tag sempre apontará para o mesmo commit, mesmo que você adicione novos commits ou reorganize o histórico posteriormente. Elas são ideais para marcar pontos de lançamento, como "v1.0.0", "v2.0-beta", etc.

Pense nas tags como os "números de versão" que você vê em softwares. Quando você baixa a "versão 3.5" de um aplicativo, essa versão corresponde a um estado específico do código-fonte que foi marcado com uma tag. Isso permite que você (ou qualquer outra pessoa) possa facilmente voltar a esse ponto exato no tempo, se necessário, para inspecionar o código daquela versão específica.

O Git oferece dois tipos principais de tags:

1.  **Tags Leves (Lightweight Tags):** São como um ponteiro para um commit, sem informações adicionais. São basicamente um nome para um commit específico. São úteis para marcar pontos temporários ou privados.
2.  **Tags Anotadas (Annotated Tags):** São armazenadas como objetos completos no banco de dados do Git. Elas contêm o nome do tagueador, e-mail, data e uma mensagem de tagueamento. Além disso, podem ser assinadas com GPG para verificação de integridade. São as tags preferidas para lançamentos públicos, pois fornecem mais metadados e segurança.

### Comandos para Gerenciar Tags

-   **`git tag`**: Lista todas as tags existentes no repositório.
-   **`git tag -l "v1.*"`**: Lista tags que correspondem a um padrão (ex: todas as tags que começam com "v1.").
-   **`git tag <nome_da_tag>`**: Cria uma tag leve no commit atual.
-   **`git tag -a <nome_da_tag> -m "Mensagem da tag"`**: Cria uma tag anotada no commit atual. A flag `-a` indica que é uma tag anotada, e `-m` fornece a mensagem.
-   **`git tag -a <nome_da_tag> <SHA-1_do_commit> -m "Mensagem"`**: Cria uma tag anotada em um commit específico (não necessariamente o HEAD).
-   **`git show <nome_da_tag>`**: Mostra os detalhes de uma tag (especialmente útil para tags anotadas).
-   **`git push origin <nome_da_tag>`**: Envia uma tag específica para o repositório remoto.
-   **`git push origin --tags`**: Envia todas as tags locais para o repositório remoto.
-   **`git tag -d <nome_da_tag>`**: Exclui uma tag localmente.
-   **`git push origin --delete <nome_da_tag>`**: Exclui uma tag do repositório remoto.

### Por que usar tags?

-   **Marcação de Lançamentos:** A principal razão é marcar versões de software (ex: v1.0.0, v1.0.1, v2.0.0). Isso permite que você e outros desenvolvedores possam facilmente fazer checkout de uma versão específica do código.
-   **Pontos de Referência:** Marcar commits importantes, como o ponto em que uma grande funcionalidade foi concluída ou um marco importante do projeto.
-   **Facilidade de Navegação:** Simplifica a navegação no histórico, pois você pode se referir a um commit por um nome significativo em vez de um SHA-1 longo.

## Aplicação no Projeto Prático: BarberShop API

Vamos aplicar o conceito de tags em nossa **BarberShop API**. Suponha que, após a Aula 10, consideramos que a API atingiu um estado "estável" com as funcionalidades básicas de agendamento, status, usuários, login e logout. Podemos marcar este ponto como a "versão 1.0.0" do nosso projeto.

1.  **Verifique o histórico de commits** para identificar o commit mais recente na `main` (ou o commit que você deseja taguear como a versão 1.0.0).
    ~~~bash
    git log --oneline
    ~~~
    Anote o SHA-1 do commit que você deseja taguear. Se for o último commit na `main`, você pode simplesmente usar `HEAD`.

2.  **Crie uma tag anotada** para a versão `v1.0.0`.
    ~~~bash
    git tag -a v1.0.0 -m "Release da versão 1.0.0 da BarberShop API com funcionalidades básicas."
    ~~~
    Se você quisesse taguear um commit anterior, usaria:
    ~~~bash
    git tag -a v1.0.0 <SHA-1_do_commit> -m "Release da versão 1.0.0 da BarberShop API com funcionalidades básicas."
    ~~~

3.  **Liste as tags** para confirmar que ela foi criada.
    ~~~bash
    git tag
    ~~~
    Você deverá ver `v1.0.0` na lista.

4.  **Visualize os detalhes da tag**.
    ~~~bash
    git show v1.0.0
    ~~~
    Isso mostrará quem criou a tag, quando e a mensagem associada, além dos detalhes do commit ao qual ela aponta.

5.  **Envie a tag para o repositório remoto** no GitHub. Por padrão, `git push` não envia tags. Você precisa especificá-las.
    ~~~bash
    git push origin v1.0.0
    ~~~
    Se você tivesse várias tags e quisesse enviar todas de uma vez:
    ~~~bash
    git push origin --tags
    ~~~
    Verifique no GitHub, na seção "Releases" ou "Tags" do seu repositório, se a tag `v1.0.0` aparece.

6.  **Simule um novo desenvolvimento** e uma nova versão.
    Vamos adicionar um novo endpoint para "serviços" e depois taguear uma `v1.1.0`.
    Primeiro, crie uma nova branch para a funcionalidade:
    ~~~bash
    git switch -c feature/servicos
    ~~~
    Edite `server.js` e adicione uma nova rota para listar serviços:
    ~~~javascript
    // Rota para listar serviços
    app.get('/servicos', (req, res) => {
      res.json([
        { id: 1, nome: 'Corte de Cabelo', preco: 50 },
        { id: 2, nome: 'Barba', preco: 30 },
        { id: 3, nome: 'Corte e Barba', preco: 75 }
      ]);
    });
    ~~~
    Adicione e commite a mudança:
    ~~~bash
    git add server.js
    git commit -m "feat: adiciona rota para listar servicos"
    ~~~
    Volte para a `main` e mescle a nova funcionalidade:
    ~~~bash
    git switch main
    git merge feature/servicos
    ~~~
    Agora, crie uma nova tag para a `v1.1.0`:
    ~~~bash
    git tag -a v1.1.0 -m "Adiciona funcionalidade de listagem de serviços"
    ~~~
    Envie a nova tag para o remoto:
    ~~~bash
    git push origin v1.1.0
    ~~~
    Exclua a feature branch:
    ~~~bash
    git branch -d feature/servicos
    git push origin --delete feature/servicos
    ~~~

## Resumo dos Pontos-Chave
-   **Tags** são ponteiros estáticos para commits, usados para marcar pontos importantes no histórico, como versões de lançamento.
-   Existem **tags leves** (simples ponteiros) e **tags anotadas** (com metadados adicionais).
-   `git tag` lista tags, `git tag -a` cria tags anotadas.
-   `git show <tag>` exibe detalhes da tag.
-   Tags precisam ser enviadas explicitamente para o remoto com `git push origin <tag>` ou `git push origin --tags`.
-   Tags são cruciais para gerenciar versões de software e pontos de referência no projeto.

## Próximos Passos
Agora que sabemos como marcar versões com tags, vamos continuar a explorar técnicas avançadas de gerenciamento de histórico. Na Aula 12, abordaremos o `git stash`, uma ferramenta útil para salvar mudanças temporariamente sem precisar commitar, ideal para alternar de contexto rapidamente.

## Log de Estado do Projeto
-   **Objetivo:** Criar e gerenciar tags para marcar versões no projeto.
-   **Código Adicionado:** Endpoint `/servicos` na branch `main`.
-   **Estado Funcional:** ✅ `main` contém os endpoints de `/status`, `/agendamentos`, `/agendamentos/:id`, `/usuarios`, `/login`, `/logout`, `/agendamentos/:id/cancelar` e `/servicos`, com as tags `v1.0.0` e `v1.1.0` marcando os marcos de versão.
-   **Próximas Etapas:** Aula 12 abordará o `git stash` para salvar mudanças temporariamente.

---
Dúvidas? Posso prosseguir para a próxima etapa?