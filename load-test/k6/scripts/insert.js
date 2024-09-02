import http from 'k6/http';
import { Trend } from 'k6/metrics';
import { sleep } from 'k6';
import { uuidv4 } from 'https://jslib.k6.io/k6-utils/1.4.0/index.js';

export const options = {
  vus: 10,
  duration: '30s',
};

const js = new Trend('_js_express');
const py = new Trend('_py_fastapi_uvicorn');
const rust_axum = new Trend('_rust_axum');
const csharp_2 = new Trend('_csharp_2');
const csharp_3 = new Trend('_csharp_3');
const go_http_router = new Trend('_go_http_router');
const go_http_only = new Trend('_go_http_only');

export default function() {
  const data = {
    key: uuidv4(),
  };
  let resp;

  resp = http.post(
    'http://localhost/app/rust_axum/insert',
    JSON.stringify(data),
    {
      headers: { 'Content-Type': 'application/json' },
    }
  );
  rust_axum.add(resp.timings.waiting);

  resp = http.post(
    'http://localhost/app/js_express_js/insert',
    JSON.stringify(data),
    {
      headers: { 'Content-Type': 'application/json' },
    }
  );
  js.add(resp.timings.waiting);

  resp = http.post(
    'http://localhost/app/csharp_2/insert',
    JSON.stringify(data),
    {
      headers: { 'Content-Type': 'application/json' },
    }
  );
  csharp_2.add(resp.timings.waiting);

  resp = http.post(
    'http://localhost/app/csharp_3/insert',
    JSON.stringify(data),
    {
      headers: { 'Content-Type': 'application/json' },
    }
  );
  csharp_3.add(resp.timings.waiting);

  resp = http.post(
    'http://localhost/app/py_fastapi_uvicorn/insert',
    JSON.stringify(data),
    {
      headers: { 'Content-Type': 'application/json' },
    }
  );
  py.add(resp.timings.waiting);

  resp = http.post(
    'http://localhost/app/go_http_router/insert',
    JSON.stringify(data),
    {
      headers: { 'Content-Type': 'application/json' },
    }
  );
  go_http_router.add(resp.timings.waiting);

  resp = http.post(
    'http://localhost/app/go_http_only/insert',
    JSON.stringify(data),
    {
      headers: { 'Content-Type': 'application/json' },
    }
  );
  go_http_only.add(resp.timings.waiting);
}
