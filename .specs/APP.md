# Especificação Local — App (Flutter)

> **Escopo.** Implementação do app Flutter: arquitetura, dependências,
> fluxo de auth no cliente, rotas, geração do cliente da API, build por
> plataforma e ordem de construção. Não repete `GLOBAL.md` (contrato, domínio,
> erros) nem `INFRA.md` (containers, borda, CI). Onde precisar do contrato,
> **referencia**.

---

## 0. Convenções de base

- **Flutter stable, Dart 3.** Versão fixada pela imagem Docker do toolchain
  (`INFRA.md`); o `pubspec.yaml` declara `sdk` compatível.
- **Código em inglês, UI em PT-BR.** Todo texto exibido vem de ARB (`intl` /
  `flutter_localizations`), inclusive os **rótulos dos enums** da API
  (`ON_SITE` → "Presencial"). Um único locale hoje; a estrutura existe para
  não espalhar strings.
- **Nada do host** (global AD-13): `flutter`, `dart run build_runner`,
  `flutter test`, builds — tudo via `docker compose run --rm app …`.
- Lint: `flutter_lints` + regras estritas (`prefer_final_locals`,
  `always_declare_return_types`, `avoid_dynamic_calls`).
- **Sem iOS na v2** (ADR 0001, decisão de plataformas), mas **sem dependência
  que não tenha suporte iOS**: quando iOS entrar, é build, não refatoração.

---

## 1. Dependências

| Papel | Pacote | Nota |
|-------|--------|------|
| Estado / DI | `flutter_riverpod`, `riverpod_annotation` (+ `riverpod_generator`) | `AsyncNotifier` para dados da API |
| Rotas | `go_router` | path URL strategy no web |
| HTTP | `dio` | interceptors de auth/refresh/erro |
| Cliente gerado | `retrofit`, `freezed`, `json_serializable`; gerador `swagger_parser` (dev) | ADR 0004; `lib/api/` é gerado |
| Token store | `flutter_secure_storage` | só mobile; no web o refresh é cookie |
| Imagens | `cached_network_image`, `image_picker` | URLs são permanentes → cache agressivo |
| Links | `url_launcher` | `ContactLink.url`, download do CV |
| Reordenar | `ReorderableListView` (SDK) | nada externo |
| i18n | `intl`, `flutter_localizations` | ARB em `lib/l10n/` |
| Config | `--dart-define` (`API_BASE_URL`) | sem `.env` no app |
| Testes | `flutter_test`, `mocktail` | |

---

## 2. Estrutura

Feature-first. Cada feature tem as três camadas; a área admin de uma feature
vive **dentro da feature**, não numa pasta `admin/` global — o que muda junto
(o modelo de Project e sua tela de edição) fica junto.

```
app/
├── lib/
│   ├── main.dart                   # ProviderScope + runApp
│   ├── app.dart                    # MaterialApp.router, tema, l10n
│   ├── api/                        # GERADO por swagger_parser — não editar
│   ├── l10n/                       # app_pt.arb (+ enums labels)
│   ├── core/
│   │   ├── config/                 # AppConfig(apiBaseUrl) via dart-define
│   │   ├── network/                # dioProvider, AuthInterceptor, RefreshInterceptor, ErrorInterceptor
│   │   ├── auth/                   # TokenStore (port), SecureTokenStore, WebTokenStore, AuthNotifier, AuthState
│   │   ├── router/                 # GoRouter, redirect de /admin, rotas nomeadas
│   │   ├── errors/                 # ApiFailure (mapeia ErrorResponse por `code`)
│   │   └── ui/                     # tema, widgets compartilhados (AsyncValueView, AppScaffold, forms)
│   └── features/
│       ├── home/presentation/      # landing pública: compõe as seções abaixo
│       ├── profile/
│       ├── projects/
│       ├── skills/
│       ├── experiences/
│       ├── educations/
│       ├── offerings/
│       ├── contact/                # links + formulário (público) + inbox (admin)
│       ├── cv/                     # botão que abre GET /cv
│       └── admin_shell/            # login, layout do painel (drawer/nav), guarda
├── test/
├── web/index.html                  # OG/meta tags estáticas (ADR 0001)
├── android/
└── swagger_parser.yaml
```

