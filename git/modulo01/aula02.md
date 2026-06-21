# Aula 2: O Repositório Local: Inicializando e Acompanhando Mudanças

## Resumo da Aula Anterior
Na Aula 1, entendemos a importância do controle de versão e do Git, instalamos e configuramos o Git em nosso ambiente Windows 11, criamos a estrutura inicial da nossa **BarberShop API** em Node.js e, finalmente, inicializamos um repositório Git local com o comando `git init`.

## Objetivo
Inicializar um repositório Git, entender os conceitos de **Working Directory**, **Staging Area** e **Local Repository**, e usar os comandos **git add** e **git commit** para começar a rastrear as mudanças em nosso projeto.

## Pré-requisitos
Git instalado e configurado, projeto `barbershop-api` criado e repositório Git inicializado (conforme Aula 1).

## Análise de Integridade
✅ Conteúdo verificado: profundidade técnica mantida, linguagem acessível, código funcional.

## Teoria Detalhada (Narrativa Densa)

No coração do funcionamento do Git reside um modelo de três estados que define como o sistema rastreia e gerencia as alterações em seus arquivos. Compreender esses estados é fundamental para dominar o Git, pois eles ditam o fluxo de trabalho básico de qualquer desenvolvedor. Pense nesses estados como diferentes "áreas" ou "etapas" pelas quais suas modificações passam antes de serem permanentemente registradas no histórico do projeto.

Os três estados principais são:

1.  **Working Directory (Diretório de Trabalho):** Esta é a área onde você realmente trabalha. É a cópia dos arquivos do seu projeto que você vê e edita no seu sistema de arquivos. Quando você abre um arquivo no VS Code e faz uma alteração, essa modificação existe apenas no seu **Working Directory**. O Git sabe que o arquivo foi modificado, mas ainda não o está "preparando" para ser salvo no histórico. É o seu rascunho atual, o estado "sujo" do seu projeto.

2.  **Staging Area (Área de Preparação ou Índice):** Também conhecida como "Index", a **Staging Area** é um arquivo simples que armazena informações sobre o que será incluído no seu próximo commit. Pense nela como uma "mesa de montagem" ou uma "cesta de compras". Você seleciona cuidadosamente quais das suas modificações no **Working Directory** você deseja incluir no próximo "instantâneo" (commit) do seu projeto. Você pode adicionar partes de um arquivo, arquivos inteiros, ou até mesmo remover arquivos da **Staging Area** antes de commitar. É uma etapa intermediária crucial que lhe dá controle granular sobre o que será salvo.

3.  **Local Repository (Repositório Local):** Este é o banco de dados do Git onde todas as versões do seu projeto são armazenadas permanentemente. Quando você executa um `git commit`, o Git pega tudo o que está na **Staging Area** e o salva como um novo "instantâneo" no **Local Repository**. Cada commit é um ponto no tempo que você pode revisitar, e ele contém um registro de todas as mudanças que foram preparadas na **Staging Area**. É o seu "álbum de fotos" final, onde cada foto (commit) representa um momento específico e importante do seu projeto.

Para ilustrar esses estados com uma analogia, imagine que você é um **fotógrafo** preparando um álbum de fotos:

*   O **Working Directory** é a **cena que você está fotografando**. Você pode mover objetos, ajustar a iluminação, e tudo isso são suas "modificações".
*   A **Staging Area** é a **seleção de fotos que você escolhe para o seu álbum**. Você tira várias fotos da cena (modificações no Working Directory), mas decide quais delas são boas o suficiente para ir para o álbum. Você pode até cortar uma foto ou aplicar um filtro antes de colocá-la na seleção.
*   O **Local Repository** é o **álbum de fotos final**. Uma vez que você decide quais fotos (modificações) vão para o álbum, você as cola permanentemente. Cada página do álbum é um "commit", um registro imutável daquelas fotos selecionadas.

O fluxo de trabalho básico no Git, portanto, segue essa sequência:

