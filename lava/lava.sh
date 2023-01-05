# // Copyright (C) 2023 sxlmnwb Recoded By NodeX Capital

echo -e "\033[0;31m"
echo "\e[36mWebsite:\e[39m https://nodexcapital.com/";
echo "\e[36mGithub:\e[39m  https://github.com/nodexcapital";
echo "\e[36mDiscord:\e[39m https://discord.gg/nodexcapital";
echo "     Auto Installer Lava | Chain ID : lava-testnet-1      ";
echo -e "\e[0m"
sleep 1
echo -e "\e[1m\e[32m1. Setting Variable... \e[0m" && sleep 1
# Variable
LAVA_WALLET=wallet
LAVA_BINARY=lavad
LAVA_CHAIN_ID=lava-testnet-1
LAVA_FOLDER=.lava
LAVA_REPO=https://github.com/K433QLtr6RA9ExEq/GHFkqmTzpdNLDd6T.git
LAVA_BIN=https://lava-binary-upgrades.s3.amazonaws.com/testnet/v0.3.0/lavad
LAVA_GENESIS=https://snapshots.nodeist.net/t/lava/genesis.json
LAVA_ADDRBOOK=https://snapshots.nodeist.net/t/lava/addrbook.json
LAVA_DENOM=ulava
LAVA_PORT=37
sleep 1
echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
echo "export LAVA_WALLET=${LAVA_WALLET}" >> $HOME/.bash_profile
echo "export LAVA_BINARY=${LAVA_BINARY}" >> $HOME/.bash_profile
echo "export LAVA_CHAIN_ID=${LAVA_CHAIN_ID}" >> $HOME/.bash_profile
echo "export LAVA_FOLDER=${LAVA_FOLDER}" >> $HOME/.bash_profile
echo "export LAVA_REPO=${LAVA_REPO}" >> $HOME/.bash_profile
echo "export LAVA_BIN=${LAVA_BIN}" >> $HOME/.bash_profile
echo "export LAVA_GENESIS=${LAVA_GENESIS}" >> $HOME/.bash_profile
echo "export LAVA_ADDRBOOK=${LAVA_ADDRBOOK}" >> $HOME/.bash_profile
echo "export LAVA_DENOM=${LAVA_DENOM}" >> $HOME/.bash_profile
echo "export LAVA_PORT=${LAVA_PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile
sleep 1
echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# Set Vars
if [ ! $LAVA_NODENAME ]; then
        read -p "hello@nodexcapital:~# [ENTER YOUR NODENAME] > " NODENAME
        echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi
echo ""
echo -e "YOUR NODE NAME : \e[1m\e[31m$NODENAME\e[0m"
echo -e "NODE CHAIN ID  : \e[1m\e[31m$LAVA_CHAIN_ID\e[0m"
echo -e "NODE PORT      : \e[1m\e[31m$LAVA_PORT\e[0m"
echo ""
sleep 1
echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# Update
sudo apt update && sudo apt upgrade -y
sleep 1
echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# Package
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
sleep 1
echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# Install GO
ver="1.19.3"
cd $HOME
rm -rf go
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
sleep 1
echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# Get testnet version of LAVA
cd $HOME
git clone $LAVA_REPO
wget $LAVA_BIN
chmod +x $LAVA_BINARY
mv $LAVA_BINARY $HOME/go/bin/
echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# Init generation
$LAVA_BINARY config chain-id $LAVA_CHAIN_ID
$LAVA_BINARY config keyring-backend test
$LAVA_BINARY config node tcp://localhost:${LAVA_PORT}657
$LAVA_BINARY init $NODENAME --chain-id $LAVA_CHAIN_ID
sleep 1
echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# Download genesis and addrbook
curl -Ls $LAVA_GENESIS > $HOME/$LAVA_FOLDER/config/genesis.json
curl -Ls $LAVA_ADDRBOOK > $HOME/$LAVA_FOLDER/config/addrbook.json
sleep 1
echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# Add seeds,gas-prices & peers
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ulava\"/" $HOME/$LAVA_FOLDER/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/$LAVA_FOLDER/config/config.toml
external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/$LAVA_FOLDER/config/config.toml
peers="3a445bfdbe2d0c8ee82461633aa3af31bc2b4dc0@prod-pnet-seed-node.lavanet.xyz:26656,e593c7a9ca61f5616119d6beb5bd8ef5dd28d62d@prod-pnet-seed-node2.lavanet.xyz:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/$LAVA_FOLDER/config/config.toml
seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/$LAVA_FOLDER/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 50/g' $HOME/$LAVA_FOLDER/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 50/g' $HOME/$LAVA_FOLDER/config/config.toml
sleep 1
echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# Set Port
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${LAVA_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${LAVA_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${LAVA_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${LAVA_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${LAVA_PORT}660\"%" $HOME/$LAVA_FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${LAVA_PORT}317\"%; s%^address = \":8080\"%address = \":${LAVA_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${LAVA_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${LAVA_PORT}091\"%" $HOME/$LAVA_FOLDER/config/app.toml
sleep 1
echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# Set Config Pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/$LAVA_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/$LAVA_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/$LAVA_FOLDER/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/$LAVA_FOLDER/config/app.toml
sleep 1
echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# Set indexer
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/$LAVA_FOLDER/config/config.toml
sleep 1
echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# Create Service
sudo tee /etc/systemd/system/$LAVA_BINARY.service > /dev/null <<EOF
[Unit]
Description=$LAVA_BINARY
After=network-online.target

[Service]
User=$USER
ExecStart=$(which $LAVA_BINARY) start --home $HOME/$LAVA_FOLDER
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF
sleep 1
echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# Register And Start Service
sudo systemctl daemon-reload
sudo systemctl enable $LAVA_BINARY
sudo systemctl start $LAVA_BINARY
sleep 1
echo -e "\e[1m\e[31mSETUP FINISHED\e[0m"
echo ""
echo -e "CHECK RUNNING LOGS : \e[1m\e[31mjournalctl -fu $LAVA_BINARY -o cat\e[0m"
echo -e "CHECK LOCAL STATUS : \e[1m\e[31mcurl -s localhost:${LAVA_PORT}657/status | jq .result.sync_info\e[0m"
echo ""