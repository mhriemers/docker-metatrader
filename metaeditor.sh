#!/usr/bin/env bash

if [[ -z "${MT_EDITOR_EXE_PATH}" ]]; then
  echo "Missing \$MT_EDITOR_EXE_PATH"
  exit 1
fi

if [[ ! -f "${MT_EDITOR_EXE_PATH}" ]]; then
  echo "MetaEditor .exe does not exist!"
  echo "\$MT_EDITOR_EXE_PATH: $MT_EDITOR_EXE_PATH" 1>&2
  exit 1
fi

if [[ ! -r "${MT_EDITOR_EXE_PATH}" ]]; then
  echo "MetaEditor .exe is not readable!"
  echo "\$MT_EDITOR_EXE_PATH: $MT_EDITOR_EXE_PATH" 1>&2
  echo "Current permissions: $(ls -n "${MT_EDITOR_EXE_PATH}")" 1>&2
  echo "Current user: $(id)" 1>&2
  exit 1
fi

echo "MetaEditor .exe located at ${MT_EDITOR_EXE_PATH}" 1>&2

exec with-display wine "${MT_EDITOR_EXE_PATH}" "$@"
