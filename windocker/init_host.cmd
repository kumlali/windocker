@echo off
rem Copyright 2016 windocker authors. All rights reserved.
rem Use of this source code is governed by Apache License 2.0
rem that can be found in the LICENSE file.

rem --------------------------------------------------------------------
rem This script needs to be run only once for a VM(default). When VM 
rem is deleted and a new VM(default) is created, then the script has 
rem to be run again.
rem --------------------------------------------------------------------
call conf.cmd
echo [windocker] Configuration file(conf.cmd) has been loaded.

set WINDOCKER_HOME=/c/Users/%USERNAME%/windocker

docker-machine ssh default "export WINDOCKER_HOME=%WINDOCKER_HOME%;export HTTP_PROXY=%HTTP_PROXY%;export HTTPS_PROXY=%HTTPS_PROXY%;export NO_PROXY=%NO_PROXY%;%WINDOCKER_HOME%/init_host.sh"

echo [windocker] Proxy configuration and certificates are persisted into Boot2Docker VM. 
echo [windocker] VM will be rebooted in 60 seconds to let Boot2Docker to load certificates.

rem This hack let us wait 60 seconds before restarting VM. 
rem In some environments it is necessary. Otherwise changes made in
rem /var/lib/boot2docker/profile are not persisted.
ping 127.0.0.1 -n 61 > nul

docker-machine restart default

rem Was changes persisted, really?
rem docker-machine ssh default "%WINDOCKER_HOME%/init_host.sh showWindockerChanges"
