FROM debian:stable-slim AS base

LABEL maintainer="CallOrRet CallOrRet@gmail.com"

WORKDIR /root

RUN apt-get update -y
RUN apt-get install -y ninja-build gettext cmake unzip curl fd-find ripgrep

COPY ./neovim /root/neovim

WORKDIR /root/neovim

RUN make CMAKE_BUILD_TYPE=Release
RUN make install

FROM debian:stable-slim

LABEL maintainer="CallOrRet CallOrRet@gmail.com"

WORKDIR /root

RUN apt-get update -y
RUN apt-get install -y git curl unzip build-essential

COPY --from=base /usr/local /usr/local

ARG TARGETARCH

COPY ./lemonade/lemonade_${TARGETARCH} /usr/local/bin/lemonade

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
