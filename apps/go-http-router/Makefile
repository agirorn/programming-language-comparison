.PHONY: setup
setup:
	go mod download

.PHONY: build-local
build-local: setup
build-local:
	CGO_ENABLED=0 GOOS=linux go build main.go
	echo "Build done"

.PHONY: clean
clean:
	rm -f main
	go clean -cache

.PHONY: build
build:
	docker build . --tag app-go-http-router

.PHONY: docker-run
docker-run:
	docker run --rm -p 127.0.0.1:8080:8080 app-go-http-router

.PHONY: go-build
go-build:
	go build main.go

.PHONY: run
run:
	DATABASE_URL="postgres://db_user:db_pass@localhost/the_database?sslmode=disable" ./main
	./main

.PHONY: dev
dev:
	yardman Makefile '*.mod' '*.sum' '*.go' 'make dev-exec'

.PHONY: dev-exec
dev-exec:
	clear
	make go-build
	make run

.PHONY: start
start:
	kubectl apply -f deployment.yml

.PHONY: stop
stop:
	kubectl delete -f deployment.yml

