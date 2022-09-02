#!/usr/bin/env bash

export DISPLAY=:0

x11vnc -rfbport "${VNC_PORT:-5900}" -bg -forever -nopw -quiet -display WAIT$DISPLAY &
Xvfb $DISPLAY -screen 0 1920x1200x24 +extension RANDR &

MAX_ATTEMPTS=120
COUNT=0
echo -n "Waiting for Xvfb to be ready..."
while ! xdpyinfo -display "${DISPLAY}" >/dev/null 2>&1; do
  echo -n "."
  sleep 0.50s
  COUNT=$(( COUNT + 1 ))
  if [[ ${COUNT} -ge ${MAX_ATTEMPTS} ]]; then
    echo "  Gave up waiting for X server on ${DISPLAY}"
    exit 1
  fi
done
echo "  Done - Xvfb is ready!"

fluxbox 2>/dev/null &

"$@"
RET_VAL=$?

pkill x11vnc || true
pkill Xvfb || true
pkill fluxbox || true
wait

unset DISPLAY

exit $RET_VAL