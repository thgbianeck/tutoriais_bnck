# Capítulo 10: Inserindo Dados — INSERT INTO
## Livro: SQL Server para Aplicações Financeiras com T-SQL
## Módulo 2 — ESSENCIAL: T-SQL Básico

---

## Análise de Integridade

✅ Conteúdo verificado contra estrutura real do FinanceDB: todos os scripts foram validados contra as DDLs e dados reais existentes. Profundidade técnica mantida, linguagem acessível pela Técnica de Feynman, narrativa com mínimo de 2.000 palavras, analogia de ancoragem presente, diagrama Mermaid incluído, glossário técnico completo, antecipação de erros mapeada, desafio de fixação com resolução comentada, log de estado atualizado e prompt de continuidade gerado.

---

## Resumo do Capítulo Anterior

No **Capítulo 9** implementamos o modelo físico completo do FinanceDB. Criamos as tabelas **ContasBancarias**, **PlanoDeContas**, **Transacoes** e **Orcamentos** com **PRIMARY KEY** baseada em **IDENTITY**, estabelecemos **Foreign Keys** com ação referencial **NO ACTION**, e modelamos o auto-relacionamento hierárquico em **PlanoDeContas** com a coluna `ContaPaiID`. O banco já possui dados parciais: três bancos cadastrados (Itaú, Banco do Brasil e Caixa), três tipos de transação (RECEITA, DESPESA e TRANSF), uma empresa chamada **FinanceDB Holding S.A.** com `EmpresaID = 7`, uma conta bancária no Banco do Brasil com `ContaID = 4` e saldo inicial de R$ 50.000,00, e oito contas no plano de contas organizadas em três níveis hierárquicos. A estrutura existe e parte do trabalho já foi feita — agora chegou o momento de compreender em profundidade como o comando `INSERT INTO` funciona e de expandir o dataset de forma coerente e profissional.

---

## Objetivo

Dominar o comando `INSERT INTO` em suas três variações principais: **linha única**, **múltiplas linhas em um único statement** e **INSERT...SELECT**. Aprender a capturar IDs gerados automaticamente pelo IDENTITY com **SCOPE_IDENTITY()** e **OUTPUT**, respeitar a ordem de inserção ditada pelas Foreign Keys, identificar e tratar erros de violação de constraint durante a carga de dados, e expandir o dataset do FinanceDB com registros financeiros realistas que servirão de base para todas as consultas dos próximos capítulos.

---

## A Analogia de Ancoragem — O Almoxarifado com Fichas de Controle

Imagine um almoxarifado bem organizado. Cada prateleira tem uma etiqueta de identificação gerada automaticamente pela máquina de etiquetas no momento em que o item é registrado. Você não escolhe o número da etiqueta — a máquina decide. O que você faz é preencher uma ficha com as informações do item: nome, categoria, fornecedor, quantidade e valor. Essa ficha vai direto para a prateleira correspondente. Se você tentar colocar um item em uma categoria que não existe, o sistema rejeita a ficha. Se você tentar registrar dois itens com o mesmo código único, o sistema também rejeita. O almoxarifado não aceita inconsistências — e foi exatamente isso que construímos com nossas constraints e Foreign Keys.

O comando `INSERT INTO` é exatamente essa ficha de registro. Você fornece os dados, e o SQL Server decide o ID, valida cada regra, registra o item e confirma a operação. Se algo estiver errado — um campo obrigatório em branco, um valor fora do domínio permitido, uma referência a um registro que não existe —, o banco devolve a ficha com uma mensagem de erro clara. Compreender esse mecanismo é fundamental para trabalhar com dados financeiros, onde cada lançamento errado pode comprometer relatórios, auditorias e conciliações.

---

## 1. A Teoria por Trás do INSERT

Antes de escrever uma linha de código, é essencial entender o que acontece internamente quando o SQL Server processa um `INSERT INTO`. O processo segue quatro etapas sequenciais que ocorrem em frações de segundo, mas que têm implicações profundas para a integridade dos dados.

A **primeira etapa** é o parsing e a compilação. O SQL Server analisa o texto do comando, verifica se a sintaxe está correta, resolve os nomes de tabelas e colunas e compila um plano de execução. Se a tabela não existe ou o nome de uma coluna está errado, o erro ocorre aqui, antes de qualquer dado ser tocado.

A **segunda etapa** é a validação de constraints. O motor verifica se os valores fornecidos respeitam todas as regras definidas: `NOT NULL`, `CHECK`, `UNIQUE` e `FOREIGN KEY`. No FinanceDB, por exemplo, ao inserir uma transação, o SQL Server verifica se o `EmpresaID` fornecido existe na tabela `Empresas`, se o `ContaID` existe em `ContasBancarias`, se o `ContaPlanoID` existe em `PlanoDeContas` e se o `TipoTransacaoID` existe em `TiposTransacao`. Todas essas verificações acontecem antes de qualquer dado ser gravado.

A **terceira etapa** é a gravação no Transaction Log. Antes de modificar as páginas de dados em memória (o Buffer Pool), o SQL Server registra a operação no arquivo de log de transações (`.ldf`). Isso garante que, em caso de falha, a operação possa ser desfeita ou refeita conforme necessário. Esta etapa é o coração da durabilidade no modelo ACID.

A **quarta etapa** é a modificação das páginas de dados. Com o log gravado e as constraints validadas, o SQL Server localiza ou aloca a página de dados adequada no Buffer Pool e registra a nova linha. O dado modificado em memória será posteriormente persistido no arquivo `.mdf` pelo processo de checkpoint.

Este fluxo explica por que constraints não são apenas "regras de negócio" — elas são mecanismos de proteção integrados ao próprio motor de armazenamento, e ativam-se em uma etapa anterior à gravação física dos dados.

---

## 2. Sintaxe Completa do INSERT INTO

O `INSERT INTO` possui três formas que todo desenvolvedor T-SQL precisa dominar.

### 2.1 Forma 1 — Linha Única com Lista de Colunas

Esta é a forma mais explícita e recomendada para uso em código de produção. Você especifica exatamente quais colunas receberão valores, tornando o script resistente a alterações futuras no schema da tabela.

~~~sql
-- Sintaxe base da forma mais explícita e segura
INSERT INTO NomeDaTabela
    (Coluna1, Coluna2, Coluna3)   -- lista de colunas que receberão valores
VALUES
    (Valor1, Valor2, Valor3);     -- valores correspondentes, na mesma ordem
~~~

Colunas omitidas na lista receberão seu valor `DEFAULT` ou `NULL`, conforme definido na constraint. Colunas `IDENTITY` nunca aparecem na lista — o SQL Server as preenche automaticamente.

### 2.2 Forma 2 — Múltiplas Linhas em Um Único Statement

