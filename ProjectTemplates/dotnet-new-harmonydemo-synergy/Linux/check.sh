#!/bin/bash

# Make sure we are in the same directory as the script

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $SCRIPT_DIR

# startserver.sh runs the service as Services.Host.<environment>

if [ -e .environment ]; then
  SERVER_BINARY=Services.Host.`cat .environment`
else
  SERVER_BINARY=Services.Host
fi

echo ""

servicePids=$(pidof $SERVER_BINARY)

if [ -z "$servicePids" ]
then
  echo "Harmony Core service ($SERVER_BINARY): NOT running"
else
  echo "Harmony Core service ($SERVER_BINARY): $servicePids"
fi

workerPids=`ps aux | grep -E '[d]b[rs].*host\.dbr$' | awk '{print $2}'`

if [ -z "$workerPids" ]
then
  echo "Traditional bridge workers: NONE"
else
  echo "Traditional bridge workers: $workerPids"
fi

echo ""
