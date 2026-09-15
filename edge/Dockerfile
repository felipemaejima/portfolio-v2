# Contexto de build: raiz do repositório.
ARG FLUTTER_VERSION=stable
FROM ghcr.io/cirruslabs/flutter:${FLUTTER_VERSION} AS build
WORKDIR /app
COPY app/ .
# API_BASE_URL vazio: mesma origem. Os paths do cliente gerado já incluem /api/v1.
RUN flutter pub get && flutter build web --release

FROM caddy:2-alpine
COPY --from=build /app/build/web /srv
COPY edge/Caddyfile.prod /etc/caddy/Caddyfile
