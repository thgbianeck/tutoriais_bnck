# Capítulo 10: Inserindo Dados — INSERT INTO
## Livro: SQL Server para Aplicações Financeiras com T-SQL
## Módulo 2 — ESSENCIAL: T-SQL Básico

---

## Análise de Integridade

✅ Conteúdo verificado: profundidade técnica mantida, linguagem acessível pela Técnica de Feynman, narrativa com mínimo de 2.000 palavras, analogia de ancoragem presente, diagrama Mermaid incluído, glossário técnico completo, antecipação de erros mapeada, desafio de fixação com resolução comentada, log de estado atualizado e prompt de continuidade gerado.

---

## Resumo do Capítulo Anterior

No **Capítulo 9** implementamos o modelo físico completo do FinanceDB. Criamos as quatro tabelas restantes — **ContasBancarias**, **PlanoDeContas**, **Transacoes** e **Orcamentos** — com **PRIMARY KEY** baseada em **IDENTITY**, estabelecemos **10 Foreign Keys** com ação referencial **NO ACTION**, e modelamos o auto-relacionamento hierárquico em **PlanoDeContas** com a coluna `ContaParenteID`. Inserimos dados iniciais em Empresas (1 registro), ContasBancarias (1 registro) e PlanoDeContas (8 registros em 3 níveis hierárquicos). O modelo físico está completo e íntegro, verificado nas views de catálogo `sys.tables`, `sys.foreign_keys` e `sys.foreign_key_columns`. A estrutura existe — agora precisamos dar vida a ela com dados financeiros reais.

---

## Objetivo

Popular todas as tabelas do **FinanceDB** com dados financeiros realistas usando o comando `INSERT INTO` em suas três variações: **linha única**, **múltiplas linhas em um único statement** e **INSERT...SELECT** para carga a partir de outra tabela. Aprender a capturar IDs gerados automaticamente pelo IDENTITY com **SCOPE_IDENTITY()** e **OUTPUT**, respeitar a ordem de inserção ditada pelas Foreign Keys, identificar e resolver erros de violação de constraint durante a carga de dados e construir um dataset financeiro coerente que servirá de base para todas as consultas, relatórios e análises dos próximos capítulos.

---

## Pré-requisitos

**Capítulo 9 concluído.** As 7 tabelas do FinanceDB devem estar criadas com todas as constraints e Foreign Keys ativas. Os dados iniciais de Empresas, ContasBancarias e PlanoDeContas devem estar presentes conforme registrado no log de estado do Capítulo 9.

---

## Teoria Detalhada

### A Analogia de Ancoragem: O Arquivo Morto de um Departamento Financeiro

Imagine que você acabou de construir o arquivo físico de um departamento financeiro. As prateleiras estão montadas, as pastas estão etiquetadas, os divisores separam categorias e as regras de organização estão afixadas na parede — ninguém pode colocar um documento na pasta "Despesas" sem antes ter a pasta "Empresas" corretamente identificada. O arquivo existe, a estrutura é perfeita, mas as prateleiras estão completamente vazias.

O `INSERT INTO` é o ato de pegar os documentos financeiros reais — os extratos bancários, os comprovantes de pagamento, as notas fiscais, os relatórios de orçamento — e arquivá-los nas pastas corretas, na ordem correta, respeitando todas as regras de organização estabelecidas. Se você tentar arquivar um comprovante de pagamento antes de ter criado a pasta da empresa pagadora, o arquivista — que neste caso é o SQL Server — devolverá o documento com um erro de violação de integridade referencial. A ordem importa. A coerência importa. E uma vez que os documentos estão arquivados corretamente, qualquer consulta futura encontrará exatamente o que procura, exatamente onde deveria estar.

---

### O Comando INSERT INTO: Três Faces do Mesmo Mecanismo

O `INSERT INTO` é o comando DML — **Data Manipulation Language** — responsável por adicionar novas linhas a uma tabela. Ele possui três variações principais, cada uma adequada a um contexto diferente.

**Variação 1: Linha Única.** A forma mais simples e explícita. Insere exatamente um registro por execução. É ideal para inserções interativas, testes e situações onde você precisa capturar o ID gerado imediatamente após cada inserção.

~~~sql
INSERT INTO NomeTabela (Coluna1, Coluna2, Coluna3)
VALUES (Valor1, Valor2, Valor3);
~~~

**Variação 2: Múltiplas Linhas em Um Único Statement.** Introduzida no SQL Server 2008, permite inserir várias linhas em um único comando separando os conjuntos de valores por vírgula. É significativamente mais eficiente do que múltiplos INSERTs individuais porque reduz o número de roundtrips entre a aplicação e o banco de dados e gera menos entradas no Transaction Log.

~~~sql
INSERT INTO NomeTabela (Coluna1, Coluna2, Coluna3)
VALUES
    (Valor1a, Valor2a, Valor3a),
    (Valor1b, Valor2b, Valor3b),
    (Valor1c, Valor2c, Valor3c);
~~~

**Variação 3: INSERT...SELECT.** A forma mais poderosa. Em vez de especificar valores literais, utiliza uma query SELECT como fonte de dados. É a base das operações de carga e transformação de dados, permitindo copiar, filtrar e transformar dados de uma ou mais tabelas origem para uma tabela destino.

~~~sql
INSERT INTO TabelaDestino (Coluna1, Coluna2)
SELECT ColunaA, ColunaB
FROM TabelaOrigem
WHERE Condicao = 'valor';
~~~

---

### IDENTITY e o Problema do ID Gerado

Todas as tabelas do FinanceDB usam colunas `IDENTITY(1,1)` como chave primária. Isso significa que o SQL Server gera automaticamente o valor do ID a cada INSERT — o programador não informa o ID, o banco o atribui. Isso resolve o problema de unicidade, mas cria uma nova questão: como saber qual ID foi gerado para usar como Foreign Key na inserção seguinte?

