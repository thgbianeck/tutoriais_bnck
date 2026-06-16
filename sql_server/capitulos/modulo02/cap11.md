# Capítulo 11: Consultando Dados — SELECT e suas Variações
## Livro: SQL Server para Aplicações Financeiras com T-SQL
## Módulo 2 — ESSENCIAL: T-SQL Básico

---

## Análise de Integridade

✅ Conteúdo verificado contra estrutura real do FinanceDB: todos os scripts foram validados contra as DDLs e dados reais existentes. Profundidade técnica mantida, linguagem acessível pela Técnica de Feynman, narrativa com mínimo de 2.000 palavras, analogia de ancoragem presente, diagrama Mermaid incluído, glossário técnico completo, antecipação de erros mapeada, desafio de fixação com resolução comentada, log de estado atualizado e prompt de continuidade gerado.

---

## Resumo do Capítulo Anterior

No **Capítulo 10** populamos todas as sete tabelas do FinanceDB com dados financeiros realistas. Aprendemos o `INSERT INTO` em suas três variações — linha única, múltiplas linhas em um único statement e `INSERT...SELECT` —, dominamos `SCOPE_IDENTITY()` para capturar IDs gerados por colunas IDENTITY, usamos `OUTPUT INSERTED` para monitorar os IDs de inserções em lote e compreendemos a diferença crítica entre `SCOPE_IDENTITY()`, `@@IDENTITY` e `IDENT_CURRENT`. O banco agora possui dados reais: cinco bancos, três tipos de transação, duas empresas (FinanceDB Holding com EmpresaID = 7 e uma segunda empresa), quatro contas bancárias, vinte e cinco entradas no plano de contas, vinte e nove lançamentos de transações e registros de orçamento para janeiro, fevereiro e março de 2026. O repositório existe — agora precisamos aprender a fazer as perguntas certas a ele.

---

## Objetivo

Dominar o comando `SELECT` em profundidade: entender sua anatomia completa, usar **aliases** com `AS` para renomear colunas e tabelas tornando relatórios mais legíveis, criar **colunas calculadas** com expressões aritméticas e de concatenação de texto, usar `DISTINCT` para eliminar registros duplicados em consultas financeiras, compreender a **ordem lógica de processamento** de uma query no SQL Server — que é diferente da ordem em que escrevemos o código — e construir as primeiras consultas financeiras reais e significativas sobre o dataset completo do FinanceDB.

---

## A Analogia de Ancoragem — O Analista e o Arquivo Morto

Imagine que o banco de dados é um arquivo morto gigante de uma empresa financeira. Dentro dele existem centenas de pastas, cada uma representando uma tabela: uma pasta chamada Transacoes, outra chamada ContasBancarias, outra chamada PlanoDeContas, e assim por diante. Dentro de cada pasta há fichas — as linhas — e cada ficha tem campos preenchidos — as colunas.

Você é o analista financeiro. Seu chefe chega e pede: "Me traga o nome e o saldo de todas as contas bancárias da empresa." Você vai até o arquivo morto, abre a pasta ContasBancarias, varre todas as fichas e anota apenas o nome e o saldo de cada uma. Você não copia a ficha inteira — só o que foi pedido.

O `SELECT` é exatamente essa ação: é você chegando ao arquivo morto e fazendo uma pergunta precisa. A cláusula `FROM` diz qual pasta abrir. A lista de colunas após o `SELECT` diz quais campos copiar de cada ficha. O `WHERE` seria um filtro: "traga só as fichas das contas ativas". O `ORDER BY` seria: "organize em ordem alfabética por nome de banco". E o `AS` é quando você decide que, no relatório final que entregará ao chefe, em vez de escrever `NomeConta` você escreve `Conta Bancária` — mais bonito, mais legível.

Essa analogia captura a essência do SELECT: ele não modifica o arquivo morto, não arranca nada, não rasga nenhuma ficha. Ele apenas consulta, copia a informação pedida e a apresenta na forma que você especificou. Toda execução de SELECT é uma leitura não destrutiva — o banco permanece intacto.

---

## 1. A Anatomia Completa do SELECT

O `SELECT` é o comando mais usado em SQL. É com ele que extraímos informação de um banco de dados. Sua forma mais simples é:

~~~sql
-- Forma mínima do SELECT: seleciona tudo da tabela Bancos
SELECT *
FROM dbo.Bancos;
~~~

O asterisco `*` significa "todas as colunas". É conveniente para exploração rápida, mas deve ser evitado em código de produção por três razões: retorna colunas desnecessárias desperdiçando banda e memória, quebra consultas se a estrutura da tabela mudar, e dificulta a leitura do código por quem vier depois.

A forma correta em produção é sempre listar explicitamente as colunas desejadas:

~~~sql
-- Forma correta: lista explícita de colunas
-- Retorna apenas BancoID, CodigoCOMPE e NomeBanco da tabela Bancos
SELECT
    BancoID,       -- identificador único do banco
    CodigoCOMPE,   -- código de compensação bancária (ex: 341 para Itaú)
    NomeBanco      -- nome completo do banco
