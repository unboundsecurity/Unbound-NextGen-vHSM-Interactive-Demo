#!/bin/bash

echo "#################################################################### RPM Verify ####################################################################"

echo "Prepare the Public Key File"
ucl export -n codeSigning -f PGP -o out.pgp

echo "Import the Public Key into RPM DB"
rpm --import out.pgp

echo "Verify the Signature"
rpm -Kv /setup/testfiles/pgdg-redhat-repo-latest.noarch.rpm
