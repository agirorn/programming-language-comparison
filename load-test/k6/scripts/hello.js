import http from 'k6/http';
import { Trend } from 'k6/metrics';
import { sleep } from 'k6';
export const options = {
  vus: 10,
  duration: '30s',
};

const cs_1 = new Trend('app_csharp_1_hello');
const cs_2 = new Trend('app_csharp_2_hello');
const cs_3 = new Trend('app_csharp_3_hello');
const js = new Trend('app_js_express_hello');
const py = new Trend('app_py_fastapi_hello');
const py_uvicorn = new Trend('app_py_fastapi_uvicorn');
const go_http_router = new Trend('app_go_http_router');
const go_http_only = new Trend('app_go_http_only');
const rust_axum = new Trend('app_rust_axum');

export default function() {
  cs_1.add(http.get('http://localhost/app/csharp-1/hello').timings.waiting);
  cs_2.add(http.get('http://localhost/app/csharp-2/hello').timings.waiting);
  cs_3.add(http.get('http://localhost/app/csharp-3/hello').timings.waiting);
  js.add(http.get('http://localhost/app/js-express-js/hello').timings.waiting);
  py.add(http.get('http://localhost/app/py-fastapi/hello').timings.waiting);
  py_uvicorn.add(http.get('http://localhost/app/py-fastapi-uvicorn/hello').timings.waiting);
  go_http_router.add(http.get('http://localhost/app/go-http-router/hello').timings.waiting);
  go_http_only.add(http.get('http://localhost/app/go_http_only/hello').timings.waiting);
  rust_axum.add(http.get('http://localhost/app/rust-axum/hello').timings.waiting);

}
