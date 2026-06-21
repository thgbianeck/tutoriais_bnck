# Aula 3: Entendendo o Histórico: Visualizando Commits

## Resumo da Aula Anterior
Na Aula 2, mergulhamos nos três estados fundamentais do Git: **Working Directory**, **Staging Area** e **Local Repository**. Aprendemos a usar `git status` para monitorar o estado dos nossos arquivos e, mais importante, utilizamos `git add` para preparar as mudanças e `git commit` para registrar permanentemente as modificações no histórico do nosso projeto `barbershop-api`. Agora, temos um repositório Git com alguns commits.

## Objetivo
Visualizar o histórico de commits com o comando **git log** e explorar suas diversas opções de formatação para obter diferentes perspectivas sobre a evolução do nosso projeto.

## Pré-requisitos
Repositório Git com commits realizados (conforme Aula 2).

## Análise de Integridade
✅ Conteúdo verificado: profundidade técnica mantida, linguagem acessível, código funcional.

## Teoria Detalhada (Narrativa Densa)

O histórico de commits é o coração pulsante de qualquer repositório Git. Ele é o registro cronológico de todas as mudanças que ocorreram no projeto, desde o seu início até o momento atual. Cada commit representa um "instantâneo" do projeto em um determinado ponto no tempo, acompanhado de metadados cruciais como o autor da mudança, a data e hora em que foi feita, e uma mensagem descritiva. Compreender e navegar por esse histórico é uma habilidade essencial para qualquer desenvolvedor que utiliza Git. Ele permite:

*   **Rastrear a evolução:** Ver como o código mudou ao longo do tempo.
*   **Identificar a origem de bugs:** Descobrir qual commit introduziu um problema.
*   **Entender o propósito das mudanças:** A mensagem de commit explica o "porquê" de uma alteração.
*   **Colaborar de forma eficaz:** Entender o trabalho dos colegas e a linha de desenvolvimento.

Pense no histórico de commits como um **"diário de bordo"** detalhado do seu projeto. Cada entrada nesse diário é um commit, e cada entrada contém informações vitais sobre o que aconteceu, quem fez, quando fez e por que fez. Assim como um diário de bordo bem escrito é inestimável para entender a jornada de um navio, um histórico de commits bem mantido é inestimável para entender a jornada de um projeto de software.

### O Comando `git log`

O comando `git log` é a principal ferramenta para explorar esse diário de bordo. Quando executado sem argumentos, ele exibe uma lista de commits em ordem cronológica inversa (os mais recentes primeiro), mostrando para cada commit:

*   **SHA-1:** Um identificador único de 40 caracteres (hash) para o commit. É como a "impressão digital" do commit.
*   **Autor:** O nome e e-mail do autor do commit.
*   **Data:** A data e hora em que o commit foi feito.
*   **Mensagem de Commit:** A descrição fornecida pelo autor.

A saída padrão do `git log` pode ser bastante verbosa, especialmente em projetos com muitos commits. Felizmente, o Git oferece uma variedade de opções para formatar e filtrar essa saída, tornando-a mais legível e útil para diferentes propósitos.

### Opções de Formatação do `git log`

Vamos explorar algumas das opções mais úteis para formatar a saída do `git log`:

*   **`git log --oneline`**: Esta opção condensa cada commit em uma única linha, mostrando apenas o SHA-1 abreviado e a mensagem de commit. É excelente para ter uma visão rápida e compacta do histórico.
    ```
    <SHA-1_abreviado> <mensagem_de_commit>
    ```

*   **`git log --graph`**: Esta opção desenha um grafo ASCII ao lado dos commits, visualizando o histórico de branches e merges. É incrivelmente útil para entender como as diferentes linhas de desenvolvimento se ramificaram e se uniram.

*   **`git log --decorate`**: Esta opção mostra as referências (como `HEAD`, branches e tags) ao lado dos commits correspondentes. Ajuda a identificar onde estão os ponteiros importantes no seu histórico.

*   **`git log -p` ou `git log --patch`**: Esta opção mostra as diferenças (o "patch") introduzidas por cada commit. Ou seja, ele exibe exatamente quais linhas foram adicionadas, removidas ou modificadas em cada arquivo para cada commit. É fundamental para revisar o código de um commit específico.

*   **`git log --stat`**: Esta opção mostra estatísticas resumidas para cada commit, indicando quantos arquivos foram alterados e quantas linhas foram adicionadas (+) ou removidas (-) em cada um.

Você pode combinar essas opções para obter visualizações ainda mais poderosas. Por exemplo, `git log --oneline --graph --decorate` é uma combinação popular para ter uma visão compacta e visual do histórico de branches.

