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

// Comentário: Você pode adicionar mais rotas aqui, como POST /agendamentos para criar um novo agendamento, etc.
// Nova rota para verificar o status da API
app.get('/status', (req, res) => {
  res.json({ status: 'ok', version: '1.0.0' });
});

// Rota para cadastro de usuários
app.post('/usuarios', (req, res) => {
  res.status(201).json({ message: 'Endpoint de cadastro de usuário (em desenvolvimento)' });
// Rota para autenticação (login)
});  

app.post('/login', (req, res) => {
  // Lógica de autenticação virá aqui. Por enquanto, apenas um placeholder.
  res.status(200).json({ message: 'Endpoint de login (em construção)' });
});

// Rota para logout
app.post('/logout', (req, res) => {
  res.json({ message: 'Usuário deslogado com sucesso' });
});

// Rota para cancelar um agendamento
app.delete('/agendamentos/:id/cancelar', (req, res) => {
  const { id } = req.params;
  res.json({ message: `Agendamento ${id} cancelado com sucesso` });
});

// Inicia o servidor
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`); // Loga uma mensagem quando o servidor inicia
  console.log(`Acesse: http://localhost:${PORT}`); // Informa o endereço para acessar a API
  console.log('API BarberShop inicializada com sucesso!');
});