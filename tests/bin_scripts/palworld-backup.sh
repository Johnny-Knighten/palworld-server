#!/bin/bash

source ./tests/test_helper_functions.sh

perform_test "Verify Backup Is Created With Defaults (.tar.gz)" \
             'docker run --rm \
              --entrypoint bash \
              johnnyknighten/palworld-server:latest \
              -c "mkdir -p /palworld/server/Pal/Saved && \
                echo "test" > /palworld/server/Pal/Saved/test.txt && \
                /usr/local/bin/palworld-backup.sh > /dev/null 2>&1 && \
                ls /palworld/backups/*.tar.gz > /dev/null 2>&1"'

perform_test "Verify Backup Is Created With Defaults (.zip)" \
             'docker run --rm \
              -e ZIP_BACKUPS=True \
              --entrypoint bash \
              johnnyknighten/palworld-server:latest \
              -c "mkdir -p /palworld/server/Pal/Saved && \
                echo "test" > /palworld/server/Pal/Saved/test.txt && \
                /usr/local/bin/palworld-backup.sh > /dev/null 2>&1 && \
                ls /palworld/backups/*.zip > /dev/null 2>&1"'

perform_test "Test RETAIN_BACKUPS=2 When There Are Already 5 Backups (Delete Files)" \
             'docker run --rm \
              -e RETAIN_BACKUPS=2 \
              --entrypoint bash \
              johnnyknighten/palworld-server:latest \
              -c "mkdir -p /palworld/server/Pal/Saved > /dev/null 2>&1 && \
                echo "test" > /palworld/server/Pal/Saved/test.txt > /dev/null 2>&1 && \
                for i in \$(seq 1 5); do touch /palworld/backups/testfile\$i.txt; done; \
                /usr/local/bin/palworld-backup.sh > /dev/null 2>&1 && \
                test \$(ls /palworld/backups | wc -l) -eq 2"'

perform_test "Test RETAIN_BACKUPS=6 When There Are Already 5 Backups (No Deletion)" \
             'docker run --rm \
              -e RETAIN_BACKUPS=6 \
              --entrypoint bash \
              johnnyknighten/palworld-server:latest \
              -c "mkdir -p /palworld/server/Pal/Saved > /dev/null 2>&1 && \
                echo "test" > /palworld/server/Pal/Saved/test.txt > /dev/null 2>&1 && \
                for i in \$(seq 1 5); do touch /palworld/backups/testfile\$i.txt; done; \
                /usr/local/bin/palworld-backup.sh > /dev/null 2>&1 && \
                test \$(ls /palworld/backups | wc -l) -eq 6"'

perform_test "Test RETAIN_BACKUPS Is Empty When There Are Already 5 Backups (No Deletion)" \
             'docker run --rm \
              --entrypoint bash \
              johnnyknighten/palworld-server:latest \
              -c "mkdir -p /palworld/server/Pal/Saved > /dev/null 2>&1 && \
                echo "test" > /palworld/server/Pal/Saved/test.txt > /dev/null 2>&1 && \
                for i in \$(seq 1 5); do touch /palworld/backups/testfile\$i.txt; done; \
                /usr/local/bin/palworld-backup.sh > /dev/null 2>&1 && \
                test \$(ls /palworld/backups | wc -l) -eq 6"'

perform_test "Verify palworld-server Is Launched When 'restart' Is Passed To The Script" \
             'OUTPUT=$(docker run --rm \
              -e DRY_RUN=True \
              --entrypoint bash \
              johnnyknighten/palworld-server:latest \
              -c "/usr/local/bin/palworld-backup.sh restart");
             echo $OUTPUT | grep -q "supervisorctl start palworld-server"'

perform_test "Verify palworld-updater Is Launched When 'update' Is Passed To The Script" \
             'OUTPUT=$(docker run --rm \
              -e DRY_RUN=True \
              --entrypoint bash \
              johnnyknighten/palworld-server:latest \
              -c "/usr/local/bin/palworld-backup.sh update");
             echo $OUTPUT | grep -q "supervisorctl start palworld-updater"'

log_failed_tests
