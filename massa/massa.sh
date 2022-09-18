#!/bin/bash

echo -e "\033[0;35m"
echo "       ::::    :::  ::::::::  :::::::::  :::::::: ::::     ::::  ";
echo "      :+:+:   :+: :+:    :+: :+:    :+: :+:       :+:     :+:    ";
echo "     :+:+:+  +:+ +:+    +:+ +:+    +:+ +:+        +:+   +:+      ";
echo "    +#+ +:+ +#+ +#+    +:+ +#+    +:+ +#++:++#      #+#          ";
echo "   +#+  +#+#+# +#+    +#+ +#+    +#+ +#+        +#+   +#+        ";
echo "  #+#   #+#+# #+#    #+# #+#    #+# #+#       #+#     #+#        ";
echo " ###    ####  ########  #########  ######## ###        ###       ";
echo -e "\e[0m"
 
sleep 2

echo -e "\e[1m\e[32m1. Server Updating and Port Setting ... \e[0m" && sleep 1
# server update and port settings
sudo apt-get update -y
sudo apt install ufw -y
sudo ufw enable
sudo ufw allow 22
sudo ufw allow ssh
sudo ufw allow 31244/tcp
sudo ufw allow 31245/tcp
sudo ufw status

echo "Node loading please wait :)"
sleep 3

echo -e "\e[1m\e[32m1. Update Package ... \e[0m" && sleep 1
# required libraries
sudo apt install pkg-config curl git build-essential libssl-dev libclang-dev -y
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
rustc --version
rustup toolchain install nightly
rustup default nightly
rustc --version
git clone --branch testnet https://github.com/massalabs/massa.git

# rustc explain fixed
sudo apt install make clang pkg-config libssl-dev -y
rustup default nightly 
rustup update

# settings file
echo "Yeay! Congrats, Node installed successfully...."
sleep 2

echo "Enter your server's ip address :"
read ipadr
echo -e "[network]\nroutable_ip = '$ipadr'" >> massa/massa-node/config/config.toml

echo -e "\e[1m\e[32m1. Restartting server for the settings to take effect. ... \e[0m"
# reboot to take effect
sleep 2
reboot
