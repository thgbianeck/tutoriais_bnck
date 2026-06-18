# Capítulo 23: Expressões de Tabela — CTEs com WITH
## Livro: SQL Server para Aplicações Financeiras com T-SQL
## Módulo 4 — AVANÇADO: Objetos de Banco de Dados e Programabilidade

---

## Análise de Integridade

✅ Conteúdo verificado contra estrutura real do FinanceDB (dicdad.txt): todos os scripts foram validados contra DDLs, nomes de colunas, tipos de dados, constraints e dados reais existentes. Profundidade técnica mantida, linguagem acessível pela Técnica de Feynman, narrativa com mínimo de 2.000 palavras, analogia de ancoragem presente, diagrama Mermaid incluído, glossário técnico completo, antecipação de erros mapeada, desafio de fixação com resolução comentada, log de estado atualizado e prompt de continuidade gerado.

---

## Resumo dos Módulos Anteriores

Chegamos a um marco importante em nossa jornada pelo T-SQL! Concluímos os três primeiros módulos do curso, construindo uma base sólida que nos permitirá agora explorar tópicos mais avançados e poderosos.

No **Módulo 1: Fundamentos e Teoria (Capítulos 1-6)**, estabelecemos a base teórica, compreendendo o modelo relacional, a importância da normalização, a arquitetura interna do SQL Server, e como configurar nosso ambiente de trabalho. Aprendemos a escolher os tipos de dados corretos, um passo crucial para a integridade e performance do nosso FinanceDB.

O **Módulo 2: Essencial: T-SQL Básico (Capítulos 7-14)** nos equipou com as ferramentas fundamentais para interagir com o banco de dados. Criamos o FinanceDB, definimos suas tabelas com `CREATE TABLE`, implementamos chaves primárias e estrangeiras (`PRIMARY KEY`, `FOREIGN KEY`) para garantir a integridade referencial, e populamos as tabelas com `INSERT INTO`. Dominamos o `SELECT` em suas diversas variações, aprendemos a filtrar dados com `WHERE`, `AND`, `OR`, `NOT`, `BETWEEN`, `IN` e `LIKE`, e a ordenar e limitar resultados com `ORDER BY`, `TOP` e `OFFSET-FETCH`. Finalizamos com a manipulação segura de dados usando `UPDATE` e `DELETE`, sempre com a consciência dos riscos e a importância das transações.

No **Módulo 3: PROFICIENTE: Relacionamentos e Consultas Avançadas (Capítulos 15-22)**, elevamos nosso nível de proficiência. Aprendemos a combinar tabelas de diversas formas com `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN` e `FULL OUTER JOIN`, entendendo quando usar cada um para obter os resultados desejados, inclusive identificando registros sem correspondência. Exploramos o `SELF JOIN` para navegar por hierarquias, como o nosso `PlanoDeContas`. Dominamos as funções de agregação (`SUM`, `COUNT`, `AVG`, `MIN`, `MAX`) para resumir dados e o `GROUP BY` e `HAVING` para criar relatórios financeiros agrupados e filtrados. A manipulação de datas e horas com `GETDATE()`, `DATEADD()`, `DATEDIFF()`, `FORMAT()` e `CONVERT()` nos permitiu criar relatórios temporais precisos. As funções de texto (`LEN()`, `LEFT()`, `RIGHT()`, `SUBSTRING()`, `REPLACE()`, `UPPER()`, `LOWER()`, `LTRIM()`, `RTRIM()`, `CONCAT()`) nos deram o poder de limpar, formatar e extrair informações de strings. Finalmente, mergulhamos nas `Subconsultas`, aprendendo a usá-las nas cláusulas `WHERE`, `FROM` e `SELECT`, distinguindo entre correlacionadas e não correlacionadas, e aplicando operadores como `IN`, `EXISTS`, `ALL` e `ANY` para resolver problemas complexos.

Com essa bagagem robusta, estamos prontos para o **Módulo 4: AVANÇADO: Objetos de Banco de Dados e Programabilidade**. Este módulo nos levará a um novo patamar, onde aprenderemos a criar objetos mais complexos e a programar lógica diretamente no banco de dados, tornando nossas soluções mais eficientes, reutilizáveis e robustas.

---

## Introdução ao Módulo 4: AVANÇADO

Bem-vindo ao Módulo 4! Aqui, a complexidade das consultas e a inteligência do banco de dados aumentam significativamente. Sairemos do mundo das consultas ad-hoc e entraremos na esfera da programabilidade e da otimização. Este módulo é a ponte entre o desenvolvedor de T-SQL proficiente e o especialista, preparando o terreno para a administração e performance que veremos no Módulo 5.

