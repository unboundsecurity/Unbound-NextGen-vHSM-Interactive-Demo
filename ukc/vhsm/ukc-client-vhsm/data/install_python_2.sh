#!/bin/bash
yum install -y python2
yum clean all
rm -rf /var/cache/yum
ln -s /usr/bin/python2 /usr/bin/python
ln -s /usr/bin/pip2 /usr/bin/pip
pip install --no-cache-dir pykmip