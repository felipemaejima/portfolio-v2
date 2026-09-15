# Especificação Global — Portfolio Project

> **Escopo deste documento.** Esta é a especificação **global** do sistema: o
> contrato entre back-end e front-end, o modelo de domínio e as decisões
> arquiteturais transversais. Não descreve implementação interna de nenhum dos
> lados (estrutura de camadas da API, componentes do Vue, etc.) — isso vive nas
> specs locais `/specs/api` e `/specs/web`. A regra de fronteira: **se os dois
> lados precisam concordar sobre algo, está aqui; se um lado pode mudar sem
> quebrar o outro, está na spec local daquele lado.**

---

## 1. Visão geral

Aplicação de portfólio profissional com gerenciamento de conteúdo via painel
administrativo. Um único usuário **admin** edita todas as informações;
visitantes **não autenticados** apenas visualizam.

Arquitetura: **monorepo** com dois artefatos independentes:

- **`api/`** — API REST em Laravel, servida isoladamente.
- **`web/`** — SPA em Vue (build estático), consome a API.

Não há SSR. O front é estático; a API é a única fonte de dados.

### Stack e dependências (escolhas iniciais)

- **API:** Laravel (PHP). Autenticação Sanctum. Geração de PDF para o CV.
- **Front:** Vue como SPA, sem SSR. Build estático servido isoladamente.
- **Infra:** monorepo coordenado por Docker Compose. Front e API deployados como
  artefatos separados.

As versões concretas e bibliotecas específicas de cada lado ficam nas specs
locais.

---

## 2. Decisões arquiteturais (ADRs resumidos)

Estas decisões são **restrições acordadas**. A implementação deve respeitá-las em
todo lugar.

| # | Decisão | Justificativa |
|---|---------|---------------|
| AD-1 | **SPA + API separadas** (não Inertia/SSR) | O contrato de API é o artefato central; front e back evoluem e deployam de forma independente. |
| AD-2 | **Autenticação via Sanctum (Bearer token)** | Front guarda o token e envia `Authorization: Bearer <token>`; API stateless, sem sessão/cookie. |
| AD-3 | **Versionamento de API sob `/api/v1`** | Permite evolução sem quebra. |
| AD-4 | **Serialização exclusivamente via API Resources** | Nunca retornar model Eloquent cru; o formato de saída é contrato, não detalhe. |
| AD-5 | **Validação via Form Requests** | Entrada validada na borda; erros em formato padronizado (seção 7). |
| AD-6 | **Autorização é responsabilidade da API** | O front esconde/mostra UI por conveniência; a trava real é Policy/Gate no back, revalidada em toda ação de escrita. |
| AD-7 | **Contato recebido pelo Laravel; dispatch delegado a microsserviço (fase futura)** | A API recebe e enfileira a mensagem; o processamento/envio será feito por serviço externo, abstraído atrás da API. O contrato público (`POST /contact-messages`) não muda quando o Serviço entrar. Detalhes na spec local `/specs/api`. |
| AD-8 | **Documentação de API via OpenAPI** (Scramble) | O contrato é executável e verificável, não só prosa. |

---

## 3. Modelo de domínio

### Natureza das seções

Três categorias, com impacto direto no desenho de endpoints:

- **Perfil do usuário** (dados do admin autenticado; a seção "Sobre" é a edição
  do próprio perfil): `User`.
- **Singleton público** (registro único, editável): os **contatos/links**
  exibidos na seção de contato (`ContactLink` funciona como coleção pequena; ver
  abaixo).
- **Coleção** (lista com múltiplos itens, CRUD completo): `Project`, `Skill`,
  `SkillCategory`, `Experience`, `Education`, `Service`, `ContactMessage`.

### Entidades

**User** *(perfil do admin — origem da seção "Sobre")*

Os dados do "Sobre" residem no registro do usuário admin. A tela "Sobre" é a
edição do próprio perfil. Além das credenciais de autenticação (email, senha),
o registro carrega os campos de apresentação:
- `description` — texto do "Sobre mim"
- `location` — { city, state, country }
- `availability` — múltiplos de: `CLT`, `PJ`, `Freelance`, `Contrato`
- `work_modes` — múltiplos de: `Remoto`, `Híbrido`, `Presencial`
- `languages` — lista de { language, level }
- `profile_image` — imagem

