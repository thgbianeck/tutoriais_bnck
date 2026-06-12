# Prompts Individuais — SQL Server para Aplicações Financeiras com T-SQL

---

## Instruções de Uso

Cada prompt abaixo foi preparado para gerar uma aula completa do curso, seguindo toda a estrutura definida no `plano_mestre.txt`. Para usar, copie o prompt da aula desejada e cole em uma nova conversa, **anexando os arquivos `plano_mestre.txt` e `log_estado_projeto.md`** para garantir que o contexto do curso seja mantido. Confirme com "Ok", "Aprovo" ou "Pode prosseguir" quando solicitado.

---

## Módulo 1 — Essencial: Fundamentos

---

### Prompt — Aula 1

~~~text
Você é o Tutor Sênior do curso "SQL Server para Aplicações Financeiras com T-SQL", conforme definido no plano_mestre.txt anexo. O aluno usa Windows 11, VS Code como editor de arquivos do projeto e SSMS 21 para execução de scripts SQL. A versão do SQL Server é a 2022. O aluno é iniciante absoluto. Não use comandos ainda não abordados. Gere a Aula 1 completa, seguindo rigorosamente toda a estrutura de aula definida no plano mestre, com no mínimo 2.000 palavras de conteúdo teórico.

**Aula 1 — O que é um Banco de Dados Relacional e por que o SQL Server?**

Conteúdo esperado:
- Conceito de banco de dados relacional: o que é, para que serve e por que ele existe
- Analogia do cotidiano para explicar tabelas, linhas e colunas
- Diferença entre banco de dados, SGBD (Sistema Gerenciador de Banco de Dados) e linguagem SQL
- Apresentação do SQL Server 2022: história resumida, posicionamento no mercado e aplicação em sistemas financeiros
- Apresentação do SSMS 21: o que é, como instalar (link oficial) e tour pela interface principal
- Configuração do VS Code como editor do projeto: criação da pasta FinanceDB/, extensões recomendadas
- Fluxo de trabalho entre VS Code e SSMS: quando usar cada ferramenta
- Estrutura inicial de pastas do projeto criada no VS Code
- Nenhum script SQL ainda — foco total em conceitos e ambiente
- Diagrama Mermaid ilustrando o fluxo VS Code → SSMS
- Glossário técnico com os termos introduzidos
- Antecipação de erros comuns de ambiente (ex: SQL Server não aparece no SSMS)
- Exercício de fixação conceitual (sem código)
- Log de Estado do Projeto atualizado
- Prompt de continuidade para a Aula 2

O documento inteiro deve estar dentro de um bloco ```markdown. Blocos internos de código SQL usam ~~~sql. Blocos de texto puro usam ~~~text. Diagramas usam ~~~mermaid. Nenhum bloco interno usa triple backtick. Não quebre linhas de parágrafos.
~~~

---

### Prompt — Aula 2

~~~text
Você é o Tutor Sênior do curso "SQL Server para Aplicações Financeiras com T-SQL", conforme definido no plano_mestre.txt anexo. Consulte também o log_estado_projeto.md para ver o estado atual do projeto. O aluno usa Windows 11, VS Code como editor e SSMS 21 para execução. SQL Server 2022. Iniciante absoluto. Use apenas comandos já introduzidos ou introduzidos nesta aula. Gere a Aula 2 completa com no mínimo 2.000 palavras de conteúdo teórico.

**Aula 2 — Criando o Banco de Dados FinanceDB**

Conteúdo esperado:
- O que é um banco de dados no contexto do SQL Server (diferente do conceito genérico da Aula 1)
- Analogia do cotidiano para explicar o banco de dados como um "cofre organizado"
- O que são os arquivos MDF (dados) e LDF (log de transações) e por que o SQL Server usa dois arquivos
- Conceito de instância do SQL Server
- Como o SQL Server organiza bancos de dados do sistema (master, model, msdb, tempdb) — apenas conceitual, sem manipulá-los
- Comando CREATE DATABASE: sintaxe básica, explicação de cada parte
- Comando USE: para que serve e como usar
- Comando DROP DATABASE: o que faz e por que exige atenção redobrada
- Como visualizar o banco criado no SSMS (Object Explorer)
- Fluxo completo: escrever o script no VS Code → salvar como criar_banco.sql na pasta aula_02/codigo/ → abrir no SSMS → executar
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

### Prompt — Aula 3

~~~text
Você é o Tutor Sênior do curso "SQL Server para Aplicações Financeiras com T-SQL", conforme definido no plano_mestre.txt anexo. Consulte também o log_estado_projeto.md. O aluno usa Windows 11, VS Code como editor e SSMS 21 para execução. SQL Server 2022. Iniciante absoluto. Use apenas comandos já introduzidos (CREATE DATABASE, USE, DROP DATABASE) ou introduzidos nesta aula. Gere a Aula 3 completa com no mínimo 2.000 palavras de conteúdo teórico.

**Aula 3 — Tipos de Dados no SQL Server: Escolhendo com Precisão**

Conteúdo esperado:
- Por que a escolha do tipo de dado é crítica em aplicações financeiras (precisão, armazenamento, desempenho)
- Analogia do cotidiano: tipos de dado como "caixas de tamanhos diferentes para guardar coisas diferentes"
- Tipos numéricos inteiros: INT, BIGINT, SMALLINT, TINYINT — quando usar cada um, limites e exemplos financeiros
- Tipos numéricos decimais: DECIMAL(p,s), NUMERIC(p,s) — explicação de precisão e escala, por que são preferidos para valores monetários
- Tipo MONEY e SMALLMONEY: o que são, limitações e por que DECIMAL é geralmente mais seguro em sistemas financeiros sérios
- Tipos de texto: VARCHAR(n), NVARCHAR(n), CHAR(n) — diferenças, quando usar cada um, impacto do Unicode
- Tipos de data e hora: DATE, DATETIME, DATETIME2 — diferenças de precisão e uso em registros financeiros
- Tipo lógico: BIT — como funciona e exemplos de uso (ex: lançamento ativo/inativo)
- Tabela comparativa dos tipos mais usados no projeto FinanceDB
- Nenhum CREATE TABLE ainda — apenas conceitos e preparação para a Aula 4
- Script de exemplo simples apenas para demonstrar como os tipos se comportam com SELECT e valores literais
- Diagrama Mermaid mostrando os grupos de tipos de dados
- Glossário técnico da aula
- Antecipação de erros: usar VARCHAR para valores monetários, usar DATETIME quando DATE basta, overflow de tipo
- Exercício de fixação com resolução comentada
- Log de Estado do Projeto atualizado
- Prompt de continuidade para a Aula 4

O documento inteiro deve estar dentro de um bloco ```markdown. Blocos internos de código SQL usam ~~~sql. Blocos de texto puro usam ~~~text. Diagramas usam ~~~mermaid. Nenhum bloco interno usa triple backtick. Não quebre linhas de parágrafos.
~~~

---

### Prompt — Aula 4

~~~text
Você é o Tutor Sênior do curso "SQL Server para Aplicações Financeiras com T-SQL", conforme definido no plano_mestre.txt anexo. Consulte também o log_estado_projeto.md. O aluno usa Windows 11, VS Code como editor e SSMS 21 para execução. SQL Server 2022. Iniciante absoluto. Comandos já conhecidos: CREATE DATABASE, USE, DROP DATABASE e todos os tipos de dados da Aula 3. Use apenas esses ou introduza apenas o que for ensinado nesta aula. Gere a Aula 4 completa com no mínimo 2.000 palavras de conteúdo teórico.

**Aula 4 — Criando Tabelas: A Estrutura do FinanceDB**

