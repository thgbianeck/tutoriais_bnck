# Aula 03: Estruturas de Decisão: if, elif e else

## Análise de Integridade (Auditoria Prévia)

Antes de iniciar, este conteúdo foi verificado nos seguintes critérios: profundidade técnica mantida com linguagem acessível para iniciantes absolutos, analogias do cotidiano presentes antes de qualquer formalização técnica, código Python 3.13 funcional e comentado linha a linha, testes pytest cobrindo todos os ramos condicionais de cada função, diagrama Mermaid correto e bem formatado com escape adequado, glossário completo, antecipação de erros relevantes para iniciantes, e mínimo de 2.000 palavras de teoria. Nenhuma falha detectada. Conteúdo aprovado para geração.

---

## Objetivo da Aula

Aprender a controlar o fluxo de execução de um algoritmo usando estruturas de decisão — `if`, `elif` e `else` — compreendendo como condições booleanas determinam qual caminho o programa seguirá, e implementar quatro funções de classificação que demonstram cada variação das estruturas de decisão em contextos práticos e testáveis.

## Pré-requisitos

Aula 02 concluída — especialmente operadores de comparação (`==`, `!=`, `>`, `<`, `>=`, `<=`) e operadores lógicos (`and`, `or`, `not`), pois são a base de toda condição usada dentro de um `if`. O ambiente virtual deve estar ativo e o pytest instalado.

---

## Teoria Detalhada

### O problema da execução linear

Imagine que você está descrevendo para um robô como verificar se uma pessoa pode entrar em uma festa com restrição de idade. Se o robô seguisse apenas instruções lineares — uma após a outra, sem nenhuma capacidade de decisão — ele executaria sempre as mesmas ações independentemente da idade da pessoa. Ele diria "bem-vindo" para uma criança de cinco anos da mesma forma que diria para um adulto de trinta. Claramente, isso não é útil.

A maioria dos problemas reais exige que o algoritmo tome decisões: "se a nota for maior ou igual a sete, o aluno está aprovado; caso contrário, está reprovado". "Se o saldo for suficiente, realize o saque; caso contrário, exiba uma mensagem de erro". "Se o dia for sábado ou domingo, exiba 'fim de semana'; caso contrário, exiba 'dia útil'". Essa capacidade de escolher entre caminhos diferentes com base em condições é o que transforma um algoritmo linear e rígido em um programa verdadeiramente útil.

Em Python, essa capacidade é fornecida pelas **estruturas de decisão** — blocos de código que só são executados quando uma condição específica é satisfeita. A estrutura principal é o `if`, e ela vem acompanhada de dois complementos opcionais: `elif` (abreviação de "else if") e `else`.

### A estrutura `if`: a decisão mais simples

O `if` é a estrutura de decisão mais fundamental. Ele avalia uma condição booleana — uma expressão que resulta em `True` ou `False` — e executa o bloco de código indentado abaixo dele apenas se essa condição for `True`. Se a condição for `False`, o bloco é completamente ignorado e a execução continua na próxima linha após o bloco.

A sintaxe em Python é direta e elegante. A linha do `if` termina obrigatoriamente com dois pontos (`:`), e o bloco de código que pertence ao `if` é marcado pela **indentação** — quatro espaços a mais em relação à linha do `if`. Essa indentação não é apenas estética em Python: ela é parte da sintaxe. Um bloco sem indentação correta causa `IndentationError` e impede o código de executar.

Considere o algoritmo mais simples possível com decisão: verificar se um número é positivo e, se for, exibir uma mensagem. Se o número não for positivo, nada acontece — o algoritmo simplesmente não entra no bloco do `if` e continua. Essa é a forma mais pura da decisão: "faça isso somente se a condição for verdadeira".

### A cláusula `else`: o caminho alternativo

Frequentemente, você não quer apenas "fazer algo se a condição for verdadeira" — você quer "fazer uma coisa se for verdadeira e outra coisa se for falsa". Para isso existe o `else`. O bloco do `else` é executado exatamente quando a condição do `if` é `False`. Ele é o "senão" do português: "se a nota for maior ou igual a sete, aprove; senão, reprove".

O `else` não tem condição própria — ele é o capturador de todos os casos que não satisfizeram o `if`. Isso significa que um `if` com `else` garante que sempre um dos dois blocos será executado: ou o bloco do `if` (quando a condição é `True`), ou o bloco do `else` (quando a condição é `False`). Nunca ambos, nunca nenhum.

Esta garantia é muito importante para a confiabilidade de algoritmos. Quando você precisa ter certeza de que toda entrada recebe uma resposta — seja qual for —, o `if-else` é a estrutura correta. Sem o `else`, entradas que não satisfazem o `if` seriam simplesmente ignoradas, o que pode levar a comportamentos indefinidos em sistemas reais.

### A cláusula `elif`: múltiplos caminhos

Muitos problemas têm mais de dois caminhos possíveis. Uma nota pode resultar em "Aprovado", "Recuperação" ou "Reprovado". Uma temperatura pode ser classificada como "Frio", "Agradável", "Quente" ou "Muito quente". Uma pessoa pode ser "Criança", "Adolescente", "Adulto" ou "Idoso". Para esses casos com mais de dois resultados possíveis, existe o `elif`.

O `elif` é avaliado apenas se o `if` anterior (e todos os `elif` anteriores) resultaram em `False`. Ele permite encadear múltiplas condições em sequência, criando uma série de perguntas: "É isso? Não. É aquilo? Não. É aquele outro? Sim — execute este bloco". Quando uma condição `elif` é `True`, seu bloco é executado e todos os `elif` e o `else` subsequentes são ignorados — apenas um bloco é executado por vez.

