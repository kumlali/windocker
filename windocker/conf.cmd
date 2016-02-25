@echo off
rem Copyright 2016 windocker authors. All rights reserved.
rem Use of this source code is governed by Apache License 2.0
rem that can be found in the LICENSE file.

rem HTTP proxy's URL. (e.g. http://10.10.10.240:8080)
set HTTP_PROXY=

rem HTTPS proxy's URL. It is generally same as HTTP_PROXY. 
set HTTPS_PROXY=

rem If Docker Toolbox and internal/private Docker registry are running 
rem under the same domain (e.g. kumlali.mycompany.com and 
rem docker-registry.mycompany.com), then requests from Docker Toolbox 
rem to private Docker registry should not pass through the proxy server.
rem Therefore, in B2D VM, it is necessary to export NO_PROXY environment 
rem variable containing private Docker registry (e.g. 
rem docker-registry.mycompany.com). NO_PROXY defined here is 
rem automatically exported in B2D VM by windocker.
rem
rem If you do not have a private registry, you can keep the varible 
rem as is.
set NO_PROXY=