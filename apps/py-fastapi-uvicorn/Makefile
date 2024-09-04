.PHONY: setup
setup:
	pyenv virtualenv 3.10.14 app-py-fastapi-uvicorn || echo "OK"
	echo "app-py-fastapi-uvicorn" > .python-version
	pip install --upgrade -r requirements.txt


.PHONY: build-local
build-local: setup
build-local:
	echo "Build done"

.PHONY: clean
clean:
	go clean -cache

install-python:
	pyenv install 3.10.14


.PHONY: build
build:
	docker build . --tag app-py-fastapi-uvicorn


.PHONY: docker-run
docker-run:
	docker run --rm -p 127.0.0.1:8080:8080 app-py-fastapi-uvicorn

.PHONY: run
run:
	DB_HOST=localhost \
	DB_PORT=5432 \
	DB_USER=db_user \
	DB_PASS=db_pass \
	DB_DATABASE=the_database \
	yardman \
		*.py \
		'clear && uvicorn main:app --port 8082  --lifespan=on'


start:
	kubectl apply -f deployment.yml

stop:
	kubectl delete -f deployment.yml

