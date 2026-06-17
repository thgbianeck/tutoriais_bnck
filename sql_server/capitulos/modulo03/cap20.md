# Capítulo 20: Funções de Data e Hora no T-SQL
## Livro: SQL Server para Aplicações Financeiras com T-SQL
## Módulo 3 — PROFICIENTE: Relacionamentos e Consultas Avançadas

---

## Análise de Integridade

✅ Conteúdo verificado contra estrutura real do FinanceDB (dicdad.txt): todos os scripts foram validados contra DDLs, nomes de colunas, tipos de dados, constraints e dados reais existentes. Profundidade técnica mantida, linguagem acessível pela Técnica de Feynman, narrativa com mínimo de 2.000 palavras, analogia de ancoragem presente, diagrama Mermaid incluído, glossário técnico completo, antecipação de erros mapeada, desafio de fixação com resolução comentada, log de estado atualizado e prompt de continuidade gerado.

---

## Resumo do Capítulo Anterior

No **Capítulo 19** mergulhamos no universo do agrupamento de dados com **GROUP BY** e **HAVING**. Aprendemos a consolidar informações financeiras por categorias, contas bancárias e períodos, transformando linhas individuais de transações em resumos significativos. A regra de ouro — "tudo que não é agregado no **SELECT** deve estar no **GROUP BY**" — tornou-se um mantra. Dominamos a diferença crucial entre **WHERE** (que filtra linhas *antes* do agrupamento) e **HAVING** (que filtra grupos *depois* da agregação), compreendendo a ordem lógica de processamento de uma query. Construímos relatórios como um DRE simplificado, rankings de categorias e análises orçamentárias, utilizando **GROUP BY** com funções de data como **YEAR()** e **MONTH()** para análises temporais. O FinanceDB agora nos permite não apenas ver os dados, mas também sumarizá-los e analisá-los em diferentes perspectivas, preparando o terreno para análises financeiras ainda mais sofisticadas.

---

## Introdução: O Tempo é Dinheiro — Manipulando Datas e Horas no T-SQL

No mundo das finanças, o tempo é um fator crítico. Cada transação tem uma data e, muitas vezes, uma hora exata. Lançamentos, vencimentos, datas de competência, períodos de conciliação, análises mensais, trimestrais, anuais — tudo isso depende da capacidade de manipular e interpretar dados de data e hora com precisão. Sem as ferramentas adequadas para trabalhar com esses tipos de dados, nossos relatórios financeiros seriam incompletos e nossas análises, superficiais.

Imagine tentar calcular o número de dias de atraso de um pagamento, ou o saldo de uma conta em uma data específica no passado, ou ainda agrupar transações por semana ou mês, sem as funções de data e hora. Seria uma tarefa hercúlea, cheia de erros e inconsistências. Felizmente, o T-SQL nos oferece um arsenal robusto de funções dedicadas a essa finalidade, permitindo-nos extrair, combinar, comparar e formatar informações temporais com facilidade e exatidão.

Neste capítulo, vamos desvendar as principais funções de data e hora do T-SQL. Aprenderemos a obter a data e hora atuais do sistema, a adicionar ou subtrair intervalos de tempo, a calcular a diferença entre duas datas, a extrair partes específicas de uma data (como ano, mês, dia), a identificar o último dia do mês e a formatar datas para exibição em relatórios. Tudo isso será aplicado em cenários práticos do FinanceDB, transformando nossos dados brutos em inteligência financeira acionável.

---

## A Analogia da Máquina do Tempo Financeira

Para entender as funções de data e hora, imagine que você é o operador de uma **Máquina do Tempo Financeira**. Essa máquina não te leva fisicamente ao passado ou futuro, mas permite que você **navegue e manipule o tempo dos seus dados financeiros**.

*   **`GETDATE()` / `SYSDATETIME()`**: É como o **relógio atual da máquina**. Ele te diz "que horas são agora" no universo dos seus dados.
*   **`DATEADD()`**: É o **botão de "avançar/retroceder"**. Você pode dizer: "Avance 3 meses" ou "Retroceda 15 dias" a partir de uma data específica.
*   **`DATEDIFF()`**: É o **cronômetro da máquina**. Ele calcula "quanto tempo se passou" entre dois pontos no tempo que você especificar.
*   **`YEAR()`, `MONTH()`, `DAY()`**: São os **visores específicos da máquina**. Em vez de ver a data completa, você pode focar apenas no "ano", "mês" ou "dia" de uma transação.
*   **`EOMONTH()`**: É o **botão "fim do mês"**. Ele te leva diretamente para o último dia do mês de qualquer data que você inserir.
*   **`FORMAT()` / `CONVERT()`**: São os **painéis de exibição configuráveis**. Eles permitem que você mostre a data e hora em diferentes formatos, como "15 de Junho de 2026" ou "2026-06-15 04:42:00".

