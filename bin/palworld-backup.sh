#!/usr/bin/env bash

set -e

[[ -z "${DEBUG}" ]] || [[ "${DEBUG,,}" = "false" ]] || [[ "${DEBUG,,}" = "0" ]] || set -x

echo "Backup Process - Starting"

SCRIPT_PARAM="$1"

main() {
  clean_up_backups_dir
  backup_palworld_server
  start_palworld_server
  start_palworld_update
}

start_palworld_server() {
  if [[ "$SCRIPT_PARAM" = "restart" ]]; then
     echo "Backup Process - Starting Palworld Server After Backup"
    if [[ "$DRY_RUN" = "True" ]]; then
      echo "DRY_RUN - supervisorctl start palworld-server"
    else
      supervisorctl start palworld-server
    fi
  fi
}

start_palworld_update() {
  if [[ "$SCRIPT_PARAM" = "update" ]]; then
    echo "Backup Process - Starting Palworld Server Update After Backup"
    if [[ "$DRY_RUN" = "True" ]]; then
      echo "DRY_RUN - supervisorctl start palworld-updater"
    else
      supervisorctl start palworld-updater
    fi
  fi
}

zip_backup() {
if [[ "$DRY_RUN" = "True" ]]; then
    echo "DRY_RUN - zip -r \"${BACKUPS_DIR}/palworld-server-$(date +%Y%m%d%H%M%S).zip\" \"${SERVER_DIR}/Pal/Saved\""
  else
    zip -r "${BACKUPS_DIR}/palworld-server-$(date +%Y%m%d%H%M%S).zip" "${SERVER_DIR}/Pal/Saved"
  fi
}

tar_gz_backup() {
  if [[ "$DRY_RUN" = "True" ]]; then
    echo "DRY_RUN - tar -czf \"${BACKUPS_DIR}/palworld-server-$(date +%Y%m%d%H%M%S).tar.gz\" \"${SERVER_DIR}/Pal/Saved\""
  else
    tar -czf "${BACKUPS_DIR}"/palworld-server-$(date +%Y%m%d%H%M%S).tar.gz "${SERVER_DIR}"/Pal/Saved
  fi
}

backup_palworld_server() {
  echo "Backup Process - Backing Up Palworld Server"
  if [[ "$ZIP_BACKUPS" = "True" ]]; then
    zip_backup
  else
    tar_gz_backup
  fi
  echo "Backup Process - Backup Finished"
}

clean_up_backups_dir() {
  if [[ -n "$RETAIN_BACKUPS" ]]; then
    echo "Backup Process - Cleaning Up Backup Directory"
    count_files() {
      find "$BACKUPS_DIR" -type f | wc -l
    }

    delete_oldest_file() {
        find "$BACKUPS_DIR" -type f -print0 | xargs -0 ls -tr | head -n 1 | xargs rm -f
    }

    current_file_count=$(count_files)

    while [ "$current_file_count" -gt "$((RETAIN_BACKUPS - 1))" ]; do
        echo "Backup Process - File Limit Exceded: ($current_file_count),  Deleting Oldest"
        delete_oldest_file
        current_file_count=$(count_files)
    done

    echo "Backup Process - File Count Post Cleanup: $(count_files)"
  fi
}

main
