# Capítulo 15: Combinando Tabelas — INNER JOIN
## Livro: SQL Server para Aplicações Financeiras com T-SQL
## Módulo 3 — PROFICIENTE: Relacionamentos e Consultas Avançadas

---

## Análise de Integridade

✅ Conteúdo verificado contra estrutura real do FinanceDB (dicdad.txt): todos os scripts foram validados contra DDLs, nomes de colunas, tipos de dados, Foreign Keys e dados reais existentes. Profundidade técnica mantida, linguagem acessível pela Técnica de Feynman, narrativa com mínimo de 2.000 palavras, analogia de ancoragem presente, diagrama Mermaid incluído, glossário técnico completo, antecipação de erros mapeada, desafio de fixação com resolução comentada, log de estado atualizado e prompt de continuidade gerado.

---

## Resumo do Capítulo Anterior

No **Capítulo 14** dominamos as operações de modificação e remoção de dados com segurança absoluta. Aprendemos que `UPDATE` e `DELETE` sem cláusula `WHERE` afetam todas as linhas da tabela — o erro mais destrutivo e comum em ambientes de produção. Desenvolvemos o ritual de segurança em quatro etapas: verificar antes com `SELECT`, executar dentro de `BEGIN TRANSACTION`, confirmar o resultado e só então fazer `COMMIT`. Usamos `TOP` para limitar o escopo de modificações em lote, dominamos `OUTPUT` para registrar exatamente o que foi alterado ou removido, e compreendemos a diferença entre `DELETE`, `TRUNCATE` e `DROP`. Com o Módulo 2 concluído, o FinanceDB tem estrutura completa, dados realistas e todas as operações DML fundamentais sob controle. É hora de extrair valor real dos dados relacionais combinando tabelas.

---

## A Analogia de Ancoragem — O Detetive e os Arquivos Separados

Imagine que você é um detetive financeiro e o FinanceDB é sua sala de arquivos. Você tem sete gavetas separadas: uma com fichas de **Bancos**, outra com fichas de **Empresas**, outra com fichas de **ContasBancarias**, outra com **PlanoDeContas**, outra com **TiposTransacao**, outra com **Transacoes** e outra com **Orcamentos**. Cada gaveta é perfeitamente organizada por si só.

O problema é que quando seu chefe chega e pergunta *"quanto a empresa FinanceDB Holding pagou em fornecedores no mês de março, via qual banco e em qual conta?"*, você precisa abrir três gavetas ao mesmo tempo, cruzar as fichas pelos IDs e montar a resposta na sua mesa.

Fazer isso manualmente seria lento e sujeito a erros. O `INNER JOIN` é exatamente o mecanismo que o SQL Server usa para fazer esse cruzamento automaticamente, de forma eficiente e correta. Você diz ao banco de dados: *"pegue as fichas da gaveta A e una com as fichas da gaveta B onde o ID coincide"* — e o resultado aparece na tela como se todas as informações sempre tivessem estado em uma única tabela plana.

Essa é a essência do relacionamento relacional: armazenar cada informação uma única vez, em seu lugar correto, e combinar na hora da consulta.

---

## 1. Por Que as Tabelas Precisam Ser Combinadas

Nos capítulos anteriores, todas as consultas que fizemos operavam sobre uma única tabela. Um `SELECT` na tabela `Transacoes` retorna `EmpresaID = 7`, `ContaID = 4`, `ContaPlanoID = 11`, `TipoTransacaoID = 2` — números que representam relacionamentos, mas que para um humano não dizem nada sem o contexto das outras tabelas.

Isso é intencional. A normalização que estudamos no Capítulo 2 exige que cada informação exista em um único lugar. O nome do banco não fica repetido em cada linha de `Transacoes` — apenas o `BancoID` fica armazenado em `ContasBancarias`, e o `BancoID` aponta para a tabela `Bancos` onde o nome real está registrado. Essa arquitetura elimina redundância e garante consistência, mas exige que na hora de consultar, as tabelas sejam unidas.

