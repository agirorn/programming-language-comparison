.PHONY: setup
setup:
	dotnet restore api.csproj

.PHONY: build
build:
	docker build . --tag app-csharp-3-api

.PHONY: start
start:
	kubectl apply -f deployment.yml

.PHONY: stop
stop:
	kubectl delete -f deployment.yml

.PHONY: swagger
swagger:
	open http://localhost:5228/swagger
