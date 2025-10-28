#!/bin/sh

: "${CERT_NAME:?Need to set CERT_NAME}"
: "${CERT_DAYS:=365}"
: "${CERT_RENEW_DAYS:=30}"
: "${DELETE_ON_STARTUP:=false}"

CERT_DIR="/app/certs"
KEY_PATH="$CERT_DIR/${CERT_NAME}.key"
CRT_PATH="$CERT_DIR/${CERT_NAME}.crt"

generate_cert() {
    echo "Generating certificate for $CERT_NAME..."
    mkdir -p "$CERT_DIR"
    openssl req -x509 -nodes -days "$CERT_DAYS" \
      -newkey rsa:2048 \
      -keyout "$KEY_PATH" \
      -out "$CRT_PATH" \
      -subj "/CN=$CERT_NAME"
}

if [ "$DELETE_ON_STARTUP" = "true" ]; then
    echo "Deleting existing certificate files..."
    rm -f "$KEY_PATH" "$CRT_PATH"
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

echo "Done."
exit 0
