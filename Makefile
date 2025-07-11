.PHONY: help build up shell docker-clean orphans logs config-dir

help:
	@echo "Comandos disponibles para el entorno Neovim Docker:"
	@echo "  make build        - Construye la imagen Docker (sin caché)"
	@echo "  make up           - Arranca Neovim directamente en el contenedor"
	@echo "  make nvim         - Abre Neovim directamente en el contenedor"
	@echo "  make shell        - Abre una shell bash en el contenedor"
	@echo "  make docker-clean - Elimina la imagen Docker"
	@echo "  make orphans      - Elimina contenedores huérfanos"
	@echo "  make logs         - Muestra los logs del contenedor (si usas docker compose up)"
	@echo "  make config-dir   - Crea la carpeta de configuración local si no existe"

.DEFAULT_GOAL := help

build:
	docker build --no-cache -t nvim-lua .

shell:
	docker compose run --rm nvim-service bash

up:
	docker compose run --rm nvim-service

docker-clean:
	docker rmi -f nvim-lua || true

orphans:
	docker compose up --remove-orphans

logs:
	docker compose logs -f

config-dir:
	mkdir -p nvim_config 

nvim:
	docker compose run --rm nvim-service nvim 