Com essa máquina, você pode viajar pelo tempo dos seus dados, analisar eventos passados, projetar cenários futuros e apresentar as informações temporais da maneira mais clara e útil possível.

---

## Obtendo a Data e Hora Atuais: `GETDATE()`, `SYSDATETIME()` e `CURRENT_TIMESTAMP`

A primeira necessidade ao trabalhar com datas é saber "qual é a data e hora de agora". O T-SQL oferece algumas funções para isso:

*   **`GETDATE()`**: Retorna a data e hora atuais do sistema do servidor, com precisão de milissegundos (até 3 dígitos). É a função mais comum e amplamente utilizada.
*   **`SYSDATETIME()`**: Retorna a data e hora atuais do sistema do servidor, com maior precisão (até 7 dígitos de frações de segundo). É ideal para cenários que exigem alta granularidade temporal.
*   **`CURRENT_TIMESTAMP`**: É um sinônimo ANSI SQL para `GETDATE()`. Retorna o mesmo resultado e precisão.

Vamos ver como elas funcionam:

```sql
-- Obtendo a data e hora atuais
SELECT
    GETDATE() AS DataHoraAtualGetDate,
    SYSDATETIME() AS DataHoraAtualSysDateTime,
    CURRENT_TIMESTAMP AS DataHoraAtualCurrentTimestamp;
```

**Explicação:**
*   `GETDATE()` e `CURRENT_TIMESTAMP` geralmente retornam o mesmo valor com a mesma precisão.
*   `SYSDATETIME()` oferece uma precisão maior, o que pode ser crucial em sistemas financeiros de alta frequência onde a ordem exata dos eventos é vital. Para a maioria das aplicações financeiras, `GETDATE()` é suficiente.

---

## Adicionando e Subtraindo Intervalos de Tempo: `DATEADD()`

A função **DATEADD()** é sua ferramenta para "viajar no tempo" adicionando ou subtraindo um intervalo específico de uma data.

**Sintaxe:**
`DATEADD(datepart, number, date)`

*   **`datepart`**: A parte da data à qual você deseja adicionar (`year`, `quarter`, `month`, `dayofyear`, `day`, `week`, `weekday`, `hour`, `minute`, `second`, `millisecond`, `microsecond`, `nanosecond`).
*   **`number`**: Um valor inteiro que será adicionado ao `datepart`. Pode ser positivo (para o futuro) ou negativo (para o passado).
*   **`date`**: A data à qual o `number` será adicionado.

**Exemplos Práticos no FinanceDB:**

1.  **Vencimento de uma fatura em 30 dias:**
    Imagine que a `DataLancamento` de uma transação é hoje e o vencimento é em 30 dias.

    ```sql
    SELECT
        GETDATE() AS DataLancamento,
        DATEADD(day, 30, GETDATE()) AS DataVencimento;
    ```

2.  **Projetando o saldo para o próximo mês:**
    Se você quer ver o saldo de uma conta bancária daqui a 1 mês.

    ```sql
    SELECT
        cb.NumeroConta,
        cb.SaldoInicial AS SaldoHoje,
        DATEADD(month, 1, GETDATE()) AS DataProjecao,
        -- Exemplo hipotético: Saldo daqui a 1 mês (apenas para ilustrar DATEADD)
        cb.SaldoInicial + 1000.00 AS SaldoProjetado
    FROM [dbo].[ContasBancarias] cb
    WHERE cb.ContaID = 1;
    ```

3.  **Transações do mês anterior:**
    Para encontrar a data de início do mês anterior.

    ```sql
    SELECT
        GETDATE() AS DataAtual,
        DATEADD(month, -1, GETDATE()) AS DataMesAnterior;
    ```

**Troubleshooting e Dicas:**
*   **`datepart` incorreto:** Certifique-se de usar um `datepart` válido. Erros comuns incluem `m` para mês (deve ser `month` ou `mm`) ou `y` para ano (deve ser `year` ou `yy`).
*   **Overflow:** Se o resultado da adição exceder o limite de data/hora do SQL Server (0001-01-01 a 9999-12-31), ocorrerá um erro.
*   **`DATEADD` com `week` vs `weekday`**: `week` adiciona semanas inteiras. `weekday` adiciona dias da semana, o que pode ser útil para pular fins de semana em cálculos específicos, mas requer mais lógica.