Conteúdo esperado:
- O que é uma tabela no modelo relacional: linhas (registros) e colunas (atributos)
- Analogia do cotidiano: tabela como uma planilha com regras rígidas
- Comando CREATE TABLE: sintaxe completa explicada parte por parte
- Conceito de chave primária (PRIMARY KEY): o que é, por que toda tabela precisa de uma, como declarar
- IDENTITY(1,1): o que é e como o SQL Server gera valores automáticos para a chave primária
- Restrições de coluna: NOT NULL (obrigatório), NULL (opcional), DEFAULT (valor padrão)
- Criação da tabela Categorias: colunas CategoriaId, Nome, Tipo (Receita/Despesa), Ativo
- Criação da tabela Contas: colunas ContaId, Nome, Tipo (Corrente/Poupança/Carteira), SaldoInicial, Ativo
- Comando para verificar se a tabela foi criada (via Object Explorer no SSMS e via consulta em sys.tables)
- Fluxo: escrever no VS Code → salvar como criar_tabelas.sql em aula_04/codigo/ → executar no SSMS
- Scripts comentados linha a linha, sem complexidade excessiva
- Diagrama Mermaid mostrando as duas tabelas criadas e suas colunas
- Glossário técnico da aula
- Antecipação de erros: tabela já existe, nome de coluna com espaço, PRIMARY KEY duplicada
- Exercício de fixação com resolução comentada
- Log de Estado do Projeto atualizado
- Prompt de continuidade para a Aula 5

O documento inteiro deve estar dentro de um bloco ```markdown. Blocos internos de código SQL usam ~~~sql. Blocos de texto puro usam ~~~text. Diagramas usam ~~~mermaid. Nenhum bloco interno usa triple backtick. Não quebre linhas de parágrafos.
~~~

---

### Prompt — Aula 5

~~~text
Você é o Tutor Sênior do curso "SQL Server para Aplicações Financeiras com T-SQL", conforme definido no plano_mestre.txt anexo. Consulte também o log_estado_projeto.md. O aluno usa Windows 11, VS Code como editor e SSMS 21 para execução. SQL Server 2022. Iniciante absoluto. Comandos já conhecidos: CREATE DATABASE, USE, DROP DATABASE, tipos de dados, CREATE TABLE, PRIMARY KEY, NOT NULL, NULL, DEFAULT, IDENTITY. Use apenas esses ou introduza apenas o que for ensinado nesta aula. Gere a Aula 5 completa com no mínimo 2.000 palavras de conteúdo teórico.

**Aula 5 — Inserindo Dados: Populando o FinanceDB**

Conteúdo esperado:
- Por que precisamos inserir dados manualmente antes de ter uma aplicação conectada
- Analogia do cotidiano: INSERT como preencher um formulário e entregá-lo ao arquivo
- Comando INSERT INTO ... VALUES: sintaxe completa explicada parte por parte
- Regras de inserção por tipo de dado: aspas simples para texto e datas, sem aspas para números, formato de data recomendado (YYYY-MM-DD)
- Como o IDENTITY funciona na inserção: não informar a coluna de chave primária gerada automaticamente
- Inserção de uma linha por vez: sintaxe básica
- Inserção de múltiplas linhas em um único INSERT: sintaxe com múltiplos blocos VALUES
- Inserção de dados na tabela Categorias: pelo menos 6 categorias (Salário, Freelance, Alimentação, Transporte, Moradia, Lazer)
- Inserção de dados na tabela Contas: pelo menos 3 contas (Conta Corrente, Poupança, Carteira)
- Como verificar os dados inseridos com um SELECT * simples (introdução prévia do SELECT, que será aprofundado na Aula 6)
- Fluxo: VS Code → salvar como inserir_dados.sql em aula_05/codigo/ → executar no SSMS
- Scripts comentados linha a linha
- Diagrama Mermaid mostrando o fluxo de inserção de dados nas tabelas
- Glossário técnico da aula
- Antecipação de erros: inserir valor na coluna IDENTITY, tipo incompatível, valor NOT NULL ausente, formato de data errado
- Exercício de fixação com resolução comentada
- Log de Estado do Projeto atualizado
- Prompt de continuidade para a Aula 6

O documento inteiro deve estar dentro de um bloco ```markdown. Blocos internos de código SQL usam ~~~sql. Blocos de texto puro usam ~~~text. Diagramas usam ~~~mermaid. Nenhum bloco interno usa triple backtick. Não quebre linhas de parágrafos.
~~~

---

### Prompt — Aula 6

~~~text
Você é o Tutor Sênior do curso "SQL Server para Aplicações Financeiras com T-SQL", conforme definido no plano_mestre.txt anexo. Consulte também o log_estado_projeto.md. O aluno usa Windows 11, VS Code como editor e SSMS 21 para execução. SQL Server 2022. Iniciante absoluto. Comandos já conhecidos: CREATE DATABASE, USE, DROP DATABASE, tipos de dados, CREATE TABLE, PRIMARY KEY, NOT NULL, NULL, DEFAULT, IDENTITY, INSERT INTO. Use apenas esses ou introduza apenas o que for ensinado nesta aula. Gere a Aula 6 completa com no mínimo 2.000 palavras de conteúdo teórico.

**Aula 6 — Consultando Dados: O Comando SELECT**

Conteúdo esperado:
- O que é uma consulta (query) e o que significa "recuperar dados" de um banco
- Analogia do cotidiano: SELECT como fazer uma pergunta ao banco de dados e receber uma resposta organizada
- Estrutura fundamental do SELECT: SELECT ... FROM ...
- Seleção de todas as colunas com * — quando usar e quando evitar
- Seleção de colunas específicas: por que isso é uma boa prática
- Uso de AS para aliases: renomear colunas no resultado sem alterar a tabela
- Conceito de result set: o que é o conjunto de resultados retornado
- Como o SSMS exibe os resultados: aba Results, aba Messages
- Consultas nas tabelas Categorias e Contas do FinanceDB
- Introdução a comentários em SQL: -- para linha única e /* */ para bloco
- Fluxo: VS Code → salvar como consultas_basicas.sql em aula_06/codigo/ → executar no SSMS
- Scripts comentados linha a linha, progressivos e simples
- Diagrama Mermaid mostrando o fluxo SELECT → SQL Server → result set → SSMS
- Glossário técnico da aula
- Antecipação de erros: coluna inexistente, tabela inexistente, banco errado selecionado
- Exercício de fixação com resolução comentada
- Log de Estado do Projeto atualizado
- Prompt de continuidade para a Aula 7

O documento inteiro deve estar dentro de um bloco ```markdown. Blocos internos de código SQL usam ~~~sql. Blocos de texto puro usam ~~~text. Diagramas usam ~~~mermaid. Nenhum bloco interno usa triple backtick. Não quebre linhas de parágrafos.
~~~

---

### Prompt — Aula 7

~~~text
Você é o Tutor Sênior do curso "SQL Server para Aplicações Financeiras com T-SQL", conforme definido no plano_mestre.txt anexo. Consulte também o log_estado_projeto.md. O aluno usa Windows 11, VS Code como editor e SSMS 21 para execução. SQL Server 2022. Iniciante absoluto. Comandos já conhecidos: CREATE DATABASE, USE, DROP DATABASE, tipos de dados, CREATE TABLE, PRIMARY KEY, NOT NULL, NULL, DEFAULT, IDENTITY, INSERT INTO, SELECT, AS, comentários SQL. Use apenas esses ou introduza apenas o que for ensinado nesta aula. Gere a Aula 7 completa com no mínimo 2.000 palavras de conteúdo teórico.

**Aula 7 — Filtrando Dados: A Cláusula WHERE**

Conteúdo esperado:
- Por que filtrar dados é essencial em aplicações financeiras (imagine um extrato com milhões de linhas)
- Analogia do cotidiano: WHERE como um filtro de café — deixa passar apenas o que interessa
- Cláusula WHERE: posição na query, como o SQL Server a avalia
- Operadores de comparação: = (igual), <> (diferente), > (maior), < (menor), >= (maior ou igual), <= (menor ou igual)
- Operadores lógicos: AND (ambas as condições), OR (qualquer condição), NOT (negação) — com exemplos claros de cada
- Operador BETWEEN: filtrando intervalos de valores e datas (muito útil em finanças)
- Operador IN: filtrando por uma lista de valores
- Operador LIKE: buscas por padrão de texto, curingas % (qualquer sequência) e _ (um caractere)
- Filtrando NULL: IS NULL e IS NOT NULL (por que = NULL não funciona)
- Consultas práticas filtrando Categorias ativas, Contas por tipo, categorias por nome
- Fluxo: VS Code → salvar como filtros_where.sql em aula_07/codigo/ → executar no SSMS
- Scripts comentados linha a linha, progressivos
- Diagrama Mermaid mostrando a lógica de avaliação do WHERE
- Glossário técnico da aula
- Antecipação de erros: usar = NULL em vez de IS NULL, confundir AND com OR, LIKE sem %
- Exercício de fixação com resolução comentada
- Log de Estado do Projeto atualizado
- Prompt de continuidade para a Aula 8

O documento inteiro deve estar dentro de um bloco ```markdown. Blocos internos de código SQL usam ~~~sql. Blocos de texto puro usam ~~~text. Diagramas usam ~~~mermaid. Nenhum bloco interno usa triple backtick. Não quebre linhas de parágrafos.
~~~

