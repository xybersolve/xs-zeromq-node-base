.PHONY: build clean ssh tag login push pull clean hash archive help
#
# Manage zeromq-node-base image build and archive
#
org := xybersolve
# base_image := zeromq-node-base:latest
base_image := zeromq-base
project := zeromq-node-base
git_hash := $(shell git rev-parse HEAD)
# beginning of commit hash, is all we need
git_short := $(shell echo $(git_hash) | cut -c1-7)
# full or abbreviated version of git hash
git_tag := $(git_hash)

build: ## Build base image, used across all example sub-projects
	@docker build --tag $(base_image) --file ./Dockerfile.base .

ssh: ## SSH into the base image
	@docker run -it --rm $(base_image) /bin/bash

tag: ## Tag the base image for deployment to DockerHub
	@docker tag $(base_image) $(org)/$(base_image):$(git_tag)
	@docker tag $(base_image) $(org)/$(base_image):latest

login: ## login to docker hub
	@docker login -u ${DOCKER_USER} -p ${DOCKER_PASS} #${DOCKER_HOST}
	#@docker login --username=$DOCKER_USER --password=$DOCKER_PASS

push: login ## Push to DockerHub, requires prior login
	@docker push $(org)/$(base_image):$(git_tag)
	@docker push $(org)/$(base_image):latest

pull: ## Pull the base image, from docker hub
	@docker pull $(org)/$(base_image):latest

clean: ## Delete the base image
	#docker rm --force $(con)
	@docker rmi --force $(base_image)

hash: ## Show the shortened git commit hash, used in tag
	@echo $(git_start)

archive: ## Archive the 'zeromq-base' image
	@docker save -o ../image-archive/$(base_image).tar $(base_image)

help: ## This help file
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'
