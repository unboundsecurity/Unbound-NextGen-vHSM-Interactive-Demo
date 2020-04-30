#!/bin/bash

echo "#################################################################### RPM signer ####################################################################"

echo "Sign on RPM"
ucl sign-rpm -i /setup/testfiles/pgdg-redhat-repo-latest.noarch.rpm -o out.rpm -n codeSigning