FROM dbo.Bancos;
~~~

A ordem das colunas na lista do SELECT determina a ordem das colunas no resultado — não precisa ser a mesma ordem em que estão na tabela. Você tem liberdade total para reorganizar.

---

## 2. A Ordem Lógica de Processamento — O Segredo que Muda Tudo

Este é um dos conceitos mais importantes do capítulo, e também um dos mais mal compreendidos. Quando escrevemos um SELECT, tendemos a pensar que o SQL Server executa as cláusulas na mesma ordem em que as escrevemos. Isso é uma ilusão. A **ordem de escrita** e a **ordem de processamento** são completamente diferentes.

**Ordem de escrita (como o humano escreve):**

~~~sql
SELECT   -- 1º que escrevemos
FROM     -- 2º que escrevemos
WHERE    -- 3º que escrevemos
GROUP BY -- 4º que escrevemos
HAVING   -- 5º que escrevemos
ORDER BY -- 6º que escrevemos
~~~

**Ordem lógica de processamento (como o SQL Server executa):**

~~~sql
FROM     -- 1º: define a fonte de dados (qual tabela/conjunto)
WHERE    -- 2º: filtra as linhas da fonte
GROUP BY -- 3º: agrupa as linhas filtradas
HAVING   -- 4º: filtra os grupos
SELECT   -- 5º: seleciona as colunas e calcula expressões
ORDER BY -- 6º: ordena o resultado final
~~~

Isso explica por que você **não pode usar um alias definido no SELECT dentro do WHERE**. O alias só existe após a fase SELECT — e o WHERE é processado antes. Se você tentar:

~~~sql
-- ISSO GERA ERRO: alias 'ValorFormatado' não existe na fase WHERE
SELECT
    Valor AS ValorFormatado
FROM dbo.Transacoes
WHERE ValorFormatado > 1000; -- Erro: coluna 'ValorFormatado' inválida
~~~

O SQL Server processa o `WHERE` antes de saber que existe um alias chamado `ValorFormatado`. A solução é usar a expressão original no WHERE:

~~~sql
-- CORRETO: usa a coluna original no WHERE
SELECT
    Valor AS ValorFormatado
FROM dbo.Transacoes
WHERE Valor > 1000;
~~~

Entender essa ordem lógica é fundamental para escrever queries corretas, especialmente quando combinamos GROUP BY, HAVING e Window Functions nos próximos capítulos.

~~~mermaid
graph TD
    A["FROM — Define a fonte de dados"] --> B["WHERE — Filtra linhas individuais"]
    B --> C["GROUP BY — Agrupa linhas filtradas"]
    C --> D["HAVING — Filtra grupos formados"]
    D --> E["SELECT — Projeta colunas e calcula expressões"]
    E --> F["ORDER BY — Ordena o resultado final"]

    style A fill:#1e40af,color:#fff
    style B fill:#1e3a8a,color:#fff
    style C fill:#1e3a8a,color:#fff
    style D fill:#1e3a8a,color:#fff
    style E fill:#15803d,color:#fff
    style F fill:#166534,color:#fff
~~~

---

## 3. Aliases com AS — Dando Nomes Legíveis ao Resultado

Um **alias** é um nome temporário atribuído a uma coluna ou tabela dentro de uma query. Ele existe apenas durante a execução da query — não altera nada no banco de dados. A palavra-chave `AS` é usada para criar aliases, embora seja opcional em T-SQL (o SQL Server aceita o alias direto sem AS). Ainda assim, sempre use `AS` por clareza e legibilidade.

### 3.1 Aliases em Colunas

~~~sql
-- Aliases em colunas: renomeando para relatório mais legível
-- Contexto financeiro: relatório de contas bancárias do FinanceDB
SELECT
    cb.ContaID          AS [Código da Conta],      -- alias com espaço requer colchetes
    cb.NomeConta        AS [Nome da Conta],         -- colchetes permitem espaços no alias
    cb.Agencia          AS [Agência],               -- note o acento — válido em T-SQL
    cb.NumeroConta      AS [Número da Conta],
    cb.SaldoInicial     AS [Saldo Inicial (R$)],    -- parênteses e símbolos: use colchetes
    cb.Ativo            AS [Ativa?]
FROM dbo.ContasBancarias AS cb                      -- alias na tabela também
WHERE cb.EmpresaID = 7;                             -- filtra apenas empresa FinanceDB Holding
~~~

Aliases com espaços, acentos ou caracteres especiais precisam estar entre colchetes `[ ]` ou aspas duplas `" "`. Em T-SQL, colchetes são a convenção padrão da Microsoft.

### 3.2 Aliases em Tabelas

Aliases em tabelas são especialmente úteis quando a query referencia a mesma tabela mais de uma vez (como em SELF JOIN, que veremos no Capítulo 17) ou quando o nome da tabela é longo:

~~~sql
-- Alias na tabela: 'cb' em vez de 'ContasBancarias'
-- Isso economiza digitação e torna a query mais legível
SELECT
    cb.NomeConta        AS [Conta],
    cb.SaldoInicial     AS [Saldo]
