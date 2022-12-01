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
STRIDE_PORT=16
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export STRIDE_CHAIN_ID=stride-1" >> $HOME/.bash_profile
echo "export STRIDE_PORT=${STRIDE_PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile

echo '================================================='
echo -e "Your node name: \e[1m\e[32m$NODENAME\e[0m"
echo -e "Your wallet name: \e[1m\e[32m$WALLET\e[0m"
echo -e "Your chain name: \e[1m\e[32m$STRIDE_CHAIN_ID\e[0m"
echo -e "Your port: \e[1m\e[32m$STRIDE_PORT\e[0m"
echo '================================================='
sleep 2

echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Installing dependencies... \e[0m" && sleep 1
# packages
sudo apt install curl build-essential git wget jq make gcc tmux chrony -y

# install go
if ! [ -x "$(command -v go)" ]; then
  ver="1.18.2"
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
git clone https://github.com/Stride-Labs/stride
cd stride && git checkout v3.0.0
make install

sudo cp $HOME/stride/build/strided /usr/local/bin

# config
strided config chain-id $STRIDE_CHAIN_ID
strided config keyring-backend test
strided config node tcp://localhost:${STRIDE_PORT}657

# init
strided init $NODENAME --chain-id $STRIDE_CHAIN_ID

# download genesis and addrbook
wget -qO $HOME/.stride/config/genesis.json "https://raw.githubusercontent.com/Stride-Labs/testnet/infra-test/poolparty/infra/genesis.json"
wget -O $HOME/.stride/config/addrbook.json "https://raw.githubusercontent.com/obajay/nodes-Guides/main/Stride/addrbook.json"

# set peers and seeds
SEEDS=""
PEERS="3a6ea526f5f0857272c79448850abef71653d4df@83.136.249.85:26656,fbc05b4136a15b0b69a2b7f093731453f04ce2f4@192.168.50.57:26656,6795c4cd27d6132a547888ed5b7996aee454a025@172.25.0.2:26656,34c52450d2f107b7c164eb103641df9e45a322d4@65.21.192.108:26656,681803f48d5e9ef9870918e8330551513eccb31c@78.47.51.53:26656,0f2d7f17589e6e31691649ec04fe19561c0d12a6@10.138.0.7:26656,cb0b38aa612e8ac05f704d9b2feb7526607afb77@159.203.191.62:26656,55b446443f2bd68e06200c3f294c735c333722b0@162.251.235.252:26656,68fb634620e00a5a18f606360b6ca6d989da8ce6@65.108.106.131:26656,f56ddd6af02efaac4c47cc8053685d11c1065996@0.0.0.0:26656,f1721dd0324f29c108c1072b2e4fe9c64e63122d@192.168.86.25:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.stride/config/config.toml

# set custom ports
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${STRIDE_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${STRIDE_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${STRIDE_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${STRIDE_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${STRIDE_PORT}660\"%" $HOME/.stride/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${STRIDE_PORT}317\"%; s%^address = \":8080\"%address = \":${STRIDE_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${STRIDE_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${STRIDE_PORT}091\"%" $HOME/.stride/config/app.toml

# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.stride/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.stride/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.stride/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.stride/config/app.toml
sed -i -e "s/^pruning *=.*/pruning = \"nothing\"/" $HOME/.stride/config/app.toml
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.stride/config/config.toml

# set minimum gas price and timeout commit
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ustrd\"/" $HOME/.stride/config/app.toml

# enable prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.stride/config/config.toml

# reset
strided tendermint unsafe-reset-all --home $HOME/.stride

echo -e "\e[1m\e[32m4. Starting service... \e[0m" && sleep 1
# create service
sudo tee /etc/systemd/system/strided.service > /dev/null <<EOF
[Unit]
Description=stride
After=network-online.target

[Service]
User=$USER
ExecStart=$(which strided) start --home $HOME/.stride
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# start service
sudo systemctl daemon-reload
sudo systemctl enable strided
sudo systemctl restart strided

echo '=============== SETUP FINISHED ==================='
echo -e 'To check logs: \e[1m\e[32mjournalctl -u strided -f -o cat\e[0m'
echo -e "To check sync status: \e[1m\e[32mcurl -s localhost:${STRIDE_PORT}657/status | jq .result.sync_info\e[0m"

