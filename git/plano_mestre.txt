# PASSO 1: O MAPA DA MINA
## Planejamento Mestre — GIT para Grandes Aplicações com Node.js

---

## Configuração do Ambiente Detectada

-   **Sistema Operacional:** Windows 11
-   **IDE/Editor:** VS Code
-   **Versão do Git:** Mais recente
-   **Público-alvo:** Iniciante em Git, com experiência em engenharia de software
-   **Foco:** Git do zero ao domínio, com teoria sólida, prática incremental e aplicação em grandes aplicações.

---

## Filosofia e Metodologia do Curso

Este curso é estruturado sobre duas bases pedagógicas complementares: a **Metodologia ADDIE** e a **Taxonomia de Bloom**. A **Metodologia ADDIE** organiza o curso em cinco fases — **Análise** (identificar o que o aluno precisa aprender), **Design** (planejar a estrutura e os materiais), **Desenvolvimento** (criar o conteúdo detalhado e prático), **Implementação** (apresentar cada aula com confirmação do aluno) e **Avaliação** (validar a compreensão por meio de desafios e do projeto incremental). A **Taxonomia de Bloom** garante que cada aula evolua em complexidade cognitiva: partimos de **Lembrar** e **Compreender** (teoria e analogias), passamos por **Aplicar** e **Analisar** (projeto prático e exercícios) e chegamos a **Avaliar** e **Criar** (desafios e projeto final). Juntas, essas metodologias garantem que nenhum conceito seja apresentado sem que o anterior tenha sido solidamente construído.

A **Técnica de Feynman** permeia todas as aulas: cada conceito técnico novo é explicado como se o aluno nunca tivesse ouvido falar sobre ele, com analogias do cotidiano que ancoram o entendimento antes de qualquer formalização técnica. O resultado é uma narrativa densa, literária e profundamente conectada à prática.

---

## Nome e Objetivo do Projeto Prático Incremental

**Nome do Projeto:** BarberShop API — Sistema de Agendamento para Barbearias

**Descrição:** Ao longo do curso, construiremos progressivamente uma API Node.js para agendamento de barbearias. Este projeto simulará um ambiente de desenvolvimento real onde múltiplos desenvolvedores colaboram, utilizando o Git para gerenciar o controle de versão de forma eficiente e segura. Começaremos com uma API Node.js simples e a expandiremos gradualmente, aplicando cada conceito do Git que aprendermos. Cada aula adicionará uma camada funcional ao projeto, de modo que ao final o aluno terá uma API funcional e um domínio completo das ferramentas Git.

---

## Divisão em Módulos

### Módulo 1 — ESSENCIAL: Fundamentos do Git Local (Aulas 1 a 5)
O aluno compreenderá os conceitos básicos do Git, como inicializar um repositório, acompanhar mudanças, registrar commits e navegar pelo histórico local.

### Módulo 2 — PROFICIENTE: Colaboração e Repositórios Remotos (Aulas 6 a 10)
O aluno aprenderá a interagir com repositórios remotos, clonar projetos, sincronizar mudanças e trabalhar com branches para isolar o desenvolvimento.

### Módulo 3 — AVANÇADO: Gerenciamento de Histórico e Boas Práticas (Aulas 11 a 15)
O aluno dominará técnicas para reorganizar o histórico de commits, gerenciar tags, salvar mudanças temporariamente, aplicar commits específicos e seguir boas práticas para um fluxo de trabalho eficiente.

---

## Lista Completa de Aulas

### MÓDULO 1 — ESSENCIAL: Fundamentos do Git Local

| # | Título da Aula | Objetivo Principal |
|---|---|---|
| 1 | Introdução ao Git e Controle de Versão | Entender o que é controle de versão, a importância do Git e instalar/configurar o ambiente |
| 2 | O Repositório Local: Inicializando e Acompanhando Mudanças | Inicializar um repositório Git, entender Working Directory, Staging Area e Local Repository, e usar `git add` e `git commit` |
| 3 | Entendendo o Histórico: Visualizando Commits | Visualizar o histórico de commits com `git log` e suas opções de formatação |
| 4 | Desfazendo Mudanças Locais: Restore e Reset | Desfazer alterações no Working Directory e Staging Area com `git restore` e voltar no tempo com `git reset` |
| 5 | Ignorando Arquivos: O .gitignore | Compreender e configurar o arquivo `.gitignore` para a API Node.js |

### MÓDULO 2 — PROFICIENTE: Colaboração e Repositórios Remotos

| # | Título da Aula | Objetivo Principal |
|---|---|---|
| 6 | Repositórios Remotos: Conectando-se ao GitHub | Entender repositórios remotos, criar um no GitHub e conectar o repositório local com `git remote add` e `git push` |
| 7 | Clonando e Sincronizando: git clone e git pull | Clonar um repositório existente com `git clone` e obter as últimas mudanças do remoto com `git pull` |
| 8 | Branches: Isolando o Desenvolvimento | Compreender branches, criar, listar e alternar entre elas com `git branch` e `git checkout` |
| 9 | Integrando Mudanças: git merge | Mesclar branches com `git merge`, entendendo Fast-Forward e 3-Way Merge, e resolvendo conflitos |
| 10 | Fluxo de Trabalho: Feature Branch Workflow | Aplicar o Feature Branch Workflow para organizar o desenvolvimento de funcionalidades |

### MÓDULO 3 — AVANÇADO: Gerenciamento de Histórico e Boas Práticas

