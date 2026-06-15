# Capítulo 2: Teoria dos Bancos de Dados — Normalização e Formas Normais

## Livro: SQL Server para Aplicações Financeiras com T-SQL

## Módulo 1 — FUNDAMENTOS: Teoria e Ambiente

## Resumo do Capítulo Anterior

Na **Capítulo 1** aprendemos que um banco de dados relacional organiza dados em **tabelas** compostas por **linhas** e **colunas**. Entendemos a diferença entre **dado** e **informação**, conhecemos a origem matemática do modelo proposto por **Edgar Codd** em 1970, compreendemos o papel das **chaves primárias** e das **chaves estrangeiras** na identificação e no relacionamento de registros, e conhecemos as propriedades **ACID** que tornam o banco de dados relacional a escolha ideal para sistemas financeiros. Esboçamos também as primeiras entidades do nosso projeto: **Empresas**, **ContasBancarias**, **PlanoDeContas**, **Transacoes** e **Orcamentos**.

## Objetivo

Compreender o que é a **Normalização** de banco de dados, por que ela existe, quais problemas ela resolve e como aplicar as três primeiras formas normais — **1FN**, **2FN** e **3FN** — no contexto do projeto **FinanceDB**. Ao final deste Capítulo, você será capaz de identificar se uma tabela está ou não normalizada, diagnosticar os problemas que a falta de normalização causa e reestruturar tabelas financeiras de forma tecnicamente correta.

## Pré-requisitos

**Capítulo 1 concluído.** É necessário compreender os conceitos de tabela, linha, coluna, chave primária e chave estrangeira.

## Teoria Detalhada

### O problema que a normalização resolve

Imagine que você herdou uma planilha financeira de uma empresa. Nela, cada linha representa uma transação, e as colunas são: `id_transacao`, `data`, `valor`, `descricao`, `nome_conta`, `banco_da_conta`, `agencia_da_conta`, `nome_categoria`, `descricao_categoria`, `nome_empresa`, `cnpj_empresa` e `endereco_empresa`. À primeira vista, parece conveniente: em uma única linha você tem tudo sobre uma transação. Mas observe o que acontece quando você analisa algumas centenas de registros.

O nome da empresa `"Tech Finance Ltda"` aparece em todas as trezentas transações dessa empresa. O CNPJ `12.345.678/0001-99` se repete trezentas vezes. O nome da conta `"Conta Corrente Bradesco"` aparece em cento e cinquenta linhas. Agora imagine que a empresa muda de endereço. Você precisa atualizar trezentas linhas. Se esquecer de atualizar uma delas, o banco de dados passa a ter duas versões diferentes do mesmo endereço — e qual delas está correta? Ninguém sabe.

Esse é o problema central que a **Normalização** resolve: a **redundância de dados**, que por sua vez gera **anomalias** — situações em que o banco de dados fica em um estado inconsistente, contraditório ou incompleto.

### O que é normalização

**Normalização** é o processo de organizar as tabelas e colunas de um banco de dados relacional de forma a **reduzir a redundância** e **garantir a integridade dos dados**. O processo foi formalizado pelo próprio **Edgar Codd** como uma extensão natural da teoria relacional que ele havia proposto.

A normalização é aplicada por meio de **Formas Normais** — um conjunto de regras progressivas, onde cada forma normal pressupõe que a anterior já foi satisfeita. Existem formalmente até a **Forma Normal de Boyce-Codd (FNBC)**, a **4FN** e a **5FN**, mas na prática dos sistemas financeiros a aplicação das três primeiras formas normais — **1FN**, **2FN** e **3FN** — já é suficiente para eliminar a grande maioria dos problemas de redundância e inconsistência.

### Os três tipos de anomalias que a normalização elimina

Antes de estudar cada forma normal, precisamos entender exatamente quais problemas estamos resolvendo. Existem três tipos de **anomalias** que surgem em tabelas não normalizadas.

A **anomalia de inserção** acontece quando não é possível inserir um novo dado sem que outro dado relacionado também exista. Por exemplo: em uma tabela que mistura empresa e transação, não é possível cadastrar uma empresa que ainda não realizou nenhuma transação — porque a linha exigiria um `id_transacao`, que não existe.

A **anomalia de atualização** acontece quando uma informação está duplicada em múltiplas linhas e uma atualização parcial deixa o banco de dados em estado inconsistente. O exemplo do endereço da empresa descrito acima é exatamente esse caso.

A **anomalia de exclusão** acontece quando a exclusão de um registro causa a perda acidental de outros dados relacionados. Se a única transação de uma determinada conta bancária for excluída, e os dados da conta bancária estiverem na mesma linha da transação, os dados da conta também serão perdidos.

### Primeira Forma Normal — 1FN

