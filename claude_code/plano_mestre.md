# PASSO 1: O MAPA DA MINA
## Plano Mestre — Claude Code para Desenvolvimento e Manutenção de Aplicações Java
### Versão 1.0 | Tutor Sênior | Windows 11 | VS Code | Versões Latest

---

## 1. VISÃO GERAL DO CURSO

**Tema:** Usar o Claude Code como ferramenta central de desenvolvimento, manutenção, refatoração e automação de aplicações Java no ambiente Windows 11 com VS Code.

**Perfil do Aluno:** Profissional experiente em engenharia, iniciante no uso do Claude Code como ferramenta de desenvolvimento Java.

**Filosofia:** Cada aula é uma camada de conhecimento construída sobre a anterior. O projeto prático começa na Aula 1 e evolui até se tornar uma aplicação Java completa, mantida e evoluída com Claude Code do início ao fim.

---

## 2. AMBIENTE E CONFIGURAÇÃO

- **Sistema Operacional:** Windows 11
- **IDE:** VS Code (com extensões Java e Claude Code)
- **Linguagem:** Java (latest LTS — atualmente Java 21)
- **Build Tool:** Maven (latest) e/ou Gradle (latest), conforme aula
- **Claude Code:** Versão CLI latest (via npm)
- **Framework:** Spring Boot (latest) nas aulas de aplicação web
- **Controle de Versão:** Git + GitHub

---

## 3. PROJETO PRÁTICO INCREMENTAL

### Nome do Projeto: TaskFlow API

**Descrição:** Uma API REST de gerenciamento de tarefas (Task Manager) desenvolvida em Java com Spring Boot, construída e mantida integralmente com Claude Code. O projeto simula um cenário real de desenvolvimento profissional — desde a estrutura inicial até refatoração, testes, documentação e manutenção contínua.

**Por que este projeto?**
- Abrange os principais cenários de uso do Claude Code: criar, refatorar, testar, documentar e corrigir bugs.
- É familiar o suficiente para focar no aprendizado do Claude Code, sem sobrecarga cognitiva no domínio do problema.
- Evolui naturalmente de simples para complexo, espelhando projetos reais.

**Entregável Final:** API REST funcional com endpoints CRUD, testes unitários e de integração, documentação gerada com Claude Code, pipeline de CI básico e histórico Git com commits semânticos — tudo orquestrado pelo Claude Code.

---

## 4. ESTRUTURA DE MÓDULOS E AULAS

---

### MÓDULO 1 — ESSENCIAL: Fundamentos e Configuração
**Objetivo:** Dominar o ambiente, entender o que é o Claude Code e fazer as primeiras interações reais com código Java.

---

#### Aula 1: O que é o Claude Code e por que ele muda tudo
**Objetivo:** Entender o modelo mental do Claude Code — o que é, como funciona, onde vive, qual é sua diferença para um chatbot comum e por que ele é uma ferramenta de engenharia, não apenas de assistência.
**Entregável:** Nenhum código ainda. Mapa mental claro do ecossistema Claude Code.
**Tempo estimado:** 30 min de leitura

---

#### Aula 2: Instalação e Configuração do Ambiente Completo
**Objetivo:** Instalar e configurar Java 21, Maven, Git, VS Code com extensões Java, Node.js (para CLI do Claude Code) e o próprio Claude Code no Windows 11. Validar que tudo funciona com o primeiro comando real.
**Entregável:** Ambiente 100% funcional. Primeiro `claude` no terminal respondendo corretamente.
**Tempo estimado:** 30 min de leitura

---

#### Aula 3: Anatomia do Claude Code — CLI, Contexto e Sessões
**Objetivo:** Entender a interface de linha de comando do Claude Code, como ele lê arquivos, como funciona o contexto de sessão, quais são os comandos principais e como ele "enxerga" seu projeto.
**Entregável:** Primeiros comandos Claude Code explorando a estrutura de um projeto Java de exemplo.
**Tempo estimado:** 30 min de leitura

---

#### Aula 4: Criando o Projeto TaskFlow API do Zero com Claude Code
**Objetivo:** Usar o Claude Code para gerar a estrutura inicial do projeto Spring Boot (TaskFlow API), configurar o pom.xml, criar os pacotes base e validar que a aplicação sobe corretamente.
**Entregável:** Projeto TaskFlow API rodando localmente com `mvn spring-boot:run`, gerado pelo Claude Code.
**Tempo estimado:** 30 min de leitura