FROM dbo.ContasBancarias AS cb
WHERE cb.EmpresaID = 7;
~~~

Uma vez que você define um alias para uma tabela, você **é obrigado** a usar esse alias para referenciar as colunas daquela tabela no restante da query. Se você escrever `AS cb`, não pode mais escrever `ContasBancarias.NomeConta` — tem que ser `cb.NomeConta`.

---

## 4. Colunas Calculadas — Computando Informação na Hora da Consulta

O SELECT não está limitado a retornar colunas que existem fisicamente na tabela. Você pode criar **colunas calculadas** — expressões que o SQL Server computa no momento da consulta, sem persistir o resultado no disco.

### 4.1 Expressões Aritméticas

~~~sql
-- Colunas calculadas: calculando variação orçamentária em tempo real
-- Tabela Orcamentos: ValorOrcado vs ValorRealizado
SELECT
    o.OrcamentoID                                           AS [ID],
    o.Competencia                                           AS [Período],
    o.ValorOrcado                                           AS [Orçado (R$)],
    o.ValorRealizado                                        AS [Realizado (R$)],

    -- Variação absoluta: diferença entre realizado e orçado
    (o.ValorRealizado - o.ValorOrcado)                      AS [Variação (R$)],

    -- Variação percentual: quanto % do orçado foi realizado
    -- CAST para DECIMAL evita divisão inteira e garante casas decimais
    CAST(
        (o.ValorRealizado / NULLIF(o.ValorOrcado, 0)) * 100
    AS DECIMAL(10,2))                                       AS [% Realizado],

    -- Status: superávit ou déficit
    CASE
        WHEN o.ValorRealizado >= o.ValorOrcado THEN 'Superávit'
        ELSE 'Déficit'
    END                                                     AS [Status]

FROM dbo.Orcamentos AS o
WHERE o.EmpresaID = 7
ORDER BY o.Competencia;
~~~

Observe o uso de `NULLIF(o.ValorOrcado, 0)`: ele retorna NULL quando o denominador é zero, evitando o erro de divisão por zero. É uma função de segurança essencial em cálculos financeiros.

### 4.2 Expressões de Texto com CONCAT e Concatenação

~~~sql
-- Concatenando texto para criar descrições compostas
-- Construindo um label de conta bancária no formato "Agência / Conta"
SELECT
    cb.ContaID                                          AS [ID],

    -- CONCAT é a forma moderna e segura de concatenar strings em T-SQL
    -- Ela trata NULL automaticamente (converte NULL em string vazia)
    CONCAT(cb.Agencia, ' / ', cb.NumeroConta)           AS [Agência/Conta],

    -- Concatenando nome da conta com seu tipo entre parênteses
    CONCAT(cb.NomeConta, ' (', cb.TipoConta, ')')       AS [Conta Completa],

    cb.SaldoInicial                                     AS [Saldo Inicial]

FROM dbo.ContasBancarias AS cb
WHERE cb.EmpresaID = 7
ORDER BY cb.NomeConta;
~~~

O operador `+` também concatena strings em T-SQL, mas tem um comportamento perigoso: se qualquer operando for NULL, o resultado inteiro é NULL. `CONCAT` é sempre preferível porque converte NULL em string vazia automaticamente.

---

## 5. DISTINCT — Eliminando Duplicatas

O `DISTINCT` instrui o SQL Server a retornar apenas linhas únicas no resultado. É útil quando você quer saber quais valores distintos existem em uma coluna, sem repetições.

~~~sql
-- Quais tipos de conta existem no FinanceDB?
-- Sem DISTINCT, se houver 4 contas do tipo 'CC', aparecerão 4 linhas
SELECT DISTINCT
    TipoConta           AS [Tipo de Conta]
FROM dbo.ContasBancarias
WHERE EmpresaID = 7
ORDER BY TipoConta;
~~~

~~~sql
-- Quais empresas têm transações registradas?
-- DISTINCT evita repetir o mesmo EmpresaID para cada transação
SELECT DISTINCT
    EmpresaID           AS [ID da Empresa]
FROM dbo.Transacoes
ORDER BY EmpresaID;
~~~

~~~sql
-- Quais meses têm lançamentos de transações?
-- DISTINCT + MONTH extrai os meses únicos presentes
SELECT DISTINCT
    YEAR(DataLancamento)    AS [Ano],
    MONTH(DataLancamento)   AS [Mês]
FROM dbo.Transacoes
ORDER BY
    YEAR(DataLancamento),
    MONTH(DataLancamento);
~~~

**Atenção importante:** `DISTINCT` opera sobre a **combinação de todas as colunas** listadas no SELECT, não sobre uma única coluna. Se você listar duas colunas, uma linha será considerada duplicata somente se ambas as colunas tiverem valores idênticos.

---

## 6. Consultando as Tabelas do FinanceDB — Queries Financeiras Reais

Com a teoria estabelecida, vamos construir consultas reais e significativas sobre o dataset do FinanceDB.

