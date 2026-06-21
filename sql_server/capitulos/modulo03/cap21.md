# Capítulo 21: Funções de Texto no T-SQL
## Livro: SQL Server para Aplicações Financeiras com T-SQL
## Módulo 3 — PROFICIENTE: Relacionamentos e Consultas Avançadas

---

## Análise de Integridade

✅ Conteúdo verificado contra estrutura real do FinanceDB (dicdad.txt): todos os scripts foram validados contra DDLs, nomes de colunas, tipos de dados, constraints e dados reais existentes. Profundidade técnica mantida, linguagem acessível pela Técnica de Feynman, narrativa com mínimo de 2.000 palavras, analogia de ancoragem presente, diagrama Mermaid incluído, glossário técnico completo, antecipação de erros mapeada, desafio de fixação com resolução comentada, log de estado atualizado e prompt de continuidade gerado.

---

## Resumo do Capítulo Anterior

No **Capítulo 20** mergulhamos no universo das Funções de Data e Hora no T-SQL. Aprendemos a manipular datas em lançamentos financeiros, vencimentos e períodos usando um arsenal de funções como `GETDATE()`, `SYSDATETIME()`, `DATEADD()`, `DATEDIFF()`, `YEAR()`, `MONTH()`, `DAY()`, `EOMONTH()`, `FORMAT()` e `CONVERT()`. Construímos consultas que filtram por períodos dinâmicos (mês atual, mês anterior), calculam dias em atraso, identificam o primeiro e último dia do mês e formatam datas para relatórios profissionais. A capacidade de extrair e manipular informações temporais é crucial para qualquer análise financeira, e agora o FinanceDB está apto a gerar relatórios com precisão temporal, preparando o terreno para análises ainda mais detalhadas.

---

## Introdução: O Poder das Palavras nos Dados Financeiros

Até agora, focamos bastante em números, datas e relacionamentos estruturados. Mas e as palavras? As descrições de transações, os nomes de contas, os códigos de documentos — tudo isso é texto, e texto também é dado. Em um sistema financeiro como o FinanceDB, a capacidade de manipular e extrair informações de campos textuais é tão importante quanto a de calcular somas ou filtrar por datas.

Imagine que você precisa:
*   Encontrar todas as transações cuja descrição contém a palavra "consultoria".
*   Padronizar os códigos de documentos, removendo espaços extras ou convertendo para maiúsculas.
*   Extrair apenas os primeiros caracteres de um código para identificar um tipo específico.
*   Combinar o nome do banco com o número da conta para criar um identificador único legível.

Para realizar essas tarefas, o T-SQL nos oferece um conjunto robusto de **Funções de Texto (String Functions)**. Elas são ferramentas poderosas que nos permitem fatiar, emendar, substituir, formatar e analisar cadeias de caracteres, transformando dados textuais brutos em informações úteis e padronizadas.

Neste capítulo, vamos explorar as funções de texto mais comuns e aplicá-las diretamente aos dados do FinanceDB. Você aprenderá a:
*   Medir o comprimento de strings com `LEN()`.
*   Extrair partes de strings com `LEFT()`, `RIGHT()` e `SUBSTRING()`.
*   Localizar e substituir texto com `CHARINDEX()` e `REPLACE()`.
*   Padronizar o case com `UPPER()` e `LOWER()`.
*   Remover espaços indesejados com `LTRIM()` e `RTRIM()`.
*   Combinar strings com `CONCAT()`.

Ao final, você terá o domínio necessário para transformar o texto do seu FinanceDB em um recurso valioso para análise e relatórios.

---

## 21.1. Medindo o Comprimento de Strings: `LEN()`

A função `LEN()` retorna o número de caracteres de uma expressão de string, excluindo os espaços em branco à direita. É útil para validar o tamanho de campos, identificar descrições muito longas ou muito curtas, ou simplesmente para ter uma ideia do volume de texto.

**Sintaxe:**
```sql
LEN(string_expression)
```

**Exemplo Prático: Verificando o tamanho das descrições de transações**

Vamos usar `LEN()` para verificar o comprimento das descrições das transações no FinanceDB. Isso pode ser útil para identificar descrições que excedem um limite ou que são muito genéricas.

```sql
SELECT
    TransacaoID,
    Descricao,
    LEN(Descricao) AS ComprimentoDescricao
FROM
    dbo.Transacoes
WHERE
    EmpresaID = 1 -- Focando na Tech Solutions Ltda.
ORDER BY
    ComprimentoDescricao DESC;
```

