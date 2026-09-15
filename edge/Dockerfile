# Contexto de build: raiz do repositório.
ARG FLUTTER_VERSION=stable
FROM ghcr.io/cirruslabs/flutter:${FLUTTER_VERSION} AS build
WORKDIR /app
COPY app/ .
RUN flutter pub get && flutter build web --release --dart-define=API_BASE_URL=/api/v1

FROM caddy:2-alpine
COPY --from=build /app/build/web /srv
COPY edge/Caddyfile.prod /etc/caddy/Caddyfile