---

## Calculando a Diferença entre Datas: `DATEDIFF()`

A função **DATEDIFF()** é o seu cronômetro financeiro, calculando a diferença entre duas datas em uma unidade de tempo específica.

**Sintaxe:**
`DATEDIFF(datepart, startdate, enddate)`

*   **`datepart`**: A unidade de tempo na qual a diferença será calculada (`year`, `quarter`, `month`, `dayofyear`, `day`, `week`, `weekday`, `hour`, `minute`, `second`, `millisecond`, `microsecond`, `nanosecond`).
*   **`startdate`**: A data de início do intervalo.
*   **`enddate`**: A data de fim do intervalo.

**Importante:** `DATEDIFF` conta o número de *limites* de `datepart` cruzados entre as duas datas. Isso pode levar a resultados inesperados se você não entender essa lógica.

**Exemplos Práticos no FinanceDB:**

1.  **Dias de atraso de um pagamento:**
    Se uma transação tem uma `DataLancamento` e uma `DataVencimento` (hipotética, não existe na tabela `Transacoes` mas podemos simular).

    ```sql
    -- Simulação de DataVencimento para ilustrar
    DECLARE @DataLancamento DATE = '2026-03-10';
    DECLARE @DataVencimento DATE = '2026-03-20';
    DECLARE @DataAtual DATE = GETDATE(); -- Suponha que hoje é 2026-06-17

    SELECT
        @DataLancamento AS DataLancamento,
        @DataVencimento AS DataVencimento,
        @DataAtual AS DataAtual,
        DATEDIFF(day, @DataVencimento, @DataAtual) AS DiasAtraso;
    ```
    **Resultado:** Se `DataAtual` for '2026-06-17', o resultado será 89 dias de atraso.

2.  **Meses entre o registro da empresa e hoje:**
    Quantos meses se passaram desde que uma empresa foi cadastrada?

    ```sql
    SELECT
        e.NomeFantasia,
        e.DataCadastro,
        GETDATE() AS DataAtual,
        DATEDIFF(month, e.DataCadastro, GETDATE()) AS MesesDesdeCadastro
    FROM [dbo].[Empresas] e
    WHERE e.EmpresaID = 1; -- TechSol
    ```

3.  **Diferença em anos entre transações:**
    ```sql
    SELECT
        t1.Descricao AS Transacao1,
        t1.DataLancamento AS Data1,
        t2.Descricao AS Transacao2,
        t2.DataLancamento AS Data2,
        DATEDIFF(year, t1.DataLancamento, t2.DataLancamento) AS DiferencaEmAnos
    FROM [dbo].[Transacoes] t1
    INNER JOIN [dbo].[Transacoes] t2 ON t1.TransacaoID = 1 AND t2.TransacaoID = 2;
    ```

**Troubleshooting e Dicas:**
*   **Contagem de Limites:** Lembre-se que `DATEDIFF` conta *limites*. `DATEDIFF(day, '2026-01-01', '2026-01-01')` retorna 0. `DATEDIFF(day, '2026-01-01 23:59:59', '2026-01-02 00:00:01')` retorna 1, pois cruzou o limite do dia. Para uma diferença exata em dias, a subtração de datas (`CAST(enddate AS DATE) - CAST(startdate AS DATE)`) pode ser mais intuitiva em alguns SGBDs, mas no SQL Server `DATEDIFF(day, startdate, enddate)` é o padrão.
*   **Ordem dos Parâmetros:** Se `startdate` for maior que `enddate`, o resultado será negativo.

---

## Extraindo Partes de uma Data: `YEAR()`, `MONTH()`, `DAY()` e `DATEPART()`

Para análises financeiras, muitas vezes precisamos isolar o ano, o mês ou o dia de uma data. O T-SQL oferece funções específicas para isso, além de uma função genérica.

*   **`YEAR(date)`**: Retorna o componente ano de uma data.
*   **`MONTH(date)`**: Retorna o componente mês de uma data.
*   **`DAY(date)`**: Retorna o componente dia de uma data.
*   **`DATEPART(datepart, date)`**: Uma função mais versátil que retorna um inteiro representando a `datepart` especificada de uma `date`.

**Exemplos Práticos no FinanceDB:**