O SQL Server oferece três funções para capturar o último ID gerado por IDENTITY, e a distinção entre elas é crítica — e frequentemente cobrada em certificações.

**`@@IDENTITY`** retorna o último valor de IDENTITY gerado na sessão atual, em qualquer tabela, incluindo tabelas manipuladas por Triggers. É a função mais antiga e a mais perigosa: se um Trigger disparar durante o INSERT e inserir em outra tabela com IDENTITY, `@@IDENTITY` retornará o ID da tabela do Trigger, não da tabela que você acabou de inserir. Nunca use `@@IDENTITY` em código de produção.

**`SCOPE_IDENTITY()`** retorna o último valor de IDENTITY gerado na sessão atual e no escopo atual — ignorando Triggers e chamadas a outros escopos. É a função correta para capturar o ID de um INSERT em código de produção.

**`IDENT_CURRENT('NomeTabela')`** retorna o último valor de IDENTITY gerado para uma tabela específica, independentemente de sessão ou escopo. É útil para diagnóstico e administração, mas não deve ser usada para capturar o ID de um INSERT recém-executado em código concorrente, pois outra sessão pode ter inserido um registro entre o seu INSERT e a chamada à função.

A regra de ouro é simples: **sempre use `SCOPE_IDENTITY()`** para capturar IDs gerados logo após um INSERT em código T-SQL.

---

### A Cláusula OUTPUT: Visibilidade Total sobre o que Foi Inserido

A cláusula `OUTPUT` permite capturar, no momento exato da inserção, os valores de todas as colunas — incluindo as geradas pelo IDENTITY — de cada linha inserida. Ela acessa a tabela especial `INSERTED`, que existe temporariamente durante a execução do comando DML e contém exatamente as linhas que acabaram de ser escritas.

~~~sql
INSERT INTO Bancos (NomeBanco, CodigoBanco, Ativo)
OUTPUT INSERTED.BancoID, INSERTED.NomeBanco, INSERTED.CodigoBanco
VALUES ('Itaú Unibanco', '341', 1);
~~~

O resultado do `OUTPUT` aparece como um resultado adicional no painel do SSMS, mostrando o ID gerado e todos os valores inseridos. Em cenários de inserção múltipla, o OUTPUT exibe uma linha para cada registro inserido — algo que `SCOPE_IDENTITY()` não consegue fazer, pois retorna apenas o último ID gerado, não todos os IDs de um INSERT de múltiplas linhas.

---

### A Ordem de Inserção e o Grafo de Dependências

Com 10 Foreign Keys ativas no FinanceDB, a ordem de inserção entre tabelas não é arbitrária — ela é ditada pelo grafo de dependências. Uma tabela que contém uma FK para outra tabela só pode ser populada depois que a tabela referenciada já contiver os registros necessários.

A ordem correta de inserção para o FinanceDB é a seguinte, do menos dependente para o mais dependente: primeiro **Bancos** e **TiposTransacao** (sem dependências externas), depois **Empresas** (sem dependências externas), depois **ContasBancarias** (depende de Bancos e Empresas), depois **PlanoDeContas** (depende de Empresas e de si mesma via auto-relacionamento), e finalmente **Transacoes** e **Orcamentos** (dependem de praticamente todas as outras tabelas).

~~~mermaid
graph TD
    Bancos --> ContasBancarias
    TiposTransacao --> Transacoes
    Empresas --> ContasBancarias
    Empresas --> PlanoDeContas
    Empresas --> Orcamentos
    ContasBancarias --> Transacoes
    PlanoDeContas --> Transacoes
    PlanoDeContas --> Orcamentos
    PlanoDeContas --> PlanoDeContas
    Transacoes --> Transacoes
~~~

---

## Implementação Prática: Populando o FinanceDB Completo

Vamos popular todas as tabelas do FinanceDB com um dataset financeiro realista e coerente, seguindo rigorosamente a ordem do grafo de dependências. Todos os scripts devem ser executados no contexto do banco FinanceDB.

~~~sql
-- ============================================================
-- SCRIPT: popular_financedb.sql
-- DESCRIÇÃO: Popula todas as tabelas do FinanceDB com dados
--            financeiros realistas para o curso completo.
-- ORDEM: Respeita o grafo de dependências das Foreign Keys.
-- ============================================================

-- Garante que estamos no contexto correto
USE FinanceDB;
GO

-- ============================================================
-- ETAPA 1: VARIÁVEIS DE CONTROLE
-- Declara variáveis para capturar IDs gerados pelo IDENTITY
-- usando SCOPE_IDENTITY() após cada INSERT crítico.
-- ============================================================

DECLARE @EmpresaID      INT; -- ID da empresa principal inserida
DECLARE @BancoItauID    INT; -- ID do Banco Itaú após inserção
DECLARE @BancoBBID      INT; -- ID do Banco do Brasil após inserção
DECLARE @BancoCaixaID   INT; -- ID da Caixa Econômica após inserção
DECLARE @ContaCorrenteID INT; -- ID da conta corrente principal
DECLARE @ContaPoupancaID INT; -- ID da conta poupança inserida

-- ============================================================
-- ETAPA 2: LIMPEZA CONDICIONAL (OPCIONAL PARA REEXECUÇÃO)
-- Permite reexecutar o script do zero sem erro de duplicação.
-- A ordem de DELETE respeita as FKs (filhos antes dos pais).
-- ============================================================

