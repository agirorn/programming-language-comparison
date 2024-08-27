import http from 'k6/http';
import { Trend } from 'k6/metrics';
import { sleep } from 'k6';
import { uuidv4 } from 'https://jslib.k6.io/k6-utils/1.4.0/index.js';

export const options = {
  vus: 10,
  duration: '30s',
};

const app = __ENV.APP;
const trend = new Trend(`_${app}`);
const URL = `http://localhost/app/${app}/insert`;

export default function() {
  const data = {
    key: uuidv4(),
  };
  let resp = http.post(
    URL,
    JSON.stringify(data),
    {
      headers: { 'Content-Type': 'application/json' },
    }
  );
  trend.add(resp.timings.waiting);
}
