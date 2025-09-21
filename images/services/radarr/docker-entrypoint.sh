#!/bin/sh
set -e

CONFIG_FILE="/config/config.xml"

# Patch AuthenticationMethod if EXTERNAL_AUTH=true
if [ "$EXTERNAL_AUTH" = "true" ] && [ -f "$CONFIG_FILE" ]; then
    if grep -q "<AuthenticationMethod>" "$CONFIG_FILE"; then
        sed -i 's|<AuthenticationMethod>.*</AuthenticationMethod>|<AuthenticationMethod>External</AuthenticationMethod>|' "$CONFIG_FILE"
    else
        # Add it under <Config> root
        sed -i '0,/<Config>/ s|<Config>|<Config>\n  <AuthenticationMethod>External</AuthenticationMethod>|' "$CONFIG_FILE"
    fi
fi

# Start radarr
exec dotnet /app/Radarr.dll --no-browser --data=/config
