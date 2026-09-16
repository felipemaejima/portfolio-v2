# Interface única do projeto. Pré-requisito no host: Docker (com o plugin compose) e make.
# Nada de Node, pnpm, Dart ou Flutter fora dos containers (ADR 0005).
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
APP_T        := $(COMPOSE) --profile app run --rm -T app
BACKUPS      := backups
STAMP        := $(shell date +%Y%m%d-%H%M%S)

.PHONY: help setup secret \
        up down restart logs ps clean dev app-dev app-dev-stop app-dev-attach \
        api-sh api-install api-generate api-lint api-format api-build api-test api-e2e api-logs api-outdated \
        migrate migrate-deploy migrate-status seed openapi openapi-check \
        db-shell db-backup db-restore uploads-backup uploads-restore \
        app-sh app-install app-gen app-gen-check app-analyze app-format app-test app-build-web app-clean app-outdated \
        build-apk-dev build-apk build-aab app-android \
        check check-api check-app \
        prod-build prod-up prod-down prod-restart prod-logs prod-ps prod-migrate-status

help: ## lista os alvos, por seção
	@awk 'BEGIN {FS = ":.*?## "} \
	  /^## ---/ { t = $$0; sub(/^## --- /, "", t); sub(/ ---$$/, "", t); printf "\n\033[1m%s\033[0m\n", t; next } \
	  /^[a-zA-Z0-9_-]+:.*?## / { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

## --- primeira vez ---
setup: ## .env (com segredo JWT gerado), imagens, deps, cliente prisma, migrations, seed
	@test -f .env || (cp .env.example .env && echo ".env criado a partir de .env.example")
	$(COMPOSE) build db api edge
	$(API_TOOL) pnpm install
	@grep -q '^JWT_ACCESS_SECRET=troque' .env && { \
	  S=$$($(API_TOOL) node -e "process.stdout.write(require('crypto').randomBytes(48).toString('base64url'))" | tail -c 64); \
	  sed -i.bak "s|^JWT_ACCESS_SECRET=.*|JWT_ACCESS_SECRET=$$S|" .env && rm -f .env.bak && echo "JWT_ACCESS_SECRET gerado no .env"; } || true
	$(MAKE) api-generate migrate-deploy seed
	@echo
	@echo "pronto. próximos passos:"
	@echo "  make up          → API em http://localhost/api/v1/health · Swagger em http://localhost/api/docs"
	@echo "  make dev         → o mesmo + Flutter Web em http://localhost/"
	@echo "  revise ADMIN_EMAIL / ADMIN_PASSWORD no .env (e rode make seed de novo se mudar)"

secret: ## imprime um segredo aleatório (para JWT_ACCESS_SECRET ou ADMIN_PASSWORD)
	@$(API_TOOL) node -e "process.stdout.write(require('crypto').randomBytes(48).toString('base64url') + '\n')" | tail -1

## --- dev: ciclo de vida ---
up: ## sobe db, api (watch) e edge — http://localhost
	$(COMPOSE) up -d db api edge

down: ## derruba tudo (mantém volumes: banco, uploads, caches)
	$(COMPOSE) --profile app down

restart: ## reinicia a api (ex.: após mudar o .env)
	$(COMPOSE) restart api

logs: ## segue os logs de tudo
	$(COMPOSE) logs -f --tail=100

ps: ## estado dos serviços
	$(COMPOSE) --profile app ps

clean: ## derruba tudo E apaga volumes (banco, uploads, caches) — irreversível
	$(COMPOSE) --profile app down -v

dev: up app-dev ## sobe API + dev server do Flutter Web (http://localhost/)

app-dev: ## dev server do Flutter Web atrás do Caddy (http://localhost/); hot reload: make app-dev-attach
	$(COMPOSE) --profile app up -d app

app-dev-stop: ## para o dev server do Flutter
	$(COMPOSE) --profile app stop app

app-dev-attach: ## terminal do dev server: r = hot reload, R = restart, q = sair
	$(COMPOSE) --profile app attach app

