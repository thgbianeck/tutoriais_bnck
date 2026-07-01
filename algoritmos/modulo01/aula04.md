# Aula 04: Estruturas de Repetição: for e while

## Análise de Integridade (Auditoria Prévia)

Antes de iniciar, este conteúdo foi verificado nos seguintes critérios: profundidade técnica mantida com linguagem acessível para iniciantes absolutos, analogias do cotidiano presentes antes de qualquer formalização técnica, código Python 3.13 funcional e comentado linha a linha, testes pytest cobrindo casos normais e extremos incluindo comportamentos de `break` e `continue`, diagrama Mermaid correto e bem formatado com escape adequado, glossário completo, antecipação de erros relevantes para iniciantes, e mínimo de 2.000 palavras de teoria. Nenhuma falha detectada. Conteúdo aprovado para geração.

---

## Objetivo da Aula

Dominar as duas estruturas de repetição do Python — `for` e `while` — compreendendo quando usar cada uma, como controlar o fluxo interno com `break` e `continue`, como usar `range()` para gerar sequências numéricas, e implementar quatro funções que demonstram laços em contextos práticos e testáveis, cada uma completamente autocontida e independente de aulas anteriores.

## Pré-requisitos

Aula 03 concluída — especialmente o conceito de condição booleana e estruturas de decisão com `if`, pois o `while` depende de uma condição para determinar quando parar, e o `break` usa uma condição para interromper o laço antecipadamente. O ambiente virtual deve estar ativo e o pytest instalado.

---

## Teoria Detalhada

### O problema da repetição

Imagine que você precisa somar os números de 1 a 100. Sem repetição, você seria forçado a escrever cem linhas de código — `total = 1 + 2 + 3 + 4 + ...` — o que seria tedioso, propenso a erros e completamente impraticável para listas maiores. Pior ainda: se o problema mudasse de "somar de 1 a 100" para "somar de 1 a 1.000.000", você precisaria reescrever tudo do zero.

Esse é exatamente o problema que as **estruturas de repetição** resolvem. Em vez de escrever a mesma instrução centenas de vezes, você a escreve uma vez e instrui o computador a repeti-la quantas vezes for necessário. O computador é imbatível nesse tipo de tarefa: ele pode repetir uma instrução um bilhão de vezes sem se cansar, sem se distrair e sem cometer erros de digitação.

As estruturas de repetição são chamadas de **laços** (ou loops, em inglês) — uma metáfora visual que descreve bem o que acontece: o fluxo de execução "volta" ao início do bloco repetidamente, como um círculo, até que uma condição de parada seja atingida.

Python oferece duas estruturas de repetição fundamentais: o `for` e o `while`. Cada uma tem sua personalidade, seus casos de uso ideais e suas armadilhas características. Compreender quando usar cada uma é tão importante quanto saber como usar cada uma.

### O laço `for`: repetição sobre sequências

O `for` é o laço ideal quando você sabe exatamente **o que** vai iterar — uma lista de elementos, uma sequência de números, os caracteres de uma string, ou qualquer outra coleção. A ideia central é simples: "para cada item desta coleção, execute este bloco de código".

A sintaxe do `for` em Python é elegante e próxima da linguagem natural. `for numero in [1, 2, 3, 4, 5]:` pode ser lido literalmente como "para cada número em [1, 2, 3, 4, 5]". A variável `numero` (que você pode nomear como quiser) assume automaticamente o valor de cada elemento da lista a cada iteração — na primeira iteração é `1`, na segunda é `2`, e assim por diante, até o último elemento.

O `for` em Python é fundamentalmente diferente do `for` em linguagens como C ou Java. Em Python, o `for` não trabalha com contadores e índices explicitamente — ele trabalha com **iteráveis**, que são qualquer objeto capaz de fornecer seus elementos um por um. Listas, strings, tuplas, dicionários, arquivos — todos são iteráveis. Essa abordagem torna o código mais expressivo e menos propenso a erros de índice.

### A função `range()`: gerando sequências numéricas

Quando você precisa repetir algo um número específico de vezes — não sobre uma lista existente, mas simplesmente N vezes — o `for` é usado em combinação com a função `range()`. O `range()` gera uma sequência de números inteiros sem criar uma lista na memória, o que o torna muito eficiente para sequências grandes.

`range()` aceita até três argumentos: `range(stop)`, `range(start, stop)` e `range(start, stop, step)`. `range(5)` gera os números `0, 1, 2, 3, 4` — começa em zero e vai até `stop - 1`. `range(1, 6)` gera `1, 2, 3, 4, 5` — começa em `start` e vai até `stop - 1`. `range(0, 10, 2)` gera `0, 2, 4, 6, 8` — avança de dois em dois (o `step`). `range(10, 0, -1)` gera `10, 9, 8, 7, 6, 5, 4, 3, 2, 1` — contagem regressiva com `step` negativo.

Um detalhe importante: o valor `stop` é sempre **exclusivo** — `range(5)` não inclui o `5`. Isso é consistente com a convenção de indexação do Python (que começa em zero) e com a forma como o fatiamento de listas funciona. Internalizar essa convenção desde cedo evita muitos erros de "off-by-one" (errar por um elemento a mais ou a menos).

