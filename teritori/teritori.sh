#!/bin/bash
echo "=========================================="
echo -e "\033[0;35m"
echo "       ::::    :::  ::::::::  :::::::::  :::::::: ::::     ::::  ";
echo "      :+:+:   :+: :+:    :+: :+:    :+: :+:       :+:     :+:    ";
echo "     :+:+:+  +:+ +:+    +:+ +:+    +:+ +:+        +:+   +:+      ";
echo "    +#+ +:+ +#+ +#+    +:+ +#+    +:+ +#++:++#      #+#          ";
echo "   +#+  +#+#+# +#+    +#+ +#+    +#+ +#+        +#+   +#+        ";
echo "  #+#   #+#+# #+#    #+# #+#    #+# #+#       #+#     #+#        ";
echo " ###    ####  ########  #########  ######## ###        ###       ";
echo -e "\e[0m"
echo "==========================================" 

sleep 2

# Setup
TERITORI_WALLET=wallet
TERITORI=teritorid
TERITORI_ID=teritori-testnet-v2
TERITORI_PORT=45
TERITORI_FOLDER=.teritorid
TERITORI_FOLDER2=teritori-chain
TERITORI_VER=teritori-testnet-v2
TERITORI_REPO=https://github.com/TERITORI/teritori-chain
TERITORI_GENESIS=https://raw.githubusercontent.com/TERITORI/teritori-chain/main/testnet/teritori-testnet-v2/genesis.json
TERITORI_ADDRBOOK=
TERITORI_MIN_GAS=0
TERITORI_DENOM=utori
TERITORI_SEEDS=
TERITORI_PEERS=96b55467792a143e0169684f0e8da9a9aeb97af4@23.88.77.188:28656,4eb8b8bed6aecc52dccf21fd1e9432e071659db2@38.242.154.39:36656,986cdc276eea5fcb205ea3c66503c0610f99895d@95.216.140.117:26656,545b1fe982b92aeb9f1eadd05ab0954b38eba402@194.163.177.240:26656,0d19829b0dd1fc324cfde1f7bc15860c896b7ac1@65.108.121.240:27656,34df38933c32ee21078c1d79787d76668f398b9e@89.163.231.30:36656,0248e2989a8a4f6ad87cbe0490c08908a2c2da7f@5.199.133.165:26656,691efb2bee7b585c1f434d934abf18428d0b8ff1@161.97.91.254:26656,cd363d841f4dab90f290aab21c97f8d80a93a028@38.242.154.35:36656,a1c845585abbd8490ecbbcc7f96ff3b027cbed88@38.242.154.40:36656
sleep 1

echo "export TERITORI_WALLET=${TERITORI_WALLET}" >> $HOME/.bash_profile
echo "export TERITORI=${TERITORI}" >> $HOME/.bash_profile
echo "export TERITORI_ID=${TERITORI_ID}" >> $HOME/.bash_profile
echo "export TERITORI_PORT=${TERITORI_PORT}" >> $HOME/.bash_profile
echo "export TERITORI_FOLDER=${TERITORI_FOLDER}" >> $HOME/.bash_profile
echo "export TERITORI_FOLDER2=${TERITORI_FOLDER2}" >> $HOME/.bash_profile
echo "export TERITORI_VER=${TERITORI_VER}" >> $HOME/.bash_profile
echo "export TERITORI_REPO=${TERITORI_REPO}" >> $HOME/.bash_profile
echo "export TERITORI_GENESIS=${TERITORI_GENESIS}" >> $HOME/.bash_profile
echo "export TERITORI_PEERS=${TERITORI_PEERS}" >> $HOME/.bash_profile
echo "export TERITORI_SEED=${TERITORI_SEED}" >> $HOME/.bash_profile
echo "export TERITORI_MIN_GAS=${TERITORI_MIN_GAS}" >> $HOME/.bash_profile
echo "export TERITORI_DENOM=${TERITORI_DENOM}" >> $HOME/.bash_profile
source $HOME/.bash_profile

