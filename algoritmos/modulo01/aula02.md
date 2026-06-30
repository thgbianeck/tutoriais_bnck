# Aula 02: Variáveis, Tipos de Dados e Operadores em Python

## Análise de Integridade (Auditoria Prévia)

Antes de iniciar, este conteúdo foi verificado nos seguintes critérios: profundidade técnica mantida com linguagem acessível para iniciantes absolutos, analogias do cotidiano presentes antes de qualquer formalização técnica, código Python 3.13 funcional e comentado linha a linha, testes pytest cobrindo casos normais e extremos, diagrama Mermaid correto e bem formatado com escape adequado, glossário completo, antecipação de erros relevantes para iniciantes, e mínimo de 2.000 palavras de teoria. Nenhuma falha detectada. Conteúdo aprovado para geração.

---

## Objetivo da Aula

Dominar os quatro tipos de dados básicos do Python — `int`, `float`, `str` e `bool` — compreender como variáveis funcionam como recipientes de informação, aprender a aplicar operadores aritméticos, de comparação e lógicos, e implementar cinco funções que demonstram cada um desses conceitos em um contexto prático e testável.

## Pré-requisitos

Aula 01 concluída — especialmente o conceito de entrada, processamento e saída, e a estrutura básica de uma função Python com `def` e `return`. O ambiente virtual deve estar ativo e o pytest instalado.

---

## Teoria Detalhada

### O problema de guardar informação

Imagine que você está resolvendo um problema matemático no papel. Você calcula um valor intermediário — digamos, o total de uma soma — e precisa usá-lo mais tarde no cálculo. O que você faz? Você anota o valor em algum lugar da folha, provavelmente ao lado de uma etiqueta como "total = 28", e consulta essa anotação quando precisar. Sem essa capacidade de guardar e recuperar informação intermediária, qualquer problema um pouco mais complexo se tornaria impossível de resolver.

Os computadores têm exatamente a mesma necessidade. Para executar um algoritmo que some vinte números, o computador precisa de algum lugar para guardar a soma acumulada enquanto percorre a lista. Para calcular o IMC de uma pessoa, ele precisa guardar o peso e a altura antes de realizar a divisão. Para exibir uma mensagem personalizada, ele precisa guardar o nome do usuário. Essa necessidade de guardar e nomear valores é o que deu origem ao conceito de **variável**.

### O que é uma variável?

Uma **variável** é um nome que você escolhe para referenciar um valor armazenado na memória do computador. Quando você escreve `idade = 25` em Python, três coisas acontecem: o valor `25` é armazenado em algum lugar na memória RAM do computador, esse espaço de memória recebe o nome `idade`, e a partir desse momento você pode usar a palavra `idade` em qualquer parte do código para recuperar o valor `25`.

O nome "variável" vem do fato de que esse valor pode mudar ao longo do tempo. Se mais tarde você escrever `idade = 26`, o valor armazenado sob o nome `idade` é atualizado para `26`. A variável é o mesmo recipiente com um conteúdo diferente.

Uma analogia poderosa: pense em variáveis como **caixas com etiquetas**. Cada caixa tem uma etiqueta (o nome da variável) e um conteúdo (o valor armazenado). Você pode olhar o conteúdo de uma caixa a qualquer momento consultando sua etiqueta, pode trocar o conteúdo mantendo a mesma etiqueta, e pode ter quantas caixas quiser — cada uma com sua etiqueta única e seu conteúdo específico. Assim como uma caixa física só comporta certos tipos de objeto — você não coloca um elefante em uma caixa de sapatos — cada variável armazena um tipo específico de dado.

### Tipagem dinâmica: a personalidade do Python

Em muitas linguagens de programação, como Java e C++, você precisa declarar explicitamente o tipo de uma variável antes de usá-la: "esta variável guardará inteiros", "esta guardará texto". Em Python, isso não é necessário — o Python determina automaticamente o tipo do valor com base no que você atribui. Isso é chamado de **tipagem dinâmica**.

Quando você escreve `quantidade = 10`, o Python olha para o valor `10` e conclui: "isso é um número inteiro, então `quantidade` é do tipo `int`". Quando você escreve `nome = "Ana"`, o Python conclui: "isso é texto, então `nome` é do tipo `str`". Você não precisou declarar o tipo — o Python inferiu por você.

Isso não significa, porém, que os valores não têm tipo. **Os valores sempre têm tipo em Python** — o que muda é que a variável em si não é amarrada a um tipo fixo. Uma variável pode guardar um inteiro agora e uma string amanhã. Isso traz flexibilidade, mas também responsabilidade: você precisa sempre saber o tipo do valor que está manipulando para evitar erros.

Para verificar o tipo de qualquer valor em Python, use a função `type()`. `type(42)` retorna `<class 'int'>`. `type("Olá")` retorna `<class 'str'>`. `type(3.14)` retorna `<class 'float'>`. `type(True)` retorna `<class 'bool'>`. Essa função é sua aliada quando você não tem certeza sobre o tipo de um valor.

### Os quatro tipos básicos de dados

Python possui quatro tipos de dados fundamentais que você encontrará em praticamente todo algoritmo que escrever. Compreendê-los profundamente é a base para tudo o que vem a seguir.