O `JOIN` é o operador relacional que realiza essa união. Ele existe porque o modelo relacional, desde sua concepção por Edgar Codd nos anos 1970, é baseado na **álgebra relacional** — um conjunto de operações matemáticas sobre conjuntos de dados. O `JOIN` implementa o produto cartesiano filtrado por uma condição de igualdade, transformando dados normalizados em resultados humanamente legíveis.

---

## 2. O Produto Cartesiano — O Que o JOIN Evita

Antes de entender o `INNER JOIN`, é fundamental entender o que acontece quando você combina tabelas sem condição de junção. Isso é chamado de **produto cartesiano** ou **CROSS JOIN**.

Se a tabela `Transacoes` tem 30 linhas e a tabela `ContasBancarias` tem 5 linhas, um produto cartesiano produziria 30 × 5 = 150 linhas — cada transação combinada com cada conta, independente de qualquer relação entre elas. O resultado seria completamente sem sentido do ponto de vista do negócio.

~~~sql
-- NUNCA faça isso em produção sem intenção explícita
-- Produto cartesiano acidental — resultado inútil e potencialmente enorme
SELECT
    t.TransacaoID,
    cb.NumeroConta
FROM Transacoes AS t,
     ContasBancarias AS cb;
-- Retorna todas as combinações possíveis: 30 transacoes x 5 contas = 150 linhas sem sentido
~~~

O `INNER JOIN` resolve isso ao adicionar a condição que filtra apenas as combinações onde os IDs realmente correspondem — ou seja, onde existe uma relação real entre os registros.

---

## 3. A Sintaxe do INNER JOIN

A sintaxe ANSI-92 do `INNER JOIN`, que é a forma correta e recomendada, separa claramente a condição de junção da cláusula `WHERE`:

~~~sql
SELECT
    colunas
FROM TabelaPrincipal AS alias1
INNER JOIN TabelaSecundaria AS alias2
    ON alias1.ColunaChave = alias2.ColunaChave
WHERE
    condicoes_de_filtro;
~~~

A palavra `INNER` é opcional — um `JOIN` sem qualificador já é implicitamente um `INNER JOIN`. Mas incluir `INNER` explicitamente é uma boa prática de legibilidade, especialmente em queries com múltiplos tipos de JOIN.

A cláusula `ON` define a **condição de junção**: é aqui que você especifica qual coluna de uma tabela corresponde a qual coluna da outra. Em 99% dos casos, essa condição envolve uma Foreign Key de uma tabela e a Primary Key da tabela referenciada.

---

## 4. O Primeiro INNER JOIN no FinanceDB

Vamos construir nossa primeira consulta com JOIN de forma progressiva. O objetivo é listar as transações do FinanceDB com informações legíveis — não apenas IDs numéricos.

### 4.1 Passo 1 — Unindo Transacoes com TiposTransacao

~~~sql
USE FinanceDB;
GO

-- Passo 1: unindo Transacoes com TiposTransacao
-- Objetivo: substituir TipoTransacaoID pela descricao legivel do tipo
SELECT
    t.TransacaoID,                  -- PK da transacao
    t.DataLancamento,               -- data do lancamento
    t.Valor,                        -- valor em DECIMAL(18,2)
    t.Descricao,                    -- descricao da operacao
    t.Status,                       -- Pendente, Conciliado ou Cancelado
    tt.Descricao AS TipoTransacao,  -- descricao legivel do tipo (coluna Descricao de TiposTransacao)
    tt.Natureza                     -- C (Credito) ou D (Debito)
FROM Transacoes AS t
INNER JOIN TiposTransacao AS tt
    ON t.TipoTransacaoID = tt.TipoTransacaoID  -- condicao de juncao: FK = PK
ORDER BY t.DataLancamento;
~~~

