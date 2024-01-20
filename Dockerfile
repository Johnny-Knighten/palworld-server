FROM cm2network/steamcmd:root

LABEL maintainer="https://github.com/Johnny-Knighten"

ARG PGID=0 \
    PUID=0

ENV DEBUG=False \
    DRY_RUN=False \
    TZ=America/New_York \
    SERVER_DIR="/palworld/server" \
    LOGS_DIR="/palworld/logs" \
    SKIP_FILE_VALIDATION=False \
    PUBLIC_SERVER=True \
    PUBLIC_IP= \
    GAME_PORT=8211 \
    PLAYER_COUNT=32 \
    MULTITHREADING=True \
    EXTRA_LAUNCH_OPTIONS=

RUN set -x && \
    apt-get update && \
    apt-get install --no-install-recommends -y  \
                        supervisor && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd -g "$PGID" -o palworld && \
    useradd -l -g "$PGID" -u "$PUID" -o --create-home palworld

COPY bin/ /usr/local/bin
COPY supervisord.conf /usr/local/etc/supervisord.conf
RUN ["chmod", "-R", "+x", "/usr/local/bin"]

VOLUME [ "${SERVER_DIR}" ]
VOLUME [ "${LOGS_DIR}" ]

WORKDIR ${SERVER_DIR}

EXPOSE 8211/udp

ENTRYPOINT ["/usr/local/bin/system-bootstrap.sh"]
CMD [""]