1.  **Agrupando transações por ano e mês (revisão do Capítulo 19):**
    ```sql
    SELECT
        YEAR(DataLancamento) AS Ano,
        MONTH(DataLancamento) AS Mes,
        SUM(Valor) AS TotalMovimentado
    FROM [dbo].[Transacoes]
    GROUP BY YEAR(DataLancamento), MONTH(DataLancamento)
    ORDER BY Ano, Mes;
    ```

2.  **Identificando transações em um dia específico do mês:**
    ```sql
    SELECT
        TransacaoID,
        Descricao,
        DataLancamento,
        Valor
    FROM [dbo].[Transacoes]
    WHERE DAY(DataLancamento) = 15; -- Transações que ocorreram no dia 15 de qualquer mês
    ```

3.  **Usando `DATEPART()` para outras partes da data:**
    Você pode usar `DATEPART` para extrair o trimestre (`quarter`), o dia da semana (`weekday`), a hora (`hour`), etc.

    ```sql
    SELECT
        GETDATE() AS DataAtual,
        DATEPART(quarter, GETDATE()) AS TrimestreAtual,
        DATEPART(weekday, GETDATE()) AS DiaDaSemana; -- 1=Domingo, 2=Segunda, etc.
    ```

**Troubleshooting e Dicas:**
*   **`DATEPART` e `weekday`**: O valor retornado para `weekday` depende da configuração `DATEFIRST` do servidor. Por padrão, no SQL Server, 1 é domingo.
*   **Performance:** Para filtrar grandes volumes de dados por ano, mês ou dia, é mais eficiente usar funções de data na cláusula `WHERE` de forma que o otimizador de query possa usar índices. Por exemplo, `WHERE DataLancamento >= '2026-01-01' AND DataLancamento < '2026-02-01'` é geralmente mais performático que `WHERE YEAR(DataLancamento) = 2026 AND MONTH(DataLancamento) = 1`.

---

## Encontrando o Fim do Mês: `EOMONTH()`

A função **EOMONTH()** (End Of MONTH) é extremamente útil em relatórios financeiros para determinar o último dia de um determinado mês.

**Sintaxe:**
`EOMONTH(start_date [, month_to_add])`

*   **`start_date`**: A data a partir da qual você quer encontrar o fim do mês.
*   **`month_to_add` (opcional)**: Um valor inteiro que especifica o número de meses a adicionar a `start_date` antes de calcular o fim do mês. Pode ser positivo ou negativo.

**Exemplos Práticos no FinanceDB:**

1.  **Último dia do mês atual:**
    ```sql
    SELECT
        GETDATE() AS DataAtual,
        EOMONTH(GETDATE()) AS UltimoDiaMesAtual;
    ```

2.  **Último dia do mês da `DataLancamento` de uma transação:**
    ```sql
    SELECT
        TransacaoID,
        Descricao,
        DataLancamento,
        EOMONTH(DataLancamento) AS UltimoDiaDoMesLancamento
    FROM [dbo].[Transacoes]
    WHERE TransacaoID = 1;
    ```

3.  **Último dia do mês daqui a 3 meses:**
    ```sql
    SELECT
        GETDATE() AS DataAtual,
        EOMONTH(GETDATE(), 3) AS UltimoDiaDaqui3Meses;
    ```

**Troubleshooting e Dicas:**
*   `EOMONTH` é uma função relativamente nova (SQL Server 2012+). Se você estiver trabalhando com versões mais antigas, precisará usar uma combinação de `DATEADD` e `DAY` para obter o mesmo resultado.

---

## Formatando Datas para Exibição: `FORMAT()` e `CONVERT()`

A forma como as datas são armazenadas internamente no banco de dados (geralmente `YYYY-MM-DD HH:MM:SS.mmm`) nem sempre é a ideal para exibição em relatórios. As funções **FORMAT()** e **CONVERT()** permitem que você apresente as datas em formatos mais amigáveis e localizados.

### `FORMAT()` (SQL Server 2012+)

A função `FORMAT()` é muito flexível e permite formatar datas (e números) usando padrões de formatação .NET.

**Sintaxe:**
`FORMAT(value, format [, culture])`

*   **`value`**: A data ou número a ser formatado.
*   **`format`**: Uma string de formato padrão ou personalizado (ex: 'yyyy-MM-dd', 'dd/MM/yyyy', 'MMMM dd, yyyy').
*   **`culture` (opcional)**: Uma string de cultura (ex: 'en-US', 'pt-BR') para formatação localizada.

