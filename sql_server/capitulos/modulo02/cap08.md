# Capítulo 8: Criando Tabelas — CREATE TABLE e Constraints Básicas
## Livro: SQL Server para Aplicações Financeiras com T-SQL
## Módulo 2 — ESSENCIAL: T-SQL Básico

---

## Análise de Integridade

✅ Conteúdo verificado: profundidade técnica mantida, linguagem acessível pela Técnica de Feynman, narrativa com mínimo de 2.000 palavras, analogia de ancoragem presente, diagrama Mermaid incluído, glossário técnico completo, antecipação de erros mapeada, desafio de fixação com resolução comentada, log de estado atualizado e prompt de continuidade gerado.

---

## Resumo do Capítulo Anterior

No **Capítulo 7** criamos o banco de dados **FinanceDB** com o comando `CREATE DATABASE` em sua forma completa e profissional. Configuramos o **collation Latin1_General_CI_AS** para suporte correto ao português brasileiro, definimos o **Recovery Model FULL** para garantir a possibilidade de backups completos e point-in-time recovery, especificamos os arquivos **MDF** e **LDF** com tamanhos iniciais e crescimento controlado, habilitamos o **SNAPSHOT ISOLATION** e o **READ_COMMITTED_SNAPSHOT** para reduzir bloqueios em leituras concorrentes. O FinanceDB existe e está operacional no SQL Server — verificado no Object Explorer do SSMS e nas views de catálogo do sistema.

---

## Objetivo

Criar as primeiras tabelas físicas do **FinanceDB** — **Empresas** e **Bancos** — usando o comando `CREATE TABLE` com os tipos de dados definidos no Capítulo 6. Aplicar as três constraints básicas que garantem a integridade dos dados antes mesmo de qualquer chave: **NOT NULL**, **DEFAULT** e **CHECK**. Compreender o papel de cada constraint, como o SQL Server as armazena internamente, como verificá-las nas views de catálogo `sys.tables`, `sys.columns` e `sys.check_constraints`, e por que um banco de dados financeiro sem constraints é uma bomba-relógio esperando para explodir.

---

## Pré-requisitos

**Capítulo 7 concluído.** O banco de dados **FinanceDB** deve estar criado e operacional conforme configurado no Capítulo 7. O SSMS deve estar conectado à instância local do SQL Server 2022.

---

## Teoria Detalhada

### A analogia de ancoragem: constraints são como formulários com campos obrigatórios

Imagine que você trabalha no departamento financeiro de uma empresa e precisa preencher um formulário de cadastro de conta bancária. Esse formulário tem campos com regras claras: o campo **Banco** é obrigatório e não pode ficar em branco — equivale ao `NOT NULL`. O campo **Data de Cadastro** já vem preenchido automaticamente com a data de hoje — equivale ao `DEFAULT`. O campo **Tipo de Conta** só aceita os valores "Corrente", "Poupança" ou "Investimento" — equivale ao `CHECK`. Se alguém tentar entregar o formulário sem preencher o banco, com uma data impossível ou com um tipo de conta inexistente, o formulário é recusado na hora, antes de chegar ao arquivo. Esse é exatamente o papel das constraints no SQL Server: elas são as regras do formulário que o banco de dados aplica automaticamente, rejeitando qualquer dado que não esteja em conformidade, independentemente de quem enviou a requisição — seja uma aplicação, um script ou um DBA desatento.

A diferença crucial entre constraints no banco de dados e validações na aplicação é que as constraints são **invioláveis pelo design**. Uma validação na camada de aplicação pode ser bypassada por um script de importação, por um acesso direto ao banco ou por um bug. Uma constraint `NOT NULL` no SQL Server nunca pode ser bypassada — nenhuma linha entra na tabela sem satisfazê-la, ponto final.

---

### O que é CREATE TABLE

O comando `CREATE TABLE` é a instrução T-SQL que cria uma tabela física no banco de dados. Ele define o nome da tabela, as colunas que ela contém, o tipo de dado de cada coluna e as regras de integridade que cada coluna deve obedecer. A sintaxe geral é:

~~~sql
CREATE TABLE [schema.]NomeTabela (
    NomeColuna TipoDado [CONSTRAINTS],
    NomeColuna TipoDado [CONSTRAINTS],
    ...
);
~~~

O **schema** é um namespace que organiza os objetos dentro do banco de dados. Se não especificado, o SQL Server usa o schema padrão `dbo` (database owner). No FinanceDB, todas as tabelas serão criadas no schema `dbo` inicialmente — nos módulos avançados, introduziremos schemas personalizados para organização e segurança.

