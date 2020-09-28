#!/usr/bin/env bash
docker build --build-arg from=unboundukc/centos8:2004 \
             --build-arg UKC_SERVER_FILENAME=ekm-2.0.2007.46470.el8.x86_64.rpm \
             --build-arg UKC_SERVER_DOWNLOAD_URL=https://repo.dyadicsec.com/ekm/UB2007/snapshots/linux/ekm-2.0.2007.46470.el8.x86_64.rpm \
             -t unboundukc/ukc-vhsm:2007 .
