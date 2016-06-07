# What is windocker?
- If your computer is behind a corporate proxy
- and the proxy replaces SSL certificates with its own(SSL Interception proxy - [here](https://bto.bluecoat.com/webguides/proxysg/security_first_steps/Content/Solutions/SSL/ssl_solution.htm), [here](https://www.secureworks.com/research/transitive-trust), [here](http://www.zdnet.com/article/how-the-nsa-and-your-boss-can-intercept-and-break-ssl) and [here](https://media.blackhat.com/bh-eu-12/Jarmoc/bh-eu-12-Jarmoc-SSL_TLS_Interception-Slides.pdf)).

then you might probably need this tool to help resolve problems of Docker Toolbox on Windows.

windocker helps you:
* use Docker commands from within Windows Command Prompt (instead of MINGW64 shell)
* access to Docker Hub
* access to your private Docker registry

# Installation
## Installation and Preparation of Docker Toolbox
- Install Docker Toolbox: https://docs.docker.com/engine/installation/windows
- Make sure your proxy server and corporate firewall let you access to Docker Hub(https://index.docker.io) and https://api.github.com/repos/boot2docker/boot2docker/releases/latest. If your internet browser uses your company's proxy, you can test it by calling the mentioned URLs on your browser.
- Obtain your corporate's HTTP and HTTPS proxy IP and port (e.g. 10.10.10.240:8080). HTTPS proxy URL is generally same as HTTP proxy. Make sure you can connect to them (e.g. `telnet 10.10.10.240 8080`).
- Add following lines at the top of `C:\Program Files\Docker Toolbox\start.sh` after `#!/bin/bash`. Otherwise, if Boot2Docker image distributed by Docker Toolbox is out-of-date, Docker Quickstart Terminal does not work because latest Boot2Docker image cannot be downloaded.
```bash
# --- windocker ---
# Replace with your own values!
export HTTP_PROXY=http://10.10.10.240:8080
export HTTPS_PROXY=http://10.10.10.240:8080
export NO_PROXY=.mycompany.com
# --- windocker ---
```
- Run Docker Quickstart Terminal and make sure it works properly.
- Now, we are sure Boot2Docker VM, and so Docker daemon, is running. You can close MINGW64 shell if you want.

## Installation of windocker
- Copy [windocker](windocker) directory into `C:\Users\<USER>` (e.g. C:\Users\akumlali)
- Obtain PEM encoded self signed CA certificate files of your corporate proxy and private Docker registry. Please have a look at [Obtaining Proxy Server's CA Certificate](docs/README.md). 
- Make sure certificates have `pem` extension. (e.g. proxy.mycompany.com.pem, docker-registry.mycompany.com.pem)
- Make sure certificates are self signed. You can check it by changing file extension to `crt` and open it in Windows. Under `General` tab you should see the same description in `Issued to` and `Issued by` fields.
- Copy certificate files to `C:\Users\<USER>\windocker\certs`. (e.g. C:\Users\akumlali\windocker\certs)
- Enter your `HTTP_PROXY`, `HTTPS_PROXY` and `NO_PROXY` to `conf.cmd`. If Docker Toolbox and internal/private Docker registry are running under the same domain (e.g. kumlali.mycompany.com and docker-registry.mycompany.com), then requests from Docker Toolbox to private Docker registry should not pass through the proxy server. Therefore, in Boot2Docker VM, it is necessary to export `NO_PROXY` environment variable containing private Docker registry (e.g. docker-registry.mycompany.com). `NO_PROXY` defined in `conf.cmd` is automatically exported in Boot2Docker VM by windocker.
- Run `init_host.cmd`. This script initializes Docker daemon running in Boot2Docker VM. Because configuration is persisted, you can safely reboot VM when you need. If you delete `default` VM and create new one, then you need to run the script again. 
- Run `windocker.cmd`. In command prompt try `docker run hello-world`
- You can run more than one `windocker.cmd` in parallel.

# Tested Environments
| Windows | Docker Toolbox | Boot2Docker |
| --- | --- | --- |
| Windows 7 - 64bit | 1.9.1i | v1.10.2  |
| Windows 7 - 64bit | 1.10.1a | v1.10.2  |
| Windows 7 - 64bit | 1.10.2 | v1.10.2 |


# Notes
- When you reboot Boot2Docker VM (`docker-machine restart default`) its IP might change. Then you might need to run `windocker.cmd` again. It adds new IP to `NO_PROXY` so that Docker client can connect to Docker daemon running in Boot2Docker VM.
- Make sure you use self signed CA certificates. If you followed instructions under [Docker Trusted Registry - Security configuration] (https://docs.docker.com/docker-trusted-registry/configure/config-security) you probably ended up an openssl command like `openssl s_client ...`. In my case that command created a file containing all the certificates of the chain. But, in my tests, it was required the file had only CA's root certificate. If your proxy intercepts SSL traffic and inserts its own certificate, you can simply export proxy's CA certificate. Please have a look at [Obtaining Proxy Server's CA Certificate](docs/README.md).
- Make sure `NO_PROXY` is correct. In my case `*.mycompany.com` does not work, while `.mycompany.com` and `docker-registry.mycompany.com` work perfectly.
- Windows' line ending characters(CR+LF) found in PEM encoded certificates are automatically converted to Unix's (LF) by windocker. But if you make changes on windocker scripts, then make sure *.sh scripts do not have CR+LF line endings.

# References
- [How to install Docker on Windows behind a proxy](http://www.netinstructions.com/how-to-install-docker-on-windows-behind-a-proxy)
- 'VirtualBox Guest Additions' and 'Installing secure Registry' parts of [SvenDowideit/boot2docker](https://github.com/SvenDowideit/boot2docker)
