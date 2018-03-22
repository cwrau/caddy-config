FROM frolvlad/alpine-gxx
LABEL maintainer="CWRau"

WORKDIR /brotli

RUN apk add --no-cache git bash cmake make

ADD https://api.github.com/repos/google/brotli/compare/master...HEAD /dev/null

RUN git clone https://github.com/google/brotli .

RUN mkdir out && \
    cd out && \
    ../configure-cmake --disable-debug && \
    make

RUN ./out/brotli -V

RUN mv ./out/brotli /bin/brotli

FROM alpine
LABEL maintainer="CWRau"

RUN apk add --no-cache tar curl bash

ARG plugins=tls.dns.cloudflare

RUN curl -sSL -H "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
      "https://caddyserver.com/download/linux/amd64?license=personal&plugins=${plugins}" \
    | tar --no-same-owner -xz caddy && \
    chmod 0755 caddy

RUN ./caddy -version

RUN mv caddy /bin/caddy

FROM alpine
LABEL maintainer="CWRau"

COPY --from=0 /bin/brotli /bin/brotli
RUN brotli -V

COPY --from=1 /bin/caddy /bin/caddy
RUN caddy -version

EXPOSE 80 443
WORKDIR /caddy

CMD ["caddy", "-log", "stdout", "-quic"]
