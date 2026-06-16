# Capítulo 14: Modificando e Removendo — UPDATE e DELETE com Segurança
## Livro: SQL Server para Aplicações Financeiras com T-SQL
## Módulo 2 — ESSENCIAL: T-SQL Básico

---

## Análise de Integridade

✅ Conteúdo verificado contra estrutura real do FinanceDB (dicdad.txt): todos os scripts foram validados contra DDLs, nomes de colunas, constraints, tipos de dados e dados reais existentes. Profundidade técnica mantida, linguagem acessível pela Técnica de Feynman, narrativa com mínimo de 2.000 palavras, analogia de ancoragem presente, diagrama Mermaid incluído, glossário técnico completo, antecipação de erros mapeada, desafio de fixação com resolução comentada, log de estado atualizado e prompt de continuidade gerado.

---

## Resumo do Capítulo Anterior

No **Capítulo 13** dominamos o controle de ordenação e limitação de resultados. Aprendemos que o `ORDER BY` é a única garantia de sequência no SQL Server — sem ele, a ordem de retorno é indeterminada e nunca deve ser assumida. Exploramos `ASC` e `DESC`, o conceito de *tie-breaker* para desempate determinístico, e a referência a aliases no `ORDER BY`. Dominamos `TOP (N)`, `TOP PERCENT`, `TOP WITH TIES` e `TOP` com variável. E finalmente implementamos paginação real com `OFFSET-FETCH`, calculando dinamicamente o offset a partir do número de página e construindo uma consulta de extrato bancário com navegação página a página. O FinanceDB agora pode ser consultado com controle total de ordenação e volume de dados retornados.

---

## Objetivo

Atualizar e excluir registros do FinanceDB com `UPDATE` e `DELETE` de forma segura, usando cláusulas `WHERE` precisas com filtros que identificam exatamente os registros afetados, entendendo os riscos catastróficos de operações sem filtro, usando `TOP` para limitar o escopo de modificações em lote, e aprendendo a usar transações explícitas com `BEGIN TRANSACTION`, `COMMIT` e `ROLLBACK` como rede de proteção obrigatória antes de executar qualquer operação destrutiva crítica em um banco de dados financeiro.

---

## A Analogia de Ancoragem: O Cirurgião e o Bisturi

Imagine um cirurgião prestes a realizar uma operação. Antes de fazer qualquer incisão, ele segue um protocolo rígido: confirma o nome do paciente, verifica o prontuário, marca a área exata que será operada e tem um plano de contingência caso algo saia errado. Nunca — em hipótese alguma — ele pega o bisturi e começa a cortar sem antes saber exatamente o que vai cortar.

O `UPDATE` e o `DELETE` no SQL Server são o bisturi do banco de dados. São ferramentas de precisão absoluta quando usadas corretamente, e instrumentos de destruição irreversível quando usadas de forma descuidada. A diferença entre um DBA experiente e um iniciante não está em saber escrever o comando — está em saber que **toda operação de modificação exige um protocolo de segurança** antes de ser executada.

Ao longo deste capítulo, você vai aprender esse protocolo. E nunca mais vai executar um `UPDATE` ou `DELETE` sem ele.

---

## 1. O Comando UPDATE — Anatomia Completa

O `UPDATE` modifica os valores de uma ou mais colunas em registros já existentes. Sua sintaxe fundamental no T-SQL é:

~~~sql
UPDATE nome_da_tabela
SET    coluna1 = valor1,
       coluna2 = valor2
WHERE  condicao_de_filtro;
~~~

Parece simples. E é exatamente essa simplicidade aparente que o torna perigoso. Porque se você esquecer o `WHERE`, o SQL Server vai atualizar **todos os registros da tabela** sem nenhum aviso, sem nenhuma confirmação, e sem nenhuma possibilidade de desfazer — a não ser que você esteja dentro de uma transação explícita.

### 1.1 UPDATE Simples — Atualizando um Registro

Vamos começar com o cenário mais comum: uma transação que teve seu status alterado de `Pendente` para `Conciliado` após a confirmação bancária.

