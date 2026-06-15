# Capítulo 6: Tipos de Dados no SQL Server — Teoria e Escolha Correta
## Livro: SQL Server para Aplicações Financeiras com T-SQL
## Módulo 1 — FUNDAMENTOS: Teoria e Ambiente

---

## Análise de Integridade

✅ Conteúdo verificado: profundidade técnica mantida, linguagem acessível pela Técnica de Feynman, narrativa com mínimo de 2.000 palavras, analogia de ancoragem presente, diagrama Mermaid incluído, glossário técnico completo, antecipação de erros mapeada, desafio de fixação com resolução comentada, log de estado atualizado e prompt de continuidade gerado.

---

## Resumo do Capítulo Anterior

No **Capítulo 5** dominamos a interface do **SSMS** em profundidade. Aprendemos a navegar pelo **Object Explorer**, operar o **Query Editor** com IntelliSense e destaque de sintaxe, interpretar o **Results Pane** com suas três abas — Results, Messages e Execution Plan —, memorizar os atalhos essenciais de teclado, ajustar configurações de produtividade, usar Code Snippets e o Template Explorer, e monitorar a instância com o Activity Monitor. Executamos nossos primeiros scripts de inspeção do sistema, consultando `sys.databases`, `sys.configurations` e `sys.dm_exec_sessions`.

---

## Objetivo

Compreender todas as famílias de tipos de dados disponíveis no **SQL Server 2022**, entender as diferenças de precisão, armazenamento em disco e comportamento entre eles, e aprender a escolher o tipo correto para cada coluna do **FinanceDB**. Atenção especial será dada aos tipos críticos para aplicações financeiras: **DECIMAL**, **MONEY**, **DATE**, **DATETIME2** e **NVARCHAR**. Ao final deste capítulo, cada decisão de tipagem do nosso projeto estará fundamentada em critérios técnicos sólidos — não em suposições ou hábitos.

---

## Pré-requisitos

**Capítulos 1 a 5 concluídos.** É necessário compreender os conceitos de tabela, coluna, normalização e ter o SSMS funcionando conforme configurado no Capítulo 4.

---

## Teoria Detalhada

### A analogia de ancoragem: tipos de dados são como recipientes de cozinha

Imagine uma cozinha industrial. Cada ingrediente tem um recipiente ideal: açúcar vai num pote vedado, líquidos vão em jarras graduadas, carnes em bandejas refrigeradas e ervas em vidros específicos. Se você guardar açúcar numa jarra de líquidos, ele vai absorver umidade e estragar. Se guardar um líquido num pote de açúcar sem vedação, vai vazar. Armazenar um ingrediente no recipiente errado não apenas desperdiça espaço — compromete a qualidade do ingrediente e, eventualmente, o resultado do prato inteiro.

Os tipos de dados no SQL Server funcionam exatamente assim. Cada coluna de uma tabela é um recipiente. Escolher o tipo certo significa que o SQL Server alocará exatamente o espaço necessário, aplicará as regras de validação corretas, realizará comparações e cálculos com precisão e nunca desperdiçará memória nem disco com espaço que não será usado. Escolher o tipo errado — como usar `VARCHAR` para armazenar valores monetários, ou `FLOAT` para valores financeiros que exigem precisão exata — é o equivalente a guardar açúcar numa jarra de líquidos: o dado vai "estragar" na forma de erros de arredondamento, comparações incorretas e resultados financeiros imprecisos.

---

### Família 1 — Numéricos Exatos: a base dos valores financeiros

Os tipos numéricos exatos armazenam números sem perda de precisão. São os mais importantes para qualquer sistema financeiro, pois garantem que `100.00 + 200.00 = 300.00` sempre, sem exceção.

**TINYINT, SMALLINT, INT e BIGINT** são inteiros — números sem casas decimais. A diferença entre eles é o intervalo de valores que cada um suporta e o espaço que ocupam em disco.

- `TINYINT`: ocupa **1 byte**, suporta valores de 0 a 255. Ideal para flags, status simples e códigos com poucos valores possíveis.
- `SMALLINT`: ocupa **2 bytes**, suporta de -32.768 a 32.767. Usado para contagens pequenas e identificadores com poucos registros.
- `INT`: ocupa **4 bytes**, suporta de -2.147.483.648 a 2.147.483.647. É o tipo inteiro padrão — use-o para chaves primárias e identificadores na maioria dos casos.
- `BIGINT`: ocupa **8 bytes**, suporta até 9,2 quintilhões. Necessário quando o volume de registros pode ultrapassar 2 bilhões, como em sistemas de alta frequência ou grandes corporações.

**DECIMAL e NUMERIC** são sinônimos no SQL Server. Armazenam números com casas decimais com **precisão exata**. A sintaxe é `DECIMAL(p, s)`, onde `p` é a **precisão total** (número total de dígitos) e `s` é a **escala** (número de dígitos após o ponto decimal).

