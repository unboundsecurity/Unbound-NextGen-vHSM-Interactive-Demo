FROM unboundukc/centos8:2004

ARG UKC_CLIENT_RPM=ekm-client-2.0.2001.41853-el7+el8.x86_64.rpm

COPY data/$UKC_CLIENT_RPM /
RUN rpm -ivh /$UKC_CLIENT_RPM
RUN rm /$UKC_CLIENT_RPM
RUN echo "servers=ukc-ep">/etc/ekm/client.conf

RUN wget -O jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
RUN chmod +x ./jq
RUN cp jq /usr/bin

COPY data/setup /setup
COPY data/pipelines /pipelines

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
