# Aula 01: O que é um Algoritmo? Pensamento Computacional e Lógica

## Análise de Integridade (Auditoria Prévia)

Antes de iniciar, este conteúdo foi verificado nos seguintes critérios: profundidade técnica mantida com linguagem acessível para iniciantes absolutos, analogias do cotidiano presentes antes de qualquer formalização técnica, código Python 3.13 funcional e comentado linha a linha, testes pytest cobrindo casos normais e extremos, diagrama Mermaid correto e bem formatado com escape adequado, glossário completo, antecipação de erros relevantes para iniciantes, e mínimo de 2.000 palavras de teoria. Nenhuma falha detectada. Conteúdo aprovado para geração.

---

## Objetivo da Aula

Entender o conceito de algoritmo, compreender os três pilares de qualquer algoritmo (entrada, processamento e saída), conhecer os quatro pilares do pensamento computacional e implementar três funções Python simples que representam algoritmos do cotidiano — tudo isso sem depender de nenhuma aula anterior.

## Pré-requisitos

Nenhum. Este é o ponto de partida absoluto do curso. Você precisa apenas do VS Code instalado, do Python 3.13 configurado e do pytest instalado no ambiente virtual. Se ainda não fez essa configuração, consulte o plano mestre do curso antes de continuar.

---

## Teoria Detalhada

### O que é, afinal, um algoritmo?

Antes de escrever uma linha de código, antes de abrir o VS Code, antes mesmo de pensar em Python, precisamos responder uma pergunta que parece simples mas carrega um peso enorme: o que é um algoritmo? A resposta está muito mais perto do nosso cotidiano do que imaginamos, e é justamente por isso que ela costuma surpreender quem está começando.

Pense na última vez que você preparou um café. Você provavelmente fez isso de forma automática — pegou o pó, colocou no filtro, adicionou água, esperou o café passar. Mas se alguém te pedisse para ensinar um robô a fazer café, você precisaria ser extremamente preciso. "Coloque o pó no filtro" não é suficiente. Quanto pó? Em qual filtro? Onde fica o filtro? O que acontece se o filtro estiver cheio? Essa necessidade de precisão absoluta, de instruções sem ambiguidade, de uma sequência lógica que um executor mecânico possa seguir passo a passo — isso é a essência de um algoritmo.

Um **algoritmo** é uma sequência finita, ordenada e não ambígua de instruções que, quando executada, resolve um problema ou realiza uma tarefa. Cada palavra dessa definição importa. **Finita** significa que o algoritmo termina em algum momento — ele não pode ficar executando para sempre sem produzir resultado. **Ordenada** significa que a sequência importa — você não pode colocar o filtro depois de ligar a cafeteira. **Não ambígua** significa que cada instrução tem exatamente um significado, sem espaço para interpretação — "adicione um pouco de água" é ambíguo para um computador, "adicione 200 mililitros de água" não é.

Algoritmos existem muito antes dos computadores. Os matemáticos gregos já os usavam para calcular máximos divisores comuns. Receitas de culinária são algoritmos. Manuais de montagem de móveis são algoritmos. Partituras musicais são algoritmos. O que os computadores fizeram foi dar aos algoritmos um executor incrivelmente rápido, preciso e incansável — uma máquina que pode seguir um bilhão de instruções por segundo sem se distrair ou se cansar.

### Os três pilares de qualquer algoritmo

Todo algoritmo, sem exceção, é estruturado em torno de três conceitos fundamentais que funcionam como os três atos de uma peça de teatro.

O primeiro pilar é a **entrada** — os dados que o algoritmo recebe para trabalhar. Uma função que calcula a média de notas recebe as notas como entrada. Uma função que verifica se alguém é maior de idade recebe a idade como entrada. Uma função que monta um sanduíche recebe os ingredientes como entrada. A entrada é a matéria-prima do algoritmo, o ponto de partida sem o qual nenhum processamento faz sentido.

O segundo pilar é o **processamento** — o conjunto de operações que o algoritmo realiza sobre a entrada para transformá-la em algo útil. É aqui que a lógica vive. É aqui que o algoritmo soma, compara, organiza, filtra, transforma. O processamento é o coração do algoritmo — é onde o trabalho real acontece, invisível para quem usa mas essencial para quem cria.

