#!/bin/bash

echo "Download some rpm and jar for signing"
wget -P /rpm_and_jars_files https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-redhat-repo-42.0-9.noarch.rpm

wget -P /rpm_and_jars_files https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm

wget -P /rpm_and_jars_files http://www.java2s.com/Code/JarDownload/sample-calculator/sample-calculator-bundle-2.0.jar.zip
unzip /rpm_and_jars_files/sample-calculator-bundle-2.0.jar.zip -d /rpm_and_jars_files/

wget -P /rpm_and_jars_files http://www.java2s.com/Code/JarDownload/keystore/keystore-1.0.jar.zip
unzip /rpm_and_jars_files/keystore-1.0.jar.zip -d /rpm_and_jars_files/

wget -P /rpm_and_jars_files http://www.java2s.com/Code/JarDownload/keytool/keytool-api-1.1.jar.zip
unzip /rpm_and_jars_files/keytool-api-1.1.jar.zip -d /rpm_and_jars_files/

rm -rf /rpm_and_jars_files/*.zip
