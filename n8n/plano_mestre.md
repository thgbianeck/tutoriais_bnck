# Plano Mestre de Aprendizado: Dominando o n8n do Zero ao Avançado

## Nome e Objetivo do Projeto Prático Incremental

Nosso projeto prático incremental será a construção de um **"Sistema de Automação de Notificações e Processamento de Dados Simples"**. O objetivo é criar um fluxo de trabalho automatizado que receba dados de uma fonte (simulada ou real, conforme avançarmos), processe-os de forma básica e envie uma notificação ou salve os dados em outro local. Este projeto nos permitirá explorar os principais conceitos do n8n de forma prática e incremental, construindo uma solução funcional passo a passo.

## Divisão em Módulos

Para garantir uma progressão lógica e um aprendizado sólido, dividiremos o curso em três módulos principais:

### Módulo 1: Essencial (Fundamentos do n8n)
Este módulo cobrirá os conceitos básicos e a configuração inicial do n8n. O foco será entender o que é o n8n, como instalá-lo e configurá-lo, e como criar seus primeiros fluxos de trabalho simples. Abordaremos a interface, os tipos de nós fundamentais e a lógica de execução.

### Módulo 2: Proficiente (Prática e Integrações Básicas)
Neste módulo, aprofundaremos na criação de fluxos de trabalho mais elaborados, explorando diferentes tipos de nós, manipulação de dados e integrações com serviços externos populares. O projeto prático começará a tomar forma, com a adição de funcionalidades de processamento e conexão com outras ferramentas.

### Módulo 3: Mestre (Otimização e Boas Práticas)
O módulo final se concentrará em otimização, tratamento de erros, agendamento de fluxos e boas práticas de desenvolvimento no n8n. Exploraremos recursos mais avançados para tornar os fluxos de trabalho robustos, eficientes e escaláveis, consolidando o domínio sobre a ferramenta.

## Lista de Aulas

A seguir, a lista de aulas planejadas, cada uma com aproximadamente 30 minutos de leitura e cerca de 2.000 palavras, garantindo profundidade e detalhe.

### Módulo 1: Essencial (Fundamentos do n8n)

| # | Título da Aula | Objetivo Principal |
|---|---|---|
| 1 | Introdução ao n8n: O que é e Por Que Usar? | Compreender o conceito de automação, o papel do n8n e suas principais vantagens. |
| 2 | Instalação e Configuração do n8n no Windows 11 | Instalar o n8n localmente e configurar o ambiente de trabalho. |
| 3 | Explorando a Interface do n8n: Workflows, Nós e Conexões | Familiarizar-se com a interface do usuário do n8n e seus componentes principais. |
| 4 | Seu Primeiro Workflow: Hello World com o n8n | Criar e executar um workflow simples para entender o fluxo de dados. |
| 5 | Tipos de Nós Fundamentais: Triggers e Nodes de Operação | Entender a diferença entre nós de gatilho (Trigger) e nós de operação, e como usá-los. |

### Módulo 2: Proficiente (Prática e Integrações Básicas)

| # | Título da Aula | Objetivo Principal |
|---|---|---|
| 6 | Manipulando Dados: O Nó Function e Expressões Básicas | Aprender a manipular dados dentro dos workflows usando o nó Function e expressões. |
| 7 | Conectando com Serviços Externos: O Nó HTTP Request | Entender como o n8n pode interagir com APIs externas usando o nó HTTP Request. |
| 8 | Tomada de Decisão: O Nó IF e Lógica Condicional | Implementar lógica condicional nos workflows para direcionar o fluxo de dados. |
| 9 | Iterando sobre Dados: O Nó Split In Batches e Loop | Aprender a processar listas de itens individualmente ou em lotes. |
| 10 | Armazenando Dados: O Nó Write Binary File e Integração com Google Sheets (Exemplo) | Salvar dados processados em arquivos ou em serviços de armazenamento. |