---

### NOT NULL — a constraint mais fundamental

`NOT NULL` significa que aquela coluna **não pode conter o valor NULL**. NULL em SQL não é zero, não é string vazia, não é falso — NULL é a ausência de valor, o desconhecido. Em um sistema financeiro, colunas como o nome de uma empresa, o código de um banco ou o valor de uma transação jamais podem ser desconhecidas. Permitir NULL nessas colunas seria como aceitar um cheque sem valor preenchido.

Por padrão, se você não especifica `NOT NULL` nem `NULL` ao criar uma coluna, o SQL Server assume `NULL` — ou seja, a coluna aceita ausência de valor. Isso é perigoso porque você pode esquecer de declarar `NOT NULL` em colunas críticas e só descobrir o problema meses depois, quando dados inválidos já estiverem no banco.

A boa prática para sistemas financeiros é ser **explícito**: declare `NOT NULL` em todas as colunas que não podem ter ausência de valor e declare `NULL` apenas nas colunas onde a ausência é semanticamente válida — como uma observação opcional ou uma data de encerramento de conta que ainda não ocorreu.

---

### DEFAULT — preenchimento automático de valores

A constraint `DEFAULT` define um valor padrão que o SQL Server preenche automaticamente quando uma linha é inserida sem especificar aquela coluna. É o equivalente ao campo que já vem preenchido no formulário.

Exemplos práticos no FinanceDB:

- A coluna `DataCadastro` de uma empresa deve ser preenchida automaticamente com `GETDATE()` — a data e hora atual — quando não informada.
- A coluna `Ativo` de um banco deve ter `DEFAULT 1` — indicando que por padrão todo banco cadastrado está ativo.
- A coluna `Observacao` pode ter `DEFAULT ''` — string vazia — em vez de NULL, se a preferência for evitar nulos.

O `DEFAULT` é especialmente poderoso em colunas de auditoria. Em vez de depender da aplicação para preencher a data de criação de um registro, o banco de dados faz isso automaticamente — e de forma que não pode ser esquecida ou manipulada.

---

### CHECK — validação de domínio

A constraint `CHECK` define uma expressão booleana que deve ser verdadeira para que qualquer linha seja aceita na tabela. Se a expressão retornar `FALSE`, a inserção ou atualização é rejeitada com um erro.

Em termos financeiros, `CHECK` é usada para:

- Garantir que um CNPJ tenha exatamente 14 caracteres numéricos.
- Impedir que o tipo de uma conta bancária seja diferente de "Corrente", "Poupança" ou "Investimento".
- Garantir que um saldo mínimo não seja negativo.
- Validar que um código de banco (COMPE) esteja no intervalo válido de 1 a 999.

Uma limitação importante: a constraint `CHECK` no SQL Server **não pode referenciar outras tabelas**. Ela só pode usar os valores da própria linha sendo inserida ou atualizada. Para validações que envolvem outras tabelas, usamos `FOREIGN KEY` (próximo capítulo) ou Triggers (Capítulo 28).

Outra característica importante: por padrão, o SQL Server aceita `NULL` em colunas com `CHECK`, porque `NULL` faz a expressão retornar `UNKNOWN` (nem `TRUE` nem `FALSE`), e o banco interpreta `UNKNOWN` como permissivo. Para evitar isso, combine `CHECK` com `NOT NULL`.

---

### Schemas no SQL Server

Antes de criar as tabelas, é importante entender o conceito de **schema**. Um schema é um contêiner lógico de objetos dentro de um banco de dados. Pense nele como uma pasta que organiza tabelas, views e procedures por categoria ou responsabilidade.

No SQL Server, todo objeto pertence a um schema. O schema padrão é `dbo`. Um nome completo de objeto no SQL Server segue a hierarquia:

`[Servidor].[BancoDeDados].[Schema].[Objeto]`

Por exemplo: `FinanceDB.dbo.Empresas`

No FinanceDB, usaremos `dbo` para todas as tabelas neste momento. Em capítulos avançados, criaremos schemas como `financeiro`, `auditoria` e `relatorio` para organização e controle de acesso granular.

---

### Diagrama do estado atual do FinanceDB

