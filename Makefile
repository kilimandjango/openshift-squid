IMAGE_NAME = squid-centos7

build:
	docker build -t $(IMAGE_NAME) .
