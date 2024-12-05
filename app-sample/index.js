const express = require('express');
const fs = require('fs');
const path = require('path');

const app = express();

// Atraso de 5 segundos antes de o servidor começar a ouvir
setTimeout(() => {
  const PORT = process.env.PORT || 3000;
  app.listen(PORT, () => {
    console.log(`Servidor ouvindo http://localhost:${PORT}`);
  });
}, 5000);

// Rota para responder com 'Hello World' e as variáveis de ambiente
app.get('/', (req, res) => {
  const filePath = path.join(__dirname, 'index.html');

  fs.readFile(filePath, 'utf8', (err, data) => {
    if (err) {
      return res.status(500).send('Erro ao carregar a página');
    }

    // Substitui as variáveis no HTML
    const result = data.replace(
      /\$\{DEPLOYMENT\}/g,
      process.env.DEPLOYMENT || 'unknown'
    );

    res.send(result);
  });
});

app.get('/healthcheck', (req, res) => {
  res.send('ok!');
});
