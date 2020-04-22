#!/bin/bash

sed -i '29 s/^/#/' /etc/pki/tls/openssl.cnf
echo "# Create directory /certs"
mkdir --parents /certs

if ! ucl list -n ca -t ECC | grep ECC; then
  echo "# Create ca key"
  ucl generate -t ECC -n ca --user user

  echo "# Export the CA key"
  ucl export -n ca -o /certs/ca.key --obfuscate

  echo "# Self-sign the CA"
  openssl req -config /openssl.cnf -key /certs/ca.key  -new -x509 -days 7300 -sha256 -extensions v3_ca  -out /certs/ca.crt -subj "/CN=myCA"
fi

if ! ucl list -n ca | grep Certificate; then
  echo "# Import ca certificate"
  ucl import --input /certs/ca.crt  --user user --name ca
fi


if ! ucl list -n codeSigning -t RSA | grep RSA ; then
  echo "# Create codeSigning key"
  ucl generate -t RSA -n codeSigning --user user
  
  echo "# Export the codeSigning  key"
  ucl export -n codeSigning -o /certs/code_signing.key --obfuscate

  echo "# Create certificate request."
  #ucl csr -o /certs/code_signing.csr --subject "CN=code Signing" -n codeSigning --user user
  openssl req -new -sha256 -key /certs/code_signing.key -out /certs/code_signing.csr -subj '/CN=code Signing'

  #echo "# Convert CSR to PEM."
  #openssl req -inform DER -in /certs/code_signing.csr -out /certs/code_signing.csr

  echo "Create index file txt"
  touch /certs/index.txt

  echo "Create certificate"
  (echo y; sleep 1; echo y; sleep 1) | openssl ca -config /openssl.cnf -create_serial -extensions codeSigning_cert -days 375  -in /certs/code_signing.csr -out /certs/code_signing.crt
fi

if ! ucl list -n codeSigning | grep Certificate; then
  echo "Import certificate"
  ucl import --input /certs/code_signing.crt --user user --name codeSigning
fi

if ! ucl list -n tomcat -t ECC | grep ECC ; then
  echo "# Create tomcat key"
  ucl generate -t ECC -n tomcat --user user

  echo "# Export the tomcat key"
  ucl export -n tomcat -o /certs/tomcat.key --obfuscate

  echo "# Create certificate request."
  #ucl csr -o /certs/tomcat.csr --subject "CN=ukc-ep;O=SERVER" -n tomcat --user user
  openssl req -new -sha256 -key /certs/tomcat.key -out /certs/tomcat.csr -subj '/CN=ukc-ep;/O=SERVER'

  #echo "# Convert CSR to PEM."
  #openssl req -inform DER -in /certs/tomcat.csr -out /certs/tomcat.csr

  echo "Create certificate"
  (echo y; sleep 1; echo y; sleep 1) | openssl ca -config /openssl.cnf -create_serial -extensions vhsmdemo_cert -days 375  -in /certs/tomcat.csr -out /certs/tomcat.crt
fi

if ! ucl list -n tomcat | grep Certificate; then
  echo "Import certificate"
  ucl import --input /certs/tomcat.crt --user user --name tomcat
fi

echo "# Check existing keys in UKC"
ucl list
