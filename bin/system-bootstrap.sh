#!/usr/bin/env bash

set -e

[[ -z "${DEBUG}" ]] || [[ "${DEBUG,,}" = "false" ]] || [[ "${DEBUG,,}" = "0" ]] || set -x

echo "System Bootstrap - Starting"

cleanup() {
    echo "System Bootstrap - Cleanup Starting"
    supervisorctl stop all
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

    trap 'cleanup' SIGTERM
    /usr/bin/supervisord -c /usr/local/etc/supervisord.conf &
    wait $!
  fi
}

main