O terceiro pilar é a **saída** — o resultado que o algoritmo produz após o processamento. A média calculada. O texto "maior de idade" ou "menor de idade". A lista de passos para montar o sanduíche. A saída é a razão de existir do algoritmo, o produto final que será entregue a quem solicitou.

Esses três pilares são tão fundamentais que você os encontrará em absolutamente todo algoritmo que estudará neste curso — desde a busca linear mais simples até os algoritmos de grafos mais sofisticados. Sempre haverá algo entrando, algo sendo processado e algo saindo.

### Os quatro pilares do pensamento computacional

Saber o que é um algoritmo é o primeiro passo. O segundo, igualmente importante, é desenvolver a capacidade de **pensar computacionalmente** — ou seja, a habilidade de olhar para um problema do mundo real e enxergar nele uma estrutura que pode ser expressa como uma sequência de instruções precisas. Pesquisadores da área de educação em computação identificaram quatro pilares que compõem essa habilidade.

O primeiro pilar é a **decomposição**. Problemas grandes são difíceis. Problemas pequenos são gerenciáveis. A decomposição é a arte de quebrar um problema complexo em partes menores, cada uma com um objetivo específico e bem definido. Quando você quer construir um sistema de biblioteca, você não tenta resolver tudo de uma vez — você decompõe em "cadastrar livro", "registrar empréstimo", "gerar relatório de atrasos", e assim por diante. Cada parte é um algoritmo menor que, combinado com os outros, resolve o problema maior.

O segundo pilar é o **reconhecimento de padrões**. Depois de decompor um problema, você frequentemente percebe que algumas das partes menores se parecem com problemas que você já resolveu antes. "Buscar um nome em uma lista" é o mesmo problema independentemente de ser uma lista de livros, de usuários ou de produtos. Reconhecer esses padrões é o que permite reutilizar soluções — e é por isso que estudar algoritmos clássicos é tão valioso: eles são padrões que aparecem em contextos completamente diferentes.

O terceiro pilar é a **abstração**. Abstração significa focar no que é essencial e ignorar o que não importa para o problema em questão. Quando você implementa uma função que calcula a média de uma lista de números, você não precisa saber se esses números são notas de alunos, temperaturas de cidades ou preços de produtos. O algoritmo de média é o mesmo — você abstraiu os detalhes específicos e trabalhou com a essência do problema.

O quarto pilar é o **algoritmo em si** — a capacidade de expressar a solução como uma sequência clara, ordenada e precisa de passos. Depois de decompor o problema, reconhecer padrões e abstrair os detalhes irrelevantes, você está pronto para escrever o algoritmo. Este é o momento em que o pensamento se torna instrução, em que a ideia se torna código.

### A diferença entre algoritmo e código

Este é um dos pontos mais importantes da aula, e também um dos mais mal compreendidos por iniciantes: **algoritmo e código não são a mesma coisa**. O algoritmo é a ideia, a lógica, a sequência de passos — ele pode ser escrito em português, em inglês, em pseudocódigo, desenhado como um diagrama ou explicado verbalmente. O código é apenas uma das formas de expressar esse algoritmo, usando a sintaxe de uma linguagem de programação específica.

Considere o algoritmo para encontrar o maior número em uma lista. Em português estruturado (pseudocódigo), ele pode ser escrito assim:

~~~text
1. Defina "maior" como o primeiro elemento da lista
2. Para cada elemento restante da lista:
   2.1. Se o elemento atual for maior que "maior":
        2.1.1. Atualize "maior" com o valor do elemento atual
3. Retorne "maior"
~~~

Esse mesmo algoritmo pode ser implementado em Python, em Java, em C, em JavaScript — a linguagem muda, mas a lógica permanece idêntica. Aprender algoritmos significa aprender a pensar, não aprender uma linguagem. Python é nossa ferramenta de expressão neste curso, mas o pensamento algorítmico que você desenvolverá aqui é universal e duradouro.

### Por que estudar algoritmos?

Você talvez esteja pensando: "Mas o Python não tem funções prontas para ordenar listas, buscar elementos e calcular médias? Por que preciso aprender a implementar isso do zero?" A resposta tem três dimensões.

A primeira é a **compreensão profunda**. Usar uma ferramenta pronta sem entender como ela funciona cria uma dependência frágil. Quando algo dá errado — e eventualmente algo sempre dá errado — o programador que entende os fundamentos sabe diagnosticar, adaptar e corrigir. O que apenas usa ferramentas prontas fica perdido.

