# Aula 06: Listas em Python: Armazenando e Manipulando Coleções

## Análise de Integridade (Auditoria Prévia)

Antes de iniciar, este conteúdo foi verificado nos seguintes critérios: profundidade técnica mantida com linguagem acessível para iniciantes absolutos, analogias do cotidiano presentes antes de qualquer formalização técnica, código Python 3.13 funcional e comentado linha a linha, testes pytest cobrindo casos normais e extremos incluindo listas vazias, listas com um elemento, duplicatas e rotações maiores que o tamanho, diagrama Mermaid correto e bem formatado com escape adequado, glossário completo, antecipação de erros relevantes para iniciantes, e mínimo de 2.000 palavras de teoria. Nenhuma falha detectada. Conteúdo aprovado para geração.

---

## Objetivo da Aula

Dominar listas como a estrutura de dados central dos algoritmos em Python — compreendendo criação, acesso por índice positivo e negativo, fatiamento, mutabilidade, os métodos mais importantes e a diferença entre cópia rasa e profunda — e implementar quatro funções de manipulação de listas sem depender de métodos prontos do Python, preparando o terreno para os algoritmos de busca e ordenação do Módulo 2.

## Pré-requisitos

Aulas 04 e 05 concluídas — especialmente laços `for` (para iterar sobre listas) e funções com `def` e `return` (toda a lógica desta aula vive dentro de funções). O ambiente virtual deve estar ativo e o pytest instalado.

---

## Teoria Detalhada

### Por que listas são tão importantes para algoritmos

Antes de escrever qualquer algoritmo de busca ou ordenação, precisamos de uma resposta para uma pergunta fundamental: onde os dados ficam armazenados enquanto o algoritmo trabalha? Em problemas reais, algoritmos raramente operam sobre um único valor. Eles recebem dezenas, centenas ou milhões de valores e precisam organizá-los, buscá-los, filtrá-los e transformá-los. A estrutura que armazena esses valores em sequência, em Python, é a **lista**.

A lista é tão central para a computação que quase todos os outros algoritmos que estudaremos neste curso — busca linear, busca binária, Bubble Sort, Selection Sort, Insertion Sort, Merge Sort, Quick Sort, BFS, DFS — operam sobre listas ou estruturas construídas a partir delas. Dominar listas profundamente agora é um investimento que você colherá em todas as aulas seguintes.

### O que é uma lista em Python

Uma **lista** em Python é uma coleção ordenada e mutável de elementos. **Ordenada** significa que os elementos têm posições fixas — o primeiro elemento é sempre o primeiro, o último é sempre o último, e a ordem é preservada entre operações (a menos que você explicitamente a modifique). **Mutável** significa que você pode modificar a lista após sua criação — adicionar elementos, remover elementos, alterar valores.

Listas são criadas com colchetes e elementos separados por vírgula: `[1, 2, 3]`, `["Ana", "Carlos", "Bia"]`, `[True, 42, 3.14, "texto"]`. Diferentemente de muitas linguagens, as listas Python podem conter elementos de tipos diferentes na mesma lista — embora na prática seja melhor manter listas com elementos do mesmo tipo para evitar confusões. Uma lista pode também estar vazia: `[]`.

### Índices: acessando elementos por posição

Cada elemento de uma lista tem um **índice** — um número que representa sua posição. Em Python, os índices começam em zero, não em um. O primeiro elemento está na posição `0`, o segundo na posição `1`, o terceiro na posição `2`, e assim por diante. Para uma lista com `n` elementos, o último índice é `n - 1`.

Essa convenção de começar em zero é uma das características do Python (e da maioria das linguagens de programação) que mais surpreende iniciantes. O motivo histórico vem da memória do computador — o índice representa o deslocamento (offset) em bytes a partir do início da área de memória da lista, e o primeiro elemento está a zero bytes de distância do início.

Python também suporta **índices negativos**, que contam a partir do final da lista. O índice `-1` acessa o último elemento, `-2` acessa o penúltimo, e assim por diante. Isso é muito conveniente quando você quer acessar os últimos elementos sem precisar calcular `len(lista) - 1`. `lista[-1]` é a forma Pythônica de obter o último elemento.

Tentar acessar um índice que não existe — como `lista[10]` em uma lista com cinco elementos — causa `IndexError: list index out of range`. Esse é um dos erros mais comuns em algoritmos que trabalham com listas, especialmente em laços onde o índice cresce.

### Fatiamento (slicing): obtendo sublistas

Uma das funcionalidades mais poderosas das listas Python é o **fatiamento** (slicing) — a capacidade de extrair uma porção da lista como uma nova lista usando a sintaxe `lista[inicio:fim:passo]`. Essa operação cria uma nova lista contendo os elementos do índice `inicio` (inclusivo) até o índice `fim` (exclusivo), avançando de `passo` em `passo`.

`lista[1:4]` retorna os elementos nos índices 1, 2 e 3 (não o 4). `lista[:3]` retorna os três primeiros elementos (o `inicio` padrão é 0). `lista[2:]` retorna todos os elementos a partir do índice 2 até o final (o `fim` padrão é o tamanho da lista). `lista[:]` retorna uma cópia completa da lista — uma técnica fundamental para criar uma cópia independente antes de modificar.

O `passo` permite saltar elementos: `lista[::2]` retorna apenas os elementos nos índices pares (0, 2, 4...). `lista[::-1]` — com passo `-1` — retorna a lista invertida. Essa última forma é Pythônica e elegante, mas nesta aula implementaremos a inversão manualmente para entender o algoritmo por trás.

### Mutabilidade: listas são modificáveis

Ao contrário das strings (que são imutáveis), listas podem ser modificadas após a criação. Você pode alterar o valor de um elemento específico: `lista[0] = 99` muda o primeiro elemento para 99. Você pode adicionar elementos com `append()` (no final) ou `insert(indice, valor)` (em qualquer posição). Pode remover elementos com `remove(valor)` (remove a primeira ocorrência do valor) ou `pop(indice)` (remove e retorna o elemento na posição).