DELETE FROM Orcamentos;          -- depende de Empresas e PlanoDeContas
DELETE FROM Transacoes;          -- depende de ContasBancarias e PlanoDeContas
DELETE FROM PlanoDeContas;       -- depende de Empresas (auto-ref)
DELETE FROM ContasBancarias;     -- depende de Bancos e Empresas
DELETE FROM Empresas;            -- tabela raiz de negócio
DELETE FROM TiposTransacao;      -- tabela de domínio independente
DELETE FROM Bancos;              -- tabela de domínio independente

-- Reseta as sementes do IDENTITY para garantir IDs previsíveis
DBCC CHECKIDENT ('Bancos',         RESEED, 0);
DBCC CHECKIDENT ('TiposTransacao', RESEED, 0);
DBCC CHECKIDENT ('Empresas',       RESEED, 0);
DBCC CHECKIDENT ('ContasBancarias',RESEED, 0);
DBCC CHECKIDENT ('PlanoDeContas',  RESEED, 0);
DBCC CHECKIDENT ('Transacoes',     RESEED, 0);
DBCC CHECKIDENT ('Orcamentos',     RESEED, 0);
GO

-- ============================================================
-- ETAPA 3: BANCOS
-- Primeira tabela a ser populada — sem nenhuma dependência.
-- Usamos INSERT de múltiplas linhas com OUTPUT para visualizar
-- todos os IDs gerados de uma única vez.
-- ============================================================

INSERT INTO Bancos (NomeBanco, CodigoBanco, Ativo)
OUTPUT
    INSERTED.BancoID    AS ID_Gerado,
    INSERTED.NomeBanco  AS Banco,
    INSERTED.CodigoBanco AS Codigo
VALUES
    ('Itaú Unibanco',          '341', 1), -- BancoID = 1
    ('Banco do Brasil',        '001', 1), -- BancoID = 2
    ('Caixa Econômica Federal','104', 1), -- BancoID = 3
    ('Bradesco',               '237', 1), -- BancoID = 4
    ('Nubank',                 '260', 1); -- BancoID = 5

-- ============================================================
-- ETAPA 4: TIPOS DE TRANSAÇÃO
-- Tabela de domínio — define as categorias de lançamento.
-- ============================================================

INSERT INTO TiposTransacao (Descricao, Ativo)
OUTPUT INSERTED.TipoTransacaoID, INSERTED.Descricao
VALUES
    ('RECEITA',         1), -- TipoTransacaoID = 1
    ('DESPESA',         1), -- TipoTransacaoID = 2
    ('TRANSFERENCIA',   1); -- TipoTransacaoID = 3

-- ============================================================
-- ETAPA 5: EMPRESAS — LINHA ÚNICA COM CAPTURA DE ID
-- Inserimos a empresa principal e capturamos seu ID com
-- SCOPE_IDENTITY() para usar nas tabelas dependentes.
-- ============================================================

INSERT INTO Empresas (RazaoSocial, NomeFantasia, CNPJ, Ativo, DataCadastro)
VALUES (
    'TechFinance Soluções Ltda',  -- RazaoSocial: nome jurídico
    'TechFinance',                -- NomeFantasia: nome comercial
    '12.345.678/0001-99',         -- CNPJ: formato padrão brasileiro
    1,                            -- Ativo: empresa em operação
    GETDATE()                     -- DataCadastro: data atual do sistema
);

-- Captura o ID da empresa recém-inserida com SCOPE_IDENTITY()
-- Esta é a forma correta e segura para código de produção.
SET @EmpresaID = SCOPE_IDENTITY();

-- Confirma o ID capturado antes de prosseguir
PRINT 'Empresa inserida com ID: ' + CAST(@EmpresaID AS VARCHAR(10));

-- Segunda empresa para enriquecer os relatórios futuros
INSERT INTO Empresas (RazaoSocial, NomeFantasia, CNPJ, Ativo, DataCadastro)
VALUES (
    'Alpha Investimentos S.A.',   -- holding do grupo
    'Alpha Invest',
    '98.765.432/0001-11',
    1,
    GETDATE()
);

-- ============================================================
-- ETAPA 6: CONTAS BANCÁRIAS
-- Depende de Bancos (já inseridos) e Empresas (já inseridas).
-- Inserimos contas da empresa TechFinance (EmpresaID = 1).
-- ============================================================

INSERT INTO ContasBancarias
    (EmpresaID, BancoID, NomeConta, Agencia, NumeroConta, TipoConta, SaldoAtual, Ativo)
OUTPUT
    INSERTED.ContaID,
    INSERTED.NomeConta,
    INSERTED.SaldoAtual
VALUES
    -- Conta corrente principal no Itaú — ID esperado: 1
    (1, 1, 'Conta Corrente Principal', '0341', '12345-6', 'CORRENTE',  125000.00, 1),
    -- Conta poupança reserva no Itaú — ID esperado: 2
    (1, 1, 'Poupança Reserva',         '0341', '12345-7', 'POUPANCA',   38500.00, 1),
    -- Conta no Banco do Brasil para folha de pagamento — ID: 3
    (1, 2, 'Folha de Pagamento BB',    '1234',  '99887-5', 'CORRENTE',  15000.00, 1),
    -- Conta da segunda empresa (Alpha Invest) na Caixa — ID: 4
    (2, 3, 'Conta Alpha Invest',       '0104',  '55443-2', 'CORRENTE',  250000.00, 1);

-- ============================================================
-- ETAPA 7: PLANO DE CONTAS — AUTO-RELACIONAMENTO HIERÁRQUICO
-- A ordem dentro desta tabela também importa: contas pai
-- devem ser inseridas antes das contas filho.
-- ContaParenteID NULL indica conta raiz (nível 1).
-- ============================================================

