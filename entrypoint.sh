#!/bin/bash

# Unset globals
unset -v MT_VERSION
unset -v MT_INSTALLATION
unset -v MT_TERMINAL_NAME
unset -v MT_TERMINAL_PATH
unset -v MT_METAEDITOR_NAME
unset -v MT_METAEDITOR_PATH

compile() {
  true;
}

backtest() {
  true;
}

run() {
  true;
}

while getopts :i:45 opt; do
  case ${opt} in
    i)
      MT_INSTALLATION=$OPTARG
      ;;
    4)
      MT_VERSION=4
      ;;
    5)
      MT_VERSION=5
      ;;
    *)
      echo "Invalid Option: $1"
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

if [ -z "${MT_VERSION}" ]; then
  echo "Missing MetaTrader version [-4|5]"
  exit 1
fi

if [ -z "${MT_INSTALLATION}" ]; then
  echo "Missing MetaTrader installation path [-i <path>]"
  exit 1
fi

if [ "${MT_VERSION}" == "4" ]; then
  MT_TERMINAL_NAME="terminal.exe"
  MT_METAEDITOR_NAME="metaeditor.exe"
elif [ "${MT_VERSION}" == "5" ]; then
  MT_TERMINAL_NAME="terminal64.exe"
  MT_METAEDITOR_NAME="metaeditor64.exe"
else
  echo "Unsupported MetaTrader version!"
  exit 1
fi

if [ ! -f "${MT_INSTALLATION}${MT_TERMINAL_NAME}" ]; then
  echo "MetaTrader Terminal does not exist!"
  exit 1
fi

if [ ! -f "${MT_INSTALLATION}${MT_METAEDITOR_NAME}" ]; then
  echo "MetaEditor does not exist!"
  exit 1
fi

echo "Using MetaTrader ${MT_VERSION} installed at ${MT_INSTALLATION}"

command=$1; shift
case ${command} in
  verify)
    echo "Installation valid!"
    exit 0
    ;;
  compile)
    shift; compile
    ;;
  backtest)
    shift; backtest
    ;;
  run)
    shift; run
    ;;
esac