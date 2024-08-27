.PHONY: build
build:
	xk6 build \
    --output bin/k6 \
	  --with github.com/grafana/xk6-dashboard@latest
    # --with <module[@version][=replacement]>...]
    # --replace <module=replacement>...]

.PHONY: run-script
run-script:
	./bin/k6 run \
		--vus 50 \
		--duration 4m \
		--out "dashboard=export=reports/script.html" \
		./scripts/script.js

.PHONY: run-hello
run-hello:
	./bin/k6 run \
		--vus 200 \
		--duration 10m \
		--out "dashboard=export=reports/hello.html" \
		./scripts/hello.js

.PHONY: run-insert
run-insert:
	./bin/k6 run \
		--vus 200 \
		--duration 1m \
		--out "dashboard=export=reports/insert.html" \
		./scripts/insert.js

# run-insert-high-load
# Requesting with 10x database pool max virtual users
.PHONY: run-insert-high-load
run-insert-high-load:
	./bin/k6 run \
		--vus 100 \
		--duration 10m \
		--out "dashboard=export=reports/insert-high-load.html" \
		./scripts/insert.js > logs/insert-high-load.log
	cat logs/insert-high-load.log

# run-insert-low-load
# Requesting with 2x database pool max virtual users
.PHONY: run-insert-medium-load
run-insert-medium-load:
	./bin/k6 run \
		--vus 20 \
		--duration 10m \
		--out "dashboard=export=reports/insert-medium-load.html" \
		./scripts/insert.js > logs/insert-medium-load.log
	cat logs/insert-medium-load.log

# run-insert-low-load
# Requesting with fewer than database pool max virtual users
.PHONY: run-insert-low-load
run-insert-low-load:
	./bin/k6 run \
		--vus 8 \
		--duration 10m \
		--out "dashboard=export=reports/insert-low-load.html" \
		./scripts/insert.js > logs/insert-low-load.log
	cat logs/insert-low-load.log

.PHONY: run-insert-rust_axum
run-insert-rust_axum:
	make run-insert-app-rust_axum

.PHONY: run-insert-csharp_2
run-insert-csharp_2:
	make run-insert-app-csharp_2

.PHONY: run-insert-py_fastapi_uvicorn
run-insert-py_fastapi_uvicorn:
	make run-insert-app-py_fastapi_uvicorn

.PHONY: run-insert-go_http_router
run-insert-go_http_router:
	make run-insert-app-go_http_router

.PHONY: run-insert-js_express_js
run-insert-js_express_js:
	make run-insert-app-js_express_js

.PHONY: run-insert-all_in_a_row
run-insert-all_in_a_row:
	sleep 600
	make run-insert-csharp_2
	sleep 600
	make run-insert-js_express_js
	sleep 600
	make run-insert-py_fastapi_uvicorn
	sleep 600
	make run-insert-rust_axum
	sleep 600
	make run-insert-go_http_router

.PHONY: run-insert-app-%:
run-insert-app-%:
	./bin/k6 run \
		-e APP=$* \
		--vus 20 \
		--duration 30m \
		--out "dashboard=export=reports/insert-app_$*.html" \
		./scripts/insert-app.js > logs/insert-app_$*.log

.PHONY: run-insert-rust
run-insert-rust:
	./bin/k6 run \
		--vus 200 \
		--duration 2m \
		--out "dashboard=export=reports/insert-rust.html" \
		./scripts/insert-rust.js

.PHONY: run-insert-js-express-js
run-insert-js-express-js:
	./bin/k6 run \
		--vus 200 \
		--duration 2m \
		--out "dashboard=export=reports/insert-rust-js-express-js.html" \
		./scripts/insert-js-express-js.js
