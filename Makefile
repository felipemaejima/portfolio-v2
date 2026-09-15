# Todos os alvos rodam em containers. Nada pressupõe Node/Dart/Flutter no host.
COMPOSE      := docker compose
COMPOSE_PROD := docker compose -f docker-compose.yml -f docker-compose.prod.yml
API          := $(COMPOSE) exec api
API_RUN      := $(COMPOSE) run --rm --no-deps api
APP          := $(COMPOSE) --profile app run --rm --no-deps app

.PHONY: up down logs ps api-sh app-sh api-install migrate seed api-test api-e2e api-lint api-build openapi \
        app-gen app-test app-android build-web build-aab prod-up prod-down

## --- dev ---
up:            ; $(COMPOSE) up -d --build db api edge
down:          ; $(COMPOSE) --profile app down
logs:          ; $(COMPOSE) logs -f --tail=100
ps:            ; $(COMPOSE) ps
api-sh:        ; $(API) sh
app-sh:        ; $(APP) bash

## --- api ---
api-install:   ; $(API_RUN) pnpm install
migrate:       ; $(API) pnpm prisma migrate dev --name $(NAME)
seed:          ; $(API) pnpm prisma db seed
api-lint:      ; $(API_RUN) pnpm lint
api-build:     ; $(API_RUN) pnpm build
api-test:      ; $(API_RUN) pnpm test
api-e2e:       ; $(COMPOSE) run --rm api pnpm test:e2e
openapi:       ; $(API_RUN) pnpm openapi:emit

## --- app ---
app-gen:       ; cp api/openapi.json app/openapi.json && $(APP) sh -c "dart run swagger_parser && dart run build_runner build -d"
app-test:      ; $(APP) flutter test
app-android:   ; $(APP) flutter run -d $(DEVICE) --dart-define=API_BASE_URL=$(API_BASE_URL)

## --- release ---
build-web:     ; $(COMPOSE_PROD) build edge
build-aab:     ; $(APP) flutter build appbundle --dart-define=API_BASE_URL=$(API_BASE_URL)
prod-up:       ; $(COMPOSE_PROD) up -d --build
prod-down:     ; $(COMPOSE_PROD) down