---

### Prompt — Aula 8

~~~text
Você é o Tutor Sênior do curso "SQL Server para Aplicações Financeiras com T-SQL", conforme definido no plano_mestre.txt anexo. Consulte também o log_estado_projeto.md. O aluno usa Windows 11, VS Code como editor e SSMS 21 para execução. SQL Server 2022. Iniciante absoluto. Comandos já conhecidos: CREATE DATABASE, USE, DROP DATABASE, tipos de dados, CREATE TABLE, PRIMARY KEY, NOT NULL, NULL, DEFAULT, IDENTITY, INSERT INTO, SELECT, AS, WHERE, operadores de comparação e lógicos, BETWEEN, IN, LIKE, IS NULL. Use apenas esses ou introduza apenas o que for ensinado nesta aula. Gere a Aula 8 completa com no mínimo 2.000 palavras de conteúdo teórico.

**Aula 8 — Ordenando e Limitando Resultados**

Conteúdo esperado:
- Por que a ordem dos resultados importa em relatórios financeiros
- Analogia do cotidiano: ORDER BY como ordenar um extrato bancário por data
- Cláusula ORDER BY: sintaxe, posição na query, ordenação por uma ou mais colunas
- ASC (crescente) e DESC (decrescente): quando usar cada um
- Ordenação por múltiplas colunas: critério primário e secundário
- Como o SQL Server trata NULL em ordenações (NULLs aparecem primeiro ou por último)
- Cláusula TOP: o que faz, sintaxe básica, uso para limitar resultados
- TOP com ORDER BY: a combinação correta para "os N maiores/menores"
- TOP sem ORDER BY: por que o resultado pode ser imprevisível
- Consultas práticas: top 3 categorias por nome, contas ordenadas por saldo, resultados combinando WHERE + ORDER BY + TOP
- Fluxo: VS Code → salvar como ordenacao_limite.sql em aula_08/codigo/ → executar no SSMS
- Scripts comentados linha a linha
- Diagrama Mermaid mostrando a ordem de execução das cláusulas SQL (FROM → WHERE → SELECT → ORDER BY → TOP)
- Glossário técnico da aula
- Antecipação de erros: usar TOP sem ORDER BY esperando resultado determinístico, ordenar por alias inexistente
- Exercício de fixação com resolução comentada
- Log de Estado do Projeto atualizado — marcos do Módulo 1 concluído
- Prompt de continuidade para a Aula 9

O documento inteiro deve estar dentro de um bloco ```markdown. Blocos internos de código SQL usam ~~~sql. Blocos de texto puro usam ~~~text. Diagramas usam ~~~mermaid. Nenhum bloco interno usa triple backtick. Não quebre linhas de parágrafos.
~~~

---

## Módulo 2 — Proficiente: Prática e Relacionamentos

---

### Prompt — Aula 9

~~~text
Você é o Tutor Sênior do curso "SQL Server para Aplicações Financeiras com T-SQL", conforme definido no plano_mestre.txt anexo. Consulte também o log_estado_projeto.md. O aluno usa Windows 11, VS Code como editor e SSMS 21 para execução. SQL Server 2022. Iniciante absoluto. Comandos já conhecidos: todos os do Módulo 1 (CREATE DATABASE, USE, CREATE TABLE, PRIMARY KEY, IDENTITY, NOT NULL, NULL, DEFAULT, INSERT INTO, SELECT, AS, WHERE, BETWEEN, IN, LIKE, IS NULL, ORDER BY, TOP). Use apenas esses ou introduza apenas o que for ensinado nesta aula. Gere a Aula 9 completa com no mínimo 2.000 palavras de conteúdo teórico.

**Aula 9 — Chaves Estrangeiras e Integridade Referencial**

Conteúdo esperado:
- Por que relacionamentos entre tabelas existem e qual problema eles resolvem
- Analogia do cotidiano: chave estrangeira como um número de protocolo que referencia outro documento
- Conceito de chave estrangeira (FOREIGN KEY): o que é, como funciona, o que ela garante
- Integridade referencial: o que é e por que é crítica em sistemas financeiros
- Sintaxe FOREIGN KEY na criação de tabela com REFERENCES
- Comportamentos ON DELETE e ON UPDATE: NO ACTION, CASCADE, SET NULL, SET DEFAULT — explicados com exemplos simples
- Criação da tabela Lancamentos com as colunas: LancamentoId, Descricao, Valor, Data, Tipo (Receita/Despesa), CategoriaId (FK), ContaId (FK)
- Como visualizar os relacionamentos no Object Explorer do SSMS
- Diagrama Mermaid mostrando o modelo de dados completo até agora: Categorias, Contas e Lancamentos
- Fluxo: VS Code → salvar como criar_lancamentos.sql em aula_09/codigo/ → executar no SSMS
- Scripts comentados linha a linha
- Glossário técnico da aula
- Antecipação de erros: inserir FK com valor inexistente na tabela pai, tentar deletar registro pai com filhos vinculados
- Exercício de fixação com resolução comentada
- Log de Estado do Projeto atualizado
- Prompt de continuidade para a Aula 10

O documento inteiro deve estar dentro de um bloco ```markdown. Blocos internos de código SQL usam ~~~sql. Blocos de texto puro usam ~~~text. Diagramas usam ~~~mermaid. Nenhum bloco interno usa triple backtick. Não quebre linhas de parágrafos.
~~~

---

### Prompt — Aula 10

~~~text
Você é o Tutor Sênior do curso "SQL Server para Aplicações Financeiras com T-SQL", conforme definido no plano_mestre.txt anexo. Consulte também o log_estado_projeto.md. O aluno usa Windows 11, VS Code como editor e SSMS 21 para execução. SQL Server 2022. Iniciante absoluto. Comandos já conhecidos: todos os do Módulo 1 + FOREIGN KEY, REFERENCES, ON DELETE, ON UPDATE. Use apenas esses ou introduza apenas o que for ensinado nesta aula. Gere a Aula 10 completa com no mínimo 2.000 palavras de conteúdo teórico.

**Aula 10 — Alterando e Removendo Dados: UPDATE e DELETE**

Conteúdo esperado:
- Por que alterar e remover dados são operações críticas e perigosas em ambientes financeiros
- Analogia do cotidiano: UPDATE como corrigir um lançamento no extrato, DELETE como rasgar um comprovante
- Comando UPDATE: sintaxe completa, cláusula SET, importância do WHERE
- O que acontece quando UPDATE é executado sem WHERE: todos os registros são alterados
- Comando DELETE: sintaxe completa, importância do WHERE
- O que acontece quando DELETE é executado sem WHERE: todos os registros são removidos
- Boas práticas antes de executar UPDATE e DELETE: testar com SELECT primeiro, usar transações (menção prévia, aprofundado na Aula 20)
- Como o SSMS protege contra execuções acidentais: opção de confirmação
- Atualizações e exclusões práticas no FinanceDB: corrigir nome de categoria, desativar uma conta (Ativo = 0), remover um lançamento de teste
- Fluxo: VS Code → salvar como update_delete.sql em aula_10/codigo/ → executar no SSMS
- Scripts comentados linha a linha, com ênfase nas boas práticas
- Diagrama Mermaid mostrando o fluxo seguro: SELECT → verificar → UPDATE/DELETE
- Glossário técnico da aula
- Antecipação de erros: esquecer o WHERE, tentar deletar registro pai com filhos (violação de FK), alterar coluna com tipo incompatível
- Exercício de fixação com resolução comentada
- Log de Estado do Projeto atualizado
- Prompt de continuidade para a Aula 11

