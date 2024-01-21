#!/bin/bash

source ./tests/test_helper_functions.sh

perform_test "GAME_PORT=12345 - Game Port Is Set To 12345" \
             'OUTPUT=$(docker run --rm \
              -e DRY_RUN=True \
              -e GAME_PORT=12345 \
              --entrypoint bash \
              johnnyknighten/palworld-server:latest \
              -c "/usr/local/bin/palworld-server.sh");
             echo $OUTPUT | grep -q "port=12345"'

perform_test "GAME_PORT Not Set - Defaults To 8122" \
             'OUTPUT=$(docker run --rm \
              -e DRY_RUN=True \
              --entrypoint bash \
              johnnyknighten/palworld-server:latest \
              -c "/usr/local/bin/palworld-server.sh");
             echo $OUTPUT | grep -q "port=8122"'

perform_test "EXTRA_LAUNCH_OPTIONS='-ExtraFlag' - '-ExtraFlag' Appears In Launch Command" \
             'OUTPUT=$(docker run --rm \
              -e DRY_RUN=True \
              -e EXTRA_LAUNCH_OPTIONS="-ExtraFlag" \
              --entrypoint bash \
              johnnyknighten/palworld-server:latest \
              -c "/usr/local/bin/palworld-server.sh");
             echo $OUTPUT | grep -q "\-ExtraFlag"'

log_failed_tests
