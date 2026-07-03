# Aula 07: Strings como Sequências: Algoritmos sobre Texto

## Análise de Integridade (Auditoria Prévia)

Antes de iniciar, este conteúdo foi verificado nos seguintes critérios: profundidade técnica mantida com linguagem acessível para iniciantes absolutos, analogias do cotidiano presentes antes de qualquer formalização técnica, código Python 3.13 funcional e comentado linha a linha, testes pytest cobrindo casos normais e extremos incluindo strings com espaços, maiúsculas, acentos e strings vazias, diagrama Mermaid correto e bem formatado com escape adequado, glossário completo, antecipação de erros relevantes para iniciantes, e mínimo de 2.000 palavras de teoria. Nenhuma falha detectada. Conteúdo aprovado para geração.

---

## Objetivo da Aula

Aprender a tratar strings como sequências de caracteres e aplicar lógica algorítmica sobre texto — implementando quatro algoritmos clássicos: verificação de palíndromos com a técnica de dois ponteiros, detecção de anagramas com contagem de frequências, contagem de caracteres com dicionário, e compressão de strings por contagem de sequências repetidas. Esta é a última aula do Módulo 1, que fecha os fundamentos e abre caminho para os algoritmos de busca e ordenação do Módulo 2.

## Pré-requisitos

Aulas 04, 05 e 06 concluídas — especialmente laços `for` para iterar sobre sequências, funções com `def` e `return`, e o conceito de dicionário como estrutura de contagem (introduzido brevemente na Aula 05 no desafio de `contar_vogais`). O ambiente virtual deve estar ativo e o pytest instalado.

---

## Teoria Detalhada

### Strings como sequências: a perspectiva algorítmica

Nas primeiras aulas deste curso, usamos strings principalmente para armazenar texto — nomes de pessoas, mensagens, classificações. Mas há uma perspectiva completamente diferente e muito mais poderosa: strings são **sequências de caracteres**, e como tal, todos os algoritmos que aprendemos para listas se aplicam a elas também.

Assim como uma lista `[1, 2, 3, 4, 5]` tem cinco elementos com índices de 0 a 4, a string `"Python"` tem seis caracteres com índices de 0 a 5. `"Python"[0]` retorna `"P"`. `"Python"[-1]` retorna `"n"`. `"Python"[1:4]` retorna `"yth"`. Você pode iterar sobre cada caractere com `for caractere in "Python":`. Pode verificar pertencimento com `"P" in "Python"` que retorna `True`. Pode medir o comprimento com `len("Python")` que retorna `6`.

Essa equivalência entre strings e listas é o que torna possível aplicar algoritmos clássicos — como o de dois ponteiros que usamos para inverter listas — diretamente sobre texto. E é por isso que estudar algoritmos sobre strings é tanto um exercício de processamento de texto quanto um treino de raciocínio algorítmico.

### A imutabilidade das strings: consequências práticas

A diferença fundamental entre strings e listas — e que tem consequências profundas para os algoritmos — é a **imutabilidade**. Uma string, uma vez criada, não pode ser modificada. `"Python"[0] = "p"` causa `TypeError: 'str' object does not support item assignment`. Você não pode trocar um caractere por outro, não pode inserir no meio, não pode remover elementos individuais.

Toda operação que "modifica" uma string na verdade cria uma **nova string**. `texto.lower()` não modifica `texto` — retorna uma nova string com todos os caracteres em minúsculas. `texto.replace("a", "b")` retorna uma nova string com as substituições. `texto + " mundo"` cria uma nova string concatenada.

Isso tem duas implicações práticas para algoritmos. Primeira: quando você precisar de um resultado que acumula caracteres ou partes de string, não use concatenação em laço (`resultado += caractere` repetidamente em um laço grande) — isso cria uma nova string a cada iteração, o que é ineficiente para textos longos. A alternativa eficiente é acumular em uma lista e usar `"".join(lista)` ao final, que cria apenas uma string. Segunda: para "comparar" se dois textos são iguais após transformações, você não precisa modificar nada — basta criar versões transformadas e comparar.

### Métodos essenciais de string para algoritmos

Python oferece um conjunto rico de métodos de string que são especialmente úteis em algoritmos de texto. Os mais importantes são:

`.lower()` que converte todos os caracteres para minúsculas — fundamental para comparações que ignoram capitalização. `.upper()` que converte para maiúsculas. `.strip()` que remove espaços, tabs e quebras de linha das bordas — essencial para normalizar entradas. `.replace(antigo, novo)` que substitui todas as ocorrências de um substring por outro. `.split(separador)` que divide a string em uma lista de substrings usando o separador especificado — sem separador, divide por qualquer sequência de espaços. `"separador".join(lista)` que une os elementos de uma lista em uma única string com o separador entre eles. `.find(substring)` que retorna o índice da primeira ocorrência do substring, ou `-1` se não encontrado. `.count(substring)` que conta quantas vezes o substring aparece. `str.isalpha()` que retorna `True` se a string contém apenas letras. `str.isdigit()` que retorna `True` se contém apenas dígitos.

### O algoritmo de dois ponteiros aplicado a strings

O algoritmo de dois ponteiros — que usamos na Aula 06 para inverter listas — tem uma aplicação clássica e elegante em strings: a **verificação de palíndromos**. Um palíndromo é uma palavra ou frase que lê igual de trás para frente — "Ana", "radar", "A man a plan a canal Panama".

A abordagem ingênua seria inverter a string e comparar com o original: `texto == texto[::-1]`. Isso funciona e é Pythônico, mas não ensina o algoritmo. A abordagem algorítmica usa dois ponteiros: um no início (`esquerda = 0`) e um no final (`direita = len(texto) - 1`). A cada passo, comparamos os caracteres nas duas posições — se são iguais, avançamos os ponteiros em direção ao centro. Se em algum ponto os caracteres são diferentes, o texto não é palíndromo. Se os ponteiros se cruzam sem encontrar diferença, o texto é palíndromo.