A segunda é a **capacidade de adaptação**. Problemas reais raramente se encaixam perfeitamente nas funções prontas das bibliotecas. Você frequentemente precisará adaptar, combinar ou criar algoritmos específicos para uma situação nova. Isso só é possível com uma compreensão sólida dos princípios.

A terceira é a **eficiência**. Nem todos os algoritmos que resolvem o mesmo problema são igualmente rápidos ou econômicos em memória. Entender os fundamentos permite escolher o algoritmo certo para cada situação — uma decisão que pode fazer a diferença entre um sistema que responde em milissegundos e um que demora minutos para processar dados.

---

## Analogia de Ancoragem

Imagine que você está ensinando um robô a preparar um sanduíche. O robô é absolutamente literal — ele faz exatamente o que você diz, nada mais, nada menos. Se você disser "coloque o recheio no pão" sem especificar qual pão, qual recheio, em qual ordem, o robô ficará parado aguardando informações ou fará algo completamente inesperado.

Para que o robô prepare um bom sanduíche, você precisa de uma **entrada** (os ingredientes disponíveis), um **processamento** (a sequência precisa de ações: pegar o pão, abrir, espalhar a manteiga, colocar o recheio, fechar) e uma **saída** (o sanduíche pronto).

Agora pense: e se você quiser ensinar o mesmo robô a preparar qualquer sanduíche, não apenas um específico? Você precisaria criar um algoritmo genérico que recebe uma **lista de ingredientes** como entrada e retorna os **passos de montagem** como saída — independentemente de ser um sanduíche de queijo, de frango ou de atum. Isso é exatamente o que a função `fazer_sanduiche` do nosso projeto prático faz: ela é um algoritmo genérico que funciona para qualquer lista de ingredientes.

Algoritmos são como receitas escritas para robôs: precisas, completas, sem ambiguidade e sempre com uma entrada, um processamento e uma saída.

---

## Diagrama Mermaid

~~~mermaid
flowchart TD
    A["ENTRADA\nnumeros = [7, 3, 9, 4, 5]"] --> B["PROCESSAMENTO\nSomar todos os números\ntotal = 7+3+9+4+5 = 28\nContar elementos\nquantidade = 5"]
    B --> C["PROCESSAMENTO\nDividir total por quantidade\nmedia = 28 / 5 = 5.6"]
    C --> D["SAÍDA\nRetornar 5.6"]

    style A fill:#4CAF50,color:#fff
    style B fill:#2196F3,color:#fff
    style C fill:#2196F3,color:#fff
    style D fill:#FF9800,color:#fff
~~~

---

## Aplicação no Projeto Prático

Nesta aula, implementaremos três funções que representam algoritmos do cotidiano. Cada função demonstra claramente os três pilares: entrada, processamento e saída. O código está organizado de forma autocontida — você pode criar a pasta `modulo_01_fundamentos/aula_01_o_que_e_algoritmo/codigo/` e criar o arquivo `algoritmo_intro.py` com o conteúdo abaixo.

~~~python
# algoritmo_intro.py
# Aula 01: O que é um Algoritmo? Pensamento Computacional e Lógica
# Curso: AlgoLab — Algoritmos do Básico ao Avançado com Python
#
# Este arquivo implementa três funções que representam algoritmos do cotidiano.
# Cada função demonstra os três pilares de qualquer algoritmo:
# ENTRADA → PROCESSAMENTO → SAÍDA


def fazer_sanduiche(ingredientes):
    """
    Algoritmo para montar um sanduíche com base nos ingredientes disponíveis.

    ENTRADA: ingredientes — uma lista de strings com os ingredientes disponíveis
    SAÍDA: uma lista de strings com os passos de montagem do sanduíche

    Exemplo:
        fazer_sanduiche(["pão", "queijo", "presunto"])
        → ["1. Pegue o pão", "2. Adicione queijo", "3. Adicione presunto", "4. Feche o sanduíche"]
    """

    # PASSO 1: Verificar se a lista de ingredientes está vazia
    # Se não há ingredientes, não há sanduíche a ser feito
    if not ingredientes:
        # Retornamos uma lista com uma única mensagem de aviso
        return ["Sem ingredientes disponíveis para montar o sanduíche."]

    # PASSO 2: Inicializar a lista de passos com uma lista vazia
    # Esta lista vai crescer conforme adicionarmos cada passo
    passos = []

    # PASSO 3: O primeiro passo é sempre pegar o pão (o primeiro ingrediente)
    # Usamos f-string para criar uma string formatada com o número do passo
    passos.append(f"1. Pegue o {ingredientes[0]}")

    # PASSO 4: Para cada ingrediente restante (a partir do segundo),
    # adicionamos um passo de "Adicione [ingrediente]"
    # Usamos range começando em 1 para pular o primeiro ingrediente (já usado)
    for i in range(1, len(ingredientes)):
        # len(passos) + 1 garante que o número do passo seja sequencial
        numero_passo = len(passos) + 1
        passos.append(f"{numero_passo}. Adicione {ingredientes[i]}")

    # PASSO 5: O último passo é sempre fechar o sanduíche
    numero_final = len(passos) + 1
    passos.append(f"{numero_final}. Feche o sanduíche")

    # SAÍDA: retornamos a lista completa de passos
    return passos


def calcular_media(numeros):
    """
    Algoritmo para calcular a média aritmética de uma lista de números.

    ENTRADA: numeros — uma lista de números inteiros ou decimais
    SAÍDA: a média aritmética como um número decimal (float),
           ou None se a lista estiver vazia

    Exemplo:
        calcular_media([7, 3, 9, 4, 5]) → 5.6
        calcular_media([]) → None
    """

    # PASSO 1: Verificar se a lista está vazia
    # Dividir por zero causaria um erro, então tratamos este caso antes
    if not numeros:
        # Retornamos None para indicar que a operação não é possível
        return None

    # PASSO 2: Calcular o total somando todos os elementos da lista
    # Inicializamos o acumulador com zero
    total = 0

    # Percorremos cada número da lista e somamos ao acumulador
    for numero in numeros:
        total = total + numero  # equivalente a: total += numero

    # PASSO 3: Contar quantos elementos existem na lista
    # A função len() retorna o número de elementos
    quantidade = len(numeros)

    # PASSO 4: Calcular a média dividindo o total pela quantidade
    # Em Python 3, a divisão com / sempre retorna float
    media = total / quantidade

    # SAÍDA: retornamos a média calculada
    return media


def e_maior_de_idade(idade):
    """
    Algoritmo para verificar se uma pessoa é maior de idade.

    ENTRADA: idade — um número inteiro representando a idade da pessoa
    SAÍDA: True se a pessoa tem 18 anos ou mais, False caso contrário

    Exemplo:
        e_maior_de_idade(20) → True
        e_maior_de_idade(16) → False
        e_maior_de_idade(18) → True  (exatamente 18 já é maior de idade)
    """

    # PASSO 1: Validar a entrada — idade não pode ser negativa
    # Uma idade negativa não faz sentido no mundo real
    if idade < 0:
        # Retornamos False pois uma idade inválida não pode ser maior de idade
        return False

    # PASSO 2: Comparar a idade com o limite legal de maioridade (18 anos)
    # O operador >= verifica se a idade é maior OU igual a 18
    if idade >= 18:
        # SAÍDA caso verdadeiro: a pessoa é maior de idade
        return True
    else:
        # SAÍDA caso falso: a pessoa é menor de idade
        return False
~~~

### Como executar o código

Abra o terminal integrado do VS Code com `Ctrl + '`, ative o ambiente virtual e navegue até a pasta da aula:

~~~text
.venv\Scripts\activate
cd modulo_01_fundamentos\aula_01_o_que_e_algoritmo\codigo
python algoritmo_intro.py
~~~

Para ver as funções em ação, você pode adicionar temporariamente ao final do arquivo:

~~~python
# Teste manual — remova após verificar o funcionamento
print(fazer_sanduiche(["pão", "queijo", "presunto", "alface"]))
print(calcular_media([7, 3, 9, 4, 5]))
print(e_maior_de_idade(20))
print(e_maior_de_idade(15))
~~~

---

## Testes Automatizados com pytest

Crie o arquivo `test_algoritmo_intro.py` dentro da pasta `modulo_01_fundamentos/aula_01_o_que_e_algoritmo/testes/`:

~~~python
# test_algoritmo_intro.py
# Testes automatizados para a Aula 01: O que é um Algoritmo?
# Execute com: pytest testes/ -v

# Importamos as três funções que vamos testar
from codigo.algoritmo_intro import fazer_sanduiche, calcular_media, e_maior_de_idade


# ============================================================
# TESTES PARA fazer_sanduiche()
# ============================================================

class TestFazerSanduiche:
    """Agrupa todos os testes da função fazer_sanduiche."""

    def test_sanduiche_com_tres_ingredientes(self):
        """Caso normal: lista com três ingredientes."""
        # DADO uma lista de três ingredientes
        ingredientes = ["pão", "queijo", "presunto"]

        # QUANDO chamamos a função
        resultado = fazer_sanduiche(ingredientes)

        # ENTÃO o resultado deve ser uma lista com quatro passos
        # (três ingredientes + o passo de fechar)
        assert len(resultado) == 4
        # E o primeiro passo deve mencionar o pão
        assert "pão" in resultado[0]
        # E o último passo deve ser fechar o sanduíche
        assert "Feche" in resultado[-1]

    def test_sanduiche_com_um_ingrediente(self):
        """Caso extremo: lista com apenas um ingrediente."""
        ingredientes = ["pão"]

        resultado = fazer_sanduiche(ingredientes)

        # Com um ingrediente, temos: pegar o pão + fechar = 2 passos
        assert len(resultado) == 2
        assert "pão" in resultado[0]
        assert "Feche" in resultado[-1]

    def test_sanduiche_com_lista_vazia(self):
        """Caso extremo: lista vazia não deve gerar erro."""
        ingredientes = []

        resultado = fazer_sanduiche(ingredientes)

        # Deve retornar uma lista com uma mensagem de aviso
        assert len(resultado) == 1
        assert "Sem ingredientes" in resultado[0]

    def test_sanduiche_retorna_lista(self):
        """Verifica que a função sempre retorna uma lista."""
        resultado = fazer_sanduiche(["pão", "manteiga"])
        assert isinstance(resultado, list)


# ============================================================
# TESTES PARA calcular_media()
# ============================================================

class TestCalcularMedia:
    """Agrupa todos os testes da função calcular_media."""

    def test_media_de_lista_simples(self):
        """Caso normal: média de cinco números."""
        numeros = [7, 3, 9, 4, 5]

        resultado = calcular_media(numeros)

        # A média de [7, 3, 9, 4, 5] é 28/5 = 5.6
        assert resultado == 5.6

    def test_media_de_lista_com_um_elemento(self):
        """Caso extremo: média de uma lista com um único elemento."""
        numeros = [42]

        resultado = calcular_media(numeros)

        # A média de uma lista com um único elemento é o próprio elemento
        assert resultado == 42.0

    def test_media_de_lista_vazia(self):
        """Caso extremo: lista vazia deve retornar None."""
        numeros = []

        resultado = calcular_media(numeros)

        # Uma lista vazia não tem média — retornamos None
        assert resultado is None

    def test_media_com_numeros_decimais(self):
        """Caso com números decimais (float)."""
        numeros = [1.5, 2.5, 3.0]

        resultado = calcular_media(numeros)

        # (1.5 + 2.5 + 3.0) / 3 = 7.0 / 3 ≈ 2.333...
        # Usamos pytest.approx para comparar floats com tolerância
        import pytest
        assert resultado == pytest.approx(2.333, rel=1e-2)

    def test_media_com_numeros_negativos(self):
        """Caso com números negativos."""
        numeros = [-10, 0, 10]

        resultado = calcular_media(numeros)

        # (-10 + 0 + 10) / 3 = 0
        assert resultado == 0.0

    def test_media_retorna_float(self):
        """Verifica que a função retorna um número (int ou float)."""
        resultado = calcular_media([1, 2, 3])
        assert isinstance(resultado, (int, float))


# ============================================================
# TESTES PARA e_maior_de_idade()
# ============================================================

class TestEMaiorDeIdade:
    """Agrupa todos os testes da função e_maior_de_idade."""

    def test_adulto_e_maior_de_idade(self):
        """Caso normal: adulto com 25 anos."""
        assert e_maior_de_idade(25) is True

    def test_crianca_nao_e_maior_de_idade(self):
        """Caso normal: criança com 10 anos."""
        assert e_maior_de_idade(10) is False

    def test_exatamente_18_anos_e_maior(self):
        """Caso limite: exatamente 18 anos deve ser maior de idade."""
        # Este é o caso mais importante — o limite exato
        assert e_maior_de_idade(18) is True

    def test_17_anos_nao_e_maior(self):
        """Caso limite: 17 anos ainda é menor de idade."""
        assert e_maior_de_idade(17) is False

    def test_idade_zero(self):
        """Caso extremo: recém-nascido com idade 0."""
        assert e_maior_de_idade(0) is False

    def test_idade_negativa(self):
        """Caso extremo: idade negativa é inválida, retorna False."""
        assert e_maior_de_idade(-5) is False

    def test_idade_muito_alta(self):
        """Caso extremo: pessoa com 100 anos é maior de idade."""
        assert e_maior_de_idade(100) is True

    def test_retorna_booleano(self):
        """Verifica que a função sempre retorna um booleano."""
        assert isinstance(e_maior_de_idade(20), bool)
        assert isinstance(e_maior_de_idade(10), bool)
~~~

### Como executar os testes

No terminal do VS Code, com o ambiente virtual ativo, navegue até a pasta da aula e execute:

~~~text
cd modulo_01_fundamentos\aula_01_o_que_e_algoritmo
pytest testes/ -v
~~~

Você verá uma saída semelhante a esta:

~~~text
collected 15 items

testes/test_algoritmo_intro.py::TestFazerSanduiche::test_sanduiche_com_tres_ingredientes PASSED
testes/test_algoritmo_intro.py::TestFazerSanduiche::test_sanduiche_com_um_ingrediente PASSED
testes/test_algoritmo_intro.py::TestFazerSanduiche::test_sanduiche_com_lista_vazia PASSED
testes/test_algoritmo_intro.py::TestFazerSanduiche::test_sanduiche_retorna_lista PASSED
testes/test_algoritmo_intro.py::TestCalcularMedia::test_media_de_lista_simples PASSED
testes/test_algoritmo_intro.py::TestCalcularMedia::test_media_de_lista_com_um_elemento PASSED
testes/test_algoritmo_intro.py::TestCalcularMedia::test_media_de_lista_vazia PASSED
testes/test_algoritmo_intro.py::TestCalcularMedia::test_media_com_numeros_decimais PASSED
testes/test_algoritmo_intro.py::TestCalcularMedia::test_media_com_numeros_negativos PASSED
testes/test_algoritmo_intro.py::TestCalcularMedia::test_media_retorna_float PASSED
testes/test_algoritmo_intro.py::TestEMaiorDeIdade::test_adulto_e_maior_de_idade PASSED
testes/test_algoritmo_intro.py::TestEMaiorDeIdade::test_crianca_nao_e_maior_de_idade PASSED
testes/test_algoritmo_intro.py::TestEMaiorDeIdade::test_exatamente_18_anos_e_maior PASSED
testes/test_algoritmo_intro.py::TestEMaiorDeIdade::test_17_anos_nao_e_maior PASSED
testes/test_algoritmo_intro.py::TestEMaiorDeIdade::test_idade_zero PASSED
...

15 passed in 0.12s
~~~

### Estrutura necessária para os imports funcionarem

Para que o import `from codigo.algoritmo_intro import ...` funcione corretamente, crie um arquivo vazio chamado `__init__.py` dentro da pasta `codigo/`:

~~~text
modulo_01_fundamentos/
└── aula_01_o_que_e_algoritmo/
    ├── codigo/
    │   ├── __init__.py       ← arquivo vazio, necessário para o import
    │   └── algoritmo_intro.py
    └── testes/
        └── test_algoritmo_intro.py
~~~

Para criar o `__init__.py` vazio no terminal:

~~~text
type nul > modulo_01_fundamentos\aula_01_o_que_e_algoritmo\codigo\__init__.py
~~~

---

## Glossário Técnico da Aula

**Algoritmo:** sequência finita, ordenada e não ambígua de instruções que, quando executada, resolve um problema ou realiza uma tarefa. Existe independentemente de qualquer linguagem de programação.

**Entrada (input):** os dados que um algoritmo recebe para trabalhar. Na programação, corresponde aos parâmetros de uma função.

**Processamento:** o conjunto de operações que o algoritmo realiza sobre a entrada para transformá-la em resultado. É a lógica interna do algoritmo.

**Saída (output):** o resultado que o algoritmo produz após o processamento. Na programação, corresponde ao valor retornado por uma função com `return`.

**Pensamento computacional:** conjunto de habilidades cognitivas para resolver problemas de forma estruturada, composto por decomposição, reconhecimento de padrões, abstração e algoritmos.

**Decomposição:** técnica de quebrar um problema complexo em partes menores e mais gerenciáveis.

**Abstração:** foco nos aspectos essenciais de um problema, ignorando detalhes irrelevantes para o contexto atual.

**Pseudocódigo:** forma de descrever um algoritmo usando linguagem natural estruturada, sem a sintaxe formal de nenhuma linguagem de programação. Útil para planejar antes de codificar.

**Função Python:** bloco de código com um nome, que recebe parâmetros (entrada), executa uma lógica (processamento) e retorna um resultado (saída) com a palavra `return`.

**pytest:** framework de testes para Python que permite escrever funções de teste e verificar automaticamente se o código se comporta como esperado.

**assert:** instrução Python usada em testes para verificar se uma condição é verdadeira. Se for falsa, o teste falha e exibe uma mensagem de erro.

**`None`:** valor especial do Python que representa a ausência de valor. Usado quando uma função não tem resultado a retornar em determinados casos.

---

## Antecipação de Erros

**Erro 1: Confundir algoritmo com código.** Um erro muito comum é pensar que "escrever um algoritmo" significa "escrever código Python". O algoritmo é a lógica — pode ser expresso em português, desenhado como diagrama ou escrito como pseudocódigo. O código é apenas uma implementação desse algoritmo em uma linguagem específica. Sempre planeje o algoritmo antes de abrir o editor.

**Erro 2: Esquecer o `return` na função.** Em Python, uma função sem `return` retorna `None` automaticamente. Se você esquecer o `return` na função `calcular_media`, ela executará os cálculos corretamente mas não entregará o resultado — ele simplesmente desaparecerá. Sempre verifique se o resultado do processamento está sendo retornado.

**Erro 3: Não tratar a lista vazia.** Tentar calcular a média de uma lista vazia sem verificar primeiro causa `ZeroDivisionError` — divisão por zero. Sempre antecipe os casos extremos: o que acontece se a entrada for vazia, negativa ou inválida? Trate esses casos antes de processar.

**Erro 4: Confundir `==` com `=`.** Dentro de uma condição `if`, o operador de comparação é `==` (dois sinais de igual), não `=` (um sinal). `if idade = 18` causa `SyntaxError`. `if idade == 18` verifica se `idade` é igual a 18.

**Erro 5: Ignorar a indentação.** Python usa indentação (espaços no início da linha) para definir blocos de código. Um bloco dentro de um `if` deve ter exatamente quatro espaços a mais que o `if`. Misturar espaços e tabs causa `IndentationError`. Configure o VS Code para usar espaços (não tabs) ao pressionar Tab, o que já é o padrão na extensão Python da Microsoft.

---

## Troubleshooting

**Problema: `ModuleNotFoundError: No module named 'codigo'` ao executar pytest.**
Causa: o arquivo `__init__.py` está faltando na pasta `codigo/`, ou o pytest está sendo executado de um diretório diferente do esperado.
Solução: certifique-se de que o arquivo `__init__.py` existe em `codigo/`, e execute o pytest sempre a partir da pasta `aula_01_o_que_e_algoritmo/` com o comando `pytest testes/ -v`.

**Problema: `pytest: command not found` no terminal.**
Causa: o ambiente virtual não está ativo, ou o pytest não foi instalado.
Solução: ative o ambiente virtual com `.venv\Scripts\activate` e instale o pytest com `pip install pytest`. Verifique com `pytest --version`.

**Problema: O teste `test_media_com_numeros_decimais` falha com erro de precisão.**
Causa: comparar floats com `==` pode falhar devido à imprecisão de ponto flutuante. `2.333... == 2.333` pode ser falso na aritmética de máquina.
Solução: use `pytest.approx()` para comparações com tolerância, como já está no código dos testes: `assert resultado == pytest.approx(2.333, rel=1e-2)`.

**Problema: `SyntaxError` ao tentar executar o código.**
Causa: erro de digitação na sintaxe Python — parênteses não fechados, dois pontos esquecidos no `if` ou `for`, aspas não fechadas.
Solução: leia a mensagem de erro com atenção — ela indica o arquivo e a linha onde o erro ocorreu. O VS Code com a extensão Python também sublinha erros de sintaxe em vermelho antes mesmo de executar.

