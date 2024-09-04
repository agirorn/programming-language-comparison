.PHONY: setup-no-build
setup-no-build:
	make ingress-install
	make ingress-list
	make prometheus-stack-install
	make pg-start
	make app-setup

setup-nats:
	# kubectl apply -f https://github.com/nats-io/nack/releases/latest/download/crds.yml
	helm repo add nats https://nats-io.github.io/k8s/helm/charts/
	helm repo update
	# helm install my-nats nats/nats
	# helm repo add nats https://nats-io.github.io/k8s/helm/charts/
	# helm install nats nats/nats
	# This probblay is not part of the setup
	# helm install nack-jsc nats/nack --set jetstream.nats.url=nats://nats:4222

.PHONY: nats-install
nats-install:
	helm install my-nats nats/nats

.PHONY: nats-get-service
nats-get-service:
	kubectl get service | grep nats

.PHONY: nats-port-forward
nats-port-forward:
	kubectl port-forward svc/ 9090:9090

.PHONY: nats-k-pub
nats-k-pub:
	kubectl exec -it deployment/my-nats-box -- nats pub my-subject "Hello?"

.PHONY: nats-pub
nats-pub:
	nats pub my-subject "Hello?"

.PHONY: nats-k-sub
nats-k-sub:
	kubectl exec -it deployment/my-nats-box -- nats sub my-subject


.PHONY: nats-sub
nats-sub:
	nats sub my-subject

.PHONY: setup
setup: setup-no-build
	echo "Ready to rock"

.PHONY: setup-and-build
setup-and-build:
	make setup-no-build
	make build
	echo "Ready to rock"

.PHONY: start
start:
	make apps-start
	make ingress-start
	echo "All apps should now be loading in Kubernetes"

.PHONY: stop
stop:
	make apps-stop
	make ingress-stop
	echo "All apps should be stopping now"

.PHONY: apps-start
apps-start:
	cd apps && make start

.PHONY: apps-stop
apps-stop:
	cd apps && make stop

.PHONY: apps-hello
apps-hello:
	@ echo "---------------------------------------------"
	@ echo http://localhost/app/js-express-js/hello
	@ curl -i http://localhost/app/js-express-js/hello
	@ echo ""
	@ echo "---------------------------------------------"
	@ echo curl -i http://localhost/app/rust-axum/hello
	@ curl -i http://localhost/app/rust-axum/hello
	@ echo ""
	@ echo "---------------------------------------------"
	@ echo curl -i http://localhost/app/csharp-2/hello
	@ curl -i http://localhost/app/csharp-2/hello
	@ echo ""
	@ echo "---------------------------------------------"
	@ echo curl -i http://localhost/app/go-http-router/hello
	@ curl -i http://localhost/app/go-http-router/hello
	@ echo ""
	@ echo "---------------------------------------------"
	@ echo http://localhost/app/py-fastapi-uvicorn/hello
	@ curl -i http://localhost/app/py-fastapi-uvicorn/hello

.PHONY: clean
clean:
	cd apps && make clean

#
# prometheus-stack-install
#
# https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack
#
# Prometheus Monitoring for Kubernetes Cluster [Tutorial]
# https://spacelift.io/blog/prometheus-kubernetes
#
.PHONY: prometheus-stack-install
prometheus-stack-install:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update
	helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack
	./bin/patch-prometheus-node-exporter


.PHONY: node-exporter-status
node-exporter-status:
	kubectl get pods | rg kube-prometheus-stack-prometheus-node-exporter

#
# This may be needed to get things running in docker-desktop see:
# https://github.com/prometheus-operator/kube-prometheus/discussions/790
#
.PHONY: prometheus-patch
prometheus-patch:
	kubectl patch ds kube-prometheus-stack-prometheus-node-exporter --type "json" -p '[{"op": "remove", "path" : "/spec/template/spec/containers/0/volumeMounts/2/mountPropagation"}]'

.PHONY: prometheus-port-forward
prometheus-port-forward:
	kubectl port-forward svc/kube-prometheus-stack-prometheus 9090:9090

.PHONY: prometheus-web
prometheus-web:
	open http://localhost:9090/graph?g0.expr=learn_with_pratap%7B%7D%5B5m%5D%0A&g0.tab=1&g0.stacked=0&g0.show_exemplars=0&g0.range_input=1h

.PHONY: prom-cpu-usage-per-pod
prom-cpu-usage-per-pod:
	open "http://localhost:9090/graph?g0.expr=max(rate(container_cpu_usage_seconds_total%7Bpod%3D~%22app.*%22%7D%5B5m%5D))%20by%20(pod)&g0.tab=0&g0.display_mode=stacked&g0.show_exemplars=0&g0.range_input=1h"

.PHONY: grafana-port-forward
grafana-port-forward:
	kubectl port-forward svc/kube-prometheus-stack-grafana 10000:80

.PHONY: grafana-web
grafana-web:
	open http://localhost:10000

