ARG UNBOUND_VERSION
ARG UNBOUND_REPO=unboundukc
FROM ${UNBOUND_REPO}/ukc-server:${UNBOUND_VERSION}

#############################################
#  Frontail - used for showing logs in webapp
#  Requires NodeJs
RUN curl -L# https://rpm.nodesource.com/setup_10.x | bash -; \
    yum install -y nodejs; \
    yum clean all; rm -rf /var/cache/yum

EXPOSE 9001
EXPOSE 9002
RUN curl -LJ# https://github.com/mthenw/frontail/tarball/master | tar xz; \
    mv mthenw* /frontail; \
    npm i --prefix /frontail --only=prod
# Apply Unbound look & feel
COPY /data/frontail/default.css /frontail/web/assets/styles/default.css
#############################################

# Disable HSTS to allow http access to vhsm app from localhost
# after installing CA certificate (when HTTPS is legit)
COPY data/web.xml /opt/ekm/conf/web.xml
# Open port 8080
COPY data/server.xml /opt/ekm/conf/server.xml