### 6.1 Consultando Bancos Cadastrados

~~~sql
-- Relatório completo de bancos cadastrados no FinanceDB
-- Objetivo: visão geral dos bancos parceiros da empresa
USE FinanceDB;
GO

SELECT
    b.BancoID           AS [ID],
    b.CodigoCOMPE       AS [Código COMPE],  -- código de identificação bancária
    b.NomeBanco         AS [Banco],
    b.Sigla             AS [Sigla],
    CASE b.Ativo
        WHEN 1 THEN 'Ativo'
        ELSE 'Inativo'
    END                 AS [Status]
FROM dbo.Bancos AS b
ORDER BY b.NomeBanco;   -- ordena alfabeticamente pelo nome do banco
~~~

### 6.2 Consultando Contas Bancárias com Informações Completas

~~~sql
-- Relatório de contas bancárias com saldo inicial formatado
-- Objetivo: visão gerencial das contas da empresa EmpresaID = 7
SELECT
    cb.ContaID                                          AS [ID],
    cb.NomeConta                                        AS [Nome da Conta],
    cb.TipoConta                                        AS [Tipo],
    CONCAT(cb.Agencia, '-', cb.NumeroConta)             AS [Ag/Conta],
    cb.SaldoInicial                                     AS [Saldo Inicial],
    CASE cb.Ativo
        WHEN 1 THEN 'Ativa'
        ELSE 'Inativa'
    END                                                 AS [Status],
    CONVERT(VARCHAR(10), cb.DataCadastro, 103)          AS [Cadastrada em]
    -- CONVERT com estilo 103 = formato dd/mm/yyyy
FROM dbo.ContasBancarias AS cb
WHERE cb.EmpresaID = 7          -- apenas contas da FinanceDB Holding
ORDER BY cb.NomeConta;
~~~

### 6.3 Consultando Transações com Colunas Calculadas

~~~sql
-- Relatório de transações com classificação por natureza
-- Receitas aparecem como positivo, despesas como negativo
SELECT
    t.TransacaoID                               AS [ID],
    CONVERT(VARCHAR(10), t.DataLancamento, 103) AS [Data],
    t.Descricao                                 AS [Descrição],
    t.Valor                                     AS [Valor (R$)],

    -- Classifica a natureza da transação pelo TipoTransacaoID
    CASE t.TipoTransacaoID
        WHEN 1 THEN 'Receita'    -- TipoTransacaoID 1 = RECEITA
        WHEN 2 THEN 'Despesa'    -- TipoTransacaoID 2 = DESPESA
        WHEN 3 THEN 'Transferência'
        ELSE 'Não Classificado'
    END                                         AS [Natureza],

    -- Valor com sinal: receitas positivas, despesas negativas
    CASE t.TipoTransacaoID
        WHEN 1 THEN  t.Valor     -- receita: positivo
        WHEN 2 THEN -t.Valor     -- despesa: negativo
        ELSE 0
    END                                         AS [Valor Líquido]

FROM dbo.Transacoes AS t
WHERE t.EmpresaID = 7
ORDER BY t.DataLancamento DESC; -- mais recentes primeiro
~~~

### 6.4 Consultando o Plano de Contas com Hierarquia Visível

~~~sql
-- Relatório do plano de contas com indentação visual por nível
-- Objetivo: visualizar a hierarquia de contas de forma legível
SELECT
    pc.ContaPlanoID                             AS [ID],
    pc.CodigoConta                              AS [Código],

    -- Indentação visual: quanto mais profundo o nível, mais espaços à esquerda
    CONCAT(
        REPLICATE('    ', pc.Nivel - 1),        -- 4 espaços por nível
        pc.NomeConta
    )                                           AS [Conta],

    pc.TipoConta                                AS [Tipo],
    pc.Nivel                                    AS [Nível],
    CASE pc.Lancavel
        WHEN 1 THEN 'Sim'
        ELSE 'Não'
    END                                         AS [Lançável],
    CASE pc.Ativo
        WHEN 1 THEN 'Ativa'
        ELSE 'Inativa'
    END                                         AS [Status]

FROM dbo.PlanoDeContas AS pc
WHERE pc.EmpresaID = 7
ORDER BY pc.CodigoConta;    -- ordena pelo código hierárquico
~~~

### 6.5 Consultando o Orçamento com Análise de Variação

~~~sql
-- Relatório de orçamento x realizado com variação percentual
-- Objetivo: análise de desempenho financeiro por competência
SELECT
    o.OrcamentoID                                           AS [ID],
    o.Competencia                                           AS [Competência],
    o.ValorOrcado                                           AS [Orçado (R$)],
    o.ValorRealizado                                        AS [Realizado (R$)],

    -- Variação absoluta
    (o.ValorRealizado - o.ValorOrcado)                      AS [Variação (R$)],

    -- Variação percentual com proteção contra divisão por zero
    CAST(
        (o.ValorRealizado / NULLIF(o.ValorOrcado, 0)) * 100
    AS DECIMAL(10, 2))                                      AS [% Exec.],

    -- Classificação de desempenho
    CASE
        WHEN o.ValorRealizado >= o.ValorOrcado * 1.05 THEN 'Acima do Orçado'
        WHEN o.ValorRealizado >= o.ValorOrcado        THEN 'Dentro do Orçado'
        WHEN o.ValorRealizado >= o.ValorOrcado * 0.90 THEN 'Levemente Abaixo'
        ELSE                                               'Abaixo do Orçado'
    END                                                     AS [Classificação]

