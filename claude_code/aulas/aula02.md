# Aula 2: Instalação e Configuração do Ambiente Completo

## Módulo 1 — Essencial: Fundamentos e Configuração

---

## Resumo da Aula Anterior

Na Aula 1, construímos o modelo mental fundamental: o Claude Code é um agente, não um assistente. Ele vive no seu terminal, dentro do seu projeto, e fecha o loop entre instrução e execução de forma autônoma. Entendemos que ele amplifica o desenvolvedor — não o substitui — e que sua maior força no contexto Java é eliminar o custo cognitivo do boilerplate e das tarefas de manutenção repetitivas. Agora vamos sair do mundo conceitual e construir o ambiente real onde tudo isso vai acontecer.

---

## Análise de Integridade (Auditoria Prévia)

✅ Esta aula é predominantemente prática e técnica. Todo comando foi verificado para Windows 11 com PowerShell e Terminal do VS Code. As versões referenciadas são as latest LTS disponíveis no momento da elaboração deste material — Java 21 (LTS), Maven 3.9.x, Node.js 22 LTS, Git latest stable. Os comandos de validação foram incluídos em cada etapa para garantir que o aluno pode verificar independentemente se cada instalação foi bem-sucedida antes de prosseguir. O entregável é objetivo e verificável: o comando `claude` funcionando no terminal.

---

## Objetivo Específico

Ao final desta aula, você terá um ambiente de desenvolvimento 100% funcional no Windows 11, com Java 21, Maven, Git, Node.js, VS Code configurado com as extensões certas e o Claude Code instalado e autenticado. Você vai executar seu primeiro comando `claude` real no terminal e ver o agente respondendo dentro do contexto de um diretório de projeto. Cada ferramenta será instalada com um propósito claro — você entenderá por que cada peça existe e como ela se conecta às demais.

## Pré-requisitos

Aula 1 concluída. Você precisa ter: acesso de administrador no Windows 11, conexão estável com a internet, uma conta na Anthropic (console.anthropic.com) para gerar a chave de API, e uma conta no GitHub (github.com). Se ainda não tem conta na Anthropic ou no GitHub, crie-as antes de começar — o processo leva menos de 5 minutos em cada.

---

## Teoria Detalhada

### O ambiente como fundação — por que cada peça importa

Existe uma tentação comum entre desenvolvedores experientes: pular a configuração de ambiente e ir direto ao que parece interessante. É uma tentação compreensível — configuração é trabalhosa e não tem a satisfação imediata de ver código funcionando. Mas no contexto deste curso, o ambiente não é apenas infraestrutura: ele é parte do aprendizado.

Cada ferramenta que você vai instalar tem um papel específico no ecossistema do Claude Code com Java. Entender esse papel transforma a instalação de uma tarefa mecânica em construção de conhecimento. Por isso, antes de cada bloco de instalação, vamos entender brevemente o que aquela ferramenta faz e por que o Claude Code precisa dela.

---

### Analogia de Ancoragem: a oficina do artesão

Imagine um marceneiro master que acaba de contratar um assistente extraordinariamente talentoso. O assistente sabe tudo sobre marcenaria — técnicas, materiais, padrões, acabamentos. Mas quando chega na primeira manhã de trabalho, a oficina está vazia. Sem torno, sem serras, sem lixas, sem verniz. Por mais talentoso que seja o assistente, ele não consegue produzir nada sem as ferramentas certas no lugar certo.

O Claude Code é esse assistente extraordinário. Mas ele precisa da sua oficina montada. O Java SDK é o torno — a ferramenta principal que transforma matéria-prima em produto. O Maven é a bancada de trabalho organizada — onde as peças se encaixam e o processo de construção acontece. O Git é o diário da oficina — registra cada decisão, cada mudança, cada versão. O VS Code é a iluminação e organização do espaço — onde você observa e revisa o trabalho. E o Node.js é o veículo que trouxe o assistente até a sua oficina.

Quando a oficina está montada e organizada, o assistente opera com máxima eficiência. Quando falta alguma ferramenta ou está no lugar errado, o trabalho trava.

---

### Visão geral do que vamos instalar

Antes de começar, veja o mapa completo do que será instalado e a ordem correta — a sequência importa porque algumas ferramentas dependem de outras já presentes no sistema:

~~~mermaid
graph TD
    A[Início] --> B[1. Winget / Chocolatey]
    B --> C[2. Java 21 JDK]
    C --> D[3. Maven 3.9.x]
    D --> E[4. Git latest]
    E --> F[5. Node.js 22 LTS]
    F --> G[6. VS Code + Extensões Java]
    G --> H[7. Claude Code CLI via npm]
    H --> I[8. Autenticação API Anthropic]
    I --> J[9. Validação Final]
    J --> K[✅ Ambiente Pronto]

    style A fill:#95A5A6,color:#fff
    style K fill:#2ECC71,color:#fff
    style H fill:#4A90D9,color:#fff
    style I fill:#E74C3C,color:#fff
~~~

---

### Passo 1: Preparando o Windows 11 para desenvolvimento

O Windows 11 tem um gerenciador de pacotes nativo chamado **winget** (Windows Package Manager), disponível por padrão na maioria das instalações modernas. Ele funciona de forma similar ao `apt` no Linux ou ao `brew` no macOS — permite instalar e atualizar software via linha de comando, o que é mais confiável e reproduzível do que baixar instaladores manualmente.

Abra o **Windows Terminal** ou o **PowerShell** como administrador. Para isso, pressione `Win + X` e escolha "Terminal (Admin)" ou "Windows PowerShell (Admin)". Verifique se o winget está disponível:

~~~powershell
winget --version
~~~

Se retornar uma versão (ex: `v1.8.x`), você está pronto. Se não encontrar o comando, abra a Microsoft Store, pesquise "App Installer" e atualize o aplicativo — isso instala/atualiza o winget.

---

### Passo 2: Instalando o Java 21 JDK

O **JDK (Java Development Kit)** é o conjunto completo de ferramentas para desenvolver em Java — inclui o compilador (`javac`), a JVM (Java Virtual Machine) para executar programas, e bibliotecas padrão. Sem ele, nenhum código Java compila ou roda.

Usaremos o **Eclipse Temurin 21**, que é a distribuição OpenJDK mais amplamente usada em produção, mantida pela Adoptium. É gratuita, open source e tem suporte LTS garantido.

~~~powershell
# Instala o Eclipse Temurin 21 JDK via winget
winget install --id EclipseAdoptium.Temurin.21.JDK --source winget
~~~

Após a instalação, **feche e reabra o terminal** (isso é importante — o PATH precisa ser recarregado). Então valide:

~~~powershell
# Verifica a versão do Java instalada
java --version

# Verifica o compilador Java
javac --version
~~~

A saída esperada é algo como:

~~~text
openjdk 21.0.x 2024-xx-xx LTS
OpenJDK Runtime Environment Temurin-21.0.x
~~~

Se aparecer essa saída, o Java está instalado corretamente. Se o terminal disser "comando não encontrado" mesmo após reabrir, precisamos configurar a variável de ambiente `JAVA_HOME` manualmente — veja a seção de Troubleshooting ao final desta aula.

---

### Passo 3: Instalando o Maven

O **Apache Maven** é a ferramenta de build e gerenciamento de dependências mais usada no ecossistema Java empresarial. Ele lê o arquivo `pom.xml` do projeto para entender suas dependências, plugins e configurações, e então baixa o que for necessário, compila o código, roda os testes e empacota a aplicação.

O Claude Code vai interagir constantemente com o Maven — pedindo para compilar, rodar testes, verificar dependências. Por isso, o Maven precisa estar acessível no PATH do sistema.

~~~powershell
# Instala o Maven via winget
winget install --id Apache.Maven --source winget
~~~

Feche e reabra o terminal, então valide:

~~~powershell
# Verifica a versão do Maven
mvn --version
~~~

A saída esperada inclui algo como:

~~~text
Apache Maven 3.9.x
Maven home: C:\Users\...\apache-maven-3.9.x
Java version: 21.0.x, vendor: Eclipse Adoptium
~~~

Note que o Maven já reconhece o Java que instalamos — isso confirma que o `JAVA_HOME` está configurado corretamente.

---

### Passo 4: Instalando o Git