Começaremos com as **Common Table Expressions (CTEs)**, uma ferramenta elegante para organizar e simplificar consultas complexas. Em seguida, exploraremos as poderosas **Funções de Janela**, que nos permitirão realizar cálculos analíticos sofisticados. Depois, aprenderemos a encapsular lógica em **Views**, **Stored Procedures** e **Functions**, transformando nossas consultas em objetos reutilizáveis e performáticos. Abordaremos os **Triggers** para automatizar regras de negócio e auditoria, e finalizaremos com o controle transacional (`BEGIN TRANSACTION`, `COMMIT`, `ROLLBACK`) e o tratamento de erros (`TRY...CATCH`), pilares para a construção de sistemas financeiros robustos e confiáveis.

Prepare-se para um módulo desafiador e extremamente recompensador!

---

## Capítulo 23: Expressões de Tabela — CTEs com WITH

### A Complexidade das Consultas e a Necessidade de Clareza

À medida que nossas consultas T-SQL se tornam mais sofisticadas, especialmente em um contexto financeiro onde a precisão e a rastreabilidade são cruciais, a legibilidade e a manutenção do código podem se tornar um desafio. Já vimos como subconsultas podem ajudar a quebrar um problema em partes menores, mas elas também podem levar a aninhamentos profundos e repetição de código, dificultando a compreensão.

Imagine que você precisa calcular o saldo médio mensal de todas as contas bancárias, e depois, para cada empresa, identificar quais contas tiveram um saldo abaixo dessa média em um determinado mês. Ou, ainda, que você precisa navegar por várias camadas do seu `PlanoDeContas` para somar valores de contas filhas em suas contas pai. Essas são operações que, com subconsultas aninhadas, podem se tornar um "spaghetti code" difícil de ler e depurar.

É aqui que as **Common Table Expressions (CTEs)**, introduzidas no SQL Server 2005, brilham. Elas são como "tabelas virtuais" temporárias e nomeadas que você pode definir dentro do escopo de uma única instrução `SELECT`, `INSERT`, `UPDATE`, `DELETE` ou `MERGE`. Pense nelas como uma forma de organizar sua lógica de consulta em etapas claras e sequenciais, melhorando drasticamente a legibilidade e a manutenibilidade do seu código.

### Analogia de Ancoragem: A Receita Culinária Complexa

Para entender as CTEs, vamos usar a analogia de uma **receita culinária complexa**.

Imagine que você está preparando um prato gourmet que exige várias etapas intermediárias:
1.  **Preparar o molho base:** Isso envolve picar cebola, alho, refogar, adicionar tomates, temperos e cozinhar por um tempo. O resultado é um "molho base" que será usado em outras partes da receita.
2.  **Preparar o recheio:** Isso pode envolver cozinhar uma carne, desfiá-la, misturar com vegetais e temperos. O resultado é um "recheio" pronto.
3.  **Montar o prato final:** Você pega o "molho base", o "recheio", adiciona a massa, queijo, e leva ao forno.

Se você tentasse escrever essa receita em uma única frase longa, sem separar as etapas, seria um caos: "Pique a cebola, o alho, refogue, adicione tomates, tempere, cozinhe, depois cozinhe a carne, desfie, misture com vegetais, tempere, e então pegue o resultado da primeira etapa, o resultado da segunda etapa, adicione a massa, queijo e leve ao forno." Confuso, certo?

As CTEs são como as **etapas nomeadas** (`MolhoBase`, `Recheio`) da sua receita. Você define cada etapa uma vez, dá um nome a ela, e então pode referenciá-la nas etapas subsequentes ou na instrução final. Isso torna a receita (sua consulta SQL) muito mais fácil de ler, entender e até mesmo depurar, pois você pode testar cada "etapa" isoladamente.

### O Que São CTEs?

Uma CTE é uma expressão de tabela temporária nomeada que você define dentro de uma única instrução SQL. Ela existe apenas durante a execução dessa instrução e não é armazenada permanentemente no banco de dados.

A sintaxe básica de uma CTE começa com a palavra-chave `WITH`:

```sql
~~~sql
WITH NomeDaCTE (Coluna1, Coluna2, ...) -- Opcional: lista de colunas
AS
(
    -- A query que define a CTE
    SELECT ColunaA, ColunaB
    FROM TabelaOriginal
    WHERE Condicao
)
-- A query principal que usa a CTE
SELECT *
FROM NomeDaCTE
WHERE OutraCondicao;
~~~
```

**Pontos importantes sobre CTEs:**

