# PASSO 1: O MAPA DA MINA — Planejamento Mestre do Curso (Revisado)

## SQL Server para Aplicações Financeiras com T-SQL

---

## Informações do Ambiente

- **Sistema Operacional:** Windows 11
- **Editor de Arquivos do Projeto:** Visual Studio Code (VS Code) — para editar, organizar e versionar arquivos `.sql`, `.md` e demais arquivos do projeto
- **Execução de Comandos SQL:** SQL Server Management Studio 21 (SSMS 21) — para conectar ao SQL Server, executar scripts e visualizar resultados
- **Versão do SQL Server:** SQL Server 2022
- **Perfil do Aluno:** Iniciante absoluto em SQL/T-SQL, com experiência em engenharia
- **Foco:** Conceitos básicos, sintaxe T-SQL, construção progressiva do conhecimento

---

## Fluxo de Trabalho com as Duas Ferramentas

A separação entre editor e executor é uma prática profissional muito comum. Pense assim: o **VS Code** é sua **prancheta de projeto** — onde você escreve, organiza, versiona e documenta. O **SSMS 21** é sua **bancada de testes** — onde você conecta ao banco, executa os scripts e analisa os resultados. As duas ferramentas se complementam perfeitamente.

~~~mermaid
graph LR
    A[VS Code\nEditar e organizar arquivos .sql e .md] -->|Abre o arquivo ou copia o script| B[SSMS 21\nExecutar scripts e visualizar resultados]
    B -->|Resultados e ajustes| A
~~~

**Fluxo prático de cada aula:**
- Você escreve e salva o script `.sql` no **VS Code**
- Abre o SSMS 21, conecta ao SQL Server 2022 e abre ou cola o script
- Executa e analisa os resultados diretamente no SSMS 21
- Volta ao VS Code para ajustar, documentar e versionar

---

## Extensões Recomendadas para o VS Code

Para trabalhar com arquivos `.sql` e `.md` no VS Code de forma produtiva, instale as seguintes extensões:

- **SQL Server (mssql)** — da Microsoft: realce de sintaxe T-SQL, IntelliSense e execução direta de queries (opcional, mas útil para revisar scripts sem sair do VS Code)
- **Markdown All in One** — para visualizar e editar arquivos `.md` com conforto
- **GitLens** — para versionamento Git com interface visual dentro do VS Code
- **Material Icon Theme** — para identificar visualmente os tipos de arquivo nas pastas do projeto

---

## Nome e Objetivo do Projeto Prático Incremental

**Nome do Projeto:** `FinanceDB` — Sistema de Controle Financeiro Pessoal

**Descrição:** Ao longo do curso, você construirá um banco de dados completo para controle financeiro pessoal. Começando pela criação do banco e das primeiras tabelas, passando por inserção de dados, consultas, relacionamentos, funções financeiras e relatórios, até chegar a um sistema funcional com visões, procedimentos armazenados e boas práticas de segurança. Cada aula entrega uma parte funcional e testável do projeto.

**Por que este projeto?** Aplicações financeiras são o contexto ideal para aprender SQL: elas exigem precisão, integridade de dados, relacionamentos claros e consultas analíticas — exatamente o que o T-SQL oferece de melhor.

---

## Estrutura de Módulos

### Módulo 1 — Essencial: Fundamentos (Aulas 1 a 8)

Neste módulo você sairá do zero absoluto e chegará à capacidade de criar bancos de dados, tabelas, inserir dados e realizar consultas básicas. É a base sobre a qual tudo o mais será construído.

### Módulo 2 — Proficiente: Prática e Relacionamentos (Aulas 9 a 16)

Aqui você aprenderá a trabalhar com múltiplas tabelas, relacionamentos, junções (JOINs), agrupamentos, funções de agregação e subconsultas. Você começará a escrever consultas que respondem perguntas reais de negócio.

### Módulo 3 — Mestre: Otimização e Recursos Avançados (Aulas 17 a 24)