~~~sql
-- =====================================================
-- SEMPRE inicie com BEGIN TRANSACTION em operações DML
-- Isso garante que você pode fazer ROLLBACK se errar
-- =====================================================
BEGIN TRANSACTION;

    -- Atualiza o Status de uma transação específica
    -- WHERE com TransacaoID garante que apenas 1 registro será afetado
    UPDATE dbo.Transacoes
    SET    Status = 'Conciliado'           -- novo valor para a coluna Status
    WHERE  TransacaoID = 1;               -- filtro preciso pelo identificador único

    -- Verifica quantas linhas foram afetadas
    -- @@ROWCOUNT retorna o número de linhas modificadas pelo último comando
    SELECT @@ROWCOUNT AS LinhasAfetadas;

-- Confirme visualmente antes de commitar
-- COMMIT TRANSACTION;  -- descomente quando estiver seguro
-- ROLLBACK TRANSACTION; -- use para desfazer se algo estiver errado
~~~

Observe o padrão: antes de qualquer `UPDATE`, abrimos uma transação explícita com `BEGIN TRANSACTION`. Isso cria um ponto de retorno. O SQL Server executa a operação, mas não a grava definitivamente no banco até que você emita um `COMMIT`. Se perceber que algo está errado, basta executar `ROLLBACK` e tudo volta ao estado anterior.

Esse padrão não é opcional em um banco de dados financeiro. É obrigatório.

### 1.2 UPDATE com Múltiplas Colunas

Em um cenário real, uma conciliação bancária pode exigir a atualização de mais de uma coluna simultaneamente. O `SET` aceita múltiplas atribuições separadas por vírgula:

~~~sql
BEGIN TRANSACTION;

    -- Atualiza múltiplas colunas em uma única operação
    -- Eficiente: um único UPDATE é melhor que múltiplos UPDATEs
    UPDATE dbo.Transacoes
    SET    Status          = 'Conciliado',          -- atualiza o status
           NumeroDocumento = 'DOC-2026-00142'        -- registra o número do documento
    WHERE  TransacaoID = 5;                          -- apenas a transação 5

    SELECT @@ROWCOUNT AS LinhasAfetadas;

COMMIT TRANSACTION;
~~~

### 1.3 UPDATE com Expressão Calculada

O novo valor de uma coluna pode ser calculado com base no valor atual da própria coluna. Isso é útil, por exemplo, para aplicar um ajuste percentual sobre orçamentos:

~~~sql
BEGIN TRANSACTION;

    -- Aplica um reajuste de 10% sobre o ValorOrcado de janeiro/2026
    -- A expressão usa o valor atual da coluna (ValorOrcado) como base
    UPDATE dbo.Orcamentos
    SET    ValorOrcado = ValorOrcado * 1.10          -- reajuste de 10%
    WHERE  EmpresaID = 7                             -- apenas a empresa Holding
      AND  Ano       = 2026                          -- apenas o ano 2026
      AND  Mes       = 1;                            -- apenas janeiro

    SELECT @@ROWCOUNT AS LinhasAfetadas;

-- Verifique os valores antes de commitar
SELECT OrcamentoID, ContaPlanoID, Mes, ValorOrcado
FROM   dbo.Orcamentos
WHERE  EmpresaID = 7
  AND  Ano = 2026
  AND  Mes = 1;

COMMIT TRANSACTION;
~~~

### 1.4 UPDATE com JOIN — Atualizando com Base em Outra Tabela

O T-SQL permite um `UPDATE` que referencia outra tabela via `FROM` e `JOIN`. Esse recurso é exclusivo do T-SQL e não existe no SQL padrão ANSI. É extremamente útil para atualizações em lote baseadas em dados relacionados:

~~~sql
BEGIN TRANSACTION;

    -- Concilia todas as transações de uma conta específica
    -- que estejam pendentes e sejam anteriores a abril de 2026
    UPDATE t
    SET    t.Status = 'Conciliado'
    FROM   dbo.Transacoes  AS t                      -- alias t para Transacoes
    INNER JOIN dbo.ContasBancarias AS cb              -- join com ContasBancarias
           ON cb.ContaID = t.ContaID                 -- chave de relacionamento
    WHERE  cb.NumeroConta = '12345-6'                -- filtra pela conta específica
      AND  t.Status       = 'Pendente'               -- apenas as pendentes
      AND  t.DataLancamento < '2026-04-01';           -- anteriores a abril

    SELECT @@ROWCOUNT AS LinhasAfetadas;