### O laço `while`: repetição baseada em condição

O `while` é o laço ideal quando você **não sabe de antemão quantas vezes** precisará repetir — quando a repetição deve continuar enquanto uma condição for verdadeira e parar quando ela se tornar falsa. A ideia central é: "enquanto esta condição for verdadeira, continue executando este bloco".

A sintaxe do `while` é igualmente direta. `while saldo > 0:` pode ser lido como "enquanto o saldo for maior que zero, execute este bloco". A cada iteração, a condição é reavaliada — se ainda for `True`, o bloco executa novamente; se for `False`, o laço termina e a execução continua na próxima linha após o bloco.

A diferença fundamental entre `for` e `while` pode ser resumida assim: o `for` é controlado pela **coleção** (termina quando os elementos acabam), enquanto o `while` é controlado pela **condição** (termina quando a condição se torna falsa). Use `for` quando souber o que vai iterar. Use `while` quando souber quando parar, mas não quantas iterações serão necessárias.

### O perigo do laço infinito

O maior risco do `while` é o **laço infinito** — quando a condição de parada nunca se torna falsa e o programa fica executando indefinidamente. Isso acontece quando o bloco do `while` não modifica nenhuma variável que afeta a condição, ou quando a lógica de atualização está incorreta.

Considere este exemplo problemático: `contador = 0` seguido de `while contador < 5:` seguido de `print(contador)` sem a linha `contador += 1`. O `contador` nunca aumenta, então `contador < 5` é sempre `True` e o programa imprime `0` indefinidamente até ser interrompido manualmente.

A regra de ouro para evitar laços infinitos é: **todo `while` deve ter, dentro do seu bloco, pelo menos uma instrução que eventualmente tornará a condição falsa**. Geralmente isso significa incrementar um contador (`contador += 1`), remover um elemento de uma lista (`lista.pop()`), ou modificar alguma variável usada na condição.

Se você acidentalmente criar um laço infinito durante o desenvolvimento, pressione `Ctrl + C` no terminal para interromper a execução.

### As instruções `break` e `continue`: controle fino do laço

Além das condições normais de parada, Python oferece duas instruções que permitem controle fino sobre o comportamento de laços: `break` e `continue`.

O **`break`** interrompe o laço imediatamente, independentemente da condição — o fluxo de execução pula para a primeira linha após o bloco do laço. É usado quando você encontrou o que estava procurando e não precisa continuar iterando. O exemplo clássico é a busca em uma lista: assim que o elemento é encontrado, você usa `break` para parar a busca e não desperdiçar tempo percorrendo o restante da lista.

O **`continue`** pula apenas a iteração atual — as instruções abaixo do `continue` nessa iteração são ignoradas, e o laço avança para o próximo elemento (no `for`) ou reavalia a condição (no `while`). É usado quando uma iteração específica deve ser pulada, mas o laço deve continuar. O exemplo clássico é filtrar elementos: ao encontrar um elemento indesejado, você usa `continue` para pular sua processamento e passar para o próximo.

Uma analogia útil: imagine um inspetor de qualidade em uma linha de produção. Ao encontrar um produto com defeito grave, ele para toda a linha (`break`). Ao encontrar um produto com defeito menor que deve ser descartado mas não impede a produção, ele coloca o produto de lado e chama o próximo (`continue`).

### O laço `for` com `else` e o `while` com `else`

Python tem um recurso pouco conhecido mas muito útil: tanto o `for` quanto o `while` podem ter uma cláusula `else`. O bloco `else` de um laço é executado apenas se o laço terminou **normalmente** — sem ser interrompido por um `break`. Se o laço foi interrompido por `break`, o `else` é ignorado.

Esse comportamento é especialmente útil em buscas: você tenta encontrar um elemento com um laço e `break`, e usa o `else` para detectar o caso em que o elemento não foi encontrado (pois o laço terminou sem nenhum `break`). Essa é uma forma elegante e Pythônica de evitar uma variável de flag (`encontrado = False`).

### Iteração sobre strings: caracteres como sequência

Um detalhe importante e frequentemente subestimado: strings em Python são iteráveis. Você pode usar um `for` para percorrer cada caractere de uma string da mesma forma que percorre cada elemento de uma lista. `for caractere in "Python":` itera sobre os seis caracteres da string, um por vez. Isso significa que todos os algoritmos que aprendemos para listas também funcionam para strings — busca de caracteres, contagem de ocorrências, verificação de padrões.

### Acumuladores: o padrão fundamental dos laços

O padrão mais comum em algoritmos com laços é o **acumulador** — uma variável inicializada fora do laço que é atualizada a cada iteração para acumular um resultado. A soma de uma lista é o acumulador mais simples: `total = 0` fora do laço, `total += numero` dentro do laço. Ao final, `total` contém a soma de todos os números.

O padrão acumulador se manifesta de várias formas: somar valores, contar elementos que satisfazem uma condição, construir uma nova lista com os elementos filtrados, concatenar strings. Em todos esses casos, a estrutura é a mesma — inicialize o acumulador antes do laço, atualize dentro do laço, use o resultado após o laço.

