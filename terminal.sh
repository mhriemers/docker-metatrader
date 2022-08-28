#!/usr/bin/env bash

if [[ -z "${MT_TERMINAL_EXE_PATH}" ]]; then
  echo "Missing \$MT_TERMINAL_EXE_PATH"
  exit 1
fi

if [[ ! -f "${MT_TERMINAL_EXE_PATH}" ]]; then
  echo "MetaTrader Terminal .exe does not exist!"
  echo "\$MT_TERMINAL_EXE_PATH: ${MT_TERMINAL_EXE_PATH}" 1>&2
  exit 1
fi

if [[ ! -r "${MT_TERMINAL_EXE_PATH}" ]]; then
  echo "MetaTrader Terminal .exe is not readable!"
  echo "\$MT_TERMINAL_EXE_PATH: ${MT_TERMINAL_EXE_PATH}" 1>&2
  echo "Current permissions: $(ls -n "${MT_TERMINAL_EXE_PATH}")" 1>&2
  echo "Current user: $(id)" 1>&2
  exit 1
fi

echo "MetaTrader Terminal .exe located at ${MT_TERMINAL_EXE_PATH}"

exec xvfb-run -a wine "${MT_TERMINAL_EXE_PATH}" "$@"
