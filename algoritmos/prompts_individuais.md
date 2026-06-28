# Prompts Individuais — AlgoLab: Algoritmos do Básico ao Avançado com Python

Este documento contém os prompts detalhados para a geração de cada aula do curso. Cada prompt instrui o Tutor Sênior a gerar uma aula completa, com teoria, analogias, diagramas, código independente e autocontido, testes automatizados com pytest, glossário, antecipação de erros, exercícios e resumo, garantindo um mínimo de 2.000 palavras e o formato Markdown especificado.

---

## Módulo 1 — Essencial: Fundamentos de Algoritmos e Python

### Aula 01: O que é um Algoritmo? Pensamento Computacional e Lógica

**Prompt:**
"Gere a **Aula 01: O que é um Algoritmo? Pensamento Computacional e Lógica**, seguindo rigorosamente a estrutura completa de aula definida no plano do curso.
**Objetivo:** Entender o conceito de algoritmo, sequência lógica, entrada, processamento e saída, e dar os primeiros passos no pensamento computacional.
**Pré-requisitos:** Nenhum. Este é o ponto de partida absoluto do curso.
**Configuração do Ambiente:** Windows 11, VS Code, Python 3.13.x, pytest instalado via pip.
**Independência:** O código desta aula não depende de nenhuma aula anterior. Ele é completamente autocontido.
**Projeto Prático da Aula:** Implementar três funções simples que representam algoritmos do cotidiano: `fazer_sanduiche(ingredientes)` que recebe uma lista e retorna os passos para montar o sanduiche, `calcular_media(numeros)` que recebe uma lista de números e retorna a média, e `e_maior_de_idade(idade)` que recebe uma idade e retorna se a pessoa é maior de idade. Cada função deve demonstrar o conceito de entrada, processamento e saída.
**Testes:** Gere um arquivo `test_algoritmo_intro.py` com testes pytest para as três funções, cobrindo casos normais e casos extremos como lista vazia e idade zero.
**Log de Estado da Aula:**
- **Objetivo:** Implementar funções simples que ilustram o conceito de algoritmo.
- **Arquivo Principal:** `algoritmo_intro.py` com três funções autocontidas.
- **Arquivo de Testes:** `test_algoritmo_intro.py` com cobertura de todos os casos.
- **Estado Funcional:** ✅ Funções executam sem erros e todos os testes passam.
- **Próximas Etapas:** Aula 02 aprofundará variáveis, tipos de dados e operadores em Python.
**Instruções Específicas:**
- A analogia de ancoragem deve comparar um algoritmo a uma receita de bolo ou a instruções de montagem de móvel — passos precisos, ordenados e com resultado previsível.
- O diagrama Mermaid deve ilustrar o fluxo entrada → processamento → saída para o exemplo `calcular_media`.
- A seção de teoria deve explicar os quatro pilares do pensamento computacional: decomposição, reconhecimento de padrões, abstração e algoritmos.
- A antecipação de erros deve abordar a confusão entre algoritmo e código — o algoritmo existe antes do código e pode ser escrito em português estruturado (pseudocódigo) antes de ser implementado.
- O desafio de fixação deve pedir ao aluno que escreva em pseudocódigo (português puro, sem Python) um algoritmo para verificar se um número é par ou ímpar, antes de implementá-lo em Python."

---

### Aula 02: Variáveis, Tipos de Dados e Operadores em Python

**Prompt:**
"Gere a **Aula 02: Variáveis, Tipos de Dados e Operadores em Python**, seguindo rigorosamente a estrutura completa de aula definida no plano do curso.
**Objetivo:** Dominar os tipos de dados básicos do Python (`int`, `float`, `str`, `bool`), como declarar e usar variáveis, e aplicar operadores aritméticos, de comparação e lógicos.
**Pré-requisitos:** Aula 01 concluída (conceito de entrada, processamento e saída).
**Configuração do Ambiente:** Windows 11, VS Code, Python 3.13.x, pytest instalado via pip.
**Independência:** O código desta aula não depende de nenhuma aula anterior. Ele é completamente autocontido.
**Projeto Prático da Aula:** Implementar um arquivo `calculadora_basica.py` com funções que demonstram cada tipo de dado e operador: `somar(a, b)`, `dividir(a, b)`, `e_positivo(numero)`, `concatenar_nome(nome, sobrenome)` e `calcular_imc(peso, altura)`. Cada função deve receber parâmetros tipados, realizar uma operação simples e retornar o resultado.
**Testes:** Gere um arquivo `test_calculadora_basica.py` com testes pytest cobrindo divisão por zero, concatenação com strings vazias, IMC com altura zero e valores negativos.
**Log de Estado da Aula:**
- **Objetivo:** Implementar funções que demonstram o uso de tipos de dados e operadores.
- **Arquivo Principal:** `calculadora_basica.py` com cinco funções autocontidas.
- **Arquivo de Testes:** `test_calculadora_basica.py` com cobertura de casos normais e extremos.
- **Estado Funcional:** ✅ Funções executam sem erros e todos os testes passam.
- **Próximas Etapas:** Aula 03 ensinará estruturas de decisão para que o algoritmo possa escolher caminhos diferentes.
**Instruções Específicas:**
- A analogia de ancoragem deve comparar variáveis a caixas com etiquetas — cada caixa guarda um tipo específico de conteúdo e o tipo da caixa determina o que pode ser armazenado dentro dela.
- O diagrama Mermaid deve ilustrar os quatro tipos básicos (`int`, `float`, `str`, `bool`) com exemplos de valores para cada um.
- A teoria deve explicar a tipagem dinâmica do Python, o que significa que a variável não tem tipo fixo, mas o valor tem, e como verificar o tipo de uma variável com `type()`.
- A antecipação de erros deve cobrir a divisão inteira `//` versus divisão float `/`, a concatenação de `str` com `int` (que gera `TypeError`) e o uso de `=` (atribuição) versus `==` (comparação).
- O desafio de fixação deve pedir ao aluno que implemente uma função `converter_temperatura(celsius)` que converte Celsius para Fahrenheit e Kelvin, retornando os dois resultados."

---

### Aula 03: Estruturas de Decisão: if, elif e else

**Prompt:**
"Gere a **Aula 03: Estruturas de Decisão: if, elif e else**, seguindo rigorosamente a estrutura completa de aula definida no plano do curso.
**Objetivo:** Aprender a controlar o fluxo de execução de um algoritmo usando condicionais, permitindo que o programa tome decisões com base em condições.
**Pré-requisitos:** Aula 02 concluída (variáveis, tipos de dados e operadores de comparação).
**Configuração do Ambiente:** Windows 11, VS Code, Python 3.13.x, pytest instalado via pip.
**Independência:** O código desta aula não depende de nenhuma aula anterior. Ele é completamente autocontido.
**Projeto Prático da Aula:** Implementar um arquivo `classificador.py` com funções que tomam decisões: `classificar_nota(nota)` que retorna 'Aprovado', 'Recuperação' ou 'Reprovado', `classificar_idade(idade)` que retorna a faixa etária ('Criança', 'Adolescente', 'Adulto', 'Idoso'), `dia_e_util(dia_semana)` que retorna `True` ou `False`, e `calcular_desconto(valor, tipo_cliente)` que aplica descontos diferentes para clientes 'vip', 'regular' e 'novo'.
**Testes:** Gere um arquivo `test_classificador.py` com testes pytest cobrindo todos os ramos de cada função — cada `if`, `elif` e `else` deve ter pelo menos um teste correspondente.
**Log de Estado da Aula:**
- **Objetivo:** Implementar funções que tomam decisões baseadas em condições.
- **Arquivo Principal:** `classificador.py` com quatro funções de decisão autocontidas.
- **Arquivo de Testes:** `test_classificador.py` com cobertura de todos os ramos condicionais.
- **Estado Funcional:** ✅ Funções executam sem erros e todos os testes passam.
- **Próximas Etapas:** Aula 04 ensinará laços de repetição para executar operações múltiplas vezes.
**Instruções Específicas:**
- A analogia de ancoragem deve comparar o `if-elif-else` a um semáforo — dependendo da condição (cor da luz), o comportamento muda completamente.
- O diagrama Mermaid deve ser um flowchart que ilustra o fluxo de decisão da função `classificar_nota`, com os três ramos possíveis.
- A teoria deve explicar operadores de comparação (`==`, `!=`, `>`, `<`, `>=`, `<=`) e operadores lógicos (`and`, `or`, `not`), mostrando como combiná-los para criar condições compostas.
- A antecipação de erros deve cobrir o erro de indentação (`IndentationError`), o uso de `=` em vez de `==` dentro do `if`, e a ordem dos `elif` — uma condição mais específica deve vir antes de uma mais genérica.
- O desafio de fixação deve pedir ao aluno que implemente uma função `calcular_imposto(salario)` com faixas de tributação progressivas, usando `if-elif-else`."

---

### Aula 04: Estruturas de Repetição: for e while

**Prompt:**
"Gere a **Aula 04: Estruturas de Repetição: for e while**, seguindo rigorosamente a estrutura completa de aula definida no plano do curso.
**Objetivo:** Dominar os laços `for` e `while` para repetir operações de forma controlada, e entender as instruções `break`, `continue` e `range()`.
**Pré-requisitos:** Aula 03 concluída (estruturas de decisão).
**Configuração do Ambiente:** Windows 11, VS Code, Python 3.13.x, pytest instalado via pip.
**Independência:** O código desta aula não depende de nenhuma aula anterior. Ele é completamente autocontido.
**Projeto Prático da Aula:** Implementar um arquivo `repeticoes.py` com funções que demonstram laços: `somar_lista(numeros)` que usa `for` para somar todos os elementos, `contar_ate(limite)` que usa `while` para contar de 1 até o limite retornando uma lista, `encontrar_primeiro_par(numeros)` que usa `for` com `break` para retornar o primeiro número par da lista, e `filtrar_positivos(numeros)` que usa `for` com `continue` para retornar apenas os números positivos.
**Testes:** Gere um arquivo `test_repeticoes.py` com testes pytest cobrindo listas vazias, listas com um elemento, listas sem nenhum elemento par e limites zero e negativos.
**Log de Estado da Aula:**
- **Objetivo:** Implementar funções que utilizam laços de repetição para processar coleções de dados.
- **Arquivo Principal:** `repeticoes.py` com quatro funções autocontidas.
- **Arquivo de Testes:** `test_repeticoes.py` com cobertura de casos normais e extremos.
- **Estado Funcional:** ✅ Funções executam sem erros e todos os testes passam.
- **Próximas Etapas:** Aula 05 ensinará como organizar algoritmos em funções reutilizáveis.
**Instruções Específicas:**
- A analogia de ancoragem deve comparar o `for` a um garçom que serve cada mesa da fila até acabar, e o `while` a um segurança que fica na porta enquanto a festa não terminar.
- O diagrama Mermaid deve ilustrar em paralelo o fluxo do `for` (número fixo de iterações) e do `while` (condição de parada), destacando onde `break` e `continue` atuam.
- A teoria deve explicar `range(start, stop, step)` com exemplos de contagem regressiva, e a diferença fundamental entre `for` (iterar sobre uma sequência) e `while` (repetir enquanto uma condição for verdadeira).
- A antecipação de erros deve cobrir laços infinitos no `while` (esquecer de atualizar a condição de parada) e o erro `off-by-one` — iterar uma vez a mais ou a menos.
- O desafio de fixação deve pedir ao aluno que implemente uma função `tabuada(numero)` que retorna uma lista com os dez primeiros múltiplos do número recebido."