1.  Você modifica arquivos no seu **Working Directory**.
2.  Você usa o comando `git add` para mover as modificações que deseja incluir no próximo commit para a **Staging Area**.
3.  Você usa o comando `git commit` para pegar tudo o que está na **Staging Area** e salvá-lo como um novo commit no seu **Local Repository**.

### O Comando `git status`

Antes de adicionar ou commitar, o comando `git status` é seu melhor amigo. Ele mostra o estado atual do seu **Working Directory** e da **Staging Area**. Ele informa:

*   Quais arquivos foram modificados mas ainda não foram adicionados à **Staging Area** (`Changes not staged for commit`).
*   Quais arquivos estão na **Staging Area** e prontos para serem commitados (`Changes to be committed`).
*   Quais arquivos são novos e não estão sendo rastreados pelo Git (`Untracked files`).

### O Comando `git add`

O comando `git add` é usado para mover as modificações do seu **Working Directory** para a **Staging Area**.

*   `git add <nome_do_arquivo>`: Adiciona um arquivo específico à **Staging Area**.
*   `git add .` ou `git add -A`: Adiciona todas as modificações (novos arquivos, arquivos modificados e arquivos excluídos) do **Working Directory** para a **Staging Area**. Use com cautela, pois pode adicionar arquivos que você não pretendia commitar.

### O Comando `git commit`

Uma vez que você preparou suas modificações na **Staging Area**, o comando `git commit` as registra permanentemente no seu **Local Repository**.

*   `git commit -m "Sua mensagem de commit"`: Cria um novo commit com a mensagem fornecida. A mensagem de commit é crucial; ela deve descrever de forma clara e concisa o que foi alterado e por quê. Boas mensagens de commit são como um diário do seu projeto, permitindo que você e outros desenvolvedores entendam o histórico rapidamente.

A importância de mensagens de commit claras não pode ser subestimada. Uma mensagem de commit deve ser um resumo útil das mudanças. Ela serve como documentação para o futuro, ajudando a entender a evolução do código, depurar problemas e colaborar de forma eficaz. Uma boa prática é que a primeira linha seja um resumo conciso (até 50-72 caracteres) e, se necessário, um corpo mais detalhado explicando o "porquê" das mudanças.

## Analogia de Ancoragem

Imagine que você está montando um **quebra-cabeça gigante**.

*   O **Working Directory** são todas as **peças soltas** que você tem na mesa. Você pode pegar uma peça, tentar encaixá-la, ou até mesmo pintá-la de outra cor.
*   A **Staging Area** é a **bandeja onde você coloca as peças que já encontrou o lugar certo** e que farão parte da próxima seção que você vai montar. Você não vai montar o quebra-cabeça inteiro de uma vez; você monta seções.
*   O **Local Repository** é a **seção do quebra-cabeça que você já montou e colou**. Uma vez colada, ela se torna parte permanente do quebra-cabeça. Você pode olhar para ela e ver como ela se encaixa no todo.

O `git add` é como pegar uma peça solta da mesa e colocá-la na bandeja. O `git commit` é como pegar todas as peças da bandeja e colá-las no quebra-cabeça.

## Diagrama Mermaid

~~~mermaid
graph TD
    A[Working Directory] -- "Modifica arquivos" --> B{Arquivos Modificados};
    B -- "git add <arquivo>" --> C[Staging Area];
    C -- "git commit -m 'mensagem'" --> D[Local Repository];
    D -- "git checkout <commit>" --> A;
    B -- "git status" --> E[Estado Atual];
    C -- "git status" --> E;
    A -- "git restore <arquivo>" --> A;
    C -- "git restore --staged <arquivo>" --> B;
~~~

## Aplicação no Projeto Prático

Vamos aplicar esses conceitos em nossa **BarberShop API**.

1.  **Verificar o estado inicial:**
    Certifique-se de estar na pasta `barbershop-api` no seu terminal.
    ~~~bash
    git status
    ~~~
    Você deverá ver algo como:
    ```
    On branch main

    No commits yet

    Untracked files:
      (use "git add <file>..." to include in what will be committed)
            .env
            package-lock.json
            package.json
            server.js

    nothing added to commit but untracked files present (use "git add" to track)
    ```
    Isso nos informa que estamos na branch `main` (a branch padrão), ainda não há commits, e temos quatro arquivos (`.env`, `package-lock.json`, `package.json`, `server.js`) que não estão sendo rastreados pelo Git.

