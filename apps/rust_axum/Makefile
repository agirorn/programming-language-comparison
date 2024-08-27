.PHONY: setup
setup:
	echo "No op"

.PHONY: prep
prep:
	cargo sqlx prepare

.PHONY: build
build:
	docker build . --tag app-rust-axum

.PHONY: docker-run
docker-run:
	docker run --rm -p 127.0.0.1:8080:8080 app-rust-axum

.PHONY: start
start:
	kubectl apply -f deployment.yml

.PHONY: stop
stop:
	kubectl delete -f deployment.yml

.PHONY: dev
dev:
	cargo watch -s 'make dev-exec'

.PHONY: dev-exec
dev-exec:
	clear
	cargo build
	clear
	cargo run

#
# dev-docker:
# 	yardman \
# 		Makefile \
# 		Dockerfile \
# 		package.json \
# 		src \
# 		'clear && make build'
#
#
# build:
# 	docker build -t nodejs-service .
# 	docker run -it nodejs-service ls -R
#
# shell:
# 	docker run -it nodejs-service sh
#
# start:
# 	docker compose --project-name rust up
#
# clean:
# 	docker system prune --volumes --force
#
#
# hellow-world:
# 	curl -X GET http://localhost:3000/hello-world
#
# save:
# 	curl -H "Content-Type: application/json" -d "@../../post.json" -X POST http://localhost:3000/save