---

### Aula 05: Funções: Reutilizando e Organizando Algoritmos

**Prompt:**
"Gere a **Aula 05: Funções: Reutilizando e Organizando Algoritmos**, seguindo rigorosamente a estrutura completa de aula definida no plano do curso.
**Objetivo:** Aprender a definir e chamar funções em Python, entender parâmetros, argumentos, valores padrão, retorno múltiplo e o conceito de escopo de variáveis.
**Pré-requisitos:** Aula 04 concluída (laços de repetição).
**Configuração do Ambiente:** Windows 11, VS Code, Python 3.13.x, pytest instalado via pip.
**Independência:** O código desta aula não depende de nenhuma aula anterior. Ele é completamente autocontido.
**Projeto Prático da Aula:** Implementar um arquivo `funcoes_uteis.py` com funções que demonstram os conceitos: `saudar(nome, saudacao='Olá')` com parâmetro padrão, `calcular_estatisticas(numeros)` que retorna múltiplos valores (mínimo, máximo, média), `e_primo(numero)` que implementa a verificação de número primo encapsulada em uma função, e `aplicar_operacao(numero, operacao)` que recebe uma função como argumento e a aplica ao número.
**Testes:** Gere um arquivo `test_funcoes_uteis.py` com testes pytest cobrindo saudação com e sem parâmetro padrão, estatísticas com lista de um elemento, verificação de primos conhecidos (2, 3, 17) e não primos (4, 9, 25), e aplicação de operações.
**Log de Estado da Aula:**
- **Objetivo:** Implementar funções que demonstram parâmetros, retorno múltiplo e funções como argumentos.
- **Arquivo Principal:** `funcoes_uteis.py` com quatro funções autocontidas.
- **Arquivo de Testes:** `test_funcoes_uteis.py` com cobertura de todos os comportamentos.
- **Estado Funcional:** ✅ Funções executam sem erros e todos os testes passam.
- **Próximas Etapas:** Aula 06 ensinará listas como estrutura de dados fundamental para algoritmos.
**Instruções Específicas:**
- A analogia de ancoragem deve comparar uma função a uma máquina de café — você coloca o insumo (parâmetros), aperta o botão (chamada) e recebe o resultado (retorno), sem precisar saber o que acontece dentro.
- O diagrama Mermaid deve ilustrar o fluxo de chamada de função com escopo local versus escopo global, mostrando onde as variáveis vivem.
- A teoria deve explicar a diferença entre parâmetro (na definição da função) e argumento (na chamada), e o conceito de escopo — variáveis criadas dentro da função não existem fora dela.
- A antecipação de erros deve cobrir o erro de chamar uma função antes de defini-la, retornar `None` por esquecer o `return`, e a mutabilidade de listas passadas como argumento.
- O desafio de fixação deve pedir ao aluno que implemente uma função `contar_vogais(texto)` que recebe uma string e retorna quantas vogais ela contém, usando as funções aprendidas."

---

### Aula 06: Listas em Python: Armazenando e Manipulando Coleções

**Prompt:**
"Gere a **Aula 06: Listas em Python: Armazenando e Manipulando Coleções**, seguindo rigorosamente a estrutura completa de aula definida no plano do curso.
**Objetivo:** Dominar listas como estrutura de dados fundamental — criação, acesso por índice, fatiamento (slicing), métodos de lista e iteração — como base para implementar algoritmos de busca e ordenação nas próximas aulas.
**Pré-requisitos:** Aulas 04 e 05 concluídas (laços e funções).
**Configuração do Ambiente:** Windows 11, VS Code, Python 3.13.x, pytest instalado via pip.
**Independência:** O código desta aula não depende de nenhuma aula anterior. Ele é completamente autocontido.
**Projeto Prático da Aula:** Implementar um arquivo `manipulador_listas.py` com funções que operam sobre listas: `inverter_lista(lista)` sem usar `reverse()` — implementar manualmente com laço, `remover_duplicatas(lista)` preservando a ordem original, `mesclar_listas(lista_a, lista_b)` que une duas listas sem duplicatas, e `rotacionar(lista, k)` que rotaciona a lista `k` posições para a direita.
**Testes:** Gere um arquivo `test_manipulador_listas.py` com testes pytest cobrindo listas vazias, listas com um elemento, listas já ordenadas, duplicatas consecutivas e intercaladas, e rotações maiores que o tamanho da lista.
**Log de Estado da Aula:**
- **Objetivo:** Implementar funções de manipulação de listas sem depender de métodos prontos do Python.
- **Arquivo Principal:** `manipulador_listas.py` com quatro funções autocontidas.
- **Arquivo de Testes:** `test_manipulador_listas.py` com cobertura extensa de casos extremos.
- **Estado Funcional:** ✅ Funções executam sem erros e todos os testes passam.
- **Próximas Etapas:** Aula 07 abordará strings como sequências, aplicando lógica algorítmica sobre texto.
**Instruções Específicas:**
- A analogia de ancoragem deve comparar uma lista Python a uma prateleira numerada — cada item tem uma posição (índice), você pode pegar qualquer item pelo número da posição, e pode expandir a prateleira dinamicamente.
- O diagrama Mermaid deve ilustrar o conceito de índice positivo e negativo em uma lista, e o funcionamento do fatiamento `lista[inicio:fim:passo]`.
- A teoria deve cobrir mutabilidade de listas (diferença de `list.copy()` versus atribuição direta), e os métodos mais importantes: `append`, `insert`, `remove`, `pop`, `index`, `count` e `len()`.
- A antecipação de erros deve cobrir `IndexError` (acesso fora dos limites), a armadilha de copiar listas com `lista_b = lista_a` (cópia rasa versus profunda) e a diferença entre `remove()` (remove por valor) e `pop()` (remove por índice).
- O desafio de fixação deve pedir ao aluno que implemente uma função `achatar_lista(lista_aninhada)` que recebe uma lista de listas e retorna uma única lista plana com todos os elementos."

---

### Aula 07: Strings como Sequências: Algoritmos sobre Texto

**Prompt:**
"Gere a **Aula 07: Strings como Sequências: Algoritmos sobre Texto**, seguindo rigorosamente a estrutura completa de aula definida no plano do curso.
**Objetivo:** Tratar strings como sequências de caracteres e aplicar lógica algorítmica sobre texto — verificação de palíndromos, anagramas, contagem de caracteres e manipulação de padrões.
**Pré-requisitos:** Aula 06 concluída (listas e sequências).
**Configuração do Ambiente:** Windows 11, VS Code, Python 3.13.x, pytest instalado via pip.
**Independência:** O código desta aula não depende de nenhuma aula anterior. Ele é completamente autocontido.
**Projeto Prático da Aula:** Implementar um arquivo `algoritmos_texto.py` com funções clássicas sobre strings: `e_palindromo(texto)` que verifica se a string é igual ao inverso (ignorando espaços e maiúsculas/minúsculas), `e_anagrama(texto_a, texto_b)` que verifica se dois textos são anagramas, `contar_caracteres(texto)` que retorna um dicionário com a frequência de cada caractere, e `comprimir_string(texto)` que comprime sequências repetidas ('aaabbc' → 'a3b2c1').
**Testes:** Gere um arquivo `test_algoritmos_texto.py` com testes pytest cobrindo palíndromos com espaços e maiúsculas ('A mim', 'Racecar'), não palíndromos, anagramas clássicos ('amor'/'roma'), strings vazias e strings com um caractere.
**Log de Estado da Aula:**
- **Objetivo:** Implementar algoritmos clássicos sobre strings.
- **Arquivo Principal:** `algoritmos_texto.py` com quatro funções autocontidas.
- **Arquivo de Testes:** `test_algoritmos_texto.py` com cobertura de casos clássicos e extremos.
- **Estado Funcional:** ✅ Funções executam sem erros e todos os testes passam.
- **Próximas Etapas:** Módulo 2 começa com busca linear — o primeiro algoritmo formal do curso.
**Instruções Específicas:**
- A analogia de ancoragem deve comparar uma string a um colar de contas — cada conta é um caractere, tem uma posição e pode ser acessada individualmente, e o colar inteiro é imutável (não dá para trocar uma conta, apenas criar um colar novo).
- O diagrama Mermaid deve ilustrar o algoritmo de verificação de palíndromo com dois ponteiros — um no início e um no fim, avançando para o centro.
- A teoria deve explicar imutabilidade de strings em Python, os métodos mais usados (`strip`, `split`, `join`, `replace`, `lower`, `upper`, `find`) e como iterar sobre caracteres de uma string com `for`.
- A antecipação de erros deve cobrir a tentativa de modificar um caractere da string por índice (`TypeError: 'str' object does not support item assignment`) e a diferença entre `find()` (retorna -1 se não encontrar) e `index()` (lança exceção se não encontrar).
- O desafio de fixação deve pedir ao aluno que implemente uma função `contar_palavras(frase)` que retorna um dicionário com a frequência de cada palavra na frase, ignorando maiúsculas e pontuação."

---

## Módulo 2 — Proficiente: Algoritmos de Busca e Ordenação

### Aula 08: Busca Linear: Encontrando Elementos um a um

**Prompt:**
"Gere a **Aula 08: Busca Linear: Encontrando Elementos um a um**, seguindo rigorosamente a estrutura completa de aula definida no plano do curso.
**Objetivo:** Implementar o algoritmo de busca linear, entender sua lógica, analisar seu comportamento em diferentes cenários e compreender por que é o ponto de partida de qualquer estudo de algoritmos de busca.
**Pré-requisitos:** Módulo 1 concluído — especialmente listas (Aula 06) e funções (Aula 05).
**Configuração do Ambiente:** Windows 11, VS Code, Python 3.13.x, pytest instalado via pip.
**Independência:** O código desta aula não depende de nenhuma aula anterior. Ele é completamente autocontido.
**Projeto Prático da Aula:** Implementar um arquivo `busca_linear.py` com as seguintes funções: `busca_linear(lista, alvo)` que retorna o índice do alvo ou -1 se não encontrado, `busca_linear_todos(lista, alvo)` que retorna uma lista com todos os índices onde o alvo aparece, e `busca_linear_maior(lista)` que encontra o maior elemento sem usar `max()` — implementando manualmente a lógica de comparação.
**Testes:** Gere um arquivo `test_busca_linear.py` com testes pytest cobrindo: alvo no início, alvo no final, alvo no meio, alvo não presente, lista vazia, lista com um elemento, lista com duplicatas e busca do maior em lista com todos os elementos iguais.
**Log de Estado da Aula:**
- **Objetivo:** Implementar busca linear em suas três variações.
- **Arquivo Principal:** `busca_linear.py` com três funções autocontidas.
- **Arquivo de Testes:** `test_busca_linear.py` com cobertura de todos os casos relevantes.
- **Estado Funcional:** ✅ Funções executam sem erros e todos os testes passam.
- **Próximas Etapas:** Aula 09 apresentará busca binária — muito mais eficiente, mas com uma pré-condição importante.
**Instruções Específicas:**
- A analogia de ancoragem deve comparar a busca linear a procurar uma chave em uma gaveta bagunçada — você abre item por item, da esquerda para a direita, até encontrar ou chegar ao fim.
- O diagrama Mermaid deve ser um flowchart da busca linear mostrando cada passo: pegar elemento, comparar com alvo, retornar índice se igual, avançar para o próximo, retornar -1 se chegar ao fim.
- A teoria deve introduzir informalmente o conceito de complexidade: no melhor caso o alvo está na primeira posição, no pior caso está na última ou não está — isso significa que o tempo de execução cresce com o tamanho da lista.
- A antecipação de erros deve cobrir a confusão entre o índice retornado e o valor encontrado, e o retorno de `False` versus `-1` para indicar 'não encontrado' (por que `-1` é mais informativo que `False`).
- O desafio de fixação deve pedir ao aluno que implemente uma função `busca_linear_sentinela(lista, alvo)` que usa a técnica da sentinela — adicionar o alvo ao final da lista antes de buscar — e explicar como essa técnica simplifica o código removendo uma comparação do laço."

