-- ============================================================
-- FinanceDB — Script Completo de Reset e Carga de Dados
-- Zera todas as tabelas, reseta identidades e repopula
-- Validado contra dicdad.txt v1.0
-- SQL Server 2022
-- ============================================================

USE [FinanceDB];
GO

-- ============================================================
-- BLOCO 1: LIMPEZA COMPLETA NA ORDEM CORRETA (respeita FKs)
-- ============================================================

-- Desabilita constraints temporariamente para limpeza segura
EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';
GO

-- Limpa todas as tabelas na ordem correta (filhos antes dos pais)
DELETE FROM [dbo].[Transacoes];
DELETE FROM [dbo].[Orcamentos];
DELETE FROM [dbo].[PlanoDeContas];
DELETE FROM [dbo].[ContasBancarias];
DELETE FROM [dbo].[TiposTransacao];
DELETE FROM [dbo].[Empresas];
DELETE FROM [dbo].[Bancos];
GO

-- Reabilita todas as constraints
EXEC sp_MSforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL';
GO

-- ============================================================
-- BLOCO 2: RESET DAS IDENTIDADES (todos os IDs começam em 1)
-- ============================================================

DBCC CHECKIDENT ('dbo.Transacoes',    RESEED, 0);
DBCC CHECKIDENT ('dbo.Orcamentos',    RESEED, 0);
DBCC CHECKIDENT ('dbo.PlanoDeContas', RESEED, 0);
DBCC CHECKIDENT ('dbo.ContasBancarias', RESEED, 0);
DBCC CHECKIDENT ('dbo.TiposTransacao',  RESEED, 0);
DBCC CHECKIDENT ('dbo.Empresas',      RESEED, 0);
DBCC CHECKIDENT ('dbo.Bancos',        RESEED, 0);
GO

-- ============================================================
-- BLOCO 3: BANCOS (6 registros)
-- BancoID 1 a 6
-- ============================================================

INSERT INTO [dbo].[Bancos]
    (CodigoCOMPE, NomeBanco, Sigla, Ativo)
VALUES
    (341, 'Itaú Unibanco S.A.',              'ITAU',      1),
    (1,   'Banco do Brasil S.A.',             'BB',        1),
    (104, 'Caixa Econômica Federal',          'CEF',       1),
    (237, 'Banco Bradesco S.A.',              'BRADESCO',  1),
    (33,  'Banco Santander (Brasil) S.A.',    'SANTANDER', 1),
    (260, 'Nu Pagamentos S.A. (Nubank)',      'NUBANK',    1);
GO

-- Verificação
SELECT 'Bancos inseridos:' AS Etapa, COUNT(*) AS Total FROM [dbo].[Bancos];
GO

-- ============================================================
-- BLOCO 4: TIPOS DE TRANSAÇÃO (3 registros)
-- TipoTransacaoID 1 a 3
-- ============================================================

INSERT INTO [dbo].[TiposTransacao]
    (Codigo, Descricao, Natureza, Ativo)
VALUES
    ('RECEITA', 'Receita Financeira',          'C', 1),
    ('DESPESA', 'Despesa Financeira',           'D', 1),
    ('TRANSF',  'Transferência entre Contas',   'D', 1);
GO

SELECT 'TiposTransacao inseridos:' AS Etapa, COUNT(*) AS Total FROM [dbo].[TiposTransacao];
GO

-- ============================================================
-- BLOCO 5: EMPRESAS (3 registros)
-- EmpresaID 1 a 3
-- ============================================================

INSERT INTO [dbo].[Empresas]
    (CNPJ, RazaoSocial, NomeFantasia, Telefone, Email, Ativo, Observacao)
