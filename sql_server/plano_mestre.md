# PASSO 1: O MAPA DA MINA
## Planejamento Mestre — SQL Server 2017 com T-SQL para Aplicações Financeiras

---

## DADOS DO AMBIENTE

- **Sistema Operacional:** Windows 11
- **IDEs:** VS Code + SQL Server Management Studio 21 (SSMS 21)
- **Versão do SQL Server:** 2017 (compatibilidade 140)
- **Perfil:** Profissional experiente em engenharia, iniciante em SQL Server e T-SQL
- **Foco:** Aplicações financeiras — precisão, integridade, auditoria, performance e segurança

---

## NOME DO PROJETO PRÁTICO INCREMENTAL

**FinanceCore DB — Sistema de Gestão Financeira Corporativa**

### Descrição do Projeto
Ao longo de todas as aulas, construiremos o FinanceCore DB: um banco de dados financeiro corporativo completo, cobrindo cadastro de clientes, contas bancárias, lançamentos financeiros, controle de saldo, conciliação, auditoria de operações, relatórios gerenciais e procedures de negócio. Ao final do curso, você terá um sistema robusto, seguro e performático — pronto para uso em ambiente de produção financeiro real.

---

## ESTRUTURA DE MÓDULOS

### MÓDULO 1 — ESSENCIAL: Fundamentos Sólidos
> Construção da base teórica e prática. Sem atalhos. Sem pular etapas.

- Aula 01 — Introdução ao SQL Server 2017: Arquitetura, Instâncias e o Ambiente Profissional
- Aula 02 — Criando o Banco de Dados FinanceCore: Filegroups, Arquivos e Configurações
- Aula 03 — Tipos de Dados no SQL Server: Escolhas Críticas para Sistemas Financeiros
- Aula 04 — DDL Completo: CREATE, ALTER, DROP — Construindo as Tabelas do FinanceCore
- Aula 05 — Constraints e Integridade: PRIMARY KEY, FOREIGN KEY, CHECK, DEFAULT, UNIQUE
- Aula 06 — DML Essencial: INSERT, UPDATE, DELETE com Segurança e Controle
- Aula 07 — SELECT Profundo: Filtragem, Ordenação, Aliases e Projeção de Dados
- Aula 08 — Joins e Relacionamentos: INNER, LEFT, RIGHT, FULL OUTER e CROSS JOIN
- Aula 09 — Funções de Agregação: SUM, COUNT, AVG, MIN, MAX e GROUP BY Financeiro
- Aula 10 — Subqueries e CTEs: Consultas Aninhadas e Expressões de Tabela Comuns

### MÓDULO 2 — PROFICIENTE: T-SQL Avançado e Lógica de Negócio
> Aqui a linguagem T-SQL ganha vida. Programação real dentro do banco de dados.

- Aula 11 — T-SQL Procedural: Variáveis, Controle de Fluxo IF/ELSE, WHILE e CASE
- Aula 12 — Stored Procedures: Criando a Lógica de Negócio Financeira no Banco
- Aula 13 — Funções do Usuário: Scalar Functions e Table-Valued Functions Financeiras
- Aula 14 — Triggers: Automação, Auditoria e Integridade em Tempo Real
- Aula 15 — Transações e Controle de Concorrência: ACID, BEGIN TRAN, COMMIT e ROLLBACK
- Aula 16 — Tratamento de Erros: TRY/CATCH, RAISERROR e Mensagens Customizadas
- Aula 17 — Views: Camadas de Abstração e Segurança para Relatórios Financeiros
- Aula 18 — Funções de Janela (Window Functions): ROW_NUMBER, RANK, LAG, LEAD e Saldos Acumulados
- Aula 19 — Pivot e Unpivot: Relatórios Matriciais Financeiros
- Aula 20 — Cursores e Set-Based Operations: Quando Usar e Quando Evitar

### MÓDULO 3 — MESTRE: Performance, Segurança e Produção
> O diferencial de um DBA/Dev financeiro sênior. Código que aguenta o mundo real.

