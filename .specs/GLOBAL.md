# Especificação Global — Portfolio v2

> **Escopo deste documento.** Esta é a especificação **global** do sistema: o
> contrato entre API e app, o modelo de domínio e as decisões arquiteturais
> transversais. Não descreve implementação interna de nenhum dos lados — isso
> vive em `API.md`, `APP.md` e `INFRA.md`. A regra de fronteira: **se os dois
> lados precisam concordar sobre algo, está aqui; se um lado pode mudar sem
> quebrar o outro, está na spec local daquele lado.**
>
> Vocabulário: [`/CONTEXT.md`](../CONTEXT.md). Decisões com justificativa:
> [`/docs/adr/`](../docs/adr/). Este documento não os duplica — aponta.

---

## 1. Visão geral

Portfólio profissional de uma única pessoa (o **Admin**) com gerenciamento de
conteúdo embutido. **Visitors** leem e enviam mensagens de contato; o Admin
edita tudo.

Arquitetura: **monorepo** com dois artefatos independentes:

- **`api/`** — API REST em **NestJS** (TypeScript), PostgreSQL via Prisma.
- **`app/`** — **um único app Flutter** que contém a área pública e o painel
  admin, entregue como **Flutter Web** e como app **Android**; iOS é fase
  posterior (ADR 0001).

Não há SSR nem site indexável: o link do portfólio é compartilhado
diretamente. A API é a única fonte de dados; o app não tem estado próprio além
de cache.

### Stack (escolhas fechadas)

| Lado | Escolha |
|------|---------|
| API | NestJS 11+, Node 22 LTS, TypeScript strict, Prisma 6+, PostgreSQL 16 |
| Auth | JWT access curto + refresh opaco rotativo (ADR 0002) |
| Storage | Disco local atrás de port `FileStorage` (ADR 0003) |
| PDF | pdfmake, sob demanda, em memória |
| Contrato | OpenAPI emitido pela API; cliente Dart **gerado** dele (ADR 0004) |
| App | Flutter stable, Riverpod, go_router, cliente gerado (retrofit/freezed) |
| Infra | **Docker em dev e em prod**, inclusive o toolchain Flutter. Caddy como borda única: serve o Flutter Web, `/uploads` e faz proxy de `/api` (mesma origem) |

Versões concretas e bibliotecas ficam nas specs locais.

---

## 2. Decisões arquiteturais

Restrições acordadas. A implementação respeita todas, em todo lugar. Onde há
ADR, o ADR é a fonte; a linha aqui é só o resumo.

| # | Decisão | Fonte |
|---|---------|-------|
| AD-1 | **Um app Flutter para público + admin, web + mobile; SEO zero aceito.** | [ADR 0001](../docs/adr/0001-flutter-unico-para-publico-e-admin.md) |
| AD-2 | **Só o Admin autentica.** Não há registro, outros papéis nem campo `role`. Autenticado ⇔ Admin. | CONTEXT.md |
| AD-3 | **JWT access + refresh rotativo.** Refresh em cookie httpOnly no web, no body no mobile. Web e API same-site. | [ADR 0002](../docs/adr/0002-jwt-com-refresh-rotativo-e-cookie-so-no-web.md) |
| AD-4 | **Versionamento sob `/api/v1`.** | — |
| AD-5 | **Toda resposta tem DTO explícito; o OpenAPI gerado é a fonte do cliente Dart.** Nunca sai tipo de ORM cru. | [ADR 0004](../docs/adr/0004-openapi-como-fonte-do-cliente-dart.md) |
| AD-6 | **Validação na borda, formato de erro único** (seção 7). | — |
| AD-7 | **Autorização é da API; protegido por padrão.** Toda rota exige Admin salvo as marcadas públicas. O app só esconde UI. | — |
| AD-8 | **Contato só persiste.** Sem fila, sem notificação, sem serviço externo. Revoga o AD-7 da v1. | — |
| AD-9 | **Imagens: URLs públicas permanentes, chave imutável; disco local atrás de port.** | [ADR 0003](../docs/adr/0003-storage-em-disco-local-atras-de-port.md) |
| AD-10 | **Ordenação editorial por `position`** em toda coleção não cronológica, incluindo Project. | — |
| AD-11 | **CV gerado sob demanda, nunca armazenado.** | — |
| AD-12 | **JSON em `camelCase`.** Muda em relação à v1 (`snake_case`): TS e Dart são camelCase-nativos e o cliente é gerado. | — |
| AD-13 | **Tudo roda em Docker, dev e prod** — API, banco, borda e o toolchain Flutter. Nenhuma ferramenta instalada no host além de Docker. | [ADR 0005](../docs/adr/0005-tudo-em-docker-inclusive-flutter.md) |