VALUES
    ('12345678000195',
     'Tech Solutions Ltda.',
     'TechSol',
     '(11) 3000-1000',
     'financeiro@techsol.com.br',
     1,
     'Empresa principal do grupo — tecnologia e software'),

    ('98765432000188',
     'Comercial Bianeck S.A.',
     'Bianeck Comercial',
     '(11) 3000-2000',
     'financeiro@bianeck.com.br',
     1,
     'Empresa de comércio varejista do grupo'),

    ('11223344000177',
     'Holding FinGroup Participações Ltda.',
     'FinGroup',
     '(11) 3000-3000',
     'holding@fingroup.com.br',
     1,
     'Empresa holding — participações societárias');
GO

SELECT 'Empresas inseridas:' AS Etapa, COUNT(*) AS Total FROM [dbo].[Empresas];
GO

-- ============================================================
-- BLOCO 6: CONTAS BANCÁRIAS (7 registros)
-- ContaID 1 a 7
-- ============================================================

-- EmpresaID 1 (TechSol): 3 contas
-- EmpresaID 2 (Bianeck Comercial): 3 contas
-- EmpresaID 3 (FinGroup): 1 conta

INSERT INTO [dbo].[ContasBancarias]
    (EmpresaID, BancoID, Agencia, NumeroConta, TipoConta, SaldoInicial, Ativa)
VALUES
    -- TechSol
    (1, 1, '0001',   '12345-6',   'Corrente',    50000.00, 1),  -- ContaID 1: Itaú
    (1, 2, '1234',   '56789-0',   'Corrente',    30000.00, 1),  -- ContaID 2: BB
    (1, 5, '0042',   '98765-4',   'Investimento', 100000.00, 1), -- ContaID 3: Santander

    -- Bianeck Comercial
    (2, 4, '0500',   '11111-2',   'Corrente',    25000.00, 1),  -- ContaID 4: Bradesco
    (2, 1, '0002',   '22222-3',   'Poupança',    15000.00, 1),  -- ContaID 5: Itaú
    (2, 6, '0001',   '33333-4',   'Corrente',    10000.00, 1),  -- ContaID 6: Nubank

    -- FinGroup Holding
    (3, 3, '0010',   '44444-5',   'Corrente',    200000.00, 1); -- ContaID 7: CEF
GO

SELECT 'ContasBancarias inseridas:' AS Etapa, COUNT(*) AS Total FROM [dbo].[ContasBancarias];
GO

-- ============================================================
-- BLOCO 7: PLANO DE CONTAS (20 registros)
-- Estrutura hierárquica em 3 níveis por empresa
-- EmpresaID 1 (TechSol): ContaPlanoID 1-10
-- EmpresaID 2 (Bianeck): ContaPlanoID 11-20
-- ============================================================

-- -----------------------------------------------------------------
-- EMPRESA 1 — TechSol
-- -----------------------------------------------------------------

-- NÍVEL 1: Grupos raiz (ContaPaiID = NULL, AceitaLancamentos = 0)
INSERT INTO [dbo].[PlanoDeContas]
    (EmpresaID, ContaPaiID, Codigo, Descricao, Tipo, Nivel, AceitaLancamentos, Ativa)
VALUES
    (1, NULL, '1',   'RECEITAS',               'RECEITA', 1, 0, 1),  -- ID 1
    (1, NULL, '2',   'DESPESAS',               'DESPESA', 1, 0, 1);  -- ID 2

-- NÍVEL 2: Subgrupos (ContaPaiID aponta para nível 1)
INSERT INTO [dbo].[PlanoDeContas]
    (EmpresaID, ContaPaiID, Codigo, Descricao, Tipo, Nivel, AceitaLancamentos, Ativa)
VALUES
    (1, 1, '1.1', 'Receitas de Serviços',      'RECEITA', 2, 0, 1), -- ID 3
    (1, 1, '1.2', 'Receitas Financeiras',       'RECEITA', 2, 0, 1), -- ID 4
    (1, 2, '2.1', 'Despesas Operacionais',      'DESPESA', 2, 0, 1), -- ID 5
    (1, 2, '2.2', 'Despesas Administrativas',   'DESPESA', 2, 0, 1); -- ID 6

