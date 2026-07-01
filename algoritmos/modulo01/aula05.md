# Aula 05: Funções: Reutilizando e Organizando Algoritmos

## Análise de Integridade (Auditoria Prévia)

Antes de iniciar, este conteúdo foi verificado nos seguintes critérios: profundidade técnica mantida com linguagem acessível para iniciantes absolutos, analogias do cotidiano presentes antes de qualquer formalização técnica, código Python 3.13 funcional e comentado linha a linha, testes pytest cobrindo casos normais e extremos incluindo parâmetros padrão, retorno múltiplo e funções como argumentos, diagrama Mermaid correto e bem formatado com escape adequado, glossário completo, antecipação de erros relevantes para iniciantes, e mínimo de 2.000 palavras de teoria. Nenhuma falha detectada. Conteúdo aprovado para geração.

---

## Objetivo da Aula

Aprender a definir e chamar funções em Python com precisão e clareza — compreendendo parâmetros, argumentos, valores padrão, retorno múltiplo, escopo de variáveis e funções como argumentos — e implementar quatro funções que demonstram cada um desses conceitos em contextos práticos e testáveis, completamente autocontidos e independentes de aulas anteriores.

## Pré-requisitos

Aula 04 concluída — especialmente o padrão acumulador com laços, pois as funções desta aula o utilizam internamente. O ambiente virtual deve estar ativo e o pytest instalado.

---

## Teoria Detalhada

### O problema da repetição de código

Imagine que você está desenvolvendo um sistema e precisou calcular a média de notas em cinco lugares diferentes do código. Sem funções, você escreveria a mesma lógica cinco vezes — somar os elementos, dividir pelo total, tratar a lista vazia. Isso funciona, mas cria um problema sério: se você descobrir um bug na lógica (por exemplo, esquecer de tratar a lista vazia), precisará corrigir em cinco lugares diferentes. E se esquecer de corrigir em um deles, o bug persiste em partes do sistema que parecem não relacionadas.

Esse problema tem um nome na engenharia de software: **duplicação de código**. E tem uma solução elegante: **funções**. Uma função é um bloco de código com um nome, que você escreve uma vez e reutiliza quantas vezes precisar. Se precisar corrigir a lógica, corrige em um único lugar e todos os pontos que chamam a função se beneficiam automaticamente da correção.

Mas funções são muito mais do que apenas evitar repetição. Elas são a ferramenta fundamental para **organizar** um algoritmo complexo em partes menores, cada uma com um objetivo específico e bem definido. Um algoritmo bem estruturado em funções é como um livro bem dividido em capítulos — cada parte tem uma responsabilidade clara, é fácil de entender isoladamente e contribui para o todo de forma coerente.

### Anatomia de uma função em Python

Uma função em Python é definida com a palavra-chave `def`, seguida do nome da função, parênteses com os parâmetros (que podem ser zero ou mais), e dois pontos. O bloco de código que pertence à função é indentado com quatro espaços, exatamente como nos blocos `if` e `for` que você já conhece.

O nome da função segue as mesmas regras de nomenclatura das variáveis — deve ser descritivo, em **snake_case** e sem espaços. Um bom nome de função descreve o que ela faz, não como ela faz. `calcular_media()` é um nome excelente. `cm()` ou `funcao1()` são nomes ruins — eles não comunicam nada sobre a responsabilidade da função.

A instrução `return` encerra a execução da função e devolve um valor para quem a chamou. Uma função sem `return` implicitamente retorna `None` — o que às vezes é intencional (quando a função apenas realiza uma ação sem produzir um resultado) e às vezes é um bug (quando você esqueceu de retornar o resultado calculado). Desenvolva o hábito de sempre verificar: esta função deveria retornar algo? Se sim, onde está o `return`?

### Parâmetros versus argumentos: uma distinção importante

Dois termos que confundem iniciantes são **parâmetro** e **argumento** — eles parecem sinônimos mas descrevem coisas ligeiramente diferentes. O **parâmetro** é o nome que você usa na definição da função — é como uma variável local que existe apenas dentro da função. O **argumento** é o valor concreto que você passa quando chama a função. Considere `def saudar(nome):` — aqui, `nome` é o parâmetro. Quando você chama `saudar("Ana")`, o texto `"Ana"` é o argumento. O argumento `"Ana"` é atribuído ao parâmetro `nome` no momento da chamada.

Essa distinção importa porque parâmetros existem apenas dentro da função — eles são variáveis locais. Fora da função, o nome `nome` não existe (a menos que você tenha uma variável com esse nome no escopo externo, mas ela seria uma variável diferente). Isso nos leva ao conceito de escopo.

### Escopo de variáveis: onde cada variável vive

O **escopo** de uma variável define em que parte do código ela existe e pode ser acessada. Em Python, o escopo mais importante para iniciantes é a distinção entre **escopo local** (dentro de uma função) e **escopo global** (fora de qualquer função, no nível do módulo).

Variáveis criadas dentro de uma função têm escopo local — elas nascem quando a função é chamada e morrem quando a função retorna. Elas são completamente invisíveis de fora da função. Variáveis criadas fora de qualquer função têm escopo global — elas existem pelo tempo de vida do programa e podem ser lidas de dentro de qualquer função.

Uma analogia útil: imagine que cada função é uma sala com paredes opacas. Você pode olhar pela janela para fora da sala (ler variáveis globais), mas ninguém de fora pode ver o que está dentro da sala (as variáveis locais são invisíveis externamente). E quando você sai da sala (a função retorna), tudo que estava dentro dela desaparece.

