#!/usr/bin/env bash
set -e

# build app
DOCKER_CLIENT_ROOT=../ukc_client
docker exec -w /unbound \
  -it vhsm-dev \
  mvn clean package

cp ../../../webapp/target/ukc-vhsm-server-0.0.1.jar ../ukc_client/data/

# build docker image
cd ../ukc_client
./build_2007.sh

# publish
# docker push unboundukc/vhsm-client:2001