-- NÍVEL 3: Contas analíticas (AceitaLancamentos = 1)
INSERT INTO [dbo].[PlanoDeContas]
    (EmpresaID, ContaPaiID, Codigo, Descricao, Tipo, Nivel, AceitaLancamentos, Ativa)
VALUES
    (1, 3, '1.1.01', 'Receita de Consultoria',     'RECEITA', 3, 1, 1), -- ID 7
    (1, 3, '1.1.02', 'Receita de Desenvolvimento', 'RECEITA', 3, 1, 1), -- ID 8
    (1, 4, '1.2.01', 'Rendimentos de Aplicação',   'RECEITA', 3, 1, 1), -- ID 9
    (1, 5, '2.1.01', 'Salários e Encargos',        'DESPESA', 3, 1, 1), -- ID 10
    (1, 5, '2.1.02', 'Infraestrutura Cloud',        'DESPESA', 3, 1, 1), -- ID 11
    (1, 6, '2.2.01', 'Aluguel de Escritório',      'DESPESA', 3, 1, 1), -- ID 12
    (1, 6, '2.2.02', 'Energia Elétrica',            'DESPESA', 3, 1, 1), -- ID 13
    (1, 6, '2.2.03', 'Licenças de Software',       'DESPESA', 3, 1, 1); -- ID 14

-- -----------------------------------------------------------------
-- EMPRESA 2 — Bianeck Comercial
-- -----------------------------------------------------------------

-- NÍVEL 1
INSERT INTO [dbo].[PlanoDeContas]
    (EmpresaID, ContaPaiID, Codigo, Descricao, Tipo, Nivel, AceitaLancamentos, Ativa)
VALUES
    (2, NULL, '1',   'RECEITAS',   'RECEITA', 1, 0, 1), -- ID 15
    (2, NULL, '2',   'DESPESAS',   'DESPESA', 1, 0, 1); -- ID 16

-- NÍVEL 2
INSERT INTO [dbo].[PlanoDeContas]
    (EmpresaID, ContaPaiID, Codigo, Descricao, Tipo, Nivel, AceitaLancamentos, Ativa)
VALUES
    (2, 15, '1.1', 'Receitas de Vendas',        'RECEITA', 2, 0, 1), -- ID 17
    (2, 16, '2.1', 'Custo das Mercadorias',     'DESPESA', 2, 0, 1), -- ID 18
    (2, 16, '2.2', 'Despesas Comerciais',       'DESPESA', 2, 0, 1); -- ID 19

-- NÍVEL 3
INSERT INTO [dbo].[PlanoDeContas]
    (EmpresaID, ContaPaiID, Codigo, Descricao, Tipo, Nivel, AceitaLancamentos, Ativa)
VALUES
    (2, 17, '1.1.01', 'Venda de Produtos',       'RECEITA', 3, 1, 1), -- ID 20
    (2, 17, '1.1.02', 'Venda de Mercadorias',    'RECEITA', 3, 1, 1), -- ID 21
    (2, 18, '2.1.01', 'Compra de Mercadorias',   'DESPESA', 3, 1, 1), -- ID 22
    (2, 19, '2.2.01', 'Comissões de Vendas',     'DESPESA', 3, 1, 1), -- ID 23
    (2, 19, '2.2.02', 'Frete e Logística',       'DESPESA', 3, 1, 1); -- ID 24
GO

SELECT 'PlanoDeContas inserido:' AS Etapa, COUNT(*) AS Total FROM [dbo].[PlanoDeContas];
GO

-- ============================================================
-- BLOCO 8: ORÇAMENTOS (24 registros)
-- Empresa 1: 6 contas analíticas × 3 meses (Jan-Mar/2026) = 18
-- Empresa 2: 5 contas analíticas × 3 meses               =  6 (resumido)
-- ============================================================

INSERT INTO [dbo].[Orcamentos]
    (EmpresaID, ContaPlanoID, Ano, Mes, ValorOrcado, ValorRealizado)