---

#### Aula 5: Engenharia de Prompts para Desenvolvedores Java
**Objetivo:** Aprender a escrever prompts técnicos eficazes para o Claude Code no contexto Java — como dar contexto, como pedir código específico, como iterar, como evitar respostas genéricas e como estruturar tarefas complexas em etapas.
**Entregável:** Biblioteca pessoal de prompts reutilizáveis para tarefas Java comuns.
**Tempo estimado:** 30 min de leitura

---

### MÓDULO 2 — PROFICIENTE: Desenvolvimento Ativo com Claude Code
**Objetivo:** Usar o Claude Code como copiloto real de desenvolvimento — criando features, refatorando, testando e documentando o TaskFlow API.

---

#### Aula 6: Criando Entidades, Repositórios e Services com Claude Code
**Objetivo:** Usar o Claude Code para gerar as camadas de domínio do TaskFlow API — entidade Task, repositório JPA, service com regras de negócio — com código limpo, comentado e funcional.
**Entregável:** Camada de domínio completa do TaskFlow API (Task, TaskRepository, TaskService).
**Tempo estimado:** 30 min de leitura

---

#### Aula 7: Criando Controllers REST e DTOs com Claude Code
**Objetivo:** Usar o Claude Code para criar os endpoints REST do TaskFlow API (CRUD completo), implementar DTOs, validações com Bean Validation e tratamento de exceções global.
**Entregável:** API REST com endpoints GET, POST, PUT, DELETE funcionais e testáveis via curl ou Postman.
**Tempo estimado:** 30 min de leitura

---

#### Aula 8: Refatoração Inteligente com Claude Code
**Objetivo:** Aprender a usar o Claude Code para identificar e refatorar código problemático — extrair métodos, renomear variáveis, aplicar padrões de design (Strategy, Factory), reduzir complexidade ciclomática e melhorar legibilidade sem quebrar comportamento.
**Entregável:** TaskFlow API com código refatorado, mais limpo e documentado internamente.
**Tempo estimado:** 30 min de leitura

---

#### Aula 9: Geração e Manutenção de Testes com Claude Code
**Objetivo:** Usar o Claude Code para gerar testes unitários (JUnit 5 + Mockito) e de integração (Spring Boot Test) para o TaskFlow API, entender como iterar sobre testes que falham e como manter cobertura alta sem esforço manual excessivo.
**Entregável:** Suite de testes completa para o TaskFlow API com cobertura mínima de 80%.
**Tempo estimado:** 30 min de leitura

---

#### Aula 10: Documentação Técnica Automatizada com Claude Code
**Objetivo:** Usar o Claude Code para gerar Javadoc, comentários inline inteligentes, README do projeto, documentação da API (OpenAPI/Swagger) e changelogs baseados no histórico Git.
**Entregável:** TaskFlow API com documentação completa — Javadoc, README, Swagger UI funcional.
**Tempo estimado:** 30 min de leitura

---

### MÓDULO 3 — MESTRE: Manutenção, Otimização e Fluxos Avançados
**Objetivo:** Dominar os fluxos avançados do Claude Code — debug, análise de performance, segurança, automação de tarefas repetitivas e integração com pipelines CI/CD.

---

#### Aula 11: Debug e Correção de Bugs com Claude Code
**Objetivo:** Usar o Claude Code para identificar, analisar e corrigir bugs reais — aprender a apresentar erros de forma eficaz, interpretar stack traces com auxílio do Claude Code e validar correções com testes.
**Entregável:** TaskFlow API com bugs intencionalmente inseridos, identificados e corrigidos via Claude Code.
**Tempo estimado:** 30 min de leitura

---

#### Aula 12: Análise de Performance e Otimização com Claude Code
**Objetivo:** Usar o Claude Code para identificar gargalos de performance no código Java — queries N+1, uso inadequado de streams, alocação excessiva de memória — e aplicar otimizações com explicação técnica.
**Entregável:** TaskFlow API com análise de performance documentada e otimizações aplicadas.
**Tempo estimado:** 30 min de leitura

---

#### Aula 13: Segurança e Code Review com Claude Code
**Objetivo:** Usar o Claude Code para realizar code review automatizado focado em segurança — identificar vulnerabilidades comuns (SQL Injection, exposição de dados sensíveis, autenticação fraca), sugerir correções e aplicar boas práticas de segurança Java.
**Entregável:** Relatório de segurança do TaskFlow API gerado pelo Claude Code + correções aplicadas.
**Tempo estimado:** 30 min de leitura

