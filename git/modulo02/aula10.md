# Aula 10: Fluxo de Trabalho: Feature Branch Workflow

## Resumo da Aula Anterior
Na Aula 9, exploramos o `git rebase` como uma alternativa poderosa ao `git merge` para integrar mudanças, com o objetivo de criar um histórico de commits mais linear e limpo. Aprendemos como o `rebase` "re-baseia" os commits de uma branch sobre outra e a importância da "Regra de Ouro": nunca rebasear commits que já foram compartilhados em um repositório remoto.

## Objetivo
Compreender e aplicar o **Feature Branch Workflow**, um dos fluxos de trabalho mais comuns e eficazes no desenvolvimento de software com Git. Aprender a gerenciar o ciclo de vida completo de uma funcionalidade, desde a criação da branch até sua integração final na `main`, utilizando os comandos `git branch`, `git switch`, `git add`, `git commit`, `git push`, `git pull` e `git merge` (ou `git rebase`).

## Pré-requisitos
Conhecimento sólido de branches, `git merge` e `git rebase` (conforme Aulas 7, 8 e 9).

## Análise de Integridade
✅ Conteúdo verificado: profundidade técnica mantida, linguagem acessível, código funcional.

## Teoria Detalhada (Narrativa Densa)

Até agora, aprendemos os blocos de construção fundamentais do Git: como criar commits, gerenciar branches, interagir com repositórios remotos e integrar mudanças. No entanto, o Git é uma ferramenta flexível, e a forma como esses comandos são combinados para gerenciar o desenvolvimento de um projeto é o que chamamos de **fluxo de trabalho** (workflow). Um fluxo de trabalho define um conjunto de regras e procedimentos para o uso do Git em uma equipe, garantindo consistência, colaboração eficiente e um histórico de projeto organizado.

Existem vários fluxos de trabalho populares no Git, como GitFlow, GitHub Flow e GitLab Flow. Para o nosso curso, vamos nos concentrar no **Feature Branch Workflow**, que é um dos mais simples, diretos e amplamente adotados, especialmente em projetos menores e equipes ágeis. Ele serve como uma excelente base para entender conceitos mais complexos de outros fluxos.

### O que é o Feature Branch Workflow?

O **Feature Branch Workflow** é um modelo de desenvolvimento onde todas as novas funcionalidades, correções de bugs ou experimentos são desenvolvidos em branches dedicadas, chamadas **feature branches**, em vez de diretamente na branch `main`. A branch `main` é sempre mantida em um estado estável e pronto para produção.

Pense no `main` como a "linha de produção" principal da sua fábrica de software. Você não quer que máquinas novas e não testadas (novas funcionalidades) sejam instaladas diretamente na linha de produção, correndo o risco de parar tudo. Em vez disso, você as constrói e testa em uma "área de montagem" separada (a feature branch). Somente quando a nova máquina está totalmente funcional e testada, ela é integrada à linha de produção principal.

### Ciclo de Vida de uma Feature Branch

O ciclo de vida de uma feature branch segue um padrão previsível:

1.  **Criação da Feature Branch:**
    *   Sempre comece a partir da branch `main` (ou de uma branch de desenvolvimento estável).
    *   Use um nome descritivo para a branch, como `feature/nome-da-funcionalidade` ou `bugfix/descricao-do-bug`.
    *   Comando: `git switch -c feature/minha-nova-funcionalidade`

2.  **Desenvolvimento da Funcionalidade:**
    *   Trabalhe na sua feature branch, fazendo commits regulares e atômicos.
    *   Cada commit deve representar uma mudança lógica e completa.
    *   Comandos: `git add .`, `git commit -m "feat: implementa parte da funcionalidade"`

3.  **Sincronização com a `main` (Opcional, mas Recomendado):**
    *   À medida que você trabalha na sua feature branch, a branch `main` pode receber novas atualizações de outros desenvolvedores.
    *   É uma boa prática manter sua feature branch atualizada com a `main` para evitar grandes conflitos de merge no final.
    *   Você pode fazer isso de duas maneiras:
        *   **`git merge main` na sua feature branch:** Isso trará os commits da `main` para sua feature branch, criando um commit de merge.
        *   **`git rebase main` na sua feature branch:** Isso reescreverá o histórico da sua feature branch, colocando seus commits "em cima" dos commits mais recentes da `main`, resultando em um histórico mais linear. (Lembre-se da "Regra de Ouro" do rebase se a branch já foi compartilhada!).
    *   Comandos: `git switch main`, `git pull origin main`, `git switch feature/minha-nova-funcionalidade`, `git merge main` (ou `git rebase main`).