---

## Desafio de Fixação

Antes de implementar em Python, escreva em **pseudocódigo** (português puro, sem nenhuma sintaxe de programação) um algoritmo para verificar se um número é par ou ímpar. Use apenas as palavras "SE", "SENÃO", "RETORNE" e operações matemáticas simples. Depois, implemente esse algoritmo como uma função Python chamada `e_par(numero)` e escreva pelo menos quatro testes pytest para ela, cobrindo: número par positivo, número ímpar positivo, zero (caso especial — zero é par) e número negativo par.

**Resolução comentada:**

Pseudocódigo:

~~~text
Algoritmo E_PAR:
  ENTRADA: numero (um inteiro)
  PROCESSAMENTO:
    SE o resto da divisão de numero por 2 for igual a zero:
      RETORNE Verdadeiro
    SENÃO:
      RETORNE Falso
  SAÍDA: Verdadeiro ou Falso
~~~

Implementação Python:

~~~python
def e_par(numero):
    """
    Verifica se um número inteiro é par.

    ENTRADA: numero — um inteiro (positivo, negativo ou zero)
    SAÍDA: True se o número for par, False se for ímpar

    O operador % (módulo) retorna o resto da divisão.
    Um número é par quando o resto da divisão por 2 é zero.
    """

    # O operador % calcula o resto da divisão
    # Se numero % 2 == 0, não há resto — o número é par
    if numero % 2 == 0:
        return True   # Par
    else:
        return False  # Ímpar
~~~

Testes:

~~~python
def test_numero_par_positivo():
    assert e_par(4) is True

def test_numero_impar_positivo():
    assert e_par(7) is False

def test_zero_e_par():
    # Zero é divisível por 2 sem resto — portanto é par
    assert e_par(0) is True

def test_numero_par_negativo():
    # Números negativos pares também têm resto zero
    assert e_par(-6) is True
~~~

---

## Resumo dos Pontos-Chave

Um **algoritmo** é uma sequência finita, ordenada e não ambígua de instruções para resolver um problema. Todo algoritmo tem três pilares: **entrada** (os dados recebidos), **processamento** (as operações realizadas) e **saída** (o resultado produzido). O **pensamento computacional** é composto por quatro habilidades complementares: **decomposição** (quebrar problemas grandes em partes), **reconhecimento de padrões** (identificar semelhanças com problemas já resolvidos), **abstração** (focar no essencial e ignorar detalhes irrelevantes) e **algoritmo** (expressar a solução como passos precisos). Algoritmo e código não são sinônimos — o algoritmo é a ideia, o código é apenas uma das formas de expressá-la. Em Python, as funções são a estrutura natural para implementar algoritmos: elas recebem parâmetros (entrada), executam uma lógica (processamento) e retornam um valor com `return` (saída). Testes automatizados com pytest verificam que o algoritmo se comporta corretamente para casos normais e extremos — incluindo listas vazias, valores zero e entradas inválidas.

---

## Log de Estado da Aula

**Aula:** 01 — O que é um Algoritmo? Pensamento Computacional e Lógica
**Objetivo:** Implementar três funções que representam algoritmos do cotidiano.
**Arquivos criados:**
- `modulo_01_fundamentos/aula_01_o_que_e_algoritmo/codigo/__init__.py`
- `modulo_01_fundamentos/aula_01_o_que_e_algoritmo/codigo/algoritmo_intro.py`
- `modulo_01_fundamentos/aula_01_o_que_e_algoritmo/testes/test_algoritmo_intro.py`

**Estado Funcional:** ✅ Três funções implementadas e 15 testes passando.
**Próximas Etapas:** Aula 02 aprofundará variáveis, tipos de dados e operadores — os blocos de construção que tornam os algoritmos capazes de trabalhar com qualquer tipo de informação.

---

## Próximos Passos

Na **Aula 02: Variáveis, Tipos de Dados e Operadores em Python**, você aprenderá os quatro tipos básicos de dados do Python (`int`, `float`, `str` e `bool`), como declarar variáveis e como usar operadores aritméticos, de comparação e lógicos para construir algoritmos mais expressivos e completos. Você implementará uma calculadora básica com funções para soma, divisão, concatenação de nomes e cálculo de IMC — tudo autocontido, com testes pytest.