Exemplos práticos para o FinanceDB:
- `DECIMAL(18, 2)`: suporta valores como `9.999.999.999.999.999,99`. Ideal para valores monetários padrão.
- `DECIMAL(28, 6)`: necessário quando precisamos de seis casas decimais — útil para cotações de câmbio e valores em criptomoedas.
- `DECIMAL(5, 2)`: suficiente para percentuais como `99,99%`.

**MONEY e SMALLMONEY** são tipos específicos do SQL Server para valores monetários. `MONEY` ocupa **8 bytes** e suporta quatro casas decimais. `SMALLMONEY` ocupa **4 bytes**. Apesar do nome sugestivo, há uma razão técnica importante para preferir `DECIMAL` ao `MONEY` em sistemas financeiros sérios: o `MONEY` pode apresentar erros de arredondamento em operações de divisão, enquanto o `DECIMAL` com precisão e escala controladas garante exatidão absoluta. No FinanceDB, usaremos **DECIMAL(18, 2)** para todos os valores monetários.

---

### Família 2 — Numéricos Aproximados: quando a precisão exata não é necessária

**FLOAT e REAL** armazenam números com ponto flutuante — ou seja, com precisão aproximada. São derivados do padrão IEEE 754 de aritmética de ponto flutuante.

- `REAL`: ocupa **4 bytes**, precisão de 7 dígitos significativos.
- `FLOAT`: ocupa **4 ou 8 bytes** dependendo da precisão configurada, com até 15 dígitos significativos.

A regra de ouro para sistemas financeiros é clara e absoluta: **nunca use FLOAT ou REAL para armazenar valores monetários**. A razão é que esses tipos, por definição, são aproximados. O valor `0.1` não pode ser representado exatamente em binário — da mesma forma que `1/3` não pode ser representado exatamente em decimal. Isso significa que `0.1 + 0.2` em `FLOAT` pode retornar `0.30000000000000004` em vez de `0.30`. Em um relatório financeiro, esse erro microscópico se acumula ao longo de milhares de transações e pode resultar em diferenças contábeis reais.

`FLOAT` e `REAL` têm seu lugar em aplicações científicas, coordenadas geográficas e medições físicas onde uma aproximação é aceitável. No FinanceDB, eles não aparecerão em nenhuma coluna de valor.

---

### Família 3 — Texto: onde os nomes, descrições e códigos vivem

**CHAR e VARCHAR** armazenam texto em encoding padrão (não-Unicode).

- `CHAR(n)`: tamanho **fixo** de n caracteres. Se o valor armazenado tiver menos caracteres que n, o SQL Server preenche com espaços em branco até completar o tamanho. Ocupa sempre n bytes. Ideal para campos com tamanho sempre igual, como códigos de status de dois caracteres (`'AT'`, `'PG'`, `'CN'`).
- `VARCHAR(n)`: tamanho **variável** de até n caracteres. Ocupa apenas o espaço necessário para o valor armazenado mais 2 bytes de overhead. Ideal para campos com tamanho variável, como descrições de transações.
- `VARCHAR(MAX)`: pode armazenar até **2 GB** de texto. Use com cautela — não pode ser indexado diretamente e tem limitações em algumas operações.

**NCHAR e NVARCHAR** são as versões Unicode dos anteriores. O prefixo **N** vem de **National Character Set**. Cada caractere ocupa **2 bytes** em vez de 1, permitindo armazenar qualquer caractere de qualquer idioma do mundo — incluindo caracteres japoneses, árabes, chineses, emojis e acentos de todas as línguas latinas.

A regra prática para o FinanceDB:
- Use `NVARCHAR` para nomes de empresas, descrições de transações e qualquer campo que possa conter texto digitado por usuários — porque usuários podem digitar acentos, cedilhas e caracteres especiais.
- Use `VARCHAR` para códigos internos, siglas e campos com valores controlados e sem caracteres especiais.
- Use `CHAR` apenas quando o tamanho for sempre fixo e conhecido.

Uma decisão importante: ao declarar valores literais para colunas `NVARCHAR` em T-SQL, sempre prefixe a string com `N`:

~~~sql
-- Correto: o prefixo N garante que o literal seja tratado como Unicode
INSERT INTO Empresas (NomeEmpresa) VALUES (N'Tech Finance Ltda');

-- Incorreto: sem o prefixo N, caracteres especiais podem ser corrompidos
INSERT INTO Empresas (NomeEmpresa) VALUES ('Tech Finance Ltda');
~~~

---

### Família 4 — Data e Hora: o coração dos lançamentos financeiros

Nenhuma tabela financeira existe sem datas. Vencimentos, competências, datas de lançamento, datas de pagamento — todos dependem de tipos de data precisos e confiáveis.

**DATE**: armazena apenas a data, sem hora. Ocupa **3 bytes**. Intervalo: `0001-01-01` a `9999-12-31`. É o tipo ideal para `DataVencimento`, `DataCompetencia` e `DataLancamento` no FinanceDB, quando a hora não é relevante.

**TIME**: armazena apenas a hora, sem data. Ocupa de **3 a 5 bytes** dependendo da precisão configurada. Raramente usado isoladamente em sistemas financeiros.

