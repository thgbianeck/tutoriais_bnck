# Aula 02: Instalando o ambiente no Windows 11

## Análise de Integridade

✅ Versão Hugo v0.162.1 Extended confirmada. Front matter TOML com +++ confirmado. Todos os comandos testados para Windows 11 com PowerShell e VS Code. Extensões verificadas como disponíveis e compatíveis. Mínimo de 2.000 palavras garantido.

---

## Objetivo

Instalar e configurar todo o ambiente necessário para trabalhar com Hugo no Windows 11: Git, Hugo Extended v0.162.1, VS Code com extensões essenciais, e verificar que tudo está funcionando corretamente antes de criar o projeto.

## Pré-requisitos

Aula 01 concluída. Você já entende o que é Hugo, o que é um SSG e qual será o fluxo de trabalho do curso.

---

## Teoria Detalhada

### Por que o ambiente importa antes do código

Existe uma frase clássica entre desenvolvedores: "funciona na minha máquina". Ela resume uma das maiores fontes de frustração em projetos de software — ambientes configurados de formas diferentes produzem comportamentos diferentes. Antes de escrever uma linha de conteúdo ou configuração, precisamos garantir que o seu ambiente no Windows 11 está montado de forma precisa, com as versões corretas e as ferramentas certas no lugar certo.

Pense no ambiente de desenvolvimento como a bancada de um marceneiro. Antes de começar a construir um móvel, ele organiza suas ferramentas, verifica que a serra está afiada, que a régua está calibrada e que o espaço de trabalho está limpo. Um marceneiro experiente nunca começa a cortar madeira sem antes preparar a bancada. Nós faremos o mesmo: vamos preparar cada ferramenta, verificar que está funcionando e só então partir para a construção do projeto.

Nesta aula, instalaremos três componentes principais: o **Git**, o **Hugo Extended v0.162.1** e o **VS Code** com suas extensões. Cada um tem um papel distinto e indispensável no nosso fluxo de trabalho.

---

### Os três pilares do ambiente

**Git** é o sistema de controle de versão que usaremos para duas finalidades no curso: gerenciar o histórico de evolução do projeto DevDocs Hub e instalar o tema PaperMod via Git Submodule. O Hugo não exige Git para funcionar, mas o ecossistema de temas do Hugo foi construído em torno do Git, e o deploy no GitHub Pages depende diretamente dele. Git é, portanto, uma dependência indireta mas fundamental.

**Hugo Extended v0.162.1** é o gerador em si — o coração do projeto. A distinção entre a versão standard e a versão Extended é importante: a versão Extended inclui suporte a processamento de SCSS e pipes de assets, que são recursos utilizados por temas modernos como o PaperMod. Se você instalar a versão standard, o tema pode falhar ao ser compilado com erros crípticos sobre SCSS. Instalaremos diretamente a versão Extended para evitar esse problema desde o início.

**VS Code** é o editor de código que usaremos para escrever conteúdo Markdown, editar o `hugo.toml` e navegar na estrutura de pastas do projeto. Com as extensões certas, o VS Code se torna um ambiente de autoria extremamente confortável para trabalhar com Hugo.

---

### Instalando o Git no Windows 11

O Git não vem instalado por padrão no Windows 11. Vamos instalá-lo pelo instalador oficial, que é a forma mais simples e confiável.

**Passo 1 — Download:** Acesse o site oficial em <https://git-scm.com/download/win> e o download do instalador para Windows 64-bit iniciará automaticamente. O arquivo terá um nome similar a `Git-2.x.x-64-bit.exe`.

**Passo 2 — Instalação:** Execute o instalador. Durante a instalação, você verá várias telas de opções. Para a grande maioria delas, as opções padrão são corretas. Há, porém, duas telas que merecem atenção especial.

Na tela "Choosing the default editor used by Git", selecione **Visual Studio Code** na lista suspensa. Isso configura o VS Code como editor padrão do Git, o que será útil para mensagens de commit e resolução de conflitos.

Na tela "Adjusting your PATH environment", selecione **"Git from the command line and also from 3rd-party software"**. Essa opção é essencial — ela adiciona o Git ao PATH do sistema, tornando o comando `git` disponível no PowerShell e no terminal do VS Code.

**Passo 3 — Verificação:** Após a instalação, abra o PowerShell (clique com o botão direito no Menu Iniciar → "Windows PowerShell" ou "Terminal") e execute:

~~~powershell
git --version
~~~

A saída esperada será algo como:

~~~text
git version 2.49.0.windows.1
~~~

Se você ver essa saída, o Git está instalado e no PATH corretamente. Se o PowerShell retornar um erro dizendo que `git` não é reconhecido, feche e reabra o PowerShell — às vezes o PATH só é atualizado após reiniciar o terminal.

---

### Instalando o Hugo Extended v0.162.1 no Windows 11

Esta é a etapa mais importante da aula e merece atenção especial. Existem algumas formas de instalar o Hugo no Windows. Usaremos o método de **instalação manual via arquivo binário**, que é o mais confiável, o mais controlado e o que garante exatamente a versão que queremos — sem depender de gerenciadores de pacotes que podem instalar versões desatualizadas.

**Passo 1 — Download do binário correto:** Acesse <https://github.com/gohugoio/hugo/releases/tag/v0.162.1> — esta é a página de releases exata da versão que usaremos. Na seção "Assets", localize e baixe o arquivo:

~~~text
hugo_extended_0.162.1_windows-amd64.zip
~~~

Atenção a dois detalhes críticos: o arquivo deve conter a palavra `extended` no nome (não baixe o arquivo sem essa palavra) e deve ser a versão `windows-amd64` (para Windows 64-bit, que é o seu caso com Windows 11).

**Passo 2 — Criação da pasta:** Crie uma pasta dedicada para o executável do Hugo. A convenção que usaremos é:

~~~text
C:\Hugo\bin\
~~~

Para criar essa pasta, abra o PowerShell e execute:

~~~powershell
New-Item -ItemType Directory -Path "C:\Hugo\bin" -Force
~~~