### Módulo 3: Mestre (Otimização e Boas Práticas)

| # | Título da Aula | Objetivo Principal |
|---|---|---|
| 11 | Agendamento e Execução de Workflows: Cron e Webhooks | Configurar workflows para serem executados automaticamente em intervalos ou por eventos externos. |
| 12 | Tratamento de Erros e Resiliência de Workflows | Implementar mecanismos para lidar com falhas e garantir a robustez dos workflows. |
| 13 | Boas Práticas e Organização de Workflows | Aprender a organizar, documentar e manter workflows de forma eficiente. |
| 14 | Variáveis de Ambiente e Credenciais Seguras | Gerenciar informações sensíveis e configurações de ambiente de forma segura. |
| 15 | Deploy e Monitoramento Básico do n8n | Entender as opções de deploy e como monitorar a execução dos workflows. |

## Estrutura de Progressão

~~~mermaid
graph TD
    M1[MÓDULO 1: Essencial (Fundamentos do n8n)]
    M2[MÓDULO 2: Proficiente (Prática e Integrações Básicas)]
    M3[MÓDULO 3: Mestre (Otimização e Boas Práticas)]

    M1 --> M2
    M2 --> M3

    M1 --> A1[Aula 1: Introdução ao n8n]
    M1 --> A2[Aula 2: Instalação e Configuração]
    M1 --> A3[Aula 3: Explorando a Interface]
    M1 --> A4[Aula 4: Seu Primeiro Workflow]
    M1 --> A5[Aula 5: Tipos de Nós Fundamentais]

    M2 --> A6[Aula 6: Manipulando Dados]
    M2 --> A7[Aula 7: Conectando com Serviços Externos]
    M2 --> A8[Aula 8: Tomada de Decisão]
    M2 --> A9[Aula 9: Iterando sobre Dados]
    M2 --> A10[Aula 10: Armazenando Dados]

    M3 --> A11[Aula 11: Agendamento e Execução]
    M3 --> A12[Aula 12: Tratamento de Erros]
    M3 --> A13[Aula 13: Boas Práticas]
    M3 --> A14[Aula 14: Variáveis de Ambiente]
    M3 --> A15[Aula 15: Deploy e Monitoramento]
~~~

## Estrutura de Pastas do Projeto

~~~text
automacao_n8n/
├── README.md
├── plano_mestre.txt
├── log_estado_projeto.md
├── modulo_01_essencial/
│   ├── aula_01/
│   │   ├── README.md
│   │   ├── workflows/
│   │   │   └── hello_world.json
│   │   ├── exercicios/
│   │   │   └── exercicio_01.md
│   │   └── respostas/
│   │       └── resposta_01.json
│   ├── aula_02/
│   ├── aula_03/
│   ├── aula_04/
│   └── aula_05/
├── modulo_02_proficiente/
│   ├── aula_06/
│   │   ├── README.md
│   │   ├── workflows/
│   │   │   └── processamento_dados_simples.json
│   │   ├── exercicios/
│   │   │   └── exercicio_06.md
│   │   └── respostas/
│   │       └── resposta_06.json
│   ├── aula_07/ ... aula_10/
├── modulo_03_mestre/
│   ├── aula_11/ ... aula_15/
│   └── projeto_final/
│       └── sistema_notificacoes_completo.json
└── .gitignore
~~~

## Conteúdo do arquivo README.md

~~~text
# Sistema de Automação de Notificações e Processamento de Dados Simples

## Descrição
Projeto prático incremental desenvolvido ao longo do curso
"Dominando o n8n do Zero ao Avançado".
O objetivo é construir, do zero, um sistema de automação que receba dados,
processe-os de forma básica e envie notificações ou salve os dados.

## Tecnologias
- n8n (última versão)
- Windows 11

## Estrutura
Cada módulo possui uma pasta com as aulas correspondentes.
Os arquivos .json contêm os workflows do n8n desenvolvidos e comentados.
A pasta exercicios/ contém os desafios de cada aula.
A pasta respostas/ contém as resoluções comentadas dos workflows.

