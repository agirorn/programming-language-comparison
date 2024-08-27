.PHONY: setup
setup:
	pyenv virtualenv 3.10.14 app-py-fastapi || echo "OK"
	echo "app-py-fastapi" > .python-version

install-python:
	pyenv install 3.10.14


.PHONY: build
build:
	docker build . --tag app-py-fastapi


.PHONY: docker-run
docker-run:
	docker run --rm -p 127.0.0.1:8080:8080 app-py-fastapi

start:
	kubectl apply -f deployment.yml

stop:
	kubectl delete -f deployment.yml