VALUES
-- -------------------------------------------------------
-- EMPRESA 1 (TechSol) — Janeiro 2026
-- -------------------------------------------------------
    (1,  7, 2026, 1,  45000.00, 0.00),  -- Consultoria
    (1,  8, 2026, 1,  30000.00, 0.00),  -- Desenvolvimento
    (1,  9, 2026, 1,   2000.00, 0.00),  -- Rendimentos
    (1, 10, 2026, 1,  35000.00, 0.00),  -- Salários
    (1, 11, 2026, 1,   8000.00, 0.00),  -- Cloud
    (1, 12, 2026, 1,   3500.00, 0.00),  -- Aluguel
    (1, 13, 2026, 1,   1200.00, 0.00),  -- Energia
    (1, 14, 2026, 1,   3000.00, 0.00),  -- Licenças
-- -------------------------------------------------------
-- EMPRESA 1 (TechSol) — Fevereiro 2026
-- -------------------------------------------------------
    (1,  7, 2026, 2,  50000.00, 0.00),
    (1,  8, 2026, 2,  32000.00, 0.00),
    (1,  9, 2026, 2,   2000.00, 0.00),
    (1, 10, 2026, 2,  35000.00, 0.00),
    (1, 11, 2026, 2,   8500.00, 0.00),
    (1, 12, 2026, 2,   3500.00, 0.00),
    (1, 13, 2026, 2,   1200.00, 0.00),
    (1, 14, 2026, 2,   3500.00, 0.00),
-- -------------------------------------------------------
-- EMPRESA 1 (TechSol) — Março 2026
-- -------------------------------------------------------
    (1,  7, 2026, 3,  55000.00, 0.00),
    (1,  8, 2026, 3,  35000.00, 0.00),
    (1,  9, 2026, 3,   2500.00, 0.00),
    (1, 10, 2026, 3,  36000.00, 0.00),
    (1, 11, 2026, 3,   9000.00, 0.00),
    (1, 12, 2026, 3,   3500.00, 0.00),
    (1, 13, 2026, 3,   1200.00, 0.00),
    (1, 14, 2026, 3,   3500.00, 0.00),
-- -------------------------------------------------------
-- EMPRESA 2 (Bianeck Comercial) — Janeiro a Março 2026
-- -------------------------------------------------------
    (2, 20, 2026, 1,  80000.00, 0.00),  -- Venda Produtos Jan
    (2, 21, 2026, 1,  40000.00, 0.00),  -- Venda Mercadorias Jan
    (2, 22, 2026, 1,  50000.00, 0.00),  -- Compra Mercadorias Jan
    (2, 23, 2026, 1,   6000.00, 0.00),  -- Comissões Jan
    (2, 24, 2026, 1,   4000.00, 0.00),  -- Frete Jan
    (2, 20, 2026, 2,  85000.00, 0.00),
    (2, 21, 2026, 2,  42000.00, 0.00),
    (2, 22, 2026, 2,  53000.00, 0.00),
    (2, 23, 2026, 2,   6500.00, 0.00),
    (2, 24, 2026, 2,   4200.00, 0.00),
    (2, 20, 2026, 3,  90000.00, 0.00),
    (2, 21, 2026, 3,  45000.00, 0.00),
    (2, 22, 2026, 3,  56000.00, 0.00),
    (2, 23, 2026, 3,   7000.00, 0.00),
    (2, 24, 2026, 3,   4500.00, 0.00);
GO

SELECT 'Orcamentos inseridos:' AS Etapa, COUNT(*) AS Total FROM [dbo].[Orcamentos];
GO

-- ============================================================
-- BLOCO 9: TRANSAÇÕES (60 registros)
-- Empresa 1 (TechSol):       40 lançamentos (Jan-Mar 2026)
-- Empresa 2 (Bianeck):       20 lançamentos (Jan-Mar 2026)
-- TipoTransacaoID: 1=RECEITA, 2=DESPESA, 3=TRANSF
-- Status: Conciliado / Pendente / Cancelado
-- ============================================================