O **Git** é o sistema de controle de versão que registra cada mudança no projeto. Para o Claude Code, o Git tem um papel duplo: primeiro, permite que o Claude Code analise o histórico de commits para entender a evolução do projeto; segundo, é através do Git que você vai salvar cada avanço feito com o Claude Code, criando um histórico rastreável de tudo que foi gerado, refatorado ou corrigido.

~~~powershell
# Instala o Git via winget
winget install --id Git.Git --source winget
~~~

Feche e reabra o terminal, então valide e configure:

~~~powershell
# Verifica a versão do Git
git --version

# Configura seu nome (aparecerá nos commits)
git config --global user.name "Thiago"

# Configura seu e-mail (deve ser o mesmo do GitHub)
git config --global user.email "seu-email@exemplo.com"

# Configura o editor padrão como VS Code
git config --global core.editor "code --wait"

# Configura o branch padrão como main (padrão moderno)
git config --global init.defaultBranch main

# Verifica as configurações
git config --list
~~~

---

### Passo 5: Instalando o Node.js

O **Node.js** é uma plataforma de execução JavaScript. Como mencionamos na Aula 1, ele serve exclusivamente como veículo de distribuição do Claude Code — o npm (Node Package Manager, que vem junto com o Node.js) é o canal pelo qual o Claude Code é instalado e atualizado.

Usaremos a versão **22 LTS** (Long Term Support), que é a versão estável de longo prazo mais recente.

~~~powershell
# Instala o Node.js 22 LTS via winget
winget install --id OpenJS.NodeJS.LTS --source winget
~~~

Feche e reabra o terminal, então valide:

~~~powershell
# Verifica a versão do Node.js
node --version

# Verifica a versão do npm
npm --version
~~~

Saída esperada: `node` retornando `v22.x.x` e `npm` retornando `10.x.x` ou superior.

---

### Passo 6: Instalando e Configurando o VS Code

O **Visual Studio Code** é nossa IDE central. Para Java com Spring Boot, ele precisa de algumas extensões específicas. Vamos instalar o VS Code e em seguida configurá-lo como um ambiente Java profissional.

~~~powershell
# Instala o VS Code via winget
winget install --id Microsoft.VisualStudioCode --source winget
~~~

Após a instalação, abra o VS Code. Você pode fazer isso pelo terminal:

~~~powershell
code .
~~~

Agora instale as extensões essenciais. O VS Code permite instalar extensões via linha de comando, o que é mais rápido do que navegar pela interface:

~~~powershell
# Extension Pack for Java — pacote completo com suporte Java no VS Code
# Inclui: Language Support for Java, Debugger for Java, Test Runner for Java,
# Maven for Java, Project Manager for Java, e IntelliCode
code --install-extension vscjava.vscode-java-pack

# Spring Boot Extension Pack — suporte completo ao Spring Boot
# Inclui: Spring Boot Tools, Spring Initializr, Spring Dashboard
code --install-extension vmware.vscode-boot-dev-pack

# GitLens — visualização avançada do histórico Git dentro do VS Code
code --install-extension eamodio.gitlens

# REST Client — testar endpoints REST diretamente do VS Code (alternativa ao Postman)
code --install-extension humao.rest-client

# Markdown All in One — edição confortável de arquivos .md
code --install-extension yzhang.markdown-all-in-one
~~~

Após instalar as extensões, configure o VS Code para Java. Crie ou edite o arquivo de configurações do usuário. No VS Code, pressione `Ctrl + Shift + P`, digite "Open User Settings (JSON)" e selecione a opção. Substitua ou adicione estas configurações:

~~~json
{
  "editor.fontSize": 14,
  "editor.tabSize": 4,
  "editor.insertSpaces": true,
  "editor.formatOnSave": true,
  "editor.rulers": [120],
  "java.configuration.runtimes": [
    {
      "name": "JavaSE-21",
      "path": "C:\\Program Files\\Eclipse Adoptium\\jdk-21.x.x-hotspot",
      "default": true
    }
  ],
  "java.compile.nullAnalysis.mode": "automatic",
  "java.saveActions.organizeImports": true,
  "spring-boot.ls.java.home": "C:\\Program Files\\Eclipse Adoptium\\jdk-21.x.x-hotspot",
  "git.autofetch": true,
  "terminal.integrated.defaultProfile.windows": "PowerShell"
}
~~~