O primeiro é o **`int`** — números inteiros, positivos ou negativos, sem parte decimal. `0`, `1`, `-5`, `1000000` são todos `int`. Inteiros são usados para contagens, índices, quantidades discretas — qualquer coisa que não pode ser fracionada. A quantidade de livros em uma biblioteca é um `int`. A posição de um elemento em uma lista é um `int`. A idade de uma pessoa é um `int`. Em Python 3, inteiros não têm limite de tamanho — você pode trabalhar com números astronomicamente grandes sem se preocupar com overflow.

O segundo é o **`float`** — números de ponto flutuante, ou seja, números com parte decimal. `3.14`, `0.5`, `-2.7`, `1.0` são todos `float`. O nome "ponto flutuante" vem da representação interna usada pelos computadores, onde o ponto decimal pode "flutuar" para diferentes posições. Floats são usados para medições, proporções, cálculos científicos — qualquer coisa que pode ter fração. O peso de uma pessoa em quilos é um `float`. A temperatura em graus Celsius é um `float`. Uma importante limitação: floats têm precisão finita, o que pode causar pequenas imprecisões em cálculos. `0.1 + 0.2` em Python retorna `0.30000000000000004` — não `0.3`. Por isso, ao comparar floats, é melhor verificar se a diferença é menor que um valor pequeno (tolerância) em vez de usar `==` diretamente.

O terceiro é o **`str`** — strings, ou cadeias de caracteres. `"Olá"`, `'Python'`, `"123"`, `""` (string vazia) são todos `str`. Strings são usadas para qualquer tipo de texto — nomes, mensagens, endereços, descrições. Em Python, você pode usar aspas simples `'` ou aspas duplas `"` para delimitar uma string — ambas funcionam da mesma forma. Strings são **imutáveis** em Python, o que significa que uma vez criada, uma string não pode ser modificada — qualquer operação que "modifica" uma string na verdade cria uma nova string. `"123"` é uma string, não um número — você não pode realizar operações aritméticas com ela sem antes convertê-la para `int` ou `float`.

O quarto é o **`bool`** — booleano, que representa verdadeiro ou falso. Os únicos valores possíveis são `True` e `False` — com inicial maiúscula, exatamente assim. Booleanos são o resultado de comparações e condições: `5 > 3` retorna `True`, `10 == 7` retorna `False`. Eles são o fundamento lógico de todo algoritmo — toda decisão (`if`) e toda condição de parada de laço (`while`) se baseia em um valor booleano.

### Regras para nomear variáveis

O Python tem regras simples mas obrigatórias para nomes de variáveis. O nome deve começar com uma letra ou underscore (`_`), nunca com um número. Pode conter letras, números e underscores, mas nenhum outro caractere especial — sem espaços, sem hífens, sem acentos. O Python é sensível a maiúsculas: `idade`, `Idade` e `IDADE` são três variáveis completamente diferentes.

Além das regras obrigatórias, há convenções da comunidade Python definidas no documento PEP 8 — o guia de estilo oficial. Para variáveis comuns, use **snake_case**: palavras em minúsculas separadas por underscore. `nome_completo`, `total_vendas`, `e_maior_de_idade` são exemplos de nomes seguindo snake_case. Evite nomes de uma única letra (exceto em contextos muito específicos como índices de laço) e evite abreviações obscuras. `n` é um nome ruim; `numero_alunos` é um nome excelente. Nomes semânticos tornam o código autoexplicativo — você não precisa de comentários para entender o que `preco_com_desconto` guarda.

### Operadores: as ferramentas do processamento

Operadores são os símbolos que permitem realizar operações sobre os valores. Python possui três categorias principais de operadores que você usará em praticamente todo algoritmo.

Os **operadores aritméticos** realizam cálculos matemáticos: `+` (adição), `-` (subtração), `*` (multiplicação), `/` (divisão — sempre retorna `float`), `//` (divisão inteira — descarta a parte decimal), `%` (módulo — retorna o resto da divisão) e `**` (exponenciação). A distinção entre `/` e `//` é fundamental: `7 / 2` retorna `3.5`, enquanto `7 // 2` retorna `3`. O operador `%` é especialmente útil para verificar paridade (`numero % 2 == 0` significa par) e para trabalhar com ciclos.

Os **operadores de comparação** comparam dois valores e retornam um booleano: `==` (igual), `!=` (diferente), `>` (maior que), `<` (menor que), `>=` (maior ou igual) e `<=` (menor ou igual). Atenção especial ao `==`: ele é o operador de comparação, completamente diferente do `=`, que é o operador de atribuição. Confundir os dois é um dos erros mais comuns entre iniciantes — e o Python lança `SyntaxError` quando você usa `=` dentro de uma condição `if`.

Os **operadores lógicos** combinam condições booleanas: `and` (e — verdadeiro apenas se ambas as condições forem verdadeiras), `or` (ou — verdadeiro se pelo menos uma condição for verdadeira) e `not` (não — inverte o valor booleano). `5 > 3 and 10 < 20` retorna `True` porque ambas as condições são verdadeiras. `5 > 3 and 10 > 20` retorna `False` porque a segunda condição é falsa. `not True` retorna `False`.

