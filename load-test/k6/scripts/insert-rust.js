import http from 'k6/http';
import { Trend } from 'k6/metrics';
import { sleep } from 'k6';
export const options = {
  vus: 10,
  duration: '30s',
};

const rust_axum = new Trend('app_rust_axum_insert');

export default function() {
  const data = {
    key: "key-value",
  };
  let resp = http.post(
    'http://localhost/app/rust_axum/insert',
    JSON.stringify(data),
    {
      headers: { 'Content-Type': 'application/json' },
    }
  );
  rust_axum.add(resp.timings.waiting);
}