---

#### Aula 14: Automação de Tarefas Repetitivas com Claude Code
**Objetivo:** Usar o Claude Code para automatizar tarefas comuns de manutenção — atualização de dependências, migração de versões Java, padronização de código (formatação, imports), geração de boilerplate e scripts de automação.
**Entregável:** Scripts e workflows reutilizáveis para automação de manutenção Java com Claude Code.
**Tempo estimado:** 30 min de leitura

---

#### Aula 15: Claude Code em Fluxos CI/CD e o Desenvolvedor do Futuro
**Objetivo:** Integrar o Claude Code em pipelines GitHub Actions, entender como usar o Claude Code em revisões de PR automatizadas, consolidar todo o aprendizado do curso e traçar o roadmap do desenvolvedor Java aumentado por IA.
**Entregável:** Pipeline GitHub Actions completo para o TaskFlow API com etapa de análise Claude Code. Versão final do projeto entregue e documentada.
**Tempo estimado:** 30 min de leitura

---

## 5. ESTRUTURA DE PROGRESSÃO

~~~mermaid
graph TD
    M1[MÓDULO 1 — ESSENCIAL] --> M2[MÓDULO 2 — PROFICIENTE]
    M2 --> M3[MÓDULO 3 — MESTRE]

    M1 --> A1[Aula 1: O que é Claude Code]
    M1 --> A2[Aula 2: Instalação e Configuração]
    M1 --> A3[Aula 3: CLI, Contexto e Sessões]
    M1 --> A4[Aula 4: Criando o TaskFlow API]
    M1 --> A5[Aula 5: Engenharia de Prompts]

    M2 --> A6[Aula 6: Entidades, Repos e Services]
    M2 --> A7[Aula 7: Controllers REST e DTOs]
    M2 --> A8[Aula 8: Refatoração Inteligente]
    M2 --> A9[Aula 9: Testes com Claude Code]
    M2 --> A10[Aula 10: Documentação Automatizada]

    M3 --> A11[Aula 11: Debug e Correção de Bugs]
    M3 --> A12[Aula 12: Performance e Otimização]
    M3 --> A13[Aula 13: Segurança e Code Review]
    M3 --> A14[Aula 14: Automação de Tarefas]
    M3 --> A15[Aula 15: CI/CD e o Futuro]
~~~

---

## 6. TEMPO ESTIMADO

| Módulo | Aulas | Tempo de Leitura | Tempo com Prática |
|---|---|---|---|
| Módulo 1 — Essencial | 5 aulas | ~2,5 horas | ~5 horas |
| Módulo 2 — Proficiente | 5 aulas | ~2,5 horas | ~6 horas |
| Módulo 3 — Mestre | 5 aulas | ~2,5 horas | ~7 horas |
| **Total** | **15 aulas** | **~7,5 horas** | **~18 horas** |

---

## 7. ESTRUTURA DO REPOSITÓRIO GITHUB

~~~text
taskflow-api/
├── README.md
├── plano_mestre.txt
├── log_estado_projeto.md
├── .gitignore
├── pom.xml
├── src/
│   ├── main/
│   │   ├── java/com/taskflow/
│   │   └── resources/
│   └── test/
│       └── java/com/taskflow/
├── aula_01/
│   ├── README.md
│   └── exercicios/
├── aula_02/
│   ├── README.md
│   ├── exercicios/
│   └── respostas/
└── ... (aulas 03 a 15)
~~~

---

## 8. INSTRUÇÕES DE SALVAMENTO

**Ação necessária antes de prosseguir:**

1. Copie todo o conteúdo deste bloco.
2. Salve como `plano_mestre.txt` na raiz do seu projeto.
3. Nas próximas sessões, anexe este arquivo para que eu mantenha o contexto completo do curso.
4. Confirme quando estiver pronto para iniciarmos a Aula 1.

---

## 9. LOG DE ESTADO INICIAL

| Campo | Valor |
|---|---|
| Aula Atual | — (aguardando início) |
| Projeto | TaskFlow API |
| Estado | 🟡 Planejamento concluído |
| Próxima Etapa | Aula 1 — O que é o Claude Code e por que ele muda tudo |

---

*Pronto para iniciar, Thiago? Confirme quando tiver salvo o plano_mestre.txt e podemos começar a Aula 1.*