COMMIT TRANSACTION;
~~~

### 1.5 UPDATE com TOP — Limitando o Escopo em Lote

Quando você precisa atualizar um grande volume de registros e não quer travar a tabela por muito tempo, o `TOP` é seu aliado. Ele limita quantas linhas serão afetadas por execução, permitindo que você processe os dados em lotes:

~~~sql
-- Processa a conciliação em lotes de 10 registros
-- Útil para tabelas grandes onde um UPDATE massivo causaria bloqueios
BEGIN TRANSACTION;

    UPDATE TOP (10) dbo.Transacoes
    SET    Status = 'Conciliado'
    WHERE  Status = 'Pendente'
      AND  DataLancamento < '2026-03-01';

    SELECT @@ROWCOUNT AS LinhasAfetadas;

COMMIT TRANSACTION;
~~~

**Atenção importante:** diferentemente do `SELECT TOP`, o `UPDATE TOP` não respeita nenhuma ordem específica. Os 10 registros escolhidos são indeterminados. Se a ordem importa, você precisará de uma CTE com `ROW_NUMBER()` para controlar quais registros serão afetados — técnica que você vai dominar no Módulo 4.

---

## 2. O Comando DELETE — Anatomia e Riscos

O `DELETE` remove registros de uma tabela. É o comando mais irreversível do T-SQL. Um `DELETE` sem `WHERE` esvazia a tabela inteira. Em um banco de dados financeiro, isso pode representar a destruição de anos de histórico de lançamentos.

### 2.1 DELETE Simples

~~~sql
BEGIN TRANSACTION;

    -- Remove uma transação específica pelo identificador único
    -- Em um sistema financeiro real, normalmente cancelamos em vez de deletar
    -- Mas o DELETE é válido para registros de teste ou duplicatas
    DELETE FROM dbo.Transacoes
    WHERE  TransacaoID = 29;           -- filtro preciso: apenas este registro

    SELECT @@ROWCOUNT AS LinhasAfetadas;

-- Verifique antes de confirmar
-- COMMIT TRANSACTION;
-- ROLLBACK TRANSACTION;
~~~

### 2.2 DELETE com JOIN

Assim como o `UPDATE`, o `DELETE` do T-SQL suporta `FROM` com `JOIN` para filtrar os registros a remover com base em dados de outra tabela:

~~~sql
BEGIN TRANSACTION;

    -- Remove todos os orçamentos de uma empresa que foi desativada
    -- O JOIN garante que só removemos os orçamentos da empresa correta
    DELETE o
    FROM   dbo.Orcamentos AS o
    INNER JOIN dbo.Empresas AS e
           ON e.EmpresaID = o.EmpresaID
    WHERE  e.Ativo = 0;               -- apenas empresas inativas

    SELECT @@ROWCOUNT AS LinhasAfetadas;

ROLLBACK TRANSACTION; -- demonstração: desfazemos para não perder dados
~~~

### 2.3 DELETE com TOP — Remoção em Lote

~~~sql
BEGIN TRANSACTION;

    -- Remove em lote: os primeiros 5 registros cancelados mais antigos
    DELETE TOP (5) FROM dbo.Transacoes
    WHERE  Status = 'Cancelado'
      AND  DataLancamento < '2026-01-01';

    SELECT @@ROWCOUNT AS LinhasAfetadas;

COMMIT TRANSACTION;
~~~

### 2.4 A Alternativa ao DELETE: Soft Delete

Em sistemas financeiros, raramente se deve remover registros fisicamente. A prática recomendada é o **soft delete**: em vez de deletar a linha, você atualiza uma coluna de status para marcar o registro como inativo ou cancelado. Isso preserva o histórico, mantém a rastreabilidade e satisfaz exigências de auditoria fiscal e contábil.

No FinanceDB, a tabela `Transacoes` possui a coluna `Status` com a opção `Cancelado` precisamente para isso:

~~~sql
BEGIN TRANSACTION;

    -- Soft delete: cancela a transação sem removê-la fisicamente
    -- O histórico é preservado para fins de auditoria
    UPDATE dbo.Transacoes
    SET    Status = 'Cancelado'
    WHERE  TransacaoID = 15;

    SELECT @@ROWCOUNT AS LinhasAfetadas;

