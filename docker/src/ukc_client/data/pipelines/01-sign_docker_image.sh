#!/bin/bash

echo "#################################################################### Docker signer ####################################################################"
echo "Load key to GPG keyring"
ucl pgp-key -p $UKC_PARTITION -n codeSigning

echo "Export the public key"
gpg2 --armor --output /certs/public.gpg --export codeSigning

echo "Copy an image with skopeo"
skopeo copy docker://busybox:latest dir:busybox

echo "standalone-sign"
skopeo standalone-sign busybox/manifest.json registry.example.com/example/busybox codeSigning --output busybox.signature