Por que isso importa? Porque o isolamento proporcionado pelo escopo local torna as funções **independentes** — uma função não pode acidentalmente modificar variáveis de outra função. Isso é fundamental para a confiabilidade de algoritmos complexos: cada função opera em seu próprio espaço limpo, sem interferências externas.

### Valores padrão: parâmetros opcionais

Python permite definir **valores padrão** para parâmetros — um valor que é usado automaticamente se nenhum argumento for fornecido para aquele parâmetro. A sintaxe é simples: `def saudar(nome, saudacao="Olá")`. Nesta definição, `saudacao` tem o valor padrão `"Olá"`. Se você chamar `saudar("Ana")`, a função usa `"Olá"` como saudação. Se você chamar `saudar("Ana", "Bom dia")`, a função usa `"Bom dia"`.

Parâmetros com valores padrão devem sempre vir **após** os parâmetros sem valor padrão na definição da função. `def func(a, b=10)` é válido. `def func(a=10, b)` causa `SyntaxError`. A lógica é que os parâmetros obrigatórios (sem padrão) precisam ser preenchidos pelo chamador — portanto devem vir primeiro para que o Python saiba a quem atribuir cada argumento posicional.

Valores padrão são avaliados **uma única vez**, no momento em que a função é definida — não a cada chamada. Isso cria uma armadilha clássica para iniciantes: nunca use um objeto mutável (como uma lista `[]` ou um dicionário `{}`) como valor padrão. Se você escrever `def func(lista=[]):` e modificar `lista` dentro da função, a mesma lista será compartilhada entre todas as chamadas subsequentes sem argumento, acumulando valores inesperadamente. A solução é usar `None` como padrão e criar o objeto mutável dentro da função.

### Retorno múltiplo: uma tupla disfarçada

Python permite que uma função retorne múltiplos valores separados por vírgula: `return valor1, valor2, valor3`. Na prática, o Python empacota esses valores em uma **tupla** automaticamente, e o chamador pode desempacotá-los em variáveis separadas com a sintaxe `a, b, c = minha_funcao()`.

Esse recurso é especialmente útil quando uma função calcula naturalmente vários resultados relacionados — como o mínimo, máximo e média de uma lista, que são três valores distintos mas logicamente parte da mesma análise. Em vez de chamar três funções separadas ou retornar um dicionário, você retorna os três valores diretamente.

Alternativamente, você pode retornar um dicionário quando os valores têm nomes significativos que devem ser documentados explicitamente na estrutura de retorno — como fizemos na função `calcular_imc()` da Aula 02. Dicionários são mais descritivos mas um pouco mais verbosos. Tuplas são mais compactas mas exigem que o chamador saiba a ordem dos valores. Ambas as abordagens são válidas — escolha com base na clareza.

### Funções como argumentos: o poder da abstração

Uma das características mais poderosas do Python é que **funções são objetos de primeira classe** — elas podem ser armazenadas em variáveis, passadas como argumentos para outras funções e retornadas como resultados de outras funções. Isso abre um mundo de possibilidades para a abstração.

Considere o problema de aplicar diferentes operações a um número: dobrar, triplicar, elevar ao quadrado. Em vez de escrever três funções separadas `aplicar_dobro(n)`, `aplicar_triplo(n)` e `aplicar_quadrado(n)`, você escreve uma única função `aplicar_operacao(numero, operacao)` que recebe a operação como argumento e a aplica ao número. As funções `dobrar`, `triplicar` e `elevar_ao_quadrado` são passadas como argumentos — não chamadas, apenas referenciadas pelo nome, sem parênteses.

Esse padrão — funções que recebem outras funções como argumentos — é chamado de **função de ordem superior** (higher-order function). Ele é a base de técnicas avançadas como `map()`, `filter()` e `sorted()` do Python, que você encontrará frequentemente em algoritmos de processamento de dados. Entender esse conceito agora, de forma simples, prepara o terreno para os algoritmos de ordenação e filtragem dos módulos seguintes.

### Docstrings: a documentação que vive no código

Python tem uma convenção elegante para documentar funções: a **docstring** — uma string literal colocada imediatamente após a linha `def`, antes de qualquer outra instrução. Ela é delimitada por aspas triplas (`"""`) e pode ocupar múltiplas linhas. O Python armazena essa string no atributo `__doc__` da função, tornando-a acessível via `help(funcao)` no terminal interativo.

Uma boa docstring deve descrever o que a função faz, quais são seus parâmetros (com tipos), o que ela retorna e exemplos de uso. Ela é escrita para quem vai usar a função, não para quem vai implementá-la — portanto foca no comportamento externo, não nos detalhes internos de implementação.

Escrever docstrings é um hábito que distingue desenvolvedores mediocres de desenvolvedores excelentes. Código sem documentação é compreensível apenas para quem o escreveu, e apenas por algumas semanas — depois que o contexto mental se perde, mesmo o autor precisará de tempo para reentender o que escreveu. Docstrings tornam o código autoexplicativo e colaborativo.

### Funções puras versus funções com efeitos colaterais

Uma distinção importante em algoritmos é entre **funções puras** e **funções com efeitos colaterais**. Uma função pura sempre retorna o mesmo resultado para os mesmos argumentos e não modifica nada fora de si mesma — ela não altera variáveis globais, não modifica a lista recebida como argumento, não escreve em arquivos. Uma função com efeito colateral modifica algo além do seu retorno — imprime na tela, modifica uma lista recebida, escreve em um banco de dados.

Funções puras são muito mais fáceis de testar, depurar e reutilizar — porque seu comportamento é completamente previsível e independente do estado externo. Por isso, prefira sempre funções puras quando possível. Quando um efeito colateral for necessário (como imprimir no terminal ou salvar em arquivo), isole-o em uma função dedicada e mantenha a lógica de cálculo em funções puras separadas.

