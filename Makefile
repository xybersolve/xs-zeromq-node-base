.PHONY: build clean ssh tag push pull clean hash archive help
#
# For managing the zeromq-base image
#
org := xybersolve
base_image := zeromq-base:latest
project := xs-zeromq
git_hash := $(shell git rev-parse HEAD)
# beginning of commit hash, is all we really need
git_start := $(shell echo $(git_hash) | cut -c1-7)
#git_start := $(shell ${githash:0:5})

build: ## Build base image, used across all example sub-projects
	docker build --tag $(base_image) --file ./Dockerfile.base .

ssh: ## SSH into the base image
	docker run -it --rm $(base_image) /bin/bash

tag: ## Tag the base image for deployment to DockerHub
	#@docker tag $(base_image) $(org)/$(base_image):$(git_start)
	docker tag $(base_image) $(org)/$(base_image)

push: ## Push to DockerHub, requires prior login
	#@docker push $(org)/$(base_image):$(git_start)
	docker push $(org)/$(base_image)

pull: ## Pull the base image, from docker hub
	docker pull $(org)/$(base_image)

clean: ## Delete the base image
	#docker rm --force $(con)
	docker rmi --force $(base_image)

hash: ## Show the shortened git commit hash, used in tag
	@echo $(git_start)

archive: ## Archive the 'zeromq-base' image
	docker save -o ../image-archive/zeromq-base.tar zeromq-base

help: ## This help file
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'