Uma tabela está na **Primeira Forma Normal** quando satisfaz três condições: todos os valores de cada coluna são **atômicos** (indivisíveis), cada coluna contém valores de um **único tipo**, e cada linha é **única** e identificável por uma chave primária.

**Atomicidade** é o conceito central da 1FN. Um valor atômico é aquele que não pode ser subdividido em partes menores que ainda tenham significado para o banco de dados. Um valor como `"João Silva, Maria Souza"` em uma coluna `responsaveis` não é atômico — ele contém dois valores distintos em uma única célula. Da mesma forma, uma coluna `telefones` com o valor `"(11) 9999-1111, (11) 8888-2222"` viola a 1FN porque armazena múltiplos valores em um único campo.

No contexto do **FinanceDB**, considere uma versão não normalizada da tabela de transações:

~~~sql
-- ============================================================
-- EXEMPLO DE TABELA QUE VIOLA A 1FN
-- Problema: coluna 'categorias' armazena múltiplos valores
-- ============================================================

-- Esta estrutura viola a Primeira Forma Normal porque
-- a coluna 'categorias' contém múltiplos valores separados
-- por vírgula em uma única célula, o que torna impossível
-- filtrar por uma categoria específica sem manipulação de string.

-- id_transacao | data       | valor   | categorias
-- 1            | 2026-01-10 | 1500.00 | 'Aluguel, Fixo, Mensal'
-- 2            | 2026-01-15 | 350.00  | 'Alimentação, Variável'
~~~

Para corrigir essa violação e colocar a tabela na 1FN, cada valor deve ocupar sua própria linha e coluna, e uma chave primária deve identificar cada registro de forma única:

~~~sql
-- ============================================================
-- TABELA CORRIGIDA PARA 1FN
-- Cada valor é atômico e cada linha possui chave única
-- ============================================================

-- Tabela Categorias: cada categoria tem sua própria linha
-- id_categoria | descricao     | tipo
-- 1            | 'Aluguel'     | 'Fixo'
-- 2            | 'Alimentação' | 'Variável'

-- Tabela Transacoes: cada transação se relaciona
-- com uma única categoria via id_categoria (chave estrangeira)
-- id_transacao | data       | valor   | id_categoria
-- 1            | 2026-01-10 | 1500.00 | 1
-- 2            | 2026-01-15 | 350.00  | 2
~~~

### Segunda Forma Normal — 2FN

Uma tabela está na **Segunda Forma Normal** quando está na 1FN e todos os atributos não-chave dependem **completamente** da chave primária — e não apenas de uma parte dela. A 2FN só é relevante quando a chave primária é **composta** (formada por mais de uma coluna). Se a chave primária é simples (uma única coluna), a tabela já está automaticamente na 2FN desde que esteja na 1FN.

O conceito central aqui é a **dependência funcional parcial**: quando um atributo depende apenas de parte da chave primária composta, e não da chave inteira.

No contexto do **FinanceDB**, considere uma tabela de itens de orçamento onde a chave primária é composta por `id_orcamento` e `id_categoria`:

~~~sql
-- ============================================================
-- EXEMPLO DE TABELA QUE VIOLA A 2FN
-- Problema: dependência funcional parcial
-- Chave primária composta: (id_orcamento, id_categoria)
-- ============================================================

-- A coluna 'descricao_categoria' depende APENAS de id_categoria,
-- não da chave composta inteira (id_orcamento, id_categoria).
-- Isso é uma dependência parcial — violação da 2FN.

-- id_orcamento | id_categoria | valor_previsto | descricao_categoria
-- 1            | 2            | 5000.00        | 'Alimentação'
-- 1            | 3            | 2000.00        | 'Transporte'
-- 2            | 2            | 4500.00        | 'Alimentação'
-- 2            | 3            | 1800.00        | 'Transporte'

-- Problema: 'Alimentação' aparece duas vezes.
-- Se a descrição mudar, precisamos atualizar múltiplas linhas.
~~~

A solução é separar os dados em tabelas distintas, onde cada atributo depende completamente da chave primária da sua tabela:

~~~sql
-- ============================================================
-- TABELAS CORRIGIDAS PARA 2FN
-- Cada atributo depende completamente da chave primária
-- ============================================================

-- Tabela Categorias: descricao_categoria depende de id_categoria
-- id_categoria | descricao_categoria
-- 2            | 'Alimentação'
-- 3            | 'Transporte'

-- Tabela ItensOrcamento: valor_previsto depende da chave composta
-- id_orcamento | id_categoria | valor_previsto
-- 1            | 2            | 5000.00
-- 1            | 3            | 2000.00
-- 2            | 2            | 4500.00
-- 2            | 3            | 1800.00

-- Agora, se a descrição 'Alimentação' mudar, atualizamos
-- apenas UMA linha na tabela Categorias. Consistência garantida.
~~~

### Terceira Forma Normal — 3FN

