#!/bin/bash
set -e
PARTITION=$UKC_PARTITION
CLIENT=ukc-docker-client

echo "Deleting client $CLIENT from $PARTITION"
# Delete if exists
curl "https://ukc-ep/api/v1/clients/$CLIENT?partitionId=$PARTITION" \
  -X DELETE -H 'Connection: keep-alive' \
  -H 'Accept: application/json, text/plain, */*' \
  --fail \
  --user "so@$UKC_PARTITION:$UKC_PASSWORD" --compressed --insecure -output /dev/null --silent || true

echo "Creating client $CLIENT from $UKC_PARTITION"
ACTIVATION_CODE=$(curl "https://ukc-ep/api/v1/clients?partitionId=$PARTITION" \
 -H 'Connection: keep-alive' \
 -H 'Accept: application/json' \
 --user "so@$UKC_PARTITION:$UKC_PASSWORD" \
 -H 'Content-Type: application/json' \
 --compressed --insecure --data-binary "{\"name\":\"$CLIENT\"}")

ACTIVATION_CODE=$(echo $ACTIVATION_CODE | jq -r '.activationCode')

echo "Activation code is $ACTIVATION_CODE"
ucl register -p $PARTITION -n $CLIENT -c $ACTIVATION_CODE