.PHONY: grafana-template
grafana-template:
	cat grafana-templates/pod-resource-usage.json| pbcopy

#
# ingress
#
.PHONY: ingress-install
ingress-install:
	helm upgrade \
		--install ingress-nginx ingress-nginx \
		--repo https://kubernetes.github.io/ingress-nginx \
		--namespace ingress-nginx --create-namespace

.PHONY: ingress-check
ingress-check:
		helm list --namespace ingress-nginx

.PHONY: ingress-list
ingress-list:
	 kubectl get ingress

.PHONY: ingress-describe
ingress-describe:
	# kubectl describe ingress example-ingress-1
	kubectl describe ingress example-ingress-2

.PHONY: app-setup
app-setup:
	cd apps && make setup

.PHONY: build
build:
	cd apps && make build

.PHONY: build-local
build-local:
	cd apps && make build-local

#
# postgres
#
.PHONY: x
pg-start:
	kubectl apply -f postgres.deployment.yaml

.PHONY: x
pg-stop:
	kubectl delete -f postgres.deployment.yaml

pg-port-forward:
	kubectl port-forward postgres-0 5432:5432

.PHONY: psql
psql:
	PGPASSWORD=db_pass psql -U db_user -h localhost -p 5432 the_database

.PHONY: db-clean
db-clean:
	cat apps/flyway-migrations/scripts/clean.sql | make psql

.PHONEY: db-count
db-count:
	cat apps/flyway-migrations/scripts/count.sql | make psql

.PHONEY: db-select-all
db-select-all:
	cat apps/flyway-migrations/scripts/select-all.sql | make psql

.PHONY: pg-migrate
pg-migrate:
	cd apps/flyway-migrations && make start

#
# app-root
#
app-root-apply:
	kubectl apply -f app-root/deployment.yml

app-root-delete:
	kubectl delete -f app-root/deployment.yml

app-root-log:
	kubectl logs app-root -f

#
# app1
#
app-1-apply:
	kubectl apply -f app1/deployment.yml

app-1-delete:
	kubectl delete -f app1/deployment.yml

app-1-log:
	kubectl logs app1 -f

#
# app2
#
app-2-apply:
	kubectl apply -f app2/deployment.yml

app-2-delete:
	kubectl delete -f app2/deployment.yml

app-2-log:
	kubectl logs app1 -f

#
# app-wurly
#
app-wurly-apply:
	kubectl apply -f curly-wurly/wurly/deployment.yml

app-wurly-delete:
	kubectl delete -f curly-wurly/wurly/deployment.yml

app-wurly-log:
	kubectl logs app-wurly -f

#
# app-curly
#
app-curly-apply:
	kubectl apply -f curly-wurly/curly/deployment.yml

app-curly-delete:
	kubectl delete -f curly-wurly/curly/deployment.yml

app-curly-log:
	kubectl logs app-wurly -f

#
# migrations
#
.PHONY: migrations-apply
migrations-apply:
	kubectl apply -f migrations/deployment.yml

.PHONY: migrations-delete
migrations-delete:
	kubectl delete -f migrations/deployment.yml


.PHONY: migrations-run
migrations-run:
	cd migrations \
		&& make build \
		&& cd - \
		&& make migrations-delete \
		&& sleep 1 \
		&& make migrations-apply

#
# app-js-express-js
#
app-js-express-js-apply:
	kubectl apply -f apps/js-express-js/deployment.yml

app-js-express-js-delete:
	kubectl delete -f apps/js-express-js/deployment.yml

#
# app-csharp
#
app-csharp-apply:
	kubectl apply -f apps/csharp/deployment.yml

app-csharp-delete:
	kubectl delete -f apps/csharp/deployment.yml

#
# ingress
#
ingress-start:
	kubectl apply -f ingress.yaml

ingress-stop:
	kubectl delete -f ingress.yaml

curl-curly:
	time -p curl -s localhost:80/curly | jq .
	# time -p curl -s localhost:80/curly | jq '. |.app,.url'

curl-root:
	time -p curl -s localhost:80/extra | jq '. |.app,.url'
	time -p curl -s localhost:80/extra | jq '. |.app,.url'

curl-root-raw:
	@curl -i localhost:80/extra

curl-app-1:
	@curl -s localhost:80/app1/extra | jq '. |.app,.url'
	@curl -s localhost:80/app-1/extra | jq '. |.app,.url'

curl-app-1-raw:
	@curl -i localhost:80/app1/extra
	@curl -i localhost:80/app-1/extra

curl-app-2:
	@curl -s localhost:80/app2/extra | jq '. |.app,.url'
	@curl -s localhost:80/app-2/extra | jq '. |.app,.url'

curl-app-2-raw:
	@curl -is localhost:80/app2/extra
	@curl -is localhost:80/app-2/extra

.PHONY: load-1
load-1:
	./bin/load curl-app-1

.PHONY: load-2
load-2:
	./bin/load curl-app-2

.PHONY: load-root
load-root:
	./bin/load curl-root
