#!/bin/bash
set -e

# build app
DOCKER_CLIENT_ROOT=~/work/UKC-Express-Deploy/ukc-docker/src/ukc_client_rest
docker exec -w /unbound \
  -it vhsm-dev \
  mvn clean package

cp ~/work/unbound_crypto_server/target/ukc-vhsm-server-0.0.1.jar ../ukc_client_rest/data/

# build docker image
 cd ../ukc_client_rest
 ./build.sh

# publish
# docker push unboundukc/vhsm-client:2001
