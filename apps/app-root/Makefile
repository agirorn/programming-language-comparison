.PHONY: setup
setup:
	pnpm install

.PHONY: build-local
build-local: setup
build-local:
	echo "Build done"

.PHONY: clean
clean:
	rm -rf node_modules
	go clean -cache

.PHONY: build
build:
	docker build . --tag `node -pe "require('./package.json').name"`

docker-run:
	docker run --rm -p 127.0.0.1:8080:8080 `node -pe "require('./package.json').name"`

start:
	kubectl apply -f deployment.yml

stop:
	kubectl delete -f deployment.yml