## Como Usar
1. Certifique-se de que o n8n esteja instalado e em execução.
2. Navegue até a pasta do módulo e aula correspondente.
3. Importe o arquivo .json do workflow para o n8n.
4. Consulte o log_estado_projeto.md para acompanhar o progresso.

## Módulos
- Módulo 1: Essencial (Fundamentos do n8n)
- Módulo 2: Proficiente (Prática e Integrações Básicas)
- Módulo 3: Mestre (Otimização e Boas Práticas)
~~~

## Conteúdo do arquivo .gitignore

~~~text
# n8n
.n8n/
*.log
*.sqlite
*.db

# Windows
Thumbs.db
desktop.ini
~~~

## Boas Práticas de Versionamento

Ao longo do curso, cada aula deve ser registrada no repositório com um **commit semântico**, seguindo o padrão **Conventional Commits**. Os padrões recomendados são: **feat:** para adição de nova funcionalidade ou workflow, **fix:** para correção de um workflow com erro, **docs:** para atualização de README ou log, e **chore:** para tarefas de configuração e organização. Exemplos práticos: `feat: cria workflow hello world` na Aula 4, `feat: adiciona processamento de dados simples` na Aula 6, e `docs: atualiza log_estado_projeto aula 8` após cada aula concluída. Ao final de cada módulo, recomenda-se criar uma **tag** de versão para marcar o marco atingido: `v1.0-essencial`, `v2.0-proficiente`, e `v3.0-mestre`.

## Log de Estado Inicial do Projeto

~~~text
## Estado Inicial — Antes da Aula 1
- Projeto: Sistema de Automação de Notificações e Processamento de Dados Simples
- Status: Aguardando início
- Workflows: Nenhum
- Módulo Atual: Módulo 1 — Essencial (Fundamentos do n8n)
- Próximas Etapas: Aula 1 apresentará o conceito de automação e o papel do n8n.
~~~

## Apêndice — Referências e Recursos

### Documentação Oficial

- **Documentação Oficial do n8n:** https://docs.n8n.io/
- **Comunidade n8n:** https://community.n8n.io/

### Ferramentas Recomendadas

- **n8n Desktop App (para Windows):** Para uma instalação local fácil.
- **VS Code:** Para editar arquivos de texto, como o `README.md` e o `log_estado_projeto.md`.
- **Git para Windows:** https://git-scm.com/download/win

## Tempo Estimado do Curso

- **15 aulas** com aproximadamente **30 a 40 minutos de leitura** cada
- **Tempo total estimado:** 8 a 10 horas de estudo
- **Ritmo sugerido:** 2 a 3 aulas por semana, com prática entre as aulas
- **Duração aproximada:** 5 a 7 semanas
- **Projeto prático:** construído incrementalmente ao longo de todas as aulas

## Instrução para o Aluno

Salve este planejamento como **plano_mestre.txt** na pasta raiz do seu projeto **automacao_n8n**. Ele será sua bússola durante todo o curso — sempre que tiver dúvidas sobre onde estamos ou para onde vamos, consulte este arquivo. Ao iniciar cada nova sessão de estudo, anexe este arquivo para garantir que o contexto do curso seja preservado com precisão.

## ✅ Planejamento Concluído

O **Mapa da Mina** está pronto. Temos **15 aulas** organizadas em **3 módulos**, cobrindo desde a introdução ao n8n até o deploy e monitoramento básico. O projeto prático incremental **"Sistema de Automação de Notificações e Processamento de Dados Simples"** evolui em todos os módulos, com estrutura de pastas organizada por módulo e aula, boas práticas de versionamento com **Conventional Commits**, apêndice completo de referências e log de estado inicial registrado.

---

Dúvidas? Posso prosseguir para a **Aula 1: Introdução ao n8n: O que é e Por Que Usar?**