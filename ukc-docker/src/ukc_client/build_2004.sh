docker build \
  --build-arg UKC_CLIENT_FILENAME=ekm-client-2.0.2004.44153-el7+el8.x86_64.rpm \
  --build-arg UKC_CLIENT_DOWNLOAD_URL=https://repo.dyadicsec.com/cust/autotest/ekm/2.0.2004.44153/linux/ekm-client-2.0.2004.44153-el7+el8.x86_64.rpm \
  -t unboundukc/vhsm-client:2004 .
