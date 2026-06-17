# Dicionário de Dados - FinanceDB

Este documento descreve a estrutura do banco de dados FinanceDB, detalhando tabelas, colunas, relacionamentos e restrições.

## Índice
- [Dicionário de Dados - FinanceDB](#dicionário-de-dados---financedb)
  - [Índice](#índice)
  - [Bancos](#bancos)
  - [Empresas](#empresas)
  - [ContasBancarias](#contasbancarias)
  - [PlanoDeContas](#planodecontas)
  - [Orcamentos](#orcamentos)
  - [TiposTransacao](#tipostransacao)
  - [Transacoes](#transacoes)
  - [Relacionamentos](#relacionamentos)
    - [Foreign Keys](#foreign-keys)
  - [Restrições de Validação](#restrições-de-validação)
    - [Check Constraints](#check-constraints)
  - [Índices Únicos](#índices-únicos)
    - [Unique Constraints](#unique-constraints)
  - [Dados nas Tabelas](#dados-nas-tabelas)

## Bancos
Armazena as instituições financeiras cadastradas.

| Campo | Tipo | Tamanho | Nulo | PK | Descrição | Padrão | Restrições |
|---|---|---|---|---|---|---|---|
| BancoID | INT | - | Não | Sim | Identificador único | IDENTITY(1,1) | - |
| CodigoCOMPE | INT | - | Não | Não | Código COMPE do banco | - | CHECK (1-999) |
| NomeBanco | NVARCHAR | 100 | Não | Não | Nome da instituição | - | - |
| Sigla | NVARCHAR | 20 | Sim | Não | Sigla do banco | - | - |
| Ativo | BIT | - | Não | Não | Status ativo/inativo | 1 | - |
| DataCadastro | DATETIME2 | 0 | Não | Não | Data de cadastro | GETDATE() | - |

## Empresas
Cadastro de empresas ou entidades do grupo.

| Campo | Tipo | Tamanho | Nulo | PK | Descrição | Padrão | Restrições |
|---|---|---|---|---|---|---|---|
| EmpresaID | INT | - | Não | Sim | Identificador único | IDENTITY(1,1) | - |
| CNPJ | CHAR | 14 | Não | Não | Cadastro Nacional | - | CHECK (len=14) |
| RazaoSocial | NVARCHAR | 100 | Não | Não | Nome jurídico | - | - |
| NomeFantasia | NVARCHAR | 100 | Sim | Não | Nome comercial | - | - |
| Telefone | NVARCHAR | 20 | Sim | Não | Telefone de contato | - | - |
| Email | NVARCHAR | 100 | Sim | Não | Email corporativo | - | CHECK (formato email) |
| Ativo | BIT | - | Não | Não | Status ativo/inativo | 1 | - |
| DataCadastro | DATETIME2 | 0 | Não | Não | Data de cadastro | GETDATE() | - |
| Observacao | NVARCHAR | 500 | Sim | Não | Observações gerais | - | - |

## ContasBancarias
Contas correntes vinculadas aos bancos e empresas.

| Campo | Tipo | Tamanho | Nulo | PK | Descrição | Padrão | Restrições |
|---|---|---|---|---|---|---|---|
| ContaID | INT | - | Não | Sim | Identificador único | IDENTITY(1,1) | - |
| EmpresaID | INT | - | Não | Não | FK para Empresas | - | Foreign Key |
| BancoID | INT | - | Não | Não | FK para Bancos | - | Foreign Key |
| Agencia | NVARCHAR | 10 | Não | Não | Número da agência | - | - |
| NumeroConta | NVARCHAR | 20 | Não | Não | Número da conta | - | - |
| TipoConta | NVARCHAR | 20 | Não | Não | Tipo de conta | Corrente | CHECK (Corrente/Poupança/Investimento) |
| SaldoInicial | DECIMAL | 18,2 | Não | Não | Saldo inicial | 0.00 | - |
| DataCadastro | DATETIME2 | 0 | Não | Não | Data de cadastro | GETDATE() | - |
| Ativa | BIT | - | Não | Não | Status ativo/inativo | 1 | - |

## PlanoDeContas
Estrutura hierárquica de categorias financeiras.

| Campo | Tipo | Tamanho | Nulo | PK | Descrição | Padrão | Restrições |
|---|---|---|---|---|---|---|---|
| ContaPlanoID | INT | - | Não | Sim | Identificador único | IDENTITY(1,1) | - |
| EmpresaID | INT | - | Não | Não | FK para Empresas | - | Foreign Key |
| ContaPaiID | INT | - | Sim | Não | FK para conta pai (hierarquia) | - | Foreign Key (auto-referência) |
| Codigo | NVARCHAR | 20 | Não | Não | Código contábil (ex: 1.1.01) | - | Unique |
| Descricao | NVARCHAR | 100 | Não | Não | Nome da categoria | - | - |
| Tipo | NVARCHAR | 10 | Não | Não | Tipo de conta | - | CHECK (RECEITA/DESPESA) |
| Nivel | INT | - | Não | Não | Nível hierárquico | - | CHECK (1-5) |
| AceitaLancamentos | BIT | - | Não | Não | Aceita lançamentos diretos | 0 | - |
| Ativa | BIT | - | Não | Não | Status ativo/inativo | 1 | - |

## Orcamentos
Planejamento financeiro por conta e período.

| Campo | Tipo | Tamanho | Nulo | PK | Descrição | Padrão | Restrições |
|---|---|---|---|---|---|---|---|
| OrcamentoID | INT | - | Não | Sim | Identificador único | IDENTITY(1,1) | - |
| EmpresaID | INT | - | Não | Não | FK para Empresas | - | Foreign Key |
| ContaPlanoID | INT | - | Não | Não | FK para PlanoDeContas | - | Foreign Key |
| Ano | INT | - | Não | Não | Ano do orçamento | - | CHECK (2000-2100) |
| Mes | INT | - | Não | Não | Mês do orçamento | - | CHECK (1-12) |
| ValorOrcado | DECIMAL | 18,2 | Não | Não | Valor planejado | - | CHECK (>=0) |
| ValorRealizado | DECIMAL | 18,2 | Não | Não | Valor realizado | 0.00 | - |

## TiposTransacao
Classificação de entradas e saídas.

| Campo | Tipo | Tamanho | Nulo | PK | Descrição | Padrão | Restrições |
|---|---|---|---|---|---|---|---|
| TipoTransacaoID | INT | - | Não | Sim | Identificador único | IDENTITY(1,1) | - |
| Codigo | NVARCHAR | 10 | Não | Não | Código do tipo | - | Unique |
| Descricao | NVARCHAR | 50 | Não | Não | Descrição (ex: Receita, Despesa) | - | - |
| Natureza | CHAR | 1 | Não | Não | C (Crédito) ou D (Débito) | - | CHECK (C/D) |
| Ativo | BIT | - | Não | Não | Status ativo/inativo | 1 | - |
| DataCadastro | DATETIME2 | 0 | Não | Não | Data de cadastro | GETDATE() | - |

## Transacoes
Registro de movimentações financeiras.

| Campo | Tipo | Tamanho | Nulo | PK | Descrição | Padrão | Restrições |
|---|---|---|---|---|---|---|---|
| TransacaoID | BIGINT | - | Não | Sim | Identificador único | IDENTITY(1,1) | - |
| EmpresaID | INT | - | Não | Não | FK para Empresas | - | Foreign Key |
| ContaID | INT | - | Não | Não | FK para ContasBancarias | - | Foreign Key |
| ContaPlanoID | INT | - | Não | Não | FK para PlanoDeContas | - | Foreign Key |
| TipoTransacaoID | INT | - | Não | Não | FK para TiposTransacao | - | Foreign Key |
| DataLancamento | DATE | - | Não | Não | Data do lançamento | GETDATE() | - |
| DataCompetencia | DATE | - | Não | Não | Data de competência | - | - |
| Valor | DECIMAL | 18,2 | Não | Não | Valor da transação | - | CHECK (>0) |
| Descricao | NVARCHAR | 200 | Não | Não | Descrição da operação | - | - |
| NumeroDocumento | NVARCHAR | 50 | Sim | Não | Número do documento | - | - |
| Status | NVARCHAR | 20 | Não | Não | Status da transação | Pendente | CHECK (Pendente/Conciliado/Cancelado) |
| DataRegistro | DATETIME2 | 0 | Não | Não | Data/hora do registro | GETDATE() | - |

## Relacionamentos

### Foreign Keys
- **FK_ContasBancarias_Bancos**: `ContasBancarias.BancoID` → `Bancos.BancoID`
- **FK_ContasBancarias_Empresas**: `ContasBancarias.EmpresaID` → `Empresas.EmpresaID`
- **FK_PlanoDeContas_Empresas**: `PlanoDeContas.EmpresaID` → `Empresas.EmpresaID`
- **FK_PlanoDeContas_ContaPai**: `PlanoDeContas.ContaPaiID` → `PlanoDeContas.ContaPlanoID` (auto-referência)
- **FK_Orcamentos_Empresas**: `Orcamentos.EmpresaID` → `Empresas.EmpresaID`
- **FK_Orcamentos_PlanoDeContas**: `Orcamentos.ContaPlanoID` → `PlanoDeContas.ContaPlanoID`
- **FK_Transacoes_Empresas**: `Transacoes.EmpresaID` → `Empresas.EmpresaID`
- **FK_Transacoes_ContasBancarias**: `Transacoes.ContaID` → `ContasBancarias.ContaID`
- **FK_Transacoes_PlanoDeContas**: `Transacoes.ContaPlanoID` → `PlanoDeContas.ContaPlanoID`
- **FK_Transacoes_TiposTransacao**: `Transacoes.TipoTransacaoID` → `TiposTransacao.TipoTransacaoID`

## Restrições de Validação

### Check Constraints
| Tabela | Constraint | Descrição |
|---|---|---|
| Bancos | CK_Bancos_CodigoCOMPE | CodigoCOMPE deve estar entre 1 e 999 |
| Empresas | CK_Empresas_CNPJ | CNPJ deve ter exatamente 14 caracteres |
| Empresas | CK_Empresas_Email | Email deve conter @ e . (formato válido) |
| ContasBancarias | CK_ContasBancarias_TipoConta | TipoConta: Corrente, Poupança ou Investimento |
| PlanoDeContas | CK_PlanoDeContas_Tipo | Tipo: RECEITA ou DESPESA |
| PlanoDeContas | CK_PlanoDeContas_Nivel | Nivel: 1 a 5 |
| Orcamentos | CK_Orcamentos_Ano | Ano: 2000 a 2100 |
| Orcamentos | CK_Orcamentos_Mes | Mes: 1 a 12 |
| Orcamentos | CK_Orcamentos_ValorOrcado | ValorOrcado >= 0 |
| TiposTransacao | CK_TiposTransacao_Natureza | Natureza: C (Crédito) ou D (Débito) |
| Transacoes | CK_Transacoes_Status | Status: Pendente, Conciliado ou Cancelado |
| Transacoes | CK_Transacoes_Valor | Valor > 0 |

## Índices Únicos

### Unique Constraints
| Tabela | Índice | Colunas |
|---|---|---|
| Bancos | PK_Bancos | BancoID |
| Empresas | PK_Empresas | EmpresaID |
| ContasBancarias | PK_ContasBancarias | ContaID |
| ContasBancarias | UQ_ContasBancarias_AgenciaConta | BancoID, Agencia, NumeroConta |
| PlanoDeContas | PK_PlanoDeContas | ContaPlanoID |
| PlanoDeContas | UQ_PlanoDeContas_EmpresaCodigo | EmpresaID, Codigo |
| Orcamentos | PK_Orcamentos | OrcamentoID |
| Orcamentos | UQ_Orcamentos_EmpresaContaAnomes | EmpresaID, ContaPlanoID, Ano, Mes |
| TiposTransacao | PK_TiposTransacao | TipoTransacaoID |
| Transacoes | PK_Transacoes | TransacaoID |

---

**Banco de Dados**: FinanceDB  
**Data de Geração**: 15/06/2026  
**Versão**: 1.0

---

## Dados nas Tabelas

**Resultado do SELECT * FROM dbo.Bancos;**


BancoID	CodigoCOMPE	NomeBanco	Sigla	Ativo	DataCadastro
1	341	Itaú Unibanco S.A.	ITAU	1	2026-06-16 18:28:11
2	1	Banco do Brasil S.A.	BB	1	2026-06-16 18:28:11
3	104	Caixa Econômica Federal	CEF	1	2026-06-16 18:28:11
4	237	Banco Bradesco S.A.	BRADESCO	1	2026-06-16 18:28:11
5	33	Banco Santander (Brasil) S.A.	SANTANDER	1	2026-06-16 18:28:11
6	260	Nu Pagamentos S.A. (Nubank)	NUBANK	1	2026-06-16 18:28:11

**Resultado do SELECT * FROM dbo.Empresas;**


EmpresaID	CNPJ	RazaoSocial	NomeFantasia	Telefone	Email	Ativo	DataCadastro	Observacao
1	12345678000195	Tech Solutions Ltda.	TechSol	(11) 3000-1000	financeiro@techsol.com.br	1	2026-06-16 18:28:11	Empresa principal do grupo — tecnologia e software
2	98765432000188	Comercial Bianeck S.A.	Bianeck Comercial	(11) 3000-2000	financeiro@bianeck.com.br	1	2026-06-16 18:28:11	Empresa de comércio varejista do grupo
3	11223344000177	Holding FinGroup Participações Ltda.	FinGroup	(11) 3000-3000	holding@fingroup.com.br	1	2026-06-16 18:28:11	Empresa holding — participações societárias

**Resultado do SELECT * FROM dbo.ContasBancarias;**


ContaID	EmpresaID	BancoID	Agencia	NumeroConta	TipoConta	SaldoInicial	DataCadastro	Ativa
1	1	1	0001	12345-6	Corrente	50000.00	2026-06-16 18:28:11	1
2	1	2	1234	56789-0	Corrente	30000.00	2026-06-16 18:28:11	1
3	1	5	0042	98765-4	Investimento	100000.00	2026-06-16 18:28:11	1
4	2	4	0500	11111-2	Corrente	25000.00	2026-06-16 18:28:11	1
5	2	1	0002	22222-3	Poupança	15000.00	2026-06-16 18:28:11	1
6	2	6	0001	33333-4	Corrente	10000.00	2026-06-16 18:28:11	1
7	3	3	0010	44444-5	Corrente	200000.00	2026-06-16 18:28:11	1

**Resultado do SELECT * FROM dbo.PlanoDeContas;**


ContaPlanoID	EmpresaID	ContaPaiID	Codigo	Descricao	Tipo	Nivel	AceitaLancamentos	Ativa
1	1	NULL	1	RECEITAS	RECEITA	1	0	1
2	1	NULL	2	DESPESAS	DESPESA	1	0	1
3	1	1	1.1	Receitas de Serviços	RECEITA	2	0	1
4	1	1	1.2	Receitas Financeiras	RECEITA	2	0	1
5	1	2	2.1	Despesas Operacionais	DESPESA	2	0	1
6	1	2	2.2	Despesas Administrativas	DESPESA	2	0	1
7	1	3	1.1.01	Receita de Consultoria	RECEITA	3	1	1
8	1	3	1.1.02	Receita de Desenvolvimento	RECEITA	3	1	1
9	1	4	1.2.01	Rendimentos de Aplicação	RECEITA	3	1	1
10	1	5	2.1.01	Salários e Encargos	DESPESA	3	1	1
11	1	5	2.1.02	Infraestrutura Cloud	DESPESA	3	1	1
12	1	6	2.2.01	Aluguel de Escritório	DESPESA	3	1	1
13	1	6	2.2.02	Energia Elétrica	DESPESA	3	1	1
14	1	6	2.2.03	Licenças de Software	DESPESA	3	1	1
15	2	NULL	1	RECEITAS	RECEITA	1	0	1
16	2	NULL	2	DESPESAS	DESPESA	1	0	1
17	2	15	1.1	Receitas de Vendas	RECEITA	2	0	1
18	2	16	2.1	Custo das Mercadorias	DESPESA	2	0	1
19	2	16	2.2	Despesas Comerciais	DESPESA	2	0	1
20	2	17	1.1.01	Venda de Produtos	RECEITA	3	1	1
21	2	17	1.1.02	Venda de Mercadorias	RECEITA	3	1	1
22	2	18	2.1.01	Compra de Mercadorias	DESPESA	3	1	1
23	2	19	2.2.01	Comissões de Vendas	DESPESA	3	1	1
24	2	19	2.2.02	Frete e Logística	DESPESA	3	1	1

**Resultado do SELECT * FROM dbo.TiposTransacao;**


TipoTransacaoID	Codigo	Descricao	Natureza	Ativo	DataCadastro
1	RECEITA	Receita Financeira	C	1	2026-06-16 18:28:11
2	DESPESA	Despesa Financeira	D	1	2026-06-16 18:28:11
3	TRANSF	Transferência entre Contas	D	1	2026-06-16 18:28:11

**Resultado do SELECT * FROM dbo.Transacoes;**


TransacaoID	EmpresaID	ContaID	ContaPlanoID	TipoTransacaoID	DataLancamento	DataCompetencia	Valor	Descricao	NumeroDocumento	Status	DataRegistro
1	1	1	7	1	2026-01-05	2026-01-05	12000.00	Consultoria estratégica — Cliente Alpha	NF-001	Conciliado	2026-06-16 18:28:12
2	1	1	7	1	2026-01-12	2026-01-12	18000.00	Consultoria técnica — Cliente Beta	NF-002	Conciliado	2026-06-16 18:28:12
3	1	2	7	1	2026-01-20	2026-01-20	15000.00	Consultoria de processos — Cliente Gamma	NF-003	Conciliado	2026-06-16 18:28:12
4	1	1	8	1	2026-01-08	2026-01-08	22000.00	Desenvolvimento sistema ERP — Fase 1	NF-004	Conciliado	2026-06-16 18:28:12
5	1	2	8	1	2026-01-25	2026-01-25	8500.00	Manutenção evolutiva — Portal Web	NF-005	Conciliado	2026-06-16 18:28:12
6	1	3	9	1	2026-01-31	2026-01-31	1850.00	Rendimento CDB Santander — Janeiro	RND-001	Conciliado	2026-06-16 18:28:12
7	1	1	10	2	2026-01-05	2026-01-05	32000.00	Folha de pagamento — Janeiro 2026	FP-JAN26	Conciliado	2026-06-16 18:28:12
8	1	1	10	2	2026-01-05	2026-01-05	4800.00	FGTS — Janeiro 2026	FGTS-JAN26	Conciliado	2026-06-16 18:28:12
9	1	2	11	2	2026-01-10	2026-01-10	7200.00	AWS — infraestrutura cloud Janeiro	AWS-JAN26	Conciliado	2026-06-16 18:28:12
10	1	1	12	2	2026-01-05	2026-01-05	3500.00	Aluguel escritório Paulista — Janeiro	ALG-JAN26	Conciliado	2026-06-16 18:28:12
11	1	1	13	2	2026-01-15	2026-01-15	980.00	Energia elétrica — Janeiro 2026	CELSP-JAN26	Conciliado	2026-06-16 18:28:12
12	1	2	14	2	2026-01-20	2026-01-20	2800.00	Licenças Microsoft 365 — Janeiro	MS-JAN26	Conciliado	2026-06-16 18:28:12
13	1	1	7	1	2026-02-03	2026-02-03	20000.00	Consultoria estratégica — Cliente Delta	NF-006	Conciliado	2026-06-16 18:28:12
14	1	2	7	1	2026-02-14	2026-02-14	16500.00	Consultoria de TI — Cliente Epsilon	NF-007	Conciliado	2026-06-16 18:28:12
15	1	1	8	1	2026-02-10	2026-02-10	28000.00	Desenvolvimento App Mobile — Entrega parcial	NF-008	Conciliado	2026-06-16 18:28:12
16	1	2	8	1	2026-02-20	2026-02-20	5000.00	Suporte técnico mensal — Contratos	NF-009	Conciliado	2026-06-16 18:28:12
17	1	3	9	1	2026-02-28	2026-02-28	1920.00	Rendimento CDB Santander — Fevereiro	RND-002	Conciliado	2026-06-16 18:28:12
18	1	1	10	2	2026-02-05	2026-02-05	33000.00	Folha de pagamento — Fevereiro 2026	FP-FEV26	Conciliado	2026-06-16 18:28:12
19	1	1	10	2	2026-02-05	2026-02-05	4950.00	FGTS — Fevereiro 2026	FGTS-FEV26	Conciliado	2026-06-16 18:28:12
20	1	2	11	2	2026-02-10	2026-02-10	8100.00	AWS — infraestrutura cloud Fevereiro	AWS-FEV26	Conciliado	2026-06-16 18:28:12
21	1	1	12	2	2026-02-05	2026-02-05	3500.00	Aluguel escritório Paulista — Fevereiro	ALG-FEV26	Conciliado	2026-06-16 18:28:12
22	1	1	13	2	2026-02-15	2026-02-15	1050.00	Energia elétrica — Fevereiro 2026	CELSP-FEV26	Conciliado	2026-06-16 18:28:12
23	1	2	14	2	2026-02-20	2026-02-20	3200.00	Licenças Adobe Creative Cloud — Fevereiro	ADO-FEV26	Conciliado	2026-06-16 18:28:12
24	1	1	7	1	2026-03-04	2026-03-04	25000.00	Consultoria financeira — Cliente Zeta	NF-010	Conciliado	2026-06-16 18:28:12
25	1	2	7	1	2026-03-18	2026-03-18	19000.00	Consultoria de segurança — Cliente Eta	NF-011	Conciliado	2026-06-16 18:28:12
26	1	1	7	1	2026-03-28	2026-03-28	8000.00	Consultoria ágil — Sprint Review	NF-012	Pendente	2026-06-16 18:28:12
27	1	1	8	1	2026-03-10	2026-03-10	35000.00	Desenvolvimento sistema ERP — Fase 2	NF-013	Conciliado	2026-06-16 18:28:12
28	1	2	8	1	2026-03-25	2026-03-25	4500.00	Suporte e manutenção — Março	NF-014	Pendente	2026-06-16 18:28:12
29	1	3	9	1	2026-03-31	2026-03-31	2100.00	Rendimento CDB Santander — Março	RND-003	Conciliado	2026-06-16 18:28:12
30	1	1	10	2	2026-03-05	2026-03-05	34000.00	Folha de pagamento — Março 2026	FP-MAR26	Conciliado	2026-06-16 18:28:12
31	1	1	10	2	2026-03-05	2026-03-05	5100.00	FGTS — Março 2026	FGTS-MAR26	Conciliado	2026-06-16 18:28:12
32	1	2	11	2	2026-03-10	2026-03-10	9200.00	AWS — infraestrutura cloud Março	AWS-MAR26	Conciliado	2026-06-16 18:28:12
33	1	1	12	2	2026-03-05	2026-03-05	3500.00	Aluguel escritório Paulista — Março	ALG-MAR26	Conciliado	2026-06-16 18:28:12
34	1	1	13	2	2026-03-15	2026-03-15	1180.00	Energia elétrica — Março 2026	CELSP-MAR26	Conciliado	2026-06-16 18:28:12
35	1	2	14	2	2026-03-20	2026-03-20	3500.00	Licenças Microsoft + Adobe — Março	LIC-MAR26	Conciliado	2026-06-16 18:28:12
36	1	1	14	2	2026-03-22	2026-03-22	1500.00	Licença duplicada — CANCELADO	LIC-MAR26-X	Cancelado	2026-06-16 18:28:12
37	2	4	20	1	2026-01-10	2026-01-10	45000.00	Venda de produtos — Lote Janeiro A	VND-001	Conciliado	2026-06-16 18:28:12
38	2	4	20	1	2026-01-22	2026-01-22	38000.00	Venda de produtos — Lote Janeiro B	VND-002	Conciliado	2026-06-16 18:28:12
39	2	6	21	1	2026-01-15	2026-01-15	22000.00	Venda de mercadorias — Janeiro	VND-003	Conciliado	2026-06-16 18:28:12
40	2	4	22	2	2026-01-08	2026-01-08	35000.00	Compra de mercadorias — Fornecedor Alpha	NF-F001	Conciliado	2026-06-16 18:28:12
41	2	4	23	2	2026-01-31	2026-01-31	5200.00	Comissões vendedores — Janeiro	COM-JAN26	Conciliado	2026-06-16 18:28:12
42	2	6	24	2	2026-01-20	2026-01-20	3800.00	Frete e logística — Entregas Janeiro	FRT-JAN26	Conciliado	2026-06-16 18:28:12
43	2	4	20	1	2026-02-12	2026-02-12	52000.00	Venda de produtos — Lote Fevereiro A	VND-004	Conciliado	2026-06-16 18:28:12
44	2	6	21	1	2026-02-20	2026-02-20	25000.00	Venda de mercadorias — Fevereiro	VND-005	Conciliado	2026-06-16 18:28:12
45	2	4	22	2	2026-02-05	2026-02-05	40000.00	Compra de mercadorias — Fornecedor Beta	NF-F002	Conciliado	2026-06-16 18:28:12
46	2	4	23	2	2026-02-28	2026-02-28	5800.00	Comissões vendedores — Fevereiro	COM-FEV26	Conciliado	2026-06-16 18:28:12
47	2	6	24	2	2026-02-18	2026-02-18	4100.00	Frete e logística — Entregas Fevereiro	FRT-FEV26	Conciliado	2026-06-16 18:28:12
48	2	4	20	1	2026-03-08	2026-03-08	60000.00	Venda de produtos — Lote Março A	VND-006	Conciliado	2026-06-16 18:28:12
49	2	4	20	1	2026-03-22	2026-03-22	32000.00	Venda de produtos — Lote Março B	VND-007	Pendente	2026-06-16 18:28:12
50	2	6	21	1	2026-03-15	2026-03-15	28000.00	Venda de mercadorias — Março	VND-008	Conciliado	2026-06-16 18:28:12
51	2	4	22	2	2026-03-04	2026-03-04	48000.00	Compra de mercadorias — Fornecedor Gamma	NF-F003	Conciliado	2026-06-16 18:28:12
52	2	4	23	2	2026-03-31	2026-03-31	6500.00	Comissões vendedores — Março	COM-MAR26	Pendente	2026-06-16 18:28:12
53	2	6	24	2	2026-03-18	2026-03-18	4400.00	Frete e logística — Entregas Março	FRT-MAR26	Conciliado	2026-06-16 18:28:12
54	2	5	22	3	2026-03-28	2026-03-28	10000.00	Transferência Poupança ? Corrente (reforço de caixa)	TRF-MAR26	Conciliado	2026-06-16 18:28:12

**Resultado do SELECT * FROM dbo.Orcamentos;**


OrcamentoID	EmpresaID	ContaPlanoID	Ano	Mes	ValorOrcado	ValorRealizado
1	1	7	2026	1	45000.00	0.00
2	1	8	2026	1	30000.00	0.00
3	1	9	2026	1	2000.00	0.00
4	1	10	2026	1	35000.00	0.00
5	1	11	2026	1	8000.00	0.00
6	1	12	2026	1	3500.00	0.00
7	1	13	2026	1	1200.00	0.00
8	1	14	2026	1	3000.00	0.00
9	1	7	2026	2	50000.00	0.00
10	1	8	2026	2	32000.00	0.00
11	1	9	2026	2	2000.00	0.00
12	1	10	2026	2	35000.00	0.00
13	1	11	2026	2	8500.00	0.00
14	1	12	2026	2	3500.00	0.00
15	1	13	2026	2	1200.00	0.00
16	1	14	2026	2	3500.00	0.00
17	1	7	2026	3	55000.00	0.00
18	1	8	2026	3	35000.00	0.00
19	1	9	2026	3	2500.00	0.00
20	1	10	2026	3	36000.00	0.00
21	1	11	2026	3	9000.00	0.00
22	1	12	2026	3	3500.00	0.00
23	1	13	2026	3	1200.00	0.00
24	1	14	2026	3	3500.00	0.00
25	2	20	2026	1	80000.00	0.00
26	2	21	2026	1	40000.00	0.00
27	2	22	2026	1	50000.00	0.00
28	2	23	2026	1	6000.00	0.00
29	2	24	2026	1	4000.00	0.00
30	2	20	2026	2	85000.00	0.00
31	2	21	2026	2	42000.00	0.00
32	2	22	2026	2	53000.00	0.00
33	2	23	2026	2	6500.00	0.00
34	2	24	2026	2	4200.00	0.00
35	2	20	2026	3	90000.00	0.00
36	2	21	2026	3	45000.00	0.00
37	2	22	2026	3	56000.00	0.00
38	2	23	2026	3	7000.00	0.00
39	2	24	2026	3	4500.00	0.00
