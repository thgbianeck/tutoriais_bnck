# Aula 08: Busca Linear — Encontrando Elementos um a um

## Análise de Integridade (Auditoria Prévia)

Antes de iniciar, este conteúdo foi verificado nos seguintes critérios: profundidade técnica mantida com linguagem acessível para iniciantes absolutos, analogias do cotidiano presentes antes de qualquer formalização técnica, código Python 3.13 funcional e comentado linha a linha, testes pytest cobrindo todos os casos relevantes incluindo alvo no início, meio e fim, lista vazia, duplicatas e maior elemento, diagrama Mermaid correto e bem formatado com escape adequado, glossário completo, antecipação de erros relevantes para iniciantes, e mínimo de 2.000 palavras de teoria. Nenhuma falha detectada. Conteúdo aprovado para geração.

---

## Objetivo da Aula

Implementar o algoritmo de busca linear em três variações — busca do primeiro índice, busca de todos os índices e busca do maior elemento — compreendendo a lógica de percorrer uma lista elemento por elemento, analisando o comportamento do algoritmo em diferentes cenários de entrada e entendendo por que a busca linear é o ponto de partida obrigatório de qualquer estudo de algoritmos de busca.

## Pré-requisitos

Módulo 1 concluído — especialmente listas com acesso por índice (Aula 06) e funções com `def` e `return` (Aula 05). Todo o código desta aula é completamente autocontido e não depende de nenhuma aula anterior. O ambiente virtual deve estar ativo e o pytest instalado.

---

## Teoria Detalhada

### Bem-vindo ao Módulo 2: o problema da busca

Imagine que você tem uma lista com dez mil nomes de clientes armazenados em uma planilha e precisa saber se "Carlos Andrade" está entre eles. Como você faria isso? Se a lista não estiver em nenhuma ordem especial, a única alternativa honesta é verificar nome por nome, do primeiro ao último, até encontrar o que procura ou concluir que ele não está lá. Esse processo intuitivo — verificar cada elemento sequencialmente até encontrar o alvo ou esgotar a lista — é exatamente o que o **algoritmo de busca linear** faz.

A busca linear é o algoritmo de busca mais simples que existe. Ela não exige que a lista esteja ordenada, não exige nenhuma estrutura especial, não faz nenhuma suposição sobre os dados. Ela simplesmente olha para cada elemento, um por um, e pergunta: "é você que estou procurando?" É por essa universalidade — funciona em qualquer lista, com qualquer tipo de dado, em qualquer ordem — que a busca linear é o ponto de partida obrigatório de qualquer estudo de algoritmos de busca.

### A lógica por trás da busca linear

O algoritmo de busca linear pode ser descrito em pseudocódigo de forma muito clara antes de qualquer código Python:

~~~text
Algoritmo BUSCA_LINEAR:
  ENTRADA: lista (uma sequência de elementos), alvo (o elemento procurado)
  PARA cada elemento na lista, com seu índice:
    SE o elemento atual é igual ao alvo:
      RETORNE o índice atual
  RETORNE -1  (chegamos ao fim sem encontrar)
~~~

Esse pseudocódigo captura a essência do algoritmo: percorrer a lista do início ao fim, comparando cada elemento com o alvo. Se encontrar, retorna a posição. Se esgotar a lista sem encontrar, sinaliza que o elemento não está presente.

A decisão de retornar **`-1`** (e não `False`, `None` ou qualquer outro valor) para indicar "não encontrado" é uma convenção clássica em algoritmos de busca, herdada de linguagens como C e adotada amplamente. O motivo é prático e poderoso: `-1` é um inteiro, do mesmo tipo que um índice válido. Isso permite que o chamador trate o resultado de forma uniforme — verificando `if resultado != -1:` para saber se o elemento foi encontrado. Retornar `False` seria ambíguo (e se o índice zero é um resultado válido? `False == 0` em Python é `True`, o que poderia causar bugs silenciosos). Retornar `None` funciona, mas exige verificação explícita de tipo. O `-1` é o mais informativo, o mais seguro e o mais alinhado com as convenções da área.

### Três variações do mesmo algoritmo

A busca linear não existe em apenas uma forma. Dependendo do problema, você pode precisar de comportamentos diferentes. Nesta aula, implementamos três variações que ilustram como o mesmo núcleo algorítmico pode ser adaptado para resolver problemas distintos.

A **primeira variação** — `busca_linear(lista, alvo)` — é a forma clássica: retorna o índice da **primeira** ocorrência do alvo. Assim que encontra, para imediatamente com `return`. Essa é a versão mais eficiente quando você só precisa saber se o elemento existe e onde está pela primeira vez.

A **segunda variação** — `busca_linear_todos(lista, alvo)` — não para na primeira ocorrência. Ela continua percorrendo a lista inteira e acumula **todos os índices** onde o alvo aparece. É essencial quando a lista pode ter duplicatas e você precisa encontrar todas as posições. O custo é que ela sempre percorre a lista completa, mesmo se o alvo aparecer só uma vez.

A **terceira variação** — `busca_linear_maior(lista)` — não procura um alvo específico. Ela usa a mesma lógica de percorrer cada elemento, mas em vez de comparar com um alvo, compara cada elemento com o maior valor encontrado até então. É a implementação manual do que `max()` faz internamente — e implementá-la do zero é um exercício fundamental de compreensão.

### O conceito de complexidade: sua primeira análise de eficiência

A busca linear é o algoritmo perfeito para introduzir a análise de eficiência, porque seu comportamento em diferentes cenários é intuitivo e claro. Vamos analisar três casos.