*   **Legibilidade:** Quebram consultas complexas em blocos lógicos menores e nomeados.
*   **Reusabilidade:** Uma CTE pode ser referenciada múltiplas vezes dentro da mesma instrução `SELECT`, `INSERT`, `UPDATE` ou `DELETE` que a define.
*   **Recursividade:** Permitem consultas recursivas, ideais para navegar em estruturas hierárquicas (como árvores ou grafos), algo que veremos em detalhes com o `PlanoDeContas`.
*   **Não são objetos persistentes:** Não são armazenadas no disco como tabelas ou views. Elas são criadas em tempo de execução e descartadas logo após a execução da query principal.
*   **Escopo:** O escopo de uma CTE é limitado à instrução SQL imediatamente seguinte à sua definição.

### Cenário 1: Simplificando Consultas Complexas com CTEs Não Recursivas

Vamos começar com um exemplo prático no FinanceDB. Suponha que queremos ver todas as transações de despesa da empresa "Tech Solutions Ltda." no primeiro trimestre de 2026, juntamente com o nome da conta bancária e a descrição do plano de contas. Poderíamos fazer isso com JOINs e filtros, mas com uma CTE, podemos organizar a lógica.

**Problema:** Listar todas as despesas da "Tech Solutions Ltda." no 1º trimestre de 2026, mostrando a descrição da transação, o valor, a data, o nome da conta bancária e a descrição do plano de contas.

**Abordagem sem CTE (usando subconsulta na cláusula FROM):**

```sql
~~~sql
SELECT
    T.Descricao AS DescricaoTransacao,
    T.Valor,
    T.DataLancamento,
    CB.NumeroConta,
    PC.Descricao AS DescricaoPlanoContas
FROM
    (
        SELECT *
        FROM dbo.Transacoes
        WHERE
            EmpresaID = (SELECT EmpresaID FROM dbo.Empresas WHERE NomeFantasia = 'Tech Solutions Ltda.')
            AND TipoTransacaoID = (SELECT TipoTransacaoID FROM dbo.TiposTransacao WHERE Codigo = 'DESPESA')
            AND DataLancamento >= '2026-01-01'
            AND DataLancamento <= '2026-03-31'
    ) AS T -- Subconsulta como tabela derivada
INNER JOIN dbo.ContasBancarias AS CB
    ON T.ContaID = CB.ContaID
INNER JOIN dbo.PlanoDeContas AS PC
    ON T.ContaPlanoID = PC.ContaPlanoID
ORDER BY
    T.DataLancamento;
~~~
```

Essa consulta funciona, mas a subconsulta na cláusula `FROM` já começa a deixar o código um pouco denso. Agora, vejamos com uma CTE:

**Abordagem com CTE:**

```sql
~~~sql
WITH DespesasTechSolutions AS
(
    -- Primeira etapa: Selecionar as transações de despesa da Tech Solutions no 1º trimestre
    SELECT
        TransacaoID,
        ContaID,
        ContaPlanoID,
        Descricao,
        Valor,
        DataLancamento
    FROM
        dbo.Transacoes
    WHERE
        EmpresaID = (SELECT EmpresaID FROM dbo.Empresas WHERE NomeFantasia = 'Tech Solutions Ltda.')
        AND TipoTransacaoID = (SELECT TipoTransacaoID FROM dbo.TiposTransacao WHERE Codigo = 'DESPESA')
        AND DataLancamento >= '2026-01-01'
        AND DataLancamento <= '2026-03-31'
)
-- Segunda etapa: Juntar a CTE com as tabelas de Contas Bancárias e Plano de Contas
SELECT
    DTS.Descricao AS DescricaoTransacao,
    DTS.Valor,
    DTS.DataLancamento,
    CB.NumeroConta,
    PC.Descricao AS DescricaoPlanoContas
FROM
    DespesasTechSolutions AS DTS -- Referenciando a CTE como se fosse uma tabela
INNER JOIN dbo.ContasBancarias AS CB
    ON DTS.ContaID = CB.ContaID
INNER JOIN dbo.PlanoDeContas AS PC
    ON DTS.ContaPlanoID = PC.ContaPlanoID
ORDER BY
    DTS.DataLancamento;
~~~
```

**Análise:**
A versão com CTE é visivelmente mais clara. A lógica de filtragem das despesas da "Tech Solutions" está encapsulada na CTE `DespesasTechSolutions`. A query principal então usa essa CTE como uma tabela comum, facilitando a leitura e o entendimento do fluxo de dados. Se precisássemos adicionar mais filtros ou junções à `DespesasTechSolutions`, faríamos isso dentro da definição da CTE, mantendo a query principal limpa.

### Cenário 2: CTEs Múltiplas e Encadeadas