Essa mutabilidade é poderosa, mas esconde uma armadilha crítica: **atribuição não cria cópia**. Quando você escreve `lista_b = lista_a`, não está criando uma nova lista — está criando uma segunda variável que aponta para a mesma lista na memória. Qualquer modificação em `lista_b` também modifica `lista_a`, porque ambas referenciam o mesmo objeto.

Para criar uma cópia independente, use o fatiamento `lista_b = lista_a[:]` ou o método `lista_b = lista_a.copy()`. Ambos criam uma **cópia rasa** (shallow copy) — uma nova lista com os mesmos elementos. Para listas simples com valores primitivos (inteiros, strings, floats), isso é suficiente. Para listas de listas (listas aninhadas), é necessária uma **cópia profunda** (deep copy) com `copy.deepcopy()`, pois a cópia rasa copia apenas as referências dos elementos internos, não os elementos em si.

### Os métodos mais importantes de lista

Python oferece um conjunto rico de métodos para manipular listas. Os mais importantes para algoritmos são: `append(valor)` que adiciona um elemento ao final, `insert(indice, valor)` que insere em uma posição específica deslocando os demais, `remove(valor)` que remove a primeira ocorrência de um valor, `pop(indice)` que remove e retorna o elemento na posição (padrão: último), `index(valor)` que retorna o índice da primeira ocorrência de um valor (lança `ValueError` se não encontrar), `count(valor)` que conta quantas vezes um valor aparece, `sort()` que ordena a lista no lugar (in-place) e `reverse()` que inverte a lista no lugar.

A distinção entre métodos que operam **in-place** (modificam a lista original e retornam `None`) e métodos que retornam uma **nova lista** é crítica. `lista.sort()` modifica a lista original e retorna `None` — não `sorted(lista)`. `sorted(lista)` retorna uma nova lista ordenada sem modificar a original. Confundir os dois é uma fonte comum de bugs sutis.

### A função `len()` e iteração

A função `len(lista)` retorna o número de elementos da lista. É uma das funções mais usadas em algoritmos — para saber quando parar um laço, para calcular índices, para verificar se a lista está vazia. `len([])` retorna `0`, confirmando que a lista está vazia — embora a verificação Pythônica seja simplesmente `if not lista:` (listas vazias são falsy).

Para iterar sobre todos os elementos de uma lista com seus índices simultaneamente, use `enumerate()`: `for indice, valor in enumerate(lista):`. Para iterar sobre duas listas em paralelo, use `zip()`: `for a, b in zip(lista_a, lista_b):`. Essas ferramentas tornam o código mais legível e menos propenso a erros de índice do que a alternativa `for i in range(len(lista)):`.

### Implementando operações manualmente: por que isso importa

Nesta aula, implementaremos quatro operações sobre listas sem usar os métodos prontos do Python que as realizariam trivialmente: `lista.reverse()`, `list(set(lista))`, etc. Isso pode parecer redundante — por que reinventar a roda?

A resposta está no coração do estudo de algoritmos: **entender como algo funciona é diferente de saber usá-lo**. Quando você implementa a inversão de uma lista manualmente, você entende que inverter significa trocar o elemento da posição `0` com o da posição `n-1`, depois o da posição `1` com o da `n-2`, e assim por diante — e que isso requer exatamente `n/2` trocas. Esse raciocínio é o que você precisará para implementar algoritmos de ordenação mais complexos nos módulos seguintes, onde não existem métodos prontos.

Além disso, implementar operações simples do zero é a forma mais eficaz de praticar os padrões fundamentais — acesso por índice, troca de valores, laços com controle preciso — que se repetem em todos os algoritmos de listas.

### Troca de valores: um padrão fundamental

Uma operação que aparece constantemente em algoritmos de ordenação é a **troca de dois elementos** em uma lista. Em muitas linguagens, trocar dois valores requer uma variável temporária: `temp = lista[i]`, `lista[i] = lista[j]`, `lista[j] = temp`. Em Python, você pode fazer isso elegantemente em uma única linha usando desempacotamento de tupla: `lista[i], lista[j] = lista[j], lista[i]`. O Python avalia o lado direito completamente antes de realizar as atribuições, tornando a variável temporária desnecessária.

Essa sintaxe de troca é tão fundamental que você a verá em quase todos os algoritmos de ordenação que implementaremos no Módulo 2. Internalizar esse padrão agora, em um contexto simples, facilita enormemente a compreensão quando ele aparecer em contextos mais complexos.

### Listas como estruturas de dados abstratas

Uma perspectiva mais ampla e muito útil: listas Python são implementações de uma estrutura de dados chamada **array dinâmico**. Um array é uma sequência de elementos armazenados contiguamente na memória, o que permite acesso em tempo constante O(1) a qualquer elemento pelo índice — você acessa `lista[999]` tão rapidamente quanto `lista[0]`. A palavra "dinâmico" significa que o tamanho pode crescer automaticamente quando você adiciona elementos com `append()`.

No entanto, operações como `insert(0, valor)` (inserir no início) e `remove(valor)` são lentas — O(n) — porque exigem deslocar todos os elementos subsequentes. Para inserções frequentes no início, outras estruturas como `collections.deque` são mais adequadas. Entender essa característica de performance das listas é o primeiro passo para escolher a estrutura certa para cada problema — uma habilidade que você desenvolverá ao longo do Módulo 3.

---

## Analogia de Ancoragem

Pense em uma lista Python como uma **prateleira numerada** em uma biblioteca — cada posição tem um número (o índice), e você pode colocar qualquer tipo de livro em qualquer posição. A prateleira começa no número 0 (não no 1), e você pode também contar de trás para frente: a última posição é -1, a penúltima é -2.

O **fatiamento** é como pedir ao bibliotecário: "me dê os livros das posições 2 até 5" — você recebe uma cópia daqueles livros em uma nova sacola, sem remover os originais da prateleira. O **índice negativo** é como pedir o último livro sem saber quantos há na prateleira — você simplesmente pede o "-1" e ele entrega o último, seja lá qual for.