---

## 3. Modelo de domínio

Os termos e suas definições estão em `CONTEXT.md`. Aqui, só a **forma dos
dados** que os dois lados precisam concordar. Convenções:

- Todo recurso tem `id` (UUID, string), `createdAt`, `updatedAt` (ISO 8601 UTC).
- Campos opcionais são `null`, nunca ausentes.
- Enums são strings em inglês, `UPPER_SNAKE`. Rótulo em PT é do app.
- Datas parciais: mês/ano como `"YYYY-MM"`; ano como inteiro.

### Enums

| Enum | Valores |
|------|---------|
| `Availability` | `CLT`, `PJ`, `FREELANCE`, `CONTRACT` |
| `WorkMode` | `REMOTE`, `HYBRID`, `ON_SITE` |
| `LanguageLevel` | `BASIC`, `INTERMEDIATE`, `ADVANCED`, `FLUENT`, `NATIVE` |
| `ClientPlatform` | `WEB`, `MOBILE` |

### Entidades

**Admin** *(identidade; nunca exposta publicamente)*
- `email`, `passwordHash` — só a API vê. `GET /auth/me` devolve `{ id, email }`.

**Profile** *(singleton público; edição = o Admin editando a si mesmo)*
- `name` — nome exibido (nav, hero, footer)
- `headline` — uma linha acima do nome no hero (ex.: "Desenvolvedor Full-Stack")
- `summary` — parágrafo curto do hero
- `description` — texto longo do "Sobre mim" (parágrafos separados por linha em branco)
- `contactIntro` — texto de abertura da seção Contato; nullable
- `location` — `{ city, state, country }`
- `availability` — `Availability[]`
- `workModes` — `WorkMode[]`
- `languages` — `{ language: string, level: LanguageLevel }[]`
- `imageUrl` — nullable; URL pública permanente

**Project** *(coleção, ordenada por `position`)*
- `name`
- `slug` — derivado de `name` na criação, **imutável** depois; único
- `shortDescription` — listagem
- `fullDescription` — detalhe
- `technologies` — `string[]`
- `codeUrl`, `demoUrl` — nullable
- `position`
- `images` — `ProjectImage[]`, ordenadas por `position`

**ProjectImage**
- `id`, `url`, `position`

**SkillCategory** *(coleção, por `position`)*
- `name`, `position`
- `skills` — `Skill[]`, por `position`

**Skill**
- `name`, `position`, `categoryId`

**Experience** *(coleção, cronológica)*
- `role`, `companyName`
- `activities` — `string[]` (itens; viram bullets no CV)
- `startDate` — `"YYYY-MM"`
- `endDate` — `"YYYY-MM"` ou `null` (atual)

**Education** *(coleção, cronológica)*
- `courseName`, `institution`
- `startYear` — int
- `endYear` — int ou `null`

**Offering** *(coleção, por `position`)*
- `title`, `description`, `position`

**ContactLink** *(coleção, por `position`)*
- `label` — nome do canal, ex.: "GitHub"
- `value` — texto exibido, ex.: "github.com/usuario", "(11) 99999-0000"
- `url` — destino abrível pelo app: `https://…`, `mailto:…`, `tel:…`
- `position`

**ContactMessage** *(coleção; criada por Visitor, gerida pelo Admin)*
- `name`, `email`, `message`
- `readAt` — nullable
- `createdAt`

---

## 4. Superfície de endpoints (contrato)

Convenções:
- Prefixo `/api/v1` em tudo.
- **Público** = sem autenticação. **Admin** = `Authorization: Bearer <access>`.
  Tudo que não está marcado Público é Admin (AD-7).
- `PUT` substitui o recurso inteiro; `PATCH` é usado só para operações nomeadas
  (`reorder`, `read`).
- Uploads são `multipart/form-data`; todo o resto é `application/json`.
- Listagens devolvem a coleção completa (seção 6).
- Respostas de escrita devolvem o recurso resultante (`201` em `POST`, `200` em
  `PUT`/`PATCH`), exceto `DELETE` e `reorder`, que devolvem `204`.

