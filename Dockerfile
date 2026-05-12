FROM debian:stable-slim AS builder

RUN apt-get update -y && \
  apt-get install -y  git curl cmake unzip gettext ninja-build build-essential

COPY neovim /neovim

WORKDIR /neovim

RUN make CMAKE_BUILD_TYPE=Release && make install

FROM ubuntu:24.04

LABEL maintainer="CallOrRet CallOrRet@icloud.com"

WORKDIR /root

ARG TARGETARCH

COPY --from=builder /usr/local /usr/local

RUN apt-get update -y && \
  apt-get install -y git fzf wget curl fish unzip fd-find ripgrep build-essential

RUN cat > /usr/local/bin/osc52-copy <<'EOF' \
  && chmod +x /usr/local/bin/osc52-copy \
  && ln -sf /usr/local/bin/osc52-copy /usr/local/bin/pbcopy
#!/bin/sh
# Copy stdin to the local terminal clipboard via OSC52.
# Works in terminals that support OSC52: Ghostty, WezTerm, iTerm2, kitty, etc.

printf '\033]52;c;'
base64 | tr -d '\r\n'
printf '\a'
EOF

RUN LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*') && \
  case "${TARGETARCH}" in \
  "amd64")  LAZYGIT_ARCH="x86_64" ;; \
  "arm64")  LAZYGIT_ARCH="arm64" ;; \
  *)        exit 1 ;; \
  esac && \
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_${LAZYGIT_ARCH}.tar.gz" && \
  tar xf lazygit.tar.gz lazygit && install lazygit -D -t /usr/local/bin/ && rm -rf lazygit

RUN useradd -m -s /usr/bin/fish agent

COPY ./entrypoint.sh /entrypoint.sh


ENTRYPOINT ["/entrypoint.sh"]
