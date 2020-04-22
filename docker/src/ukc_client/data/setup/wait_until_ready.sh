#!/bin/bash
until $(curl --output /dev/null -k --silent --head --fail \
  http://localhost:8081); do
    printf '.'
    sleep 1
done
sleep 2

echo
echo "########  ########    ###    ########  ##    ## "
echo "##     ## ##         ## ##   ##     ##  ##  ##  "
echo "##     ## ##        ##   ##  ##     ##   ####   "
echo "########  ######   ##     ## ##     ##    ##    "
echo "##   ##   ##       ######### ##     ##    ##    "
echo "##    ##  ##       ##     ## ##     ##    ##    "
echo "##     ## ######## ##     ## ########     ##    "
echo
echo "Unbound vHSM demo is ready !"
echo "Browse to http://localhost:8081"