---

### Aula 09: Busca Binária: Dividindo para Encontrar Mais Rápido

**Prompt:**
"Gere a **Aula 09: Busca Binária: Dividindo para Encontrar Mais Rápido**, seguindo rigorosamente a estrutura completa de aula definida no plano do curso.
**Objetivo:** Implementar o algoritmo de busca binária, entender a pré-condição de lista ordenada, compreender por que dividir ao meio é muito mais eficiente do que verificar elemento a elemento, e comparar visualmente com a busca linear.
**Pré-requisitos:** Aula 08 (busca linear) — lógica de busca e retorno de índice.
**Configuração do Ambiente:** Windows 11, VS Code, Python 3.13.x, pytest instalado via pip.
**Independência:** O código desta aula não depende de nenhuma aula anterior. Ele é completamente autocontido.
**Projeto Prático da Aula:** Implementar um arquivo `busca_binaria.py` com: `busca_binaria(lista, alvo)` que implementa a versão iterativa retornando o índice ou -1, `busca_binaria_recursiva(lista, alvo, inicio, fim)` que implementa a versão recursiva, e `contar_passos_busca(lista, alvo)` que retorna quantas comparações foram necessárias para encontrar o alvo (comparando busca linear versus binária).
**Testes:** Gere um arquivo `test_busca_binaria.py` com testes pytest cobrindo: alvo no início, alvo no final, alvo no meio, alvo não presente, lista com um elemento, lista com número par e ímpar de elementos, e verificação de que a versão iterativa e recursiva retornam o mesmo resultado para os mesmos inputs.
**Log de Estado da Aula:**
- **Objetivo:** Implementar busca binária iterativa e recursiva com comparação de passos.
- **Arquivo Principal:** `busca_binaria.py` com três funções autocontidas.
- **Arquivo de Testes:** `test_busca_binaria.py` com cobertura de todos os casos relevantes.
- **Estado Funcional:** ✅ Funções executam sem erros e todos os testes passam.
- **Próximas Etapas:** Aula 10 inicia os algoritmos de ordenação com o Bubble Sort.
**Instruções Específicas:**
- A analogia de ancoragem deve comparar a busca binária a procurar uma palavra no dicionário — você abre no meio, verifica se a palavra está antes ou depois, descarta metade e repete, chegando ao resultado em pouquíssimas tentativas.
- O diagrama Mermaid deve ilustrar passo a passo a busca binária do número 37 em uma lista de 10 elementos ordenados, mostrando como o espaço de busca é reduzido à metade a cada iteração.
- A teoria deve introduzir informalmente a ideia de logaritmo: uma lista de 1.000 elementos exige no máximo 10 comparações na busca binária, enquanto a busca linear pode exigir 1.000 — e explicar por que isso é revolucionário.
- A antecipação de erros deve cobrir o erro mais clássico da busca binária: aplicá-la em uma lista não ordenada, gerando resultados incorretos sem erro de execução.
- O desafio de fixação deve pedir ao aluno que implemente uma função `encontrar_ponto_de_insercao(lista, valor)` que, dado um valor que não está na lista ordenada, retorna o índice onde ele deveria ser inserido para manter a ordem."

---

### Aula 10: Bubble Sort: Ordenação por Troca de Vizinhos

**Prompt:**
"Gere a **Aula 10: Bubble Sort: Ordenação por Troca de Vizinhos**, seguindo rigorosamente a estrutura completa de aula definida no plano do curso.
**Objetivo:** Implementar o Bubble Sort, entender a lógica de comparação de vizinhos e troca, e compreender por que, apesar de simples, ele não é eficiente para listas grandes.
**Pré-requisitos:** Aula 06 (listas) e Aula 04 (laços de repetição).
**Configuração do Ambiente:** Windows 11, VS Code, Python 3.13.x, pytest instalado via pip.
**Independência:** O código desta aula não depende de nenhuma aula anterior. Ele é completamente autocontido.
**Projeto Prático da Aula:** Implementar um arquivo `bubble_sort.py` com: `bubble_sort(lista)` que retorna a lista ordenada sem modificar a original, `bubble_sort_otimizado(lista)` que inclui a otimização de parar cedo quando nenhuma troca ocorre em uma passagem, e `contar_trocas(lista)` que retorna quantas trocas foram necessárias para ordenar a lista.
**Testes:** Gere um arquivo `test_bubble_sort.py` com testes pytest cobrindo: lista já ordenada (deve fazer zero trocas na versão otimizada), lista em ordem decrescente (pior caso), lista com um elemento, lista vazia, lista com elementos repetidos, e verificação de que a função não modifica a lista original.
**Log de Estado da Aula:**
- **Objetivo:** Implementar Bubble Sort em versão básica e otimizada com contagem de trocas.
- **Arquivo Principal:** `bubble_sort.py` com três funções autocontidas.
- **Arquivo de Testes:** `test_bubble_sort.py` com cobertura de casos normais, extremos e verificação de imutabilidade.
- **Estado Funcional:** ✅ Funções executam sem erros e todos os testes passam.
- **Próximas Etapas:** Aula 11 apresentará o Selection Sort — uma abordagem diferente de ordenação.
**Instruções Específicas:**
- A analogia de ancoragem deve comparar o Bubble Sort a organizar alunos por altura em fila — você percorre a fila comparando dois alunos vizinhos e trocando de posição quando necessário, e repete isso várias vezes até que todos estejam na ordem certa.
- O diagrama Mermaid deve mostrar uma simulação passo a passo do Bubble Sort em uma lista de cinco elementos, indicando quais pares são comparados e quando ocorre uma troca.
- A teoria deve explicar intuitivamente por que são necessárias n-1 passagens no pior caso e por que a otimização de parar cedo melhora o caso médio sem mudar o pior caso.
- A antecipação de erros deve cobrir a modificação da lista original (por que criar uma cópia com `lista[:]` no início da função é importante) e a confusão entre `lista[i]` e `lista[i+1]` ao realizar a troca.
- O desafio de fixação deve pedir ao aluno que implemente o Bubble Sort em ordem decrescente e que crie uma função `bubble_sort_strings(lista)` que ordena uma lista de strings alfabeticamente."

---

### Aula 11: Selection Sort: Encontrando o Mínimo Repetidamente

**Prompt:**
"Gere a **Aula 11: Selection Sort: Encontrando o Mínimo Repetidamente**, seguindo rigorosamente a estrutura completa de aula definida no plano do curso.
**Objetivo:** Implementar o Selection Sort, entender a lógica de encontrar o mínimo e colocá-lo na posição correta, e comparar sua abordagem com o Bubble Sort.
**Pré-requisitos:** Aula 06 (listas) e Aula 08 (lógica de encontrar o mínimo com busca linear).
**Configuração do Ambiente:** Windows 11, VS Code, Python 3.13.x, pytest instalado via pip.
**Independência:** O código desta aula não depende de nenhuma aula anterior. Ele é completamente autocontido.
**Projeto Prático da Aula:** Implementar um arquivo `selection_sort.py` com: `encontrar_indice_minimo(lista, inicio)` que retorna o índice do menor elemento a partir da posição `inicio`, `selection_sort(lista)` que usa a função anterior para ordenar a lista sem modificar a original, e `selection_sort_com_log(lista)` que retorna uma lista de strings descrevendo cada passo da ordenação.
**Testes:** Gere um arquivo `test_selection_sort.py` com testes pytest cobrindo: lista já ordenada, lista em ordem decrescente, lista com elementos repetidos, lista com um elemento, lista vazia, verificação de que a lista original não é modificada, e verificação de que o log da versão com log tem exatamente n-1 entradas para uma lista de n elementos.
**Log de Estado da Aula:**
- **Objetivo:** Implementar Selection Sort com função auxiliar de mínimo e versão com log de passos.
- **Arquivo Principal:** `selection_sort.py` com três funções autocontidas.
- **Arquivo de Testes:** `test_selection_sort.py` com cobertura de casos normais, extremos e verificação de comportamento interno.
- **Estado Funcional:** ✅ Funções executam sem erros e todos os testes passam.
- **Próximas Etapas:** Aula 12 apresentará o Insertion Sort — ordenação que funciona como organizar cartas na mão.
**Instruções Específicas:**
- A analogia de ancoragem deve comparar o Selection Sort a organizar cartas em uma mesa — você varre todas as cartas, pega a menor, coloca na primeira posição, varre o restante, pega a menor dentre elas, coloca na segunda posição, e assim por diante.
- O diagrama Mermaid deve mostrar uma simulação passo a passo do Selection Sort em uma lista de cinco elementos, destacando a parte já ordenada (à esquerda) e a parte não ordenada (à direita) a cada iteração.
- A teoria deve comparar o número de trocas do Selection Sort (no máximo n-1) com o Bubble Sort (pode ser muito mais), e explicar por que o Selection Sort faz menos trocas mas o mesmo número de comparações.
- A antecipação de erros deve cobrir a troca com o próprio elemento (quando o mínimo já está na posição correta) e a importância de atualizar o índice do mínimo, não o valor.
- O desafio de fixação deve pedir ao aluno que implemente o Selection Sort para ordenar uma lista de tuplas `(nome, nota)` pelo valor da nota, em ordem decrescente."

---

### Aula 12: Insertion Sort: Organizando como um Baralho de Cartas

