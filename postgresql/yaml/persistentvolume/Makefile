.PHONY: namespace-create
namespace-create:
	kubectl apply -f namespaces.yaml

.PHONY: namespace-delete
namespace-delete:
	kubectl delete -f namespaces.yaml

.PHONY: pg-no-pv
pg-no-pv:
	kubectl apply -f postgres-no-pv.yaml

.PHONY: pg-no-pv-delete
pg-no-pv-delete:
	kubectl delete -f postgres-no-pv.yaml

.PHONY: pg-no-pv-port-forward-forward
pg-no-pv-port-forward:
	kubectl port-forward -n postgres-no-pv postgres-0 5432:5432


.PHONY: pg-with-pv
pg-with-pv:
	kubectl apply -f postgres-with-pv.yaml

.PHONY: pg-with-pv-delete
pg-with-pv-delete:
	kubectl delete -f postgres-with-pv.yaml

.PHONY: pg-with-pv-port-forward-forward
pg-with-pv-port-forward:
	kubectl port-forward -n postgres-with-pv postgres-0 5432:5432


.PHONY: persistent-volume-claim
persistent-volume-claim:
	kubectl apply -f persistent-volume-claim.yaml

.PHONY: persistent-volume-claim-delete
persistent-volume-claim-delete:
	kubectl delete -f persistent-volume-claim.yaml

.PHONY: persistent-volume
persistent-volume:
	kubectl apply -f persistent-volume.yaml

.PHONY: persistent-volume-delete
persistent-volume-delete:
	kubectl delete -f persistent-volume.yaml

.PHONY: psql
psql:
	PGPASSWORD=admin psql -U admin -h localhost -p 5432 admin_db
	# PGPASSWORD=admin psql -U admin -h localhost -p 5432 postgres
