const pg = require('pg');
const uuid = require('uuid');
const express = require('express')
const port = process.env.PORT || 8080;
const pkg = require('../package.json');
const prom = require('prom-client');

const {
  DB_HOST,
  DB_PORT,
  DB_USER,
  DB_PASS,
  DB_DATABASE,
} = process.env;

const server = express()
server.use(express.json());

prom.collectDefaultMetrics();
const stringify = (v) => JSON.stringify(v, null, 2)

const METRICS_COUNTER = new prom.Counter({
  name: 'http_get_metrics',
  help: 'Counting the number of times the get /metrics route got called',
});

const PROM_CONTENT_TYPE = prom.register.contentType;
const PROM = prom.register;
server.get('/metrics', (req, res) => {
  METRICS_COUNTER.inc();
  PROM.metrics()
    .then(
      (metrics) => {
        res.set('Content-Type', PROM_CONTENT_TYPE);
        res.end(metrics);
      },
      (err) => {
        res.status(500).end(err);
      }
    );
});

const HTTP_GET_HELLO = new prom.Counter({
  name: 'http_get_hello',
  help: 'Counting the number of times the get /hello route got called',
});

server.get('/hello', function(req, res, next) {
  console.log({
    DB_HOST,
    DB_PORT,
    DB_USER,
    DB_PASS,
    DB_DATABASE,
  })
  HTTP_GET_HELLO.inc();
  // const log = {
  //   app: pkg.name,
  //   method: req.method,
  //   url: req.url,
  // };
  // console.log(`/hellow called => ${stringify(log)}`)
  res.json({ body: "world form js-express-js/" });
});

const pool = new pg.Pool({
  max: 10,
  user: DB_USER,
  host: DB_HOST,
  port: DB_PORT,
  password: DB_PASS,
  database: DB_DATABASE,
});

const wrap = (fn) => (...args) => fn(...args).catch(args[2]);

server.get('/select-true', wrap(async (req, res, next) => {
  const rows = (await pool.query(`SELECT TRUE;`)).rows;
  res.json(rows);
}));

server.get('/select-count', wrap(async (req, res, next) => {
  const rows = (await pool.query(`select count(*) from js_table;`)).rows;
  res.json(rows);
}));

server.post('/insert', wrap(async (req, res, next) => {
  const { body } = req;
  const data = JSON.parse(body);
  const id = uuid.v4();
  const { rows } = await pool.query(`
    insert into js_express_js (id, data)
    values ($1, $2)
    returning id, "offset";
  `, [id, JSON.stringify(body)])
  res.json(rows);
}));

server.all('/*', (req, res, next) => {
  res.end(req.url);
});

server.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})