**Prompt:**
"Gere a **Aula 12: Insertion Sort: Organizando como um Baralho de Cartas**, seguindo rigorosamente a estrutura completa de aula definida no plano do curso.
**Objetivo:** Implementar o Insertion Sort, entender a lógica de inserir cada elemento na posição correta dentro da parte já ordenada, e reconhecer por que este algoritmo é eficiente para listas quase ordenadas.
**Pré-requisitos:** Aula 06 (listas) e Aula 04 (laços de repetição).
**Configuração do Ambiente:** Windows 11, VS Code, Python 3.13.x, pytest instalado via pip.
**Independência:** O código desta aula não depende de nenhuma aula anterior. Ele é completamente autocontido.
**Projeto Prático da Aula:** Implementar um arquivo `insertion_sort.py` com: `insertion_sort(lista)` que retorna a lista ordenada sem modificar a original, `insertion_sort_com_log(lista)` que retorna uma lista com o estado da lista após cada inserção, e `quase_ordenado(lista)` que detecta se uma lista está quase ordenada (menos de 10% dos elementos fora do lugar).
**Testes:** Gere um arquivo `test_insertion_sort.py` com testes pytest cobrindo: lista já ordenada (deve fazer zero movimentos), lista em ordem decrescente, lista quase ordenada com um elemento fora de lugar, lista com um elemento, lista vazia, elementos repetidos, e verificação de que a lista original não é modificada.
**Log de Estado da Aula:**
- **Objetivo:** Implementar Insertion Sort com versão de log e detector de lista quase ordenada.
- **Arquivo Principal:** `insertion_sort.py` com três funções autocontidas.
- **Arquivo de Testes:** `test_insertion_sort.py` com cobertura de casos normais, extremos e casos ótimos.
- **Estado Funcional:** ✅ Funções executam sem erros e todos os testes passam.
- **Próximas Etapas:** Aula 13 apresentará o Merge Sort — um salto de complexidade em direção à ordenação eficiente.
**Instruções Específicas:**
- A analogia de ancoragem deve comparar o Insertion Sort a organizar cartas recebidas uma a uma — cada carta nova é inserida na posição correta entre as cartas já organizadas na mão, deslocando as maiores para a direita.
- O diagrama Mermaid deve mostrar uma simulação passo a passo do Insertion Sort em uma lista de cinco elementos, destacando a carta sendo inserida e os elementos sendo deslocados para a direita.
- A teoria deve explicar por que o Insertion Sort é O(n) no melhor caso (lista já ordenada) — um fato que o distingue positivamente do Bubble Sort e do Selection Sort — e por que isso o torna uma boa escolha para listas quase ordenadas.
- A antecipação de erros deve cobrir a confusão entre deslocar elementos para a direita (mover cada um uma posição) versus trocar pares, e o risco de `IndexError` ao acessar `lista[j-1]` quando `j` é zero.
- O desafio de fixação deve pedir ao aluno que implemente uma função `insertion_sort_binario(lista)` que usa busca binária para encontrar a posição de inserção de cada elemento — uma otimização que reduz o número de comparações, mas não o número de movimentos."

---

### Aula 13: Merge Sort: Dividir, Ordenar e Combinar

**Prompt:**
"Gere a **Aula 13: Merge Sort: Dividir, Ordenar e Combinar**, seguindo rigorosamente a estrutura completa de aula definida no plano do curso.
**Objetivo:** Implementar o Merge Sort usando o paradigma Dividir e Conquistar, entender como a recursão permite resolver o problema de ordenação de forma elegante e eficiente.
**Pré-requisitos:** Aula 06 (listas) e Aula 05 (funções) — a recursão será introduzida aqui de forma gradual antes da aula formal de Recursão.
**Configuração do Ambiente:** Windows 11, VS Code, Python 3.13.x, pytest instalado via pip.
**Independência:** O código desta aula não depende de nenhuma aula anterior. Ele é completamente autocontido.
**Projeto Prático da Aula:** Implementar um arquivo `merge_sort.py` com: `mesclar(esquerda, direita)` que combina duas listas ordenadas em uma única lista ordenada (a função mais importante — implementar e testar separadamente), `merge_sort(lista)` que usa `mesclar` e recursão para ordenar a lista completa, e `mesclar_multiplas(listas)` que recebe uma lista de listas já ordenadas e as combina em uma única lista ordenada.
**Testes:** Gere um arquivo `test_merge_sort.py` com testes pytest cobrindo: mesclar duas listas vazias, mesclar lista vazia com lista não vazia, mesclar listas de tamanhos diferentes, ordenar lista vazia, lista com um elemento, lista com elementos repetidos, lista em ordem decrescente, e verificação de que a lista original não é modificada.
**Log de Estado da Aula:**
- **Objetivo:** Implementar a função de mesclagem e o Merge Sort completo com recursão.
- **Arquivo Principal:** `merge_sort.py` com três funções autocontidas.
- **Arquivo de Testes:** `test_merge_sort.py` com cobertura extensiva, especialmente da função `mesclar`.
- **Estado Funcional:** ✅ Funções executam sem erros e todos os testes passam.
- **Próximas Etapas:** Aula 14 apresentará o Quick Sort — outro algoritmo eficiente com uma abordagem completamente diferente.
**Instruções Específicas:**
- A analogia de ancoragem deve comparar o Merge Sort a organizar uma baralho enorme pedindo ajuda — você divide o baralho ao meio, pede para um amigo ordenar uma metade e você ordena a outra, depois vocês dois combinam as duas metades em ordem — e cada amigo pode chamar outros amigos para ajudar com suas metades.
- O diagrama Mermaid deve mostrar a árvore de recursão do Merge Sort para uma lista de oito elementos: a divisão descendo até listas de um elemento, e a mesclagem subindo até a lista ordenada completa.
- A teoria deve introduzir o paradigma Dividir e Conquistar de forma clara: dividir o problema em subproblemas menores, resolver cada subproblema (recursivamente), e combinar as soluções — e mostrar por que isso garante O(n log n) no pior caso.
- A antecipação de erros deve cobrir o caso base da recursão (lista com zero ou um elemento já está ordenada) e o que acontece se o caso base for esquecido — recursão infinita e `RecursionError`.
- O desafio de fixação deve pedir ao aluno que implemente uma função `merge_sort_decrescente(lista)` que ordena em ordem decrescente modificando apenas a comparação dentro da função `mesclar`."

---

### Aula 14: Quick Sort: O Algoritmo do Pivô

**Prompt:**
"Gere a **Aula 14: Quick Sort: O Algoritmo do Pivô**, seguindo rigorosamente a estrutura completa de aula definida no plano do curso.
**Objetivo:** Implementar o Quick Sort, entender a lógica de particionamento em torno de um pivô, e compreender por que é um dos algoritmos de ordenação mais usados na prática.
**Pré-requisitos:** Aula 06 (listas) e Aula 13 (conceito de Dividir e Conquistar).
**Configuração do Ambiente:** Windows 11, VS Code, Python 3.13.x, pytest instalado via pip.
**Independência:** O código desta aula não depende de nenhuma aula anterior. Ele é completamente autocontido.
**Projeto Prático da Aula:** Implementar um arquivo `quick_sort.py` com: `quick_sort_simples(lista)` usando a versão Pythonica com list comprehension (didática e clara), `particionar(lista, inicio, fim)` que implementa o esquema de particionamento in-place de Lomuto, `quick_sort_inplace(lista, inicio, fim)` que usa `particionar` para ordenar a lista sem criar novas listas, e `escolher_pivo_mediana(lista, inicio, fim)` que escolhe o pivô como a mediana de três elementos.
**Testes:** Gere um arquivo `test_quick_sort.py` com testes pytest cobrindo: lista vazia, lista com um elemento, lista já ordenada, lista em ordem decrescente, lista com todos os elementos iguais, lista com dois elementos, e verificação de que ambas as versões (`simples` e `inplace`) produzem o mesmo resultado.
**Log de Estado da Aula:**
- **Objetivo:** Implementar Quick Sort em versão didática e versão in-place eficiente.
- **Arquivo Principal:** `quick_sort.py` com quatro funções autocontidas.
- **Arquivo de Testes:** `test_quick_sort.py` com cobertura de casos normais, extremos e comparação entre versões.
- **Estado Funcional:** ✅ Funções executam sem erros e todos os testes passam.
- **Próximas Etapas:** Módulo 3 começa com Pilhas — primeira estrutura de dados formal do curso.
**Instruções Específicas:**
- A analogia de ancoragem deve comparar o Quick Sort a organizar estudantes por altura escolhendo um aluno de referência (pivô) — todos os mais baixos vão para a esquerda, todos os mais altos para a direita, e depois você repete o processo em cada grupo.
- O diagrama Mermaid deve ilustrar o particionamento de uma lista de seis elementos em torno de um pivô, mostrando os elementos menores à esquerda e maiores à direita após a partição.
- A teoria deve explicar a escolha do pivô como ponto crítico — um pivô ruim (sempre o menor ou maior elemento) degrada o Quick Sort para O(n²), enquanto um pivô mediano garante O(n log n) — e por que a versão in-place usa muito menos memória que o Merge Sort.
- A antecipação de erros deve cobrir `RecursionError` para listas grandes com pivô ruim e a diferença entre a versão simples (cria novas listas) e a versão in-place (modifica a lista original — cuidado com os testes).
- O desafio de fixação deve pedir ao aluno que implemente uma função `ordenar_por_chave(lista_de_tuplas, indice_chave)` que usa Quick Sort para ordenar uma lista de tuplas com base em um índice específico — por exemplo, ordenar `[('Ana', 25), ('Carlos', 18), ('Bia', 30)]` pela idade."

---

## Módulo 3 — Avançado: Estruturas de Dados e Algoritmos Sobre Elas

### Aula 15: Pilhas (Stacks): O Princípio LIFO na Prática

**Prompt:**
"Gere a **Aula 15: Pilhas (Stacks): O Princípio LIFO na Prática**, seguindo rigorosamente a estrutura completa de aula definida no plano do curso.
**Objetivo:** Entender o conceito de Pilha (Last In, First Out), implementar uma Pilha do zero usando lista Python, e resolver problemas clássicos que exigem comportamento LIFO.
**Pré-requisitos:** Aula 06 (listas) e Aula 05 (funções e classes simples).
**Configuração do Ambiente:** Windows 11, VS Code, Python 3.13.x, pytest instalado via pip.
**Independência:** O código desta aula não depende de nenhuma aula anterior. Ele é completamente autocontido.
**Projeto Prático da Aula:** Implementar um arquivo `pilha.py` com: a classe `Pilha` com métodos `empilhar(item)`, `desempilhar()`, `topo()`, `esta_vazia()` e `tamanho()`, e as funções `verificar_parenteses(expressao)` que usa a Pilha para verificar se os parênteses, colchetes e chaves de uma expressão estão balanceados, e `inverter_string(texto)` que usa a Pilha para inverter uma string.
**Testes:** Gere um arquivo `test_pilha.py` com testes pytest cobrindo: empilhar e desempilhar em ordem correta, desempilhar de pilha vazia (deve lançar exceção), topo de pilha vazia (deve lançar exceção), verificação de expressões balanceadas e não balanceadas, inversão de string vazia e de um caractere.
**Log de Estado da Aula:**
- **Objetivo:** Implementar a estrutura Pilha e aplicá-la em dois problemas clássicos.
- **Arquivo Principal:** `pilha.py` com classe `Pilha` e duas funções de aplicação.
- **Arquivo de Testes:** `test_pilha.py` com cobertura de operações e aplicações.
- **Estado Funcional:** ✅ Classe e funções executam sem erros e todos os testes passam.
- **Próximas Etapas:** Aula 16 apresentará Filas — a estrutura complementar com princípio FIFO.
**Instruções Específicas:**
- A analogia de ancoragem deve comparar a Pilha a uma pilha de pratos — você só pode colocar e retirar pratos do topo, nunca do meio ou da base, e o último prato empilhado é o primeiro a ser retirado.
- O diagrama Mermaid deve ilustrar a sequência de operações `empilhar(A)`, `empilhar(B)`, `empilhar(C)`, `desempilhar()` (retorna C), mostrando o estado da Pilha após cada operação.
- A teoria deve explicar por que o Python não precisa de uma classe Pilha dedicada (listas com `append` e `pop` já funcionam como pilha), mas implementá-la do zero é fundamental para entender a estrutura antes de usá-la pronta.
- A antecipação de erros deve cobrir `Stack Overflow` — o que acontece quando uma recursão infinita esgota a pilha de chamadas do Python — e a diferença entre `pop()` (remove e retorna) e `topo()` (apenas espia sem remover).
- O desafio de fixação deve pedir ao aluno que implemente uma função `avaliar_rpn(expressao)` que avalia uma expressão em Notação Polonesa Reversa usando a Pilha — por exemplo, `'3 4 + 2 *'` deve retornar 14."

