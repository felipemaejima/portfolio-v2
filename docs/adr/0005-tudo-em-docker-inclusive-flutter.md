---
status: accepted
---

# Todo o ambiente roda em Docker, em dev e em prod — inclusive o toolchain Flutter

Nenhuma ferramenta do projeto é instalada no host além de Docker: Node/pnpm,
Prisma, Postgres, Caddy e o **SDK Flutter + Android SDK** rodam em containers
do mesmo `docker-compose`. Dev e prod têm a **mesma topologia** (borda Caddy
na frente de app e API, mesma origem), diferindo só em targets de imagem,
bind mounts e TLS. Decidimos isso para que o ambiente seja reprodutível em
qualquer máquina e para que o CI use exatamente os mesmos containers.

## Consequences

- Testes e2e da API usam o Postgres do compose (banco `portfolio_test`), não
  Testcontainers — Docker-in-Docker não vale o custo.
- O dev server do Flutter Web roda no container (`flutter run -d web-server`)
  atrás do Caddy; hot reload é acionado pelo terminal do container, não pelo
  browser.
- **Emulador Android não roda em Docker** de forma razoável (precisa de KVM e
  GUI). Teste em Android é feito em **dispositivo físico via ADB Wi-Fi** a
  partir do container, ou instalando o APK gerado. Isso é uma limitação
  aceita, não um bug.
- Builds de release (web, `.aab`) são `docker compose run` — o CI é o mesmo
  comando.