-- -------------------------------------------------------
-- EMPRESA 1 — JANEIRO 2026
-- ContaID: 1 (Itaú Corrente), 2 (BB Corrente), 3 (Santander Invest.)
-- -------------------------------------------------------
INSERT INTO [dbo].[Transacoes]
    (EmpresaID, ContaID, ContaPlanoID, TipoTransacaoID,
     DataLancamento, DataCompetencia, Valor,
     Descricao, NumeroDocumento, Status)
VALUES
-- Receitas de Consultoria (PlanoID 7)
    (1, 1,  7, 1, '2026-01-05', '2026-01-05', 12000.00,
     'Consultoria estratégica — Cliente Alpha',      'NF-001', 'Conciliado'),
    (1, 1,  7, 1, '2026-01-12', '2026-01-12', 18000.00,
     'Consultoria técnica — Cliente Beta',           'NF-002', 'Conciliado'),
    (1, 2,  7, 1, '2026-01-20', '2026-01-20', 15000.00,
     'Consultoria de processos — Cliente Gamma',     'NF-003', 'Conciliado'),

-- Receitas de Desenvolvimento (PlanoID 8)
    (1, 1,  8, 1, '2026-01-08', '2026-01-08', 22000.00,
     'Desenvolvimento sistema ERP — Fase 1',        'NF-004', 'Conciliado'),
    (1, 2,  8, 1, '2026-01-25', '2026-01-25',  8500.00,
     'Manutenção evolutiva — Portal Web',           'NF-005', 'Conciliado'),

-- Rendimentos de Aplicação (PlanoID 9)
    (1, 3,  9, 1, '2026-01-31', '2026-01-31',  1850.00,
     'Rendimento CDB Santander — Janeiro',          'RND-001', 'Conciliado'),

-- Despesas: Salários (PlanoID 10)
    (1, 1, 10, 2, '2026-01-05', '2026-01-05', 32000.00,
     'Folha de pagamento — Janeiro 2026',           'FP-JAN26', 'Conciliado'),
    (1, 1, 10, 2, '2026-01-05', '2026-01-05',  4800.00,
     'FGTS — Janeiro 2026',                         'FGTS-JAN26', 'Conciliado'),

-- Despesas: Cloud (PlanoID 11)
    (1, 2, 11, 2, '2026-01-10', '2026-01-10',  7200.00,
     'AWS — infraestrutura cloud Janeiro',          'AWS-JAN26', 'Conciliado'),

-- Despesas: Aluguel (PlanoID 12)
    (1, 1, 12, 2, '2026-01-05', '2026-01-05',  3500.00,
     'Aluguel escritório Paulista — Janeiro',       'ALG-JAN26', 'Conciliado'),

-- Despesas: Energia (PlanoID 13)
    (1, 1, 13, 2, '2026-01-15', '2026-01-15',   980.00,
     'Energia elétrica — Janeiro 2026',            'CELSP-JAN26', 'Conciliado'),

-- Despesas: Licenças (PlanoID 14)
    (1, 2, 14, 2, '2026-01-20', '2026-01-20',  2800.00,
     'Licenças Microsoft 365 — Janeiro',           'MS-JAN26', 'Conciliado'),

-- -------------------------------------------------------
-- EMPRESA 1 — FEVEREIRO 2026
-- -------------------------------------------------------
-- Receitas de Consultoria (PlanoID 7)
    (1, 1,  7, 1, '2026-02-03', '2026-02-03', 20000.00,
     'Consultoria estratégica — Cliente Delta',     'NF-006', 'Conciliado'),
    (1, 2,  7, 1, '2026-02-14', '2026-02-14', 16500.00,
     'Consultoria de TI — Cliente Epsilon',         'NF-007', 'Conciliado'),

