# Toolchain Flutter + Android SDK para dev, testes e builds (ADR 0005).
# Roda como root porque o SDK (checkout git em /sdks/flutter) precisa escrever
# no próprio cache; o entrypoint devolve ao dono do host o que for criado
# no bind mount /app.
ARG FLUTTER_VERSION=stable
FROM ghcr.io/cirruslabs/flutter:${FLUTTER_VERSION}
COPY entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint \
    && git config --system --add safe.directory '*'
WORKDIR /app
ENTRYPOINT ["entrypoint"]
CMD ["flutter", "--version"]
