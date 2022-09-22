#!/bin/bash

echo -e "\033[0;35m"
echo " ::::    :::  ::::::::  :::::::::  :::::::: ::::     ::::  :::::::::: :::       ::::::::  ::: :::::::::::    ";
echo " :+:+:   :+: :+:    :+: :+:    :+: :+:       :+:     :+:   :+:    :+: :+:      :+:    :+: :+:     :+:        ";
echo " :+:+:+  +:+ +:+    +:+ :+:    :+: +:+        +:+   +:+    :+:    :+: +:+      +:+    +:+ +:+     +:+        ";
echo " +#+ +:+ +#+ +#+    +:+ +#+    +:+ +#++:++#      #+#       +#++:+:+:+ +#+      +#+    +:+ +#+     +#+        ";
echo " +#+  +#+#+# +#+    +#+ +#+    +:+ +#+        +#+   +#+    +#+        +#+      +#+    +#+ +#+     +#+        ";
echo " #+#   #+#+# #+#    #+# #+#    #+# #+#       #+#     #+#   #+#        #+#      #+#    #+# #+#     #+#        ";
echo " ###    ####  ########  #########  ######## ###       ###  ###        ########  ########  ###     ###        ";
echo -e "\e[0m"

sleep 2

echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
#Update
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Installing dependencies... \e[0m"
#Package
sudo apt install curl ncdu htop git wget build-essential libssl-dev gcc make libssl-dev pkg-config npm -y

sleep 1

echo -e "\e[1m\e[32m2. Installing Docker... \e[0m"
#Docker
cd $HOME
apt update && apt purge docker docker-engine docker.io containerd docker-compose -y
rm /usr/bin/docker-compose /usr/local/bin/docker-compose
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

sleep 1

#Docker-compose
curl -SL https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

sleep 1

# NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
source ~/.bashrc
nvm install 16
nvm use 16

#Library
git clone --recurse-submodules https://github.com/Bundlr-Network/validator-rust.git


