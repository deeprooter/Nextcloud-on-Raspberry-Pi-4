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


### The Production File (`docker-compose.yml`)
This deployment pairs the Nextcloud application with an in-memory Redis cache and automated health checking to make the platform self-healing.

