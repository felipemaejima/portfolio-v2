# portfolio-v2

Portfólio profissional com painel de administração embutido.

- **Site (web):** área pública (sobre, habilidades, projetos, experiência,
  formação, serviços, contato, CV em PDF) e o painel admin em `/admin`.
  É o único artefato hospedado.
- **App Android:** o **mesmo painel admin**, instalado direto no seu celular
  (APK, sem loja) para editar o conteúdo de qualquer lugar. Não tem área
  pública.
- **API:** NestJS + PostgreSQL, consumida pelos dois.

Um único **Admin** (você). Visitantes só leem e enviam mensagens de contato.

```
                    ┌───────────── Caddy (edge, :80/:443, TLS automático) ─────────────┐
  browser ───────►  │  /            → Flutter Web (site + painel)                        │
  app Android ───►  │  /api/v1/*    → API NestJS  ──► PostgreSQL                        │
                    │  /uploads/*   → imagens (volume compartilhado com a API)           │
                    └────────────────────────────────────────────────────────────────────┘
```

## Onde cada coisa está documentada

| O quê | Onde |
|-------|------|
| Contrato da API, modelo de domínio, decisões transversais | [`.specs/GLOBAL.md`](.specs/GLOBAL.md) |
| Implementação da API / do app / da infra | [`.specs/API.md`](.specs/API.md) · [`.specs/APP.md`](.specs/APP.md) · [`.specs/INFRA.md`](.specs/INFRA.md) |
| Glossário (os nomes que o código usa) | [`CONTEXT.md`](CONTEXT.md) |
| Decisões com trade-off e o porquê (ADRs) | [`docs/adr/`](docs/adr/) |
| Contrato executável (gera o cliente Dart) | [`api/openapi.json`](api/openapi.json) |

## Pré-requisitos

**Docker** (com o plugin compose) e **make**. Nada mais: Node, pnpm, Prisma,
Dart, Flutter e o SDK Android rodam em containers. Funciona em Linux, macOS
e Windows (WSL2). A primeira execução baixa imagens grandes (o toolchain
Flutter tem ~7 GB).

## Primeira vez

```sh
git clone git@github.com:felipemaejima/portfolio-v2.git && cd portfolio-v2
make setup
```

`make setup` cria o `.env` a partir do `.env.example`, gera um segredo para
o JWT, constrói as imagens, instala dependências, aplica as migrations e
cria o admin. **Abra o `.env` e defina `ADMIN_EMAIL` e `ADMIN_PASSWORD`**
(rode `make seed` de novo se mudar depois — a senha é re-hasheada a cada
seed).

## Dia a dia

```sh
make up          # API + banco + Caddy — http://localhost/api/v1/health · Swagger em http://localhost/api/docs
make dev         # o mesmo + dev server do Flutter Web em http://localhost/ (painel em /admin)
make app-dev-attach   # terminal do dev server: r = hot reload, R = restart, q = sair
make logs        # logs de tudo
make down        # derruba (mantém banco e uploads); make clean apaga os volumes
make help        # todos os alvos, por seção
```

A API recompila sozinha ao salvar (`nest --watch`). O Flutter Web recompila
com `r` no terminal do dev server.

### Testes e verificação

```sh
make check       # tudo o que o CI roda (abaixo)
make check-api   # lint, build (type-check), unit, e2e contra o Postgres real, contrato em dia
make check-app   # cliente Dart em dia com o contrato, analyze, testes
```

### Mudou a API?

O app não escreve modelos à mão: eles vêm do `openapi.json`.

```sh
make migrate NAME=descricao   # se mexeu no schema Prisma
make openapi                  # reemite api/openapi.json
make app-gen                  # regenera app/lib/api (commit os dois)
```

## Mapa do app Flutter (para quem não conhece Flutter)

Seis lugares explicam 90% do `app/`:

| Onde | O que é |
|------|---------|
| `lib/api/` | **Gerado** do `openapi.json` (`make app-gen`). Nunca edite: modelos (`ProfileDto`…) e chamadas (`RestClient`) vêm daqui. Se a API muda, isso muda sozinho. |
| `lib/core/auth/` | Sessão. `AuthNotifier` faz o boot (tenta o refresh, depois `me`), login e logout. Access token só em memória; refresh em cookie (web) ou secure storage (Android). |
| `lib/core/network/dio.dart` | O cliente HTTP: anexa o bearer e, num 401, faz um refresh e repete a request. `uploads.dart` são as únicas chamadas escritas à mão (multipart). |
| `lib/core/router/app_router.dart` | Todas as rotas e a guarda de `/admin`. No Android o app abre em `/admin`. |
| `lib/features/<x>/` | Uma pasta por área (profile, projects, skills…), cada uma com `data/` (chama a API), `application/` (estado com Riverpod) e `presentation/` (telas; `admin/` dentro). Para adicionar uma tela, copie a de uma feature parecida. |
| `lib/l10n/app_pt.arb` | Todo texto exibido. Mudar um rótulo é aqui, não no widget. |