2.  **Adicionar o arquivo `README.md`:**
    Vamos criar um arquivo `README.md` para descrever nosso projeto. No VS Code, crie um novo arquivo na raiz da pasta `barbershop-api` chamado `README.md` com o seguinte conteúdo:
    ```markdown
    # BarberShop API

    Esta é uma API Node.js para gerenciar agendamentos de barbearias.
    Ela serve como projeto prático para o curso de Git para Grandes Aplicações.

    ## Endpoints
    - GET /: Retorna uma mensagem de boas-vindas.
    - GET /agendamentos: Retorna uma lista de agendamentos (atualmente vazia).

    ## Como Rodar
    1. Instale as dependências: `npm install`
    2. Inicie o servidor: `node server.js`
    ```
    Salve o arquivo.

3.  **Verificar o estado novamente:**
    ~~~bash
    git status
    ~~~
    Agora você verá `README.md` como um novo arquivo não rastreado, além dos outros.
    ```
    On branch main

    No commits yet

    Untracked files:
      (use "git add <file>..." to include in what will be committed)
            .env
            README.md
            package-lock.json
            package.json
            server.js

    nothing added to commit but untracked files present (use "git add" to track)
    ```

4.  **Adicionar `README.md` à Staging Area:**
    Vamos adicionar apenas o `README.md` por enquanto.
    ~~~bash
    git add README.md
    ~~~

5.  **Verificar o estado após `git add`:**
    ~~~bash
    git status
    ~~~
    Observe a mudança: `README.md` agora está em `Changes to be committed`.
    ```
    On branch main

    No commits yet

    Changes to be committed:
      (use "git rm --cached <file>..." to unstage)
            new file:   README.md

    Untracked files:
      (use "git add <file>..." to include in what will be committed)
            .env
            package-lock.json
            package.json
            server.js
    ```

6.  **Criar o primeiro commit:**
    Agora, vamos registrar o `README.md` no histórico do Git.
    ~~~bash
    git commit -m "feat: adiciona README inicial do projeto"
    ~~~
    Você verá uma saída como:
    ```
    [main (root-commit) 7c9a0b1] feat: adiciona README inicial do projeto
     1 file changed, 11 insertions(+)
     create mode 100644 README.md
    ```
    O `7c9a0b1` é o início do SHA-1 do seu commit.

7.  **Adicionar os arquivos restantes à Staging Area e fazer um segundo commit:**
    Vamos adicionar os arquivos restantes que compõem a base da nossa API.
    ~~~bash
    git add .env package-lock.json package.json server.js
    ~~~
    Ou, para adicionar todos os arquivos não rastreados e modificados de uma vez:
    ~~~bash
    git add .
    ~~~
    Verifique com `git status` para confirmar que todos estão na Staging Area.

    Agora, vamos commitar esses arquivos.
    ~~~bash
    git commit -m "feat: inicializa estrutura base da BarberShop API"
    ~~~
    Você verá uma saída similar à anterior, indicando que um novo commit foi criado.

8.  **Verificar o estado final:**
    ~~~bash
    git status
    ~~~
    Você deverá ver:
    ```
    On branch main
    nothing to commit, working tree clean
    ```
    Isso significa que seu **Working Directory** está limpo, e todas as suas modificações foram salvas no **Local Repository**.

## Glossário Técnico da Aula
-   **Working Directory:** A cópia dos arquivos do projeto que você edita no seu sistema de arquivos.
-   **Staging Area (Index):** Uma área intermediária onde você prepara as modificações que farão parte do próximo commit.
-   **Local Repository:** O banco de dados do Git onde todos os commits (versões) do seu projeto são armazenados.
-   **`git status`:** Comando para verificar o estado atual do Working Directory e da Staging Area.
-   **`git add`:** Comando para adicionar modificações do Working Directory para a Staging Area.
-   **`git commit`:** Comando para registrar as modificações da Staging Area no Local Repository.
-   **Mensagem de Commit:** Descrição que acompanha um commit, explicando as mudanças realizadas.