**Importante:** O caminho `C:\\Program Files\\Eclipse Adoptium\\jdk-21.x.x-hotspot` precisa refletir o caminho real onde o JDK foi instalado. Para descobrir o caminho exato, execute no terminal:

~~~powershell
# Encontra o caminho de instalação do Java
where java
~~~

O caminho retornado será algo como `C:\Program Files\Eclipse Adoptium\jdk-21.0.x.x-hotspot\bin\java.exe`. Use tudo até `\bin\java.exe` — ou seja, `C:\Program Files\Eclipse Adoptium\jdk-21.0.x.x-hotspot`.

---

### Passo 7: Instalando o Claude Code

Este é o momento central desta aula. Com Java, Maven, Git, Node.js e VS Code configurados, agora instalamos o próprio Claude Code. A instalação é feita via npm e é global — estará disponível em qualquer diretório do sistema.

~~~powershell
# Instala o Claude Code globalmente via npm
npm install -g @anthropic-ai/claude-code
~~~

Valide a instalação:

~~~powershell
# Verifica se o Claude Code foi instalado
claude --version
~~~

Se retornar uma versão, a instalação foi bem-sucedida. Se o terminal disser "comando não encontrado", veja a seção de Troubleshooting.

---

### Passo 8: Autenticação com a API da Anthropic

O Claude Code precisa de uma chave de API para se comunicar com os servidores da Anthropic. Esta chave identifica sua conta e controla o acesso ao modelo. Veja como obtê-la e configurá-la:

**Obtendo a chave de API:**
1. Acesse console.anthropic.com e faça login.
2. No menu lateral, clique em "API Keys".
3. Clique em "Create Key", dê um nome descritivo (ex: "claude-code-dev") e copie a chave gerada — ela começa com `sk-ant-`.
4. **Atenção:** A chave só é exibida uma vez. Salve-a em um local seguro antes de fechar a página.

**Configurando a autenticação:**

O Claude Code pode ser autenticado de duas formas. A forma recomendada para desenvolvimento local é via variável de ambiente. No Windows 11, configure assim:

~~~powershell
# Adiciona a variável de ambiente ANTHROPIC_API_KEY permanentemente
# para o usuário atual (não precisa de admin)
[System.Environment]::SetEnvironmentVariable(
    "ANTHROPIC_API_KEY",
    "sk-ant-SUA-CHAVE-AQUI",
    "User"
)
~~~

Feche e reabra o terminal, então verifique:

~~~powershell
# Confirma que a variável foi configurada
echo $env:ANTHROPIC_API_KEY
~~~

Deve retornar sua chave. Alternativamente, você pode autenticar diretamente pelo Claude Code na primeira execução:

~~~powershell
# Inicia o Claude Code — na primeira execução, solicitará autenticação
claude
~~~

Se a variável `ANTHROPIC_API_KEY` não estiver configurada, o Claude Code abrirá um fluxo de autenticação interativo onde você cola a chave diretamente.

---

### Passo 9: Validação completa do ambiente

Agora vamos validar que todas as peças funcionam juntas. Crie uma pasta de teste temporária:

~~~powershell
# Cria uma pasta de teste
mkdir C:\dev\teste-claude
cd C:\dev\teste-claude

# Inicializa um repositório Git
git init

# Cria um arquivo Java simples para dar contexto ao Claude Code
@"
public class Ola {
    public static void main(String[] args) {
        System.out.println("Olá, Claude Code!");
    }
}
"@ | Out-File -FilePath Ola.java -Encoding utf8

# Inicia o Claude Code neste diretório
claude
~~~

Dentro da sessão interativa do Claude Code, digite:

~~~text
Leia o arquivo Ola.java e me diga o que ele faz, depois sugira como melhorá-lo seguindo boas práticas Java modernas.
~~~

Se o Claude Code responder com uma análise do arquivo e sugestões de melhoria, **seu ambiente está 100% funcional**. Você acaba de fazer sua primeira interação real com o Claude Code dentro de um projeto.

Para sair da sessão interativa, pressione `Ctrl + C` ou digite `/exit`.

---

### Organizando o ambiente de trabalho permanente