- Aula 21 — Índices: Clustered, Non-Clustered, Filtered e Columnstore para Finanças
- Aula 22 — Planos de Execução: Lendo e Otimizando Queries Financeiras
- Aula 23 — Estatísticas e Cardinality Estimator: Como o SQL Server Toma Decisões
- Aula 24 — Particionamento de Tabelas: Gerenciando Volumes Históricos Financeiros
- Aula 25 — In-Memory OLTP (Hekaton): Performance Extrema para Transações Financeiras
- Aula 26 — Segurança: Logins, Users, Roles, Schemas e Row-Level Security
- Aula 27 — Criptografia: TDE, Column-Level Encryption e Always Encrypted
- Aula 28 — Backup, Restore e Recovery: Estratégias para Ambientes Financeiros
- Aula 29 — SQL Server Agent: Agendamento de Jobs, Alertas e Automação
- Aula 30 — Auditoria Completa: SQL Server Audit, Change Data Capture e Temporal Tables

---

## ESTRUTURA DE PROGRESSÃO

~~~mermaid
graph TD
    A[Módulo 1: Essencial\nAulas 01-10] --> B[Módulo 2: Proficiente\nAulas 11-20]
    B --> C[Módulo 3: Mestre\nAulas 21-30]
    A --> |Fundação do FinanceCore DB| P[Projeto Prático]
    B --> |Lógica de Negócio Financeira| P
    C --> |Performance, Segurança e Produção| P
    P --> |Entregável Final| F[FinanceCore DB\nSistema Financeiro Completo]
~~~

---

## ESTIMATIVA DE TEMPO

| Módulo | Aulas | Tempo de Leitura | Tempo de Prática |
|--------|-------|-----------------|-----------------|
| Módulo 1 — Essencial | 10 aulas | ~5 horas | ~10 horas |
| Módulo 2 — Proficiente | 10 aulas | ~5 horas | ~12 horas |
| Módulo 3 — Mestre | 10 aulas | ~5 horas | ~15 horas |
| **Total** | **30 aulas** | **~15 horas** | **~37 horas** |

> Estimativa total: **~52 horas de estudo e prática** para domínio completo.

---

## ESTRUTURA DO REPOSITÓRIO GITHUB

~~~text
financecore-db/
├── README.md
├── plano_mestre.txt
├── prompts_individuais.md
├── log_estado_projeto.md
├── .gitignore
├── modulo_01_essencial/
│   ├── aula_01/
│   │   ├── README.md
│   │   ├── codigo/
│   │   │   └── aula_01_setup.sql
│   │   ├── exercicios/
│   │   │   └── exercicio_01.md
│   │   └── respostas/
│   │       └── resposta_01.sql
│   ├── aula_02/ ... aula_10/
├── modulo_02_proficiente/
│   ├── aula_11/ ... aula_20/
├── modulo_03_mestre/
│   ├── aula_21/ ... aula_30/
└── financecore_completo/
    ├── schema_completo.sql
    ├── dados_seed.sql
    └── procedures_completas.sql
~~~

---

## ARQUIVO prompts_individuais.md — PRÉVIA DA ESTRUTURA

Ao final de cada aula, gerarei o prompt exato para acionar a aula seguinte. O arquivo `prompts_individuais.md` acumulará todos esses prompts, organizados por número de aula, para que você possa retomar o curso a qualquer momento com total contexto.

---

## CONFIGURAÇÃO DO AMBIENTE (RESUMO)

- **SQL Server 2017:** Instância local instalada no Windows 11
- **SSMS 21:** Ferramenta principal de administração e execução de queries
- **VS Code:** Editor de código com extensão mssql (Microsoft SQL Server) para edição e versionamento dos scripts .sql
- **GitHub Desktop ou Git for Windows:** Para versionamento do repositório FinanceCore DB

---

## PRÓXIMA AÇÃO OBRIGATÓRIA

Por favor, Thiago:

1. Salve este planejamento como `plano_mestre.txt` no seu computador.
2. Crie a pasta raiz `financecore-db/` no seu ambiente local.
3. Se quiser já versionar: inicialize um repositório Git nessa pasta (`git init`).
4. Anexe o arquivo `plano_mestre.txt` nas próximas sessões para manter o contexto completo.

---

**Dúvidas sobre o planejamento? Quer ajustar algum módulo, adicionar tópicos ou reorganizar aulas?**
**Quando estiver pronto, confirme com "Pode prosseguir" e inicio a Aula 01 completa.**