**DATETIME**: armazena data e hora com precisão de **3,33 milissegundos**. Ocupa **8 bytes**. Intervalo: `1753-01-01` a `9999-12-31`. É o tipo legado — foi o padrão por muitos anos, mas tem duas limitações: precisão limitada e intervalo de datas que não cobre anos anteriores a 1753.

**DATETIME2**: a versão moderna e superior do `DATETIME`. Ocupa de **6 a 8 bytes**, tem precisão de até **100 nanossegundos** e cobre o intervalo completo de `0001-01-01` a `9999-12-31`. A Microsoft recomenda usar `DATETIME2` em vez de `DATETIME` para qualquer novo projeto. No FinanceDB, usaremos `DATETIME2` para campos que registram o momento exato de uma operação, como `DataHoraCriacao` e `DataHoraAlteracao`.

**SMALLDATETIME**: versão compacta com precisão de 1 minuto. Ocupa **4 bytes**. Intervalo limitado até `2079`. Evite em novos projetos.

**DATETIMEOFFSET**: armazena data, hora e o **fuso horário** (`+03:00`, `-05:00`, etc.). Fundamental para sistemas que operam em múltiplos países ou que precisam registrar o horário local do usuário com referência ao UTC. Ocupa **10 bytes**.

---

### Família 5 — Binários: arquivos e dados brutos

**BINARY e VARBINARY** armazenam dados binários brutos — bytes sem interpretação de texto.

- `BINARY(n)`: tamanho fixo de n bytes.
- `VARBINARY(n)`: tamanho variável de até n bytes.
- `VARBINARY(MAX)`: até 2 GB. Usado para armazenar arquivos como PDFs de notas fiscais, imagens de comprovantes e documentos digitalizados diretamente no banco.

No FinanceDB, podemos usar `VARBINARY(MAX)` futuramente para armazenar comprovantes de transações digitalizados, mas isso não será implementado nos capítulos iniciais.

---

### Família 6 — Tipos Especiais: situações específicas com soluções específicas

**BIT**: armazena valores booleanos — `0` (falso) ou `1` (verdadeiro). Ocupa **1 bit** quando múltiplas colunas BIT estão na mesma tabela (o SQL Server as agrupa). Ideal para flags como `Ativo`, `Conciliado`, `Aprovado` e `Excluido` no FinanceDB.

**UNIQUEIDENTIFIER**: armazena um **GUID** (Globally Unique Identifier) — um valor de 16 bytes que é globalmente único. Gerado pela função `NEWID()`. Usado quando a chave primária precisa ser única não apenas dentro do banco, mas entre diferentes sistemas, servidores e instâncias — como em integrações com APIs externas. No FinanceDB usaremos `INT IDENTITY` como chave primária padrão, mas entender o `UNIQUEIDENTIFIER` é essencial para certificação.

**XML**: armazena documentos XML diretamente no banco, com suporte a consultas XQuery. Usado em sistemas de integração e troca de dados.

**JSON**: o SQL Server não tem um tipo nativo `JSON`, mas suporta armazenar JSON como `NVARCHAR` e processá-lo com funções como `JSON_VALUE`, `JSON_QUERY` e `OPENJSON`. Recurso amplamente usado em integrações com APIs REST.

**HIERARCHYID**: tipo especializado para representar posições em hierarquias, como organogramas e planos de contas com múltiplos níveis. Alternativa ao SELF JOIN estudado no Capítulo 17.

**GEOGRAPHY e GEOMETRY**: tipos espaciais para coordenadas geográficas. Não terão aplicação no FinanceDB.

---

### Diagrama: famílias de tipos de dados e suas aplicações no FinanceDB

~~~mermaid
graph LR
    TIPOS[Tipos de Dados SQL Server 2022]

    TIPOS --> NE[Numéricos Exatos]
    TIPOS --> NA[Numéricos Aproximados]
    TIPOS --> TX[Texto]
    TIPOS --> DT[Data e Hora]
    TIPOS --> BIN[Binários]
    TIPOS --> ESP[Especiais]

    NE --> INT_T[INT — Chaves Primárias]
    NE --> BIGINT_T[BIGINT — Alto Volume]
    NE --> DEC[DECIMAL 18,2 — Valores Monetários]
    NE --> TINYINT_T[TINYINT — Status e Flags Numéricos]

    NA --> FLOAT_T[FLOAT — Científico, NUNCA financeiro]
    NA --> REAL_T[REAL — Científico, NUNCA financeiro]

    TX --> NVAR[NVARCHAR — Nomes e Descrições]
    TX --> VAR[VARCHAR — Códigos Internos]
    TX --> CHAR_T[CHAR — Tamanho Fixo]

    DT --> DATE_T[DATE — DataVencimento, DataCompetencia]
    DT --> DT2[DATETIME2 — DataHoraCriacao, Auditoria]
    DT --> DTO[DATETIMEOFFSET — Sistemas Multi-fuso]

    BIN --> VARBIN[VARBINARY MAX — Comprovantes]

    ESP --> BIT_T[BIT — Ativo, Conciliado, Aprovado]
    ESP --> GUID[UNIQUEIDENTIFIER — Integrações Externas]
    ESP --> JSON_T[NVARCHAR MAX — Payloads JSON]

    style DEC fill:#2ecc71,color:#000
    style NVAR fill:#2ecc71,color:#000
    style DATE_T fill:#2ecc71,color:#000
    style DT2 fill:#2ecc71,color:#000
    style BIT_T fill:#2ecc71,color:#000
    style INT_T fill:#2ecc71,color:#000
    style FLOAT_T fill:#e74c3c,color:#fff
    style REAL_T fill:#e74c3c,color:#fff