### Auth
| Método | Rota | Acesso | Descrição |
|--------|------|--------|-----------|
| POST | `/auth/login` | Público | `{ email, password, clientPlatform }`. Devolve `{ accessToken, expiresIn, refreshToken? }`. `refreshToken` vem no body só para `MOBILE`; para `WEB` vai em cookie httpOnly. |
| POST | `/auth/refresh` | Público* | Lê o refresh do cookie (web) ou de `{ refreshToken }` (mobile). Rotaciona e devolve o mesmo formato do login. |
| POST | `/auth/logout` | Admin | Revoga a família do refresh atual; limpa o cookie. `204`. |
| GET | `/auth/me` | Admin | `{ id, email }`. Serve para o app validar a sessão no boot. |

\* "Público" no sentido de não exigir access token; exige um refresh válido.

### Profile
| Método | Rota | Acesso |
|--------|------|--------|
| GET | `/profile` | Público |
| PUT | `/profile` | Admin |
| PUT | `/profile/image` | Admin — multipart, campo `file` |
| DELETE | `/profile/image` | Admin |

### Projects
| Método | Rota | Acesso |
|--------|------|--------|
| GET | `/projects` | Público (listagem, com `images`) |
| GET | `/projects/{slug}` | Público (detalhe) |
| POST | `/projects` | Admin |
| PUT | `/projects/{id}` | Admin (não altera `slug`) |
| DELETE | `/projects/{id}` | Admin (apaga imagens junto) |
| PATCH | `/projects/reorder` | Admin |
| POST | `/projects/{id}/images` | Admin — multipart, campo `files` (1..n); devolve o Project atualizado |
| DELETE | `/projects/{id}/images/{imageId}` | Admin |
| PATCH | `/projects/{id}/images/reorder` | Admin |

### Skills
| Método | Rota | Acesso |
|--------|------|--------|
| GET | `/skill-categories` | Público (categorias com `skills` aninhadas) |
| POST | `/skill-categories` | Admin |
| PUT | `/skill-categories/{id}` | Admin |
| DELETE | `/skill-categories/{id}` | Admin (apaga skills junto) |
| PATCH | `/skill-categories/reorder` | Admin |
| POST | `/skill-categories/{id}/skills` | Admin |
| PUT | `/skills/{id}` | Admin (pode mover de categoria via `categoryId`) |
| DELETE | `/skills/{id}` | Admin |
| PATCH | `/skill-categories/{id}/skills/reorder` | Admin |

### Experiences / Educations / Offerings / Contact links
Mesmo padrão CRUD para `{recurso}` ∈ { `experiences`, `educations`,
`offerings`, `contact-links` }:

| Método | Rota | Acesso |
|--------|------|--------|
| GET | `/{recurso}` | Público |
| POST | `/{recurso}` | Admin |
| PUT | `/{recurso}/{id}` | Admin |
| DELETE | `/{recurso}/{id}` | Admin |
| PATCH | `/{recurso}/reorder` | Admin — só `offerings` e `contact-links` (os cronológicos não têm `position`) |

### Contact messages
| Método | Rota | Acesso |
|--------|------|--------|
| POST | `/contact-messages` | Público — `{ name, email, message }`; rate-limited. `201` sem body. |
| GET | `/contact-messages` | Admin — mais recentes primeiro |
| PATCH | `/contact-messages/{id}/read` | Admin — marca lida (idempotente) |
| DELETE | `/contact-messages/{id}` | Admin |

### CV
| Método | Rota | Acesso |
|--------|------|--------|
| GET | `/cv` | Público — `application/pdf`, `Content-Disposition: attachment` |

### Operacional
| Método | Rota | Acesso |
|--------|------|--------|
| GET | `/health` | Público — `{ status: "ok" }`; usado pelo `HEALTHCHECK` do container. Fora do cliente gerado. |

### Contrato de `reorder`

Body: `{ "ids": ["…", "…"] }`. A lista deve conter **exatamente** o conjunto de
ids da coleção (ou do escopo: imagens de um projeto, skills de uma categoria) —
nem a mais, nem a menos. Caso contrário, `422`. A ordem da lista vira
`position` 0..n-1. Resposta `204`.

---

## 5. Autenticação e autorização

