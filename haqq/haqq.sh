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
if [ ! $NODENAME ]; then
	read -p "Enter node name: " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export HAQQ_CHAIN_ID=haqq_53211-1" >> $HOME/.bash_profile
source $HOME/.bash_profile

echo '================================================='
echo -e "Moniker: \e[1m\e[32m$NODENAME\e[0m"
echo -e "Wallet Name: \e[1m\e[32m$WALLET\e[0m"
  echo -e "Chain Name: \e[1m\e[32m$HAQQ_CHAIN_ID\e[0m"
echo '================================================='
sleep 2

echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Installing dependencies... \e[0m" && sleep 1
# packages
sudo apt install curl tar wget clang pkg-config libssl-dev libleveldb-dev jq build-essential bsdmainutils git make ncdu htop screen unzip bc fail2ban htop -y

# install go
if ! [ -x "$(command -v go)" ]; then
  ver="1.18.3"
  cd $HOME
  wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
  rm "go$ver.linux-amd64.tar.gz"
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
  source ~/.bash_profile
fi

echo -e "\e[1m\e[32m3. Downloading and building binaries... \e[0m" && sleep 1
# download binary
cd $HOME
git clone -b v1.0.3 https://github.com/haqq-network/haqq && \
cd haqq && \
make install

# config
haqqd config chain-id $HAQQ_CHAIN_ID
haqqd config keyring-backend file

# init
haqqd init $NODENAME --chain-id $HAQQ_CHAIN_ID

# download genesis and addrbook
curl -OL https://storage.googleapis.com/haqq-testedge-snapshots/genesis.json
mv genesis.json $HOME/.haqqd/config/genesis.json
wget -O $HOME/.haqqd/config/addrbook.json "https://raw.githubusercontent.com/obajay/nodes-Guides/main/haqq/addrbook.json"

# set peers and seeds
seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.haqqd/config/config.toml
peers="e15e1867f68011f80f2763e6691c89c923bf2f24@78.46.16.236:41656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.haqqd/config/config.toml

sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0stake\"/;" ~/.haqqd/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.haqqd/config/config.toml
external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.haqqd/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 100/g' $HOME/.haqqd/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 100/g' $HOME/.haqqd/config/config.toml

# config pruning and indexer
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.haqqd/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.haqqd/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.haqqd/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.haqqd/config/app.toml
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.haqqd/config/config.toml

echo -e "\e[1m\e[32m4. Starting service... \e[0m" && sleep 1
# create service
sudo tee /etc/systemd/system/haqqd.service > /dev/null <<EOF
[Unit]
Description=haqqd
After=network-online.target

[Service]
User=$USER
ExecStart=$(which haqqd) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# start service
sudo systemctl daemon-reload
sudo systemctl enable haqqd
sudo systemctl restart haqqd

echo '=============== CONGRATZ! SETUP FINISHED ==================='
echo -e 'To check logs: \e[1m\e[32mjournalctl -u haqqd -f -o cat\e[0m'
