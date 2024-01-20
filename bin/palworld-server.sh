#!/usr/bin/env bash

set -e

[[ -z "${DEBUG}" ]] || [[ "${DEBUG,,}" = "false" ]] || [[ "${DEBUG,,}" = "0" ]] || set -x


trap cleanup SIGTERM SIGINT

start_time=$(date +%s)
echo "Palworld Server - Starting at $start_time"

main() {
  start_server
}

start_server() {
  echo "Palworld Server - Starting server..."

  local public_flags=""

  if [[ "$PUBLIC_SERVER" = "True" ]]; then
    public_flags+="EpicApp=PalServer -publicport=$GAME_PORT"
  fi

  if [[ -n $PUBLIC_PORT ]];then
      public_flags+=" -publicport=$PUBLIC_PORT"
  fi

  local thread_flags=""

  if [[ "$MULTITHREADING" = "True"  ]];then
      thread_flags+="-useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS"
  fi

  echo ./PalServer.sh players="$PLAYER_COUNT" port="$GAME_PORT" "$public_flags" "$thread_flags" "$EXTRA_LAUNCH_OPTIONS"
  ./PalServer.sh players="$PLAYER_COUNT" port="$GAME_PORT" "$public_flags" "$thread_flags" "$EXTRA_LAUNCH_OPTIONS"
}

cleanup() {
  echo "Palworld Server - Cleaning up before stopping..."
  echo "Palworld Server - Cleanup complete."
}

main
