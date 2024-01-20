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
  ./PalServer.sh
}

cleanup() {
  echo "Palworld Server - Cleaning up before stopping..."
  echo "Palworld Server - Cleanup complete."
}

main