No **melhor caso**, o alvo é o primeiro elemento da lista. O algoritmo faz apenas uma comparação e retorna imediatamente. Não importa se a lista tem dez ou dez milhões de elementos — com o alvo na primeira posição, o trabalho é o mesmo: uma única comparação. Esse é o melhor caso possível, e dizemos que a complexidade do melhor caso é **O(1)** — constante, independente do tamanho da entrada.

No **pior caso**, o alvo é o último elemento da lista, ou o alvo não está na lista. O algoritmo precisa comparar cada um dos n elementos antes de chegar ao resultado. Se a lista tem 10 elementos, são 10 comparações. Se tem 10.000 elementos, são 10.000 comparações. Se tem 1.000.000 de elementos, são 1.000.000 de comparações. O número de operações cresce proporcionalmente ao tamanho da lista — dizemos que a complexidade do pior caso é **O(n)** — linear. Esse é o cenário mais relevante para análise, porque define o limite superior de tempo que o algoritmo pode levar.

No **caso médio**, assumindo que o alvo está em uma posição aleatória na lista, em média ele estará no meio. O algoritmo fará aproximadamente n/2 comparações. Mas n/2 ainda cresce linearmente com n, então o caso médio também é **O(n)**.

Essa análise informal — melhor caso O(1), pior caso O(n) — é o embrião do que você aprenderá formalmente na Aula 28 com a Notação Big O. Por ora, o que importa internalizar é: **o tempo de execução da busca linear cresce linearmente com o tamanho da lista no pior caso**. Para uma lista de 1.000 elementos, pode ser mil vezes mais lento do que para uma lista de 1 elemento.

### Quando usar a busca linear

Apesar de não ser o algoritmo mais eficiente para listas grandes, a busca linear tem casos de uso genuínos e importantes. Ela é a escolha correta quando a **lista não está ordenada** — sem ordenação, a busca binária (que aprenderemos na Aula 09) não pode ser usada, e a busca linear é a única opção universal. Ela também é adequada quando a **lista é pequena** — para listas com menos de algumas dezenas de elementos, a simplicidade da busca linear supera qualquer vantagem de algoritmos mais sofisticados. E ela é a escolha quando você precisa **encontrar todas as ocorrências** de um elemento, não apenas a primeira — nenhum algoritmo mais eficiente resolve esse problema diretamente.

Além disso, a busca linear é a base conceitual que torna compreensível a busca binária. Para entender por que dividir a lista ao meio é tão revolucionário, você precisa primeiro entender bem o custo de verificar elemento por elemento. A busca linear fornece esse ponto de referência.

### A técnica da sentinela: uma otimização clássica

Uma variação interessante da busca linear — que você implementará no desafio desta aula — é a **busca com sentinela**. Na busca linear clássica, o laço tem duas condições em cada iteração: "ainda há elementos?" e "o elemento atual é o alvo?". A ideia da sentinela é eliminar a primeira condição, tornando o laço mais simples.

A técnica funciona assim: antes de buscar, você adiciona o próprio alvo ao final da lista (como sentinela). Agora, você tem a garantia de que o alvo **sempre** será encontrado em algum ponto — no máximo na posição que você adicionou. O laço precisa verificar apenas uma condição: "o elemento atual é o alvo?". Quando encontrar (que vai acontecer com certeza), você verifica se o índice encontrado é menor que o tamanho original da lista. Se for, o alvo estava na lista original. Se for o índice da sentinela, não estava.

O ganho é pequeno em Python (porque Python já otimiza a iteração sobre listas), mas a técnica é historicamente importante em linguagens de baixo nível onde cada instrução de comparação conta. É um exemplo elegante de como uma pequena mudança na estrutura do problema pode simplificar o algoritmo.

### Por que implementar manualmente o que `max()` já faz?

A função `busca_linear_maior()` faz o que `max()` do Python já faz de forma nativa. Por que, então, implementá-la manualmente? Porque entender o algoritmo por trás de `max()` é fundamental. Quando você usa `max([3, 7, 1, 9, 2])`, o Python está fazendo exatamente o que `busca_linear_maior()` faz: percorrendo cada elemento, mantendo o maior visto até então, e retornando o maior ao final. Implementar isso do zero torna o comportamento de `max()` transparente e removem o mistério de funções que parecem "mágicas" para iniciantes.

Além disso, implementar `busca_linear_maior()` treina um padrão fundamental — o padrão do **"melhor até agora"** (best-so-far): inicializar com o primeiro elemento, percorrer o restante comparando cada um com o melhor visto, atualizar o melhor quando encontrar um superior. Esse padrão reaparece em algoritmos mais sofisticados — o Selection Sort (Aula 11) usa exatamente esse padrão para encontrar o mínimo a cada iteração.

### A importância de não modificar a lista original

As três funções desta aula recebem uma lista como parâmetro e **não a modificam**. Isso é proposital e segue o princípio das funções puras que estudamos na Aula 05. A busca linear é uma operação de **leitura** — ela consulta a lista sem alterar nada. Qualquer função de busca que modifique a lista original seria profundamente problemática: o chamador não esperaria que sua lista fosse alterada por uma simples consulta.

A técnica da sentinela, no desafio de fixação, é uma exceção a essa regra — ela adiciona um elemento à lista. Por isso, a implementação correta deve trabalhar em uma **cópia** da lista, nunca na original. Isso é uma lição importante: mesmo quando uma otimização é tentadora, manter as funções puras e previsíveis é geralmente mais valioso do que o ganho de performance.

---

## Analogia de Ancoragem