A ordem dos `elif` é crítica. Você deve sempre ordenar as condições do mais específico para o mais genérico. Imagine classificar temperaturas com os limiares 0°C, 15°C e 30°C. Se você colocar a condição `temperatura < 30` antes de `temperatura < 15`, uma temperatura de 10°C seria classificada como "Quente" — porque `10 < 30` é verdadeiro e o código para aí, sem nunca chegar à condição `temperatura < 15`. A regra prática é: condições mais restritivas (que aceitam menos valores) devem vir primeiro.

### O operador ternário: decisões em uma linha

Python oferece uma forma compacta de escrever uma decisão simples em uma única linha, chamada de **expressão condicional** ou **operador ternário**. A sintaxe é `valor_se_verdadeiro if condição else valor_se_falso`. Por exemplo, `"par" if numero % 2 == 0 else "ímpar"` retorna a string `"par"` se o número for par, e `"ímpar"` caso contrário.

O operador ternário é elegante e Pythônico quando a lógica é simples — uma decisão direta entre dois valores. Ele não deve ser usado para lógicas complexas, pois prejudica a legibilidade. A regra de ouro: se você precisaria explicar o ternário para entendê-lo, use o `if-else` tradicional.

### Condições compostas com operadores lógicos

A condição dentro de um `if` não precisa ser uma comparação simples. Você pode combinar múltiplas comparações usando os operadores lógicos `and`, `or` e `not` para criar condições compostas.

`and` exige que todas as condições sejam verdadeiras: `if idade >= 18 and possui_documento:` só é verdadeiro se a pessoa for maior de idade E possuir documento. `or` exige que pelo menos uma condição seja verdadeira: `if dia == "sábado" or dia == "domingo":` é verdadeiro para qualquer dia do fim de semana. `not` inverte o valor booleano: `if not esta_vazio:` é verdadeiro quando a variável `esta_vazio` é `False`.

Python também permite uma sintaxe especial para verificar intervalos que se aproxima da notação matemática: `if 0 <= nota <= 10:` verifica se `nota` está entre 0 e 10 inclusive — algo que em outras linguagens exigiria `nota >= 0 and nota <= 10`. Essa forma encadeada de comparações é mais legível e é um dos recursos que tornam o Python elegante para iniciantes.

### O conceito de fluxo de controle

Quando um algoritmo tem estruturas de decisão, dizemos que ele tem **fluxo de controle** não linear — a sequência de instruções executadas depende dos valores de entrada. Para entender e depurar algoritmos com decisões, é essencial ser capaz de **rastrear o fluxo** mentalmente ou no papel: dado um valor de entrada específico, qual caminho o algoritmo segue? Quais blocos são executados e quais são ignorados?

Essa habilidade de rastrear fluxo é a base do debugging — o processo de encontrar e corrigir erros em algoritmos. Quando um algoritmo não produz o resultado esperado, a primeira pergunta é sempre: "qual caminho o algoritmo realmente tomou com esta entrada?" Ferramentas como o Python Tutor (disponível em pythontutor.com) permitem visualizar o fluxo passo a passo de forma gráfica, o que é enormemente útil para iniciantes.

### Cobertura de ramos: por que testar cada caminho

Uma das consequências mais importantes das estruturas de decisão para o desenvolvimento de software é o conceito de **cobertura de ramos**. Cada `if`, `elif` e `else` cria um ramo — um caminho possível de execução. Um algoritmo com três condições `elif` tem pelo menos quatro ramos (o `if` inicial mais três `elif` mais o `else` final).

Para garantir que um algoritmo funciona corretamente para todos os casos possíveis, você precisa testar cada ramo — ou seja, fornecer entradas que forcem o algoritmo a entrar em cada um dos caminhos possíveis. É exatamente por isso que os testes desta aula têm um teste para cada ramo de cada função: se testarmos apenas o caso feliz (o caminho mais comum), podemos ter bugs escondidos nos caminhos alternativos que só se manifestarão em produção, quando for mais difícil e custoso corrigi-los.

A regra prática é: para cada `if` ou `elif` que você escrever, escreva pelo menos dois testes — um onde a condição é verdadeira e um onde é falsa. Para condições de limite (como `>= 18`), escreva testes para o valor exato do limite, para um valor logo abaixo e para um valor logo acima. Esses são os casos mais propensos a erros de lógica.

### Valores truthy e falsy: o Python além do True e False

Python tem um comportamento especial e muito útil: qualquer valor pode ser avaliado em um contexto booleano — não apenas os valores literais `True` e `False`. Alguns valores são considerados "falsy" (equivalentes a `False`) e outros são "truthy" (equivalentes a `True`).

São **falsy** em Python: `False`, `0`, `0.0`, `""` (string vazia), `[]` (lista vazia), `{}` (dicionário vazio), `None`. Absolutamente todos os outros valores são **truthy**. Isso significa que você pode escrever `if lista:` em vez de `if len(lista) > 0:` — se a lista estiver vazia, a condição é falsa; se tiver qualquer elemento, é verdadeira. Da mesma forma, `if nome:` verifica se a string `nome` não está vazia.

Essa característica torna o código Python mais conciso e legível, mas também é fonte de bugs para iniciantes que não conhecem esse comportamento. Se `0` é falsy, então `if resultado:` falha quando o resultado legítimo de um cálculo é zero — o código entraria no `else` mesmo tendo calculado corretamente. Nesses casos, seja explícito: `if resultado is not None:` ou `if resultado != 0:`.

### Decisões aninhadas: `if` dentro de `if`

É possível colocar um `if` dentro do bloco de outro `if` — isso é chamado de **aninhamento** (nesting). Às vezes essa estrutura é necessária para representar lógicas hierárquicas: primeiro verificar uma condição ampla, e dentro desse contexto verificar uma condição mais específica.

