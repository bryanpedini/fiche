ARG ALPINE_VERSION="3"
# Stage 1 · builder
FROM alpine:${ALPINE_VERSION} AS builder

WORKDIR /usr/src/fiche
COPY . .

RUN apk update && apk add \
    make \
    gcc \
    g++ && \
    make && \
    make install && \
    make clean

# Stage 2 · app
FROM alpine:${ALPINE_VERSION} AS app

WORKDIR /opt/fiche
COPY --from=builder /usr/local/bin/fiche /usr/local/bin/fiche
COPY docker-entrypoint.sh /docker-entrypoint.sh

VOLUME /opt/fiche/code

ENTRYPOINT ["/docker-entrypoint.sh"]