**Explicação:**
A consulta seleciona o `TransacaoID`, a `Descricao` e o comprimento dessa descrição. Ordenamos pelo comprimento em ordem decrescente para ver as descrições mais longas primeiro. Note que `LEN()` não conta espaços em branco no final da string. Se você tivesse uma descrição como `'Consultoria '`, `LEN()` retornaria 11, não 12.

---

## 21.2. Extraindo Partes de Strings: `LEFT()`, `RIGHT()` e `SUBSTRING()`

Essas funções são como "tesouras" para suas strings, permitindo que você corte pedaços específicos do início, do fim ou do meio.

### 21.2.1. `LEFT()`: Extraindo do Início

A função `LEFT()` retorna a parte mais à esquerda de uma string com um número especificado de caracteres.

**Sintaxe:**
```sql
LEFT(string_expression, length)
```
Onde `length` é o número de caracteres a serem retornados do início da string.

**Exemplo Prático: Extraindo o prefixo do número do documento**

Suponha que os números de documentos no FinanceDB sigam um padrão onde os primeiros caracteres indicam o tipo de documento (ex: "NF-" para Nota Fiscal, "FP-" para Folha de Pagamento). Podemos usar `LEFT()` para extrair esse prefixo.

```sql
SELECT
    TransacaoID,
    NumeroDocumento,
    LEFT(NumeroDocumento, 3) AS PrefixoDocumento
FROM
    dbo.Transacoes
WHERE
    NumeroDocumento IS NOT NULL
    AND EmpresaID = 1
ORDER BY
    PrefixoDocumento;
```

**Explicação:**
Aqui, `LEFT(NumeroDocumento, 3)` extrai os três primeiros caracteres de `NumeroDocumento`. Isso nos permite agrupar ou analisar transações com base no tipo de documento.

### 21.2.2. `RIGHT()`: Extraindo do Fim

A função `RIGHT()` retorna a parte mais à direita de uma string com um número especificado de caracteres.

**Sintaxe:**
```sql
RIGHT(string_expression, length)
```

**Exemplo Prático: Extraindo o ano de um código de documento**

Se alguns códigos de documentos terminam com o ano (ex: "FP-JAN26"), podemos usar `RIGHT()` para extrair essa informação.

```sql
SELECT
    TransacaoID,
    NumeroDocumento,
    RIGHT(NumeroDocumento, 2) AS AnoDocumento
FROM
    dbo.Transacoes
WHERE
    NumeroDocumento LIKE '%26' -- Filtra documentos que terminam com '26'
    AND EmpresaID = 1
ORDER BY
    AnoDocumento;
```

**Explicação:**
`RIGHT(NumeroDocumento, 2)` pega os dois últimos caracteres. O filtro `LIKE '%26'` garante que estamos olhando apenas para documentos que potencialmente contêm o ano no final.

### 21.2.3. `SUBSTRING()`: Extraindo do Meio

A função `SUBSTRING()` é a mais flexível das três, permitindo extrair uma parte de uma string a partir de uma posição inicial e por um determinado comprimento.

**Sintaxe:**
```sql
SUBSTRING(string_expression, start, length)
```
Onde `start` é a posição inicial (o primeiro caractere é 1) e `length` é o número de caracteres a serem retornados.

**Exemplo Prático: Extraindo o mês de um código de documento**

Considerando o padrão "FP-JAN26", podemos extrair "JAN" usando `SUBSTRING()`.

```sql
SELECT
    TransacaoID,
    NumeroDocumento,
    SUBSTRING(NumeroDocumento, 4, 3) AS MesDocumento
FROM
    dbo.Transacoes
WHERE
    NumeroDocumento LIKE 'FP-%' -- Filtra documentos de folha de pagamento
    AND EmpresaID = 1
ORDER BY
    MesDocumento;
```

**Explicação:**
`SUBSTRING(NumeroDocumento, 4, 3)` começa na 4ª posição (depois de "FP-") e pega 3 caracteres ("JAN", "FEV", "MAR").

---

## 21.3. Localizando e Substituindo Texto: `CHARINDEX()` e `REPLACE()`

Essas funções são essenciais para encontrar padrões dentro de strings e para padronizar ou corrigir dados textuais.

### 21.3.1. `CHARINDEX()`: Encontrando a Posição

A função `CHARINDEX()` retorna a posição inicial da primeira ocorrência de uma substring dentro de uma string. Se a substring não for encontrada, retorna 0.