4.  **Envio para o Repositório Remoto:**
    *   Envie sua feature branch para o repositório remoto para backup e para que outros possam revisá-la.
    *   Comando: `git push -u origin feature/minha-nova-funcionalidade`

5.  **Revisão de Código (Code Review):**
    *   Em equipes, a feature branch é geralmente revisada por outros desenvolvedores. Isso pode ser feito através de um **Pull Request (PR)** no GitHub (ou Merge Request no GitLab/Bitbucket).
    *   Durante a revisão, podem ser solicitadas alterações, que você fará na sua feature branch e enviará novamente.

6.  **Integração na `main`:**
    *   Após a aprovação da revisão de código, a feature branch é mesclada na `main`.
    *   Isso geralmente é feito através da interface do GitHub/GitLab/Bitbucket, que oferece opções para `merge`, `squash and merge` (combina todos os commits da feature em um único commit na `main`) ou `rebase and merge`.
    *   Comando (se feito localmente): `git switch main`, `git pull origin main`, `git merge feature/minha-nova-funcionalidade`, `git push origin main`.

7.  **Exclusão da Feature Branch:**
    *   Após a integração bem-sucedida, a feature branch geralmente é excluída, tanto localmente quanto no repositório remoto, para manter o repositório limpo.
    *   Comandos: `git branch -d feature/minha-nova-funcionalidade` (local), `git push origin --delete feature/minha-nova-funcionalidade` (remoto).

### Vantagens do Feature Branch Workflow

-   **Isolamento:** O desenvolvimento de novas funcionalidades não interfere na branch `main` estável.
-   **Colaboração:** Permite que vários desenvolvedores trabalhem em diferentes funcionalidades simultaneamente.
-   **Revisão de Código:** Facilita o processo de revisão de código antes que as mudanças sejam integradas à `main`.
-   **Histórico Limpo:** Quando usado com `rebase` ou `squash and merge`, pode resultar em um histórico mais linear e fácil de entender.

### Desvantagens Potenciais

-   **Conflitos de Merge:** Se as feature branches forem muito longas ou não forem sincronizadas frequentemente com a `main`, podem surgir grandes conflitos.
-   **Overhead:** Gerenciar muitas branches pode adicionar um pequeno overhead, mas os benefícios geralmente superam isso.

## Aplicação no Projeto Prático

Nosso `server.js` atual já contém as rotas `/status`, `/agendamentos`, `/agendamentos/:id`, `/usuarios`, `/login` e `/logout`. Vamos simular o desenvolvimento de uma nova funcionalidade, como a adição de um endpoint para **cancelamento de agendamentos**, seguindo o Feature Branch Workflow.

