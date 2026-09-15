---
status: accepted
---

# Um único app Flutter (público + admin) para web e mobile, aceitando SEO zero

O portfólio tem uma área pública (visitante) e um painel de administração (um
admin). Decidimos que **um único codebase Flutter** serve as duas áreas e é
publicado como Flutter Web e como app nas lojas (Android/iOS), em vez de um
site estático indexável separado do app. Aceitamos conscientemente que o site
público **não é indexável** (Flutter Web renderiza em canvas): o link do
portfólio é sempre compartilhado diretamente (LinkedIn, CV, e-mail), e previews
de link são resolvidos por meta tags estáticas no `index.html` do build web.

## Considered Options

- **Nest servir um shell HTML para crawlers** nas mesmas URLs (Handlebars/EJS),
  entregando Flutter Web para humanos. Rejeitado: duplica a camada de
  apresentação pública dentro da API só para SEO que não é objetivo do projeto.
- **Site público separado e indexável** (Astro/Nuxt/Vue atual) + Flutter só como
  app. Rejeitado: três artefatos para manter, e a área pública deixaria de
  demonstrar Flutter — que é parte do motivo da migração.

## Consequences

- Meta tags OG/description ficam hardcoded no `index.html` do Flutter Web (não
  vêm da API). Mudar o "título" do portfólio exige rebuild do web.
- O primeiro carregamento do site é o de um app Flutter Web (alguns MB); vale
  tratar splash/loading como parte do design, não como acidente.
- A API é consumida por um único cliente com dois modos (visitante / admin), o
  que simplifica versionamento de contrato: não há cliente legado a preservar.