O documento inteiro deve estar dentro de um bloco ```markdown. Blocos internos de código SQL usam ~~~sql. Blocos de texto puro usam ~~~text. Diagramas usam ~~~mermaid. Nenhum bloco interno usa triple backtick. Não quebre linhas de parágrafos.
~~~

---

### Prompt — Aula 11

~~~text
Você é o Tutor Sênior do curso "SQL Server para Aplicações Financeiras com T-SQL", conforme definido no plano_mestre.txt anexo. Consulte também o log_estado_projeto.md. O aluno usa Windows 11, VS Code como editor e SSMS 21 para execução. SQL Server 2022. Iniciante absoluto. Comandos já conhecidos: todos os anteriores + UPDATE, DELETE. Use apenas esses ou introduza apenas o que for ensinado nesta aula. Gere a Aula 11 completa com no mínimo 2.000 palavras de conteúdo teórico.

**Aula 11 — Alterando a Estrutura de Tabelas: ALTER TABLE**

Conteúdo esperado:
- Por que a estrutura de uma tabela precisa mudar ao longo do tempo (evolução do sistema)
- Analogia do cotidiano: ALTER TABLE como reformar um cômodo sem derrubar a casa inteira
- Comando ALTER TABLE para adicionar coluna: ADD coluna tipo restrições
- Comando ALTER TABLE para modificar coluna: ALTER COLUMN — o que pode e o que não pode ser alterado
- Comando ALTER TABLE para remover coluna: DROP COLUMN — cuidados necessários
- Adicionando restrições com CONSTRAINT: ADD CONSTRAINT para DEFAULT e NOT NULL
- Removendo restrições com DROP CONSTRAINT
- Aplicação prática: adicionar coluna DataCriacao (DATETIME2, DEFAULT GETDATE()) e Observacao (VARCHAR) às tabelas do FinanceDB
- Por que colunas de auditoria (DataCriacao, DataAtualizacao) são essenciais em sistemas financeiros
- Como verificar as alterações no SSMS (Object Explorer e sp_help — apenas para consulta)
- Fluxo: VS Code → salvar como alter_tabelas.sql em aula_11/codigo/ → executar no SSMS
- Scripts comentados linha a linha
- Diagrama Mermaid mostrando o estado atualizado das tabelas do FinanceDB
- Glossário técnico da aula
- Antecipação de erros: tentar adicionar NOT NULL sem DEFAULT em tabela com dados, remover coluna referenciada por FK
- Exercício de fixação com resolução comentada
- Log de Estado do Projeto atualizado
- Prompt de continuidade para a Aula 12

O documento inteiro deve estar dentro de um bloco ```markdown. Blocos internos de código SQL usam ~~~sql. Blocos de texto puro usam ~~~text. Diagramas usam ~~~mermaid. Nenhum bloco interno usa triple backtick. Não quebre linhas de parágrafos.
~~~

---

### Prompt — Aula 12

~~~text
Você é o Tutor Sênior do curso "SQL Server para Aplicações Financeiras com T-SQL", conforme definido no plano_mestre.txt anexo. Consulte também o log_estado_projeto.md. O aluno usa Windows 11, VS Code como editor e SSMS 21 para execução. SQL Server 2022. Iniciante absoluto. Comandos já conhecidos: todos os anteriores + ALTER TABLE. Use apenas esses ou introduza apenas o que for ensinado nesta aula. Gere a Aula 12 completa com no mínimo 2.000 palavras de conteúdo teórico.

**Aula 12 — Funções de Agregação: Resumindo Dados Financeiros**

Conteúdo esperado:
- O que são funções de agregação e por que elas são essenciais em relatórios financeiros
- Analogia do cotidiano: funções de agregação como um contador que resume pilhas de notas em um único número
- Função COUNT: contar registros, diferença entre COUNT(*) e COUNT(coluna) — comportamento com NULL
- Função SUM: somar valores — aplicação direta em totais de lançamentos
- Função AVG: calcular média — média de gastos mensais
- Função MIN e MAX: menor e maior valor — identificar menor e maior lançamento
- Cláusula GROUP BY: agrupar resultados por categoria, por conta, por tipo de lançamento
- Regra fundamental: toda coluna no SELECT que não é função de agregação deve estar no GROUP BY
- Cláusula HAVING: filtrar grupos — diferença fundamental entre WHERE (filtra linhas) e HAVING (filtra grupos)
- Consultas práticas: total de receitas e despesas, total por categoria, média de gastos por conta
- Fluxo: VS Code → salvar como agregacoes.sql em aula_12/codigo/ → executar no SSMS
- Scripts comentados linha a linha, progressivos
- Diagrama Mermaid mostrando o fluxo FROM → WHERE → GROUP BY → HAVING → SELECT
- Glossário técnico da aula
- Antecipação de erros: coluna no SELECT fora do GROUP BY, usar WHERE para filtrar agregação, confundir COUNT(*) com COUNT(coluna)
- Exercício de fixação com resolução comentada
- Log de Estado do Projeto atualizado
- Prompt de continuidade para a Aula 13

O documento inteiro deve estar dentro de um bloco ```markdown. Blocos internos de código SQL usam ~~~sql. Blocos de texto puro usam ~~~text. Diagramas usam ~~~mermaid. Nenhum bloco interno usa triple backtick. Não quebre linhas de parágrafos.
~~~

---

### Prompt — Aula 13

~~~text
Você é o Tutor Sênior do curso "SQL Server para Aplicações Financeiras com T-SQL", conforme definido no plano_mestre.txt anexo. Consulte também o log_estado_projeto.md. O aluno usa Windows 11, VS Code como editor e SSMS 21 para execução. SQL Server 2022. Iniciante absoluto. Comandos já conhecidos: todos os anteriores + COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING. Use apenas esses ou introduza apenas o que for ensinado nesta aula. Gere a Aula 13 completa com no mínimo 2.000 palavras de conteúdo teórico.

**Aula 13 — Junções entre Tabelas: INNER JOIN**

Conteúdo esperado:
- Por que junções existem: o problema de dados separados em tabelas diferentes
- Analogia do cotidiano: JOIN como juntar duas planilhas pela coluna comum (como PROCV no Excel, mas muito mais poderoso)
- O que é INNER JOIN: retorna apenas os registros que têm correspondência nas duas tabelas
- Sintaxe do INNER JOIN: SELECT ... FROM tabela1 INNER JOIN tabela2 ON tabela1.coluna = tabela2.coluna
- Alias de tabela: usar apelidos curtos (L, C, CT) para simplificar queries com JOIN
- Quando um registro não aparece no resultado do INNER JOIN (ausência de correspondência)
- Consultas práticas: extrato de lançamentos com nome de categoria, lançamentos com nome de conta, relatório completo com Lancamentos + Categorias + Contas
- Combinando INNER JOIN com WHERE, ORDER BY e funções de agregação já conhecidas
- Fluxo: VS Code → salvar como inner_join.sql em aula_13/codigo/ → executar no SSMS
- Scripts comentados linha a linha, progressivos e sem excessos
- Diagrama Mermaid mostrando como o INNER JOIN une as três tabelas do FinanceDB
- Glossário técnico da aula
- Antecipação de erros: ambiguidade de coluna (nome de coluna igual nas duas tabelas sem prefixo), ON com coluna errada, produto cartesiano acidental
- Exercício de fixação com resolução comentada
- Log de Estado do Projeto atualizado
- Prompt de continuidade para a Aula 14

O documento inteiro deve estar dentro de um bloco ```markdown. Blocos internos de código SQL usam ~~~sql. Blocos de texto puro usam ~~~text. Diagramas usam ~~~mermaid. Nenhum bloco interno usa triple backtick. Não quebre linhas de parágrafos.
~~~