Camadas de uma feature:

```
features/projects/
├── data/
│   └── projects_repository.dart    # envolve o client gerado; traduz DioException → ApiFailure
├── application/
│   ├── projects_provider.dart      # AsyncNotifier<List<ProjectDto>>  (público)
│   └── project_editor_provider.dart# estado do form/admin: save, delete, reorder, upload
└── presentation/
    ├── projects_section.dart       # público (home)
    ├── project_detail_page.dart    # público (/projects/:slug)
    └── admin/
        ├── projects_admin_page.dart
        └── project_form_page.dart
```

**Modelos:** o app usa os DTOs gerados (`ProjectDto`, `CreateProjectDto`…)
diretamente na UI. Não há camada de "entidade Dart" separada — o contrato é
tipado, gerado e único (ADR 0004). O `data/` existe só para isolar o cliente
gerado e normalizar erros.

---

## 3. Cliente gerado (ADR 0004)

- Fonte: `../api/openapi.json`. Config em `swagger_parser.yaml`:
  `output_directory: lib/api`, `json_serializer: freezed`, `root_client:
  true`, `put_clients_in_folder: true`.
- Script `make app-gen` (ver `INFRA.md`): copia o `openapi.json`, roda
  `swagger_parser`, depois `build_runner`. **`lib/api/` é versionado** (para o
  CI não depender de gerar) e nunca editado à mão.
- Um `RestClient` raiz recebe o `Dio` configurado em `core/network`.
- **Exceção documentada:** se o gerador não produzir multipart utilizável
  para `PUT /profile/image` e `POST /projects/{id}/images`, essas duas
  chamadas são escritas à mão em `core/network/uploads.dart` com `FormData`.
  São as únicas chamadas manuais permitidas.

---

## 4. Rede e autenticação (global seção 5, ADR 0002)

### `Dio`
- `baseUrl` = `AppConfig.apiBaseUrl` (em dev e prod, `/api/v1` relativo à
  mesma origem no web; URL absoluta no Android).
- Web: `BrowserHttpClientAdapter(withCredentials: true)` — obrigatório para o
  cookie de refresh trafegar.
- Interceptors, nesta ordem:
  1. `AuthInterceptor`: anexa `Authorization: Bearer` se houver access em
     memória.
  2. `RefreshInterceptor`: em `401` de rota não-auth, executa **um único**
     refresh em voo (single-flight, `Completer` compartilhado), repete a
     request original uma vez; se o refresh falhar, `AuthNotifier.logout()`.
  3. `ErrorInterceptor`: converte `DioException` em `ApiFailure` por `code`
     do `ErrorResponse` (global seção 7). Rede/timeout → `ApiFailure.network`.

### `TokenStore` (port)
```dart
abstract class TokenStore {
  Future<String?> readRefresh();
  Future<void> writeRefresh(String token);
  Future<void> clear();
}
```
- `SecureTokenStore` (Android/iOS): `flutter_secure_storage`.
- `WebTokenStore`: no-op — o browser guarda o cookie; `readRefresh` devolve
  `null` e o app **tenta o refresh mesmo assim** no boot.
- Escolha por `kIsWeb` num provider.

### `AuthNotifier`
Estado: `unknown → anonymous | authenticated(AdminDto)`.
- **Boot:** chama `POST /auth/refresh` (web: cookie vai sozinho; mobile: com
  o refresh do store; sem refresh no store → `anonymous` direto). Sucesso →
  guarda access em memória, `GET /auth/me` → `authenticated`.
- **Login:** `POST /auth/login` com `clientPlatform: kIsWeb ? WEB : MOBILE`;
  mobile grava `refreshToken` no store.
- **Logout:** `POST /auth/logout`, limpa store e memória → `anonymous`.
- **Access token nunca toca disco.** Só memória.

---

## 5. Rotas (`go_router`)