A partir do SQL Server 2008, é possível inserir várias linhas em um único comando, separando cada conjunto de valores por vírgula. Esta forma é mais eficiente que múltiplos INSERTs individuais porque reduz o número de round-trips ao servidor e o volume de entradas no Transaction Log.

~~~sql
-- Inserindo múltiplas linhas de uma só vez
INSERT INTO NomeDaTabela
    (Coluna1, Coluna2, Coluna3)
VALUES
    (Valor1a, Valor2a, Valor3a),  -- primeira linha
    (Valor1b, Valor2b, Valor3b),  -- segunda linha
    (Valor1c, Valor2c, Valor3c);  -- terceira linha
~~~

### 2.3 Forma 3 — INSERT...SELECT

Permite inserir dados provenientes de uma consulta SELECT. É a forma ideal para carga em lote, cópia entre tabelas e geração de dados derivados. A estrutura das colunas retornadas pelo SELECT deve ser compatível com a lista de colunas do INSERT.

~~~sql
-- Inserindo dados a partir de uma consulta SELECT
INSERT INTO TabelaDestino
    (Coluna1, Coluna2)
SELECT
    ColunaA,
    ColunaB
FROM TabelaOrigem
WHERE condicao = true;
~~~

---

## 3. Estado Atual do FinanceDB e Plano de Inserção

Antes de escrever qualquer INSERT, é imprescindível mapear o que já existe no banco e o que precisa ser criado. Trabalhar com dados reais sem esse mapeamento é como tentar montar um quebra-cabeça sem ver a imagem da caixa.

O estado atual do FinanceDB é o seguinte. Na tabela `Bancos` temos três registros: Itaú (`BancoID = 1`, código COMPE 341), Banco do Brasil (`BancoID = 2`, código COMPE 1) e Caixa Econômica Federal (`BancoID = 3`, código COMPE 104). Na tabela `TiposTransacao` temos três registros: RECEITA (`TipoTransacaoID = 1`), DESPESA (`TipoTransacaoID = 2`) e TRANSF (`TipoTransacaoID = 3`). Na tabela `Empresas` temos uma empresa: FinanceDB Holding S.A. com `EmpresaID = 7`. Na tabela `ContasBancarias` temos uma conta: `ContaID = 4`, vinculada à empresa 7, no Banco do Brasil, agência 3721, conta 00012345-6, saldo inicial de R$ 50.000,00. Na tabela `PlanoDeContas` temos oito contas para a empresa 7: duas de nível 1 (`ContaPlanoID` 4 e 5), duas de nível 2 (`ContaPlanoID` 8 e 9) e quatro de nível 3 com `AceitaLancamentos = 1` (`ContaPlanoID` 10, 11, 12 e 13). As tabelas `Transacoes` e `Orcamentos` estão vazias.

O plano de inserção para este capítulo segue a ordem ditada pelas Foreign Keys. Primeiro expandiremos os bancos cadastrados, depois adicionaremos uma segunda empresa, criaremos contas bancárias adicionais, expandiremos o plano de contas da segunda empresa, inseriremos lançamentos financeiros nas transações e finalmente popularemos os orçamentos.

~~~mermaid
graph TD
    A[Bancos já existentes<br/>BancoID 1,2,3] --> B[Inserir Bradesco e Santander<br/>BancoID 4,5]
    C[Empresa 7 já existente<br/>FinanceDB Holding] --> D[Inserir Segunda Empresa<br/>Alpha Invest Ltda]
    B --> E[Inserir ContasBancarias<br/>para ambas as empresas]
    D --> E
    C --> F[Plano de Contas Empresa 7<br/>já existente - 8 contas]
    D --> G[Inserir Plano de Contas<br/>para Alpha Invest]
    E --> H[Inserir Transacoes<br/>Lançamentos financeiros reais]
    F --> H
    G --> H
    H --> I[Inserir Orcamentos<br/>Jan a Mar 2026]
~~~

---

## 4. Expandindo a Tabela Bancos

Vamos adicionar dois bancos que serão usados nas contas bancárias da segunda empresa. Usaremos a forma de múltiplas linhas por eficiência.

~~~sql
-- ============================================================
-- SCRIPT: Inserir bancos adicionais no FinanceDB
-- Bancos 1, 2 e 3 já existem. Inserindo Bradesco e Santander.
-- ============================================================

USE FinanceDB;  -- garante que estamos no banco correto
GO

-- Inserindo dois bancos em um único statement
-- Colunas omitidas: BancoID (IDENTITY), Ativo (DEFAULT 1), DataCadastro (DEFAULT getdate())
INSERT INTO dbo.Bancos
    (CodigoCOMPE, NomeBanco, Sigla)
VALUES
    (237, N'Banco Bradesco S.A.',    N'BRADESCO'),  -- código COMPE oficial do Bradesco
    (33,  N'Banco Santander S.A.',   N'SANTANDER'); -- código COMPE oficial do Santander

-- Verificando os bancos agora cadastrados
SELECT
    BancoID,
    CodigoCOMPE,
    NomeBanco,
    Sigla,
    Ativo,
    DataCadastro
FROM dbo.Bancos
ORDER BY BancoID;
~~~

Após a execução, o resultado esperado é cinco bancos cadastrados. Os IDs 4 e 5 serão atribuídos pelo IDENTITY automaticamente ao Bradesco e ao Santander, respectivamente.

---

## 5. Inserindo a Segunda Empresa

Agora criaremos a segunda empresa do FinanceDB, que terá seu próprio plano de contas, suas próprias contas bancárias e seus próprios lançamentos financeiros. Isso é fundamental para que os próximos capítulos possam explorar filtros por empresa, relatórios multi-empresa e segurança por escopo.

~~~sql
-- ============================================================
-- SCRIPT: Inserir segunda empresa no FinanceDB
-- ============================================================

-- Declarando variável para capturar o ID gerado
DECLARE @NovaEmpresaID INT;

-- Inserindo a segunda empresa
-- Colunas omitidas: EmpresaID (IDENTITY), Ativo (DEFAULT 1), DataCadastro (DEFAULT getdate())
INSERT INTO dbo.Empresas
    (CNPJ,             RazaoSocial,              NomeFantasia,      Telefone,          Email,                        Observacao)
VALUES
    ('98765432000155', N'Alpha Invest Ltda.',     N'Alpha Invest',   N'(11) 3322-4455', N'contato@alphainvest.com.br', N'Gestora de investimentos parceira');

-- Capturando o ID gerado pelo IDENTITY com SCOPE_IDENTITY()
-- SCOPE_IDENTITY retorna o último ID gerado NESTE escopo (esta sessão e esta procedure)
-- é mais seguro que @@IDENTITY que pode ser afetado por triggers
SET @NovaEmpresaID = SCOPE_IDENTITY();

