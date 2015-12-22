# tails-scripts

A set of scripts for quickly getting the ShadowCore client up and running on Debian/Tails.

##shadowqt_compile.sh
This script will compile the ShadowCore client from the "master" Shadow branch.

**Dependencies**
* Tails > 1.80 (tested)
* Persistence Mode
* Enable [Persistence] (https://tails.boum.org/doc/first_steps/persistence/configure/index.en.html#index3h1) features
  * Personal Data
  *	APT Packages
  * APT Lists

**Install**
```
cd /home/amnesia/Persitence/
git clone https://github.com/shadowproject/tails-scripts
cd tails-scripts
sh shadowqt_compile.sh
```

**Known Issues** 

Due to a bug in Tails Persistence Additional Software app during reboot of Tails the installed dependencies are not reconfigured.
You can fix this by running the below command on start-up.

`sudo apt-get -y install qt5-default qt5-qmake qtbase5-dev-tools qttools5-dev-tools build-essential libboost-dev libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libssl-dev libdb++-dev libminiupnpc-dev libqt5webkit5-dev qtbase5-dev qtchooser
`