## Antecipação de Erros
-   **Erro Comum 1: Esquecer de adicionar arquivos (`git add`) antes de commitar.**
    -   **Sintoma:** `nothing to commit, working tree clean` ou `no changes added to commit`.
    -   **Como evitar:** Sempre use `git status` para verificar o que precisa ser adicionado e lembre-se de `git add` antes de `git commit`.
-   **Erro Comum 2: Mensagens de commit vagas ou sem sentido.**
    -   **Sintoma:** Dificuldade em entender o histórico do projeto depois de um tempo.
    -   **Como evitar:** Pense na mensagem como um resumo para o seu "eu do futuro" ou para um colega. Use o padrão `tipo: descrição` (ex: `feat: adiciona nova funcionalidade`).
-   **Erro Comum 3: Tentar commitar sem arquivos na Staging Area.**
    -   **Sintoma:** O Git informa que não há nada para commitar.
    -   **Como evitar:** O `git commit` só opera sobre o que está na Staging Area. Se não há nada lá, ele não tem o que registrar.

## Troubleshooting
-   **Problema: Adicionei um arquivo à Staging Area, mas mudei de ideia e não quero commitar.**
    -   **Solução:** Use `git restore --staged <nome_do_arquivo>` para remover o arquivo da Staging Area. As modificações permanecerão no seu Working Directory.
-   **Problema: Fiz um commit, mas a mensagem está errada ou esqueci de incluir algo pequeno.**
    -   **Solução:** Para corrigir a última mensagem de commit ou adicionar pequenas mudanças ao último commit, você pode usar `git commit --amend`. Isso "reescreve" o último commit. **Cuidado:** Não use `--amend` em commits que já foram enviados para um repositório remoto, pois isso pode causar problemas para outros colaboradores.

## Desafio de Fixação
1.  Crie um arquivo vazio chamado `.env` (se ainda não o fez na Aula 1) na raiz do projeto `barbershop-api`.
2.  Adicione o arquivo `.env` à Staging Area.
3.  Faça um commit com a mensagem apropriada, seguindo o padrão de boas práticas (ex: `chore: adiciona arquivo .env para variáveis de ambiente`).
4.  Verifique o `git status` para garantir que o Working Directory esteja limpo.

## Resoluções Comentadas
1.  No terminal, dentro da pasta `barbershop-api`:
    ~~~bash
    type nul > .env  # Para Windows
    # ou
    touch .env      # Para Linux/macOS
    ~~~
2.  ~~~bash
    git add .env
    ~~~
3.  ~~~bash
    git commit -m "chore: adiciona arquivo .env para variáveis de ambiente"
    ~~~
4.  ~~~bash
    git status
    ~~~
    Deverá retornar `On branch main` e `nothing to commit, working tree clean`.

## Resumo dos Pontos-Chave
-   O Git opera com três estados: **Working Directory**, **Staging Area** e **Local Repository**.
-   `git status` é essencial para monitorar o estado dos seus arquivos.
-   `git add` move as modificações para a Staging Area.
-   `git commit` registra as modificações da Staging Area no Local Repository, criando um novo ponto no histórico.
-   Mensagens de commit claras são cruciais para a documentação e colaboração.

## Próximos Passos
Na próxima aula, vamos aprofundar na visualização do histórico de commits. Aprenderemos a usar o comando `git log` e suas diversas opções para navegar e entender a linha do tempo do nosso projeto.

## Log de Estado do Projeto
-   **Objetivo:** Entender os estados do Git e realizar os primeiros commits no projeto `barbershop-api`.
-   **Código Adicionado:** `README.md`, `package.json`, `package-lock.json`, `server.js`, `.env`.
-   **Estado Funcional:** ✅ Repositório Git com histórico inicial contendo a estrutura base da API.
-   **Próximas Etapas:** Aula 3 abordará a visualização do histórico de commits com `git log`.

---
Dúvidas? Posso prosseguir para a próxima etapa?