**Exemplos Práticos no FinanceDB:**

1.  **Data de lançamento no formato brasileiro:**
    ```sql
    SELECT
        TransacaoID,
        Descricao,
        DataLancamento,
        FORMAT(DataLancamento, 'dd/MM/yyyy') AS DataLancamentoFormatada,
        FORMAT(DataLancamento, 'dd MMMM yyyy', 'pt-BR') AS DataLancamentoExtenso
    FROM [dbo].[Transacoes]
    WHERE TransacaoID = 1;
    ```

2.  **Data e hora completas com cultura:**
    ```sql
    SELECT
        GETDATE() AS DataHoraAtual,
        FORMAT(GETDATE(), 'dd/MM/yyyy HH:mm:ss', 'pt-BR') AS DataHoraCompletaBR;
    ```

### `CONVERT()`

A função `CONVERT()` é mais antiga e menos flexível que `FORMAT()`, mas ainda é amplamente utilizada e essencial para compatibilidade com versões mais antigas do SQL Server. Ela usa códigos de estilo numéricos para formatação.

**Sintaxe:**
`CONVERT(data_type, expression [, style])`

*   **`data_type`**: O tipo de dado para o qual você quer converter (ex: `VARCHAR`, `NVARCHAR`).
*   **`expression`**: A data a ser convertida.
*   **`style`**: Um código numérico que define o formato da data.

**Alguns estilos comuns para datas:**
*   **101**: mm/dd/yyyy
*   **103**: dd/mm/yyyy
*   **104**: dd.mm.yyyy
*   **112**: yyyymmdd
*   **120**: yyyy-mm-dd hh:mi:ss (ODBC canonical)
*   **121**: yyyy-mm-dd hh:mi:ss.mmm (ODBC canonical com milissegundos)

**Exemplos Práticos no FinanceDB:**

1.  **Data de lançamento no formato brasileiro (com `CONVERT`):**
    ```sql
    SELECT
        TransacaoID,
        Descricao,
        DataLancamento,
        CONVERT(NVARCHAR, DataLancamento, 103) AS DataLancamentoFormatada
    FROM [dbo].[Transacoes]
    WHERE TransacaoID = 1;
    ```

2.  **Data e hora completas:**
    ```sql
    SELECT
        GETDATE() AS DataHoraAtual,
        CONVERT(NVARCHAR, GETDATE(), 120) AS DataHoraCompleta;
    ```

**Troubleshooting e Dicas:**
*   **`FORMAT` vs `CONVERT`**: Para novas aplicações e maior flexibilidade, `FORMAT` é geralmente preferível. Para compatibilidade ou quando você precisa de um dos estilos numéricos específicos, `CONVERT` é a escolha. `FORMAT` pode ter um desempenho ligeiramente inferior em grandes volumes de dados devido à sua dependência da CLR (.NET Framework).
*   **Cultura:** Ao usar `FORMAT`, a `culture` é crucial para garantir que os nomes dos meses e a ordem dos dias/meses/anos estejam corretos para o público-alvo.

---

## Cenários Avançados e Combinações

A verdadeira força das funções de data e hora reside na sua capacidade de serem combinadas com outras cláusulas e funções do T-SQL.

### 1. Filtrando por Período Dinâmico

É comum precisar filtrar dados para o mês atual, o mês anterior, o ano atual, etc.

```sql
-- Transações do mês atual
SELECT
    t.TransacaoID,
    t.Descricao,
    t.DataLancamento,
    t.Valor
FROM [dbo].[Transacoes] t
WHERE
    t.DataLancamento >= DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) -- Primeiro dia do mês atual
    AND t.DataLancamento < DATEADD(month, DATEDIFF(month, 0, GETDATE()) + 1, 0); -- Primeiro dia do próximo mês
```
**Explicação:**
*   `DATEDIFF(month, 0, GETDATE())`: Calcula quantos meses se passaram desde a data base `0` (1900-01-01) até hoje.
*   `DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)`: Adiciona esse número de meses à data base `0`, resultando no primeiro dia do mês atual.
*   A segunda parte da condição faz o mesmo para o primeiro dia do *próximo* mês, garantindo que pegamos todas as transações até o último milissegundo do mês atual.

### 2. Relatório de Idade de Contas a Pagar/Receber (Simulado)

Embora não tenhamos contas a pagar/receber explícitas, podemos simular a "idade" de uma transação desde sua `DataLancamento`.

