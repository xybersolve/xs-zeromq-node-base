.PHONY: build clean ssh tag login push pull clean hash archive help list list_
#
# Manage zeromq-node-base image build and archive
#
# include project specifics
include env.mk
#GIT_LONG := $(shell git log -1 --pretty=%H)
GIT_SHORT := $(shell git log -1 --pretty=%h)

# assign docker login from environment, for terminal make
# overwritten by Jenkins credentials, for jenkins make
user := ${DOCKER_USER}
pass := ${DOCKER_PASS}

build: ## Build base image, used across all example sub-projects
	@docker build --tag $(IMAGE) --file ./Dockerfile.base .

ssh: ## SSH into the base image
	@docker run -it --rm $(IMAGE) /bin/bash

tag: ## Tag the base image for deployment to DockerHub
	@docker tag $(IMAGE) $(ORG)/$(IMAGE):$(GIT_SHORT)
	@docker tag $(IMAGE) $(ORG)/$(IMAGE):latest

login: ## Login to docker hub
	# from terminal or Jenkins Credentials
	@docker login -u $(user) -p $(pass)

push:  ## Push to DockerHub, requires prior login
	@docker push $(ORG)/$(IMAGE):$(GIT_SHORT)
	@docker push $(ORG)/$(IMAGE):latest

pull: ## Pull the base image, from docker hub
	@docker pull $(ORG)/$(IMAGE):latest

clean: ## Delete the base image
	#docker rm --force $(CON)
	@docker rmi --force $(IMAGE)

hash: ## Show the shortened git commit hash, used in tag
	@echo $(GIT_TAG)

archive: ## Archive the 'zeromq-base' image
	@docker save -o ../image-archive/$(IMAGE).tar $(IMAGE)

list:
	@sh -c "$(MAKE) -p list_ \
		|  awk -F':' '/^[a-zA-Z0-9][^\$$#\/\\t=]*:([^=]|$$)/ {split(\$$1,A,/ /); \
		for(i in A)print A[i]}' \
		| grep -v '__\$$' \
		| sort"
	#@echo $(MAKEFILE_LIST)

help: ## This help file
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'
