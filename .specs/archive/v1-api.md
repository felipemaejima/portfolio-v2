# Especificação Local — API (Back-end)

> **Escopo.** Este documento detalha a **implementação** da API: arquitetura
> modular, padrões de código, dependências e ordem de construção. Não repete o
> que está em `global.md` (modelo de domínio, contrato de endpoints, regras de
> acesso, decisões transversais). Onde uma regra de negócio ou formato de
> resposta for necessária, este documento **referencia** a spec global em vez de
> reproduzi-la.

---

## 0. Convenções de base (valem para todo o projeto)

- **Chave primária: UUID** em todas as tabelas. Configurar nos models via trait
  (`HasUuids`) ou os atributos do L13 (`#[Table(...)]` com `keyType: 'string'`,
  `incrementing: false`). As migrations usam `uuid` como PK e `foreignUuid` nas
  FKs. Sem colunas auto-incremento.
- **Idioma — código em inglês, conteúdo em português.** Nomes de tabelas,
  colunas, models, métodos, rotas e campos de API em **inglês** (`profile`,
  `short_description`, `work_modes`). O **conteúdo** armazenado e exibido é em
  **português** (o texto do "Sobre", nomes de projetos, etc.). Enums de domínio:
  o identificador do case em inglês, o rótulo exibível pode ser PT quando
  necessário (ver seção 5, "Enums de domínio").

---

## 1. Ambiente e dependências

- **Framework:** Laravel 13
- **PHP:** 8.3 mínimo; **8.4 recomendado** (Laravel 13.3+ traz componentes
  Symfony 8 que funcionam melhor em 8.4).
- **Banco:** PostgreSQL
- **Autenticação:** Laravel Sanctum (first-party, oficial). Usado no **modo API
  token** (Bearer no header `Authorization`), não no modo cookie/stateful —
  adequado porque front e API ficam em domínios distintos. Instalação via
  `php artisan install:api`, que publica config e a migration de
  `personal_access_tokens`. O model `User` usa a trait `HasApiTokens`.
- **Geração de PDF (CV):** `dompdf` (dompdf), atrás de uma
  interface própria (ver seção 5, "Storage e artefatos desacoplados"). Escolhido
  pela leveza e por não exigir Node/Chromium no container — suficiente porque o
  CV é texto estruturado, sem necessidade de CSS moderno. Fica encapsulado atrás
  da interface, substituível sem afetar o resto.
- **Testes:** Pest
- **Documentação de API:** Scramble (gera OpenAPI a partir do código), conforme
  decisão registrada na global.

Restrições de ambiente (Docker, deploy, storage concreto) vêm da global e de
`infra`; não se repetem aqui.

---

## 2. Arquitetura modular

### Princípio

Organização por **módulo de domínio**, não por tipo de artefato. Cada módulo é
uma fatia vertical autocontida sob `app/Modules/`. Isso mantém coeso tudo que
muda junto (o controller de projeto, seu service, suas requests e resources
vivem lado a lado) e torna cada módulo legível isoladamente.

### Estrutura de um módulo

```
app/Modules/{Modulo}/
├── Controllers/          # Controllers HTTP do módulo
├── Requests/             # Form Requests (validação de entrada)
├── Resources/            # API Resources (serialização de saída)
├── Services/
│   ├── Contracts/        # Interfaces (ports) — o contrato do service
│   └── {Servico}.php     # Implementação (adapter)
├── Models/               # Eloquent models do domínio
├── Enums/                # Enums de domínio do módulo (quando houver)
├── Policies/             # Policies de autorização do módulo
├── Providers/            # Service provider do módulo (bindings, rotas)
└── routes.php            # Rotas do módulo (incluídas pelo provider)
```

Nem todo módulo usa todas as pastas — só o que precisar. Um módulo simples
(ex.: `Service`) pode não ter Policy separada se a autorização for trivial.

### Ports & Adapters (interfaces por módulo)

Cada service expõe uma **interface** em `Services/Contracts/` e uma
**implementação** concreta. Controllers dependem da interface, nunca da
implementação — a resolução acontece via container.

Exemplo de contrato:

```php
namespace App\Modules\Project\Services\Contracts;

interface ProjectService
{
    public function list(): iterable;
    public function findBySlug(string $slug): ?Project;
    public function create(array $data): Project;
    public function update(string $id, array $data): Project;
    public function delete(string $id): void;
}
```

> Nota: identificadores são `string` (UUID), não `int`.

O binding interface → implementação é registrado no provider do módulo:

```php
$this->app->bind(
    \App\Modules\Project\Services\Contracts\ProjectService::class,
    \App\Modules\Project\Services\EloquentProjectService::class,
);
```

**Por que interfaces:** permite trocar implementação sem tocar no controller
(ex.: um service que hoje resolve algo localmente e amanhã delega a um serviço
externo — caso concreto do módulo de contato, cujo processamento pode ser
extraído para um microsserviço externo no futuro). A interface é a costura que
isola essa mudança.

### Registro de módulos

Cada módulo tem um `Providers/{Modulo}ServiceProvider.php` responsável por:
registrar os bindings de interface, carregar `routes.php` do módulo, e registrar
policies. Os providers de módulo são declarados em `bootstrap/providers.php`
(Laravel 11+ não usa mais `config/app.php` para isso).

---

## 3. Divisão de responsabilidades (fluxo de uma requisição)

A cadeia é fixa e vale para todos os módulos:

```
Rota → Controller → Form Request (valida) → Service (regra de negócio)
     → Model (persistência) → API Resource (serializa) → Resposta
```

Regras por camada:

- **Controller:** fino. Recebe a request já validada, chama o service, retorna
  o Resource. Não contém regra de negócio nem query.
- **Form Request:** toda validação de entrada. Nenhuma validação mora no
  controller ou no service. Formato de erro 422 conforme global (seção de erros).
- **Service:** onde vive a regra de negócio. Recebe dados já validados, orquestra
  models, retorna entidades ou dados. Não conhece HTTP (não recebe `Request`, não
  retorna `Response`).
- **Model:** Eloquent. Relações, casts (inclusive cast de enums), scopes. Sem
  regra de negócio de aplicação — só o que é do dado.
- **API Resource:** única forma de serializar saída (decisão global AD-4). Nunca
  retornar model cru.

---

## 4. Autorização

Conforme global (AD-6): autorização é responsabilidade da API, revalidada em toda
ação de escrita.

- Cada módulo com escrita define uma **Policy** (`Policies/{Modelo}Policy.php`).
- Rotas admin são protegidas pelo middleware `auth:sanctum` **e** pela policy do
  recurso. Em Laravel 13, a checagem pode usar o atributo `#[Authorize]` no
  controller, ou `$this->authorize()` explícito — padronizar por um dos dois no
  projeto inteiro (recomendo o atributo, por ser mais declarativo e um recurso
  novo do L13 que vale demonstrar).
- O front recebe o **papel** do usuário autenticado para decidir o que exibir. O
  endpoint `me` retorna `"role": "admin"` ou `"role": "user"`. O front usa esse
  valor apenas para conveniência de UI (mostrar/esconder controles de edição). A
  trava real continua sendo a Policy no endpoint — o `role` não autoriza nada por
  si só; trocá-lo no cliente não concede acesso, porque toda ação de escrita é
  revalidada no back.

O `role` reflete apenas o papel do próprio requisitante — não expõe estrutura de
permissões nem papéis de terceiros.

---

## 5. Convenções transversais da API

- **Versionamento:** todas as rotas sob `/api/v1` (global AD-3). O prefixo é
  aplicado no carregamento das rotas, não repetido em cada `routes.php` de módulo.
- **Serialização:** exclusivamente API Resources (AD-4).
- **Validação:** exclusivamente Form Requests (AD-5).
- **Slug de projeto:** gerado a partir do nome na criação; usado na rota de
  detalhe. Model observer ou lógica no service — decidir no módulo Project.
- **Ordenação:** coleções temporais por data decrescente (global, seção de
  ordenação). Implementar via scope no model.
- **Sem paginação** (global): listagens retornam a coleção completa via Resource
  collection.
- **Chaves:** UUID em todas as tabelas (ver seção 0). Ids nas assinaturas de
  service e nas rotas são `string`.

### Enums de domínio

Conjuntos fixos de valores são modelados como **enums nativos do PHP 8.1+**
(backed enums), com o case em inglês e cast no model. Isso dá validação
centralizada, autocompletar e segurança de tipo.

Enums previstos:

- `Availability` — `CLT`, `PJ`, `FREELANCE`, `CONTRACT`.
- `WorkMode` — `REMOTE`, `HYBRID`, `ON_SITE`.
- `LanguageLevel` — `BASIC`, `INTERMEDIATE`, `ADVANCED`, `FLUENT`, `NATIVE`.
- `Role` (usuário) — `ADMIN`, `USER`.

Notas:

- `availability` e `work_modes` do perfil são **múltiplos** (o admin pode marcar
  mais de um). Persistir como coleção — coluna JSON com cast para array de enum,
  ou tabela de junção. Para volume de portfólio, cast de JSON no model é
  suficiente e mais simples; decidir no módulo User.
- `languages` é uma lista de pares `{ language, level }` onde `level` é o enum
  `LanguageLevel`. `language` é texto livre (nome do idioma, em PT no conteúdo).
- O **rótulo exibível** (ex.: "Presencial" para `ON_SITE`) pode ser resolvido por
  um método no enum (`label()`) retornando PT, mantendo o identificador em inglês.
  Alternativamente, o front cuida da tradução — decidir na fronteira com o
  `web.md`. Por ora, a API expõe o valor do enum (inglês); o rótulo PT é
  responsabilidade de apresentação.

### Storage e artefatos desacoplados

Todo artefato produzido ou armazenado pela aplicação — imagens de projeto, imagem
de perfil e o **PDF do CV** — é tratado de forma **desacoplada**. Nenhum módulo
conhece o provedor de armazenamento concreto.

Princípios:

- **Local definido por ambiente.** O destino de escrita (disco/bucket/caminho) é
  configurado no `.env`, nunca fixado em código. O service escreve no local
  indicado pela configuração — trocar de disco local para storage externo é
  mudança de `.env`, não de código.
- **Escrita via abstração.** Os services usam a abstração de filesystem do Laravel
  (`Storage` / disks configuráveis). O service de escrita grava o arquivo no disco
  configurado e **retorna uma URL temporária** de acesso (URL assinada com
  expiração), em vez de expor caminho fixo ou tornar o arquivo publicamente
  permanente. Isso vale para imagens e para o PDF do CV igualmente.
- **PDF do CV.** A geração do documento fica atrás de uma interface própria
  (ex.: `Contracts/CvGenerator`). A implementação concreta usa dompdf, entrega o arquivo ao service de storage, e o que
  retorna ao cliente é uma **URL temporária** para download — não o binário inline
  nem um caminho permanente. A biblioteca fica isolada atrás da interface e é
  substituível sem afetar contrato.
- **Contrato estável.** Em todos os casos a API devolve uma URL (temporária); a
  origem e o mecanismo de armazenamento são resolvidos por trás da abstração,
  coerente com a global (seção de upload/armazenamento).

---

## 6. Ordem de implementação

Regra geral (sua diretriz): **finalizar um módulo por completo antes de passar ao
próximo** — controller, requests, service (interface + implementação), resource,
policy, migration, model e testes do módulo. Exceção: quando um módulo depende de
outro já existir (FK, relação), o pré-requisito vem antes.

A ordem abaixo respeita dependências de dados e de infraestrutura.

### Fase 0 — Fundação (pré-requisito de tudo)

Não é módulo de domínio, mas precisa existir antes:

1. Setup do projeto Laravel 13, PostgreSQL, `.env`, Docker (via infra).
2. Configuração de base de UUID (trait/atributos padrão nos models) e convenção
   de migrations com `uuid`/`foreignUuid`.
3. Instalação e configuração do Sanctum: `php artisan install:api` (publica
   config e a migration de `personal_access_tokens`), adicionar `HasApiTokens` ao
   model `User`, configurar expiração de token no `config/sanctum.php` (não deixar
   sem expiração em produção). Uso no modo API token (Bearer), não cookie.
4. Configuração de CORS conforme global (origem explícita do front,
   `supports_credentials` false, camada única na API) — publicar `config/cors.php`
   via `php artisan config:publish cors` e restringir `allowed_origins`.
5. Estrutura base de `app/Modules/`, convenção de service provider de módulo,
   registro em `bootstrap/providers.php`.
6. **Seeder do admin.** O usuário admin é criado via seeder, com credenciais
   lidas do `.env` (ex.: `ADMIN_EMAIL`, `ADMIN_PASSWORD`) — nunca hardcoded no
   código. O seeder é idempotente (`updateOrCreate` pelo email) para poder rodar
   sem duplicar. Não há rota de registro público.
7. Base de testes (Pest) e o Resource/Request base se houver abstração comum.

### Fase 1 — Módulo Auth / User (base de identidade)

Primeiro módulo real, porque todo o resto depende de "admin autenticado" e
porque a seção "Sobre" é o próprio perfil do usuário (global).