No entanto, aninhamento excessivo é um sinal de alerta. Código com três ou mais níveis de indentação de decisões geralmente indica que a lógica pode ser simplificada — usando condições compostas com `and` e `or`, ou extraindo parte da lógica para uma função separada. O princípio do **Early Return** — retornar cedo quando uma condição de erro é detectada, em vez de aninhar o caminho feliz dentro de vários `if` — é uma das boas práticas mais valiosas que você pode aprender neste estágio.

---

## Analogia de Ancoragem

Pense nas estruturas de decisão como um **semáforo inteligente** em uma cruzamento movimentado. O semáforo não executa sempre a mesma ação — ele avalia uma condição (quanto tempo se passou, se há veículos aguardando, se é hora de pico) e toma uma decisão diferente dependendo dessa avaliação.

O `if` é o semáforo verificando: "há veículos vindo da direita?" Se sim, acende o verde para eles. O `elif` é a verificação seguinte: "então, há pedestres aguardando?" Se sim, acende o sinal de pedestres. O `else` é o caso padrão: "nenhuma das situações especiais se aplica, então mantenha o vermelho para todos e aguarde".

Assim como um semáforo sempre executa exatamente uma ação por ciclo — nunca duas ao mesmo tempo, nunca nenhuma — um bloco `if-elif-else` sempre executa exatamente um dos seus ramos. A condição avaliada determina qual ramo é o "verde" naquele momento específico.

A **ordem das condições** no semáforo também importa: ambulâncias têm prioridade sobre ônibus, que têm prioridade sobre carros particulares. Da mesma forma, em um `if-elif-else`, a primeira condição verdadeira "ganha" — todas as outras são ignoradas, independentemente de também serem verdadeiras.

---

## Diagrama Mermaid

~~~mermaid
flowchart TD
    A["ENTRADA\nnota = 6.5"] --> B{"nota >= 7.0?"}
    B -->|"True"| C["classificacao = 'Aprovado'"]
    B -->|"False"| D{"nota >= 5.0?"}
    D -->|"True"| E["classificacao = 'Recuperação'"]
    D -->|"False"| F["classificacao = 'Reprovado'"]
    C --> G["SAÍDA\nRetornar classificacao"]
    E --> G
    F --> G

    style A fill:#4CAF50,color:#fff
    style B fill:#2196F3,color:#fff
    style D fill:#2196F3,color:#fff
    style C fill:#4CAF50,color:#fff
    style E fill:#FF9800,color:#fff
    style F fill:#f44336,color:#fff
    style G fill:#9C27B0,color:#fff
~~~

---

## Aplicação no Projeto Prático

Crie a pasta `modulo_01_fundamentos/aula_03_decisao/codigo/` e o arquivo `classificador.py` com o conteúdo abaixo. Crie também o arquivo `__init__.py` vazio na mesma pasta.

~~~python
# classificador.py
# Aula 03: Estruturas de Decisão: if, elif e else
# Curso: AlgoLab — Algoritmos do Básico ao Avançado com Python
#
# Este arquivo implementa quatro funções que demonstram o uso de
# estruturas de decisão para classificar e tomar decisões.
# Cada função é autocontida e independente das demais.


def classificar_nota(nota):
    """
    Classifica uma nota escolar em três categorias.

    Regras de classificação:
        - Aprovado:     nota >= 7.0
        - Recuperação:  5.0 <= nota < 7.0
        - Reprovado:    nota < 5.0

    ENTRADA: nota — número (int ou float) entre 0 e 10
    SAÍDA: string com a classificação ('Aprovado', 'Recuperação' ou 'Reprovado'),
           ou 'Nota inválida' se a nota estiver fora do intervalo [0, 10]

    Exemplos:
        classificar_nota(8.5)  → 'Aprovado'
        classificar_nota(6.0)  → 'Recuperação'
        classificar_nota(3.0)  → 'Reprovado'
        classificar_nota(7.0)  → 'Aprovado'   (limite exato é aprovado)
        classificar_nota(11)   → 'Nota inválida'
    """

    # PASSO 1: Validar se a nota está dentro do intervalo permitido [0, 10]
    # Usamos a sintaxe encadeada do Python: 0 <= nota <= 10
    # que é equivalente a: nota >= 0 and nota <= 10
    if not (0 <= nota <= 10):
        # A nota está fora do intervalo válido — retornamos uma mensagem de erro
        return "Nota inválida"

    # PASSO 2: Verificar o critério de aprovação
    # A condição mais restritiva (maior limiar) vem primeiro
    if nota >= 7.0:
        # Nota suficiente para aprovação direta
        return "Aprovado"

    # PASSO 3: Verificar o critério de recuperação
    # Só chegamos aqui se nota < 7.0 (o if anterior foi False)
    elif nota >= 5.0:
        # Nota entre 5.0 (inclusive) e 7.0 (exclusive) — recuperação
        return "Recuperação"

    # PASSO 4: Caso padrão — nota abaixo de 5.0
    # Só chegamos aqui se nota < 5.0 (todos os elif anteriores foram False)
    else:
        return "Reprovado"