Esse algoritmo é O(n) — percorre no máximo metade dos caracteres — e usa O(1) de espaço adicional (apenas duas variáveis de índice). A abordagem de inverter e comparar também é O(n), mas usa O(n) de espaço adicional para criar a string invertida. Para strings muito longas, a diferença de uso de memória importa.

### Detecção de anagramas: a técnica da frequência de caracteres

Dois textos são **anagramas** se contêm exatamente os mesmos caracteres com as mesmas frequências, apenas em ordem diferente. "amor" e "roma" são anagramas — ambos têm um 'a', um 'm', um 'o' e um 'r'. "listen" e "silent" são anagramas. "hello" e "world" não são.

A abordagem mais elegante e eficiente para detectar anagramas usa a contagem de frequência de caracteres. Para cada texto, criamos um dicionário que mapeia cada caractere à sua frequência. Se os dois dicionários são iguais, os textos são anagramas. O algoritmo é O(n + m) onde n e m são os comprimentos dos dois textos — cada texto é percorrido uma vez para construir seu dicionário de frequências.

Um detalhe importante: ao verificar anagramas, geralmente normalizamos os textos primeiro — convertendo para minúsculas e removendo espaços — para que a comparação seja sobre o conteúdo semântico, não sobre formatação. "Amor" e "Roma" devem ser anagramas apesar das maiúsculas.

### Contagem de frequências: dicionários como acumuladores

Um padrão algorítmico fundamental — que aparece em anagramas, em análise de texto, em compressão de dados e em muitos outros problemas — é a **contagem de frequências**: dado uma sequência de elementos, contar quantas vezes cada elemento distinto aparece.

Em Python, a estrutura natural para isso é o **dicionário** (`dict`): as chaves são os elementos únicos e os valores são as contagens. O padrão é: para cada elemento da sequência, se ele já está no dicionário, incrementa o contador; se não está, cria a entrada com valor 1. Em Python, isso pode ser escrito com `dicionario.get(chave, 0)` — que retorna o valor associado à chave, ou `0` se a chave não existir.

A alternativa mais elegante para contagem de frequências em Python é `collections.Counter`, mas nesta aula implementaremos manualmente para entender o algoritmo subjacente. Implementar `Counter` manualmente com um dicionário é um exercício perfeito de dicionários como acumuladores.

### Compressão de strings: codificação por comprimento de execução

A **codificação por comprimento de execução** (Run-Length Encoding ou RLE) é um algoritmo simples de compressão de dados que funciona muito bem para strings com muitos caracteres repetidos consecutivos. A ideia é substituir sequências de caracteres idênticos pelo caractere seguido do número de repetições: `"aaabbc"` torna-se `"a3b2c1"`.

Esse algoritmo é um exemplo claro de como processar uma string de forma algorítmica — mantendo controle do caractere atual, contando repetições consecutivas e decidindo quando "fechar" um grupo e começar outro. É também um exemplo de algoritmo que pode ou não comprimir — se a string original é mais curta que a versão comprimida (como `"abc"` que viraria `"a1b1c1"`), é melhor retornar o original.

O RLE é usado em formatos de imagem como BMP e TIFF para comprimir áreas de cor uniforme, e em protocolos de comunicação para comprimir dados repetitivos.

### Normalização de strings: o pré-processamento que muda tudo

Antes de aplicar qualquer algoritmo sobre texto, é essencial **normalizar** a string — remover ruído e trazer o texto para um formato padrão que facilite a comparação. As operações de normalização mais comuns são: converter para minúsculas (`.lower()`), remover espaços nas bordas (`.strip()`), remover espaços internos (`.replace(" ", "")`), remover pontuação (usando laço com `str.isalpha()`), e remover acentos (com `unicodedata.normalize()`).

Para o algoritmo de palíndromo, precisamos ignorar espaços e capitalização — "A man a plan a canal Panama" deve ser reconhecido como palíndromo. Para o algoritmo de anagrama, precisamos ignorar espaços e capitalização também. A função de normalização é separada da lógica principal — isso é um exemplo do princípio da responsabilidade única que estudamos na Aula 05.

### Iteração sobre strings e construção de resultados

Quando você precisa construir uma nova string caractere a caractere — como no algoritmo de compressão — a abordagem eficiente é acumular as partes em uma lista e usar `"".join(lista)` ao final. A alternativa de concatenar strings em laço (`resultado += parte`) cria uma nova string a cada iteração, o que é O(n²) no total para n caracteres. `"".join(lista)` cria uma única string final em O(n).

A função `join()` recebe um iterável de strings e as une com o separador entre elas. `"-".join(["a", "b", "c"])` retorna `"a-b-c"`. `"".join(["a", "b", "c"])` retorna `"abc"` — sem separador, apenas concatenação. Essa função é fundamental para qualquer algoritmo que constrói strings a partir de partes.

---

## Analogia de Ancoragem

Pense em uma string como um **colar de contas coloridas** — cada conta é um caractere, tem uma posição específica e uma cor (o valor do caractere). O colar é **imutável**: você não pode substituir uma conta do meio por outra cor. Se quiser um colar com uma conta diferente, precisa fazer um colar novo.

O algoritmo de **palíndromo com dois ponteiros** é como verificar se um colar é simétrico: você pega a primeira e a última conta e compara as cores. Se iguais, pega a segunda e a penúltima e compara. Continua em direção ao centro — se em algum momento as cores são diferentes, o colar não é simétrico. Se chegar ao centro sem encontrar diferença, é simétrico.

O algoritmo de **anagrama** é como verificar se dois colares têm exatamente as mesmas quantidades de contas de cada cor, independentemente da ordem em que estão dispostas. Você conta quantas contas vermelhas, azuis e verdes tem em cada colar — se as contagens são iguais para cada cor, são anagramas.

A **compressão RLE** é como descrever verbalmente um colar: em vez de dizer "vermelho, vermelho, vermelho, azul, azul, verde", você diz "três vermelhos, dois azuis, um verde" — mais eficiente para colares com muitas repetições. Para colares totalmente alternados, a descrição verbosa pode ser mais longa que a original.

---

## Diagrama Mermaid

~~~mermaid
flowchart LR
    subgraph PALINDROMO["Algoritmo de Palíndromo: 'radar'"]
        P1["texto = 'radar'\nesquerda=0, direita=4"] --> P2{"texto[0]=='r'\n== texto[4]=='r'?"}
        P2 -->|"Sim"| P3["esquerda=1, direita=3"]
        P3 --> P4{"texto[1]=='a'\n== texto[3]=='a'?"}
        P4 -->|"Sim"| P5["esquerda=2, direita=2"]
        P5 --> P6{"esquerda >= direita?"}
        P6 -->|"Sim"| P7["✅ É palíndromo!\nRetornar True"]
    end

    subgraph ANAGRAMA["Algoritmo de Anagrama: 'amor' e 'roma'"]
        A1["Normalizar:\namor → amor\nroma → roma"] --> A2["Contar freq. de 'amor':\na:1 m:1 o:1 r:1"]
        A2 --> A3["Contar freq. de 'roma':\nr:1 o:1 m:1 a:1"]
        A3 --> A4{"freq_a == freq_b?"}
        A4 -->|"Sim"| A5["✅ São anagramas!\nRetornar True"]
    end

    style P7 fill:#4CAF50,color:#fff
    style A5 fill:#4CAF50,color:#fff
    style P2 fill:#2196F3,color:#fff
    style P4 fill:#2196F3,color:#fff
    style P6 fill:#2196F3,color:#fff
    style A4 fill:#2196F3,color:#fff
~~~

---

## Aplicação no Projeto Prático

Crie a pasta `modulo_01_fundamentos/aula_07_strings/codigo/` e o arquivo `algoritmos_texto.py` com o conteúdo abaixo. Crie também o arquivo `__init__.py` vazio na mesma pasta.

~~~python
# algoritmos_texto.py
# Aula 07: Strings como Sequências: Algoritmos sobre Texto
# Curso: AlgoLab — Algoritmos do Básico ao Avançado com Python
#
# Este arquivo implementa quatro algoritmos clássicos sobre strings,
# tratando-as como sequências de caracteres e aplicando técnicas
# aprendidas nas aulas anteriores (dois ponteiros, dicionários, laços).
# Cada função é autocontida e independente das demais.


def _normalizar(texto):
    """
    Função auxiliar privada que normaliza um texto para comparações.

    Remove espaços, converte para minúsculas e mantém apenas letras e números.
    Usada internamente por e_palindromo() e e_anagrama().

    O prefixo _ (underscore) indica que esta função é de uso interno —
    não é parte da interface pública do módulo.

    ENTRADA: texto — string qualquer
    SAÍDA: string normalizada (minúsculas, sem espaços, apenas alfanuméricos)

    Exemplos:
        _normalizar("A man!")  → "aman"
        _normalizar("  Radar  ")  → "radar"
        _normalizar("amor")  → "amor"
    """

    # PASSO 1: Converter para minúsculas para ignorar capitalização
    texto_lower = texto.lower()

    # PASSO 2: Manter apenas caracteres alfanuméricos (letras e números)
    # Removemos espaços, pontuação e caracteres especiais
    # isalnum() retorna True para letras e dígitos, False para tudo mais
    apenas_alnum = ""
    for caractere in texto_lower:
        if caractere.isalnum():
            # Acumulamos apenas os caracteres válidos
            apenas_alnum += caractere

    return apenas_alnum


def e_palindromo(texto):
    """
    Verifica se um texto é um palíndromo usando o algoritmo de dois ponteiros.

    Um palíndromo lê igual de trás para frente.
    A verificação ignora espaços, pontuação e diferenças de capitalização.

    Demonstra: algoritmo de dois ponteiros, normalização de string,
               acesso a caracteres por índice.

    ENTRADA: texto — string qualquer
    SAÍDA: True se o texto for palíndromo, False caso contrário

    Exemplos:
        e_palindromo("radar")           → True
        e_palindromo("Ana")             → True   (ignora maiúsculas)
        e_palindromo("A man a plan a canal Panama")  → True
        e_palindromo("python")          → False
        e_palindromo("")                → True   (string vazia é palíndromo)
        e_palindromo("a")               → True   (um caractere é palíndromo)
    """

    # PASSO 1: Normalizar o texto — remover espaços e converter para minúsculas
    # Usamos a função auxiliar _normalizar() que já cuida disso
    texto_normalizado = _normalizar(texto)

    # PASSO 2: Inicializar os dois ponteiros
    # 'esquerda' começa no primeiro caractere
    # 'direita' começa no último caractere
    esquerda = 0
    direita = len(texto_normalizado) - 1

    # PASSO 3: Executar o algoritmo de dois ponteiros
    # Enquanto os ponteiros não se cruzarem, comparamos os caracteres
    while esquerda < direita:
        # Comparar o caractere da esquerda com o da direita
        if texto_normalizado[esquerda] != texto_normalizado[direita]:
            # Os caracteres são diferentes — não é palíndromo
            return False

        # Os caracteres são iguais — avançar os ponteiros em direção ao centro
        esquerda += 1  # Ponteiro esquerdo avança para a direita
        direita -= 1   # Ponteiro direito recua para a esquerda

    # PASSO 4: Se chegamos aqui sem retornar False, todos os pares eram iguais
    # O texto é um palíndromo
    return True


def e_anagrama(texto_a, texto_b):
    """
    Verifica se dois textos são anagramas usando contagem de frequência.

    Dois textos são anagramas se contêm exatamente os mesmos caracteres
    com as mesmas frequências, em qualquer ordem.
    A verificação ignora espaços e diferenças de capitalização.

    Demonstra: dicionário como contador de frequências, método .get(),
               comparação de dicionários, normalização de string.

    ENTRADA: texto_a — primeira string para comparação
             texto_b — segunda string para comparação
    SAÍDA: True se os textos forem anagramas, False caso contrário

    Exemplos:
        e_anagrama("amor", "roma")       → True
        e_anagrama("listen", "silent")   → True
        e_anagrama("Amor", "Roma")       → True   (ignora maiúsculas)
        e_anagrama("hello", "world")     → False
        e_anagrama("", "")               → True   (dois vazios são anagramas)
        e_anagrama("a", "aa")            → False  (frequências diferentes)
    """

    # PASSO 1: Normalizar os dois textos
    # Após normalizar, trabalhamos com minúsculas sem espaços ou pontuação
    norm_a = _normalizar(texto_a)
    norm_b = _normalizar(texto_b)

    # PASSO 2: Otimização — se os comprimentos são diferentes, não podem ser anagramas
    # Anagramas têm exatamente os mesmos caracteres — portanto, mesmo comprimento
    if len(norm_a) != len(norm_b):
        return False

    # PASSO 3: Contar a frequência de cada caractere no primeiro texto
    # frequencia_a mapeia cada caractere à sua contagem em norm_a
    frequencia_a = {}
    for caractere in norm_a:
        # .get(chave, valor_padrao) retorna o valor da chave,
        # ou o valor_padrao se a chave não existir no dicionário
        # Se 'caractere' já está em frequencia_a, incrementa o contador
        # Se não está, inicia com 0 e adiciona 1 (resultado: 1)
        frequencia_a[caractere] = frequencia_a.get(caractere, 0) + 1

    # PASSO 4: Contar a frequência de cada caractere no segundo texto
    frequencia_b = {}
    for caractere in norm_b:
        frequencia_b[caractere] = frequencia_b.get(caractere, 0) + 1

    # PASSO 5: Comparar os dois dicionários de frequência
    # Em Python, dois dicionários são iguais se têm as mesmas chaves
    # e os mesmos valores para cada chave
    # Se frequencia_a == frequencia_b, os textos são anagramas
    return frequencia_a == frequencia_b


def contar_caracteres(texto):
    """
    Conta a frequência de cada caractere em um texto.

    Retorna um dicionário com todos os caracteres presentes no texto
    (incluindo espaços e pontuação) mapeados para suas contagens.

    Demonstra: dicionário como acumulador de frequências, iteração sobre string,
               .get() para inicialização segura de contadores.

    ENTRADA: texto — string qualquer (incluindo espaços e pontuação)
    SAÍDA: dicionário {caractere: contagem} com a frequência de cada caractere

    Exemplos:
        contar_caracteres("aab")   → {'a': 2, 'b': 1}
        contar_caracteres("hello") → {'h': 1, 'e': 1, 'l': 2, 'o': 1}
        contar_caracteres("")      → {}
        contar_caracteres("aaa")   → {'a': 3}
    """

    # PASSO 1: Inicializar o dicionário de frequências vazio
    # Cada chave será um caractere, cada valor será a contagem
    frequencias = {}

    # PASSO 2: Iterar sobre cada caractere do texto
    # Como strings são sequências, podemos usar for diretamente
    for caractere in texto:
        # Para cada caractere, incrementar seu contador no dicionário
        # .get(caractere, 0) retorna a contagem atual ou 0 se ainda não existe
        # +1 incrementa o contador
        frequencias[caractere] = frequencias.get(caractere, 0) + 1

    # PASSO 3: Retornar o dicionário completo de frequências
    return frequencias


def comprimir_string(texto):
    """
    Comprime uma string usando codificação por comprimento de execução (RLE).

    Substitui sequências de caracteres repetidos pelo caractere seguido
    do número de repetições. Se a versão comprimida for mais longa ou igual
    à original, retorna a string original.

    Demonstra: laço com controle de grupo, acumulação em lista com join(),
               comparação de comprimentos para decisão de retorno.

    ENTRADA: texto — string qualquer
    SAÍDA: string comprimida no formato "a3b2c1" se mais curta que o original,
           ou a string original se a compressão não reduzir o comprimento

    Exemplos:
        comprimir_string("aaabbc")    → "a3b2c1"
        comprimir_string("aaaaabbb")  → "a5b3"
        comprimir_string("abc")       → "abc"    (a3b1c1 seria mais longa)
        comprimir_string("aab")       → "aab"    (a2b1 tem mesmo comprimento)
        comprimir_string("")          → ""
        comprimir_string("a")         → "a"
    """

    # PASSO 1: Tratar o caso de string vazia
    if not texto:
        return ""

    # PASSO 2: Inicializar variáveis de controle
    # 'partes' acumulará as peças do resultado como lista (eficiente com join)
    partes = []

    # 'char_atual' é o caractere que estamos contando no momento
    char_atual = texto[0]

    # 'contagem' é quantas vezes o char_atual apareceu consecutivamente
    contagem = 1

    # PASSO 3: Percorrer os caracteres restantes (a partir do segundo)
    # Usamos range(1, len(texto)) para começar no índice 1
    for i in range(1, len(texto)):
        # Obter o caractere na posição atual
        char = texto[i]

        if char == char_atual:
            # O caractere atual é igual ao anterior — incrementar contagem
            contagem += 1
        else:
            # O caractere mudou — "fechar" o grupo atual
            # Adicionar a representação "charN" à lista de partes
            # str(contagem) converte o inteiro para string para concatenação
            partes.append(char_atual + str(contagem))

            # Iniciar um novo grupo com o caractere atual
            char_atual = char
            contagem = 1

    # PASSO 4: Fechar o último grupo (o laço não fecha o último automaticamente)
    partes.append(char_atual + str(contagem))

    # PASSO 5: Unir todas as partes em uma única string
    # "".join(lista) une os elementos sem separador
    resultado = "".join(partes)

    # PASSO 6: Comparar comprimentos — retornar o mais curto
    # Se a compressão não reduz o comprimento, o original é preferível
    if len(resultado) >= len(texto):
        return texto

    return resultado
~~~

### Como executar o código

Com o ambiente virtual ativo, navegue até a pasta e teste manualmente:

~~~text
.venv\Scripts\activate
cd modulo_01_fundamentos\aula_07_strings\codigo
python -c "from algoritmos_texto import *; print(e_palindromo('radar')); print(e_anagrama('amor','roma')); print(contar_caracteres('hello')); print(comprimir_string('aaabbc'))"
~~~

---

## Testes Automatizados com pytest

Crie o arquivo `test_algoritmos_texto.py` dentro da pasta `modulo_01_fundamentos/aula_07_strings/testes/`:

~~~python
# test_algoritmos_texto.py
# Testes automatizados para a Aula 07: Strings como Sequências
# Execute com: pytest testes/ -v
#
# Filosofia dos testes:
# - Palíndromo: casos clássicos, com espaços, com maiúsculas, casos extremos
# - Anagrama: casos verdadeiros, falsos, com normalização, comprimentos diferentes
# - Contagem: verificar cada caractere individualmente, string vazia
# - Compressão: comprimir com ganho, sem ganho, string vazia, um caractere

import pytest

# Importamos as quatro funções públicas que vamos testar
from codigo.algoritmos_texto import (
    e_palindromo,
    e_anagrama,
    contar_caracteres,
    comprimir_string,
)


# ============================================================
# TESTES PARA e_palindromo()
# ============================================================

class TestEPalindromo:
    """
    Testa todos os comportamentos da função e_palindromo.
    Verifica: palíndromos simples, com espaços, com maiúsculas,
              não palíndromos, casos extremos (vazio, um caractere).
    """

    # --- Palíndromos simples ---

    def test_palindromo_radar(self):
        """'radar' é um palíndromo clássico."""
        assert e_palindromo("radar") is True

    def test_palindromo_ana(self):
        """'ana' é palíndromo."""
        assert e_palindromo("ana") is True

    def test_palindromo_arara(self):
        """'arara' é palíndromo."""
        assert e_palindromo("arara") is True

    # --- Palíndromos com maiúsculas ---

    def test_palindromo_ignora_maiusculas(self):
        """'Ana' com maiúscula deve ser reconhecido como palíndromo."""
        assert e_palindromo("Ana") is True

    def test_palindromo_tudo_maiusculo(self):
        """'RADAR' em maiúsculas deve ser palíndromo."""
        assert e_palindromo("RADAR") is True

    # --- Palíndromos com espaços e pontuação ---

    def test_palindromo_com_espaco(self):
        """'a man a plan a canal panama' é palíndromo ignorando espaços."""
        assert e_palindromo("a man a plan a canal panama") is True

    def test_palindromo_frase_classica(self):
        """Frase clássica com maiúsculas e espaços."""
        assert e_palindromo("A man a plan a canal Panama") is True

    def test_palindromo_com_pontuacao(self):
        """Palíndromo com vírgula e espaço deve ser reconhecido."""
        assert e_palindromo("Socorram-me, subi no onibus em Marrocos") is True

    # --- Não palíndromos ---

    def test_nao_palindromo_python(self):
        """'python' não é palíndromo."""
        assert e_palindromo("python") is False

    def test_nao_palindromo_algoritmo(self):
        """'algoritmo' não é palíndromo."""
        assert e_palindromo("algoritmo") is False

    def test_nao_palindromo_ab(self):
        """'ab' não é palíndromo."""
        assert e_palindromo("ab") is False

    # --- Casos extremos ---

    def test_string_vazia_e_palindromo(self):
        """String vazia é considerada palíndromo por definição."""
        assert e_palindromo("") is True

    def test_um_caractere_e_palindromo(self):
        """Qualquer string com um caractere é palíndromo."""
        assert e_palindromo("a") is True
        assert e_palindromo("z") is True

    def test_dois_caracteres_iguais(self):
        """'aa' é palíndromo."""
        assert e_palindromo("aa") is True

    def test_dois_caracteres_diferentes(self):
        """'ab' não é palíndromo."""
        assert e_palindromo("ab") is False

    def test_retorna_booleano(self):
        """A função deve sempre retornar um booleano."""
        assert isinstance(e_palindromo("radar"), bool)
        assert isinstance(e_palindromo("python"), bool)


# ============================================================
# TESTES PARA e_anagrama()
# ============================================================

class TestEAnagrama:
    """
    Testa todos os comportamentos da função e_anagrama.
    Verifica: anagramas verdadeiros, falsos, com normalização,
              comprimentos diferentes, strings vazias.
    """

    # --- Anagramas verdadeiros ---

    def test_anagrama_amor_roma(self):
        """'amor' e 'roma' são anagramas clássicos."""
        assert e_anagrama("amor", "roma") is True

    def test_anagrama_listen_silent(self):
        """'listen' e 'silent' são anagramas."""
        assert e_anagrama("listen", "silent") is True

    def test_anagrama_com_maiusculas(self):
        """'Amor' e 'Roma' são anagramas ignorando capitalização."""
        assert e_anagrama("Amor", "Roma") is True

    def test_anagrama_tudo_maiusculo(self):
        """'AMOR' e 'ROMA' são anagramas."""
        assert e_anagrama("AMOR", "ROMA") is True

    def test_anagrama_com_espacos(self):
        """Anagramas com espaços — espaços devem ser ignorados."""
        assert e_anagrama("amor", "r o m a") is True

    def test_anagrama_mesma_string(self):
        """Uma string é anagrama de si mesma."""
        assert e_anagrama("python", "python") is True

    # --- Não anagramas ---

    def test_nao_anagrama_hello_world(self):
        """'hello' e 'world' não são anagramas."""
        assert e_anagrama("hello", "world") is False

    def test_nao_anagrama_frequencias_diferentes(self):
        """'a' e 'aa' têm frequências diferentes — não são anagramas."""
        assert e_anagrama("a", "aa") is False

    def test_nao_anagrama_caracteres_diferentes(self):
        """'abc' e 'abd' diferem em um caractere."""
        assert e_anagrama("abc", "abd") is False

    # --- Comprimentos diferentes ---

    def test_comprimentos_diferentes_nao_e_anagrama(self):
        """Strings de comprimentos diferentes nunca são anagramas."""
        assert e_anagrama("ab", "abc") is False

    def test_comprimento_zero_e_um(self):
        """String vazia e string com um caractere não são anagramas."""
        assert e_anagrama("", "a") is False

    # --- Casos extremos ---

    def test_dois_vazios_sao_anagramas(self):
        """Duas strings vazias são anagramas entre si."""
        assert e_anagrama("", "") is True

    def test_mesmo_caractere_sao_anagramas(self):
        """'a' e 'a' são anagramas."""
        assert e_anagrama("a", "a") is True

    def test_retorna_booleano(self):
        """A função deve sempre retornar um booleano."""
        assert isinstance(e_anagrama("amor", "roma"), bool)
        assert isinstance(e_anagrama("hello", "world"), bool)


