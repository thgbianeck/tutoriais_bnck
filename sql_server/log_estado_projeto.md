## Estado — Após o Capítulo 19

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
Orcamentos:        registros por conta e período

=== MÓDULOS CONCLUÍDOS ===
✅ Módulo 1 — Fundamentos: Teoria e Ambiente (Capítulos 1–6)
✅ Módulo 2 — Essencial: T-SQL Básico (Capítulos 7–14)

=== CAPÍTULOS DO MÓDULO 3 ===
✅ Capítulo 15: INNER JOIN
✅ Capítulo 16: LEFT JOIN, RIGHT JOIN e FULL OUTER JOIN
✅ Capítulo 17: SELF JOIN — Auto-relacionamento e hierarquias
✅ Capítulo 18: Funções de Agregação — SUM, COUNT, AVG, MIN e MAX
✅ Capítulo 19: GROUP BY e HAVING — Agrupamento e filtragem de grupos
⬜ Capítulo 20: Funções de Data e Hora
⬜ Capítulo 21: Funções de Texto
⬜ Capítulo 22: Subconsultas

=== HABILIDADES ADQUIRIDAS NESTE CAPÍTULO ===
- GROUP BY para particionamento de resultados em grupos
- Regra de unicidade: toda coluna no SELECT fora de agregação vai no GROUP BY
- HAVING para filtrar grupos pelo resultado de funções de agregação
- Diferença fundamental: WHERE filtra linhas, HAVING filtra grupos
- Ordem lógica de processamento: FROM → WHERE → GROUP BY → Agregação → HAVING → SELECT → ORDER BY
- GROUP BY com expressões: YEAR(), MONTH() aplicados a colunas de data
- LEFT JOIN + GROUP BY para incluir categorias sem lançamentos
- ISNULL(SUM(...), 0) para tratar grupos sem registros correspondentes
- Condição no ON vs WHERE em LEFT JOINs agrupados
- DRE simplificado com SUM + CASE por natureza de transação
- Ranking com TOP + GROUP BY + ORDER BY
- Análise orçamentária: ValorOrcado vs ValorRealizado com percentual

=== PRÓXIMO ===
Capítulo 20: Funções de Data e Hora no T-SQL
Objetivo: manipular datas em lançamentos financeiros, vencimentos
e períodos usando GETDATE, DATEADD, DATEDIFF, YEAR, MONTH, DAY,
FORMAT e CONVERT, construindo consultas que filtram e calculam
intervalos de tempo em relatórios financeiros do FinanceDB