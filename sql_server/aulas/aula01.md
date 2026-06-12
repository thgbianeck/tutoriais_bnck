# Aula 1 — O que é um Banco de Dados Relacional e por que o SQL Server?

**Curso:** SQL Server para Aplicações Financeiras com T-SQL
**Projeto:** FinanceDB — Sistema de Controle Financeiro Pessoal
**Módulo:** 1 — Essencial: Fundamentos
**Ambiente:** Windows 11 · VS Code (editor) · SSMS 21 (execução) · SQL Server 2022

---

## Técnica de Feynman

Imagine que você precisa explicar para um amigo que nunca ouviu falar em banco de dados o que você faz quando organiza suas finanças pessoais. Você provavelmente tem uma planilha, ou um caderno, onde anota suas receitas e despesas. Cada linha é um lançamento. Cada coluna é uma informação: data, descrição, valor, categoria. Isso, na essência, é um banco de dados. Um banco de dados relacional nada mais é do que um conjunto de planilhas organizadas com regras rígidas, onde as informações se relacionam entre si de forma controlada e confiável. O SQL Server é o sistema que gerencia tudo isso para você, e o T-SQL é a linguagem que você usa para conversar com ele.

---

## Teoria

### O problema que os bancos de dados resolvem

Antes de existirem bancos de dados, as empresas guardavam suas informações em arquivos físicos, fichas e cadernos. Uma instituição financeira dos anos 1970 podia ter galpões inteiros repletos de papéis. Encontrar o extrato de um cliente específico exigia horas de trabalho manual. O risco de perda, duplicação ou inconsistência era altíssimo.

Com a informatização, o primeiro impulso foi simplesmente digitalizar esses arquivos: guardar dados em arquivos de texto, planilhas ou arquivos proprietários de cada programa. Isso resolveu parte do problema, mas criou outros. Se dois programas diferentes precisassem acessar os mesmos dados simultaneamente, havia conflito. Se o arquivo corrompesse, os dados se perdiam. Se a estrutura precisasse mudar, todos os programas que liam aquele arquivo precisavam ser reescritos.

Foi para resolver esses problemas que os **Sistemas Gerenciadores de Banco de Dados** (SGBDs) foram criados. Eles centralizam o armazenamento, o acesso e a proteção dos dados, oferecendo uma camada de abstração entre os programas e os dados em si.

### O que é um banco de dados relacional

O modelo relacional foi proposto pelo matemático britânico **Edgar F. Codd** em 1970, em um artigo que se tornou um dos mais influentes da história da computação. A ideia central é simples e poderosa: organizar dados em **tabelas** (chamadas de relações na teoria formal), onde cada tabela representa um tipo de entidade do mundo real.

Uma **tabela** é composta por **colunas** (também chamadas de atributos ou campos), que definem quais informações serão armazenadas, e por **linhas** (também chamadas de registros ou tuplas), que representam cada ocorrência individual daquela entidade.

No contexto do nosso projeto **FinanceDB**, uma tabela chamada `Categorias` teria colunas como `CategoriaId`, `Nome` e `Tipo`. Cada linha seria uma categoria específica: Salário, Alimentação, Transporte, e assim por diante.

A palavra **relacional** não vem apenas do fato de os dados estarem em tabelas, mas principalmente do fato de que as tabelas podem se **relacionar entre si**. Uma tabela de `Lancamentos` pode referenciar uma tabela de `Categorias`, indicando a qual categoria cada lançamento pertence. Essa capacidade de relacionamento é o que torna o modelo tão poderoso para aplicações complexas como sistemas financeiros.

### Três conceitos fundamentais que você precisa separar

Existe uma confusão muito comum entre iniciantes que vale a pena esclarecer desde o início, porque ela vai aparecer em toda a sua jornada:

**Banco de Dados** é o conjunto de dados armazenados, organizados em tabelas, com seus relacionamentos, restrições e regras. É o "conteúdo". No nosso curso, o `FinanceDB` é o banco de dados — ele conterá todas as tabelas, dados e objetos do nosso sistema financeiro.

**SGBD (Sistema Gerenciador de Banco de Dados)** é o software responsável por criar, gerenciar, proteger e fornecer acesso aos bancos de dados. Ele é o "motor". O **SQL Server 2022** é o SGBD que usaremos. Ele roda como um serviço no Windows, aceita conexões, processa comandos e garante que os dados sejam armazenados e recuperados de forma correta e segura.

