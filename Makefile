# Interface única do projeto. Pré-requisito no host: Docker (com o plugin compose).
# Nada de Node, pnpm, Dart ou Flutter fora dos containers.
SHELL := /bin/sh
.DEFAULT_GOAL := help

COMPOSE      := docker compose
COMPOSE_PROD := docker compose -f docker-compose.yml -f docker-compose.prod.yml
API_RUN      := $(COMPOSE) run --rm -T api           # sobe o db (depends_on)
API_TOOL     := $(COMPOSE) run --rm -T --no-deps api # sem banco
APP          := $(COMPOSE) --profile app run --rm app

.PHONY: help setup up down restart logs ps clean \
        api-sh api-install api-generate api-lint api-format api-build api-test api-e2e migrate migrate-deploy migrate-status seed openapi openapi-check \
        app-sh app-gen app-test app-android \
        check build-web build-aab prod-up prod-down prod-logs

help: ## lista os alvos
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'

## ---------- ciclo de vida (dev) ----------
setup: ## primeira vez: .env, imagens, deps, migrations, seed
	@test -f .env || (cp .env.example .env && echo ".env criado a partir de .env.example — revise os segredos")
	$(COMPOSE) build db api edge
	$(API_TOOL) pnpm install
	$(MAKE) api-generate migrate-deploy seed
	@echo "pronto: make up  →  http://localhost/api/v1/health"

up: ## sobe db, api e edge (dev, com watch)
	$(COMPOSE) up -d db api edge

down: ## derruba tudo (mantém volumes)
	$(COMPOSE) --profile app down

restart: ## reinicia a api
	$(COMPOSE) restart api

logs: ## segue os logs
	$(COMPOSE) logs -f --tail=100

ps: ## estado dos serviços
	$(COMPOSE) ps

clean: ## derruba tudo E apaga volumes (banco, uploads, caches)
	$(COMPOSE) --profile app down -v

## ---------- api ----------
api-sh: ## shell no container da api
	$(COMPOSE) run --rm --no-deps api sh

api-install: ## pnpm install (node_modules no bind mount)
	$(API_TOOL) pnpm install

api-lint: ## oxlint + prettier --check
	$(API_TOOL) pnpm lint

api-format: ## prettier --write
	$(API_TOOL) pnpm format

api-build: ## nest build
	$(API_TOOL) pnpm build

api-test: ## testes unitários
	$(API_TOOL) pnpm test

api-e2e: ## testes e2e (sobe o banco; usa portfolio_test)
	$(API_RUN) pnpm test:e2e

api-generate: ## regenera o cliente prisma (src/generated)
	$(API_TOOL) pnpm prisma generate

migrate: ## cria/aplica migration em dev e regenera o cliente: make migrate NAME=descricao
	@test -n "$(NAME)" || (echo "uso: make migrate NAME=descricao" && exit 1)
	$(API_RUN) pnpm prisma migrate dev --name $(NAME)
	$(MAKE) api-generate

migrate-deploy: ## aplica migrations pendentes (sem criar)
	$(API_RUN) pnpm prisma migrate deploy

migrate-status: ## estado das migrations
	$(API_RUN) pnpm prisma migrate status

seed: ## seed idempotente (admin via ADMIN_EMAIL/ADMIN_PASSWORD)
	$(API_RUN) pnpm prisma db seed

openapi: ## emite api/openapi.json
	$(API_TOOL) pnpm openapi:emit

openapi-check: ## falha se api/openapi.json estiver desatualizado
	$(MAKE) openapi
	git diff --exit-code -- api/openapi.json

## ---------- app (flutter) ----------
app-sh: ## bash no toolchain flutter
	$(APP) bash

app-gen: ## gera o cliente dart a partir de api/openapi.json
	cp api/openapi.json app/openapi.json
	$(APP) sh -c "dart run swagger_parser && dart run build_runner build -d"

app-test: ## flutter test
	$(APP) flutter test

app-android: ## roda no dispositivo: make app-android DEVICE=<id> API_BASE_URL=http://<ip>/api/v1
	$(APP) flutter run -d $(DEVICE) --dart-define=API_BASE_URL=$(API_BASE_URL)

## ---------- verificação (o que o CI roda) ----------
check: api-lint api-build api-test api-e2e openapi-check ## lint + build + unit + e2e + contrato em dia

## ---------- release ----------
build-web: ## imagem do edge com o flutter web embutido
	$(COMPOSE_PROD) build edge

build-aab: ## android app bundle: make build-aab API_BASE_URL=https://<dominio>/api/v1
	$(APP) flutter build appbundle --dart-define=API_BASE_URL=$(API_BASE_URL)

prod-up: ## sobe prod (build + migrate no entrypoint)
	$(COMPOSE_PROD) up -d --build

prod-down: ## derruba prod (mantém volumes)
	$(COMPOSE_PROD) down

prod-logs: ## logs de prod
	$(COMPOSE_PROD) logs -f --tail=100