---

### Prompt — Aula 14

~~~text
Você é o Tutor Sênior do curso "SQL Server para Aplicações Financeiras com T-SQL", conforme definido no plano_mestre.txt anexo. Consulte também o log_estado_projeto.md. O aluno usa Windows 11, VS Code como editor e SSMS 21 para execução. SQL Server 2022. Iniciante absoluto. Comandos já conhecidos: todos os anteriores + INNER JOIN, alias de tabela. Use apenas esses ou introduza apenas o que for ensinado nesta aula. Gere a Aula 14 completa com no mínimo 2.000 palavras de conteúdo teórico.

**Aula 14 — Mais Junções: LEFT JOIN, RIGHT JOIN e conceito de FULL JOIN**

Conteúdo esperado:
- Limitação do INNER JOIN: registros sem correspondência desaparecem — isso é um problema em análises financeiras
- Analogia do cotidiano: LEFT JOIN como listar todos os clientes e mostrar seus pedidos (mesmo quem não pediu nada)
- LEFT JOIN: retorna todos os registros da tabela da esquerda, com NULL para colunas da direita sem correspondência
- RIGHT JOIN: retorna todos os registros da tabela da direita, com NULL para colunas da esquerda sem correspondência
- Conceito de FULL JOIN: retorna tudo de ambos os lados, com NULL onde não há correspondência (apenas conceitual, sem aprofundamento excessivo)
- Como identificar registros sem correspondência: filtrar IS NULL na coluna da tabela que pode não ter match
- Consultas práticas: categorias que nunca tiveram lançamentos, contas sem movimentação, lançamentos com categoria deletada (se houver)
- Quando usar LEFT JOIN em vez de INNER JOIN em relatórios financeiros
- Fluxo: VS Code → salvar como left_right_join.sql em aula_14/codigo/ → executar no SSMS
- Scripts comentados linha a linha
- Diagrama Mermaid comparando INNER JOIN, LEFT JOIN e RIGHT JOIN visualmente
- Glossário técnico da aula
- Antecipação de erros: confundir a ordem das tabelas no LEFT JOIN, filtrar WHERE em coluna da direita (anula o LEFT JOIN, vira INNER JOIN)
- Exercício de fixação com resolução comentada
- Log de Estado do Projeto atualizado
- Prompt de continuidade para a Aula 15

O documento inteiro deve estar dentro de um bloco ```markdown. Blocos internos de código SQL usam ~~~sql. Blocos de texto puro usam ~~~text. Diagramas usam ~~~mermaid. Nenhum bloco interno usa triple backtick. Não quebre linhas de parágrafos.
~~~

---

### Prompt — Aula 15

~~~text
Você é o Tutor Sênior do curso "SQL Server para Aplicações Financeiras com T-SQL", conforme definido no plano_mestre.txt anexo. Consulte também o log_estado_projeto.md. O aluno usa Windows 11, VS Code como editor e SSMS 21 para execução. SQL Server 2022. Iniciante absoluto. Comandos já conhecidos: todos os anteriores + LEFT JOIN, RIGHT JOIN, FULL JOIN (conceitual). Use apenas esses ou introduza apenas o que for ensinado nesta aula. Gere a Aula 15 completa com no mínimo 2.000 palavras de conteúdo teórico.

**Aula 15 — Subconsultas: Consultas dentro de Consultas**

Conteúdo esperado:
- O que é uma subconsulta (subquery) e que problema ela resolve
- Analogia do cotidiano: subconsulta como perguntar "quem ganhou mais que a média?" — você precisa saber a média primeiro
- Subconsulta na cláusula WHERE: usar o resultado de uma query como critério de filtro
- Subconsulta retornando um único valor (escalar): comparação com =, >, <
- Subconsulta retornando múltiplos valores: uso com IN e NOT IN
- Operador EXISTS: verificar se uma subconsulta retorna algum resultado (muito eficiente)
- Operador NOT EXISTS: verificar ausência de resultado
- Subconsulta na cláusula SELECT: calcular um valor relacionado para cada linha do resultado
- Consultas práticas financeiras: lançamentos acima da média, categorias com pelo menos um lançamento, contas sem nenhum lançamento usando NOT EXISTS
- Fluxo: VS Code → salvar como subconsultas.sql em aula_15/codigo/ → executar no SSMS
- Scripts comentados linha a linha, progressivos e sem excessos
- Diagrama Mermaid mostrando a relação entre consulta externa e subconsulta
- Glossário técnico da aula
- Antecipação de erros: subconsulta retornando mais de um valor com =, subconsulta correlacionada muito pesada (apenas mencionar o risco)
- Exercício de fixação com resolução comentada
- Log de Estado do Projeto atualizado
- Prompt de continuidade para a Aula 16

O documento inteiro deve estar dentro de um bloco ```markdown. Blocos internos de código SQL usam ~~~sql. Blocos de texto puro usam ~~~text. Diagramas usam ~~~mermaid. Nenhum bloco interno usa triple backtick. Não quebre linhas de parágrafos.
~~~

---

### Prompt — Aula 16

~~~text
Você é o Tutor Sênior do curso "SQL Server para Aplicações Financeiras com T-SQL", conforme definido no plano_mestre.txt anexo. Consulte também o log_estado_projeto.md. O aluno usa Windows 11, VS Code como editor e SSMS 21 para execução. SQL Server 2022. Iniciante absoluto. Comandos já conhecidos: todos os anteriores + subconsultas, EXISTS, NOT EXISTS. Use apenas esses ou introduza apenas o que for ensinado nesta aula. Gere a Aula 16 completa com no mínimo 2.000 palavras de conteúdo teórico.

**Aula 16 — Funções de Data e Texto no T-SQL**

Conteúdo esperado:
- Por que funções de data e texto são indispensáveis em relatórios financeiros
- Analogia do cotidiano: funções como ferramentas de uma caixa — cada uma resolve um problema específico
- Funções de data: GETDATE() (data/hora atual), YEAR(), MONTH(), DAY() (extrair partes da data), DATEDIFF() (diferença entre datas), DATEADD() (adicionar/subtrair períodos), FORMAT() (formatar data para exibição)
- Aplicações financeiras das funções de data: filtrar lançamentos do mês atual, calcular dias em atraso, formatar datas em relatórios
- Funções de texto: LEN() (tamanho da string), UPPER() e LOWER() (caixa alta/baixa), TRIM() (remover espaços), CONCAT() (concatenar textos), SUBSTRING() (extrair parte do texto)
- Aplicações das funções de texto: padronizar nomes de categorias, formatar descrições de lançamentos
- Combinando funções de data e texto em consultas do FinanceDB
- Fluxo: VS Code → salvar como funcoes_data_texto.sql em aula_16/codigo/ → executar no SSMS
- Scripts comentados linha a linha, progressivos
- Diagrama Mermaid agrupando as funções por categoria (data e texto)
- Glossário técnico da aula
- Antecipação de erros: DATEDIFF com argumentos invertidos, FORMAT retornando string em vez de data, CONCAT com NULL
- Exercício de fixação com resolução comentada
- Log de Estado do Projeto atualizado — marcos do Módulo 2 concluído
- Prompt de continuidade para a Aula 17

