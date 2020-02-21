#!/bin/bash
# sudo apt-get install cifs-utils
# mkdir ~/Desktop/Windows-Share 
sudo mount.cifs //Bigmomma5/Quickstarts /home/pi/Quickstarts -Share -o user=pi