-- Receitas de Desenvolvimento (PlanoID 8)
    (1, 1,  8, 1, '2026-02-10', '2026-02-10', 28000.00,
     'Desenvolvimento App Mobile — Entrega parcial','NF-008', 'Conciliado'),
    (1, 2,  8, 1, '2026-02-20', '2026-02-20',  5000.00,
     'Suporte técnico mensal — Contratos',          'NF-009', 'Conciliado'),

-- Rendimentos (PlanoID 9)
    (1, 3,  9, 1, '2026-02-28', '2026-02-28',  1920.00,
     'Rendimento CDB Santander — Fevereiro',        'RND-002', 'Conciliado'),

-- Salários (PlanoID 10)
    (1, 1, 10, 2, '2026-02-05', '2026-02-05', 33000.00,
     'Folha de pagamento — Fevereiro 2026',         'FP-FEV26', 'Conciliado'),
    (1, 1, 10, 2, '2026-02-05', '2026-02-05',  4950.00,
     'FGTS — Fevereiro 2026',                       'FGTS-FEV26', 'Conciliado'),

-- Cloud (PlanoID 11)
    (1, 2, 11, 2, '2026-02-10', '2026-02-10',  8100.00,
     'AWS — infraestrutura cloud Fevereiro',        'AWS-FEV26', 'Conciliado'),

-- Aluguel (PlanoID 12)
    (1, 1, 12, 2, '2026-02-05', '2026-02-05',  3500.00,
     'Aluguel escritório Paulista — Fevereiro',     'ALG-FEV26', 'Conciliado'),

-- Energia (PlanoID 13)
    (1, 1, 13, 2, '2026-02-15', '2026-02-15',  1050.00,
     'Energia elétrica — Fevereiro 2026',           'CELSP-FEV26', 'Conciliado'),

-- Licenças (PlanoID 14)
    (1, 2, 14, 2, '2026-02-20', '2026-02-20',  3200.00,
     'Licenças Adobe Creative Cloud — Fevereiro',   'ADO-FEV26', 'Conciliado'),

-- -------------------------------------------------------
-- EMPRESA 1 — MARÇO 2026
-- -------------------------------------------------------
-- Receitas de Consultoria (PlanoID 7)
    (1, 1,  7, 1, '2026-03-04', '2026-03-04', 25000.00,
     'Consultoria financeira — Cliente Zeta',       'NF-010', 'Conciliado'),
    (1, 2,  7, 1, '2026-03-18', '2026-03-18', 19000.00,
     'Consultoria de segurança — Cliente Eta',      'NF-011', 'Conciliado'),
    (1, 1,  7, 1, '2026-03-28', '2026-03-28',  8000.00,
     'Consultoria ágil — Sprint Review',            'NF-012', 'Pendente'),

-- Receitas de Desenvolvimento (PlanoID 8)
    (1, 1,  8, 1, '2026-03-10', '2026-03-10', 35000.00,
     'Desenvolvimento sistema ERP — Fase 2',        'NF-013', 'Conciliado'),
    (1, 2,  8, 1, '2026-03-25', '2026-03-25',  4500.00,
     'Suporte e manutenção — Março',                'NF-014', 'Pendente'),

-- Rendimentos (PlanoID 9)
    (1, 3,  9, 1, '2026-03-31', '2026-03-31',  2100.00,
     'Rendimento CDB Santander — Março',            'RND-003', 'Conciliado'),

-- Salários (PlanoID 10)
    (1, 1, 10, 2, '2026-03-05', '2026-03-05', 34000.00,
     'Folha de pagamento — Março 2026',             'FP-MAR26', 'Conciliado'),
    (1, 1, 10, 2, '2026-03-05', '2026-03-05',  5100.00,
     'FGTS — Março 2026',                           'FGTS-MAR26', 'Conciliado'),

-- Cloud (PlanoID 11)
    (1, 2, 11, 2, '2026-03-10', '2026-03-10',  9200.00,
     'AWS — infraestrutura cloud Março',            'AWS-MAR26', 'Conciliado'),