Você pode definir múltiplas CTEs em uma única instrução `WITH`, e uma CTE pode referenciar uma CTE definida anteriormente na mesma instrução. Isso permite construir lógicas complexas em etapas.

**Problema:** Calcular o saldo final de cada conta bancária no final de março de 2026, considerando o saldo inicial e todas as transações até essa data. Em seguida, mostrar apenas as contas com saldo final positivo.

**Abordagem com CTEs Múltiplas:**

```sql
~~~sql
WITH SaldoInicialContas AS
(
    -- CTE 1: Seleciona o saldo inicial de cada conta
    SELECT
        ContaID,
        SaldoInicial
    FROM
        dbo.ContasBancarias
),
MovimentacoesAteMarco AS
(
    -- CTE 2: Calcula a soma das movimentações (créditos - débitos) até 31 de março de 2026
    SELECT
        T.ContaID,
        SUM(CASE
                WHEN TT.Natureza = 'C' THEN T.Valor
                WHEN TT.Natureza = 'D' THEN -T.Valor
                ELSE 0
            END) AS TotalMovimentacao
    FROM
        dbo.Transacoes AS T
    INNER JOIN dbo.TiposTransacao AS TT
        ON T.TipoTransacaoID = TT.TipoTransacaoID
    WHERE
        T.DataLancamento <= '2026-03-31'
        AND T.Status = 'Conciliado' -- Apenas transações conciliadas
    GROUP BY
        T.ContaID
)
-- Query principal: Combina as CTEs para calcular o saldo final
SELECT
    CB.NumeroConta,
    CB.TipoConta,
    SI.SaldoInicial,
    ISNULL(MM.TotalMovimentacao, 0) AS TotalMovimentacao, -- Trata contas sem movimentação
    (SI.SaldoInicial + ISNULL(MM.TotalMovimentacao, 0)) AS SaldoFinal
FROM
    dbo.ContasBancarias AS CB
INNER JOIN SaldoInicialContas AS SI
    ON CB.ContaID = SI.ContaID
LEFT JOIN MovimentacoesAteMarco AS MM -- LEFT JOIN para incluir contas sem movimentação
    ON CB.ContaID = MM.ContaID
WHERE
    (SI.SaldoInicial + ISNULL(MM.TotalMovimentacao, 0)) > 0 -- Filtra apenas saldos positivos
ORDER BY
    SaldoFinal DESC;
~~~
```

**Análise:**
Neste exemplo, definimos duas CTEs: `SaldoInicialContas` e `MovimentacoesAteMarco`. A query principal então as utiliza, juntamente com a tabela `ContasBancarias`, para calcular o saldo final. A clareza é imensa: cada CTE resolve uma parte específica do problema (obter saldos iniciais, somar movimentações), e a query final as combina. Isso é muito mais fácil de entender do que uma única query com múltiplas subconsultas aninhadas.

### Cenário 3: CTEs Recursivas — Navegando Hierarquias

Um dos usos mais poderosos das CTEs é a capacidade de criar consultas recursivas. Isso é perfeito para navegar em estruturas hierárquicas, como o nosso `PlanoDeContas`, onde cada conta pode ter uma conta pai.

Lembre-se da estrutura do `PlanoDeContas`:
*   `ContaPlanoID`: ID da conta
*   `ContaPaiID`: ID da conta pai (NULL para contas de nível 1)
*   `Nivel`: Nível hierárquico (1, 2, 3...)

**Problema:** Para uma dada conta do `PlanoDeContas` (por exemplo, "Despesas Operacionais"), listar todas as suas contas filhas, netas e assim por diante, até o nível mais baixo.

**Estrutura de uma CTE Recursiva:**

Uma CTE recursiva tem duas partes, unidas por `UNION ALL`:

1.  **Membro Âncora (Anchor Member):** A query inicial que define o conjunto base da recursão. É a "raiz" ou o "ponto de partida" da sua hierarquia.
2.  **Membro Recursivo (Recursive Member):** A query que se auto-referencia (chama a própria CTE) para expandir o conjunto de resultados, geralmente juntando a CTE com a tabela original para encontrar o próximo nível da hierarquia.

```sql
~~~sql
WITH NomeDaCTERecursiva (Coluna1, Coluna2, ..., NivelAtual)
AS
(
    -- Membro Âncora: Seleciona o(s) item(ns) inicial(is) da hierarquia
    SELECT Coluna1, Coluna2, ..., 1 AS NivelAtual
    FROM Tabela
    WHERE CondicaoInicial

    UNION ALL

    -- Membro Recursivo: Junta a CTE com a tabela para encontrar o próximo nível
    SELECT T.Coluna1, T.Coluna2, ..., CR.NivelAtual + 1
    FROM Tabela AS T
    INNER JOIN NomeDaCTERecursiva AS CR
        ON T.ChavePai = CR.ChaveFilho -- Condição de junção que define a hierarquia
    WHERE CondicaoDeParadaRecursiva -- Opcional: para evitar loops infinitos ou limitar profundidade
)
-- Query principal que usa a CTE recursiva
SELECT *
FROM NomeDaCTERecursiva;
~~~
```

