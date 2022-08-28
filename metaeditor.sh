#!/usr/bin/env bash

if [[ -z "${MT_EDITOR_EXE_PATH}" ]]; then
  echo "Missing \$MT_EDITOR_EXE_PATH"
  exit 1
fi

if [[ ! -r "${MT_EDITOR_EXE_PATH}" ]]; then
  echo "MetaEditor .exe is not readable!"
  echo "Current user: $(id)"
  echo "Current permissions: $(ls -n "${MT_EDITOR_EXE_PATH}")"
  exit 1
fi

echo "MetaEditor .exe located at ${MT_EDITOR_EXE_PATH}"

exec xvfb-run -a wine "${MT_EDITOR_EXE_PATH}" "$@"
