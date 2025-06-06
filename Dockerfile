FROM debian:stable-slim AS builder

RUN apt-get update -y && \
  apt-get install -y ninja-build curl cmake unzip gettext

COPY neovim /neovim

WORKDIR /neovim

RUN make CMAKE_BUILD_TYPE=Release && make install

FROM ubuntu:24.04

LABEL maintainer="CallOrRet CallOrRet@outlook.com"

WORKDIR /root

ARG TARGETARCH

COPY --from=builder /usr/local /usr/local

RUN apt-get update -y && \
  apt-get install -y build-essential git fzf wget curl fish unzip fd-find ripgrep

RUN apt-get install -y locales libicu-dev && \
  locale-gen en_US.UTF-8 && \
  localedef -c -i en_US -f UTF-8 en_US.UTF-8

RUN LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*') && \
  case "${TARGETARCH}" in \
  "amd64")  LAZYGIT_ARCH="x86_64" ;; \
  "arm64")  LAZYGIT_ARCH="arm64" ;; \
  *)        exit 1 ;; \
  esac && \
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_${LAZYGIT_ARCH}.tar.gz" && \
  tar xf lazygit.tar.gz lazygit && install lazygit -D -t /usr/local/bin/ && rm -rf lazygit

COPY ./lemonade/lemonade_${TARGETARCH} /usr/local/bin/lemonade

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