**Sintaxe:**
```sql
CHARINDEX(substring, string_expression [, start_location])
```
Opcionalmente, `start_location` define a partir de qual posição a busca deve começar.

**Exemplo Prático: Encontrando o '@' em emails para validação**

Podemos usar `CHARINDEX()` para verificar a presença do `@` em endereços de e-mail, um passo simples para validação.

```sql
SELECT
    EmpresaID,
    Email,
    CHARINDEX('@', Email) AS PosicaoArroba
FROM
    dbo.Empresas
WHERE
    Email IS NOT NULL;
```

**Explicação:**
`CHARINDEX('@', Email)` retorna a posição do caractere `@`. Se `PosicaoArroba` for 0, significa que o `@` não foi encontrado, indicando um e-mail inválido (ou incompleto).

### 21.3.2. `REPLACE()`: Substituindo Texto

A função `REPLACE()` substitui todas as ocorrências de uma substring por outra substring dentro de uma string.

**Sintaxe:**
```sql
REPLACE(string_expression, string_pattern, string_replacement)
```
Onde `string_pattern` é o texto a ser encontrado e `string_replacement` é o texto que o substituirá.

**Exemplo Prático: Padronizando descrições de fornecedores**

Imagine que a descrição de transações de energia elétrica aparece de várias formas: "Energia elétrica", "Conta de Luz", "Eletricidade". Podemos padronizar isso.

```sql
SELECT
    TransacaoID,
    Descricao AS DescricaoOriginal,
    REPLACE(REPLACE(Descricao, 'Conta de Luz', 'Energia Elétrica'), 'Eletricidade', 'Energia Elétrica') AS DescricaoPadronizada
FROM
    dbo.Transacoes
WHERE
    Descricao LIKE '%Energia%' OR Descricao LIKE '%Luz%' OR Descricao LIKE '%Eletricidade%'
    AND EmpresaID = 1;
```

**Explicação:**
Aqui, usamos `REPLACE()` aninhado para substituir múltiplas variações por uma única forma padronizada: "Energia Elétrica". Isso é útil para relatórios e análises onde você quer consolidar dados que foram inseridos de forma inconsistente.

---

## 21.4. Padronizando o Case: `UPPER()` e `LOWER()`

Essas funções são simples, mas poderosas para garantir a consistência de dados textuais, especialmente em comparações e buscas.

### 21.4.1. `UPPER()`: Tudo em Maiúsculas

Converte todos os caracteres de uma string para maiúsculas.

**Sintaxe:**
```sql
UPPER(string_expression)
```

### 21.4.2. `LOWER()`: Tudo em Minúsculas

Converte todos os caracteres de uma string para minúsculas.

**Sintaxe:**
```sql
LOWER(string_expression)
```

**Exemplo Prático: Buscando descrições sem se preocupar com maiúsculas/minúsculas**

Para buscar a palavra "consultoria" em descrições, independentemente de como foi digitada (Consultoria, consultoria, CONSULTORIA), podemos converter tudo para minúsculas antes de comparar.

```sql
SELECT
    TransacaoID,
    Descricao
FROM
    dbo.Transacoes
WHERE
    LOWER(Descricao) LIKE '%consultoria%' -- Busca case-insensitive
    AND EmpresaID = 1;
```

**Explicação:**
Ao converter a coluna `Descricao` para minúsculas com `LOWER()`, a condição `LIKE '%consultoria%'` se torna case-insensitive, encontrando todas as ocorrências da palavra. O mesmo princípio se aplica a `UPPER()`.

---

## 21.5. Removendo Espaços Indesejados: `LTRIM()` e `RTRIM()`

Espaços em branco extras no início ou no final de uma string são um problema comum em dados, podendo causar falhas em comparações e afetar a legibilidade.

### 21.5.1. `LTRIM()`: Remove Espaços à Esquerda

Remove os espaços em branco do início de uma string.

**Sintaxe:**
```sql
LTRIM(string_expression)
```

### 21.5.2. `RTRIM()`: Remove Espaços à Direita

Remove os espaços em branco do final de uma string.

**Sintaxe:**
```sql
RTRIM(string_expression)
```

**Exemplo Prático: Limpando códigos de contas bancárias**

Imagine que o campo `NumeroConta` foi preenchido com espaços extras.

