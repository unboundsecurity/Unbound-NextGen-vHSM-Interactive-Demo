# Unbound NextGen vHSM™ Interactive Demo

The Unbound NextGen vHSM™ Interactive Demo provides a quick and easy way to evaluate the Unbound Key Control [UKC](https://www.unboundtech.com/product/unbound-key-control/) solution. UKC is composed of several components that need to be setup to work properly. Therefore, this quick start solution is provided to enable you to launch UKC without any configuration using Docker.


## Installation

Use these instructions to get UKC running using Docker.

1. If you are not registered for Docker, follow the <a href="https://hub.docker.com/?overlay=onboarding" target="_blank">registration process</a> (It is recommended to open this link in a new tab).
1. [Contact Unbound](https://www.unboundtech.com/company/contact-us/) and provide us with your Docker username to get access to the Docker images.
1. Install Docker.
    - For Windows:
        - Install Docker Desktop CE (community edition). It must include Docker Engine version 19.03 or newer. You can get the latest version from [Docker](https://hub.docker.com/?overlay=onboarding).
        - Use the default Docker settings during installation.
   - For Linux:
        - Follow the instructions to [install Docker Compose](https://docs.docker.com/compose/install/).
   - For Mac:
       - Install Docker Desktop (community edition) v2.1.0.5 or newer. Follow the instructions to [install Docker Desktop](https://docs.docker.com/compose/install/).

1. Download or clone this repository from the [main page](https://github.com/unbound-tech/vhsm_demo) or click [here](https://github.com/unbound-tech/vhsm_demo/archive/master.zip).
1. If you downloaded a compressed (*.zip*) file, uncompress it.
1. The download contains a folder called *ukc-docker*. Open a terminal (such as *cmd* or *PowerShell* on Windows) and navigate to the `ukc-docker` folder.

    **Note: All subsequent commands are run from a terminal from this directory.**
1. Start Docker.
    - On Windows and Mac, start the Docker program.
    - On Linux, run *docker* from the command line in a shell with administrator privileges.
1. Check that Docker is running.

    You can check if Docker is running with the command `docker info`.
    - If it returns an error, then it is not running. This error may happen if Docker was run without administrator privileges.
    - On success, it returns status information about the Docker installation.
1. Open a terminal and navigate to the `ukc-docker` folder.
1. Run this command to log into Docker:
    ```bash
	docker login
	```
	Enter the credentials that you created for the Docker Hub website.

	After successful login you see:
    ````
    Login Succeeded
    ````

1. The Docker installation uses a settings file, called [settings.env](./settings.env). This file is located in the root of the `ukc-docker` folder that was downloaded in step 6.

    Installation works with the default values set in this file, so you do not have to change anything in it. However, you may want take a look at it to see what settings can be configured before running the installation process. The settings are described in the file.
1. Run Docker to create the UKC container:

   **Note:** If you are restarting or trying to update the demo, refer to [Restarting/Updating Docker](#update).

    ```bash
    docker-compose pull
    docker-compose up
    ```
    The setup takes several minutes to complete. During this time, Docker creates multiple containers for CASP, CASP database, CASP client, and UKC servers. It also creates the CASP user, client, keys, and more.

1. Wait until you see a large **READY** message. This message means that everything is installed and working. You may see some errors during the install process, but as long as you get the **READY** message, UKC was installed correctly.

    **Note:** Do not close the terminal window. Closing it terminates the Docker containers.


**Congratulations! UKC is now running.**

## Next Step - Explore the Web Interface
Open your browser and navigate to `http://localhost:8081` (for Windows and Mac) or `http://<docker-ip-address>:8081` (for Linux, where *docker-ip-address* is the server where you installed Docker).

The Web UI provides the following sections:

1. Tokenization - UKC can be used for tokenization with a format-preserving encryption (FPE) key. This site demonstrates tokenization/de-tokenization of various tokens by UKC using a pre-defined FPE key stored in UKC. The demo use cases include free text, credit card number, email address, USA SSN, and USA phone number.
2. UKC Admin - access the UKC administration interface, which can be used to view the FPE key details and more. Use these credentials to log in:
    - Username: so
    - Password: Unbound1!
    - Partition: root (or test)
    For more information on how to use the web interface, see [UKC User Guide](https://www.unboundtech.com/docs/UKC/UKC_User_Guide/HTML/Content/Products/UKC-EKM/UKC_User_Guide/UI/A1.html).
3. CLI - get access to the UKC client command line interface.
4. Logs - view the logs for the UKC servers. This can be helpful to view after running tokenization/de-tokenization operations.
5. Resources - links to more information about UKC, the SDE API, and


<a name="update"></a>
## Restarting/Updating Docker

To update and restart Docker:

1. Ensure that the previous session is finished:
    ```bash
    docker-compose down
    ```
2. Get the latest files:
    ```bash
    docker-compose pull
    ```
3. Retart Docker:
    ```bash
    docker-compose up
    ```

## Troubleshooting

### *docker-compose* hangs on startup

If you run `docker-compose up` and after a few minutes you still do not see the READY message, it probably means that there was an error starting up the Docker environment. You may have noticed that there were some error messages in the `docker-compose` output.

If this happens, follow these steps:
1. Stop the `docker-compose` process by pressing Ctrl+c.
1. Remove any running UKC containers:
    ```
    docker rm -f ukc-client ukc-ep ukc-partner ukc-aux
    ```
1. Remove existing images:
    ```
    docker rmi -f unboundukc/ukc-vhsm:2001  unboundukc/vhsm-client:2001
    ```
1. Run `docker system prune`.
1. Restart the docker service.
1. Run `docker-compose pull` (in the directory where your UKC *docker-compose.yaml* file is located).
1. Run `docker-compose up`.

### Cannot open the web console

If you cannot open the UKC web console in your browser, you might have port 443 in use by another service.

You can change UKC web console port by editing `docker-compose.yml`, and replacing the UKC export port with a different port.

For example, to change the port from 443 to 9443:
1. Change `"443:443"` to `"9443:443"`.
2. Restart the Docker with:

    ```bash
    docker-compose down
    docker-compose up
    ```
3. Use `https://localhost:9443/login` to open UKC web console.

### Virtualization

If you need to turn on virtualization on your Windows device, use these instructions:

- Enable Hyper-V using the [instructions from Microsoft](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v).
- You must [enable virtualization](https://blogs.technet.microsoft.com/canitpro/2015/09/08/step-by-step-enabling-hyper-v-for-use-on-windows-10/) in the BIOS on your device.

### UKC logs
You can see the UKC log files by logging into the Docker container for the EP and then finding the UKC logs. See [here](https://www.unboundtech.com/docs/UKC/UKC_User_Guide/HTML/Content/Products/UKC-EKM/UKC_User_Guide/Logs/A1.html) for more information about the UKC logs.

## Tips

### Installing Docker on CentOS 7

The default Docker installed by `yum` is an older version of Docker. You can use the technique below to update to a newer Docker version.

```bash
sudo yum install -y yum-utils   device-mapper-persistent-data   lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum -y install docker-ce
sudo systemctl start docker
sudo curl -L \
     "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" \
     -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

## Docker License
See [here](https://docs.docker.com/docker-for-windows/opensource/) for information about Docker licensing.