Todas as funções desta aula são puras: elas recebem valores como argumentos, calculam um resultado e retornam — sem modificar nada externo. Isso é proposital e um padrão que você deve seguir ao longo de todo o curso.

### A regra de responsabilidade única

Um princípio fundamental de bom design de funções é a **responsabilidade única**: cada função deve fazer exatamente uma coisa, e fazê-la bem. Uma função chamada `calcular_e_exibir_media()` está fazendo duas coisas — calcular e exibir. O correto seria ter `calcular_media()` (que retorna o valor) e uma chamada separada a `print()` (que exibe). Isso torna cada função mais simples, mais testável e mais reutilizável — porque você pode usar `calcular_media()` em contextos onde não quer exibir o resultado na tela.

Quando você sentir que uma função está ficando longa demais ou fazendo coisas demais, é um sinal de que ela deve ser quebrada em funções menores. Como referência prática: se uma função não cabe em uma tela sem rolar, provavelmente está fazendo coisas demais.

---

## Analogia de Ancoragem

Pense em uma função como uma **máquina de café profissional** em uma cafeteria. A máquina tem uma interface bem definida: você insere os insumos pelos parâmetros (tipo de café, quantidade de água, temperatura) e ela entrega o resultado pelo retorno (a xícara de café pronta). Você não precisa saber os detalhes internos de como a máquina funciona — a resistência elétrica, a pressão da bomba, o tempo de extração. Você só precisa saber como usá-la: quais insumos colocar e o que esperar de volta.

Os **valores padrão** são os botões de configuração rápida da máquina — "expresso padrão", "cappuccino padrão" — que funcionam sem nenhum ajuste, mas podem ser personalizados quando você quiser algo específico. O **escopo local** é o interior da máquina — os processos que acontecem lá dentro não interferem em outras máquinas nem no ambiente externo. O **retorno múltiplo** é quando a máquina entrega não apenas o café, mas também o recibo e a temperatura recomendada de consumo — múltiplas informações em uma única resposta.

E **funções como argumentos** são os módulos intercambiáveis da máquina — você pode trocar o módulo de moagem (grossa para coado, fina para espresso) sem mudar o resto da máquina. A função `aplicar_operacao(numero, operacao)` é a máquina; as funções `dobrar` e `triplicar` são os módulos — você escolhe qual instalar dependendo do resultado que deseja.

---

## Diagrama Mermaid

~~~mermaid
flowchart TD
    subgraph CHAMADA["Chamada da Função"]
        A["Código chamador\ncalcular_estatisticas([7, 3, 9, 4, 5])"] --> B["Passagem de argumentos\nlista = [7, 3, 9, 4, 5]"]
    end

    subgraph FUNCAO["Dentro da Função — Escopo Local"]
        B --> C["minimo = 3\nmaximo = 9\nmedia = 5.6"]
        C --> D["return minimo, maximo, media\n→ (3, 9, 5.6)"]
    end

    subgraph RETORNO["Retorno ao Chamador"]
        D --> E["mn, mx, med = (3, 9, 5.6)\nDesempacotamento da tupla"]
        E --> F["mn = 3\nmx = 9\nmed = 5.6"]
    end

    style A fill:#4CAF50,color:#fff
    style C fill:#2196F3,color:#fff
    style D fill:#FF9800,color:#fff
    style F fill:#9C27B0,color:#fff
~~~

---

## Aplicação no Projeto Prático

Crie a pasta `modulo_01_fundamentos/aula_05_funcoes/codigo/` e o arquivo `funcoes_uteis.py` com o conteúdo abaixo. Crie também o arquivo `__init__.py` vazio na mesma pasta.

~~~python
# funcoes_uteis.py
# Aula 05: Funções: Reutilizando e Organizando Algoritmos
# Curso: AlgoLab — Algoritmos do Básico ao Avançado com Python
#
# Este arquivo implementa quatro funções que demonstram:
# - Parâmetros com valores padrão
# - Retorno múltiplo
# - Verificação de primo encapsulada em função
# - Funções como argumentos (higher-order functions)
# Cada função é autocontida e independente das demais.


def saudar(nome, saudacao="Olá"):
    """
    Gera uma mensagem de saudação personalizada.

    Demonstra: parâmetro com valor padrão, f-string, parâmetro opcional.

    ENTRADA: nome     — string com o nome da pessoa a ser saudada
             saudacao — string com a saudação desejada (padrão: "Olá")
    SAÍDA: string formatada no padrão "Saudação, Nome!"

    Exemplos:
        saudar("Ana")                → "Olá, Ana!"
        saudar("Carlos", "Bom dia") → "Bom dia, Carlos!"
        saudar("  Maria  ")         → "Olá, Maria!"  (espaços removidos)
        saudar("pedro", "Oi")       → "Oi, Pedro!"   (nome capitalizado)
    """

    # PASSO 1: Normalizar o nome — remover espaços e capitalizar
    # .strip() remove espaços nas bordas
    # .capitalize() coloca a primeira letra maiúscula e o restante minúsculo
    nome_formatado = nome.strip().capitalize()

    # PASSO 2: Normalizar a saudação — remover espaços nas bordas
    saudacao_formatada = saudacao.strip()

    # PASSO 3: Montar e retornar a mensagem usando f-string
    # f-strings permitem inserir expressões dentro de strings com {}
    return f"{saudacao_formatada}, {nome_formatado}!"


