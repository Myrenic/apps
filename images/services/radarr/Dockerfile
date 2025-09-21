# ╔═════════════════════════════════════════════════════╗
# ║                      radarr                         ║
# ╚═════════════════════════════════════════════════════╝
# By Myrenic

# Versions as ARGs for Renovate
ARG RADARR_VERSION=5.27.5.10198
ARG DOTNET_VERSION=8.0.413
ARG APP_UID=1000
ARG APP_GID=1000
ARG APP_ROOT=/config

# ────────────────────────────────
# Builder: download radarr release
# ────────────────────────────────
FROM alpine:3.22 AS builder

ARG RADARR_VERSION
WORKDIR /tmp

RUN apk add --no-cache curl tar

# Construct URL statically for Renovate
# Example pattern: https://github.com/radarr/radarr/releases/download/v5.27.5.10198/Radarr.master.5.27.5.10198.linux-musl-core-x64.tar.gz
RUN curl -L https://github.com/radarr/radarr/releases/download/v${RADARR_VERSION}/Radarr.master.${RADARR_VERSION}.linux-musl-core-x64.tar.gz \
    -o radarr.tar.gz && \
    mkdir /radarr && \
    tar -xzf radarr.tar.gz -C /radarr && \
    rm radarr.tar.gz
# ────────────────────────────────
# Final: based on custom dotnet distroless
# ────────────────────────────────
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine

ARG APP_UID
ARG APP_GID

ENV EXTERNAL_AUTH=false
WORKDIR /app

COPY --from=builder /radarr/* /app

# Root user
USER root

RUN apk add --no-cache sqlite-libs icu-libs curl && \
    mkdir -p ${APP_ROOT}/etc && \
    mkdir /config && chown -R ${APP_UID}:${APP_GID} /config

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

#fix for crashing due to globalization-invariant mode in .NET.
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=0
ENV LANG=en_US.UTF-8

# Non-root user
USER ${APP_UID}:${APP_GID}
EXPOSE 7878
VOLUME /config

HEALTHCHECK --interval=60s --timeout=10s --retries=5 \
  CMD curl -fs http://127.0.0.1:7878/ping >/dev/null || exit 1

ENTRYPOINT ["docker-entrypoint.sh"]