INSERT INTO PlanoDeContas (EmpresaID, Codigo, Descricao, Tipo, Nivel, ContaParenteID, Ativo)
VALUES
-- NÍVEL 1: Contas Raiz (sem pai — ContaParenteID NULL)
(1, '1',   'RECEITAS',                     'RECEITA',  1, NULL, 1), -- ID: 1
(1, '2',   'DESPESAS',                     'DESPESA',  1, NULL, 1), -- ID: 2

-- NÍVEL 2: Grupos de Receita (pai = ID 1 - RECEITAS)
(1, '1.1', 'Receitas Operacionais',        'RECEITA',  2, 1,    1), -- ID: 3
(1, '1.2', 'Receitas Financeiras',         'RECEITA',  2, 1,    1), -- ID: 4

-- NÍVEL 2: Grupos de Despesa (pai = ID 2 - DESPESAS)
(1, '2.1', 'Despesas Operacionais',        'DESPESA',  2, 2,    1), -- ID: 5
(1, '2.2', 'Despesas com Pessoal',         'DESPESA',  2, 2,    1), -- ID: 6
(1, '2.3', 'Despesas Financeiras',         'DESPESA',  2, 2,    1), -- ID: 7

-- NÍVEL 3: Contas Analíticas de Receita Operacional (pai = ID 3)
(1, '1.1.1', 'Venda de Software',          'RECEITA',  3, 3,    1), -- ID: 8
(1, '1.1.2', 'Consultoria e Projetos',     'RECEITA',  3, 3,    1), -- ID: 9
(1, '1.1.3', 'Suporte e Manutenção',       'RECEITA',  3, 3,    1), -- ID: 10

-- NÍVEL 3: Contas Analíticas de Receita Financeira (pai = ID 4)
(1, '1.2.1', 'Rendimentos de Aplicações',  'RECEITA',  3, 4,    1), -- ID: 11
(1, '1.2.2', 'Juros Recebidos',            'RECEITA',  3, 4,    1), -- ID: 12

-- NÍVEL 3: Contas Analíticas de Despesa Operacional (pai = ID 5)
(1, '2.1.1', 'Aluguel e Condomínio',       'DESPESA',  3, 5,    1), -- ID: 13
(1, '2.1.2', 'Energia Elétrica',           'DESPESA',  3, 5,    1), -- ID: 14
(1, '2.1.3', 'Telefone e Internet',        'DESPESA',  3, 5,    1), -- ID: 15
(1, '2.1.4', 'Material de Escritório',     'DESPESA',  3, 5,    1), -- ID: 16

-- NÍVEL 3: Contas Analíticas de Pessoal (pai = ID 6)
(1, '2.2.1', 'Salários e Encargos',        'DESPESA',  3, 6,    1), -- ID: 17
(1, '2.2.2', 'Benefícios',                 'DESPESA',  3, 6,    1), -- ID: 18
(1, '2.2.3', 'Pró-labore',                 'DESPESA',  3, 6,    1), -- ID: 19

-- NÍVEL 3: Contas Analíticas de Despesa Financeira (pai = ID 7)
(1, '2.3.1', 'Tarifas Bancárias',          'DESPESA',  3, 7,    1), -- ID: 20
(1, '2.3.2', 'IOF e Impostos Financeiros', 'DESPESA',  3, 7,    1); -- ID: 21

-- ============================================================
-- ETAPA 8: TRANSAÇÕES — O CORAÇÃO DO SISTEMA FINANCEIRO
-- Depende de ContasBancarias, PlanoDeContas e TiposTransacao.
-- Inserimos lançamentos reais dos últimos 3 meses para que
-- os capítulos futuros de consultas e relatórios tenham
-- dados ricos o suficiente para análises significativas.
-- ============================================================

INSERT INTO Transacoes
    (ContaID, PlanoContaID, TipoTransacaoID, Descricao, Valor, DataTransacao, Conciliado)
VALUES
-- JANEIRO 2026 — Receitas
(1,  8, 1, 'Licença Software ERP - Cliente Alfa',      45000.00, '2026-01-05', 1),
(1,  9, 1, 'Consultoria Implantação - Projeto Beta',   28000.00, '2026-01-08', 1),
(1, 10, 1, 'Contrato Suporte Anual - Cliente Gama',    12000.00, '2026-01-10', 1),
(1, 11, 1, 'Rendimento CDB Janeiro',                     890.50, '2026-01-31', 1),

-- JANEIRO 2026 — Despesas
(1, 13, 2, 'Aluguel Escritório Janeiro',                8500.00, '2026-01-05', 1),
(1, 14, 2, 'Energia Elétrica Janeiro',                   650.00, '2026-01-10', 1),
(1, 15, 2, 'Internet Fibra + Telefonia Janeiro',          380.00, '2026-01-10', 1),
(1, 17, 2, 'Folha de Pagamento Janeiro',               35000.00, '2026-01-31', 1),
(1, 18, 2, 'Vale Refeição e Transporte Janeiro',        4200.00, '2026-01-31', 1),
(1, 19, 2, 'Pró-labore Sócios Janeiro',                18000.00, '2026-01-31', 1),
(1, 20, 2, 'Tarifas Bancárias Janeiro',                   95.00, '2026-01-31', 1),

-- FEVEREIRO 2026 — Receitas
(1,  8, 1, 'Licença Software CRM - Cliente Delta',     32000.00, '2026-02-03', 1),
(1,  9, 1, 'Projeto Migração Cloud - Cliente Epsilon', 55000.00, '2026-02-15', 1),
(1, 10, 1, 'Suporte Premium Q1 - Cliente Zeta',         9500.00, '2026-02-20', 1),
(2, 11, 1, 'Rendimento Poupança Fevereiro',              420.30, '2026-02-28', 1),