---

### Aula 16: Filas (Queues): O Princípio FIFO na Prática

**Prompt:**
"Gere a **Aula 16: Filas (Queues): O Princípio FIFO na Prática**, seguindo rigorosamente a estrutura completa de aula definida no plano do curso.
**Objetivo:** Entender o conceito de Fila (First In, First Out), implementar uma Fila do zero, e resolver problemas clássicos que exigem comportamento FIFO, incluindo a Fila de Prioridade.
**Pré-requisitos:** Aula 15 (Pilhas — estrutura de dados com interface controlada).
**Configuração do Ambiente:** Windows 11, VS Code, Python 3.13.x, pytest instalado via pip.
**Independência:** O código desta aula não depende de nenhuma aula anterior. Ele é completamente autocontido.
**Projeto Prático da Aula:** Implementar um arquivo `fila.py` com: a classe `Fila` com métodos `enfileirar(item)`, `desenfileirar()`, `frente()`, `esta_vazia()` e `tamanho()`, a classe `FilaPrioridade` onde cada item tem uma prioridade numérica e o de maior prioridade sai primeiro, e a função `simular_atendimento(clientes)` que recebe uma lista de nomes e simula a ordem de atendimento usando a Fila.
**Testes:** Gere um arquivo `test_fila.py` com testes pytest cobrindo: enfileirar e desenfileirar na ordem correta (FIFO), desenfileirar de fila vazia (deve lançar exceção), fila de prioridade com prioridades diferentes e iguais, e simulação com lista vazia e com um cliente.
**Log de Estado da Aula:**
- **Objetivo:** Implementar Fila simples e de Prioridade com simulação de atendimento.
- **Arquivo Principal:** `fila.py` com duas classes e uma função de simulação.
- **Arquivo de Testes:** `test_fila.py` com cobertura de comportamento FIFO e casos extremos.
- **Estado Funcional:** ✅ Classes e funções executam sem erros e todos os testes passam.
- **Próximas Etapas:** Aula 17 apresentará Dicionários e Tabelas Hash — estruturas de acesso por chave.
**Instruções Específicas:**
- A analogia de ancoragem deve comparar a Fila a uma fila de banco — o primeiro a chegar é o primeiro a ser atendido, e ninguém fura a fila (a não ser na Fila de Prioridade, onde idosos e gestantes têm preferência).
- O diagrama Mermaid deve ilustrar a operação de enfileirar na traseira e desenfileirar da frente, em contraste direto com a Pilha que opera em uma única extremidade.
- A teoria deve explicar por que usar `list.pop(0)` em Python é ineficiente para filas (O(n) porque desloca todos os elementos) e mencionar que `collections.deque` resolve isso, mas a implementação manual com lista é suficiente para fins didáticos.
- A antecipação de erros deve cobrir a confusão clássica entre LIFO e FIFO — qual extremidade é a frente e qual é a traseira — e a diferença entre Fila simples (ordem de chegada) e Fila de Prioridade (prioridade explícita).
- O desafio de fixação deve pedir ao aluno que implemente uma `FilaCircular` de tamanho fixo que, ao atingir a capacidade máxima, sobrescreve o elemento mais antigo — comportamento útil em buffers de dados em tempo real."

---

### Aula 17: Dicionários e Tabelas Hash: Acesso por Chave

**Prompt:**
"Gere a **Aula 17: Dicionários e Tabelas Hash: Acesso por Chave**, seguindo rigorosamente a estrutura completa de aula definida no plano do curso.
**Objetivo:** Entender como funciona uma Tabela Hash internamente, dominar o uso de dicionários Python para resolver problemas de acesso eficiente por chave, e implementar uma tabela hash simplificada do zero.
**Pré-requisitos:** Aula 06 (listas) e Aula 07 (strings).
**Configuração do Ambiente:** Windows 11, VS Code, Python 3.13.x, pytest instalado via pip.
**Independência:** O código desta aula não depende de nenhuma aula anterior. Ele é completamente autocontido.
**Projeto Prático da Aula:** Implementar um arquivo `tabela_hash.py` com: `funcao_hash(chave, tamanho)` que implementa uma função hash simples para strings, a classe `TabelaHash` com métodos `inserir(chave, valor)`, `buscar(chave)` e `remover(chave)` usando tratamento de colisões por encadeamento (cada bucket é uma lista), e `contar_frequencias(lista)` que usa um dicionário Python para contar a frequência de cada elemento.
**Testes:** Gere um arquivo `test_tabela_hash.py` com testes pytest cobrindo: inserir e buscar com sucesso, buscar chave inexistente (retorna `None`), colisão de hash (duas chaves mapeiam para o mesmo bucket), remover chave existente, remover chave inexistente, e contagem de frequências com lista vazia e com todos os elementos iguais.
**Log de Estado da Aula:**
- **Objetivo:** Implementar Tabela Hash com tratamento de colisão e usar dicionário para contagem de frequências.
- **Arquivo Principal:** `tabela_hash.py` com função hash, classe `TabelaHash` e função de contagem.
- **Arquivo de Testes:** `test_tabela_hash.py` com cobertura de operações básicas e tratamento de colisão.
- **Estado Funcional:** ✅ Classe e funções executam sem erros e todos os testes passam.
- **Próximas Etapas:** Aula 18 apresentará Conjuntos — estrutura que usa hash para garantir unicidade.
**Instruções Específicas:**
- A analogia de ancoragem deve comparar a Tabela Hash a um vestiário de academia com chaves numeradas — você dá seu nome (chave) ao atendente, ele aplica uma fórmula (função hash) para descobrir qual armário (bucket) é o seu, e guarda/recupera seus pertences (valor) sem precisar procurar um por um.
- O diagrama Mermaid deve ilustrar o processo de inserção: chave → função hash → índice do bucket → armazenar (chave, valor) no bucket, mostrando dois exemplos com e sem colisão.
- A teoria deve explicar por que a busca em tabela hash é O(1) no caso médio — e o que acontece no pior caso quando todas as chaves colidem no mesmo bucket (degenera para O(n)).
- A antecipação de erros deve cobrir o erro `KeyError` ao buscar uma chave inexistente em dicionários Python (use `.get(chave, None)` para evitá-lo) e a diferença entre usar chaves mutáveis (inválido) e imutáveis (strings, números, tuplas) em dicionários.
- O desafio de fixação deve pedir ao aluno que implemente uma função `dois_somam(lista, alvo)` que encontra dois números na lista que somam ao alvo, usando um dicionário para resolver o problema em O(n) em vez de O(n²) com dois laços aninhados."

---

### Aula 18: Conjuntos (Sets): Algoritmos de Teoria dos Conjuntos

**Prompt:**
"Gere a **Aula 18: Conjuntos (Sets): Algoritmos de Teoria dos Conjuntos**, seguindo rigorosamente a estrutura completa de aula definida no plano do curso.
**Objetivo:** Entender a estrutura de Conjunto (Set) do Python — que garante unicidade e usa hash internamente — e aplicar operações de teoria dos conjuntos (união, interseção, diferença) para resolver problemas práticos.
**Pré-requisitos:** Aula 17 (Dicionários e Tabelas Hash — conceito de hash e unicidade).
**Configuração do Ambiente:** Windows 11, VS Code, Python 3.13.x, pytest instalado via pip.
**Independência:** O código desta aula não depende de nenhuma aula anterior. Ele é completamente autocontido.
**Projeto Prático da Aula:** Implementar um arquivo `conjuntos.py` com funções que demonstram operações de conjuntos: `elementos_unicos(lista)` que retorna os elementos únicos preservando a ordem original sem usar `set()` diretamente (implementar manualmente), `itens_em_comum(lista_a, lista_b)` que retorna os elementos presentes em ambas as listas, `apenas_em_uma(lista_a, lista_b)` que retorna os elementos que estão em exatamente uma das listas (diferença simétrica), e `verificar_subconjunto(lista_pequena, lista_grande)` que verifica se todos os elementos da primeira lista estão na segunda.
**Testes:** Gere um arquivo `test_conjuntos.py` com testes pytest cobrindo: listas vazias, listas sem elementos em comum, listas com todos os elementos em comum, listas com duplicatas, subconjunto vazio (sempre é subconjunto de qualquer conjunto), e conjunto sendo subconjunto de si mesmo.
**Log de Estado da Aula:**
- **Objetivo:** Implementar operações de conjuntos manualmente e com recursos nativos do Python.
- **Arquivo Principal:** `conjuntos.py` com quatro funções autocontidas.
- **Arquivo de Testes:** `test_conjuntos.py` com cobertura de todos os casos de borda.
- **Estado Funcional:** ✅ Funções executam sem erros e todos os testes passam.
- **Próximas Etapas:** Aula 19 apresentará Recursão — a técnica que permite que uma função resolva problemas chamando a si mesma.
**Instruções Específicas:**
- A analogia de ancoragem deve comparar um Conjunto a uma lista de convidados de uma festa sem repetições — cada pessoa só aparece uma vez, não importa quantas vezes o nome seja mencionado, e você pode facilmente descobrir quem está em duas festas diferentes fazendo a interseção das listas.
- O diagrama Mermaid deve ilustrar as quatro operações principais com diagramas de Venn: união, interseção, diferença e diferença simétrica, com exemplos de valores em cada região.
- A teoria deve explicar por que a verificação `elemento in conjunto` é O(1) (usa hash internamente) enquanto `elemento in lista` é O(n) (percorre a lista inteira), e quando é vantajoso converter uma lista para conjunto antes de fazer buscas repetidas.
- A antecipação de erros deve cobrir a perda de ordem ao usar `set()` em Python (conjuntos não são ordenados), a impossibilidade de armazenar listas dentro de sets (listas são mutáveis e não podem ser hasheadas), e a diferença entre `difference()` (A - B) e `symmetric_difference()` (A △ B).
- O desafio de fixação deve pedir ao aluno que implemente uma função `amigos_em_comum(rede_social, usuario_a, usuario_b)` onde `rede_social` é um dicionário que mapeia usuários para conjuntos de amigos, e a função retorna os amigos em comum entre os dois usuários."

---

### Aula 19: Recursão: Funções que Chamam a Si Mesmas

