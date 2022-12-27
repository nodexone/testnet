#!/bin/bash

echo -e "\033[0;31m"
echo " ::::    :::  ::::::::  :::::::::  :::::::: ::::     :::: ";
echo " :+:+:   :+: :+:    :+: :+:    :+: :+:       :+:     :+:  ";
echo " :+:+:+  +:+ +:+    +:+ :+:    :+: +:+        +:+   +:+   ";
echo " +#+ +:+ +#+ +#+    +:+ +#+    +:+ +#++:++#      #+#      ";
echo " +#+  +#+#+# +#+    +#+ +#+    +:+ +#+        +#+   +#+   ";
echo " #+#   #+#+# #+#    #+# #+#    #+# #+#       #+#     #+#  ";
echo " ###    ####  ########  #########  ######## ###       ### ";
echo -e "\e[0m"

sleep 2

# set vars

echo -e "\e[1;33m1. Updating packages... \e[0m"
sleep 1

# update

sudo apt update && apt upgrade -y
clear

echo -e "\e[1;33m2. Installing dependencies... \e[0m"
sleep 1
# packages
sudo apt update && sudo apt upgrade -y && sudo apt install wget openjdk-8-jdk ccze jq -y
clear
echo -e "\e[1;33m3. Downloading and building binaries... \e[0m"
 sleep 1

# download wallet and decompress
wget http://8.219.130.70:8002/download/ICW_Wallet.tar
tar -xvf ICW_Wallet.tar

# Create systemd
sudo tee /etc/systemd/system/icwd.service > /dev/null <<EOF
[Unit]
Description=icw wallet
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$HOME/ICW_Wallet/./cmd
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# enable systemd
sudo systemctl daemon-reload
sudo systemctl enable icwd
sudo systemctl restart icwd


echo -e '\n\e[1;33m=============== SETUP FINISHED ===================\n\e[0m'
echo -e "\e[1mCheck your logs \e[1;32m journalctl -ocat -fuicwd | ccze -A\e[0m\n"