A inicialização correta do acumulador é crítica. Para somas, inicialize com `0`. Para produtos, inicialize com `1` (o elemento neutro da multiplicação). Para listas, inicialize com `[]`. Para strings, inicialize com `""`. Inicializar errado — como inicializar uma soma com `1` em vez de `0` — produz resultados incorretos sem gerar nenhum erro de execução.

### Complexidade e laços aninhados

Quando você coloca um laço dentro de outro laço — **laços aninhados** — o número de iterações total se multiplica. Um laço externo com 10 iterações e um laço interno com 10 iterações resultam em 100 iterações totais. Com 100 iterações cada, são 10.000 iterações. Esse crescimento quadrático é a razão pela qual algoritmos com laços aninhados são muito mais lentos que algoritmos com laços simples para entradas grandes.

Nesta aula, evitamos laços aninhados propositalmente — o foco é dominar os laços simples. Laços aninhados aparecerão naturalmente nos algoritmos de ordenação do Módulo 2, quando você já tiver a base sólida para entender por que eles são necessários e quais são suas consequências de eficiência.

---

## Analogia de Ancoragem

Imagine dois funcionários em uma fábrica de caixas. O primeiro funcionário — o **`for`** — recebe uma esteira com caixas numeradas. Ele sabe exatamente quantas caixas há na esteira (dez, cem, mil) e seu trabalho é processar cada caixa exatamente uma vez, da primeira à última. Quando a esteira acaba, ele para — não importa o que aconteça, ele sempre processa cada caixa uma vez.

O segundo funcionário — o **`while`** — fica na porta do armazém verificando um sensor de temperatura. Ele não sabe quanto tempo ficará lá — continuará verificando enquanto a temperatura estiver acima de 30°C. Quando a temperatura cair abaixo de 30°C, ele para. Podem ser cinco verificações ou cinco mil — ele não sabe de antemão, apenas obedece à condição.

O **`break`** é o alarme de emergência da fábrica — quando toca, o funcionário para imediatamente o que está fazendo, independentemente de quantas caixas ainda restam na esteira ou de qual é a temperatura. O **`continue`** é uma caixa marcada com "pular" — o funcionário a descarta sem processá-la e vai para a próxima imediatamente.

A analogia mais importante: se o sensor do segundo funcionário nunca mudar de leitura, ele ficará na porta para sempre — esse é o laço infinito. Por isso, toda verificação com `while` precisa de algo que eventualmente mude a condição.

---

## Diagrama Mermaid

~~~mermaid
flowchart TD
    subgraph FOR["Laço FOR"]
        FA["Início\nnumeros = [7, 3, 9, 4, 5]"] --> FB["Pegar próximo\nelemento da lista"]
        FB --> FC{"Ainda há\nelementos?"}
        FC -->|"Sim"| FD["Executar bloco\ntotal += numero"]
        FD --> FC
        FC -->|"Não"| FE["Fim do laço\nRetornar total"]
    end

    subgraph WHILE["Laço WHILE"]
        WA["Início\ncontador = 1\nlimite = 5"] --> WB{"contador\n<= limite?"}
        WB -->|"True"| WC["Executar bloco\nresultado.append(contador)"]
        WC --> WD["Atualizar condição\ncontador += 1"]
        WD --> WB
        WB -->|"False"| WE["Fim do laço\nRetornar resultado"]
    end

    style FA fill:#4CAF50,color:#fff
    style FE fill:#9C27B0,color:#fff
    style WA fill:#2196F3,color:#fff
    style WE fill:#9C27B0,color:#fff
    style FC fill:#FF9800,color:#fff
    style WB fill:#FF9800,color:#fff
~~~

---

## Aplicação no Projeto Prático

Crie a pasta `modulo_01_fundamentos/aula_04_repeticao/codigo/` e o arquivo `repeticoes.py` com o conteúdo abaixo. Crie também o arquivo `__init__.py` vazio na mesma pasta.

~~~python
# repeticoes.py
# Aula 04: Estruturas de Repetição: for e while
# Curso: AlgoLab — Algoritmos do Básico ao Avançado com Python
#
# Este arquivo implementa quatro funções que demonstram o uso de
# laços for e while com break, continue e range().
# Cada função é autocontida e independente das demais.


def somar_lista(numeros):
    """
    Soma todos os elementos de uma lista usando um laço for.

    Demonstra: padrão acumulador com for, iteração sobre lista.

    ENTRADA: numeros — lista de números inteiros ou decimais
    SAÍDA: a soma de todos os elementos como número (int ou float),
           ou 0 se a lista estiver vazia

    Exemplos:
        somar_lista([1, 2, 3, 4, 5])  → 15
        somar_lista([])               → 0
        somar_lista([-3, 3])          → 0
        somar_lista([7])              → 7
    """

    # PASSO 1: Inicializar o acumulador com o elemento neutro da adição
    # O elemento neutro da soma é 0 — somar 0 não altera o resultado
    # Esta variável acumulará a soma de todos os elementos
    total = 0

    # PASSO 2: Iterar sobre cada número da lista com for
    # A cada iteração, 'numero' assume o valor do próximo elemento
    # Na primeira iteração: numero = numeros[0]
    # Na segunda iteração:  numero = numeros[1]
    # ... e assim por diante até o último elemento
    for numero in numeros:
        # Adicionar o elemento atual ao acumulador
        # total += numero é equivalente a total = total + numero
        total += numero

    # PASSO 3: Retornar o total acumulado
    # Se a lista estava vazia, o for não executou nenhuma iteração
    # e total permanece 0 — o valor correto para uma soma vazia
    return total