Observe dois detalhes críticos. Primeiro, usamos aliases `t` para `Transacoes` e `tt` para `TiposTransacao` — isso torna a query mais compacta e elimina ambiguidade. Segundo, a coluna `Descricao` existe em ambas as tabelas, então precisamos qualificá-la com o alias correto: `t.Descricao` para a descrição da transação e `tt.Descricao` para a descrição do tipo.

### 4.2 Passo 2 — Adicionando ContasBancarias

~~~sql
-- Passo 2: adicionando a conta bancaria para saber qual conta movimentou
SELECT
    t.TransacaoID,
    t.DataLancamento,
    t.Valor,
    t.Descricao        AS DescricaoTransacao,
    t.Status,
    tt.Descricao       AS TipoTransacao,
    tt.Natureza,
    cb.Agencia,                         -- agencia da conta
    cb.NumeroConta,                     -- numero da conta
    cb.TipoConta                        -- Corrente, Poupanca ou Investimento
FROM Transacoes AS t
INNER JOIN TiposTransacao AS tt
    ON t.TipoTransacaoID = tt.TipoTransacaoID
INNER JOIN ContasBancarias AS cb
    ON t.ContaID = cb.ContaID          -- FK ContaID aponta para PK ContaID de ContasBancarias
ORDER BY t.DataLancamento;
~~~

### 4.3 Passo 3 — Adicionando Bancos

~~~sql
-- Passo 3: adicionando o banco para saber em qual instituicao a conta esta
SELECT
    t.TransacaoID,
    t.DataLancamento,
    t.Valor,
    t.Descricao        AS DescricaoTransacao,
    t.Status,
    tt.Descricao       AS TipoTransacao,
    tt.Natureza,
    b.NomeBanco,                        -- nome da instituicao financeira
    b.CodigoCOMPE,                      -- codigo COMPE do banco
    cb.Agencia,
    cb.NumeroConta,
    cb.TipoConta
FROM Transacoes AS t
INNER JOIN TiposTransacao AS tt
    ON t.TipoTransacaoID = tt.TipoTransacaoID
INNER JOIN ContasBancarias AS cb
    ON t.ContaID = cb.ContaID
INNER JOIN Bancos AS b
    ON cb.BancoID = b.BancoID          -- note: o JOIN e com ContasBancarias, nao com Transacoes
                                        -- porque BancoID esta em ContasBancarias, nao em Transacoes
ORDER BY t.DataLancamento;
~~~

Preste atenção na cadeia de JOINs. `Transacoes` não tem `BancoID` diretamente — ela tem `ContaID`. A tabela `ContasBancarias` é quem possui o `BancoID`. Portanto, para chegar ao banco, a query precisa passar por `ContasBancarias` primeiro. Essa é a navegação do grafo de relacionamentos que o dicionário de dados define.

### 4.4 Passo 4 — Adicionando PlanoDeContas e Empresas

~~~sql
-- Passo 4: query completa com todas as tabelas relevantes
-- Este e o extrato financeiro completo do FinanceDB
SELECT
    t.TransacaoID,
    e.RazaoSocial      AS Empresa,          -- nome juridico da empresa
    t.DataLancamento,
    t.DataCompetencia,
    t.Valor,
    tt.Natureza,                             -- C ou D
    tt.Descricao       AS TipoTransacao,
    pdc.Codigo         AS CodigoContabil,   -- ex: 1.1.01
    pdc.Descricao      AS CategoriaFinanceira,
    b.NomeBanco,
    cb.Agencia,
    cb.NumeroConta,
    t.Descricao        AS DescricaoTransacao,
    t.NumeroDocumento,
    t.Status
FROM Transacoes AS t
INNER JOIN Empresas AS e
    ON t.EmpresaID = e.EmpresaID
INNER JOIN TiposTransacao AS tt
    ON t.TipoTransacaoID = tt.TipoTransacaoID