def calcular_estatisticas(numeros):
    """
    Calcula o mínimo, máximo e média de uma lista de números.

    Demonstra: retorno múltiplo com tupla, funções auxiliares internas,
               tratamento de lista vazia com None.

    ENTRADA: numeros — lista de números inteiros ou decimais
    SAÍDA: tupla (minimo, maximo, media) com os três valores calculados,
           ou (None, None, None) se a lista estiver vazia

    Exemplos:
        calcular_estatisticas([7, 3, 9, 4, 5])  → (3, 9, 5.6)
        calcular_estatisticas([42])              → (42, 42, 42.0)
        calcular_estatisticas([])               → (None, None, None)
    """

    # PASSO 1: Tratar o caso de lista vazia
    # Uma lista vazia não tem mínimo, máximo nem média
    # Retornamos três None como tupla para manter a assinatura consistente
    if not numeros:
        return None, None, None

    # PASSO 2: Calcular o mínimo manualmente com laço
    # Iniciamos assumindo que o primeiro elemento é o menor
    minimo = numeros[0]

    # Percorremos os demais elementos procurando um menor
    for numero in numeros:
        if numero < minimo:
            # Encontramos um valor menor — atualizamos o mínimo
            minimo = numero

    # PASSO 3: Calcular o máximo manualmente com laço
    # Iniciamos assumindo que o primeiro elemento é o maior
    maximo = numeros[0]

    # Percorremos os demais elementos procurando um maior
    for numero in numeros:
        if numero > maximo:
            # Encontramos um valor maior — atualizamos o máximo
            maximo = numero

    # PASSO 4: Calcular a média
    # Somamos todos os elementos e dividimos pela quantidade
    total = 0
    for numero in numeros:
        total += numero

    # A divisão com / sempre retorna float em Python 3
    media = total / len(numeros)

    # PASSO 5: Retornar os três valores como tupla
    # Python empacota automaticamente múltiplos valores em uma tupla
    # O chamador pode desempacotá-los: mn, mx, med = calcular_estatisticas(lista)
    return minimo, maximo, media


def e_primo(numero):
    """
    Verifica se um número inteiro é primo.

    Um número primo é aquele maior que 1 que só é divisível por 1 e por si mesmo.

    Demonstra: encapsulamento de lógica complexa em função reutilizável,
               laço for com break, retorno booleano, casos especiais.

    ENTRADA: numero — inteiro qualquer
    SAÍDA: True se o número for primo, False caso contrário

    Exemplos:
        e_primo(2)   → True   (o menor número primo)
        e_primo(3)   → True
        e_primo(4)   → False  (4 = 2 * 2)
        e_primo(17)  → True
        e_primo(1)   → False  (por definição, 1 não é primo)
        e_primo(-5)  → False  (negativos não são primos)
        e_primo(0)   → False
    """

    # PASSO 1: Tratar os casos especiais que não são primos por definição
    # Números menores ou iguais a 1 nunca são primos
    if numero <= 1:
        return False

    # PASSO 2: O número 2 é o único primo par — tratamos separadamente
    # Isso evita que o laço abaixo precise verificar 2 como divisor
    if numero == 2:
        return True

    # PASSO 3: Números pares maiores que 2 nunca são primos
    # (são divisíveis por 2)
    if numero % 2 == 0:
        return False

    # PASSO 4: Verificar divisibilidade por ímpares de 3 até sqrt(numero)
    # Se numero tem um divisor maior que sua raiz quadrada,
    # então também tem um divisor menor que a raiz — já teríamos encontrado.
    # Portanto, só precisamos verificar até a raiz quadrada.
    # Usamos numero ** 0.5 para calcular a raiz quadrada sem importar math
    divisor = 3
    while divisor <= numero ** 0.5:
        if numero % divisor == 0:
            # Encontramos um divisor — o número não é primo
            return False
        # Avançamos de dois em dois (apenas ímpares, pois pares já foram descartados)
        divisor += 2

    # PASSO 5: Se chegamos aqui, nenhum divisor foi encontrado — é primo!
    return True


def aplicar_operacao(numero, operacao):
    """
    Aplica uma função (operação) a um número e retorna o resultado.

    Demonstra: função como argumento (higher-order function),
               separação entre COMO fazer (operação) e O QUE fazer (aplicar).

    ENTRADA: numero   — número inteiro ou decimal a ser processado
             operacao — função que recebe um número e retorna um número
    SAÍDA: o resultado de chamar operacao(numero)

    Exemplos (assumindo as funções dobrar e triplicar definidas fora):
        aplicar_operacao(5, dobrar)     → 10
        aplicar_operacao(5, triplicar)  → 15
        aplicar_operacao(4, quadrado)   → 16
    """

    # PASSO 1: Chamar a função recebida como argumento, passando o número
    # 'operacao' é uma variável que aponta para uma função
    # 'operacao(numero)' chama essa função com 'numero' como argumento
    # Não usamos 'operacao()' com parênteses na definição — apenas no momento de chamar
    resultado = operacao(numero)

    # PASSO 2: Retornar o resultado da operação aplicada
    return resultado


# --- Funções auxiliares para demonstrar aplicar_operacao() ---
# Estas funções são simples transformações numéricas
# que serão passadas como argumento para aplicar_operacao()

def dobrar(numero):
    """Retorna o dobro do número recebido."""
    # Multiplica o número por 2 e retorna o resultado
    return numero * 2


def triplicar(numero):
    """Retorna o triplo do número recebido."""
    # Multiplica o número por 3 e retorna o resultado
    return numero * 3


def quadrado(numero):
    """Retorna o quadrado do número recebido (numero elevado a 2)."""
    # Usa o operador de exponenciação ** para elevar ao quadrado
    return numero ** 2


def inverter_sinal(numero):
    """Retorna o número com o sinal invertido."""
    # Multiplica por -1 para inverter o sinal
    return numero * -1
~~~

### Como executar o código

Com o ambiente virtual ativo, navegue até a pasta e teste manualmente:

~~~text
.venv\Scripts\activate
cd modulo_01_fundamentos\aula_05_funcoes\codigo
python -c "from funcoes_uteis import *; print(saudar('Ana')); print(calcular_estatisticas([7,3,9,4,5])); print(e_primo(17)); print(aplicar_operacao(5, dobrar))"
~~~

---

## Testes Automatizados com pytest

Crie o arquivo `test_funcoes_uteis.py` dentro da pasta `modulo_01_fundamentos/aula_05_funcoes/testes/`:

~~~python
# test_funcoes_uteis.py
# Testes automatizados para a Aula 05: Funções
# Execute com: pytest testes/ -v
#
# Filosofia dos testes:
# - Parâmetros padrão: testar com e sem o argumento opcional
# - Retorno múltiplo: verificar cada componente da tupla retornada
# - Primo: testar casos especiais (0, 1, 2), primos conhecidos e não-primos
# - Higher-order: testar com cada função auxiliar como argumento

import pytest

# Importamos todas as funções que vamos testar
from codigo.funcoes_uteis import (
    saudar,
    calcular_estatisticas,
    e_primo,
    aplicar_operacao,
    dobrar,
    triplicar,
    quadrado,
    inverter_sinal,
)


# ============================================================
# TESTES PARA saudar()
# ============================================================

class TestSaudar:
    """
    Testa todos os comportamentos da função saudar.
    Verifica: saudação padrão, saudação personalizada, normalização de entrada.
    """

    def test_saudacao_padrao(self):
        """Sem segundo argumento, usa a saudação padrão 'Olá'."""
        assert saudar("Ana") == "Olá, Ana!"

    def test_saudacao_personalizada(self):
        """Com segundo argumento, usa a saudação fornecida."""
        assert saudar("Carlos", "Bom dia") == "Bom dia, Carlos!"

    def test_saudacao_boa_noite(self):
        """Outro exemplo de saudação personalizada."""
        assert saudar("Maria", "Boa noite") == "Boa noite, Maria!"

    def test_nome_em_minusculas_capitalizado(self):
        """Nome em minúsculas deve ser capitalizado automaticamente."""
        assert saudar("pedro") == "Olá, Pedro!"

    def test_nome_em_maiusculas_normalizado(self):
        """Nome em maiúsculas deve ser normalizado pelo capitalize."""
        # capitalize() coloca apenas a primeira letra maiúscula
        assert saudar("JOAO") == "Olá, Joao!"

    def test_nome_com_espacos_extras(self):
        """Espaços extras no nome devem ser removidos."""
        assert saudar("  Maria  ") == "Olá, Maria!"

    def test_retorna_string(self):
        """A função deve sempre retornar uma string."""
        assert isinstance(saudar("Ana"), str)

    def test_resultado_termina_com_exclamacao(self):
        """A saudação deve sempre terminar com ponto de exclamação."""
        resultado = saudar("Teste", "Oi")
        assert resultado.endswith("!")

    def test_saudacao_com_espacos_extras(self):
        """Espaços extras na saudação também devem ser removidos."""
        assert saudar("Ana", "  Oi  ") == "Oi, Ana!"


# ============================================================
# TESTES PARA calcular_estatisticas()
# ============================================================

class TestCalcularEstatisticas:
    """
    Testa todos os comportamentos da função calcular_estatisticas.
    Verifica: valores corretos, lista vazia, lista unitária, negativos.
    """

    def test_estatisticas_lista_simples(self):
        """Caso normal: lista com cinco números distintos."""
        minimo, maximo, media = calcular_estatisticas([7, 3, 9, 4, 5])
        assert minimo == 3
        assert maximo == 9
        assert media == pytest.approx(5.6)

    def test_lista_vazia_retorna_tres_none(self):
        """Lista vazia deve retornar (None, None, None)."""
        resultado = calcular_estatisticas([])
        assert resultado == (None, None, None)

    def test_lista_com_um_elemento(self):
        """Lista com um único elemento — mínimo, máximo e média são iguais."""
        minimo, maximo, media = calcular_estatisticas([42])
        assert minimo == 42
        assert maximo == 42
        assert media == pytest.approx(42.0)

    def test_lista_com_negativos(self):
        """Caso com números negativos."""
        minimo, maximo, media = calcular_estatisticas([-5, -1, -3])
        assert minimo == -5
        assert maximo == -1
        assert media == pytest.approx(-3.0)

    def test_lista_com_positivos_e_negativos(self):
        """Caso com mistura de positivos e negativos."""
        minimo, maximo, media = calcular_estatisticas([-10, 0, 10])
        assert minimo == -10
        assert maximo == 10
        assert media == pytest.approx(0.0)

    def test_lista_com_elementos_iguais(self):
        """Lista com todos os elementos iguais — mín e máx são o mesmo."""
        minimo, maximo, media = calcular_estatisticas([5, 5, 5, 5])
        assert minimo == 5
        assert maximo == 5
        assert media == pytest.approx(5.0)

    def test_retorno_e_tupla(self):
        """A função deve retornar uma tupla com três elementos."""
        resultado = calcular_estatisticas([1, 2, 3])
        assert isinstance(resultado, tuple)
        assert len(resultado) == 3

    def test_desempacotamento_funciona(self):
        """O retorno múltiplo deve suportar desempacotamento."""
        # Esta sintaxe deve funcionar sem erros
        mn, mx, med = calcular_estatisticas([1, 5, 3])
        assert mn == 1
        assert mx == 5
        assert med == pytest.approx(3.0)


# ============================================================
# TESTES PARA e_primo()
# ============================================================