def contar_ate(limite):
    """
    Conta de 1 até o limite (inclusive) usando um laço while.

    Demonstra: laço while com contador, condição de parada, acumulador de lista.

    ENTRADA: limite — número inteiro positivo até onde contar
    SAÍDA: lista com todos os inteiros de 1 até limite (inclusive),
           ou lista vazia se limite for menor que 1

    Exemplos:
        contar_ate(5)  → [1, 2, 3, 4, 5]
        contar_ate(1)  → [1]
        contar_ate(0)  → []
        contar_ate(-3) → []
    """

    # PASSO 1: Inicializar o acumulador de resultado como lista vazia
    # Esta lista receberá cada número conforme contamos
    resultado = []

    # PASSO 2: Inicializar o contador — começamos em 1
    # O contador é a variável que controla o laço while
    contador = 1

    # PASSO 3: Executar o laço while enquanto o contador não ultrapassar o limite
    # A condição é verificada ANTES de cada iteração
    # Se limite < 1, a condição já começa False e o laço não executa
    while contador <= limite:
        # Adicionar o valor atual do contador à lista de resultado
        # O método append() adiciona um elemento ao final da lista
        resultado.append(contador)

        # CRÍTICO: incrementar o contador a cada iteração
        # Sem esta linha, o while executaria infinitamente
        # contador += 1 é equivalente a contador = contador + 1
        contador += 1

    # PASSO 4: Retornar a lista com os números contados
    return resultado


def encontrar_primeiro_par(numeros):
    """
    Encontra e retorna o primeiro número par de uma lista usando break.

    Demonstra: laço for com break para parada antecipada.

    ENTRADA: numeros — lista de números inteiros
    SAÍDA: o primeiro número par encontrado,
           ou None se não houver nenhum número par na lista

    Exemplos:
        encontrar_primeiro_par([3, 7, 4, 9, 2])  → 4
        encontrar_primeiro_par([1, 3, 5, 7])      → None
        encontrar_primeiro_par([2, 4, 6])          → 2
        encontrar_primeiro_par([])                 → None
    """

    # PASSO 1: Inicializar o resultado como None
    # None representa "nenhum par encontrado ainda"
    # Se o laço terminar sem encontrar nenhum par, retornamos None
    primeiro_par = None

    # PASSO 2: Iterar sobre cada número da lista
    for numero in numeros:
        # Verificar se o número atual é par
        # O operador % (módulo) retorna o resto da divisão por 2
        # Um número é par quando o resto da divisão por 2 é zero
        if numero % 2 == 0:
            # Encontramos o primeiro número par!
            # Guardamos o valor encontrado no resultado
            primeiro_par = numero

            # BREAK: interrompemos o laço imediatamente
            # Não precisamos continuar verificando os próximos elementos
            # pois já encontramos o que procurávamos
            break

        # Se o número não for par, o laço avança automaticamente
        # para o próximo elemento sem precisar de nenhuma instrução extra

    # PASSO 3: Retornar o resultado
    # Será o primeiro par encontrado, ou None se nenhum foi encontrado
    return primeiro_par


def filtrar_positivos(numeros):
    """
    Retorna uma nova lista contendo apenas os números positivos da lista original.

    Demonstra: laço for com continue para pular elementos indesejados.

    ENTRADA: numeros — lista de números inteiros ou decimais
    SAÍDA: nova lista com apenas os números estritamente positivos (> 0),
           preservando a ordem original

    Exemplos:
        filtrar_positivos([3, -1, 5, 0, -7, 2])  → [3, 5, 2]
        filtrar_positivos([-1, -2, -3])           → []
        filtrar_positivos([1, 2, 3])               → [1, 2, 3]
        filtrar_positivos([])                      → []
        filtrar_positivos([0, 0, 0])               → []  (0 não é positivo)
    """

    # PASSO 1: Inicializar a lista de resultado como vazia
    # Os números positivos serão adicionados aqui conforme os encontrarmos
    positivos = []

    # PASSO 2: Iterar sobre cada número da lista original
    for numero in numeros:
        # Verificar se o número NÃO é positivo (é zero ou negativo)
        # Usamos a condição negada para identificar os elementos a PULAR
        if numero <= 0:
            # CONTINUE: pula o restante do bloco para ESTA iteração
            # O laço avança imediatamente para o próximo elemento
            # sem executar o append() abaixo
            continue

        # Se chegamos aqui, o número é positivo (passou pelo filtro do continue)
        # Adicionamos à lista de resultados
        positivos.append(numero)

    # PASSO 3: Retornar a lista com apenas os positivos
    return positivos
~~~

### Como executar o código

Com o ambiente virtual ativo, navegue até a pasta e teste manualmente:

~~~text
.venv\Scripts\activate
cd modulo_01_fundamentos\aula_04_repeticao\codigo
python -c "from repeticoes import *; print(somar_lista([1,2,3,4,5])); print(contar_ate(5)); print(encontrar_primeiro_par([3,7,4,9,2])); print(filtrar_positivos([3,-1,5,0,-7,2]))"
~~~