- Endpoints: `login`, `logout`, `refresh`, `me` (contrato na global).
- Perfil: `GET /profile` (público, só campos de apresentação) e `PUT /profile`
  (admin). Model `User` carrega os campos de apresentação do "Sobre", incluindo
  os enums `Availability`/`WorkMode` (múltiplos) e a lista de `languages` com
  `LanguageLevel`.
- `role` do usuário é o enum `Role` (`ADMIN`/`USER`), exposto em `me`.
- Cuidado de segurança (global): o Resource público do perfil nunca expõe email
  de login nem hash de senha.
- Entrega o middleware/guard que os módulos seguintes vão consumir.

### Fase 2 — Módulo Project

Núcleo do portfólio, e o mais completo (listagem, detalhe por slug, CRUD, galeria
de imagens). Bom segundo módulo porque exercita todos os padrões (upload,
autorização, slug, Resource collection).

### Fase 3 — Skills (SkillCategory + Skill)

Duas entidades relacionadas (categoria 1:N skill). A migration de `skills` tem FK
(`foreignUuid`) para `skill_categories` — por isso a categoria vem primeiro
dentro do módulo. Trata as duas como um módulo `Skill` coeso, já que sempre mudam
juntas.

### Fase 4 — Experience

CRUD simples com ordenação por data decrescente. Sem dependências novas.

### Fase 5 — Education

Análogo a Experience. Simples, sem dependências.

### Fase 6 — Service (serviços oferecidos)

CRUD mais simples do projeto (título + descrição). Rápido.

### Fase 7 — Contact (ContactLink + ContactMessage)

- `ContactLink`: CRUD admin + leitura pública.
- `ContactMessage`: criação pública (visitante) + leitura admin.
- **Ponto de arquitetura:** o service de processamento da mensagem é definido
  **por interface** desde já (`Contracts/MessageDispatcher` ou similar). A
  implementação inicial resolve localmente (enfileira/persiste); uma futura pode
  delegar a um microsserviço externo. Graças à interface, essa troca não toca
  controller nem o contrato público `POST /contact-messages` (global AD-7). Este é
  o caso concreto que justifica a camada de ports/adapters.

### Fase 8 — CV (geração de PDF)

Deixado por último porque **depende dos dados de todos os módulos anteriores**
(perfil, experiência, formação, skills, serviços). Só faz sentido gerar o CV
quando há de onde extrair.

- A geração fica atrás de uma interface (`Contracts/CvGenerator`), conforme a
  seção 5 ("Storage e artefatos desacoplados"). A implementação concreta usa
  dompdf, monta o PDF a partir dos dados atuais, grava no storage configurado pelo
  `.env` e o endpoint retorna uma **URL temporária** de download.
- A biblioteca (dompdf) é detalhe interno da implementação, substituível sem
  afetar contrato nem os demais módulos.
- Endpoint `GET /cv` (público).

### Fase 9 — Documentação e finalização

- Scramble gerando o OpenAPI a partir dos controllers/resources já prontos.
- Revisão de cobertura de testes.
- Ajustes de performance se necessário (índices, eager loading para evitar N+1 —
  ponto que você já tratou em projetos anteriores e que vale cuidar aqui,
  sobretudo em Project com imagens e Skills com categorias).

---

## 7. Testes

- Pest, um conjunto de testes por módulo, escrito junto com o módulo (não depois).
- Prioridade: testes de feature nos endpoints (request → resposta), cobrindo o
  caminho autenticado e o não autorizado (403) de cada ação de escrita — isso
  valida a autorização, que é o ponto sensível.
- Testes de unidade nos services onde houver regra de negócio não trivial.

---

## 8. Notas de desenvolvimento

- **N+1:** com Resource collections e relações (Project→imagens,
  SkillCategory→skills), usar eager loading (`with()`) nos services de listagem.
- **Consistência de módulo:** manter a mesma estrutura de pastas em todos os
  módulos, mesmo que alguns fiquem com pastas vazias — previsibilidade vale mais
  que economia de diretório.
- **Nada de lógica no controller:** se um controller começar a crescer, a regra
  pertence ao service. Esse é o erro mais comum a evitar nesta arquitetura.
- **Atributos do L13:** `#[Authorize]`, `#[Middleware]` e atributos de model são
  novidades da versão que se encaixam bem aqui e demonstram domínio da stack
  atual — mas padronizar o uso (ou usa em todo o projeto, ou em nenhum), para não
  misturar estilos.
- **UUID em toda parte:** models com a trait de UUID, migrations com
  `uuid`/`foreignUuid`, e assinaturas de service/rotas tipadas como `string`. Não
  misturar com auto-incremento.