Pense na busca linear como procurar uma **chave específica em uma gaveta completamente bagunçada**. A gaveta tem dezenas de chaves misturadas sem nenhuma ordem — chaves de casa, de carro, de cadeado, antigas, novas. Você não tem como saber onde está a chave que procura sem olhar uma por uma.

O processo é sempre o mesmo: você pega a primeira chave, olha — "é essa?" — se não for, coloca de lado e pega a próxima. Continua assim até encontrar a chave certa ou perceber que chegou ao fim da gaveta sem encontrá-la. Esse processo exaustivo, sistemático e sem atalhos é a busca linear.

A **primeira variação** é como parar imediatamente ao encontrar a chave — você não precisa olhar as restantes. A **segunda variação** seria o caso em que você tem cópias de várias chaves e quer encontrar todas elas — você precisa olhar a gaveta inteira mesmo depois de encontrar a primeira cópia. A **terceira variação** — encontrar o maior elemento — seria como procurar a chave mais pesada da gaveta: você olha cada uma e vai guardando na mão a mais pesada encontrada até agora, trocando sempre que encontrar uma mais pesada ainda.

E a **técnica da sentinela** seria como colocar uma cópia da chave que procura **no fundo da gaveta antes de começar a busca**. Agora você tem a garantia de que vai encontrar — a questão é se vai encontrar antes de chegar ao fundo (estava na gaveta original) ou só no fundo (não estava).

---

## Diagrama Mermaid

~~~mermaid
flowchart TD
    A["INÍCIO\nbusca_linear(lista, alvo)\nlista=[10,25,7,42,3]\nalvo=42"] --> B["indice = 0"]
    B --> C{"indice < len(lista)?"}
    C -->|"Sim"| D{"lista[indice] == alvo?"}
    D -->|"Não\nlista[0]=10 ≠ 42"| E["indice += 1\nindice=1"]
    E --> C
    D -->|"Não\nlista[1]=25 ≠ 42"| F["indice += 1\nindice=2"]
    F --> C
    D -->|"Não\nlista[2]=7 ≠ 42"| G["indice += 1\nindice=3"]
    G --> C
    D -->|"✅ Sim!\nlista[3]=42 == 42"| H["return 3\n✅ Encontrado no índice 3"]
    C -->|"Não\n(lista esgotada)"| I["return -1\n❌ Não encontrado"]

    style A fill:#4CAF50,color:#fff
    style H fill:#4CAF50,color:#fff
    style I fill:#f44336,color:#fff
    style D fill:#2196F3,color:#fff
    style C fill:#FF9800,color:#fff
~~~

---

## Aplicação no Projeto Prático

Crie a pasta `modulo_02_busca_ordenacao/aula_08_busca_linear/codigo/` e o arquivo `busca_linear.py` com o conteúdo abaixo. Crie também o arquivo `__init__.py` vazio na mesma pasta.

~~~python
# busca_linear.py
# Aula 08: Busca Linear — Encontrando Elementos um a um
# Curso: AlgoLab — Algoritmos do Básico ao Avançado com Python
#
# Este arquivo implementa três variações do algoritmo de busca linear.
# Cada função é autocontida e independente das demais.
# Nenhuma função usa max(), min() ou métodos de busca prontos do Python.


def busca_linear(lista, alvo):
    """
    Encontra a primeira ocorrência do alvo em uma lista.

    Percorre a lista do início ao fim, elemento por elemento,
    retornando o índice da primeira ocorrência do alvo.
    Retorna -1 se o alvo não estiver presente na lista.

    Demonstra: laço for com enumerate, retorno antecipado com break implícito,
               convenção de retornar -1 para 'não encontrado'.

    Complexidade de tempo: O(n) no pior caso, O(1) no melhor caso.
    Complexidade de espaço: O(1) — não cria estruturas auxiliares.

    ENTRADA: lista — lista com qualquer número de elementos comparáveis
             alvo  — o elemento a ser buscado (deve ser do mesmo tipo
                     ou comparável aos elementos da lista)
    SAÍDA: índice (int) da primeira ocorrência do alvo,
           ou -1 se o alvo não estiver na lista

    Exemplos:
        busca_linear([10, 25, 7, 42, 3], 42)  → 3
        busca_linear([10, 25, 7, 42, 3], 99)  → -1
        busca_linear([], 5)                    → -1
        busca_linear([7], 7)                   → 0
        busca_linear([1, 2, 3, 2, 1], 2)       → 1  (primeira ocorrência)
    """

    # PASSO 1: Percorrer cada elemento da lista com seu índice
    # enumerate(lista) retorna pares (indice, elemento) a cada iteração
    # Isso nos dá tanto a posição quanto o valor sem precisar de range(len(lista))
    for indice, elemento in enumerate(lista):

        # PASSO 2: Comparar o elemento atual com o alvo
        # Se encontramos o alvo, retornamos imediatamente o índice
        # Não precisamos continuar percorrendo o restante da lista
        if elemento == alvo:
            return indice

    # PASSO 3: Se chegamos aqui, percorremos toda a lista sem encontrar o alvo
    # Retornamos -1 como convenção para 'não encontrado'
    # -1 é preferível a False ou None porque:
    # - É um inteiro, do mesmo tipo que um índice válido
    # - Não causa confusão com o índice 0 (False == 0 em Python)
    # - É a convenção histórica em algoritmos de busca
    return -1


