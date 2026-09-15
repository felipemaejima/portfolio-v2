# Especificação Local — API (NestJS)

> **Escopo.** Implementação da API: arquitetura modular, padrões de código,
> dependências e ordem de construção. Não repete o que está em `GLOBAL.md`
> (domínio, contrato, erros, regras de acesso) nem em `docs/adr/`. Onde uma
> regra de negócio for necessária, **referencia** a global.

---

## 0. Convenções de base

- **Chave primária UUID** em todas as tabelas, gerada pela aplicação
  (`@id @default(uuid()) @db.Uuid`). Sem auto-incremento.
- **Código em inglês, conteúdo em português.** Tabelas, colunas, classes,
  rotas e campos JSON em inglês; o texto armazenado é PT-BR.
- **Colunas `snake_case`, JSON `camelCase`.** Prisma mapeia com `@map` /
  `@@map`; a fronteira HTTP nunca vê `snake_case` (global AD-12).
- **Timestamps** `created_at` / `updated_at` em toda tabela (`@default(now())`,
  `@updatedAt`), `timestamptz`.
- **TypeScript strict**, `noUncheckedIndexedAccess`, oxlint + Prettier do
  scaffold Nest. Nada de `any` em DTO.

---

## 1. Ambiente e dependências

| Papel | Escolha | Nota |
|-------|---------|------|
| Runtime | Node 22 LTS, pnpm | `.nvmrc` / `engines` no `package.json` |
| Framework | NestJS 12 (ESM-only, Express 5) | Fastify não vale o custo com multipart + cookie. Imports relativos com `.js`; top-level `await` no bootstrap |
| ORM | Prisma 7 | `prisma.config.ts` (url, migrations, seed), driver adapter `@prisma/adapter-pg`, cliente gerado em `src/generated/prisma` (gitignored; `postinstall` gera) |
| Banco | PostgreSQL 16 | via compose (`INFRA.md`) |
| Auth | `@nestjs/passport`, `passport-jwt`, `@nestjs/jwt`, `argon2`, `cookie-parser` | argon2id para senha; refresh é `randomBytes(32)` → hash SHA-256 no banco |
| Validação | `class-validator`, `class-transformer` | `ValidationPipe` global |
| Config | `@nestjs/config` + `zod` | schema valida `.env` no boot; falha rápido |
| OpenAPI | `@nestjs/swagger` + CLI plugin | plugin em `nest-cli.json` com `introspectComments`, `dtoFileNameSuffix: ['.dto.ts']` |
| Upload | `multer` via `@nestjs/platform-express`, `file-type` | limite e mime por magic bytes, não por extensão |
| Estáticos (dev) | `@nestjs/serve-static` | só em `NODE_ENV=development`; em prod é a borda (`INFRA.md`) |
| PDF | `pdfmake` | fontes embutidas no repositório (`assets/fonts`) |
| Rate limit | `@nestjs/throttler` | |
| Slug | `slugify` | |
| Testes | Vitest 4, `supertest` | padrão do scaffold Nest 12 (ESM). e2e contra o banco `portfolio_test` do Postgres do compose (sem Testcontainers: tudo já roda em Docker) |
| Lint / formato | oxlint, Prettier | padrão do scaffold Nest 12 |

Versões exatas ficam no `package.json`; esta tabela fixa **majors** e razões.

**Nada roda fora de Docker** (global AD-13): `pnpm`, `prisma`, `jest` e o
`openapi:emit` executam dentro do container `api` (`docker compose exec api
pnpm …`). O `Dockerfile` da API tem dois targets: `dev` (bind mount do
código, `pnpm start:dev` com watch) e `prod` (multi-stage, só `dist/` +
`node_modules` de produção + `prisma migrate deploy` no entrypoint).

---

## 2. Arquitetura modular

### Princípio

Um `NestModule` por **conceito de domínio**, fatia vertical autocontida. Tudo
que muda junto mora junto. Módulos de infraestrutura compartilhada ficam em
`shared/` e são importados pelos de domínio, nunca o contrário.

