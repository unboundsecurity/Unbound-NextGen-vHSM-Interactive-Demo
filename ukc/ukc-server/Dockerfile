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
    yum update -y; \
    yum install -y which wget unzip nano initscripts openssl sudo; \
    yum clean all; rm -rf /var/cache/yum;

# Install UKC server
ARG UKC_SERVER_INSTALLER_URL
RUN echo "Downloading ${UKC_SERVER_INSTALLER_URL}"; \
    curl -O# "${UKC_SERVER_INSTALLER_URL}"; \
    echo "Installing $(basename ${UKC_SERVER_INSTALLER_URL})"; \
    rpm -i $(basename "${UKC_SERVER_INSTALLER_URL}"); \
    rm $(basename "${UKC_SERVER_INSTALLER_URL}"); \
    echo "UKC installed. version is: "; \
    ucl version

COPY data/start_ukc.sh unbound/
RUN chmod +x /unbound/start_ukc.sh

# Used when using UKC for CASP
COPY data/casp_backup.pem unbound/data/

EXPOSE 8443
EXPOSE 433



