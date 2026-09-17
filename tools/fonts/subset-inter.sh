#!/bin/sh
# Gera app/assets/fonts/Inter-latin.ttf a partir do release oficial do Inter:
# eixo opsz fixado em 14 e subset Latin (pt-BR + pontuação), ~110 KB em vez de 860 KB.
# Roda em container (python + fonttools). Uso: make app-fonts
set -e
cd "$(dirname "$0")/../.."
docker run --rm -v "$PWD/app/assets/fonts":/f python:3.12-slim sh -c '
  set -e
  pip install -q fonttools brotli >/dev/null
  apt-get update -qq >/dev/null && apt-get install -y -qq curl unzip >/dev/null
  curl -sL -o /tmp/inter.zip https://github.com/rsms/inter/releases/download/v4.1/Inter-4.1.zip
  unzip -q -o /tmp/inter.zip -d /tmp/inter "InterVariable.ttf" "LICENSE.txt"
  fonttools varLib.instancer -q -o /tmp/Inter-opsz.ttf /tmp/inter/InterVariable.ttf opsz=14
  pyftsubset /tmp/Inter-opsz.ttf \
    --unicodes="U+0000-00FF,U+0100-017F,U+2000-206F,U+20AC,U+2022,U+2190-2193,U+2212" \
    --layout-features="kern,liga,calt,ccmp,mark,mkmk,locl,tnum" \
    --output-file=/f/Inter-latin.ttf
  cp /tmp/inter/LICENSE.txt /f/LICENSE-Inter.txt
  ls -la /f/Inter-latin.ttf
'
