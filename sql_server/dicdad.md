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