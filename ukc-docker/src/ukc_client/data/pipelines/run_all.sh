#!/bin/sh

./01-sign_docker_image.sh
./02-verify_docker_image.sh
./03-sign_jar_file.sh
./04-verify_jar_file.sh
./05-sign_rpm_file.sh
./06-verify_rpm_file.sh
./07-kmip.sh
