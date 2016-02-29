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
echo [windocker] Configuration file(conf.cmd) has been loaded.

rem Requests from Docker client in Windows to Docker daemon in B2D VM 
rem should not pass through proxy. '--no-proxy' causes IP of B2D VM 
rem to be added to the end of NO_PROXY variable.
for /f "tokens=*" %%i in ('docker-machine env --no-proxy default') do %%i

echo [windocker] Environment variables have been set:
echo [windocker]   HTTP_PROXY         : %HTTP_PROXY%
echo [windocker]   HTTPS_PROXY        : %HTTPS_PROXY%
echo [windocker]   NO_PROXY           : %NO_PROXY%
echo [windocker]   DOCKER_HOST        : %DOCKER_HOST%
echo [windocker]   DOCKER_MACHINE_NAME: %DOCKER_MACHINE_NAME%
echo [windocker]   DOCKER_TLS_VERIFY  : %DOCKER_TLS_VERIFY%
echo [windocker]   DOCKER_CERT_PATH   : %DOCKER_CERT_PATH%
echo.
echo [windocker] Command prompt has been initialized.
echo [windocker] Try 'docker run hello-world'.