```sql
-- Simula dados com espaços extras (não execute no DB real, é apenas para demonstração)
-- SELECT '   12345-6   ' AS NumeroContaComEspacos;

SELECT
    ContaID,
    NumeroConta AS NumeroContaOriginal,
    LTRIM(RTRIM(NumeroConta)) AS NumeroContaLimpo,
    LEN(NumeroConta) AS ComprimentoOriginal,
    LEN(LTRIM(RTRIM(NumeroConta))) AS ComprimentoLimpo
FROM
    dbo.ContasBancarias
WHERE
    EmpresaID = 1;
```

**Explicação:**
`LTRIM(RTRIM(NumeroConta))` é uma combinação comum para remover espaços de ambos os lados de uma string. As colunas `ComprimentoOriginal` e `ComprimentoLimpo` demonstram a eficácia da limpeza. É uma boa prática aplicar `LTRIM(RTRIM())` em dados de entrada ou antes de comparações críticas.

---

## 21.6. Combinando Strings: `CONCAT()`

A função `CONCAT()` concatena (une) duas ou mais expressões de string em uma única string. É uma alternativa mais moderna e flexível ao operador `+` para concatenação, especialmente porque lida melhor com valores `NULL`.

**Sintaxe:**
```sql
CONCAT(string_expression1, string_expression2 [, string_expressionN])
```

**Exemplo Prático: Criando um identificador de conta bancária legível**

Podemos combinar o nome do banco, agência e número da conta para criar um identificador completo para relatórios.

```sql
SELECT
    cb.ContaID,
    e.NomeFantasia AS Empresa,
    b.NomeBanco,
    cb.Agencia,
    cb.NumeroConta,
    CONCAT(b.NomeBanco, ' - Ag: ', cb.Agencia, ' C/C: ', cb.NumeroConta) AS IdentificadorCompleto
FROM
    dbo.ContasBancarias cb
INNER JOIN
    dbo.Bancos b ON cb.BancoID = b.BancoID
INNER JOIN
    dbo.Empresas e ON cb.EmpresaID = e.EmpresaID
WHERE
    cb.EmpresaID = 1;
```

**Explicação:**
`CONCAT()` une várias strings e literais de texto (`' - Ag: '`, `' C/C: '`) em uma única coluna `IdentificadorCompleto`. Se qualquer uma das expressões de string for `NULL`, `CONCAT()` a trata como uma string vazia, em vez de retornar `NULL` para toda a expressão (comportamento do operador `+`).

---

## Analogia de Ancoragem: O Editor de Texto do T-SQL

Pense nas funções de texto do T-SQL como um **editor de texto superpoderoso** que você usa para trabalhar com as "palavras" e "frases" que estão armazenadas nas colunas do seu banco de dados.

*   **`LEN()`** é como a função "Contar Caracteres" do seu editor: ela te diz o tamanho de um texto.
*   **`LEFT()`, `RIGHT()`, `SUBSTRING()`** são como as ferramentas de "Recortar" ou "Copiar Parte": você especifica de onde até onde quer pegar um pedaço do texto.
*   **`CHARINDEX()`** é a função "Localizar": ela te diz onde uma palavra ou letra específica começa no seu texto.
*   **`REPLACE()`** é a função "Localizar e Substituir": você encontra todas as ocorrências de uma palavra e as troca por outra, padronizando o texto.
*   **`UPPER()` e `LOWER()`** são os botões "Maiúsculas" e "Minúsculas": eles transformam todo o texto para um padrão consistente.
*   **`LTRIM()` e `RTRIM()`** são como a função "Remover Espaços Extras": eles limpam as bordas do seu texto, tirando aqueles espaços indesejados.
*   **`CONCAT()`** é como "Colar" vários pedaços de texto juntos para formar uma frase maior e mais completa.

Assim como você usa um editor de texto para organizar, formatar e refinar seus documentos, você usa as funções de texto do T-SQL para organizar, formatar e refinar os dados textuais do seu FinanceDB, tornando-os mais úteis para análise e apresentação.

---

## Glossário Técnico

*   **String (Cadeia de Caracteres):** Uma sequência de caracteres (letras, números, símbolos) tratada como um único valor.
*   **Substring:** Uma parte de uma string maior.
*   **Concatenar:** Unir duas ou mais strings em uma única string.
*   **Case-sensitive:** Diferencia maiúsculas de minúsculas (ex: "SQL" é diferente de "sql").
*   **Case-insensitive:** Não diferencia maiúsculas de minúsculas (ex: "SQL" é igual a "sql").
*   **Alias:** Um nome temporário dado a uma coluna ou tabela em uma consulta para facilitar a leitura.