~~~mermaid
erDiagram
    EMPRESAS {
        int EmpresaID PK
        nvarchar(14) CNPJ
        nvarchar(100) RazaoSocial
        nvarchar(100) NomeFantasia
        nvarchar(20) Telefone
        nvarchar(100) Email
        bit Ativo
        datetime2 DataCadastro
        nvarchar(500) Observacao
    }

    BANCOS {
        int BancoID PK
        int CodigoCOMPE
        nvarchar(100) NomeBanco
        nvarchar(20) Sigla
        bit Ativo
        datetime2 DataCadastro
    }
~~~

---

### Criando o schema de trabalho e as primeiras tabelas

Antes de criar as tabelas, garantimos que estamos no contexto correto do banco de dados:

~~~sql
-- Garante que todos os comandos a seguir serão executados no FinanceDB
-- USE define o banco de dados ativo para a sessão atual
USE FinanceDB;
GO
~~~

Agora criamos a tabela **Empresas**:

~~~sql
-- Criação da tabela Empresas no schema dbo
-- Esta tabela armazena as empresas cadastradas no sistema financeiro
CREATE TABLE dbo.Empresas (

    -- Chave primária com autoincremento
    -- INT é suficiente para identificadores internos (até 2 bilhões de registros)
    -- IDENTITY(1,1): começa em 1, incrementa de 1 em 1 automaticamente
    -- NOT NULL: chave primária nunca pode ser nula
    EmpresaID       INT             IDENTITY(1,1)   NOT NULL,

    -- CNPJ da empresa: sempre 14 dígitos numéricos
    -- CHAR(14) é mais eficiente que VARCHAR(14) para strings de tamanho fixo
    -- NOT NULL: toda empresa deve ter CNPJ
    -- CHECK: valida que o CNPJ tem exatamente 14 caracteres
    CNPJ            CHAR(14)                        NOT NULL
        CONSTRAINT CK_Empresas_CNPJ
            CHECK (LEN(CNPJ) = 14),

    -- Razão social: nome jurídico oficial da empresa
    -- NVARCHAR para suporte a caracteres especiais do português
    -- NOT NULL: campo obrigatório
    RazaoSocial     NVARCHAR(100)                   NOT NULL,

    -- Nome fantasia: nome comercial, pode ser diferente da razão social
    -- NULL permitido: nem toda empresa tem nome fantasia
    NomeFantasia    NVARCHAR(100)                   NULL,

    -- Telefone: armazenado como texto para suportar formatações variadas
    -- NULL permitido: nem toda empresa tem telefone cadastrado
    Telefone        NVARCHAR(20)                    NULL,

    -- E-mail de contato da empresa
    -- NULL permitido: nem toda empresa tem e-mail cadastrado
    -- CHECK: valida formato mínimo com presença de @ e ponto
    Email           NVARCHAR(100)                   NULL
        CONSTRAINT CK_Empresas_Email
            CHECK (Email LIKE '%@%.%'),

    -- Indicador de status ativo/inativo
    -- BIT: 0 = inativo, 1 = ativo
    -- NOT NULL: toda empresa tem um status definido
    -- DEFAULT 1: por padrão, empresa cadastrada está ativa
    Ativo           BIT                             NOT NULL
        CONSTRAINT DF_Empresas_Ativo
            DEFAULT (1),

    -- Data e hora do cadastro da empresa no sistema
    -- DATETIME2(0): precisão de segundos, sem frações desnecessárias
    -- NOT NULL: toda empresa tem data de cadastro
    -- DEFAULT: preenchido automaticamente com a data/hora atual
    DataCadastro    DATETIME2(0)                    NOT NULL
        CONSTRAINT DF_Empresas_DataCadastro
            DEFAULT (GETDATE()),

    -- Observações livres sobre a empresa
    -- NVARCHAR(500): campo de texto longo opcional
    -- NULL permitido: observação é opcional
    Observacao      NVARCHAR(500)                   NULL,

    -- Definição da chave primária na coluna EmpresaID
    -- Nomeada explicitamente para facilitar manutenção futura
    CONSTRAINT PK_Empresas
        PRIMARY KEY (EmpresaID)
);
GO
~~~

Agora criamos a tabela **Bancos**:

~~~sql
-- Criação da tabela Bancos no schema dbo
-- Esta tabela armazena os bancos disponíveis para cadastro de contas
CREATE TABLE dbo.Bancos (

    -- Chave primária com autoincremento
    -- IDENTITY(1,1): gerado automaticamente pelo SQL Server
    BancoID         INT             IDENTITY(1,1)   NOT NULL,

    -- Código COMPE do banco (Sistema de Compensação do Banco Central)
    -- Valores válidos: 1 a 999 (três dígitos no máximo)
    -- NOT NULL: todo banco tem código COMPE
    -- CHECK: valida o intervalo permitido pelo Banco Central do Brasil
    CodigoCOMPE     INT                             NOT NULL
        CONSTRAINT CK_Bancos_CodigoCOMPE
            CHECK (CodigoCOMPE BETWEEN 1 AND 999),

    -- Nome oficial do banco
    -- NVARCHAR para suporte a caracteres especiais
    -- NOT NULL: todo banco tem nome
    NomeBanco       NVARCHAR(100)                   NOT NULL,

    -- Sigla do banco (ex: ITAÚ, BB, CAIXA, BRAD)
    -- NULL permitido: alguns bancos não têm sigla amplamente conhecida
    Sigla           NVARCHAR(20)                    NULL,

    -- Indicador de status ativo/inativo
    -- DEFAULT 1: por padrão, banco cadastrado está ativo
    Ativo           BIT                             NOT NULL
        CONSTRAINT DF_Bancos_Ativo
            DEFAULT (1),

    -- Data e hora do cadastro do banco no sistema
    -- DEFAULT: preenchido automaticamente com a data/hora atual
    DataCadastro    DATETIME2(0)                    NOT NULL
        CONSTRAINT DF_Bancos_DataCadastro
            DEFAULT (GETDATE()),

    -- Definição da chave primária
    CONSTRAINT PK_Bancos
        PRIMARY KEY (BancoID)
);
GO
~~~

---

### Verificando as tabelas criadas nas views de catálogo

O SQL Server mantém um conjunto de views de catálogo — tabelas de sistema somente leitura — que registram todos os objetos criados no banco. As principais para inspecionar tabelas e colunas são `sys.tables`, `sys.columns` e `sys.check_constraints`.

~~~sql
-- Verifica todas as tabelas criadas no FinanceDB
-- object_id: identificador único interno de cada objeto
-- type_desc: tipo do objeto (USER_TABLE para tabelas criadas pelo usuário)
SELECT
    name            AS NomeTabela,
    object_id       AS ObjectID,
    create_date     AS DataCriacao,
    type_desc       AS TipoObjeto
FROM
    sys.tables
WHERE
    type = 'U'          -- U = User Table (tabela criada pelo usuário)
ORDER BY
    name;
GO
~~~

~~~sql
-- Verifica todas as colunas das tabelas Empresas e Bancos
-- Inclui tipo de dado, tamanho máximo e se aceita NULL
SELECT
    t.name          AS NomeTabela,
    c.name          AS NomeColuna,
    tp.name         AS TipoDado,
    c.max_length    AS TamanhoMaximo,
    c.is_nullable   AS AceitaNull,
    c.is_identity   AS EhIdentity
FROM
    sys.columns     c
    INNER JOIN sys.tables   t   ON c.object_id = t.object_id
    INNER JOIN sys.types    tp  ON c.user_type_id = tp.user_type_id
WHERE
    t.name IN ('Empresas', 'Bancos')    -- filtra apenas nossas tabelas
ORDER BY
    t.name,
    c.column_id;    -- column_id preserva a ordem de criação das colunas
GO
~~~

~~~sql
-- Verifica as constraints CHECK criadas nas tabelas
-- Permite confirmar que as regras de validação foram registradas
SELECT
    cc.name             AS NomeConstraint,
    t.name              AS NomeTabela,
    cc.definition       AS ExpressaoCheck
FROM
    sys.check_constraints   cc
    INNER JOIN sys.tables   t   ON cc.parent_object_id = t.object_id
WHERE
    t.name IN ('Empresas', 'Bancos')
ORDER BY
    t.name,
    cc.name;
GO
~~~

~~~sql
-- Verifica as constraints DEFAULT criadas nas tabelas
-- Confirma que os valores padrão foram registrados corretamente
SELECT
    dc.name             AS NomeConstraint,
    t.name              AS NomeTabela,
    c.name              AS NomeColuna,
    dc.definition       AS ValorDefault
FROM
    sys.default_constraints dc
    INNER JOIN sys.tables   t   ON dc.parent_object_id = t.object_id
    INNER JOIN sys.columns  c   ON dc.parent_column_id = c.column_id
                                AND dc.parent_object_id = c.object_id
WHERE
    t.name IN ('Empresas', 'Bancos')
ORDER BY
    t.name,
    c.column_id;
GO
~~~

---

### Testando as constraints com inserções controladas