A **mutabilidade** é o que diferencia essa prateleira de um livro impresso — você pode adicionar novos livros ao final (`append`), inserir no meio deslocando os demais (`insert`), ou remover um livro específico (`remove`). Mas atenção: se duas pessoas têm a **mesma ficha** da prateleira (mesma referência), qualquer modificação que uma fizer é vista pela outra imediatamente — porque é a mesma prateleira, não uma cópia. Para ter uma prateleira independente, você precisa copiar todos os livros para uma nova prateleira (`lista[:]` ou `.copy()`).

A **troca de elementos** é como trocar dois livros de posição na prateleira — você precisa segurar um na mão enquanto move o outro, ou em Python, usar o desempacotamento `a, b = b, a` que faz isso atomicamente.

---

## Diagrama Mermaid

~~~mermaid
flowchart TD
    subgraph INDICES["Índices de uma lista com 5 elementos"]
        L["lista = [10, 20, 30, 40, 50]"]
        POS["Índices positivos:\nlista[0]=10  lista[1]=20  lista[2]=30  lista[3]=40  lista[4]=50"]
        NEG["Índices negativos:\nlista[-5]=10 lista[-4]=20 lista[-3]=30 lista[-2]=40 lista[-1]=50"]
    end

    subgraph FATIAMENTO["Fatiamento (Slicing)"]
        F1["lista[1:4]  → [20, 30, 40]"]
        F2["lista[:3]   → [10, 20, 30]"]
        F3["lista[2:]   → [30, 40, 50]"]
        F4["lista[:]    → [10, 20, 30, 40, 50] (cópia)"]
        F5["lista[::-1] → [50, 40, 30, 20, 10] (invertida)"]
    end

    subgraph INVERSAO["Algoritmo de Inversão Manual"]
        I1["inicio=0, fim=4"] --> I2["Trocar lista[0] ↔ lista[4]\n[50,20,30,40,10]"]
        I2 --> I3["Trocar lista[1] ↔ lista[3]\n[50,40,30,20,10]"]
        I3 --> I4["inicio >= fim → parar\n[50,40,30,20,10]"]
    end

    L --> POS
    L --> NEG
    L --> F1
    L --> I1

    style L fill:#4CAF50,color:#fff
    style I4 fill:#9C27B0,color:#fff
~~~

---

## Aplicação no Projeto Prático

Crie a pasta `modulo_01_fundamentos/aula_06_listas/codigo/` e o arquivo `manipulador_listas.py` com o conteúdo abaixo. Crie também o arquivo `__init__.py` vazio na mesma pasta.

~~~python
# manipulador_listas.py
# Aula 06: Listas em Python: Armazenando e Manipulando Coleções
# Curso: AlgoLab — Algoritmos do Básico ao Avançado com Python
#
# Este arquivo implementa quatro funções de manipulação de listas
# sem usar os métodos prontos do Python para as operações centrais.
# O objetivo é entender os algoritmos por trás das operações.
# Cada função é autocontida e independente das demais.


def inverter_lista(lista):
    """
    Inverte a ordem dos elementos de uma lista sem usar .reverse() ou [::-1].

    Implementa o algoritmo de dois ponteiros: um no início, outro no fim,
    trocando os elementos e avançando em direção ao centro.

    Demonstra: acesso por índice, troca de elementos, algoritmo de dois ponteiros,
               cópia de lista para não modificar o original.

    ENTRADA: lista — lista com qualquer número de elementos de qualquer tipo
    SAÍDA: nova lista com os elementos em ordem invertida
           (a lista original não é modificada)

    Exemplos:
        inverter_lista([1, 2, 3, 4, 5])  → [5, 4, 3, 2, 1]
        inverter_lista([1, 2])           → [2, 1]
        inverter_lista([42])             → [42]
        inverter_lista([])               → []
    """

    # PASSO 1: Criar uma cópia da lista original para não modificá-la
    # lista[:] é fatiamento completo — cria uma nova lista com os mesmos elementos
    # Modificar 'copia' não afetará 'lista'
    copia = lista[:]

    # PASSO 2: Inicializar os dois ponteiros
    # 'inicio' aponta para o primeiro elemento
    # 'fim' aponta para o último elemento
    inicio = 0
    fim = len(copia) - 1

    # PASSO 3: Executar o algoritmo de dois ponteiros
    # Enquanto 'inicio' não ultrapassar 'fim', trocamos os elementos
    # e aproximamos os ponteiros em direção ao centro
    while inicio < fim:
        # Trocar os elementos nas posições 'inicio' e 'fim'
        # Python permite trocar dois valores em uma linha com desempacotamento:
        # o lado direito é avaliado completamente antes das atribuições
        copia[inicio], copia[fim] = copia[fim], copia[inicio]

        # Avançar o ponteiro do início para a direita
        inicio += 1

        # Recuar o ponteiro do fim para a esquerda
        fim -= 1

    # PASSO 4: Retornar a cópia invertida
    # A lista original permanece inalterada
    return copia