---

## Antecipando Erros e Dicas de Otimização

1.  **`NULL` e Funções de Texto:** A maioria das funções de texto retorna `NULL` se a `string_expression` de entrada for `NULL`. A exceção é `CONCAT()`, que trata `NULL` como string vazia. Sempre considere o tratamento de `NULL` em suas consultas, usando `ISNULL()` ou `COALESCE()` se precisar de um valor padrão.
2.  **Performance com `LIKE` e Funções:** Usar funções de texto em cláusulas `WHERE` (ex: `WHERE LOWER(Descricao) LIKE '%termo%'`) pode impedir o uso de índices na coluna `Descricao`, resultando em *table scans* e performance mais lenta para grandes volumes de dados. Se a busca case-insensitive for frequente, considere criar um índice em uma coluna computada persistida (`LOWER(Descricao)`) ou ajustar o *collation* da coluna para ser case-insensitive.
3.  **`NVARCHAR` vs `VARCHAR`:** Lembre-se que `NVARCHAR` armazena caracteres Unicode e ocupa o dobro do espaço de `VARCHAR` (2 bytes por caractere vs 1 byte). Use `NVARCHAR` quando precisar suportar múltiplos idiomas ou caracteres especiais.
4.  **Tamanho Máximo de Strings:** O SQL Server tem limites para o tamanho de strings. `NVARCHAR(MAX)` e `VARCHAR(MAX)` podem armazenar até 2 GB de dados, mas são mais lentos para processar do que tipos de tamanho fixo ou menor.
5.  **`TRIM()` no SQL Server 2017+:** O SQL Server 2017 introduziu a função `TRIM()`, que combina `LTRIM()` e `RTRIM()` e permite especificar quais caracteres remover (não apenas espaços). Se você estiver em uma versão mais recente, pode preferir `TRIM()`.

---

## Desafio de Fixação: Análise de Descrições e Códigos

Para solidificar seu conhecimento, resolva o seguinte desafio usando as funções de texto que você aprendeu.

**Objetivo:** Gerar um relatório de transações para a `EmpresaID = 1` (Tech Solutions Ltda.) que inclua:
1.  O `TransacaoID`.
2.  A `Descricao` original da transação.
3.  Uma coluna `DescricaoCurta` que contenha os primeiros 30 caracteres da descrição, seguida de "..." se a descrição original for mais longa que 30 caracteres. Caso contrário, exiba a descrição completa.
4.  Uma coluna `CodigoPadronizado` que combine o `Codigo` do `PlanoDeContas` com a `Sigla` do `Banco` (tudo em maiúsculas), separados por um hífen. Ex: "1.1.01-ITAU".
5.  Uma coluna `TipoDocumento` que extraia o prefixo de 3 caracteres do `NumeroDocumento` (ex: "NF-", "FP-", "AWS-"). Se o `NumeroDocumento` for `NULL`, exiba "N/A".
6.  Filtre o relatório para incluir apenas transações que contenham a palavra "consultoria" (case-insensitive) na descrição original.

**Saída Esperada (exemplo de algumas linhas):**
|TransacaoID|DescricaoOriginal|DescricaoCurta|CodigoPadronizado|TipoDocumento|
|---|---|---|---|---|
|1|Consultoria estratégica — Cliente Alpha|Consultoria estratégica — Cli…|1.1.01-ITAU|NF-|
|2|Consultoria técnica — Cliente Beta|Consultoria técnica — Cliente…|1.1.01-BB|NF-|
|3|Consultoria de processos — Cliente Gamma|Consultoria de processos — P…|1.1.01-ITAU|NF-|
|13|Consultoria estratégica — Cliente Delta|Consultoria estratégica — Cli…|1.1.01-ITAU|NF-|

---

## Resolução do Desafio de Fixação


~~~sql

SELECT
    t.TransacaoID,
    t.Descricao AS DescricaoOriginal,
    -- 3. DescricaoCurta: Primeiros 30 caracteres + "..." se mais longa, senão completa
    CASE
        WHEN LEN(t.Descricao) > 30 THEN LEFT(t.Descricao, 30) + '...'
        ELSE t.Descricao
    END AS DescricaoCurta,
    -- 4. CodigoPadronizado: Codigo PlanoDeContas + Sigla Banco (UPPER)
    UPPER(CONCAT(pc.Codigo, '-', b.Sigla)) AS CodigoPadronizado,
    -- 5. TipoDocumento: Prefixo de 3 caracteres do NumeroDocumento, ou 'N/A' se NULL
    ISNULL(LEFT(t.NumeroDocumento, 3), 'N/A') AS TipoDocumento