-- Aluguel (PlanoID 12)
    (1, 1, 12, 2, '2026-03-05', '2026-03-05',  3500.00,
     'Aluguel escritório Paulista — Março',         'ALG-MAR26', 'Conciliado'),

-- Energia (PlanoID 13)
    (1, 1, 13, 2, '2026-03-15', '2026-03-15',  1180.00,
     'Energia elétrica — Março 2026',               'CELSP-MAR26', 'Conciliado'),

-- Licenças (PlanoID 14)
    (1, 2, 14, 2, '2026-03-20', '2026-03-20',  3500.00,
     'Licenças Microsoft + Adobe — Março',          'LIC-MAR26', 'Conciliado'),

-- Lançamento cancelado (para exercícios de filtro por status)
    (1, 1, 14, 2, '2026-03-22', '2026-03-22',  1500.00,
     'Licença duplicada — CANCELADO',               'LIC-MAR26-X', 'Cancelado');
GO

-- -------------------------------------------------------
-- EMPRESA 2 — JANEIRO A MARÇO 2026
-- ContaID: 4 (Bradesco Corrente), 5 (Itaú Poupança), 6 (Nubank)
-- -------------------------------------------------------
INSERT INTO [dbo].[Transacoes]
    (EmpresaID, ContaID, ContaPlanoID, TipoTransacaoID,
     DataLancamento, DataCompetencia, Valor,
     Descricao, NumeroDocumento, Status)
VALUES
-- JANEIRO — Receitas (PlanoID 20 e 21)
    (2, 4, 20, 1, '2026-01-10', '2026-01-10', 45000.00,
     'Venda de produtos — Lote Janeiro A',          'VND-001', 'Conciliado'),
    (2, 4, 20, 1, '2026-01-22', '2026-01-22', 38000.00,
     'Venda de produtos — Lote Janeiro B',          'VND-002', 'Conciliado'),
    (2, 6, 21, 1, '2026-01-15', '2026-01-15', 22000.00,
     'Venda de mercadorias — Janeiro',              'VND-003', 'Conciliado'),

-- JANEIRO — Despesas (PlanoID 22, 23, 24)
    (2, 4, 22, 2, '2026-01-08', '2026-01-08', 35000.00,
     'Compra de mercadorias — Fornecedor Alpha',    'NF-F001', 'Conciliado'),
    (2, 4, 23, 2, '2026-01-31', '2026-01-31',  5200.00,
     'Comissões vendedores — Janeiro',              'COM-JAN26', 'Conciliado'),
    (2, 6, 24, 2, '2026-01-20', '2026-01-20',  3800.00,
     'Frete e logística — Entregas Janeiro',        'FRT-JAN26', 'Conciliado'),

-- FEVEREIRO — Receitas
    (2, 4, 20, 1, '2026-02-12', '2026-02-12', 52000.00,
     'Venda de produtos — Lote Fevereiro A',        'VND-004', 'Conciliado'),
    (2, 6, 21, 1, '2026-02-20', '2026-02-20', 25000.00,
     'Venda de mercadorias — Fevereiro',            'VND-005', 'Conciliado'),

-- FEVEREIRO — Despesas
    (2, 4, 22, 2, '2026-02-05', '2026-02-05', 40000.00,
     'Compra de mercadorias — Fornecedor Beta',     'NF-F002', 'Conciliado'),
    (2, 4, 23, 2, '2026-02-28', '2026-02-28',  5800.00,
     'Comissões vendedores — Fevereiro',            'COM-FEV26', 'Conciliado'),
    (2, 6, 24, 2, '2026-02-18', '2026-02-18',  4100.00,
     'Frete e logística — Entregas Fevereiro',      'FRT-FEV26', 'Conciliado'),

