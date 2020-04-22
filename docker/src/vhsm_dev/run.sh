WEBAPP_ROOT=$(pwd)/../../../webapp/
docker run -d \
  -v $WEBAPP_ROOT/../.m2/:/root/.m2/ \
  -v $WEBAPP_ROOT:/unbound \
  --name vhsm-dev \
  --network unbound-ukc-demo \
  -p 127.0.0.1:35729:35729/tcp \
  -p 127.0.0.1:8081:8081/tcp -p 127.0.0.1:8444:8443 \
  --env-file ../../settings.env \
  -e VHSM_DEMO_TLS_KEY_ALIAS=democlient3 \
  -e VHSM_DEMO_USE_HTTPS=false \
  vhsm-client-dev

docker exec -it vhsm-dev /start.sh
docker exec -it vhsm-dev /bin/bash