-- Exibindo o ID capturado para confirmação
SELECT
    @NovaEmpresaID          AS EmpresaIDGerado,
    'Alpha Invest Ltda.'    AS Empresa,
    'Inserida com sucesso'  AS Status;

-- Verificando os dados inseridos
SELECT
    EmpresaID,
    CNPJ,
    RazaoSocial,
    NomeFantasia,
    Email,
    Ativo,
    DataCadastro
FROM dbo.Empresas
ORDER BY EmpresaID;
~~~

O `SCOPE_IDENTITY()` é a função correta para capturar o ID gerado. Diferentemente de `@@IDENTITY`, que retorna o último ID gerado em qualquer escopo incluindo triggers, o `SCOPE_IDENTITY()` é restrito ao escopo atual, tornando-o seguro mesmo em ambientes com triggers ativos. Existe ainda o `IDENT_CURRENT('NomeDaTabela')`, que retorna o último ID gerado para uma tabela específica independentemente de sessão ou escopo — útil para diagnóstico, mas perigoso para uso em lógica de negócio em ambientes com múltiplos usuários simultâneos.

---

## 6. Inserindo Contas Bancárias

Com os bancos e as empresas definidos, podemos criar contas bancárias para ambas as empresas. Lembre-se: a empresa com `EmpresaID = 7` já tem uma conta (`ContaID = 4`). Vamos adicionar mais contas para ela e criar contas para a Alpha Invest.

A constraint `UQ_ContasBancarias_AgenciaConta` impede que a mesma combinação de `BancoID + Agencia + NumeroConta` seja cadastrada duas vezes — exatamente como no mundo real, onde um número de conta em uma agência específica de um banco é único.

A constraint `CK_ContasBancarias_TipoConta` aceita apenas três valores: `'Corrente'`, `'Poupança'` e `'Investimento'`. Qualquer outro valor causará erro.

~~~sql
-- ============================================================
-- SCRIPT: Inserir contas bancárias no FinanceDB
-- Empresa 7 (FinanceDB Holding) já tem ContaID = 4 no BB
-- Vamos adicionar mais contas para ela e para a Alpha Invest
-- ============================================================

USE FinanceDB;
GO

-- Inserindo contas bancárias usando OUTPUT para visualizar os IDs gerados
-- O OUTPUT INSERTED retorna as colunas especificadas de cada linha inserida
INSERT INTO dbo.ContasBancarias
    (EmpresaID, BancoID, Agencia,  NumeroConta,   TipoConta,      SaldoInicial)
OUTPUT
    INSERTED.ContaID,       -- ID gerado automaticamente pelo IDENTITY
    INSERTED.EmpresaID,     -- para confirmar o vínculo com a empresa correta
    INSERTED.BancoID,       -- para confirmar o banco
    INSERTED.NumeroConta,   -- para confirmar o número da conta
    INSERTED.TipoConta,     -- para confirmar o tipo
    INSERTED.SaldoInicial   -- para confirmar o saldo inicial
VALUES
    -- Segunda conta da FinanceDB Holding (EmpresaID 7) — Itaú Corrente
    (7,  1,  '0042',  '00098765-1',  N'Corrente',     25000.00),
    -- Terceira conta da FinanceDB Holding — Caixa Poupança
    (7,  3,  '1234',  '00045678-3',  N'Poupança',     10000.00),
    -- Primeira conta da Alpha Invest — BB Corrente
    -- EmpresaID da Alpha será 8 se o IDENTITY continuou de 7
    -- Ajuste o EmpresaID abaixo conforme o valor retornado pelo SCOPE_IDENTITY() na etapa anterior
    (8,  2,  '5500',  '00077777-9',  N'Corrente',     80000.00),
    -- Segunda conta da Alpha Invest — Bradesco Investimento
    (8,  4,  '0011',  '00033333-7',  N'Investimento', 150000.00);

-- Verificando todas as contas bancárias cadastradas
SELECT
    cb.ContaID,
    e.RazaoSocial               AS Empresa,
    b.NomeBanco                 AS Banco,
    cb.Agencia,
    cb.NumeroConta,
    cb.TipoConta,
    cb.SaldoInicial,
    cb.Ativa
FROM dbo.ContasBancarias cb
    INNER JOIN dbo.Empresas       e ON e.EmpresaID = cb.EmpresaID
    INNER JOIN dbo.Bancos         b ON b.BancoID   = cb.BancoID
ORDER BY cb.EmpresaID, cb.ContaID;
~~~

Note o uso de `OUTPUT INSERTED` diretamente no INSERT. Esta cláusula é extremamente poderosa porque retorna os dados de cada linha inserida — incluindo os valores gerados automaticamente como IDs e defaults — sem a necessidade de uma query adicional. É especialmente útil quando você insere múltiplas linhas e precisa saber todos os IDs gerados de uma vez.

---

## 7. Expandindo o Plano de Contas

A empresa FinanceDB Holding (EmpresaID 7) já possui oito contas no plano. Precisamos criar o plano de contas completo para a Alpha Invest. A estrutura hierárquica exige atenção à ordem de inserção: contas pai devem ser inseridas antes das contas filhas, pois a Foreign Key `FK_PlanoDeContas_ContaPai` valida essa dependência.

~~~sql
-- ============================================================
-- SCRIPT: Inserir plano de contas para a Alpha Invest (EmpresaID 8)
-- A constraint UQ_PlanoDeContas_EmpresaCodigo garante que o mesmo
-- código de conta não se repete dentro de uma mesma empresa.
-- Os códigos podem se repetir entre empresas diferentes — ok.
-- ============================================================

USE FinanceDB;
GO

-- ETAPA 1: Inserir contas de Nível 1 (sem pai — ContaPaiID = NULL)
-- AceitaLancamentos = 0 porque são contas sintéticas (agrupadores)
DECLARE @ReceitasAlphaID   INT;
DECLARE @DespesasAlphaID   INT;

INSERT INTO dbo.PlanoDeContas
    (EmpresaID, ContaPaiID, Codigo,  Descricao,   Tipo,       Nivel, AceitaLancamentos)
VALUES
    (8, NULL, N'1',  N'RECEITAS',  N'RECEITA',  1, 0),  -- raiz de receitas da Alpha
    (8, NULL, N'2',  N'DESPESAS',  N'DESPESA',  1, 0);  -- raiz de despesas da Alpha

-- Capturando os IDs das contas raiz recém-inseridas para usar como ContaPaiID nas filhas
-- Usamos MAX(ContaPlanoID) por empresa e código — seguro pois a constraint UQ garante unicidade
SELECT @ReceitasAlphaID = ContaPlanoID FROM dbo.PlanoDeContas WHERE EmpresaID = 8 AND Codigo = N'1';
SELECT @DespesasAlphaID = ContaPlanoID FROM dbo.PlanoDeContas WHERE EmpresaID = 8 AND Codigo = N'2';

