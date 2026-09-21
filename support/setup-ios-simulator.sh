#!/bin/bash

################### Setting up Maestro ##################
mkdir -p ~/maestro-dir
cd ~/maestro-dir
# Pinned to Maestro 2.6.1. For a higher version, connect with support@testmuai.com
export MAESTRO_VERSION=2.6.1
curl -Ls "https://get.maestro.mobile.dev" | bash
sleep 5
export PATH="$PATH":"$HOME/.maestro/bin"
source /Users/ltuser/.bashrc
