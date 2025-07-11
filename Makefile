.PHONY: help build up nvim shell docker-clean orphans logs config-dir

help: ## Show this help message
	@echo "Available commands:"; \
	awk 'BEGIN {FS = ":.*?## "}; /^[a-zA-Z0-9_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## Build the Docker image (no cache)
	docker build --no-cache -t nvim-lua .

up: ## Start Neovim directly in the container
	docker compose run --rm nvim-service

nvim: ## Open Neovim directly in the container
	docker compose run --rm nvim-service nvim

shell: ## Open a bash shell in the container
	docker compose run --rm nvim-service bash

docker-clean: ## Remove the Docker image
	docker rmi -f nvim-lua || true

orphans: ## Remove orphan containers
	docker compose up --remove-orphans

logs: ## Show container logs (if using docker compose up)
	docker compose logs -f

config-dir: ## Create the local config directory if it does not exist
	mkdir -p nvim_config

.DEFAULT_GOAL := help 