Uma tabela está na **Terceira Forma Normal** quando está na 2FN e nenhum atributo não-chave depende de outro atributo não-chave. Em outras palavras, todos os atributos devem depender **diretamente** da chave primária, e nunca de outros atributos não-chave. Esse tipo de problema é chamado de **dependência transitiva**.

Pense assim: se `A` é a chave primária, `B` é um atributo não-chave, e `C` é outro atributo não-chave, e `C` depende de `B` (que por sua vez depende de `A`), então `C` depende transitivamente de `A` — e isso viola a 3FN.

No contexto do **FinanceDB**, considere a tabela de contas bancárias:

~~~sql
-- ============================================================
-- EXEMPLO DE TABELA QUE VIOLA A 3FN
-- Problema: dependência transitiva
-- Chave primária: id_conta
-- ============================================================

-- id_conta | descricao          | id_banco | nome_banco  | codigo_banco
-- 1        | 'Conta Corrente'   | 237      | 'Bradesco'  | '237-2'
-- 2        | 'Conta Poupança'   | 237      | 'Bradesco'  | '237-2'
-- 3        | 'Conta Corrente'   | 341      | 'Itaú'      | '341-7'

-- Problema: 'nome_banco' e 'codigo_banco' dependem de 'id_banco',
-- não de 'id_conta'. Isso é uma dependência transitiva.
-- id_conta → id_banco → nome_banco (transitiva — viola 3FN)
-- Se o nome do banco mudar, precisamos atualizar múltiplas linhas.
~~~

A solução, como nas formas anteriores, é separar os dados:

~~~sql
-- ============================================================
-- TABELAS CORRIGIDAS PARA 3FN
-- Cada atributo depende diretamente da chave primária da sua tabela
-- ============================================================

-- Tabela Bancos: nome_banco e codigo_banco dependem de id_banco
-- id_banco | nome_banco | codigo_banco
-- 237      | 'Bradesco' | '237-2'
-- 341      | 'Itaú'     | '341-7'

-- Tabela ContasBancarias: apenas id_banco como referência ao banco
-- id_conta | descricao        | id_banco | id_empresa
-- 1        | 'Conta Corrente' | 237      | 1
-- 2        | 'Conta Poupança' | 237      | 1
-- 3        | 'Conta Corrente' | 341      | 1

-- Agora, se o nome do banco 'Bradesco' mudar,
-- atualizamos apenas UMA linha na tabela Bancos.
~~~

### Aplicando as três formas normais ao FinanceDB

Com as três formas normais aplicadas, o modelo do **FinanceDB** começa a tomar forma com clareza e consistência. Veja como as entidades se relacionam após a normalização completa:

~~~sql
-- ============================================================
-- ESBOÇO NORMALIZADO DO FINANCEDB — APÓS 1FN, 2FN E 3FN
-- Este é o mapa conceitual que guiará a criação das tabelas
-- nas Capítulos 7, 8 e 9. Por ora, são apenas comentários explicativos.
-- ============================================================

-- TABELA: Empresas
-- Armazena as empresas que utilizam o sistema financeiro.
-- Chave primária: id_empresa
-- Dependência: todos os atributos dependem diretamente de id_empresa.
-- Colunas: id_empresa, razao_social, cnpj, endereco, telefone

-- TABELA: Bancos
-- Armazena os bancos disponíveis no sistema.
-- Chave primária: id_banco
-- Dependência: nome_banco e codigo_compensacao dependem de id_banco.
-- Colunas: id_banco, nome_banco, codigo_compensacao

-- TABELA: ContasBancarias
-- Cada conta pertence a uma empresa e a um banco.
-- Chave primária: id_conta
-- Chaves estrangeiras: id_empresa → Empresas, id_banco → Bancos
-- Colunas: id_conta, descricao, agencia, numero_conta,
--          saldo_inicial, id_empresa, id_banco

-- TABELA: PlanoDeContas
-- Categorias contábeis para classificar as transações.
-- Chave primária: id_plano
-- Colunas: id_plano, codigo, descricao, tipo ('R' ou 'D'),
--          id_plano_pai (para hierarquia de contas — SELF JOIN no Capítulo 17)

-- TABELA: Transacoes
-- Cada lançamento financeiro do sistema.
-- Chave primária: id_transacao
-- Chaves estrangeiras: id_conta → ContasBancarias,
--                      id_plano → PlanoDeContas
-- Colunas: id_transacao, data_lancamento, data_competencia,
--          descricao, valor, tipo ('R' ou 'D'),
--          id_conta, id_plano, id_empresa

-- TABELA: Orcamentos
-- Orçamento previsto por categoria e período.
-- Chave primária: id_orcamento
-- Chaves estrangeiras: id_plano → PlanoDeContas,
--                      id_empresa → Empresas
-- Colunas: id_orcamento, ano, mes, valor_previsto,
--          id_plano, id_empresa
~~~