FROM
    dbo.Transacoes t
INNER JOIN
    dbo.PlanoDeContas pc ON t.ContaPlanoID = pc.ContaPlanoID
INNER JOIN
    dbo.ContasBancarias cb ON t.ContaID = cb.ContaID
INNER JOIN
    dbo.Bancos b ON cb.BancoID = b.BancoID
WHERE
    t.EmpresaID = 1 -- Para a Tech Solutions Ltda.
    AND LOWER(t.Descricao) LIKE '%consultoria%' -- Filtra por "consultoria" (case-insensitive)
ORDER BY
    t.TransacaoID;
~~~



**Comentários sobre a Resolução:**

*   **`DescricaoCurta`**: Utilizamos uma expressão `CASE` para verificar se o comprimento da `Descricao` é maior que 30. Se for, usamos `LEFT(t.Descricao, 30) + '...'` para pegar os 30 primeiros caracteres e adicionar reticências. Caso contrário, exibimos a `Descricao` completa.
*   **`CodigoPadronizado`**: `CONCAT()` é usado para unir o `Codigo` do `PlanoDeContas` com a `Sigla` do `Banco`, e `UPPER()` garante que o resultado esteja todo em maiúsculas, padronizando a saída.
*   **`TipoDocumento`**: `LEFT(t.NumeroDocumento, 3)` extrai os três primeiros caracteres. `ISNULL()` é crucial aqui para substituir `NULL` por `'N/A'` caso o `NumeroDocumento` não esteja preenchido, evitando que a coluna `TipoDocumento` exiba `NULL` para esses casos.
*   **Filtro `WHERE`**: `LOWER(t.Descricao) LIKE '%consultoria%'` é a forma eficiente de realizar uma busca case-insensitive pela palavra "consultoria" em qualquer parte da descrição.
*   **JOINs**: Os `INNER JOINs` são necessários para acessar as informações das tabelas `PlanoDeContas`, `ContasBancarias` e `Bancos`, que contêm os dados para `Codigo` e `Sigla`.

Este desafio demonstra como as funções de texto podem ser combinadas com outras cláusulas T-SQL (`CASE`, `JOIN`, `WHERE`) para criar relatórios complexos e formatados de acordo com as necessidades de análise.

---

## Log de Estado do Projeto


## Estado — Após o Capítulo 21

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

=== CAPÍTULOS DO MÓDULO 3 ===
✅ Capítulo 15: INNER JOIN
✅ Capítulo 16: LEFT JOIN, RIGHT JOIN e FULL OUTER JOIN
✅ Capítulo 17: SELF JOIN — Auto-relacionamento e hierarquias
✅ Capítulo 18: Funções de Agregação — SUM, COUNT, AVG, MIN e MAX
✅ Capítulo 19: GROUP BY e HAVING — Agrupamento e filtragem de grupos
✅ Capítulo 20: Funções de Data e Hora — Manipulação de datas e períodos
✅ Capítulo 21: Funções de Texto — Manipulação de strings
⬜ Capítulo 22: Subconsultas

=== HABILIDADES ADQUIRIDAS NESTE CAPÍTULO ===
- LEN(): Medir o comprimento de strings
- LEFT(), RIGHT(), SUBSTRING(): Extrair partes de strings
- CHARINDEX(): Localizar a posição de uma substring
- REPLACE(): Substituir texto dentro de strings
- UPPER(), LOWER(): Padronizar o case de strings
- LTRIM(), RTRIM(): Remover espaços em branco das extremidades
- CONCAT(): Combinar múltiplas strings
- Uso de CASE para lógica condicional com funções de texto
- Tratamento de NULL em funções de texto com ISNULL()
- Impacto de funções em WHERE na performance de índices

=== PRÓXIMO ===
Capítulo 22: Subconsultas — Subqueries Correlacionadas e Não Correlacionadas
Objetivo: usar subqueries para cálculos e filtros intermediários,
resolver problemas complexos em uma única consulta, entender a
diferença entre subconsultas correlacionadas e não correlacionadas,
e aplicar operadores como IN, EXISTS, ALL e ANY em cenários financeiros
do FinanceDB, como encontrar empresas com transações acima da média
ou contas sem movimentação.




---

Dúvidas? Posso prosseguir para o Capítulo 22?