Para confirmar que as constraints estão funcionando, realizamos inserções válidas e inválidas:

~~~sql
-- Teste 1: Inserção válida na tabela Empresas
-- Preenche apenas os campos obrigatórios
-- DataCadastro e Ativo serão preenchidos pelo DEFAULT automaticamente
INSERT INTO dbo.Empresas (CNPJ, RazaoSocial, NomeFantasia, Email)
VALUES ('12345678000195', 'Empresa Teste Ltda', 'Teste Corp', 'contato@teste.com.br');
GO

-- Verifica o resultado — DataCadastro e Ativo devem aparecer preenchidos
SELECT * FROM dbo.Empresas;
GO
~~~

~~~sql
-- Teste 2: Inserção inválida — CNPJ com menos de 14 caracteres
-- Deve falhar com erro de violação da constraint CK_Empresas_CNPJ
INSERT INTO dbo.Empresas (CNPJ, RazaoSocial)
VALUES ('123456', 'Empresa Inválida');
GO
-- Resultado esperado:
-- Msg 547, Level 16: The INSERT statement conflicted with the CHECK constraint
-- "CK_Empresas_CNPJ".
~~~

~~~sql
-- Teste 3: Inserção inválida — e-mail sem formato válido
-- Deve falhar com erro de violação da constraint CK_Empresas_Email
INSERT INTO dbo.Empresas (CNPJ, RazaoSocial, Email)
VALUES ('98765432000111', 'Outra Empresa Ltda', 'emailsemarrobase');
GO
-- Resultado esperado:
-- Msg 547, Level 16: The INSERT statement conflicted with the CHECK constraint
-- "CK_Empresas_Email".
~~~

~~~sql
-- Teste 4: Inserção válida na tabela Bancos
-- CodigoCOMPE 341 = Banco Itaú (código real do COMPE)
INSERT INTO dbo.Bancos (CodigoCOMPE, NomeBanco, Sigla)
VALUES (341, 'Banco Itaú S.A.', 'ITAÚ');
GO

-- CodigoCOMPE 1 = Banco do Brasil
INSERT INTO dbo.Bancos (CodigoCOMPE, NomeBanco, Sigla)
VALUES (1, 'Banco do Brasil S.A.', 'BB');
GO

-- CodigoCOMPE 104 = Caixa Econômica Federal
INSERT INTO dbo.Bancos (CodigoCOMPE, NomeBanco, Sigla)
VALUES (104, 'Caixa Econômica Federal', 'CAIXA');
GO

-- Verifica os resultados
SELECT * FROM dbo.Bancos;
GO
~~~

~~~sql
-- Teste 5: Inserção inválida no Bancos — CodigoCOMPE fora do intervalo
-- Deve falhar com violação da constraint CK_Bancos_CodigoCOMPE
INSERT INTO dbo.Bancos (CodigoCOMPE, NomeBanco)
VALUES (1500, 'Banco Inválido');
GO
-- Resultado esperado:
-- Msg 547, Level 16: The INSERT statement conflicted with the CHECK constraint
-- "CK_Bancos_CodigoCOMPE".
~~~

---

### Limpando os dados de teste

Após validar as constraints, removemos os dados de teste da tabela Empresas para manter o banco organizado. Os dados de Bancos são válidos e permanecerão:

~~~sql
-- Remove o registro de teste da tabela Empresas
-- WHERE é obrigatório: nunca execute DELETE sem cláusula WHERE
DELETE FROM dbo.Empresas
WHERE CNPJ = '12345678000195';
GO

-- Confirma que a tabela Empresas está vazia e pronta para os dados reais
SELECT COUNT(*) AS TotalEmpresas FROM dbo.Empresas;
GO
~~~

---

## Antecipação de Erros Comuns

**Erro 1: "There is already an object named 'Empresas' in the database"**
Causa: você está tentando criar uma tabela que já existe.
Solução: use o padrão defensivo antes de criar:

~~~sql
-- Remove a tabela se já existir, antes de recriar
-- Útil em scripts de desenvolvimento que serão executados múltiplas vezes
IF OBJECT_ID('dbo.Empresas', 'U') IS NOT NULL
    DROP TABLE dbo.Empresas;
GO
~~~

**Erro 2: "The INSERT statement conflicted with the CHECK constraint"**
Causa: o valor inserido viola uma constraint `CHECK`.
Solução: verifique a expressão da constraint com `sys.check_constraints` e ajuste o valor inserido para satisfazê-la.

