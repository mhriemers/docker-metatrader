#!/usr/bin/env bash

set -e

cleanup() {
  trap - SIGINT SIGTERM
  unset DISPLAY
  kill 0
}

find_free_servernum() {
  local i=0
  while [ -f /tmp/.X${i}-lock ]; do
    i=$((i + 1))
  done
  echo $i
}

trap 'cleanup' SIGINT SIGTERM

USE_VNC=true

while getopts "n" arg; do
  case $arg in
  n)
    USE_VNC=false
    ;;
  *)
    exit 1
    ;;
  esac
done
shift $((OPTIND - 1))

SERVER_NUM=$(find_free_servernum)
export DISPLAY=":${SERVER_NUM}"
echo "Set display to $DISPLAY"

echo "Starting virtual framebuffer"
Xvfb "${DISPLAY}" -screen 0 1920x1200x24 +extension RANDR &

if [[ $USE_VNC == true ]]; then
  echo "Starting VNC server on port $VNC_PORT"
  x11vnc -rfbport "${VNC_PORT:-5900}" -bg -forever -nopw -quiet -display "WAIT${DISPLAY}" &
fi

MAX_ATTEMPTS=120
COUNT=0
echo -n "Waiting for Xvfb to be ready..."
while ! xdpyinfo -display "${DISPLAY}" >/dev/null 2>&1; do
  echo -n "."
  sleep 0.50s
  COUNT=$((COUNT + 1))
  if [[ ${COUNT} -ge ${MAX_ATTEMPTS} ]]; then
    echo "  Gave up waiting for X server on ${DISPLAY}"
    exit 1
  fi
done
echo "  Done - Xvfb is ready!"

if [[ $USE_VNC == true ]]; then
  echo "Starting fluxbox"
  fluxbox &
fi

"$@"
RET_VAL=$?

if [[ $USE_VNC == true ]]; then
  echo "Stopping fluxbox"
  pkill fluxbox || true

  echo "Stopping x11vnc"
  pkill x11vnc || true
fi

echo "Stopping Xvfb"
pkill Xvfb || true

wait
unset DISPLAY
exit $RET_VAL