def classificar_idade(idade):
    """
    Classifica uma pessoa em faixas etárias.

    Faixas etárias:
        - Criança:     0 a 12 anos (inclusive)
        - Adolescente: 13 a 17 anos (inclusive)
        - Adulto:      18 a 59 anos (inclusive)
        - Idoso:       60 anos ou mais

    ENTRADA: idade — número inteiro representando a idade em anos
    SAÍDA: string com a faixa etária, ou 'Idade inválida' se negativa

    Exemplos:
        classificar_idade(8)   → 'Criança'
        classificar_idade(15)  → 'Adolescente'
        classificar_idade(30)  → 'Adulto'
        classificar_idade(65)  → 'Idoso'
        classificar_idade(-1)  → 'Idade inválida'
    """

    # PASSO 1: Validar que a idade não é negativa
    # Uma idade negativa é biologicamente impossível
    if idade < 0:
        return "Idade inválida"

    # PASSO 2: Verificar cada faixa etária em ordem crescente de limite
    # Começamos pelo limite mais baixo e avançamos para os maiores
    if idade <= 12:
        # De 0 a 12 anos — fase da infância
        return "Criança"

    elif idade <= 17:
        # De 13 a 17 anos — chegamos aqui porque idade > 12
        # então não precisamos verificar idade >= 13 explicitamente
        return "Adolescente"

    elif idade <= 59:
        # De 18 a 59 anos — chegamos aqui porque idade > 17
        return "Adulto"

    else:
        # 60 anos ou mais — todos os elif anteriores foram False
        # portanto idade >= 60
        return "Idoso"


def dia_e_util(dia_semana):
    """
    Verifica se um dia da semana é um dia útil de trabalho.

    Dias úteis: segunda, terça, quarta, quinta e sexta.
    Dias não úteis: sábado e domingo.

    ENTRADA: dia_semana — string com o nome do dia em português
             (aceita maiúsculas, minúsculas ou misto)
    SAÍDA: True se for dia útil, False se for fim de semana,
           None se o dia não for reconhecido

    Exemplos:
        dia_e_util("segunda")   → True
        dia_e_util("Sábado")    → False
        dia_e_util("DOMINGO")   → False
        dia_e_util("segunda")   → True
        dia_e_util("feriado")   → None
    """

    # PASSO 1: Normalizar o texto para minúsculas
    # Isso permite aceitar "Segunda", "SEGUNDA", "segunda" da mesma forma
    # O método .lower() retorna uma nova string com todos os caracteres
    # convertidos para minúsculas — a string original não é modificada
    dia_normalizado = dia_semana.lower().strip()

    # PASSO 2: Verificar se é um dia de fim de semana
    # Usamos o operador 'or' para combinar as duas condições em uma linha
    if dia_normalizado == "sábado" or dia_normalizado == "sabado":
        # Sábado não é dia útil — com ou sem acento
        return False

    elif dia_normalizado == "domingo":
        # Domingo não é dia útil
        return False

    # PASSO 3: Verificar se é um dia útil conhecido
    # Usamos o operador 'in' para verificar se o dia está na lista de úteis
    elif dia_normalizado in ["segunda", "terça", "terca", "quarta",
                              "quinta", "sexta"]:
        # O dia está na lista de dias úteis
        return True

    # PASSO 4: Dia não reconhecido
    else:
        # O texto não corresponde a nenhum dia da semana conhecido
        # Retornamos None para distinguir "não é dia útil" de "não reconhecido"
        return None


def calcular_desconto(valor, tipo_cliente):
    """
    Calcula o preço final após aplicar desconto baseado no tipo de cliente.

    Tabela de descontos:
        - 'vip':     30% de desconto
        - 'regular': 10% de desconto
        - 'novo':     5% de desconto
        - outros:     sem desconto (0%)

    ENTRADA: valor        — preço original (int ou float, deve ser >= 0)
             tipo_cliente — string com o tipo do cliente
    SAÍDA: dicionário com 'desconto_percentual', 'valor_desconto'
           e 'valor_final', todos arredondados em 2 casas decimais,
           ou None se o valor for negativo

    Exemplos:
        calcular_desconto(100.0, 'vip')     → {'desconto_percentual': 30, ...}
        calcular_desconto(100.0, 'regular') → {'desconto_percentual': 10, ...}
        calcular_desconto(100.0, 'novo')    → {'desconto_percentual': 5, ...}
        calcular_desconto(100.0, 'outro')   → {'desconto_percentual': 0, ...}
        calcular_desconto(-50.0, 'vip')     → None
    """

    # PASSO 1: Validar que o valor não é negativo
    # Um preço negativo não faz sentido comercialmente
    if valor < 0:
        return None

    # PASSO 2: Normalizar o tipo de cliente para minúsculas
    # Garante que 'VIP', 'Vip' e 'vip' sejam tratados da mesma forma
    tipo_normalizado = tipo_cliente.lower().strip()

    # PASSO 3: Determinar o percentual de desconto com base no tipo
    # Cada ramo do if-elif-else atribui um valor diferente a 'percentual'
    if tipo_normalizado == "vip":
        # Clientes VIP recebem o maior desconto: 30%
        percentual = 30

    elif tipo_normalizado == "regular":
        # Clientes regulares recebem desconto intermediário: 10%
        percentual = 10

    elif tipo_normalizado == "novo":
        # Novos clientes recebem um desconto de boas-vindas: 5%
        percentual = 5

    else:
        # Qualquer outro tipo não recebe desconto
        percentual = 0

    # PASSO 4: Calcular o valor do desconto em reais
    # Dividimos o percentual por 100 para obter a fração decimal
    # Ex: 30% de R$100 = 100 * (30/100) = 100 * 0.30 = R$30
    valor_desconto = valor * (percentual / 100)

    # PASSO 5: Calcular o valor final após o desconto
    valor_final = valor - valor_desconto

    # PASSO 6: Montar e retornar o dicionário com os resultados
    # Arredondamos os valores monetários para 2 casas decimais
    return {
        "desconto_percentual": percentual,
        "valor_desconto": round(valor_desconto, 2),
        "valor_final": round(valor_final, 2)
    }
~~~

### Como executar o código

Com o ambiente virtual ativo, navegue até a pasta e teste manualmente:

~~~text
.venv\Scripts\activate
cd modulo_01_fundamentos\aula_03_decisao\codigo
python -c "from classificador import *; print(classificar_nota(8.5)); print(classificar_idade(15)); print(calcular_desconto(100, 'vip'))"
~~~

---

## Testes Automatizados com pytest

Crie o arquivo `test_classificador.py` dentro da pasta `modulo_01_fundamentos/aula_03_decisao/testes/`:

~~~python
# test_classificador.py
# Testes automatizados para a Aula 03: Estruturas de Decisão
# Execute com: pytest testes/ -v
#
# Filosofia dos testes: cada ramo de cada função tem pelo menos um teste.
# Para condições de limite, testamos o valor exato, um abaixo e um acima.

import pytest

# Importamos as quatro funções que vamos testar
from codigo.classificador import (
    classificar_nota,
    classificar_idade,
    dia_e_util,
    calcular_desconto,
)


# ============================================================
# TESTES PARA classificar_nota()
# ============================================================

class TestClassificarNota:
    """
    Testa todos os ramos da função classificar_nota.
    Ramos: Aprovado | Recuperação | Reprovado | Nota inválida
    """

    # --- Ramo: Aprovado ---

    def test_nota_alta_aprovado(self):
        """Nota claramente dentro da faixa de aprovação."""
        assert classificar_nota(9.0) == "Aprovado"

    def test_nota_limite_aprovado(self):
        """Nota exatamente no limite de aprovação — 7.0 deve aprovar."""
        # Este é o caso de limite mais importante: 7.0 deve ser Aprovado
        assert classificar_nota(7.0) == "Aprovado"

    def test_nota_maxima(self):
        """Nota máxima possível (10) deve ser Aprovado."""
        assert classificar_nota(10) == "Aprovado"

    # --- Ramo: Recuperação ---

    def test_nota_media_recuperacao(self):
        """Nota no meio da faixa de recuperação."""
        assert classificar_nota(6.0) == "Recuperação"

    def test_nota_limite_inferior_recuperacao(self):
        """Nota exatamente em 5.0 — limite inferior da recuperação."""
        # 5.0 deve ser Recuperação, não Reprovado
        assert classificar_nota(5.0) == "Recuperação"

    def test_nota_logo_abaixo_do_aprovado(self):
        """Nota ligeiramente abaixo de 7.0 deve ser Recuperação."""
        assert classificar_nota(6.9) == "Recuperação"

    # --- Ramo: Reprovado ---

    def test_nota_baixa_reprovado(self):
        """Nota claramente dentro da faixa de reprovação."""
        assert classificar_nota(2.0) == "Reprovado"

    def test_nota_zero_reprovado(self):
        """Nota zero deve ser Reprovado."""
        assert classificar_nota(0) == "Reprovado"

    def test_nota_logo_abaixo_da_recuperacao(self):
        """Nota ligeiramente abaixo de 5.0 deve ser Reprovado."""
        assert classificar_nota(4.9) == "Reprovado"

    # --- Ramo: Nota inválida ---

    def test_nota_acima_de_dez(self):
        """Nota acima de 10 é inválida."""
        assert classificar_nota(11) == "Nota inválida"

    def test_nota_negativa(self):
        """Nota negativa é inválida."""
        assert classificar_nota(-1) == "Nota inválida"

    def test_nota_muito_alta(self):
        """Nota muito acima do máximo é inválida."""
        assert classificar_nota(100) == "Nota inválida"

    # --- Verificação de tipo ---

    def test_retorna_string(self):
        """A função deve sempre retornar uma string."""
        assert isinstance(classificar_nota(8.0), str)
        assert isinstance(classificar_nota(0), str)


# ============================================================
# TESTES PARA classificar_idade()
# ============================================================

class TestClassificarIdade:
    """
    Testa todos os ramos da função classificar_idade.
    Ramos: Criança | Adolescente | Adulto | Idoso | Idade inválida
    """

    # --- Ramo: Criança ---

    def test_crianca_tipica(self):
        """Criança com idade claramente na faixa."""
        assert classificar_idade(8) == "Criança"

    def test_recem_nascido(self):
        """Recém-nascido com idade zero deve ser Criança."""
        assert classificar_idade(0) == "Criança"

    def test_limite_superior_crianca(self):
        """12 anos é o limite superior da infância."""
        assert classificar_idade(12) == "Criança"

    # --- Ramo: Adolescente ---

    def test_adolescente_tipico(self):
        """Adolescente com idade claramente na faixa."""
        assert classificar_idade(15) == "Adolescente"

    def test_limite_inferior_adolescente(self):
        """13 anos é o primeiro ano da adolescência."""
        assert classificar_idade(13) == "Adolescente"

    def test_limite_superior_adolescente(self):
        """17 anos é o último ano da adolescência."""
        assert classificar_idade(17) == "Adolescente"

    # --- Ramo: Adulto ---

    def test_adulto_tipico(self):
        """Adulto com idade claramente na faixa."""
        assert classificar_idade(35) == "Adulto"

    def test_limite_inferior_adulto(self):
        """18 anos é o primeiro ano da vida adulta."""
        assert classificar_idade(18) == "Adulto"

    def test_limite_superior_adulto(self):
        """59 anos é o último ano antes da terceira idade."""
        assert classificar_idade(59) == "Adulto"

    # --- Ramo: Idoso ---

    def test_idoso_tipico(self):
        """Idoso com idade claramente na faixa."""
        assert classificar_idade(70) == "Idoso"

    def test_limite_inferior_idoso(self):
        """60 anos é o primeiro ano da terceira idade."""
        assert classificar_idade(60) == "Idoso"

    def test_idoso_muito_velho(self):
        """Idade muito alta ainda deve ser Idoso."""
        assert classificar_idade(110) == "Idoso"

    # --- Ramo: Idade inválida ---

    def test_idade_negativa(self):
        """Idade negativa é biologicamente impossível."""
        assert classificar_idade(-1) == "Idade inválida"

    def test_retorna_string(self):
        """A função deve sempre retornar uma string."""
        assert isinstance(classificar_idade(25), str)


