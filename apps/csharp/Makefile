.PHONY: setup
setup:
	dotnet restore my-api.csproj

.PHONY: build-local
build-local: setup
build-local:
	dotnet build "./my-api.csproj" -c Release
	echo "Build done"

.PHONY: clean
clean:
	dotnet clean
	rm -rf obj bin

.PHONY: build
build:
	docker build . --tag app-csharp

.PHONY: docker-run
docker-run:
	docker run --rm -p 127.0.0.1:8888:8080 app-csharp

start:
	kubectl apply -f deployment.yml

stop:
	kubectl delete -f deployment.yml