Como só há um admin, o perfil público exposto é o desse usuário. A leitura
pública retorna apenas os campos de apresentação — nunca email de login, hash de
senha ou qualquer dado sensível de autenticação.

**Project** *(coleção)*
- `name`
- `short_description` — usada na listagem
- `full_description` — usada no detalhe
- `technologies` — lista
- `code_url` — nullable
- `demo_url` — nullable
- `images` — lista de imagens
- `slug` — derivado de `name`, usado na rota de detalhe (`/projects/:slug`)

**SkillCategory** *(coleção)*
- `name` (ex.: Linguagem, Banco de Dados)
- `skills` — relação 1:N com `Skill`

**Skill** *(coleção)*
- `name`
- `category_id` — pertence a uma `SkillCategory`

**Experience** *(coleção)*
- `role` — cargo
- `company_name`
- `activities` — descrição/lista de atividades
- `start_date` — mês/ano
- `end_date` — mês/ano, nullable (emprego atual)

**Education** *(coleção)*
- `course_name`
- `institution`
- `start_year`
- `end_year` — nullable

**Service** *(coleção)*
- `title`
- `description`

**ContactLink** *(coleção — exibição pública)*
- `label` (ex.: Email, LinkedIn, GitHub)
- `value` (ex.: email@email.com, URL)

**ContactMessage** *(coleção — gerada por visitantes, lida pelo admin)*
- `name`
- `email`
- `message`
- `created_at`

As mensagens são **persistidas** (o admin consulta o histórico) e enfileiradas
para dispatch. O envio efetivo será feito pelo microsserviço em fase futura,
abstraído atrás da API (AD-7); o contrato público não muda quando o Serviço entrar.

---

## 4. Superfície de endpoints (contrato)

Convenções:
- **Público** = acessível sem autenticação (somente leitura).
- **Admin** = requer token Token válido; escrita.
- Listagens retornam a coleção completa, ordenada conforme a seção 6.

### Autenticação (Sanctum)
| Método | Rota | Acesso | Descrição |
|--------|------|--------|-----------|
| POST | `/api/v1/login` | Público | Autentica o admin; retorna o token. |
| POST | `/api/v1/logout` | Admin | Invalida o token atual. |
| POST | `/api/v1/refresh` | Admin | Renova o token. |
| GET | `/api/v1/me` | Admin | Retorna o usuário autenticado (alimenta o estado do front). |

### Perfil / Sobre
| Método | Rota | Acesso | Descrição |
|--------|------|--------|-----------|
| GET | `/api/v1/profile` | Público | Campos de apresentação do admin (a seção "Sobre"). Nunca expõe dados de autenticação. |
| PUT | `/api/v1/profile` | Admin | Edita o próprio perfil. |

### Projects
| Método | Rota | Acesso |
|--------|------|--------|
| GET | `/api/v1/projects` | Público (listagem) |
| GET | `/api/v1/projects/{slug}` | Público (detalhe) |
| POST | `/api/v1/projects` | Admin |
| PUT | `/api/v1/projects/{id}` | Admin |
| DELETE | `/api/v1/projects/{id}` | Admin |

### Skill Categories & Skills
| Método | Rota | Acesso |
|--------|------|--------|
| GET | `/api/v1/skill-categories` | Público (categorias com skills aninhadas) |
| POST | `/api/v1/skill-categories` | Admin |
| PUT | `/api/v1/skill-categories/{id}` | Admin |
| DELETE | `/api/v1/skill-categories/{id}` | Admin |
| POST | `/api/v1/skills` | Admin |
| PUT | `/api/v1/skills/{id}` | Admin |
| DELETE | `/api/v1/skills/{id}` | Admin |

### Experience / Education / Services
Cada um segue o mesmo padrão CRUD:
| Método | Rota | Acesso |
|--------|------|--------|
| GET | `/api/v1/{recurso}` | Público |
| POST | `/api/v1/{recurso}` | Admin |
| PUT | `/api/v1/{recurso}/{id}` | Admin |
| DELETE | `/api/v1/{recurso}/{id}` | Admin |

