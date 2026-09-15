# Interface única do projeto. Pré-requisito no host: Docker (com o plugin compose).
# Nada de Node, pnpm, Dart ou Flutter fora dos containers.
SHELL := /bin/sh
.DEFAULT_GOAL := help

# Containers de dev rodam com o seu uid/gid: arquivos criados no bind mount são seus.
export HOST_UID ?= $(shell id -u)
export HOST_GID ?= $(shell id -g)

COMPOSE      := docker compose
COMPOSE_PROD := docker compose -f docker-compose.yml -f docker-compose.prod.yml
API_RUN      := $(COMPOSE) run --rm -T api           # sobe o db (depends_on)
API_TOOL     := $(COMPOSE) run --rm -T --no-deps api # sem banco
APP          := $(COMPOSE) --profile app run --rm app

.PHONY: help setup up down restart logs ps clean \
        api-sh api-install api-generate api-lint api-format api-build api-test api-e2e migrate migrate-deploy migrate-status seed openapi openapi-check \
        app-sh app-gen app-gen-check app-analyze app-test app-build-web app-android \
        check build-web build-apk-dev build-apk build-aab prod-up prod-down prod-logs

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

app-gen-check: ## falha se app/lib/api estiver desatualizado em relação ao contrato
	$(MAKE) app-gen
	git diff --exit-code -- app/lib/api

## ---------- app (flutter) ----------
app-sh: ## bash no toolchain flutter
	$(APP) bash

app-gen: ## gera cliente dart (api/openapi.json → lib/api; multipart fica à mão) e l10n
	cp api/openapi.json app/openapi.source.json
	$(APP) sh -c "dart run tool/prepare_openapi.dart openapi.source.json openapi.json && dart run swagger_parser && dart run build_runner build -d && flutter gen-l10n"

app-analyze: ## flutter analyze (gera l10n antes)
	$(APP) sh -c "flutter gen-l10n && flutter analyze"

app-test: ## flutter test
	$(APP) flutter test

app-build-web: ## flutter build web (release, mesma origem)
	$(APP) flutter build web --release

app-android: ## roda no dispositivo: make app-android DEVICE=<id> API_BASE_URL=http://<ip-da-maquina>
	$(APP) flutter run -d $(DEVICE) --dart-define=API_BASE_URL=$(API_BASE_URL)

## ---------- verificação (o que o CI roda) ----------
check: api-lint api-build api-test api-e2e openapi-check app-gen-check app-analyze app-test ## api: lint + build + unit + e2e + contrato · app: cliente em dia + analyze + test

## ---------- release ----------
build-web: ## imagem do edge com o flutter web embutido
	$(COMPOSE_PROD) build edge

build-apk-dev: ## apk de DEBUG para testar na rede local (aceita http): make build-apk-dev API_BASE_URL=http://<ip-da-maquina>
	@test -n "$(API_BASE_URL)" || (echo "uso: make build-apk-dev API_BASE_URL=http://<ip-da-maquina>" && exit 1)
	$(APP) flutter build apk --debug --dart-define=API_BASE_URL=$(API_BASE_URL)
	@echo "apk: app/build/app/outputs/flutter-apk/app-debug.apk"

build-apk: ## apk release (assinatura de debug): make build-apk API_BASE_URL=https://<dominio>
	$(APP) flutter build apk --release --dart-define=API_BASE_URL=$(API_BASE_URL)

build-aab: ## android app bundle: make build-aab API_BASE_URL=https://<dominio>
	$(APP) flutter build appbundle --dart-define=API_BASE_URL=$(API_BASE_URL)

prod-up: ## sobe prod (build + migrate no entrypoint)
	$(COMPOSE_PROD) up -d --build

prod-down: ## derruba prod (mantém volumes)
	$(COMPOSE_PROD) down

prod-logs: ## logs de prod
	$(COMPOSE_PROD) logs -f --tail=100