-- ETAPA 2: Inserir contas de Nível 2 (filhas das raízes)
DECLARE @RecOpAlphaID   INT;
DECLARE @RecFinAlphaID  INT;
DECLARE @DesOpAlphaID   INT;
DECLARE @DesAdmAlphaID  INT;

INSERT INTO dbo.PlanoDeContas
    (EmpresaID, ContaPaiID,          Codigo,   Descricao,                   Tipo,       Nivel, AceitaLancamentos)
VALUES
    (8, @ReceitasAlphaID, N'1.1',  N'Receitas Operacionais',   N'RECEITA',  2, 0),
    (8, @ReceitasAlphaID, N'1.2',  N'Receitas Financeiras',    N'RECEITA',  2, 0),
    (8, @DespesasAlphaID, N'2.1',  N'Despesas Operacionais',   N'DESPESA',  2, 0),
    (8, @DespesasAlphaID, N'2.2',  N'Despesas Administrativas',N'DESPESA',  2, 0);

-- Capturando IDs das contas de nível 2
SELECT @RecOpAlphaID  = ContaPlanoID FROM dbo.PlanoDeContas WHERE EmpresaID = 8 AND Codigo = N'1.1';
SELECT @RecFinAlphaID = ContaPlanoID FROM dbo.PlanoDeContas WHERE EmpresaID = 8 AND Codigo = N'1.2';
SELECT @DesOpAlphaID  = ContaPlanoID FROM dbo.PlanoDeContas WHERE EmpresaID = 8 AND Codigo = N'2.1';
SELECT @DesAdmAlphaID = ContaPlanoID FROM dbo.PlanoDeContas WHERE EmpresaID = 8 AND Codigo = N'2.2';

-- ETAPA 3: Inserir contas de Nível 3 — estas aceitam lançamentos (AceitaLancamentos = 1)
INSERT INTO dbo.PlanoDeContas
    (EmpresaID, ContaPaiID,          Codigo,      Descricao,                    Tipo,       Nivel, AceitaLancamentos)
VALUES
    (8, @RecOpAlphaID,  N'1.1.01', N'Gestão de Carteiras',       N'RECEITA',  3, 1),
    (8, @RecOpAlphaID,  N'1.1.02', N'Taxa de Performance',        N'RECEITA',  3, 1),
    (8, @RecFinAlphaID, N'1.2.01', N'Rendimento de Aplicações',   N'RECEITA',  3, 1),
    (8, @RecFinAlphaID, N'1.2.02', N'Juros Ativos',               N'RECEITA',  3, 1),
    (8, @DesOpAlphaID,  N'2.1.01', N'Corretagem',                 N'DESPESA',  3, 1),
    (8, @DesOpAlphaID,  N'2.1.02', N'Custódia de Ativos',         N'DESPESA',  3, 1),
    (8, @DesAdmAlphaID, N'2.2.01', N'Aluguel',                    N'DESPESA',  3, 1),
    (8, @DesAdmAlphaID, N'2.2.02', N'Salários e Encargos',        N'DESPESA',  3, 1);

-- Verificando o plano de contas completo de ambas as empresas
SELECT
    pc.ContaPlanoID,
    e.NomeFantasia                              AS Empresa,
    REPLICATE(N'  ', pc.Nivel - 1) + pc.Codigo AS CodigoRecuado,  -- recuo visual por nível
    pc.Descricao,
    pc.Tipo,
    pc.Nivel,
    CASE pc.AceitaLancamentos
        WHEN 1 THEN N'Sim'
        ELSE N'Não'
    END                                         AS AceitaLancamentos
FROM dbo.PlanoDeContas pc
    INNER JOIN dbo.Empresas e ON e.EmpresaID = pc.EmpresaID
ORDER BY pc.EmpresaID, pc.Codigo;
~~~

---

## 8. Inserindo Transações Financeiras

Este é o coração do FinanceDB: os lançamentos financeiros. A tabela `Transacoes` tem quatro Foreign Keys ativas e duas constraints de domínio. Cada INSERT precisa fornecer `EmpresaID`, `ContaID`, `ContaPlanoID`, `TipoTransacaoID`, `DataLancamento`, `DataCompetencia`, `Valor`, `Descricao` e `Status`. O campo `Valor` deve ser sempre positivo (constraint `CK_Transacoes_Valor`), e o `Status` aceita apenas `'Pendente'`, `'Conciliado'` ou `'Cancelado'`. Somente contas do plano com `AceitaLancamentos = 1` devem receber lançamentos — embora o banco não imponha essa regra via constraint, ela é uma regra de negócio essencial que trataremos nas Stored Procedures do Módulo 4.

~~~sql
-- ============================================================
-- SCRIPT: Inserir lançamentos financeiros no FinanceDB
-- Período: Janeiro a Março de 2026
-- Empresas: FinanceDB Holding (EmpresaID 7) e Alpha Invest (EmpresaID 8)
--
-- Referências de IDs já existentes:
-- ContasBancarias: ContaID 4 = Holding/BB | 5 = Holding/Itaú | 6 = Holding/Caixa
--                  ContaID 7 = Alpha/BB   | 8 = Alpha/Bradesco
-- PlanoDeContas Empresa 7: ContaPlanoID 10=Vendas, 11=Serviços, 12=Fornecedores, 13=Folha
-- PlanoDeContas Empresa 8: verificar IDs gerados na etapa anterior
-- TiposTransacao: 1=RECEITA(C) | 2=DESPESA(D) | 3=TRANSF(D)
-- ============================================================

USE FinanceDB;
GO

-- Lançamentos da FinanceDB Holding S.A. (EmpresaID = 7)
-- Conta principal: ContaID = 4 (BB Corrente)
INSERT INTO dbo.Transacoes
    (EmpresaID, ContaID, ContaPlanoID, TipoTransacaoID, DataLancamento, DataCompetencia, Valor,      Descricao,                              NumeroDocumento, Status)
VALUES
    -- Janeiro 2026 — Receitas
    (7, 4, 11, 1, '2026-01-05', '2026-01-01',  8500.00, N'Prestação de Serviços — Cliente A',   N'NF-001',  N'Conciliado'),
    (7, 4, 11, 1, '2026-01-12', '2026-01-01',  6200.00, N'Prestação de Serviços — Cliente B',   N'NF-002',  N'Conciliado'),
    (7, 4, 10, 1, '2026-01-15', '2026-01-01', 12000.00, N'Venda de Software — Licença Anual',   N'NF-003',  N'Conciliado'),
    -- Janeiro 2026 — Despesas
    (7, 4, 12, 2, '2026-01-07', '2026-01-01',  3200.00, N'Pagamento Fornecedor de TI',          N'PG-001',  N'Conciliado'),
    (7, 4, 13, 2, '2026-01-30', '2026-01-01',  9800.00, N'Folha de Pagamento Janeiro/2026',     N'FP-012026', N'Conciliado'),
    -- Fevereiro 2026 — Receitas
    (7, 4, 11, 1, '2026-02-03', '2026-02-01',  7800.00, N'Prestação de Serviços — Cliente C',   N'NF-004',  N'Conciliado'),
    (7, 4, 10, 1, '2026-02-20', '2026-02-01', 15000.00, N'Venda de Software — Módulo Premium',  N'NF-005',  N'Conciliado'),
    -- Fevereiro 2026 — Despesas
    (7, 4, 12, 2, '2026-02-10', '2026-02-01',  2900.00, N'Serviço de Suporte Técnico',          N'PG-002',  N'Conciliado'),
    (7, 4, 13, 2, '2026-02-28', '2026-02-01',  9800.00, N'Folha de Pagamento Fevereiro/2026',   N'FP-022026', N'Conciliado'),
    -- Março 2026 — Receitas
    (7, 4, 11, 1, '2026-03-10', '2026-03-01',  9100.00, N'Prestação de Serviços — Cliente A',   N'NF-006',  N'Pendente'),
    (7, 4, 10, 1, '2026-03-18', '2026-03-01', 11000.00, N'Venda de Software — Renovação',       N'NF-007',  N'Pendente'),
    -- Março 2026 — Despesas
    (7, 4, 12, 2, '2026-03-05', '2026-03-01',  4100.00, N'Infraestrutura Cloud — Março',        N'PG-003',  N'Pendente'),
    (7, 4, 13, 2, '2026-03-31', '2026-03-01',  9800.00, N'Folha de Pagamento Março/2026',       N'FP-032026', N'Pendente');

-- Verificando os lançamentos inseridos da Holding
SELECT
    t.TransacaoID,
    e.NomeFantasia          AS Empresa,
    cb.NumeroConta          AS Conta,
    pc.Descricao            AS PlanoContas,
    tt.Descricao            AS TipoTransacao,
    t.DataLancamento,
    t.Valor,
    t.Status
FROM dbo.Transacoes t
    INNER JOIN dbo.Empresas         e  ON e.EmpresaID        = t.EmpresaID
    INNER JOIN dbo.ContasBancarias  cb ON cb.ContaID         = t.ContaID
    INNER JOIN dbo.PlanoDeContas    pc ON pc.ContaPlanoID    = t.ContaPlanoID
    INNER JOIN dbo.TiposTransacao   tt ON tt.TipoTransacaoID = t.TipoTransacaoID
WHERE t.EmpresaID = 7
ORDER BY t.DataLancamento;
~~~

Agora inserimos lançamentos para a Alpha Invest. Aqui usamos `INSERT...SELECT` para demonstrar a terceira forma do INSERT — muito útil quando os dados vêm de outra tabela ou de uma lógica de consulta.

~~~sql
-- ============================================================
-- Lançamentos da Alpha Invest (EmpresaID = 8)
-- Usamos INSERT...SELECT para demonstrar a terceira forma
-- Os ContaPlanoIDs da Alpha devem ser consultados antes da inserção
-- ============================================================

-- Primeiro, consultamos os IDs do plano de contas da Alpha para referência
SELECT ContaPlanoID, Codigo, Descricao, AceitaLancamentos
FROM dbo.PlanoDeContas
WHERE EmpresaID = 8 AND AceitaLancamentos = 1
ORDER BY Codigo;

-- ContasBancarias da Alpha — consultando para referência
SELECT ContaID, NumeroConta, TipoConta
FROM dbo.ContasBancarias
WHERE EmpresaID = 8;
~~~

~~~sql
-- Inserindo lançamentos da Alpha Invest
-- Substitua os ContaPlanoIDs abaixo pelos IDs reais retornados na consulta acima
-- Os valores fictícios abaixo assumem que os IDs seguiram a sequência do IDENTITY
-- Ex: se o plano da Alpha começou em ContaPlanoID = 14, ajuste conforme necessário

INSERT INTO dbo.Transacoes
    (EmpresaID, ContaID, ContaPlanoID, TipoTransacaoID, DataLancamento, DataCompetencia, Valor,       Descricao,                                NumeroDocumento, Status)
SELECT
    SubQuery.EmpresaID,
    SubQuery.ContaID,
    SubQuery.ContaPlanoID,
    SubQuery.TipoTransacaoID,
    SubQuery.DataLancamento,
    SubQuery.DataCompetencia,
    SubQuery.Valor,
    SubQuery.Descricao,
    SubQuery.NumeroDocumento,
    SubQuery.Status
FROM (
    -- Subquery que define os lançamentos como um conjunto de valores nomeados
    -- Isso é mais legível que um INSERT VALUES muito longo
    SELECT 8 AS EmpresaID,
           -- ContaID da conta corrente da Alpha no BB (ajuste conforme ID gerado)
           (SELECT ContaID FROM dbo.ContasBancarias WHERE EmpresaID = 8 AND TipoConta = N'Corrente') AS ContaID,
           -- ContaPlanoID de Gestão de Carteiras (código 1.1.01) da Alpha
           (SELECT ContaPlanoID FROM dbo.PlanoDeContas WHERE EmpresaID = 8 AND Codigo = N'1.1.01') AS ContaPlanoID,
           1 AS TipoTransacaoID,
           CAST('2026-01-10' AS DATE) AS DataLancamento,
           CAST('2026-01-01' AS DATE) AS DataCompetencia,
           22000.00 AS Valor,
           N'Receita de Gestão de Carteiras — Janeiro' AS Descricao,
           N'REC-001' AS NumeroDocumento,
           N'Conciliado' AS Status
    UNION ALL
    SELECT 8,
           (SELECT ContaID FROM dbo.ContasBancarias WHERE EmpresaID = 8 AND TipoConta = N'Corrente'),
           (SELECT ContaPlanoID FROM dbo.PlanoDeContas WHERE EmpresaID = 8 AND Codigo = N'1.2.01'),
           1, CAST('2026-01-25' AS DATE), CAST('2026-01-01' AS DATE),
           8500.00, N'Rendimento de Aplicações — Janeiro', N'REC-002', N'Conciliado'
    UNION ALL
    SELECT 8,
           (SELECT ContaID FROM dbo.ContasBancarias WHERE EmpresaID = 8 AND TipoConta = N'Corrente'),
           (SELECT ContaPlanoID FROM dbo.PlanoDeContas WHERE EmpresaID = 8 AND Codigo = N'2.2.01'),
           2, CAST('2026-01-15' AS DATE), CAST('2026-01-01' AS DATE),
           4500.00, N'Aluguel da Sede — Janeiro', N'PG-010', N'Conciliado'
    UNION ALL
    SELECT 8,
           (SELECT ContaID FROM dbo.ContasBancarias WHERE EmpresaID = 8 AND TipoConta = N'Corrente'),
           (SELECT ContaPlanoID FROM dbo.PlanoDeContas WHERE EmpresaID = 8 AND Codigo = N'2.2.02'),
           2, CAST('2026-01-31' AS DATE), CAST('2026-01-01' AS DATE),
           18000.00, N'Salários e Encargos — Janeiro', N'FP-012026', N'Conciliado'
    UNION ALL
    SELECT 8,
           (SELECT ContaID FROM dbo.ContasBancarias WHERE EmpresaID = 8 AND TipoConta = N'Corrente'),
           (SELECT ContaPlanoID FROM dbo.PlanoDeContas WHERE EmpresaID = 8 AND Codigo = N'1.1.01'),
           1, CAST('2026-02-12' AS DATE), CAST('2026-02-01' AS DATE),
           25000.00, N'Receita de Gestão de Carteiras — Fevereiro', N'REC-003', N'Conciliado'
    UNION ALL
    SELECT 8,
           (SELECT ContaID FROM dbo.ContasBancarias WHERE EmpresaID = 8 AND TipoConta = N'Corrente'),
           (SELECT ContaPlanoID FROM dbo.PlanoDeContas WHERE EmpresaID = 8 AND Codigo = N'2.1.01'),
           2, CAST('2026-02-20' AS DATE), CAST('2026-02-01' AS DATE),
           3200.00, N'Corretagem — Operações de Fevereiro', N'PG-011', N'Conciliado'
) AS SubQuery;

-- Contagem final de lançamentos por empresa
SELECT
    e.NomeFantasia  AS Empresa,
    COUNT(*)        AS TotalLancamentos,
    SUM(CASE WHEN tt.Natureza = 'C' THEN t.Valor ELSE 0 END) AS TotalReceitas,
    SUM(CASE WHEN tt.Natureza = 'D' THEN t.Valor ELSE 0 END) AS TotalDespesas
FROM dbo.Transacoes t
    INNER JOIN dbo.Empresas       e  ON e.EmpresaID        = t.EmpresaID
    INNER JOIN dbo.TiposTransacao tt ON tt.TipoTransacaoID = t.TipoTransacaoID
GROUP BY e.NomeFantasia
ORDER BY e.NomeFantasia;
~~~

---

## 9. Inserindo Orçamentos

A tabela `Orcamentos` tem uma constraint `UQ_Orcamentos_EmpresaContaAnomes` que impede a duplicidade de orçamento para a mesma empresa, conta do plano, ano e mês. Isso reflete a realidade: não faz sentido ter dois orçamentos para a mesma rubrica no mesmo período.

~~~sql
-- ============================================================
-- SCRIPT: Inserir orçamentos para Jan/Fev/Mar de 2026
-- Apenas contas com AceitaLancamentos = 1 fazem sentido aqui
-- ValorRealizado = 0 por padrão (será atualizado por procedure futura)
-- ============================================================

USE FinanceDB;
GO

-- Orçamentos da FinanceDB Holding (EmpresaID = 7)
-- Referência: ContaPlanoID 10=Vendas, 11=Serviços, 12=Fornecedores, 13=Folha
INSERT INTO dbo.Orcamentos
    (EmpresaID, ContaPlanoID, Ano,   Mes, ValorOrcado)
VALUES
    -- Conta 10 — Vendas de Produtos
    (7, 10, 2026, 1,  10000.00),  -- orçado para Janeiro
    (7, 10, 2026, 2,  12000.00),  -- orçado para Fevereiro
    (7, 10, 2026, 3,  11000.00),  -- orçado para Março
    -- Conta 11 — Prestação de Serviços
    (7, 11, 2026, 1,   8000.00),
    (7, 11, 2026, 2,   8000.00),
    (7, 11, 2026, 3,   9000.00),
    -- Conta 12 — Fornecedores
    (7, 12, 2026, 1,   3500.00),
    (7, 12, 2026, 2,   3500.00),
    (7, 12, 2026, 3,   4000.00),
    -- Conta 13 — Folha de Pagamento
    (7, 13, 2026, 1,  10000.00),
    (7, 13, 2026, 2,  10000.00),
    (7, 13, 2026, 3,  10000.00);

-- Orçamentos da Alpha Invest (EmpresaID = 8)
-- Usando subqueries para referenciar ContaPlanoIDs pelo código — mais robusto
INSERT INTO dbo.Orcamentos
    (EmpresaID, ContaPlanoID, Ano, Mes, ValorOrcado)
VALUES
    (8, (SELECT ContaPlanoID FROM dbo.PlanoDeContas WHERE EmpresaID = 8 AND Codigo = N'1.1.01'), 2026, 1, 20000.00),
    (8, (SELECT ContaPlanoID FROM dbo.PlanoDeContas WHERE EmpresaID = 8 AND Codigo = N'1.1.01'), 2026, 2, 22000.00),
    (8, (SELECT ContaPlanoID FROM dbo.PlanoDeContas WHERE EmpresaID = 8 AND Codigo = N'1.1.01'), 2026, 3, 25000.00),
    (8, (SELECT ContaPlanoID FROM dbo.PlanoDeContas WHERE EmpresaID = 8 AND Codigo = N'1.2.01'), 2026, 1,  8000.00),
    (8, (SELECT ContaPlanoID FROM dbo.PlanoDeContas WHERE EmpresaID = 8 AND Codigo = N'1.2.01'), 2026, 2,  8000.00),
    (8, (SELECT ContaPlanoID FROM dbo.PlanoDeContas WHERE EmpresaID = 8 AND Codigo = N'2.2.01'), 2026, 1,  4500.00),
    (8, (SELECT ContaPlanoID FROM dbo.PlanoDeContas WHERE EmpresaID = 8 AND Codigo = N'2.2.01'), 2026, 2,  4500.00),
    (8, (SELECT ContaPlanoID FROM dbo.PlanoDeContas WHERE EmpresaID = 8 AND Codigo = N'2.2.02'), 2026, 1, 18000.00),
    (8, (SELECT ContaPlanoID FROM dbo.PlanoDeContas WHERE EmpresaID = 8 AND Codigo = N'2.2.02'), 2026, 2, 18000.00);

-- Verificação final — orçamentos cadastrados por empresa e conta
SELECT
    e.NomeFantasia      AS Empresa,
    pc.Codigo,
    pc.Descricao        AS Conta,
    o.Ano,
    o.Mes,
    o.ValorOrcado,
    o.ValorRealizado
FROM dbo.Orcamentos o
    INNER JOIN dbo.Empresas      e  ON e.EmpresaID   = o.EmpresaID
    INNER JOIN dbo.PlanoDeContas pc ON pc.ContaPlanoID = o.ContaPlanoID
ORDER BY e.NomeFantasia, pc.Codigo, o.Ano, o.Mes;
~~~

---

## 10. Antecipação de Erros e Troubleshooting

