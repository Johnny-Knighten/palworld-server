FROM cm2network/steamcmd:root

LABEL maintainer="https://github.com/Johnny-Knighten"

ARG PGID=1000 \
    PUID=1000

ENV DEBUG=False \
    DRY_RUN=False \
    TZ=America/New_York \
    SERVER_DIR="/palworld/server" \
    LOGS_DIR="/palworld/logs" \
    BACKUPS_DIR="/palworld/backups" \
    SKIP_FILE_VALIDATION=False \
    PUBLIC_SERVER=True \
    PUBLIC_IP= \
    GAME_PORT=8211 \
    PLAYER_COUNT=32 \
    MULTITHREADING=True \
    EXTRA_LAUNCH_OPTIONS= \
    MANUAL_CONFIG=False \
    UPDATE_ON_BOOT=True \
    SERVER_NAME="Containerized Palworld Server" \
    SERVER_PASSWORD= \
    ADMIN_PASSWORD=adminpassword \
    RCON_ENABLED=True \
    RCON_PORT=25575 \
    SERVER_DESCRIPTION="A Containerized Palworld Server" \
    BACKUP_ON_STOP=True \
    ZIP_BACKUPS=False \
    RETAIN_BACKUPS= \
    SCHEDULED_RESTART=False \
    BACKUP_ON_SCHEDULED_RESTART=False \
    RESTART_CRON="0 4 * * *" \
    SCHEDULED_UPDATE=False \
    BACKUP_BEFORE_UPDATE=False \
    UPDATE_CRON="0 5 * * 0" \
    SCHEDULED_BACKUP=False \
    BACKUP_CRON="0 6 * * *" 

RUN set -x && \
    apt-get update && \
    apt-get install --no-install-recommends -y  \
                        supervisor=4.2.2-2 \
                        cron=3.0pl1-137 \
                        tzdata=2021a-1+deb11u11 \
                        unzip=6.0-26+deb11u1 \
                        zip=3.0-12 && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd -g "$PGID" -o palworld && \
    useradd -l -g "$PGID" -u "$PUID" -o --create-home palworld && \
    usermod -a -G crontab palworld

COPY bin/ /usr/local/bin
COPY palworldsettings_from_env_vars/ /usr/local/bin/palworldsettings_from_env_vars
COPY supervisord.conf /usr/local/etc/supervisord.conf
RUN ["chmod", "-R", "+x", "/usr/local/bin"]

VOLUME [ "${SERVER_DIR}" ]
VOLUME [ "${LOGS_DIR}" ]
VOLUME [ "${BACKUPS_DIR}" ]

WORKDIR ${SERVER_DIR}

EXPOSE 8211/udp
EXPOSE 25575/tcp

ENTRYPOINT ["/usr/local/bin/system-bootstrap.sh"]
CMD [""]