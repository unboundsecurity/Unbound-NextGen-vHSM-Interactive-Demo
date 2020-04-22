FROM unboundukc/centos8:2004
#FROM unboundukc/centos7:2004

# ARG UKC_CLIENT_RPM=ekm-client-2.0.2004.42976-el7+el8.x86_64.rpm
#ARG UKC_CLIENT_RPM=ekm-client-2.0.2001.42928-el7+el8.x86_64.rpm
ARG UKC_CLIENT_RPM=ekm-client-2.0.2001.42407-el7+el8.x86_64.rpm

COPY data/openssl.cnf /
COPY data/$UKC_CLIENT_RPM /
RUN rpm -ivh /$UKC_CLIENT_RPM
RUN rm /$UKC_CLIENT_RPM
RUN echo "servers=ukc-ep">/etc/ekm/client.conf

RUN wget -O jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
RUN chmod +x ./jq
RUN cp jq /usr/bin

COPY data/register_new_client.sh .
COPY data/start.sh .
COPY data/wait_until_ready.sh .
COPY data/create_certificates.sh .
COPY data/pgp_docker_signing.sh .
COPY data/get_dummies_rpm_and_jars.sh /
RUN /get_dummies_rpm_and_jars.sh


RUN yes | /etc/ekm/dy_openssl

COPY data/ukc-vhsm-server-0.0.1.jar /unbound_vhsm/

ENV VHSM_DEMO_USE_HTTPS false
ENV VHSM_DEMO_SSL_PROTOCOL "TLSv1.1"
ENV UKC_PARTITION test
ENV VHSM_DEMO_HTTPS_GENERATE_KEY_WITH OPENSSL
ENV VHSM_DEMO_HTTPS_KEY_TYPE RSA
ENV VHSM_DEMO_TLS_KEY_ALIAS "vhsmdemo"
EXPOSE 8081
EXPOSE 8443
ENTRYPOINT ["/start.sh"]
