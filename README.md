# portfolio-v2

Portfólio profissional com painel de administração embutido: **API NestJS**
(`api/`) e **um app Flutter** para web e Android (`app/`, próxima etapa).

Toda a documentação de decisão está no repositório:

| O quê | Onde |
|-------|------|
| Contrato, domínio, decisões transversais | [`.specs/GLOBAL.md`](.specs/GLOBAL.md) |
| Implementação da API / do app / da infra | [`.specs/API.md`](.specs/API.md) · [`.specs/APP.md`](.specs/APP.md) · [`.specs/INFRA.md`](.specs/INFRA.md) |
| Glossário do domínio | [`CONTEXT.md`](CONTEXT.md) |
| Decisões com trade-off (ADRs) | [`docs/adr/`](docs/adr/) |
| Contrato executável | [`api/openapi.json`](api/openapi.json) |

## Rodando

Pré-requisito no host: **Docker** (com o plugin compose) e `make`. Nada mais —
Node, pnpm, Prisma, Dart e Flutter rodam em containers.

```sh
make setup   # primeira vez: .env, imagens, deps, migrations, seed do admin
make up      # http://localhost/api/v1/health · Swagger em http://localhost/api/docs
make check   # lint + build + unit + e2e + contrato em dia (o que o CI roda)
make help    # todos os alvos
```

Credenciais do admin vêm de `ADMIN_EMAIL`/`ADMIN_PASSWORD` no `.env`.

## Estado

- [x] API — fases 0 a 10 de `.specs/API.md` (auth, profile, projects, skills,
      experiences, educations, offerings, contact, cv)
- [ ] App Flutter — `.specs/APP.md`
- [ ] Release web e Android — `.specs/INFRA.md`