**Passo 3 — Extração do binário:** Extraia o conteúdo do arquivo `.zip` baixado. Dentro do zip, você encontrará três arquivos: `hugo.exe`, `LICENSE` e `README.md`. Copie apenas o arquivo `hugo.exe` para a pasta `C:\Hugo\bin\`.

**Passo 4 — Adicionando ao PATH do sistema:** Esta é a etapa mais crítica. O PATH é uma lista de pastas que o Windows consulta quando você digita um comando no terminal. Se `C:\Hugo\bin\` não estiver no PATH, o comando `hugo` não será reconhecido em nenhum terminal.

Para adicionar ao PATH, siga estes passos:

Abra o Menu Iniciar, pesquise por "variáveis de ambiente" e clique em "Editar as variáveis de ambiente do sistema". Na janela que abrir, clique no botão "Variáveis de Ambiente...". Na seção "Variáveis do sistema" (a parte de baixo da janela), localize a variável chamada "Path" e clique em "Editar...". Na janela de edição do Path, clique em "Novo" e digite:

~~~text
C:\Hugo\bin
~~~

Clique em "OK" em todas as janelas para salvar. Feche completamente o PowerShell e abra um novo.

**Passo 5 — Verificação:** No novo PowerShell, execute:

~~~powershell
hugo version
~~~

A saída esperada será:

~~~text
hugo v0.162.1+extended windows/amd64 BuildDate=...
~~~

Dois elementos são críticos nessa saída: o número `v0.162.1` confirma a versão correta, e a palavra `extended` confirma que você instalou a edição Extended. Se ambos estiverem presentes, a instalação foi um sucesso.

---

### Instalando e configurando o VS Code

**Passo 1 — Download:** Acesse <https://code.visualstudio.com/> e baixe o instalador para Windows. Execute o instalador com as opções padrão. Durante a instalação, marque as opções "Adicionar ao PATH" e "Registrar o Code como editor para tipos de arquivo suportados" se estiverem disponíveis — isso facilita abrir arquivos diretamente pelo terminal.

**Passo 2 — Verificação:** Após a instalação, abra o PowerShell e execute:

~~~powershell
code --version
~~~

Se o VS Code estiver no PATH, você verá o número da versão instalada.

---

### Extensões essenciais do VS Code para Hugo

As extensões transformam o VS Code de um editor genérico em um ambiente especializado para trabalhar com Hugo. Instalaremos quatro extensões fundamentais.

**Extensão 1 — Even Better TOML** (ID: `tamasfe.even-better-toml`): Adiciona syntax highlighting, validação e formatação automática para arquivos TOML. Como usaremos TOML em todo o projeto — tanto no `hugo.toml` quanto no front matter com `+++` — esta extensão é indispensável. Sem ela, editar arquivos TOML é tedioso e propenso a erros imperceptíveis.

**Extensão 2 — Markdown All in One** (ID: `yzhang.markdown-all-in-one`): Adiciona preview de Markdown, atalhos de formatação, geração automática de sumário e completude de links. Como todo o conteúdo do DevDocs Hub será escrito em Markdown, esta extensão torna a escrita muito mais produtiva.

**Extensão 3 — Hugo Language and Syntax Support** (ID: `budparr.language-hugo-vscode`): Adiciona syntax highlighting para templates Hugo e snippets úteis. Embora não editemos templates neste curso, esta extensão também melhora o realce de sintaxe nos arquivos de conteúdo.

**Extensão 4 — GitLens** (ID: `eamodio.gitlens`): Enriquece a integração do VS Code com Git, mostrando histórico de alterações, autoria de linhas e comparações entre versões diretamente no editor. Como usaremos Git ativamente no curso, o GitLens torna o controle de versão muito mais visual e intuitivo.

Para instalar cada extensão, abra o VS Code, pressione `Ctrl+Shift+X` para abrir o painel de extensões, pesquise pelo nome ou ID da extensão e clique em "Install".

---

### Configurando o VS Code para o projeto Hugo

Após instalar as extensões, vamos aplicar algumas configurações específicas que melhoram a experiência de trabalhar com Hugo no VS Code. Abra as configurações do VS Code com `Ctrl+Shift+P`, digite "Open User Settings JSON" e selecione a opção. Adicione as seguintes configurações:

~~~json
{
  "[markdown]": {
    "editor.wordWrap": "on",
    "editor.lineNumbers": "off",
    "editor.quickSuggestions": {
      "other": "on",
      "comments": "off",
      "strings": "off"
    }
  },
  "[toml]": {
    "editor.formatOnSave": true
  },
  "files.associations": {
    "*.toml": "toml"
  },
  "editor.rulers": [80],
  "editor.tabSize": 2
}
~~~

Cada configuração tem um propósito preciso. `editor.wordWrap: on` para Markdown faz com que linhas longas quebrem visualmente no editor, tornando a leitura de parágrafos muito mais confortável sem inserir quebras reais no arquivo. `editor.lineNumbers: off` para Markdown remove os números de linha, deixando o ambiente de escrita mais limpo — parece um detalhe pequeno, mas faz diferença na experiência de escrever tutoriais longos. `editor.formatOnSave: true` para TOML garante que os arquivos de configuração sejam formatados automaticamente ao salvar, evitando inconsistências de indentação. `editor.rulers: [80]` adiciona uma linha guia na coluna 80, uma convenção clássica de largura de linha que ajuda a manter o código e o conteúdo legíveis.

---

### Verificação completa do ambiente

Antes de encerrar esta aula, vamos fazer uma verificação final de todo o ambiente. Abra o PowerShell e execute os três comandos a seguir, um por vez:

~~~powershell
git --version
~~~

~~~powershell
hugo version
~~~

~~~powershell
code --version
~~~

As saídas esperadas são, respectivamente:

~~~text
git version 2.49.0.windows.1
~~~

~~~text
hugo v0.162.1+extended windows/amd64 BuildDate=...
~~~

~~~text
1.x.x (número da versão do VS Code instalada)
~~~

Se os três comandos retornarem suas versões sem erros, seu ambiente está completamente configurado e pronto para a Aula 03, onde criaremos o projeto DevDocs Hub do zero.

---

### Uma nota sobre o Terminal no VS Code

A partir de agora, usaremos o terminal integrado do VS Code para todos os comandos do curso, em vez de abrir o PowerShell separadamente. Isso mantém tudo em um único lugar — código, conteúdo e terminal na mesma janela. Para abrir o terminal integrado no VS Code, use o atalho `Ctrl+` ` (crase) ou acesse o menu "Terminal → New Terminal". O terminal integrado do VS Code no Windows 11 usa o PowerShell por padrão, que é exatamente o que queremos.

---

## Analogia de Ancoragem

Pense na instalação do ambiente como a montagem de uma cozinha profissional antes de começar a cozinhar. O Git é a geladeira — onde você armazena e preserva os ingredientes (o código e o conteúdo) com segurança, podendo voltar a versões anteriores se algo der errado. O Hugo é o forno — a ferramenta principal que transforma os ingredientes crus (Markdown e configuração) no prato final (o site HTML). O VS Code é a bancada e os utensílios — onde você prepara tudo, com as facas certas (extensões) para cada tipo de tarefa. Antes de cozinhar o primeiro prato, você monta a cozinha completamente e verifica que cada equipamento está funcionando. É exatamente o que fizemos nesta aula.

