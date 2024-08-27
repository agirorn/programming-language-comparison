# Programming language comparison

## links

[Youtube: C# (.NET) vs. Go (Golang): Performance Benchmark in Kubernetes](https://www.youtube.com/watch?v=56TUfwejKfo)

## Notes

* Need to read the [ConfigureAwait FAQ](https://devblogs.microsoft.com/dotnet/configureawait-faq/)

## dual apps and NGINX Ingresss

This is an excample of using 2 application Kubernetes in 2 diffrent containers
expose bia NGINX Ingress controller.

## Setup

Setup and build the required apps

```bash
make setup
```

## Start

To Start the apps in the Kubernetes cluster

```bash
make start
```

## Build the apps

To build and push the apps to the docker registry run

```bash
make start
```

## Node Exporter not starting on MAc

If the Node Exporter wont start on mac, then you can check if is is running by
running `make node-exporter-status` and its status is __RunContainerError__ then
you might need to patch is and thata can be done with this command.

```
make prometheus-patch:
```

# Notes

## Checking for ingress controller

kubectl get pods -n ingress-nginx

## Installing an ingress controller

You can install an ingress controller for docker=tesktop like so

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

## Exposing the ingress controller 
Docker desktop does not have an installed ingress controller so one hast to be
installed and this is how you install the ingress-nginx

```bash
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace
```