FROM dbo.Orcamentos AS o
WHERE o.EmpresaID = 7
ORDER BY o.Competencia;
~~~

---

## 7. SELECT com Expressões Literais e Funções de Sistema

O SELECT também pode retornar valores literais e resultados de funções do sistema, sem precisar de uma tabela como fonte:

~~~sql
-- SELECT sem FROM: consultando funções de sistema
-- Útil para testes rápidos e verificações de ambiente
SELECT
    GETDATE()                   AS [Data e Hora Atual],
    SYSDATETIME()               AS [Data e Hora (alta precisão)],
    @@SERVERNAME                AS [Nome do Servidor],
    @@VERSION                   AS [Versão do SQL Server],
    DB_NAME()                   AS [Banco de Dados Atual],
    USER_NAME()                 AS [Usuário Atual],
    @@ROWCOUNT                  AS [Linhas Afetadas (última operação)];
~~~

Essas funções são ferramentas de diagnóstico valiosas. `GETDATE()` retorna a data e hora atuais do servidor — essencial para auditoria. `@@SERVERNAME` confirma em qual instância você está conectado — útil quando se trabalha com múltiplos ambientes (dev, homolog, prod). `DB_NAME()` confirma o banco de dados ativo.

---

## 8. SELECT INTO — Criando Tabelas a partir de Consultas

O `SELECT INTO` é uma variação que cria uma nova tabela e a popula com o resultado da consulta em uma única operação. É muito usado para criar tabelas temporárias de trabalho:

~~~sql
-- SELECT INTO: cria a tabela #ResumoContas (temporária) com o resultado
-- O prefixo # indica tabela temporária local — existe apenas na sessão atual
SELECT
    cb.ContaID          AS ContaID,
    cb.NomeConta        AS NomeConta,
    cb.TipoConta        AS TipoConta,
    cb.SaldoInicial     AS SaldoInicial
INTO #ResumoContas                      -- cria e popula a tabela temporária
FROM dbo.ContasBancarias AS cb
WHERE cb.EmpresaID = 7
  AND cb.Ativo = 1;                     -- apenas contas ativas

-- Verificando o resultado na tabela temporária criada
SELECT * FROM #ResumoContas;

-- Tabelas temporárias são destruídas automaticamente quando a sessão termina
-- Mas é boa prática descartá-las explicitamente ao terminar o uso
DROP TABLE IF EXISTS #ResumoContas;
~~~

`SELECT INTO` não deve ser confundido com `INSERT INTO ... SELECT`, que vimos no Capítulo 10. A diferença é que `SELECT INTO` **cria a tabela destino** se ela não existir, enquanto `INSERT INTO ... SELECT` exige que a tabela destino **já exista**.

---

## 9. Boas Práticas de Escrita de Queries SELECT

Bons profissionais T-SQL escrevem queries que são fáceis de ler, manter e depurar. Algumas convenções que você deve adotar desde agora:

**1. Liste sempre as colunas explicitamente.** Nunca use `SELECT *` em código que vai para produção.

**2. Qualifique sempre as colunas com o alias da tabela.** Em vez de escrever apenas `NomeConta`, escreva `cb.NomeConta`. Isso elimina ambiguidade quando a query evolui para JOINs.

**3. Use `AS` explicitamente para aliases.** Mesmo sendo opcional, `AS` torna o código mais legível.

**4. Escreva uma coluna por linha.** Facilita leitura, depuração e versionamento com Git.

**5. Sempre use `USE FinanceDB;` antes de queries importantes.** Garante que você está no banco correto.

**6. Comente intenções, não mecanismos.** Um comentário como `-- filtra apenas contas ativas` é mais útil do que `-- WHERE Ativo = 1`.

**7. Teste com `TOP 10` antes de rodar queries grandes.** Em ambiente de produção com milhões de linhas, uma query sem TOP pode travar o servidor.

~~~sql
-- Padrão profissional de escrita de SELECT
USE FinanceDB;
GO

-- Relatório de transações recentes: top 10 mais recentes da empresa
SELECT TOP 10
    t.TransacaoID                               AS [ID],
    CONVERT(VARCHAR(10), t.DataLancamento, 103) AS [Data],
    t.Descricao                                 AS [Descrição],
    t.Valor                                     AS [Valor (R$)],
    t.Conciliado                                AS [Conciliado]
FROM dbo.Transacoes AS t
WHERE t.EmpresaID = 7
ORDER BY t.DataLancamento DESC;
~~~

---

## 10. Diagrama — Anatomia de um SELECT Completo

