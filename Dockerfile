FROM alpine

LABEL maintainer="push-edp aspushedp@gamil.com"

WORKDIR /root

RUN apk update
RUN apk add bash git build-base cmake coreutils curl unzip gettext-tiny-dev

ENTRYPOINT ["bash"]
