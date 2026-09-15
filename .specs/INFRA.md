# Especificação Local — Infra

> **Escopo.** Containers, topologia de rede, volumes, variáveis de ambiente,
> scripts de desenvolvimento e CI/CD. Regra vigente: **nada roda fora de
> Docker, em dev nem em prod** (global AD-13, ADR 0005). Não repete `API.md`
> nem `APP.md`; define o que os dois consomem.

---

## 1. Topologia

Dev e prod têm a **mesma forma**: uma borda (Caddy) na frente de tudo, mesma
origem para app e API (requisito do cookie de refresh, ADR 0002).

```
                      ┌──────────────────────────────┐
  browser / Android ─►│  edge (Caddy)  :80 / :443     │
                      │  /api/*     → api:3000        │
                      │  /uploads/* → volume uploads  │
                      │  /*         → Flutter Web     │
                      └───────┬──────────────┬────────┘
                              │              │
                     ┌────────▼───────┐ ┌────▼────────────────┐
                     │ api (Nest)     │ │ dev: app (flutter    │
                     │ :3000          │ │ run -d web-server)   │
                     └────────┬───────┘ │ prod: estático no    │
                              │         │ próprio edge         │
                     ┌────────▼───────┐ └─────────────────────┘
                     │ db (Postgres)  │
                     └────────────────┘
```

| Serviço | Dev | Prod |
|---------|-----|------|
| `edge` | `caddy:2`, `Caddyfile.dev`, `:80` | imagem própria: build do Flutter Web copiado para `/srv`, `Caddyfile.prod`, TLS automático |
| `api` | `api/Dockerfile` target `dev`, bind mount `./api`, `pnpm start:dev` | target `prod`, `node dist/main.js`, `prisma migrate deploy` no entrypoint |
| `db` | `postgres:16-alpine`, volume `pgdata`, init script cria `portfolio` e `portfolio_test` | idem, sem `portfolio_test` |
| `app` | `tools/flutter/Dockerfile` sobre `ghcr.io/cirruslabs/flutter:<FLUTTER_VERSION>`, bind mount `./app`, `flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0` | **não existe** — o build web vai para dentro da imagem do `edge`; o `.aab` é produzido pelo mesmo toolchain no CI |

O Android em dev acessa `http://<ip-da-máquina>` (a borda). Em release acessa
`https://<domínio>`.

---

## 2. Arquivos

```
/
├── docker-compose.yml            # base: db, api, edge
├── docker-compose.override.yml   # dev (carregado automaticamente): app, bind mounts, portas, Caddyfile.dev
├── docker-compose.prod.yml       # prod: targets prod, TLS, sem app
├── Makefile                      # atalhos; nenhum comando roda no host além de docker compose
├── .env.example                  # todas as variáveis, sem valores sensíveis
├── edge/
│   ├── Dockerfile                # multi-stage: flutter build web → caddy
│   ├── Caddyfile.dev
│   └── Caddyfile.prod
├── api/Dockerfile                # targets: dev, prod
├── db/init/01-databases.sql      # CREATE DATABASE portfolio_test (dev)
├── tools/flutter/                # Dockerfile + entrypoint do toolchain Flutter
└── app/                          # projeto Flutter (sem Dockerfile próprio)
```

### `Caddyfile` (essência, igual em dev e prod salvo TLS)
```
{$SITE_ADDRESS}

handle /api/* {
  reverse_proxy api:3000
}
handle_path /uploads/* {
  root * /data/uploads
  file_server
  header Cache-Control "public, max-age=31536000, immutable"
}
handle {
  # dev: reverse_proxy app:8080
  # prod:
  root * /srv
  try_files {path} /index.html          # path URL strategy do go_router
  file_server
  header /flutter_service_worker.js Cache-Control "no-cache"
}
encode zstd gzip
```

`SITE_ADDRESS` é `:80` em dev e `https://<domínio>` em prod (Caddy emite o
certificado sozinho).

### `api/Dockerfile`
- `base`: `node:22-bookworm-slim` (glibc: Prisma e argon2 preferem a Debian
  à Alpine), `openssl`, corepack com pnpm fixado, usuário `node` (uid 1000 =
  dono dos arquivos no bind mount).
