.PHONY: test
test:
	echo test

.PHONY: start
start:
	kubectl apply -f deployment/postgresql-deployment.yml
	kubectl apply -f service/postgresql-service.yml
	kubectl apply -f configs/postgresql-pv.yml
	kubectl apply -f configs/postgresql-pvc.yml
	kubectl apply -f configs/postgresql-secret.yml

.PHONY: namespace-create
namespace-create:
	kubectl create ns postgresql

.PHONY: secret-create
secret-create:
	kubectl -n postgresql create secret generic postgresql \
		--from-literal POSTGRES_USER="postgresadmin" \
		--from-literal POSTGRES_PASSWORD='admin123' \
		--from-literal POSTGRES_DB="postgresdb" \
		--from-literal REPLICATION_USER="replicationuser" \
		--from-literal REPLICATION_PASSWORD='replicationPassword'

.PHONY: pg-deploy
pg-deploy:
	kubectl -n postgresql apply -f yaml/statefulset.yml