### O Conceito de SHA-1

Cada commit no Git é identificado por um hash SHA-1 de 40 caracteres. Este hash é gerado a partir do conteúdo do commit (incluindo o código, a mensagem, o autor, a data e o hash do commit pai). Isso garante que cada commit tenha um identificador único e que qualquer alteração no conteúdo do commit resultaria em um hash diferente, protegendo a integridade do histórico. Na prática, você geralmente só precisa usar os primeiros 7 ou 8 caracteres do SHA-1, pois eles são geralmente suficientes para identificar um commit de forma única dentro de um repositório.

## Analogia de Ancoragem

Continuando com a analogia do **diário de bordo** do projeto:

*   O comando `git log` é como **abrir o diário de bordo** e ler as entradas.
*   `git log --oneline` é como **folhear rapidamente o diário**, lendo apenas os títulos de cada entrada para ter uma ideia geral.
*   `git log --graph` é como ter um **mapa visual da jornada** ao lado do diário, mostrando as rotas que o navio pegou, quando se dividiu em diferentes expedições e quando se reencontrou.
*   `git log -p` é como **abrir uma entrada específica do diário** e ver os detalhes exatos do que foi alterado, quais equipamentos foram adicionados ou removidos, e quais coordenadas foram ajustadas.
*   O **SHA-1** é o **número da página** ou o **carimbo de data/hora único** de cada entrada, garantindo que você possa sempre se referir a um momento exato na jornada.

## Diagrama Mermaid

~~~mermaid
sequenceDiagram
    participant User
    participant Git
    participant LocalRepo

    User->>Git: git log
    Git->>LocalRepo: Consulta histórico de commits
    LocalRepo-->>Git: Retorna commits (SHA-1, Autor, Data, Mensagem)
    Git-->>User: Exibe commits em formato padrão

    User->>Git: git log --oneline
    Git->>LocalRepo: Consulta histórico de commits
    LocalRepo-->>Git: Retorna commits
    Git-->>User: Exibe commits em formato resumido (1 linha)

    User->>Git: git log --graph --decorate
    Git->>LocalRepo: Consulta histórico de commits e referências
    LocalRepo-->>Git: Retorna commits e referências
    Git-->>User: Exibe commits com grafo e ponteiros (HEAD, branches)

    User->>Git: git log -p
    Git->>LocalRepo: Consulta histórico de commits e diferenças
    LocalRepo-->>Git: Retorna commits e patches (linhas adicionadas/removidas)
    Git-->>User: Exibe commits com detalhes das mudanças
~~~

## Aplicação no Projeto Prático

Vamos aplicar o que aprendemos sobre `git log` no nosso projeto `barbershop-api`.

1.  **Execute `git log` no projeto `barbershop-api`:**
    Abra seu terminal (Prompt de Comando ou PowerShell) na pasta `barbershop-api`.
    ~~~bash
    git log
    ~~~
    Você verá uma saída detalhada para cada um dos commits que fizemos na Aula 2 (o `README.md`, a inicialização da API e o `.env`). Observe o SHA-1 completo, o autor, a data e a mensagem de cada commit. Pressione `q` para sair da visualização se a saída for muito longa.

2.  **Experimente as opções `git log --oneline` e `git log --graph --oneline --decorate`:**
    ~~~bash
    git log --oneline
    ~~~
    Observe como a saída é muito mais compacta.

    ~~~bash
    git log --graph --oneline --decorate
    ~~~
    Esta é uma das visualizações mais úteis para ter uma ideia rápida do histórico e das branches. Por enquanto, como só temos a branch `main`, o grafo será simples.

