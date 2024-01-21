#!/bin/bash

source ./tests/test_helper_functions.sh

perform_test "Verify SteamCMD is Installed" \
            "docker run --rm \
              --entrypoint steamcmd \
              johnnyknighten/palworld-server:latest \
              +quit > /dev/null 2>&1"

perform_test "Verify Supervisor is Installed" \
             "docker run --rm \
                --entrypoint supervisord \
                johnnyknighten/palworld-server:latest \
                -v > /dev/null 2>&1"

perform_test "Verify CRON is Installed" \
             'docker run --rm \
                --entrypoint bash \
                johnnyknighten/palworld-server:latest \
                -c "echo \"* * * * * test\" > crontab.txt && crontab crontab.txt && crontab -l" > /dev/null 2>&1'

perform_test "Verify tzdata is Installed" \
             'docker run --rm \
                --entrypoint bash \
                johnnyknighten/palworld-server:latest \
                -c "cat /usr/share/zoneinfo/tzdata.zi | head -n 1 | grep \"# version 2023c\"" > /dev/null 2>&1'

perform_test "Verify tar is Installed" \
             'docker run --rm \
                --entrypoint tar \
                johnnyknighten/palworld-server:latest \
                --version > /dev/null 2>&1'

perform_test "Verify zip is Installed" \
             'docker run --rm \
                --entrypoint zip \
                johnnyknighten/palworld-server:latest \
                -v > /dev/null 2>&1'

perform_test "Verify unzip is Installed" \
             'docker run --rm \
                --entrypoint unzip \
                johnnyknighten/palworld-server:latest \
                -v > /dev/null 2>&1'

perform_test "Verify supervisord.conf Is Present" \
            'docker run --rm \
              --entrypoint bash \
              johnnyknighten/palworld-server:latest \
              -c "test -f /usr/local/etc/supervisord.conf"'

perform_test "Verify Python Is Installed" \
            'docker run --rm \
              --entrypoint bash \
              johnnyknighten/palworld-server:latest \
              -c "python3 --version"'

perform_test "Verify palworld-container/bin Content is Present" \
            'docker run --rm \
              --entrypoint bash \
              johnnyknighten/palworld-server:latest \
              -c "test -f /usr/local/bin/system-bootstrap.sh && \
                  test -f /usr/local/bin/palworld-bootstrap.sh && \
                  test -f /usr/local/bin/palworld-server.sh && \
                  test -f /usr/local/bin/palworld-updater.sh && \
                  test -f /usr/local/bin/palworld-backup.sh && \
                  test -f /usr/local/bin/palworldsettings_from_env_vars/__init__.py && \
                  test -f /usr/local/bin/palworldsettings_from_env_vars/main.py"'

log_failed_tests