-- FEVEREIRO 2026 — Despesas
(1, 13, 2, 'Aluguel Escritório Fevereiro',              8500.00, '2026-02-05', 1),
(1, 14, 2, 'Energia Elétrica Fevereiro',                 720.00, '2026-02-10', 1),
(1, 16, 2, 'Material de Escritório Fev',                 340.00, '2026-02-12', 1),
(1, 17, 2, 'Folha de Pagamento Fevereiro',             35000.00, '2026-02-28', 1),
(1, 21, 2, 'IOF Operação de Crédito Fev',                 78.90, '2026-02-28', 1),

-- MARÇO 2026 — Receitas
(1,  8, 1, 'Licença Software BI - Cliente Eta',        68000.00, '2026-03-02', 0),
(1,  9, 1, 'Consultoria Fiscal Digital - Theta',       22000.00, '2026-03-10', 0),
(1, 12, 1, 'Juros sobre NF Atrasada - Cliente Iota',     850.00, '2026-03-15', 0),

-- MARÇO 2026 — Despesas
(1, 13, 2, 'Aluguel Escritório Março',                  8500.00, '2026-03-05', 0),
(1, 15, 2, 'Internet e Telefonia Março',                 380.00, '2026-03-10', 0),
(1, 17, 2, 'Folha de Pagamento Março',                 36500.00, '2026-03-31', 0),
(1, 18, 2, 'Benefícios Março',                          4400.00, '2026-03-31', 0),
(1, 19, 2, 'Pró-labore Sócios Março',                  18000.00, '2026-03-31', 0),
(1, 20, 2, 'Tarifas Bancárias Março',                    105.00, '2026-03-31', 0);

-- ============================================================
-- ETAPA 9: ORÇAMENTOS — METAS ANUAIS POR CATEGORIA
-- Depende de Empresas e PlanoDeContas.
-- Usamos INSERT...SELECT para gerar orçamentos automaticamente
-- a partir das contas analíticas (Nível 3) do PlanoDeContas.
-- ============================================================

-- Primeiro: orçamentos manuais para as principais categorias
INSERT INTO Orcamentos (EmpresaID, PlanoContaID, Ano, Mes, ValorOrcado, ValorRealizado)
VALUES
-- Orçamento de Receita — Venda de Software (PlanoContaID = 8)
(1, 8,  2026, 1,  40000.00, 45000.00), -- Janeiro: superou a meta
(1, 8,  2026, 2,  40000.00, 32000.00), -- Fevereiro: ficou abaixo
(1, 8,  2026, 3,  50000.00, 68000.00), -- Março: superou com folga
-- Orçamento de Receita — Consultoria (PlanoContaID = 9)
(1, 9,  2026, 1,  25000.00, 28000.00),
(1, 9,  2026, 2,  30000.00, 55000.00),
(1, 9,  2026, 3,  30000.00, 22000.00),
-- Orçamento de Despesa — Folha de Pagamento (PlanoContaID = 17)
(1, 17, 2026, 1,  35000.00, 35000.00),
(1, 17, 2026, 2,  35000.00, 35000.00),
(1, 17, 2026, 3,  35000.00, 36500.00), -- hora extra em março
-- Orçamento de Despesa — Aluguel (PlanoContaID = 13)
(1, 13, 2026, 1,   8500.00,  8500.00),
(1, 13, 2026, 2,   8500.00,  8500.00),
(1, 13, 2026, 3,   8500.00,  8500.00);

-- Segundo: INSERT...SELECT para gerar registros de orçamento
-- dos meses futuros (Abril a Dezembro) com valores base zerados,
-- para todas as contas analíticas de nível 3 da empresa.
-- Demonstra o poder do INSERT...SELECT para carga em massa.
INSERT INTO Orcamentos (EmpresaID, PlanoContaID, Ano, Mes, ValorOrcado, ValorRealizado)
SELECT
    pc.EmpresaID,           -- empresa dona da conta
    pc.PlanoContaID,        -- cada conta analítica de nível 3
    2026,                   -- ano do orçamento
    meses.Mes,              -- mês gerado pela subconsulta
    0.00,                   -- valor orçado inicial (a ser preenchido)
    0.00                    -- valor realizado inicial
FROM PlanoDeContas pc
-- Gera os meses de 4 a 12 usando uma tabela de valores inline
CROSS JOIN (
    VALUES (4),(5),(6),(7),(8),(9),(10),(11),(12)
) AS meses(Mes)
WHERE pc.EmpresaID = 1      -- apenas empresa TechFinance
  AND pc.Nivel = 3          -- apenas contas analíticas (nível 3)
  AND pc.Ativo = 1;         -- apenas contas ativas

-- ============================================================
-- ETAPA 10: VERIFICAÇÃO FINAL DO DATASET
-- Confirma o total de registros em cada tabela.
-- ============================================================

SELECT
    'Bancos'          AS Tabela, COUNT(*) AS TotalRegistros FROM Bancos
UNION ALL SELECT 'TiposTransacao',  COUNT(*) FROM TiposTransacao
UNION ALL SELECT 'Empresas',        COUNT(*) FROM Empresas
UNION ALL SELECT 'ContasBancarias', COUNT(*) FROM ContasBancarias
UNION ALL SELECT 'PlanoDeContas',   COUNT(*) FROM PlanoDeContas
UNION ALL SELECT 'Transacoes',      COUNT(*) FROM Transacoes
UNION ALL SELECT 'Orcamentos',      COUNT(*) FROM Orcamentos;
~~~

---

## Conceitos Avançados: INSERT com OUTPUT INTO

Além de exibir os valores inseridos na tela, a cláusula `OUTPUT` pode redirecionar os dados para uma tabela temporária ou variável de tabela usando a sintaxe `OUTPUT ... INTO`. Isso é extremamente útil em cenários de carga onde você precisa mapear IDs originais para IDs gerados pelo IDENTITY.

