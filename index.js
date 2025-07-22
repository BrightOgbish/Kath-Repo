const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send('<h1>Hello from Node.js App on Azure!</h1><p>This is served from Express.</p>');
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