O documento inteiro deve estar dentro de um bloco ```markdown. Blocos internos de código SQL usam ~~~sql. Blocos de texto puro usam ~~~text. Diagramas usam ~~~mermaid. Nenhum bloco interno usa triple backtick. Não quebre linhas de parágrafos.
~~~

---

## Módulo 3 — Mestre: Otimização e Recursos Avançados

---

### Prompt — Aula 17

~~~text
Você é o Tutor Sênior do curso "SQL Server para Aplicações Financeiras com T-SQL", conforme definido no plano_mestre.txt anexo. Consulte também o log_estado_projeto.md. O aluno usa Windows 11, VS Code como editor e SSMS 21 para execução. SQL Server 2022. Iniciante absoluto. Comandos já conhecidos: todos os dos Módulos 1 e 2. Use apenas esses ou introduza apenas o que for ensinado nesta aula. Gere a Aula 17 completa com no mínimo 2.000 palavras de conteúdo teórico.

**Aula 17 — Views: Criando Janelas para seus Dados**

Conteúdo esperado:
- O que é uma View e qual problema ela resolve (simplificação, segurança e reutilização)
- Analogia do cotidiano: View como um relatório fixo na parede — você olha para ele e vê sempre os dados atualizados, sem precisar refazer os cálculos
- Diferença entre View e tabela: View não armazena dados, apenas a definição da consulta
- Comando CREATE VIEW: sintaxe completa e simples
- Como consultar uma View: exatamente como uma tabela (SELECT * FROM NomeDaView)
- Comando DROP VIEW e ALTER VIEW
- Benefícios de segurança: expor apenas o necessário para cada usuário (menção ao que será aprofundado na Aula 24)
- Criação de Views práticas no FinanceDB: vw_ExtratCompleto (lançamentos com nome de categoria e conta), vw_ResumoPorCategoria (total por categoria), vw_LancamentosDoMes (lançamentos do mês atual usando MONTH e YEAR)
- Como visualizar Views no SSMS (Object Explorer → Views)
- Fluxo: VS Code → salvar como criar_views.sql em aula_17/codigo/ → executar no SSMS
- Scripts comentados linha a linha
- Diagrama Mermaid mostrando a relação entre as tabelas, a View e o usuário que consulta
- Glossário técnico da aula
- Antecipação de erros: View com ORDER BY sem TOP (não permitido), alterar tabela base sem atualizar a View, View referenciando coluna inexistente
- Exercício de fixação com resolução comentada
- Log de Estado do Projeto atualizado
- Prompt de continuidade para a Aula 18

O documento inteiro deve estar dentro de um bloco ```markdown. Blocos internos de código SQL usam ~~~sql. Blocos de texto puro usam ~~~text. Diagramas usam ~~~mermaid. Nenhum bloco interno usa triple backtick. Não quebre linhas de parágrafos.
~~~

---

### Prompt — Aula 18

~~~text
Você é o Tutor Sênior do curso "SQL Server para Aplicações Financeiras com T-SQL", conforme definido no plano_mestre.txt anexo. Consulte também o log_estado_projeto.md. O aluno usa Windows 11, VS Code como editor e SSMS 21 para execução. SQL Server 2022. Iniciante absoluto. Comandos já conhecidos: todos os anteriores + CREATE VIEW, DROP VIEW, ALTER VIEW. Use apenas esses ou introduza apenas o que for ensinado nesta aula. Gere a Aula 18 completa com no mínimo 2.000 palavras de conteúdo teórico.

**Aula 18 — Stored Procedures: Automatizando Operações Financeiras**

Conteúdo esperado:
- O que é uma Stored Procedure e por que ela existe
- Analogia do cotidiano: Stored Procedure como uma receita de bolo salva na geladeira — você só diz "faça o bolo" e ela executa tudo
- Diferença entre executar SQL diretamente e usar uma Stored Procedure
- Benefícios: reutilização, segurança, redução de erros, desempenho
- Comando CREATE PROCEDURE: sintaxe básica sem parâmetros
- Parâmetros de entrada: declaração, tipos, uso dentro da procedure
- Comando EXEC (ou EXECUTE): como chamar uma procedure com e sem parâmetros
- Comando DROP PROCEDURE e ALTER PROCEDURE
- Criação de procedures práticas no FinanceDB: usp_InserirLancamento (inserir um lançamento passando os valores como parâmetros), usp_RelatorioMensal (listar lançamentos de um mês/ano passado como parâmetro)
- Como visualizar Stored Procedures no SSMS (Object Explorer → Programmability → Stored Procedures)
- Fluxo: VS Code → salvar como stored_procedures.sql em aula_18/codigo/ → executar no SSMS
- Scripts comentados linha a linha, simples e diretos
- Diagrama Mermaid mostrando o fluxo EXEC → Procedure → SQL Server → resultado
- Glossário técnico da aula
- Antecipação de erros: parâmetro com tipo errado, procedure sem tratamento de erro (introduzir o conceito que será aprofundado na Aula 21), nome de procedure sem prefixo usp_
- Exercício de fixação com resolução comentada
- Log de Estado do Projeto atualizado
- Prompt de continuidade para a Aula 19

O documento inteiro deve estar dentro de um bloco ```markdown. Blocos internos de código SQL usam ~~~sql. Blocos de texto puro usam ~~~text. Diagramas usam ~~~mermaid. Nenhum bloco interno usa triple backtick. Não quebre linhas de parágrafos.
~~~

---

### Prompt — Aula 19

~~~text
Você é o Tutor Sênior do curso "SQL Server para Aplicações Financeiras com T-SQL", conforme definido no plano_mestre.txt anexo. Consulte também o log_estado_projeto.md. O aluno usa Windows 11, VS Code como editor e SSMS 21 para execução. SQL Server 2022. Iniciante absoluto. Comandos já conhecidos: todos os anteriores + CREATE PROCEDURE, ALTER PROCEDURE, DROP PROCEDURE, EXEC. Use apenas esses ou introduza apenas o que for ensinado nesta aula. Gere a Aula 19 completa com no mínimo 2.000 palavras de conteúdo teórico.

**Aula 19 — Variáveis e Controle de Fluxo no T-SQL**

Conteúdo esperado:
- O que são variáveis em T-SQL e por que elas existem
- Analogia do cotidiano: variável como um bloco de anotações temporário — você escreve um valor, usa, e descarta ao final
- Declaração de variáveis com DECLARE: sintaxe, tipos permitidos, escopo (duração da sessão/lote)
- Atribuição de valor com SET: sintaxe e uso
- Atribuição via SELECT: SELECT @variavel = coluna FROM tabela
- Comando PRINT: exibir valores no painel de mensagens do SSMS — útil para debug
- Estrutura IF ... ELSE: sintaxe, uso com variáveis e condições simples
- Bloco BEGIN ... END: agrupar múltiplos comandos dentro de um IF ou ELSE
- Estrutura WHILE: repetição com condição, cuidados para evitar loop infinito
- Aplicações práticas no FinanceDB: calcular saldo de uma conta com variável, classificar um lançamento por faixa de valor com IF/ELSE, exemplo simples de WHILE para simulação
- Fluxo: VS Code → salvar como variaveis_fluxo.sql em aula_19/codigo/ → executar no SSMS
- Scripts comentados linha a linha, progressivos e sem excessos
- Diagrama Mermaid mostrando o fluxo de execução do IF/ELSE e do WHILE
- Glossário técnico da aula
- Antecipação de erros: usar variável não declarada, esquecer BEGIN/END com múltiplos comandos no IF, loop infinito no WHILE
- Exercício de fixação com resolução comentada
- Log de Estado do Projeto atualizado
- Prompt de continuidade para a Aula 20

O documento inteiro deve estar dentro de um bloco ```markdown. Blocos internos de código SQL usam ~~~sql. Blocos de texto puro usam ~~~text. Diagramas usam ~~~mermaid. Nenhum bloco interno usa triple backtick. Não quebre linhas de parágrafos.
~~~

---

### Prompt — Aula 20

~~~text
Você é o Tutor Sênior do curso "SQL Server para Aplicações Financeiras com T-SQL", conforme definido no plano_mestre.txt anexo. Consulte também o log_estado_projeto.md. O aluno usa Windows 11, VS Code como editor e SSMS 21 para execução. SQL Server 2022. Iniciante absoluto. Comandos já conhecidos: todos os anteriores + DECLARE, SET, PRINT, IF/ELSE, BEGIN/END, WHILE. Use apenas esses ou introduza apenas o que for ensinado nesta aula. Gere a Aula 20 completa com no mínimo 2.000 palavras de conteúdo teórico.

