docker build \
  --build-arg UKC_CLIENT_FILENAME=ekm-client-2.0.2007.46455.el8.x86_64.rpm \
  --build-arg UKC_CLIENT_DOWNLOAD_URL=https://repo.dyadicsec.com/ekm/releases/2007/2.0.2007.46455/linux/ekm-client-2.0.2007.46455.el8.x86_64.rpm \
  -t unboundukc/vhsm-client:2007 .