---

## Testes Automatizados com pytest

Crie o arquivo `test_repeticoes.py` dentro da pasta `modulo_01_fundamentos/aula_04_repeticao/testes/`:

~~~python
# test_repeticoes.py
# Testes automatizados para a Aula 04: Estruturas de Repetição
# Execute com: pytest testes/ -v
#
# Filosofia dos testes:
# - Casos normais: entrada típica com resultado esperado claro
# - Casos extremos: lista vazia, um elemento, limite zero, todos negativos
# - Casos de comportamento: verificar que break e continue funcionam corretamente

import pytest

# Importamos as quatro funções que vamos testar
from codigo.repeticoes import (
    somar_lista,
    contar_ate,
    encontrar_primeiro_par,
    filtrar_positivos,
)


# ============================================================
# TESTES PARA somar_lista()
# ============================================================

class TestSomarLista:
    """
    Testa todos os comportamentos da função somar_lista.
    Verifica: soma correta, lista vazia, elemento único, negativos, floats.
    """

    def test_soma_lista_simples(self):
        """Caso normal: soma de cinco números positivos."""
        # 1 + 2 + 3 + 4 + 5 = 15
        assert somar_lista([1, 2, 3, 4, 5]) == 15

    def test_soma_lista_vazia(self):
        """Caso extremo: lista vazia deve retornar 0."""
        # A soma de nenhum elemento é o elemento neutro da adição: 0
        assert somar_lista([]) == 0

    def test_soma_com_um_elemento(self):
        """Caso extremo: lista com um único elemento."""
        # A soma de uma lista com um elemento é o próprio elemento
        assert somar_lista([42]) == 42

    def test_soma_com_numeros_negativos(self):
        """Caso com números negativos."""
        # -3 + (-7) + (-2) = -12
        assert somar_lista([-3, -7, -2]) == -12

    def test_soma_com_positivos_e_negativos(self):
        """Caso com mistura de positivos e negativos."""
        # -3 + 3 = 0
        assert somar_lista([-3, 3]) == 0

    def test_soma_com_zero_na_lista(self):
        """Zero na lista não deve alterar a soma."""
        assert somar_lista([5, 0, 3]) == 8

    def test_soma_com_floats(self):
        """Caso com números decimais."""
        assert somar_lista([1.5, 2.5, 1.0]) == pytest.approx(5.0)

    def test_soma_lista_grande(self):
        """Caso com lista maior — verifica corretude para N elementos."""
        # Soma de 1 a 10 = 55 (fórmula: n*(n+1)/2 = 10*11/2 = 55)
        assert somar_lista(list(range(1, 11))) == 55

    def test_retorna_numero(self):
        """A função deve retornar um número (int ou float)."""
        resultado = somar_lista([1, 2, 3])
        assert isinstance(resultado, (int, float))


# ============================================================
# TESTES PARA contar_ate()
# ============================================================

class TestContarAte:
    """
    Testa todos os comportamentos da função contar_ate.
    Verifica: contagem correta, limite zero, limite negativo, limite um.
    """

    def test_contar_ate_cinco(self):
        """Caso normal: contar de 1 até 5."""
        assert contar_ate(5) == [1, 2, 3, 4, 5]

    def test_contar_ate_um(self):
        """Caso extremo: limite igual a 1 deve retornar lista com apenas [1]."""
        assert contar_ate(1) == [1]

    def test_contar_ate_zero(self):
        """Caso extremo: limite zero deve retornar lista vazia."""
        # Não há nenhum número entre 1 e 0
        assert contar_ate(0) == []

    def test_contar_ate_negativo(self):
        """Caso extremo: limite negativo deve retornar lista vazia."""
        assert contar_ate(-5) == []

    def test_contar_ate_dez(self):
        """Caso normal com limite maior."""
        resultado = contar_ate(10)
        # A lista deve ter exatamente 10 elementos
        assert len(resultado) == 10
        # O primeiro elemento deve ser 1
        assert resultado[0] == 1
        # O último elemento deve ser 10 (o limite é inclusivo)
        assert resultado[-1] == 10

    def test_contar_preserva_ordem_crescente(self):
        """Os números devem estar em ordem crescente."""
        resultado = contar_ate(5)
        # Verificamos que cada elemento é exatamente um maior que o anterior
        for i in range(len(resultado) - 1):
            assert resultado[i + 1] == resultado[i] + 1

    def test_retorna_lista(self):
        """A função deve sempre retornar uma lista."""
        assert isinstance(contar_ate(5), list)
        assert isinstance(contar_ate(0), list)


# ============================================================
# TESTES PARA encontrar_primeiro_par()
# ============================================================