**SQL (Structured Query Language)** é a linguagem padronizada usada para se comunicar com o SGBD. É o "idioma". Você escreve comandos em SQL para criar tabelas, inserir dados, fazer consultas e muito mais. O **T-SQL (Transact-SQL)** é a variante do SQL usada especificamente pelo SQL Server, com extensões proprietárias da Microsoft que adicionam recursos procedurais, tratamento de erros e muito mais.

A relação entre os três é assim: você escreve **T-SQL** para se comunicar com o **SQL Server** (SGBD), que por sua vez gerencia o **FinanceDB** (banco de dados).

### Por que o SQL Server para aplicações financeiras

Existem vários SGBDs no mercado: PostgreSQL, MySQL, Oracle, SQLite, entre outros. Cada um tem seus pontos fortes. O SQL Server, desenvolvido pela Microsoft, é particularmente bem posicionado para aplicações financeiras por algumas razões que vão além do marketing.

A primeira razão é a **confiabilidade transacional**. O SQL Server implementa com rigor as propriedades ACID (Atomicidade, Consistência, Isolamento e Durabilidade), que são o alicerce da integridade em sistemas financeiros. Você aprenderá sobre isso em detalhes na Aula 20, mas desde já entenda que "ACID" significa que o banco garante que uma transferência entre contas ou acontece completamente ou não acontece de forma alguma — nunca pela metade.

A segunda razão é a **precisão numérica**. O SQL Server oferece tipos de dados como `DECIMAL` e `NUMERIC` com controle preciso de casas decimais, essencial para evitar erros de arredondamento em cálculos financeiros. Um centavo a mais ou a menos em escala pode representar milhões.

A terceira razão é a **integração com o ecossistema Microsoft**. Em ambientes corporativos financeiros, SQL Server, Windows Server, Active Directory e ferramentas como Power BI e Excel trabalham de forma integrada e bem documentada.

A quarta razão é a **adoção no mercado**. O SQL Server é amplamente usado em bancos, corretoras, fintechs e empresas de contabilidade no Brasil e no mundo. Dominar T-SQL abre portas concretas no mercado de trabalho financeiro.

### O SQL Server 2022 em particular

A versão 2022 do SQL Server é a mais recente ao início deste curso e traz recursos relevantes como integração nativa com o Azure (nuvem da Microsoft), melhorias de desempenho no Query Optimizer e suporte aprimorado a linguagens como Python e R para análise de dados dentro do próprio banco. Para o nosso curso, o que importa é que todos os comandos T-SQL que você aprenderá são compatíveis com o SQL Server 2022 e, em sua maioria, com versões anteriores como 2019 e 2017.

### O SSMS 21 — sua bancada de trabalho

O **SQL Server Management Studio (SSMS)** é a ferramenta oficial da Microsoft para administrar e interagir com o SQL Server. Pense nele como o painel de controle da sua bancada de trabalho — é onde você se conecta ao banco, executa scripts T-SQL, visualiza resultados e navega pelos objetos do banco de dados.

A versão 21 é a mais recente e traz melhorias de interface e desempenho em relação às versões anteriores. Para instalar o SSMS 21, acesse o link oficial:

~~~text
https://aka.ms/ssmsfullsetup
~~~

Após instalar e abrir o SSMS 21, você verá a tela de conexão. No campo **Server name**, você digitará o nome da sua instância do SQL Server. Na maioria das instalações locais no Windows, o valor padrão é simplesmente um ponto (`.`) ou `localhost` ou `.\SQLEXPRESS` se você instalou o SQL Server Express. No campo **Authentication**, selecione **Windows Authentication** para usar as credenciais do seu usuário Windows — o modo mais simples para começar.

Após conectar, você verá o **Object Explorer** à esquerda — uma árvore hierárquica que mostra todos os bancos de dados, tabelas, views, procedures e outros objetos gerenciados pelo seu SQL Server. Ao longo do curso, você usará muito o Object Explorer para verificar se os objetos que criou realmente existem.

A área central do SSMS é o **Editor de Queries** — onde você escreve e executa seus scripts T-SQL. Para abrir um novo editor, use o botão **New Query** na barra de ferramentas ou o atalho `Ctrl + N`. Após escrever seu script, execute com `F5` ou o botão **Execute**. Os resultados aparecem na aba **Results** logo abaixo. Mensagens de sucesso ou erro aparecem na aba **Messages**.

### O VS Code — sua prancheta de projeto

