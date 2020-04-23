#!/bin/bash

echo "#################################################################### Docker Verify ####################################################################"
echo "Get pub id"
PUBID=$(gpg --list-keys gpg  2>/dev/null | sed -n -e  's/^ * //p')

echo "standalone-verify"
skopeo standalone-verify busybox/manifest.json registry.example.com/example/busybox  $PUBID busybox.signature