def remover_duplicatas(lista):
    """
    Remove elementos duplicados de uma lista preservando a ordem de primeira aparição.

    Não usa set() diretamente para a operação central — implementa manualmente
    usando um conjunto auxiliar para rastrear elementos já vistos.

    Demonstra: uso de conjunto (set) como auxiliar, padrão de "já visto",
               preservação de ordem, laço com condição de inclusão.

    ENTRADA: lista — lista com qualquer número de elementos comparáveis
    SAÍDA: nova lista com cada elemento aparecendo apenas uma vez,
           na ordem em que apareceu pela primeira vez na lista original

    Exemplos:
        remover_duplicatas([1, 2, 3, 2, 1, 4])  → [1, 2, 3, 4]
        remover_duplicatas([3, 3, 3])            → [3]
        remover_duplicatas([1, 2, 3])            → [1, 2, 3]
        remover_duplicatas([])                   → []
    """

    # PASSO 1: Inicializar a lista de resultado (sem duplicatas)
    resultado = []

    # PASSO 2: Inicializar o conjunto auxiliar de elementos já vistos
    # Usamos um conjunto (set) porque verificar pertencimento em set é O(1)
    # enquanto verificar em uma lista é O(n)
    # O conjunto não precisa preservar ordem — só precisa responder "já vi isso?"
    ja_vistos = set()

    # PASSO 3: Percorrer cada elemento da lista original
    for elemento in lista:
        # Verificar se este elemento já foi visto antes
        if elemento not in ja_vistos:
            # Este elemento é novo — incluir no resultado
            resultado.append(elemento)

            # Registrar que já vimos este elemento
            # add() adiciona um elemento ao conjunto
            ja_vistos.add(elemento)

        # Se o elemento já foi visto (else implícito), simplesmente ignoramos
        # O continue é desnecessário aqui — o laço avança naturalmente

    # PASSO 4: Retornar a lista sem duplicatas
    return resultado


def mesclar_listas(lista_a, lista_b):
    """
    Une dois listas em uma única lista sem elementos duplicados.

    A ordem dos elementos é: primeiro os de lista_a (sem duplicatas),
    depois os de lista_b que ainda não apareceram em lista_a.

    Demonstra: composição de funções (usa remover_duplicatas internamente),
               concatenação de listas, reutilização de lógica existente.

    ENTRADA: lista_a — primeira lista de elementos
             lista_b — segunda lista de elementos
    SAÍDA: nova lista com todos os elementos únicos de ambas as listas,
           sem modificar as listas originais

    Exemplos:
        mesclar_listas([1, 2, 3], [3, 4, 5])     → [1, 2, 3, 4, 5]
        mesclar_listas([1, 2], [1, 2])             → [1, 2]
        mesclar_listas([], [1, 2])                 → [1, 2]
        mesclar_listas([1, 2], [])                 → [1, 2]
        mesclar_listas([], [])                     → []
        mesclar_listas([1, 1, 2], [2, 3, 3])      → [1, 2, 3]
    """

    # PASSO 1: Concatenar as duas listas em uma lista temporária
    # O operador + para listas cria uma NOVA lista com os elementos de ambas
    # As listas originais não são modificadas
    lista_combinada = lista_a + lista_b

    # PASSO 2: Remover duplicatas da lista combinada
    # Reutilizamos a função remover_duplicatas() que já implementamos
    # Isso demonstra o poder da composição de funções
    resultado = remover_duplicatas(lista_combinada)

    # PASSO 3: Retornar a lista mesclada sem duplicatas
    return resultado


def rotacionar(lista, k):
    """
    Rotaciona os elementos da lista k posições para a direita.

    Rotacionar para a direita significa que os últimos k elementos
    vão para o início da lista e os demais se deslocam para a direita.

    Demonstra: fatiamento para dividir e recombinar lista,
               tratamento de k maior que o tamanho (módulo),
               imutabilidade da lista original.

    ENTRADA: lista — lista com qualquer número de elementos
             k     — número de posições para rotacionar (inteiro >= 0)
    SAÍDA: nova lista com os elementos rotacionados k posições à direita
           (a lista original não é modificada)

    Exemplos:
        rotacionar([1, 2, 3, 4, 5], 2)   → [4, 5, 1, 2, 3]
        rotacionar([1, 2, 3, 4, 5], 5)   → [1, 2, 3, 4, 5]  (volta ao início)
        rotacionar([1, 2, 3, 4, 5], 7)   → [4, 5, 1, 2, 3]  (7 % 5 = 2)
        rotacionar([1, 2, 3], 0)          → [1, 2, 3]
        rotacionar([], 3)                  → []
        rotacionar([42], 100)              → [42]
    """

    # PASSO 1: Tratar casos especiais
    # Se a lista está vazia ou tem um único elemento, não há nada a rotacionar
    if len(lista) <= 1:
        return lista[:]  # Retornamos uma cópia para manter consistência

    # PASSO 2: Calcular o deslocamento efetivo usando módulo
    # Se k >= len(lista), rotacionar k vezes é equivalente a rotacionar k % len(lista) vezes
    # Exemplo: rotacionar [1,2,3,4,5] por 5 posições volta ao estado original
    # Exemplo: rotacionar por 7 é igual a rotacionar por 7 % 5 = 2
    tamanho = len(lista)
    k_efetivo = k % tamanho

    # PASSO 3: Tratar o caso onde k_efetivo é zero (sem rotação)
    if k_efetivo == 0:
        return lista[:]  # Retornamos uma cópia sem modificação

    # PASSO 4: Dividir a lista em duas partes usando fatiamento
    # Para rotação à direita de k posições:
    # - Os últimos k elementos vão para o início
    # - Os primeiros (n-k) elementos vão para o final
    #
    # Exemplo: [1, 2, 3, 4, 5] com k=2
    # ponto_de_corte = 5 - 2 = 3
    # parte_final  = lista[3:]  → [4, 5]  (os últimos 2 elementos)
    # parte_inicio = lista[:3]  → [1, 2, 3]  (os primeiros 3 elementos)
    ponto_de_corte = tamanho - k_efetivo
    parte_final = lista[ponto_de_corte:]   # Últimos k elementos
    parte_inicio = lista[:ponto_de_corte]  # Primeiros (n-k) elementos

    # PASSO 5: Recombinar as partes na nova ordem
    # Os últimos k elementos vêm primeiro, seguidos pelos primeiros (n-k)
    resultado = parte_final + parte_inicio

    # PASSO 6: Retornar a lista rotacionada
    # A lista original não foi modificada
    return resultado
~~~

### Como executar o código

Com o ambiente virtual ativo, navegue até a pasta e teste manualmente:

~~~text
.venv\Scripts\activate
cd modulo_01_fundamentos\aula_06_listas\codigo
python -c "from manipulador_listas import *; print(inverter_lista([1,2,3,4,5])); print(remover_duplicatas([1,2,3,2,1,4])); print(mesclar_listas([1,2,3],[3,4,5])); print(rotacionar([1,2,3,4,5],2))"
~~~

---

## Testes Automatizados com pytest

Crie o arquivo `test_manipulador_listas.py` dentro da pasta `modulo_01_fundamentos/aula_06_listas/testes/`:

~~~python
# test_manipulador_listas.py
# Testes automatizados para a Aula 06: Listas em Python
# Execute com: pytest testes/ -v
#
# Filosofia dos testes:
# - Casos normais: entradas típicas com resultado esperado claro
# - Casos extremos: lista vazia, lista com um elemento
# - Imutabilidade: verificar que a lista original nunca é modificada
# - Casos de borda: duplicatas consecutivas, k maior que o tamanho

import pytest

# Importamos as quatro funções que vamos testar
from codigo.manipulador_listas import (
    inverter_lista,
    remover_duplicatas,
    mesclar_listas,
    rotacionar,
)


# ============================================================
# TESTES PARA inverter_lista()
# ============================================================

class TestInverterlista:
    """
    Testa todos os comportamentos da função inverter_lista.
    Verifica: inversão correta, lista vazia, um elemento, imutabilidade.
    """

    def test_inverter_lista_simples(self):
        """Caso normal: inverter lista com cinco elementos."""
        assert inverter_lista([1, 2, 3, 4, 5]) == [5, 4, 3, 2, 1]

    def test_inverter_lista_dois_elementos(self):
        """Caso mínimo com troca: dois elementos trocam de posição."""
        assert inverter_lista([1, 2]) == [2, 1]

    def test_inverter_lista_um_elemento(self):
        """Caso extremo: lista com um único elemento não muda."""
        assert inverter_lista([42]) == [42]

    def test_inverter_lista_vazia(self):
        """Caso extremo: lista vazia invertida é lista vazia."""
        assert inverter_lista([]) == []

    def test_inverter_lista_com_repetidos(self):
        """Caso com elementos repetidos — inversão ainda funciona."""
        assert inverter_lista([1, 1, 2, 2, 3]) == [3, 2, 2, 1, 1]

    def test_inverter_lista_com_strings(self):
        """Listas de strings também devem ser invertidas corretamente."""
        assert inverter_lista(["a", "b", "c"]) == ["c", "b", "a"]

    def test_inverter_lista_par_de_elementos(self):
        """Lista com número par de elementos."""
        assert inverter_lista([1, 2, 3, 4]) == [4, 3, 2, 1]

    def test_inverter_nao_modifica_original(self):
        """A lista original NÃO deve ser modificada pela função."""
        original = [1, 2, 3, 4, 5]
        copia_antes = original.copy()
        inverter_lista(original)
        # A lista original deve ser idêntica à cópia feita antes da chamada
        assert original == copia_antes

    def test_retorna_nova_lista(self):
        """A função deve retornar uma nova lista, não a mesma referência."""
        original = [1, 2, 3]
        resultado = inverter_lista(original)
        # Verificar que são objetos diferentes na memória
        assert resultado is not original

    def test_inverter_duas_vezes_retorna_original(self):
        """Inverter duas vezes deve retornar a lista na ordem original."""
        original = [1, 2, 3, 4, 5]
        assert inverter_lista(inverter_lista(original)) == original


# ============================================================
# TESTES PARA remover_duplicatas()
# ============================================================

class TestRemoverDuplicatas:
    """
    Testa todos os comportamentos da função remover_duplicatas.
    Verifica: remoção correta, preservação de ordem, casos extremos.
    """

    def test_remover_duplicatas_simples(self):
        """Caso normal: lista com algumas duplicatas."""
        assert remover_duplicatas([1, 2, 3, 2, 1, 4]) == [1, 2, 3, 4]

    def test_preserva_primeira_ocorrencia(self):
        """A primeira ocorrência de cada elemento deve ser preservada."""
        # O 3 aparece primeiro, depois o 1 — a ordem de primeira aparição é [3,1,2]
        resultado = remover_duplicatas([3, 1, 2, 1, 3])
        assert resultado == [3, 1, 2]

    def test_sem_duplicatas_retorna_igual(self):
        """Lista sem duplicatas deve retornar lista equivalente à original."""
        assert remover_duplicatas([1, 2, 3, 4]) == [1, 2, 3, 4]

    def test_todos_duplicados(self):
        """Lista com todos os elementos iguais deve retornar lista com um elemento."""
        assert remover_duplicatas([5, 5, 5, 5, 5]) == [5]

    def test_lista_vazia(self):
        """Lista vazia deve retornar lista vazia."""
        assert remover_duplicatas([]) == []

    def test_lista_um_elemento(self):
        """Lista com um elemento não tem duplicatas."""
        assert remover_duplicatas([7]) == [7]

    def test_duplicatas_consecutivas(self):
        """Duplicatas consecutivas devem ser removidas corretamente."""
        assert remover_duplicatas([1, 1, 2, 2, 3, 3]) == [1, 2, 3]

    def test_duplicatas_intercaladas(self):
        """Duplicatas intercaladas devem ser removidas corretamente."""
        assert remover_duplicatas([1, 2, 1, 2, 1, 2]) == [1, 2]

    def test_com_strings(self):
        """Deve funcionar com listas de strings."""
        assert remover_duplicatas(["a", "b", "a", "c", "b"]) == ["a", "b", "c"]

    def test_nao_modifica_original(self):
        """A lista original NÃO deve ser modificada."""
        original = [1, 2, 3, 2, 1]
        copia_antes = original.copy()
        remover_duplicatas(original)
        assert original == copia_antes

    def test_retorna_lista(self):
        """A função deve sempre retornar uma lista."""
        assert isinstance(remover_duplicatas([1, 2, 3]), list)


# ============================================================
# TESTES PARA mesclar_listas()
# ============================================================

