# Palworld - Dedicated Server Docker Container

Docker container image for running a Palworld dedicated server.


# Table of Contents

* [Features](#features)
* [Quick Start](#quick-start)
   - [Linux Host](#linux-host)
   - [Windows Host](#windows-host)
* [Game/Server Configs](#game/server-configs)
   - [Environment Variables](#environment-variables)
   - [Config Files](#config-files)
   - [Exposed Ports](#exposed-ports)
   - [Volumes](#volumes)
   - [Backups](#backups)
* [Deployment](#deployment)
* [Tags](#tags)
* [Build Image](#build-image)
* [Contributing](#contributing)

## Features

* Simple automated installation of Palworld dedicated server
* Configuration via environment variables and config files
* Scheduled server restarts and updates via Cron
  * Can be frozen to a specific version that is already downloaded
* Automated backups
* Linux Container


## Quickstart


### Linux Host

The Palwolrd server data in this example will be stored in your home directory (`/home/USERNAME/palworld`). 

```bash
# written for bash, but should work in other shells
# may require Sudo depending on your docker setup
$ docker run -d \
  --name palworld-server \
  -p 8211:8211/udp \
  -p 25575:25575/tcp \
  -e SERVER_NAME="\"My Palworld Server\"" \
  -e ADMIN_PASSWORD=secretpassword \
  -v $HOME/palworld/server:/palworld/server \
  -v $HOME/palworld/logs:/palworld/logs \
  johnnyknighten/palworld-server:latest
```

To view the container logs:

```bash
$ docker logs palworld-server -f
```

Press `CTRL+C` to exit the logs output.

To stop the container:
  
```bash
$ docker stop palworld-server
```
### Windows Host

This code is written for PowerShell, but assumes you are running Docker via WSL. If you installed Docker via Docker Desktop recently then you should be good to go. The volume mount path is written in context of a Linux shell in WSL, so you will need to adjust it to match your system.

For instance if you want to use `C:\Users\johnny\palworld` then the WSL path should be `/mnt/c/Users/johnny/palworld`. In general `/mnt/c` is the root of your C drive in WSL, and `/mnt/d` is the root of your D drive in WSL and so on.

```powershell
# written for powershell, but should work in other shells
docker run -d `
  --name palworld-server `
  -p 8211:8211/udp `
  -p 25575:25575/tcp `
  -e SERVER_NAME="My Palworld Server" `
  -e ADMIN_PASSWORD=secretpassword `
  -v /mnt/c/Users/USER/palworld/server:/palworld/server`
  -v /mnt/c/Users/USER/palworld/logs:/palworld/logs `
  johnnyknighten/ark-sa-server:latest
```

To view the container logs:

```bash
docker logs palworld-server -f
```

Press `CTRL+C` to exit the logs output.

To stop the container:
  
```bash
docker stop palworld-server
```

## Server/Game Configs

### Environment Variables

Environment variables are the primary way to configure the server itself.

The table below shows all available environment variables exposed for ease of use. Variables used to directly modify `PalWorldSettings.ini` can be found in the section below.

| Variable | Description | Default |
| --- | --- | :---: |
| `SKIP_FILE_VALIDATION` | Skips SteamCMD validation of the server files. Can speed up server start time, but could risk not detecting corrupted files. | `False` |
| `TZ` | Sets the timezone of the container. See the table [here](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) and look in the TZ identifier column. Highly recommend to set this if you will be using any of the CRON variables. | `America/New_York` |
| `MANUAL_CONFIG` | If set to `True` then the container will not auto generate `PalWorldSettings.ini` using environment variables. This is useful if you want to manage `PalWorldSettings.ini` yourself. | `False` |
| `SCHEDULED_RESTART` | Enable scheduled restarts of the server. | `False` |
| `BACKUP_ON_SCHEDULED_RESTART` | Determines if the server should backup itself before restarting. | `False` |
| `RESTART_CRON` | Cron expression for scheduled restarts. Default is everyday at 4am. | `0 4 * * *` |
| `SCHEDULED_UPDATE` | Enable scheduled updates of the server. | `False` |
| `UPDATE_CRON` | Cron expression for scheduled updates. Default is every Sunday at 5am. | `0 5 * * 0` |
| `BACKUP_BEFORE_UPDATE` | Determines if the server should backup itself before updating. | `False` |
| `SCHEDULED_BACKUP` | Enable scheduled backups of the server. | `False` |
| `BACKUP_CRON` | Cron expression for scheduled backups. Default is every day at 6am. | `0 6 * * *` |
| `UPDATE_ON_BOOT` | Determines if the server should update itself when it starts. | `True` |
| `BACKUP_ON_STOP` | Determines if the server should backup itself when the container stops. | `True` |
| `ZIP_BACKUPS` | If this is set to `True` then it will zip your backups instead of the default tar and gzip. | `False` |
| `RETAIN_BACKUPS` | Number of backups to keep. If not set, then an unlimited number of backs will be kept. | EMPTY |
| `MULTITHREADING` | Enables multithreading for the server. The `-useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS` launch flags will be included on server launch. | `True` |
| `SERVER_NAME` | Name of the server that appears in the server list. If the name contains a space wrap the name in quotes, depending on your system you may need to add escaped quotes `\"`. | `"Containerized Palworld Server"` |
| `SERVER_DESCRIPTION` | Description of the server that appears in the server list.| `"A Containerized Palworld Server"` |
| `SERVER_PASSWORD` | Password to login to the server. Defaults to no password aka a public server. **Do not put spaces in your password.** | EMPTY |
| `ADMIN_PASSWORD `| Password used for RCON access. **Do not put spaces in your password.** | `adminpassword` |
| `PUBLIC_SERVER` | Determines if the server should be listed on the in game server browser. | `True` |
| `PUBLIC_IP` | Public IP of the server. This is used to set the `-publicip=xxx.xxx.xxx.xxx` launch flag. This should be your networks external IP address and not you containers IP address | EMPTY |
| `GAME_PORT` | Primary game port. Also used to set the `-publicport=xxxx` launch flag. | `8211` |
| `RCON_ENABLED` | Enable RCON on the server. | `True` |
| `RCON_PORT`| RCON port for the server. | `25575` |
| `PLAYER_COUNT`| Maximum number of players allowed on the server. | `32` |
| `EXTRA_LAUNCH_OPTIONS`  | Extra launch options for the server. Allows additional flags that do not have an environment variable provided yet. | EMPTY |


### Configuring `PalWorldSettings.ini` 

The `PalWorldSettings.ini` file is the primary config file for the server. It is located in the `/palworld/server/Pal/Saved/Config/LinuxServer` directory inside the container. This file is generated automatically by the container using environment variables. If you wish to manage this file yourself, you must set `MANUAL_CONFIG=True` to prevent the container from generating/overwriting the file.

This container has two primary ways to manage `PalWorldSettings.ini`:
* Via `PALWORD_` Environment Variables
* Manually Edit The File

**Note - You should not mix and match these methods.**


#### Manual Config

To manually edit the config file, you must set `MANUAL_CONFIG=True` in your environment variables. This will prevent the container from generating the file. You can then edit the file directly in the `/palworld/server/Pal/Saved/Config/LinuxServer` directory inside the container.

If you want to configure `PalWorldSettings.ini` from inside the container, you can use the following command:

```bash
$ docker exec -it <CONTAINER-ID-OR-CONTAINER_NAME> nano /palworld/server/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
```

This will open `PalWorldSettings.ini` inside  `nano`. Make your edits then exit `nano` by pressing `CTRL+X` then `Y` then `ENTER`. Then restart your container for the changes to take effect.

#### Environment Variables

The container will automatically generate `PalWorldSettings.ini` using environment variables. Any environment variable prefixed with `PALWROLD_` will automatically be placed inside the `/Script/Pal.PalGameWorldSettings` section of `PalWorldSettings.ini` and saves them under the `OptionSettings` variable as comma separated values.

All text after the `PALWORLD_` prefix will be used as the variable name. For example `PALWORLD_ServerName` will be converted to `ServerName`.

Example:
`PALWORLD_ServerName="Palworld Server"`

Results in:
```ini
#PalWorldSettings.ini
[/Script/Pal.PalGameWorldSettings]
OptionSettings=(ServerName="Palworld Server")
```

Here is an example of a `docker run` command that uses environment variables to configure the server:

```bash
$ docker run -d \
  --name palworld-server \
  -p 8211:8211/udp \
  -p 25575:25575/tcp \
  -e PALWORLD_ExpRate=5.0 \
  -e PALWORLD_PalSpawnNumRate=2.0 \
  -e PALWORLD_PalDamageRateAttack=3.0 \
  -v $HOME/palworld/server:/palworld/server \
  -v $HOME/palworld/logs:/palworld/logs \
  johnnyknighten/palworld-server:latest
```

Another special feature of using environment variables is that backup copies of `PalWorldSettings.ini` are made when configuration changes are detected. That is, if you make a configuration change a `PalWorldSettings.ini.backup#` file is made. The `#` is incremented for each backup made. The highest number reflects the newest backup. This is useful if you make a mistake and want to revert to a previous config.

There are some overlap between some of the provided environment variables and the special `PALWORLD_` variables. For instance, `SERVER_NAME` is provided but `PALWORLD_ServerName` is also available. This container is setup to give non `PALWORLD_` priority over their `PALWORLD_` counterparts. For these specific variables **do not** use their `PALWORLD_` counterparts. Below shows the variables that have priority:

* `SERVER_NAME`
  * Do not use `PALWORLD_ServerName`
* `SERVER_DESCRIPTION`
  * Do not use `PALWORLD_ServerDescription`
* `SERVER_PASSWORD`
  * Do not use `PALWORLD_ServerPassword`
* `ADMIN_PASSWORD`
  * Do not use `PALWORLD_AdminPassword`
* `PLAYER_COUNT`
  * Do not use `PALWORLD_ServerPlayerMaxNum`
* `GAME_PORT`
  * Do not use `PALWORLD_PublicPort`
* `PUBLIC_IP`
  * Do not use `PALWORLD_PublicIP`
* `RCON_ENABLED`
  * Do not use `PALWORLD_RCONEnabled`
* `RCON_PORT`
  * Do not use `PALWORLD_RCONPort`

#### If `PalWorldSettings.ini` is Missing

Despite setting `MANUAL_CONFIG=True`, if the `PalWorldSettings.ini` file is missing a minimal config will be generated using the high priority variables mentioned in the section above.

### Exposed Ports

The table below shows the default ports that are exposed by the container. These can be changed by setting the environment variables `GAME_PORT` and `RCON_PORT`.

| Port | Protocol | Description |
| :---: | :---: | --- |
| 8211 | UDP | Game port |
| 25575 | TCP | RCON Port |

Make sure you have Port Forwarding configured otherwise the server will not be accessible from the internet. 

Note - Always ensure that your `-p` port mappings (if using docker run) and the `ports` section (if using docker compose) match up to the ports specified via the environment variables. If they do not match up, the server will not be accessible.

### Volumes

There are the volumes used by the container:

| Volume | Description |
| --- | --- |
| /palworld/server | Contains server files |
| /palworld/logs | Contains all log files generated by the container |

### Backups

Backups can be performed automatically if configured. Backups are performed by making a copy of the `/palworld/server/Pal/Saved` directory to the `/palworld/backups` volume. The backups file names use the following format: `server-backup-{datetime}`. They are compressed as `tar.gz` files by default(can be set to zip via `ZIP_BACKUPS=True`). You can configure the number of backups to keep using `RETAIN_BACKUPS`, otherwise you will need to manually delete old backups.

Backup Automation Options
* `BACKUP_ON_STOP` - Backup the server when the container stops
* `BACKUP_ON_SCHEDULED_RESTART` - Backup the server before a scheduled restart
* `BACKUP_BEFORE_UPDATE` - Backup the server before an update
* `SCHEDULED_BACKUP` - Backup the server on a schedule

#### Tip For Using `BACKUP_ON_STOP=True`

If you are planning on using `BACKUP_ON_STOP=True`, it is highly recommended you adjust the timeout settings of your `docker stop/compose down` command to allow the backup process enough time to complete its backup. Without doing this, it is likely your backup will be unfinished and corrupt. The longer your server has been running the bigger your backup will become which increases the time needed to backup the server. See the [Backup On Container Stop - Docker Timeout Considerations](https://github.com/Johnny-Knighten/palworld-server/wiki/Backups#backup-on-container-stop---docker-timeout-considerations) section of the wiki for more details.

## Deployment

See the deployment-examples directory for examples of how to deploy this container using docker-compose.

## Container Tags

| Tag | Description | Examples |
| ---| --- | :---: |
| latest | latest build from `main` branch. | `latest` |
| major.minor.fix | semantic versioned releases. | `1.0.0` |

There are also pre-release tags that are built from the `next` branch. These are used for testing and are not recommended for production use.

## Build Image

For development purposes, you can build the image locally.

```bash
$ docker build -t johnnyknighten/palworld-server:dev .
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to contribute to this project.