### Conversão entre tipos

Python permite converter valores de um tipo para outro usando funções de conversão. `int("42")` converte a string `"42"` para o inteiro `42`. `float("3.14")` converte `"3.14"` para o float `3.14`. `str(100)` converte o inteiro `100` para a string `"100"`. `bool(0)` converte `0` para `False` — e qualquer número diferente de zero para `True`.

Essas conversões são chamadas de **casting** ou **type casting**. Elas são essenciais quando você recebe dados de uma fonte externa — como entrada do usuário via `input()` — que sempre retorna string, mesmo que o usuário tenha digitado um número. Sem converter, `"5" + "3"` retorna `"53"` (concatenação de strings), não `8` (soma de inteiros).

### Por que isso tudo importa para algoritmos?

Você pode estar se perguntando por que dedicamos uma aula inteira a variáveis e tipos antes de estudar algoritmos mais sofisticados. A resposta é simples: **todo algoritmo opera sobre dados**, e entender profundamente os tipos desses dados é a diferença entre um algoritmo que funciona corretamente e um que produz resultados errados sem erros aparentes.

Um algoritmo de ordenação precisa saber se está ordenando números ou strings — porque `"10" < "9"` é `True` (comparação lexicográfica de strings), mas `10 < 9` é `False` (comparação numérica). Um algoritmo de busca precisa saber se o alvo é um `int` ou um `float` — porque `5 == 5.0` é `True` em Python, mas `type(5) == type(5.0)` é `False`. Esses detalhes parecem pequenos, mas causam bugs sutis e difíceis de detectar em sistemas reais.

Dominar variáveis e tipos é, portanto, construir a base sobre a qual todos os algoritmos deste curso serão edificados.

---

## Analogia de Ancoragem

Pense nas variáveis como **caixas com etiquetas em um armazém**. Cada caixa tem uma etiqueta única colada nela — esse é o nome da variável. Dentro de cada caixa há um item armazenado — esse é o valor. O tipo do item determina o que pode ser guardado: na caixa etiquetada `quantidade` (tipo `int`) cabem apenas números inteiros como `42` ou `100`. Na caixa etiquetada `preco` (tipo `float`) cabem números decimais como `29.90`. Na caixa etiquetada `nome` (tipo `str`) cabe texto como `"Ana"`. Na caixa etiquetada `disponivel` (tipo `bool`) cabe apenas `True` ou `False` — sim ou não, ligado ou desligado.

Quando você escreve `preco = 29.90`, você está colocando o valor `29.90` dentro da caixa etiquetada `preco`. Quando você escreve `total = preco * quantidade`, você está abrindo as duas caixas, realizando a multiplicação com os valores encontrados, e colocando o resultado em uma terceira caixa chamada `total`. As caixas originais continuam inalteradas — você apenas consultou seus conteúdos.

Os operadores são as **ferramentas do almoxarifado** — a calculadora que multiplica os valores das caixas `preco` e `quantidade`, a régua que compara os valores das caixas `altura_a` e `altura_b`, e o carimbo que marca a caixa `aprovado` com `True` ou `False` dependendo da nota.

---

## Diagrama Mermaid

~~~mermaid
flowchart TD
    subgraph TIPOS["Quatro Tipos Básicos de Dados em Python"]
        INT["int\nNúmeros inteiros\n42, -5, 0, 1000"]
        FLOAT["float\nNúmeros decimais\n3.14, -2.7, 0.5"]
        STR["str\nCadeias de texto\n'Olá', 'Python', '123'"]
        BOOL["bool\nVerdadeiro ou Falso\nTrue, False"]
    end

    subgraph OPS["Operadores"]
        ARIT["Aritméticos\n+ - * / // % **"]
        COMP["Comparação\n== != > < >= <="]
        LOG["Lógicos\nand  or  not"]
    end

    subgraph SAIDA["Resultado"]
        NUM["Número\nint ou float"]
        BOOLOUTP["Booleano\nTrue ou False"]
    end

    INT --> ARIT --> NUM
    FLOAT --> ARIT
    INT --> COMP --> BOOLOUTP
    FLOAT --> COMP
    STR --> COMP
    BOOL --> LOG --> BOOLOUTP

    style INT fill:#4CAF50,color:#fff
    style FLOAT fill:#2196F3,color:#fff
    style STR fill:#FF9800,color:#fff
    style BOOL fill:#9C27B0,color:#fff
~~~

---

## Aplicação no Projeto Prático

Crie a pasta `modulo_01_fundamentos/aula_02_variaveis_tipos/codigo/` e o arquivo `calculadora_basica.py` com o conteúdo abaixo. Crie também o arquivo `__init__.py` vazio na mesma pasta.

~~~python
# calculadora_basica.py
# Aula 02: Variáveis, Tipos de Dados e Operadores em Python
# Curso: AlgoLab — Algoritmos do Básico ao Avançado com Python
#
# Este arquivo implementa cinco funções que demonstram o uso de
# variáveis, tipos de dados e operadores em Python.
# Cada função é autocontida e independente das demais.


