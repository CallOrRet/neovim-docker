FROM debian:stable-slim AS builder

WORKDIR /root

RUN apt-get update -y
RUN apt-get install -y ninja-build gettext cmake unzip curl

COPY ./neovim /root/neovim

WORKDIR /root/neovim

RUN make CMAKE_BUILD_TYPE=Release
RUN make install

FROM debian:stable-slim

LABEL maintainer="CallOrRet CallOrRet@outlook.com"

WORKDIR /root

RUN apt-get update -y
RUN apt-get install -y git wget curl unzip build-essential fzf fd-find ripgrep

COPY --from=builder /usr/local /usr/local

ARG TARGETARCH

COPY ./lemonade/lemonade_${TARGETARCH} /usr/local/bin/lemonade

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