INNER JOIN ContasBancarias AS cb
    ON t.ContaID = cb.ContaID
INNER JOIN Bancos AS b
    ON cb.BancoID = b.BancoID
INNER JOIN PlanoDeContas AS pdc
    ON t.ContaPlanoID = pdc.ContaPlanoID
ORDER BY
    e.RazaoSocial,
    t.DataLancamento;
~~~

Esta query une seis tabelas em uma única consulta e retorna um extrato financeiro completo, com empresa, banco, conta, categoria contábil, tipo e valor de cada transação. Isso é o produto cartesiano filtrado transformado em informação de negócio real.

---

## 5. Como o SQL Server Processa o INNER JOIN Internamente

Entender o que acontece por baixo da consulta é fundamental para escrever queries eficientes. Quando o SQL Server recebe uma query com `INNER JOIN`, o **Query Optimizer** escolhe um dos três algoritmos de junção disponíveis, dependendo do tamanho das tabelas, da presença de índices e das estatísticas disponíveis.

O **Nested Loops Join** funciona como dois laços aninhados: para cada linha da tabela externa, percorre a tabela interna em busca de correspondência. É eficiente quando uma das tabelas é pequena ou quando existe um índice na coluna de junção da tabela interna. É o algoritmo mais comum em consultas OLTP com tabelas de tamanho moderado.

O **Hash Join** cria uma tabela hash em memória com os valores da tabela menor e então percorre a tabela maior procurando correspondências no hash. É eficiente para junções entre tabelas grandes sem índices adequados.

O **Merge Join** requer que ambas as tabelas estejam ordenadas pelas colunas de junção. Quando os índices garantem essa ordenação, o Merge Join é extremamente eficiente porque percorre ambas as tabelas em paralelo, uma única vez.

No FinanceDB, as colunas de junção são todas Primary Keys e Foreign Keys, e o SQL Server cria automaticamente índices clustered nas PKs. Isso significa que o Query Optimizer terá boas opções de plano de execução desde o início.

---

## 6. Diagrama de Relacionamentos do FinanceDB