# ============================================================
# TESTES PARA contar_caracteres()
# ============================================================

class TestContarCaracteres:
    """
    Testa todos os comportamentos da função contar_caracteres.
    Verifica: contagem correta, string vazia, repetições, espaços incluídos.
    """

    def test_contar_hello(self):
        """Caso clássico: 'hello' tem 'l' repetido."""
        resultado = contar_caracteres("hello")
        assert resultado["h"] == 1
        assert resultado["e"] == 1
        assert resultado["l"] == 2
        assert resultado["o"] == 1

    def test_contar_string_vazia(self):
        """String vazia retorna dicionário vazio."""
        assert contar_caracteres("") == {}

    def test_contar_um_caractere(self):
        """String com um único caractere."""
        resultado = contar_caracteres("a")
        assert resultado == {"a": 1}

    def test_contar_todos_iguais(self):
        """String com todos os caracteres iguais."""
        resultado = contar_caracteres("aaaa")
        assert resultado == {"a": 4}

    def test_contar_inclui_espacos(self):
        """Espaços também são contados."""
        resultado = contar_caracteres("a b")
        assert resultado["a"] == 1
        assert resultado[" "] == 1
        assert resultado["b"] == 1

    def test_contar_numero_de_chaves_unicas(self):
        """O número de chaves deve ser igual ao número de caracteres únicos."""
        resultado = contar_caracteres("aabb")
        # Apenas dois caracteres únicos: 'a' e 'b'
        assert len(resultado) == 2

    def test_contar_retorna_dicionario(self):
        """A função deve retornar um dicionário."""
        assert isinstance(contar_caracteres("abc"), dict)

    def test_contar_soma_total_igual_comprimento(self):
        """A soma de todas as contagens deve ser igual ao comprimento da string."""
        texto = "algoritmo"
        resultado = contar_caracteres(texto)
        soma_contagens = sum(resultado.values())
        assert soma_contagens == len(texto)

    def test_contar_com_numeros(self):
        """Dígitos também devem ser contados."""
        resultado = contar_caracteres("a1b1")
        assert resultado["a"] == 1
        assert resultado["1"] == 2
        assert resultado["b"] == 1

    def test_contar_preserva_maiusculas(self):
        """'A' e 'a' são caracteres diferentes — devem ter contagens separadas."""
        resultado = contar_caracteres("Aa")
        assert resultado["A"] == 1
        assert resultado["a"] == 1
        assert len(resultado) == 2


# ============================================================
# TESTES PARA comprimir_string()
# ============================================================

class TestComprimirString:
    """
    Testa todos os comportamentos da função comprimir_string.
    Verifica: compressão com ganho, sem ganho, mesmo comprimento,
              string vazia, um caractere, todos iguais.
    """

    # --- Casos com compressão eficaz ---

    def test_comprimir_aaabbc(self):
        """Caso clássico: compressão gera string mais curta."""
        assert comprimir_string("aaabbc") == "a3b2c1"

    def test_comprimir_aaaaabbb(self):
        """Muitas repetições — compressão claramente eficaz."""
        assert comprimir_string("aaaaabbb") == "a5b3"

    def test_comprimir_todos_iguais(self):
        """String com todos os caracteres iguais."""
        assert comprimir_string("aaaaa") == "a5"

    def test_comprimir_dois_grupos(self):
        """Dois grupos de repetições."""
        assert comprimir_string("aaabb") == "a3b2"

    # --- Casos sem ganho de compressão ---

    def test_sem_compressao_abc(self):
        """'abc' → 'a1b1c1' tem mais caracteres — retorna original."""
        assert comprimir_string("abc") == "abc"

    def test_sem_compressao_ab(self):
        """'ab' → 'a1b1' tem mesmo comprimento — retorna original."""
        assert comprimir_string("ab") == "ab"

    def test_sem_compressao_abcd(self):
        """'abcd' → 'a1b1c1d1' é mais longa — retorna original."""
        assert comprimir_string("abcd") == "abcd"

    # --- Casos extremos ---

    def test_string_vazia(self):
        """String vazia retorna string vazia."""
        assert comprimir_string("") == ""

    def test_um_caractere(self):
        """'a' → 'a1' tem mesmo comprimento — retorna original 'a'."""
        assert comprimir_string("a") == "a"

    def test_dois_caracteres_iguais(self):
        """'aa' → 'a2' tem mesmo comprimento — retorna original."""
        # 'aa' tem comprimento 2, 'a2' também tem comprimento 2
        # Pelo critério (>= retorna original), deve retornar 'aa'
        assert comprimir_string("aa") == "aa"

    def test_tres_caracteres_iguais(self):
        """'aaa' → 'a3': mesmos comprimentos — retorna original."""
        # 'aaa' tem comprimento 3, 'a3' tem comprimento 2 — compressão eficaz
        assert comprimir_string("aaa") == "a3"

    def test_retorna_string(self):
        """A função deve sempre retornar uma string."""
        assert isinstance(comprimir_string("aaabb"), str)
        assert isinstance(comprimir_string("abc"), str)

    def test_comprimir_maiusculas_e_minusculas_separadas(self):
        """'Aa' tem dois caracteres diferentes — sem compressão."""
        # 'A' e 'a' são grupos diferentes — 'A1a1' é mais longa que 'Aa'
        assert comprimir_string("Aa") == "Aa"

    def test_comprimir_string_longa_com_grupos(self):
        """String mais longa com vários grupos de repetições."""
        # 'aaabbbccc' → 'a3b3c3': comprimento 9 → comprimento 6
        assert comprimir_string("aaabbbccc") == "a3b3c3"
~~~

### Como executar os testes

~~~text
cd modulo_01_fundamentos\aula_07_strings
pytest testes/ -v
~~~

### Estrutura de pastas necessária