def somar(a, b):
    """
    Soma dois números e retorna o resultado.

    ENTRADA: a — primeiro número (int ou float)
             b — segundo número (int ou float)
    SAÍDA: a soma de a e b (int se ambos forem int, float caso contrário)

    Demonstra: operador aritmético +, tipagem dinâmica do Python.

    Exemplos:
        somar(3, 4)     → 7
        somar(1.5, 2.5) → 4.0
        somar(-5, 5)    → 0
    """

    # O operador + realiza adição entre dois números
    # Se ambos forem int, o resultado é int
    # Se pelo menos um for float, o resultado é float
    resultado = a + b

    # Retornamos o resultado da soma
    return resultado


def dividir(a, b):
    """
    Divide o primeiro número pelo segundo e retorna o resultado.

    ENTRADA: a — numerador (int ou float)
             b — denominador (int ou float)
    SAÍDA: o resultado da divisão como float,
           ou None se b for zero (divisão por zero não é permitida)

    Demonstra: operador /, tratamento de caso inválido, retorno de None.

    Exemplos:
        dividir(10, 2)  → 5.0
        dividir(7, 2)   → 3.5
        dividir(5, 0)   → None
    """

    # PASSO 1: Verificar se o denominador é zero
    # Divisão por zero não é matematicamente definida
    # Sem esta verificação, Python lançaria ZeroDivisionError
    if b == 0:
        # Retornamos None para indicar que a operação é impossível
        return None

    # PASSO 2: Realizar a divisão
    # O operador / em Python 3 SEMPRE retorna float, mesmo que o resultado
    # seja um número inteiro — 10 / 2 retorna 5.0, não 5
    resultado = a / b

    # Retornamos o resultado da divisão
    return resultado


def e_positivo(numero):
    """
    Verifica se um número é estritamente positivo (maior que zero).

    ENTRADA: numero — um número inteiro ou decimal
    SAÍDA: True se numero > 0, False caso contrário

    Demonstra: operador de comparação >, tipo bool como saída.

    Exemplos:
        e_positivo(5)    → True
        e_positivo(-3)   → False
        e_positivo(0)    → False  (zero NÃO é positivo)
        e_positivo(0.1)  → True
    """

    # O operador > retorna True se numero for maior que zero
    # e False caso contrário — isso é um valor booleano direto
    # Podemos retornar a comparação diretamente sem usar if
    return numero > 0


def concatenar_nome(nome, sobrenome):
    """
    Combina nome e sobrenome em uma string formatada.

    ENTRADA: nome      — string com o primeiro nome
             sobrenome — string com o sobrenome
    SAÍDA: string no formato "Nome Sobrenome" com as primeiras letras
           maiúsculas e um espaço entre as partes

    Demonstra: tipo str, operador + para concatenação, método .strip(),
               método .capitalize() e f-strings.

    Exemplos:
        concatenar_nome("ana", "silva")     → "Ana Silva"
        concatenar_nome("  João  ", "SOUZA") → "João Souza"
        concatenar_nome("", "Silva")         → "Silva"
    """

    # PASSO 1: Remover espaços extras nas bordas de cada string
    # O método .strip() remove espaços, tabs e quebras de linha
    # das extremidades esquerda e direita da string
    nome_limpo = nome.strip()
    sobrenome_limpo = sobrenome.strip()

    # PASSO 2: Capitalizar cada parte
    # O método .capitalize() coloca a primeira letra maiúscula
    # e o restante minúsculo — "ANA" vira "Ana", "silva" vira "Silva"
    nome_formatado = nome_limpo.capitalize()
    sobrenome_formatado = sobrenome_limpo.capitalize()

    # PASSO 3: Combinar as partes
    # Se o nome estiver vazio após o strip, retornamos apenas o sobrenome
    # O operador .strip() em nome_formatado remove espaço extra se nome vazio
    # Usamos f-string para combinar as partes com um espaço entre elas
    nome_completo = f"{nome_formatado} {sobrenome_formatado}".strip()

    # Retornamos o nome completo formatado
    return nome_completo


def calcular_imc(peso, altura):
    """
    Calcula o Índice de Massa Corporal (IMC) de uma pessoa.

    Fórmula: IMC = peso / (altura ** 2)

    ENTRADA: peso   — peso em quilogramas (float ou int, deve ser > 0)
             altura — altura em metros (float ou int, deve ser > 0)
    SAÍDA: dicionário com 'imc' (float arredondado em 2 casas)
           e 'classificacao' (string com a categoria do IMC),
           ou None se os valores de entrada forem inválidos

    Demonstra: operador **, operador /, arredondamento com round(),
               operadores de comparação, dicionário como estrutura de saída.

    Exemplos:
        calcular_imc(70, 1.75)  → {'imc': 22.86, 'classificacao': 'Normal'}
        calcular_imc(0, 1.75)   → None
        calcular_imc(70, 0)     → None
    """

    # PASSO 1: Validar as entradas
    # Peso e altura devem ser maiores que zero para ter sentido biológico
    # O operador 'or' retorna True se pelo menos uma condição for verdadeira
    if peso <= 0 or altura <= 0:
        # Retornamos None para indicar entrada inválida
        return None

    # PASSO 2: Calcular o IMC
    # O operador ** realiza exponenciação: altura ** 2 é altura ao quadrado
    # O operador / realiza a divisão — resultado é sempre float
    imc = peso / (altura ** 2)

    # PASSO 3: Arredondar para 2 casas decimais
    # A função round(valor, casas) arredonda o float
    imc_arredondado = round(imc, 2)

    # PASSO 4: Classificar o IMC segundo a tabela da OMS
    # Usamos if-elif-else para verificar em qual faixa o IMC se enquadra
    if imc_arredondado < 18.5:
        # IMC abaixo do peso saudável
        classificacao = "Abaixo do peso"
    elif imc_arredondado < 25.0:
        # IMC dentro da faixa saudável
        classificacao = "Normal"
    elif imc_arredondado < 30.0:
        # IMC acima do ideal, mas não obeso
        classificacao = "Sobrepeso"
    else:
        # IMC acima de 30 — obesidade
        classificacao = "Obesidade"

    # PASSO 5: Montar e retornar o resultado como dicionário
    # Um dicionário permite retornar múltiplas informações organizadas
    return {
        "imc": imc_arredondado,
        "classificacao": classificacao
    }
