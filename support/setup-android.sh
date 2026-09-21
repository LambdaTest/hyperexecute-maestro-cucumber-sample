#!/bin/bash

############## Don't modify this part of the script #####################
# Updates ADB to a version that supports Maestro
sudo rm -f /usr/bin/adb
sudo rm -rf /usr/lib/android-sdk/platform-tools

sudo mkdir -p /usr/local/android-sdk

cd /usr/local/android-sdk/
sudo curl -OL https://dl.google.com/android/repository/platform-tools-latest-linux.zip
sudo unzip platform-tools-latest-linux.zip
sudo rm -f platform-tools-latest-linux.zip
sudo ln -s /usr/local/android-sdk/platform-tools/adb /usr/bin/adb
sudo cp -r /usr/local/android-sdk/platform-tools /usr/lib/android-sdk/

################### Setting up Maestro ##################
mkdir -p ~/maestro-dir
cd ~/maestro-dir
# Pinned to Maestro 2.6.1. For a higher version, connect with support@testmuai.com
export MAESTRO_VERSION=2.6.1
curl -Ls "https://get.maestro.mobile.dev" | bash
sleep 5
export PATH="$PATH":"$HOME/.maestro/bin"
source /home/ltuser/.bashrc
