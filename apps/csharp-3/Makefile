.PHONY: setup
setup:
	dotnet restore api.csproj

.PHONY: build
build:
	dotnet publish ./api.csproj \
		--output ./published-app \
		--configuration Release \
		 -r linux-x64 \
		 --self-contained true



.PHONY: build-local
build-local:
	make setup
	dotnet build

.PHONY: start
start:
	kubectl apply -f deployment.yml

.PHONY: stop
stop:
	kubectl delete -f deployment.yml

.PHONY: swagger
swagger:
	open http://localhost:5228/swagger
