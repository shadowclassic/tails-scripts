#!/bin/bash
set -e
clear

# Check for root.
if [ $(id -u) = "0" ]; then
  echo "
YOU SHOULD NOT RUN THIS SCRIPT AS ROOT!
YOU WILL BE PROMPTED FOR THE ADMIN PASS WHEN REQUIRED.
"
  exit 0
fi

# Make sure user has chosen the correct script.
echo "
THIS SCRIPT WILL COMPILE SHADOW CORE QT CLIENT, BLOCK CHAIN DATA AND DEPENDENCIES. 
YOU MUST HAVE AT LEAST 2GB OF FREE SPACE ON YOUR DEVICE.

ADMIN PASS WILL BE REQUIRED MULTIPLE TIMES.
PRESS ENTER TO CONTINUE.
"
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
  read -p "QUIT INSTALLTION TO MOVE PATH? (y/n) " q
  if [ "$q" = "y" -o "$q" = "Y" ]; then
    exit 0
  fi
elif [ ! -e /home/amnesia/Persistent ]; then
  echo "UNABLE TO DETECT PERSISTENCE MODE - INSTALLER WILL EXIT"
  exit 0
fi

# Update apt-get sources.
echo "
ENTER PASSWORD TO UPDATE SOURCES.
"
sudo apt-get update
clear

# Install dependencies.
echo "
INSTALLING DEPENDENCIES FOR SHADOW CORE QT.
"
sudo apt-get -y install git qt5-default qt5-qmake qtbase5-dev-tools qttools5-dev-tools build-essential libboost-dev libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libssl-dev libdb++-dev libminiupnpc-dev libqt5webkit5-dev qtbase5-dev qtchooser
clear

# Download/verify Shadow Core.
echo "
GETTING SHADOW CORE AND CONFIGURE...
"
if [ -e "$PWD/shadow/" ]; then
  cd shadow
  git pull
else
  git clone https://github.com/ShadowProject/shadow
  cd shadow 
fi
qmake && make
mkdir -p /home/amnesia/Persistent/.shadowcoin
clear

# Check for shadowcoin.conf
if [ -e "/home/amnesia/Persistent/.shadowcoin/shadowcoin.conf" ]; then
  echo ""; 
  read -p 'FILE "shadowcoin.conf" EXISTS. OVERWRITE? (y/n) ' ow
  if  [ "$ow" = "y" -o "$ow" = "Y" ]; then
	# Create a shadowcoin.conf.
	rpcu=$(pwgen -ncsB 35 1)
	rpcp=$(pwgen -ncsB 75 1)
	echo "rpcuser="$rpcu"
rpcpassword="$rpcp"
daemon=1
proxy=127.0.0.1:9050
listen=0
addnode=shadow5ea566kf2j.onion
addnode=shadow6ol332q3pc.onion
addnode=shadow7tqhrivoa3.onion
datadir=/home/amnesia/Persistent/.shadowcoin/" > /home/amnesia/Persistent/.shadowcoin/shadowcoin.conf
  fi
else
	# Create a shadowcoin.conf.
	rpcu=$(pwgen -ncsB 35 1)
	rpcp=$(pwgen -ncsB 75 1)
	echo "rpcuser="$rpcu"
rpcpassword="$rpcp"
daemon=1
proxy=127.0.0.1:9050
listen=0
addnode=shadow5ea566kf2j.onion
addnode=shadow6ol332q3pc.onion
addnode=shadow7tqhrivoa3.onion
datadir=/home/amnesia/Persistent/.shadowcoin/" > /home/amnesia/Persistent/.shadowcoin/shadowcoin.conf
fi

# Download/verify Shadow Blockchain.
echo "
GETTING SHADOW BLOCKCHAIN AND CHECKSUM...
"
DOWNLOAD_URL="https://github.com/ShadowProject/blockchain/releases/download/latest"
DOWNLOAD_FILE="blockchain.zip"

cd ..
wget --no-check-certificate $DOWNLOAD_URL/$DOWNLOAD_FILE -O $DOWNLOAD_FILE
wget --no-check-certificate $DOWNLOAD_URL/$DOWNLOAD_FILE.DIGESTS.txt -O $DOWNLOAD_FILE.DIGESTS.txt
if [ ! -e $DOWNLOAD_FILE ] ; then
	echo "[blockchain] Error : downloading latest blockchain file"
	exit 0
fi

echo "[blockchain] Verifying checkum"
SHA256SUM=$( sha256sum $DOWNLOAD_FILE )
MD5SUM=$( md5sum $DOWNLOAD_FILE )
SHA256PASS=$( grep $SHA256SUM ${DOWNLOAD_FILE}.DIGESTS.txt | wc -l )
MD5SUMPASS=$( grep $MD5SUM ${DOWNLOAD_FILE}.DIGESTS.txt | wc -l )
if [ $SHA256PASS -lt 1 -o $MD5SUMPASS -lt 1 ] ; then
		echo "[blockchain] Error : Checksum Failed."
		exit 0
fi

echo "[blockchain] Extracting file"
unzip -o $DOWNLOAD_FILE -d /home/amnesia/Persistent/.shadowcoin/

# Finish off.
echo "
SHADOW CORE SUCCESSFULLY INSTALLED AND CONFIGURED!

YOUR SHADOWCORE FOLDER:                 $(pwd)/shadow/
YOUR SHADOWCORE BLOCKCHAIN DATA FOLDER: /home/amnesia/Persistent/.shadowcoin/
YOUR SHADOWCOIN.CONF         :          /home/amnesia/Persistent/.shadowcoin/shadowcoin.conf

TO RUN SHADOW, ENTER FOLDER: $(pwd)/shadow/
AND RUN: ./shadow -conf=/home/amnesia/Persistent/.shadowcoin/shadowcoin.conf
"
