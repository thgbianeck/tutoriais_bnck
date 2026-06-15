# Capítulo 9: Chaves Primárias e Estrangeiras — PRIMARY KEY, FOREIGN KEY e IDENTITY
## Livro: SQL Server para Aplicações Financeiras com T-SQL
## Módulo 2 — ESSENCIAL: T-SQL Básico

---

## Análise de Integridade

✅ Conteúdo verificado: profundidade técnica mantida, linguagem acessível pela Técnica de Feynman, narrativa com mínimo de 2.000 palavras, analogia de ancoragem presente, diagrama Mermaid incluído, glossário técnico completo, antecipação de erros mapeada, desafio de fixação com resolução comentada, log de estado atualizado e prompt de continuidade gerado.

---

## Resumo do Capítulo Anterior

No **Capítulo 8** criamos as primeiras tabelas físicas do FinanceDB: **Empresas**, **Bancos** e **TiposTransacao**. Aplicamos as três constraints básicas — **NOT NULL** para garantir que colunas obrigatórias jamais recebam valor vazio, **DEFAULT** para preencher automaticamente valores padrão quando o INSERT não os especifica, e **CHECK** para impor regras de domínio diretamente na estrutura da tabela. Aprendemos que todas as constraints devem ser nomeadas explicitamente para facilitar manutenção e diagnóstico de erros. Populamos as tabelas com dados reais: os bancos Itaú (341), Banco do Brasil (1) e Caixa (104), e os tipos de transação RECEITA, DESPESA e TRANSF.

---

## Objetivo

Implementar **integridade referencial completa** no FinanceDB criando as quatro tabelas restantes do projeto: **ContasBancarias**, **PlanoDeContas**, **Transacoes** e **Orcamentos**. Compreender como a **PRIMARY KEY** identifica unicamente cada linha de uma tabela, como o **IDENTITY** gera automaticamente valores únicos e sequenciais para os identificadores, como a **FOREIGN KEY** cria vínculos formais entre tabelas e como as ações referenciais **ON DELETE** e **ON UPDATE** controlam o comportamento do banco quando um registro pai é alterado ou removido. Ao final deste capítulo, o modelo físico completo do FinanceDB estará implementado e verificado nas views de catálogo do SQL Server.

---

## Pré-requisitos

**Capítulo 8 concluído.** As tabelas Empresas, Bancos e TiposTransacao devem estar criadas no banco FinanceDB com suas constraints NOT NULL, DEFAULT e CHECK. Os dados de Bancos e TiposTransacao devem estar populados conforme o capítulo anterior.

---

## Teoria Detalhada

### A Analogia de Ancoragem: O Sistema de Identidade Civil e os Registros Cartoriais

Imagine o seguinte cenário: você nasce e o cartório emite uma certidão de nascimento com um número único — o CPF. Esse número é a sua **PRIMARY KEY** no "banco de dados da sociedade". Nenhuma outra pessoa no Brasil terá aquele mesmo CPF. Se você tentar registrar dois cidadãos com o mesmo CPF, o sistema rejeita imediatamente. O CPF é imutável, único e obrigatório — exatamente como uma chave primária bem projetada.

Agora, quando você abre uma conta bancária, o banco não precisa saber toda a sua história de vida. Ele simplesmente guarda o seu CPF em um campo chamado `cpf_titular`. Esse campo é uma **FOREIGN KEY** — uma referência ao registro que existe na tabela de cidadãos. Se você tentar abrir uma conta com um CPF que não existe no cadastro de cidadãos, o banco rejeita. Se o registro do cidadão for excluído do sistema, o banco precisará decidir o que fazer com a conta vinculada — e essa decisão é exatamente o que as **ações referenciais** ON DELETE e ON UPDATE controlam.

O **IDENTITY** é o cartório eletrônico: cada vez que um novo cidadão nasce, o sistema gera automaticamente o próximo número disponível na sequência, sem intervenção humana. Você não precisa descobrir qual foi o último CPF emitido — o próprio sistema cuida disso.

---

### PRIMARY KEY: A Identidade Irrefutável de Cada Linha

A **PRIMARY KEY** é a constraint mais fundamental de qualquer tabela relacional. Ela tem três responsabilidades simultâneas: garantir **unicidade** (não existirão duas linhas com o mesmo valor), garantir **não-nulidade** (a coluna jamais poderá ser NULL) e servir como **âncora de referência** para as chaves estrangeiras de outras tabelas.

Internamente, quando você define uma PRIMARY KEY no SQL Server, ele automaticamente cria um **índice Clustered** sobre aquela coluna — a menos que você instrua o contrário. Isso significa que as linhas da tabela são fisicamente armazenadas no disco na ordem da chave primária. Para tabelas de transações financeiras, esse comportamento tem impacto direto na performance de consultas por ID.

Uma PRIMARY KEY pode ser **simples** (uma única coluna) ou **composta** (duas ou mais colunas combinadas). No FinanceDB, todas as tabelas usarão chaves primárias simples baseadas em colunas INT IDENTITY, o que é a abordagem mais comum e eficiente para sistemas OLTP (Online Transaction Processing) — categoria na qual um sistema financeiro corporativo se enquadra.

---

### IDENTITY: O Gerador Automático de Identificadores

O **IDENTITY** é uma propriedade de coluna, não uma constraint isolada. Ele instrui o SQL Server a gerar automaticamente um valor numérico sequencial para cada nova linha inserida. A sintaxe é `IDENTITY(semente, incremento)`, onde a semente é o valor do primeiro registro e o incremento é o passo entre cada valor gerado.

A configuração mais comum — e a que usaremos no FinanceDB — é `IDENTITY(1, 1)`: começa em 1 e incrementa de 1 em 1. Isso significa que o primeiro registro terá ID 1, o segundo terá ID 2, o terceiro terá ID 3, e assim por diante.

Três comportamentos críticos do IDENTITY que você precisa conhecer para a certificação:

Primeiro, **o IDENTITY nunca reutiliza valores**. Se você inserir um registro com ID 5 e depois excluí-lo, o próximo registro inserido receberá ID 6, não 5. Isso é intencional — garante que IDs excluídos não sejam reutilizados, evitando confusão em logs de auditoria.

Segundo, **você não pode inserir valores manualmente em uma coluna IDENTITY** sem antes executar `SET IDENTITY_INSERT NomeTabela ON`. Essa operação é usada em cenários específicos de migração de dados e deve ser revertida com `SET IDENTITY_INSERT NomeTabela OFF` imediatamente após.

Terceiro, **para descobrir o ID gerado pelo último INSERT**, use a função `SCOPE_IDENTITY()`. Essa função retorna o último valor IDENTITY gerado na sessão e escopo atual — essencial em Stored Procedures que precisam encadear inserções em tabelas relacionadas.

---

### FOREIGN KEY: O Vínculo Formal Entre Tabelas

A **FOREIGN KEY** é a implementação física do relacionamento entre tabelas que existia apenas como linha no diagrama ER. Quando você cria uma FK, o SQL Server passa a verificar automaticamente — a cada INSERT, UPDATE e DELETE — se o valor referenciado existe na tabela pai.

A estrutura de uma FOREIGN KEY exige três elementos: a **coluna filha** (que contém o valor de referência), a **tabela pai** (onde o valor deve existir) e a **coluna pai** (que deve ter uma PRIMARY KEY ou UNIQUE constraint). Sem esses três elementos, a FK não pode ser criada.

Uma FK impõe **integridade referencial** nos dois sentidos: você não pode inserir na tabela filha um valor que não existe na tabela pai (violação de inserção), e você não pode excluir da tabela pai um registro que ainda tem filhos na tabela filha (violação de exclusão) — a menos que uma ação referencial permita isso.

---

### Ações Referenciais: ON DELETE e ON UPDATE

Quando um registro pai é excluído ou atualizado, o SQL Server precisa saber o que fazer com os registros filhos que o referenciam. As **ações referenciais** definem esse comportamento. Existem quatro opções disponíveis:

**NO ACTION** é o padrão. Se você tentar excluir ou atualizar um registro pai que possui filhos, o SQL Server rejeita a operação com um erro de violação de FK. O nome "NO ACTION" é enganoso — na prática, ele **impede** a operação.

**CASCADE** propaga automaticamente a alteração para os filhos. Se o pai for excluído, todos os filhos são excluídos. Se o ID do pai for atualizado, todos os filhos têm o valor de FK atualizado automaticamente. Em sistemas financeiros, CASCADE na exclusão é perigoso — você poderia excluir um Banco e perder automaticamente todas as ContasBancarias e todas as Transacoes vinculadas a elas.

**SET NULL** define o campo FK dos filhos como NULL quando o pai é excluído ou atualizado. Só é válido se a coluna FK admitir NULL. Em sistemas financeiros, isso raramente faz sentido — uma Transacao sem ContaBancaria é um dado inconsistente.

**SET DEFAULT** define o campo FK dos filhos com o valor DEFAULT da coluna quando o pai é excluído ou atualizado. Raramente utilizado na prática.

No **FinanceDB**, usaremos **NO ACTION** (o padrão) em todas as FKs. Essa decisão é deliberada: em um sistema financeiro, nenhuma exclusão deve ser propagada automaticamente. Excluir um Banco não deve excluir contas. Excluir uma conta não deve excluir transações. A integridade histórica dos dados financeiros é inviolável.

---

### A Regra de Ouro: Ordem de Criação das Tabelas

Quando tabelas têm FKs entre si, a **ordem de criação importa**. Você não pode criar uma FK referenciando uma tabela que ainda não existe. A regra é simples: **tabelas pai sempre antes das tabelas filhas**.

No FinanceDB, a hierarquia de dependências é:

- Empresas e Bancos não dependem de ninguém → criadas no Capítulo 8
- TiposTransacao não depende de ninguém → criada no Capítulo 8
- ContasBancarias depende de Empresas e Bancos → cria agora
- PlanoDeContas depende de Empresas (e de si mesma, para hierarquia) → cria agora
- Transacoes depende de ContasBancarias, PlanoDeContas e TiposTransacao → cria por último
- Orcamentos depende de Empresas e PlanoDeContas → cria depois de PlanoDeContas

---

## Diagrama do Modelo Físico Completo

