import http from 'k6/http';
import { Trend } from 'k6/metrics';
import { sleep } from 'k6';
export const options = {
  vus: 10,
  duration: '30s',
};

const js = new Trend('app_js_express_insert');

export default function() {
  const data = {
    key: "key-value",
  };
  let resp = http.post(
    'http://localhost/app/js_express_js/insert',
    JSON.stringify(data),
    {
      headers: { 'Content-Type': 'application/json' },
    }
  );
  js.add(resp.timings.waiting);
}
