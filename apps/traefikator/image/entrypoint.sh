#!/bin/sh
# https://github.com/Myrenic/apps

: "${CERT_NAME:?Need to set CERT_NAME}"
: "${CERT_DAYS:=365}"
: "${CERT_RENEW_DAYS:=30}"
: "${DELETE_ON_STARTUP:=false}"
: "${CERT_TRAEFIK_PATH:=?Need to set CERT_TRAEFIK_PATH}"

CERT_DIR="/app/certs"
DYNAMIC_DIR="/app/dynamic"

KEY_PATH="$CERT_DIR/${CERT_NAME}.key"
CRT_PATH="$CERT_DIR/${CERT_NAME}.crt"

TLS_CONFIG="$DYNAMIC_DIR/tls.yml"

generate_cert() {
    echo "Generating certificate for $CERT_NAME..."
    mkdir -p "$CERT_DIR"
    openssl req -x509 -nodes -days "$CERT_DAYS" \
      -newkey rsa:2048 \
      -keyout "$KEY_PATH" \
      -out "$CRT_PATH" \
      -subj "/CN=$CERT_NAME"
}

generate_tls_config() {
    echo "Creating Traefik TLS configuration..."
    cat > "$TLS_CONFIG" << EOF
tls:
  certificates:
    - certFile: "$CERT_TRAEFIK_PATH/${CERT_NAME}.crt"
      keyFile: "$CERT_TRAEFIK_PATH/${CERT_NAME}.key"
EOF
}

if [ "$DELETE_ON_STARTUP" = "true" ]; then
    echo "Deleting existing certificate and TLS config files..."
    rm -f "$KEY_PATH" "$CRT_PATH" "$TLS_CONFIG"
fi

if [ ! -f "$KEY_PATH" ] || [ ! -f "$CRT_PATH" ]; then
    generate_cert
else
    EXPIRY=$(openssl x509 -enddate -noout -in "$CRT_PATH" | cut -d= -f2)
    EXPIRY_CLEAN=$(echo "$EXPIRY" | sed 's/ GMT//')
    EXPIRY_TS=$(date -d "$EXPIRY_CLEAN" +%s)
    NOW_TS=$(date +%s)
    RENEW_TS=$((EXPIRY_TS - CERT_RENEW_DAYS * 24 * 3600))

    if [ "$NOW_TS" -ge "$RENEW_TS" ]; then
        echo "Certificate is expired or near expiry. Regenerating..."
        generate_cert
    else
        echo "Certificate is still valid."
    fi
fi

generate_tls_config

echo "Done."
exit 0
