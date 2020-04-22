#!/bin/bash

(echo changeit; sleep 1; echo y; sleep 1)|keytool -importcert -file /certs/ca.crt -alias ukcdh -keystore /usr/local/jdk-11.0.2/lib/security/cacerts

echo "Load key to GPG keyring"
ucl pgp-key -p $UKC_PARTITION -n codeSigning

echo "Get pub id"
#PUBID=$(gpg --list-keys | grep -v '^pub' | grep -v  '^uid' | grep -v '^/root'|  grep -v '-' |grep   '[A-Z]*[0-9]*')
PUBID=$(gpg --list-keys | sed -n -e  's/^ * //p')
echo "Export the public key"
gpg2 --armor --output /certs/public.gpg --export codeSigning

echo "Copy an image with skopeo"
skopeo copy docker://busybox:latest dir:busybox

echo "standalone-sign"
skopeo standalone-sign busybox/manifest.json registry.example.com/example/busybox codeSigning --output busybox.signature

echo "standalone-verify"
skopeo standalone-verify busybox/manifest.json registry.example.com/example/busybox  $PUBID busybox.signature