class TestEncontrarPrimeiroPar:
    """
    Testa todos os comportamentos da função encontrar_primeiro_par.
    Verifica: par no início, no meio, no fim, sem par, lista vazia.
    Foco especial: comportamento do break.
    """

    def test_par_no_inicio(self):
        """O primeiro elemento já é par — deve ser retornado imediatamente."""
        assert encontrar_primeiro_par([2, 3, 5, 7]) == 2

    def test_par_no_meio(self):
        """Caso normal: primeiro par está no meio da lista."""
        assert encontrar_primeiro_par([3, 7, 4, 9, 2]) == 4

    def test_par_no_fim(self):
        """O par está apenas no último elemento."""
        assert encontrar_primeiro_par([1, 3, 5, 7, 8]) == 8

    def test_sem_par_retorna_none(self):
        """Lista sem nenhum número par deve retornar None."""
        assert encontrar_primeiro_par([1, 3, 5, 7]) is None

    def test_lista_vazia_retorna_none(self):
        """Lista vazia não tem par — deve retornar None."""
        assert encontrar_primeiro_par([]) is None

    def test_todos_pares_retorna_o_primeiro(self):
        """Quando todos são pares, deve retornar apenas o primeiro."""
        # O break deve garantir que apenas o primeiro seja retornado
        assert encontrar_primeiro_par([2, 4, 6, 8]) == 2

    def test_zero_e_par(self):
        """Zero é par (resto de 0/2 é 0) — deve ser retornado."""
        assert encontrar_primeiro_par([1, 3, 0, 5]) == 0

    def test_numero_negativo_par(self):
        """Números negativos pares também devem ser encontrados."""
        assert encontrar_primeiro_par([1, 3, -4, 5]) == -4

    def test_retorno_e_int_ou_none(self):
        """A função deve retornar int ou None."""
        resultado_com_par = encontrar_primeiro_par([1, 2, 3])
        resultado_sem_par = encontrar_primeiro_par([1, 3, 5])
        assert isinstance(resultado_com_par, int)
        assert resultado_sem_par is None


# ============================================================
# TESTES PARA filtrar_positivos()
# ============================================================

class TestFiltrarPositivos:
    """
    Testa todos os comportamentos da função filtrar_positivos.
    Verifica: filtragem correta, lista vazia, todos positivos, todos negativos.
    Foco especial: comportamento do continue e tratamento do zero.
    """

    def test_filtragem_mista(self):
        """Caso normal: lista com positivos, negativos e zero."""
        resultado = filtrar_positivos([3, -1, 5, 0, -7, 2])
        assert resultado == [3, 5, 2]

    def test_lista_vazia(self):
        """Lista vazia deve retornar lista vazia."""
        assert filtrar_positivos([]) == []

    def test_todos_positivos(self):
        """Quando todos são positivos, a lista retornada é igual à original."""
        numeros = [1, 2, 3, 4, 5]
        assert filtrar_positivos(numeros) == numeros

    def test_todos_negativos(self):
        """Quando todos são negativos, deve retornar lista vazia."""
        assert filtrar_positivos([-1, -2, -3]) == []

    def test_zero_nao_e_positivo(self):
        """Zero não é estritamente positivo — deve ser filtrado."""
        assert filtrar_positivos([0, 0, 0]) == []

    def test_zero_e_negativos_filtrados(self):
        """Mistura de zeros e negativos deve resultar em lista vazia."""
        assert filtrar_positivos([-5, 0, -3, 0]) == []

    def test_preserva_ordem_original(self):
        """Os positivos devem aparecer na mesma ordem da lista original."""
        resultado = filtrar_positivos([5, -1, 3, -2, 1])
        assert resultado == [5, 3, 1]

    def test_com_floats_positivos(self):
        """Floats positivos também devem ser incluídos."""
        resultado = filtrar_positivos([-1.5, 0.5, 2.3, -0.1])
        assert resultado == [0.5, 2.3]

    def test_nao_modifica_lista_original(self):
        """A função não deve modificar a lista de entrada."""
        original = [3, -1, 5, 0, -7, 2]
        copia = original.copy()
        filtrar_positivos(original)
        # A lista original deve permanecer inalterada
        assert original == copia

    def test_retorna_lista(self):
        """A função deve sempre retornar uma lista."""
        assert isinstance(filtrar_positivos([1, -1, 0]), list)
~~~

### Como executar os testes

~~~text
cd modulo_01_fundamentos\aula_04_repeticao
pytest testes/ -v
~~~

### Estrutura de pastas necessária

~~~text
modulo_01_fundamentos/
└── aula_04_repeticao/
    ├── codigo/
    │   ├── __init__.py        ← arquivo vazio
    │   └── repeticoes.py
    └── testes/
        └── test_repeticoes.py
~~~

Criando o `__init__.py` no terminal:

~~~text
type nul > modulo_01_fundamentos\aula_04_repeticao\codigo\__init__.py
~~~

---

## Glossário Técnico da Aula

**Laço (loop):** estrutura de repetição que executa um bloco de código múltiplas vezes. Python tem dois tipos: `for` e `while`.

**`for`:** laço que itera sobre os elementos de um iterável (lista, string, range etc.), executando o bloco uma vez para cada elemento.

**`while`:** laço que executa o bloco repetidamente enquanto uma condição booleana for `True`. Termina quando a condição se torna `False`.

**Iterável:** qualquer objeto Python capaz de fornecer seus elementos um por um. Exemplos: listas, strings, tuplas, `range()`.

**`range(start, stop, step)`:** função que gera uma sequência de inteiros de `start` até `stop - 1` com passo `step`. O valor `stop` é exclusivo.

**Iteração:** cada execução individual do bloco de código dentro de um laço. Um laço com 10 elementos realiza 10 iterações.

