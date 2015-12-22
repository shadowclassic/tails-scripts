# tails-scripts

A set of scripts for quickly getting the ShadowCore client up and running on Debian/Tails.

#shadowqt_compile.sh
This script will compile the ShadowCore client from the "master" Shadow branch.

Dependencies:
* Tails > 1.80 (tested)
* Persistence Mode
* Enable Persistence features
  * Personal Data
  *	APT Packages
  * APT Lists

Install:

1. cd /home/amnesia/Persitence/
2. git clone https://github.com/shadowproject/tails-scripts
3. cd tails-scripts
4. sh shadowqt_compile.sh
