# ╔═════════════════════════════════════════════════════╗
# ║                      SONARR                         ║
# ╚═════════════════════════════════════════════════════╝
# By Myrenic.

# ────────────────────────────────
# Versions (Renovate will detect)
# ────────────────────────────────
# renovate: datasource=github-releases depName=Sonarr/Sonarr versioning=loose
ARG SONARR_VERSION=4.0.15.2941

# renovate: datasource=docker depName=mcr.microsoft.com/dotnet/aspnet
ARG DOTNET_VERSION=10.0-alpine

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

# Download Sonarr release (static URL pattern for Renovate)
RUN curl -L https://github.com/Sonarr/Sonarr/releases/download/v${SONARR_VERSION}/Sonarr.main.${SONARR_VERSION}.linux-musl-x64.tar.gz \
    -o sonarr.tar.gz && \
    mkdir /sonarr && \
    tar -xzf sonarr.tar.gz -C /sonarr && \
    rm sonarr.tar.gz

# ────────────────────────────────
# Final image
# ────────────────────────────────
FROM mcr.microsoft.com/dotnet/aspnet:${DOTNET_VERSION}

ARG APP_UID
ARG APP_GID
ARG APP_ROOT

ENV EXTERNAL_AUTH=false
WORKDIR /app

# Copy Sonarr from builder
COPY --from=builder /sonarr/* /app

# Root setup
USER root
RUN apk add --no-cache sqlite-libs curl && \
    mkdir -p ${APP_ROOT}/etc && \
    chown -R ${APP_UID}:${APP_GID} ${APP_ROOT}


# Entrypoint
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Switch to non-root
USER ${APP_UID}:${APP_GID}

EXPOSE 8989
VOLUME /config

HEALTHCHECK --interval=60s --timeout=10s --retries=5 \
  CMD curl -fs http://127.0.0.1:8989/ping >/dev/null || exit 1

ENTRYPOINT ["docker-entrypoint.sh"]
