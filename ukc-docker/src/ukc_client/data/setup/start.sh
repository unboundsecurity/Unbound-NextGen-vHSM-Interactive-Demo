#!/bin/bash
set -e

echo "Waiting for EP to start"
until $(curl --output /dev/null -k --silent --head --fail \
  https://ukc-ep/api/v1/health); do
    printf '*'
    sleep 5
done

echo "Waiting for partition ${UKC_PARTITION} 'so' password reset"
until $(curl --output /dev/null --silent -k --fail --compressed \
  --user "so@$UKC_PARTITION:$UKC_PASSWORD" \
  "https://ukc-ep/api/v1/info?partitionId=$UKC_PARTITION" ); do
    printf '.'
    sleep 5
done

echo "UKC ready registering client"
./setup/register_new_client.sh

echo "Resetting 'user' password to empty"
# ucl user reset-pwd -n user -w $UKC_PASSWORD

curl "https://ukc-ep/api/v1/users/user/password?partitionId=$UKC_PARTITION" \
    -X PUT -H 'Connection: keep-alive' \
    -H 'Accept: application/json, text/plain, */*' \
    -H 'Content-Type: application/json' \
    --user 'so@test:Unbound1!' \
    --compressed --insecure \
    --output /dev/null --silent \
    --data-binary "{\"password\":\"\"}"


echo "Create certificates"
./setup/create_certificates.sh

if ! ucl list -n $UKC_FPE_KEY -t PRF | grep PRF; then
  echo "Creating key '$UKC_FPE_KEY' for tokenization"
  ucl generate -n $UKC_FPE_KEY -t PRF
fi

if [ "$VHSM_DEMO_USE_HTTPS" = "true" ]; then
  echo "Using HTTPS"
  # Check if key already exists, if not generate it
  if ! ucl show -n $VHSM_DEMO_TLS_KEY_ALIAS; then
    echo "Generating TLS certificate for tomcat"
    case $VHSM_DEMO_HTTPS_GENERATE_KEY_WITH in

      KEYTOOL)
        echo "Using keytool for key generation"
        case $VHSM_DEMO_HTTPS_KEY_TYPE in

          EC)
            keytool -genkey -keyalg EC -alias $VHSM_DEMO_TLS_KEY_ALIAS \
             -keystore NONE \
             -storetype PKCS11 \
             -providername DYADIC \
             -validity 365 \
             -keysize 256 \
             -providerclass com.dyadicsec.provider.DYCryptoProvider -providerarg $UKC_PARTITION \
             -providerpath /usr/lib64/ekm-java-provider-2.0.jar \
             -dname "O=CLIENT, CN=$VHSM_DEMO_TLS_KEY_ALIAS" \
             -noprompt \
             -storepass $UKC_PASSWORD
             ;;

          RSA)
            keytool -genkey -keyalg RSA -alias $VHSM_DEMO_TLS_KEY_ALIAS \
             -keystore NONE \
             -storetype PKCS11 \
             -providername DYADIC \
             -validity 365 \
             -keysize 2048 \
             -providerclass com.dyadicsec.provider.DYCryptoProvider -providerarg $UKC_PARTITION \
             -providerpath /usr/lib64/ekm-java-provider-2.0.jar \
             -dname "O=CLIENT, CN=$VHSM_DEMO_TLS_KEY_ALIAS" \
             -noprompt \
             -storepass $UKC_PASSWORD
             ;;

          *)
            echo "Unknown VHSM_DEMO_HTTPS_KEY_TYPE '$VHSM_DEMO_HTTPS_KEY_TYPE'"
            exit 1
            ;;

        esac # case VHSM_DEMO_HTTPS_KEY_TYPE
        ;;

      OPENSSL)
        echo "Using OPENSSL for key generation"
        echo "Configuring openssl with Unbound security provider"
        export OPENSSL_CONF="/etc/pki/tls/openssl.cnf"
        case $VHSM_DEMO_HTTPS_KEY_TYPE in

          RSA)
            openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 \
              -subj "/O=SERVER/CN=ukc-demo-client" \
              -keyout ukc-demo.key  -out ukc-demo.cer \
              -reqexts SAN \
              -config <(cat $OPENSSL_CONF \
                  <(printf "\n[SAN]\nsubjectAltName=DNS:localhost,DNS:192.168.0.1"))
            # change the key name - find it as it will be the only one with UID as name
            ucl change-info -u $(ucl list | grep -Po '(0x00\w+)') --newname $VHSM_DEMO_TLS_KEY_ALIAS
            ucl import -i ukc-demo.cer -p test --name $VHSM_DEMO_TLS_KEY_ALIAS
            ;;

          EC)
            echo "Don't know how to generate EC with openssl"
            exit 1
            ;;

          *)
            echo "Unknown VHSM_DEMO_HTTPS_KEY_TYPE '$VHSM_DEMO_HTTPS_KEY_TYPE'"
            exit 1
            ;;

        esac #case $VHSM_DEMO_HTTPS_KEY_TYPE
        ;; #OPENSSL)
     *)
        echo "Unknown VHSM_DEMO_HTTPS_GENERATE_KEY_WITH '$VHSM_DEMO_HTTPS_GENERATE_KEY_WITH'"
        exit 1
        ;;

    esac #case $VHSM_DEMO_HTTPS_GENERATE_KEY_WITH
  fi #if ! ucl show -n $VHSM_DEMO_TLS_KEY_ALIAS; then
fi #if [ "$VHSM_DEMO_USE_HTTPS" = "true" ]
# tail -f /dev/null
# cd /unbound_crypto_server && mvn spring-boot:run

echo "Starting vHSM app"
/setup/wait_until_ready.sh &
java -jar /opt/unbound_vhsm/ukc-vhsm-server-0.0.1.jar > /opt/unbound_vhsm/vhsm-demo.log