### Normalização e desnormalização — quando quebrar as regras

É importante que você saiba que a normalização não é uma lei absoluta. Em sistemas de **alta performance** ou em **data warehouses** (bancos de dados analíticos), a **desnormalização controlada** é uma técnica comum — onde redundância é introduzida intencionalmente para reduzir o número de JOINs e acelerar consultas de leitura intensiva.

No contexto do **FinanceDB**, que é um sistema **OLTP** (Online Transaction Processing — processamento transacional online), a normalização completa até a 3FN é a abordagem correta. Sistemas OLTP priorizam **consistência** e **velocidade de escrita**, enquanto sistemas **OLAP** (Online Analytical Processing) priorizam **velocidade de leitura**. Essa distinção será retomada no **Módulo 5**, quando estudarmos performance e o **Azure SQL** no Módulo 6.

## Analogia de Ancoragem

Pense em um escritório de contabilidade que guarda documentos físicos. No começo, sem organização, tudo vai para uma única caixa enorme: contratos, notas fiscais, extratos bancários, dados de clientes — tudo misturado. Quando precisam encontrar o endereço atualizado de um cliente, precisam revirar a caixa inteira e ainda correm o risco de encontrar dois endereços diferentes para o mesmo cliente em documentos distintos.

A **normalização** é o equivalente a criar um arquivo organizado com gavetas separadas: uma gaveta para **clientes**, uma para **bancos**, uma para **categorias contábeis** e uma para **lançamentos**. Cada documento vai para a gaveta certa, sem repetição. Se o endereço de um cliente muda, você atualiza em um único lugar — na ficha do cliente na gaveta de clientes — e todos os documentos que referenciam aquele cliente automaticamente refletem a informação correta, porque apontam para a mesma ficha.

A **1FN** é a regra de que cada documento deve conter apenas uma informação por campo — sem listas, sem valores misturados. A **2FN** é a regra de que cada informação deve estar na gaveta correta, não espalhada entre gavetas que não são as suas. A **3FN** é a regra de que as informações dentro de uma gaveta devem se referir diretamente ao dono da gaveta — não a outros documentos dentro da mesma gaveta.

## Diagrama Mermaid

~~~mermaid
---
config:
  theme: redux-color