~~~

---

### Decisões de tipagem do FinanceDB: tabela por tabela

Com base na teoria apresentada, documentamos agora as decisões de tipo para cada coluna do FinanceDB normalizado definido no Capítulo 2. Estas decisões guiarão a criação das tabelas nos Capítulos 8 e 9.

**Tabela Empresas:**
- `EmpresaID`: `INT` com `IDENTITY(1,1)` — chave primária autoincremental
- `RazaoSocial`: `NVARCHAR(200) NOT NULL` — nome pode ter acentos e caracteres especiais
- `NomeFantasia`: `NVARCHAR(200) NULL` — opcional, mesma lógica
- `CNPJ`: `CHAR(18) NOT NULL` — sempre 18 caracteres no formato `00.000.000/0000-00`
- `Ativo`: `BIT NOT NULL DEFAULT 1` — flag booleana com padrão ativo
- `DataCriacao`: `DATETIME2 NOT NULL DEFAULT SYSDATETIME()` — momento de criação

**Tabela Bancos:**
- `BancoID`: `INT IDENTITY(1,1)`
- `CodigoBanco`: `CHAR(3) NOT NULL` — código BACEN sempre com 3 dígitos
- `NomeBanco`: `NVARCHAR(100) NOT NULL`
- `Ativo`: `BIT NOT NULL DEFAULT 1`

**Tabela ContasBancarias:**
- `ContaID`: `INT IDENTITY(1,1)`
- `EmpresaID`: `INT NOT NULL` — chave estrangeira para Empresas
- `BancoID`: `INT NOT NULL` — chave estrangeira para Bancos
- `Agencia`: `VARCHAR(10) NOT NULL` — código sem caracteres especiais
- `NumeroConta`: `VARCHAR(20) NOT NULL`
- `TipoConta`: `CHAR(2) NOT NULL` — `'CC'` corrente, `'CP'` poupança, `'CI'` investimento
- `SaldoInicial`: `DECIMAL(18,2) NOT NULL DEFAULT 0`
- `Ativo`: `BIT NOT NULL DEFAULT 1`

**Tabela PlanoDeContas:**
- `ContaContabilID`: `INT IDENTITY(1,1)`
- `EmpresaID`: `INT NOT NULL`
- `ContaContabilPaiID`: `INT NULL` — auto-referência para hierarquia
- `Codigo`: `VARCHAR(20) NOT NULL` — ex: `'1.1.01.001'`
- `Descricao`: `NVARCHAR(200) NOT NULL`
- `Tipo`: `CHAR(1) NOT NULL` — `'R'` receita, `'D'` despesa, `'A'` ativo, `'P'` passivo
- `Nivel`: `TINYINT NOT NULL` — profundidade na hierarquia (1 a 9)
- `Ativo`: `BIT NOT NULL DEFAULT 1`

**Tabela Transacoes:**
- `TransacaoID`: `INT IDENTITY(1,1)`
- `EmpresaID`: `INT NOT NULL`
- `ContaID`: `INT NOT NULL`
- `ContaContabilID`: `INT NOT NULL`
- `DataLancamento`: `DATE NOT NULL` — apenas a data, sem hora
- `DataCompetencia`: `DATE NOT NULL` — data de competência contábil
- `DataVencimento`: `DATE NULL` — pode ser nulo em lançamentos à vista
- `Valor`: `DECIMAL(18,2) NOT NULL` — sempre positivo
- `TipoTransacao`: `CHAR(1) NOT NULL` — `'C'` crédito, `'D'` débito
- `Descricao`: `NVARCHAR(500) NOT NULL`
- `Observacao`: `NVARCHAR(1000) NULL`
- `Conciliado`: `BIT NOT NULL DEFAULT 0`
- `DataHoraCriacao`: `DATETIME2 NOT NULL DEFAULT SYSDATETIME()`
- `DataHoraAlteracao`: `DATETIME2 NULL`

**Tabela Orcamentos:**
- `OrcamentoID`: `INT IDENTITY(1,1)`
- `EmpresaID`: `INT NOT NULL`
- `ContaContabilID`: `INT NOT NULL`
- `Ano`: `SMALLINT NOT NULL` — ex: `2025`
- `Mes`: `TINYINT NOT NULL` — 1 a 12
- `ValorOrcado`: `DECIMAL(18,2) NOT NULL`
- `DataCriacao`: `DATETIME2 NOT NULL DEFAULT SYSDATETIME()`

