#!/bin/bash

sed -i '29 s/^/#/' /etc/pki/tls/openssl.cnf
echo "# Create directory /certs"
mkdir --parents /certs

if ! ucl list -n ca -t ECC | grep ECC; then
  echo "# Create ca key"
  ucl generate -t ECC -n ca --user user --desc "Used for CA certificate"

  echo "# Export the CA key"
  ucl export -n ca -o /certs/ca.key --obfuscate

  echo "# Self-sign the CA"
  openssl req -config /setup/openssl.cnf -key /certs/ca.key  -new -x509 -days 7300 -sha256 -extensions v3_ca  -out /certs/ca.crt -subj "/CN=myCA" 2>/dev/null

  echo "# Keytool import cert"
  (echo changeit; sleep 1; echo y; sleep 1)|keytool -importcert -file /certs/ca.crt -alias ukcdh -keystore /usr/local/jdk-11.0.2/lib/security/cacerts &>/dev/null
fi

if ! ucl list -n ca | grep Certificate; then
  echo "# Import ca certificate"
  ucl import --input /certs/ca.crt  --user user --name ca
fi


if ! ucl list -n codeSigning -t RSA | grep RSA ; then
  echo "# Create codeSigning key"
  ucl generate -t RSA -n codeSigning --desc "Used for code signing" --user user

  echo "# Export the codeSigning  key"
  ucl export -n codeSigning -o /certs/code_signing.key --obfuscate

  echo "# Create certificate request."
  #ucl csr -o /certs/code_signing.csr --subject "CN=code Signing" -n codeSigning --user user
  openssl req -new -sha256 -key /certs/code_signing.key -out /certs/code_signing.csr -subj '/CN=code Signing'

  #echo "# Convert CSR to PEM."
  #openssl req -inform DER -in /certs/code_signing.csr -out /certs/code_signing.csr

  echo "# Create index file txt"
  touch /certs/index.txt

  echo "# Create certificate"
  (echo y; sleep 1; echo y; sleep 1) | openssl ca -config /setup/openssl.cnf -create_serial -extensions codeSigning_cert -days 375  -in /certs/code_signing.csr -out /certs/code_signing.crt
fi

if ! ucl list -n codeSigning | grep Certificate; then
  echo "# Import certificate"
  ucl import --input /certs/code_signing.crt --user user --name codeSigning
fi

echo "# Check existing keys in UKC"
ucl list
