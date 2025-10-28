# Traefikator

Generates self-signed TLS certificates for Traefikator in `/app/certs`. Can delete existing certificates on startup and automatically regenerate them when near expiry.  

This container **runs as non-root** when you provide a user via `--user`, making it safe for mounted host directories.

## Usage

```bash
docker run --user 1000:1000 \
    -e CERT_NAME=mydomain.com \
    -e CERT_DAYS=30 \
    -e CERT_RENEW_DAYS=10 \
    -e DELETE_ON_STARTUP=false \
    -v certs:/app/certs \
    -v dynamic:/app/dynamic \
           traefikator
````

## Build

```bash
git clone https://github.com/Myrenic/apps

cd apps/images/services/traefikator

docker build -t traefikator .
```

## Environment Variables

| Variable            | Default      | Description                                             |
| ------------------- | ------------ | ------------------------------------------------------- |
| `CERT_NAME`         | **Required** | Name of the certificate (used for filenames and CN).    |
| `CERT_DAYS`         | 365          | Validity of the certificate in days.                    |
| `CERT_RENEW_DAYS`   | 30           | Days before expiry to regenerate the cert.              |
| `DELETE_ON_STARTUP` | false        | Delete existing certificate files on startup if `true`. |

## Behavior

1. Deletes existing `.key` and `.crt` files if `DELETE_ON_STARTUP=true`.
2. Generates certificates if they do not exist.
3. Regenerates certificates if near expiry (within `CERT_RENEW_DAYS`).
4. Certificates are stored in `/app/certs` (or the mounted host directory).

## Notes

* Ensure `/app/certs` directory is writable by the UID/GID you specify via `--user`.
* Container exits after generating or validating certificates.
* Running with `--user` avoids root and allows safe file ownership on host-mounted directories.