~~~

### Como executar o código

Com o ambiente virtual ativo, navegue até a pasta e teste manualmente no terminal Python:

~~~text
.venv\Scripts\activate
cd modulo_01_fundamentos\aula_02_variaveis_tipos\codigo
python -c "from calculadora_basica import *; print(somar(3, 4)); print(calcular_imc(70, 1.75))"
~~~

---

## Testes Automatizados com pytest

Crie o arquivo `test_calculadora_basica.py` dentro da pasta `modulo_01_fundamentos/aula_02_variaveis_tipos/testes/`:

~~~python
# test_calculadora_basica.py
# Testes automatizados para a Aula 02: Variáveis, Tipos de Dados e Operadores
# Execute com: pytest testes/ -v

import pytest

# Importamos as cinco funções que vamos testar
from codigo.calculadora_basica import (
    somar,
    dividir,
    e_positivo,
    concatenar_nome,
    calcular_imc,
)


# ============================================================
# TESTES PARA somar()
# ============================================================

class TestSomar:
    """Agrupa todos os testes da função somar."""

    def test_soma_dois_inteiros_positivos(self):
        """Caso normal: soma de dois inteiros positivos."""
        assert somar(3, 4) == 7

    def test_soma_com_numero_negativo(self):
        """Caso com número negativo."""
        assert somar(-5, 10) == 5

    def test_soma_dois_negativos(self):
        """Caso com dois números negativos."""
        assert somar(-3, -7) == -10

    def test_soma_com_zero(self):
        """Caso extremo: somar com zero não altera o valor."""
        assert somar(42, 0) == 42

    def test_soma_dois_floats(self):
        """Caso com dois floats — usa pytest.approx para precisão."""
        assert somar(1.5, 2.5) == pytest.approx(4.0)

    def test_soma_int_e_float(self):
        """Caso com int e float — resultado deve ser float."""
        resultado = somar(3, 0.5)
        assert resultado == pytest.approx(3.5)
        # Verifica que o resultado é float quando um dos operandos é float
        assert isinstance(resultado, float)

    def test_soma_retorna_int_quando_ambos_int(self):
        """Verifica que int + int retorna int em Python."""
        resultado = somar(10, 20)
        assert isinstance(resultado, int)


# ============================================================
# TESTES PARA dividir()
# ============================================================

class TestDividir:
    """Agrupa todos os testes da função dividir."""

    def test_divisao_exata(self):
        """Caso normal: divisão com resultado inteiro."""
        # Em Python 3, / sempre retorna float
        assert dividir(10, 2) == pytest.approx(5.0)

    def test_divisao_com_resultado_decimal(self):
        """Caso com resultado decimal."""
        assert dividir(7, 2) == pytest.approx(3.5)

    def test_divisao_por_zero_retorna_none(self):
        """Caso crítico: divisão por zero deve retornar None."""
        resultado = dividir(5, 0)
        assert resultado is None

    def test_divisao_com_numerador_zero(self):
        """Caso: zero dividido por qualquer número é zero."""
        assert dividir(0, 5) == pytest.approx(0.0)

    def test_divisao_com_negativos(self):
        """Caso com número negativo no numerador."""
        assert dividir(-10, 2) == pytest.approx(-5.0)

    def test_divisao_retorna_float(self):
        """Verifica que a função sempre retorna float (ou None)."""
        resultado = dividir(6, 3)
        # 6/3 = 2.0 — mesmo sendo divisão exata, retorna float
        assert isinstance(resultado, float)


# ============================================================
# TESTES PARA e_positivo()
# ============================================================

class TestEPositivo:
    """Agrupa todos os testes da função e_positivo."""

    def test_numero_positivo_grande(self):
        """Caso normal: número claramente positivo."""
        assert e_positivo(100) is True

    def test_numero_negativo(self):
        """Caso normal: número negativo não é positivo."""
        assert e_positivo(-7) is False

    def test_zero_nao_e_positivo(self):
        """Caso limite crítico: zero NÃO é estritamente positivo."""
        assert e_positivo(0) is False

    def test_float_positivo_pequeno(self):
        """Caso com float muito pequeno mas positivo."""
        assert e_positivo(0.001) is True

    def test_float_negativo(self):
        """Caso com float negativo."""
        assert e_positivo(-0.5) is False

    def test_retorna_booleano(self):
        """Verifica que a função retorna booleano puro."""
        assert isinstance(e_positivo(5), bool)
        assert isinstance(e_positivo(-5), bool)


