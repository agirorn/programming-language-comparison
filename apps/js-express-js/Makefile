.PHONY: setup
setup:
	pnpm install

.PHONY: build
build:
	docker build . --tag `node -pe "require('./package.json').name"`


.PHONY: docker-run
docker-run:
	docker run --rm -p 127.0.0.1:8080:8080 `node -pe "require('./package.json').name"`

.PHONY: start
start:
	kubectl apply -f deployment.yml

.PHONY: stop
stop:
	kubectl delete -f deployment.yml