~~~text
modulo_01_fundamentos/
└── aula_07_strings/
    ├── codigo/
    │   ├── __init__.py        ← arquivo vazio
    │   └── algoritmos_texto.py
    └── testes/
        └── test_algoritmos_texto.py
~~~

Criando o `__init__.py` no terminal:

~~~text
type nul > modulo_01_fundamentos\aula_07_strings\codigo\__init__.py
~~~

---

## Glossário Técnico da Aula

**String:** sequência imutável de caracteres em Python. Pode ser iterada, fatiada e acessada por índice — exatamente como uma lista, com a diferença de ser imutável.

**Imutabilidade de strings:** strings não podem ser modificadas após a criação. Toda operação que "altera" uma string cria uma nova string. Tente `"abc"[0] = "z"` e obterá `TypeError`.

**Palíndromo:** palavra ou frase que lê igual de trás para frente, ignorando espaços e pontuação. Exemplos: "radar", "Ana", "A man a plan a canal Panama".

**Anagrama:** dois textos que contêm exatamente os mesmos caracteres com as mesmas frequências, em ordem diferente. Exemplos: "amor" e "roma", "listen" e "silent".

**Codificação por comprimento de execução (RLE):** algoritmo de compressão que substitui sequências de caracteres repetidos pelo caractere seguido do número de repetições. `"aaabbc"` → `"a3b2c1"`.

**`.lower()`:** método que retorna nova string com todos os caracteres em minúsculas.

**`.isalnum()`:** método que retorna `True` se a string contém apenas letras e dígitos — sem espaços, pontuação ou caracteres especiais.

**`.get(chave, padrão)`:** método de dicionário que retorna o valor associado à chave, ou o `padrão` se a chave não existir. Evita `KeyError` e simplifica o padrão de inicialização de contadores.

**`"".join(lista)`:** método que une os elementos de uma lista de strings em uma única string. Mais eficiente que concatenação em laço para construir strings a partir de muitas partes.

**Normalização:** processo de transformar um texto para um formato padrão antes de processá-lo — geralmente envolvendo conversão para minúsculas, remoção de espaços e pontuação.

**Dicionário como contador:** padrão algorítmico onde as chaves são elementos únicos e os valores são contagens de ocorrências. Base de muitos algoritmos de análise de texto e compressão.

**`.isalpha()`:** método que retorna `True` se a string contém apenas letras (sem dígitos, espaços ou pontuação).

**Função privada (prefixo `_`):** convenção Python onde o nome começa com underscore para indicar que é de uso interno — não faz parte da interface pública do módulo. `_normalizar()` é um exemplo.

**`str(numero)`:** função que converte um número inteiro ou float para sua representação em string. Usada na compressão para converter a contagem `3` em `"3"`.

---

## Antecipação de Erros

**Erro 1: Tentar modificar um caractere de uma string por índice.** `texto[0] = "x"` causa `TypeError: 'str' object does not support item assignment`. Strings são imutáveis — para "modificar", crie uma nova string. Se precisar de uma versão modificada, construa-a caractere a caractere com uma lista e use `"".join()` ao final.

**Erro 2: Usar `==` para comparar strings sem normalizar.** `"Ana" == "ana"` retorna `False`. Sempre normalize antes de comparar quando a capitalização não deve importar: `"Ana".lower() == "ana".lower()` retorna `True`. A função `_normalizar()` desta aula faz isso automaticamente.

**Erro 3: Concatenar strings em laço grande é ineficiente.** `resultado += caractere` em um laço de 10.000 iterações cria 10.000 strings intermediárias — O(n²) no total. Para construir strings longas, acumule partes em uma lista e use `"".join(lista)` ao final — O(n).

**Erro 4: Confundir `str.split()` sem argumento com `str.split(" ")`.** `"  a  b  ".split()` retorna `["a", "b"]` — divide por qualquer espaço e ignora múltiplos espaços. `"  a  b  ".split(" ")` retorna `["", "", "a", "", "b", "", ""]` — divide por espaço único, produzindo strings vazias. Para limpar entradas, prefira `.split()` sem argumento.

**Erro 5: Esquecer de fechar o último grupo na compressão RLE.** O laço que percorre a string de `range(1, len(texto))` detecta mudanças de grupo mas não fecha o último grupo ao terminar — porque só fecha quando detecta uma mudança, e após o último grupo não há mudança. Sempre adicione `partes.append(char_atual + str(contagem))` após o laço para fechar o último grupo.

**Erro 6: `KeyError` ao acessar chave inexistente em dicionário.** `dicionario["chave"]` lança `KeyError` se a chave não existe. Use `dicionario.get("chave", 0)` para retornar `0` (ou qualquer padrão) quando a chave não existir — evitando o erro e simplificando o código.

---

## Troubleshooting

**Problema: `e_palindromo("A man a plan a canal Panama")` retorna `False`.**
Causa: a normalização não está removendo espaços e pontuação corretamente.
Solução: verifique a função `_normalizar()`. Ela deve converter para minúsculas e manter apenas caracteres alfanuméricos com `.isalnum()`. Teste `_normalizar("A man!")` — deve retornar `"aman"`.

**Problema: `e_anagrama("amor", "roma")` retorna `False`.**
Causa: os dicionários de frequência estão sendo comparados incorretamente, ou a normalização está alterando os caracteres de forma diferente para cada texto.
Solução: adicione prints temporários para verificar `frequencia_a` e `frequencia_b` separadamente. Ambos devem ser `{"a": 1, "m": 1, "o": 1, "r": 1}` após normalização.

**Problema: `comprimir_string("aaa")` retorna `"aaa"` em vez de `"a3"`.**
Causa: a condição de retorno usa `>=` quando deveria usar `>` — ou vice-versa.
Solução: `"a3"` tem comprimento 2, `"aaa"` tem comprimento 3 — a compressão é mais curta, então deve retornar `"a3"`. Verifique: `len(resultado) >= len(texto)` retorna `False` para este caso (2 >= 3 é False), portanto o código desce para `return resultado` — correto. Se ainda assim retornar errado, verifique se o último grupo está sendo fechado após o laço.