O **Visual Studio Code** será o seu editor principal para escrever, organizar e versionar todos os arquivos do projeto `FinanceDB`. Enquanto o SSMS é especializado em executar SQL, o VS Code é um editor de código de propósito geral, leve, extensível e com excelente suporte a Git.

No contexto deste curso, o VS Code será usado para escrever os scripts `.sql` de cada aula, editar os arquivos `.md` de documentação (como este plano mestre e os READMEs de cada aula), e organizar toda a estrutura de pastas do projeto. Quando um script estiver pronto, você o abre no SSMS para executar, ou simplesmente copia e cola no editor de queries.

### Configurando o VS Code para o projeto

Abra o VS Code. Vá em **File → Open Folder** e crie ou selecione a pasta `FinanceDB` em um local de sua preferência no Windows 11 — por exemplo, `C:\Projetos\FinanceDB`. Esta pasta será a raiz do seu projeto durante todo o curso.

Com a pasta aberta no VS Code, instale as extensões recomendadas. Para instalar uma extensão, use o atalho `Ctrl + Shift + X` para abrir o painel de extensões e pesquise pelo nome. As extensões recomendadas são **SQL Server (mssql)** da Microsoft para realce de sintaxe T-SQL, **Markdown All in One** para trabalhar confortavelmente com arquivos `.md`, **GitLens** para versionamento Git visual e **Material Icon Theme** para identificar os tipos de arquivo pelas suas pastas com ícones visuais.

Após instalar as extensões, crie a estrutura inicial de pastas do projeto. No painel **Explorer** do VS Code (ícone de arquivos à esquerda), crie as seguintes pastas e arquivos clicando com o botão direito na área de arquivos:

~~~text
FinanceDB/
├── README.md
├── plano_mestre.txt
├── log_estado_projeto.md
├── prompts_individuais.md
├── .gitignore
├── aula_01/
│   ├── README.md
│   └── exercicios/
│       └── exercicio_01.md
~~~

No arquivo `README.md` da raiz, escreva uma descrição simples do projeto:

~~~text
# FinanceDB — Sistema de Controle Financeiro Pessoal

Projeto prático do curso "SQL Server para Aplicações Financeiras com T-SQL".
Construído aula a aula, do zero ao domínio completo.

## Tecnologias
- SQL Server 2022
- T-SQL
- SSMS 21
- VS Code

## Estrutura
Cada pasta aula_XX contém o README da aula, os scripts SQL e os exercícios.
~~~

No arquivo `.gitignore`, adicione as seguintes entradas para ignorar arquivos temporários do Windows e do VS Code:

~~~text
.vs/
*.suo
*.user
Thumbs.db
desktop.ini
.vscode/settings.json
~~~

### O fluxo de trabalho entre VS Code e SSMS

O fluxo que você usará em cada aula é sempre o mesmo, e é importante internalizá-lo desde o início porque ele reflete uma prática profissional real:

Você **escreve** o script `.sql` no VS Code, aproveitando o realce de sintaxe e a organização por pastas. Você **salva** o arquivo na pasta da aula correspondente. Você **abre ou copia** o script no SSMS 21, que já está conectado ao SQL Server 2022. Você **executa** com `F5` e analisa os resultados na aba Results e as mensagens na aba Messages. Se precisar ajustar, você volta ao VS Code, faz a correção, salva e reexecuta no SSMS.

---

## Analogia de Ancoragem

Pense no SQL Server como o **cofre central de um banco**. O cofre (SQL Server) guarda as caixas-fortes (bancos de dados). Cada caixa-forte (FinanceDB) contém gavetas organizadas (tabelas). Cada gaveta (tabela) tem fichas padronizadas (linhas) com campos bem definidos (colunas). O SSMS é o **painel de controle do cofre** — a interface pela qual o gerente (você) opera o sistema. O VS Code é a sua **mesa de trabalho** — onde você prepara os documentos antes de depositá-los no cofre. O T-SQL é o **protocolo oficial de comunicação** — a linguagem que o cofre entende para executar ordens.

---

## Diagrama Mermaid

~~~mermaid
graph LR
    A[VS Code\nEscrever e organizar scripts .sql] -->|Copiar ou abrir o arquivo| B[SSMS 21\nExecutar e visualizar resultados]
    B -->|Ajustes e correções| A
    B -->|Conecta e executa comandos| C[SQL Server 2022\nGerencia o banco de dados]
    C -->|Retorna resultados e mensagens| B

    subgraph Projeto FinanceDB
        D[plano_mestre.txt]
        E[log_estado_projeto.md]
        F[aula_01/README.md]
        G[aula_01/exercicios/]
    end

    A --> D
    A --> E
    A --> F
    A --> G