~~~mermaid
erDiagram
    Empresas {
        int EmpresaID PK
        nvarchar RazaoSocial
        nvarchar CNPJ
        bit Ativo
    }
    Bancos {
        int BancoID PK
        int CodigoBanco
        nvarchar NomeBanco
        bit Ativo
    }
    TiposTransacao {
        int TipoTransacaoID PK
        nvarchar Descricao
        nvarchar Natureza
    }
    ContasBancarias {
        int ContaID PK
        int EmpresaID FK
        int BancoID FK
        nvarchar Agencia
        nvarchar NumeroConta
        nvarchar TipoConta
        decimal SaldoInicial
        bit Ativa
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
    Transacoes {
        int TransacaoID PK
        int EmpresaID FK
        int ContaID FK
        int ContaPlanoID FK
        int TipoTransacaoID FK
        date DataLancamento
        date DataCompetencia
        decimal Valor
        nvarchar Descricao
        nvarchar NumerDocumento
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

    Empresas ||--o{ ContasBancarias : "possui"
    Bancos ||--o{ ContasBancarias : "abriga"
    Empresas ||--o{ PlanoDeContas : "define"
    PlanoDeContas ||--o{ PlanoDeContas : "hierarquia pai-filho"
    Empresas ||--o{ Transacoes : "registra"
    ContasBancarias ||--o{ Transacoes : "movimenta"
    PlanoDeContas ||--o{ Transacoes : "categoriza"
    TiposTransacao ||--o{ Transacoes : "classifica"
    Empresas ||--o{ Orcamentos : "planeja"
    PlanoDeContas ||--o{ Orcamentos : "orça"
~~~

---

## Implementação: Criando as Tabelas com PRIMARY KEY e FOREIGN KEY

### Passo 1: Confirmar o contexto

~~~sql
-- Sempre comece garantindo que está no banco correto
-- Evita criar objetos no master ou em outro banco por engano
USE FinanceDB;
GO

-- Verificar as tabelas já existentes antes de criar as novas
-- sys.tables lista todas as tabelas do banco atual
SELECT
    name AS NomeTabela,
    create_date AS DataCriacao
FROM sys.tables
ORDER BY create_date;
-- Resultado esperado: Empresas, Bancos, TiposTransacao
~~~

---

### Passo 2: Criar a tabela ContasBancarias

~~~sql
-- ContasBancarias: depende de Empresas e Bancos
-- EmpresaID referencia Empresas.EmpresaID
-- BancoID referencia Bancos.BancoID
CREATE TABLE dbo.ContasBancarias
(
    -- Chave primária com IDENTITY: geração automática de IDs
    -- INT comporta até 2.147.483.647 registros — mais que suficiente
    ContaID         INT             NOT NULL IDENTITY(1,1),

    -- FK para Empresas: toda conta pertence a uma empresa
    EmpresaID       INT             NOT NULL,

    -- FK para Bancos: toda conta está vinculada a um banco
    BancoID         INT             NOT NULL,

    -- Agência bancária: formato variável, até 10 caracteres
    Agencia         NVARCHAR(10)    NOT NULL,

    -- Número da conta com dígito verificador
    NumeroConta     NVARCHAR(20)    NOT NULL,

    -- Tipo de conta: Corrente, Poupança ou Investimento
    TipoConta       NVARCHAR(20)    NOT NULL
        CONSTRAINT CK_ContasBancarias_TipoConta
        CHECK (TipoConta IN (N'Corrente', N'Poupança', N'Investimento')),

    -- Saldo inicial no momento do cadastro da conta no sistema
    -- DECIMAL(18,2): 18 dígitos no total, 2 casas decimais
    -- DEFAULT 0.00: conta pode ser cadastrada com saldo zero
    SaldoInicial    DECIMAL(18,2)   NOT NULL
        CONSTRAINT DF_ContasBancarias_SaldoInicial DEFAULT (0.00),

    -- Data em que a conta foi cadastrada no sistema
    -- GETDATE() registra automaticamente o momento do INSERT
    DataCadastro    DATETIME2(0)    NOT NULL
        CONSTRAINT DF_ContasBancarias_DataCadastro DEFAULT (GETDATE()),

    -- Flag de atividade: 1 = conta ativa, 0 = conta encerrada
    Ativa           BIT             NOT NULL
        CONSTRAINT DF_ContasBancarias_Ativa DEFAULT (1),

    -- Definição da PRIMARY KEY com nome explícito
    CONSTRAINT PK_ContasBancarias
        PRIMARY KEY CLUSTERED (ContaID),

    -- FK para Empresas: NO ACTION impede exclusão de empresa com contas
    CONSTRAINT FK_ContasBancarias_Empresas
        FOREIGN KEY (EmpresaID)
        REFERENCES dbo.Empresas (EmpresaID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    -- FK para Bancos: NO ACTION impede exclusão de banco com contas vinculadas
    CONSTRAINT FK_ContasBancarias_Bancos
        FOREIGN KEY (BancoID)
        REFERENCES dbo.Bancos (BancoID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    -- Constraint de unicidade: não podem existir duas contas iguais
    -- no mesmo banco com a mesma agência e número de conta
    CONSTRAINT UQ_ContasBancarias_AgenciaConta
        UNIQUE (BancoID, Agencia, NumeroConta)
);
GO
~~~

---

### Passo 3: Criar a tabela PlanoDeContas

~~~sql
-- PlanoDeContas: depende de Empresas e de si mesma (auto-relacionamento)
-- ContaPaiID referencia PlanoDeContas.ContaPlanoID
-- Isso cria a hierarquia de contas (pai -> filho -> neto)
CREATE TABLE dbo.PlanoDeContas
(
    -- Chave primária com IDENTITY
    ContaPlanoID        INT             NOT NULL IDENTITY(1,1),

    -- FK para Empresas: cada conta do plano pertence a uma empresa
    EmpresaID           INT             NOT NULL,

    -- Auto-relacionamento: ContaPaiID aponta para outro registro
    -- da mesma tabela, criando a hierarquia pai-filho
    -- NULL indica que é uma conta raiz (sem pai)
    ContaPaiID          INT             NULL,

    -- Código contábil: ex. "1", "1.1", "1.1.01", "1.1.01.001"
    Codigo              NVARCHAR(20)    NOT NULL,

    -- Descrição legível da conta contábil
    Descricao           NVARCHAR(100)   NOT NULL,

    -- Tipo: RECEITA ou DESPESA — natureza da conta
    Tipo                NVARCHAR(10)    NOT NULL
        CONSTRAINT CK_PlanoDeContas_Tipo
        CHECK (Tipo IN (N'RECEITA', N'DESPESA')),

    -- Nível hierárquico: 1 = raiz, 2 = grupo, 3 = subgrupo, 4 = conta
    Nivel               INT             NOT NULL
        CONSTRAINT CK_PlanoDeContas_Nivel
        CHECK (Nivel BETWEEN 1 AND 5),

    -- Indica se esta conta aceita lançamentos diretos
    -- Contas de grupo geralmente não aceitam — só suas filhas aceitam
    AceitaLancamentos   BIT             NOT NULL
        CONSTRAINT DF_PlanoDeContas_AceitaLancamentos DEFAULT (0),

    -- Flag de atividade
    Ativa               BIT             NOT NULL
        CONSTRAINT DF_PlanoDeContas_Ativa DEFAULT (1),

    -- PRIMARY KEY
    CONSTRAINT PK_PlanoDeContas
        PRIMARY KEY CLUSTERED (ContaPlanoID),

    -- FK para Empresas
    CONSTRAINT FK_PlanoDeContas_Empresas
        FOREIGN KEY (EmpresaID)
        REFERENCES dbo.Empresas (EmpresaID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    -- Auto-FK: ContaPaiID referencia a própria tabela PlanoDeContas
    -- Isso é um SELF JOIN estrutural — estudaremos no Capítulo 17
    CONSTRAINT FK_PlanoDeContas_ContaPai
        FOREIGN KEY (ContaPaiID)
        REFERENCES dbo.PlanoDeContas (ContaPlanoID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    -- Código deve ser único por empresa
    CONSTRAINT UQ_PlanoDeContas_EmpresaCodigo
        UNIQUE (EmpresaID, Codigo)
);
GO
~~~

---

### Passo 4: Criar a tabela Transacoes

~~~sql
-- Transacoes: a tabela central do FinanceDB
-- Referencia ContasBancarias, PlanoDeContas e TiposTransacao
-- Deve ser criada DEPOIS de todas as tabelas que ela referencia
CREATE TABLE dbo.Transacoes
(
    -- Chave primária com IDENTITY
    -- BIGINT usado aqui: sistemas financeiros acumulam milhões de transações
    TransacaoID         BIGINT          NOT NULL IDENTITY(1,1),

    -- FK para Empresas: toda transação pertence a uma empresa
    EmpresaID           INT             NOT NULL,

    -- FK para ContasBancarias: conta que movimentou o valor
    ContaID             INT             NOT NULL,

    -- FK para PlanoDeContas: categoria contábil da transação
    ContaPlanoID        INT             NOT NULL,

    -- FK para TiposTransacao: RECEITA, DESPESA ou TRANSF
    TipoTransacaoID     INT             NOT NULL,

    -- Data em que o lançamento foi registrado no sistema
    DataLancamento      DATE            NOT NULL
        CONSTRAINT DF_Transacoes_DataLancamento DEFAULT (CAST(GETDATE() AS DATE)),

    -- Data de competência contábil (pode diferir do lançamento)
    -- Ex: despesa de dezembro paga em janeiro
    DataCompetencia     DATE            NOT NULL,

    -- Valor da transação: sempre positivo — a natureza define o sinal
    Valor               DECIMAL(18,2)   NOT NULL
        CONSTRAINT CK_Transacoes_Valor
        CHECK (Valor > 0),

    -- Descrição livre do lançamento
    Descricao           NVARCHAR(200)   NOT NULL,

    -- Número do documento: NF, boleto, cheque, etc.
    NumeroDocumento     NVARCHAR(50)    NULL,

    -- Status do lançamento financeiro
    Status              NVARCHAR(20)    NOT NULL
        CONSTRAINT CK_Transacoes_Status
        CHECK (Status IN (N'Pendente', N'Conciliado', N'Cancelado'))
        CONSTRAINT DF_Transacoes_Status DEFAULT (N'Pendente'),

    -- Data e hora do registro para auditoria
    DataRegistro        DATETIME2(0)    NOT NULL
        CONSTRAINT DF_Transacoes_DataRegistro DEFAULT (GETDATE()),

    -- PRIMARY KEY usando BIGINT para suportar grande volume
    CONSTRAINT PK_Transacoes
        PRIMARY KEY CLUSTERED (TransacaoID),

    -- FK para Empresas
    CONSTRAINT FK_Transacoes_Empresas
        FOREIGN KEY (EmpresaID)
        REFERENCES dbo.Empresas (EmpresaID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    -- FK para ContasBancarias
    CONSTRAINT FK_Transacoes_ContasBancarias
        FOREIGN KEY (ContaID)
        REFERENCES dbo.ContasBancarias (ContaID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    -- FK para PlanoDeContas
    CONSTRAINT FK_Transacoes_PlanoDeContas
        FOREIGN KEY (ContaPlanoID)
        REFERENCES dbo.PlanoDeContas (ContaPlanoID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    -- FK para TiposTransacao
    CONSTRAINT FK_Transacoes_TiposTransacao
        FOREIGN KEY (TipoTransacaoID)
        REFERENCES dbo.TiposTransacao (TipoTransacaoID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);
GO
~~~

---

### Passo 5: Criar a tabela Orcamentos

~~~sql
-- Orcamentos: planejamento financeiro por conta e período
-- Referencia Empresas e PlanoDeContas
CREATE TABLE dbo.Orcamentos
(
    -- Chave primária com IDENTITY
    OrcamentoID         INT             NOT NULL IDENTITY(1,1),

    -- FK para Empresas
    EmpresaID           INT             NOT NULL,

    -- FK para PlanoDeContas: conta orçada
    ContaPlanoID        INT             NOT NULL,

    -- Ano do orçamento: ex. 2024, 2025
    Ano                 INT             NOT NULL
        CONSTRAINT CK_Orcamentos_Ano
        CHECK (Ano BETWEEN 2000 AND 2100),

    -- Mês do orçamento: 1 a 12
    Mes                 INT             NOT NULL
        CONSTRAINT CK_Orcamentos_Mes
        CHECK (Mes BETWEEN 1 AND 12),

    -- Valor previsto no orçamento para o período
    ValorOrcado         DECIMAL(18,2)   NOT NULL
        CONSTRAINT CK_Orcamentos_ValorOrcado
        CHECK (ValorOrcado >= 0),

    -- Valor realizado: atualizado conforme transações são lançadas
    ValorRealizado      DECIMAL(18,2)   NOT NULL
        CONSTRAINT DF_Orcamentos_ValorRealizado DEFAULT (0.00),

    -- PRIMARY KEY
    CONSTRAINT PK_Orcamentos
        PRIMARY KEY CLUSTERED (OrcamentoID),

    -- FK para Empresas
    CONSTRAINT FK_Orcamentos_Empresas
        FOREIGN KEY (EmpresaID)
        REFERENCES dbo.Empresas (EmpresaID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    -- FK para PlanoDeContas
    CONSTRAINT FK_Orcamentos_PlanoDeContas
        FOREIGN KEY (ContaPlanoID)
        REFERENCES dbo.PlanoDeContas (ContaPlanoID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    -- Unicidade: só pode existir um orçamento por empresa, conta, ano e mês
    CONSTRAINT UQ_Orcamentos_EmpresaContaAnomes
        UNIQUE (EmpresaID, ContaPlanoID, Ano, Mes)
);
GO
~~~

---

### Passo 6: Verificar os relacionamentos criados

~~~sql
-- Verificar todas as foreign keys criadas no banco FinanceDB
-- sys.foreign_keys: catálogo de todas as FKs
-- sys.tables: catálogo de todas as tabelas
SELECT
    fk.name                         AS NomeFK,
    tp.name                         AS TabelaPai,
    tf.name                         AS TabelaFilha,
    fk.delete_referential_action_desc   AS AcaoDelete,
    fk.update_referential_action_desc   AS AcaoUpdate,
    fk.is_disabled                  AS Desabilitada
FROM sys.foreign_keys fk
-- Junção com a tabela pai (referenciada)
INNER JOIN sys.tables tp
    ON fk.referenced_object_id = tp.object_id
-- Junção com a tabela filha (que contém a FK)
INNER JOIN sys.tables tf
    ON fk.parent_object_id = tf.object_id
ORDER BY tf.name, fk.name;
~~~

~~~sql
-- Verificar as colunas envolvidas em cada FK
-- sys.foreign_key_columns: detalha as colunas de cada FK
SELECT
    fk.name                     AS NomeFK,
    tf.name                     AS TabelaFilha,
    cf.name                     AS ColunaFilha,
    tp.name                     AS TabelaPai,
    cp.name                     AS ColunaPai
FROM sys.foreign_key_columns fkc
INNER JOIN sys.foreign_keys fk
    ON fkc.constraint_object_id = fk.object_id
INNER JOIN sys.tables tf
    ON fkc.parent_object_id = tf.object_id
INNER JOIN sys.columns cf
    ON fkc.parent_object_id = cf.object_id
    AND fkc.parent_column_id = cf.column_id
INNER JOIN sys.tables tp
    ON fkc.referenced_object_id = tp.object_id
INNER JOIN sys.columns cp
    ON fkc.referenced_object_id = cp.object_id
    AND fkc.referenced_column_id = cp.column_id
ORDER BY tf.name, fk.name;
~~~

~~~sql
-- Verificar o total de tabelas criadas no FinanceDB
-- O resultado deve ser 7: Empresas, Bancos, TiposTransacao,
-- ContasBancarias, PlanoDeContas, Transacoes e Orcamentos
SELECT COUNT(*) AS TotalTabelas
FROM sys.tables
WHERE type = 'U'; -- U = User Table (tabela do usuário, não do sistema)
~~~

---

### Passo 7: Testar a integridade referencial

~~~sql
-- TESTE 1: Tentar inserir uma ContaBancaria com EmpresaID inexistente
-- Esse INSERT deve FALHAR com erro de violação de FK
-- Demonstra que a FK está funcionando corretamente
INSERT INTO dbo.ContasBancarias
    (EmpresaID, BancoID, Agencia, NumeroConta, TipoConta, SaldoInicial)
VALUES
    (9999, 1, N'0001', N'12345-6', N'Corrente', 1000.00);
-- Erro esperado: The INSERT statement conflicted with the FOREIGN KEY constraint
GO

-- TESTE 2: Inserir uma ContaBancaria válida
-- Assumindo que EmpresaID=1 existe em Empresas e BancoID=1 existe em Bancos
-- Primeiro, inserir uma empresa de teste
INSERT INTO dbo.Empresas
    (RazaoSocial, CNPJ)
VALUES
    (N'FinanceDB Holding S.A.', N'12.345.678/0001-90');
GO

-- Agora inserir uma conta bancária válida
-- EmpresaID=1 (recém-criada), BancoID=1 (Banco do Brasil, inserido no Cap. 8)
INSERT INTO dbo.ContasBancarias
    (EmpresaID, BancoID, Agencia, NumeroConta, TipoConta, SaldoInicial)
VALUES
    (1, 1, N'3721', N'00012345-6', N'Corrente', 50000.00);
GO

-- Verificar o registro inserido com o ID gerado pelo IDENTITY
-- SCOPE_IDENTITY() retorna o último ID gerado na sessão atual
SELECT
    ContaID,           -- ID gerado automaticamente pelo IDENTITY
    EmpresaID,
    BancoID,
    Agencia,
    NumeroConta,
    TipoConta,
    SaldoInicial,
    Ativa,
    DataCadastro
FROM dbo.ContasBancarias;

-- Capturar o ID gerado pelo IDENTITY imediatamente após o INSERT
SELECT SCOPE_IDENTITY() AS UltimoIDGerado;
GO
~~~

---

## Antecipação de Erros e Troubleshooting

### Erro: "There are no primary or candidate keys in the referenced table"

**Causa:** Você tentou criar uma FOREIGN KEY referenciando uma coluna que não é PRIMARY KEY nem tem uma constraint UNIQUE. O SQL Server exige que a coluna referenciada identifique unicamente cada linha.

**Solução:** Verifique se a coluna referenciada tem PRIMARY KEY ou UNIQUE constraint. Se for a primeira vez criando as tabelas, verifique a ordem de criação — a tabela pai deve ser criada antes da tabela filha.

---

### Erro: "The INSERT statement conflicted with the FOREIGN KEY constraint"

**Causa:** Você tentou inserir na tabela filha um valor de FK que não existe na tabela pai. Por exemplo, inserir uma ContaBancaria com EmpresaID=99 quando não existe nenhuma empresa com esse ID.

**Solução:** Verifique os dados que existem na tabela pai antes de inserir na filha. Use um SELECT na tabela pai para confirmar quais IDs estão disponíveis.

---

### Erro: "The DELETE statement conflicted with the REFERENCE constraint"

**Causa:** Você tentou excluir um registro pai que ainda possui registros filhos referenciando-o. Com ON DELETE NO ACTION, o SQL Server protege o registro pai de ser removido enquanto tiver dependências.

**Solução:** Exclua ou reatribua primeiro os registros filhos, depois exclua o pai. Em sistemas financeiros, prefira **desativar** o registro pai (Ativo = 0) em vez de excluí-lo — preservando o histórico.

---

### Erro: "Cannot insert explicit value for identity column"

**Causa:** Você tentou inserir um valor explícito em uma coluna IDENTITY sem habilitar IDENTITY_INSERT.

**Solução:** Se for uma operação de migração legítima:

~~~sql
SET IDENTITY_INSERT dbo.ContasBancarias ON;
-- Execute o INSERT com o valor explícito
INSERT INTO dbo.ContasBancarias (ContaID, EmpresaID, ...) VALUES (100, 1, ...);
SET IDENTITY_INSERT dbo.ContasBancarias OFF;
~~~

Em operações normais, simplesmente não inclua a coluna IDENTITY no INSERT — o SQL Server a preencherá automaticamente.

---

### Erro: "Introducing FOREIGN KEY constraint may cause cycles or multiple cascade paths"

**Causa:** Você tentou usar CASCADE em uma tabela que já faz parte de um caminho de cascata existente. O SQL Server não permite caminhos de cascata múltiplos para proteger contra loops de exclusão.

**Solução:** Use NO ACTION em todos os relacionamentos do caminho problemático e implemente a lógica de propagação manualmente em Stored Procedures ou Triggers. No FinanceDB, essa situação não ocorrerá porque usamos NO ACTION em todas as FKs.

---

## Glossário Técnico

**PRIMARY KEY (PK):** Constraint que garante unicidade e não-nulidade de uma coluna ou conjunto de colunas, identificando unicamente cada linha de uma tabela.

**FOREIGN KEY (FK):** Constraint que cria um vínculo formal entre uma coluna da tabela filha e a chave primária da tabela pai, garantindo integridade referencial.

**IDENTITY:** Propriedade de coluna que instrui o SQL Server a gerar automaticamente valores numéricos sequenciais para cada nova linha inserida.

**SCOPE_IDENTITY():** Função T-SQL que retorna o último valor IDENTITY gerado na sessão e escopo atual, usada para capturar IDs gerados após INSERTs.

**Integridade Referencial:** Propriedade de um banco de dados que garante que os relacionamentos entre tabelas sejam sempre válidos — nenhum registro filho pode existir sem o registro pai correspondente.

**ON DELETE NO ACTION:** Ação referencial que impede a exclusão de um registro pai enquanto existirem registros filhos referenciando-o.

**ON DELETE CASCADE:** Ação referencial que propaga automaticamente a exclusão do pai para todos os seus filhos.

**Índice Clustered:** Índice que determina a ordem física de armazenamento das linhas em disco. Uma PRIMARY KEY cria automaticamente um índice Clustered, a menos que especificado de outra forma.

**IDENTITY_INSERT:** Opção de sessão que permite inserir valores explícitos em colunas IDENTITY, usada exclusivamente em cenários de migração de dados.

**Auto-relacionamento (Self-Reference):** Quando uma tabela tem uma FOREIGN KEY referenciando sua própria PRIMARY KEY, criando hierarquias pai-filho dentro da mesma tabela.

**sys.foreign_keys:** View de catálogo do SQL Server que lista todas as constraints de chave estrangeira do banco de dados atual.

**sys.foreign_key_columns:** View de catálogo que detalha as colunas envolvidas em cada FOREIGN KEY.

**BIGINT:** Tipo de dados inteiro que comporta valores de -9.223.372.036.854.775.808 a 9.223.372.036.854.775.807, recomendado para tabelas de alto volume como Transacoes.

---

## Desafio de Fixação

### Problema

A empresa **FinanceDB Holding S.A.** (EmpresaID = 1) precisa ter seu Plano de Contas básico criado. Insira a estrutura abaixo respeitando a hierarquia (pai antes do filho) e as constraints definidas:

| Nível | Código | Descrição | Tipo | Aceita Lançamentos | ContaPaiID |
|-------|--------|-----------|------|-------------------|------------|
| 1 | 1 | RECEITAS | RECEITA | 0 | NULL |
| 2 | 1.1 | Receitas Operacionais | RECEITA | 0 | ID do "1" |
| 3 | 1.1.01 | Vendas de Produtos | RECEITA | 1 | ID do "1.1" |
| 3 | 1.1.02 | Prestação de Serviços | RECEITA | 1 | ID do "1.1" |
| 1 | 2 | DESPESAS | DESPESA | 0 | NULL |
| 2 | 2.1 | Despesas Operacionais | DESPESA | 0 | ID do "2" |
| 3 | 2.1.01 | Fornecedores | DESPESA | 1 | ID do "2.1" |
| 3 | 2.1.02 | Folha de Pagamento | DESPESA | 1 | ID do "2.1" |

Após inserir, consulte a tabela PlanoDeContas mostrando a hierarquia completa com o nome da conta pai ao lado de cada conta.

---

### Resolução Comentada

~~~sql
USE FinanceDB;
GO

-- PASSO 1: Inserir as contas raiz (sem pai — ContaPaiID = NULL)
-- Nível 1: "RECEITAS" e "DESPESAS" não têm pai
INSERT INTO dbo.PlanoDeContas
    (EmpresaID, ContaPaiID, Codigo, Descricao, Tipo, Nivel, AceitaLancamentos)
VALUES
    (1, NULL, N'1',  N'RECEITAS', N'RECEITA', 1, 0),  -- ContaPlanoID = 1
    (1, NULL, N'2',  N'DESPESAS', N'DESPESA', 1, 0);  -- ContaPlanoID = 2
GO

-- PASSO 2: Inserir as contas de nível 2
-- ContaPaiID = 1 para "Receitas Operacionais" (filha de RECEITAS)
-- ContaPaiID = 2 para "Despesas Operacionais" (filha de DESPESAS)
INSERT INTO dbo.PlanoDeContas
    (EmpresaID, ContaPaiID, Codigo, Descricao, Tipo, Nivel, AceitaLancamentos)
VALUES
    (1, 1, N'1.1', N'Receitas Operacionais',  N'RECEITA', 2, 0), -- ContaPlanoID = 3
    (1, 2, N'2.1', N'Despesas Operacionais',  N'DESPESA', 2, 0); -- ContaPlanoID = 4
GO

-- PASSO 3: Inserir as contas de nível 3 (que aceitam lançamentos diretos)
-- ContaPaiID = 3 para filhas de "Receitas Operacionais"
-- ContaPaiID = 4 para filhas de "Despesas Operacionais"
INSERT INTO dbo.PlanoDeContas
    (EmpresaID, ContaPaiID, Codigo, Descricao, Tipo, Nivel, AceitaLancamentos)
VALUES
    (1, 3, N'1.1.01', N'Vendas de Produtos',    N'RECEITA', 3, 1),
    (1, 3, N'1.1.02', N'Prestação de Serviços', N'RECEITA', 3, 1),
    (1, 4, N'2.1.01', N'Fornecedores',           N'DESPESA', 3, 1),
    (1, 4, N'2.1.02', N'Folha de Pagamento',     N'DESPESA', 3, 1);
GO

-- PASSO 4: Consultar o Plano de Contas com hierarquia completa
-- SELF JOIN: a tabela PlanoDeContas junta-se a si mesma
-- pai.Descricao mostra o nome da conta pai de cada linha
SELECT
    filho.ContaPlanoID,
    filho.Codigo,
    filho.Descricao                         AS NomeConta,
    filho.Tipo,
    filho.Nivel,
    filho.AceitaLancamentos,
    pai.Descricao                           AS ContaPai
FROM dbo.PlanoDeContas AS filho
-- LEFT JOIN: contas raiz (ContaPaiID = NULL) também aparecem
-- com ContaPai = NULL em vez de serem excluídas do resultado
LEFT JOIN dbo.PlanoDeContas AS pai
    ON filho.ContaPaiID = pai.ContaPlanoID
ORDER BY filho.Codigo;
~~~

**Resultado esperado:**

| ContaPlanoID | Codigo | NomeConta | Tipo | Nivel | AceitaLancamentos | ContaPai |
|---|---|---|---|---|---|---|
| 1 | 1 | RECEITAS | RECEITA | 1 | 0 | NULL |
| 3 | 1.1 | Receitas Operacionais | RECEITA | 2 | 0 | RECEITAS |
| 5 | 1.1.01 | Vendas de Produtos | RECEITA | 3 | 1 | Receitas Operacionais |
| 6 | 1.1.02 | Prestação de Serviços | RECEITA | 3 | 1 | Receitas Operacionais |
| 2 | 2 | DESPESAS | DESPESA | 1 | 0 | NULL |
| 4 | 2.1 | Despesas Operacionais | DESPESA | 2 | 0 | DESPESAS |
| 7 | 2.1.01 | Fornecedores | DESPESA | 3 | 1 | Despesas Operacionais |
| 8 | 2.1.02 | Folha de Pagamento | DESPESA | 3 | 1 | Despesas Operacionais |

---

## Resumo dos Pontos-Chave

A **PRIMARY KEY** é a identidade irrefutável de cada linha: garante unicidade, proíbe NULL e cria automaticamente um índice Clustered no SQL Server. O **IDENTITY** elimina o trabalho manual de gerenciar IDs: o SQL Server gera automaticamente valores sequenciais a cada INSERT, e `SCOPE_IDENTITY()` permite capturar o ID gerado para uso imediato. A **FOREIGN KEY** transforma linhas em diagramas ER em vínculos físicos no banco de dados, rejeitando automaticamente valores inválidos em INSERTs e controlando o comportamento em exclusões e atualizações via ações referenciais. No FinanceDB, todas as FKs usam **NO ACTION** — a escolha deliberada de um sistema financeiro que valoriza a integridade histórica acima da conveniência de cascatas automáticas. O **auto-relacionamento** da tabela PlanoDeContas (ContaPaiID referenciando ContaPlanoID da mesma tabela) é a implementação física de uma hierarquia pai-filho — um padrão clássico em planos de contas contábeis. A **ordem de criação das tabelas** segue rigorosamente a hierarquia de dependências: tabelas pai sempre antes das tabelas filhas. As views de catálogo **sys.foreign_keys** e **sys.foreign_key_columns** permitem inspecionar e auditar todos os relacionamentos do banco de dados.

---

## Log de Estado do Projeto

~~~text
## Log de Estado — Após o Capítulo 9

=== PROJETO FINANCEDB ===
Livro: SQL Server para Aplicações Financeiras com T-SQL
Módulo Atual: Módulo 2 — ESSENCIAL: T-SQL Básico
Capítulo Concluído: 9 — PRIMARY KEY, FOREIGN KEY e IDENTITY

=== BANCO DE DADOS ===
Nome: FinanceDB
Servidor: localhost (SQL Server 2022)
Collation: Latin1_General_CI_AS
Recovery Model: FULL
Status: Online e operacional

=== TABELAS CRIADAS ===
[Módulo 1 — Capítulos 7 e 8]
✅ dbo.Empresas         — PK: EmpresaID (IDENTITY)
✅ dbo.Bancos           — PK: BancoID (IDENTITY)
✅ dbo.TiposTransacao   — PK: TipoTransacaoID (IDENTITY)

[Módulo 2 — Capítulo 9]
✅ dbo.ContasBancarias  — PK: ContaID (IDENTITY) | FK: Empresas, Bancos
✅ dbo.PlanoDeContas    — PK: ContaPlanoID (IDENTITY) | FK: Empresas, PlanoDeContas (self)
✅ dbo.Transacoes       — PK: TransacaoID BIGINT (IDENTITY) | FK: Empresas, ContasBancarias, PlanoDeContas, TiposTransacao
✅ dbo.Orcamentos       — PK: OrcamentoID (IDENTITY) | FK: Empresas, PlanoDeContas

Total de Tabelas: 7 (modelo físico completo implementado)

=== DADOS INSERIDOS ===
✅ dbo.Bancos: 3 registros (Itaú 341, Banco do Brasil 1, Caixa 104)
✅ dbo.TiposTransacao: 3 registros (RECEITA, DESPESA, TRANSF)
✅ dbo.Empresas: 1 registro (FinanceDB Holding S.A.)
✅ dbo.ContasBancarias: 1 registro (conta corrente BB — EmpresaID=1)
✅ dbo.PlanoDeContas: 8 registros (hierarquia completa 3 níveis)
🔲 dbo.Transacoes: vazio — será populado no Capítulo 10
🔲 dbo.Orcamentos: vazio — será populado nos capítulos avançados

=== FOREIGN KEYS ===
✅ FK_ContasBancarias_Empresas     (NO ACTION)
✅ FK_ContasBancarias_Bancos       (NO ACTION)
✅ FK_PlanoDeContas_Empresas       (NO ACTION)
✅ FK_PlanoDeContas_ContaPai       (NO ACTION — self-reference)
✅ FK_Transacoes_Empresas          (NO ACTION)
✅ FK_Transacoes_ContasBancarias   (NO ACTION)
✅ FK_Transacoes_PlanoDeContas     (NO ACTION)
✅ FK_Transacoes_TiposTransacao    (NO ACTION)
✅ FK_Orcamentos_Empresas          (NO ACTION)
✅ FK_Orcamentos_PlanoDeContas     (NO ACTION)

=== SCRIPTS SALVOS ===
📁 modulo_02_essencial/aula_09/
   └── criar_tabelas_relacionais.sql
   └── verificar_foreign_keys.sql
   └── teste_integridade_referencial.sql
   └── inserir_plano_de_contas.sql
   └── desafio_09.sql
   └── respostas/resposta_09.sql

=== PRÓXIMAS ETAPAS ===
Capítulo 10 — INSERT INTO: popular todas as tabelas com dados financeiros reais
~~~

---

## Prompt de Continuidade para o Capítulo 10

~~~text
Contexto: Estou estudando o livro "SQL Server para Aplicações
Financeiras com T-SQL". Meu ambiente é Windows 11, SSMS,
SQL Server 2022. O projeto prático incremental se chama FinanceDB.

Concluí o Capítulo 9, que implementou o modelo físico completo
do FinanceDB com PRIMARY KEY (IDENTITY), FOREIGN KEY (NO ACTION)
e auto-relacionamento em PlanoDeContas. As 7 tabelas estão criadas:
Empresas, Bancos, TiposTransacao, ContasBancarias, PlanoDeContas,
Transacoes e Orcamentos. Existem 10 FKs ativas. Os dados iniciais
foram inseridos em Empresas (1 registro), ContasBancarias (1 registro)
e PlanoDeContas (8 registros em 3 níveis).

Siga rigorosamente o Prompt Mestre v1.1: narrativa densa com
mínimo de 2.000 palavras, Técnica de Feynman, analogia de
ancoragem, diagrama Mermaid escapado com ~~~mermaid, código SQL
comentado linha a linha escapado com ~~~, glossário técnico,
antecipação de erros, troubleshooting, desafio de fixação com
resolução comentada, resumo dos pontos-chave, log de estado do
projeto atualizado e prompt de continuidade para o próximo capítulo.
Todo o conteúdo deve ser gerado dentro de um bloco ```markdown.
Chame aulas de capítulos e curso de livro.

Por favor, gere o Capítulo 10: Inserindo Dados — INSERT INTO.
Objetivo: popular todas as tabelas do FinanceDB com dados
financeiros realistas usando INSERT INTO em suas três variações:
linha única, múltiplas linhas em um único INSERT e INSERT...SELECT.
Aprender a capturar IDs gerados com SCOPE_IDENTITY(), respeitar
a ordem de inserção ditada pelas FKs, lidar com erros de violação
de constraint durante a carga de dados e usar OUTPUT para
monitorar os IDs gerados.
Pré-requisito: Capítulo 9 concluído, modelo físico completo
implementado.
~~~

---

Dúvidas? Posso prosseguir para o Capítulo 10?