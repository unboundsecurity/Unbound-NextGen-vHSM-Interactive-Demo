FROM centos:8
RUN echo 'alias ll="ls -l"' >> ~/.bashrc
RUN yum install -y python2\
     which\
     wget \
     unzip\
     nano \
     vim\
     initscripts\
     skopeo\
     make \
     openssl; \
    yum clean all; \
    rm -rf /var/cache/yum

#OpenJDK Java 11
RUN curl -sO https://download.oracle.com/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz ;\
    tar zxvf openjdk-11.0.2_linux-x64_bin.tar.gz ;\
    mv jdk-11.0.2 /usr/local/ ; \
    ln -s /usr/local/jdk-11.0.2/bin/java /usr/bin/java ; \
    rm /openjdk-11.0.2_linux-x64_bin.tar.gz; \
    rm /usr/local/jdk-11.0.2/lib/src.zip
ENV JAVA_HOME=/usr/local/jdk-11.0.2
ENV PATH=$PATH:$JAVA_HOME/bin

RUN ln -s /usr/bin/python2 /usr/bin/python
RUN ln -s /usr/bin/pip2 /usr/bin/pip

RUN pip install --no-cache-dir pykmip

#RUN curl -sL https://rpm.nodesource.com/setup_10.x | bash - ;  yum install -y nodejs;  yum clean all
