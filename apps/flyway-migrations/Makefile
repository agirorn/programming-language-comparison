.PHONY: setup
setup:
	echo "Nothing to setup"

.PHONY: build
build:
	docker build . --tag flyway-migrations

.PHONY: docker-run
docker-run:
	docker run --rm -p 127.0.0.1:8080:8080 flyway-migrations

start:
	kubectl apply -f deployment.yml

stop:
	kubectl delete -f deployment.yml


