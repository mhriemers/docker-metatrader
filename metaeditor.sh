#!/usr/bin/env bash

if [ -z "${MT_VERSION}" ]; then
  echo "Missing MetaTrader version"
  exit 1
fi

if [ -z "${MT_INSTALLATION}" ]; then
  echo "Missing MetaTrader installation"
  exit 1
fi

if [ "${MT_VERSION}" == "4" ]; then
  exec xvfb-run -a wine "${MT_INSTALLATION}metaeditor.exe" "$@"
elif [ "${MT_VERSION}" == "5" ]; then
  exec xvfb-run -a wine "${MT_INSTALLATION}metaeditor64.exe" "$@"
else
  echo "Unsupported MetaTrader version!"
  exit 1
fi