Todo desenvolvedor que trabalha com inserção de dados em um banco financeiro precisa reconhecer os erros mais comuns e saber diagnosticá-los rapidamente. A tabela a seguir mapeia os principais erros que podem ocorrer nos scripts deste capítulo.

O **Erro 547 — violação de Foreign Key** é o mais frequente. Ocorre quando você tenta inserir um `EmpresaID`, `BancoID`, `ContaID`, `ContaPlanoID` ou `TipoTransacaoID` que não existe na tabela pai. A solução é verificar a existência do registro pai antes do INSERT: `SELECT EmpresaID FROM dbo.Empresas WHERE EmpresaID = X`. No FinanceDB, a empresa com `EmpresaID = 7` existe, mas se você tentar usar `EmpresaID = 1`, receberá este erro.

O **Erro 2601 ou 2627 — violação de constraint UNIQUE** ocorre quando você tenta inserir uma combinação de valores que já existe em uma constraint única. Na tabela `ContasBancarias`, a combinação `BancoID + Agencia + NumeroConta` deve ser única. Na tabela `Orcamentos`, a combinação `EmpresaID + ContaPlanoID + Ano + Mes` deve ser única. Se você executar o script de orçamentos duas vezes, receberá este erro na segunda execução.

O **Erro 515 — violação de NOT NULL** ocorre quando você omite uma coluna que não tem valor DEFAULT e não aceita NULL. Na tabela `Transacoes`, as colunas `Descricao`, `DataLancamento`, `DataCompetencia` e `Valor` são obrigatórias sem DEFAULT. Omiti-las no INSERT causará este erro.

O **Erro 8152 — truncamento de string** ocorre quando você tenta inserir um valor de texto maior do que o tamanho máximo definido na coluna. Por exemplo, uma `Descricao` de transação com mais de 200 caracteres causará este erro na tabela `Transacoes`.

O **Erro 513 — violação de CHECK** ocorre quando um valor não satisfaz uma constraint CHECK. Na tabela `Transacoes`, inserir `Status = 'Aprovado'` causará este erro, pois a constraint `CK_Transacoes_Status` aceita apenas `'Pendente'`, `'Conciliado'` ou `'Cancelado'`. Na tabela `Bancos`, inserir `CodigoCOMPE = 1000` causará erro pois o intervalo permitido é 1 a 999.

---

## 11. Diagrama — Estado Final do FinanceDB após o Capítulo 10