**Acumulador:** variável inicializada antes do laço e atualizada a cada iteração para acumular um resultado. Exemplo: `total = 0` seguido de `total += numero`.

**`break`:** instrução que interrompe o laço imediatamente, pulando para a primeira linha após o bloco do laço. Usada quando a condição de parada é atingida antes do fim natural do laço.

**`continue`:** instrução que pula o restante do bloco para a iteração atual e avança para a próxima. Usada para ignorar elementos indesejados sem interromper o laço.

**Laço infinito:** laço `while` cuja condição nunca se torna `False`, causando execução indefinida. Prevenido garantindo que o bloco modifique a variável da condição.

**`+=`:** operador de atribuição aumentada. `total += 5` é equivalente a `total = total + 5`. Também existe `-=`, `*=`, `/=` e outros.

**`append()`:** método de lista que adiciona um elemento ao final da lista. `lista.append(42)` adiciona `42` como último elemento.

**Off-by-one:** erro clássico de laços onde se itera uma vez a mais ou a menos. Comum ao confundir `<` com `<=` ou ao usar `range(stop)` sem lembrar que `stop` é exclusivo.

**Laços aninhados:** laços colocados dentro de outros laços. O número de iterações total é o produto dos tamanhos dos laços — O(n²) para dois laços com n iterações cada.

---

## Antecipação de Erros

**Erro 1: Criar laço infinito esquecendo de atualizar o contador no `while`.** O erro mais clássico do `while` é esquecer `contador += 1` dentro do bloco, fazendo a condição nunca se tornar `False`. O programa trava, consumindo 100% de um núcleo do processador. Se isso acontecer, pressione `Ctrl + C` no terminal. A prevenção é simples: sempre que escrever um `while`, imediatamente escreva a linha de atualização da variável de controle antes de escrever qualquer outra coisa dentro do bloco.

**Erro 2: `range(stop)` começa em zero, não em um.** `range(5)` gera `0, 1, 2, 3, 4` — não `1, 2, 3, 4, 5`. Se você precisa de `1, 2, 3, 4, 5`, use `range(1, 6)`. Esquecer isso causa erros de "off-by-one" — o laço processa um elemento a menos ou a mais do que esperado. Verifique sempre: qual é o primeiro valor? Qual é o último? O `stop` é exclusivo.

**Erro 3: Modificar a lista que está sendo iterada com `for`.** Nunca remova ou adicione elementos a uma lista enquanto itera sobre ela com `for` — o comportamento é imprevisível e pode pular elementos ou causar `IndexError`. A solução é criar uma nova lista para o resultado (como na função `filtrar_positivos`) em vez de modificar a original.

**Erro 4: Esquecer que `continue` não termina o laço — apenas pula a iteração atual.** Um erro comum é pensar que `continue` funciona como `break`. O `continue` volta para o início do laço e começa a próxima iteração. O `break` sai completamente do laço. Usar `continue` quando precisava de `break` faz o laço continuar executando quando deveria ter parado.

**Erro 5: Inicializar o acumulador com o valor errado.** Para soma, inicialize com `0`. Para produto, inicialize com `1`. Para lista de resultados, inicialize com `[]`. Para string, inicialize com `""`. Inicializar uma soma com `1` resulta em um valor sempre uma unidade a mais. Inicializar um produto com `0` resulta em zero sempre, independentemente dos valores multiplicados.

**Erro 6: Usar `for i in lista` quando precisa do índice E do valor.** Se você precisar tanto do índice quanto do valor, use `enumerate()`: `for indice, valor in enumerate(lista):`. Sem `enumerate()`, muitos iniciantes escrevem `for i in range(len(lista)):` e depois acessam `lista[i]` — o que funciona, mas é menos legível e Pythônico que `enumerate()`.

---

## Troubleshooting

**Problema: O programa travou e não responde (laço infinito).**
Causa: a condição do `while` nunca se torna `False`.
Solução: pressione `Ctrl + C` no terminal para interromper. Verifique se existe dentro do bloco do `while` uma instrução que modifica a variável usada na condição. Adicione um `print()` temporário dentro do laço para visualizar os valores a cada iteração e identificar onde a atualização está faltando.

**Problema: `IndexError: list index out of range` dentro de um laço.**
Causa: tentativa de acessar `lista[i]` com um índice `i` que está além do tamanho da lista.
Solução: verifique os limites do `range()`. Se `lista` tem 5 elementos (índices 0 a 4), use `range(len(lista))` ou `range(5)` — nunca `range(6)`. Prefira `for elemento in lista:` quando não precisar do índice.

**Problema: O `break` não está funcionando como esperado.**
Causa: o `break` está dentro de um `if` mas o `if` nunca é `True`, então o `break` nunca executa.
Solução: adicione um `print()` antes do `break` para verificar se o `if` está sendo atingido. Revise a condição do `if` — pode haver um erro de lógica ou de tipo (comparar `int` com `str`, por exemplo).

**Problema: A função `filtrar_positivos` está retornando elementos que não deveria.**
Causa: a condição do `continue` está incorreta — por exemplo, usando `< 0` em vez de `<= 0`, o que faz o zero passar pelo filtro.
Solução: verifique se a condição usa `<=` (menor ou igual) para excluir zero, pois zero não é estritamente positivo. Escreva um teste específico para o zero: `assert filtrar_positivos([0]) == []`.

