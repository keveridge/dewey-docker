# Dewey Docker Configuration

## Overview
This repo contains configuration for services stored on the Dewey server.

Each docker container is configured via the following two files:
 * **.env.<service_name>**: Environment variables for the service
 * **docker-compose-<service_name>.yaml**: Docker compose configuration for the service

## Helper scripts
The folowing scripts are available to start and access the services:
* **start.ps1 <service_name>**: Starts the service
* **terminal.ps1 <service_name>**: Opens a terminal to the service

## Location of .env files
The .env files contain secrets, and are therefore backed up to the https://mega.nz service using the `kev.thomas@gmail.com` account.

Backups are made using the `duplicati` service.

Encryption keys for each of the individual backups are available in the [Duplicati - Dewey.local 1Password record](https://start.1password.com/open/i?a=M3ODQATEDRDPFD4DJYOAXHHC4M&v=rwx253urosbmfzydidvmwnvsxy&i=yhnfcfz5yc7jag3qbw25z6ip7q&h=my.1password.com).