.PHONY: build
build:
	cd flyway-migrations && make build
	cd go-http-router && make build
	cd go-http-only && make build
	cd py-fastapi && make build
	cd py-fastapi-uvicorn && make build
	cd app-root && make build
	cd js-express-js && make build
	cd csharp && make build
	cd csharp-2 && make build
	cd csharp-3 && make build
	cd rust_axum && make build

.PHONY: setup
setup:
	cd flyway-migrations && make setup
	cd go-http-router && make setup
	cd go-http-only && make setup
	cd py-fastapi && make setup
	cd py-fastapi-uvicorn && make setup
	cd app-root && make setup
	cd js-express-js && make setup
	cd csharp && make setup
	cd csharp-2 && make setup
	cd csharp-3 && make setup
	cd rust_axum && make setup

.PHONY: start
start:
	cd flyway-migrations && make start
	cd go-http-router && make start
	cd go-http-only && make start
	# cd py-fastapi && make start
	cd py-fastapi-uvicorn && make start
	# cd app-root && make start
	cd js-express-js && make start
	# cd csharp && make start
	cd csharp-2 && make start
	cd csharp-3 && make start
	cd rust_axum && make start

.PHONY: stop
stop:
	cd flyway-migrations && make stop
	cd go-http-router && make stop
	cd go-http-only && make stop
	# cd py-fastapi && make stop
	cd py-fastapi-uvicorn && make stop
	# cd app-root && make stop
	cd js-express-js && make stop
	# cd csharp && make stop
	cd csharp-2 && make stop
	cd csharp-3 && make stop
	cd rust_axum && make stop


.PHONY: clean
clean:
	cd flyway-migrations && pwd && make clean
	cd go-http-router && pwd && make clean
	cd go-http-only && pwd && make clean
	cd py-fastapi && pwd && make clean
	cd py-fastapi-uvicorn && pwd && make clean
	cd app-root && pwd && make clean
	cd js-express-js && pwd && make clean
	cd csharp && pwd && make clean
	cd csharp-2 && pwd && make clean
	cd csharp-3 && pwd && make clean
	cd rust_axum && pwd && make clean


.PHONY: build-local
build-local:
	@echo "--------------------------------------------"
	cd flyway-migrations && pwd && /usr/bin/time -p make build-local
	@echo "--------------------------------------------"
	cd go-http-router && pwd && /usr/bin/time -p make build-local
	@echo "--------------------------------------------"
	cd go-http-only && pwd && /usr/bin/time -p make build-local
	@echo "--------------------------------------------"
	cd py-fastapi && pwd && /usr/bin/time -p make build-local
	@echo "--------------------------------------------"
	cd py-fastapi-uvicorn && pwd && /usr/bin/time -p make build-local
	@echo "--------------------------------------------"
	cd app-root && pwd && /usr/bin/time -p make build-local
	@echo "--------------------------------------------"
	cd js-express-js && pwd && /usr/bin/time -p make build-local
	@echo "--------------------------------------------"
	cd csharp && pwd && /usr/bin/time -p make build-local
	@echo "--------------------------------------------"
	cd csharp-2 && pwd && /usr/bin/time -p make build-local
	@echo "--------------------------------------------"
	cd csharp-3 && pwd && /usr/bin/time -p make build-local
	@echo "--------------------------------------------"
	cd rust_axum && pwd && /usr/bin/time -p make build-local
	@echo "--------------------------------------------"
