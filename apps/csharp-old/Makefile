# start:
# 	docker compose -p csharp -f docker-compose-run.yaml up
#
# build:
# 	make build-cvs
# 	make build-api
#
# build-cvs:
# 	docker build -f Dockerfile.svc . --tag momo/cvs
#
# build-api:
# 	docker build -f Dockerfile.api . --tag momo/api

format:
	cd src/api && dotnet format
	cd src/svc && dotnet format
	cd tests && dotnet format

format-check:
	cd src/api && dotnet format --verify-no-changes
	cd src/svc && dotnet format --verify-no-changes
	cd tests && dotnet format --verify-no-changes
