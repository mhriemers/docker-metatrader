#!/usr/bin/env bash

export DISPLAY=:0

x11vnc -bg -forever -nopw -quiet -display WAIT$DISPLAY
Xvfb $DISPLAY -screen 0 1920x1080x32 +extension RANDR &
sleep 1
fluxbox 2>/dev/null &
xdpyinfo

"$@"
RET_VAL=$?

pkill x11vnc Xvfb fluxbox || true

exit $RET_VAL