#!/bin/bash

# Assert that a password has been provided as an environment variable
if [ -z "${TAILSCALE_ENCRYPT_PASSWORD}" ]; then
  echo "TAILSCALE_ENCRYPT_PASSWORD is not set"
  exit 1
fi

# Iterate over YAML files
for file in $(find . -name "*.yaml"); do
    # If gpg file exists, delete it
    if [ -f "$file.gpg" ]; then
        rm "$file.gpg"
    fi
    # Encrypt the file
    gpg -c --passphrase "$TAILSCALE_ENCRYPT_PASSWORD" --batch "$file"
    # Remove original
    rm "$file"
done