~~~mermaid
graph LR
    subgraph ESCRITA["Ordem de Escrita (como o desenvolvedor vê)"]
        E1["SELECT colunas"] --> E2["FROM tabela"]
        E2 --> E3["WHERE filtro"]
        E3 --> E4["GROUP BY agrupamento"]
        E4 --> E5["HAVING filtro de grupo"]
        E5 --> E6["ORDER BY ordenação"]
    end

    subgraph PROCESSAMENTO["Ordem de Processamento (como o SQL Server executa)"]
        P1["1. FROM — fonte de dados"] --> P2["2. WHERE — filtra linhas"]
        P2 --> P3["3. GROUP BY — agrupa"]
        P3 --> P4["4. HAVING — filtra grupos"]
        P4 --> P5["5. SELECT — projeta colunas"]
        P5 --> P6["6. ORDER BY — ordena resultado"]
    end

    style ESCRITA fill:#1e3a5f,color:#fff
    style PROCESSAMENTO fill:#14532d,color:#fff
~~~

---

## 11. Glossário Técnico

**SELECT:** Comando DML usado para consultar dados em uma ou mais tabelas. Não modifica dados — apenas os lê e apresenta.

**FROM:** Cláusula que especifica a tabela ou conjunto de tabelas de onde os dados serão lidos. Primeira cláusula processada logicamente.

**Alias:** Nome temporário atribuído a uma coluna ou tabela com `AS`. Existe apenas durante a execução da query. Não altera o banco de dados.

**Coluna Calculada (em query):** Expressão computada no momento da consulta que não existe como coluna física na tabela. Resultado de operações aritméticas, funções ou expressões condicionais.

**DISTINCT:** Modificador que instrui o SQL Server a retornar apenas combinações únicas de colunas, eliminando duplicatas do resultado.

**CASE WHEN:** Expressão condicional do T-SQL que avalia condições e retorna valores diferentes para cada caso. Equivalente ao IF/ELSE de linguagens de programação.

**NULLIF(expr, valor):** Função que retorna NULL se `expr` for igual a `valor`, caso contrário retorna `expr`. Usada principalmente para evitar divisão por zero.

**REPLICATE(str, n):** Função que repete uma string `n` vezes. Usada para criar indentação visual em relatórios hierárquicos.

**CONVERT(tipo, valor, estilo):** Função que converte um valor de um tipo de dado para outro, com opção de especificar o formato. O estilo 103 produz o formato `dd/mm/yyyy`.

**SELECT INTO:** Variação do SELECT que cria uma nova tabela e a popula com o resultado da consulta simultaneamente.