## --- api ---
api-sh: ## shell no container da api
	$(COMPOSE) run --rm --no-deps api sh

api-install: ## pnpm install (node_modules no bind mount)
	$(API_TOOL) pnpm install

api-generate: ## regenera o cliente prisma (src/generated)
	$(API_TOOL) pnpm prisma generate

api-lint: ## oxlint + prettier --check
	$(API_TOOL) pnpm lint

api-format: ## prettier --write
	$(API_TOOL) pnpm format

api-build: ## nest build (type-check completo)
	$(API_TOOL) pnpm build

api-test: ## testes unitários (vitest)
	$(API_TOOL) pnpm test

api-e2e: ## testes e2e contra o Postgres do compose (banco portfolio_test)
	$(API_RUN) pnpm test:e2e

api-logs: ## logs só da api
	$(COMPOSE) logs -f --tail=200 api

api-outdated: ## dependências desatualizadas
	$(API_TOOL) pnpm outdated || true

migrate: ## cria/aplica migration em dev e regenera o cliente: make migrate NAME=descricao
	@test -n "$(NAME)" || (echo "uso: make migrate NAME=descricao" && exit 1)
	$(API_RUN) pnpm prisma migrate dev --name $(NAME)
	$(MAKE) api-generate

migrate-deploy: ## aplica migrations pendentes (sem criar)
	$(API_RUN) pnpm prisma migrate deploy

migrate-status: ## estado das migrations
	$(API_RUN) pnpm prisma migrate status

seed: ## garante o admin (ADMIN_EMAIL/ADMIN_PASSWORD do .env) e o profile; idempotente
	$(API_RUN) pnpm prisma db seed

openapi: ## emite api/openapi.json (fonte do cliente dart)
	$(API_TOOL) pnpm openapi:emit

openapi-check: ## falha se api/openapi.json estiver desatualizado em relação ao código
	$(MAKE) openapi
	git diff --exit-code -- api/openapi.json

## --- banco e uploads ---
db-shell: ## psql no banco de dev
	$(COMPOSE) exec db sh -c 'psql -U "$$POSTGRES_USER" "$$POSTGRES_DB"'

db-backup: ## dump do banco em backups/db-<data>.sql (funciona com o stack de dev ou de prod no ar)
	@mkdir -p $(BACKUPS)
	$(COMPOSE) exec -T db sh -c 'pg_dump -U "$$POSTGRES_USER" "$$POSTGRES_DB"' > $(BACKUPS)/db-$(STAMP).sql
	@echo "backups/db-$(STAMP).sql"

db-restore: ## restaura um dump: make db-restore FILE=backups/db-....sql (apaga o banco atual)
	@test -f "$(FILE)" || (echo "uso: make db-restore FILE=backups/db-....sql" && exit 1)
	$(COMPOSE) exec -T db sh -c 'psql -U "$$POSTGRES_USER" -d postgres -c "DROP DATABASE IF EXISTS \"$$POSTGRES_DB\"" -c "CREATE DATABASE \"$$POSTGRES_DB\""'
	$(COMPOSE) exec -T db sh -c 'psql -U "$$POSTGRES_USER" "$$POSTGRES_DB"' < $(FILE)

uploads-backup: ## tar.gz do volume de uploads em backups/uploads-<data>.tgz
	@mkdir -p $(BACKUPS)
	docker run --rm -v portfolio_uploads:/data:ro -v "$$PWD/$(BACKUPS)":/out alpine tar czf /out/uploads-$(STAMP).tgz -C /data .
	@echo "backups/uploads-$(STAMP).tgz"

uploads-restore: ## restaura o volume de uploads: make uploads-restore FILE=backups/uploads-....tgz
	@test -f "$(FILE)" || (echo "uso: make uploads-restore FILE=backups/uploads-....tgz" && exit 1)
	docker run --rm -v portfolio_uploads:/data -v "$$PWD/$(FILE)":/in.tgz:ro alpine sh -c 'tar xzf /in.tgz -C /data'

