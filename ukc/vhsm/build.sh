#!/bin/bash
set -e

version=${UNBOUND_VERSION:-2007}
sh ../ukc-server/build.sh
sh ./vhsm_webapp_build/build_web_app.sh
sh ./ukc-server-vhsm/build.sh
sh ./ukc-client-vhsm/build.sh