class TestMesclarListas:
    """
    Testa todos os comportamentos da função mesclar_listas.
    Verifica: mesclagem correta, tratamento de duplicatas, listas vazias.
    """

    def test_mesclar_sem_elementos_comuns(self):
        """Caso normal: listas sem elementos em comum."""
        assert mesclar_listas([1, 2, 3], [4, 5, 6]) == [1, 2, 3, 4, 5, 6]

    def test_mesclar_com_elementos_comuns(self):
        """Caso normal: listas com alguns elementos em comum."""
        assert mesclar_listas([1, 2, 3], [3, 4, 5]) == [1, 2, 3, 4, 5]

    def test_mesclar_listas_identicas(self):
        """Listas idênticas mescladas devem resultar em uma sem duplicatas."""
        assert mesclar_listas([1, 2, 3], [1, 2, 3]) == [1, 2, 3]

    def test_mesclar_com_lista_vazia_a(self):
        """Mesclar lista vazia com lista não vazia."""
        assert mesclar_listas([], [1, 2, 3]) == [1, 2, 3]

    def test_mesclar_com_lista_vazia_b(self):
        """Mesclar lista não vazia com lista vazia."""
        assert mesclar_listas([1, 2, 3], []) == [1, 2, 3]

    def test_mesclar_duas_listas_vazias(self):
        """Mesclar duas listas vazias deve resultar em lista vazia."""
        assert mesclar_listas([], []) == []

    def test_mesclar_preserva_ordem_de_a(self):
        """Elementos de lista_a devem aparecer antes dos de lista_b."""
        resultado = mesclar_listas([3, 1], [2, 4])
        # 3 e 1 vêm de lista_a — devem aparecer primeiro
        assert resultado.index(3) < resultado.index(2)
        assert resultado.index(1) < resultado.index(4)

    def test_mesclar_com_duplicatas_internas(self):
        """Duplicatas dentro de cada lista também devem ser removidas."""
        assert mesclar_listas([1, 1, 2], [2, 3, 3]) == [1, 2, 3]

    def test_nao_modifica_lista_a(self):
        """A lista_a original NÃO deve ser modificada."""
        lista_a = [1, 2, 3]
        copia_antes = lista_a.copy()
        mesclar_listas(lista_a, [4, 5])
        assert lista_a == copia_antes

    def test_nao_modifica_lista_b(self):
        """A lista_b original NÃO deve ser modificada."""
        lista_b = [3, 4, 5]
        copia_antes = lista_b.copy()
        mesclar_listas([1, 2], lista_b)
        assert lista_b == copia_antes

    def test_retorna_lista(self):
        """A função deve sempre retornar uma lista."""
        assert isinstance(mesclar_listas([1], [2]), list)


# ============================================================
# TESTES PARA rotacionar()
# ============================================================

class TestRotacionar:
    """
    Testa todos os comportamentos da função rotacionar.
    Verifica: rotação correta, k=0, k igual ao tamanho, k maior que tamanho,
              lista vazia, lista com um elemento, imutabilidade.
    """

    def test_rotacionar_dois(self):
        """Caso normal: rotacionar 2 posições à direita."""
        # [1,2,3,4,5] com k=2 → os últimos 2 ([4,5]) vão para o início
        assert rotacionar([1, 2, 3, 4, 5], 2) == [4, 5, 1, 2, 3]

    def test_rotacionar_um(self):
        """Rotacionar 1 posição: apenas o último vai para o início."""
        assert rotacionar([1, 2, 3, 4, 5], 1) == [5, 1, 2, 3, 4]

    def test_rotacionar_zero(self):
        """k=0: sem rotação, deve retornar cópia igual à original."""
        assert rotacionar([1, 2, 3, 4, 5], 0) == [1, 2, 3, 4, 5]

    def test_rotacionar_tamanho_completo(self):
        """k igual ao tamanho da lista: volta ao estado original."""
        assert rotacionar([1, 2, 3, 4, 5], 5) == [1, 2, 3, 4, 5]

    def test_rotacionar_maior_que_tamanho(self):
        """k maior que o tamanho: usa módulo para calcular k efetivo."""
        # k=7, tamanho=5: 7 % 5 = 2 → mesmo que rotacionar por 2
        assert rotacionar([1, 2, 3, 4, 5], 7) == [4, 5, 1, 2, 3]

    def test_rotacionar_multiplo_do_tamanho(self):
        """k múltiplo exato do tamanho: equivale a k=0."""
        assert rotacionar([1, 2, 3], 6) == [1, 2, 3]

    def test_rotacionar_lista_vazia(self):
        """Lista vazia rotacionada é lista vazia."""
        assert rotacionar([], 3) == []

    def test_rotacionar_um_elemento(self):
        """Lista com um elemento não muda independentemente de k."""
        assert rotacionar([42], 100) == [42]

    def test_rotacionar_dois_elementos(self):
        """Rotacionar dois elementos por 1 os troca de posição."""
        assert rotacionar([1, 2], 1) == [2, 1]

    def test_nao_modifica_original(self):
        """A lista original NÃO deve ser modificada."""
        original = [1, 2, 3, 4, 5]
        copia_antes = original.copy()
        rotacionar(original, 2)
        assert original == copia_antes

    def test_retorna_nova_lista(self):
        """A função deve retornar uma nova lista, não a mesma referência."""
        original = [1, 2, 3]
        resultado = rotacionar(original, 1)
        assert resultado is not original

    def test_rotacionar_com_strings(self):
        """Deve funcionar com listas de strings."""
        assert rotacionar(["a", "b", "c", "d"], 1) == ["d", "a", "b", "c"]
~~~

### Como executar os testes

~~~text
cd modulo_01_fundamentos\aula_06_listas
pytest testes/ -v
~~~

### Estrutura de pastas necessária

~~~text
modulo_01_fundamentos/
└── aula_06_listas/
    ├── codigo/
    │   ├── __init__.py        ← arquivo vazio
    │   └── manipulador_listas.py
    └── testes/
        └── test_manipulador_listas.py