```
api/
├── prisma/
│   ├── schema.prisma
│   ├── migrations/
│   └── seed.ts                     # admin idempotente via ADMIN_EMAIL/ADMIN_PASSWORD
├── prisma.config.ts                # url do datasource, caminho das migrations, comando de seed
├── openapi.json                    # EMITIDO; versionado; nunca editado à mão
├── assets/fonts/                   # fontes do pdfmake
└── src/
    ├── main.ts                     # bootstrap + Swagger UI em dev
    ├── app.setup.ts                # configureApp(): prefixo, cookies, CORS — usado por main, emit e e2e
    ├── app.module.ts
    ├── openapi/                    # document.ts (DocumentBuilder) + emit.ts (grava openapi.json)
    ├── generated/prisma/           # GERADO pelo Prisma; gitignored
    ├── shared/
    │   ├── config/                 # ConfigModule + schema zod + tipo AppConfig
    │   ├── prisma/                 # PrismaModule / PrismaService
    │   ├── storage/                # port FileStorage + LocalDiskStorage
    │   ├── auth/                   # JwtAuthGuard (global), JwtStrategy, @Public(), @CurrentAdmin(), JwtModule exportado
    │   ├── health/                 # GET /health (público, fora do OpenAPI)
    │   └── http/                   # ErrorResponseDto, exceções de domínio, exception filter, ValidationPipe, ReorderDto, @ApiErrorResponses()
    └── modules/
        ├── auth/
        ├── profile/
        ├── projects/
        ├── skills/                 # SkillCategory + Skill (mudam juntos)
        ├── experiences/
        ├── educations/
        ├── offerings/
        ├── contact/                # ContactLink + ContactMessage
        └── cv/
```

### Estrutura de um módulo de domínio

```
modules/projects/
├── projects.module.ts
├── projects.controller.ts
├── projects.service.ts             # regra de negócio; classe concreta
├── dto/
│   ├── create-project.dto.ts       # entrada (class-validator)
│   ├── update-project.dto.ts
│   ├── project.dto.ts              # SAÍDA (@ApiProperty em tudo) + static from()
│   └── project-image.dto.ts
├── ports/
│   └── project.repository.ts       # abstract class ProjectRepository
├── adapters/
│   └── prisma-project.repository.ts
└── projects.service.spec.ts        # unit, com InMemoryProjectRepository
```

Nem todo módulo precisa de tudo (`cv/` não tem repositório; `contact/` tem
dois). A **forma** é a mesma em todos: previsibilidade vale mais que economia
de pasta.

### Ports & adapters — onde fica a costura (muda em relação à v1)

A v1 colocava a interface no *service*. Na v2 o service é **concreto** — ele é
a regra de negócio, não há o que trocar. As costuras ficam onde existe de fato
uma alternativa de implementação:

| Port (abstract class) | Adapter | Módulo |
|----------------------|---------|--------|
| `ProjectRepository`, `SkillCategoryRepository`, `SkillRepository`, `ExperienceRepository`, `EducationRepository`, `OfferingRepository`, `ContactLinkRepository`, `ContactMessageRepository`, `ProfileRepository`, `AdminRepository`, `RefreshTokenRepository` | `Prisma*Repository` | cada domínio |
| `FileStorage` | `LocalDiskStorage` | `shared/storage` |
| `CvRenderer` | `PdfmakeCvRenderer` | `cv` |

Ports são `abstract class` (não `interface`) para servirem de token de injeção
sem `@Inject('STRING')`:

```ts
// ports/project.repository.ts
export abstract class ProjectRepository {
  abstract findAll(): Promise<Project[]>;
  abstract findBySlug(slug: string): Promise<Project | null>;
  abstract findById(id: string): Promise<Project | null>;
  abstract create(data: CreateProjectData): Promise<Project>;
  abstract update(id: string, data: UpdateProjectData): Promise<Project>;
  abstract delete(id: string): Promise<void>;
  abstract reorder(ids: string[]): Promise<void>;   // transação
  abstract slugExists(slug: string): Promise<boolean>;
}

// projects.module.ts
providers: [
  ProjectsService,
  { provide: ProjectRepository, useClass: PrismaProjectRepository },
]
```

`Project` aqui é o **tipo do Prisma** (com `include` de imagens) — não vale
criar uma segunda camada de entidades para um portfólio. O que **não** pode
acontecer é esse tipo atravessar o controller: a saída é sempre um
`ProjectDto` (global AD-5).

O que **não** abstrair: o `PrismaService` dentro dos adapters, o `JwtService`,
o `ConfigService`. Abstração só onde existe um segundo adapter plausível.

---