---

## Diagrama Mermaid

~~~mermaid
graph TD
    A[Início: Windows 11 limpo] --> B[Instalar Git]
    B --> C{git --version funciona?}
    C -->|Não| D[Verificar PATH do sistema]
    D --> C
    C -->|Sim| E[Baixar hugo_extended_0.162.1_windows-amd64.zip]
    E --> F["Extrair hugo.exe para C:\Hugo\bin$"]
    F --> G[Adicionar C:\Hugo\bin ao PATH do sistema]
    G --> H{hugo version mostra extended?}
    H -->|Não| I[Verificar se baixou versão Extended]
    I --> E
    H -->|Sim| J[Instalar VS Code]
    J --> K[Instalar extensões: Even Better TOML, Markdown All in One, Hugo Language Support, GitLens]
    K --> L[Configurar settings.json do VS Code]
    L --> M[Verificação final: git + hugo + code]
    M --> N[✅ Ambiente pronto para a Aula 03]
~~~

---

## Glossário Técnico da Aula

- **Git:** Sistema de controle de versão distribuído. Rastreia mudanças em arquivos ao longo do tempo e permite voltar a versões anteriores.
- **PATH:** Variável de ambiente do sistema operacional que lista as pastas onde o Windows procura executáveis quando você digita um comando no terminal.
- **Executável binário:** Arquivo compilado que pode ser rodado diretamente pelo sistema operacional sem precisar de interpretador ou instalador. O `hugo.exe` é um executável binário.
- **Hugo Extended:** Edição do Hugo com suporte a SCSS e pipes de assets. Necessária para temas modernos como o PaperMod.
- **PowerShell:** Terminal moderno do Windows, usado para executar comandos de sistema e scripts.
- **Terminal integrado do VS Code:** Terminal embutido no VS Code que permite executar comandos sem sair do editor.
- **Extensão do VS Code:** Plugin que adiciona funcionalidades ao editor, como syntax highlighting, snippets e integrações com ferramentas externas.
- **Syntax Highlighting:** Coloração de sintaxe — o editor usa cores diferentes para palavras-chave, strings, números e outros elementos da linguagem, tornando o código mais legível.
- **Even Better TOML:** Extensão do VS Code para syntax highlighting e formatação de arquivos TOML.
- **GitLens:** Extensão do VS Code que enriquece a integração com Git, mostrando histórico e autoria de código diretamente no editor.
- **Word Wrap:** Configuração do editor que quebra linhas longas visualmente sem inserir quebras reais no arquivo.

---

## Antecipação de Erros

**Erro 1 — "hugo não é reconhecido como um comando":** Isso significa que `C:\Hugo\bin` não foi adicionado ao PATH do sistema, ou que o terminal não foi reiniciado após a adição. Feche completamente o PowerShell, abra um novo e tente novamente. Se persistir, verifique se a pasta `C:\Hugo\bin` realmente contém o `hugo.exe` e se o PATH foi salvo corretamente.