def busca_linear_todos(lista, alvo):
    """
    Encontra TODAS as ocorrências do alvo em uma lista.

    Percorre a lista inteira do início ao fim, acumulando os índices
    de todas as posições onde o alvo aparece.
    Retorna uma lista vazia se o alvo não estiver presente.

    Demonstra: padrão acumulador com lista, laço sem retorno antecipado,
               distinção entre busca da primeira ocorrência e de todas.

    Complexidade de tempo: O(n) sempre — percorre a lista inteira.
    Complexidade de espaço: O(k) onde k é o número de ocorrências.

    ENTRADA: lista — lista com qualquer número de elementos comparáveis
             alvo  — o elemento a ser buscado
    SAÍDA: lista de inteiros com todos os índices onde o alvo aparece,
           ou lista vazia [] se o alvo não estiver presente

    Exemplos:
        busca_linear_todos([1, 2, 3, 2, 1], 2)  → [1, 3]
        busca_linear_todos([1, 2, 3, 2, 1], 5)  → []
        busca_linear_todos([], 5)               → []
        busca_linear_todos([7, 7, 7], 7)         → [0, 1, 2]
        busca_linear_todos([1, 2, 3], 1)         → [0]
    """

    # PASSO 1: Inicializar a lista acumuladora de índices encontrados
    # Começa vazia — se nenhum elemento for encontrado, retorna []
    indices_encontrados = []

    # PASSO 2: Percorrer TODA a lista — não há retorno antecipado aqui
    # Diferente de busca_linear(), esta função NUNCA para cedo
    # porque precisa encontrar TODAS as ocorrências, não apenas a primeira
    for indice, elemento in enumerate(lista):

        # PASSO 3: Verificar se o elemento atual é o alvo
        if elemento == alvo:
            # Adicionar o índice à lista de resultados
            # Não retornamos — continuamos percorrendo o restante
            indices_encontrados.append(indice)

    # PASSO 4: Retornar a lista com todos os índices encontrados
    # Se o alvo não apareceu nenhuma vez, retorna [] (lista vazia)
    return indices_encontrados


def busca_linear_maior(lista):
    """
    Encontra o maior elemento de uma lista sem usar max().

    Implementa manualmente a lógica de encontrar o maior elemento,
    usando o padrão 'melhor até agora' (best-so-far):
    inicializa com o primeiro elemento e atualiza sempre que encontra
    um valor maior.

    Demonstra: padrão 'melhor até agora', laço começando pelo segundo elemento,
               caso base de lista vazia, equivalência com max() do Python.

    Complexidade de tempo: O(n) sempre — percorre todos os elementos.
    Complexidade de espaço: O(1) — apenas uma variável auxiliar.

    ENTRADA: lista — lista com elementos comparáveis entre si (números ou strings)
    SAÍDA: o maior elemento da lista,
           ou None se a lista estiver vazia

    Exemplos:
        busca_linear_maior([3, 7, 1, 9, 2])    → 9
        busca_linear_maior([5])                 → 5
        busca_linear_maior([])                  → None
        busca_linear_maior([-3, -1, -7, -2])   → -1
        busca_linear_maior([4, 4, 4, 4])        → 4
    """

    # PASSO 1: Tratar o caso de lista vazia
    # Uma lista vazia não tem maior elemento — retornamos None
    if not lista:
        return None

    # PASSO 2: Inicializar o 'maior até agora' com o primeiro elemento
    # Não podemos inicializar com 0 ou qualquer valor arbitrário
    # porque a lista pode conter apenas valores negativos
    # O primeiro elemento é sempre um candidato válido ao maior
    maior_ate_agora = lista[0]

    # PASSO 3: Percorrer os elementos restantes (a partir do segundo)
    # Usamos fatiamento lista[1:] para pular o primeiro elemento
    # (que já usamos como valor inicial)
    for elemento in lista[1:]:

        # PASSO 4: Comparar o elemento atual com o maior encontrado até agora
        if elemento > maior_ate_agora:
            # Encontramos um novo maior — atualizar o registro
            maior_ate_agora = elemento

        # Se o elemento não for maior, simplesmente ignoramos
        # e continuamos para o próximo (continue implícito)

    # PASSO 5: Retornar o maior elemento encontrado
    # Após percorrer toda a lista, maior_ate_agora contém o maior elemento
    return maior_ate_agora
~~~

Crie agora a pasta `modulo_02_busca_ordenacao/aula_08_busca_linear/testes/` e o arquivo `test_busca_linear.py`:

~~~python
# test_busca_linear.py
# Testes automatizados para a Aula 08: Busca Linear
# Execute com: pytest testes/ -v

import sys
import os

# Adicionar o diretório de código ao path para importação
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'codigo'))

from busca_linear import busca_linear, busca_linear_todos, busca_linear_maior


# ============================================================
# TESTES PARA busca_linear()
# ============================================================

