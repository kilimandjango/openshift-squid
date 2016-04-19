IMAGE_NAME = squid-openshift

build:
	docker build -t $(IMAGE_NAME) .
