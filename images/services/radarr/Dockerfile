# ╔═════════════════════════════════════════════════════╗
# ║                      radarr                         ║
# ╚═════════════════════════════════════════════════════╝
# By Myrenic

ARG APP_UID=1000
ARG APP_GID=1000
ARG APP_ROOT=/config

# ────────────────────────────────
# Builder: download Radarr release
# ────────────────────────────────
FROM alpine:3.22 AS builder

WORKDIR /tmp

RUN apk add --no-cache curl tar

# Construct URL statically for Renovate
# renovate: datasource=github-releases packageName=radarr/radarr versioning=loose
ARG RADARR_VERSION=5.17.2.9580
RUN curl -L https://github.com/radarr/radarr/releases/download/v${RADARR_VERSION}/Radarr.master.${RADARR_VERSION}.linux-musl-core-x64.tar.gz \
    -o radarr.tar.gz && \
    mkdir /radarr && \
    tar -xzf radarr.tar.gz -C /radarr && \
    rm radarr.tar.gz

# ────────────────────────────────
# Final: based on .NET distroless
# ────────────────────────────────
FROM mcr.microsoft.com/dotnet/aspnet:10.0-alpine

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

# Fix for .NET globalization
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=0
ENV LANG=en_US.UTF-8

# Non-root user
USER ${APP_UID}:${APP_GID}
EXPOSE 7878
VOLUME /config

HEALTHCHECK --interval=60s --timeout=10s --retries=5 \
  CMD curl -fs http://127.0.0.1:7878/ping >/dev/null || exit 1

ENTRYPOINT ["docker-entrypoint.sh"]