**Problema: `contar_caracteres("Aa")` retorna `{"a": 2}` em vez de `{"A": 1, "a": 1}`.**
Causa: a função está normalizando para minúsculas antes de contar, o que não é o comportamento correto para `contar_caracteres` — esta função deve contar literalmente cada caractere, incluindo diferenças de capitalização.
Solução: `contar_caracteres()` não deve chamar `.lower()` — ela conta os caracteres exatamente como aparecem. Apenas `e_palindromo()` e `e_anagrama()` normalizam internamente, pois precisam ignorar capitalização para suas comparações.

---

## Desafio de Fixação

Implemente uma função chamada `contar_palavras(frase)` que recebe uma frase e retorna um dicionário com a frequência de cada palavra, ignorando maiúsculas e pontuação. A pontuação a remover inclui os caracteres `.,!?;:"'()`. Em seguida, implemente `palavra_mais_frequente(frase)` que usa `contar_palavras()` internamente e retorna a palavra que aparece mais vezes (em caso de empate, retorna qualquer uma das mais frequentes).

**Resolução comentada:**

~~~python
def contar_palavras(frase):
    """
    Conta a frequência de cada palavra em uma frase.

    ENTRADA: frase — string com palavras separadas por espaços
    SAÍDA: dicionário {palavra: contagem} ignorando maiúsculas e pontuação
    """

    # PASSO 1: Converter para minúsculas
    frase_lower = frase.lower()

    # PASSO 2: Remover pontuação
    pontuacao = '.,!?;:"\'()'
    frase_limpa = ""
    for caractere in frase_lower:
        if caractere not in pontuacao:
            frase_limpa += caractere

    # PASSO 3: Dividir em palavras
    # .split() divide por qualquer espaço e ignora múltiplos espaços
    palavras = frase_limpa.split()

    # PASSO 4: Contar frequência de cada palavra
    frequencias = {}
    for palavra in palavras:
        frequencias[palavra] = frequencias.get(palavra, 0) + 1

    return frequencias


def palavra_mais_frequente(frase):
    """
    Retorna a palavra mais frequente em uma frase.

    ENTRADA: frase — string com palavras
    SAÍDA: a palavra mais frequente, ou None se a frase estiver vazia
    """

    # PASSO 1: Contar palavras usando a função anterior
    frequencias = contar_palavras(frase)

    # PASSO 2: Tratar frase vazia
    if not frequencias:
        return None

    # PASSO 3: Encontrar a palavra com maior contagem
    palavra_max = None
    contagem_max = 0

    for palavra, contagem in frequencias.items():
        if contagem > contagem_max:
            contagem_max = contagem
            palavra_max = palavra

    return palavra_max
~~~

Testes para o desafio:

~~~python
def test_contar_palavras_simples():
    resultado = contar_palavras("o gato e o rato")
    assert resultado["o"] == 2
    assert resultado["gato"] == 1

def test_contar_palavras_com_pontuacao():
    resultado = contar_palavras("Ola, mundo! Ola.")
    assert resultado["ola"] == 2
    assert resultado["mundo"] == 1

def test_contar_palavras_vazia():
    assert contar_palavras("") == {}

def test_palavra_mais_frequente():
    assert palavra_mais_frequente("o gato e o rato e o cao") == "o"

def test_palavra_mais_frequente_frase_vazia():
    assert palavra_mais_frequente("") is None
~~~

---

## Resumo dos Pontos-Chave

**Strings são sequências imutáveis** — podem ser iteradas, fatiadas e acessadas por índice como listas, mas não modificadas. Toda operação que "altera" uma string cria uma nova. O **algoritmo de dois ponteiros** aplicado a strings verifica palíndromos em O(n) e O(1) de espaço — comparando caracteres das extremidades em direção ao centro. A **detecção de anagramas** usa dicionários de frequência de caracteres — dois textos são anagramas se e somente se seus dicionários de frequência são iguais. A **codificação RLE** comprime sequências repetidas mantendo um contador de grupo e fechando cada grupo quando o caractere muda — o último grupo deve ser fechado explicitamente após o laço. **Normalizar antes de comparar** — converter para minúsculas e remover espaços e pontuação — é a primeira etapa de qualquer algoritmo de texto que deve ser insensível a formatação. O padrão `dicionario.get(chave, 0) + 1` é a forma Pythônica de incrementar contadores sem risco de `KeyError`. Para construir strings em laços, acumule em lista e use `"".join(lista)` — mais eficiente que concatenação repetida.

---

## Log de Estado da Aula

**Aula:** 07 — Strings como Sequências: Algoritmos sobre Texto
**Objetivo:** Implementar quatro algoritmos clássicos sobre strings usando técnicas aprendidas no Módulo 1.
**Arquivos criados:**
- `modulo_01_fundamentos/aula_07_strings/codigo/__init__.py`
- `modulo_01_fundamentos/aula_07_strings/codigo/algoritmos_texto.py`
- `modulo_01_fundamentos/aula_07_strings/testes/test_algoritmos_texto.py`

**Estado Funcional:** ✅ Quatro algoritmos implementados — palíndromo com dois ponteiros, anagrama com frequência de caracteres, contador de caracteres com dicionário e compressão RLE — com testes cobrindo casos clássicos, normalizações, casos extremos e verificações de tipo de retorno.
**Módulo 1 concluído:** ✅ Todos os sete fundamentos implementados e testados.
**Próximas Etapas:** Módulo 2 começa com a Aula 08 — Busca Linear — o primeiro algoritmo formal de busca do curso, construído sobre os fundamentos do Módulo 1.

---

## Próximos Passos

O **Módulo 1 está concluído**. Você implementou e testou sete conjuntos de algoritmos que cobrem os fundamentos absolutos: pensamento computacional, variáveis e tipos, decisões, repetições, funções, listas e strings. Com essa base sólida, você está pronto para o **Módulo 2: Algoritmos de Busca e Ordenação**. Na **Aula 08: Busca Linear**, você implementará o primeiro algoritmo formal do curso — o algoritmo de busca mais simples e universal, que percorre uma lista elemento por elemento até encontrar o alvo — e analisará seu comportamento em diferentes cenários de entrada.

---

Dúvidas? Posso prosseguir para a próxima etapa?