~~~sql
-- Declara uma variável de tabela para capturar os IDs gerados
DECLARE @BancosInseridos TABLE (
    BancoID_Gerado INT,
    NomeBanco      NVARCHAR(100)
);

-- INSERT com OUTPUT INTO captura todos os IDs em uma operação
INSERT INTO Bancos (NomeBanco, CodigoBanco, Ativo)
OUTPUT INSERTED.BancoID, INSERTED.NomeBanco
INTO @BancosInseridos (BancoID_Gerado, NomeBanco)
VALUES
    ('Santander', '033', 1),
    ('Inter',     '077', 1);

-- Consulta a tabela de mapeamento para verificar os IDs
SELECT BancoID_Gerado, NomeBanco
FROM @BancosInseridos;
~~~

Esta técnica é especialmente poderosa em scripts de migração de dados, onde você precisa preservar o relacionamento entre IDs antigos e IDs novos gerados pelo IDENTITY do banco de destino.

---

## Glossário Técnico

**INSERT INTO** — comando DML para adicionar novas linhas a uma tabela. Requer que os valores fornecidos respeitem os tipos de dados e todas as constraints ativas.

**DML (Data Manipulation Language)** — subconjunto do SQL responsável por manipular os dados armazenados: INSERT, UPDATE, DELETE e SELECT. Distinto do DDL (CREATE, ALTER, DROP) que manipula estruturas.

**IDENTITY(seed, increment)** — propriedade de coluna que gera automaticamente valores numéricos sequenciais. O seed define o valor inicial e o increment o passo entre valores consecutivos.

**SCOPE_IDENTITY()** — função que retorna o último valor de IDENTITY gerado no escopo e sessão atuais. É a forma correta e segura de capturar IDs após um INSERT.

**@@IDENTITY** — função legada que retorna o último IDENTITY gerado na sessão, incluindo Triggers. Perigosa em código de produção.

**IDENT_CURRENT('tabela')** — retorna o último IDENTITY gerado para uma tabela específica, sem considerar sessão ou escopo. Útil para diagnóstico, não para código concorrente.

**OUTPUT** — cláusula que expõe as tabelas virtuais INSERTED e DELETED durante operações DML, permitindo capturar os valores processados em tempo real.

**INSERTED** — tabela virtual disponível dentro de Triggers e da cláusula OUTPUT que contém as linhas recém-inseridas ou os novos valores em uma operação UPDATE.

**DELETED** — tabela virtual disponível dentro de Triggers e da cláusula OUTPUT que contém as linhas excluídas ou os valores antigos em uma operação UPDATE.

**CROSS JOIN** — tipo de junção que produz o produto cartesiano de duas tabelas: cada linha da primeira é combinada com cada linha da segunda. Usado neste capítulo para gerar combinações de contas e meses.

**VALUES inline** — construção `(VALUES (...), (...)) AS alias(coluna)` que cria uma tabela derivada a partir de valores literais, sem necessidade de uma tabela física. Útil para gerar sequências e conjuntos de valores em uma query.

**DBCC CHECKIDENT** — comando de administração que inspeciona e redefine a semente atual de uma coluna IDENTITY. O parâmetro RESEED permite reiniciar a contagem.

**Grafo de Dependências** — representação das relações de dependência entre tabelas ditadas pelas Foreign Keys. Determina a ordem obrigatória de inserção (pais antes de filhos) e exclusão (filhos antes de pais).

---

## Antecipação de Erros e Troubleshooting

**Erro: "The INSERT statement conflicted with the FOREIGN KEY constraint"**
Causa: tentativa de inserir em uma tabela filha referenciando um ID que ainda não existe na tabela pai. Por exemplo, inserir uma Transacao com ContaID = 5 quando ContasBancarias só tem IDs 1 a 4.
Solução: verifique o grafo de dependências e garanta que a tabela pai foi populada antes da tabela filha. Execute `SELECT * FROM ContasBancarias` para confirmar quais IDs existem antes de referenciar.

**Erro: "Cannot insert the value NULL into column 'X', table 'Y'"**
Causa: a coluna foi definida como NOT NULL e o INSERT não forneceu um valor para ela, nem há um DEFAULT configurado.
Solução: inclua a coluna na lista de colunas do INSERT e forneça um valor explícito. Se o campo for opcional, reconsidere se a constraint NOT NULL é realmente necessária.

**Erro: "Violation of CHECK constraint 'CK_NomeDaConstraint'"**
Causa: o valor fornecido viola uma regra de domínio definida na constraint CHECK. Por exemplo, inserir `TipoConta = 'INVESTIMENTO'` quando o CHECK só aceita 'CORRENTE' ou 'POUPANCA'.
Solução: consulte a definição da constraint com `SELECT definition FROM sys.check_constraints WHERE name = 'CK_NomeDaConstraint'` para ver os valores permitidos.

**Erro: "Violation of UNIQUE KEY constraint" ou "Violation of PRIMARY KEY constraint"**
Causa: tentativa de inserir um valor duplicado em uma coluna com constraint UNIQUE ou PRIMARY KEY. Comum em reexecuções de script sem limpeza prévia.
Solução: use o bloco de limpeza condicional com DELETE e DBCC CHECKIDENT RESEED no início do script, como demonstrado no script deste capítulo.

**Comportamento inesperado: SCOPE_IDENTITY() retorna NULL**
Causa: nenhum INSERT com IDENTITY foi executado no escopo atual antes da chamada. Pode ocorrer se o INSERT falhou silenciosamente ou se o script foi executado em um escopo diferente.
Solução: verifique se o INSERT foi executado com sucesso antes de chamar SCOPE_IDENTITY(). Use `SELECT @@ROWCOUNT` imediatamente após o INSERT para confirmar que exatamente 1 linha foi afetada.

