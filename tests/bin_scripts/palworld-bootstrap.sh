#!/bin/bash

source ./tests/test_helper_functions.sh

GAME_SETTINGS_PATH="/palworld/server/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini"

perform_test "Ensure Config Templating Script Is Being Launched" \
             'docker run --rm \
              -e DRY_RUN=True \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              --entrypoint bash \
              johnnyknighten/palworld-server:latest \
              -c "/usr/local/bin/palworld-bootstrap.sh > /dev/null 2>&1 && \
                test -f $GAME_SETTINGS_PATH"'

perform_test "Server Files Not Present - Download Palworld Server" \
             'OUTPUT=$(docker run --rm \
              -e DRY_RUN=True \
              --entrypoint bash \
              johnnyknighten/palworld-server:latest \
              -c "/usr/local/bin/palworld-bootstrap.sh");
                echo $OUTPUT | grep -q "No Server Files Found" && \
                echo $OUTPUT | grep -qv "Update On Boot Enabled" && \
                echo $OUTPUT | grep -q "supervisorctl start palworld-updater" && \
                echo $OUTPUT | grep -qv "supervisorctl start palworld-server"'

perform_test "Server Files Present With Default UPDATE_ON_BOOT (Default = True)" \
            'OUTPUT=$(docker run --rm \
            -e DRY_RUN=True \
            --entrypoint bash \
            johnnyknighten/palworld-server:latest \
            -c "/usr/local/bin/system-bootstrap.sh && \
                touch /palworld/server/extra_file.txt && \
                /usr/local/bin/palworld-bootstrap.sh");
              echo $OUTPUT | grep -qv "No Server Files Found" && \
              echo $OUTPUT | grep -q "Update On Boot Enabled" && \
              echo $OUTPUT | grep -q "supervisorctl start palworld-updater" && \
              echo $OUTPUT | grep -qv "supervisorctl start palworld-server"'

perform_test "Server Files Present With UPDATE_ON_BOOT=False" \
            'OUTPUT=$(docker run --rm \
            -e DRY_RUN=True \
            -e UPDATE_ON_BOOT=False \
            --entrypoint bash \
            johnnyknighten/palworld-server:latest \
            -c "/usr/local/bin/system-bootstrap.sh && \
                touch /palworld/server/extra_file.txt && \
                /usr/local/bin/palworld-bootstrap.sh");
              echo $OUTPUT | grep -qv "No Server Files Found" && \
              echo $OUTPUT | grep -q "Update On Boot Disabled" && \
              echo $OUTPUT | grep -qv "supervisorctl start palworld-updater" && \
              echo $OUTPUT | grep -q "supervisorctl start palworld-server"'

log_failed_tests