- `dev`: **não** copia código nem instala deps (bind mount; `node_modules`
  vive no bind mount, instalado via `make api-install`), `CMD pnpm start:dev`.
- `build`: copia `package.json`, lockfile, `pnpm-workspace.yaml` (lista de
  `allowBuilds` do pnpm 12), `prisma.config.ts` e `prisma/` **antes** do
  `pnpm install --frozen-lockfile` (o `postinstall` roda `prisma generate`);
  depois `nest build` e `pnpm prune --prod`.
- `prod`: copia `dist/`, `node_modules` (prod), `prisma/`, `prisma.config.ts`;
  entrypoint roda `prisma migrate deploy` e sobe. `HEALTHCHECK` em
  `/api/v1/health` (rota pública trivial, fora do OpenAPI).

### `tools/flutter/Dockerfile` (toolchain)
A imagem do cirruslabs roda como **root** e o SDK (checkout git em
`/sdks/flutter`) precisa escrever no próprio cache — `chmod -R` no SDK
duplicaria gigabytes numa camada. Solução: o container roda como root e um
`entrypoint` faz `chown -R $HOST_UID:$HOST_GID /app` ao final de cada comando,
entregando ao dono do host tudo que foi criado no bind mount. `git config
--system safe.directory '*'` evita o "dubious ownership" do SDK.

### `edge/Dockerfile` (prod)
```
FROM ghcr.io/cirruslabs/flutter:<versão> AS build
WORKDIR /app
COPY app/ .
RUN flutter pub get && flutter build web --release   # API_BASE_URL vazio: mesma origem
FROM caddy:2-alpine
COPY --from=build /app/build/web /srv
COPY edge/Caddyfile.prod /etc/caddy/Caddyfile
```

---

## 3. Volumes

| Volume | Montado em | Conteúdo |
|--------|-----------|----------|
| `pgdata` | `db:/var/lib/postgresql/data` | banco |
| `uploads` | `api:/data/uploads` **e** `edge:/data/uploads` (ro) | imagens (ADR 0003) |
| `caddy_data` | `edge:/data` (prod) | certificados |
| `pub_cache` | `app:/root/.pub-cache` (dev) | cache do `pub` entre `run`s |

Backup (prod): `pg_dump` diário + `tar` de `uploads`, via `docker compose exec`
num cron do host. Fora do escopo de código; documentado aqui para não ser
esquecido.

---

## 4. Variáveis de ambiente

Fonte única. `API.md` e `APP.md` referenciam esta tabela.

| Variável | Serviço | Dev (exemplo) | Notas |
|----------|---------|---------------|-------|
| `NODE_ENV` | api | `development` | `production` em prod |
| `PORT` | api | `3000` | |
| `DATABASE_URL` | api | `postgresql://portfolio:portfolio@db:5432/portfolio` | |
| `DATABASE_URL_TEST` | api | `…/portfolio_test` | só dev/CI |
| `JWT_ACCESS_SECRET` | api | — | ≥ 32 bytes aleatórios |
| `JWT_ACCESS_TTL` | api | `15m` | |
| `REFRESH_TTL_DAYS` | api | `30` | |
| `COOKIE_SECURE` | api | `false` | `true` em prod |
| `CORS_ORIGINS` | api | *(vazio)* | mesma origem via edge; só preencher se expor a API direto |
| `UPLOADS_DIR` | api | `/data/uploads` | |
| `PUBLIC_UPLOADS_BASE_URL` | api | `http://localhost/uploads` | `https://<domínio>/uploads` em prod |
| `ADMIN_EMAIL`, `ADMIN_PASSWORD` | api (seed) | — | seed idempotente |
| `POSTGRES_USER/PASSWORD/DB` | db | `portfolio` | |
| `SITE_ADDRESS` | edge | `:80` | `https://<domínio>` em prod |
| `HOST_UID`, `HOST_GID` | api (dev) | `id -u` / `id -g` | exportados pelo `Makefile` automaticamente; o container de dev roda com o seu uid para os arquivos do bind mount serem seus. Só precisa definir à mão se chamar `docker compose` direto |
| `API_BASE_URL` | app (dart-define) | *(vazio)* | **origem** da API, sem path (os paths gerados já têm `/api/v1`). Web: vazio = mesma origem. Android: `http://<ip-da-máquina>` em dev, `https://<domínio>` em release |
| `FLUTTER_VERSION` | app, edge | `3.44.0` | tag da imagem `cirruslabs/flutter`; subir de versão é um PR (ver §8) |

