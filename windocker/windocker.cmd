@echo off
rem Copyright 2016 windocker authors. All rights reserved.
rem Use of this source code is governed by Apache License 2.0
rem that can be found in the LICENSE file.

rem --------------------------------------------------------------------
rem This script opens a new command prompt and initializes it. 
rem Please make sure init_host.cmd has already been executed. 
rem Otherwise, Docker commands will not work correctly.
rem --------------------------------------------------------------------
start "windocker" init_client.cmd