| Rota | Área | Tela |
|------|------|------|
| `/` | Pública | Home: uma página longa com todas as seções (ver §6) |
| `/projects` | Pública | Todos os projetos (grid), por `position` |
| `/projects/:slug` | Pública | Detalhe do projeto (`fullDescription` + galeria) |
| `/contact` | Pública | Formulário de contato (também embutido na home) |
| `/admin/login` | — | Login |
| `/admin` | Admin | Shell: nav lateral (web) / bottom nav (mobile) |
| `/admin/profile` | Admin | Editar Profile + foto |
| `/admin/projects`, `/admin/projects/new`, `/admin/projects/:id` | Admin | Lista (reorder), form, galeria |
| `/admin/skills` | Admin | Categorias e skills (reorder nos dois níveis) |
| `/admin/experiences`, `/admin/educations`, `/admin/offerings`, `/admin/contact-links` | Admin | CRUDs (reorder onde houver `position`) |
| `/admin/messages` | Admin | Inbox: lida/não lida, apagar |

- `redirect`: qualquer `/admin/**` (exceto `/admin/login`) com estado
  `anonymous` → `/admin/login?from=…`. Estado `unknown` mostra splash até o
  boot de auth terminar.
- Web: `usePathUrlStrategy()` — URLs sem `#`. Exige fallback para
  `index.html` na borda (`INFRA.md`).
- Android app links para o domínio: **fora da v2** (nota para depois).

---

## 6. UI

### Pública
Segue o layout de referência (Claude Design:
`https://claude.ai/artifact/6oAzUafndqPDk4J3Yb5QP4`, artboard "Portfólio").
Ordem das seções na home, cada uma com âncora para a nav:

| Seção | Dados | Notas |
|-------|-------|-------|
| Nav | `Profile.name`, botão "Baixar CV" | links de âncora; no mobile vira menu |
| Hero | `headline`, `name`, `summary`, CTAs "Ver projetos" / "Falar comigo", até 3 `ContactLink` por `position` | |
| Sobre | `imageUrl`, `description`, grid Localização / Disponibilidade / Modalidade / Idiomas | enums → rótulos PT; listas unidas por " e "/" / " |
| Habilidades | `SkillCategory` em colunas (4 no desktop), `Skill` como chips | |
| Projetos | primeiros **6** `Project` por `position` como cards: capa = `images[0]`, `name`, `shortDescription`, `technologies` chips, links Código/Demo; botão "Ver todos" → `/projects` | card sem imagem mostra placeholder |
| Experiência | timeline: período `"jan/2023 — atual"`, `role`, `companyName`, `activities` como bullets | mês abreviado PT-BR, `endDate` nulo = "atual" |
| Formação | período `"2017 — 2021"` (ou só `"2023"` se `startYear == endYear`), `courseName`, `institution` | `endYear` nulo = "atual" |
| Serviços | `Offering` como cards `title` + `description` | rótulo da seção é "Serviços" |
| Contato | `contactIntro`, lista `label — value` (abre `url`), formulário Nome / E-mail / Mensagem | |
| Footer | `© <ano> <name>` | |

- Responsiva: < 600 coluna única e grids empilhados; ≥ 900 layout do
  artboard. Mesmo código no web e no Android.
- Imagens via `cached_network_image` com placeholder; URLs são permanentes,
  cache ilimitado.
- **CV:** botão abre `$API_BASE_URL/cv` com `url_launcher`
  (`LaunchMode.externalApplication`). Web: nova aba/download; Android:
  browser baixa. Não há geração local.
- Contato: formulário `name/email/message`, erros por campo vindos de
  `ApiFailure.validation(details)`; `429` mostra "aguarde um instante".
- Rodapé discreto com link para `/admin/login`.

### Admin
- Formulários com `Form` + `TextFormField`; validação **mínima** local
  (obrigatório) e a real vem da API (`422` → erros por campo).
- Reordenar: `ReorderableListView`; ao soltar, otimista na UI, `PATCH
  …/reorder` com a lista completa; em erro, reverte e mostra snackbar.
- Upload: `image_picker` (galeria/câmera) → multipart. Perfil: um arquivo;
  projeto: múltiplos, respeitando o limite de 12 (global seção 8) — o app
  desabilita o botão ao atingir.
- Delete sempre com confirmação.
- `AsyncValueView` padroniza loading/erro/retry em toda lista.