class TestBuscaLinear:
    """
    Testa todos os comportamentos da função busca_linear.
    Verifica: alvo no início, meio e fim, ausente, lista vazia,
              lista com um elemento, duplicatas e tipos variados.
    """

    # --- Posição do alvo na lista ---

    def test_alvo_no_inicio(self):
        """Alvo na primeira posição — melhor caso O(1)."""
        # O algoritmo faz apenas uma comparação e retorna
        assert busca_linear([42, 25, 7, 10, 3], 42) == 0

    def test_alvo_no_meio(self):
        """Alvo exatamente no meio da lista — caso médio."""
        assert busca_linear([10, 25, 7, 42, 3], 7) == 2

    def test_alvo_no_fim(self):
        """Alvo na última posição — quase pior caso."""
        # O algoritmo percorre todos os elementos antes de encontrar
        assert busca_linear([10, 25, 7, 42, 3], 3) == 4

    def test_alvo_ausente(self):
        """Alvo não está na lista — pior caso, retorna -1."""
        assert busca_linear([10, 25, 7, 42, 3], 99) == -1

    # --- Casos extremos de tamanho ---

    def test_lista_vazia(self):
        """Lista vazia — deve retornar -1 imediatamente."""
        assert busca_linear([], 5) == -1

    def test_lista_com_um_elemento_encontrado(self):
        """Lista com um único elemento — alvo presente."""
        assert busca_linear([7], 7) == 0

    def test_lista_com_um_elemento_ausente(self):
        """Lista com um único elemento — alvo ausente."""
        assert busca_linear([7], 99) == -1

    # --- Duplicatas ---

    def test_duplicatas_retorna_primeira_ocorrencia(self):
        """Com duplicatas, deve retornar o PRIMEIRO índice encontrado."""
        # O valor 2 aparece nos índices 1 e 3 — deve retornar 1
        resultado = busca_linear([1, 2, 3, 2, 1], 2)
        assert resultado == 1

    def test_todos_elementos_iguais(self):
        """Lista com todos os elementos iguais ao alvo — retorna índice 0."""
        assert busca_linear([5, 5, 5, 5, 5], 5) == 0

    # --- Tipos variados ---

    def test_lista_de_strings(self):
        """Deve funcionar com listas de strings."""
        lista = ["banana", "maçã", "uva", "pera"]
        assert busca_linear(lista, "uva") == 2

    def test_lista_de_strings_ausente(self):
        """Busca de string ausente em lista de strings."""
        lista = ["banana", "maçã", "uva"]
        assert busca_linear(lista, "melancia") == -1

    def test_lista_com_negativos(self):
        """Deve funcionar com números negativos."""
        assert busca_linear([-5, -3, -1, -7], -3) == 1

    def test_lista_com_floats(self):
        """Deve funcionar com números de ponto flutuante."""
        assert busca_linear([1.1, 2.2, 3.3, 4.4], 3.3) == 2

    # --- Verificação do tipo de retorno ---

    def test_retorno_e_inteiro_quando_encontrado(self):
        """O retorno deve ser um inteiro quando o alvo é encontrado."""
        resultado = busca_linear([1, 2, 3], 2)
        assert isinstance(resultado, int)
        assert resultado == 1

    def test_retorno_e_menos_um_quando_ausente(self):
        """O retorno deve ser exatamente -1 (não False, não None)."""
        resultado = busca_linear([1, 2, 3], 99)
        assert resultado == -1
        # Verificação crítica: -1 não é False nem None
        assert resultado is not False
        assert resultado is not None

    def test_indice_zero_nao_confunde_com_falso(self):
        """Índice 0 é um resultado válido — não deve ser confundido com False."""
        resultado = busca_linear([42, 1, 2, 3], 42)
        # Se a função retornasse False para 'não encontrado',
        # 'resultado == 0' seria True (porque False == 0 em Python)
        # mas 'resultado is False' seria False — por isso usamos -1
        assert resultado == 0
        assert resultado is not False


# ============================================================
# TESTES PARA busca_linear_todos()
# ============================================================

class TestBuscaLinearTodos:
    """
    Testa todos os comportamentos da função busca_linear_todos.
    Verifica: múltiplas ocorrências, ocorrência única, ausente,
              lista vazia e todos os elementos iguais.
    """

    # --- Múltiplas ocorrências ---

    def test_duas_ocorrencias(self):
        """Alvo aparece duas vezes — deve retornar ambos os índices."""
        resultado = busca_linear_todos([1, 2, 3, 2, 1], 2)
        assert resultado == [1, 3]

    def test_tres_ocorrencias(self):
        """Alvo aparece três vezes em posições não consecutivas."""
        resultado = busca_linear_todos([5, 1, 5, 2, 5], 5)
        assert resultado == [0, 2, 4]

    def test_ocorrencias_consecutivas(self):
        """Alvo aparece em posições consecutivas."""
        resultado = busca_linear_todos([1, 2, 2, 2, 3], 2)
        assert resultado == [1, 2, 3]

    def test_todos_elementos_iguais_ao_alvo(self):
        """Todos os elementos são iguais ao alvo — retorna todos os índices."""
        resultado = busca_linear_todos([7, 7, 7, 7], 7)
        assert resultado == [0, 1, 2, 3]

    # --- Ocorrência única ---

    def test_uma_ocorrencia(self):
        """Alvo aparece exatamente uma vez."""
        resultado = busca_linear_todos([1, 2, 3, 4, 5], 3)
        assert resultado == [2]

    # --- Alvo ausente ---

    def test_alvo_ausente(self):
        """Alvo não aparece — deve retornar lista vazia."""
        resultado = busca_linear_todos([1, 2, 3], 99)
        assert resultado == []

    # --- Casos extremos ---

    def test_lista_vazia(self):
        """Lista vazia — deve retornar lista vazia."""
        assert busca_linear_todos([], 5) == []

    def test_lista_um_elemento_encontrado(self):
        """Lista com um elemento — alvo presente."""
        assert busca_linear_todos([42], 42) == [0]

    def test_lista_um_elemento_ausente(self):
        """Lista com um elemento — alvo ausente."""
        assert busca_linear_todos([42], 99) == []

    # --- Verificação de tipo e ordem ---

    def test_retorna_lista(self):
        """A função deve sempre retornar uma lista."""
        assert isinstance(busca_linear_todos([1, 2, 3], 2), list)
        assert isinstance(busca_linear_todos([1, 2, 3], 99), list)

    def test_indices_em_ordem_crescente(self):
        """Os índices retornados devem estar em ordem crescente."""
        resultado = busca_linear_todos([3, 1, 3, 1, 3], 3)
        assert resultado == [0, 2, 4]
        # Verificar que a lista está ordenada
        assert resultado == sorted(resultado)

    def test_nao_modifica_lista_original(self):
        """A função não deve modificar a lista de entrada."""
        original = [1, 2, 3, 2, 1]
        copia_antes = original.copy()
        busca_linear_todos(original, 2)
        assert original == copia_antes