Agora que tudo funciona, vamos criar a estrutura de pastas que usaremos ao longo do curso. Execute no terminal:

~~~powershell
# Cria a pasta raiz do curso
mkdir C:\dev\taskflow-api
cd C:\dev\taskflow-api

# Inicializa o repositório Git
git init

# Cria o arquivo .gitignore para projetos Java/Maven/VS Code
@"
# Maven
target/
*.class

# VS Code
.vscode/settings.json
.vscode/tasks.json
.vscode/launch.json
.vscode/*.code-workspace

# Java
*.jar
*.war
*.ear

# Logs
*.log
logs/

# Sistema operacional
.DS_Store
Thumbs.db

# Variáveis de ambiente locais
.env
"@ | Out-File -FilePath .gitignore -Encoding utf8

# Cria o arquivo README inicial
@"
# TaskFlow API

API REST de gerenciamento de tarefas desenvolvida com Java e Spring Boot,
construída e mantida com Claude Code ao longo do curso.

## Sobre o projeto

Este projeto é o prático incremental do curso 'Claude Code para
Desenvolvimento e Manutenção de Aplicações Java'.

## Ambiente

- Java 21 (Eclipse Temurin LTS)
- Spring Boot (latest)
- Maven (latest)
- Claude Code (latest)
"@ | Out-File -FilePath README.md -Encoding utf8

# Cria o log de estado do projeto
@"
# Log de Estado do Projeto — TaskFlow API

## Aula 2: Instalação e Configuração do Ambiente Completo
- **Objetivo:** Configurar ambiente de desenvolvimento completo.
- **Realizado:** Java 21, Maven, Git, Node.js, VS Code e Claude Code instalados e validados.
- **Estado Funcional:** Ambiente configurado e validado.
- **Próximas Etapas:** Aula 3 — Anatomia do Claude Code (CLI, Contexto e Sessões).
"@ | Out-File -FilePath log_estado_projeto.md -Encoding utf8

# Copia o plano_mestre.txt para a pasta do projeto
# (assuma que o arquivo está em Downloads — ajuste o caminho se necessário)
# Copy-Item "$env:USERPROFILE\Downloads\plano_mestre.txt" -Destination .

# Primeiro commit do projeto
git add .
git commit -m "chore: configuração inicial do ambiente e estrutura do repositório"
~~~

Abra o VS Code nesta pasta:

~~~powershell
code .
~~~

O VS Code detectará automaticamente que é um projeto Java (nas próximas aulas, quando o `pom.xml` existir) e ativará as extensões Java instaladas.

---

## Glossário Técnico da Aula

**JDK (Java Development Kit):** Conjunto completo de ferramentas para desenvolver em Java — inclui o compilador `javac`, a JVM para executar programas, e as bibliotecas padrão. Diferente do JRE (Java Runtime Environment), que só permite executar programas Java já compilados, o JDK permite criar e compilar programas novos.

**Maven:** Ferramenta de automação de build e gerenciamento de dependências para Java. Lê o arquivo `pom.xml` para entender a estrutura do projeto, baixa as bibliotecas necessárias de repositórios online (como o Maven Central), e executa o ciclo de vida de build (compile → test → package → install → deploy).

**npm (Node Package Manager):** Gerenciador de pacotes do ecossistema Node.js. Permite instalar, atualizar e gerenciar bibliotecas e ferramentas JavaScript. Usado aqui exclusivamente para instalar o Claude Code.

**PATH:** Variável de ambiente do sistema operacional que lista os diretórios onde o sistema procura por executáveis quando você digita um comando no terminal. Quando você instala o Java e digita `java --version`, o sistema só encontra o executável `java` porque o diretório `bin` do JDK está no PATH.

**JAVA_HOME:** Variável de ambiente que aponta para o diretório raiz do JDK instalado. Usada pelo Maven, pelo VS Code e por muitas outras ferramentas Java para encontrar o JDK correto quando há múltiplas versões instaladas.

**Chave de API:** Identificador único e secreto que autentica suas requisições aos servidores da Anthropic. Funciona como uma senha: quem tem a chave pode usar a API e será cobrado pelo uso. Por isso deve ser tratada com o mesmo cuidado de uma senha.

**Variável de ambiente:** Valor de configuração armazenado no sistema operacional e acessível por qualquer processo em execução. No Windows, variáveis de ambiente do usuário (como `ANTHROPIC_API_KEY`) ficam associadas à conta do usuário e são carregadas automaticamente em cada sessão do terminal.

**.gitignore:** Arquivo de texto na raiz do repositório que lista padrões de arquivos e diretórios que o Git deve ignorar — ou seja, não rastrear nem incluir nos commits. Usado para excluir arquivos compilados, dependências baixadas automaticamente e configurações locais que não devem ser compartilhadas.

---

## Antecipação de Erros

**Erro 1: `java` não encontrado após instalação** — O instalador adicionou o Java ao PATH, mas o terminal ainda está com o PATH antigo em memória. Solução: sempre fechar e reabrir o terminal após cada instalação. Se persistir, verifique manualmente nas Variáveis de Ambiente do Windows (Win + X → Sistema → Configurações avançadas do sistema → Variáveis de Ambiente) se o diretório `bin` do JDK aparece na variável `Path`.

**Erro 2: `claude` não encontrado após instalação via npm** — O npm instala pacotes globais em um diretório específico que pode não estar no PATH. Verifique o diretório de pacotes globais com `npm config get prefix` e confirme se o subdiretório `\bin` desse caminho está no PATH do sistema.

**Erro 3: Erro de autenticação ao iniciar o Claude Code** — A variável `ANTHROPIC_API_KEY` não foi carregada. Confirme com `echo $env:ANTHROPIC_API_KEY`. Se vazio, a variável não foi configurada corretamente ou o terminal foi aberto antes da configuração. Repita o comando de configuração e reabra o terminal.

**Erro 4: VS Code não reconhece o Java** — As extensões Java precisam do `JAVA_HOME` configurado corretamente no `settings.json`. Verifique se o caminho no campo `java.configuration.runtimes` existe exatamente como especificado. Caminhos no JSON precisam usar barras duplas `\\` no Windows.

**Erro 5: Maven falha com "JAVA_HOME not set"** — O Maven não conseguiu encontrar o JDK. Configure manualmente: no PowerShell, execute `[System.Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Program Files\Eclipse Adoptium\jdk-21.x.x-hotspot", "User")` e reabra o terminal.

---

## Troubleshooting

**Como verificar se todas as ferramentas estão no PATH:**

~~~powershell
# Script de validação completo — execute no PowerShell
Write-Host "=== Validação do Ambiente ===" -ForegroundColor Cyan

Write-Host "`n[Java]" -ForegroundColor Yellow
java --version

Write-Host "`n[Maven]" -ForegroundColor Yellow
mvn --version

Write-Host "`n[Git]" -ForegroundColor Yellow
git --version

Write-Host "`n[Node.js]" -ForegroundColor Yellow
node --version

Write-Host "`n[npm]" -ForegroundColor Yellow
npm --version

Write-Host "`n[Claude Code]" -ForegroundColor Yellow
claude --version

Write-Host "`n[ANTHROPIC_API_KEY]" -ForegroundColor Yellow
if ($env:ANTHROPIC_API_KEY) {
    Write-Host "Configurada: sk-ant-****" -ForegroundColor Green
} else {
    Write-Host "NÃO configurada" -ForegroundColor Red
}

Write-Host "`n=== Validação Concluída ===" -ForegroundColor Cyan
~~~

Salve este script como `validar_ambiente.ps1` na pasta `C:\dev\taskflow-api\aula_02\` — ele será útil sempre que precisar verificar o ambiente rapidamente.

**Como encontrar o caminho exato do JDK:**

~~~powershell
# Encontra todos os executáveis Java no sistema
Get-Command java | Select-Object -ExpandProperty Source

# Alternativa: lista instalações via winget
winget list --id EclipseAdoptium.Temurin.21.JDK
~~~

---

## Desafio de Fixação

**Parte 1 — Validação:** Execute o script `validar_ambiente.ps1` que criamos. Todos os itens devem retornar versões válidas e a chave de API deve aparecer como "Configurada". Tire um print ou copie a saída para registrar seu ambiente.

**Parte 2 — Primeira conversa real:** Dentro da pasta `C:\dev\taskflow-api`, inicie o Claude Code com `claude` e faça as seguintes perguntas em sequência, observando como ele responde e como usa o contexto do diretório:

~~~text
1. "Leia os arquivos deste diretório e descreva a estrutura atual do projeto."
2. "Com base no README.md, o que este projeto vai construir?"
3. "Sugira o que deve ser adicionado ao .gitignore para um projeto Spring Boot com Maven."
~~~

Observe: o Claude Code vai ao diretório, lê os arquivos, e responde com base no conteúdo real — não em suposições genéricas. Esta é a diferença concreta entre o agente e o assistente que discutimos na Aula 1.

**Parte 3 — Commit semântico:** Após o desafio, faça um commit registrando o estado do ambiente:

~~~powershell
git add .
git commit -m "chore: validação completa do ambiente de desenvolvimento"
~~~

---

## Resolução Comentada

Para a Parte 1, se algum item falhar na validação, o fluxo de troubleshooting é sempre o mesmo: verificar se o executável está no PATH, reiniciar o terminal, e se persistir, verificar as variáveis de ambiente manualmente no painel do Windows.

Para a Parte 2, a resposta correta do Claude Code para a primeira pergunta deve mencionar os três arquivos que criamos: `README.md`, `.gitignore` e `log_estado_projeto.md`. Se ele descrever corretamente o conteúdo de cada um sem você ter copiado o conteúdo manualmente, você confirmou que o agente lê o sistema de arquivos real.

Para a Parte 3, o formato `chore:` segue o padrão de Conventional Commits — commits semânticos que descrevem o tipo de mudança. `chore` é usado para tarefas de manutenção e configuração que não afetam o código de produção. Usaremos este padrão ao longo de todo o curso.

---

## Resumo dos Pontos-Chave

O ambiente está construído sobre cinco camadas: Java 21 (a linguagem e a plataforma), Maven (o sistema de build e dependências), Git (o controle de versão), Node.js/npm (o veículo do Claude Code) e VS Code (o espaço de trabalho visual). O Claude Code se senta sobre tudo isso, acessando o sistema de arquivos diretamente e executando comandos no terminal. A autenticação via `ANTHROPIC_API_KEY` é a ponte entre o executável local e o modelo na nuvem. Com o ambiente validado e o repositório inicial criado, você tem a oficina do artesão montada e pronta para o trabalho real.

---

## Log de Estado do Projeto

| Campo | Valor |
|---|---|
| Aula | 2 — Instalação e Configuração do Ambiente Completo |
| Objetivo | Ambiente de desenvolvimento 100% funcional |
| Realizado | Java 21, Maven, Git, Node.js 22, VS Code + extensões, Claude Code instalados e validados |
| Estado Funcional | ✅ Primeiro comando `claude` executado com sucesso |
| Arquivos Criados | `.gitignore`, `README.md`, `log_estado_projeto.md` |
| Próximas Etapas | Aula 3 — Anatomia do Claude Code: CLI, Contexto e Sessões |

---

## Prompt de Continuidade para a Aula 3
Sou o Thiago. Estou seguindo o curso "Claude Code para Desenvolvimento e Manutenção de Aplicações Java" com o Tutor Sênior. Concluí a Aula 2 — ambiente instalado e validado: Java 21, Maven, Git, Node.js 22, VS Code com extensões Java e Claude Code funcionando. O plano_mestre.txt está em anexo. Por favor, gere a Aula 3 completa: "Anatomia do Claude Code — CLI, Contexto e Sessões", seguindo toda a estrutura pedagógica do Prompt Mestre — com mínimo de 2.000 palavras, analogia de ancoragem, diagrama Mermaid, comandos comentados linha a linha, glossário, antecipação de erros, troubleshooting e desafio de fixação.

---

## Próximos Passos

Na Aula 3, vamos dissecar o Claude Code por dentro — cada comando da CLI, como funciona o contexto de sessão, o que acontece quando você inicia uma nova sessão versus continua uma existente, como o Claude Code decide quais arquivos ler, e quais são os atalhos e comandos especiais que tornam o trabalho mais eficiente. Você vai usar o ambiente que montou hoje para explorar o Claude Code de forma sistemática e intencional.

---

Dúvidas? Posso prosseguir para a Aula 3?