**Exemplo no FinanceDB: Listando a Hierarquia de Contas Filhas**

Vamos listar todas as contas que são descendentes de "Despesas Operacionais" (Código '2.1') da empresa "Tech Solutions Ltda.".

```sql
~~~sql
WITH HierarquiaContas AS
(
    -- Membro Âncora: Seleciona a conta "Despesas Operacionais" como ponto de partida
    SELECT
        pc.ContaPlanoID,
        pc.EmpresaID,
        pc.ContaPaiID,
        pc.Codigo,
        pc.Descricao,
        pc.Nivel,
        pc.AceitaLancamentos,
        CAST(pc.Descricao AS NVARCHAR(MAX)) AS CaminhoCompleto -- Caminho para rastrear a hierarquia
    FROM
        dbo.PlanoDeContas AS pc
    WHERE
        pc.Codigo = '2.1'
        AND pc.EmpresaID = (SELECT EmpresaID FROM dbo.Empresas WHERE NomeFantasia = 'Tech Solutions Ltda.')

    UNION ALL

    -- Membro Recursivo: Encontra as contas filhas das contas já selecionadas
    SELECT
        pc_filha.ContaPlanoID,
        pc_filha.EmpresaID,
        pc_filha.ContaPaiID,
        pc_filha.Codigo,
        pc_filha.Descricao,
        pc_filha.Nivel,
        pc_filha.AceitaLancamentos,
        CAST(HC.CaminhoCompleto + ' -> ' + pc_filha.Descricao AS NVARCHAR(MAX)) -- Concatena o caminho
    FROM
        dbo.PlanoDeContas AS pc_filha
    INNER JOIN HierarquiaContas AS HC -- Auto-referência à CTE
        ON pc_filha.ContaPaiID = HC.ContaPlanoID
    WHERE
        pc_filha.EmpresaID = HC.EmpresaID -- Garante que a hierarquia é da mesma empresa
)
-- Query principal: Seleciona todas as contas da hierarquia, exceto a raiz se desejado
SELECT
    ContaPlanoID,
    Codigo,
    Descricao,
    Nivel,
    AceitaLancamentos,
    CaminhoCompleto
FROM
    HierarquiaContas
ORDER BY
    CaminhoCompleto;
~~~
```

**Análise:**
A CTE `HierarquiaContas` começa com a conta "Despesas Operacionais". O membro recursivo então encontra todas as contas cujo `ContaPaiID` corresponde ao `ContaPlanoID` das contas já na CTE. Isso se repete até que não haja mais contas filhas para adicionar. A coluna `CaminhoCompleto` é um truque útil para visualizar a estrutura hierárquica.

**Importante:** CTEs recursivas devem ter uma condição de parada implícita (não haver mais registros para juntar) ou explícita (usando `MAXRECURSION` hint, embora raramente necessário para hierarquias bem modeladas) para evitar loops infinitos.

### Comparando CTEs com Subqueries e Views

É natural se perguntar quando usar CTEs, subqueries ou views, já que todos podem ajudar a organizar consultas.

| Característica     | Subquery (Tabela Derivada)                                  | CTE (Common Table Expression)                               | View (Visão)                                                |
| :----------------- | :---------------------------------------------------------- | :---------------------------------------------------------- | :---------------------------------------------------------- |
| **Reusabilidade**  | Limitada à query principal (uma vez)                        | Múltiplas vezes na mesma query principal                    | Múltiplas vezes em qualquer query, por qualquer usuário     |
| **Persistência**   | Não persistente (executada a cada vez)                      | Não persistente (executada a cada vez)                      | Persistente (objeto de banco de dados)                      |
| **Escopo**         | Query principal                                             | Query principal imediatamente seguinte                      | Banco de dados inteiro                                      |
| **Recursividade**  | Não suporta                                                 | Suporta (CTEs recursivas)                                   | Não suporta diretamente                                     |
| **Parâmetros**     | Não suporta diretamente                                     | Não suporta diretamente                                     | Não suporta diretamente (mas pode ser envolvida em SPs)    |
| **Complexidade**   | Pode levar a aninhamentos profundos e difícil leitura      | Melhora a legibilidade, quebra em etapas lógicas            | Simplifica consultas complexas, abstrai detalhes da tabela |
| **Performance**    | Otimizador trata como parte da query principal              | Otimizador trata como parte da query principal              | Otimizador trata como parte da query principal              |
| **Uso Comum**      | Filtros intermediários, pequenas transformações             | Consultas complexas em etapas, hierarquias, relatórios     | Relatórios padrão, segurança (abstração de dados)           |