Segredos de prod ficam num `.env` no servidor, fora do git. Segredos de
release Android (keystore, senhas) ficam em secrets do CI.

---

## 5. Comandos (`Makefile`)

Todos os alvos são `docker compose …`. Nada pressupõe Node, Dart ou Flutter
no host.

| Alvo | Faz |
|------|-----|
| `make up` / `make down` | sobe/derruba dev (`db`, `api`, `app`, `edge`) |
| `make api-sh` / `make app-sh` | shell no container |
| `make migrate NAME=x` | `exec api pnpm prisma migrate dev --name x` |
| `make seed` | `exec api pnpm prisma db seed` |
| `make api-test` / `make api-e2e` | Jest unit / e2e (`DATABASE_URL_TEST`) |
| `make openapi` | `exec api pnpm openapi:emit` → `api/openapi.json` |
| `make app-gen` | copia `openapi.json`, remove operações multipart (`tool/prepare_openapi.dart`), `swagger_parser`, `build_runner`, `gen-l10n` |
| `make app-test` | `run --rm app flutter test` |
| `make app-analyze` / `make app-test` / `make app-build-web` | `flutter analyze` / `flutter test` / `flutter build web --release` |
| `make app-android` | `run --rm app flutter run -d <device>` (ADB Wi-Fi; ver §6) |
| `make build-web` | `docker compose -f docker-compose.yml -f docker-compose.prod.yml build edge` |
| `make build-apk` / `make build-aab` | `run --rm app flutter build apk|appbundle --release --dart-define=API_BASE_URL=…` (apk com assinatura de debug, para instalar direto) |
| `make prod-up` | `-f docker-compose.yml -f docker-compose.prod.yml up -d` |

Hot reload do Flutter Web: `make app-sh` → o `flutter run` já está rodando
como processo do serviço; usar `docker compose attach app` e teclar `r`/`R`.

---

## 6. Android a partir do container

O emulador não roda em Docker de forma prática (ADR 0005). Fluxo suportado:

1. Dispositivo físico com **depuração Wi-Fi** ativada.
2. No container `app`: `adb connect <ip-do-celular>:<porta>` (o container tem
   `adb` da imagem do toolchain; rede `host` não é necessária — é TCP).
3. `flutter run -d <id> --dart-define=API_BASE_URL=http://<ip-da-máquina>`.

Alternativa sem `flutter run`: `make build-apk` e instalar o `.apk` no
aparelho.

---

## 7. CI (GitHub Actions)

Os jobs usam os **mesmos containers** do compose; nenhum `setup-node` /
`setup-flutter`.

| Job | Passos |
|-----|--------|
| `api` | `docker compose build api` → `run --rm api pnpm lint` → `pnpm test` → sobe `db` → `pnpm test:e2e` → `pnpm openapi:emit` + `git diff --exit-code api/openapi.json` |
| `app` | `run --rm app flutter analyze` → `flutter test` → `git diff --exit-code app/lib/api` (cliente gerado em dia) |
| `release-web` (tag) | `build edge` → push da imagem para o registry → deploy |
| `release-android` (tag) | `flutter build appbundle` com keystore dos secrets → artefato `.aab` (upload à Play é manual na v2) |

Deploy: servidor com Docker; `docker compose pull && up -d` via SSH no job de
release. Migrations rodam no entrypoint da API (idempotente).

---

## 8. Notas

- **Mesma origem em todo lugar.** Se em algum momento a API for exposta em
  outro host, o cookie de refresh quebra (ADR 0002). Não fazer.
- `uploads` é montado **read-only** no `edge`; só a API escreve.
- O `edge` em dev faz proxy para `app:8080`; o dev server do Flutter serve
  `index.html` para qualquer rota, então o `try_files` só é necessário em
  prod.
- Versão do Flutter é **fixada na tag da imagem** do toolchain e repetida no
  `edge/Dockerfile`; subir de versão é um PR que muda as duas.
