import http from 'k6/http';
import { Trend } from 'k6/metrics';
import { sleep } from 'k6';
export const options = {
  vus: 10,
  duration: '30s',
};

const root = new Trend('app_root');
const cs_hello = new Trend('app_csharp_hello');
const js_hello = new Trend('app_js_express_hello');
const js_insert = new Trend('app_js_express_insert');

export default function() {
  let resp = http.get(
    'http://localhost/',
    {
      tags: {
        app: 'root'
      }
    }
  );
  root.add(resp.timings.waiting);

  resp = http.get(
    'http://localhost/test/csharp/hello',
    {
      tags: {
        app: 'hello'
      }
    }
  );
  cs_hello.add(resp.timings.waiting);

  resp = http.get(
    'http://localhost/test/js-express-js/hello',
    {
      tags: {
        app: 'hello'
      }
    }
  );
  js_hello.add(resp.timings.waiting);

  // const data = {
  //   user: "sdfklsdjfklasj",
  //   pass: "fajklsdjfkasdjlfa",
  // };
  // resp = http.post(
  //   'http://localhost/test/js-express-js/insert',
  //   JSON.stringify(data),
  //   {
  //     headers: { 'Content-Type': 'application/json' },
  //     tags: {
  //       app: 'insert'
  //     }
  //   }
  // );
  // js_insert.add(resp.timings.waiting);
  // sleep(1);
}