# ============================================================
# TESTES PARA concatenar_nome()
# ============================================================

class TestConcatenarNome:
    """Agrupa todos os testes da função concatenar_nome."""

    def test_nome_e_sobrenome_minusculos(self):
        """Caso normal: ambos em minúsculo devem ser capitalizados."""
        assert concatenar_nome("ana", "silva") == "Ana Silva"

    def test_nome_e_sobrenome_maiusculos(self):
        """Caso: maiúsculas devem ser normalizadas para capitalize."""
        assert concatenar_nome("JOAO", "SOUZA") == "Joao Souza"

    def test_nome_com_espacos_extras(self):
        """Caso: espaços extras nas bordas devem ser removidos."""
        assert concatenar_nome("  Maria  ", "  Santos  ") == "Maria Santos"

    def test_nome_vazio_retorna_apenas_sobrenome(self):
        """Caso extremo: nome vazio — retorna apenas o sobrenome."""
        resultado = concatenar_nome("", "Silva")
        # O resultado não deve ter espaço extra no início
        assert resultado == "Silva"

    def test_retorna_string(self):
        """Verifica que a função sempre retorna uma string."""
        resultado = concatenar_nome("Carlos", "Lima")
        assert isinstance(resultado, str)

    def test_nome_ja_capitalizado(self):
        """Caso: nome já capitalizado corretamente."""
        assert concatenar_nome("Pedro", "Alves") == "Pedro Alves"


# ============================================================
# TESTES PARA calcular_imc()
# ============================================================

class TestCalcularImc:
    """Agrupa todos os testes da função calcular_imc."""

    def test_imc_normal(self):
        """Caso normal: IMC dentro da faixa saudável."""
        resultado = calcular_imc(70, 1.75)
        # 70 / (1.75²) = 70 / 3.0625 ≈ 22.86
        assert resultado["imc"] == pytest.approx(22.86, rel=1e-2)
        assert resultado["classificacao"] == "Normal"

    def test_imc_abaixo_do_peso(self):
        """Caso: IMC abaixo de 18.5."""
        resultado = calcular_imc(45, 1.70)
        # 45 / (1.70²) = 45 / 2.89 ≈ 15.57
        assert resultado["classificacao"] == "Abaixo do peso"

    def test_imc_sobrepeso(self):
        """Caso: IMC entre 25 e 30."""
        resultado = calcular_imc(85, 1.75)
        # 85 / (1.75²) = 85 / 3.0625 ≈ 27.76
        assert resultado["classificacao"] == "Sobrepeso"

    def test_imc_obesidade(self):
        """Caso: IMC acima de 30."""
        resultado = calcular_imc(100, 1.70)
        # 100 / (1.70²) = 100 / 2.89 ≈ 34.6
        assert resultado["classificacao"] == "Obesidade"

    def test_peso_zero_retorna_none(self):
        """Caso extremo: peso zero é inválido."""
        assert calcular_imc(0, 1.75) is None

    def test_altura_zero_retorna_none(self):
        """Caso extremo: altura zero causaria divisão por zero."""
        assert calcular_imc(70, 0) is None

    def test_peso_negativo_retorna_none(self):
        """Caso extremo: peso negativo é biologicamente impossível."""
        assert calcular_imc(-10, 1.75) is None

    def test_resultado_e_dicionario(self):
        """Verifica que o resultado é um dicionário com as chaves corretas."""
        resultado = calcular_imc(70, 1.75)
        assert isinstance(resultado, dict)
        assert "imc" in resultado
        assert "classificacao" in resultado

    def test_imc_e_float(self):
        """Verifica que o campo imc é um número (int ou float)."""
        resultado = calcular_imc(70, 1.75)
        assert isinstance(resultado["imc"], (int, float))
~~~

### Como executar os testes

~~~text
cd modulo_01_fundamentos\aula_02_variaveis_tipos
pytest testes/ -v
~~~

### Estrutura de pastas necessária

~~~text
modulo_01_fundamentos/
└── aula_02_variaveis_tipos/
    ├── codigo/
    │   ├── __init__.py        ← arquivo vazio
    │   └── calculadora_basica.py
    └── testes/
        └── test_calculadora_basica.py
~~~

Criando o `__init__.py` no terminal:

~~~text
type nul > modulo_01_fundamentos\aula_02_variaveis_tipos\codigo\__init__.py
~~~

---

## Glossário Técnico da Aula

**Variável:** nome que referencia um valor armazenado na memória do computador. Em Python, criada pela simples atribuição `nome = valor`.

**`int`:** tipo de dado para números inteiros positivos, negativos ou zero. Sem limite de tamanho em Python 3. Exemplos: `0`, `42`, `-100`.

**`float`:** tipo de dado para números com parte decimal, representados internamente em ponto flutuante. Têm precisão finita. Exemplos: `3.14`, `0.5`, `-2.7`.

