#!/bin/bash
sudo apt-get install cifs-utils
mkdir -p ~/qs-apps 
sudo mount.cifs //Bigmomma5/qs-apps ~/qs-apps -o user=pi