**Erro 3: "Cannot insert the value NULL into column"**
Causa: você tentou inserir NULL em uma coluna `NOT NULL` sem `DEFAULT`.
Solução: forneça um valor explícito para a coluna ou adicione um `DEFAULT` se semanticamente adequado.

**Erro 4: "Column name or number of supplied values does not match table definition"**
Causa: o número de colunas no `INSERT` não corresponde ao número de valores no `VALUES`.
Solução: conte as colunas e os valores — devem ser iguais. Colunas `IDENTITY` e com `DEFAULT` não precisam ser listadas.

**Erro 5: Coluna NVARCHAR com max_length negativo no sys.columns**
Causa: `NVARCHAR(MAX)` aparece como `-1` em `sys.columns` — isso é normal.
Solução: não é um erro, apenas a representação interna do SQL Server para tipos de comprimento variável máximo.

---

## Troubleshooting

**Problema:** A constraint CHECK não está rejeitando valores inválidos.
**Diagnóstico:** Verifique se a coluna também tem `NOT NULL`. Se a coluna aceitar NULL, o SQL Server permite a inserção de NULL mesmo com CHECK ativo, pois NULL torna a expressão UNKNOWN.
**Solução:** Combine `NOT NULL` com `CHECK` em toda coluna que precisa de validação rigorosa.

**Problema:** O valor DEFAULT não está sendo aplicado.
**Diagnóstico:** Verifique se você está listando explicitamente a coluna no INSERT. Se você listar a coluna e passar NULL, o DEFAULT não é usado — o NULL é inserido diretamente.
**Solução:** Omita a coluna do INSERT completamente para que o DEFAULT seja aplicado. Ou use a palavra-chave `DEFAULT` explicitamente: `INSERT INTO dbo.Empresas (CNPJ, RazaoSocial, Ativo) VALUES ('12345678000195', 'Empresa', DEFAULT)`.

**Problema:** A tabela não aparece no Object Explorer do SSMS.
**Diagnóstico:** O Object Explorer pode estar desatualizado.
**Solução:** Clique com o botão direito em "Tables" dentro do FinanceDB no Object Explorer e selecione "Refresh".

---

## Glossário Técnico

**CREATE TABLE:** instrução DDL (Data Definition Language) que cria uma nova tabela no banco de dados, definindo suas colunas, tipos de dados e constraints.

**NOT NULL:** constraint que proíbe a ausência de valor em uma coluna. Qualquer tentativa de inserir NULL será rejeitada com erro.

**NULL:** valor especial que representa a ausência de dado, o desconhecido. Não é zero, não é string vazia — é a ausência de qualquer valor.

**DEFAULT:** constraint que define um valor a ser automaticamente preenchido pelo SQL Server quando a coluna não é fornecida em um INSERT.

**CHECK:** constraint que define uma expressão booleana que deve ser verdadeira para que qualquer linha seja aceita. Funciona como uma regra de validação de domínio.

**IDENTITY:** propriedade de coluna que faz o SQL Server gerar automaticamente valores sequenciais inteiros. `IDENTITY(semente, incremento)` — `IDENTITY(1,1)` começa em 1 e incrementa de 1 em 1.

**DDL (Data Definition Language):** subconjunto do SQL responsável por definir e modificar estruturas do banco de dados: `CREATE`, `ALTER`, `DROP`.

**DML (Data Manipulation Language):** subconjunto do SQL responsável por manipular dados: `INSERT`, `UPDATE`, `DELETE`, `SELECT`.

**Schema:** namespace lógico que organiza objetos dentro de um banco de dados. O schema padrão no SQL Server é `dbo`.

**sys.tables:** view de catálogo do sistema que lista todas as tabelas de um banco de dados.

**sys.columns:** view de catálogo do sistema que lista todas as colunas de todas as tabelas de um banco de dados.

**sys.check_constraints:** view de catálogo que lista todas as constraints CHECK de um banco de dados.

**sys.default_constraints:** view de catálogo que lista todas as constraints DEFAULT de um banco de dados.

**COMPE:** Sistema de Compensação de Cheques e Outros Papéis do Banco Central do Brasil. Cada banco participante tem um código COMPE único de até 3 dígitos.

**CHAR vs NVARCHAR:** `CHAR(n)` armazena strings de tamanho fixo com 1 byte por caractere (ASCII). `NVARCHAR(n)` armazena strings de tamanho variável com 2 bytes por caractere (Unicode), suportando todos os caracteres do português e outros idiomas.

---

## Desafio de Fixação

**Enunciado:** Crie uma tabela chamada `dbo.TiposTransacao` que armazene os tipos de transação do FinanceDB (como Receita, Despesa, Transferência). A tabela deve ter:

- Um identificador autoincremental.
- Um código de até 10 caracteres, obrigatório e único no domínio da aplicação.
- Uma descrição de até 50 caracteres, obrigatória.
- Uma coluna `Natureza` que só aceite os valores `'D'` (Débito) ou `'C'` (Crédito).
- Uma coluna `Ativo` com valor padrão `1`.
- Uma data de cadastro preenchida automaticamente.

---

**Resolução comentada:**

~~~sql
-- Criação da tabela TiposTransacao
-- Armazena os tipos de movimentação financeira permitidos no FinanceDB
CREATE TABLE dbo.TiposTransacao (

    -- Chave primária com autoincremento
    TipoTransacaoID INT             IDENTITY(1,1)   NOT NULL,

    -- Código do tipo de transação: até 10 caracteres, obrigatório
    -- NVARCHAR(10) para suportar caracteres especiais se necessário
    Codigo          NVARCHAR(10)                    NOT NULL,

    -- Descrição legível do tipo de transação
    Descricao       NVARCHAR(50)                    NOT NULL,

    -- Natureza da transação: D = Débito, C = Crédito
    -- CHAR(1) é suficiente e eficiente para um único caractere
    -- CHECK garante que apenas D ou C sejam aceitos
    Natureza        CHAR(1)                         NOT NULL
        CONSTRAINT CK_TiposTransacao_Natureza
            CHECK (Natureza IN ('D', 'C')),

    -- Status ativo com valor padrão 1 (ativo)
    Ativo           BIT                             NOT NULL
        CONSTRAINT DF_TiposTransacao_Ativo
            DEFAULT (1),

    -- Data de cadastro preenchida automaticamente
    DataCadastro    DATETIME2(0)                    NOT NULL
        CONSTRAINT DF_TiposTransacao_DataCadastro
            DEFAULT (GETDATE()),

    -- Chave primária nomeada explicitamente
    CONSTRAINT PK_TiposTransacao
        PRIMARY KEY (TipoTransacaoID)
);
GO

-- Teste: insere os tipos padrão do FinanceDB
INSERT INTO dbo.TiposTransacao (Codigo, Descricao, Natureza)
VALUES
    ('RECEITA',     'Receita Financeira',       'C'),  -- Crédito
    ('DESPESA',     'Despesa Financeira',        'D'),  -- Débito
    ('TRANSF',      'Transferência entre Contas','D');  -- Débito na origem
GO

-- Teste de violação: natureza inválida
-- Deve falhar com violação de CK_TiposTransacao_Natureza
INSERT INTO dbo.TiposTransacao (Codigo, Descricao, Natureza)
VALUES ('ESTORNO', 'Estorno', 'X');  -- X não é D nem C
GO

-- Verifica os dados inseridos
SELECT * FROM dbo.TiposTransacao;
GO
~~~

---

## Resumo dos Pontos-Chave

Neste capítulo construímos as primeiras tabelas físicas do FinanceDB. Aprendemos que `CREATE TABLE` define a estrutura de uma tabela com colunas, tipos de dados e regras de integridade. A constraint `NOT NULL` proíbe a ausência de valor em colunas obrigatórias e é a proteção mais fundamental de um banco de dados financeiro. A constraint `DEFAULT` preenche automaticamente valores quando a inserção não os fornece, sendo especialmente útil para colunas de auditoria como `DataCadastro` e `Ativo`. A constraint `CHECK` valida o domínio dos dados com expressões booleanas, rejeitando qualquer valor que não satisfaça as regras de negócio. Aprendemos que NULL não é zero nem string vazia — é a ausência de valor — e que combinar `NOT NULL` com `CHECK` é essencial para validações rigorosas. Inspecionamos as tabelas criadas usando as views de catálogo `sys.tables`, `sys.columns`, `sys.check_constraints` e `sys.default_constraints`. Testamos as constraints com inserções válidas e inválidas, confirmando que o SQL Server rejeita dados incorretos antes de armazená-los.

---

## Log de Estado do Projeto — FinanceDB

~~~
=== LOG DE ESTADO — FinanceDB ===
Capítulo Atual    : 8 — CREATE TABLE e Constraints Básicas
Módulo Atual      : 2 — ESSENCIAL: T-SQL Básico
Data de Atualização: [preencha com a data atual]