## 3. Fluxo de uma requisição

```
Rota → JwtAuthGuard (global; @Public() libera) → ThrottlerGuard
     → ValidationPipe (DTO de entrada) → Controller (fino)
     → Service (regra) → Repository port → Prisma
     → Service devolve tipo de domínio → Controller mapeia para DTO de saída
     → JSON  |  erro em qualquer ponto → HttpExceptionFilter → ErrorResponse
```

Regras por camada:

- **Controller:** recebe DTO validado, chama o service, devolve
  `XDto.from(result)`. Sem regra, sem query, sem `try/catch`. Declara
  `@ApiOkResponse({ type: XDto })` etc. em **todo** handler — é isso que vira o
  contrato.
- **DTO de entrada:** toda validação. `class-validator` com mensagens em PT-BR
  (`{ message: 'deve ser um e-mail válido' }`). Nenhuma validação no service.
- **Service:** regra de negócio (slug, invariantes de `reorder`, limite de
  imagens, rotação de refresh). Não conhece HTTP: não recebe `Request`, não
  lança `HttpException` — lança exceções de domínio
  (`NotFoundError`, `ValidationError`, `UnauthenticatedError`) que o filtro
  traduz.
- **Repository:** persistência e só. Sem regra. `include` para evitar N+1.
- **DTO de saída:** única forma de serializar. `static from(entity)`.

---

## 4. Autenticação

Implementa a global seção 5 / ADR 0002.

- **Senha:** argon2id. Sem rota de troca de senha na v2 (troca via seed +
  `.env`, que é `upsert` por e-mail).
- **Access token:** JWT HS256, `sub` = admin id, `exp` = `JWT_ACCESS_TTL`
  (default 15 min). Validado por `passport-jwt`; **não** consulta o banco.
- **Refresh token:** `randomBytes(32).toString('base64url')`. Tabela
  `refresh_tokens`: `id`, `admin_id`, `token_hash` (SHA-256), `family_id`,
  `expires_at`, `revoked_at`, `replaced_by_id`, `created_at`.
  - `login` cria uma família nova.
  - `refresh` acha pelo hash; se expirado/revogado → `401`; se **já
    substituído** (reuso) → revoga a família inteira, `401`; senão cria o
    sucessor na mesma família e marca o atual como substituído. Tudo em uma
    transação.
  - `logout` revoga a família do token apresentado.
- **Entrega por plataforma** (`clientPlatform` no login):
  - `MOBILE`: refresh no body; `/auth/refresh` lê `body.refreshToken`.
  - `WEB`: `Set-Cookie: refresh_token=…; HttpOnly; Secure; SameSite=Strict;
    Path=/api/v1/auth; Max-Age=<ttl>`. `/auth/refresh` lê o cookie primeiro,
    body como fallback. `logout` responde com o cookie expirado.
  - Em `development` o `Secure` é desligado para `http://localhost`.
- **Origin check:** middleware em `/auth/*` rejeita requests com cookie cujo
  `Origin`/`Referer` não esteja em `CORS_ORIGINS` (defesa extra ao
  `SameSite`).
- **Guard global:** `JwtAuthGuard` registrado como `APP_GUARD`; `@Public()`
  (metadata) libera. Rotas públicas são as da global, e só elas.
- **Seed do Admin:** `prisma/seed.ts` faz `upsert` por `ADMIN_EMAIL` com hash
  de `ADMIN_PASSWORD`. Idempotente. Não há rota de registro.

---

## 5. Convenções transversais

### Prefixo, versionamento, CORS
- `app.setGlobalPrefix('/api/v1')` — **com barra inicial**: o Nest monta o
  handler de 404 no Express com o prefixo cru, e sem a barra rotas
  inexistentes caem no 404 HTML do Express em vez do `ErrorResponse`.
  Nenhum controller repete o prefixo.
- CORS: `origin: CORS_ORIGINS` (lista explícita), `credentials: true`.
  A borda torna tudo mesma origem em dev e prod; `CORS_ORIGINS` fica vazio
  e o middleware só existe como salvaguarda.

### OpenAPI (ADR 0004)
- `DocumentBuilder` com `addBearerAuth()`; todo DTO com `@ApiProperty`
  (o CLI plugin preenche o óbvio; enums exigem
  `@ApiProperty({ enum: Availability, enumName: 'Availability' })`).