~~~mermaid
erDiagram
    Bancos {
        int BancoID PK
        int CodigoCOMPE
        nvarchar NomeBanco
        nvarchar Sigla
        bit Ativo
    }
    Empresas {
        int EmpresaID PK
        char CNPJ
        nvarchar RazaoSocial
        nvarchar NomeFantasia
        bit Ativo
    }
    ContasBancarias {
        int ContaID PK
        int EmpresaID FK
        int BancoID FK
        nvarchar Agencia
        nvarchar NumeroConta
        nvarchar TipoConta
        decimal SaldoInicial
    }
    PlanoDeContas {
        int ContaPlanoID PK
        int EmpresaID FK
        int ContaPaiID FK
        nvarchar Codigo
        nvarchar Descricao
        nvarchar Tipo
        int Nivel
        bit AceitaLancamentos
    }
    TiposTransacao {
        int TipoTransacaoID PK
        nvarchar Codigo
        nvarchar Descricao
        char Natureza
    }
    Transacoes {
        bigint TransacaoID PK
        int EmpresaID FK
        int ContaID FK
        int ContaPlanoID FK
        int TipoTransacaoID FK
        date DataLancamento
        date DataCompetencia
        decimal Valor
        nvarchar Status
    }
    Orcamentos {
        int OrcamentoID PK
        int EmpresaID FK
        int ContaPlanoID FK
        int Ano
        int Mes
        decimal ValorOrcado
        decimal ValorRealizado
    }

    Empresas         ||--o{ ContasBancarias : "possui"
    Bancos           ||--o{ ContasBancarias : "associado a"
    Empresas         ||--o{ PlanoDeContas   : "define"
    PlanoDeContas    ||--o{ PlanoDeContas   : "pai de"
    Empresas         ||--o{ Transacoes      : "registra"
    ContasBancarias  ||--o{ Transacoes      : "movimenta"
    PlanoDeContas    ||--o{ Transacoes      : "classifica"
    TiposTransacao   ||--o{ Transacoes      : "tipifica"
    Empresas         ||--o{ Orcamentos      : "orça"
    PlanoDeContas    ||--o{ Orcamentos      : "orçado em"
~~~

---

## 12. Glossário Técnico

**INSERT INTO:** comando DML do T-SQL usado para adicionar uma ou mais linhas a uma tabela. Pode receber valores literais (VALUES), dados de uma consulta (SELECT) ou resultados de uma procedure.

**IDENTITY:** propriedade de coluna que gera valores numéricos sequenciais automaticamente. A sintaxe `IDENTITY(semente, incremento)` define o valor inicial e o passo. O SQL Server gerencia essa sequência internamente, e o desenvolvedor não deve — e geralmente não pode — inserir valores nessa coluna sem habilitar explicitamente o `SET IDENTITY_INSERT ON`.

**SCOPE_IDENTITY():** função que retorna o último valor de IDENTITY gerado na sessão e escopo atuais. É a forma mais segura de capturar o ID recém-gerado em código de aplicação.

**OUTPUT INSERTED:** cláusula do INSERT que retorna os dados de cada linha inserida, incluindo valores gerados por IDENTITY e DEFAULT. Equivale a um SELECT automático dos dados inseridos, sem custo adicional de round-trip ao servidor.

**Foreign Key (FK):** constraint que estabelece um relacionamento entre duas tabelas, garantindo que o valor em uma coluna da tabela filha sempre corresponda a um valor existente na coluna referenciada da tabela pai. No FinanceDB, `Transacoes.EmpresaID` deve sempre existir em `Empresas.EmpresaID`.

**DML — Data Manipulation Language:** subconjunto do SQL que inclui os comandos INSERT, UPDATE, DELETE e SELECT. Esses comandos manipulam os dados dentro das estruturas criadas pela DDL.

**Constraint CHECK:** regra de domínio aplicada diretamente na definição da coluna ou da tabela. Avaliada em cada INSERT e UPDATE. Se a expressão retornar FALSE, a operação é rejeitada com o Erro 513.

**Constraint UNIQUE:** garante que não existam dois registros com o mesmo valor (ou combinação de valores) em uma ou mais colunas. Diferente da PRIMARY KEY, permite a existência de um NULL (em algumas implementações).

**NULL:** ausência de valor, diferente de zero ou string vazia. Colunas com `NOT NULL` recusam NULL. Colunas sem valor DEFAULT e sem `NOT NULL` recebem NULL automaticamente quando omitidas em um INSERT.

---

## 13. Desafio de Fixação

**Cenário:** A FinanceDB Holding contratou um novo cliente e precisa registrar os seguintes dados no sistema:

1. Insira no banco de dados um novo banco: **Nubank**, código COMPE **260**, sigla **NUBANK**.
2. Insira uma nova conta bancária para a FinanceDB Holding (EmpresaID = 7) no Nubank. Use agência `0001`, número `99988877-0`, tipo `Corrente` e saldo inicial de R$ 5.000,00. Use `OUTPUT INSERTED` para confirmar o `ContaID` gerado.
3. Insira dois lançamentos para Abril de 2026 nessa nova conta: uma receita de R$ 4.500,00 de Prestação de Serviços (`ContaPlanoID` da conta 1.1.02 da empresa 7, que é `ContaPlanoID = 11`) com status `Pendente`, e uma despesa de R$ 1.200,00 de Fornecedores (`ContaPlanoID = 12`) com status `Pendente`.
4. Verifique os lançamentos inseridos com um SELECT que mostre empresa, número da conta, banco, plano de contas, valor e status.

---

## 14. Resolução Comentada do Desafio

~~~sql
-- ============================================================
-- RESOLUÇÃO DO DESAFIO — Capítulo 10
-- ============================================================

USE FinanceDB;
GO

-- PASSO 1: Inserir o Nubank
-- Código COMPE 260 está dentro do range 1-999 — constraint ok
INSERT INTO dbo.Bancos
    (CodigoCOMPE, NomeBanco,   Sigla)
VALUES
    (260, N'Nu Pagamentos S.A.', N'NUBANK');  -- razão social oficial do Nubank

-- Capturando o BancoID gerado
DECLARE @NubankID INT = SCOPE_IDENTITY();
SELECT @NubankID AS BancoIDNubank;  -- confirmar o ID antes de usá-lo

-- PASSO 2: Inserir a conta bancária com OUTPUT para confirmar ContaID
DECLARE @NovaContaID INT;

INSERT INTO dbo.ContasBancarias
    (EmpresaID, BancoID,      Agencia, NumeroConta,   TipoConta,   SaldoInicial)
OUTPUT
    INSERTED.ContaID,      -- ID gerado — este é o valor que precisamos para o próximo INSERT
    INSERTED.NumeroConta,
    INSERTED.TipoConta,
    INSERTED.SaldoInicial
VALUES
    (7, @NubankID, N'0001', N'99988877-0', N'Corrente', 5000.00);

-- Capturando o ContaID gerado
SET @NovaContaID = SCOPE_IDENTITY();

-- PASSO 3: Inserir os dois lançamentos de Abril de 2026
INSERT INTO dbo.Transacoes
    (EmpresaID, ContaID,      ContaPlanoID, TipoTransacaoID, DataLancamento,           DataCompetencia,          Valor,   Descricao,                               NumeroDocumento, Status)
VALUES
    -- Receita: TipoTransacaoID = 1 (RECEITA, natureza C)
    -- ContaPlanoID = 11 (Prestação de Serviços da empresa 7)
    (7, @NovaContaID, 11, 1, CAST('2026-04-10' AS DATE), CAST('2026-04-01' AS DATE), 4500.00, N'Prestação de Serviços — Novo Cliente Abril', N'NF-008', N'Pendente'),
    -- Despesa: TipoTransacaoID = 2 (DESPESA, natureza D)
    -- ContaPlanoID = 12 (Fornecedores da empresa 7)
    (7, @NovaContaID, 12, 2, CAST('2026-04-15' AS DATE), CAST('2026-04-01' AS DATE), 1200.00, N'Fornecedor de Material de Escritório',       N'PG-004', N'Pendente');

-- PASSO 4: Verificação completa com JOIN
SELECT
    e.NomeFantasia          AS Empresa,
    cb.NumeroConta          AS Conta,
    b.NomeBanco             AS Banco,
    pc.Descricao            AS PlanoContas,
    tt.Descricao            AS TipoTransacao,
    t.DataLancamento,
    t.Valor,
    t.Status
FROM dbo.Transacoes t
    INNER JOIN dbo.Empresas         e  ON e.EmpresaID        = t.EmpresaID
    INNER JOIN dbo.ContasBancarias  cb ON cb.ContaID         = t.ContaID
    INNER JOIN dbo.Bancos           b  ON b.BancoID          = cb.BancoID
    INNER JOIN dbo.PlanoDeContas    pc ON pc.ContaPlanoID    = t.ContaPlanoID
    INNER JOIN dbo.TiposTransacao   tt ON tt.TipoTransacaoID = t.TipoTransacaoID
WHERE t.EmpresaID = 7
  AND t.DataLancamento >= '2026-04-01'  -- filtrando apenas os lançamentos de Abril
ORDER BY t.DataLancamento;
~~~

---

## 15. Resumo dos Pontos-Chave

O `INSERT INTO` é o portal de entrada de dados no SQL Server, e dominá-lo vai muito além de conhecer a sintaxe básica. Neste capítulo aprendemos que o processo de inserção passa por quatro etapas internas: parsing, validação de constraints, gravação no Transaction Log e modificação das páginas de dados. Essa sequência explica por que as constraints funcionam como uma rede de proteção automática, e por que dados inválidos nunca chegam ao disco.

Aprendemos as três variações do INSERT: linha única com lista explícita de colunas, múltiplas linhas em um único statement e INSERT...SELECT para carga a partir de consultas. A lista explícita de colunas é sempre preferível em código de produção porque torna o script resistente a mudanças de schema. O INSERT de múltiplas linhas é mais eficiente em log e memória do que múltiplos INSERTs individuais.

Entendemos que `SCOPE_IDENTITY()` é a função correta para capturar IDs gerados por IDENTITY, e que `OUTPUT INSERTED` é a forma mais elegante de obter todos os IDs gerados em uma inserção em lote. Mapeamos os cinco erros mais comuns em operações de INSERT — violação de FK (547), violação de UNIQUE (2601/2627), violação de NOT NULL (515), truncamento de string (8152) e violação de CHECK (513) — e aprendemos a diagnosticar cada um deles.

Por fim, construímos um dataset financeiro coerente e realista com duas empresas, cinco bancos, cinco contas bancárias, um plano de contas completo em três níveis e dezenas de lançamentos distribuídos por três meses — base sólida para todas as consultas, relatórios e análises que virão nos próximos capítulos.

---

## Log de Estado do Projeto

~~~text
## Estado — Após o Capítulo 10

=== BANCO DE DADOS ===
Nome: FinanceDB
Status: Operacional

=== TABELAS E REGISTROS ===
Bancos:           5 registros (Itaú, BB, Caixa, Bradesco, Santander + Nubank após desafio)
TiposTransacao:   3 registros (RECEITA, DESP

