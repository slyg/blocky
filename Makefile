.DEFAULT_GOAL = build
.BUILD_IMAGE_NAME = slyg/blocky-game-build
.RUNTIME_IMAGE_NAME = slyg/blocky-game
.DEV_CMD = docker run -it --rm \
	-p 8000:8000 \
	-v $(PWD)/build:/www/build \
	-v $(PWD)/src:/www/src \
	-v $(PWD)/tests:/www/tests \
	$(.BUILD_IMAGE_NAME) 
.GREEN = \033[0;32m
.YELLOW = \033[0;33m
.NC = \033[0m

help:
	@echo ""
	@echo "Blocky game"
	@echo "==========="
	@echo ""
	@echo "Available commands :"
	@echo ""
	@echo "  make \t\t\talias for make build"
	@echo "  make build \t\tbuilds projects as a docker image ($(.RUNTIME_IMAGE_NAME))"
	@echo "  make test \t\truns unit tests"
	@echo "  make serve \t\truns a $(.RUNTIME_IMAGE_NAME) container exposing port 8080 (http://localhost:8080)"
	@echo ""

build-image: 
	docker build \
		-f env/Dockerfile.build \
		-t $(.BUILD_IMAGE_NAME) \
		.

build: build-image
	$(.DEV_CMD) elm make src/Main.elm --output build/index.html
	@echo "$(.GREEN)Build artifacts created in /build$(.NC)"
	docker build -f env/Dockerfile -t $(.RUNTIME_IMAGE_NAME) .

dev: build-image
	$(.DEV_CMD) elm reactor

test: build-image
	@echo "$(.YELLOW)Running tests$(.NC)"
	$(.DEV_CMD) elm test

serve:
	@echo "$(.YELLOW)Serving app on http://localhost:8080$(.NC)"
	docker run -p 8080:80 $(.RUNTIME_IMAGE_NAME)

.PHONY: help build-image build dev test serve