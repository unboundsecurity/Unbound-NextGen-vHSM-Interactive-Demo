FROM centos:8

# Important! To optimize docker layer size and reuse, try to keep the instructions and
# their order in similar images as much as possible. 

# Install OpenJDK 11. Reduce size by removing unnecessary stuff and optimize image size
RUN curl -O# https://download.oracle.com/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz ;\
    tar zxvf openjdk-11.0.2_linux-x64_bin.tar.gz ;\
    mv jdk-11.0.2 /usr/local/ ; \
    ln -s /usr/local/jdk-11.0.2/bin/java /usr/bin/java ; \
    rm /openjdk-11.0.2_linux-x64_bin.tar.gz; \
    rm /usr/local/jdk-11.0.2/lib/src.zip; \
    echo " \
     JAVA_HOME=/usr/local/jdk-11.0.2; \
     export JAVA_HOME; \
     PATH=\$PATH:\$JAVA_HOME/bin; \
     export PATH; " >> ~/.bashrc

# Install common utilities and clean
RUN echo 'alias ll="ls -l"' >> ~/.bashrc; \
    yum install -y which wget unzip nano initscripts openssl sudo; \
    yum clean all; rm -rf /var/cache/yum;

#### Don't change the above unless necessary in-order to keep layer reuse optimization
#### If you need to add components use new commands below

#### stuff used by UKC pipeline demos
# Python 2
RUN yum install -y python2; \
    yum clean all; \
    rm -rf /var/cache/yum; \
    ln -s /usr/bin/python2 /usr/bin/python; \
    ln -s /usr/bin/pip2 /usr/bin/pip; \
    pip install --no-cache-dir pykmip;

# JQ - Json parser
RUN curl -LO# https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64; \
    mv ./jq-linux64 ./jq; \
    chmod +x ./jq; \
    mv jq /usr/bin

# skopeo for signing docker images
RUN yum install -y skopeo; \
    yum clean all; \
    rm -rf /var/cache/yum
####### 

COPY data/setup /setup
COPY data/pipelines /pipelines

ARG UKC_CLIENT_INSTALLER_URL
RUN echo "Downloading UKC client install file: $UKC_CLIENT_INSTALLER_URL"; \
    curl -O# "${UKC_CLIENT_INSTALLER_URL}"; \
    echo "Installing $(basename ${UKC_CLIENT_INSTALLER_URL})"; \
    rpm -i $(basename "${UKC_CLIENT_INSTALLER_URL}"); \
    rm $(basename "${UKC_CLIENT_INSTALLER_URL}"); \
    echo "UKC Client Installed successfully"

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