Neste módulo você dominará Views, Stored Procedures, funções definidas pelo usuário, tratamento de erros, transações, índices e boas práticas de segurança para ambientes financeiros.

---

## Lista Completa de Aulas

### Módulo 1 — Essencial: Fundamentos

**Aula 1 — O que é um Banco de Dados Relacional e por que o SQL Server?**
Conceito de banco de dados relacional, tabelas, linhas e colunas. Diferença entre banco de dados, SGBD e linguagem SQL. Apresentação do SQL Server 2022 e do SSMS 21. Configuração do VS Code como editor do projeto. Primeira conexão ao SSMS e tour pela interface. Nenhum script ainda — apenas compreensão conceitual e orientação de ambiente.

**Aula 2 — Criando o Banco de Dados FinanceDB**
Conceito de banco de dados no SQL Server, arquivos MDF e LDF, conceito de instância. Comando `CREATE DATABASE`. Comando `USE`. Comando `DROP DATABASE` (com cuidado). Primeira estrutura do projeto criada no VS Code e executada no SSMS.

**Aula 3 — Tipos de Dados no SQL Server: Escolhendo com Precisão**
Por que a escolha do tipo de dado importa em aplicações financeiras. Tipos numéricos (`INT`, `BIGINT`, `DECIMAL`, `NUMERIC`, `MONEY`). Tipos de texto (`VARCHAR`, `NVARCHAR`, `CHAR`). Tipos de data (`DATE`, `DATETIME`, `DATETIME2`). Tipo lógico (`BIT`). Como escolher o tipo certo para cada coluna.

**Aula 4 — Criando Tabelas: A Estrutura do FinanceDB**
Comando `CREATE TABLE`. Conceito de chave primária (`PRIMARY KEY`). Conceito de `NOT NULL` e `NULL`. Conceito de `DEFAULT`. Criação das primeiras tabelas do projeto: `Categorias` e `Contas`. Script escrito no VS Code e executado no SSMS.

**Aula 5 — Inserindo Dados: Populando o FinanceDB**
Comando `INSERT INTO ... VALUES`. Inserção de múltiplas linhas. Regras de inserção por tipo de dado (aspas para texto, formatos de data, valores decimais). Inserção nas tabelas `Categorias` e `Contas`.

**Aula 6 — Consultando Dados: O Comando SELECT**
Estrutura fundamental do `SELECT`. Seleção de todas as colunas com `*`. Seleção de colunas específicas. Uso de `AS` para aliases. Conceito de resultado (result set). Primeiras consultas no FinanceDB.

**Aula 7 — Filtrando Dados: A Cláusula WHERE**
Cláusula `WHERE` e operadores de comparação (`=`, `<>`, `>`, `<`, `>=`, `<=`). Operadores lógicos (`AND`, `OR`, `NOT`). Operador `BETWEEN`. Operador `IN`. Operador `LIKE` e curingas (`%`, `_`). Filtrando dados financeiros com precisão.

**Aula 8 — Ordenando e Limitando Resultados**
Cláusula `ORDER BY` (ASC e DESC). Cláusula `TOP`. Conceito de `NULL` em ordenações. Consultas ordenadas de extratos e lançamentos financeiros.

---

### Módulo 2 — Proficiente: Prática e Relacionamentos

**Aula 9 — Chaves Estrangeiras e Integridade Referencial**
Conceito de relacionamento entre tabelas. `FOREIGN KEY` e integridade referencial. `ON DELETE` e `ON UPDATE`. Criação da tabela `Lancamentos` com relacionamentos. Diagrama de relacionamentos do FinanceDB.

**Aula 10 — Alterando e Removendo Dados: UPDATE e DELETE**
Comando `UPDATE ... SET ... WHERE`. Comando `DELETE ... WHERE`. Perigos de executar sem `WHERE`. Boas práticas de segurança em ambientes financeiros. Auditoria de mudanças.

