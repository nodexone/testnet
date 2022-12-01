#!/bin/bash

echo -e "\033[0;31m"
echo " ::::    :::  ::::::::  :::::::::  :::::::: ::::     ::::   ::::::::       ::::       :::::::::  ::: :::::::::::    ::::       :::        ";
echo " :+:+:   :+: :+:    :+: :+:    :+: :+:       :+:     :+:   :+:            :+::+:      :+:    :+: :+:     :+:       :+::+:      :+:        ";
echo " :+:+:+  +:+ +:+    +:+ :+:    :+: +:+        +:+   +:+    :+:           +:+  +:+     +:+    +:+ +:+     +:+      +:+  +:+     +:+        ";
echo " +#+ +:+ +#+ +#+    +:+ +#+    +:+ +#++:++#      #+#       +#+          +#+    +#+    +#+ +: +#  +#+     +#+     +#+    +#+    +#+        ";
echo " +#+  +#+#+# +#+    +#+ +#+    +:+ +#+        +#+   +#+    +#+         +#+ :+:+ +#+   +#+        +#+     +#+    +#+ :+:+ +#+   +#+        ";
echo " #+#   #+#+# #+#    #+# #+#    #+# #+#       #+#     #+#   #+#        #+#        #+#  #+#        #+#     #+#   #+#        #+#  #+#        ";
echo " ###    ####  ########  #########  ######## ###       ###   ######## ###          ### ###        ###     ###  ###          ### #########  ";
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
echo "export MANDE_CHAIN_ID=mande-testnet-1" >> $HOME/.bash_profile
source $HOME/.bash_profile

echo '================================================='
echo -e "Your node name: \e[1m\e[32m$NODENAME\e[0m"
echo -e "Your wallet name: \e[1m\e[32m$WALLET\e[0m"
echo -e "Your chain name: \e[1m\e[32m$MANDE_CHAIN_ID\e[0m"
echo '================================================='
sleep 2

echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Installing dependencies... \e[0m" && sleep 1
# packages
sudo apt install curl tar wget tmux htop net-tools clang pkg-config libssl-dev jq build-essential git make ncdu -y

# install go
ver="1.19" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile && \
go version

echo -e "\e[1m\e[32m3. Downloading and building binaries... \e[0m" && sleep 1
# download binary
cd $HOME
curl -OL https://github.com/mande-labs/testnet-1/raw/main/mande-chaind
mv mande-chaind /usr/local/bin
chmod 744 /usr/local/bin/mande-chaind

# config
mande-chaind init $MANDE_CHAIN_ID
mande-chaind config keyring-backend test

# init
mande-chaind init $NODENAME --chain-id $MANDE_CHAIN_ID

# download genesis and addrbook
wget -O $HOME/.mande-chain/config/genesis.json "https://raw.githubusercontent.com/mande-labs/testnet-1/main/genesis.json"
wget -O $HOME/.mande-chain/config/addrbook.json "https://raw.githubusercontent.com/obajay/nodes-Guides/main/Mande%20Chain/addrbook.json"

# set peers and seeds
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0mand\"/;" ~/.mande-chain/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.mande-chain/config/config.toml
peers="cd3e4f5b7f5680bbd86a96b38bc122aa46668399@34.171.132.212:26656,6780b2648bd2eb6adca2ca92a03a25b216d4f36b@34.170.16.69:26656,a3e3e20528604b26b792055be84e3fd4de70533b@38.242.199.93:24656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.mande-chain/config/config.toml
seeds="cd3e4f5b7f5680bbd86a96b38bc122aa46668399@34.171.132.212:26656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.mande-chain/config/config.toml


# disable indexing
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.mande-chain/config/config.toml

# config pruning
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" ~/.mande-chain/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" ~/.mande-chain/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" ~/.mande-chain/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" ~/.mande-chain/config/app.toml


echo -e "\e[1m\e[32m4. Starting service... \e[0m" && sleep 1
# create service
sudo tee /etc/systemd/system/mande-chaind.service > /dev/null <<EOF
[Unit]
Description=mande-chaind
After=network-online.target

[Service]
User=$USER
ExecStart=$(which mande-chaind) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF


# start service
sudo systemctl daemon-reload
sudo systemctl enable mande-chaind
sudo systemctl restart mande-chaind

echo '=============== SETUP FINISHED ==================='
echo -e 'To check logs: \e[1m\e[32msudo journalctl -u mande-chaind -f -o cat\e[0m'
echo -e "To check sync status: \e[1m\e[35mmande-chaind status 2>&1 | jq .SyncInfo\e[0m"