~~~

---

## Aplicação no Projeto Prático

Nesta primeira aula não há script SQL a ser executado — o foco é inteiramente na compreensão conceitual e na configuração do ambiente. Sua entrega prática desta aula é a estrutura de pastas do projeto criada no VS Code, conforme descrita acima.

Verifique se você consegue:

1. Abrir o VS Code com a pasta `FinanceDB` como raiz do projeto.
2. Visualizar a estrutura de pastas no painel Explorer.
3. Abrir o SSMS 21 e conectar ao SQL Server 2022 usando Windows Authentication.
4. Ver o Object Explorer do SSMS com os bancos de dados do sistema (master, model, msdb, tempdb).
5. Abrir um novo editor de queries no SSMS com `Ctrl + N`.

Se você conseguiu fazer tudo isso, o ambiente está configurado e você está pronto para a Aula 2.

---

## Glossário Técnico da Aula

**Banco de Dados:** Conjunto organizado de dados armazenados de forma estruturada, gerenciado por um SGBD.

**Modelo Relacional:** Modelo de organização de dados proposto por Edgar F. Codd em 1970, baseado em tabelas com relacionamentos entre si.

**SGBD (Sistema Gerenciador de Banco de Dados):** Software responsável por criar, gerenciar, proteger e fornecer acesso aos dados. Exemplos: SQL Server, PostgreSQL, MySQL, Oracle.

**SQL Server 2022:** SGBD relacional da Microsoft, versão mais recente, amplamente usado em ambientes corporativos e financeiros.

**T-SQL (Transact-SQL):** Variante do SQL padrão usada pelo SQL Server, com extensões procedurais e recursos avançados de tratamento de erros e lógica de programação.

**SQL (Structured Query Language):** Linguagem padrão para comunicação com SGBDs relacionais. Usada para criar, consultar, alterar e excluir dados.

**Tabela:** Estrutura bidimensional composta por colunas (atributos) e linhas (registros) que representa uma entidade do mundo real.

**Coluna (Campo/Atributo):** Componente vertical de uma tabela que define qual tipo de informação é armazenado. Exemplo: `Nome`, `Valor`, `Data`.

**Linha (Registro/Tupla):** Componente horizontal de uma tabela que representa uma ocorrência individual da entidade. Exemplo: um lançamento específico de R$ 150,00.

**SSMS (SQL Server Management Studio):** Ferramenta oficial da Microsoft para administrar e interagir com o SQL Server. Usada para executar scripts T-SQL e visualizar resultados.

**Object Explorer:** Painel do SSMS que exibe em forma de árvore todos os objetos gerenciados pelo SQL Server: bancos de dados, tabelas, views, procedures, etc.

**VS Code (Visual Studio Code):** Editor de código leve e extensível da Microsoft, usado neste curso como editor de scripts `.sql` e arquivos de documentação `.md`.

**Instância do SQL Server:** Uma instalação independente do SQL Server em execução no sistema operacional. Um servidor pode ter múltiplas instâncias rodando simultaneamente.

**ACID:** Conjunto de propriedades que garantem a confiabilidade de transações em bancos de dados: Atomicidade, Consistência, Isolamento e Durabilidade. Essencial em sistemas financeiros.

---

## Antecipação de Erros

**Erro: SQL Server não aparece no Object Explorer do SSMS**
Causa provável: o serviço do SQL Server não está em execução. Solução: abra o **SQL Server Configuration Manager** (pesquise no menu Iniciar do Windows 11), localize o serviço **SQL Server (MSSQLSERVER)** ou **SQL Server (SQLEXPRESS)** e certifique-se de que o status é **Running**. Se estiver parado, clique com o botão direito e selecione **Start**.

**Erro: Falha de conexão no SSMS com mensagem "Cannot connect to ."**
Causa provável: nome da instância incorreto. Tente as variações: `.`, `localhost`, `(local)`, `.\SQLEXPRESS` ou `NOME_DO_COMPUTADOR\SQLEXPRESS`. O nome correto depende de como o SQL Server foi instalado.

**Erro: SSMS 21 não instala no Windows 11**
Causa provável: versão do .NET Framework insuficiente ou permissão de administrador ausente. Certifique-se de executar o instalador como administrador (botão direito → Executar como administrador) e que o Windows 11 está atualizado.

