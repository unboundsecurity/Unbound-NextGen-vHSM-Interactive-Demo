FROM unboundukc/centos7:2004

RUN yum -y update;\
    yum -y install maven;\
    yum clean all;

RUN wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
RUN unzip ngrok-stable-linux-amd64.zip
