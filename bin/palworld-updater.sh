#!/usr/bin/env bash

set -e

[[ -z "${DEBUG}" ]] || [[ "${DEBUG,,}" = "false" ]] || [[ "${DEBUG,,}" = "0" ]] || set -x

echo "Updater - Starting"

main() {
 download_and_update_palworld
}


download_and_update_palworld() {
  if [ "$SKIP_FILE_VALIDATION" = "True" ]; then
    echo "Updater - Skipping SteamCMD Validation of Server Files"
    local app_update="+app_update 2394010"
  else
    local app_update="+app_update 2394010 validate"
  fi

  local install_dir="+force_install_dir $SERVER_DIR"

  if [[ "$DRY_RUN" = "True" ]]; then
    echo "$DRY_RUN_MSG steamcmd +login anonymous \"$install_dir\" \"$app_update\" +quit"
  else
    steamcmd +login anonymous "$install_dir" "$app_update" +quit
  fi
}

main