sleep 1

if [ ! $TERITORI_NODENAME ]; then
	read -p "Your Moniker: " TERITORI_NODENAME
	echo 'export TERITORI_NODENAME='$TERITORI_NODENAME >> $HOME/.bash_profile
fi

echo '====================INFORMATION======================'
echo -e "Your Node Name: \e[1m\e[32m$TERITORI_NODENAME\e[0m"
echo -e "Your Wallet Name: \e[1m\e[32m$TERITORI_WALLET\e[0m"
echo -e "Chain Name: \e[1m\e[32m$TERITORI_ID\e[0m"
echo -e "Your Port: \e[1m\e[32m$TERITORI_PORT\e[0m"
echo '====================INFORMATION======================'

sleep 2


# Update
echo -e "\e[1m\e[32m1. Updating Packages... \e[0m" && sleep 1
sudo apt update && sudo apt upgrade -y


# Setting
echo -e "\e[1m\e[32m2. Installing Dependencies... \e[0m" && sleep 1
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y

# Install Go
echo -e "\e[1m\e[32m1. Install Go... \e[0m" && sleep 1
ver="1.18.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version

sleep 1

# Teritori Repo
echo -e "\e[1m\e[32m1. Updating Teritori... \e[0m" && sleep 1
cd $HOME
git clone $TERITORI_REPO
cd $TERITORI_FOLDER2
git checkout $TERITORI_VER
make install

sleep 1

# Configuration
echo -e "\e[1m\e[32m1. Configuration... \e[0m" && sleep 1
$TERITORI config chain-id $TERITORI_ID
$TERITORI config keyring-backend file
$TERITORI init $TERITORI_NODENAME --chain-id $TERITORI_ID

# Addrbook
wget $TERITORI_GENESIS -O $HOME/$TERITORI_FOLDER/config/genesis.json
wget $TERITORI_ADDRBOOK -O $HOME/$TERITORI_FOLDER/config/addrbook.json

# Seed&Peers
SEEDS="$TERITORI_SEEDS"
PEERS="$TERITORI_PEERS"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/$TERITORI_FOLDER/config/config.toml

sleep 1


# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/$TERITORI_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/$TERITORI_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/$TERITORI_FOLDER/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/$TERITORI_FOLDER/config/app.toml


# ConfigPort
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${TERITORI_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${TERITORI_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${TERITORI_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${TERITORI_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${TERITORI_PORT}660\"%" $HOME/$TERITORI_FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${TERITORI_PORT}317\"%; s%^address = \":8080\"%address = \":${TERITORI_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${TERITORI_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${TERITORI_PORT}091\"%" $HOME/$TERITORI_FOLDER/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:${TERITORI_PORT}657\"%" $HOME/$TERITORI_FOLDER/config/client.toml

# Setting PROMETHEUS 
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/$TERITORI_FOLDER/config/config.toml

# Set Minimum Gas
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.00125$TERITORI_DENOM\"/" $HOME/$TERITORI_FOLDER/config/app.toml

# Indexer
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/$TERITORI_FOLDER/config/config.toml

# Reset Node
$TERITORI tendermint unsafe-reset-all --home $HOME/$TERITORI_FOLDER

echo -e "\e[1m\e[32m4. Create Service... \e[0m" && sleep 1
# create service
sudo tee /etc/systemd/system/$TERITORI.service > /dev/null <<EOF
[Unit]
Description=$TERITORI
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which $TERITORI) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF


# Restart System
sudo systemctl daemon-reload
sudo systemctl enable $TERITORI
sudo systemctl restart $TERITORI

echo '=============== CONGRATS! SETUP FINISED ==================='
echo -e 'To Check Your Logs: \e[1m\e[32mjournalctl -f $TERITORI\e[0m'
echo -e "To Check Sync: \e[1m\e[32mcurl -s localhost:${TERITORI_PORT}657/status | jq .result.sync_info\e[0m"

source $HOME/.bash_profile
