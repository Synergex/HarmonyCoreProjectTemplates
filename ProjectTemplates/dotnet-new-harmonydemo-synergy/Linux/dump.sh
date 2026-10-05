#!/bin/bash

# Check we are running as root

isroot=`id -u`
if [[ $isroot != 0 ]]
then
  echo -e "\nERROR: This script must be run as root.\n"
  return 2> /dev/null; exit
fi

# Check that dotnet-dump is installed

if [ ! -x /root/.dotnet/tools/dotnet-dump ]
then
  echo -e "\nERROR: The dotnet-dump utility was not found!\n"
  return 2> /dev/null; exit
fi

# Make sure we are in the same directory as the script

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $SCRIPT_DIR

# startserver.sh runs the service as Services.Host.<environment>

if [ -e .environment ]; then
  SERVER_BINARY=Services.Host.`cat .environment`
else
  SERVER_BINARY=Services.Host
fi

# Find the process ID of the service

thepid=$(pidof $SERVER_BINARY)
if [ -z "$thepid" ]
then
  echo -e "\nERROR: $SERVER_BINARY is not running!\n"
  return 2> /dev/null; exit
fi

echo "$SERVER_BINARY process found (pid $thepid)"

# Dump the process (this creates /tmp/coredump.<pid>)

echo "Creating coredump file"
./createdump $thepid

# Did it work?

if [[ ! $? -eq 0 ]]
then
  echo -e "\nERROR: The createdump command failed!\n"
  return 2> /dev/null; exit
fi

# Do we have a dump file?

if [ ! -e /tmp/coredump.$thepid ]
then
  echo -e "\nERROR: Dump file /tmp/coredump.$thepid not found!\n"
  return 2> /dev/null; exit
fi

# Analyze the dump file (interactive)

echo "Analyzing coredump file"
sudo /root/.dotnet/tools/dotnet-dump analyze /tmp/coredump.$thepid
