FROM unboundukc/vhsm-client:2004

RUN yum -y update;\
    yum -y install maven;\
    yum clean all;

RUN echo \
    "<settings xmlns='http://maven.apache.org/SETTINGS/1.0.0\' \
    xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' \
    xsi:schemaLocation='http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd'> \
        <localRepository>/root/.m2/repository</localRepository> \
        <interactiveMode>true</interactiveMode> \
        <usePluginRegistry>false</usePluginRegistry> \
        <offline>false</offline> \
    </settings>" \
    > /usr/share/maven/conf/settings.xml; \
    mkdir /root/.m2/; \
    echo \
    "<settings xmlns='http://maven.apache.org/SETTINGS/1.0.0\' \
    xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' \
    xsi:schemaLocation='http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd'> \
        <localRepository>/root/.m2/repository</localRepository> \
        <interactiveMode>true</interactiveMode> \
        <usePluginRegistry>false</usePluginRegistry> \
        <offline>false</offline> \
    </settings>" \
    > /root/.m2/settings.xml

RUN wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
RUN unzip ngrok-stable-linux-amd64.zip

# overwrite java 1.8 link created by maven install
RUN ln -sf /usr/local/jdk-11.0.2/bin/java /usr/bin/java

# install maven packages
RUN mvn install:install-file \
   -Dfile=/usr/lib64/ekm-java-provider-2.0.jar \
   -DgroupId=com.dyadicsec \
   -DartifactId=ekm-java-provider \
   -Dversion=2.0 \
   -Dpackaging=jar \
   -DgeneratePom=true

#COPY data/unbound_crypto_server /unbound_crypto_server
#RUN cd /unbound_crypto_server && mvn package
#RUN rm -rf /unbound_crypto_server

#COPY data/ukc-vhsm-server-0.0.1.jar /unbound_vhsm/
COPY data/start.sh ./setup/
#CMD mvn  -X clean install -pl component -P profile
#CMD mvn  -X clean install -P profile
CMD tail -f /dev/null

# livereload server
EXPOSE 35729
ENTRYPOINT [""]
