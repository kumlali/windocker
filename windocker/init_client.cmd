@echo off
rem Copyright 2016 windocker authors. All rights reserved.
rem Use of this source code is governed by Apache License 2.0
rem that can be found in the LICENSE file.

rem --------------------------------------------------------------------
rem This script has to be run in each command prompt that Docker 
rem commands to be executed. Please make sure init_host.cmd has already
rem been executed either in this command prompt or in another. 
rem Otherwise, Docker commands will not work correctly.
rem --------------------------------------------------------------------

call conf.cmd
echo Configuration file(conf.cmd) has been loaded.

rem Requests from Docker client in Windows to Docker daemon in B2D VM 
rem should not pass through proxy. '--no-proxy' causes IP of B2D VM 
rem to be added to the end of NO_PROXY variable.
for /f "tokens=*" %%i in ('docker-machine env --no-proxy default') do %%i

echo Environment variables have been set:
echo HTTP_PROXY         : %HTTP_PROXY%
echo HTTPS_PROXY        : %HTTPS_PROXY%
echo NO_PROXY           : %NO_PROXY%
echo DOCKER_HOST        : %DOCKER_HOST%
echo DOCKER_MACHINE_NAME: %DOCKER_MACHINE_NAME%
echo DOCKER_TLS_VERIFY  : %DOCKER_TLS_VERIFY%
echo DOCKER_CERT_PATH   : %DOCKER_CERT_PATH%
echo.
echo Command prompt has been initialized. Try 'docker run hello-world'.
