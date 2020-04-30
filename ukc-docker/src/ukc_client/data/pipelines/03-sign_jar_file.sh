#!/bin/bash

echo "#################################################################### JARSIGNER ####################################################################"

echo "Sign JAR file"
jarsigner -J--module-path -J/usr/lib64/ekm-java-9-provider-2.0.jar -J--add-modules -Jekm.java.client -keystore NONE -storetype PKCS11 -storepass 123456 -tsa http://timestamp.digicert.com -providername DYADIC -providerClass com.dyadicsec.provider.DYCryptoProvider /setup/testfiles/keystore-1.0.jar codeSigning