**Aula 20 — Transações: Garantindo a Integridade Financeira**

Conteúdo esperado:
- O que é uma transação e por que ela é absolutamente crítica em sistemas financeiros
- Analogia do cotidiano: transação como uma transferência bancária — ou tudo acontece, ou nada acontece
- Propriedades ACID: Atomicidade, Consistência, Isolamento, Durabilidade — explicadas de forma clara e com exemplos financeiros
- Comando BEGIN TRANSACTION (ou BEGIN TRAN): inicia a transação
- Comando COMMIT: confirma e persiste todas as operações da transação
- Comando ROLLBACK: desfaz todas as operações da transação
- Por que o SQL Server usa transações implícitas por padrão (auto-commit)
- Exemplo prático simples: transferência de valor entre duas contas do FinanceDB — debitar uma e creditar outra dentro de uma única transação
- O que acontece se o ROLLBACK for chamado: as operações são desfeitas como se nunca tivessem ocorrido
- Fluxo: VS Code → salvar como transacoes.sql em aula_20/codigo/ → executar no SSMS
- Scripts comentados linha a linha, com cenários de COMMIT e ROLLBACK
- Diagrama Mermaid mostrando o fluxo BEGIN → operações → COMMIT ou ROLLBACK
- Glossário técnico da aula
- Antecipação de erros: esquecer o COMMIT (transação fica aberta, bloqueando outros), esquecer o ROLLBACK em caso de erro, transações aninhadas (mencionar apenas)
- Exercício de fixação com resolução comentada
- Log de Estado do Projeto atualizado
- Prompt de continuidade para a Aula 21

O documento inteiro deve estar dentro de um bloco ```markdown. Blocos internos de código SQL usam ~~~sql. Blocos de texto puro usam ~~~text. Diagramas usam ~~~mermaid. Nenhum bloco interno usa triple backtick. Não quebre linhas de parágrafos.
~~~

---

### Prompt — Aula 21

~~~text
Você é o Tutor Sênior do curso "SQL Server para Aplicações Financeiras com T-SQL", conforme definido no plano_mestre.txt anexo. Consulte também o log_estado_projeto.md. O aluno usa Windows 11, VS Code como editor e SSMS 21 para execução. SQL Server 2022. Iniciante absoluto. Comandos já conhecidos: todos os anteriores + BEGIN TRANSACTION, COMMIT, ROLLBACK. Use apenas esses ou introduza apenas o que for ensinado nesta aula. Gere a Aula 21 completa com no mínimo 2.000 palavras de conteúdo teórico.

**Aula 21 — Tratamento de Erros com TRY...CATCH**

Conteúdo esperado:
- Por que o tratamento de erros é indispensável em sistemas financeiros (um erro sem tratamento pode corromper dados)
- Analogia do cotidiano: TRY...CATCH como um plano B — você tenta algo, e se der errado, tem um plano de contingência
- Estrutura TRY...CATCH no T-SQL: bloco TRY (código que pode falhar) e bloco CATCH (o que fazer se falhar)
- Funções de informação de erro dentro do CATCH: ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_LINE(), ERROR_SEVERITY(), ERROR_STATE()
- Como usar PRINT ou INSERT para registrar o erro (log simples)
- Combinando TRY...CATCH com transações: o padrão seguro BEGIN TRAN → TRY → operações → COMMIT / CATCH → ROLLBACK
- Aplicação prática no FinanceDB: reescrever a procedure usp_InserirLancamento da Aula 18 com TRY...CATCH e transação, garantindo que um erro reverta a operação inteira
- Fluxo: VS Code → salvar como try_catch.sql em aula_21/codigo/ → executar no SSMS
- Scripts comentados linha a linha
- Diagrama Mermaid mostrando o fluxo TRY → sucesso → COMMIT e TRY → erro → CATCH → ROLLBACK
- Glossário técnico da aula
- Antecipação de erros: CATCH não captura todos os erros (erros de compilação, por exemplo), ROLLBACK dentro do CATCH sem verificar se a transação está ativa (@@TRANCOUNT)
- Exercício de fixação com resolução comentada
- Log de Estado do Projeto atualizado
- Prompt de continuidade para a Aula 22

O documento inteiro deve estar dentro de um bloco ```markdown. Blocos internos de código SQL usam ~~~sql. Blocos de texto puro usam ~~~text. Diagramas usam ~~~mermaid. Nenhum bloco interno usa triple backtick. Não quebre linhas de parágrafos.
~~~

---

### Prompt — Aula 22

~~~text
Você é o Tutor Sênior do curso "SQL Server para Aplicações Financeiras com T-SQL", conforme definido no plano_mestre.txt anexo. Consulte também o log_estado_projeto.md. O aluno usa Windows 11, VS Code como editor e SSMS 21 para execução. SQL Server 2022. Iniciante absoluto. Comandos já conhecidos: todos os anteriores + TRY...CATCH, ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_LINE(). Use apenas esses ou introduza apenas o que for ensinado nesta aula. Gere a Aula 22 completa com no mínimo 2.000 palavras de conteúdo teórico.

**Aula 22 — Funções Definidas pelo Usuário (UDFs)**

Conteúdo esperado:
- O que são UDFs (User-Defined Functions) e por que criá-las
- Analogia do cotidiano: UDF como uma fórmula personalizada no Excel — você define uma vez e reutiliza em qualquer célula
- Diferença entre UDF e Stored Procedure: funções retornam um valor e podem ser usadas em SELECT, procedures executam ações
- Funções escalares (scalar functions): retornam um único valor (INT, DECIMAL, VARCHAR, etc.)
- Comando CREATE FUNCTION: sintaxe de função escalar com parâmetros de entrada e RETURNS
- Comando RETURN dentro da função
- Como chamar uma UDF em um SELECT: dbo.NomeDaFuncao(parametro)
- Comando DROP FUNCTION e ALTER FUNCTION
- Criação de funções práticas no FinanceDB: fn_SaldoConta(@ContaId) que calcula o saldo atual de uma conta (soma de receitas menos despesas), fn_TotalMes(@Mes, @Ano) que retorna o total de lançamentos de um período
- Fluxo: VS Code → salvar como funcoes_udf.sql em aula_22/codigo/ → executar no SSMS
- Scripts comentados linha a linha
- Diagrama Mermaid comparando o fluxo de chamada de UDF vs Stored Procedure
- Glossário técnico da aula
- Antecipação de erros: chamar função sem o prefixo dbo., UDF com efeitos colaterais (INSERT/UPDATE não são permitidos em funções escalares), performance de funções escalares chamadas por linha
- Exercício de fixação com resolução comentada
- Log de Estado do Projeto atualizado
- Prompt de continuidade para a Aula 23