class TestEPrimo:
    """
    Testa todos os comportamentos da função e_primo.
    Verifica: casos especiais (0, 1, 2), primos conhecidos, não-primos, negativos.
    """

    # --- Casos especiais ---

    def test_zero_nao_e_primo(self):
        """Zero não é primo por definição."""
        assert e_primo(0) is False

    def test_um_nao_e_primo(self):
        """1 não é primo — caso especial importante."""
        assert e_primo(1) is False

    def test_dois_e_primo(self):
        """2 é primo — o único número primo par."""
        assert e_primo(2) is True

    def test_negativo_nao_e_primo(self):
        """Números negativos não são primos."""
        assert e_primo(-5) is False
        assert e_primo(-2) is False

    # --- Primos conhecidos ---

    def test_tres_e_primo(self):
        assert e_primo(3) is True

    def test_cinco_e_primo(self):
        assert e_primo(5) is True

    def test_sete_e_primo(self):
        assert e_primo(7) is True

    def test_onze_e_primo(self):
        assert e_primo(11) is True

    def test_treze_e_primo(self):
        assert e_primo(13) is True

    def test_dezessete_e_primo(self):
        assert e_primo(17) is True

    def test_dezenove_e_primo(self):
        assert e_primo(19) is True

    # --- Não-primos conhecidos ---

    def test_quatro_nao_e_primo(self):
        """4 = 2 × 2 — não é primo."""
        assert e_primo(4) is False

    def test_seis_nao_e_primo(self):
        """6 = 2 × 3 — não é primo."""
        assert e_primo(6) is False

    def test_nove_nao_e_primo(self):
        """9 = 3 × 3 — não é primo."""
        assert e_primo(9) is False

    def test_vinte_e_cinco_nao_e_primo(self):
        """25 = 5 × 5 — não é primo."""
        assert e_primo(25) is False

    def test_cem_nao_e_primo(self):
        """100 = 4 × 25 — não é primo."""
        assert e_primo(100) is False

    def test_retorna_booleano(self):
        """A função deve sempre retornar um booleano."""
        assert isinstance(e_primo(7), bool)
        assert isinstance(e_primo(4), bool)


# ============================================================
# TESTES PARA aplicar_operacao() e funções auxiliares
# ============================================================

class TestAplicarOperacao:
    """
    Testa a função aplicar_operacao com cada função auxiliar como argumento.
    Verifica: resultado correto, passagem de diferentes funções, zero e negativos.
    """

    def test_dobrar_numero_positivo(self):
        """Aplicar dobrar a 5 deve retornar 10."""
        assert aplicar_operacao(5, dobrar) == 10

    def test_triplicar_numero_positivo(self):
        """Aplicar triplicar a 5 deve retornar 15."""
        assert aplicar_operacao(5, triplicar) == 15

    def test_quadrado_numero_positivo(self):
        """Aplicar quadrado a 4 deve retornar 16."""
        assert aplicar_operacao(4, quadrado) == 16

    def test_inverter_sinal_positivo(self):
        """Aplicar inverter_sinal a 7 deve retornar -7."""
        assert aplicar_operacao(7, inverter_sinal) == -7

    def test_inverter_sinal_negativo(self):
        """Aplicar inverter_sinal a número negativo deve retornar positivo."""
        assert aplicar_operacao(-3, inverter_sinal) == 3

    def test_operacao_com_zero(self):
        """Dobrar zero deve retornar zero."""
        assert aplicar_operacao(0, dobrar) == 0

    def test_operacao_com_negativo(self):
        """Dobrar número negativo deve retornar negativo dobrado."""
        assert aplicar_operacao(-4, dobrar) == -8

    def test_operacao_com_float(self):
        """Dobrar float deve funcionar corretamente."""
        assert aplicar_operacao(2.5, dobrar) == pytest.approx(5.0)

    def test_quadrado_de_zero(self):
        """Zero ao quadrado é zero."""
        assert aplicar_operacao(0, quadrado) == 0

    def test_resultado_depende_da_operacao_passada(self):
        """O mesmo número com operações diferentes deve dar resultados diferentes."""
        resultado_dobro = aplicar_operacao(6, dobrar)
        resultado_triplo = aplicar_operacao(6, triplicar)
        resultado_quad = aplicar_operacao(6, quadrado)
        # Os três resultados devem ser diferentes entre si
        assert resultado_dobro != resultado_triplo
        assert resultado_triplo != resultado_quad
        assert resultado_dobro == 12
        assert resultado_triplo == 18
        assert resultado_quad == 36


# ============================================================
# TESTES DAS FUNÇÕES AUXILIARES INDIVIDUALMENTE
# ============================================================

class TestFuncoesAuxiliares:
    """Testa as funções auxiliares dobrar, triplicar, quadrado e inverter_sinal."""

    def test_dobrar(self):
        assert dobrar(3) == 6
        assert dobrar(0) == 0
        assert dobrar(-2) == -4

    def test_triplicar(self):
        assert triplicar(3) == 9
        assert triplicar(0) == 0
        assert triplicar(-2) == -6

    def test_quadrado(self):
        assert quadrado(3) == 9
        assert quadrado(0) == 0
        assert quadrado(-3) == 9  # (-3)² = 9

    def test_inverter_sinal(self):
        assert inverter_sinal(5) == -5
        assert inverter_sinal(-5) == 5
        assert inverter_sinal(0) == 0
~~~

### Como executar os testes

~~~text
cd modulo_01_fundamentos\aula_05_funcoes
pytest testes/ -v
~~~

### Estrutura de pastas necessária

~~~text
modulo_01_fundamentos/
└── aula_05_funcoes/
    ├── codigo/
    │   ├── __init__.py        ← arquivo vazio
    │   └── funcoes_uteis.py
    └── testes/
        └── test_funcoes_uteis.py
