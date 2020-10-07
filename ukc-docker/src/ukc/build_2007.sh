#!/usr/bin/env bash
docker build --build-arg from=unboundukc/centos8:2004 \
             --build-arg UKC_SERVER_FILENAME=ekm-2.0.2007.46455.el8.x86_64.rpm \
             --build-arg UKC_SERVER_DOWNLOAD_URL=https://repo.dyadicsec.com/ekm/releases/2007/2.0.2007.46455/linux/ekm-2.0.2007.46455.el8.x86_64.rpm \
             -t unboundukc/ukc-vhsm:2007 .