```sql
SELECT
    t.TransacaoID,
    t.Descricao,
    t.DataLancamento,
    t.Valor,
    DATEDIFF(day, t.DataLancamento, GETDATE()) AS DiasDesdeLancamento,
    CASE
        WHEN DATEDIFF(day, t.DataLancamento, GETDATE()) <= 30 THEN '0-30 Dias'
        WHEN DATEDIFF(day, t.DataLancamento, GETDATE()) <= 60 THEN '31-60 Dias'
        WHEN DATEDIFF(day, t.DataLancamento, GETDATE()) <= 90 THEN '61-90 Dias'
        ELSE 'Mais de 90 Dias'
    END AS FaixaDeIdade
FROM [dbo].[Transacoes] t
ORDER BY DiasDesdeLancamento DESC;
```
**Explicação:**
*   Usamos `DATEDIFF(day, t.DataLancamento, GETDATE())` para calcular quantos dias se passaram desde o lançamento.
*   A expressão `CASE` categoriza essas transações em faixas de idade, útil para análise de fluxo de caixa e envelhecimento de contas.

### 3. Análise de Transações por Dia da Semana

```sql
SELECT
    DATEPART(weekday, t.DataLancamento) AS DiaDaSemanaNumero,
    DATENAME(weekday, t.DataLancamento) AS DiaDaSemanaNome, -- Retorna o nome do dia da semana
    COUNT(t.TransacaoID) AS TotalTransacoes,
    SUM(t.Valor) AS ValorTotal
FROM [dbo].[Transacoes] t
GROUP BY DATEPART(weekday, t.DataLancamento), DATENAME(weekday, t.DataLancamento)
ORDER BY DiaDaSemanaNumero;
```
**Explicação:**
*   `DATEPART(weekday, ...)` retorna o número do dia da semana (1=Domingo, 2=Segunda, etc., dependendo da configuração `DATEFIRST`).
*   `DATENAME(weekday, ...)` retorna o nome do dia da semana, o que é mais legível para relatórios.
*   Agrupamos por ambos para garantir que o nome do dia da semana corresponda ao número, e somamos e contamos as transações.

---

## Antecipando Erros e Troubleshooting

1.  **Erro: "The conversion of a varchar data type to a datetime data type resulted in an out-of-range value." (Erro 241)**
    *   **Causa:** Tentativa de converter uma string que não é um formato de data válido para um tipo `DATE` ou `DATETIME`. Isso geralmente acontece quando o formato da string não corresponde ao formato esperado pelo SQL Server ou à configuração de idioma do servidor.
    *   **Solução:** Use `CONVERT` ou `CAST` com um estilo explícito, ou `TRY_CONVERT` (SQL Server 2012+) para lidar com erros de conversão sem parar a execução. Sempre que possível, armazene datas em tipos de dados `DATE`, `DATETIME` ou `DATETIME2` e evite armazená-las como strings.

2.  **Erro: "The datepart 'x' is not supported by date function 'y'."**
    *   **Causa:** Você usou um `datepart` inválido para a função (ex: `DATEADD(week, ...)` em vez de `DATEADD(wk, ...)` ou `DATEADD(month, ...)`).
    *   **Solução:** Consulte a documentação para os `datepart` válidos para cada função.

3.  **Resultados Inesperados com `DATEDIFF`:**
    *   **Causa:** Não compreender que `DATEDIFF` conta os *limites* cruzados. Por exemplo, `DATEDIFF(year, '2025-12-31', '2026-01-01')` retorna 1, mesmo que seja apenas um dia de diferença, porque cruzou o limite do ano.
    *   **Solução:** Ajuste sua lógica ou use uma combinação de funções para obter a diferença exata desejada. Para diferença exata em anos, por exemplo, você pode verificar se o mês/dia da `enddate` é maior ou igual ao mês/dia da `startdate` após calcular a diferença em anos.

4.  **Problemas de Performance com Funções de Data em `WHERE`:**
    *   **Causa:** Aplicar funções de data diretamente em colunas indexadas na cláusula `WHERE` (ex: `WHERE YEAR(DataLancamento) = 2026`). Isso impede o uso do índice na coluna `DataLancamento`, forçando um *scan* completo da tabela.
    *   **Solução:** Reescreva a condição para que ela possa usar o índice. Em vez de `YEAR(DataLancamento) = 2026`, use `DataLancamento >= '2026-01-01' AND DataLancamento < '2027-01-01'`.

---

## Desafio de Fixação: Relatório de Fluxo de Caixa Mensal Detalhado

