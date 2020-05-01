FROM centos:8
RUN echo 'alias ll="ls -l"' >> ~/.bashrc
#RUN yum -y update && rm -rf /var/cache/yum
#RUN yum -y install which wget sudo unzip openssl nano vim  initscripts git svn git-svn skopeo make
RUN yum install -y python2\
     git\
     which\
     wget \
     unzip\
     nano \
     vim\
     initscripts\
     skopeo\
     make \
     openssl\
    && rm -rf /var/cache/yum

RUN ln -s /usr/bin/python2 /usr/bin/python
RUN ln -s /usr/bin/pip2 /usr/bin/pip

RUN pip install pykmip

RUN curl -sO https://download.oracle.com/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz ;\
    tar zxvf openjdk-11.0.2_linux-x64_bin.tar.gz ;\
    mv jdk-11.0.2 /usr/local/ ; \
    ln -s /usr/local/jdk-11.0.2/bin/java /usr/bin/java ; \
    rm /openjdk-11.0.2_linux-x64_bin.tar.gz
    
ENV JAVA_HOME=/usr/local/jdk-11.0.2
ENV PATH=$PATH:$JAVA_HOME/bin
#RUN curl -sL https://rpm.nodesource.com/setup_10.x | bash - ;  yum install -y nodejs;  yum clean all