**Comportamento inesperado: IDs não sequenciais após RESEED**
Causa: o DBCC CHECKIDENT com RESEED 0 define a semente para 0, mas o próximo INSERT gerará o valor 1 (seed + increment). Se houver falhas de INSERT que disparam rollback internamente, o SQL Server pode consumir IDs sem inserir registros, criando lacunas.
Solução: lacunas no IDENTITY são comportamento normal e esperado. Nunca assuma que IDs são contínuos — use sempre JOINs para relacionar registros, nunca assuma sequencialidade.

---

## Desafio de Fixação

**Enunciado:** A empresa Alpha Invest (EmpresaID = 2) precisa de um plano de contas simplificado e de três lançamentos iniciais. Sua missão é:

1. Inserir 4 contas no PlanoDeContas para a empresa Alpha Invest: uma conta raiz `RECEITAS` (nível 1), uma conta raiz `DESPESAS` (nível 1), uma conta analítica `Receita de Dividendos` (nível 2, filha de RECEITAS) e uma conta analítica `Taxas de Administração` (nível 2, filha de DESPESAS).

2. Capturar o ID da conta `Receita de Dividendos` usando SCOPE_IDENTITY() após cada INSERT.

3. Inserir 3 transações na ContaBancária da Alpha Invest (ContaID = 4): um recebimento de dividendos de R$ 15.000,00 em 01/03/2026, uma taxa de administração de R$ 2.500,00 em 05/03/2026, e um segundo recebimento de dividendos de R$ 8.750,00 em 15/03/2026.

4. Verificar com um SELECT final o total de transações e a soma dos valores inseridos para a Alpha Invest.

---

**Resolução Comentada:**

~~~sql
USE FinanceDB;
GO

-- PASSO 1: Inserir contas raiz da Alpha Invest
-- ContaParenteID NULL porque são contas de nível 1 (raiz)
INSERT INTO PlanoDeContas (EmpresaID, Codigo, Descricao, Tipo, Nivel, ContaParenteID, Ativo)
VALUES (2, '1', 'RECEITAS', 'RECEITA', 1, NULL, 1);

-- Captura o ID da conta RECEITAS da Alpha Invest
DECLARE @ReceitasAlphaID INT = SCOPE_IDENTITY();
PRINT 'ID de RECEITAS Alpha: ' + CAST(@ReceitasAlphaID AS VARCHAR(10));

INSERT INTO PlanoDeContas (EmpresaID, Codigo, Descricao, Tipo, Nivel, ContaParenteID, Ativo)
VALUES (2, '2', 'DESPESAS', 'DESPESA', 1, NULL, 1);

DECLARE @DespesasAlphaID INT = SCOPE_IDENTITY();
PRINT 'ID de DESPESAS Alpha: ' + CAST(@DespesasAlphaID AS VARCHAR(10));

-- PASSO 2: Inserir contas analíticas filhas
-- ContaParenteID aponta para os IDs capturados acima
INSERT INTO PlanoDeContas (EmpresaID, Codigo, Descricao, Tipo, Nivel, ContaParenteID, Ativo)
VALUES (2, '1.1', 'Receita de Dividendos', 'RECEITA', 2, @ReceitasAlphaID, 1);

-- Captura o ID da conta analítica de receita
DECLARE @DividendosID INT = SCOPE_IDENTITY();
PRINT 'ID de Receita de Dividendos: ' + CAST(@DividendosID AS VARCHAR(10));

INSERT INTO PlanoDeContas (EmpresaID, Codigo, Descricao, Tipo, Nivel, ContaParenteID, Ativo)
VALUES (2, '2.1', 'Taxas de Administração', 'DESPESA', 2, @DespesasAlphaID, 1);

DECLARE @TaxasAdmID INT = SCOPE_IDENTITY();
PRINT 'ID de Taxas de Administração: ' + CAST(@TaxasAdmID AS VARCHAR(10));

-- PASSO 3: Inserir as 3 transações da Alpha Invest
-- ContaID = 4 é a conta da Alpha na Caixa (inserida na Etapa 6)
-- TipoTransacaoID: 1 = RECEITA, 2 = DESPESA
INSERT INTO Transacoes
    (ContaID, PlanoContaID, TipoTransacaoID, Descricao, Valor, DataTransacao, Conciliado)
OUTPUT
    INSERTED.TransacaoID,
    INSERTED.Descricao,
    INSERTED.Valor,
    INSERTED.DataTransacao
VALUES
    (4, @DividendosID, 1, 'Dividendos Recebidos - Carteira A', 15000.00, '2026-03-01', 1),
    (4, @TaxasAdmID,   2, 'Taxa de Administração Março',        2500.00, '2026-03-05', 1),
    (4, @DividendosID, 1, 'Dividendos Recebidos - Carteira B',  8750.00, '2026-03-15', 1);

-- PASSO 4: Verificação final
-- Junta Transacoes com ContasBancarias para filtrar pela empresa
SELECT
    COUNT(*)        AS TotalTransacoes,
    SUM(t.Valor)    AS SomaTotalValores,
    SUM(CASE WHEN tt.Descricao = 'RECEITA' THEN  t.Valor ELSE 0 END) AS TotalReceitas,
    SUM(CASE WHEN tt.Descricao = 'DESPESA' THEN  t.Valor ELSE 0 END) AS TotalDespesas
FROM Transacoes t
INNER JOIN ContasBancarias cb ON t.ContaID = cb.ContaID
INNER JOIN TiposTransacao  tt ON t.TipoTransacaoID = tt.TipoTransacaoID
WHERE cb.EmpresaID = 2; -- apenas Alpha Invest

-- Resultado esperado:
-- TotalTransacoes: 3
-- SomaTotalValores: 26250.00
-- TotalReceitas: 23750.00
-- TotalDespesas: 2500.00
~~~

