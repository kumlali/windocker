#!/bin/sh
# Copyright 2016 windocker authors. All rights reserved.
# Use of this source code is governed by Apache License 2.0
# that can be found in the LICENSE file.


BOOT2DOCKER_HOME=/var/lib/boot2docker


convertWindowsEOLtoUnixEOL () {
  file=$1
  sudo sh -c "tr -d '\r' < $file > $file.tmp"
  sudo mv -f $file.tmp $file
}


printEnv () {
  echo WINDOCKER_HOME: ${WINDOCKER_HOME}
  echo HTTP_PROXY    : ${HTTP_PROXY}
  echo HTTPS_PROXY   : ${HTTPS_PROXY}
  echo NO_PROXY      : ${NO_PROXY}
}


# NO_PROXY should not include IP of Boot2Docker VM.
addProxyConfToB2DProfile () {
  sudo sh -c "echo export HTTP_PROXY=${HTTP_PROXY}>> $BOOT2DOCKER_HOME/profile"
  sudo sh -c "echo export HTTPS_PROXY=${HTTPS_PROXY}>> $BOOT2DOCKER_HOME/profile"
  sudo sh -c "echo export NO_PROXY=${NO_PROXY}>> $BOOT2DOCKER_HOME/profile"
  echo Proxy configuration has been added to the $BOOT2DOCKER_HOME/profile.
} 


copyCertificatesFromWindowsToB2D () {
  sudo cp -r $WINDOCKER_HOME/certs $BOOT2DOCKER_HOME
}


convertWindowsEOLtoUnixEOLofCertificates () {
  for f in $BOOT2DOCKER_HOME/certs/*.pem
  do 
    convertWindowsEOLtoUnixEOL $f
  done
}


restartDockerDaemon () {  
  sudo /etc/init.d/docker restart
  echo Docker daemon has been restarted.
}


printEnv
addProxyConfToB2DProfile
copyCertificatesFromWindowsToB2D
convertWindowsEOLtoUnixEOLofCertificates

echo init_host.sh has been executed.