**Aula 11 — Alterando a Estrutura de Tabelas: ALTER TABLE**
Comando `ALTER TABLE` para adicionar, modificar e remover colunas. Restrições com `CONSTRAINT`. Adicionando colunas de auditoria (`DataCriacao`, `DataAtualizacao`) ao projeto.

**Aula 12 — Funções de Agregação: Resumindo Dados Financeiros**
Funções `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`. Cláusula `GROUP BY`. Cláusula `HAVING`. Relatórios de totais por categoria, saldo por conta e médias de gastos.

**Aula 13 — Junções entre Tabelas: INNER JOIN**
Conceito de JOIN e por que ele existe. `INNER JOIN` — apenas os registros que têm correspondência. Consultas cruzando `Lancamentos`, `Categorias` e `Contas`. Extratos completos com nomes de categorias.

**Aula 14 — Mais Junções: LEFT JOIN, RIGHT JOIN e conceito de FULL JOIN**
`LEFT JOIN` — todos os registros da tabela da esquerda. `RIGHT JOIN` — todos os registros da tabela da direita. Conceito de `FULL JOIN`. Identificando lançamentos sem categoria e contas sem movimentação.

**Aula 15 — Subconsultas: Consultas dentro de Consultas**
O que é uma subconsulta (subquery). Subconsultas na cláusula `WHERE`. Subconsultas na cláusula `SELECT`. Operadores `EXISTS` e `NOT EXISTS`. Consultas financeiras que dependem de resultados intermediários.

**Aula 16 — Funções de Data e Texto no T-SQL**
Funções de data: `GETDATE()`, `YEAR()`, `MONTH()`, `DAY()`, `DATEDIFF()`, `DATEADD()`, `FORMAT()`. Funções de texto: `LEN()`, `UPPER()`, `LOWER()`, `TRIM()`, `CONCAT()`, `SUBSTRING()`. Aplicações práticas em relatórios financeiros.

---

### Módulo 3 — Mestre: Otimização e Recursos Avançados

**Aula 17 — Views: Criando Janelas para seus Dados**
O que é uma View e por que usá-la. Comando `CREATE VIEW`. Benefícios de segurança e simplicidade. Criando views de extrato mensal e resumo por categoria no FinanceDB.

**Aula 18 — Stored Procedures: Automatizando Operações Financeiras**
O que é uma Stored Procedure. Comando `CREATE PROCEDURE`. Parâmetros de entrada. Executando com `EXEC`. Criando procedures para inserir lançamentos e gerar relatórios.

**Aula 19 — Variáveis e Controle de Fluxo no T-SQL**
Declaração de variáveis com `DECLARE` e `SET`. Estrutura `IF ... ELSE`. Estrutura `WHILE`. `PRINT` para debug. Lógica condicional em contextos financeiros.

**Aula 20 — Transações: Garantindo a Integridade Financeira**
O que é uma transação e por que é crítica em sistemas financeiros. `BEGIN TRANSACTION`, `COMMIT` e `ROLLBACK`. Propriedades ACID. Exemplo prático de transferência entre contas com segurança transacional.

**Aula 21 — Tratamento de Erros com TRY...CATCH**
Bloco `TRY...CATCH` no T-SQL. Funções `ERROR_MESSAGE()`, `ERROR_NUMBER()`, `ERROR_LINE()`. Combinando transações com tratamento de erros. Procedures robustas para o FinanceDB.

**Aula 22 — Funções Definidas pelo Usuário (UDFs)**
`CREATE FUNCTION` — funções escalares. Diferença entre funções e procedures. Criando funções financeiras reutilizáveis (ex: calcular saldo de uma conta em uma data).

**Aula 23 — Índices: Otimizando Consultas Financeiras**
O que é um índice e como funciona internamente. Índice Clustered vs. Non-Clustered. Quando criar e quando evitar índices. Criando índices estratégicos no FinanceDB.