**Prompt:**
"Gere a **Aula 19: Recursão: Funções que Chamam a Si Mesmas**, seguindo rigorosamente a estrutura completa de aula definida no plano do curso.
**Objetivo:** Compreender o conceito de recursão, identificar os dois componentes obrigatórios de toda função recursiva (caso base e chamada recursiva), e implementar algoritmos clássicos de forma recursiva com clareza e segurança.
**Pré-requisitos:** Aula 05 (funções) e Aula 15 (Pilhas — para entender a pilha de chamadas).
**Configuração do Ambiente:** Windows 11, VS Code, Python 3.13.x, pytest instalado via pip.
**Independência:** O código desta aula não depende de nenhuma aula anterior. Ele é completamente autocontido.
**Projeto Prático da Aula:** Implementar um arquivo `recursao.py` com funções recursivas clássicas: `fatorial(n)` que calcula o fatorial de n recursivamente, `fibonacci(n)` que calcula o n-ésimo número de Fibonacci recursivamente, `soma_lista(lista)` que soma todos os elementos de uma lista recursivamente sem usar `sum()`, e `potencia(base, expoente)` que calcula `base^expoente` recursivamente sem usar o operador `**`.
**Testes:** Gere um arquivo `test_recursao.py` com testes pytest cobrindo: fatorial de 0 e 1 (casos base), fatorial de números maiores, Fibonacci de 0, 1 e valores maiores, soma de lista vazia (caso base), soma de lista com um elemento, potência com expoente zero (resultado é 1), e potência com base e expoente positivos.
**Log de Estado da Aula:**
- **Objetivo:** Implementar quatro algoritmos clássicos de forma recursiva com casos base corretos.
- **Arquivo Principal:** `recursao.py` com quatro funções recursivas autocontidas.
- **Arquivo de Testes:** `test_recursao.py` com cobertura de casos base e casos gerais.
- **Estado Funcional:** ✅ Funções executam sem erros e todos os testes passam.
- **Próximas Etapas:** Aula 20 apresentará Árvores Binárias — estrutura que usa recursão naturalmente.
**Instruções Específicas:**
- A analogia de ancoragem deve comparar recursão a um conjunto de espelhos voltados um para o outro — cada espelho reflete o que está à sua frente, que é outro espelho fazendo a mesma coisa, até que um espelho especial (o caso base) para o ciclo.
- O diagrama Mermaid deve ilustrar a pilha de chamadas do `fatorial(4)` — mostrando como cada chamada empilha um frame, aguarda o resultado da chamada filha, e desempilha ao retornar o valor calculado.
- A teoria deve explicar os dois erros fatais da recursão — esquecer o caso base (recursão infinita e `RecursionError`) e caso base incorreto (resultado errado) — e como o Python limita a profundidade de recursão por padrão para evitar estouro de memória.
- A antecipação de erros deve cobrir o `RecursionError: maximum recursion depth exceeded`, como verificar o limite atual com `sys.getrecursionlimit()`, e quando é melhor converter uma solução recursiva em iterativa (listas muito grandes).
- O desafio de fixação deve pedir ao aluno que implemente uma função recursiva `busca_binaria_recursiva(lista, alvo, inicio, fim)` — conectando a recursão ao algoritmo já estudado na Aula 09, agora entendendo por que a recursão é a forma mais natural de expressar aquele algoritmo."

---

### Aula 20: Árvores Binárias: Estrutura Hierárquica de Dados

**Prompt:**
"Gere a **Aula 20: Árvores Binárias: Estrutura Hierárquica de Dados**, seguindo rigorosamente a estrutura completa de aula definida no plano do curso.
**Objetivo:** Entender a estrutura de Árvore Binária de Busca (BST), implementar um Nó e uma BST do zero com operações de inserção e busca, e compreender como a estrutura hierárquica mantém os dados organizados.
**Pré-requisitos:** Aula 19 (Recursão) e Aula 09 (Busca Binária — a BST é a versão em árvore deste conceito).
**Configuração do Ambiente:** Windows 11, VS Code, Python 3.13.x, pytest instalado via pip.
**Independência:** O código desta aula não depende de nenhuma aula anterior. Ele é completamente autocontido.
**Projeto Prático da Aula:** Implementar um arquivo `arvore_binaria.py` com: a classe `No` com atributos `valor`, `esquerda` e `direita`, a classe `ArvoreBinariaBusca` com métodos `inserir(valor)`, `buscar(valor)` que retorna `True` ou `False`, `minimo()` que retorna o menor valor da árvore, e `maximo()` que retorna o maior valor.
**Testes:** Gere um arquivo `test_arvore_binaria.py` com testes pytest cobrindo: inserir e buscar valores presentes, buscar valor ausente, buscar em árvore vazia, mínimo e máximo de árvore com um elemento, mínimo e máximo de árvore com múltiplos elementos, e inserção de valores duplicados (devem ser ignorados).
**Log de Estado da Aula:**
- **Objetivo:** Implementar Nó e Árvore Binária de Busca com operações básicas.
- **Arquivo Principal:** `arvore_binaria.py` com classes `No` e `ArvoreBinariaBusca`.
- **Arquivo de Testes:** `test_arvore_binaria.py` com cobertura de operações e casos extremos.
- **Estado Funcional:** ✅ Classes executam sem erros e todos os testes passam.
- **Próximas Etapas:** Aula 21 ensinará os algoritmos de percurso (traversal) em árvores binárias.
**Instruções Específicas:**
- A analogia de ancoragem deve comparar a Árvore Binária de Busca a um torneio eliminatório — a cada nó você decide se vai para a esquerda (valores menores) ou para a direita (valores maiores), chegando ao destino em muito menos passos do que se procurasse em uma lista linear.
- O diagrama Mermaid deve ilustrar uma BST com sete nós, mostrando claramente a propriedade da BST: todos os valores à esquerda de um nó são menores, todos à direita são maiores.
- A teoria deve explicar como a propriedade da BST permite busca eficiente — similar à busca binária — e o que acontece quando a árvore fica desbalanceada (degrada para O(n) no pior caso, como uma lista encadeada).
- A antecipação de erros deve cobrir `AttributeError: 'NoneType' object has no attribute 'valor'` ao acessar nós nulos sem verificar primeiro se são `None`, e a importância do caso base `if no is None` em todas as funções recursivas que percorrem a árvore.
- O desafio de fixação deve pedir ao aluno que implemente o método `remover(valor)` na classe `ArvoreBinariaBusca` — o caso mais complexo da BST, que exige tratar três situações: remover folha, nó com um filho, e nó com dois filhos."

---

### Aula 21: Algoritmos em Árvores: Traversal em Profundidade e Largura

**Prompt:**
"Gere a **Aula 21: Algoritmos em Árvores: Traversal em Profundidade e Largura**, seguindo rigorosamente a estrutura completa de aula definida no plano do curso.
**Objetivo:** Implementar os três tipos de percurso em profundidade (in-order, pre-order, post-order) e o percurso em largura (level-order), entendendo quando cada tipo é adequado.
**Pré-requisitos:** Aula 20 (Árvores Binárias) e Aula 16 (Filas — necessária para o percurso em largura).
**Configuração do Ambiente:** Windows 11, VS Code, Python 3.13.x, pytest instalado via pip.
**Independência:** O código desta aula não depende de nenhuma aula anterior. Ele é completamente autocontido.
**Projeto Prático da Aula:** Implementar um arquivo `traversal_arvore.py` com: as classes `No` e `ArvoreBinaria` (implementadas do zero, autocontidas), e os métodos de percurso `in_order(no)`, `pre_order(no)` e `post_order(no)` — todos retornando uma lista com os valores na ordem visitada — e `level_order()` que faz o percurso em largura nível a nível.
**Testes:** Gere um arquivo `test_traversal_arvore.py` com testes pytest usando uma árvore fixa de referência (inserir os valores 4, 2, 6, 1, 3, 5, 7 nessa ordem) e verificar os resultados esperados: in-order `[1, 2, 3, 4, 5, 6, 7]`, pre-order `[4, 2, 1, 3, 6, 5, 7]`, post-order `[1, 3, 2, 5, 7, 6, 4]`, level-order `[4, 2, 6, 1, 3, 5, 7]`. Incluir também testes com árvore vazia e árvore com um único nó.
**Log de Estado da Aula:**
- **Objetivo:** Implementar os quatro algoritmos de percurso em árvore binária.
- **Arquivo Principal:** `traversal_arvore.py` com classes e quatro métodos de percurso.
- **Arquivo de Testes:** `test_traversal_arvore.py` com verificação de resultados esperados para árvore de referência.
- **Estado Funcional:** ✅ Todos os percursos retornam resultados corretos e todos os testes passam.
- **Próximas Etapas:** Módulo 4 começa com Grafos — a generalização das árvores onde qualquer nó pode conectar-se a qualquer outro.
**Instruções Específicas:**
- A analogia de ancoragem deve comparar os tipos de percurso a três formas de visitar uma família em uma reunião de parentes — in-order visita do mais novo ao mais velho (ordem crescente), pre-order registra cada pessoa antes de descer para seus filhos (útil para copiar a estrutura), e post-order processa os filhos antes do pai (útil para deletar a árvore da folha para a raiz).
- O diagrama Mermaid deve mostrar a árvore de referência (valores 1 a 7) e, ao lado, a sequência de visita de cada um dos quatro percursos, com setas indicando a ordem de visita.
- A teoria deve explicar a aplicação prática de cada percurso — in-order para recuperar dados em ordem crescente de uma BST, pre-order para serializar a árvore, post-order para avaliar expressões matemáticas em árvore, e level-order para encontrar o menor caminho em grafos (introdução ao BFS).
- A antecipação de erros deve cobrir a confusão entre os nomes dos percursos — a posição do prefixo 'pre', 'in' e 'post' se refere ao momento em que a raiz é visitada em relação aos filhos (antes, entre ou depois).
- O desafio de fixação deve pedir ao aluno que implemente uma função `altura_arvore(no)` que retorna a altura da árvore (número de níveis) usando recursão, e uma função `contar_nos(no)` que conta o total de nós usando qualquer percurso."

---

## Módulo 4 — Mestre: Grafos, Paradigmas e Complexidade

### Aula 22: Introdução a Grafos: Vértices, Arestas e Representações

**Prompt:**
"Gere a **Aula 22: Introdução a Grafos: Vértices, Arestas e Representações**, seguindo rigorosamente a estrutura completa de aula definida no plano do curso.
**Objetivo:** Entender o que é um grafo, seus componentes (vértices e arestas), as variações (dirigido, não dirigido, ponderado) e as duas formas principais de representá-lo em Python: matriz de adjacência e lista de adjacência.
**Pré-requisitos:** Aula 06 (listas) e Aula 17 (dicionários) — ambas as representações usam essas estruturas.
**Configuração do Ambiente:** Windows 11, VS Code, Python 3.13.x, pytest instalado via pip.
**Independência:** O código desta aula não depende de nenhuma aula anterior. Ele é completamente autocontido.
**Projeto Prático da Aula:** Implementar um arquivo `grafo.py` com: a classe `Grafo` usando lista de adjacência (dicionário de listas) com métodos `adicionar_vertice(v)`, `adicionar_aresta(v1, v2)`, `vizinhos(v)`, `tem_aresta(v1, v2)` e `vertices()`, e a função `matriz_para_lista(matriz)` que converte uma matriz de adjacência (lista de listas) para uma lista de adjacência (dicionário).
**Testes:** Gere um arquivo `test_grafo.py` com testes pytest cobrindo: adicionar vértices e arestas, verificar aresta existente e inexistente, obter vizinhos de vértice com e sem conexões, converter matriz para lista de adjacência, e grafo vazio.
**Log de Estado da Aula:**
- **Objetivo:** Implementar a estrutura Grafo com lista de adjacência e conversão de representações.
- **Arquivo Principal:** `grafo.py` com classe `Grafo` e função de conversão.
- **Arquivo de Testes:** `test_grafo.py` com cobertura de operações básicas.
- **Estado Funcional:** ✅ Classe e função executam sem erros e todos os testes passam.
- **Próximas Etapas:** Aula 23 implementará BFS — o primeiro algoritmo de percurso em grafos.
**Instruções Específicas:**
- A analogia de ancoragem deve comparar um grafo a um mapa de cidades conectadas por estradas — as cidades são vértices, as estradas são arestas, e algumas estradas têm sentido único (grafos dirigidos) ou pedágio (grafos ponderados).
- O diagrama Mermaid deve mostrar o mesmo grafo de cinco vértices representado de duas formas: como diagrama visual (círculos e linhas) e como lista de adjacência (dicionário), deixando clara a correspondência entre os dois.
- A teoria deve comparar matriz de adjacência versus lista de adjacência: a matriz ocupa O(V²) de espaço mas verifica arestas em O(1), enquanto a lista ocupa O(V + E) de espaço mas verificar uma aresta pode levar O(grau do vértice).
- A antecipação de erros deve cobrir a confusão entre grafo dirigido (aresta A→B não implica B→A) e não dirigido (aresta AB implica BA), e a necessidade de adicionar a aresta nos dois sentidos ao implementar grafos não dirigidos.
- O desafio de fixação deve pedir ao aluno que adicione à classe `Grafo` um método `grau(v)` que retorna o número de vizinhos do vértice, e um método `e_conectado()` que verifica se todos os vértices do grafo estão conectados (usando qualquer técnica de percurso)."

