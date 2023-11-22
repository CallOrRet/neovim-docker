FROM alpine AS base

LABEL maintainer="push-edp aspushedp@gmail.com"

WORKDIR /root

RUN apk update
RUN apk add bash git build-base cmake coreutils curl unzip gettext-tiny-dev

COPY ./neovim /root/neovim

WORKDIR /root/neovim

RUN make CMAKE_BUILD_TYPE=Release
RUN make install

FROM alpine AS nvim

WORKDIR /root

RUN apk update
RUN apk add bash git curl unzip make gcc
RUN apk add build-base

COPY --from=base /usr/local /usr/local

ARG TARGETARCH

COPY ./lemonade/lemonade_${TARGETARCH} /usr/local/bin/lemonade

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
