const express = require('express');
const app = express();

// Atraso de 5 segundos antes de o servidor começar a ouvir
setTimeout(() => {
  const PORT = process.env.PORT || 3000;
  app.listen(PORT, () => {
    console.log(`Servidor ouvindo na porta ${PORT}`);
  });
}, 5000);

// Rota para responder com 'Hello World' e as variáveis de ambiente
app.get('/', (req, res) => {
  res.send(
    `<h1 style="
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100%;
">Hello World!<br/>

NODE_ENV: ${process.env.NODE_ENV}<br/>
ENVIRONMENT: ${process.env.ENVIRONMENT}

</h1>`
  );
});
