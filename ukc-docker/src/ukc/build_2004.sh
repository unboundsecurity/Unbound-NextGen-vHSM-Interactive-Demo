#!/usr/bin/env bash
docker build --build-arg from=unboundukc/centos8:2004 \
             --build-arg UKC_SERVER_FILENAME=ekm-2.0.2004.44153.el8.x86_64.rpm \
             --build-arg UKC_SERVER_DOWNLOAD_URL=https://repo.dyadicsec.com/cust/autotest/ekm/2.0.2004.44153/linux/ekm-2.0.2004.44153.el8.x86_64.rpm \
             -t unboundukc/ukc-vhsm:2004 .
