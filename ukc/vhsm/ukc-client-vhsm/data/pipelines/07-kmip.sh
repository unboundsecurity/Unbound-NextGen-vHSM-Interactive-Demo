#!/bin/bash

echo "#################################################################### KMIP ####################################################################"

echo "Create client in full mode"
ucl client create --mode full --name kmip-client --partition $UKC_PARTITION --password $UKC_PASSWORD  --pfx_password 123456 --output /certs/kmip-client.pfx

echo "Create root_ca key"
ucl root_ca -o /certs/ukc_root_ca.pem

echo "Convert kmip-client.pfx to kmip-client.key"
openssl pkcs12 -in /certs/kmip-client.pfx -nocerts -out /certs/kmip-client.key -passin pass:123456 -passout pass:123456 -nodes

echo "Convert kmip-client.pfx to kmip-client.crt"
openssl pkcs12 -in /certs/kmip-client.pfx -clcerts -nokeys -out /certs/kmip-client.crt -passin pass:123456

echo "Run kmip sample"
python /setup/kmip_sample.py 2> /dev/null