| # | Título da Aula | Objetivo Principal |
|---|---|---|
| 11 | Reorganizando o Histórico: git rebase | Entender e usar `git rebase` para um histórico de commits mais limpo |
| 12 | Gerenciando Tags e Versões | Criar e gerenciar tags leves e anotadas com `git tag` para marcar versões |
| 13 | Stash: Salvando Mudanças Temporariamente | Utilizar `git stash` para guardar mudanças não commitadas e aplicá-las posteriormente |
| 14 | Boas Práticas e Convenções de Commits | Compreender a importância de mensagens de commit claras e seguir convenções de commits |
| 15 | Aplicando Commits Específicos: git cherry-pick | Entender e usar `git cherry-pick` para aplicar commits específicos de uma branch em outra |
| 16 | Revisão e Próximos Passos | Revisar os principais conceitos e comandos aprendidos, com desafios e recursos adicionais |

---

## Estrutura do Repositório GitHub

~~~text
barbershop-api/
├── .git/
├── .gitignore
├── README.md
├── package.json
├── server.js
├── aula_01/
│   ├── README.md
│   ├── codigo/
│   │   └── server.js
│   ├── exercicios/
│   │   └── exercicio_01.md
│   └── respostas/
│       └── resposta_01.md
├── aula_02/
│   ├── README.md
│   ├── codigo/
│   │   └── README.md
│   ├── exercicios/
│   │   └── exercicio_02.md
│   └── respostas/
│       └── resposta_02.md
└── ... (estrutura similar para as demais aulas)
~~~

## Objetivo do Repositório
O repositório `barbershop-api` servirá como o projeto prático incremental do curso. Cada aula terá sua própria pasta (`aula_XX/`) contendo o `README.md` da aula, o código relevante (`codigo/`), exercícios (`exercicios/`) e suas resoluções (`respostas/`). O objetivo é construir, do zero, uma API Node.js funcional, aplicando os conceitos do Git em cada etapa.

## Tecnologias
- Git (versão mais recente)
- Node.js
- Express.js
- VS Code
- GitHub
- Windows 11

## Estrutura
Cada módulo possui uma pasta com as aulas correspondentes.
Os arquivos de código contêm o código desenvolvido e comentado linha a linha.
A pasta `exercicios/` contém os desafios de cada aula.
A pasta `respostas/` contém as resoluções comentadas.

## Como Usar
1. Certifique-se de ter o Git e o Node.js instalados.
2. Abra o VS Code na pasta raiz do projeto `barbershop-api`.
3. Navegue até a pasta do módulo e aula correspondente.
4. Siga as instruções no `README.md` de cada aula para configurar e executar o código.
5. Consulte o `log_estado_projeto.md` para acompanhar o progresso.

## Módulos
- Módulo 1: Essencial — Fundamentos do Git Local (Aulas 1-5)
- Módulo 2: Proficiente — Colaboração e Repositórios Remotos (Aulas 6-10)
- Módulo 3: Avançado — Gerenciamento de Histórico e Boas Práticas (Aulas 11-16)

---

## Conteúdo do arquivo .gitignore

~~~text
# Node.js
node_modules/
npm-debug.log
.env

# Logs
*.log

# OS generated files
.DS_Store
Thumbs.db
~~~

---

## Boas Práticas de Versionamento

Ao longo do curso, cada aula deve ser registrada no repositório com um **commit semântico**, seguindo o padrão **Conventional Commits**. Os padrões recomendados são: **feat:** para adição de nova funcionalidade, **fix:** para correção de um bug, **docs:** para documentação, **chore:** para tarefas de manutenção, **refactor:** para refatoração, **style:** para formatação, e **test:** para testes. Exemplos práticos: `feat: inicializa api de agendamento` na Aula 2, `feat: adiciona rota de agendamento` na Aula 8, e `docs: atualiza log_estado_projeto aula 5` após cada aula concluída. Ao final de cada módulo, recomenda-se criar uma **tag** de versão para marcar o marco atingido: `v1.0-fundamentos`, `v2.0-colaboracao` e `v3.0-avancado`.

---

## Log de Estado Inicial do Projeto

~~~text
## Estado Inicial — Antes da Aula 1
- Projeto: BarberShop API
- Status: Aguardando início
- Repositório Git: Não inicializado
- Código da API: Não criado
- Módulo Atual: Módulo 1 — Essencial: Fundamentos do Git Local
- Próximas Etapas: Aula 1 apresentará o controle de versão e a instalação do Git.
~~~

---

## Apêndice — Referências e Recursos

### Documentação Oficial

-   **Documentação Oficial do Git:** https://git-scm.com/doc
-   **Node.js Documentation:** https://nodejs.org/docs/latest/api/
-   **Express.js Documentation:** https://expressjs.com/
-   **GitHub Docs:** https://docs.github.com/

### Livros Recomendados

-   **"Pro Git Book"** — Scott Chacon e Ben Straub (Apress): A bíblia do Git, disponível online gratuitamente.
-   **"Version Control with Git"** — Jon Loeliger e Matthew McCullough (O'Reilly): Um guia prático para o Git.

### Comunidades e Fóruns

-   **Stack Overflow — tag git:** https://stackoverflow.com/questions/tagged/git
-   **Stack Overflow — tag node.js:** https://stackoverflow.com/questions/tagged/node.js
-   **Reddit r/git:** https://www.reddit.com/r/git/

### Ferramentas Recomendadas

-   **VS Code:** Editor de código padrão para o curso.
-   **Git para Windows:** https://git-scm.com/download/win
-   **Node.js:** https://nodejs.org/en/download/

---

## Tempo Estimado do Curso

-   **16 aulas** com aproximadamente **30 a 40 minutos de leitura** cada
-   **Tempo total estimado:** 8 a 10 horas de estudo
-   **Ritmo sugerido:** 2 a 3 aulas por semana, com prática entre as aulas
-   **Duração aproximada:** 5 a 7 semanas
-   **Projeto prático:** construído incrementalmente ao longo de todas as aulas

---