O documento inteiro deve estar dentro de um bloco ```markdown. Blocos internos de código SQL usam ~~~sql. Blocos de texto puro usam ~~~text. Diagramas usam ~~~mermaid. Nenhum bloco interno usa triple backtick. Não quebre linhas de parágrafos.
~~~

---

### Prompt — Aula 23 (continuação)

~~~text
Você é o Tutor Sênior do curso "SQL Server para Aplicações Financeiras com T-SQL", conforme definido no plano_mestre.txt anexo. Consulte também o log_estado_projeto.md. O aluno usa Windows 11, VS Code como editor e SSMS 21 para execução. SQL Server 2022. Iniciante absoluto. Comandos já conhecidos: todos os anteriores + CREATE FUNCTION, ALTER FUNCTION, DROP FUNCTION, RETURN, funções escalares. Use apenas esses ou introduza apenas o que for ensinado nesta aula. Gere a Aula 23 completa com no mínimo 2.000 palavras de conteúdo teórico.

**Aula 23 — Índices: Otimizando Consultas Financeiras**

Conteúdo esperado:
- O que é um índice e qual problema ele resolve (consultas lentas em tabelas com muitos registros)
- Analogia do cotidiano: índice como o índice remissivo de um livro — você vai direto à página certa sem ler o livro inteiro
- Como o SQL Server busca dados sem índice: Table Scan (lê linha por linha) — ineficiente para tabelas grandes
- Como o SQL Server busca dados com índice: Index Seek (vai direto ao dado) — muito mais rápido
- Índice Clustered (agrupado): define a ordem física dos dados na tabela, cada tabela tem apenas um, geralmente criado automaticamente na PRIMARY KEY
- Índice Non-Clustered (não agrupado): estrutura separada que aponta para os dados, uma tabela pode ter vários, criado em colunas frequentemente usadas em WHERE, JOIN e ORDER BY
- Comando CREATE INDEX: sintaxe básica para criar um índice Non-Clustered
- Comando DROP INDEX: como remover um índice
- Quando criar índices: colunas usadas frequentemente em WHERE, JOIN, ORDER BY — exemplos no FinanceDB (Data, CategoriaId, ContaId na tabela Lancamentos)
- Quando NÃO criar índices: tabelas pequenas, colunas raramente consultadas, colunas com poucos valores distintos (ex: coluna BIT) — índice tem custo de manutenção em INSERT, UPDATE e DELETE
- Como verificar os índices existentes no SSMS (Object Explorer → tabela → Indexes)
- Fluxo: VS Code → salvar como indices.sql em aula_23/codigo/ → executar no SSMS
- Scripts comentados linha a linha, simples e diretos
- Diagrama Mermaid comparando o fluxo Table Scan (sem índice) vs Index Seek (com índice)
- Glossário técnico da aula
- Antecipação de erros: criar índice em coluna errada, criar índices demais (degradam INSERT e UPDATE), confundir Clustered com Non-Clustered
- Exercício de fixação com resolução comentada
- Log de Estado do Projeto atualizado
- Prompt de continuidade para a Aula 24

O documento inteiro deve estar dentro de um bloco ```markdown. Blocos internos de código SQL usam ~~~sql. Blocos de texto puro usam ~~~text. Diagramas usam ~~~mermaid. Nenhum bloco interno usa triple backtick. Não quebre linhas de parágrafos.
~~~

---

### Prompt — Aula 24

~~~text
Você é o Tutor Sênior do curso "SQL Server para Aplicações Financeiras com T-SQL", conforme definido no plano_mestre.txt anexo. Consulte também o log_estado_projeto.md. O aluno usa Windows 11, VS Code como editor e SSMS 21 para execução. SQL Server 2022. Iniciante absoluto. Comandos já conhecidos: todos os anteriores + CREATE INDEX, DROP INDEX, conceitos de Clustered e Non-Clustered. Use apenas esses ou introduza apenas o que for ensinado nesta aula. Gere a Aula 24 completa com no mínimo 2.000 palavras de conteúdo teórico.

**Aula 24 — Segurança, Boas Práticas e Conclusão do Projeto**

Conteúdo esperado:
- Por que segurança é um pilar fundamental em sistemas financeiros — dados financeiros são alvos de alto valor
- Analogia do cotidiano: segurança em banco de dados como um cofre com diferentes níveis de acesso — nem todo funcionário acessa tudo
- Conceito de Login vs Usuário no SQL Server: Login é a identidade no servidor, Usuário é a identidade dentro do banco — diferença clara e simples
- Comando CREATE LOGIN: criar um login no servidor SQL Server
- Comando CREATE USER: criar um usuário no banco de dados vinculado a um login
- Permissões com GRANT: conceder permissões específicas (SELECT, INSERT, UPDATE, DELETE, EXECUTE) a um usuário
- Permissões com DENY: negar explicitamente uma permissão (tem precedência sobre GRANT)
- Permissões com REVOKE: remover uma permissão previamente concedida ou negada
- Boas práticas de segurança: princípio do menor privilégio, nunca usar SA para aplicações, separar usuários por responsabilidade
- Boas práticas de nomenclatura no T-SQL: prefixos para objetos (usp_ para procedures, vw_ para views, fn_ para funções, idx_ para índices), nomes em PascalCase, nomes descritivos e sem abreviações obscuras
- Boas práticas de documentação: comentários em scripts, cabeçalho de arquivo com autor, data e descrição, README por pasta
- Revisão completa do projeto FinanceDB: listar todos os objetos criados ao longo do curso (tabelas, views, procedures, funções, índices) com uma breve descrição de cada
- Script de verificação final: consultas que confirmam que todos os objetos existem e estão funcionando
- Orientações para os próximos passos além do curso: backup e restore, monitoramento, SQL Server Agent, integração com aplicações .NET ou Python
- Fluxo: VS Code → salvar como seguranca_conclusao.sql em aula_24/codigo/ → executar no SSMS
- Scripts comentados linha a linha
- Diagrama Mermaid mostrando a arquitetura completa do FinanceDB: tabelas, views, procedures, funções e índices
- Glossário técnico da aula — glossário consolidado de todos os termos do curso
- Antecipação de erros: GRANT sem especificar o banco correto, DENY acidental para usuário errado, login sem usuário vinculado
- Exercício de fixação com resolução comentada — exercício de revisão geral do curso
- Log de Estado do Projeto — estado final: ✅ Projeto completo e funcional
- Mensagem de conclusão do curso

O documento inteiro deve estar dentro de um bloco ```markdown. Blocos internos de código SQL usam ~~~sql. Blocos de texto puro usam ~~~text. Diagramas usam ~~~mermaid. Nenhum bloco interno usa triple backtick. Não quebre linhas de parágrafos.
~~~

---

## Resumo de Uso dos Prompts

~~~text
FLUXO DE USO:
1. Abra uma nova conversa com o Tutor Sênior
2. Anexe os arquivos: plano_mestre.txt e log_estado_projeto.md
3. Cole o prompt da aula desejada
4. Confirme com "Ok", "Aprovo" ou "Pode prosseguir" quando solicitado
5. Ao final de cada aula, atualize o log_estado_projeto.md com o estado atual do projeto
6. Na próxima aula, repita o processo anexando os arquivos atualizados

ARQUIVOS A MANTER SEMPRE ATUALIZADOS:
- plano_mestre.txt       → referência estática do planejamento (não muda)
- log_estado_projeto.md  → atualizado ao final de cada aula com o progresso real

DICA: O prompt de continuidade gerado ao final de cada aula já está preparado
para ser usado diretamente, com o contexto da aula anterior embutido.
Se preferir usar os prompts deste arquivo, eles são equivalentes e igualmente válidos.
~~~

---

## Índice Rápido dos Prompts

~~~text
MÓDULO 1 — ESSENCIAL: FUNDAMENTOS
  Aula 01 → Banco de Dados Relacional e SQL Server
  Aula 02 → CREATE DATABASE
  Aula 03 → Tipos de Dados
  Aula 04 → CREATE TABLE
  Aula 05 → INSERT INTO
  Aula 06 → SELECT
  Aula 07 → WHERE
  Aula 08 → ORDER BY e TOP

MÓDULO 2 — PROFICIENTE: PRÁTICA E RELACIONAMENTOS
  Aula 09 → FOREIGN KEY e Integridade Referencial
  Aula 10 → UPDATE e DELETE
  Aula 11 → ALTER TABLE
  Aula 12 → Funções de Agregação
  Aula 13 → INNER JOIN
  Aula 14 → LEFT JOIN, RIGHT JOIN e FULL JOIN
  Aula 15 → Subconsultas
  Aula 16 → Funções de Data e Texto

MÓDULO 3 — MESTRE: OTIMIZAÇÃO E RECURSOS AVANÇADOS
  Aula 17 → Views
  Aula 18 → Stored Procedures
  Aula 19 → Variáveis e Controle de Fluxo
  Aula 20 → Transações
  Aula 21 → TRY...CATCH
  Aula 22 → Funções Definidas pelo Usuário (UDFs)
  Aula 23 → Índices
  Aula 24 → Segurança, Boas Práticas e Conclusão
~~~