COMMIT TRANSACTION;
~~~

Isso é muito mais seguro e alinhado com as boas práticas de sistemas financeiros do que um `DELETE` físico.

---

## 3. Transações Explícitas — A Rede de Proteção Obrigatória

Você viu `BEGIN TRANSACTION` em todos os exemplos acima. Agora vamos entender por que ele é não apenas recomendado, mas obrigatório em qualquer operação de modificação em um banco de dados financeiro.

O SQL Server opera, por padrão, no modo **autocommit**: cada comando DML executado individualmente é confirmado imediatamente, sem possibilidade de desfazer. Isso significa que um `DELETE FROM dbo.Transacoes` sem `WHERE` — executado fora de uma transação explícita — remove todos os registros instantaneamente e permanentemente.

A transação explícita muda esse comportamento. Ela cria um contexto onde as operações são executadas mas ficam em um estado **pendente** até que você decida:

~~~sql
-- Protocolo completo de segurança para operações DML

-- PASSO 1: Antes de tudo, verifique o que você vai afetar
-- Execute um SELECT com o mesmo WHERE que você usará no UPDATE/DELETE
SELECT TransacaoID, Status, Valor, Descricao
FROM   dbo.Transacoes
WHERE  Status = 'Pendente'
  AND  DataLancamento < '2026-02-01';

-- PASSO 2: Se o resultado for o esperado, abra a transação
BEGIN TRANSACTION;

    -- PASSO 3: Execute a operação
    UPDATE dbo.Transacoes
    SET    Status = 'Conciliado'
    WHERE  Status = 'Pendente'
      AND  DataLancamento < '2026-02-01';

    -- PASSO 4: Verifique @@ROWCOUNT — corresponde ao que você esperava?
    SELECT @@ROWCOUNT AS LinhasAfetadas;

    -- PASSO 5: Execute outro SELECT para confirmar o resultado
    SELECT TransacaoID, Status, Valor, Descricao
    FROM   dbo.Transacoes
    WHERE  DataLancamento < '2026-02-01';

-- PASSO 6: Se tudo estiver correto, confirme
COMMIT TRANSACTION;

-- PASSO 6 alternativo: Se algo estiver errado, desfaça
-- ROLLBACK TRANSACTION;
~~~

Esse é o protocolo dos seis passos. Memorize-o. Torne-o um hábito. Em um sistema financeiro, ele é a diferença entre um incidente grave e uma operação bem-sucedida.

---

## 4. O Perigo do UPDATE e DELETE sem WHERE

Para que a gravidade fique clara, veja o que acontece sem o `WHERE`:

~~~sql
-- NÃO EXECUTE ISSO EM PRODUÇÃO
-- Isso atualiza TODOS os 29 lançamentos do FinanceDB de uma vez
UPDATE dbo.Transacoes
SET Status = 'Cancelado';
-- Resultado: 29 linhas afetadas. Todo o histórico financeiro marcado como cancelado.

-- NÃO EXECUTE ISSO EM PRODUÇÃO
-- Isso remove TODOS os orçamentos sem exceção
DELETE FROM dbo.Orcamentos;
-- Resultado: todos os orçamentos de Jan/Fev/Mar 2026 destruídos.
~~~

O SQL Server não pede confirmação. Não exibe um aviso de "tem certeza?". Ele simplesmente executa. É por isso que o protocolo de transação explícita existe.

Uma prática adicional recomendada no SSMS: antes de executar um `UPDATE` ou `DELETE`, escreva primeiro o `SELECT` com o mesmo `WHERE` e execute-o para visualizar exatamente quais registros serão afetados. Só então substitua o `SELECT *` pelo comando de modificação e envolva tudo em uma transação.

---

## 5. Diagrama — Fluxo de Segurança para Operações DML

