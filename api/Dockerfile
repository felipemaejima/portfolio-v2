# Targets: dev (bind mount + watch) | prod (multi-stage, só runtime)
FROM node:22-bookworm-slim AS base
ARG PNPM_VERSION=12.4.1
RUN apt-get update && apt-get install -y --no-install-recommends openssl ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g pnpm@${PNPM_VERSION} \
    && mkdir -p /app /data/uploads \
    && chown -R node:node /app /data/uploads
WORKDIR /app
USER node

# --- dev: código vem por bind mount; node_modules vive no bind mount ---
FROM base AS dev
ENV NODE_ENV=development \
    HOME=/home/node
# O compose pode rodar este target com qualquer uid (UID/GID do host, ver
# INFRA.md): HOME e as pastas de trabalho ficam graváveis para todos.
USER root
RUN chmod -R a+rwX /home/node /app /data/uploads
USER node
EXPOSE 3000
CMD ["pnpm", "start:dev"]

# --- build ---
FROM base AS build
COPY --chown=node:node package.json pnpm-lock.yaml pnpm-workspace.yaml prisma.config.ts ./
COPY --chown=node:node prisma ./prisma
RUN pnpm install --frozen-lockfile
COPY --chown=node:node . .
RUN pnpm build && pnpm prune --prod

# --- prod ---
FROM base AS prod
ENV NODE_ENV=production
COPY --from=build --chown=node:node /app/package.json /app/prisma.config.ts ./
COPY --from=build --chown=node:node /app/node_modules ./node_modules
COPY --from=build --chown=node:node /app/prisma ./prisma
COPY --from=build --chown=node:node /app/dist ./dist
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s --start-period=20s \
  CMD node -e "fetch('http://localhost:3000/api/v1/health').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"
# Sem pnpm em runtime: sem lockfile na imagem ele tentaria "sincronizar" deps ao rodar scripts.
# migrations → seed idempotente do admin (ADMIN_EMAIL/ADMIN_PASSWORD) → API
CMD ["sh", "-c", "./node_modules/.bin/prisma migrate deploy && node dist/seed.js && node dist/main.js"]
