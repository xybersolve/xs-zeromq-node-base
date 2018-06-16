#
# Project Specifics
#
ORG := xybersolve
IMAGE := xs-zeromq-node-base
PROJECT := xs-zeromq-node-base

#HOST_NAME := $(shell docker-machine active)
#HOST_IP := $(shell docker-machine ip $(HOST_NAME))
HTTP_PORT := 8080

GIT_SHORT := $(shell git log -1 --pretty=%h)