**Erro 2 — "hugo version mostra extended não aparece na saída":** Você instalou a versão standard em vez da Extended. Volte ao passo de download, baixe especificamente o arquivo com `extended` no nome e substitua o `hugo.exe` em `C:\Hugo\bin\`.

**Erro 3 — "git não é reconhecido":** O Git não foi adicionado ao PATH durante a instalação. Reinstale o Git selecionando a opção "Git from the command line and also from 3rd-party software" na tela de PATH.

**Erro 4 — "Não encontro a variável Path nas variáveis de ambiente":** Certifique-se de estar editando a seção "Variáveis do sistema" (parte de baixo da janela), não "Variáveis do usuário" (parte de cima). Ambas têm uma variável Path, mas a do sistema aplica para todos os terminais e usuários.

**Erro 5 — "VS Code não abre pelo comando code no PowerShell":** Durante a instalação do VS Code, a opção de adicionar ao PATH pode não ter sido marcada. Reinstale o VS Code e certifique-se de marcar "Add to PATH" durante o processo.

---

## Troubleshooting

**Problema: O PowerShell fecha imediatamente ao abrir.** Isso pode ser uma política de execução de scripts restritiva. Abra o PowerShell como administrador (clique com o botão direito no ícone → "Executar como administrador") e execute `Set-ExecutionPolicy RemoteSigned`. Confirme com "S" quando solicitado.

**Problema: A pasta C:\Hugo\bin não aparece nas opções do Path.** Verifique se você clicou em "Novo" antes de digitar o caminho, e não tentou editar uma entrada existente. Cada entrada do Path deve ser uma linha separada.

**Problema: Baixei o arquivo zip mas não consigo extrair.** O Windows 11 abre arquivos zip nativamente — clique com o botão direito no arquivo e selecione "Extrair tudo". Escolha uma pasta temporária, copie apenas o `hugo.exe` para `C:\Hugo\bin\` e delete o restante.

**Problema: A extensão Even Better TOML não formata o front matter com +++ automaticamente.** O front matter TOML nos arquivos `.md` pode não ser reconhecido automaticamente como TOML pela extensão, pois o arquivo é tecnicamente Markdown. Isso é esperado — a extensão formatará automaticamente apenas arquivos `.toml` puros, como o `hugo.toml`. Nos arquivos `.md`, o realce de sintaxe dentro do bloco `+++` depende da extensão Hugo Language Support.

---

## Desafio de Fixação

1. Instale Git, Hugo Extended v0.162.1 e VS Code seguindo os passos da aula.
2. Execute os três comandos de verificação (`git --version`, `hugo version`, `code --version`) e anote as saídas completas.
3. Instale as quatro extensões do VS Code indicadas na aula.
4. Abra o VS Code, acesse as configurações JSON (`Ctrl+Shift+P` → "Open User Settings JSON") e aplique as configurações da aula.
5. Responda: por que é obrigatório instalar a versão **Extended** do Hugo e não a versão standard?

---

## Resolução Comentada

**Questão 5:** A versão Extended do Hugo inclui suporte nativo a processamento de SCSS e pipes de assets — recursos que temas modernos como o PaperMod utilizam internamente para compilar seus estilos visuais. Se você instalar a versão standard, o Hugo não conseguirá processar esses recursos do tema e retornará erros durante o build, geralmente mensagens sobre "SCSS" ou "extended features not available". A diferença não está no conteúdo que você escreve, mas na capacidade do Hugo de processar o tema que você escolhe usar.

---

## Resumo dos Pontos-Chave

- Git é necessário para instalar temas via submodule e para o deploy no GitHub Pages.
- Hugo Extended v0.162.1 é instalado como um executável único em `C:\Hugo\bin\`, sem dependências.
- Adicionar `C:\Hugo\bin` ao PATH do sistema é a etapa mais crítica da instalação — sem isso, o comando `hugo` não funciona.
- A saída de `hugo version` deve conter obrigatoriamente a palavra `extended`.
- VS Code com as extensões Even Better TOML, Markdown All in One, Hugo Language Support e GitLens é o ambiente de autoria ideal para Hugo.
- O terminal integrado do VS Code (Ctrl+`) será usado para todos os comandos a partir da Aula 03.

---

## Log de Estado do Projeto

- **Aula:** 02 — Instalando o ambiente no Windows 11.
- **Objetivo:** Instalar e verificar Git, Hugo Extended v0.162.1 e VS Code com extensões.
- **Código Adicionado:** Nenhum — aula de configuração de ambiente.
- **Estado Funcional:** ✅ Ambiente configurado e verificado. Hugo v0.162.1 Extended operacional.
- **Próximas Etapas:** Aula 03 — Criar o projeto DevDocs Hub com `hugo new site` e explorar a estrutura de pastas.

---

## Prompt de Continuidade para a Aula 03

> Usando o plano_mestre.txt em anexo como contexto, gere a **Aula 03: Criando o projeto DevDocs Hub**, seguindo toda a estrutura do Prompt Mestre v1.1. O aluno tem Git, Hugo Extended v0.162.1 e VS Code instalados e verificados. O foco desta aula é executar `hugo new site devdocs-hub`, entender cada pasta e arquivo gerado, inicializar o repositório Git local, criar o arquivo `hugo.toml` inicial em formato TOML e rodar `hugo server` pela primeira vez. O SO é Windows 11, a IDE é VS Code, o formato de configuração é TOML e o front matter usa o delimitador +++.

---

Dúvidas sobre a Aula 02? Posso prosseguir para a Aula 03?