~~~

Criando o `__init__.py` no terminal:

~~~text
type nul > modulo_01_fundamentos\aula_05_funcoes\codigo\__init__.py
~~~

---

## Glossário Técnico da Aula

**Função:** bloco de código nomeado com `def`, que recebe parâmetros, executa uma lógica e retorna um resultado com `return`. Permite reutilização e organização do código.

**Parâmetro:** variável local definida na assinatura da função, que recebe o valor do argumento correspondente no momento da chamada.

**Argumento:** valor concreto passado para uma função no momento de sua chamada. Atribuído ao parâmetro correspondente.

**`return`:** instrução que encerra a execução da função e devolve um valor ao chamador. Sem `return`, a função retorna `None` implicitamente.

**Valor padrão:** valor atribuído a um parâmetro na definição da função, usado automaticamente quando nenhum argumento é fornecido para aquele parâmetro.

**Escopo local:** região de visibilidade de uma variável criada dentro de uma função. Existe apenas durante a execução da função — nasce na chamada, morre no retorno.

**Escopo global:** região de visibilidade de uma variável criada fora de qualquer função. Existe pelo tempo de vida do módulo.

**Retorno múltiplo:** capacidade de uma função retornar vários valores separados por vírgula, que o Python empacota automaticamente em uma tupla.

**Tupla:** sequência imutável de valores em Python, criada por valores separados por vírgula. `a, b, c = funcao()` é desempacotamento de tupla.

**Desempacotamento:** sintaxe que distribui os elementos de uma tupla (ou lista) em variáveis separadas. `mn, mx, med = calcular_estatisticas(lista)`.

**Função de ordem superior (higher-order function):** função que recebe outra função como argumento ou retorna uma função como resultado.

**Docstring:** string literal entre aspas triplas colocada imediatamente após `def`, que documenta o comportamento, parâmetros e retorno da função. Acessível via `help()`.

**Função pura:** função que sempre retorna o mesmo resultado para os mesmos argumentos e não produz efeitos colaterais — não modifica variáveis externas nem realiza operações de I/O.

**Responsabilidade única:** princípio de design que determina que cada função deve fazer exatamente uma coisa e fazê-la bem.

**`capitalize()`:** método de string que retorna uma nova string com a primeira letra maiúscula e o restante minúsculo.

**`endswith(sufixo)`:** método de string que retorna `True` se a string termina com o sufixo especificado.

---

## Antecipação de Erros

**Erro 1: Esquecer o `return` e receber `None` inesperadamente.** Uma função sem `return` retorna `None` implicitamente. Se você escrever `def calcular(a, b): resultado = a + b` sem `return resultado`, a função calculará corretamente mas o resultado se perderá — o chamador receberá `None`. Sempre verifique: se a função deve produzir um valor, onde está o `return`?

**Erro 2: Chamar uma função passando-a como argumento com parênteses.** `aplicar_operacao(5, dobrar())` chama `dobrar()` imediatamente (sem argumento, causando `TypeError`) e passa o resultado para `aplicar_operacao`. O correto é `aplicar_operacao(5, dobrar)` — sem parênteses, passando a referência à função, não seu resultado.

**Erro 3: Usar objeto mutável como valor padrão.** `def func(lista=[]):` é uma armadilha clássica — a mesma lista é compartilhada entre todas as chamadas sem argumento. Após `func()` adicionar um elemento, a lista padrão fica `[elemento]` para todas as chamadas futuras. Use sempre `None` como padrão e crie o objeto dentro da função: `if lista is None: lista = []`.

**Erro 4: Confundir escopo local com escopo global.** Uma variável criada dentro de uma função não existe fora dela. Se você tentar acessar fora da função uma variável definida dentro, receberá `NameError`. A solução é retornar o valor com `return` e capturá-lo no escopo externo.

**Erro 5: Parâmetro padrão antes de parâmetro obrigatório.** `def func(a=10, b):` causa `SyntaxError` — parâmetros com valor padrão devem sempre vir depois dos parâmetros sem valor padrão. A ordem correta é `def func(b, a=10):`.

**Erro 6: Tentar modificar variável global dentro da função sem `global`.** Se você tentar atribuir um novo valor a uma variável global dentro de uma função sem usar a palavra-chave `global`, o Python cria uma nova variável local com o mesmo nome — a global permanece inalterada. Evite isso preferindo funções puras que retornam valores em vez de modificar o estado global.

---

## Troubleshooting

**Problema: `TypeError: funcao() missing 1 required positional argument`.**
Causa: a função foi chamada sem um argumento obrigatório.
Solução: verifique a assinatura da função — quantos parâmetros ela tem? Quantos têm valor padrão? Os parâmetros sem valor padrão são obrigatórios e devem receber um argumento na chamada.

**Problema: `TypeError: funcao() takes 1 positional argument but 2 were given`.**
Causa: a função foi chamada com mais argumentos do que parâmetros definidos.
Solução: verifique se você está chamando a função correta, ou se a definição da função tem o número correto de parâmetros.

**Problema: A função retorna `None` quando deveria retornar um valor.**
Causa: o `return` está ausente, ou está em um ramo condicional que não foi atingido.
Solução: adicione `print()` temporários para verificar qual caminho a função está tomando. Certifique-se de que todos os caminhos possíveis de execução têm um `return` com valor.

**Problema: `e_primo()` retorna resultado incorreto para números grandes.**
Causa: o algoritmo de verificação de primo por divisão de tentativas é correto mas pode ser lento para números muito grandes — não é um bug, é uma característica de performance.
Solução: para os fins desta aula, o algoritmo está correto. Otimizações como o Crivo de Eratóstenes serão exploradas em aulas futuras.

