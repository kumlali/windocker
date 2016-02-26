# What is windocker?
- If your computer is behind a corporate proxy
- and the proxy changes SSL certificates with its own(http://www.zdnet.com/article/how-the-nsa-and-your-boss-can-intercept-and-break-ssl) 
- and proxy's certificate is not from a trusted Certificate Authority

then you might probably need this tool to help resolve problems of Docker Toolbox on Windows.

windocker helps you:
* use Docker commands from whithin Windows Command Prompt (instead of MINGW64 shell)
* access Docker Hub
* access your private Docker registry

# Installation
## Installation and Preparation of Docker Toolbox
- Install Docker Toolbox: https://docs.docker.com/engine/installation/windows
- Make sure your proxy server and corporate firewall let you access to Docker Hub(https://index.docker.io) and https://api.github.com/repos/boot2docker/boot2docker/releases/latest. If your internet browser uses your company's proxy, you can test it by calling the mentioned URLs on your browser.
- Find your corporate's HTTP and HTTPS proxy IP and port (e.g. 10.10.10.240:8080). HTTPS proxy URL is generally same as HTTP proxy. Make sure you have access to them (e.g. `telnet 10.10.10.240 8080`).
- Add following lines at the top of `C:\Program Files\Docker Toolbox\start.sh` after `#!/bin/bash`.Docker Quickstart Terminal does not work because Boot2Docker image is not downloaded, otherwise.
```bash
# --- windocker ---
# Change with your own values!
export HTTP_PROXY=http://10.10.10.240:8080
export HTTPS_PROXY=http://10.10.10.240:8080
export NO_PROXY=*.mycompany.com
# --- windocker ---
```
- Run Docker Quickstart Terminal and make sure it works properly.

## Installation of windocker
- Copy [windocker](windocker) directory under to `C:\Users\<USER>`
- Obtain PEM encoded self signed CA certificate files of your corporate proxy and private Docker registry. Please have a look at [Obtaining Proxy Server's CA Certificate](docs/README.md). 
- Make sure certificates are self signed AND have `pem` extension. You can check it by changing file extension to `crt` and open it in Windows. Under `General` tab you should see the same description in `Issued to` and `Issued by` fields.
- Copy certificate files to `C:\Users\<USER>\windocker\certs`.
- Enter your `HTTP_PROXY`, `HTTPS_PROXY` and `NO_PROXY` to `conf.cmd`. Detailed explanation is found in `conf.cmd`.
- Run `init_host.cmd`. This script initializes Docker daemon running in Boot2Docker VM. Because configuration is persisted, you can safely reboot VM when you need. If you delete `default` VM and create new one, then you need to run the script again. 
- Run `windocker.cmd`. In command prompt try `docker run hello-world`
- You can run more than one `windocker.cmd` in parallel.

# Tested Environments
| Windows | Docker Toolbox |
| --- | --- |
| Windows 7 - 64bit | DockerToolbox-1.9.1i.exe |

# Notes
- When you reboot Boot2Docker VM (`docker-machine restart default`), its IP might change. Then you need to run `windocker.cmd` again. It adds new IP to `NO_PROXY` so that Docker client can connect to Docker daemon running in Boot2Docker VM.
- Make sure you use self signed CA certificates. If you followed instructions under [Docker Trusted Registry - Security configuration] (https://docs.docker.com/docker-trusted-registry/configure/config-security), you probably ended up an openssl command like `openssl s_client ...`. In my case, that command created a file containing all the certificates of the chain. But, in my tests, it was required the file had only CA's root's certificate. If your proxy intercepts SSL traffic and inserts its own certificate, you can simply export proxy's CA certificate. Please have a look at [Obtaining Proxy Server's CA Certificate](docs/README.md).

# References
- [How to install Docker on Windows behind a proxy](http://www.netinstructions.com/how-to-install-docker-on-windows-behind-a-proxy)
- 'VirtualBox Guest Additions' and 'Installing secure Registry' parts of [SvenDowideit/boot2docker](https://github.com/SvenDowideit/boot2docker/blob/4942238743be6a4c6cb930353c7f09dc01006cfa/README.md)