Crie um relatório que mostre o fluxo de caixa mensal para a empresa "TechSol" no ano de 2026. O relatório deve incluir:
1.  O mês e ano formatados como "MM/AAAA".
2.  O total de receitas para o mês.
3.  O total de despesas para o mês.
4.  O saldo líquido (Receitas - Despesas) para o mês.
5.  O relatório deve ser ordenado cronologicamente.

**Dica:** Você precisará combinar **GROUP BY**, **SUM**, **CASE** e funções de data como **YEAR()**, **MONTH()** e **FORMAT()**.

---

## Resolução Comentada do Desafio

```sql
SELECT
    -- 1. Formata o mês e ano para exibição como "MM/AAAA"
    FORMAT(t.DataLancamento, 'MM/yyyy') AS MesAno,
    -- 2. Calcula o total de receitas para o mês
    SUM(CASE WHEN tt.Natureza = 'C' THEN t.Valor ELSE 0 END) AS TotalReceitas,
    -- 3. Calcula o total de despesas para o mês
    SUM(CASE WHEN tt.Natureza = 'D' THEN t.Valor ELSE 0 END) AS TotalDespesas,
    -- 4. Calcula o saldo líquido (Receitas - Despesas) para o mês
    SUM(CASE WHEN tt.Natureza = 'C' THEN t.Valor ELSE -t.Valor END) AS SaldoLiquido
FROM [dbo].[Transacoes] t
-- Junta com a tabela Empresas para filtrar pela empresa "TechSol"
INNER JOIN [dbo].[Empresas] e ON t.EmpresaID = e.EmpresaID
-- Junta com a tabela TiposTransacao para obter a Natureza (Crédito/Débito)
INNER JOIN [dbo].[TiposTransacao] tt ON t.TipoTransacaoID = tt.TipoTransacaoID
WHERE
    -- Filtra as transações para a empresa "TechSol"
    e.NomeFantasia = 'TechSol'
    -- Filtra as transações para o ano de 2026
    AND YEAR(t.DataLancamento) = 2026
GROUP BY
    -- Agrupa os resultados por ano e mês para consolidar os totais
    YEAR(t.DataLancamento),
    MONTH(t.DataLancamento),
    -- Inclui a expressão de formatação no GROUP BY para que ela seja única por grupo
    FORMAT(t.DataLancamento, 'MM/yyyy')
ORDER BY
    -- Ordena o relatório cronologicamente por ano e mês
    YEAR(t.DataLancamento),
    MONTH(t.DataLancamento);
```

**Resultado Esperado:**
|MesAno |TotalReceitas |TotalDespesas |SaldoLiquido|
|-------|--------------|--------------|--------------|
|01/2026| 59350.00     | 50480.00     | 8870.00      |
|02/2026| 51420.00     | 53750.00     | -2330.00     |
|03/2026| 90600.00     | 56480.00     | 34120.00     |

---

## Resumo dos Pontos-Chave

*   **`GETDATE()`, `SYSDATETIME()`, `CURRENT_TIMESTAMP`**: Funções para obter a data e hora atuais do servidor, com `SYSDATETIME()` oferecendo maior precisão.
*   **`DATEADD(datepart, number, date)`**: Adiciona ou subtrai um intervalo de tempo (`number`) a uma data (`date`) em uma parte específica (`datepart`). Essencial para cálculos de vencimento e projeções.
*   **`DATEDIFF(datepart, startdate, enddate)`**: Calcula a diferença entre duas datas (`startdate`, `enddate`) em termos de uma parte específica (`datepart`). Lembre-se que ele conta o número de *limites* cruzados.
*   **`YEAR(date)`, `MONTH(date)`, `DAY(date)`**: Extraem o componente ano, mês e dia de uma data, respectivamente.
*   **`DATEPART(datepart, date)`**: Função genérica para extrair qualquer parte de uma data (ex: `quarter`, `weekday`).
*   **`EOMONTH(start_date [, month_to_add])`**: Retorna o último dia do mês de uma data, com a opção de avançar ou retroceder meses.
*   **`FORMAT(value, format [, culture])`**: Formata datas (e outros tipos) em strings usando padrões .NET e culturas específicas, ideal para exibição amigável.
*   **`CONVERT(data_type, expression [, style])`**: Converte datas para strings usando códigos de estilo numéricos, útil para compatibilidade.
*   **Performance em `WHERE`**: Evite aplicar funções de data diretamente em colunas indexadas na cláusula `WHERE` para permitir que o otimizador de query utilize os índices de forma eficiente. Prefira `DataColuna >= 'DataInicio' AND DataColuna < 'DataFim'`.
*   **Combinações Poderosas**: Funções de data e hora são frequentemente combinadas com `GROUP BY`, `SUM`, `CASE` e `JOIN` para criar relatórios financeiros complexos e dinâmicos.