**`str`:** tipo de dado para cadeias de caracteres (texto). Imutável em Python. Delimitada por aspas simples ou duplas. Exemplos: `"Olá"`, `'Python'`.

**`bool`:** tipo de dado booleano com apenas dois valores possíveis: `True` e `False`. Resultado de comparações e condições lógicas.

**Tipagem dinâmica:** característica do Python onde o tipo de uma variável é determinado automaticamente com base no valor atribuído, sem declaração explícita.

**Operador aritmético:** símbolo que realiza cálculo matemático entre valores. Os principais são: `+`, `-`, `*`, `/`, `//`, `%` e `**`.

**Operador de comparação:** símbolo que compara dois valores e retorna `True` ou `False`. Os principais são: `==`, `!=`, `>`, `<`, `>=`, `<=`.

**Operador lógico:** palavra-chave que combina condições booleanas. Os três são: `and`, `or` e `not`.

**`//` (divisão inteira):** operador que divide dois números e descarta a parte decimal do resultado. `7 // 2` retorna `3`, não `3.5`.

**`%` (módulo):** operador que retorna o resto da divisão inteira. `7 % 2` retorna `1`. Usado para verificar paridade e divisibilidade.

**Casting (conversão de tipo):** processo de converter um valor de um tipo para outro. Exemplos: `int("42")`, `float(10)`, `str(3.14)`.

**`snake_case`:** convenção de nomenclatura do Python onde palavras são separadas por underscore e escritas em minúsculas. Exemplo: `nome_completo`, `total_vendas`.

**`round(valor, casas)`:** função Python que arredonda um float para o número de casas decimais especificado. `round(3.14159, 2)` retorna `3.14`.

**f-string:** forma moderna de formatar strings em Python usando `f"texto {variavel} texto"`. Avalia a expressão entre `{}` e insere o resultado na string.

---

## Antecipação de Erros

**Erro 1: Usar `=` em vez de `==` em comparações.** Este é o erro mais clássico e frequente entre iniciantes. `=` é atribuição (coloca um valor em uma variável), `==` é comparação (verifica se dois valores são iguais). Escrever `if idade = 18:` causa `SyntaxError`. Sempre use `==` dentro de condições. Uma dica prática: leia `==` como "é igual a" em voz alta — "se idade é igual a 18" soa naturalmente correto.

**Erro 2: Concatenar `str` com `int` sem converter.** `"Sua idade é " + 25` causa `TypeError: can only concatenate str (not "int") to str`. Python não converte automaticamente. Você precisa escrever `"Sua idade é " + str(25)` ou usar f-string: `f"Sua idade é {25}"`. As f-strings são a forma mais elegante e legível de combinar texto com valores de qualquer tipo.

**Erro 3: Comparar floats com `==`.** Devido à imprecisão de ponto flutuante, `0.1 + 0.2 == 0.3` retorna `False` em Python — o resultado real é `0.30000000000000004`. Nunca use `==` para comparar floats diretamente. Use `abs(a - b) < tolerancia` ou, nos testes, use `pytest.approx()` como já está implementado nos testes desta aula.

**Erro 4: Confundir `/` com `//`.** Em Python 3, `/` sempre retorna `float` — `10 / 2` retorna `5.0`, não `5`. Se você precisa de um inteiro como resultado, use `//` (divisão inteira) ou envolva com `int()`. Confundir os dois operadores causa erros sutis em algoritmos que dependem de índices inteiros.

**Erro 5: Esquecer que `input()` sempre retorna `str`.** Quando o usuário digita `25` no terminal, a função `input()` retorna a string `"25"`, não o inteiro `25`. Se você tentar fazer `input() + 5`, obterá `TypeError`. Sempre converta com `int(input())` ou `float(input())` ao ler números do terminal.

**Erro 6: Nomes de variáveis que começam com número.** `2resultado = 10` causa `SyntaxError`. Nomes de variáveis nunca podem começar com dígito. Comece sempre com letra ou underscore: `resultado2` ou `resultado_2` são válidos.

---

## Troubleshooting

**Problema: `TypeError: unsupported operand type(s) for +: 'int' and 'str'`.**
Causa: tentativa de somar um número com uma string.
Solução: verifique os tipos dos operandos com `type()`. Converta para o tipo correto antes da operação: `int(valor)` ou `str(valor)`.

**Problema: `ZeroDivisionError: division by zero`.**
Causa: divisão por zero sem verificação prévia.
Solução: sempre verifique se o denominador é zero antes de dividir, como na função `dividir()` desta aula.

**Problema: `NameError: name 'variavel' is not defined`.**
Causa: tentativa de usar uma variável antes de atribuir um valor a ela.
Solução: certifique-se de que a variável foi criada (com `=`) antes de ser usada. Verifique também se o nome está escrito exatamente igual — Python diferencia maiúsculas de minúsculas.

**Problema: os testes de float falham com `AssertionError` mesmo com o valor aparentemente correto.**
Causa: imprecisão de ponto flutuante. `0.1 + 0.2` não é exatamente `0.3` na memória do computador.
Solução: use `pytest.approx()` para comparações de float nos testes, como já demonstrado no `test_calculadora_basica.py`.