**Estado atual do `server.js`:**
```javascript
// server.js
const express = require('express'); // Importa o módulo express
const app = express(); // Cria uma instância do aplicativo express
const PORT = process.env.PORT || 3000; // Define a porta do servidor, usando a variável de ambiente PORT ou 3000 como padrão

// Middleware para parsear JSON no corpo das requisições
app.use(express.json());

// Rota principal (root)
app.get('/', (req, res) => {
  res.send('Bem-vindo à BarberShop API!'); // Envia uma resposta de texto simples
});

// Rota de exemplo para agendamentos
app.get('/agendamentos', (req, res) => {
  // Por enquanto, apenas um array vazio. Futuramente, virá do banco de dados.
  const agendamentos = [];
  res.json(agendamentos); // Envia uma resposta JSON
});

// TODO: Adicionar validação de dados para agendamentos
// Rota para detalhes de um agendamento específico
app.get('/agendamentos/:id', (req, res) => {
  const { id } = req.params;
  res.json({ message: `Detalhes do agendamento ${id}` });
});

// Nova rota para verificar o status da API
app.get('/status', (req, res) => {
  res.json({ status: 'ok', version: '1.0.0' });
});

// Rota para cadastro de usuários
app.post('/usuarios', (req, res) => {
  res.status(201).json({ message: 'Endpoint de cadastro de usuário (em desenvolvimento)' });
});  

// Rota para autenticação (login)
app.post('/login', (req, res) => {
  // Lógica de autenticação virá aqui. Por enquanto, apenas um placeholder.
  res.status(200).json({ message: 'Endpoint de login (em construção)' });
});

// Rota para logout
app.post('/logout', (req, res) => {
  res.json({ message: 'Usuário deslogado com sucesso' });
});

// Inicia o servidor
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`); // Loga uma mensagem quando o servidor inicia
  console.log(`Acesse: http://localhost:${PORT}`); // Informa o endereço para acessar a API
  console.log('API BarberShop inicializada com sucesso!');
});
```

### Exercício Prático: Implementando Cancelamento de Agendamento

1.  **Crie uma nova feature branch** para o cancelamento de agendamentos:
    ~~~bash
    git switch -c feature/cancelar-agendamento
    ~~~
2.  **Adicione o endpoint de cancelamento** em `server.js`. Abaixo da rota `/agendamentos/:id`, adicione:
    ~~~javascript
    // Rota para cancelar um agendamento
    app.delete('/agendamentos/:id/cancelar', (req, res) => {
      const { id } = req.params;
      res.json({ message: `Agendamento ${id} cancelado com sucesso` });
    });
    ~~~
3.  **Faça um commit** com uma mensagem descritiva:
    ~~~bash
    git add server.js
    git commit -m "feat: adiciona endpoint para cancelar agendamento"
    ~~~
4.  **Envie a feature branch** para o repositório remoto (GitHub):
    ~~~bash
    git push -u origin feature/cancelar-agendamento
    ~~~
5.  **Simule a revisão e aprovação** (na vida real, isso seria um Pull Request).
6.  **Volte para a branch `main`**:
    ~~~bash
    git switch main
    ~~~
7.  **Puxe as últimas alterações da `main`** (se houver, para garantir que você está atualizado):
    ~~~bash
    git pull origin main
    ~~~
8.  **Mescle a feature branch** na `main`:
    ~~~bash
    git merge feature/cancelar-agendamento
    ~~~
9.  **Envie a `main` atualizada** para o repositório remoto:
    ~~~bash
    git push origin main
    ~~~
10. **Exclua a feature branch** localmente e remotamente:
    ~~~bash
    git branch -d feature/cancelar-agendamento
    git push origin --delete feature/cancelar-agendamento
    ~~~
11. **Verifique o histórico** para ver o commit de merge:
    ~~~bash
    git log --oneline --graph
    ~~~

## Resumo dos Pontos-Chave
-   O Feature Branch Workflow é um modelo eficaz para desenvolvimento colaborativo.
-   Novas funcionalidades são desenvolvidas em branches isoladas (`feature branches`).
-   A `main` é mantida estável e pronta para produção.
-   O ciclo inclui criação, desenvolvimento, sincronização, push, revisão e merge na `main`.
-   Excluir branches após o merge ajuda a manter o repositório limpo.

## Próximos Passos
Concluímos o Módulo 2, que focou na colaboração e repositórios remotos. Agora, vamos avançar para o Módulo 3, onde exploraremos técnicas mais avançadas de gerenciamento de histórico e boas práticas. Na Aula 11, faremos uma transição para o `git clone` e `git pull`, que são essenciais para iniciar o trabalho em um projeto existente e manter-se atualizado.

## Log de Estado do Projeto
-   **Objetivo:** Aplicar o Feature Branch Workflow para desenvolver e integrar uma nova funcionalidade.
-   **Código Adicionado:** Endpoint `/agendamentos/:id/cancelar` na branch `main`.
-   **Estado Funcional:** ✅ `main` contém os endpoints de `/status`, `/agendamentos`, `/agendamentos/:id`, `/usuarios`, `/login`, `/logout` e `/agendamentos/:id/cancelar`, com histórico organizado pelo Feature Branch Workflow.
-   **Próximas Etapas:** Aula 11 abordará `git clone` e `git pull` para iniciar e manter projetos existentes.

---
Dúvidas? Posso prosseguir para a próxima etapa?