Onde `{recurso}` ∈ { `experiences`, `education`, `services` }.

### Contact
| Método | Rota | Acesso |
|--------|------|--------|
| GET | `/api/v1/contact-links` | Público |
| POST | `/api/v1/contact-links` | Admin |
| PUT | `/api/v1/contact-links/{id}` | Admin |
| DELETE | `/api/v1/contact-links/{id}` | Admin |
| POST | `/api/v1/contact-messages` | Público (visitante envia mensagem) |
| GET | `/api/v1/contact-messages` | Admin (lê mensagens recebidas) |

O `POST /contact-messages` persiste a mensagem e a enfileira. O processamento/envio
será delegado ao microsserviço Go (fase futura, AD-7), abstraído pelo Laravel — o
contrato acima permanece estável independentemente dessa mudança interna.

### CV
| Método | Rota | Acesso |
|--------|------|--------|
| GET | `/api/v1/cv` | Público |

O CV é **gerado sob demanda** em PDF a partir dos dados da aplicação (Perfil +
Experience + Education + Skills + Services). Não há upload de arquivo estático —
o PDF reflete sempre o estado atual dos dados. A biblioteca de geração e o
layout do documento são detalhe da spec local `/specs/api`.

---

## 5. Autenticação e autorização

**Fluxo (AD-2, Sanctum / Bearer):**
1. Front envia `POST /api/v1/login` com credenciais.
2. API retorna um token.
3. Front armazena o token e o envia em `Authorization: Bearer <token>` nas
   requisições autenticadas.
4. `POST /api/v1/refresh` renova o token; `POST /api/v1/logout` o invalida.

A API é **stateless** — sem sessão de servidor nem cookie. Onde o front guarda o
token (memória, storage) é decisão da spec local `/specs/web`, com o trade-off de
segurança correspondente registrado lá.

**Autorização (AD-6):**
- Toda rota Admin é protegida por middleware de autenticação **e** por
  Policy/Gate no back. O front nunca é autoridade.
- Recursos que o admin pode editar expõem um bloco de **capacidades do próprio
  usuário** para consumo do front:
  ```json
  "role": "admin" || "user" (não autenticado)
  ```
  Calculado pela mesma Policy que barra a ação real. Expõe apenas a capacidade
  do **requisitante** sobre **aquele** recurso — nunca a estrutura de permissões
  nem capacidades de terceiros. É dica de UI, não trava.

---

## 6. Ordenação

- Não há paginação: as listagens retornam a coleção completa. O volume de dados
  de um portfólio é pequeno e limitado por natureza.
- Coleções com noção temporal (`experiences`, `education`, `projects`) são
  ordenadas por **data decrescente** (mais recente primeiro).
- Demais coleções seguem ordem natural de exibição, definida na spec local.

---

## 7. Formato de erros

Toda resposta de erro segue um formato único e consistente, detalhado no
documento de contrato:

- **422** — falha de validação, com corpo listando os campos e suas mensagens.
- **401** — não autenticado em rota que exige auth.
- **403** — autenticado mas sem permissão.
- **404** — recurso inexistente.

O front trata esses códigos de forma consistente; o formato é contrato.

---

## 8. Upload de imagens

Entidades com imagem: `User` (perfil), `Project` (galeria).

O armazenamento é **desacoplado** — a aplicação trata imagens através de uma
abstração de storage, sem acoplar a um provedor específico. A escolha concreta
(disco local, storage externo) é detalhe da spec local `/specs/api` e pode mudar
sem afetar o contrato: a API sempre retorna URLs de imagem, independentemente da
origem.

---

## 9. Requisitos não-funcionais transversais

- **CORS:** configurado para o domínio do front; token via header `Authorization`, sem cookie (AD-2).
- **Ambiente:** segredos em `.env` (fora do git). Specs não contêm credenciais.
- **Deploy:** dois artefatos — front estático (Nginx/CDN) e API Laravel.
  Coordenação via Docker Compose no monorepo.
- **Documentação de API:** o formato detalhado de request/response é definido em
  documento de contrato próprio (OpenAPI), versionado junto ao código. A spec
  base referencia; não duplica.

---

Detalhes de implementação de cada ponto ficam nas specs locais `/specs/api` e
`/specs/web`.