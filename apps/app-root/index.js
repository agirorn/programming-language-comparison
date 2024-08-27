const express = require('express')
const app = express()
const port = process.env.PORT || 8080;
const pkg = require('./package.json');

const stringify = (v) => JSON.stringify(v, null, 2)

app.all('/*', function(req, res, next) {
  const log = {
    app: pkg.name,
    method: req.method,
    url: req.url,
  };
  console.log(`Intercepting requests ${stringify(log)}`)
  res.json({
    app: pkg.name,
    baseUrl: req.baseUrl,
    headers: req.headers,
    method: req.method,
    params: req.params,
    query: req.query,
    url: req.url,
  });
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})