**Erro: VS Code não reconhece arquivos .sql com realce de sintaxe**
Causa provável: extensão **SQL Server (mssql)** não instalada. Instale-a pelo painel de extensões (`Ctrl + Shift + X`) pesquisando por "mssql".

**Erro: Pasta do projeto não aparece no VS Code**
Causa provável: você abriu um arquivo individual em vez de uma pasta. Use sempre **File → Open Folder** para abrir a pasta `FinanceDB` completa como raiz do projeto.

---

## Troubleshooting

Se o SSMS não consegue conectar ao SQL Server, o caminho de diagnóstico é sempre o mesmo: primeiro verifique se o **serviço do SQL Server está rodando** no SQL Server Configuration Manager. Segundo, verifique se o **protocolo TCP/IP está habilitado** nas configurações de rede do SQL Server Configuration Manager (em SQL Server Network Configuration → Protocols for MSSQLSERVER → TCP/IP deve estar **Enabled**). Terceiro, verifique se o **firewall do Windows** não está bloqueando a porta padrão do SQL Server (porta 1433). Para conexões locais no Windows 11, o Windows Authentication geralmente funciona sem problemas adicionais de firewall.

Se o VS Code não salva arquivos na pasta do projeto, verifique se você tem **permissão de escrita** na pasta escolhida. Prefira pastas dentro de `C:\Projetos\` ou `C:\Users\SeuNome\Projetos\` que tipicamente não exigem permissão de administrador.

---

## Desafio de Fixação

Este exercício é conceitual — sem código. Responda com suas próprias palavras:

**Questão 1:** Qual é a diferença entre banco de dados, SGBD e SQL? Use uma analogia diferente da apresentada nesta aula para explicar os três conceitos.

**Questão 2:** Por que o modelo relacional é preferível a guardar dados em planilhas separadas sem relacionamentos, no contexto de um sistema financeiro?

**Questão 3:** No contexto do nosso projeto FinanceDB, identifique pelo menos três entidades do mundo real que provavelmente se tornarão tabelas no banco de dados. Justifique sua escolha.

**Questão 4:** Qual é o papel do VS Code e qual é o papel do SSMS no fluxo de trabalho do curso? O que aconteceria se você tentasse usar apenas um deles?

---

## Resoluções Comentadas

**Questão 1 — Resposta modelo:**
Uma analogia diferente: pense em uma **biblioteca pública**. O **banco de dados** é o acervo de livros — o conjunto de informações armazenadas. O **SGBD** é o sistema de catalogação e os bibliotecários — o conjunto de regras, processos e pessoas que organizam, protegem e fornecem acesso ao acervo. O **SQL** é o sistema de requisição de livros — a linguagem padronizada que você usa para pedir "quero todos os livros de finanças publicados após 2020". Sem o sistema de catalogação (SGBD), o acervo seria um caos. Sem a linguagem de requisição (SQL), você não saberia como pedir o que quer.

**Questão 2 — Resposta modelo:**
Planilhas separadas sem relacionamentos geram **redundância e inconsistência**. Se o nome de uma categoria de despesa aparece em 10.000 linhas de uma planilha de lançamentos e você precisa corrigi-lo, precisa alterar 10.000 linhas. No modelo relacional, a categoria existe em uma única tabela `Categorias` com uma linha, e todos os lançamentos simplesmente referenciam essa linha pelo identificador. A correção é feita em um único lugar e se reflete em todos os lançamentos instantaneamente. Além disso, sem relacionamentos formais, nada impede que um lançamento referencie uma categoria que não existe — o que geraria relatórios incorretos em um sistema financeiro.

**Questão 3 — Resposta modelo:**
Três entidades naturais para o FinanceDB são **Categorias** (tipos de receita e despesa, como Salário, Alimentação, Transporte), **Contas** (onde o dinheiro fica ou passa, como Conta Corrente, Poupança, Carteira) e **Lançamentos** (cada entrada ou saída de dinheiro, com data, valor, descrição, categoria e conta associadas). Cada uma representa um conjunto de informações com atributos próprios e relacionamentos claros entre si.

**Questão 4 — Resposta modelo:**
O **VS Code** serve para escrever, organizar e versionar os scripts e arquivos do projeto — é o editor, a prancheta. O **SSMS 21** serve para executar os scripts contra o SQL Server e visualizar resultados — é a bancada de testes. Usar apenas o SSMS seria possível tecnicamente, mas os scripts ficariam desorganizados sem a estrutura de pastas, sem versionamento Git e sem a experiência de edição do VS Code. Usar apenas o VS Code (com a extensão mssql) é possível para scripts simples, mas o SSMS oferece ferramentas muito mais ricas para análise de planos de execução, Object Explorer e administração do servidor — essenciais à medida que o projeto avança.

---

## Resumo dos Pontos-Chave

O **modelo relacional** organiza dados em tabelas com linhas e colunas, permitindo relacionamentos entre entidades — ideal para sistemas financeiros onde precisão e integridade são críticas. **Banco de dados**, **SGBD** e **SQL** são três coisas distintas: o conteúdo, o motor e o idioma, respectivamente. O **SQL Server 2022** é o SGBD escolhido por sua confiabilidade transacional, precisão numérica e ampla adoção no mercado financeiro. O **SSMS 21** é a ferramenta de execução e o **VS Code** é o editor do projeto — as duas ferramentas se complementam e refletem um fluxo de trabalho profissional real. O projeto **FinanceDB** será construído incrementalmente ao longo das 24 aulas, e sua estrutura de pastas já foi criada nesta aula.

---

## Próximos Passos

Na próxima aula, aprenderemos sobre **criação de bancos de dados no SQL Server** — você escreverá seu primeiro script T-SQL real, criará o banco `FinanceDB` e entenderá o que acontece nos bastidores quando o SQL Server processa um comando `CREATE DATABASE`.

---

## Log de Estado do Projeto

- **Objetivo:** Configurar o ambiente de desenvolvimento e compreender os fundamentos conceituais
- **Código Adicionado:** Nenhum script SQL ainda — apenas estrutura de pastas e arquivos de documentação
- **Estado Funcional:** ⏳ Ambiente configurado, aguardando primeiro script na Aula 2
- **Objetos Criados:** Pasta `FinanceDB/`, `README.md`, `log_estado_projeto.md`, `plano_mestre.txt`, `prompts_individuais.md`, `.gitignore`, pasta `aula_01/` com README e exercício
- **Próximas Etapas:** Escrever e executar o primeiro script T-SQL — `CREATE DATABASE FinanceDB`

---

## Prompt de Continuidade para a Aula 2

~~~text
Você é o Tutor Sênior do curso "SQL Server para Aplicações Financeiras com T-SQL", conforme definido no plano_mestre.txt anexo. Consulte também o log_estado_projeto.md para ver o estado atual do projeto. O aluno usa Windows 11, VS Code como editor e SSMS 21 para execução. SQL Server 2022. Iniciante absoluto.

Na Aula 1 foram cobertos: conceito de banco de dados relacional, diferença entre banco de dados/SGBD/SQL, apresentação do SQL Server 2022 e SSMS 21, configuração do VS Code, fluxo de trabalho VS Code → SSMS e criação da estrutura de pastas do projeto. Nenhum script SQL foi executado ainda.

Use apenas comandos introduzidos nesta aula. Gere a Aula 2 completa com no mínimo 2.000 palavras de conteúdo teórico.

**Aula 2 — Criando o Banco de Dados FinanceDB**

Conteúdo esperado:
- O que é um banco de dados no contexto do SQL Server
- Analogia do cotidiano para o banco de dados como um "cofre organizado"
- O que são os arquivos MDF e LDF e por que o SQL Server usa dois arquivos
- Conceito de instância do SQL Server
- Bancos de dados do sistema (master, model, msdb, tempdb) — apenas conceitual
- Comando CREATE DATABASE: sintaxe básica, explicação de cada parte
- Comando USE: para que serve e como usar
- Comando DROP DATABASE: o que faz e por que exige atenção redobrada
- Como visualizar o banco criado no SSMS (Object Explorer)
- Fluxo: VS Code → salvar como criar_banco.sql em aula_02/codigo/ → abrir no SSMS → executar
- Script comentado linha a linha
- Diagrama Mermaid mostrando a relação entre instância, banco de dados e arquivos MDF/LDF
- Glossário técnico da aula
- Antecipação de erros: banco já existe, permissão insuficiente, nome com caracteres inválidos
- Exercício de fixação com resolução comentada
- Log de Estado do Projeto atualizado
- Prompt de continuidade para a Aula 3

O documento inteiro deve estar dentro de um bloco ```markdown. Blocos internos de código SQL usam ~~~sql. Blocos de texto puro usam ~~~text. Diagramas usam ~~~mermaid. Nenhum bloco interno usa triple backtick. Não quebre linhas de parágrafos.
~~~

---

Dúvidas? Posso prosseguir para a Aula 2?