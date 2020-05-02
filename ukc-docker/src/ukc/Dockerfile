FROM unboundukc/centos7:2004

#############################################
# Install UKC server
##
ARG UKC_SERVER_FILENAME=ekm-2.0.2001.41853.el7.x86_64.rpm
ARG UKC_SERVER_DOWNLOAD_URL=https://repo.dyadicsec.local/cust/autotest/ekm/2.0.2001.41853/linux/ekm-2.0.2001.41853.el7.x86_64.rpm
#Using RUN wget instead of ADD in order to avoid Downloading the same file again
# ADD caches the layer by the file content and so must download before
# the cached layer
RUN echo "Downloading UKC server install file: $UKC_SERVER_DOWNLOAD_URL"
RUN wget --no-check-certificate $UKC_SERVER_DOWNLOAD_URL; \
  rpm -i "$UKC_SERVER_FILENAME"; \
  rm "$UKC_SERVER_FILENAME";
RUN echo "UKC Installed successfully"
#############################################

#############################################
#  Frontail - used for showing logs in webapp
###
EXPOSE 9001
EXPOSE 9002
RUN wget -O - https://github.com/mthenw/frontail/tarball/master | tar xz; \
  mv mthenw* frontail; \
  cd frontail && npm i --only=prod
# Use unbound styles
COPY data/frontail/default.css /frontail/web/assets/styles/default.css
#############################################

COPY data/start.sh /
RUN chmod +x /start.sh
EXPOSE 8443
EXPOSE 433

# Disable HSTS to allow http access to vhsm app from localhost
# after installing CA certificate (when HTTPS is legit)
COPY data/web.xml /opt/ekm/conf/web.xml
# Open port 8080
COPY data/server.xml /opt/ekm/conf/server.xml

ENTRYPOINT ["/start.sh"]