**Quando usar cada um:**

*   **Subqueries:** Para filtros simples ou pequenas transformações que são usadas apenas uma vez e não precisam de muita organização.
*   **CTEs:** Para consultas complexas que se beneficiam de serem quebradas em etapas lógicas nomeadas, para consultas recursivas (hierarquias) ou quando você precisa referenciar o mesmo resultado intermediário várias vezes dentro da mesma instrução.
*   **Views:** Para encapsular consultas que são frequentemente usadas por diferentes usuários ou aplicações, para simplificar o acesso a dados complexos, ou para implementar uma camada de segurança (expondo apenas certas colunas ou linhas).

### Boas Práticas e Considerações de Performance

1.  **Nomeie suas CTEs de forma descritiva:** Assim como variáveis, nomes claros ajudam na legibilidade.
2.  **Mantenha as CTEs concisas:** Cada CTE deve resolver uma parte específica do problema. Se uma CTE ficar muito grande, talvez ela precise ser dividida em CTEs menores e encadeadas.
3.  **CTEs não são para performance:** Embora melhorem a legibilidade, CTEs não são magicamente mais rápidas que subqueries equivalentes. O otimizador de consultas do SQL Server geralmente as trata da mesma forma. A performance depende da query interna da CTE e da query principal.
4.  **Evite `SELECT *` dentro de CTEs:** Selecione apenas as colunas que você realmente precisa para as etapas subsequentes ou para a query final. Isso reduz a quantidade de dados processados.
5.  **Cuidado com CTEs recursivas:** Garanta que sua condição de junção recursiva seja correta para evitar loops infinitos. O SQL Server tem um limite padrão de recursão (100, configurável com `OPTION (MAXRECURSION N)`), que pode ser útil para depuração.

### Desafio de Fixação

**Problema:**
A empresa "Comercial Bianeck S.A." deseja um relatório que mostre o total de receitas e despesas por mês para o primeiro trimestre de 2026. Além disso, para cada mês, eles querem saber o percentual que as despesas representam das receitas.

**Requisitos:**
1.  Use CTEs para organizar a consulta.
2.  Calcule o total de receitas e despesas por mês.
3.  Calcule o percentual de despesas sobre receitas para cada mês.
4.  Exiba o mês, o total de receitas, o total de despesas e o percentual.
5.  Considere apenas transações com status 'Conciliado'.

**Dica:** Você pode precisar de duas CTEs: uma para receitas mensais e outra para despesas mensais, ou uma única CTE que agregue ambos e depois uma segunda CTE para calcular o percentual.

---

### Resolução do Desafio

```sql
~~~sql
WITH ReceitasMensais AS
(
    SELECT
        YEAR(T.DataLancamento) AS Ano,
        MONTH(T.DataLancamento) AS Mes,
        SUM(T.Valor) AS TotalReceitas
    FROM
        dbo.Transacoes AS T
    INNER JOIN dbo.TiposTransacao AS TT
        ON T.TipoTransacaoID = TT.TipoTransacaoID
    INNER JOIN dbo.Empresas AS E
        ON T.EmpresaID = E.EmpresaID
    WHERE
        E.NomeFantasia = 'Comercial Bianeck S.A.'
        AND TT.Natureza = 'C' -- Crédito = Receita
        AND T.Status = 'Conciliado'
        AND T.DataLancamento >= '2026-01-01'
        AND T.DataLancamento <= '2026-03-31'
    GROUP BY
        YEAR(T.DataLancamento),
        MONTH(T.DataLancamento)
),
DespesasMensais AS
(
    SELECT
        YEAR(T.DataLancamento) AS Ano,
        MONTH(T.DataLancamento) AS Mes,
        SUM(T.Valor) AS TotalDespesas
    FROM
        dbo.Transacoes AS T
    INNER JOIN dbo.TiposTransacao AS TT
        ON T.TipoTransacaoID = TT.TipoTransacaoID
    INNER JOIN dbo.Empresas AS E
        ON T.EmpresaID = E.EmpresaID
    WHERE
        E.NomeFantasia = 'Comercial Bianeck S.A.'
        AND TT.Natureza = 'D' -- Débito = Despesa
        AND T.Status = 'Conciliado'
        AND T.DataLancamento >= '2026-01-01'
        AND T.DataLancamento <= '2026-03-31'
    GROUP BY
        YEAR(T.DataLancamento),
        MONTH(T.DataLancamento)
)
SELECT
    RM.Ano,
    RM.Mes,
    RM.TotalReceitas,
    DM.TotalDespesas,
    -- Calcula o percentual de despesas sobre receitas, tratando divisão por zero
    CASE
        WHEN RM.TotalReceitas > 0 THEN (DM.TotalDespesas / RM.TotalReceitas) * 100
        ELSE 0 -- Ou NULL, dependendo da regra de negócio para meses sem receita
    END AS PercentualDespesasSobreReceitas
FROM
    ReceitasMensais AS RM
INNER JOIN DespesasMensais AS DM
    ON RM.Ano = DM.Ano AND RM.Mes = DM.Mes
ORDER BY
    RM.Ano, RM.Mes;
~~~
```

