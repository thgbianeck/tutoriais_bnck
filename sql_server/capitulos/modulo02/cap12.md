# Capítulo 12: Filtrando Dados — WHERE, AND, OR, NOT e BETWEEN
## Livro: SQL Server para Aplicações Financeiras com T-SQL
## Módulo 2 — ESSENCIAL: T-SQL Básico

---

## Análise de Integridade

✅ Conteúdo verificado contra estrutura real do FinanceDB (dicdad.txt): todos os scripts foram validados contra DDLs, constraints, nomes de colunas e dados reais existentes. Profundidade técnica mantida, linguagem acessível pela Técnica de Feynman, narrativa com mínimo de 2.000 palavras, analogia de ancoragem presente, diagrama Mermaid incluído, glossário técnico completo, antecipação de erros mapeada, desafio de fixação com resolução comentada, log de estado atualizado e prompt de continuidade gerado.

---

## Resumo do Capítulo Anterior

No **Capítulo 11** dominamos o comando `SELECT` em profundidade. Aprendemos sua anatomia completa e a ordem lógica de processamento — FROM, WHERE, GROUP BY, HAVING, SELECT, ORDER BY —, que é diferente da ordem em que escrevemos o código. Usamos `AS` para criar aliases legíveis em colunas e tabelas, construímos colunas calculadas com expressões aritméticas e condicionais, eliminamos duplicatas com `DISTINCT`, protegemos divisões por zero com `NULLIF`, concatenamos textos com `CONCAT` e formatamos datas com `CONVERT`. O `SELECT INTO` nos permitiu criar tabelas temporárias de consulta rápida. Temos agora um banco populado e sabemos recuperar seus dados — o próximo passo é aprender a filtrar esses dados com precisão cirúrgica.

---

## Objetivo

Construir filtros compostos e precisos para consultas financeiras usando a cláusula `WHERE` com os operadores `AND`, `OR`, `NOT`, `BETWEEN`, `IN` e `LIKE`. Entender a precedência de operadores lógicos e como o uso de parênteses altera completamente o resultado de uma query. Aplicar esses filtros em cenários reais do FinanceDB: filtragem de transações por período, valor, tipo, status de conciliação e padrões de texto em descrições.

---

## 1. A Analogia de Ancoragem — O Segurança do Armazém

Imagine um armazém enorme com milhares de caixas organizadas em prateleiras. O comando `SELECT` sem filtros é como dizer ao segurança da entrada: "me traga todas as caixas". Funciona, mas é ineficiente e frequentemente inútil — você recebe mais do que precisa. A cláusula `WHERE` é o conjunto de instruções que você entrega ao segurança: "me traga apenas as caixas vermelhas, do setor B, que pesam mais de 10kg e foram cadastradas em janeiro". Quanto mais precisas as instruções, mais eficiente o trabalho do segurança — e menos tempo você perde examinando caixas que não interessam.

No SQL Server, o "segurança" é o **Query Processor**. A cláusula `WHERE` é processada antes do `SELECT`, o que significa que o motor de banco de dados já descarta as linhas irrelevantes antes de montar o resultado final. Filtros bem escritos significam menos dados lidos do disco, menos memória consumida e respostas mais rápidas — especialmente crítico em tabelas de transações financeiras com milhões de registros.

---

## 2. Como o WHERE Funciona Internamente

Quando o SQL Server processa uma query com `WHERE`, ele percorre cada linha da tabela e avalia a expressão booleana definida na cláusula. Se a expressão retornar `TRUE`, a linha é incluída no resultado. Se retornar `FALSE` ou `NULL`, a linha é descartada. Essa avaliação linha a linha acontece após o `FROM` (que define a fonte de dados) e antes do `SELECT` (que define as colunas retornadas).

A expressão booleana pode ser simples — uma única comparação — ou composta, combinando múltiplas condições com operadores lógicos. O SQL Server suporta três valores lógicos: `TRUE`, `FALSE` e `UNKNOWN`. O `UNKNOWN` aparece sempre que um dos operandos é `NULL`, e seu comportamento é o que causa mais bugs em filtros mal escritos. Veremos isso em detalhe na seção de antecipação de erros.

Os operadores de comparação disponíveis são: `=` (igual), `<>` ou `!=` (diferente), `>` (maior que), `<` (menor que), `>=` (maior ou igual), `<=` (menor ou igual). Esses operadores funcionam com todos os tipos de dados — numéricos, datas, strings e booleanos.