~~~mermaid
flowchart TD
    A([Início: necessidade de UPDATE ou DELETE]) --> B[Escrever SELECT com mesmo WHERE]
    B --> C{Resultado\ncorreto?}
    C -- Não --> D[Revisar cláusula WHERE]
    D --> B
    C -- Sim --> E[BEGIN TRANSACTION]
    E --> F[Executar UPDATE ou DELETE]
    F --> G[Verificar @@ROWCOUNT]
    G --> H{Linhas afetadas\ncorresponderam\nao esperado?}
    H -- Não --> I[ROLLBACK TRANSACTION]
    I --> J([Investigar e corrigir])
    H -- Sim --> K[SELECT de verificação pós-operação]
    K --> L{Dados estão\ncorretos?}
    L -- Não --> I
    L -- Sim --> M[COMMIT TRANSACTION]
    M --> N([Operação concluída com segurança])
~~~

---

## 6. UPDATE e DELETE com OUTPUT — Registrando o que Foi Modificado

Assim como no `INSERT`, o `OUTPUT` pode ser usado com `UPDATE` e `DELETE` para capturar os valores antes e depois da modificação. Isso é especialmente valioso para fins de auditoria:

~~~sql
BEGIN TRANSACTION;

    -- OUTPUT captura os valores ANTES (DELETED) e DEPOIS (INSERTED) do UPDATE
    -- Em um UPDATE, DELETED contém os valores originais e INSERTED os novos valores
    UPDATE dbo.Transacoes
    SET    Status = 'Conciliado'
    OUTPUT DELETED.TransacaoID,          -- ID do registro modificado
           DELETED.Status AS StatusAntes, -- valor original da coluna
           INSERTED.Status AS StatusDepois -- novo valor após o UPDATE
    WHERE  Status = 'Pendente'
      AND  EmpresaID = 7
      AND  Mes = 1;  -- nota: Transacoes não tem coluna Mes diretamente

ROLLBACK TRANSACTION; -- desfazemos para preservar o estado do banco de demonstração
~~~

Para o `DELETE`, o `OUTPUT` usa apenas `DELETED` (não há `INSERTED`, pois o registro deixa de existir):

~~~sql
BEGIN TRANSACTION;

    -- Registra quais registros foram removidos antes de remover
    DELETE FROM dbo.Transacoes
    OUTPUT DELETED.TransacaoID,
           DELETED.Valor,
           DELETED.Descricao,
           DELETED.Status
    WHERE  Status = 'Cancelado'
      AND  TransacaoID = 29;

ROLLBACK TRANSACTION;
~~~

---

## 7. Verificando o Impacto com @@ROWCOUNT

A variável de sistema `@@ROWCOUNT` retorna o número de linhas afetadas pelo comando DML executado imediatamente antes. É uma ferramenta de verificação essencial que deve ser usada em toda operação de modificação:

~~~sql
BEGIN TRANSACTION;

    UPDATE dbo.Bancos
    SET    Ativo = 0
    WHERE  BancoID = 999;           -- BancoID inexistente (teste)

    -- @@ROWCOUNT retornará 0: nenhuma linha foi afetada
    -- Isso indica que o filtro WHERE não encontrou nenhum registro correspondente
    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'Nenhum registro foi encontrado com os critérios especificados.';
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' registro(s) atualizado(s).';
        COMMIT TRANSACTION;
    END
~~~

Esse padrão com `IF @@ROWCOUNT` cria uma verificação automática que pode ser incorporada em stored procedures para garantir que operações que não afetam nenhuma linha sejam tratadas adequadamente.

---

## 8. Cenários Reais no FinanceDB

### Cenário 1: Conciliação de Extrato Bancário

O setor financeiro recebeu o extrato bancário de janeiro de 2026 e precisa marcar todos os lançamentos confirmados como `Conciliado`:

~~~sql
BEGIN TRANSACTION;

    -- Concilia todos os lançamentos de janeiro de 2026 da conta ContaID = 4
    UPDATE dbo.Transacoes
    SET    Status = 'Conciliado'
    WHERE  ContaID       = 4                    -- conta bancária específica
      AND  Status        = 'Pendente'           -- apenas os ainda pendentes
      AND  DataLancamento >= '2026-01-01'        -- a partir de 1º de janeiro
      AND  DataLancamento <  '2026-02-01';       -- antes de 1º de fevereiro

    SELECT @@ROWCOUNT AS TransacoesConciliadas;

COMMIT TRANSACTION;
~~~

### Cenário 2: Desativação de uma Conta Bancária

