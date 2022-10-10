PROJECT_NAME = faers-app
VOLUMES = -v "${CURDIR}/data:/home/faers-app/data" -v "${CURDIR}/src:/home/faers-app/src" -v "${CURDIR}/app:/home/faers-app/app"

.PHONY: help clean app

help: ## print this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

.docker-buildstamp: Dockerfile ## build the image
	docker build -t $(PROJECT_NAME) .
	touch .docker-buildstamp

interactive: .docker-buildstamp ## launch the container and start an interactive bash shell
	docker run -ti --rm $(VOLUMES) $(PROJECT_NAME) /bin/bash

clean: ## cleans up data/ and removes the docker image
	find . -name "*.zip" -type f -delete
	find . -name "*.duckdb" -type f -delete
	find . -name ".docker-buildstamp" -type f -delete

data/faers_ascii_20%.zip: .docker-buildstamp
	docker run --rm $(VOLUMES) $(PROJECT_NAME) Rscript src/download_data.R $*

data/faers.duckdb: data/faers_ascii_2022q2.zip
	docker run --rm $(VOLUMES) $(PROJECT_NAME) Rscript src/create_database.R

app: data/faers.duckdb ## launches the app at port 8080
	docker run $(VOLUMES) -ti -p 3838:3838 $(PROJECT_NAME)