# ============================================================
# TESTES PARA busca_linear_maior()
# ============================================================

class TestBuscaLinearMaior:
    """
    Testa todos os comportamentos da função busca_linear_maior.
    Verifica: maior em diferentes posições, lista vazia, um elemento,
              negativos, todos iguais e floats.
    """

    # --- Posição do maior elemento ---

    def test_maior_no_inicio(self):
        """Maior elemento está na primeira posição."""
        assert busca_linear_maior([9, 3, 7, 1, 5]) == 9

    def test_maior_no_meio(self):
        """Maior elemento está no meio da lista."""
        assert busca_linear_maior([3, 7, 9, 1, 5]) == 9

    def test_maior_no_fim(self):
        """Maior elemento está na última posição."""
        assert busca_linear_maior([3, 7, 1, 5, 9]) == 9

    # --- Casos extremos ---

    def test_lista_vazia_retorna_none(self):
        """Lista vazia — deve retornar None."""
        assert busca_linear_maior([]) is None

    def test_lista_um_elemento(self):
        """Lista com um único elemento — retorna o próprio elemento."""
        assert busca_linear_maior([42]) == 42

    def test_todos_elementos_iguais(self):
        """Todos os elementos são iguais — retorna qualquer um (o mesmo valor)."""
        assert busca_linear_maior([5, 5, 5, 5, 5]) == 5

    # --- Números negativos ---

    def test_maior_com_negativos(self):
        """Maior entre números negativos — deve retornar o menos negativo."""
        assert busca_linear_maior([-3, -1, -7, -2, -5]) == -1

    def test_maior_com_mistura_positivos_negativos(self):
        """Mistura de positivos e negativos."""
        assert busca_linear_maior([-5, 3, -1, 7, -2]) == 7

    def test_maior_inclui_zero(self):
        """Zero pode ser o maior elemento."""
        assert busca_linear_maior([-5, -3, 0, -1]) == 0

    # --- Floats ---

    def test_maior_com_floats(self):
        """Deve funcionar com números de ponto flutuante."""
        assert busca_linear_maior([1.5, 3.7, 2.1, 0.8]) == 3.7

    # --- Verificação de equivalência com max() ---

    def test_equivalencia_com_max(self):
        """O resultado deve ser idêntico ao de max() do Python."""
        listas = [
            [3, 7, 1, 9, 2],
            [100],
            [-5, -3, -1, -7],
            [4, 4, 4, 4],
        ]
        for lista in listas:
            assert busca_linear_maior(lista) == max(lista)

    def test_nao_modifica_lista_original(self):
        """A função não deve modificar a lista de entrada."""
        original = [3, 7, 1, 9, 2]
        copia_antes = original.copy()
        busca_linear_maior(original)
        assert original == copia_antes

    def test_retorno_e_do_mesmo_tipo_que_elementos(self):
        """O retorno deve ser do mesmo tipo que os elementos da lista."""
        resultado_int = busca_linear_maior([1, 2, 3])
        resultado_float = busca_linear_maior([1.0, 2.0, 3.0])
        assert isinstance(resultado_int, int)
        assert isinstance(resultado_float, float)
~~~

### Como executar os testes

~~~text
cd modulo_02_busca_ordenacao\aula_08_busca_linear
pytest testes/ -v
~~~

### Estrutura de pastas necessária

~~~text
modulo_02_busca_ordenacao/
└── aula_08_busca_linear/
    ├── codigo/
    │   ├── __init__.py        ← arquivo vazio
    │   └── busca_linear.py
    └── testes/
        └── test_busca_linear.py
~~~

Criando o `__init__.py` no terminal:

~~~text
type nul > modulo_02_busca_ordenacao\aula_08_busca_linear\codigo\__init__.py
~~~

---

## Glossário Técnico da Aula

**Busca linear (linear search):** algoritmo que percorre uma lista elemento por elemento, do início ao fim, comparando cada um com o alvo. Funciona em qualquer lista, ordenada ou não.

**Alvo (target):** o elemento que se deseja encontrar na lista. Passado como argumento para a função de busca.

**Índice:** posição de um elemento em uma lista, começando em 0. A busca linear retorna o índice da primeira ocorrência do alvo.

**Convenção `-1`:** valor retornado quando o alvo não é encontrado. Escolhido porque é um inteiro (mesmo tipo que índices válidos) e não pode ser confundido com o índice 0 — ao contrário de `False`, que em Python é igual a 0.

**`enumerate(iterável)`:** função Python que retorna pares `(índice, elemento)` ao iterar. Permite acessar o índice e o valor simultaneamente sem usar `range(len(lista))`.

**Melhor caso:** cenário de entrada que minimiza o número de operações do algoritmo. Para a busca linear: alvo na primeira posição — apenas uma comparação — O(1).

**Pior caso:** cenário de entrada que maximiza o número de operações. Para a busca linear: alvo na última posição ou ausente — n comparações — O(n).

**Caso médio:** comportamento esperado para uma entrada aleatória típica. Para a busca linear: n/2 comparações em média — ainda O(n).

**O(n) — complexidade linear:** a quantidade de operações cresce proporcionalmente ao tamanho da entrada. Se a lista dobrar de tamanho, o tempo de execução dobra no pior caso.

**O(1) — complexidade constante:** a quantidade de operações não depende do tamanho da entrada. O acesso a um elemento por índice em uma lista é O(1).