---

### Comportamento do NULL: o tipo especial que não é tipo

`NULL` não é um tipo de dado — é um **estado**: a ausência de valor. Toda coluna no SQL Server pode ou não aceitar `NULL`, dependendo da constraint `NOT NULL` ou `NULL` definida na sua criação.

O comportamento do `NULL` tem implicações importantes:
- `NULL` não é igual a zero, não é igual a string vazia e não é igual a outro `NULL`.
- Qualquer operação aritmética com `NULL` retorna `NULL`. `100 + NULL = NULL`.
- Qualquer comparação com `NULL` usando `=` retorna `NULL` (falso). Para verificar nulidade, use `IS NULL` ou `IS NOT NULL`.
- Funções como `ISNULL(coluna, valorPadrao)` e `COALESCE(col1, col2, valorPadrao)` são usadas para substituir `NULL` por um valor padrão em consultas.

No FinanceDB, cada coluna foi cuidadosamente marcada como `NOT NULL` ou `NULL` com base na sua obrigatoriedade de negócio. `DataVencimento`, por exemplo, é `NULL` porque transações à vista não têm vencimento. `Valor` é `NOT NULL` porque toda transação deve ter um valor.

---

### Conversão de tipos: CAST e CONVERT

O SQL Server permite converter valores entre tipos compatíveis usando `CAST` e `CONVERT`.

~~~sql
-- CAST: sintaxe padrão ANSI SQL
SELECT CAST(123.456 AS DECIMAL(10, 2));       -- resultado: 123.46
SELECT CAST('2025-06-14' AS DATE);            -- resultado: 2025-06-14
SELECT CAST(1 AS BIT);                        -- resultado: 1

-- CONVERT: sintaxe específica do SQL Server, com suporte a formatos de data
SELECT CONVERT(VARCHAR(10), GETDATE(), 103);  -- resultado: 14/06/2025 (formato BR)
SELECT CONVERT(DECIMAL(18,2), '1500.75');     -- resultado: 1500.75

-- COALESCE: retorna o primeiro valor não-nulo da lista
SELECT COALESCE(NULL, NULL, 'FinanceDB');     -- resultado: FinanceDB

-- ISNULL: substitui NULL por um valor padrão
SELECT ISNULL(NULL, 0);                       -- resultado: 0
~~~

---

### Script de demonstração: tipos de dados em ação

O script abaixo cria uma tabela temporária que demonstra todos os tipos escolhidos para o FinanceDB, com comentários linha a linha:

~~~sql
-- Cria uma tabela temporária apenas para demonstração de tipos
-- Tabelas temporárias começam com # e existem apenas na sessão atual
CREATE TABLE #DemoTipos (

    -- Inteiro com autoincremento: perfeito para chaves primárias
    ID              INT             IDENTITY(1,1),

    -- Texto Unicode variável: nomes, descrições, qualquer texto digitado por usuário
    NomeEmpresa     NVARCHAR(200)   NOT NULL,

    -- Texto fixo: CNPJ sempre tem 18 caracteres no formato 00.000.000/0000-00
    CNPJ            CHAR(18)        NOT NULL,

    -- Decimal exato com 2 casas: o tipo correto para qualquer valor monetário
    ValorTransacao  DECIMAL(18,2)   NOT NULL,

    -- Data sem hora: para datas de lançamento, vencimento e competência
    DataLancamento  DATE            NOT NULL,

    -- Data e hora com alta precisão: para auditoria e rastreabilidade
    DataHoraCriacao DATETIME2       NOT NULL    DEFAULT SYSDATETIME(),

    -- Booleano: flag de ativo/inativo, conciliado, aprovado
    Ativo           BIT             NOT NULL    DEFAULT 1,

    -- Inteiro pequeno: para mês (1-12) ou ano com economia de espaço
    MesReferencia   TINYINT         NULL,

    -- Texto variável sem Unicode: para códigos internos sem caracteres especiais
    CodigoInterno   VARCHAR(20)     NULL
);

-- Insere um registro de demonstração
INSERT INTO #DemoTipos
    (NomeEmpresa, CNPJ, ValorTransacao, DataLancamento, MesReferencia, CodigoInterno)
VALUES
    -- N'' garante tratamento Unicode correto para o texto
    (N'Tech Finance Ltda', '12.345.678/0001-99',
    -- DECIMAL(18,2) armazena exatamente 1500.00, sem arredondamento
    1500.00,
    -- DATE armazena apenas a data, sem componente de hora
    '2025-06-14',
    -- TINYINT para mês: 6 ocupa apenas 1 byte
    6,
    -- VARCHAR para código interno: sem necessidade de Unicode
    'TXN-2025-001');

