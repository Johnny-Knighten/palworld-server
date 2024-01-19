FROM steamcmd/steamcmd:ubuntu-22

LABEL maintainer="https://github.com/Johnny-Knighten"

ARG PGID=0 \
    PUID=0

ENV DEBUG=False \
    DRY_RUN=False \
    TZ=America/New_York \
    SERVER_DIR="/palworld/server" \
    SKIP_FILE_VALIDATION=False

COPY bin/ /usr/local/bin
RUN ["chmod", "-R", "+x", "/usr/local/bin"]

VOLUME [ "${SERVER_DIR}" ]

WORKDIR ${SERVER_DIR}

ENTRYPOINT ["/usr/local/bin/palworld-updater.sh"]
CMD []