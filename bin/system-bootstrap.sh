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
  setup_cron_jobs
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

setup_cron_jobs() {
  if [[ "$SCHEDULED_RESTART" = "True" ]]; then
    if [[ "$BACKUP_ON_SCHEDULED_RESTART" = "True" ]]; then
      echo "System Bootstrap - Setting Up Scheduled Restart With Backup"
      setup_cron_scheduled_restart_with_backup >> /usr/local/bin/palworld-cron-jobs
    else
      echo "System Bootstrap - Setting Up Scheduled Restart"
      setup_cron_scheduled_restart >> /usr/local/bin/palworld-cron-jobs
    fi
  fi

  if [[ "$SCHEDULED_UPDATE" = "True" ]]; then
    if [[ "$BACKUP_BEFORE_UPDATE" = "True" ]]; then
      echo "System Bootstrap - Setting Up Scheduled Update With Backup"
      setup_cron_scheduled_update_with_backup >> /usr/local/bin/palworld-cron-jobs
    else
      echo "System Bootstrap - Setting Up Scheduled Update"
      setup_cron_scheduled_update >> /usr/local/bin/palworld-cron-jobs
    fi
  fi

  if [[ "$SCHEDULED_BACKUP" = "True" ]]; then
    echo "System Bootstrap - Setting Up Scheduled Backup"
    setup_cron_scheduled_backup >> /usr/local/bin/palworld-cron-jobs
  fi

  if [[ -f /usr/local/bin/palworld-cron-jobs ]]; then
    echo "System Bootstrap - Updating Crontab"
    crontab /usr/local/bin/palworld-cron-jobs
    rm /usr/local/bin/palworld-cron-jobs
  fi
}
  
setup_cron_scheduled_restart() {
  echo "$(date) - Server Restart CRON Scheduled For: $RESTART_CRON" >> /palworld/logs/cron.log
  echo "$RESTART_CRON supervisorctl restart palworld-server && \
    echo \"\$(date) - CRON Restart - palworld-server\" >> /palworld/logs/cron.log"
}

setup_cron_scheduled_restart_with_backup() {
  echo "$(date) - Server Restart and Backup CRON Scheduled For: $RESTART_CRON" >> /palworld/logs/cron.log
  echo "$RESTART_CRON supervisorctl stop palworld-server && supervisorctl start palworld-backup-and-restart &&\
    echo \"\$(date) - CRON Restart + Backup - palworld-server\" >> /palworld/logs/cron.log"
}

setup_cron_scheduled_update() {
  echo "$(date) - Server Update Scheduled For: $UPDATE_CRON" >> /palworld/logs/cron.log
  echo "$UPDATE_CRON supervisorctl stop palworld-server && supervisorctl start palworld-updater && \
    echo \"\$(date) - CRON Update - palworld-updater\" >> /palworld/logs/cron.log"
}

setup_cron_scheduled_update_with_backup() {
  echo "$(date) - Server Update and Backup Scheduled For: $UPDATE_CRON" >> /palworld/logs/cron.log
  echo "$UPDATE_CRON supervisorctl stop palworld-server && supervisorctl start palworld-backup-and-update && \
    echo \"\$(date) - CRON Update + Backup - palworld-updater\" >> /palworld/logs/cron.log"
}

setup_cron_scheduled_backup() {
  echo "$(date) - Server Backup Scheduled For: $BACKUP_CRON" >> /palworld/logs/cron.log
  echo "$BACKUP_CRON supervisorctl stop palworld-server && supervisorctl start palworld-backup-and-restart && \
    echo \"\$(date) - CRON Backup - palworld-backup\" >> /palworld/logs/cron.log"
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