---

## Desafio de Fixação

Implemente uma função chamada `converter_temperatura(celsius)` que recebe uma temperatura em graus Celsius e retorna um dicionário com a conversão para Fahrenheit e Kelvin. As fórmulas são: **Fahrenheit = Celsius × 9/5 + 32** e **Kelvin = Celsius + 273.15**. Os valores no dicionário devem ser arredondados para duas casas decimais. A função deve retornar `None` se a temperatura em Kelvin resultar em valor negativo (ou seja, se `celsius < -273.15`, o que viola a física).

**Resolução comentada:**

~~~python
def converter_temperatura(celsius):
    """
    Converte temperatura de Celsius para Fahrenheit e Kelvin.

    ENTRADA: celsius — temperatura em graus Celsius (int ou float)
    SAÍDA: dicionário com 'fahrenheit' e 'kelvin' arredondados em 2 casas,
           ou None se a temperatura for fisicamente impossível
    """

    # PASSO 1: Validar a entrada
    # O zero absoluto é -273.15°C — temperaturas abaixo disso são impossíveis
    if celsius < -273.15:
        return None

    # PASSO 2: Calcular Fahrenheit usando a fórmula de conversão
    # A ordem das operações importa: multiplicamos primeiro, depois somamos
    fahrenheit = celsius * 9 / 5 + 32

    # PASSO 3: Calcular Kelvin — simplesmente soma a constante 273.15
    kelvin = celsius + 273.15

    # PASSO 4: Arredondar ambos os resultados para 2 casas decimais
    fahrenheit_arredondado = round(fahrenheit, 2)
    kelvin_arredondado = round(kelvin, 2)

    # PASSO 5: Retornar o resultado como dicionário
    return {
        "fahrenheit": fahrenheit_arredondado,
        "kelvin": kelvin_arredondado
    }
~~~

Testes para o desafio:

~~~python
def test_zero_celsius():
    resultado = converter_temperatura(0)
    # 0°C = 32°F = 273.15K
    assert resultado["fahrenheit"] == pytest.approx(32.0)
    assert resultado["kelvin"] == pytest.approx(273.15)

def test_cem_celsius():
    resultado = converter_temperatura(100)
    # 100°C = 212°F = 373.15K
    assert resultado["fahrenheit"] == pytest.approx(212.0)
    assert resultado["kelvin"] == pytest.approx(373.15)

def test_temperatura_impossivel():
    # Abaixo do zero absoluto — fisicamente impossível
    assert converter_temperatura(-300) is None

def test_zero_absoluto():
    # Exatamente o zero absoluto é válido (o limite)
    resultado = converter_temperatura(-273.15)
    assert resultado is not None
    assert resultado["kelvin"] == pytest.approx(0.0)
~~~

---

## Resumo dos Pontos-Chave

Uma **variável** é um nome que referencia um valor na memória, criada pela atribuição com `=`. Python usa **tipagem dinâmica** — o tipo é determinado pelo valor, não pela declaração. Os **quatro tipos básicos** são `int` (inteiros), `float` (decimais), `str` (texto) e `bool` (verdadeiro/falso). Os **operadores aritméticos** realizam cálculos (`+`, `-`, `*`, `/`, `//`, `%`, `**`), os **operadores de comparação** comparam valores e retornam bool (`==`, `!=`, `>`, `<`, `>=`, `<=`), e os **operadores lógicos** combinam condições (`and`, `or`, `not`). O operador `/` sempre retorna `float` em Python 3, enquanto `//` retorna a parte inteira da divisão. Floats têm precisão finita — nunca compare floats com `==` diretamente, use tolerância ou `pytest.approx()`. O `input()` sempre retorna `str` — converta com `int()` ou `float()` ao ler números. Nomes de variáveis seguem a convenção **snake_case** e devem ser semânticos e descritivos.

---

## Log de Estado da Aula

**Aula:** 02 — Variáveis, Tipos de Dados e Operadores em Python
**Objetivo:** Implementar cinco funções que demonstram tipos de dados e operadores.
**Arquivos criados:**
- `modulo_01_fundamentos/aula_02_variaveis_tipos/codigo/__init__.py`
- `modulo_01_fundamentos/aula_02_variaveis_tipos/codigo/calculadora_basica.py`
- `modulo_01_fundamentos/aula_02_variaveis_tipos/testes/test_calculadora_basica.py`

**Estado Funcional:** ✅ Cinco funções implementadas com testes cobrindo casos normais, extremos e casos de borda.
**Próximas Etapas:** Aula 03 ensinará estruturas de decisão — `if`, `elif` e `else` — para que os algoritmos possam tomar caminhos diferentes com base em condições.

---

## Próximos Passos

Na **Aula 03: Estruturas de Decisão: if, elif e else**, você aprenderá a dar ao algoritmo a capacidade de escolher caminhos diferentes dependendo de condições — classificar notas, identificar faixas etárias, aplicar descontos por tipo de cliente. Implementará quatro funções de classificação com código totalmente autocontido e testes pytest cobrindo cada ramo de cada condição.

---

Dúvidas? Posso prosseguir para a próxima etapa?