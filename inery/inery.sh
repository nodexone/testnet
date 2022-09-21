#!/bin/bash

echo -e "\033[0;35m"
echo " ::::    :::  ::::::::  :::::::::  :::::::: ::::     ::::     ::::::::        ::        :::::::::  ::: :::::::::::    ::        :::          ";
echo " :+:+:   :+: :+:    :+: :+:    :+: :+:       :+:     :+:     :+:            :+::+:      :+:    :+: :+:     :+:      :+::+:      :+:          ";
echo " :+:+:+  +:+ +:+    +:+ :+:    :+: +:+        +:+   +:+      +:+           +:+  +:+     :+:    :+: +:+     +:+     +:+  +:+     :+:          ";
echo " +#+ +:+ +#+ +#+    +:+ +#+    +:+ +#++:++#      #+#         +#+          +#+    +#+    +#++:+:+:+ +#+     +#+    +#+    +#+    +#+          ";
echo " +#+  +#+#+# +#+    +#+ +#+    +:+ +#+        +#+   +#+      +#+         +#+#:+:#:+#+   +#+        +#+     +#+   +#+#:+:#:+#+   +#+          ";
echo " #+#   #+#+# #+#    #+# #+#    #+# #+#       #+#     #+#     #+#        #+#        #+#  #+#        #+#     #+#  #+#        #+#  #+#          ";
echo " ###    ####  ########  #########  ######## ###       ###     ######## ###          ### ###        ###     ### ###          ### ##########   ";
echo -e "\e[0m"

sleep 2

echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# Install all apps and tools needed
sudo apt-get update && sudo apt install git && sudo apt install screen

sudo apt-get install -y make bzip2 automake libbz2-dev libssl-dev doxygen graphviz libgmp3-dev \
autotools-dev libicu-dev python2.7 python2.7-dev python3 python3-dev \
autoconf libtool curl zlib1g-dev sudo ruby libusb-1.0-0-dev \
libcurl4-gnutls-dev pkg-config patch llvm-7-dev clang-7 vim-common jq libncurses5

echo -e "\e[1m\e[32m1. Opening Port... \e[0m" && sleep 1
# Open Port (firewalld)
sudo apt-get install firewalld
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --set-default-zone=public
sudo firewall-cmd --zone=public --add-port=22/tcp --permanent
sudo firewall-cmd --zone=public --add-port=8888/tcp --permanent
sudo firewall-cmd --zone=public --add-port=9010/tcp --permanent
sudo firewall-cmd --reload
sudo systemctl restart firewalld

echo -e "\e[1m\e[32m1. Installing Node... \e[0m" && sleep 1
# Installing Nodes
git clone https://github.com/inery-blockchain/inery-node
cd inery-node/inery.setup
chmod +x ine.py
./ine.py --export
cd; source .bashrc; cd -

echo '=============== SETUP FINISHED ==================='