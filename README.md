# Nextcloud-on-Raspberry-Pi-4
NExtcloud Docker conatiner runs on a optimized Raspberyy Pi 4 hardware offering High-Performance with Self-Hosted Cloud Storage capabilites.

## Nextcloud on Raspberry Pi 4: High-Performance Self-Hosted Cloud Storage

A lightweight, secure, and production-ready Nextcloud deployment optimized specifically for the Raspberry Pi 4. 




## Project Motivation
I needed a self-hosted cloud storage solution for daily use. While I previously used a Synology NAS and shared SAMBA drives, they introduced significant remote-access friction and high security/network configuration overhead for my specific use case. Moving to Nextcloud via Docker on a Raspberry Pi 4 provided a streamlined, web-accessible, and highly customizable alternative.


## Infrastructure & Hardware Layout
* **Host Platform:** Raspberry Pi 4 (Running Linux OS).
* **Storage Architecture:** Core OS and container configurations run on the internal drive, while all heavy user data is offloaded to a high-capacity external **ext4-formatted** USB 3.0 drive to ensure maximum drive speeds and longevity.


## Docker Compose Deployment
* Docker compose from hub.docker.com
  https://hub.docker.com/r/linuxserver/nextcloud

* Mariadb databse from hub.docker.com
  https://hub.docker.com/search?q=mariadb

* Redis data accelrator platform
  https://hub.docker.com/_/redis



### The Production File (`docker-compose.yml`)
This deployment pairs the Nextcloud application with an in-memory Redis cache and automated health checking to make the platform self-healing.
# Note:
1. Change the storage path a.k.a data location
2. Choose passwors for database and users. The username and password for databse are important as you will require to use same when first time accessing the webpage using https://localhost:443
3. after making the changes in the yaml file run the following commands in the shell prompt under #pwd
  Pull the docker container from source: docker compose up -d
  The logs should show the sucess. If stuck with issue then run;
```
*  #echo $?
```
* ``` #0 >> SUCESS```
* ``` #1 or -1 >> FAILURE```


### Access your page using link https://localhost:443
See the attached ```server-db_config.jpg``` file

```Upon sucess full configuration the database will be configured and you will be taken to the homepage of the Nxxtcloud 1.e. Dashboard.```
    
---
## System Hardening

### Isolate Your System Files
Do not allow Nextcloud's core app engine run off the external USB drive. Ensure your ~/nextcloud/config folder lives strictly on the Pi's internal storage (MicroSD or internal SSD). The external Transcend drive should strictly be used for the ```/data``` volume.

Use Automated Healthchecks (already embedded in yaml)
```
    healthcheck:
      test: ["CMD", "curl", "-f", "https://localhost/login"]
      interval: 1m
      timeout: 10s
      retries: 3
```


### Switch Background Jobs to Cron Engine
By default, Nextcloud uses the AJAX worker method. This means every time you load a webpage in your browser, Nextcloud forces your browser to wait while the Pi runs heavy background maintenance tasks (like generating file previews or checking for updates).Switching this to a system Cron job handles maintenance invisibly in the background every 5 minutes, making the web interface feel much snappier

Run the script 
``` 
setup_cron.sh
```


### Linux Storage Buffers Optimization (Host OS)
Prevent the Raspberry Pi from caching too much unwritten data in RAM, which causes heavy system freezes during USB data flushes.
To fix this run the following script:
```
buffer_optimize.sh
```

```Afeter executing any modifications to the docker image make sure to run the following tearing down the cureent and pulling new image with latest configurations:```

```
docker compose up -d
```



### Critical Troubleshooting: The DNS & 502 Bad Gateway Trap

### * Unable to access the storage or read/write perssion issue

```Solution``` Reset Drive permissons- The LinuxServer image runs an internal script on boot as user ID 1000 (abc). If it encounters a file it doesn't own inside your configurations or external Transcend drive, the PHP engine crashes silently. Force correct ownership:

```
sudo chown -R 1000:1000 ~/nextcloud/config
```


### * 502 Bad Gateway
During initialization, adding custom DNS server arrays directly into the `docker-compose.yml` service block caused a catastrophic network loop. The containerized Nginx web server failed its internal handshakes with the PHP-FPM processor, resulting in a persistent **502 Bad Gateway** error. 

```Solution``` 
**Do not declare DNS entries inside individual container files.** Instead, configure the Docker engine globally so all containers inherit your network's DNS mapping natively.

1. Open (or create) the global Docker configuration file:
   ```
   sudo nano /etc/docker/daemon.json
   ```
2. Inject your target DNS arrays cleanly:
   ```json
   {
     "dns": ["1.1.1.1", "8.8.8.8"]
   }
   ```
3. Purge the old network cache and restart the global Docker daemon:
   ```bash
   sudo systemctl restart docker
   ```
4. Tear down the broken container state and spin the stack up cleanly:
   ```bash
   cd ~/nextcloud
   docker compose down
   docker compose up -d
   ```