- `operationIdFactory: (_, method) => method` — logo, nomes de método de
  controller são **globais e únicos**: `listProjects`, `getProjectBySlug`,
  `createProject`, `reorderProjects`, `addProjectImages`… Isso vira o nome do
  método Dart.
- `ErrorResponseDto` declarado em todos os handlers via decorators
  compartilhados (`@ApiStandardErrors()` em `shared/http`).
- Script `pnpm openapi:emit` (= `nest build && node dist/openapi/emit.js`):
  cria a app sem `init()`/`listen()` (não toca o banco), gera o documento e
  grava `api/openapi.json`. Roda sobre o `dist/` porque o CLI plugin só age
  no `nest build`. CI roda e falha se `git diff` acusar mudança.
- `ErrorResponseDto` entra como `extraModels`: está no contrato mesmo antes
  de qualquer rota referenciá-lo.
- Swagger UI em `/api/docs` só em `development`.

### Validação e erros
- `ValidationPipe({ whitelist: true, forbidNonWhitelisted: true, transform:
  true, errorHttpStatusCode: 422 })`.
- `HttpExceptionFilter` global converte: erros de validação → `422` com
  `details` por campo; exceções de domínio → código correspondente;
  `HttpException` do Nest → mapeada; qualquer outra → `500 INTERNAL`, logada
  com stack, sem vazar mensagem.

### Enums
`enum` TS em `shared/` ou no módulo dono, espelhados como `enum` no Prisma.
Rótulo em PT não existe na API.

### Slug
No `create`, `slugify(name)` + sufixo `-2`, `-3`… até `slugExists` ser falso.
Imutável em `update` (DTO de update não tem `slug`; o service ignora `name`
para fins de slug).

### `position` e `reorder`
- Novo item: `position = max(position) + 1` no escopo, dentro da transação de
  criação.
- `reorder`: service carrega os ids do escopo, compara com o set recebido
  (igualdade exata, sem duplicatas) → senão `ValidationError` (`422`). O
  repositório aplica `position = index` em transação.
- Após `delete`, não é preciso compactar: ordenação é relativa.

### Storage (ADR 0003)
```ts
export abstract class FileStorage {
  abstract put(file: { buffer: Buffer; mime: string }, keyPrefix: string): Promise<StoredFile>; // { key, url }
  abstract delete(key: string): Promise<void>;
}
```
- `LocalDiskStorage`: grava em `UPLOADS_DIR/<keyPrefix>/<uuid>.<ext>`; `url` =
  `PUBLIC_UPLOADS_BASE_URL + '/' + key`. Extensão vem do mime detectado.
- Upload: `FileInterceptor('file')` / `FilesInterceptor('files', 12)` com
  `limits.fileSize = 5 MB`; depois `file-type` confirma o mime real; recusa →
  `415`. O service chama `put` e só então persiste a linha; se persistir
  falhar, faz `delete` do arquivo (compensação).
- `ServeStaticModule` serve `UPLOADS_DIR` em `/uploads` **só em
  development**.

### CV (global AD-11)
- `CvService` agrega Profile + Experiences + Educations + SkillCategories +
  Offerings num `CvDocument` (objeto de dados puro, sem pdfmake).
- `CvRenderer.render(doc): Promise<Buffer>`; `PdfmakeCvRenderer` monta a
  definição de documento. Layout: uma coluna, seções na ordem acima, fontes
  em `assets/fonts`.
- Controller responde `application/pdf`, `Content-Disposition: attachment;
  filename="cv-<slug do nome>.pdf"`, `Cache-Control: no-store`. Sem storage,
  sem cache — o tráfego não justifica.

### Rate limit
`ThrottlerModule` global permissivo (ex.: 100/min) e `@Throttle()` estrito em
`POST /auth/login` (5/min por IP) e `POST /contact-messages` (3/min por IP).
Resposta `429 RATE_LIMITED` pelo filtro.

### Config
`shared/config` valida com zod e expõe `AppConfig` tipado. Variáveis: ver
`INFRA.md` (tabela única; não duplicar aqui).

---

## 6. Ordem de implementação

Regra: **um módulo por completo** (schema, migration, ports, adapter, service,
DTOs, controller, testes) antes do próximo. Pré-requisitos vêm antes.

