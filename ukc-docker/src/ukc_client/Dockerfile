FROM unboundukc/centos8:2004

ARG UKC_CLIENT_FILENAME=ekm-client-2.0.2001.41853-el7+el8.x86_64.rpm
ARG UKC_CLIENT_DOWNLOAD_URL=https://repo.dyadicsec.local/cust/autotest/ekm/2.0.2001.41853/linux/ekm-client-2.0.2001.41853-el7+el8.x86_64.rpm

#Using RUN wget instead of ADD in order to avoid Downloading the same file again
# ADD caches the layer by the file content and so must download before
# the cached layer
RUN echo "Downloading UKC client install file: $UKC_CLIENT_FILENAME"
RUN wget --no-check-certificate $UKC_CLIENT_DOWNLOAD_URL; \
  rpm -i "$UKC_CLIENT_FILENAME"; \
  rm "$UKC_CLIENT_FILENAME"
RUN echo "UKC Client Installed successfully"

RUN wget -O jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64; \
    chmod +x ./jq; \
    mv jq /usr/bin

COPY data/setup /setup
COPY data/pipelines /pipelines

RUN echo "servers=ukc-ep">/etc/ekm/client.conf

RUN yes | /etc/ekm/dy_openssl

COPY data/ukc-vhsm-server-0.0.1.jar /opt/unbound_vhsm/

ENV VHSM_DEMO_USE_HTTPS false
ENV VHSM_DEMO_SSL_PROTOCOL "TLSv1.1"
ENV UKC_PARTITION test
ENV VHSM_DEMO_HTTPS_GENERATE_KEY_WITH OPENSSL
ENV VHSM_DEMO_HTTPS_KEY_TYPE RSA
ENV VHSM_DEMO_TLS_KEY_ALIAS "vhsmdemo"
EXPOSE 8081
EXPOSE 8443
ENTRYPOINT ["/setup/start.sh"]