---

### Aula 23: BFS — Busca em Largura em Grafos

**Prompt:**
"Gere a **Aula 23: BFS — Busca em Largura em Grafos**, seguindo rigorosamente a estrutura completa de aula definida no plano do curso.
**Objetivo:** Implementar o algoritmo de Busca em Largura (Breadth-First Search), entender como a Fila garante o percurso nível a nível, e aplicar BFS para encontrar o menor caminho entre dois vértices em um grafo não ponderado.
**Pré-requisitos:** Aula 22 (Grafos) e Aula 16 (Filas — o BFS usa uma fila internamente).
**Configuração do Ambiente:** Windows 11, VS Code, Python 3.13.x, pytest instalado via pip.
**Independência:** O código desta aula não depende de nenhuma aula anterior. Ele é completamente autocontido.
**Projeto Prático da Aula:** Implementar um arquivo `bfs.py` com: a classe `Grafo` (autocontida, implementada do zero) com lista de adjacência, `bfs(grafo, inicio)` que percorre o grafo a partir do vértice inicial retornando a ordem de visita como lista, e `menor_caminho(grafo, inicio, destino)` que retorna a lista de vértices do menor caminho entre dois nós ou `None` se não existir caminho.
**Testes:** Gere um arquivo `test_bfs.py` com testes pytest cobrindo: percurso em grafo simples com resultado esperado, vértice inicial sem vizinhos, menor caminho entre vértices diretamente conectados, menor caminho passando por intermediários, caminho inexistente (grafo desconectado), e caminho de um vértice para ele mesmo.
**Log de Estado da Aula:**
- **Objetivo:** Implementar BFS para percurso e encontrar menor caminho em grafos.
- **Arquivo Principal:** `bfs.py` com classe `Grafo` autocontida, função `bfs` e função `menor_caminho`.
- **Arquivo de Testes:** `test_bfs.py` com cobertura de percurso e busca de caminhos.
- **Estado Funcional:** ✅ Funções executam sem erros e todos os testes passam.
- **Próximas Etapas:** Aula 24 apresentará DFS — a alternativa em profundidade ao BFS.
**Instruções Específicas:**
- A analogia de ancoragem deve comparar BFS a ondas em um lago — você joga uma pedra (vértice inicial) e as ondas se expandem em círculos concêntricos, visitando primeiro os vizinhos imediatos, depois os vizinhos dos vizinhos, e assim por diante.
- O diagrama Mermaid deve mostrar um grafo de seis vértices e, ao lado, uma sequência de snapshots da fila e do conjunto de visitados durante a execução do BFS, tornando o algoritmo visualmente transparente.
- A teoria deve explicar por que o BFS garante o menor caminho em grafos não ponderados — porque visita todos os nós a distância 1 antes dos de distância 2, todos de distância 2 antes dos de distância 3, e assim por diante.
- A antecipação de erros deve cobrir o loop infinito causado por não marcar vértices como visitados (o algoritmo fica circulando entre nós conectados), e a importância de usar um conjunto (`set`) de visitados para verificação em O(1).
- O desafio de fixação deve pedir ao aluno que implemente uma função `componentes_conectados(grafo)` que usa BFS para encontrar todos os componentes conectados de um grafo desconectado, retornando uma lista de listas — cada sublista contém os vértices de um componente."

---

### Aula 24: DFS — Busca em Profundidade em Grafos

**Prompt:**
"Gere a **Aula 24: DFS — Busca em Profundidade em Grafos**, seguindo rigorosamente a estrutura completa de aula definida no plano do curso.
**Objetivo:** Implementar o algoritmo de Busca em Profundidade (Depth-First Search) nas versões recursiva e iterativa, entender como a Pilha (ou a pilha de chamadas) garante o percurso em profundidade, e comparar DFS com BFS.
**Pré-requisitos:** Aula 22 (Grafos), Aula 15 (Pilhas) e Aula 19 (Recursão).
**Configuração do Ambiente:** Windows 11, VS Code, Python 3.13.x, pytest instalado via pip.
**Independência:** O código desta aula não depende de nenhuma aula anterior. Ele é completamente autocontido.
**Projeto Prático da Aula:** Implementar um arquivo `dfs.py` com: a classe `Grafo` (autocontida, implementada do zero), `dfs_recursivo(grafo, inicio, visitados=None)` que retorna a ordem de visita usando recursão, `dfs_iterativo(grafo, inicio)` que retorna a ordem de visita usando uma pilha explícita, e `tem_ciclo(grafo)` que detecta se o grafo possui algum ciclo usando DFS.
**Testes:** Gere um arquivo `test_dfs.py` com testes pytest cobrindo: percurso em grafo simples verificando que todos os vértices foram visitados, grafo com um único vértice, verificação de que DFS recursivo e iterativo visitam todos os mesmos vértices (não necessariamente na mesma ordem), grafo com ciclo (`tem_ciclo` retorna `True`), e grafo sem ciclo — uma árvore (`tem_ciclo` retorna `False`).
**Log de Estado da Aula:**
- **Objetivo:** Implementar DFS recursivo, iterativo e detecção de ciclos.
- **Arquivo Principal:** `dfs.py` com classe `Grafo` autocontida, DFS recursivo, DFS iterativo e detecção de ciclos.
- **Arquivo de Testes:** `test_dfs.py` com cobertura de percurso e detecção de ciclos.
- **Estado Funcional:** ✅ Funções executam sem erros e todos os testes passam.
- **Próximas Etapas:** Aula 25 introduzirá o paradigma Guloso — tomando a melhor decisão local em cada passo.
**Instruções Específicas:**
- A analogia de ancoragem deve comparar DFS a explorar um labirinto seguindo sempre a parede da esquerda — você vai fundo em cada corredor antes de voltar e tentar outro, e marca cada local visitado para não repetir.
- O diagrama Mermaid deve mostrar o mesmo grafo percorrido por BFS (Aula 23) e por DFS, com as setas indicando a ordem de visita em cada algoritmo, deixando clara a diferença de comportamento.
- A teoria deve comparar BFS e DFS em três dimensões: uso de memória (BFS pode usar mais memória em grafos largos, DFS em grafos profundos), garantia de menor caminho (apenas BFS garante), e adequação para detecção de ciclos e ordenação topológica (DFS é melhor).
- A antecipação de erros deve cobrir a diferença de ordem entre DFS recursivo e iterativo (a pilha explícita processa vizinhos em ordem inversa à recursão), e o risco de `RecursionError` no DFS recursivo para grafos muito grandes.
- O desafio de fixação deve pedir ao aluno que implemente uma função `ordenacao_topologica(grafo)` que usa DFS para produzir uma ordenação topológica dos vértices de um grafo dirigido acíclico (DAG) — útil para determinar a ordem de execução de tarefas com dependências."

---

### Aula 25: Algoritmo Guloso: Tomando a Melhor Decisão Local

**Prompt:**
"Gere a **Aula 25: Algoritmo Guloso: Tomando a Melhor Decisão Local**, seguindo rigorosamente a estrutura completa de aula definida no plano do curso.
**Objetivo:** Entender o paradigma Guloso (Greedy), compreender quando ele produz a solução ótima e quando produz apenas uma boa aproximação, e implementá-lo em problemas clássicos.
**Pré-requisitos:** Aula 04 (laços de repetição) e Aula 06 (listas).
**Configuração do Ambiente:** Windows 11, VS Code, Python 3.13.x, pytest instalado via pip.
**Independência:** O código desta aula não depende de nenhuma aula anterior. Ele é completamente autocontido.
**Projeto Prático da Aula:** Implementar um arquivo `guloso.py` com: `troco_guloso(valor, moedas)` que recebe um valor e uma lista de denominações de moedas ordenadas e retorna o menor número de moedas para o troco, `atividades_compativeis(atividades)` que recebe uma lista de tuplas `(inicio, fim)` e retorna o maior número de atividades não sobrepostas (problema da seleção de atividades), e `mochila_fracionaria(capacidade, itens)` onde `itens` é uma lista de tuplas `(peso, valor)` e a função retorna o valor máximo que pode ser carregado (cada item pode ser dividido).
**Testes:** Gere um arquivo `test_guloso.py` com testes pytest cobrindo: troco exato com moedas padrão, troco com denominações que fazem o guloso falhar (demonstrar limitação), seleção de atividades com sobreposições totais e parciais, mochila com capacidade zero, e mochila com capacidade que comporta todos os itens.
**Log de Estado da Aula:**
- **Objetivo:** Implementar três algoritmos gulosos clássicos com demonstração de limitações.
- **Arquivo Principal:** `guloso.py` com três funções autocontidas.
- **Arquivo de Testes:** `test_guloso.py` com cobertura de casos normais, ótimos e casos onde o guloso falha.
- **Estado Funcional:** ✅ Funções executam sem erros e todos os testes passam.
- **Próximas Etapas:** Aula 26 apresentará o paradigma Divisão e Conquista — generalização do que foi visto no Merge Sort e Quick Sort.
**Instruções Específicas:**
- A analogia de ancoragem deve comparar o algoritmo guloso a um turista que, a cada cruzamento, sempre pega a rua que parece mais curta — às vezes chega ao destino pelo caminho mais rápido, mas às vezes não, porque a decisão local ótima não garante a solução global ótima.
- O diagrama Mermaid deve ilustrar o problema do troco com denominações `[25, 10, 5, 1]` e valor 41, mostrando passo a passo as escolhas gulosas: 25 → 10 → 5 → 1, totalizando 4 moedas.
- A teoria deve explicar claramente quando o algoritmo guloso é ótimo (troco com moedas canônicas, seleção de atividades, mochila fracionária) e quando falha (mochila 0/1, troco com denominações não canônicas), introduzindo a motivação para Programação Dinâmica.
- A antecipação de erros deve cobrir a armadilha de aplicar o algoritmo guloso sem provar sua corretude — o fato de funcionar em exemplos simples não garante que funcione sempre, e o teste com `moedas=[4, 3, 1]` e `valor=6` deve demonstrar que o guloso escolhe 4+1+1 (3 moedas) enquanto a solução ótima é 3+3 (2 moedas).
- O desafio de fixação deve pedir ao aluno que implemente o algoritmo de Huffman simplificado — dado um dicionário de caracteres e frequências, construir os códigos usando uma estratégia gulosa de combinar sempre os dois nós de menor frequência."

---

### Aula 26: Divisão e Conquista: Quebrando Problemas em Partes

