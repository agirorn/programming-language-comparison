.PHONY: setup
setup:
	dotnet restore api.csproj

.PHONY: build-local
build-local: setup
build-local:
	dotnet publish ./api.csproj \
		--output published-app \
		--configuration Release
	echo "Build done"

.PHONY: clean
clean:
	dotnet clean
	dotnet clean --configuration Release
	rm -rf obj bin published-app

.PHONY: build
build:
	docker build . --tag app-csharp-2-api

.PHONY: start
start:
	kubectl apply -f deployment.yml

.PHONY: stop
stop:
	kubectl delete -f deployment.yml

.PHONY: swagger
swagger:
	open http://localhost:5228/swagger
