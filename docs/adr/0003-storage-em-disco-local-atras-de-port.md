---
status: accepted
---

# Storage de arquivos em disco local, único adapter, atrás de um port

Imagens (perfil, galeria de projetos) e artefatos gerados são gravados em
**disco local** (volume persistente) e servidos como **URLs públicas
permanentes** com chave imutável (`uuid.ext`; substituir = nova chave, nunca
sobrescrever). Não escrevemos adapter S3 agora: o volume de um portfólio não
justifica infra extra (bucket, MinIO em dev, credenciais). A escrita passa por
um port `FileStorage` para que S3 seja, no futuro, um adapter novo + migração
de arquivos — não uma reescrita.

## Consequences

- O deploy precisa de volume persistente montado na API (escrita) e na borda
  (leitura); o Caddy serve os bytes sob `/uploads` em dev e em prod. A API
  nunca serve arquivos.
- URL assinada/temporária deixa de ser regra geral (era na v1); imagens
  públicas são cacheáveis por CDN e pelo app.
- Upload é sempre via API (multipart); não há upload direto do cliente para o
  storage.
