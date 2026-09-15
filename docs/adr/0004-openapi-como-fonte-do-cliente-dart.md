---
status: accepted
---

# O OpenAPI gerado pela API é a fonte do cliente Dart do app

A API (Nest) emite `openapi.json` a partir dos DTOs (`@nestjs/swagger` + CLI
plugin), e o app Flutter **gera** seu cliente HTTP e modelos a partir desse
arquivo (Retrofit + freezed via `swagger_parser`, ou `openapi-generator`
`dart-dio`). Nenhum modelo de API é escrito à mão no app. Decidimos isso para
que o contrato tenha uma única fonte de verdade e que qualquer mudança na API
quebre o app em **compile-time**, não em runtime.

## Consequences

- Toda resposta da API tem um **DTO de resposta explícito** (classe com
  `@ApiProperty`), inclusive erros. Nada de retornar o resultado do Prisma
  direto: além de vazar campos, o gerador não teria tipo.
- Enums de domínio (`Availability`, `WorkMode`, `LanguageLevel`) são declarados
  no OpenAPI como enums, para virarem enums Dart.
- O `openapi.json` é gerado em build/CI e versionado junto ao código; o script
  de geração do cliente roda no repositório do app. O gerado (`lib/api/`) não é
  editado à mão.
- Nomes de `operationId` importam: viram nomes de método no Dart. Padronizar
  (`projects_list`, `projects_create`…).
