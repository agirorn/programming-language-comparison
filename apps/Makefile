.PHONY: build
build:
	cd flyway-migrations && make build
	cd go-http-router && make build
	cd py-fastapi && make build
	cd py-fastapi-uvicorn && make build
	cd app-root && make build
	cd js-express-js && make build
	cd csharp && make build
	cd csharp-2 && make build
	cd rust_axum && make build

.PHONY: setup
setup:
	cd flyway-migrations && make setup
	cd go-http-router && make setup
	cd py-fastapi && make setup
	cd py-fastapi-uvicorn && make setup
	cd app-root && make setup
	cd js-express-js && make setup
	cd csharp && make setup
	cd csharp-2 && make setup
	cd rust_axum && make setup

.PHONY: start
start:
	cd flyway-migrations && make start
	cd go-http-router && make start
	# cd py-fastapi && make start
	cd py-fastapi-uvicorn && make start
	# cd app-root && make start
	cd js-express-js && make start
	# cd csharp && make start
	cd csharp-2 && make start
	cd rust_axum && make start

.PHONY: stop
stop:
	cd flyway-migrations && make stop
	cd go-http-router && make stop
	# cd py-fastapi && make stop
	cd py-fastapi-uvicorn && make stop
	# cd app-root && make stop
	cd js-express-js && make stop
	# cd csharp && make stop
	cd csharp-2 && make stop
	cd rust_axum && make stop