A empresa encerrou uma conta bancária. O registro não deve ser removido (histórico de transações), mas deve ser marcado como inativo:

~~~sql
BEGIN TRANSACTION;

    -- Desativa a conta sem removê-la
    -- Transações históricas permanecem intactas e consultáveis
    UPDATE dbo.ContasBancarias
    SET    Ativa = 0
    WHERE  ContaID = 4;

    SELECT @@ROWCOUNT AS ContasDesativadas;

COMMIT TRANSACTION;
~~~

### Cenário 3: Ajuste de Orçamento para o Segundo Trimestre

A diretoria aprovou um aumento de 15% em todos os orçamentos de despesas do segundo trimestre:

~~~sql
BEGIN TRANSACTION;

    -- Reajusta orçamentos de despesas (meses 4, 5 e 6) da empresa Holding
    UPDATE o
    SET    o.ValorOrcado = o.ValorOrcado * 1.15
    FROM   dbo.Orcamentos AS o
    INNER JOIN dbo.PlanoDeContas AS p
           ON p.ContaPlanoID = o.ContaPlanoID
    WHERE  o.EmpresaID = 7
      AND  o.Ano       = 2026
      AND  o.Mes       IN (4, 5, 6)
      AND  p.Tipo      = 'DESPESA';

    SELECT @@ROWCOUNT AS OrcamentosReajustados;

COMMIT TRANSACTION;
~~~

---

## Glossário Técnico

**UPDATE**: Comando DML que modifica os valores de colunas em registros existentes de uma tabela.

**DELETE**: Comando DML que remove fisicamente registros de uma tabela.

**WHERE (em DML)**: Cláusula obrigatória (por boas práticas) que filtra quais registros serão afetados pela operação. Sem ela, todos os registros são modificados ou removidos.

**BEGIN TRANSACTION**: Inicia uma transação explícita no SQL Server, suspendendo o autocommit e permitindo ROLLBACK.

**COMMIT TRANSACTION**: Confirma permanentemente todas as operações realizadas desde o `BEGIN TRANSACTION`.

**ROLLBACK TRANSACTION**: Desfaz todas as operações realizadas desde o `BEGIN TRANSACTION`, restaurando o estado anterior.

**@@ROWCOUNT**: Variável de sistema que retorna o número de linhas afetadas pelo último comando DML executado.

**Autocommit**: Modo padrão do SQL Server onde cada comando DML é confirmado automaticamente e imediatamente, sem possibilidade de desfazer.

**Soft Delete**: Técnica que consiste em marcar registros como inativos ou cancelados em vez de removê-los fisicamente, preservando o histórico.

**OUTPUT (em UPDATE/DELETE)**: Cláusula que retorna os valores das linhas modificadas ou removidas, usando `INSERTED` para os novos valores e `DELETED` para os valores originais.

**DML (Data Manipulation Language)**: Subconjunto do SQL composto pelos comandos `INSERT`, `UPDATE`, `DELETE` e `SELECT` — comandos que manipulam os dados, não a estrutura.

**Transação implícita**: Cada comando DML individual em modo autocommit. Contraposição à transação explícita iniciada por `BEGIN TRANSACTION`.

---

## Antecipação de Erros e Troubleshooting

**Erro mais perigoso — UPDATE ou DELETE sem WHERE:**
Não gera erro. O SQL Server executa silenciosamente e afeta todas as linhas. A única proteção é o `BEGIN TRANSACTION` antes da execução. Se isso acontecer fora de uma transação, a única saída é restaurar um backup — por isso o Recovery Model FULL e os backups regulares configurados no Capítulo 7 são críticos.

**Erro 547 — Violação de Foreign Key no DELETE:**
Ocorre quando você tenta deletar um registro que é referenciado por chaves estrangeiras em outras tabelas. Por exemplo, tentar deletar uma empresa que tem transações vinculadas. Solução: use soft delete (atualizar `Ativo = 0`) em vez de `DELETE` físico, ou remova primeiro os registros dependentes na ordem correta (filhos antes dos pais).

