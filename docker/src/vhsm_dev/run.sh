docker run -d \
  -v $(echo ~)/work/.m2/:/root/.m2/ \
  -v $(echo ~)/work/unbound_crypto_server:/unbound \
  --name vhsm-dev \
  --network ukc-docker_default \
  -p 127.0.0.1:35729:35729/tcp \
  -p 127.0.0.1:8081:8081/tcp -p 127.0.0.1:8444:8443 \
  --env-file ../../settings.env \
  -e VHSM_DEMO_TLS_KEY_ALIAS=democlient3 \
  -e VHSM_DEMO_USE_HTTPS=false \
  vhsm-client-dev
# docker run --network ukc-docker_default \
#   -v $(echo ~)/work/unbound_crypto_server:/unbound \
#   -p 127.0.0.1:8081:8081/tcp -p 127.0.0.1:8444:8443 \
#   --env-file ../../settings.env \
#   -e VHSM_DEMO_TLS_KEY_ALIAS=democlient3 \
#   -e VHSM_DEMO_USE_HTTPS=true \
#   --entrypoint="/bin/bash"  \
#   -it vhsm-client-dev