Regras que evitam sustos: estado vem de providers (`ref.watch(...)`), nunca de variáveis globais; erros da API viram `ApiFailure` e o app decide pelo `code` do contrato; em build de debug a tela mostra a causa técnica de qualquer erro de carregamento.

## O painel admin no celular

O APK é para **você**, não para uma loja. Duas formas:

**Contra a API hospedada (uso normal):**
```sh
make build-apk API_BASE_URL=https://seu-dominio.com
# instale app/build/app/outputs/flutter-apk/app-arm64-v8a-release.apk no aparelho
```

**Contra a API rodando na sua máquina (desenvolvimento):** celular e máquina
na mesma rede.
```sh
make build-apk-dev API_BASE_URL=http://<ip-da-máquina>   # só o build de debug aceita http
```

Hot reload no aparelho (ADB por Wi-Fi) está em [`INFRA.md` §6](.specs/INFRA.md).

## Produção (só o web + API)

Um servidor com Docker, um domínio apontando para ele e as portas 80/443
abertas. O Caddy emite o certificado TLS sozinho.

1. Clone o repositório no servidor e crie o `.env` com **valores reais**:
   `JWT_ACCESS_SECRET` (`make secret`), `ADMIN_EMAIL`, `ADMIN_PASSWORD`,
   `COOKIE_SECURE=true`, `SITE_ADDRESS=https://seu-dominio.com`, e uma senha
   forte em `POSTGRES_PASSWORD` (refletida em `DATABASE_URL`).
   **A API se recusa a subir em produção com os valores de exemplo.**
2. `make prod-up` — constrói as imagens (a do edge compila o Flutter Web
   por dentro), aplica migrations, cria/atualiza o admin, sobe tudo.
3. `make prod-ps`, `make prod-logs` para acompanhar. Atualizar = `git pull`
   + `make prod-up`. Trocar a senha do admin = editar o `.env` +
   `make prod-restart`.

Backups (funcionam com dev ou prod no ar): `make db-backup`,
`make uploads-backup`; restauração com `db-restore FILE=…` e
`uploads-restore FILE=…`.

## Segurança — o que já está feito

- Sessão: access token JWT curto só em memória; refresh opaco, rotativo,
  revogável, em cookie `HttpOnly; Secure; SameSite=Strict` restrito a
  `/api/v1/auth` no web e em secure storage no Android; reuso de refresh
  revoga a família inteira ([ADR 0002](docs/adr/0002-jwt-com-refresh-rotativo-e-cookie-so-no-web.md)).
- Toda rota exige o admin por padrão; público é opt-in explícito. Senha
  com argon2id. Rate limit no login e no formulário de contato.
- Uploads validados pelo conteúdo (magic bytes: jpeg/png/webp, 5 MB),
  chave imutável, sem path traversal; servidos pelo Caddy, nunca pela API.
- Produção recusa `.env` com placeholders ou sem `COOKIE_SECURE`/HTTPS;
  headers de segurança e HSTS no Caddy; API roda sem root; Swagger só em
  dev; segredos fora do git.

## Se algo não carrega

| Sintoma | Causa provável | O que fazer |
|---------|----------------|-------------|
| App no celular abre mas nada carrega | máquina inacessível pela rede (firewall na porta 80) ou APK de release apontando para `http` | abra `http://<ip>/api/v1/health` no navegador do celular; para `http` use `build-apk-dev`; em build de debug o app mostra a causa técnica embaixo do erro |
| `make prod-up` não sobe a API | `.env` de exemplo | `make prod-logs` lista campo a campo o que corrigir |
| Site mostra dados velhos | cache do navegador do `main.dart.js` | recarregar forte; o Caddy já serve `flutter_service_worker.js` sem cache |
| `make app-gen-check` falha no CI | contrato mudou e o cliente não foi regenerado | `make app-gen` e commit `app/lib/api` |

## Estado

- [x] API — todas as fases de `.specs/API.md`
- [x] Site web — todas as seções e o painel
- [x] App Android — painel admin, distribuição direta por APK
- [ ] Domínio + TLS no servidor (passo "Produção" acima)