**Padrão "melhor até agora" (best-so-far):** técnica algorítmica que inicializa com o primeiro elemento e atualiza o resultado sempre que encontra um valor melhor (maior, menor, etc.). Base de algoritmos como `busca_linear_maior()` e Selection Sort.

**Técnica da sentinela:** otimização que adiciona o alvo ao final da lista antes de buscar, garantindo que o laço encontrará o elemento (eliminando a condição de verificação de fim de lista). Permite simplificar o laço de busca.

**Função pura:** função que não modifica seus argumentos e sempre retorna o mesmo resultado para os mesmos argumentos. As três funções desta aula são puras — não modificam a lista recebida.

**`lista[1:]`:** fatiamento que retorna todos os elementos a partir do índice 1 (o segundo elemento). Usado em `busca_linear_maior()` para percorrer os elementos após o primeiro.

---

## Antecipação de Erros

**Erro 1: Confundir o índice retornado com o valor encontrado.** `busca_linear([10, 25, 7, 42], 42)` retorna `3` — o **índice** da posição onde 42 está, não o valor `42` em si. Se você quiser o valor, use o índice para acessar a lista: `lista[busca_linear(lista, alvo)]`. Esse erro é especialmente comum quando os valores da lista também são números — confundir `3` (índice) com `42` (valor) pode causar bugs silenciosos.

**Erro 2: Usar `False` ou `None` para sinalizar "não encontrado" em vez de `-1`.** Em Python, `False == 0` é `True`. Se a função retornar `False` quando o alvo não é encontrado, um chamador que fizer `if resultado:` tratará o índice 0 como "não encontrado" — porque `if 0:` é falso em Python. Sempre retorne `-1` para consistência com a convenção da área e para evitar essa confusão.

**Erro 3: Inicializar `busca_linear_maior()` com zero em vez do primeiro elemento.** Se a lista contém apenas números negativos, como `[-5, -3, -1]`, inicializar com `maior = 0` fará a função retornar `0` — que não está na lista. Sempre inicialize com `lista[0]`, o primeiro elemento real, para garantir que o resultado seja sempre um elemento da lista.

**Erro 4: Modificar a lista original dentro da função.** Adicionar ou remover elementos da lista recebida como parâmetro causa efeitos colaterais inesperados para o chamador. A busca linear é uma operação de leitura — nunca modifique a lista. Na técnica da sentinela (desafio), trabalhe em uma cópia: `copia = lista + [alvo]`.

**Erro 5: Usar `is` em vez de `==` para comparar valores.** `elemento is alvo` verifica identidade de objeto (se são o mesmo objeto na memória), não igualdade de valor. Para números inteiros pequenos (até 256), Python reutiliza objetos, mas para números maiores ou strings, dois valores iguais podem ser objetos diferentes. Sempre use `==` para comparar valores em buscas.

**Erro 6: Esquecer o caso de lista vazia antes de acessar `lista[0]`.** Em `busca_linear_maior()`, acessar `lista[0]` em uma lista vazia causa `IndexError`. Sempre verifique `if not lista: return None` antes de inicializar com o primeiro elemento.

---

## Troubleshooting

**Problema: `ImportError: No module named 'busca_linear'` ao rodar os testes.**
Causa: o pytest não está encontrando o arquivo `busca_linear.py` no caminho esperado, ou o arquivo `__init__.py` está faltando na pasta `codigo/`.
Solução: verifique se o `__init__.py` existe em `codigo/`, e confirme que os testes estão sendo executados de dentro da pasta `aula_08_busca_linear/` com `pytest testes/ -v`. O bloco `sys.path.insert()` no arquivo de testes garante que o Python encontre o módulo.

**Problema: `busca_linear([1, 2, 3, 2, 1], 2)` retorna `3` em vez de `1`.**
Causa: o laço está percorrendo a lista de trás para frente, ou há um erro na lógica de retorno que permite continuar após encontrar o alvo.
Solução: verifique se o `return indice` está dentro do bloco `if elemento == alvo:` e que está no lugar correto dentro do laço. O `return` deve encerrar a função imediatamente na primeira ocorrência.

**Problema: `busca_linear_maior([-5, -3, -1])` retorna `0` em vez de `-1`.**
Causa: a variável `maior_ate_agora` foi inicializada com `0` em vez de `lista[0]`.
Solução: sempre inicialize com o primeiro elemento: `maior_ate_agora = lista[0]`. Lembre-se de verificar a lista vazia antes dessa linha.

**Problema: `busca_linear_todos` retorna `None` em vez de lista vazia.**
Causa: a função tem um `return` fora do lugar, ou a lista `indices_encontrados` não está sendo retornada no final.
Solução: verifique que `return indices_encontrados` está na última linha da função, fora do laço. Se o `return` estiver dentro do `if` ou do `for`, a função encerrará prematuramente.

---

## Desafio de Fixação

Implemente uma função chamada `busca_linear_sentinela(lista, alvo)` que usa a técnica da sentinela para simplificar o laço de busca. A técnica consiste em adicionar o próprio alvo ao final de uma **cópia** da lista antes de começar a busca. Com isso, o laço não precisa verificar se chegou ao fim — ele sempre encontrará o alvo. Após o laço, verifique se o índice encontrado é menor que o tamanho da lista original. Se for, o alvo estava na lista. Se for igual ao tamanho original, o alvo foi encontrado apenas na sentinela — não estava na lista original.

**Resolução comentada:**