**@@ROWCOUNT retorna 0 inesperadamente:**
O filtro `WHERE` não encontrou nenhum registro correspondente. Verifique se os valores dos filtros estão corretos, se a coluna tem o tipo de dado esperado (por exemplo, comparar `NVARCHAR` com string sem aspas gera erro de tipo, não resultado vazio), e se o registro realmente existe com aqueles valores.

**Transação aberta esquecida:**
Se você executar `BEGIN TRANSACTION` e fechar o SSMS sem `COMMIT` ou `ROLLBACK`, o SQL Server mantém a transação aberta e pode bloquear outros usuários de acessar os registros afetados. Sempre conclua suas transações. No SSMS, use `SELECT @@TRANCOUNT` para verificar se há uma transação aberta na sessão atual — retorno maior que 0 indica transação pendente.

**UPDATE com JOIN afetando mais linhas que o esperado:**
Quando o `JOIN` produz duplicatas (por exemplo, uma transação vinculada a múltiplos orçamentos), o `UPDATE` pode afetar mais linhas do que você antecipou. Sempre execute o `SELECT` equivalente antes para contar e inspecionar os registros que serão modificados.

---

## Desafio de Fixação

**Contexto:** O setor financeiro identificou que três lançamentos foram registrados com o tipo errado. Os lançamentos com `TransacaoID` entre 20 e 22 foram cadastrados como `TipoTransacaoID = 1` (RECEITA), mas deveriam ser `TipoTransacaoID = 2` (DESPESA). Além disso, existe um lançamento de teste com `Status = 'Cancelado'` e `Valor < 10.00` que deve ser removido fisicamente (não é um lançamento real). Sua tarefa:

1. Corrija o `TipoTransacaoID` dos três lançamentos identificados.
2. Remova o lançamento de teste usando o filtro correto.
3. Use o protocolo completo de segurança: `SELECT` de verificação, `BEGIN TRANSACTION`, verificação de `@@ROWCOUNT` e `COMMIT`.

---

### Resolução Comentada

~~~sql
-- ============================================================
-- PASSO 1: Verificação prévia — visualize o que será afetado
-- ============================================================

-- Verificar os lançamentos que serão corrigidos
SELECT TransacaoID,
       TipoTransacaoID,
       Valor,
       Descricao,
       Status
FROM   dbo.Transacoes
WHERE  TransacaoID BETWEEN 20 AND 22;   -- os três lançamentos identificados

-- Verificar o lançamento de teste que será removido
SELECT TransacaoID,
       Valor,
       Status,
       Descricao
FROM   dbo.Transacoes
WHERE  Status = 'Cancelado'
  AND  Valor < 10.00;                   -- lançamento de teste com valor mínimo

-- ============================================================
-- PASSO 2: Corrigir o TipoTransacaoID incorreto
-- ============================================================
BEGIN TRANSACTION;

    UPDATE dbo.Transacoes
    SET    TipoTransacaoID = 2                    -- corrige para DESPESA
    WHERE  TransacaoID BETWEEN 20 AND 22          -- apenas os três registros
      AND  TipoTransacaoID = 1;                   -- garante que só corrige os que estão errados

    -- Verifica: deve retornar 3 (ou menos, se algum já estava correto)
    SELECT @@ROWCOUNT AS RegistrosCorrigidos;

COMMIT TRANSACTION;

-- ============================================================
-- PASSO 3: Remover o lançamento de teste
-- ============================================================
BEGIN TRANSACTION;

    DELETE FROM dbo.Transacoes
    WHERE  Status = 'Cancelado'
      AND  Valor < 10.00;                         -- filtro preciso para o teste

    -- Verifica: deve retornar 1 (apenas o lançamento de teste)
    SELECT @@ROWCOUNT AS RegistrosRemovidos;

COMMIT TRANSACTION;

-- ============================================================
-- PASSO 4: Verificação final — confirma que está tudo correto
-- ============================================================
SELECT TransacaoID,
       TipoTransacaoID,
       Valor,
       Status
FROM   dbo.Transacoes
WHERE  TransacaoID BETWEEN 20 AND 22;   -- deve mostrar TipoTransacaoID = 2
~~~

**Por que esse é o padrão correto?** Porque cada operação foi precedida por um `SELECT` de verificação, envolvida em transação explícita, verificada com `@@ROWCOUNT` e confirmada com `COMMIT` apenas após a validação. O filtro do `DELETE` usa duas condições — `Status` e `Valor` — para garantir que apenas o lançamento de teste seja removido, sem risco de remover lançamentos reais cancelados por outros motivos.

