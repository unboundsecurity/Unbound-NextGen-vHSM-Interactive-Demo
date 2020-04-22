# 1. Deploy UKC Using Docker

This project provides a quick and easy way to evaluate the Unbound Key Control [UKC](https://www.unboundtech.com/product/unbound-key-control/) solution. UKC is composed of several components that need to be setup to work properly. Therefore, this quick start solution is provided to enable you to launch UKC without any configuration using Docker.

**Note: This project is intended to be used for POCs, demos and development. For production, you can [Deploy UKC Using Terraform](../ukc-terraform/README.md).**

## 1.1. Installation

Use these instructions to get UKC running using Docker.
    
1. If you are not registered for Docker, follow the [registration process](https://hub.docker.com/?overlay=onboarding).
1. [Contact Unbound](https://www.unboundtech.com/company/contact-us/) and provide us with your Docker username to get access to the Docker images.
1. Install Docker.
    - For Windows:
        - Install Docker Desktop CE (community edition). It must include Docker Engine version 19.03 or newer. You can get the latest version from [Docker](https://hub.docker.com/?overlay=onboarding).
        - Use the default Docker settings during installation.
   - For Linux:
        - Follow the instructions to [install Docker Compose](https://docs.docker.com/compose/install/).
   - For Mac:
       - Install Docker Desktop (community edition) v2.1.0.5 or newer. Follow the instructions to [install Docker Desktop](https://docs.docker.com/compose/install/).
 
1. Download or clone this repository from the [main page](https://github.com/unbound-tech/UKC-Express-Deploy) or click [here](https://github.com/unbound-tech/UKC-Express-Deploy/archive/master.zip).
1. If you downloaded a compressed (*.zip*) file, uncompress it. 
1. The download contains a folder called *ukc-docker*. Open a terminal and navigate to the `ukc-docker` folder.

    **Note: All subsequent commands are run from a terminal from this directory.**
1. Start Docker.
1. Check that Docker is running.

    You can check if Docker is running with the command `docker info`. If it returns an error, then it is not running. Otherwise, it returns status information about the Docker installation.
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
    
1. The Docker installation uses a settings file, called [settings.env](./settings.env). Installation works with the default values set in this file, so you do not have to change anything in it. However, you may want take a look at it to see what settings can be configured before running the installation process. The settings are described in the file.
1. Run Docker to create the UKC container:

   **Note:** If you are restarting or trying to update UKC Express Deploy, refer to [Restarting/Updating Docker](#update).
   
    ```bash
    docker-compose up
    ```
    The setup takes several minutes to complete.
	
    Everything is installed and working when you see this message:
    ```
    UKC system is ready
    ```

**Congratulations! UKC is now running.**

## 1.2. Next Steps
After installation, you can try some of these tasks:
1. [Explore the web interface](./#webint)
1. [Create and activate a client](./#ukcclient)
1. [Integrate UKC with your system](./#integration)

<a name="webint"></a>
### 1.2.1. Explore the Web Interface
Open your browser and navigate to `https://localhost/login` (for Windows) or `https://<docker-ip-address>/login` (for Linux, where *docker-ip-address* is the server where you installed Docker). Use these credentials to log in:
- Username: so
- Password: Unbound1!
- Partition: root

The Web UI provides the following screens:

- Keys and Certificates - provides information about your keys and certificates.
- Partitions - lists all partitions.
- Clients - lists all client.
- Users - lists all users.
- Authorize - shows operations that are pending approval.
- Config - shows the UKC settings.
- Rescue - use to reset the SO password.
- Help - open the UKC User Guide.

There is also a partition called **test** that you can use.

For more information on how to use the web interface, see [UKC User Guide](https://www.unboundtech.com/docs/UKC/UKC_User_Guide/HTML/Content/Products/UKC-EKM/UKC_User_Guide/UI/A1.html).

<a name="ukcclient"></a>
### 1.2.2. Create and activate a client

[Contact Unbound](https://www.unboundtech.com/company/contact-us/) to get a link to download the UKC client.

Information about installing the UKC client can be found [here](https://www.unboundtech.com/docs/UKC/UKC_User_Guide/HTML/Content/Products/UKC-EKM/UKC_User_Guide/Installation/ClientInstallation.html#h2_1).

<a name="integration"></a>
### 1.2.3. Integrate UKC with your system

UKC can be integrated with 3rd-party tools, such as databases and web servers. See [here](https://www.unboundtech.com/docs/UKC/UKC_Integration_Guide/HTML/Content/Products/Unbound_Cover_Page.htm) for more information.

<a name="update"></a>
## 1.3. Restarting/Updating Docker

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

## 1.4. Troubleshooting

### 1.4.1. Cannot open the web console

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

### 1.4.2. Virtualization

If you need to turn on virtualization on your Windows device, use these instructions:

- Enable Hyper-V using the [instructions from Microsoft](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v).
- You must [enable virtualization](https://blogs.technet.microsoft.com/canitpro/2015/09/08/step-by-step-enabling-hyper-v-for-use-on-windows-10/) in the BIOS on your device.

### 1.4.3. UKC logs
You can see the UKC log files by logging into the Docker container for the EP and then finding the UKC logs. See [here](https://www.unboundtech.com/docs/UKC/UKC_User_Guide/HTML/Content/Products/UKC-EKM/UKC_User_Guide/Logs/A1.html) for more information about the UKC logs.

## 1.5. Tips

### 1.5.1. Installing Docker on CentOS 7

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

## 1.6 Docker License
See [here](https://docs.docker.com/docker-for-windows/opensource/) for information about Docker licensing.
