.PHONY: clean build test tag login push deploy \
	ssh pull repo archive help list list_
#
# Manage zeromq-node-base image build and archive
#  - reusable Makefile, with env.mk defining specifics
#
# TODO: Test build
#
include env.mk
include info.mk
include check.mk

#GIT_LONG := $(shell git log -1 --pretty=%H)
GIT_SHORT := $(shell git log -1 --pretty=%h)

# assign docker login from environment, for terminal make
# overwritten by Jenkins credentials, for jenkins make
user := ${DOCKER_USER}
pass := ${DOCKER_PASS}
#
# -------------------------------------------
# Jenkins routines start here
#   * docker only Jenkins routines
#
clean: ## Delete the base image
	${INFO} "Clean image cache..."
	#docker rm --force $(CON)
	@docker rmi --force $(IMAGE)

build: ## Build base image, used across all example sub-projects
	${INFO} "Building base image..."
	@docker build --tag $(IMAGE) --file ./Dockerfile.base .

test:
	echo "Unit & smoke test here..."

tag: ## Tag the base image for deployment to DockerHub
	${INFO} "Tagging base image..."
	@docker tag $(IMAGE) $(ORG)/$(IMAGE):$(GIT_SHORT)
	@docker tag $(IMAGE) $(ORG)/$(IMAGE):latest

login: ## Login to docker hub
	${INFO} "Logging into DockerHub..."
	# from terminal or Jenkins Credentials
	#@docker login -u $(user) -p $(pass)
	@docker login -u $(DOCKER_USER) -p $(DOCKER_PASSWORD)

push:  ## Push to DockerHub, requires prior login
	${INFO} "Push"
	@docker push $(ORG)/$(IMAGE):$(GIT_SHORT)
	@docker push $(ORG)/$(IMAGE):latest

deploy: build tag login push ## Build and deploy to DockerHub


#
# Jenkins routines end here
# -------------------------------------------
#
ssh: ## SSH into the base image
	${INFO} "SSH into base image..."
	#@docker run -it --rm $(IMAGE) /bin/bash
	@docker run -it --rm $(ORG)/$(IMAGE):latest /bin/bash

pull: ## Pull the base image, from docker hub
	${INFO} "Pull latest base image..."
	@docker pull $(ORG)/$(IMAGE):latest

test: ## Run tests
	${INFO} "Testing something or other..."
	@echo "Run our tests"


repo: ## Show the shortened git commit hash, used in tag
	${INFO} "Base image repo tagged name..."
	@echo $(ORG)/$(IMAGE):$(GIT_SHORT)
	@echo $(ORG)/$(IMAGE):latest

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