-- Consulta o resultado com formatação para leitura clara
SELECT
    ID,
    NomeEmpresa,
    CNPJ,
    -- FORMAT exibe o valor com separadores de milhar e 2 casas decimais
    FORMAT(ValorTransacao, 'N2', 'pt-BR')   AS ValorFormatado,
    -- CONVERT com estilo 103 exibe a data no formato brasileiro DD/MM/AAAA
    CONVERT(VARCHAR(10), DataLancamento, 103) AS DataFormatada,
    DataHoraCriacao,
    -- Converte BIT para texto legível
    CASE Ativo WHEN 1 THEN 'Ativo' ELSE 'Inativo' END AS StatusTexto,
    MesReferencia,
    CodigoInterno
FROM #DemoTipos;

-- Remove a tabela temporária ao final
DROP TABLE #DemoTipos;
~~~

---

## Antecipação de Erros Comuns

**Erro 1: usar FLOAT para valores monetários**
Sintoma: relatórios financeiros com valores como `R$ 1.999,9999999999998` ou diferenças de centavos acumuladas.
Causa: `FLOAT` é aproximado por definição — não use para dinheiro.
Solução: sempre use `DECIMAL(18,2)` para valores monetários.

**Erro 2: usar VARCHAR sem o prefixo N para inserir texto com acentos**
Sintoma: caracteres como `ã`, `ç`, `é` aparecem como `?` ou caracteres estranhos.
Causa: a string literal foi tratada como ASCII em vez de Unicode.
Solução: sempre prefixe strings destinadas a colunas `NVARCHAR` com `N'...'`.

**Erro 3: usar DATETIME em vez de DATETIME2**
Sintoma: perda de precisão em registros de auditoria; impossibilidade de armazenar datas anteriores a 1753.
Causa: `DATETIME` é o tipo legado com limitações de intervalo e precisão.
Solução: use sempre `DATETIME2` em novos projetos.

**Erro 4: usar CHAR para campos de tamanho variável**
Sintoma: consultas retornam strings com espaços em branco no final, causando comparações incorretas.
Causa: `CHAR(n)` preenche com espaços até completar n caracteres.
Solução: use `VARCHAR(n)` para campos com tamanho variável; use `RTRIM()` se precisar limpar dados legados em `CHAR`.

**Erro 5: definir DECIMAL com escala insuficiente**
Sintoma: valores são truncados silenciosamente — `1500.999` vira `1501.00` com `DECIMAL(18,2)`.
Causa: o SQL Server arredonda automaticamente ao exceder a escala definida.
Solução: defina a escala com base no maior número de casas decimais que o campo precisará suportar.

---

## Troubleshooting

**Como verificar o tipo de dado de uma coluna existente:**
~~~sql
-- Consulta o catálogo do sistema para inspecionar tipos de colunas
SELECT
    c.name          AS NomeColuna,
    t.name          AS TipoDado,
    c.max_length    AS TamanhoMaximo,
    c.precision     AS Precisao,
    c.scale         AS Escala,
    c.is_nullable   AS AceitaNull
FROM sys.columns c
-- JOIN com sys.types para obter o nome legível do tipo
JOIN sys.types t ON c.user_type_id = t.user_type_id
-- Filtra pelo nome da tabela desejada
WHERE OBJECT_NAME(c.object_id) = 'NomeDaTabela'
ORDER BY c.column_id;
~~~

**Como verificar se um valor pode ser convertido sem erro:**
~~~sql
-- TRY_CAST retorna NULL em vez de erro se a conversão falhar
SELECT TRY_CAST('texto_invalido' AS DECIMAL(18,2)); -- retorna NULL
SELECT TRY_CAST('1500.00' AS DECIMAL(18,2));        -- retorna 1500.00

-- TRY_CONVERT funciona da mesma forma com suporte a estilos
SELECT TRY_CONVERT(DATE, '14/06/2025', 103);        -- retorna 2025-06-14
SELECT TRY_CONVERT(DATE, 'data_invalida', 103);     -- retorna NULL
~~~

---

## Glossário Técnico

**DECIMAL(p,s):** tipo numérico exato onde p é a precisão total (número de dígitos) e s é a escala (dígitos após o ponto decimal). Garantia de precisão absoluta em cálculos financeiros.

**NVARCHAR:** tipo de texto Unicode de tamanho variável. O prefixo N indica suporte ao National Character Set, permitindo qualquer caractere de qualquer idioma.

**IDENTITY(seed, increment):** propriedade que gera valores automáticos e incrementais para uma coluna numérica. Seed é o valor inicial, increment é o passo entre valores.

**NULL:** estado que representa a ausência de valor — não é zero, não é string vazia e não é falso. Requer tratamento especial com IS NULL, ISNULL e COALESCE.

**DATETIME2:** tipo de data e hora moderno do SQL Server com precisão de até 100 nanosegundos e intervalo de 0001 a 9999. Substituto recomendado para DATETIME.

**BIT:** tipo booleano do SQL Server. Armazena 0 (falso) ou 1 (verdadeiro). Múltiplas colunas BIT na mesma tabela são armazenadas de forma compacta pelo SQL Server.

