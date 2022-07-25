#!/bin/bash

# Assert that a password has been provided as an environment variable.
if [ -z "${CKAN_ENCRYPT_PASSWORD}" ]; then
  echo "CKAN_ENCRYPT_PASSWORD is not set"
  exit 1
fi

# Iterate over YAML files
for file in $(find . -name "*.yaml.gpg"); do
    # Get filename without extension
    filename=$(basename "$file" .gpg)
    # If file exists, delete it
    if [ -f "$filename" ]; then
        rm "$filename"
    fi
    # Decrypt the file
    gpg -d --passphrase "$CKAN_ENCRYPT_PASSWORD" --batch "$file" >> "$filename"
done