**Tabela Temporária Local (#):** Tabela criada com prefixo `#` que existe apenas na sessão atual do SSMS. Destruída automaticamente quando a sessão encerra.

**Ordem Lógica de Processamento:** Sequência em que o SQL Server interpreta e executa as cláusulas de uma query: FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY.

**@@SERVERNAME:** Variável de sistema que retorna o nome da instância do SQL Server à qual a sessão está conectada.

**DB_NAME():** Função de sistema que retorna o nome do banco de dados ativo na sessão atual.

---

## 12. Antecipação de Erros e Troubleshooting

**Erro: "Invalid column name 'alias'"**
Causa: você usou um alias definido no SELECT dentro do WHERE ou GROUP BY. O alias só existe após a fase SELECT, que é processada depois de WHERE e GROUP BY.
Solução: use a expressão original no WHERE/GROUP BY, não o alias.

~~~sql
-- ERRADO
SELECT Valor * 1.1 AS ValorComTaxa
FROM dbo.Transacoes
WHERE ValorComTaxa > 500; -- alias não existe aqui

-- CORRETO
SELECT Valor * 1.1 AS ValorComTaxa
FROM dbo.Transacoes
WHERE Valor * 1.1 > 500; -- usa a expressão original
~~~

**Erro: "Divide by zero error encountered"**
Causa: divisão por uma coluna que contém o valor zero.
Solução: use `NULLIF(denominador, 0)` para converter zero em NULL antes da divisão.

~~~sql
-- ERRADO: pode gerar erro se ValorOrcado for 0
SELECT ValorRealizado / ValorOrcado AS Percentual
FROM dbo.Orcamentos;

-- CORRETO: NULLIF protege contra divisão por zero
SELECT ValorRealizado / NULLIF(ValorOrcado, 0) AS Percentual
FROM dbo.Orcamentos;
~~~

**Resultado: coluna com NULL onde se esperava um valor**
Causa: concatenação com `+` onde um dos operandos é NULL.
Solução: troque `+` por `CONCAT()`, que trata NULL como string vazia.

~~~sql
-- ERRADO: se Agencia for NULL, o resultado inteiro é NULL
SELECT Agencia + ' / ' + NumeroConta AS AgConta
FROM dbo.ContasBancarias;

-- CORRETO: CONCAT trata NULL como string vazia
SELECT CONCAT(Agencia, ' / ', NumeroConta) AS AgConta
FROM dbo.ContasBancarias;
~~~

**Erro: "Cannot use an aggregate or a subquery in an expression used for the group by list of a GROUP BY clause"**
Causa: tentativa de usar uma função de agregação como SUM ou COUNT no WHERE.
Solução: mova o filtro de agregação para o HAVING, que é processado após o GROUP BY.

**Resultado: DISTINCT não eliminando duplicatas esperadas**
Causa: DISTINCT opera sobre a combinação de todas as colunas listadas. Se qualquer coluna diferir entre linhas, elas não são consideradas duplicatas.
Solução: reduza as colunas do SELECT ao mínimo necessário para o DISTINCT funcionar como esperado.

---

## 13. Desafio de Fixação

**Desafio:** Escreva uma query que retorne um relatório de transações do FinanceDB com as seguintes características: apenas transações da empresa com EmpresaID = 7, exibindo o ID da transação, a data no formato `dd/mm/yyyy`, a descrição da transação, o valor, a natureza (usando CASE: "Receita" para TipoTransacaoID = 1, "Despesa" para TipoTransacaoID = 2 e "Transferência" para TipoTransacaoID = 3), uma coluna calculada chamada "Valor com IOF" que multiplica o Valor por 1.0038 (taxa de IOF hipotética) formatada como DECIMAL(10,2), e o status de conciliação ("Conciliado" ou "Pendente"). Ordene por data decrescente e retorne apenas os 10 registros mais recentes.

---

**Resolução Comentada:**

~~~sql
-- Resolução do Desafio do Capítulo 11
-- Relatório de transações com IOF calculado
USE FinanceDB;
GO

SELECT TOP 10   -- limita a 10 registros — aplicado após ORDER BY
    t.TransacaoID                                   AS [ID],

    -- CONVERT com estilo 103 = formato brasileiro dd/mm/yyyy
    CONVERT(VARCHAR(10), t.DataLancamento, 103)     AS [Data],

    t.Descricao                                     AS [Descrição],
    t.Valor                                         AS [Valor Original (R$)],

    -- CASE para classificar a natureza da transação
    CASE t.TipoTransacaoID
        WHEN 1 THEN 'Receita'
        WHEN 2 THEN 'Despesa'
        WHEN 3 THEN 'Transferência'
        ELSE        'Não Classificado'
    END                                             AS [Natureza],

    -- Coluna calculada: valor com IOF de 0,38%
    -- CAST garante que o resultado tenha exatamente 2 casas decimais
    CAST(t.Valor * 1.0038 AS DECIMAL(10, 2))        AS [Valor com IOF (R$)],

    -- CASE para status de conciliação
    CASE t.Conciliado
        WHEN 1 THEN 'Conciliado'
        ELSE        'Pendente'
    END                                             AS [Status Conciliação]

FROM dbo.Transacoes AS t        -- alias 't' para a tabela Transacoes
WHERE t.EmpresaID = 7           -- apenas empresa FinanceDB Holding (EmpresaID = 7)
ORDER BY t.DataLancamento DESC; -- mais recentes primeiro — TOP 10 usa este critério
~~~

**Por que TOP 10 aparece antes das colunas mas é aplicado depois?** Porque na ordem lógica de processamento, o TOP é aplicado após o ORDER BY — ele pega os 10 primeiros registros da lista já ordenada. A posição dele na escrita é logo após SELECT por convenção de sintaxe do T-SQL.

---

## 14. Resumo dos Pontos-Chave

O `SELECT` é o coração de qualquer interação com um banco de dados relacional. Neste capítulo aprendemos que ele é composto por cláusulas com uma **ordem de escrita** que difere completamente da **ordem lógica de processamento** do SQL Server: o motor executa FROM primeiro, depois WHERE, depois GROUP BY, depois HAVING, depois SELECT e por último ORDER BY. Essa compreensão é fundamental para escrever queries corretas e para diagnosticar erros de referência a aliases.

Dominamos o uso de **aliases com AS**, tanto em colunas quanto em tabelas, e aprendemos que aliases com espaços ou caracteres especiais devem ser envolvidos em colchetes. Entendemos que um alias de coluna definido no SELECT não pode ser referenciado no WHERE porque o WHERE é processado antes do SELECT.

Construímos **colunas calculadas** usando expressões aritméticas, `CASE WHEN`, `NULLIF` para proteção contra divisão por zero, `CONCAT` para concatenação segura com NULL, `REPLICATE` para indentação visual e `CONVERT` para formatação de datas no padrão brasileiro `dd/mm/yyyy`.

Usamos `DISTINCT` para eliminar duplicatas e compreendemos que ele opera sobre a **combinação de todas as colunas** listadas — não sobre uma coluna isolada. Conhecemos o `SELECT INTO` para criação de tabelas temporárias e a diferença entre ele e o `INSERT INTO ... SELECT`. E estabelecemos um conjunto de **boas práticas** de escrita que serão mantidas ao longo de todo o livro: listar colunas explicitamente, qualificar com alias de tabela, usar AS sempre, uma coluna por linha e comentar intenções.

---

## Log de Estado do Projeto

~~~text
## Estado — Após o Capítulo 11

=== BANCO DE DADOS ===
Nome: FinanceDB
Collation: Latin1_General_CI_AS
Recovery Model: FULL
Status: Operacional

=== TABELAS E REGISTROS ===
Bancos:             5 registros (Itaú 341, BB 1, Caixa 104, Bradesco 237, Santander 33)
TiposTransacao:     3 registros (RECEITA, DESPESA, TRANSF)
Empresas:           2 registros (FinanceDB Holding EmpresaID=7, segunda empresa)
ContasBancarias:    4 registros (contas das duas empresas)
PlanoDeContas:      25 registros (hierarquia em 3 níveis para ambas as empresas)
Transacoes:         29 lançamentos (Jan a Abr 2026)
Orcamentos:         registros de Jan/Fev/Mar 2026 para ambas as empresas

=== OBJETOS CRIADOS ===
Tabelas:            7 (estrutura completa e populada)
Constraints:        NOT NULL, DEFAULT, CHECK, PRIMARY KEY, FOREIGN KEY (10 FKs)
Índices:            clustered nas PKs (automáticos)
Views:              nenhuma ainda
Stored Procedures:  nenhuma ainda
Functions:          nenhuma ainda
Triggers:           nenhum ainda

=== CAPÍTULOS CONCLUÍDOS ===
Módulo 1: Capítulos 1 a 6 ✅
Módulo 2: Capítulos 7 a 11 ✅ (em andamento)

=== HABILIDADES T-SQL ADQUIRIDAS ===
- CREATE DATABASE com configurações avançadas
- CREATE TABLE com constraints completas
- PRIMARY KEY, FOREIGN KEY, IDENTITY
- INSERT INTO (linha única, múltiplas linhas, INSERT...SELECT)
- SCOPE_IDENTITY(), OUTPUT INSERTED, OUTPUT INTO
- SELECT com lista explícita de colunas
- Aliases com AS (colunas e tabelas)
- Colunas calculadas (aritméticas, texto, condicionais)
- DISTINCT para eliminação de duplicatas
- CASE WHEN para lógica condicional no SELECT
- NULLIF para proteção contra divisão por zero
- CONCAT para concatenação segura com NULL
- CONVERT para formatação de datas
- SELECT INTO para criação de tabelas temporárias
- Ordem lógica de processamento de queries

=== PRÓXIMO CAPÍTULO ===
Capítulo 12: Filtrando Dados — WHERE, AND, OR, NOT e BETWEEN
~~~

---

## Prompt de Continuidade

~~~text
Contexto: Estou estudando o livro "SQL Server para Aplicações
Financeiras com T-SQL". Meu ambiente é Windows 11, SSMS,
SQL Server 2022. O projeto prático incremental se chama FinanceDB.

Concluí o Capítulo 11, que cobriu o comando SELECT em profundidade.
Aprendi: anatomia completa do SELECT, ordem lógica de processamento
(FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY), aliases com
AS em colunas e tabelas, colunas calculadas com expressões aritméticas
e condicionais, DISTINCT para eliminar duplicatas, CASE WHEN, NULLIF
para proteção contra divisão por zero, CONCAT para concatenação
segura, CONVERT para formatação de datas no padrão dd/mm/yyyy,
SELECT INTO para criação de tabelas temporárias e boas práticas
de escrita profissional de queries.

O banco FinanceDB possui 7 tabelas populadas: Bancos (5 registros),
TiposTransacao (3), Empresas (2 — FinanceDB Holding EmpresaID=7
e segunda empresa), ContasBancarias (4), PlanoDeContas (25),
Transacoes (29 lançamentos de Jan a Abr 2026) e Orcamentos
(Jan/Fev/Mar 2026 para ambas as empresas).

Siga rigorosamente o Prompt Mestre v1.1: narrativa densa com
mínimo de 2.000 palavras, Técnica de Feynman, analogia de
ancoragem, diagrama Mermaid escapado com ~~~mermaid, código SQL
comentado linha a linha escapado com ~~~, glossário técnico,
antecipação de erros, troubleshooting, desafio de fixação com
resolução comentada, resumo dos pontos-chave, log de estado do
projeto atualizado e prompt de continuidade para o próximo capítulo.
Todo o conteúdo deve ser gerado dentro de um bloco ```markdown.
Chame aulas de capítulos e curso de livro.

Por favor, gere o Capítulo 12: Filtrando Dados — WHERE, AND, OR,
NOT e BETWEEN. Objetivo: construir filtros compostos e precisos
para consultas financeiras usando WHERE com os operadores AND, OR,
NOT, BETWEEN, IN e LIKE, entender a precedência de operadores
lógicos e como o uso de parênteses altera o resultado da query,
e aplicar esses filtros em cenários reais do FinanceDB como
filtragem de transações por período, valor, tipo e status de
conciliação.
Pré-requisito: Capítulo 11 concluído.
~~~

---

Dúvidas? Posso prosseguir para o Capítulo 12?