**Prompt:**
"Gere a **Aula 26: Divisão e Conquista: Quebrando Problemas em Partes**, seguindo rigorosamente a estrutura completa de aula definida no plano do curso.
**Objetivo:** Entender o paradigma Divisão e Conquista como estratégia geral de projeto de algoritmos, formalizar o que foi visto no Merge Sort e Quick Sort, e implementar novos exemplos que ilustrem o poder do paradigma.
**Pré-requisitos:** Aula 13 (Merge Sort) e Aula 19 (Recursão) — este paradigma formaliza esses conceitos.
**Configuração do Ambiente:** Windows 11, VS Code, Python 3.13.x, pytest instalado via pip.
**Independência:** O código desta aula não depende de nenhuma aula anterior. Ele é completamente autocontido.
**Projeto Prático da Aula:** Implementar um arquivo `divisao_conquista.py` com: `potencia_rapida(base, expoente)` que usa Divisão e Conquista para calcular potências em O(log n) em vez de O(n), `maximo_subarray(lista)` que implementa o algoritmo de Kadane como introdução e depois a versão Dividir e Conquistar que encontra a subsequência contígua de maior soma, e `contagem_inversoes(lista)` que conta quantas inversões existem em uma lista (pares onde `lista[i] > lista[j]` com `i < j`) usando uma versão modificada do Merge Sort.
**Testes:** Gere um arquivo `test_divisao_conquista.py` com testes pytest cobrindo: potência com expoente zero, um e potências maiores, comparação de resultado entre `potencia_rapida` e `**` do Python, máximo subarray em lista de todos negativos (o menos negativo), lista de um elemento, e contagem de inversões em lista já ordenada (zero inversões) e lista em ordem decrescente (máximo de inversões).
**Log de Estado da Aula:**
- **Objetivo:** Implementar três algoritmos que formalizam o paradigma Divisão e Conquista.
- **Arquivo Principal:** `divisao_conquista.py` com três funções autocontidas.
- **Arquivo de Testes:** `test_divisao_conquista.py` com cobertura de casos normais e extremos.
- **Estado Funcional:** ✅ Funções executam sem erros e todos os testes passam.
- **Próximas Etapas:** Aula 27 apresentará Programação Dinâmica — o paradigma que supera as limitações do Guloso e melhora a recursão ingênua.
**Instruções Específicas:**
- A analogia de ancoragem deve comparar Divisão e Conquista a uma empresa multinacional que resolve um problema grande dividindo em filiais regionais, cada filial divide em escritórios locais, cada escritório resolve sua parte pequena e reporta para cima, até que o resultado final é montado no topo.
- O diagrama Mermaid deve ilustrar o cálculo de `potencia_rapida(2, 8)` como árvore de recursão, mostrando como `2^8 = 2^4 * 2^4`, `2^4 = 2^2 * 2^2`, e assim por diante, reduzindo o número de multiplicações de 8 para 3.
- A teoria deve apresentar a Relação de Recorrência informalmente — `T(n) = 2T(n/2) + O(n)` — e mostrar que ela explica por que o Merge Sort é O(n log n), sem exigir matemática formal do aluno iniciante.
- A antecipação de erros deve cobrir a diferença entre `potencia_rapida(2, 8)` (O(log n) multiplicações) e `2 ** 8` do Python (que já é otimizado internamente), e por que em entrevistas técnicas implementar potência rápida ainda é relevante como exercício de raciocínio.
- O desafio de fixação deve pedir ao aluno que implemente `multiplicar_matrizes(A, B)` usando o algoritmo de Strassen para multiplicação de matrizes 2x2, demonstrando como Divisão e Conquista pode reduzir o número de multiplicações de 8 para 7."

---

### Aula 27: Programação Dinâmica: Memorizando para Não Recalcular

**Prompt:**
"Gere a **Aula 27: Programação Dinâmica: Memorizando para Não Recalcular**, seguindo rigorosamente a estrutura completa de aula definida no plano do curso.
**Objetivo:** Entender o paradigma de Programação Dinâmica (PD) nas duas abordagens — memoização (top-down) e tabulação (bottom-up) — e aplicá-lo para resolver problemas que seriam intratáveis com recursão ingênua.
**Pré-requisitos:** Aula 19 (Recursão) e Aula 25 (Algoritmo Guloso — para entender por que PD é necessária quando o guloso falha).
**Configuração do Ambiente:** Windows 11, VS Code, Python 3.13.x, pytest instalado via pip.
**Independência:** O código desta aula não depende de nenhuma aula anterior. Ele é completamente autocontido.
**Projeto Prático da Aula:** Implementar um arquivo `prog_dinamica.py` com: `fibonacci_memo(n, memo=None)` que usa memoização para calcular Fibonacci eficientemente, `fibonacci_tabela(n)` que usa tabulação (bottom-up) para o mesmo problema, `mochila_01(capacidade, pesos, valores)` que resolve o problema da Mochila 0/1 com tabulação (cada item pode ser incluído ou excluído), e `maior_subsequencia_comum(s1, s2)` que encontra o comprimento da maior subsequência comum entre duas strings.
**Testes:** Gere um arquivo `test_prog_dinamica.py` com testes pytest cobrindo: Fibonacci de 0, 1, 10 e 30 (verificar que a versão com memo é significativamente mais rápida que a recursão ingênua para n=30), mochila com capacidade zero, mochila onde nenhum item cabe, mochila onde todos os itens cabem, e maior subsequência comum entre strings vazias, strings iguais e strings sem caracteres em comum.
**Log de Estado da Aula:**
- **Objetivo:** Implementar Programação Dinâmica em quatro problemas clássicos com memoização e tabulação.
- **Arquivo Principal:** `prog_dinamica.py` com quatro funções autocontidas.
- **Arquivo de Testes:** `test_prog_dinamica.py` com cobertura de casos base, casos normais e verificação de eficiência.
- **Estado Funcional:** ✅ Funções executam sem erros e todos os testes passam.
- **Próximas Etapas:** Aula 28 ensinará a medir e comparar a eficiência de qualquer algoritmo com a notação Big O.
**Instruções Específicas:**
- A analogia de ancoragem deve comparar Programação Dinâmica a um aluno que anota as respostas dos exercícios em um caderno — quando o mesmo exercício aparece de novo, ele consulta o caderno em vez de resolver do zero, economizando um tempo enorme.
- O diagrama Mermaid deve mostrar a árvore de recursão do Fibonacci ingênuo para `fib(6)`, destacando em vermelho todos os subproblemas recalculados repetidamente, e ao lado mostrar a versão com memoização onde cada subproblema é calculado apenas uma vez.
- A teoria deve apresentar os dois critérios para que PD seja aplicável: **subestrutura ótima** (a solução ótima do problema maior usa soluções ótimas dos subproblemas) e **subproblemas sobrepostos** (os mesmos subproblemas aparecem múltiplas vezes), e comparar com Divisão e Conquista que também tem subestrutura ótima mas sem sobreposição.
- A antecipação de erros deve cobrir a confusão entre memoização (armazenar resultados de chamadas recursivas) e tabulação (preencher uma tabela de baixo para cima), e o erro de usar uma lista mutável como valor padrão em `fibonacci_memo(n, memo=[])` — usar `None` e inicializar dentro da função.
- O desafio de fixação deve pedir ao aluno que implemente `troco_pd(valor, moedas)` — o problema do troco resolvido com Programação Dinâmica — e comparar o resultado com a versão gulosa da Aula 25, demonstrando que PD encontra a solução ótima mesmo nos casos onde o guloso falha."

---

### Aula 28: Complexidade de Algoritmos: Notação Big O

**Prompt:**
"Gere a **Aula 28: Complexidade de Algoritmos: Notação Big O**, seguindo rigorosamente a estrutura completa de aula definida no plano do curso.
**Objetivo:** Aprender a analisar e classificar a eficiência de algoritmos usando a notação Big O, identificar a complexidade dos algoritmos estudados ao longo do curso, e tomar decisões informadas sobre qual algoritmo usar em cada situação.
**Pré-requisitos:** Todos os módulos anteriores — esta aula revisita os algoritmos do curso sob a perspectiva da complexidade.
**Configuração do Ambiente:** Windows 11, VS Code, Python 3.13.x, pytest instalado via pip.
**Independência:** O código desta aula não depende de nenhuma aula anterior. Ele é completamente autocontido.
**Projeto Prático da Aula:** Implementar um arquivo `complexidade.py` com funções que demonstram visualmente cada classe de complexidade: `o_constante(lista)` que acessa o primeiro elemento (O(1)), `o_logaritmico(lista, alvo)` que implementa busca binária (O(log n)), `o_linear(lista, alvo)` que implementa busca linear (O(n)), `o_nlogn(lista)` que implementa merge sort (O(n log n)), `o_quadratico(lista)` que implementa bubble sort (O(n²)), e `comparar_crescimento(tamanhos)` que recebe uma lista de tamanhos de entrada e retorna um dicionário com o número de operações estimadas para cada classe de complexidade.
**Testes:** Gere um arquivo `test_complexidade.py` com testes pytest verificando: os resultados corretos de cada função (busca linear e binária encontram o alvo, merge sort ordena corretamente), que `comparar_crescimento` retorna os cinco campos esperados para cada tamanho de entrada, e que para n=1000 as operações estimadas crescem na ordem certa: O(1) < O(log n) < O(n) < O(n log n) < O(n²).
**Log de Estado da Aula:**
- **Objetivo:** Implementar exemplos de cada classe de complexidade e criar um comparador de crescimento.
- **Arquivo Principal:** `complexidade.py` com seis funções autocontidas e um comparador.
- **Arquivo de Testes:** `test_complexidade.py` com verificação de resultados e ordenação de crescimento.
- **Estado Funcional:** ✅ Funções executam sem erros e todos os testes passam.
- **Próximas Etapas:** Curso concluído. O aluno tem um laboratório completo de algoritmos implementados e testados — do básico ao avançado.
**Instruções Específicas:**
- A analogia de ancoragem deve comparar Big O a uma previsão do tempo para algoritmos — ela não diz exatamente quantas operações serão feitas, mas diz como o tempo de execução cresce quando a entrada aumenta, e isso é suficiente para tomar boas decisões.
- O diagrama Mermaid deve ser um gráfico conceitual mostrando as curvas de crescimento das cinco classes de complexidade (O(1), O(log n), O(n), O(n log n), O(n²)) no eixo y (operações) versus o tamanho da entrada no eixo x, com rótulos claros.
- A teoria deve cobrir: como identificar a complexidade de um algoritmo (contar laços, chamadas recursivas e operações dominantes), as regras de simplificação do Big O (descartar constantes e termos menores), e a tabela de complexidade de todos os algoritmos estudados no curso organizados por categoria.
- A antecipação de erros deve cobrir a confusão entre complexidade de tempo e complexidade de espaço (um algoritmo pode ser O(n) em tempo mas O(n²) em espaço), e a armadilha de otimizar prematuramente — um algoritmo O(n²) com n=100 pode ser mais rápido na prática que um O(n log n) com overhead alto de recursão e criação de listas.
- O desafio de fixação deve pedir ao aluno que analise as funções que ele mesmo implementou ao longo do curso — escolher cinco funções de aulas diferentes, analisar a complexidade de tempo e espaço de cada uma, e justificar a análise explicando quais laços e chamadas recursivas determinam a complexidade."

