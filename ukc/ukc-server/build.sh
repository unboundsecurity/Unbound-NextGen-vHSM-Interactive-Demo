#!/bin/bash
version=${UNBOUND_VERSION:-2007}
declare INSTALLER_URLS=(
    ["2007"]="https://repo.dyadicsec.com/ekm/releases/2007/2.0.2007.46455/linux/ekm-2.0.2007.46455.el8.x86_64.rpm"
    ["2010"]=""
)
install_url=${INSTALLER_URLS[$version]}
echo "Installing from ${install_url}"
tag=${UNBOUND_REPO:-unboundukc}/ukc-server:${version}

docker build -t $tag \
     --build-arg UKC_SERVER_INSTALLER_URL=$install_url \
    $(dirname "$0")