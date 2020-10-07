#!/bin/bash

# kill running container
docker rm -f vhsm-dev

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
echo ${SCRIPTPATH}

sh $SCRIPTPATH/build.sh

WEBAPP_ROOT=$SCRIPTPATH/webapp/


# map to host folder .m2 to cache dependencies
docker run -d \
  -v "$SCRIPTPATH/.m2/:/root/.m2/" \
  -v "${WEBAPP_ROOT}:/unbound" \
  --name vhsm-dev \
  --network casp-docker_default \
  -p 127.0.0.1:35729:35729/tcp \
  -p 127.0.0.1:8081:8081/tcp -p 127.0.0.1:8444:8443 \
  --env-file $(dirname "$0")/../settings.env \
  -e VHSM_DEMO_TLS_KEY_ALIAS=democlient3 \
  -e VHSM_DEMO_USE_HTTPS=false \
  ${UNBOUND_REPO:-unboundukc}/ukc-client:2007.vhsm.dev

# install unbound java provider
docker exec  \
     -it vhsm-dev bash -c 'mvn install:install-file \
   -Dfile=/usr/lib64/ekm-java-provider-2.0.jar \
   -DgroupId=com.dyadicsec \
   -DartifactId=ekm-java-provider \
   -Dversion=2.0 \
   -Dpackaging=jar \
   -DgeneratePom=true'

# build the vhsm web app and test by connecting to running vhsm-server
# docker exec  \
#      -w /setup -it vhsm-dev bash -c './start.sh; cd /unbound; mvn clean package;'

# build the vhsm web app without testing - no need to have a running server
docker exec  \
     -w /setup -it vhsm-dev bash -c ' cd /unbound; mvn clean package -Dmaven.test.skip=true;'

# copy jar to vhsm-client data folder
cp $WEBAPP_ROOT/target/ukc-vhsm-server-0.0.1.jar $(dirname "$0")/../ukc-client-vhsm/data