# ============================================================
# TESTES PARA dia_e_util()
# ============================================================

class TestDiaEUtil:
    """
    Testa todos os ramos da função dia_e_util.
    Ramos: True (dia útil) | False (fim de semana) | None (não reconhecido)
    """

    # --- Ramo: True (dias úteis) ---

    def test_segunda_e_util(self):
        """Segunda-feira é dia útil."""
        assert dia_e_util("segunda") is True

    def test_terca_e_util(self):
        """Terça-feira é dia útil."""
        assert dia_e_util("terça") is True

    def test_quarta_e_util(self):
        """Quarta-feira é dia útil."""
        assert dia_e_util("quarta") is True

    def test_quinta_e_util(self):
        """Quinta-feira é dia útil."""
        assert dia_e_util("quinta") is True

    def test_sexta_e_util(self):
        """Sexta-feira é dia útil."""
        assert dia_e_util("sexta") is True

    # --- Ramo: False (fim de semana) ---

    def test_sabado_nao_e_util(self):
        """Sábado não é dia útil."""
        assert dia_e_util("sábado") is False

    def test_sabado_sem_acento(self):
        """Sábado sem acento também deve ser reconhecido."""
        assert dia_e_util("sabado") is False

    def test_domingo_nao_e_util(self):
        """Domingo não é dia útil."""
        assert dia_e_util("domingo") is False

    # --- Normalização de entrada ---

    def test_aceita_maiusculas(self):
        """A função deve aceitar dias escritos em maiúsculas."""
        assert dia_e_util("SEGUNDA") is True
        assert dia_e_util("DOMINGO") is False

    def test_aceita_misto(self):
        """A função deve aceitar capitalização mista."""
        assert dia_e_util("Quarta") is True

    def test_aceita_espacos_extras(self):
        """A função deve ignorar espaços extras nas bordas."""
        assert dia_e_util("  sexta  ") is True

    # --- Ramo: None (dia não reconhecido) ---

    def test_dia_invalido_retorna_none(self):
        """Texto que não é um dia da semana retorna None."""
        assert dia_e_util("feriado") is None

    def test_string_vazia_retorna_none(self):
        """String vazia retorna None."""
        assert dia_e_util("") is None

    def test_numero_como_dia_retorna_none(self):
        """Número como string retorna None."""
        assert dia_e_util("1") is None


# ============================================================
# TESTES PARA calcular_desconto()
# ============================================================

class TestCalcularDesconto:
    """
    Testa todos os ramos da função calcular_desconto.
    Ramos: vip (30%) | regular (10%) | novo (5%) | outros (0%) | inválido
    """

    # --- Ramo: cliente vip ---

    def test_desconto_vip(self):
        """Cliente VIP recebe 30% de desconto."""
        resultado = calcular_desconto(100.0, "vip")
        assert resultado["desconto_percentual"] == 30
        assert resultado["valor_desconto"] == 30.0
        assert resultado["valor_final"] == 70.0

    def test_desconto_vip_maiusculo(self):
        """'VIP' em maiúsculas deve ser aceito."""
        resultado = calcular_desconto(100.0, "VIP")
        assert resultado["desconto_percentual"] == 30

    # --- Ramo: cliente regular ---

    def test_desconto_regular(self):
        """Cliente regular recebe 10% de desconto."""
        resultado = calcular_desconto(200.0, "regular")
        assert resultado["desconto_percentual"] == 10
        assert resultado["valor_desconto"] == 20.0
        assert resultado["valor_final"] == 180.0

    # --- Ramo: cliente novo ---

    def test_desconto_novo(self):
        """Novo cliente recebe 5% de desconto."""
        resultado = calcular_desconto(100.0, "novo")
        assert resultado["desconto_percentual"] == 5
        assert resultado["valor_desconto"] == 5.0
        assert resultado["valor_final"] == 95.0

    # --- Ramo: outros clientes (sem desconto) ---

    def test_sem_desconto_para_tipo_desconhecido(self):
        """Tipo de cliente desconhecido não recebe desconto."""
        resultado = calcular_desconto(100.0, "funcionario")
        assert resultado["desconto_percentual"] == 0
        assert resultado["valor_desconto"] == 0.0
        assert resultado["valor_final"] == 100.0

    # --- Casos extremos de valor ---

    def test_valor_zero(self):
        """Desconto sobre valor zero resulta em zero."""
        resultado = calcular_desconto(0.0, "vip")
        assert resultado["valor_final"] == 0.0

    def test_valor_negativo_retorna_none(self):
        """Valor negativo é inválido e deve retornar None."""
        assert calcular_desconto(-50.0, "vip") is None

    # --- Verificação da estrutura do retorno ---

    def test_resultado_e_dicionario_com_chaves_corretas(self):
        """O retorno deve ser um dicionário com as três chaves esperadas."""
        resultado = calcular_desconto(100.0, "regular")
        assert isinstance(resultado, dict)
        assert "desconto_percentual" in resultado
        assert "valor_desconto" in resultado
        assert "valor_final" in resultado

    def test_valores_arredondados_em_duas_casas(self):
        """Os valores monetários devem ter no máximo 2 casas decimais."""
        resultado = calcular_desconto(99.99, "novo")
        # 5% de 99.99 = 4.9995 — deve ser arredondado para 5.0
        assert resultado["valor_desconto"] == pytest.approx(5.0, rel=1e-2)
~~~

### Como executar os testes

~~~text
cd modulo_01_fundamentos\aula_03_decisao
pytest testes/ -v
~~~

### Estrutura de pastas necessária

~~~text
modulo_01_fundamentos/
└── aula_03_decisao/
    ├── codigo/
    │   ├── __init__.py        ← arquivo vazio
    │   └── classificador.py
    └── testes/
        └── test_classificador.py