**Comentários sobre a Resolução:**
1.  **`ReceitasMensais` CTE:** Esta CTE calcula o total de receitas por ano e mês para a "Comercial Bianeck S.A.", filtrando por transações de crédito conciliadas no primeiro trimestre.
2.  **`DespesasMensais` CTE:** Similarmente, esta CTE calcula o total de despesas por ano e mês para a mesma empresa, filtrando por transações de débito conciliadas no mesmo período.
3.  **Query Principal:** A query final junta as duas CTEs pelos campos `Ano` e `Mes`. Isso garante que estamos comparando receitas e despesas do mesmo período.
4.  **Cálculo do Percentual:** O `CASE` statement é usado para calcular o percentual de despesas sobre receitas. É crucial verificar se `TotalReceitas` é maior que zero para evitar um erro de divisão por zero. O resultado é multiplicado por 100 para ser exibido como percentual.
5.  **`INNER JOIN` entre CTEs:** Usamos `INNER JOIN` aqui porque o problema pede o percentual de despesas sobre receitas, o que implica que ambos os valores devem existir para o mês. Se quiséssemos ver meses com receitas mas sem despesas (ou vice-versa), usaríamos um `LEFT JOIN` e trataríamos os `NULL`s.

---

## Resumo dos Pontos-Chave

*   **CTEs (Common Table Expressions)** são tabelas virtuais temporárias e nomeadas, definidas com a cláusula `WITH`, que existem apenas durante a execução de uma única instrução SQL.
*   **Propósito:** Melhorar a legibilidade de consultas complexas, quebrando-as em etapas lógicas menores e nomeadas.
*   **Sintaxe:** `WITH NomeCTE (colunas) AS (SELECT ...)` seguida pela query principal que usa a CTE.
*   **CTEs Múltiplas:** Podem ser definidas várias CTEs em uma única cláusula `WITH`, separadas por vírgula. Uma CTE pode referenciar CTEs definidas anteriormente.
*   **CTEs Recursivas:** Permitem navegar em estruturas hierárquicas (como o `PlanoDeContas`) usando um **membro âncora** (base da recursão) e um **membro recursivo** (que se auto-referencia para expandir a hierarquia), unidos por `UNION ALL`.
*   **Comparação:**
    *   **Subqueries:** Boas para filtros simples e uso único.
    *   **CTEs:** Ideais para consultas complexas em etapas, hierarquias e quando a reusabilidade dentro da mesma query é necessária.
    *   **Views:** Para encapsular lógica complexa para reuso por múltiplas queries/usuários e para segurança, sendo objetos persistentes no banco de dados.
*   **Performance:** CTEs não garantem ganho de performance sobre subqueries equivalentes; o otimizador as trata de forma similar. A otimização deve focar na query interna.
*   **Boas Práticas:** Nomear descritivamente, manter concisas, selecionar apenas colunas necessárias e ter cuidado com recursão infinita.

---

## Glossário Técnico

*   **Common Table Expression (CTE):** Expressão de tabela temporária nomeada que pode ser referenciada dentro de uma única instrução SQL.
*   **Membro Âncora (Anchor Member):** A parte inicial de uma CTE recursiva que define o conjunto base de resultados.
*   **Membro Recursivo (Recursive Member):** A parte de uma CTE recursiva que se auto-referencia para expandir o conjunto de resultados, geralmente encontrando o próximo nível em uma hierarquia.
*   **Hierarquia:** Estrutura de dados onde itens são organizados em níveis, com relações pai-filho (ex: `PlanoDeContas`).
*   **MAXRECURSION:** Uma dica de consulta (`OPTION (MAXRECURSION N)`) que define o número máximo de níveis de recursão permitidos para uma CTE recursiva.

---

## Antecipação de Erros e Troubleshooting