### Fase 0 — Fundação
1. Scaffold Nest, pnpm, TS strict, ESLint/Prettier, `.nvmrc`.
2. `shared/config` com schema zod; `.env.example`.
3. Prisma + Postgres do compose; convenções de schema (uuid, `@map`,
   timestamps); primeira migration vazia.
4. `shared/http`: `ErrorResponseDto`, exceções de domínio, filtro global,
   `ValidationPipe`, `ReorderDto`.
5. `shared/auth`: guard global + `@Public()` (o guard nasce antes do módulo
   `auth` para que **nenhuma** rota nasça desprotegida).
6. OpenAPI: `DocumentBuilder`, CLI plugin, `openapi:emit`, check no CI.
7. Base de testes: Vitest unit; e2e apontando `DATABASE_URL` para
   `portfolio_test` (criado pelo init script do Postgres, ver `INFRA.md`),
   `prisma migrate deploy` + `TRUNCATE` no `globalSetup`; helper
   `createTestApp()`. Roda com `docker compose exec api pnpm test:e2e`.

### Fase 1 — Auth
Admin, `refresh_tokens`, seed, `login/refresh/logout/me`, cookie vs body,
rotação e detecção de reuso. Testes e2e cobrem: login web (cookie) e mobile
(body), refresh rotaciona, reuso revoga família, logout limpa cookie.

### Fase 2 — Profile
`GET/PUT /profile`, `PUT/DELETE /profile/image`. Primeiro uso de
`FileStorage` (o caso mais simples: um arquivo). Seed cria Profile vazio junto
com o Admin.

### Fase 3 — Projects
CRUD, slug, `position`/`reorder`, galeria (`ProjectImage`), limite de 12,
`reorder` de imagens, cascata no delete (linhas + arquivos). Exercita todos os
padrões; depois dele o resto é repetição.

### Fase 4 — Skills
`SkillCategory` 1:N `Skill`, dois `reorder` (categorias; skills dentro da
categoria), mover skill de categoria via `PUT` (reposiciona no fim da nova).

### Fase 5 — Experiences · Fase 6 — Educations · Fase 7 — Offerings
CRUDs simples. Ordenação cronológica nas duas primeiras (global seção 6);
`position` em Offering.

### Fase 8 — Contact
`ContactLink` (CRUD + reorder) e `ContactMessage` (POST público com throttle,
GET, `read`, DELETE). Nada além de persistir (global AD-8).

### Fase 9 — CV
Depende de todos os anteriores. `CvDocument`, `CvRenderer`, `PdfmakeCvRenderer`,
`GET /cv`. Teste: gera PDF válido (magic bytes `%PDF`) com dados seedados.

### Fase 10 — Fechamento
`openapi.json` final revisado (nomes de `operationId`, enums, erros), cobertura
de testes por módulo, índices (`slug` único, `position` por escopo,
`token_hash` único), `Dockerfile` multi-stage (ver `INFRA.md`).

---

## 7. Testes

- **Unit (Vitest):** services com repositórios em memória (`InMemory*Repository`
  implementando o port, vivendo em `test/`). Cobrem regra: slug único,
  `reorder` inválido, limite de imagens, rotação/reuso de refresh.
- **E2E (supertest):** por módulo, contra o Postgres do compose (banco
  `portfolio_test`) e o app completo (guards, pipes, filtro). Cada rota Admin tem ao menos: sem
  token → `401`; payload inválido → `422` com `details`; caminho feliz. Rotas
  públicas: acessíveis sem token.
- **Contrato:** `openapi:emit` + diff no CI. Sem snapshot de JSON de resposta
  além disso — o cliente gerado é o teste de contrato.

---

## 8. Notas de desenvolvimento

- **N+1:** `include` nos repositórios de listagem (`projects` → `images`,
  `skill-categories` → `skills`), com `orderBy: { position: 'asc' }` dentro do
  `include`.
- **Nunca** devolver tipo Prisma de um controller. Se um handler retorna algo
  sem `@ApiOkResponse({ type })`, está errado.
- **Nomes de método de controller são globais** (viram `operationId`): sem
  `findAll` em dois controllers.
- **Sem lógica no controller.** Se cresceu, pertence ao service.
- **Arquivos DTO terminam em `.dto.ts`**, senão o CLI plugin do swagger não
  os enxerga.
- **Transações** via `prisma.$transaction` dentro do adapter; o service não
  conhece o Prisma.
