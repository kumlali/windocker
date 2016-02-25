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
echo Configuration file(conf.cmd) has been loaded.

set WINDOCKER_HOME=/c/Users/%USERNAME%/windocker

docker-machine ssh default "export WINDOCKER_HOME=%WINDOCKER_HOME%;export HTTP_PROXY=%HTTP_PROXY%;export HTTPS_PROXY=%HTTPS_PROXY%;export NO_PROXY=%NO_PROXY%;%WINDOCKER_HOME%/init_host.sh"
