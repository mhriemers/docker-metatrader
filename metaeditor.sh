#!/usr/bin/env bash

if [[ -z "${MT_VERSION}" ]]; then
  echo "Missing \$MT_VERSION"
  exit 1
fi

echo "MetaTrader ${MT_VERSION} selected."

if [[ -z "${MT_INSTALLATION}" ]]; then
  echo "Missing \$MT_INSTALLATION"
  exit 1
fi

echo "MetaTrader ${MT_VERSION} installed at ${MT_INSTALLATION}."

if [[ ! -r "${MT_INSTALLATION}" ]]; then
  echo "MetaTrader installation is not readable!"
  echo "Current user: $(id)"
  echo "Current permissions: $(ls -nd "${MT_INSTALLATION}")"
  exit 1
fi

if [[ -z "${MT_EDITOR_EXE_PATH}" ]]; then
  echo "Missing \$MT_EDITOR_EXE_PATH"
  exit 1
fi

echo "MetaEditor .exe located at ${MT_EDITOR_EXE_PATH}"

exec xvfb-run -a wine "${MT_EDITOR_EXE_PATH}" "$@"