**Fluxo (AD-3):**
1. App envia `POST /auth/login` com `clientPlatform` = `WEB` ou `MOBILE`.
2. API devolve access token JWT (curto, ~15 min) e o refresh token opaco
   (~30 dias): no body para `MOBILE`, em cookie httpOnly `SameSite=Strict` com
   `Path=/api/v1/auth` para `WEB`.
3. App envia `Authorization: Bearer <access>` nas rotas Admin. Access vive
   **só em memória** no app.
4. Ao receber `401` (ou preventivamente), app chama `POST /auth/refresh`; a API
   rotaciona o refresh (o antigo morre) e devolve um par novo.
5. Reuso de um refresh já rotacionado revoga a família inteira: o Admin
   precisa logar de novo. `POST /auth/logout` revoga explicitamente.

A API é **stateless** para o access token; o refresh é o único estado de
sessão, persistido como hash. Não há sessão de servidor.

**Autorização (AD-7):** rotas são protegidas por padrão; público é opt-in
explícito na API. Como só existe um Admin, não há `403` por falta de permissão
— só `401`. Nada nas respostas descreve capacidades: o app sabe se está logado.

---

## 6. Ordenação e paginação

- **Sem paginação.** Volume de portfólio é pequeno e limitado por natureza.
- **Cronológicas:** `experiences` por `endDate` nulo primeiro, depois
  `startDate` desc; `educations` por `endYear` nulo primeiro, depois
  `startYear` desc. `contact-messages` por `createdAt` desc.
- **Editoriais (`position` asc):** `projects`, `projects/{id}/images`,
  `skill-categories`, `skills` (dentro da categoria), `offerings`,
  `contact-links`.
- Itens novos entram no **fim** (`position` = max + 1).

---

## 7. Formato de erros

Toda resposta de erro tem o mesmo corpo, tipado no OpenAPI como
`ErrorResponse`:

```json
{
  "statusCode": 422,
  "code": "VALIDATION_FAILED",
  "message": "Dados inválidos.",
  "details": {
    "email": ["deve ser um e-mail válido"],
    "message": ["não pode ser vazio"]
  }
}
```

| HTTP | `code` | Quando | `details` |
|------|--------|--------|-----------|
| 400 | `BAD_REQUEST` | JSON malformado, multipart sem arquivo | — |
| 401 | `UNAUTHENTICATED` | Sem token, token inválido/expirado, refresh inválido | — |
| 404 | `NOT_FOUND` | Recurso inexistente (inclui slug) | — |
| 413 | `PAYLOAD_TOO_LARGE` | Upload acima do limite | — |
| 415 | `UNSUPPORTED_MEDIA_TYPE` | Tipo de imagem não aceito | — |
| 422 | `VALIDATION_FAILED` | Validação de DTO; `reorder` com conjunto errado | por campo |
| 429 | `RATE_LIMITED` | Throttle em `/auth/login` e `POST /contact-messages` | — |
| 500 | `INTERNAL` | Falha não tratada; sem detalhes | — |

`message` é texto exibível em PT-BR. O app trata por `code`, nunca por
`message`.

---

## 8. Imagens

- Entidades com imagem: `Profile` (uma) e `Project` (galeria).
- Tipos aceitos: `image/jpeg`, `image/png`, `image/webp`. Tamanho máximo por
  arquivo: **5 MB**. Máximo de **12** imagens por projeto.
- A API devolve sempre **URLs absolutas, públicas e permanentes**. A chave é
  imutável: substituir a foto de perfil gera nova URL. O app pode cachear por
  URL indefinidamente.
- Apagar a entidade (ou a imagem) apaga o arquivo.

---

## 9. Requisitos não-funcionais transversais

- **Same-site obrigatório** entre Flutter Web e API (AD-3). A borda (Caddy)
  serve os dois sob a **mesma origem** (`/` → web, `/api` → API) em dev **e**
  em prod, o que dispensa CORS. A API mantém `CORS_ORIGINS` configurável
  apenas como salvaguarda; o valor normal é vazio.
- **Segredos** em `.env` (fora do git). Specs não contêm credenciais.
- **Contrato executável:** `api/openapi.json` é emitido a partir do código e
  versionado. Mudou o contrato → regenera o cliente Dart no mesmo PR. CI falha
  se o arquivo estiver desatualizado.
- **Rate limit** nas duas rotas públicas de escrita/autenticação.
- **Sem dados sensíveis em logs**: nunca logar tokens, senhas ou o corpo de
  `/auth/*`.
