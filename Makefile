DOCKER_CONTAINER=trueblocks-core
DOCKER_TAG=$(DOCKER_CONTAINER):latest

include .env
ifndef TB_CACHEPATH
$(error "Must set TB_CACHEPATH")
endif
ifndef TB_INDEXPATH
$(error "Must set TB_INDEXPATH")
endif

UPSTREAM_VER=debug


.PHONY: build


all: build


build:
	docker build \
		--build-arg UPSTREAM_VER=$(UPSTREAM_VER) \
		--tag=$(DOCKER_TAG) \
		./build


status: build
	docker rm -f $(DOCKER_CONTAINER)
	docker run \
		--tty \
		--interactive \
		--rm \
		--network "host" \
		--name trueblocks-core \
		--env-file ./.env \
		--publish 8081:8080 \
		-v $(TB_CACHEPATH):/cache \
		-v $(TB_INDEXPATH):/index/unchained \
		$(DOCKER_TAG) chifra status --terse


serve: build
	docker rm -f $(DOCKER_CONTAINER)
	docker run \
		--tty \
		--interactive \
		--rm \
		--network "host" \
		--name trueblocks-core \
		--env-file ./.env \
		--publish 8081:8080 \
		-v $(TB_CACHEPATH):/cache \
		-v $(TB_INDEXPATH):/index/unchained \
		$(DOCKER_TAG) chifra serve --port 0.0.0.0:8080


stop:
	docker stop $(DOCKER_CONTAINER)


logs:
	docker logs -f $(DOCKER_CONTAINER)
