# Palworld - Dedicated Server Docker Container

Docker container image for running a Palworld dedicated server.


# Table of Contents

* [Features](#features)
* [Quick Start](#quick-start)
   - [Linux Host](#linux-host)
   - [Windows Host](#windows-host)

## Features

* Simple automated installation of Palworld dedicated server


## Quickstart


### Linux Host

The Palwolrd server data in this example will be stored in your home directory (`/home/USERNAME/palworld`). 

```bash
# written for bash, but should work in other shells
# may require Sudo depending on your docker setup
$ docker run -d \
  --name palworld-server \
  -p 8211:8211/udp \
  -v $HOME/palworld/server:/ark-server/server \
  -v $HOME/palworld/logs:/ark-server/logs \
  -v $HOME/palworld/backups:/ark-server/backups \
  johnnyknighten/palworld-server:latest
```

### Windows Host


## Build Image

For development purposes, you can build the image locally.

```bash
$ docker build -t johnnyknighten/palworld-server:dev --build-arg PUID=1000 --build-arg PGID=1000 .
```