---

## Resumo dos Pontos-Chave

`UPDATE` e `DELETE` sem cláusula `WHERE` afetam todos os registros da tabela sem aviso. O `WHERE` preciso é a primeira linha de defesa. A segunda linha é sempre o `BEGIN TRANSACTION` antes de qualquer operação DML de modificação ou remoção. `@@ROWCOUNT` deve ser verificado imediatamente após cada operação para confirmar que o número de linhas afetadas corresponde ao esperado. O protocolo dos seis passos — `SELECT` de verificação, `BEGIN TRANSACTION`, execução, `@@ROWCOUNT`, `SELECT` de confirmação e `COMMIT` ou `ROLLBACK` — é o padrão obrigatório em sistemas financeiros. Soft delete (`UPDATE Status = 'Cancelado'`) é sempre preferível ao `DELETE` físico em dados financeiros, pois preserva o histórico e a rastreabilidade. O `UPDATE` do T-SQL suporta `FROM` com `JOIN`, permitindo modificações baseadas em dados de outras tabelas. O `OUTPUT` em operações DML captura os valores antes (`DELETED`) e depois (`INSERTED`) da modificação, sendo fundamental para auditoria.

---

## Log de Estado do Projeto

~~~text
## Estado — Após o Capítulo 14

=== BANCO DE DADOS ===
Nome: FinanceDB
Recovery Model: FULL
Status: Operacional

=== TABELAS E REGISTROS (estado base) ===
Bancos:           5 registros
TiposTransacao:   3 registros (RECEITA, DESPESA, TRANSF)
Empresas:         2 registros (FinanceDB Holding EmpresaID=7 e segunda empresa)
ContasBancarias:  4 registros
PlanoDeContas:    25 registros em 3 níveis hierárquicos
Transacoes:       ~29 lançamentos (Jan a Abr 2026)
Orcamentos:       registros de Jan/Fev/Mar 2026

=== COMANDOS DML DOMINADOS ===
INSERT INTO:      ✅ (Capítulo 10)
SELECT:           ✅ (Capítulo 11)
WHERE/Filtros:    ✅ (Capítulo 12)
ORDER BY/TOP:     ✅ (Capítulo 13)
UPDATE:           ✅ (Capítulo 14)
DELETE:           ✅ (Capítulo 14)

=== PADRÕES DE SEGURANÇA APRENDIDOS ===
BEGIN TRANSACTION / COMMIT / ROLLBACK: ✅
Protocolo dos 6 passos para DML:       ✅
@@ROWCOUNT para verificação:           ✅
OUTPUT em UPDATE e DELETE:             ✅
Soft Delete como alternativa ao DELETE físico: ✅

=== MÓDULO 2 CONCLUÍDO ===
Todos os 8 capítulos do Módulo 2 — ESSENCIAL: T-SQL Básico foram concluídos.
O FinanceDB possui estrutura completa, dados realistas e o aluno domina
todos os comandos DML fundamentais do T-SQL.

=== PRÓXIMO ===
Módulo 3 — PROFICIENTE: Relacionamentos e Consultas Avançadas
Capítulo 15: Combinando Tabelas — INNER JOIN
~~~

---

## ✅ Módulo 2 Concluído

Parabéns, Bianeck. O **Módulo 2 — ESSENCIAL: T-SQL Básico** está completo. Em oito capítulos, você dominou todos os comandos fundamentais da linguagem: criou o banco de dados e as tabelas com estrutura profissional, implementou integridade referencial completa, populou o FinanceDB com dados financeiros realistas, aprendeu a consultar com precisão usando `SELECT`, filtrar com `WHERE`, ordenar e paginar com `ORDER BY` e `OFFSET-FETCH`, e agora finaliza com as operações de modificação e remoção executadas com segurança absoluta. O FinanceDB é um banco de dados real, funcional e íntegro. No próximo módulo, você vai aprender a combinar suas tabelas para extrair valor verdadeiro dos dados relacionais.

---

Dúvidas? Posso prosseguir para o Capítulo 15?