### Tema
Tokens do layout, como `ThemeData`/`ColorScheme` em `core/ui/theme.dart`:

| Token | Valor |
|-------|-------|
| bg | `#161826` |
| surface / surface-2 | `#232532` / `#2B2D3D` |
| text | `#E9E9ED` |
| neutral 300 / 400 / 500 / 600 / 800 | `#CFD3E5` / `#B2B6CA` / `#9397AB` / `#75798C` / `#3F424D` |
| accent / 100 / 300 / 800 | `#9184D9` / `#F5F4FF` / `#D2CEFD` / `#423A6A` |
| divider | `rgba(233,233,237,0.16)` |
| fonte | Inter (heading e body), **embutida** em `assets/fonts` — sem `google_fonts` em runtime |

Só tema escuro na v2.

### Rótulos de enum
`Availability`, `WorkMode`, `LanguageLevel` → extensões `label(l10n)` em
`core/ui/enum_labels.dart`, lendo do ARB. A API nunca envia rótulo.

---

## 7. Plataformas

### Web
- `flutter build web --release` (CanvasKit; não há mais `--web-renderer`).
  `--dart-define=API_BASE_URL=/api/v1` — mesma origem via Caddy.
- `web/index.html`: `<title>`, `description`, `og:title`, `og:description`,
  `og:image` (imagem estática em `web/`), `theme-color`. Splash simples em
  CSS enquanto o engine carrega (ADR 0001, consequência do bundle).
- `base href` = `/`.

### Android
- `applicationId` próprio; `minSdk 23`; permissão `INTERNET`;
  `usesCleartextTraffic=false` (só HTTPS em release).
- Release: `flutter build appbundle --dart-define=API_BASE_URL=https://<dom>/api/v1`.
  Keystore e senhas via secrets de CI, nunca no repositório (`INFRA.md`).
- Dev: `flutter run` em **dispositivo físico via ADB Wi-Fi** a partir do
  container do toolchain (ADR 0005). Emulador não faz parte do fluxo.

### iOS (fase posterior)
Sem trabalho agora. Restrição vigente: nenhuma dependência sem suporte iOS.

---

## 8. Testes

- **Unit:** notifiers (`AuthNotifier`, editores) com repositórios `mocktail`.
  Cobrem: boot com/sem refresh, single-flight do refresh, reorder otimista com
  rollback, mapeamento de `ApiFailure`.
- **Widget:** login (erro `401` exibido), formulário de contato (`422` por
  campo), uma lista admin com reorder.
- **Sem golden na v2.**
- Tudo via `docker compose run --rm app flutter test`.

---

## 9. Ordem de implementação

Regra: **uma feature por completo** (data, application, presentation público
e admin, testes) antes da próxima, seguindo a ordem em que a API entrega os
módulos.

### Fase 0 — Fundação
1. Scaffold no container do toolchain; lints; l10n; tema.
2. Pipeline de geração: `swagger_parser.yaml`, `make app-gen`, `lib/api/`
   versionado, `build_runner`.
3. `core/config`, `core/network` (Dio + interceptors), `core/errors`.
4. `core/auth` (`TokenStore`, `AuthNotifier`), `core/router` com redirect,
   `admin_shell` (login + layout vazio).

### Fase 1 — Profile
Seção "Sobre" pública + edição admin + foto (primeiro upload).

### Fase 2 — Projects
Cards na home, detalhe por slug com galeria; admin: CRUD, reorder, galeria
com upload múltiplo e reorder de imagens. Estabelece os padrões de lista,
form e reorder que as próximas repetem.

### Fase 3 — Skills · Fase 4 — Experiences · Fase 5 — Educations · Fase 6 — Offerings
Seções públicas + CRUDs admin (reorder onde houver).

### Fase 7 — Contact
Links (público + admin com reorder), formulário público, inbox admin.

### Fase 8 — CV
Botão público.

### Fase 9 — Web release
`index.html` com OG, splash, build via compose, servido pelo Caddy
(`INFRA.md`). Teste manual de cookie/refresh em produção.

### Fase 10 — Android release
Assinatura, `.aab`, Play Console (trilha interna primeiro).
