#!/bin/bash

echo "#################################################################### RPM signer ####################################################################"

echo "Sing on RPM"
ucl sign-rpm -i /setup/testfiles/pgdg-redhat-repo-latest.noarch.rpm -o out.rpm -n codeSigning

