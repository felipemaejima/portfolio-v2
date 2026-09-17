# Contexto de build: raiz do repositório.
ARG FLUTTER_VERSION=stable
FROM ghcr.io/cirruslabs/flutter:${FLUTTER_VERSION} AS build
WORKDIR /app
COPY app/ .
# --wasm: WasmGC (Chrome/Firefox/Safari recentes; fallback JS automático).
# --no-web-resources-cdn: CanvasKit/Skwasm servidos daqui, não do gstatic
# (menos uma origem, e a CSP pode ser só 'self'). API_BASE_URL vazio: mesma origem.
RUN flutter pub get && flutter build web --release --wasm --no-web-resources-cdn

# Pré-compressão: o Caddy serve .br/.gz prontos (zero CPU de compressão no servidor).
FROM alpine:3 AS compress
RUN apk add --no-cache brotli gzip
COPY --from=build /app/build/web /srv
RUN find /srv -type f \( -name '*.js' -o -name '*.mjs' -o -name '*.wasm' -o -name '*.json' \
      -o -name '*.ttf' -o -name '*.otf' -o -name '*.html' -o -name '*.css' -o -name '*.svg' -o -name '*.symbols' \) \
    -exec sh -c 'brotli -q 11 -k "$1" && gzip -9 -k "$1"' _ {} \;

FROM caddy:2-alpine
COPY --from=compress /srv /srv
COPY edge/Caddyfile.prod /etc/caddy/Caddyfile
