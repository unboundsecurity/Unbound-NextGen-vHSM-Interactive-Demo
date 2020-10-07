#!/bin/bash
version=${UNBOUND_VERSION:-2007}
repo=${UNBOUND_REPO:-unboundukc}
tag="${repo}/ukc-server:$version.vhsm"
docker build -t $tag --build-arg UNBOUND_REPO=$repo \
    --build-arg UNBOUND_VERSION=$version \
    $(dirname "$0")