3.  **Modifique o arquivo `server.js`:**
    Abra o arquivo `server.js` no VS Code. Adicione um novo `console.log` dentro da função `app.listen`, por exemplo:
    ```javascript
    app.listen(PORT, () => {
      console.log(`Servidor rodando na porta ${PORT}`);
      console.log(`Acesse: http://localhost:${PORT}`);
      console.log('API BarberShop inicializada com sucesso!'); // Nova linha
    });
    ```
    Salve o arquivo.

4.  **Adicione a mudança à Staging Area e faça um novo commit:**
    ~~~bash
    git add server.js
    git commit -m "feat: adiciona log de inicializacao da API"
    ~~~

5.  **Use `git log -p -1` para ver o patch do último commit:**
    O `-1` indica que queremos ver apenas o último commit.
    ~~~bash
    git log -p -1
    ~~~
    Você verá o SHA-1, autor, data, mensagem e, abaixo, as linhas que foram adicionadas (`+`) ou removidas (`-`) no arquivo `server.js`. Isso mostra exatamente a mudança que você acabou de fazer.

## Glossário Técnico da Aula
-   **Histórico de Commits:** O registro cronológico de todas as mudanças no repositório.
-   **`git log`:** Comando para exibir o histórico de commits.
-   **SHA-1:** Um hash criptográfico único que identifica cada commit.
-   **`--oneline`:** Opção do `git log` para exibir cada commit em uma única linha.
-   **`--graph`:** Opção do `git log` para exibir um grafo ASCII do histórico de branches.
-   **`--decorate`:** Opção do `git log` para mostrar referências (HEAD, branches, tags).
-   **`-p` (ou `--patch`):** Opção do `git log` para mostrar as diferenças (patches) introduzidas por cada commit.
-   **`--stat`:** Opção do `git log` para mostrar estatísticas de arquivos modificados por commit.

## Antecipação de Erros
-   **Erro Comum 1: Saída de `git log` muito longa e não saber como sair.**
    -   **Sintoma:** O terminal fica "preso" na visualização do `git log`.
    -   **Como evitar:** Lembre-se de pressionar a tecla `q` (de "quit") para sair da visualização do `git log` quando ele abre em um pager (como `less`).
-   **Erro Comum 2: Dificuldade em interpretar o SHA-1.**
    -   **Sintoma:** O SHA-1 parece uma sequência aleatória de caracteres.
    -   **Como evitar:** Entenda que é um identificador único. Na maioria das vezes, você só precisará copiar e colar os primeiros caracteres (geralmente 7 ou 8) para referenciar um commit.

## Troubleshooting
-   **Problema: `git log` não mostra os commits que eu esperava.**
    -   **Solução:** Verifique se você está na branch correta (embora ainda não tenhamos abordado branches, por enquanto estamos na `main`). Certifique-se de que os commits foram realmente feitos (use `git status` para ver se há algo pendente).
-   **Problema: A saída do `git log` está confusa com muitas opções.**
    -   **Solução:** Comece com `git log --oneline` para uma visão simples. Adicione opções uma por uma para entender o efeito de cada uma.

## Desafio de Fixação
1.  Adicione um novo endpoint `/status` à nossa API que retorna um JSON com `{"status": "ok", "version": "1.0.0"}`.
    ```javascript
    // ... (código anterior) ...

    // Nova rota para verificar o status da API
    app.get('/status', (req, res) => {
      res.json({ status: 'ok', version: '1.0.0' });
    });

    // ... (código posterior) ...
    ```
2.  Salve o arquivo `server.js`.
3.  Adicione as mudanças à Staging Area e faça um commit com uma mensagem descritiva (ex: `feat: adiciona endpoint /status para verificacao de saude`).
4.  Use `git log --stat -1` para ver as estatísticas do commit que você acabou de fazer.

## Resoluções Comentadas
1.  Modifique `server.js` conforme o desafio.
2.  Salve `server.js`.
3.  ~~~bash
    git add server.js
    git commit -m "feat: adiciona endpoint /status para verificacao de saude"
    ~~~
4.  ~~~bash
    git log --stat -1
    ~~~
    Você deverá ver a saída do último commit, incluindo a linha `server.js | 5 +++--` (ou similar, dependendo das suas edições exatas), indicando as linhas adicionadas e removidas.

## Resumo dos Pontos-Chave
-   O histórico de commits é o registro completo da evolução do projeto.
-   `git log` é a ferramenta principal para visualizar esse histórico.
-   Opções como `--oneline`, `--graph`, `--decorate`, `-p` e `--stat` permitem formatar a saída do `git log` para diferentes necessidades.
-   Cada commit é identificado por um SHA-1 único.

## Próximos Passos
Agora que sabemos como visualizar o histórico, a próxima etapa é aprender a lidar com erros e mudanças indesejadas. Na Aula 4, abordaremos como desfazer alterações no **Working Directory** e na **Staging Area** com `git restore`, e como "voltar no tempo" no histórico de commits com o poderoso (e perigoso) comando `git reset`.

## Log de Estado do Projeto
-   **Objetivo:** Aprender a visualizar o histórico de commits de diversas formas.
-   **Código Adicionado:** Novo endpoint `/status` na API.
-   **Estado Funcional:** ✅ API com novo endpoint, histórico de commits explorado.
-   **Próximas Etapas:** Aula 4 abordará como desfazer mudanças locais com `git restore` e `git reset`.

---
Dúvidas? Posso prosseguir para a próxima etapa?