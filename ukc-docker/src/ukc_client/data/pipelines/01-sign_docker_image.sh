#!/bin/bash

echo "#################################################################### Docker signer ####################################################################"
echo "Load key to GPG keyring"
ucl pgp-key -p $UKC_PARTITION -n codeSigning 2> /dev/null

echo "Export the public key"
gpg2 --armor --output /certs/public.gpg --export codeSigning 2> /dev/null

echo "Copy an image with skopeo"
skopeo copy --override-os linux docker://docker.io/busybox:latest dir:busybox

echo "standalone-sign"
skopeo standalone-sign busybox/manifest.json registry.example.com/example/busybox codeSigning --output busybox.signature
