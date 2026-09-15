#!/bin/sh
# Executa o comando e, ao final (sucesso ou falha), entrega ao dono do host
# tudo que foi criado/alterado em /app (bind mount). HOST_UID/HOST_GID vêm
# do Makefile.
status=0
"$@" || status=$?
if [ -n "$HOST_UID" ] && [ -d /app ]; then
  chown -R "$HOST_UID:${HOST_GID:-$HOST_UID}" /app 2>/dev/null || true
fi
exit $status