-- MARÇO — Receitas
    (2, 4, 20, 1, '2026-03-08', '2026-03-08', 60000.00,
     'Venda de produtos — Lote Março A',            'VND-006', 'Conciliado'),
    (2, 4, 20, 1, '2026-03-22', '2026-03-22', 32000.00,
     'Venda de produtos — Lote Março B',            'VND-007', 'Pendente'),
    (2, 6, 21, 1, '2026-03-15', '2026-03-15', 28000.00,
     'Venda de mercadorias — Março',                'VND-008', 'Conciliado'),

-- MARÇO — Despesas
    (2, 4, 22, 2, '2026-03-04', '2026-03-04', 48000.00,
     'Compra de mercadorias — Fornecedor Gamma',    'NF-F003', 'Conciliado'),
    (2, 4, 23, 2, '2026-03-31', '2026-03-31',  6500.00,
     'Comissões vendedores — Março',                'COM-MAR26', 'Pendente'),
    (2, 6, 24, 2, '2026-03-18', '2026-03-18',  4400.00,
     'Frete e logística — Entregas Março',          'FRT-MAR26', 'Conciliado'),

-- Transferência entre contas (TipoTransacaoID = 3)
    (2, 5, 22, 3, '2026-03-28', '2026-03-28', 10000.00,
     'Transferência Poupança → Corrente (reforço de caixa)',
     'TRF-MAR26', 'Conciliado');
GO

SELECT 'Transacoes inseridas:' AS Etapa, COUNT(*) AS Total FROM [dbo].[Transacoes];
GO

-- ============================================================
-- BLOCO 10: RESUMO FINAL DE VERIFICAÇÃO
-- ============================================================

SELECT
    'Bancos'           AS Tabela, COUNT(*) AS Registros FROM [dbo].[Bancos]
UNION ALL SELECT
    'TiposTransacao',            COUNT(*)              FROM [dbo].[TiposTransacao]
UNION ALL SELECT
    'Empresas',                  COUNT(*)              FROM [dbo].[Empresas]
UNION ALL SELECT
    'ContasBancarias',           COUNT(*)              FROM [dbo].[ContasBancarias]
UNION ALL SELECT
    'PlanoDeContas',             COUNT(*)              FROM [dbo].[PlanoDeContas]
UNION ALL SELECT
    'Orcamentos',                COUNT(*)              FROM [dbo].[Orcamentos]
UNION ALL SELECT
    'Transacoes',                COUNT(*)              FROM [dbo].[Transacoes];
GO

-- ============================================================
-- BLOCO 11: VALIDAÇÕES DE INTEGRIDADE
-- ============================================================

-- Verifica se existem transações com ContaPlanoID que não aceita lançamentos
SELECT
    t.TransacaoID,
    t.Descricao,
    p.Codigo,
    p.Descricao        AS ContaPlano,
    p.AceitaLancamentos
FROM [dbo].[Transacoes] t
INNER JOIN [dbo].[PlanoDeContas] p
    ON t.ContaPlanoID = p.ContaPlanoID
WHERE p.AceitaLancamentos = 0;
-- Resultado esperado: 0 linhas

-- Verifica distribuição de status nas transações
SELECT
    Status,
    COUNT(*)        AS Quantidade,
    SUM(Valor)      AS ValorTotal
FROM [dbo].[Transacoes]
GROUP BY Status
ORDER BY Quantidade DESC;

-- Verifica transações por empresa e mês
SELECT
    e.NomeFantasia,
    YEAR(t.DataLancamento)  AS Ano,
    MONTH(t.DataLancamento) AS Mes,
    COUNT(*)                AS Lancamentos,
    SUM(t.Valor)            AS MovimentacaoTotal
FROM [dbo].[Transacoes] t
INNER JOIN [dbo].[Empresas] e ON t.EmpresaID = e.EmpresaID
GROUP BY e.NomeFantasia, YEAR(t.DataLancamento), MONTH(t.DataLancamento)
ORDER BY e.NomeFantasia, Ano, Mes;
GO