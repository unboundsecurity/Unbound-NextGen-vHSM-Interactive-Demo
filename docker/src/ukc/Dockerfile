FROM unboundukc/centos7:2004

#install UKC
# ARG UKC_RPM=ekm-2.0.2004.42976.el7.x86_64.rpm
ARG UKC_RPM=ekm-2.0.2001.42928.el7.x86_64.rpm
COPY data/$UKC_RPM /
RUN rpm -i /$UKC_RPM
RUN rm /$UKC_RPM

# frontail ports - used for showing logs in webapp
EXPOSE 9001
EXPOSE 9002
RUN git clone https://github.com/mthenw/frontail.git
RUN cd frontail && npm i
# Use unbound styles
COPY data/frontail/default.css /frontail/web/assets/styles/default.css

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
