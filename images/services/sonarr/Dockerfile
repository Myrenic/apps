# ╔═════════════════════════════════════════════════════╗
# ║                      SONARR                         ║
# ╚═════════════════════════════════════════════════════╝
# By Myrenic

# Versions as ARGs for Renovate
ARG SONARR_VERSION=4.0.15.2941
ARG DOTNET_VERSION=8.0.413
ARG APP_UID=1000
ARG APP_GID=1000
ARG APP_ROOT=/config

# ────────────────────────────────
# Builder: download Sonarr release
# ────────────────────────────────
FROM alpine:3.22 AS builder

ARG SONARR_VERSION
WORKDIR /tmp

RUN apk add --no-cache curl tar

# Construct URL statically for Renovate
# Example pattern: https://github.com/Sonarr/Sonarr/releases/download/v4.0.15.2941/Sonarr.main.4.0.15.2941.linux-musl-x64.tar.gz
RUN curl -L https://github.com/Sonarr/Sonarr/releases/download/v${SONARR_VERSION}/Sonarr.main.${SONARR_VERSION}.linux-musl-x64.tar.gz \
    -o sonarr.tar.gz && \
    mkdir /sonarr && \
    tar -xzf sonarr.tar.gz -C /sonarr && \
    rm sonarr.tar.gz
# ────────────────────────────────
# Final: based on custom dotnet distroless
# ────────────────────────────────
FROM mcr.microsoft.com/dotnet/aspnet:10.0-alpine

ARG APP_UID
ARG APP_GID

ENV EXTERNAL_AUTH=false
WORKDIR /app

COPY --from=builder /sonarr/* /app

# Root user
USER root

RUN apk add --no-cache sqlite-libs curl && \
    mkdir -p ${APP_ROOT}/etc && \
    mkdir /config && chown -R ${APP_UID}:${APP_GID} /config

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Non-root user
USER ${APP_UID}:${APP_GID}
EXPOSE 8989
VOLUME /config

HEALTHCHECK --interval=60s --timeout=10s --retries=5 \
  CMD curl -fs http://127.0.0.1:8989/ping >/dev/null || exit 1

ENTRYPOINT ["docker-entrypoint.sh"]
