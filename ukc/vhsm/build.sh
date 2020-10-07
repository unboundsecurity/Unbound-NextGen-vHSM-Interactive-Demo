#!/bin/bash
version=${UNBOUND_VERSION:-2007}
sh ../ukc-server/build.sh
sh ./ukc-server-vhsm/build.sh
sh ./ukc-client-vhsm/build.sh


## to build and create the webapp jar, you need to 