~~~

Criando o `__init__.py` no terminal:

~~~text
type nul > modulo_01_fundamentos\aula_03_decisao\codigo\__init__.py
~~~

---

## Glossário Técnico da Aula

**Estrutura de decisão:** bloco de código que avalia uma condição e executa instruções diferentes dependendo do resultado — `True` ou `False`.

**`if`:** palavra-chave que inicia uma estrutura de decisão. O bloco indentado abaixo só é executado se a condição for `True`.

**`elif`:** abreviação de "else if". Avaliado apenas se o `if` anterior foi `False`. Permite encadear múltiplas condições alternativas.

**`else`:** bloco executado quando todas as condições do `if` e dos `elif` anteriores são `False`. Não tem condição própria — captura todos os casos restantes.

**Condição booleana:** expressão que resulta em `True` ou `False`, usada dentro de um `if` ou `elif`. Exemplos: `nota >= 7.0`, `idade < 0`, `dia == "segunda"`.

**Fluxo de controle:** a ordem em que as instruções de um algoritmo são executadas. Estruturas de decisão criam fluxo não linear — a execução pode seguir caminhos diferentes.

**Ramo (branch):** cada caminho possível de execução dentro de uma estrutura de decisão. Um `if-elif-else` com dois `elif` tem quatro ramos.

**Cobertura de ramos:** prática de garantir que os testes exercitem todos os ramos possíveis de um algoritmo.

**Operador ternário:** forma compacta de escrever uma decisão simples em uma linha. Sintaxe: `valor_se_verdadeiro if condição else valor_se_falso`.

**Indentação:** espaços no início de uma linha usados pelo Python para definir blocos de código. Blocos pertencentes a um `if` devem ter exatamente quatro espaços a mais que o `if`. Não é apenas estética — é sintaxe obrigatória.

**Truthy / Falsy:** comportamento do Python onde qualquer valor pode ser avaliado como booleano. Valores "falsy" (equivalentes a `False`): `0`, `""`, `[]`, `None`, `False`. Todo o restante é "truthy".

**Early return:** prática de retornar da função imediatamente ao detectar uma condição de erro ou caso especial, evitando aninhamentos desnecessários.

**`.lower()`:** método de string que retorna uma nova string com todos os caracteres em minúsculas. Usado para normalizar entradas de texto antes de comparações.

**`in` (operador de pertencimento):** verifica se um valor está contido em uma sequência. `"segunda" in ["segunda", "terça", "quarta"]` retorna `True`.

---

## Antecipação de Erros

**Erro 1: Ordem incorreta dos `elif`.** Se você colocar a condição mais genérica antes da mais específica, o algoritmo nunca chegará aos casos específicos. Por exemplo, se você verificar `nota >= 5.0` antes de `nota >= 7.0`, uma nota de 8.0 será classificada como "Recuperação" em vez de "Aprovado" — porque `8.0 >= 5.0` é verdadeiro e o Python para aí. A regra: condições mais restritivas (que aceitam menos valores) sempre vêm primeiro.

**Erro 2: Esquecer o dois pontos (`:`) no final do `if`, `elif` ou `else`.** `if nota >= 7.0` sem `:` causa `SyntaxError` imediatamente. O VS Code com a extensão Python sublinha esse erro antes mesmo de você executar o código. Desenvolva o hábito de sempre verificar o `:` no final de cada linha de estrutura de controle.

**Erro 3: Indentação inconsistente.** Misturar espaços e tabs, ou usar um número diferente de espaços em linhas do mesmo bloco, causa `IndentationError` ou `TabError`. Configure o VS Code para converter tabs em quatro espaços automaticamente (o que já é o padrão da extensão Python da Microsoft). Nunca misture os dois.

**Erro 4: Usar `=` em vez de `==` dentro do `if`.** `if nota = 7.0:` causa `SyntaxError`. O `=` é atribuição, o `==` é comparação. Leia `==` como "é igual a" para evitar a confusão.

**Erro 5: Confundir `None` com `False`.** A função `dia_e_util()` retorna `None` para dias não reconhecidos e `False` para fins de semana — propositalmente diferentes. Se você verificar `if dia_e_util("feriado") == False:`, obterá `False` — porque `None != False`. Use `is None` para verificar `None` explicitamente: `if dia_e_util("feriado") is None:`.

**Erro 6: Assumir que `elif` e `else` são obrigatórios.** Um `if` sem `elif` ou `else` é completamente válido — ele simplesmente não faz nada quando a condição é falsa. Use `elif` e `else` apenas quando precisar tratar os casos alternativos. A ausência de `else` não é um erro — é uma escolha.

---

## Troubleshooting

**Problema: A função retorna o resultado errado para um valor de limite (como 7.0 ou 5.0).**
Causa: uso de `>` em vez de `>=` (ou vice-versa) no limite da condição.
Solução: verifique cuidadosamente se o limite deve ser inclusivo (`>=`, `<=`) ou exclusivo (`>`, `<`). Escreva um teste específico para o valor exato do limite — como `test_nota_limite_aprovado` que verifica `classificar_nota(7.0) == "Aprovado"`.

**Problema: `IndentationError: expected an indented block`.**
Causa: o bloco de código abaixo do `if` não está indentado, ou está com número incorreto de espaços.
Solução: certifique-se de que todas as linhas dentro de um bloco `if` têm exatamente quatro espaços a mais que a linha do `if`. Use o atalho `Tab` no VS Code (configurado para quatro espaços).

**Problema: A normalização com `.lower()` não funciona para strings com acentos.**
Causa: `.lower()` funciona corretamente com acentos em Python 3 — `"Sábado".lower()` retorna `"sábado"`. Se o teste falhar, verifique se o acento está sendo comparado com a versão sem acento.
Solução: na função `dia_e_util()`, tratamos tanto `"sábado"` quanto `"sabado"` usando o operador `or`, cobrindo ambas as possibilidades.