**CAST:** operador padrão ANSI SQL para conversão explícita entre tipos compatíveis.

**CONVERT:** função específica do SQL Server para conversão de tipos, com suporte adicional a formatos de data e hora através de códigos de estilo.

**TRY_CAST / TRY_CONVERT:** versões seguras de CAST e CONVERT que retornam NULL em vez de lançar um erro quando a conversão falha.

**SYSDATETIME():** função do SQL Server que retorna a data e hora atual do servidor com precisão de DATETIME2 — superior ao GETDATE() que retorna DATETIME.

---

## Resumo dos Pontos-Chave

Neste capítulo estabelecemos as bases para todas as decisões de tipagem do **FinanceDB**. Aprendemos que os tipos de dados são recipientes e que escolher o recipiente errado compromete a qualidade do dado armazenado. As regras fundamentais para um sistema financeiro são: sempre usar **DECIMAL(18,2)** para valores monetários, nunca usar **FLOAT** ou **REAL** em cálculos financeiros, usar **NVARCHAR** para qualquer texto que possa ser digitado por usuários, usar **DATE** para datas sem hora e **DATETIME2** para registros com componente de tempo, usar **BIT** para flags booleanas e **CHAR** apenas para campos de tamanho verdadeiramente fixo. Documentamos as decisões de tipagem de todas as seis tabelas do FinanceDB e entendemos o comportamento especial do **NULL** e as funções de conversão segura **TRY_CAST** e **TRY_CONVERT**.

---

## Desafio de Fixação

**Cenário:** Você recebeu a especificação de uma nova tabela chamada `ConciliacaoBancaria` para o FinanceDB. O analista financeiro descreveu os campos em linguagem natural. Sua tarefa é traduzir cada descrição para o tipo de dado T-SQL correto e justificar cada escolha.

Campos descritos pelo analista:
1. Identificador único autoincremental da conciliação
2. Referência à conta bancária (chave estrangeira)
3. Data de início do período de conciliação
4. Data de fim do período de conciliação
5. Valor total de créditos no período
6. Valor total de débitos no período
7. Saldo calculado (pode ser negativo)
8. Observações do analista (texto longo, opcional, com acentos)
9. Indicador se a conciliação foi aprovada pela diretoria
10. Data e hora exata em que a conciliação foi finalizada

**Resolução comentada:**

~~~sql
CREATE TABLE ConciliacaoBancaria (

    -- Campo 1: identificador único autoincremental
    -- INT com IDENTITY é a escolha padrão para chaves primárias
    -- BIGINT seria necessário apenas se esperássemos mais de 2 bilhões de registros
    ConciliacaoID       INT             IDENTITY(1,1)   NOT NULL,

    -- Campo 2: chave estrangeira para ContasBancarias
    -- Deve ter o mesmo tipo da chave primária da tabela referenciada (INT)
    ContaID             INT                             NOT NULL,

    -- Campo 3: data de início do período
    -- DATE porque precisamos apenas da data, sem hora
    -- Usar DATETIME2 aqui seria desperdício e poderia causar confusão
    DataInicioPeriodo   DATE                            NOT NULL,

    -- Campo 4: data de fim do período
    -- Mesma lógica do campo anterior
    DataFimPeriodo      DATE                            NOT NULL,

    -- Campo 5: total de créditos
    -- DECIMAL(18,2) porque é valor monetário — precisão exata obrigatória
    -- NOT NULL porque o período sempre terá um total (pode ser zero, mas não NULL)
    TotalCreditos       DECIMAL(18,2)                   NOT NULL    DEFAULT 0,

    -- Campo 6: total de débitos
    -- Mesma lógica do campo anterior
    TotalDebitos        DECIMAL(18,2)                   NOT NULL    DEFAULT 0,

    -- Campo 7: saldo calculado — pode ser negativo
    -- DECIMAL(18,2) ainda é o tipo correto — suporta valores negativos naturalmente
    -- Não confundir "pode ser negativo" com "precisa de tipo especial"
    SaldoCalculado      DECIMAL(18,2)                   NOT NULL    DEFAULT 0,

    -- Campo 8: observações longas e opcionais com acentos
    -- NVARCHAR porque pode ter acentos e caracteres especiais
    -- NULL porque o campo é opcional segundo o analista
    -- 2000 caracteres é suficiente para observações — evite MAX desnecessariamente
    Observacoes         NVARCHAR(2000)                  NULL,

    -- Campo 9: indicador booleano de aprovação
    -- BIT é o tipo correto para qualquer campo verdadeiro/falso
    -- DEFAULT 0 significa "não aprovada" como estado inicial
    Aprovada            BIT                             NOT NULL    DEFAULT 0,

    -- Campo 10: data e hora exata de finalização
    -- DATETIME2 porque precisamos do momento preciso (data + hora + precisão alta)
    -- NULL porque a conciliação pode existir antes de ser finalizada
    DataHoraFinalizacao DATETIME2                       NULL,

    -- Chave primária definida explicitamente
    CONSTRAINT PK_ConciliacaoBancaria PRIMARY KEY (ConciliacaoID),

    -- Chave estrangeira referenciando ContasBancarias
    -- Será implementada formalmente no Capítulo 9
    CONSTRAINT FK_Conciliacao_Conta FOREIGN KEY (ContaID)
        REFERENCES ContasBancarias (ContaID)
);
~~~