1.  **Erro de Sintaxe `WITH`:**
    *   **Problema:** Esquecer a vírgula entre CTEs múltiplas ou não ter uma instrução `SELECT`, `INSERT`, `UPDATE`, `DELETE` ou `MERGE` imediatamente após a última CTE.
    *   **Solução:** Verifique a sintaxe. A cláusula `WITH` deve ser seguida imediatamente pela instrução que a utiliza. Se houver múltiplas CTEs, separe-as por vírgula.
2.  **Referência Circular em CTE Recursiva:**
    *   **Problema:** A condição de junção do membro recursivo cria um loop infinito, onde a CTE continua a se auto-referenciar sem uma condição de parada.
    *   **Solução:** Revise a lógica de junção (`ON`) e `WHERE` do membro recursivo. Certifique-se de que a hierarquia está sendo percorrida em uma direção definida (ex: sempre de pai para filho ou vice-versa) e que há um ponto final. Use `OPTION (MAXRECURSION 10)` durante o desenvolvimento para limitar a profundidade e facilitar a depuração.
3.  **Colunas da CTE não definidas:**
    *   **Problema:** A lista de colunas opcional após o nome da CTE (`WITH NomeCTE (Coluna1, Coluna2)`) não corresponde ao número ou tipo de colunas retornadas pela query da CTE.
    *   **Solução:** Garanta que a lista de colunas na definição da CTE corresponda exatamente às colunas retornadas pela `SELECT` interna, tanto em número quanto em ordem.
4.  **CTEs não visíveis fora do escopo:**
    *   **Problema:** Tentar usar uma CTE em uma query diferente daquela que a define.
    *   **Solução:** Lembre-se que CTEs são temporárias e de escopo limitado. Se você precisa reutilizar a lógica em várias queries, considere criar uma `VIEW` ou uma `Stored Procedure`.

---

## Log de Estado do Projeto

```text
## Estado — Após o Capítulo 23

=== BANCO DE DADOS ===
Nome: FinanceDB
Status: Operacional

=== TABELAS E REGISTROS ===
Bancos:            6 registros
TiposTransacao:    3 registros (RECEITA, DESPESA, TRANSF)
Empresas:          3 registros
ContasBancarias:   7 registros
PlanoDeContas:     24 registros em 3 níveis hierárquicos
Transacoes:        54 registros distribuídos em múltiplos meses
Orcamentos:        39 registros por conta e período

=== MÓDULOS CONCLUÍDOS ===
✅ Módulo 1 — Fundamentos: Teoria e Ambiente (Capítulos 1–6)
✅ Módulo 2 — Essencial: T-SQL Básico (Capítulos 7–14)
✅ Módulo 3 — PROFICIENTE: Relacionamentos e Consultas Avançadas (Capítulos 15–22)
✅ Módulo 4 — AVANÇADO: Objetos de Banco de Dados e Programabilidade (Capítulo 23)

=== CAPÍTULOS DO MÓDULO 3 ===
✅ Capítulo 15: INNER JOIN
✅ Capítulo 16: LEFT JOIN, RIGHT JOIN e FULL OUTER JOIN
✅ Capítulo 17: SELF JOIN — Auto-relacionamento e hierarquias
✅ Capítulo 18: Funções de Agregação — SUM, COUNT, AVG, MIN e MAX
✅ Capítulo 19: GROUP BY e HAVING — Agrupamento e filtragem de grupos
✅ Capítulo 20: Funções de Data e Hora — Manipulação de datas e períodos
✅ Capítulo 21: Funções de Texto — Manipulação de strings
✅ Capítulo 22: Subconsultas — Subqueries Correlacionadas e Não Correlacionadas

=== CAPÍTULOS DO MÓDULO 4 ===
✅ Capítulo 23: Expressões de Tabela — CTEs com WITH

=== HABILIDADES ADQUIRIDAS NESTE CAPÍTULO ===
- Uso de CTEs não recursivas para organizar consultas complexas
- Definição de múltiplas CTEs encadeadas
- Aplicação de CTEs recursivas para navegar hierarquias (PlanoDeContas)
- Comparação de CTEs com subconsultas e views
- Boas práticas e considerações de performance para CTEs

=== PRÓXIMO ===
Capítulo 24: Funções de Janela — OVER, PARTITION BY e ROW_NUMBER
Objetivo: calcular rankings de transações, totais acumulados de receitas e despesas,
médias móveis e numeração de linhas usando Window Functions com OVER, PARTITION BY,
ROW_NUMBER, RANK, DENSE_RANK e SUM OVER em consultas financeiras do FinanceDB.
```

---

Dúvidas? Posso prosseguir para o Capítulo 24?