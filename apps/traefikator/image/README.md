# Traefikator

Generates self-signed TLS certificates for Traefikator in `/app/certs`. Certificates can be deleted on startup and automatically regenerated when near expiry.

This container **runs as non-root** when you provide a user via `--user`, ensuring safe ownership for host-mounted directories.

## Usage

```bash
docker run --user 1000:1000 \
    -e CERT_NAME=mydomain.com \
    -e CERT_DAYS=365 \
    -e CERT_RENEW_DAYS=30 \
    -e DELETE_ON_STARTUP=false \
    -e CERT_TRAEFIK_PATH=/app/certs \
    -v certs:/app/certs \
    -v dynamic:/app/dynamic \
    traefikator
```

## Build

```bash
git clone https://github.com/Myrenic/apps
cd apps/images/services/traefikator
docker build -t traefikator .
```

## Environment Variables

| Variable            | Default      | Description                                            |
| ------------------- | ------------ | ------------------------------------------------------ |
| `CERT_NAME`         | **Required** | Certificate name (used for filenames and CN).          |
| `CERT_DAYS`         | 365          | Certificate validity in days.                          |
| `CERT_RENEW_DAYS`   | 30           | Days before expiry to regenerate the certificate.      |
| `DELETE_ON_STARTUP` | false        | Delete existing certs on startup if `true`.            |
| `CERT_TRAEFIK_PATH` | **Required** | Path used in Traefik TLS config for `.crt` and `.key`. |

## Behavior

1. Deletes `.key` and `.crt` files if `DELETE_ON_STARTUP=true`.
2. Generates certificates if they do not exist.
3. Regenerates certificates if near expiry (within `CERT_RENEW_DAYS`).
4. Stores certificates in `/app/certs` (or mounted host directory).
5. Generates Traefik TLS config at `/app/dynamic/tls.yml`.

## Notes

* Ensure `/app/certs` is writable by the UID/GID specified via `--user`.
* Container exits after generating or validating certificates.
* Using `--user` avoids running as root, ensuring safe file ownership on host-mounted directories.