**Aula 24 — Segurança, Boas Práticas e Conclusão do Projeto**
Logins e usuários no SQL Server. Permissões com `GRANT`, `DENY`, `REVOKE`. Boas práticas de nomenclatura, documentação e organização. Revisão completa do FinanceDB. Entregável final: o projeto completo e funcional.

---

## Estrutura de Progressão

~~~mermaid
graph TD
    A[Aula 1: Conceitos Relacionais] --> B[Aula 2: CREATE DATABASE]
    B --> C[Aula 3: Tipos de Dados]
    C --> D[Aula 4: CREATE TABLE]
    D --> E[Aula 5: INSERT INTO]
    E --> F[Aula 6: SELECT]
    F --> G[Aula 7: WHERE]
    G --> H[Aula 8: ORDER BY e TOP]
    H --> I[Aula 9: FOREIGN KEY]
    I --> J[Aula 10: UPDATE e DELETE]
    J --> K[Aula 11: ALTER TABLE]
    K --> L[Aula 12: Agregações]
    L --> M[Aula 13: INNER JOIN]
    M --> N[Aula 14: LEFT e RIGHT JOIN]
    N --> O[Aula 15: Subconsultas]
    O --> P[Aula 16: Funções de Data e Texto]
    P --> Q[Aula 17: Views]
    Q --> R[Aula 18: Stored Procedures]
    R --> S[Aula 19: Variáveis e Fluxo]
    S --> T[Aula 20: Transações]
    T --> U[Aula 21: TRY...CATCH]
    U --> V[Aula 22: UDFs]
    V --> W[Aula 23: Índices]
    W --> X[Aula 24: Segurança e Conclusão]
~~~

---

## Estrutura do Repositório / Pasta do Projeto

~~~text
FinanceDB/                        ← Pasta raiz do projeto (aberta no VS Code)
├── README.md                     ← Descrição geral do projeto
├── plano_mestre.txt              ← Este planejamento salvo como referência
├── log_estado_projeto.md         ← Log atualizado a cada aula
├── prompts_individuais.md        ← Prompts prontos para cada aula
├── .gitignore                    ← Arquivos a ignorar no versionamento
├── aula_01/
│   ├── README.md                 ← Resumo da aula e instruções
│   └── exercicios/
│       └── exercicio_01.md
├── aula_02/
│   ├── README.md
│   ├── codigo/
│   │   └── criar_banco.sql      ← Editado no VS Code, executado no SSMS
│   └── exercicios/
│       └── exercicio_02.md
├── aula_03/
│   └── ...
└── aula_24/
    └── ...
~~~

---

## Tempo Estimado

| Módulo | Aulas | Tempo de Leitura | Tempo com Prática |
|---|---|---|---|
| Módulo 1 — Essencial | 8 aulas | ~4 horas | ~8 horas |
| Módulo 2 — Proficiente | 8 aulas | ~4 horas | ~10 horas |
| Módulo 3 — Mestre | 8 aulas | ~4 horas | ~12 horas |
| **Total** | **24 aulas** | **~12 horas** | **~30 horas** |

---

## Log de Estado do Projeto (Inicial)

~~~text
## Estado Inicial
- Banco de dados: ❌ Ainda não criado
- Tabelas: ❌ Ainda não criadas
- Dados: ❌ Ainda não inseridos
- Projeto: ⏳ Aguardando início da Aula 1
~~~

---

## Ação Obrigatória — Salve este Plano

**Por favor, salve o conteúdo deste planejamento em um arquivo chamado `plano_mestre.txt`** na pasta raiz do seu projeto `FinanceDB/`. Abra o VS Code, crie a pasta `FinanceDB/` em um local de sua preferência, e salve o arquivo lá. Este arquivo será a referência central do curso e poderá ser anexado nas próximas sessões para manter o contexto completo.

Quando estiver pronto, confirme com **"Ok"**, **"Aprovo"** ou **"Pode prosseguir"** e iniciaremos a **Aula 1: O que é um Banco de Dados Relacional e por que o SQL Server?**

---

Dúvidas? Posso prosseguir para a Aula 1?