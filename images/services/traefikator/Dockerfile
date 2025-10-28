FROM alpine:latest

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh
RUN apk add --no-cache openssl
RUN mkdir -p /app/certs

WORKDIR /app/certs

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
