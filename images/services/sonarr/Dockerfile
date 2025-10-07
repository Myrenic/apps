# ╔═════════════════════════════════════════════════════╗
# ║                      RADARR                         ║
# ╚═════════════════════════════════════════════════════╝
# By Myrenic

ARG APP_UID=1000
ARG APP_GID=1000
ARG APP_ROOT=/config

# ────────────────────────────────
# Versions for Renovate
# ────────────────────────────────
# renovate: datasource=github-releases depName=radarr/radarr versioning=loose
ARG RADARR_VERSION=5.17.2.9580

# renovate: datasource=docker depName=mcr.microsoft.com/dotnet/aspnet versioning=loose
ARG DOTNET_VERSION=10.0-alpine

# ────────────────────────────────
# Builder: download Radarr release
# ────────────────────────────────
FROM alpine:3.22 AS builder

WORKDIR /tmp
RUN apk add --no-cache curl tar

RUN curl -L https://github.com/radarr/radarr/releases/download/v${RADARR_VERSION}/Radarr.master.${RADARR_VERSION}.linux-musl-core-x64.tar.gz \
    -o radarr.tar.gz && \
    mkdir /radarr && \
    tar -xzf radarr.tar.gz -C /radarr && \
    rm radarr.tar.gz

# ────────────────────────────────
# Final image
# ────────────────────────────────
FROM mcr.microsoft.com/dotnet/aspnet:${DOTNET_VERSION}

ARG APP_UID
ARG APP_GID
ARG APP_ROOT

ENV EXTERNAL_AUTH=false
WORKDIR /app

COPY --from=builder /radarr/* /app

# Root setup
USER root
RUN apk add --no-cache sqlite-libs icu-libs curl && \
    mkdir -p ${APP_ROOT}/etc && \
    chown -R ${APP_UID}:${APP_GID} ${APP_ROOT}

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Switch to non-root
USER ${APP_UID}:${APP_GID}

EXPOSE 7878
VOLUME /config

HEALTHCHECK --interval=60s --timeout=10s --retries=5 \
  CMD curl -fs http://127.0.0.1:7878/ping >/dev/null || exit 1

ENTRYPOINT ["docker-entrypoint.sh"]
