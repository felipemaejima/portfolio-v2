---
status: accepted
---

# JWT curto + refresh opaco rotativo; refresh viaja em cookie httpOnly no web e no body no mobile

Só existe um Admin autenticável (não há registro nem outros papéis), e o
mesmo app Flutter roda em web e mobile. Decidimos: **access token JWT de curta
duração** (stateless) + **refresh token opaco de longa duração**, persistido
como hash, rotacionado a cada uso e revogado no logout. No **mobile** o refresh
vive em secure storage e é enviado no body de `/auth/refresh`; no **web** ele
vive num **cookie httpOnly `SameSite=Strict`** com `Path` restrito às rotas de
auth, porque o browser não oferece storage seguro. O cliente informa a
plataforma no login (`client_platform`); a API nunca infere isso por
User-Agent.

## Considered Options

- **Token opaco único estilo Sanctum** (sem JWT, lookup no banco por request).
  Rejeitado: não exercita o padrão JWT/Passport que a migração para Nest quer
  demonstrar; sessão longa no mobile exigiria tokens de vida longa sem rotação.
- **Refresh em localStorage no web, mesmo fluxo do mobile.** Rejeitado pelo
  autor em favor de proteção contra XSS, mesmo Flutter Web renderizando em
  canvas. Custo aceito: dois fluxos de entrega do refresh e cookie na API.

## Consequences

- Revoga a regra "sem cookie" da v1: a API continua sem sessão de servidor,
  mas usa cookie como **transporte** do refresh no web.
- **Web e API devem ser same-site** (mesmo domínio registrável) para o cookie
  `SameSite=Strict` funcionar. Restrição de deploy herdada pela infra.
- CORS com `credentials: true` e origem explícita (nunca `*`).
- `/auth/refresh` e `/auth/logout` são alvos de CSRF em tese; `SameSite=Strict`
  + checagem de `Origin` cobrem. A rotação com detecção de reuso (refresh já
  usado ⇒ revoga a família inteira) fecha o roubo de refresh.