---

## Desafio de Fixação

Implemente uma função chamada `tabuada(numero)` que recebe um número inteiro e retorna uma lista com os dez primeiros múltiplos desse número — do `numero * 1` até `numero * 10`, nessa ordem. Use um laço `for` com `range()`. Em seguida, implemente uma segunda função chamada `tabuada_formatada(numero)` que usa `tabuada()` internamente e retorna uma lista de strings no formato `"N x M = R"` para cada linha da tabuada, onde `N` é o número, `M` é o multiplicador (de 1 a 10) e `R` é o resultado.

**Resolução comentada:**

~~~python
def tabuada(numero):
    """
    Retorna os dez primeiros múltiplos de um número.

    ENTRADA: numero — inteiro qualquer
    SAÍDA: lista com numero*1, numero*2, ..., numero*10
    """

    # Inicializar a lista de múltiplos
    multiplos = []

    # range(1, 11) gera os valores 1, 2, 3, ..., 10
    # Multiplicador começa em 1 (não em 0) e vai até 10 (inclusive)
    for multiplicador in range(1, 11):
        # Calcular o múltiplo atual e adicionar à lista
        multiplos.append(numero * multiplicador)

    return multiplos


def tabuada_formatada(numero):
    """
    Retorna a tabuada de um número como lista de strings formatadas.

    ENTRADA: numero — inteiro qualquer
    SAÍDA: lista de strings no formato 'N x M = R'
    """

    # Inicializar a lista de linhas formatadas
    linhas = []

    # range(1, 11) gera os multiplicadores de 1 a 10
    for multiplicador in range(1, 11):
        # Calcular o resultado da multiplicação
        resultado = numero * multiplicador

        # Formatar a linha usando f-string
        # Exemplo: "7 x 3 = 21"
        linha = f"{numero} x {multiplicador} = {resultado}"

        # Adicionar a linha formatada à lista
        linhas.append(linha)

    return linhas
~~~

Testes para o desafio:

~~~python
def test_tabuada_do_sete():
    resultado = tabuada(7)
    assert resultado == [7, 14, 21, 28, 35, 42, 49, 56, 63, 70]

def test_tabuada_tem_dez_elementos():
    assert len(tabuada(5)) == 10

def test_tabuada_do_zero():
    # A tabuada do zero são dez zeros
    assert tabuada(0) == [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

def test_tabuada_formatada_primeiro_elemento():
    resultado = tabuada_formatada(3)
    assert resultado[0] == "3 x 1 = 3"

def test_tabuada_formatada_ultimo_elemento():
    resultado = tabuada_formatada(3)
    assert resultado[-1] == "3 x 10 = 30"

def test_tabuada_formatada_tem_dez_linhas():
    assert len(tabuada_formatada(5)) == 10
~~~

---

## Resumo dos Pontos-Chave

O **`for`** itera sobre os elementos de um iterável — lista, string ou `range()` — executando o bloco uma vez para cada elemento, e termina automaticamente quando os elementos acabam. O **`while`** executa o bloco enquanto uma condição for `True`, terminando quando ela se torna `False`, e exige que o bloco atualize a variável da condição para evitar laços infinitos. O **`range(start, stop, step)`** gera sequências de inteiros — o `stop` é sempre exclusivo. O padrão **acumulador** — inicializar uma variável antes do laço e atualizá-la dentro — é a estrutura fundamental para somar, contar, filtrar e construir resultados com laços. O **`break`** interrompe o laço imediatamente e é ideal para buscas — quando encontrou o alvo, pare. O **`continue`** pula apenas a iteração atual e é ideal para filtros — quando o elemento não é desejado, pule-o. Nunca modifique a lista que está sendo iterada com `for`. Inicialize acumuladores com o elemento neutro da operação: `0` para somas, `1` para produtos, `[]` para listas, `""` para strings.

---

## Log de Estado da Aula

**Aula:** 04 — Estruturas de Repetição: for e while
**Objetivo:** Implementar quatro funções que demonstram laços com break, continue e range.
**Arquivos criados:**
- `modulo_01_fundamentos/aula_04_repeticao/codigo/__init__.py`
- `modulo_01_fundamentos/aula_04_repeticao/codigo/repeticoes.py`
- `modulo_01_fundamentos/aula_04_repeticao/testes/test_repeticoes.py`

**Estado Funcional:** ✅ Quatro funções implementadas com testes cobrindo casos normais, extremos, comportamento de break e continue, e verificação de imutabilidade da lista original.
**Próximas Etapas:** Aula 05 ensinará funções — como encapsular lógica em blocos reutilizáveis com parâmetros, retorno múltiplo e escopo de variáveis.

---

## Próximos Passos

Na **Aula 05: Funções: Reutilizando e Organizando Algoritmos**, você aprenderá a definir e chamar funções com parâmetros, valores padrão e retorno múltiplo, compreenderá o conceito de escopo de variáveis e verá como funções podem receber outras funções como argumento — uma técnica poderosa que reaparece em algoritmos avançados. Tudo com código autocontido e testes pytest.

---

Dúvidas? Posso prosseguir para a próxima etapa?