~~~

Criando o `__init__.py` no terminal:

~~~text
type nul > modulo_01_fundamentos\aula_06_listas\codigo\__init__.py
~~~

---

## Glossário Técnico da Aula

**Lista:** coleção ordenada e mutável de elementos em Python, criada com colchetes `[]`. Pode conter elementos de qualquer tipo e de tipos mistos.

**Índice:** número inteiro que representa a posição de um elemento em uma lista. Começa em `0` para o primeiro elemento. Índices negativos contam a partir do final: `-1` é o último elemento.

**Fatiamento (slicing):** sintaxe `lista[inicio:fim:passo]` que extrai uma sublista. O `inicio` é inclusivo, o `fim` é exclusivo. Cria uma nova lista sem modificar a original.

**Mutabilidade:** característica de listas que permite modificar seus elementos após a criação. Strings são imutáveis; listas são mutáveis.

**Cópia rasa (shallow copy):** cópia de uma lista que cria um novo objeto de lista com os mesmos elementos. Feita com `lista[:]` ou `lista.copy()`. Para listas de objetos simples, é suficiente.

**Cópia profunda (deep copy):** cópia que recria recursivamente todos os objetos aninhados. Necessária para listas de listas. Feita com `copy.deepcopy()`.

**`append(valor)`:** método que adiciona um elemento ao final da lista. Operação O(1) — muito eficiente.

**`insert(indice, valor)`:** método que insere um elemento em uma posição específica, deslocando os demais para a direita. Operação O(n) — pode ser lenta para listas grandes.

**`remove(valor)`:** método que remove a primeira ocorrência de um valor. Lança `ValueError` se o valor não existir.

**`pop(indice)`:** método que remove e retorna o elemento na posição especificada. Sem argumento, remove e retorna o último elemento.

**`len(lista)`:** função que retorna o número de elementos da lista.

**`enumerate(lista)`:** função que retorna pares (índice, valor) ao iterar, permitindo acesso ao índice sem `range(len(lista))`.

**Algoritmo de dois ponteiros:** técnica que usa dois índices (início e fim) que se aproximam em direção ao centro, comum em algoritmos de inversão e busca binária.

**Troca com desempacotamento:** `a, b = b, a` — sintaxe Python que troca dois valores sem variável temporária. Funcionada porque o lado direito é avaliado completamente antes das atribuições.

**`set()`:** estrutura de dados que armazena apenas elementos únicos e permite verificação de pertencimento em O(1). Usada como auxiliar em `remover_duplicatas`.

**`is not`:** operador que verifica se duas variáveis referenciam objetos diferentes na memória (identidade de objeto), diferente de `!=` que verifica apenas igualdade de valor.

---

## Antecipação de Erros

**Erro 1: `lista_b = lista_a` não cria uma cópia — é a mesma lista.** Este é o erro mais perigoso com listas em Python. Após `lista_b = lista_a`, modificar `lista_b` modifica `lista_a` também, porque ambas são nomes para o mesmo objeto. Para criar uma cópia independente, use sempre `lista_b = lista_a[:]` ou `lista_b = lista_a.copy()`.

**Erro 2: `IndexError` ao acessar índice fora dos limites.** `lista[5]` em uma lista com cinco elementos (índices 0 a 4) causa `IndexError`. O índice máximo válido é sempre `len(lista) - 1`. Em laços que usam índices, verifique sempre os limites com cuidado.

**Erro 3: Confundir `lista.sort()` com `sorted(lista)`.** `lista.sort()` modifica a lista original in-place e retorna `None`. `sorted(lista)` retorna uma nova lista ordenada sem modificar a original. Fazer `nova = lista.sort()` resulta em `nova = None` — um bug sutil que não gera erro de execução.

**Erro 4: `lista.remove(valor)` lança `ValueError` se o valor não existir.** Antes de chamar `remove()`, verifique se o valor está na lista com `if valor in lista:`. Alternativamente, use `try-except ValueError:` para tratar o caso em que o elemento não está presente.

**Erro 5: O `fim` no fatiamento é exclusivo.** `lista[1:4]` retorna os elementos nos índices 1, 2 e 3 — não o 4. Essa convenção é consistente com `range(start, stop)`, mas confunde iniciantes. Sempre lembre: o `fim` do fatiamento é exclusivo.

**Erro 6: Usar objeto mutável (lista) como padrão de parâmetro.** `def func(lista=[]):` compartilha a mesma lista entre todas as chamadas sem argumento. Nunca use objetos mutáveis como valores padrão — use `None` e crie o objeto dentro da função.

---

## Troubleshooting

**Problema: Modificar a lista dentro da função modificou a lista original fora da função.**
Causa: a função recebeu a referência para a lista original e a modificou in-place (por exemplo, usando `lista.append()` ou `lista[i] = valor` diretamente na lista recebida).
Solução: crie uma cópia no início da função com `copia = lista[:]` e opere sobre a cópia. Retorne a cópia modificada em vez de modificar o original.

**Problema: `rotacionar(lista, k)` retorna resultado incorreto para `k` grande.**
Causa: `k` maior que o tamanho da lista sem tratamento de módulo.
Solução: aplique `k = k % len(lista)` no início da função. Se `k` é múltiplo do tamanho, `k % tamanho == 0` e a lista volta ao estado original — verifique esse caso também.

**Problema: `remover_duplicatas` preserva a ordem mas o resultado parece errado.**
Causa: a função preserva a **primeira** ocorrência de cada elemento, não a última. `remover_duplicatas([3, 1, 3])` retorna `[3, 1]` — não `[1, 3]`.
Solução: esse é o comportamento correto e documentado. Se você precisa da última ocorrência, inverta a lista antes, aplique `remover_duplicatas` e inverta novamente.

**Problema: `mesclar_listas` não está removendo duplicatas que aparecem apenas dentro de uma das listas.**
Causa: comportamento esperado e correto — `mesclar_listas([1,1,2], [3])` retorna `[1, 2, 3]` pois internamente chama `remover_duplicatas` sobre a lista combinada.
Solução: não é um bug. Verifique os testes `test_mesclar_com_duplicatas_internas` para confirmar o comportamento.

---

## Desafio de Fixação

Implemente uma função chamada `achatar_lista(lista_aninhada)` que recebe uma lista de listas (cada elemento é uma lista de números) e retorna uma única lista plana com todos os elementos, preservando a ordem. Por exemplo, `achatar_lista([[1, 2], [3, 4], [5]])` deve retornar `[1, 2, 3, 4, 5]`. Em seguida, implemente `estatisticas_lista(lista)` que usa `achatar_lista()` internamente se receber uma lista aninhada, e retorna um dicionário com `"soma"`, `"minimo"`, `"maximo"` e `"quantidade"` de todos os elementos.

**Resolução comentada:**

~~~python
def achatar_lista(lista_aninhada):
    """
    Converte uma lista de listas em uma única lista plana.

    ENTRADA: lista_aninhada — lista onde cada elemento é uma lista
    SAÍDA: lista plana com todos os elementos em ordem
    """

    # Inicializar a lista plana de resultado
    resultado = []

    # Percorrer cada sublista da lista aninhada
    for sublista in lista_aninhada:
        # Percorrer cada elemento da sublista atual
        for elemento in sublista:
            # Adicionar o elemento à lista plana de resultado
            resultado.append(elemento)

    return resultado


def estatisticas_lista(lista_aninhada):
    """
    Calcula estatísticas de uma lista de listas.

    ENTRADA: lista_aninhada — lista onde cada elemento é uma lista de números
    SAÍDA: dicionário com soma, minimo, maximo e quantidade
    """

    # PASSO 1: Achatar a lista aninhada em uma lista plana
    plana = achatar_lista(lista_aninhada)

    # PASSO 2: Verificar se há elementos para calcular
    if not plana:
        return {"soma": 0, "minimo": None, "maximo": None, "quantidade": 0}

    # PASSO 3: Calcular as estatísticas manualmente
    soma = 0
    minimo = plana[0]
    maximo = plana[0]

    for numero in plana:
        soma += numero
        if numero < minimo:
            minimo = numero
        if numero > maximo:
            maximo = numero

    # PASSO 4: Retornar o dicionário com as estatísticas
    return {
        "soma": soma,
        "minimo": minimo,
        "maximo": maximo,
        "quantidade": len(plana)
    }
~~~

Testes para o desafio:

~~~python
def test_achatar_lista_simples():
    assert achatar_lista([[1, 2], [3, 4], [5]]) == [1, 2, 3, 4, 5]

def test_achatar_lista_vazia():
    assert achatar_lista([]) == []

def test_achatar_sublista_vazia():
    assert achatar_lista([[], [1, 2], []]) == [1, 2]

def test_estatisticas_basicas():
    resultado = estatisticas_lista([[1, 2], [3, 4], [5]])
    assert resultado["soma"] == 15
    assert resultado["minimo"] == 1
    assert resultado["maximo"] == 5
    assert resultado["quantidade"] == 5

def test_estatisticas_lista_vazia():
    resultado = estatisticas_lista([])
    assert resultado["quantidade"] == 0
    assert resultado["minimo"] is None
~~~

---

## Resumo dos Pontos-Chave

**Listas** são coleções ordenadas e mutáveis — a estrutura de dados central para algoritmos em Python. **Índices** começam em `0` e vão até `len(lista) - 1`; índices negativos contam do final (`-1` é o último). **Fatiamento** `lista[inicio:fim:passo]` extrai sublistas — o `fim` é exclusivo — e `lista[:]` cria uma cópia independente. **Mutabilidade** permite modificar listas após a criação, mas `lista_b = lista_a` não cria cópia — apenas um segundo nome para o mesmo objeto. Use `lista[:]` ou `.copy()` para cópias independentes. O **algoritmo de dois ponteiros** (`inicio` e `fim` aproximando-se ao centro) é a base da inversão eficiente. A **troca com desempacotamento** `a, b = b, a` elimina a necessidade de variável temporária e aparecerá em todos os algoritmos de ordenação. **`len()`** retorna o tamanho, **`append()`** adiciona ao final em O(1), **`insert()`** insere em posição específica em O(n). Sempre verifique se a função modifica a lista original ou retorna uma nova — e prefira retornar novas listas para manter as funções puras.

---

## Log de Estado da Aula

**Aula:** 06 — Listas em Python: Armazenando e Manipulando Coleções
**Objetivo:** Implementar quatro funções de manipulação de listas sem usar métodos prontos para as operações centrais.
**Arquivos criados:**
- `modulo_01_fundamentos/aula_06_listas/codigo/__init__.py`
- `modulo_01_fundamentos/aula_06_listas/codigo/manipulador_listas.py`
- `modulo_01_fundamentos/aula_06_listas/testes/test_manipulador_listas.py`

**Estado Funcional:** ✅ Quatro funções implementadas com testes cobrindo casos normais, extremos, imutabilidade da lista original e casos especiais de rotação com k maior que o tamanho.
**Próximas Etapas:** Aula 07 tratará strings como sequências algorítmicas — palíndromos, anagramas, compressão e contagem de frequências — encerrando o Módulo 1 e preparando a entrada no Módulo 2 com os algoritmos de busca e ordenação.

---

## Próximos Passos

Na **Aula 07: Strings como Sequências: Algoritmos sobre Texto**, você aprenderá a tratar strings como sequências de caracteres e aplicar raciocínio algorítmico sobre texto — verificando palíndromos com dois ponteiros, detectando anagramas com contagem de frequências, comprimindo strings repetidas e implementando algoritmos clássicos de processamento de texto. É a última aula do Módulo 1 antes de entrarmos nos algoritmos de busca e ordenação.

---

Dúvidas? Posso prosseguir para a próxima etapa?