---
erDiagram
    Empresas {
        int id_empresa PK
        varchar razao_social
        varchar cnpj
        varchar endereco
        varchar telefone
    }

    Bancos {
        int id_banco PK
        varchar nome_banco
        varchar codigo_compensacao
    }

    ContasBancarias {
        int id_conta PK
        varchar descricao
        varchar agencia
        varchar numero_conta
        decimal saldo_inicial
        int id_empresa FK
        int id_banco FK
    }

    PlanoDeContas {
        int id_plano PK
        varchar codigo
        varchar descricao
        char tipo
        int id_plano_pai FK
    }

    Transacoes {
        int id_transacao PK
        date data_lancamento
        date data_competencia
        varchar descricao
        decimal valor
        char tipo
        int id_conta FK
        int id_plano FK
        int id_empresa FK
    }

    Orcamentos {
        int id_orcamento PK
        int ano
        int mes
        decimal valor_previsto
        int id_plano FK
        int id_empresa FK
    }

    Empresas ||--o{ ContasBancarias : "possui"
    Bancos ||--o{ ContasBancarias : "opera"
    ContasBancarias ||--o{ Transacoes : "registra"
    PlanoDeContas ||--o{ Transacoes : "classifica"
    PlanoDeContas ||--o{ Orcamentos : "prevê"
    Empresas ||--o{ Orcamentos : "define"
    PlanoDeContas ||--o{ PlanoDeContas : "hierarquia"
    Empresas ||--o{ Transacoes : "pertence"
~~~

## Aplicação no Projeto Prático

Nesto Capítulo ainda não executaremos código T-SQL no SSMS — o banco de dados será criado na **Capítulo 7**. O entregável deste Capítulo é o **modelo conceitual normalizado** documentado em um arquivo de comentários SQL, que servirá como planta arquitetônica para todas as criações de tabelas que virão a seguir.

~~~sql
-- ============================================================
-- ARQUIVO: modulo_01_fundamentos/Capítulo_02/modelo_conceitual.sql
-- PROJETO: FinanceDB — Sistema de Controle Financeiro Corporativo
-- Capítulo: 2 — Normalização e Formas Normais
-- OBJETIVO: Documentar o modelo conceitual normalizado do FinanceDB
--           Este arquivo é a planta arquitetônica do banco de dados.
--           Nenhum comando será executado aqui — apenas documentação.
-- ============================================================

-- ============================================================
-- ENTIDADE 1: Empresas
-- Forma Normal: 3FN ✅
-- Justificativa: todos os atributos dependem diretamente de
--   id_empresa. Não há grupos repetitivos (1FN), não há
--   dependências parciais (2FN) e não há dependências
--   transitivas (3FN).
-- ============================================================
-- id_empresa       INT           → chave primária, identificador único
-- razao_social     VARCHAR(200)  → nome jurídico da empresa
-- cnpj             CHAR(18)      → CNPJ no formato XX.XXX.XXX/XXXX-XX
-- endereco         VARCHAR(300)  → endereço completo da sede
-- telefone         VARCHAR(20)   → telefone principal de contato

-- ============================================================
-- ENTIDADE 2: Bancos
-- Forma Normal: 3FN ✅
-- Justificativa: nome_banco e codigo_compensacao dependem
--   diretamente de id_banco. Separamos Bancos de ContasBancarias
--   para eliminar a dependência transitiva identificada na teoria.
-- ============================================================
-- id_banco             INT          → chave primária
-- nome_banco           VARCHAR(100) → nome do banco (ex: 'Bradesco')
-- codigo_compensacao   CHAR(10)     → código de compensação do banco

-- ============================================================
-- ENTIDADE 3: ContasBancarias
-- Forma Normal: 3FN ✅
-- Justificativa: todos os atributos descrevem a conta bancária
--   diretamente. A referência ao banco é feita via id_banco (FK),
--   eliminando a dependência transitiva nome_banco → id_banco.
-- ============================================================
-- id_conta         INT            → chave primária
-- descricao        VARCHAR(100)   → ex: 'Conta Corrente Bradesco'
-- agencia          VARCHAR(10)    → número da agência bancária
-- numero_conta     VARCHAR(20)    → número da conta com dígito
-- saldo_inicial    DECIMAL(18,2)  → saldo no momento do cadastro
-- id_empresa       INT            → FK → Empresas
-- id_banco         INT            → FK → Bancos

-- ============================================================
-- ENTIDADE 4: PlanoDeContas
-- Forma Normal: 3FN ✅
-- Justificativa: cada atributo descreve diretamente a conta
--   contábil. id_plano_pai permite hierarquia de contas
--   (SELF JOIN), estudado no Capítulo 17.
-- ============================================================
-- id_plano         INT           → chave primária
-- codigo           VARCHAR(20)   → código contábil (ex: '1.1.1')
-- descricao        VARCHAR(200)  → descrição da conta contábil
-- tipo             CHAR(1)       → 'R' = Receita, 'D' = Despesa
-- id_plano_pai     INT           → FK → PlanoDeContas (hierarquia)

-- ============================================================
-- ENTIDADE 5: Transacoes
-- Forma Normal: 3FN ✅
-- Justificativa: todos os atributos descrevem o lançamento
--   financeiro diretamente. Dados do banco, da empresa e da
--   categoria são referenciados via FK, sem duplicação.
-- ============================================================
-- id_transacao       INT            → chave primária
-- data_lancamento    DATE           → data do registro no sistema
-- data_competencia   DATE           → data de competência contábil
-- descricao          VARCHAR(300)   → descrição do lançamento
-- valor              DECIMAL(18,2)  → valor em reais (sempre positivo)
-- tipo               CHAR(1)        → 'R' = Receita, 'D' = Despesa
-- id_conta           INT            → FK → ContasBancarias
-- id_plano           INT            → FK → PlanoDeContas
-- id_empresa         INT            → FK → Empresas

-- ============================================================
-- ENTIDADE 6: Orcamentos
-- Forma Normal: 3FN ✅
-- Justificativa: valor_previsto depende da combinação de
--   ano, mes, id_plano e id_empresa — não há dependências
--   parciais ou transitivas.
-- ============================================================
-- id_orcamento     INT            → chave primária
-- ano              INT            → ano do orçamento (ex: 2026)
-- mes              INT            → mês do orçamento (1 a 12)
-- valor_previsto   DECIMAL(18,2)  → valor planejado para o período
-- id_plano         INT            → FK → PlanoDeContas
-- id_empresa       INT            → FK → Empresas

-- ============================================================
-- DECISÕES DE DESIGN DOCUMENTADAS
-- ============================================================

-- DECISÃO 1: Por que separamos Bancos de ContasBancarias?
-- Para eliminar a dependência transitiva identificada na 3FN:
-- id_conta → id_banco → nome_banco (transitiva — violação 3FN).
-- Com a separação, nome_banco depende diretamente de id_banco
-- na tabela Bancos, e ContasBancarias apenas referencia id_banco.

-- DECISÃO 2: Por que usamos dois campos de data em Transacoes?
-- data_lancamento: quando o registro foi criado no sistema.
-- data_competencia: quando o fato gerador ocorreu contabilmente.
-- Em sistemas financeiros, esses dois momentos frequentemente
-- diferem. A separação é fundamental para relatórios contábeis
-- precisos e para o princípio da competência contábil.

-- DECISÃO 3: Por que valor é sempre positivo em Transacoes?
-- O tipo da transação ('R' ou 'D') já indica se é entrada ou
-- saída. Armazenar valores negativos para despesas cria
-- ambiguidade em somas e médias. A convenção de valor positivo
-- com campo tipo é a prática padrão em sistemas financeiros.

-- DECISÃO 4: Por que PlanoDeContas tem id_plano_pai?
-- O plano de contas contábil é naturalmente hierárquico:
-- 1. Receitas
--   1.1. Receitas Operacionais
--     1.1.1. Vendas de Produtos
-- O campo id_plano_pai referencia a própria tabela (SELF JOIN),
-- permitindo representar essa hierarquia sem tabelas adicionais.
-- Estudaremos SELF JOIN em detalhes no Capítulo 17.
~~~

## Glossário Técnico do Capítulo

**Normalização:** processo de organizar tabelas e colunas de um banco de dados para reduzir redundância e garantir integridade dos dados, aplicado progressivamente por meio de formas normais.

**Forma Normal:** um conjunto de regras que define o nível de organização de uma tabela. Cada forma normal pressupõe que a anterior foi satisfeita.

**1FN — Primeira Forma Normal:** exige que todos os valores sejam atômicos (indivisíveis), que cada coluna contenha valores de um único tipo e que cada linha seja identificável por uma chave primária.

**2FN — Segunda Forma Normal:** exige 1FN e que todos os atributos não-chave dependam completamente da chave primária — eliminando dependências parciais em chaves compostas.

**3FN — Terceira Forma Normal:** exige 2FN e que nenhum atributo não-chave dependa de outro atributo não-chave — eliminando dependências transitivas.

**Atomicidade (de dados):** propriedade de um valor que não pode ser subdividido em partes menores com significado próprio para o banco de dados. Não confundir com Atomicidade do ACID.

**Dependência Funcional:** relação entre atributos onde o valor de um atributo determina o valor de outro. Se `id_banco` determina `nome_banco`, dizemos que `nome_banco` tem dependência funcional de `id_banco`.

**Dependência Parcial:** quando um atributo depende apenas de parte de uma chave primária composta — violação da 2FN.

**Dependência Transitiva:** quando um atributo não-chave depende de outro atributo não-chave, e não diretamente da chave primária — violação da 3FN.

**Anomalia de Inserção:** impossibilidade de inserir um dado sem que outro dado relacionado exista.

**Anomalia de Atualização:** necessidade de atualizar o mesmo dado em múltiplas linhas, com risco de inconsistência.

**Anomalia de Exclusão:** perda acidental de dados relacionados ao excluir um registro.

**OLTP:** Online Transaction Processing — sistema otimizado para operações transacionais frequentes de escrita e leitura, como o FinanceDB.

**OLAP:** Online Analytical Processing — sistema otimizado para consultas analíticas complexas sobre grandes volumes de dados históricos.

**Desnormalização:** introdução controlada de redundância em um banco de dados para melhorar performance de leitura, aplicada geralmente em sistemas OLAP.

**Modelo Conceitual:** representação das entidades, atributos e relacionamentos de um sistema, independente da implementação técnica. É a planta do banco de dados.

## Antecipação de Erros

**Erro 1 — Confundir atomicidade de dados com atomicidade do ACID:** a atomicidade da 1FN se refere à indivisibilidade de um valor em uma coluna. A atomicidade do ACID (vista no Capítulo 1) se refere à indivisibilidade de uma transação como um todo. São conceitos distintos que compartilham o mesmo nome.

**Erro 2 — Aplicar 2FN em tabelas com chave simples:** a Segunda Forma Normal só é relevante quando a chave primária é composta. Se a tabela tem uma chave primária de uma única coluna e já está na 1FN, ela automaticamente satisfaz a 2FN. Muitos iniciantes passam tempo analisando dependências parciais em tabelas com chave simples — esforço desnecessário.

**Erro 3 — Normalizar demais (over-normalization):** é possível levar a normalização além do necessário, fragmentando tabelas a ponto de exigir dezenas de JOINs para consultas simples. A 3FN é o ponto de equilíbrio ideal para sistemas OLTP como o FinanceDB. As formas normais superiores (FNBC, 4FN, 5FN) raramente são necessárias na prática do desenvolvimento financeiro.

**Erro 4 — Não documentar as decisões de design:** cada decisão de normalização que você toma tem uma razão técnica. Se você não documenta essas razões (como fizemos nos comentários do modelo conceitual), outro desenvolvedor — ou você mesmo daqui a seis meses — não saberá por que a tabela foi estruturada daquele jeito e poderá desfazer decisões corretas sem perceber.

## Troubleshooting

**"Não sei identificar se uma tabela viola a 1FN":** faça uma única pergunta sobre cada coluna: "esse valor pode ser subdividido em partes menores que ainda tenham significado?" Se a resposta for sim, a coluna viola a 1FN. Exemplos clássicos de violações: listas separadas por vírgula em uma célula, múltiplos telefones em uma coluna, endereços completos em um único campo (quando você precisará filtrar por cidade ou CEP separadamente).

**"Não consigo identificar dependências transitivas":** trace o caminho das dependências. Comece pela chave primária e pergunte: "este atributo depende diretamente da chave, ou depende de outro atributo que por sua vez depende da chave?" Se você encontrar um intermediário no caminho, há uma dependência transitiva. No exemplo do FinanceDB: `id_conta → id_banco → nome_banco`. O `nome_banco` não depende de `id_conta` diretamente — ele depende de `id_banco`, que depende de `id_conta`. Isso é transitivo.

**"Meu modelo ficou com muitas tabelas — normalizei demais?":** no FinanceDB, chegamos a 6 tabelas para um sistema financeiro completo. Isso é adequado. Se você se encontrar com 20 tabelas para um sistema simples, revise se não está separando atributos que naturalmente pertencem à mesma entidade.

## Desafio de Fixação

**Desafio:** analise a tabela abaixo, que representa um sistema de contas a pagar não normalizado. Identifique todas as violações de 1FN, 2FN e 3FN que você conseguir encontrar, e proponha o modelo normalizado correto com as tabelas separadas e os comentários explicando cada decisão.

~~~sql
-- ============================================================
-- TABELA NÃO NORMALIZADA: ContasPagar
-- Analise e identifique todas as violações de 1FN, 2FN e 3FN
-- ============================================================

-- id_conta_pagar | data_venc  | valor   | fornecedores              | id_categoria | desc_categoria | id_empresa | nome_empresa    | cnpj_empresa
-- 1              | 2026-02-10 | 3500.00 | 'Fornec. A, Fornec. B'   | 5            | 'Serviços TI'  | 1          | 'Tech Fin Ltda' | '12.345.678/0001-99'
-- 2              | 2026-02-15 | 1200.00 | 'Fornec. C'               | 5            | 'Serviços TI'  | 1          | 'Tech Fin Ltda' | '12.345.678/0001-99'
-- 3              | 2026-02-20 | 800.00  | 'Fornec. A'               | 6            | 'Material'     | 2          | 'Finance Corp'  | '98.765.432/0001-11'
~~~

## Resolução Comentada

~~~sql
-- ============================================================
-- RESOLUÇÃO DO DESAFIO — Normalização de ContasPagar
-- ============================================================

-- VIOLAÇÕES IDENTIFICADAS:

-- VIOLAÇÃO DA 1FN:
-- A coluna 'fornecedores' contém múltiplos valores separados por
-- vírgula ('Fornec. A, Fornec. B'). Isso não é atômico.
-- Um lançamento pode ter apenas um fornecedor responsável.
-- A lista deve ser resolvida com uma tabela de Fornecedores
-- e uma chave estrangeira na tabela principal.

-- VIOLAÇÃO DA 3FN (dependência transitiva 1):
-- id_conta_pagar → id_categoria → desc_categoria
-- 'desc_categoria' depende de id_categoria, não de id_conta_pagar.
-- Solução: tabela Categorias separada.

-- VIOLAÇÃO DA 3FN (dependência transitiva 2):
-- id_conta_pagar → id_empresa → nome_empresa
-- id_conta_pagar → id_empresa → cnpj_empresa
-- 'nome_empresa' e 'cnpj_empresa' dependem de id_empresa,
-- não de id_conta_pagar.
-- Solução: tabela Empresas separada (já definida no FinanceDB).

-- ============================================================
-- MODELO NORMALIZADO PROPOSTO
-- ============================================================

-- TABELA: Fornecedores
-- Resolve a violação da 1FN e organiza dados dos fornecedores.
-- id_fornecedor  INT          → chave primária
-- nome           VARCHAR(200) → nome do fornecedor
-- cnpj           CHAR(18)     → CNPJ do fornecedor

-- TABELA: Categorias
-- Resolve a dependência transitiva de desc_categoria.
-- id_categoria   INT          → chave primária
-- descricao      VARCHAR(200) → ex: 'Serviços TI', 'Material'

-- TABELA: Empresas (já existente no FinanceDB)
-- Resolve a dependência transitiva de nome_empresa e cnpj_empresa.
-- id_empresa     INT          → chave primária
-- nome_empresa   VARCHAR(200) → nome da empresa
-- cnpj           CHAR(18)     → CNPJ da empresa

-- TABELA: ContasPagar (normalizada)
-- Cada atributo depende diretamente de id_conta_pagar.
-- Fornecedores, categorias e empresas são referenciados via FK.
-- id_conta_pagar  INT            → chave primária
-- data_vencimento DATE           → data de vencimento do título
-- valor           DECIMAL(18,2)  → valor do título a pagar
-- id_fornecedor   INT            → FK → Fornecedores (1FN resolvida)
-- id_categoria    INT            → FK → Categorias   (3FN resolvida)
-- id_empresa      INT            → FK → Empresas     (3FN resolvida)

-- RESULTADO:
-- ✅ 1FN: todos os valores são atômicos. Fornecedores em tabela própria.
-- ✅ 2FN: chave primária simples — não há dependências parciais.
-- ✅ 3FN: nenhum atributo não-chave depende de outro atributo não-chave.
--         desc_categoria → tabela Categorias
--         nome_empresa, cnpj_empresa → tabela Empresas
~~~

## Resumo dos Pontos-Chave

A **Normalização** é o processo de organizar tabelas para eliminar **redundância** e evitar **anomalias de inserção, atualização e exclusão**. A **1FN** exige que todos os valores sejam **atômicos** e que cada linha tenha uma **chave primária**. A **2FN** elimina **dependências parciais** em chaves compostas. A **3FN** elimina **dependências transitivas** entre atributos não-chave. Para sistemas **OLTP** como o **FinanceDB**, a normalização até a **3FN** é a abordagem correta e suficiente. O modelo conceitual normalizado do FinanceDB possui **6 entidades**: **Empresas**, **Bancos**, **ContasBancarias**, **PlanoDeContas**, **Transacoes** e **Orcamentos** — todas na 3FN, prontas para serem implementadas em T-SQL a partir do Capítulo 7.

## Próximos Passos

Na próximo Capítulo, mergulharemos dentro do próprio SQL Server para entender como ele funciona internamente: como processa uma query, como gerencia a memória com o **Buffer Pool**, como o **Transaction Log** garante a durabilidade dos dados e quais são os componentes principais da arquitetura — **Storage Engine**, **Query Processor** e **SQLOS**. Esse conhecimento é essencial tanto para escrever T-SQL eficiente quanto para a certificação.

## Log de Estado do Projeto

~~~text
## Log de Estado — Capítulo 2
- Projeto: FinanceDB
- Módulo: 1 — Fundamentos e Teoria
- Capítulo: 2 — Normalização e Formas Normais
- Objetivo: Concluído ✅
- Banco de Dados: Não criado (Capítulo 7)
- Tabelas: Não criadas (Capítulo 7 e 8)
- Dados: Nenhum
- Entregável do Capítulo: modelo_conceitual.sql com 6 entidades
  normalizadas até a 3FN e decisões de design documentadas
- Entidades Definidas:
    ✅ Empresas
    ✅ Bancos
    ✅ ContasBancarias
    ✅ PlanoDeContas
    ✅ Transacoes
    ✅ Orcamentos
- Estado Funcional: ✅ Modelo conceitual normalizado e documentado.
- Próximas Etapas: Capítulo 3 — Arquitetura interna do SQL Server
~~~

## Prompt de Continuidade para o Capítulo 3

~~~text
Contexto: Estou estudando o Livro "SQL Server para Aplicações
Financeiras com T-SQL". Meu ambiente é Windows 11, SSMS,
SQL Server 2022. O projeto prático incremental se chama FinanceDB.

Concluí o Capítulo 2, que cobriu Normalização e Formas Normais.
O modelo conceitual normalizado do FinanceDB está definido
com 6 entidades na 3FN: Empresas, Bancos, ContasBancarias,
PlanoDeContas, Transacoes e Orcamentos. O arquivo
modelo_conceitual.sql foi criado em modulo_01_fundamentos/Capítulo_02/.

Siga rigorosamente o Prompt Mestre v1.1: narrativa densa com
mínimo de 2.000 palavras, Técnica de Feynman, analogia de
ancoragem, diagrama Mermaid escapado com ~~~mermaid, código SQL
comentado linha a linha escapado com ~~~, glossário técnico,
antecipação de erros, troubleshooting, desafio de fixação com
resolução comentada, resumo dos pontos-chave, log de estado do
projeto atualizado e prompt de continuidade para a próximo Capítulo.
Todo o conteúdo deve ser gerado dentro de um bloco ```markdown.

Por favor, gere o Capítulo 3: O SQL Server por Dentro — Arquitetura
e Componentes. Objetivo: entender como o SQL Server processa
queries internamente, como gerencia memória com o Buffer Pool,
como funciona o Transaction Log, quais são os componentes
principais (Storage Engine, Query Processor, SQLOS) e como essa
arquitetura impacta o desempenho e a confiabilidade do FinanceDB.
Pré-requisito: Capítulos 1 e 2 concluídas.
~~~

Dúvidas? Posso prosseguir para o Capítulo 3?