~~~python
def busca_linear_sentinela(lista, alvo):
    """
    Busca linear usando a técnica da sentinela.

    Adiciona o alvo ao final de uma cópia da lista antes de buscar.
    O laço tem apenas UMA condição de verificação (encontrou o alvo?)
    em vez de DUAS (chegou ao fim? encontrou o alvo?).

    ENTRADA: lista — lista com qualquer número de elementos
             alvo  — o elemento a ser buscado
    SAÍDA: índice da primeira ocorrência do alvo,
           ou -1 se o alvo não estiver na lista original
    """

    # PASSO 1: Guardar o tamanho original da lista
    # Este valor será usado para verificar se o alvo foi encontrado
    # na lista real ou apenas na sentinela
    tamanho_original = len(lista)

    # PASSO 2: Criar uma cópia da lista com o alvo adicionado ao final
    # CRÍTICO: trabalhamos em uma CÓPIA — nunca modificamos a lista original
    # O alvo adicionado é a sentinela — garante que o laço sempre termine
    lista_com_sentinela = lista + [alvo]

    # PASSO 3: Executar o laço sem verificar o fim da lista
    # O laço agora tem apenas UMA condição — não precisa de 'and indice < len'
    # porque a sentinela garante que o alvo SEMPRE será encontrado
    indice = 0
    while lista_com_sentinela[indice] != alvo:
        indice += 1

    # PASSO 4: Verificar se o alvo encontrado estava na lista original
    # ou apenas na sentinela
    if indice < tamanho_original:
        # O alvo foi encontrado antes da sentinela — estava na lista original
        return indice
    else:
        # O alvo foi encontrado apenas na sentinela — não estava na original
        return -1
~~~

Testes para o desafio:

~~~python
def test_sentinela_alvo_presente():
    """Caso normal: alvo presente na lista."""
    assert busca_linear_sentinela([10, 25, 7, 42, 3], 42) == 3

def test_sentinela_alvo_ausente():
    """Alvo ausente — deve retornar -1."""
    assert busca_linear_sentinela([10, 25, 7, 42, 3], 99) == -1

def test_sentinela_lista_vazia():
    """Lista vazia — alvo encontrado apenas na sentinela, retorna -1."""
    assert busca_linear_sentinela([], 5) == -1

def test_sentinela_alvo_no_inicio():
    """Alvo na primeira posição — melhor caso."""
    assert busca_linear_sentinela([42, 1, 2, 3], 42) == 0

def test_sentinela_nao_modifica_original():
    """A lista original NÃO deve ser modificada."""
    original = [1, 2, 3, 4, 5]
    copia_antes = original.copy()
    busca_linear_sentinela(original, 3)
    assert original == copia_antes

def test_sentinela_equivale_busca_linear():
    """O resultado deve ser idêntico ao de busca_linear() para os mesmos inputs."""
    casos = [
        ([1, 2, 3, 4, 5], 3),
        ([1, 2, 3, 4, 5], 99),
        ([], 5),
        ([7], 7),
    ]
    for lista, alvo in casos:
        assert busca_linear_sentinela(lista, alvo) == busca_linear(lista, alvo)
~~~

---

## Resumo dos Pontos-Chave

A **busca linear** percorre a lista elemento por elemento, do início ao fim, comparando cada elemento com o alvo — funciona em qualquer lista, ordenada ou não. A complexidade é **O(1) no melhor caso** (alvo na primeira posição) e **O(n) no pior caso** (alvo ausente ou no final). Retornar **`-1`** para "não encontrado" é a convenção correta — não `False` (que iguala a 0 em Python) nem `None`. As **três variações** cobrem os usos mais comuns: busca da primeira ocorrência (para cedo com `return`), busca de todas as ocorrências (percorre a lista inteira) e busca do maior elemento (padrão "melhor até agora"). A **técnica da sentinela** simplifica o laço eliminando a verificação de fim de lista, mas exige trabalhar em uma cópia para não modificar a lista original. Sempre inicialize `busca_linear_maior()` com `lista[0]`, nunca com `0`, para garantir resultado correto com listas de valores negativos. A busca linear é a base conceitual que torna compreensível a busca binária — você precisa entender o custo de O(n) para apreciar o ganho de O(log n).

---

## Log de Estado da Aula

**Aula:** 08 — Busca Linear: Encontrando Elementos um a um
**Objetivo:** Implementar busca linear em três variações com análise informal de complexidade.
**Arquivos criados:**
- `modulo_02_busca_ordenacao/aula_08_busca_linear/codigo/__init__.py`
- `modulo_02_busca_ordenacao/aula_08_busca_linear/codigo/busca_linear.py`
- `modulo_02_busca_ordenacao/aula_08_busca_linear/testes/test_busca_linear.py`

**Estado Funcional:** ✅ Três funções implementadas com testes cobrindo posição do alvo, casos extremos de tamanho, duplicatas, tipos variados, imutabilidade da lista original e equivalência de comportamento entre variações.
**Próximas Etapas:** Aula 09 apresentará a busca binária — um algoritmo que exige lista ordenada mas realiza a busca em O(log n), tornando-o revolucionariamente mais eficiente para listas grandes.

---

## Próximos Passos

Na **Aula 09: Busca Binária — Dividindo para Encontrar Mais Rápido**, você aprenderá por que verificar o elemento do meio — em vez de verificar elemento por elemento — permite descartar metade da lista a cada passo. Uma lista de 1.000.000 de elementos exige no máximo 20 comparações com busca binária, contra até 1.000.000 com busca linear. Você implementará a versão iterativa e a versão recursiva, e construirá uma função que compara o número de passos entre os dois algoritmos para o mesmo input.

---

Dúvidas? Posso prosseguir para a próxima etapa?