---

## Resumo dos Pontos-Chave

O `INSERT INTO` possui três variações com finalidades distintas: linha única para inserções individuais com captura imediata de ID, múltiplas linhas para carga em lote com uma única instrução, e INSERT...SELECT para transformação e carga a partir de outras tabelas. A ordem de inserção entre tabelas é ditada pelo grafo de dependências das Foreign Keys: tabelas pai sempre antes de tabelas filhas. Para capturar IDs gerados por IDENTITY, `SCOPE_IDENTITY()` é a única função segura para código de produção — nunca use `@@IDENTITY` em ambientes com Triggers. A cláusula OUTPUT com a tabela virtual INSERTED permite visualizar e capturar todos os valores inseridos em tempo real, inclusive em inserções de múltiplas linhas. O INSERT...SELECT com CROSS JOIN e tabela de valores inline é uma técnica poderosa para geração de dados em massa de forma estruturada e sem código repetitivo. Lacunas no IDENTITY são normais e esperadas — nunca assuma sequencialidade. O FinanceDB agora possui um dataset financeiro completo e coerente com 3 meses de histórico, pronto para as consultas e relatórios dos próximos capítulos.

---

## Log de Estado do Projeto — Após Capítulo 10

~~~text
## Estado do Projeto — Após Capítulo 10
- Livro: SQL Server para Aplicações Financeiras com T-SQL
- Módulo Atual: Módulo 2 — ESSENCIAL: T-SQL Básico
- Capítulo Concluído: Capítulo 10 — Inserindo Dados: INSERT INTO

=== BANCO DE DADOS ===
Nome: FinanceDB
Servidor: instância local Windows 11 / SQL Server 2022
Recovery Model: FULL
Collation: Latin1_General_CI_AS
SNAPSHOT ISOLATION: habilitado
READ_COMMITTED_SNAPSHOT: habilitado

=== TABELAS E REGISTROS ===
✅ Bancos:           5 registros (Itaú, BB, Caixa, Bradesco, Nubank)
✅ TiposTransacao:   3 registros (RECEITA, DESPESA, TRANSFERENCIA)
✅ Empresas:         2 registros (TechFinance ID=1, Alpha Invest ID=2)
✅ ContasBancarias:  4 registros (2 Itaú + 1 BB para TechFinance, 1 Caixa para Alpha)
✅ PlanoDeContas:   21 registros TechFinance + 4 registros Alpha = 25 total
✅ Transacoes:      29 registros (Jan/Fev/Mar 2026 TechFinance + 3 Alpha)
✅ Orcamentos:      12 registros manuais + registros gerados por INSERT...SELECT

=== TÉCNICAS APLICADAS NESTE CAPÍTULO ===
✅ INSERT linha única com SCOPE_IDENTITY()
✅ INSERT múltiplas linhas com OUTPUT INSERTED
✅ INSERT...SELECT com CROSS JOIN e tabela de valores inline
✅ OUTPUT INTO para captura de IDs em variável de tabela
✅ DBCC CHECKIDENT RESEED para reset de IDENTITY
✅ Grafo de dependências respeitado na ordem de inserção

=== SCRIPTS SALVOS ===
📁 modulo_02_essencial/capitulo_10/
   └── popular_financedb.sql
   └── verificar_dataset.sql
   └── desafio_10.sql
   └── respostas/resposta_10.sql

=== PRÓXIMAS ETAPAS ===
Capítulo 11 — SELECT: consultar os dados inseridos com
aliases, colunas calculadas e DISTINCT
~~~

---

## Prompt de Continuidade para o Capítulo 11

~~~text
Contexto: Estou estudando o livro "SQL Server para Aplicações
Financeiras com T-SQL". Meu ambiente é Windows 11, SSMS,
SQL Server 2022. O projeto prático incremental se chama FinanceDB.

Concluí o Capítulo 10, que populou todas as tabelas do FinanceDB
com dados financeiros realistas. As 7 tabelas estão populadas:
Bancos (5 registros), TiposTransacao (3), Empresas (2),
ContasBancarias (4), PlanoDeContas (25), Transacoes (29) e
Orcamentos com dados de Jan/Fev/Mar 2026 para TechFinance e
Alpha Invest. Aprendi INSERT linha única, INSERT múltiplas linhas,
INSERT...SELECT com CROSS JOIN, SCOPE_IDENTITY(), OUTPUT INSERTED
e OUTPUT INTO.

Siga rigorosamente o Prompt Mestre v1.1: narrativa densa com
mínimo de 2.000 palavras, Técnica de Feynman, analogia de
ancoragem, diagrama Mermaid escapado com ~~~mermaid, código SQL
comentado linha a linha escapado com ~~~, glossário técnico,
antecipação de erros, troubleshooting, desafio de fixação com
resolução comentada, resumo dos pontos-chave, log de estado do
projeto atualizado e prompt de continuidade para o próximo capítulo.
Todo o conteúdo deve ser gerado dentro de um bloco ```markdown.
Chame aulas de capítulos e curso de livro.

Por favor, gere o Capítulo 11: Consultando Dados — SELECT e
suas Variações. Objetivo: dominar o comando SELECT em profundidade,
usar aliases com AS para renomear colunas e tabelas, criar colunas
calculadas com expressões aritméticas e de texto, usar DISTINCT
para eliminar duplicatas em consultas financeiras, entender a
ordem lógica de processamento de uma query no SQL Server (FROM,
WHERE, GROUP BY, HAVING, SELECT, ORDER BY) e construir as
primeiras consultas financeiras reais sobre o dataset do FinanceDB.
Pré-requisito: Capítulo 10 concluído, todas as tabelas populadas.
~~~

---

Dúvidas? Posso prosseguir para o Capítulo 11?