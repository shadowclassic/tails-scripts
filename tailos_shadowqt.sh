#!/bin/bash
set -e
clear


# Check for root.
if [ $(id -u) = "0" ]; then
  echo "
YOU SHOULD NOT RUN THIS SCRIPT AS ROOT!
YOU WILL BE PROMPTED FOR THE ADMIN PASS WHEN NEEDED.
"
  echo "PRESS ENTER TO EXIT SCRIPT, AND RUN AGAIN AS amnesia. "
  read continue
  exit 0
fi


# Make sure user has chosen the correct script.
echo "
          THIS SCRIPT WILL INSTALL SHADOW CORE AND DEPENDENCIES.
         YOU MUST HAVE AT LEAST 2GB OF FREE SPACE ON YOUR DEVICE.

               ADMIN PASS WILL BE REQUIRED MULTIPLE TIMES.
"
echo "PRESS ENTER TO CONTINUE."
read continue
clear


# Check for persistence.
if [ $(pwd | grep -c Persistent) = "0" -a -e /home/amnesia/Persistent ]; then
  echo "
  IT SEEMS YOU HAVE PERSISTENCE ENABLED, BUT YOU ARE IN THE FOLDER:
  "$PWD"
  IF YOU MOVE TO THE FOLDER /home/amnesia/Persistent/
  YOUR INSTALL WILL SURVIVE REBOOTS, OTHERWISE IT WILL NOT.
  "
  read -p "QUIT THE SCRIPT NOW TO MOVE? (y/n) " q
  if [ "$q" = "y" -o "$q" = "Y" ]; then
    exit 0
  else
    clear
  fi
elif [ ! -e /home/amnesia/Persistent ]; then
  echo "
  UNABLE TO DETECT PERSISTENCE MODE - INSTALLER WILL EXIT
  "
  exit 0
fi

# Update apt-get sources.
echo "
ENTER PASSWORD TO UPDATE SOURCES.
"
#sudo apt-get update
clear

# Install deps.
echo "
INSTALLING DEPENDENCIES FOR SHADOW CORE QT.
"
sudo apt-get -y install git qt5-default qt5-qmake qtbase5-dev-tools qttools5-dev-tools build-essential libboost-dev libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libssl-dev libdb++-dev libminiupnpc-dev libqt5webkit5-dev qtbase5-dev qtchooser
clear

# Download/verify Shadow Core.
echo "
GETTING SHADOW CORE, CHECKSUM, AND SIGNING KEYS...
"
git clone https://github.com/ShadowProject/shadow
cd shadow 
qmake && make
clear
