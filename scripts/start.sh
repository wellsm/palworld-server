#!/bin/bash
set -e

export HOME=/home/steam
export USER=steam

mkdir -p "$HOME/.steam"

MAX_RETRIES=5
RETRY_DELAY=20

attempt=1

while [ $attempt -le $MAX_RETRIES ]; do
  echo "[SteamCMD] Attempt $attempt / $MAX_RETRIES"

  if /steamcmd/steamcmd.sh \
      +@ShutdownOnFailedCommand 1 \
      +@NoPromptForPassword 1 \
      +force_install_dir /palworld \
      +login anonymous \
      +app_update 2394010 validate \
      +quit; then

    echo "[SteamCMD] Update OK"

    break
  fi

  echo "[SteamCMD] Failed, cleaning cache..."

  rm -rf /home/steam/.steam
  rm -rf /palworld/steamapps

  echo "[SteamCMD] Retrying in ${RETRY_DELAY}s..."

  sleep $RETRY_DELAY

  attempt=$((attempt + 1))
done

if [ $attempt -gt $MAX_RETRIES ]; then
  echo "[SteamCMD] Failed after $MAX_RETRIES attempts"
  exit 1
fi

echo "[Palworld] Starting server..."
exec /palworld/PalServer.sh -useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS

