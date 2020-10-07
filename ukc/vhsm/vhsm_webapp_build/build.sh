docker build \
  --build-arg UKC_CLIENT_INSTALLER_URL=https://repo.dyadicsec.com/ekm/releases/2007/2.0.2007.46455/linux/ekm-client-2.0.2007.46455.el8.x86_64.rpm \
  -t unboundtech/ukc-client:2007.vhsm.dev .