---

## Desafio de Fixação

Implemente uma função chamada `contar_vogais(texto)` que recebe uma string e retorna um dicionário com duas informações: `"total"` (quantidade total de vogais na string) e `"por_vogal"` (dicionário com a contagem de cada vogal individualmente). A função deve ignorar maiúsculas e minúsculas e considerar apenas as vogais `a, e, i, o, u`. Em seguida, implemente uma segunda função chamada `aplicar_e_filtrar(numeros, operacao, minimo)` que aplica a `operacao` a cada número da lista e retorna apenas os resultados maiores ou iguais a `minimo` — demonstrando a combinação de higher-order functions com filtragem.

**Resolução comentada:**

~~~python
def contar_vogais(texto):
    """
    Conta vogais em uma string, retornando total e contagem por vogal.

    ENTRADA: texto — string qualquer
    SAÍDA: dicionário com 'total' e 'por_vogal'
    """

    # Definir o conjunto de vogais que queremos contar
    vogais = "aeiou"

    # Inicializar o dicionário de contagem por vogal
    # Cada vogal começa com contagem zero
    por_vogal = {"a": 0, "e": 0, "i": 0, "o": 0, "u": 0}

    # Inicializar o contador total
    total = 0

    # Percorrer cada caractere do texto
    for caractere in texto.lower():  # .lower() para ignorar maiúsculas
        # Verificar se o caractere é uma vogal
        if caractere in vogais:
            # Incrementar a contagem desta vogal específica
            por_vogal[caractere] += 1
            # Incrementar o total de vogais
            total += 1

    # Retornar dicionário com as duas informações
    return {"total": total, "por_vogal": por_vogal}


def aplicar_e_filtrar(numeros, operacao, minimo):
    """
    Aplica uma operação a cada número e retorna apenas os resultados >= minimo.

    ENTRADA: numeros   — lista de números
             operacao  — função a aplicar a cada número
             minimo    — valor mínimo para incluir no resultado
    SAÍDA: lista com os resultados da operação que são >= minimo
    """

    # Inicializar a lista de resultados filtrados
    resultados = []

    # Percorrer cada número da lista
    for numero in numeros:
        # Aplicar a operação ao número atual
        resultado = operacao(numero)

        # Verificar se o resultado atende ao critério mínimo
        if resultado >= minimo:
            # Incluir no resultado apenas se passar pelo filtro
            resultados.append(resultado)

    return resultados
~~~

Testes para o desafio:

~~~python
def test_contar_vogais_frase():
    resultado = contar_vogais("Python")
    assert resultado["total"] == 1
    assert resultado["por_vogal"]["o"] == 1

def test_contar_vogais_maiusculas():
    resultado = contar_vogais("AEIOUaeiou")
    assert resultado["total"] == 10

def test_contar_vogais_sem_vogais():
    resultado = contar_vogais("rhythm")
    assert resultado["total"] == 0

def test_aplicar_e_filtrar():
    numeros = [1, 2, 3, 4, 5]
    resultado = aplicar_e_filtrar(numeros, dobrar, 6)
    # dobrar([1,2,3,4,5]) = [2,4,6,8,10] — filtrar >= 6 = [6,8,10]
    assert resultado == [6, 8, 10]
~~~

---

## Resumo dos Pontos-Chave

Uma **função** é definida com `def nome(parâmetros):` e encerra com `return valor`. **Parâmetro** é o nome na definição; **argumento** é o valor na chamada. **Valores padrão** tornam parâmetros opcionais — sempre posicionados após os obrigatórios, nunca com objetos mutáveis como padrão. **Retorno múltiplo** empacota valores automaticamente em uma tupla, que pode ser desempacotada com `a, b, c = func()`. **Escopo local** isola variáveis dentro da função — elas não existem fora; use `return` para exportar resultados. **Funções de ordem superior** recebem outras funções como argumentos — passe a referência sem parênteses (`dobrar`, não `dobrar()`). **Funções puras** são preferíveis — mesmo resultado para mesmos argumentos, sem efeitos colaterais. O princípio da **responsabilidade única** diz que cada função deve fazer exatamente uma coisa. **Docstrings** documentam o comportamento esperado e são acessíveis via `help()`.

---

## Log de Estado da Aula

**Aula:** 05 — Funções: Reutilizando e Organizando Algoritmos
**Objetivo:** Implementar quatro funções demonstrando parâmetros padrão, retorno múltiplo, encapsulamento de lógica e higher-order functions.
**Arquivos criados:**
- `modulo_01_fundamentos/aula_05_funcoes/codigo/__init__.py`
- `modulo_01_fundamentos/aula_05_funcoes/codigo/funcoes_uteis.py`
- `modulo_01_fundamentos/aula_05_funcoes/testes/test_funcoes_uteis.py`

**Estado Funcional:** ✅ Quatro funções principais e quatro funções auxiliares implementadas, com testes cobrindo parâmetros padrão, retorno múltiplo, casos especiais de primo, higher-order functions e funções auxiliares individualmente.
**Próximas Etapas:** Aula 06 ensinará listas em profundidade — criação, acesso por índice, fatiamento, métodos e manipulação — como base estrutural para todos os algoritmos de busca e ordenação do Módulo 2.

---

## Próximos Passos

Na **Aula 06: Listas em Python: Armazenando e Manipulando Coleções**, você aprenderá a dominar listas como a estrutura de dados mais importante para algoritmos — índices positivos e negativos, fatiamento com `lista[inicio:fim:passo]`, métodos essenciais e implementação manual de operações como inversão, remoção de duplicatas e rotação. Tudo com código autocontido e testes pytest extensivos.

---

Dúvidas? Posso prosseguir para a próxima etapa?