## --- app (flutter) ---
app-sh: ## bash no toolchain flutter
	$(APP) bash

app-install: ## flutter pub get
	$(APP_T) flutter pub get

app-gen: ## gera cliente dart (api/openapi.json → lib/api; multipart fica à mão) e l10n
	cp api/openapi.json app/openapi.source.json
	$(APP_T) sh -c "dart run tool/prepare_openapi.dart openapi.source.json openapi.json && dart run swagger_parser && dart run build_runner build -d && flutter gen-l10n"

app-gen-check: ## falha se app/lib/api estiver desatualizado em relação ao contrato
	$(MAKE) app-gen
	git diff --exit-code -- app/lib/api

app-analyze: ## flutter analyze (gera l10n antes)
	$(APP_T) sh -c "flutter gen-l10n && flutter analyze"

app-format: ## dart format
	$(APP_T) dart format lib test tool

app-test: ## flutter test
	$(APP_T) flutter test

app-build-web: ## flutter build web --release (o que o edge embute)
	$(APP_T) flutter build web --release

app-clean: ## flutter clean (build/ e .dart_tool/)
	$(APP_T) flutter clean

app-outdated: ## dependências desatualizadas
	$(APP_T) flutter pub outdated || true

## --- app admin no android (uso próprio, sem loja) ---
build-apk-dev: ## apk de DEBUG contra a API local (aceita http): make build-apk-dev API_BASE_URL=http://<ip-da-maquina>
	@test -n "$(API_BASE_URL)" || (echo "uso: make build-apk-dev API_BASE_URL=http://<ip-da-maquina>" && exit 1)
	$(APP_T) flutter build apk --debug --dart-define=API_BASE_URL=$(API_BASE_URL)
	@echo "apk: app/build/app/outputs/flutter-apk/app-debug.apk"

build-apk: ## apk RELEASE contra a API hospedada (https): make build-apk API_BASE_URL=https://<dominio>
	@test -n "$(API_BASE_URL)" || (echo "uso: make build-apk API_BASE_URL=https://<dominio>" && exit 1)
	$(APP_T) flutter build apk --release --split-per-abi --dart-define=API_BASE_URL=$(API_BASE_URL)
	@echo "apks: app/build/app/outputs/flutter-apk/ (instale o arm64-v8a na maioria dos aparelhos)"

build-aab: ## app bundle (só se um dia for para a loja): make build-aab API_BASE_URL=https://<dominio>
	$(APP_T) flutter build appbundle --dart-define=API_BASE_URL=$(API_BASE_URL)

app-android: ## flutter run com hot reload num aparelho via ADB Wi-Fi (ver INFRA.md §6): make app-android DEVICE=<ip:porta> API_BASE_URL=http://<ip-da-maquina>
	$(APP) flutter run -d $(DEVICE) --dart-define=API_BASE_URL=$(API_BASE_URL)

## --- verificação (o que o CI roda) ---
check: check-api check-app ## tudo

check-api: api-lint api-build api-test api-e2e openapi-check ## api: lint + build + unit + e2e + contrato em dia

check-app: app-gen-check app-analyze app-test ## app: cliente em dia + analyze + test

## --- produção (docker-compose.prod.yml; .env com valores reais) ---
prod-build: ## constrói as imagens de produção (api + edge com o flutter web embutido)
	$(COMPOSE_PROD) build

prod-up: ## sobe produção (build + migrations + seed do admin no entrypoint)
	$(COMPOSE_PROD) up -d --build

prod-down: ## derruba produção (mantém volumes)
	$(COMPOSE_PROD) down

prod-restart: ## reinicia a api de produção (ex.: após mudar o .env)
	$(COMPOSE_PROD) restart api

prod-logs: ## logs de produção
	$(COMPOSE_PROD) logs -f --tail=200

prod-ps: ## estado de produção
	$(COMPOSE_PROD) ps

prod-migrate-status: ## estado das migrations em produção
	$(COMPOSE_PROD) exec api ./node_modules/.bin/prisma migrate status
