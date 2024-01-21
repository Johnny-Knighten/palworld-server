#!/usr/bin/env bash

set -e

[[ -z "${DEBUG}" ]] || [[ "${DEBUG,,}" = "false" ]] || [[ "${DEBUG,,}" = "0" ]] || set -x

echo "System Bootstrap - Starting"

cleanup() {
    echo "System Bootstrap - Cleanup Starting"
    supervisorctl stop all
    if [[ "$BACKUP_ON_STOP" = "True" ]]; then
      supervisorctl start palworld-backup
      wait_for_backup_completion
    fi
    supervisorctl exit
    echo "System Bootstrap - Cleanup Stopping"
}

main() {
  if [[ "$DRY_RUN" = "True" ]]; then
    echo "DRY_RUN - exec /usr/bin/supervisord -c /usr/local/etc/supervisord.conf"
  else
    # TODO - This is a temp fix for the permissions issue, fix with a real solution
    chown -R palworld:palworld /palworld/server
    chmod -R 755 /palworld/server
    chown -R palworld:palworld /palworld/backups
    chmod -R 755 /palworld/backups
    chown -R palworld:palworld /palworld/logs
    chmod -R 755 /palworld/logs

    trap 'cleanup' SIGTERM
    /usr/bin/supervisord -c /usr/local/etc/supervisord.conf &
    wait $!
  fi
}

wait_for_backup_completion() {
  local counter=0
  local max_wait_time=600 

  while true; do
    local status
    status=$(supervisorctl status palworld-backup)
    if [[ "$status" == *"RUNNING"* ]] || [[ "$status" == *"STARTING"* ]]; then
      echo "System Bootstrap - Waiting For Backup Process To Finish."
    elif [[ "$status" == *"STOPPED"* ]] || [[ "$status" == *"EXITED"* ]] || [[ "$status" == *"FATAL"* ]]; then
      echo "System Bootstrap - Backup Process Has Finished"
    fi

    sleep 5
    ((counter += 5))

    if [[ "$counter" -ge "$max_wait_time" ]]; then
      echo "System Bootstrap - Timeout Duration Exceeded, Closing Supervisor Without Complete Backup"
      break
    fi
  done
}

main
