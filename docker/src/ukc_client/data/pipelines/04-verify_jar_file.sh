#!/bin/bash

echo "#################################################################### Verifiy JARSIGNER ####################################################################"

echo "Verify JAR file"
jarsigner -verify /setup/testfiles/keystore-1.0.jar -verbose

