#!/usr/bin/env bash

set -e

[[ -z "${DEBUG}" ]] || [[ "${DEBUG,,}" = "false" ]] || [[ "${DEBUG,,}" = "0" ]] || set -x

echo "Palworld Server Bootstrap - Starting"

main() {
  generate_config_files
  check_if_server_files_exist
  auto_update_server
  launch_palworld_server
}

launch_palworld_server() {
  echo "Palworld Server Bootstrap - Launching Palworld Server"
  if [[ "$DRY_RUN" = "True" ]]; then
    echo "DRY_RUN - supervisorctl start palworld-server"
  else
    supervisorctl start palworld-server
  fi
}

launch_update_service() {
  echo "Palworld Server Bootstrap - Launching Updater Service"
  if [[ "$DRY_RUN" = "True" ]]; then
    echo "DRY_RUN - supervisorctl start palworld-updater"
  else
    supervisorctl start palworld-updater
  fi
  exit 0
}

generate_config_files() {
  mkdir -p "${SERVER_DIR}/Pal/Saved/Config/LinuxServer"

  if [[ ! -f "${SERVER_DIR}/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini" || "$MANUAL_CONFIG" != "True" ]]; then
    echo "Palworld Server Bootstrap - Generating PalWorldSettings.ini"
    
    export PALWORLD_ServerName="${SERVER_NAME}"
    export PALWORLD_ServerDescription="${SERVER_DESCRIPTION}"
    export PALWORLD_ServerPassword="${SERVER_PASSWORD}"
    export PALWORLD_AdminPassword="${ADMIN_PASSWORD}"
    export PALWORLD_ServerPlayerMaxNum="${PLAYER_COUNT}"
    export PALWORLD_PublicPort="${GAME_PORT}"
    export PALWORLD_PublicIP="${PUBLIC_IP}"
    export PALWORLD_RCONEnabled="${RCON_ENABLED}"
    export PALWORLD_RCONPort="${RCON_PORT}"

    python3 /usr/local/bin/palworldsettings_from_env_vars/main.py --config-path "${SERVER_DIR}/Pal/Saved/Config/LinuxServer"
  else
    echo "Palworld Server Bootstrap - Skipping PalWorldSettings.ini Generation MANAUL_CONFIG is True"
  fi
}

# -eq 1  below because we assume the single config file is generate at this point
check_if_server_files_exist() {
  if [ "$(find "$SERVER_DIR" -mindepth 1 -maxdepth 1 | wc -l)" -eq 1 ]; then
    echo "Palworld Server Bootstrap - No Server Files Found, Downloading Server"
    launch_update_service
  fi
}

auto_update_server() {
  if [ "$UPDATE_ON_BOOT" = "True" ]; then
    echo "Palworld Server Bootstrap - Update On Boot Enabled"
    launch_update_service
  else
    echo "Palworld Server Bootstrap - Update On Boot Disabled, Skipping"
  fi
}

main