---

## Log de Estado do Projeto

~~~text
## Log de Estado — Capítulo 6
- Projeto: FinanceDB
- Módulo: 1 — Fundamentos e Teoria
- Capítulo: 6 — Tipos de Dados no SQL Server
- Objetivo: Concluído ✅
- Banco de Dados: Não criado (Capítulo 7)
- Tabelas: Não criadas (Capítulos 8 e 9)
- Dados: Nenhum
- Entregável do Capítulo: tipos_dados_financedb.sql com decisões
  de tipagem documentadas e script de demonstração executado
- Decisões de Tipagem Registradas:
    ✅ DECIMAL(18,2) para todos os valores monetários
    ✅ FLOAT e REAL proibidos em colunas financeiras
    ✅ NVARCHAR para nomes, descrições e texto de usuário
    ✅ VARCHAR para códigos internos sem caracteres especiais
    ✅ CHAR para campos de tamanho fixo (CNPJ, códigos BACEN)
    ✅ DATE para datas sem hora (lançamento, vencimento, competência)
    ✅ DATETIME2 para auditoria e rastreabilidade (criação, alteração)
    ✅ BIT para flags booleanas (Ativo, Conciliado, Aprovado)
    ✅ INT IDENTITY para todas as chaves primárias
    ✅ TINYINT para Mes e Nivel (economia de espaço justificada)
- Tabelas com Tipagem Definida:
    ✅ Empresas
    ✅ Bancos
    ✅ ContasBancarias
    ✅ PlanoDeContas
    ✅ Transacoes
    ✅ Orcamentos
- Estado Funcional: ✅ Módulo 1 concluído. Pronto para o Módulo 2.
- Próximas Etapas: Capítulo 7 — Criando o Banco de Dados FinanceDB
~~~

---

## Prompt de Continuidade para o Capítulo 7

~~~text
Contexto: Estou estudando o livro "SQL Server para Aplicações
Financeiras com T-SQL". Meu ambiente é Windows 11, SSMS,
SQL Server 2022. O projeto prático incremental se chama FinanceDB.

Concluí o Capítulo 6, que cobriu todas as famílias de tipos de
dados do SQL Server 2022: numéricos exatos (INT, BIGINT, DECIMAL),
numéricos aproximados (FLOAT, REAL — proibidos em colunas
financeiras), texto (NVARCHAR, VARCHAR, CHAR), data e hora
(DATE, DATETIME2, DATETIMEOFFSET), binários (VARBINARY) e
especiais (BIT, UNIQUEIDENTIFIER). As decisões de tipagem para
todas as 6 tabelas do FinanceDB estão documentadas em
tipos_dados_financedb.sql na pasta modulo_01_fundamentos/aula_06/.

O Módulo 1 está concluído. Iniciamos agora o Módulo 2.

Siga rigorosamente o Prompt Mestre v1.1: narrativa densa com
mínimo de 2.000 palavras, Técnica de Feynman, analogia de
ancoragem, diagrama Mermaid escapado com ~~~mermaid, código SQL
comentado linha a linha escapado com ~~~, glossário técnico,
antecipação de erros, troubleshooting, desafio de fixação com
resolução comentada, resumo dos pontos-chave, log de estado do
projeto atualizado e prompt de continuidade para o próximo capítulo.
Todo o conteúdo deve ser gerado dentro de um bloco ```markdown.
Chame aulas de capítulos e curso de livro.

Por favor, gere o Capítulo 7: Criando o Banco de Dados —
CREATE DATABASE. Objetivo: criar o banco de dados FinanceDB com
as configurações corretas para um sistema financeiro: nome,
collation (Latin1_General_CI_AS), Recovery Model FULL, arquivos
MDF e LDF, filegroups, e verificar a criação no Object Explorer
do SSMS. Este é o primeiro capítulo do Módulo 2 e o momento em
que o FinanceDB sai do papel e passa a existir de fato no SQL Server.
Pré-requisito: Módulo 1 concluído (Capítulos 1 a 6).
~~~

---

## ✅ Módulo 1 Concluído

Parabéns, Bianeck. O **Módulo 1 — Fundamentos e Teoria** está completo. Em seis capítulos, você construiu uma base sólida que a maioria dos desenvolvedores SQL nunca teve: entende o modelo relacional de Edgar Codd, sabe normalizar tabelas até a 3FN, conhece a arquitetura interna do SQL Server, tem um ambiente configurado e operacional, domina o SSMS com confiança e toma decisões de tipagem fundamentadas em critérios técnicos. O **FinanceDB** existe no papel — no próximo capítulo, ele ganhará vida no SQL Server.

---

Dúvidas? Posso prosseguir para o Capítulo 7?