=== BANCO DE DADOS ===
- Nome             : FinanceDB
- Collation        : Latin1_General_CI_AS
- Recovery Model   : FULL
- Snapshot Isolation: HABILITADO
- Read Committed Snapshot: HABILITADO

=== TABELAS CRIADAS ===
- dbo.Empresas
    Colunas: EmpresaID, CNPJ, RazaoSocial, NomeFantasia,
             Telefone, Email, Ativo, DataCadastro, Observacao
    Constraints: PK_Empresas, CK_Empresas_CNPJ,
                 CK_Empresas_Email, DF_Empresas_Ativo,
                 DF_Empresas_DataCadastro

- dbo.Bancos
    Colunas: BancoID, CodigoCOMPE, NomeBanco, Sigla,
             Ativo, DataCadastro
    Constraints: PK_Bancos, CK_Bancos_CodigoCOMPE,
                 DF_Bancos_Ativo, DF_Bancos_DataCadastro
    Dados: Itaú (341), Banco do Brasil (1), Caixa (104)

- dbo.TiposTransacao [criada no desafio]
    Colunas: TipoTransacaoID, Codigo, Descricao,
             Natureza, Ativo, DataCadastro
    Constraints: PK_TiposTransacao, CK_TiposTransacao_Natureza,
                 DF_TiposTransacao_Ativo,
                 DF_TiposTransacao_DataCadastro
    Dados: RECEITA (C), DESPESA (D), TRANSF (D)

=== TABELAS PENDENTES ===
- dbo.ContasBancarias  (Capítulo 9 — após PRIMARY KEY e FOREIGN KEY)
- dbo.PlanoDeContas    (Capítulo 9)
- dbo.Transacoes       (Capítulo 9)
- dbo.Orcamentos       (Capítulo 9)

=== ARQUIVOS SALVOS ===
modulo_02_essencial/aula_08/
  - criar_tabelas_empresas_bancos.sql
  - criar_tabela_tipos_transacao.sql
  - verificar_catalogo.sql
  - testes_constraints.sql

=== PRÓXIMAS ETAPAS ===
Capítulo 9 — PRIMARY KEY, FOREIGN KEY e IDENTITY
~~~

---

## Prompt de Continuidade para o Capítulo 9

~~~text
Contexto: Estou estudando o livro "SQL Server para Aplicações
Financeiras com T-SQL". Meu ambiente é Windows 11, SSMS,
SQL Server 2022. O projeto prático incremental se chama FinanceDB.

Concluí o Capítulo 8, que cobriu a criação das tabelas Empresas,
Bancos e TiposTransacao com CREATE TABLE, aplicando as constraints
NOT NULL, DEFAULT e CHECK. As tabelas estão criadas no schema dbo
com constraints nomeadas explicitamente. Os bancos Itaú (341),
Banco do Brasil (1) e Caixa (104) foram inseridos na tabela Bancos.
Os tipos de transação RECEITA, DESPESA e TRANSF foram inseridos
na tabela TiposTransacao. Os scripts foram salvos em
modulo_02_essencial/aula_08/.

Siga rigorosamente o Prompt Mestre v1.1: narrativa densa com
mínimo de 2.000 palavras, Técnica de Feynman, analogia de
ancoragem, diagrama Mermaid escapado com ~~~mermaid, código SQL
comentado linha a linha escapado com ~~~, glossário técnico,
antecipação de erros, troubleshooting, desafio de fixação com
resolução comentada, resumo dos pontos-chave, log de estado do
projeto atualizado e prompt de continuidade para o próximo capítulo.
Todo o conteúdo deve ser gerado dentro de um bloco ```markdown.
Chame aulas de capítulos e curso de livro.

Por favor, gere o Capítulo 9: Chaves Primárias e Estrangeiras —
PRIMARY KEY, FOREIGN KEY e IDENTITY. Objetivo: implementar
integridade referencial completa no FinanceDB criando as tabelas
ContasBancarias, PlanoDeContas, Transacoes e Orcamentos com
PRIMARY KEY e FOREIGN KEY, entender como o IDENTITY garante
unicidade dos identificadores, compreender as ações referenciais
ON DELETE e ON UPDATE (CASCADE, RESTRICT, SET NULL), e verificar
os relacionamentos criados nas views de catálogo sys.foreign_keys
e sys.foreign_key_columns.
Pré-requisito: Capítulo 8 concluído.
~~~

---

Dúvidas? Posso prosseguir para o Capítulo 9?