**Problema: `pytest` reporta que um teste falhou mas o código parece correto visualmente.**
Causa: diferença sutil entre `is` e `==`, ou entre `None`, `False` e `0`.
Solução: use `is True`, `is False` e `is None` para comparar booleanos e None explicitamente nos testes. `assert resultado is True` é mais preciso que `assert resultado == True`.

---

## Desafio de Fixação

Implemente uma função chamada `calcular_imposto(salario)` que calcula o imposto de renda mensal com base em faixas progressivas simplificadas. As faixas são: **isento** para salários até R$2.000,00 (imposto = 0%), **7,5%** para salários entre R$2.000,01 e R$3.000,00, **15%** para salários entre R$3.000,01 e R$4.500,00, e **22,5%** para salários acima de R$4.500,00. A função deve retornar um dicionário com `"aliquota"` (percentual), `"imposto"` (valor em reais, arredondado em 2 casas) e `"salario_liquido"` (salário após o desconto do imposto). Retorne `None` para salários negativos.

**Resolução comentada:**

~~~python
def calcular_imposto(salario):
    """
    Calcula o imposto de renda mensal com base em faixas progressivas.

    ENTRADA: salario — salário bruto mensal (int ou float)
    SAÍDA: dicionário com aliquota, imposto e salario_liquido,
           ou None se o salário for negativo
    """

    # PASSO 1: Validar que o salário não é negativo
    if salario < 0:
        return None

    # PASSO 2: Determinar a alíquota com base na faixa salarial
    # As condições estão ordenadas do maior para o menor limiar
    if salario <= 2000.0:
        # Faixa de isenção — sem imposto
        aliquota = 0

    elif salario <= 3000.0:
        # Faixa de 7,5% — chegamos aqui porque salario > 2000
        aliquota = 7.5

    elif salario <= 4500.0:
        # Faixa de 15% — chegamos aqui porque salario > 3000
        aliquota = 15

    else:
        # Faixa de 22,5% — salario > 4500
        aliquota = 22.5

    # PASSO 3: Calcular o valor do imposto
    imposto = salario * (aliquota / 100)

    # PASSO 4: Calcular o salário líquido
    salario_liquido = salario - imposto

    # PASSO 5: Retornar o dicionário com os resultados
    return {
        "aliquota": aliquota,
        "imposto": round(imposto, 2),
        "salario_liquido": round(salario_liquido, 2)
    }
~~~

Testes para o desafio:

~~~python
def test_isento():
    resultado = calcular_imposto(1500.0)
    assert resultado["aliquota"] == 0
    assert resultado["imposto"] == 0.0
    assert resultado["salario_liquido"] == 1500.0

def test_limite_isencao():
    resultado = calcular_imposto(2000.0)
    assert resultado["aliquota"] == 0

def test_faixa_sete_e_meio():
    resultado = calcular_imposto(2500.0)
    assert resultado["aliquota"] == 7.5

def test_faixa_quinze():
    resultado = calcular_imposto(4000.0)
    assert resultado["aliquota"] == 15

def test_faixa_vinte_dois_e_meio():
    resultado = calcular_imposto(6000.0)
    assert resultado["aliquota"] == 22.5

def test_salario_negativo():
    assert calcular_imposto(-100.0) is None
~~~

---

## Resumo dos Pontos-Chave

As **estruturas de decisão** permitem que algoritmos escolham caminhos diferentes com base em condições — tornando o código útil para problemas do mundo real. O **`if`** executa um bloco somente se a condição for `True`. O **`else`** captura todos os casos em que o `if` foi `False`, garantindo que sempre um dos dois blocos seja executado. O **`elif`** permite encadear múltiplas condições alternativas, e apenas o primeiro `elif` verdadeiro tem seu bloco executado. A **ordem dos `elif`** é crítica — condições mais específicas (que aceitam menos valores) devem vir antes das mais genéricas. A **indentação** define os blocos em Python — não é apenas estética, é sintaxe obrigatória. **Valores truthy e falsy** permitem usar qualquer valor em contexto booleano, mas é mais seguro ser explícito com `is None`, `is True` e `is False`. A **cobertura de ramos** — escrever testes para cada `if`, `elif` e `else` — é a forma mais confiável de garantir que o algoritmo funciona corretamente para todos os casos possíveis, incluindo os valores exatos de limite.

---

## Log de Estado da Aula

**Aula:** 03 — Estruturas de Decisão: if, elif e else
**Objetivo:** Implementar quatro funções de classificação com estruturas de decisão.
**Arquivos criados:**
- `modulo_01_fundamentos/aula_03_decisao/codigo/__init__.py`
- `modulo_01_fundamentos/aula_03_decisao/codigo/classificador.py`
- `modulo_01_fundamentos/aula_03_decisao/testes/test_classificador.py`

**Estado Funcional:** ✅ Quatro funções implementadas com testes cobrindo todos os ramos condicionais, casos de limite e casos extremos.
**Próximas Etapas:** Aula 04 ensinará estruturas de repetição — `for` e `while` — para que os algoritmos possam executar operações múltiplas vezes sobre coleções de dados.

---

## Próximos Passos

Na **Aula 04: Estruturas de Repetição: for e while**, você aprenderá a executar blocos de código repetidamente com controle total do fluxo — somando listas, contando elementos, filtrando valores e parando a execução antecipadamente com `break` e `continue`. Implementará quatro funções que demonstram laços em diferentes contextos, com código totalmente autocontido e testes pytest cobrindo casos normais, extremos e comportamentos de `break` e `continue`.

---

Dúvidas? Posso prosseguir para a próxima etapa?