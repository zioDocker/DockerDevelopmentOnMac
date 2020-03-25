#!/usr/bin/env bash

YES=0; # set option yes
if  [[ $1 = "-y" ]]; then
    YES=1;
fi

OS=`uname -s`

if [ $OS != "Darwin" ]; then
  echo "This script is OSX-only. Please do not run it on any other Unix."
  exit 1
fi

if [[ $EUID -eq 0 ]]; then
  echo "This script must NOT be run with sudo/root. Please re-run without sudo." 1>&2
  exit 1
fi

echo ""
echo " +-----------------------------+"
echo " | Setup native NFS for Docker |"
echo " +-----------------------------+"
echo ""

echo "WARNING: This script will shut down running containers."
if [ "$YES" -ne "1" ]; then
  echo -n "Do you wish to proceed? [y]: "
  read decision

  if [ "$decision" != "y" ]; then
    echo "Exiting. No changes made."
    exit 1
  fi
fi

echo ""

if ! docker ps > /dev/null 2>&1 ; then
  echo "== Waiting for docker to start..."
fi

open -a Docker

while ! docker ps > /dev/null 2>&1 ; do sleep 2; done

echo "== Stopping running docker containers..."
docker-compose down -v -f > /dev/null 2>&1
docker volume prune -f > /dev/null

osascript -e 'quit app "Docker"'

U=`id -u`
G=`id -g`
echo "== Resetting folder permissions ->$U:$G"
sudo chown -Rf "$U":"$G" $(pwd)

echo "== Setting up nfs..."
FILE=/etc/exports
sudo cp "$(pwd)/configuration/etc/exports" $FILE

FILE=/etc/nfs.conf
sudo cp "$(pwd)/configuration/etc/nfs.conf" $FILE

echo "== Restarting nfsd..."
sudo nfsd restart

echo "== Restarting docker..."
open -a Docker

while ! docker ps > /dev/null 2>&1 ; do sleep 2; done

echo ""
echo "SUCCESS! Now go run your containers 🐳"
