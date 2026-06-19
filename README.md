# Nextcloud-on-Raspberry-Pi-4
NExtcloud Docker conatiner runs on a optimized Raspberyy Pi 4 hardware offering High-Performance with Self-Hosted Cloud Storage capabilites.

# Nextcloud on Raspberry Pi 4: High-Performance Self-Hosted Cloud Storage

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
*  #echo $?
*  #0 >> SUCESS
*  #1 or -1 >> FAILURE




    

