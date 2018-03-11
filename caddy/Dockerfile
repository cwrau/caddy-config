FROM alpine
LABEL maintainer="CWRau"

RUN apk add --no-cache tar curl bash

ARG plugins=tls.dns.cloudflare

RUN curl --silent --show-error --fail --location --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
      "https://caddyserver.com/download/linux/amd64?plugins=${plugins}" \
    | tar --no-same-owner -C /usr/bin/ -xz caddy && \
    chmod 0755 /usr/bin/caddy && \
    /usr/bin/caddy -version

EXPOSE 80 443
WORKDIR /caddy

CMD ["caddy", "-log", "stdout", "-quic"]