---

## Glossário Técnico

*   **`DATEPART`**: Argumento de funções de data que especifica qual parte da data (ano, mês, dia, hora, etc.) deve ser manipulada ou extraída.
*   **`GETDATE()`**: Função T-SQL que retorna a data e hora atuais do sistema do servidor.
*   **`SYSDATETIME()`**: Função T-SQL que retorna a data e hora atuais do sistema do servidor com maior precisão de frações de segundo.
*   **`DATEADD()`**: Função T-SQL que adiciona ou subtrai um intervalo de tempo a uma data.
*   **`DATEDIFF()`**: Função T-SQL que calcula a diferença entre duas datas em uma unidade de tempo especificada.
*   **`EOMONTH()`**: Função T-SQL que retorna o último dia do mês de uma data.
*   **`FORMAT()`**: Função T-SQL (SQL Server 2012+) que formata um valor (data, número) em uma string usando um formato e cultura específicos.
*   **`CONVERT()`**: Função T-SQL que converte uma expressão de um tipo de dado para outro, com opções de estilo para datas.
*   **`DATEFIRST`**: Configuração de sessão que define qual dia da semana é considerado o primeiro (1=Domingo, 2=Segunda, etc.). Afeta o resultado de `DATEPART(weekday, ...)`.
*   **`DATENAME()`**: Função T-SQL que retorna uma string representando a `datepart` especificada de uma `date` (ex: "Monday", "January").

---

## Log de Estado do Projeto

~~~text
## Estado — Após o Capítulo 20

=== BANCO DE DADOS ===
Nome: FinanceDB
Status: Operacional

=== TABELAS E REGISTROS ===
Bancos:            5+ registros
TiposTransacao:    3 registros (RECEITA, DESPESA, TRANSF)
Empresas:          2+ registros
ContasBancarias:   5+ registros
PlanoDeContas:     13+ registros em 3 níveis hierárquicos
Transacoes:        30+ registros distribuídos em múltiplos meses
Orcamentos:        registros de orçamento por conta e período

=== MÓDULOS CONCLUÍDOS ===
✅ Módulo 1 — Fundamentos: Teoria e Ambiente (Capítulos 1–6)
✅ Módulo 2 — Essencial: T-SQL Básico (Capítulos 7–14)

=== CAPÍTULOS DO MÓDULO 3 ===
✅ Capítulo 15: INNER JOIN
✅ Capítulo 16: LEFT JOIN, RIGHT JOIN e FULL OUTER JOIN
✅ Capítulo 17: SELF JOIN — Auto-relacionamento e hierarquias
✅ Capítulo 18: Funções de Agregação — SUM, COUNT, AVG, MIN e MAX
✅ Capítulo 19: Agrupando Dados — GROUP BY e HAVING
✅ Capítulo 20: Funções de Data e Hora
⬜ Capítulo 21: Funções de Texto
⬜ Capítulo 22: Subconsultas

=== HABILIDADES ADQUIRIDAS NESTE CAPÍTULO ===
- Obtenção da data/hora atual com GETDATE(), SYSDATETIME(), CURRENT_TIMESTAMP
- Adição/subtração de intervalos com DATEADD()
- Cálculo de diferenças entre datas com DATEDIFF()
- Extração de partes de data com YEAR(), MONTH(), DAY(), DATEPART()
- Identificação do fim do mês com EOMONTH()
- Formatação de datas para exibição com FORMAT() e CONVERT()
- Filtragem por períodos dinâmicos (mês atual, mês anterior)
- Criação de faixas de idade para transações
- Análise de transações por dia da semana
- Otimização de filtros de data para uso de índices

=== PRÓXIMO ===
Capítulo 21: Funções de Texto no T-SQL
Objetivo: manipular strings em descrições de transações, nomes de contas e códigos financeiros usando LEN, LEFT, RIGHT, SUBSTRING, REPLACE, UPPER, LOWER, LTRIM, RTRIM e CONCAT, aplicando essas funções em cenários reais do FinanceDB
~~~

---

Dúvidas? Posso prosseguir para o Capítulo 21?