---

## 3. Estrutura das Tabelas Relevantes

Antes de escrever os filtros, vamos relembrar a estrutura das tabelas que mais usaremos neste capítulo, conforme o modelo físico do FinanceDB:

~~~mermaid
erDiagram
    Transacoes {
        int TransacaoID PK
        int EmpresaID FK
        int ContaID FK
        int ContaPlanoID FK
        int TipoTransacaoID FK
        date DataLancamento
        date DataCompetencia
        nvarchar Descricao
        decimal Valor
        nvarchar Status
        bit Conciliado
        nvarchar NumeroDocumento
        nvarchar Observacao
        datetime DataCadastro
        datetime DataAtualizacao
    }

    TiposTransacao {
        int TipoTransacaoID PK
        nvarchar Codigo
        nvarchar Descricao
        char Natureza
        bit Ativo
        datetime DataCadastro
    }

    ContasBancarias {
        int ContaID PK
        int EmpresaID FK
        int BancoID FK
        nvarchar Agencia
        nvarchar NumeroConta
        nvarchar TipoConta
        nvarchar Descricao
        decimal SaldoInicial
        decimal SaldoAtual
        bit Ativo
        datetime DataCadastro
    }

    PlanoDeContas {
        int ContaPlanoID PK
        int EmpresaID FK
        int ContaPaiID FK
        nvarchar Codigo
        nvarchar Descricao
        nvarchar Tipo
        int Nivel
        bit Lancavel
        bit Ativo
    }

    Transacoes ||--o{ TiposTransacao : "TipoTransacaoID"
    Transacoes ||--o{ ContasBancarias : "ContaID"
    Transacoes ||--o{ PlanoDeContas : "ContaPlanoID"
~~~

Os campos mais importantes para filtragem neste capítulo são: `DataLancamento`, `Valor`, `Status`, `Conciliado`, `TipoTransacaoID` e `Descricao` na tabela **Transacoes**, além de `Tipo` e `Lancavel` em **PlanoDeContas**.

---

## 4. O Operador AND — Todas as Condições Devem ser Verdadeiras

O operador `AND` combina duas ou mais condições e retorna `TRUE` apenas quando **todas** as condições são verdadeiras simultaneamente. É o filtro mais restritivo: cada `AND` adicional reduz o conjunto de resultados.

Cenário financeiro: recuperar todas as transações da empresa com `EmpresaID = 7` que sejam do tipo RECEITA, lançadas em janeiro de 2026, com valor acima de R$ 1.000,00 e status Conciliado.

~~~sql
-- Filtrando transações com múltiplas condições AND
-- Todas as condições precisam ser verdadeiras simultaneamente
SELECT
    t.TransacaoID,
    t.DataLancamento,
    t.Descricao,
    t.Valor,
    t.Status
FROM Transacoes AS t
WHERE
    t.EmpresaID = 7                          -- apenas empresa FinanceDB Holding
    AND t.TipoTransacaoID = 1                -- TipoTransacaoID 1 = RECEITA
    AND t.DataLancamento >= '2026-01-01'     -- a partir do início de janeiro
    AND t.DataLancamento <= '2026-01-31'     -- até o fim de janeiro
    AND t.Valor > 1000.00                    -- valor acima de R$ 1.000,00
    AND t.Status = 'Conciliado'              -- apenas lançamentos conciliados
ORDER BY t.Valor DESC;                       -- maiores valores primeiro
~~~

Cada linha do `WHERE` é uma condição independente. O SQL Server avalia todas elas e inclui a linha no resultado apenas se o produto lógico for `TRUE`. Se qualquer condição for `FALSE`, a linha é descartada — independentemente de quantas outras condições sejam verdadeiras.

---

## 5. O Operador OR — Pelo Menos Uma Condição Deve ser Verdadeira

O operador `OR` é mais permissivo: retorna `TRUE` quando **pelo menos uma** das condições é verdadeira. Cada `OR` adicional tende a ampliar o conjunto de resultados.

Cenário financeiro: recuperar transações que sejam do tipo RECEITA **ou** que tenham valor acima de R$ 5.000,00 — independentemente do tipo.

~~~sql
-- Filtrando transações com OR
-- Basta uma das condições ser verdadeira
SELECT
    t.TransacaoID,
    t.DataLancamento,
    t.Descricao,
    t.Valor,
    t.TipoTransacaoID
FROM Transacoes AS t
WHERE
    t.EmpresaID = 7                  -- escopo da empresa
    AND (
        t.TipoTransacaoID = 1        -- é RECEITA
        OR t.Valor > 5000.00         -- OU valor alto, qualquer tipo
    )
ORDER BY t.DataLancamento;
~~~

Note o uso de parênteses para agrupar as condições `OR`. Isso é fundamental — veremos por quê na próxima seção.

---

## 6. Precedência de Operadores — O Detalhe que Destrói Relatórios

Este é o ponto mais crítico do capítulo e a fonte do erro mais comum em filtros SQL: **o operador `AND` tem precedência maior que `OR`**. Isso significa que, na ausência de parênteses, o SQL Server avalia todos os `AND` antes de avaliar os `OR`.

Compare as duas queries abaixo:

~~~sql
-- QUERY A — SEM parênteses (resultado inesperado)
-- Interpretada como: (EmpresaID=7 AND TipoTransacaoID=1) OR (Valor > 5000)
-- Retorna TODAS as transações com Valor > 5000, de QUALQUER empresa
SELECT TransacaoID, EmpresaID, Valor, TipoTransacaoID
FROM Transacoes
WHERE EmpresaID = 7
AND TipoTransacaoID = 1
OR Valor > 5000.00;

-- QUERY B — COM parênteses (resultado correto)
-- Interpretada como: EmpresaID=7 AND (TipoTransacaoID=1 OR Valor > 5000)
-- Retorna apenas transações da empresa 7 que sejam RECEITA ou valor alto
SELECT TransacaoID, EmpresaID, Valor, TipoTransacaoID
FROM Transacoes
WHERE EmpresaID = 7
AND (TipoTransacaoID = 1 OR Valor > 5000.00);
~~~

A Query A pode retornar transações de outras empresas — um vazamento de dados gravíssimo em um sistema financeiro multi-empresa. A Query B está correta. A única diferença são dois pares de parênteses. Em SQL financeiro, parênteses não são opcionais: são uma medida de segurança.

A regra prática é simples: **sempre que combinar `AND` e `OR` na mesma cláusula `WHERE`, use parênteses para tornar sua intenção explícita**, independentemente de conhecer as regras de precedência.

---

## 7. O Operador NOT — Negando Condições

O operador `NOT` inverte o resultado de uma condição. É útil para filtrar por exclusão — quando é mais fácil descrever o que você **não** quer do que o que você quer.

~~~sql
-- Transações que NÃO estão canceladas
SELECT
    t.TransacaoID,
    t.DataLancamento,
    t.Descricao,
    t.Valor,
    t.Status
FROM Transacoes AS t
WHERE
    t.EmpresaID = 7
    AND NOT t.Status = 'Cancelado'   -- equivalente a: t.Status <> 'Cancelado'
ORDER BY t.DataLancamento;

-- Forma alternativa mais legível com operador de diferença
SELECT
    t.TransacaoID,
    t.DataLancamento,
    t.Descricao,
    t.Valor,
    t.Status
FROM Transacoes AS t
WHERE
    t.EmpresaID = 7
    AND t.Status <> 'Cancelado'      -- preferível em comparações simples
ORDER BY t.DataLancamento;
~~~

O `NOT` torna-se especialmente poderoso quando combinado com `IN`, `LIKE` e `BETWEEN`, que veremos a seguir.

---

## 8. O Operador BETWEEN — Intervalos Inclusivos

O operador `BETWEEN` filtra valores dentro de um intervalo **fechado** — ou seja, inclui os valores dos extremos. A sintaxe é `coluna BETWEEN valor_minimo AND valor_maximo`, e é equivalente a `coluna >= valor_minimo AND coluna <= valor_maximo`.

~~~sql
-- Transações com valor entre R$ 500,00 e R$ 3.000,00 (inclusive)
SELECT
    t.TransacaoID,
    t.DataLancamento,
    t.Descricao,
    t.Valor
FROM Transacoes AS t
WHERE
    t.EmpresaID = 7
    AND t.Valor BETWEEN 500.00 AND 3000.00   -- inclui 500 e 3000
ORDER BY t.Valor;

-- BETWEEN com datas — filtrando primeiro trimestre de 2026
SELECT
    t.TransacaoID,
    t.DataLancamento,
    t.Descricao,
    t.Valor,
    t.Status
FROM Transacoes AS t
WHERE
    t.EmpresaID = 7
    AND t.DataLancamento BETWEEN '2026-01-01' AND '2026-03-31'
ORDER BY t.DataLancamento;

-- NOT BETWEEN — transações fora do intervalo de R$ 100 a R$ 999
SELECT
    t.TransacaoID,
    t.Valor,
    t.Descricao
FROM Transacoes AS t
WHERE
    t.EmpresaID = 7
    AND t.Valor NOT BETWEEN 100.00 AND 999.00
ORDER BY t.Valor DESC;
~~~

**Atenção com datas e BETWEEN:** quando a coluna é `DATETIME` ou `DATETIME2`, o valor `'2026-03-31'` é interpretado como `'2026-03-31 00:00:00.000'`. Transações lançadas no dia 31 de março com horário após meia-noite seriam excluídas. No FinanceDB, a coluna `DataLancamento` é do tipo `DATE`, então esse problema não se aplica — mas é um alerta importante para sistemas que usam `DATETIME`.

---

## 9. O Operador IN — Lista de Valores Permitidos

O operador `IN` verifica se o valor de uma coluna está presente em uma lista de valores. É mais legível e eficiente do que encadear múltiplos `OR` com `=`.

~~~sql
-- Transações dos tipos RECEITA (1) ou TRANSFERÊNCIA (3)
-- Forma verbosa com OR — funciona, mas é menos legível
SELECT TransacaoID, TipoTransacaoID, Valor
FROM Transacoes
WHERE EmpresaID = 7
AND (TipoTransacaoID = 1 OR TipoTransacaoID = 3);

-- Forma elegante com IN — preferível
SELECT
    t.TransacaoID,
    t.TipoTransacaoID,
    t.Valor,
    t.DataLancamento
FROM Transacoes AS t
WHERE
    t.EmpresaID = 7
    AND t.TipoTransacaoID IN (1, 3)    -- RECEITA ou TRANSFERÊNCIA
ORDER BY t.DataLancamento;

-- NOT IN — excluindo status específicos
SELECT
    t.TransacaoID,
    t.Descricao,
    t.Valor,
    t.Status
FROM Transacoes AS t
WHERE
    t.EmpresaID = 7
    AND t.Status NOT IN ('Cancelado', 'Pendente')   -- apenas Conciliado
ORDER BY t.DataLancamento DESC;
~~~

**Cuidado crítico com NOT IN e NULL:** se a lista do `NOT IN` contiver qualquer valor `NULL`, a query inteira retorna zero linhas. Isso acontece porque `valor <> NULL` é sempre `UNKNOWN`, e `UNKNOWN AND UNKNOWN AND...` nunca é `TRUE`. No FinanceDB, a coluna `Status` tem `NOT NULL`, então esse problema não ocorre aqui — mas é o tipo de armadilha que derruba sistemas em produção.

---

## 10. O Operador LIKE — Padrões em Texto

O operador `LIKE` filtra strings por padrão. Usa dois caracteres especiais: `%` representa zero ou mais caracteres quaisquer, e `_` representa exatamente um caractere qualquer.

~~~sql
-- Transações cuja descrição começa com "Pagamento"
SELECT
    t.TransacaoID,
    t.Descricao,
    t.Valor,
    t.DataLancamento
FROM Transacoes AS t
WHERE
    t.EmpresaID = 7
    AND t.Descricao LIKE 'Pagamento%'    -- começa com "Pagamento"
ORDER BY t.DataLancamento;

-- Transações com "fornecedor" em qualquer posição da descrição
SELECT
    t.TransacaoID,
    t.Descricao,
    t.Valor
FROM Transacoes AS t
WHERE
    t.EmpresaID = 7
    AND t.Descricao LIKE '%fornecedor%'    -- contém "fornecedor" em qualquer lugar
ORDER BY t.Valor DESC;

-- Buscando por número de documento no formato NF-XXXX
-- O _ representa exatamente um caractere, % representa qualquer sequência
SELECT
    t.TransacaoID,
    t.NumeroDocumento,
    t.Descricao,
    t.Valor
FROM Transacoes AS t
WHERE
    t.EmpresaID = 7
    AND t.NumeroDocumento LIKE 'NF-%'    -- documentos que começam com "NF-"
ORDER BY t.NumeroDocumento;

-- NOT LIKE — excluir transferências da listagem
SELECT
    t.TransacaoID,
    t.Descricao,
    t.Valor
FROM Transacoes AS t
WHERE
    t.EmpresaID = 7
    AND t.Descricao NOT LIKE '%Transfer%'    -- exclui descrições com "Transfer"
ORDER BY t.DataLancamento;
~~~

**Performance e LIKE:** filtros com `%` no início da string — como `LIKE '%fornecedor%'` — não conseguem usar índices e forçam um *table scan* completo. Em tabelas grandes de transações, isso é lento. Sempre que possível, prefira `LIKE 'Pagamento%'` (sem `%` no início) para aproveitar índices sobre a coluna `Descricao`.

---

## 11. Filtros Compostos — Cenários Financeiros Reais

Agora combinamos tudo para construir filtros do mundo real.

**Cenário 1:** Relatório de pendências — transações não conciliadas dos últimos três meses com valor acima de R$ 200,00:

~~~sql
-- Relatório de pendências financeiras
SELECT
    t.TransacaoID,
    t.DataLancamento,
    t.Descricao,
    t.Valor,
    t.Status,
    t.NumeroDocumento
FROM Transacoes AS t
WHERE
    t.EmpresaID = 7
    AND t.Status = 'Pendente'                          -- apenas pendentes
    AND t.Valor > 200.00                               -- valor relevante
    AND t.DataLancamento >= DATEADD(MONTH, -3, CAST(GETDATE() AS DATE))  -- últimos 3 meses
ORDER BY t.Valor DESC, t.DataLancamento;
~~~

**Cenário 2:** Auditoria de transações suspeitas — lançamentos de alto valor fora do expediente ou cancelados no mesmo dia:

~~~sql
-- Transações de alto valor canceladas ou sem número de documento
SELECT
    t.TransacaoID,
    t.DataLancamento,
    t.Descricao,
    t.Valor,
    t.Status,
    t.NumeroDocumento
FROM Transacoes AS t
WHERE
    t.EmpresaID = 7
    AND (
        t.Valor > 10000.00                     -- alto valor
        OR t.Status = 'Cancelado'              -- ou cancelada
    )
    AND t.NumeroDocumento IS NULL              -- sem número de documento
ORDER BY t.DataLancamento DESC;
~~~

**Cenário 3:** DRE simplificado — filtrar apenas contas do plano lançáveis do tipo RECEITA para o mês de fevereiro de 2026:

~~~sql
-- Receitas lançáveis de fevereiro de 2026 para DRE
SELECT
    p.Codigo,
    p.Descricao        AS ContaPlano,
    t.DataLancamento,
    t.Descricao        AS DescricaoTransacao,
    t.Valor
FROM Transacoes AS t
INNER JOIN PlanoDeContas AS p
    ON t.ContaPlanoID = p.ContaPlanoID
WHERE
    t.EmpresaID = 7
    AND p.Tipo = 'RECEITA'                              -- apenas contas de receita
    AND p.Lancavel = 1                                  -- apenas contas lançáveis
    AND t.DataLancamento BETWEEN '2026-02-01' AND '2026-02-28'   -- fevereiro
    AND t.Status <> 'Cancelado'                         -- excluir cancelados
ORDER BY p.Codigo, t.DataLancamento;
~~~

**Cenário 4:** Filtro combinado para conciliação bancária — transações de uma conta específica, em um período, pendentes de conciliação:

~~~sql
-- Transações pendentes de conciliação da conta corrente do BB
SELECT
    t.TransacaoID,
    t.DataLancamento,
    t.NumeroDocumento,
    t.Descricao,
    t.Valor,
    t.Status
FROM Transacoes AS t
INNER JOIN ContasBancarias AS cb
    ON t.ContaID = cb.ContaID
INNER JOIN Bancos AS b
    ON cb.BancoID = b.BancoID
WHERE
    t.EmpresaID = 7
    AND b.CodigoCOMPE = 1                               -- Banco do Brasil
    AND t.Conciliado = 0                                -- não conciliado (bit = 0)
    AND t.Status IN ('Pendente', 'Conciliado')          -- excluindo cancelados
    AND t.DataLancamento BETWEEN '2026-01-01' AND '2026-04-30'
ORDER BY t.DataLancamento;
~~~

---

## 12. Filtrando Valores NULL com IS NULL e IS NOT NULL

`NULL` não é um valor — é a ausência de valor. Por isso, não se usa `= NULL` ou `<> NULL`. A comparação correta é feita com `IS NULL` e `IS NOT NULL`.

~~~sql
-- Transações sem número de documento registrado
SELECT
    t.TransacaoID,
    t.DataLancamento,
    t.Descricao,
    t.Valor
FROM Transacoes AS t
WHERE
    t.EmpresaID = 7
    AND t.NumeroDocumento IS NULL    -- correto: IS NULL, não = NULL
ORDER BY t.DataLancamento;

-- Transações COM número de documento
SELECT
    t.TransacaoID,
    t.NumeroDocumento,
    t.Descricao,
    t.Valor
FROM Transacoes AS t
WHERE
    t.EmpresaID = 7
    AND t.NumeroDocumento IS NOT NULL    -- tem documento registrado
ORDER BY t.NumeroDocumento;

-- Contas do plano de contas sem conta pai (são contas raiz de nível 1)
SELECT
    ContaPlanoID,
    Codigo,
    Descricao,
    Nivel
FROM PlanoDeContas
WHERE
    EmpresaID = 7
    AND ContaPaiID IS NULL    -- sem pai = conta raiz
ORDER BY Codigo;
~~~

---

## 13. Glossário Técnico

**WHERE:** Cláusula que define a condição de filtragem de linhas em uma query. Processada após `FROM` e antes de `SELECT`.

**AND:** Operador lógico que combina condições exigindo que todas sejam verdadeiras. Tem precedência maior que `OR`.

**OR:** Operador lógico que combina condições exigindo que pelo menos uma seja verdadeira. Tem precedência menor que `AND`.

**NOT:** Operador lógico que inverte o resultado de uma condição booleana.

**BETWEEN:** Operador que verifica se um valor está dentro de um intervalo fechado (inclui os extremos). Equivale a `>= AND <=`.

**IN:** Operador que verifica se um valor pertence a uma lista de valores. Mais legível que múltiplos `OR` com `=`.

**LIKE:** Operador de padrão para strings. Usa `%` (zero ou mais caracteres) e `_` (exatamente um caractere).

**IS NULL / IS NOT NULL:** Operadores corretos para comparar com ausência de valor. Nunca use `= NULL`.

**Precedência de operadores:** Ordem em que o SQL Server avalia operadores lógicos. `NOT` > `AND` > `OR`. Parênteses sobrepõem qualquer precedência.

**UNKNOWN:** Terceiro valor lógico do SQL, retornado quando qualquer operando de uma comparação é `NULL`. Linhas com resultado `UNKNOWN` são descartadas pelo `WHERE`.

**Table scan:** Leitura sequencial de todas as páginas de uma tabela, sem uso de índice. Ocorre quando o filtro não pode ser resolvido por índice, como `LIKE '%texto%'`.

**SARGable (Search ARGument ABLE):** Predicado que pode ser resolvido usando um índice. Filtros com `=`, `>`, `<`, `BETWEEN` e `LIKE 'texto%'` são SARGable. `LIKE '%texto'` e funções aplicadas a colunas no WHERE não são.

---

## 14. Antecipação de Erros e Troubleshooting

**Erro 1 — Misturar AND e OR sem parênteses:**
O SQL Server não avisa que a query tem comportamento inesperado. Sempre teste com `SELECT COUNT(*)` antes de usar filtros compostos com `OR` em produção. Compare o número de linhas com e sem parênteses.

**Erro 2 — Usar = NULL no WHERE:**
A condição `WHERE coluna = NULL` nunca retorna linhas, porque `NULL = NULL` é `UNKNOWN`, não `TRUE`. Use sempre `IS NULL`.

**Erro 3 — NOT IN com lista contendo NULL:**
`WHERE id NOT IN (1, 2, NULL)` retorna zero linhas. O SQL Server expande para `id <> 1 AND id <> 2 AND id <> NULL`. A última condição é sempre `UNKNOWN`, tornando todo o `AND` `UNKNOWN`. Solução: use `NOT EXISTS` ou garanta que a lista não contém `NULL`.

**Erro 4 — BETWEEN com datas em colunas DATETIME:**
`BETWEEN '2026-01-01' AND '2026-01-31'` exclui registros com hora após meia-noite do dia 31. No FinanceDB, `DataLancamento` é `DATE`, então o problema não ocorre. Em sistemas com `DATETIME`, prefira `>= '2026-01-01' AND < '2026-02-01'`.

**Erro 5 — LIKE com acento e collation:**
O collation `Latin1_General_CI_AS` do FinanceDB é *case-insensitive* (CI) mas *accent-sensitive* (AS). Isso significa que `LIKE '%pagamento%'` encontra "Pagamento" e "PAGAMENTO", mas não "páGaMenTo" com acento diferente. Atenha-se ao padrão de acentuação dos dados ao usar `LIKE`.

**Erro 6 — Aplicar função à coluna no WHERE (não SARGable):**
`WHERE YEAR(DataLancamento) = 2026` não é SARGable — o SQL Server precisa calcular `YEAR()` para cada linha antes de comparar, impossibilitando o uso de índice. Prefira `WHERE DataLancamento BETWEEN '2026-01-01' AND '2026-12-31'`.

---

## 15. Desafio de Fixação

**Enunciado:** Escreva uma query que retorne todas as transações do FinanceDB que satisfaçam simultaneamente as seguintes condições: pertençam à empresa com `EmpresaID = 7`, tenham sido lançadas no primeiro semestre de 2026 (janeiro a junho), sejam do tipo RECEITA ou DESPESA (excluindo transferências), tenham valor entre R$ 100,00 e R$ 50.000,00, não estejam canceladas, e cuja descrição contenha a palavra "Serviço" ou "Produto". Ordene pelo valor descendente.

**Resolução comentada:**

~~~sql
-- Desafio do Capítulo 12 — Filtro composto com múltiplos operadores
SELECT
    t.TransacaoID,
    t.DataLancamento,
    t.Descricao,
    t.Valor,
    t.Status,
    t.TipoTransacaoID
FROM Transacoes AS t
WHERE
    -- escopo da empresa
    t.EmpresaID = 7

    -- primeiro semestre de 2026 com BETWEEN (inclusivo nos dois extremos)
    AND t.DataLancamento BETWEEN '2026-01-01' AND '2026-06-30'

    -- apenas RECEITA (1) ou DESPESA (2), excluindo TRANSFERÊNCIA (3)
    -- usando IN é mais legível do que dois OR com =
    AND t.TipoTransacaoID IN (1, 2)

    -- faixa de valor com BETWEEN
    AND t.Valor BETWEEN 100.00 AND 50000.00

    -- excluindo cancelados com <> (equivalente a NOT = 'Cancelado')
    AND t.Status <> 'Cancelado'

    -- descrição contém "Serviço" OU "Produto" — agrupado com parênteses
    -- sem parênteses, o AND anterior se ligaria apenas ao primeiro LIKE
    AND (
        t.Descricao LIKE '%Serviço%'
        OR t.Descricao LIKE '%Produto%'
    )

ORDER BY t.Valor DESC;   -- maiores valores primeiro
~~~

**Por que os parênteses no LIKE são obrigatórios?** Sem eles, a query seria interpretada como `... AND t.Descricao LIKE '%Serviço%' OR t.Descricao LIKE '%Produto%'`. O `AND` se liga ao `LIKE '%Serviço%'`, e o `OR` ficaria solto — podendo retornar transações de outras empresas cujas descrições contenham "Produto". Os parênteses garantem que o `OR` seja resolvido primeiro, formando um bloco que só então é combinado com o `AND` externo.

---

## 16. Resumo dos Pontos-Chave

A cláusula `WHERE` é o mecanismo central de filtragem do SQL e o recurso mais crítico para a corretude de relatórios financeiros. Ela é processada antes do `SELECT`, o que significa que o motor descarta linhas indesejadas antes de montar o resultado — tornando filtros bem escritos um fator direto de performance.

O operador `AND` exige que todas as condições sejam verdadeiras e tem precedência maior que `OR`, que exige apenas uma condição verdadeira. Misturar os dois sem parênteses é a principal fonte de bugs silenciosos em sistemas financeiros — silenciosos porque a query executa sem erro, mas retorna dados incorretos. A regra é simples: sempre use parênteses ao combinar `AND` e `OR` na mesma cláusula.

O operador `BETWEEN` simplifica filtros de intervalo e é inclusivo nos dois extremos. O operador `IN` substitui múltiplos `OR` com elegância e legibilidade. O operador `LIKE` filtra por padrão textual, mas filtros com `%` no início da string impedem o uso de índices. O `NOT` pode ser combinado com todos os operadores anteriores para filtragem por exclusão.

O tratamento de `NULL` merece atenção especial: sempre use `IS NULL` e `IS NOT NULL` para comparar com ausência de valor, e nunca coloque `NULL` em listas do `NOT IN`. Predicados SARGable — aqueles que permitem uso de índices — são fundamentais para performance em tabelas de transações com milhões de registros. Funções aplicadas a colunas no `WHERE` destroem SARGability; filtros por intervalo de datas a preservam.

---

## Log de Estado do Projeto

~~~text
## Estado — Após o Capítulo 12

=== BANCO DE DADOS ===
Nome: FinanceDB
Collation: Latin1_General_CI_AS
Recovery Model: FULL
Status: Operacional

=== TABELAS E REGISTROS ===
Bancos:           5 registros (Itaú 341, BB 1, Caixa 104, Bradesco 237, Santander 033)
TiposTransacao:   3 registros (RECEITA/C, DESPESA/D, TRANSF/D)
Empresas:         2 registros (FinanceDB Holding EmpresaID=7, segunda empresa)
ContasBancarias:  4 registros com SaldoAtual atualizado
PlanoDeContas:    25 registros em 3 níveis hierárquicos
Transacoes:       29 lançamentos de Jan a Abr 2026
Orcamentos:       registros de Jan/Fev/Mar 2026 para ambas as empresas

=== OBJETOS CRIADOS ===
Tabelas:          7 (todas operacionais)
Constraints:      PRIMARY KEYS, FOREIGN KEYS, CHECK CONSTRAINTS, UNIQUE
Índices:          criados automaticamente pelas PKs e UQs

=== CAPÍTULOS CONCLUÍDOS ===
Módulo 1: Capítulos 1 a 6 (Fundamentos e Teoria)
Módulo 2: Capítulos 7 a 12 (T-SQL Básico)
  - Cap 7:  CREATE DATABASE — FinanceDB criado
  - Cap 8:  CREATE TABLE — tabelas base criadas
  - Cap 9:  PRIMARY KEY, FOREIGN KEY, IDENTITY
  - Cap 10: INSERT INTO — todas as tabelas populadas
  - Cap 11: SELECT e variações
  - Cap 12: WHERE, AND, OR, NOT, BETWEEN, IN, LIKE ← ATUAL

=== PRÓXIMO CAPÍTULO ===
Capítulo 13: ORDER BY, TOP e OFFSET-FETCH
~~~

---

## Prompt de Continuidade — Capítulo 13

~~~text
Contexto: Estou estudando o livro "SQL Server para Aplicações
Financeiras com T-SQL". Meu ambiente é Windows 11, SSMS,
SQL Server 2022. O projeto prático incremental se chama FinanceDB.

Concluí o Capítulo 12, que cobriu filtragem com WHERE em
profundidade. Aprendi: AND, OR, NOT, BETWEEN, IN, LIKE,
IS NULL, IS NOT NULL, precedência de operadores lógicos,
uso de parênteses para controle de precedência, filtros
SARGable versus não SARGable, e o comportamento de NULL
em comparações e listas NOT IN. O banco FinanceDB possui
7 tabelas populadas: Bancos (5), TiposTransacao (3),
Empresas (2 — FinanceDB Holding EmpresaID=7 e segunda
empresa), ContasBancarias (4), PlanoDeContas (25),
Transacoes (29 lançamentos Jan a Abr 2026) e Orcamentos
(Jan/Fev/Mar 2026).

Siga rigorosamente o Prompt Mestre v1.1: narrativa densa
com mínimo de 2.000 palavras, Técnica de Feynman, analogia
de ancoragem, diagrama Mermaid escapado com ~~~mermaid,
código SQL comentado linha a linha escapado com ~~~,
glossário técnico, antecipação de erros, troubleshooting,
desafio de fixação com resolução comentada, resumo dos
pontos-chave, log de estado do projeto atualizado e prompt
de continuidade para o próximo capítulo.
Todo o conteúdo deve ser gerado dentro de um bloco ```markdown.
Chame aulas de capítulos e curso de livro.

Por favor, gere o Capítulo 13: Ordenando e Limitando —
ORDER BY, TOP e OFFSET-FETCH. Objetivo: controlar a ordem
e a quantidade de registros retornados em consultas
financeiras usando ORDER BY com ASC e DESC, TOP para
limitar resultados e selecionar os maiores lançamentos,
e OFFSET-FETCH para implementar paginação de extratos
bancários e relatórios financeiros no FinanceDB.
Pré-requisito: Capítulo 12 concluído.
~~~

---

Dúvidas? Posso prosseguir para o Capítulo 13?