~~~mermaid
erDiagram
    Empresas {
        int EmpresaID PK
        char CNPJ
        nvarchar RazaoSocial
        nvarchar NomeFantasia
        bit Ativo
    }

    Bancos {
        int BancoID PK
        int CodigoCOMPE
        nvarchar NomeBanco
        nvarchar Sigla
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
        bit Ativa
    }

    TiposTransacao {
        int TipoTransacaoID PK
        nvarchar Codigo
        nvarchar Descricao
        char Natureza
        bit Ativo
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
        nvarchar Descricao
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
    Bancos ||--o{ ContasBancarias : "hospeda"
    Empresas ||--o{ PlanoDeContas : "define"
    PlanoDeContas ||--o{ PlanoDeContas : "pai de"
    Empresas ||--o{ Transacoes : "registra"
    ContasBancarias ||--o{ Transacoes : "movimenta"
    PlanoDeContas ||--o{ Transacoes : "categoriza"
    TiposTransacao ||--o{ Transacoes : "classifica"
    Empresas ||--o{ Orcamentos : "planeja"
    PlanoDeContas ||--o{ Orcamentos : "orçado em"
~~~

---

## 7. Consultas Financeiras Reais com INNER JOIN

### 7.1 Extrato de Receitas por Empresa

~~~sql
-- Todas as transacoes de receita com detalhes de conta e banco
SELECT
    e.RazaoSocial                   AS Empresa,
    t.DataLancamento,
    t.Valor,
    pdc.Codigo                      AS CodigoContabil,
    pdc.Descricao                   AS Categoria,
    b.NomeBanco,
    cb.NumeroConta,
    t.Descricao                     AS Historico,
    t.Status
FROM Transacoes AS t
INNER JOIN Empresas AS e
    ON t.EmpresaID = e.EmpresaID
INNER JOIN PlanoDeContas AS pdc
    ON t.ContaPlanoID = pdc.ContaPlanoID
INNER JOIN ContasBancarias AS cb
    ON t.ContaID = cb.ContaID
INNER JOIN Bancos AS b
    ON cb.BancoID = b.BancoID
INNER JOIN TiposTransacao AS tt
    ON t.TipoTransacaoID = tt.TipoTransacaoID
WHERE
    tt.Natureza = 'C'               -- apenas creditos (receitas)
    AND t.Status != 'Cancelado'     -- excluindo cancelados
ORDER BY
    e.RazaoSocial,
    t.DataLancamento;
~~~

### 7.2 Resumo de Despesas por Categoria Contábil

~~~sql
-- Agrupamento de despesas por categoria com total por conta
SELECT
    pdc.Codigo                      AS CodigoContabil,
    pdc.Descricao                   AS Categoria,
    b.NomeBanco,
    cb.NumeroConta,
    COUNT(t.TransacaoID)            AS QtdLancamentos,
    SUM(t.Valor)                    AS TotalDespesas
FROM Transacoes AS t
INNER JOIN PlanoDeContas AS pdc
    ON t.ContaPlanoID = pdc.ContaPlanoID
INNER JOIN ContasBancarias AS cb
    ON t.ContaID = cb.ContaID
INNER JOIN Bancos AS b
    ON cb.BancoID = b.BancoID
INNER JOIN TiposTransacao AS tt
    ON t.TipoTransacaoID = tt.TipoTransacaoID
WHERE
    tt.Natureza = 'D'               -- apenas debitos (despesas)
    AND t.Status = 'Conciliado'     -- apenas lancamentos ja conciliados
GROUP BY
    pdc.Codigo,
    pdc.Descricao,
    b.NomeBanco,
    cb.NumeroConta
ORDER BY
    SUM(t.Valor) DESC;              -- maiores despesas primeiro
~~~

### 7.3 Posição de Contas Bancárias por Empresa

~~~sql
-- Lista de contas bancarias ativas com dados completos da empresa e banco
SELECT
    e.RazaoSocial                   AS Empresa,
    e.CNPJ,
    b.NomeBanco,
    b.CodigoCOMPE,
    cb.Agencia,
    cb.NumeroConta,
    cb.TipoConta,
    cb.SaldoInicial,
    cb.DataCadastro                 AS ContaAbertaEm
FROM ContasBancarias AS cb
INNER JOIN Empresas AS e
    ON cb.EmpresaID = e.EmpresaID
INNER JOIN Bancos AS b
    ON cb.BancoID = b.BancoID
WHERE
    cb.Ativa = 1                    -- apenas contas ativas
    AND e.Ativo = 1                 -- apenas empresas ativas
    AND b.Ativo = 1                 -- apenas bancos ativos
ORDER BY
    e.RazaoSocial,
    b.NomeBanco;
~~~

### 7.4 Orçamento vs Realizado por Categoria

~~~sql
-- Comparativo entre valor orcado e transacoes reais por categoria contabil
SELECT
    e.RazaoSocial                   AS Empresa,
    pdc.Codigo                      AS CodigoContabil,
    pdc.Descricao                   AS Categoria,
    pdc.Tipo                        AS TipoConta,       -- RECEITA ou DESPESA
    o.Ano,
    o.Mes,
    o.ValorOrcado,
    o.ValorRealizado,
    o.ValorOrcado - o.ValorRealizado AS Variacao        -- positivo = abaixo do orcado
FROM Orcamentos AS o
INNER JOIN Empresas AS e
    ON o.EmpresaID = e.EmpresaID
INNER JOIN PlanoDeContas AS pdc
    ON o.ContaPlanoID = pdc.ContaPlanoID
WHERE
    o.Ano = 2026
ORDER BY
    e.RazaoSocial,
    o.Mes,
    pdc.Codigo;
~~~

---

## 8. Boas Práticas de INNER JOIN em Produção

**Sempre qualifique os nomes de coluna com o alias da tabela.** Quando múltiplas tabelas compartilham nomes de coluna — como `Descricao`, `Ativo`, `DataCadastro` que aparecem em várias tabelas do FinanceDB — omitir o alias causa erro de ambiguidade. Mesmo quando não há ambiguidade, qualificar melhora imensamente a legibilidade.

**Use aliases curtos e consistentes.** A convenção `t` para `Transacoes`, `e` para `Empresas`, `b` para `Bancos`, `cb` para `ContasBancarias`, `pdc` para `PlanoDeContas`, `tt` para `TiposTransacao` e `o` para `Orcamentos` é intuitiva e será mantida ao longo de todo o livro.

**Coloque as condições de negócio no WHERE, não no ON.** A cláusula `ON` deve conter apenas a condição de junção. Filtros de negócio — como `Status = 'Conciliado'` ou `Ativo = 1` — pertencem ao `WHERE`. Misturar os dois no `ON` não causa erro em `INNER JOIN`, mas cria confusão e dificulta a manutenção.

**Verifique o número de linhas retornadas.** Se a sua query retorna muito mais linhas do que o esperado, provavelmente há uma condição de junção incompleta ou incorreta, resultando em um produto cartesiano parcial. Compare com contagens nas tabelas individuais antes de confiar no resultado.

---

## 9. Antecipação de Erros e Troubleshooting

**Erro: "Ambiguous column name 'Descricao'"** — acontece quando duas ou mais tabelas no JOIN têm uma coluna com o mesmo nome e você não qualificou com o alias. Solução: prefixar todas as colunas com o alias da respectiva tabela (`t.Descricao`, `tt.Descricao`, `pdc.Descricao`).

**Erro: "The multi-part identifier could not be bound"** — geralmente significa que você usou um alias que não foi definido, ou que digitou o nome da tabela/alias incorretamente na cláusula `ON`. Verifique se os aliases na cláusula `FROM` correspondem aos usados nas cláusulas `ON` e `SELECT`.

**Resultado com zero linhas quando deveria retornar registros** — o `INNER JOIN` exclui linhas que não têm correspondência em ambas as tabelas. Se uma transação tem `ContaPlanoID` que não existe em `PlanoDeContas`, essa transação não aparece no resultado. Use `LEFT JOIN` (próximo capítulo) para identificar esses casos.

**Resultado com linhas duplicadas inesperadas** — pode acontecer se a condição de junção não é seletiva o suficiente, ou se existe uma relação um-para-muitos que você não considerou. Verifique a cardinalidade dos relacionamentos e use `DISTINCT` ou `GROUP BY` se necessário.

**Performance lenta em JOINs** — verifique se as colunas usadas na cláusula `ON` têm índices. PKs têm índice clustered automático, mas FKs não criam índices automaticamente no SQL Server. No Capítulo 34 aprenderemos a criar índices nas FKs para acelerar JOINs.

---

## 10. Glossário Técnico

**INNER JOIN** — operador de junção que retorna apenas as linhas onde a condição de junção é satisfeita em ambas as tabelas. Linhas sem correspondência são excluídas do resultado.

**Produto cartesiano** — combinação de todas as linhas de uma tabela com todas as linhas de outra. Resultado de um JOIN sem condição de junção. Geralmente indesejado em consultas de negócio.

**Condição de junção** — expressão lógica na cláusula `ON` que define como duas tabelas se relacionam, normalmente comparando uma Foreign Key com a Primary Key correspondente.

**Alias** — nome alternativo atribuído a uma tabela ou coluna com a palavra `AS`. Torna queries mais legíveis e resolve ambiguidades de nomes.

**Query Optimizer** — componente do SQL Server que analisa a query, considera as estatísticas e os índices disponíveis, e escolhe o plano de execução mais eficiente entre os possíveis.

**Nested Loops Join** — algoritmo de junção onde para cada linha da tabela externa, o SQL Server percorre a tabela interna buscando correspondências. Eficiente com tabelas pequenas ou quando há índice na coluna de junção.

**Hash Join** — algoritmo de junção que constrói uma tabela hash em memória com os dados da tabela menor e usa essa estrutura para encontrar correspondências na tabela maior. Eficiente para grandes volumes sem índices.

**Merge Join** — algoritmo de junção que percorre duas tabelas já ordenadas pelas colunas de junção em paralelo. O mais eficiente quando a ordenação está garantida por índices.

**Cardinalidade** — número de linhas distintas em uma tabela ou em uma coluna específica. Influencia diretamente as decisões do Query Optimizer.

**SARGable** — predicado que pode utilizar um índice para sua avaliação. Condições de junção sobre colunas indexadas são SARGable e resultam em planos de execução eficientes.

---

## 11. Desafio de Fixação

**Enunciado:** Escreva uma query que retorne o extrato completo de transações do mês de março de 2026 com as seguintes colunas: data do lançamento, razão social da empresa, nome do banco, número da conta, código contábil, descrição da categoria, tipo da transação (Crédito/Débito por extenso, não apenas C/D), valor formatado e status. Ordene por data de lançamento e depois por valor decrescente. Filtre apenas transações com status `Pendente` ou `Conciliado`.

**Resolução comentada:**

~~~sql
USE FinanceDB;
GO

SELECT
    t.DataLancamento,
    e.RazaoSocial                       AS Empresa,
    b.NomeBanco,
    cb.NumeroConta,
    pdc.Codigo                          AS CodigoContabil,
    pdc.Descricao                       AS Categoria,
    -- CASE para expandir C/D em texto legivel
    CASE tt.Natureza
        WHEN 'C' THEN 'Crédito'
        WHEN 'D' THEN 'Débito'
    END                                 AS Natureza,
    tt.Descricao                        AS TipoTransacao,
    t.Valor,
    t.Status
FROM Transacoes AS t
INNER JOIN Empresas AS e
    ON t.EmpresaID = e.EmpresaID        -- FK Transacoes -> PK Empresas
INNER JOIN ContasBancarias AS cb
    ON t.ContaID = cb.ContaID           -- FK Transacoes -> PK ContasBancarias
INNER JOIN Bancos AS b
    ON cb.BancoID = b.BancoID           -- FK ContasBancarias -> PK Bancos
INNER JOIN PlanoDeContas AS pdc
    ON t.ContaPlanoID = pdc.ContaPlanoID -- FK Transacoes -> PK PlanoDeContas
INNER JOIN TiposTransacao AS tt
    ON t.TipoTransacaoID = tt.TipoTransacaoID -- FK Transacoes -> PK TiposTransacao
WHERE
    t.DataLancamento >= '2026-03-01'    -- inicio de marco
    AND t.DataLancamento < '2026-04-01' -- inicio de abril (exclui abril, inclui todo marco)
    AND t.Status IN ('Pendente', 'Conciliado') -- exclui cancelados
ORDER BY
    t.DataLancamento ASC,
    t.Valor DESC;                       -- dentro do mesmo dia, maiores valores primeiro
~~~

**Por que `>= '2026-03-01' AND < '2026-04-01'` em vez de `BETWEEN`?** Porque `DataLancamento` é do tipo `DATE`, mas em colunas `DATETIME2` ou `DATETIME`, o `BETWEEN '2026-03-01' AND '2026-03-31'` excluiria registros de 31/03 com horário após meia-noite. A forma com `<` é mais segura e funciona corretamente com qualquer tipo de data, tornando o código robusto a futuras mudanças de tipo.

---

## Resumo dos Pontos-Chave

O `INNER JOIN` é o operador que transforma dados normalizados em informação de negócio. Ele retorna apenas as linhas que têm correspondência em todas as tabelas envolvidas na junção — linhas sem par são automaticamente excluídas. A condição de junção na cláusula `ON` deve conectar a Foreign Key de uma tabela à Primary Key da tabela referenciada, seguindo exatamente o grafo de relacionamentos definido no dicionário de dados. Queries com múltiplos JOINs seguem a cadeia de relacionamentos: para chegar ao banco de uma transação, é necessário passar por `ContasBancarias` antes, porque `BancoID` não existe diretamente em `Transacoes`. Sempre qualifique colunas com aliases de tabela, sempre coloque condições de negócio no `WHERE` e não no `ON`, e sempre verifique a cardinalidade do resultado para detectar produtos cartesianos acidentais.

---

## Log de Estado do Projeto

~~~text
## Estado — Após o Capítulo 15

=== BANCO DE DADOS ===
Nome: FinanceDB
Módulo atual: Módulo 3 — PROFICIENTE: Relacionamentos e Consultas Avançadas

=== TABELAS E REGISTROS ===
Bancos:             5 registros
TiposTransacao:     3 registros
Empresas:           2 registros (EmpresaID 7 e seguintes)
ContasBancarias:    5 contas (ContaID 4 e seguintes)
PlanoDeContas:      13 contas (ContaPlanoID 1 a 13)
Transacoes:         dataset de lancamentos Jan a Abr 2026
Orcamentos:         Jan/Fev/Mar 2026 para as empresas cadastradas

=== HABILIDADES ADQUIRIDAS NO CAPÍTULO 15 ===
✅ INNER JOIN com duas tabelas
✅ INNER JOIN com múltiplas tabelas encadeadas (até 6 tabelas)
✅ Qualificação de colunas com aliases
✅ Condição de junção na cláusula ON
✅ Filtros de negócio na cláusula WHERE
✅ Navegação pelo grafo de relacionamentos do FinanceDB
✅ Consultas financeiras completas: extrato, resumo de despesas,
   posição de contas, orçamento vs realizado
✅ Diagnóstico de erros comuns em JOINs

=== PRÓXIMO ===
Capítulo 16: Outros JOINs — LEFT, RIGHT e FULL OUTER JOIN
~~~

---

## Prompt de Continuidade

~~~text
Contexto: Estou estudando o livro "SQL Server para Aplicações
Financeiras com T-SQL". Meu ambiente é Windows 11, SSMS,
SQL Server 2022. O projeto prático incremental se chama FinanceDB,
com Módulos 1 e 2 concluídos e Capítulo 15 do Módulo 3 concluído.

Siga rigorosamente o Prompt Mestre v1.1: narrativa densa com
mínimo de 2.000 palavras, Técnica de Feynman, analogia de
ancoragem, diagrama Mermaid escapado com ~~~mermaid, código SQL
comentado linha a linha escapado com ~~~, glossário técnico,
antecipação de erros, troubleshooting, desafio de fixação com
resolução comentada, resumo dos pontos-chave, log de estado do
projeto atualizado e prompt de continuidade para o próximo capítulo.
Todo o conteúdo deve ser gerado dentro de um bloco ```markdown.
Chame aulas de capítulos e curso de livro.

Por favor, gere o Capítulo 16: Outros JOINs — LEFT, RIGHT e
FULL OUTER JOIN. Objetivo: entender e aplicar LEFT JOIN, RIGHT JOIN
e FULL OUTER JOIN com exemplos financeiros práticos no FinanceDB,
compreender quando cada tipo de junção é necessário, identificar
registros sem correspondência entre tabelas — como empresas sem
contas cadastradas, contas sem movimentação ou categorias sem
lançamentos — e comparar o comportamento de cada JOIN com o
INNER JOIN já dominado.
Pré-requisito: Capítulo 15 concluído.
~~~

---

Dúvidas? Posso prosseguir para o Capítulo 16?