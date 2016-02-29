#!/bin/sh
# Copyright 2016 windocker authors. All rights reserved.
# Use of this source code is governed by Apache License 2.0
# that can be found in the LICENSE file.


BOOT2DOCKER_HOME=/var/lib/boot2docker

log () {
  echo "[windocker] $1"
}

convertWindowsEOLtoUnixEOL () {
  file=$1
  sudo sh -c "tr -d '\r' < $file > $file.tmp"
  sudo mv -f $file.tmp $file
}


printEnv () {
  log "WINDOCKER_HOME: ${WINDOCKER_HOME}"
  log "HTTP_PROXY    : ${HTTP_PROXY}"
  log "HTTPS_PROXY   : ${HTTPS_PROXY}"
  log "NO_PROXY      : ${NO_PROXY}"
}


# NO_PROXY should not include IP of Boot2Docker VM.
addProxyConfToB2DProfile () {
  sudo sh -c "echo export HTTP_PROXY=${HTTP_PROXY}>> $BOOT2DOCKER_HOME/profile"
  sudo sh -c "echo export HTTPS_PROXY=${HTTPS_PROXY}>> $BOOT2DOCKER_HOME/profile"
  sudo sh -c "echo export NO_PROXY=${NO_PROXY}>> $BOOT2DOCKER_HOME/profile"
  log "Proxy configuration has been added to the $BOOT2DOCKER_HOME/profile."
} 


copyCertificatesFromWindowsToB2D () {
  sudo cp -r $WINDOCKER_HOME/certs $BOOT2DOCKER_HOME
  log "Certificate files have been copied from Windows to Boot2Docker."
}


convertWindowsEOLtoUnixEOLofCertificates () {
  for f in $BOOT2DOCKER_HOME/certs/*.pem
  do 
    convertWindowsEOLtoUnixEOL $f
  done
}


restartDockerDaemon () {  
  sudo /etc/init.d/docker restart
  log "Docker daemon has been restarted."
}


showWindockerChanges () {
  log "------------------------------------------ "
  log "Certificates"
  log "------------------------------------------ "
  ls -all $BOOT2DOCKER_HOME/certs

  log "------------------------------------------ "
  log "$BOOT2DOCKER_HOME/profile"
  log "------------------------------------------ "
  cat $BOOT2DOCKER_HOME/profile
} 



# ----------------------------------------------------------------------

COMMAND=${1}

if [[ "$COMMAND" = "showWindockerChanges" ]] ; then
  showWindockerChanges
else
  #Was environment variables really passed from Windows to Boot2Docker VM?
  #printEnv
  
  addProxyConfToB2DProfile
  copyCertificatesFromWindowsToB2D
  convertWindowsEOLtoUnixEOLofCertificates

  log "Initialization of Boot2Docker VM has been completed: "
  showWindockerChanges
fi
