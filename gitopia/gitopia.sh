#
# // Copyright (C) 2023 Salman Wahib Recoded By NodeX Capital
#

echo -e "\033[0;35m"
echo " ███╗   ██╗ ██████╗ ██████╗ ███████╗██╗  ██╗     ██████╗ █████╗ ██████╗ ██╗████████╗ █████╗ ██╗     ";
echo " ████╗  ██║██╔═══██╗██╔══██╗██╔════╝╚██╗██╔╝    ██╔════╝██╔══██╗██╔══██╗██║╚══██╔══╝██╔══██╗██║     ";
echo " ██╔██╗ ██║██║   ██║██║  ██║█████╗   ╚███╔╝     ██║     ███████║██████╔╝██║   ██║   ███████║██║     ";
echo " ██║╚██╗██║██║   ██║██║  ██║██╔══╝   ██╔██╗     ██║     ██╔══██║██╔═══╝ ██║   ██║   ██╔══██║██║     ";
echo " ██║ ╚████║╚██████╔╝██████╔╝███████╗██╔╝ ██╗    ╚██████╗██║  ██║██║     ██║   ██║   ██║  ██║███████╗";
echo " ╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝     ╚═════╝╚═╝  ╚═╝╚═╝     ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝";
echo ">>> Cosmovisor Automatic Installer for Gitopiad | Chain ID : gitopia-janus-testnet-2  <<<";
echo -e "\e[0m"

sleep 1

# Variable
SOURCE=gitopia
WALLET=wallet
BINARY=gitopiad 
CHAIN=gitopia-janus-testnet-2
FOLDER=.gitopia
VERSION=v1.2.0
DENOM=utlore
COSMOVISOR=cosmovisor
BASH=https://get.gitopia.com
REPO=gitopia://Gitopia/gitopia
GENESIS=https://snapshots.nodeist.net/t/gitopia/genesis.json
ADDRBOOK=https://snapshots-testnet.nodejumper.io/gitopia-testnet/addrbook.json
PORT=37

echo "export SOURCE=${SOURCE}" >> $HOME/.bash_profile
echo "export WALLET=${WALLET}" >> $HOME/.bash_profile
echo "export BINARY=${BINARY}" >> $HOME/.bash_profile
echo "export DENOM=${DENOM}" >> $HOME/.bash_profile
echo "export CHAIN=${CHAIN}" >> $HOME/.bash_profile
echo "export FOLDER=${FOLDER}" >> $HOME/.bash_profile
echo "export VERSION=${VERSION}" >> $HOME/.bash_profile
echo "export COSMOVISOR=${COSMOVISOR}" >> $HOME/.bash_profile
echo "export REPO=${REPO}" >> $HOME/.bash_profile
echo "export GENESIS=${GENESIS}" >> $HOME/.bash_profile
echo "export ADDRBOOK=${ADDRBOOK}" >> $HOME/.bash_profile
echo "export BASH=${BASH}" >> $HOME/.bash_profile
echo "export PORT=${PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile

# Set Vars
if [ ! $NODENAME ]; then
        read -p "hello@nodexcapital:~# [ENTER YOUR NODENAME] > " NODENAME
        echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi
echo ""
echo -e "YOUR NODE NAME : \e[1m\e[35m$NODENAME\e[0m"
echo -e "NODE CHAIN ID  : \e[1m\e[35m$CHAIN\e[0m"
echo -e "NODE PORT      : \e[1m\e[35m$PORT\e[0m"
echo ""

# Package
sudo apt -q update
sudo apt -qy install curl git jq lz4 build-essential
sudo apt -qy upgrade

# Install GO
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.19.5.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)

# Get testnet version of LAVA
cd $HOME
curl $BASH | bash
cd || return
rm -rf $SOURCE
git clone $REPO
cd $SOURCE || return
git checkout $VERSION
make build
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0

# Prepare binaries for Cosmovisor
mkdir -p $HOME/$FOLDER/$COSMOVISOR/genesis/bin
mv build/$BINARY $HOME/$FOLDER/$COSMOVISOR/genesis/bin/
rm -rf build

# Create application symlinks
ln -s $HOME/$FOLDER/$COSMOVISOR/genesis $HOME/$FOLDER/$COSMOVISOR/current
sudo ln -s $HOME/$FOLDER/$COSMOVISOR/current/bin/$BINARY /usr/local/bin/$BINARY

# Init generation
$BINARY config chain-id $CHAIN
$BINARY config keyring-backend test
$BINARY config node tcp://localhost:${PORT}657
$BINARY init $NODENAME --chain-id $CHAIN

# Set peers and seeds
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/$FOLDER/config/config.toml
external_address=$(wget -qO- eth0.me)
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/$FOLDER/config/config.toml
PEERS="6146658ffe2d148524a9fdcc3d701440053442bf@gitopia-testnet.nodejumper.io:30656,b745e0c6a1e0c7ec248ec274cfd038ed4bc4c2cf@65.21.134.202:26356,0c31077af45cb4f0424e58c91b0a917c36a90fd9@65.108.195.235:16656,f06f794dcc5964197da0e13709d71ea5e0f5b7f1@88.99.3.158:11156,5c45e8920c5094827ec5afaca9ab469aaa0b4eaf@65.109.88.254:28656,f9b892ea2e8ed8aa83f7b98e7e47371c23b01924@213.239.207.175:36656,7182dfadba43a9a3b35f6862e63f75be20c8b1db@95.217.214.125:41656,9cd6d2477d278ef6ccffa5cc4e22fd0d9489cd23@85.10.199.157:34656,d9d59b442e46f142394fcdf2f246ca8c7b2b7ce9@149.102.146.36:26656,e1ab0573d55ff92fad55d2929e353904f1bbe36f@135.181.16.252:31656,481189b7e246f6c824a969482446c49abbfe76b8@161.97.172.147:26656,3b0956b482f89b361dd350f1c6b3743096897446@65.108.124.219:35656,0534e64a6df8a0ac7d032d3eff3587f5fd69ba37@65.108.206.118:60756,35c829910f80387ee825da9fb69efbcbf8e2149e@164.68.118.227:26656,df5b61e51ab2f6c3bf1f3c387ba1586a84b41b25@141.95.65.26:27956,3b7845f8c8361c2f2de742473cd891c6e8cdeabf@83.171.249.159:656,4e4f87cfa1993f4f3f7645c41f469987cafdf960@85.10.202.135:12656,ea53a3f77fe373f47be4e77fd5f9ff526dfaec33@51.79.143.46:41656,a6f4fd8efe8a575a15e25652ecebce3fa1ed62a0@213.239.217.52:35656,c2beb74ebaf76137702732f6076c9a319bf15262@159.69.72.247:41656,63381c5528ed8ca93f9ba31008a9630d21b29a97@142.132.152.46:46656,3e5ba61e8481c6c71d3f2cc022dd6671ed7cacf8@65.21.170.3:41656,5c58d5c43b0a93a28da0cd528af7921567a43921@146.190.34.12:41656,95fbdc6d62be17db6688222b15b57d3e795ed07a@167.86.84.102:656,1f0f03a1c845e810e5cfeb0d960639c637d049fe@154.26.131.130:36656,53b421af01f3260e949d6a9c2dc09e3b1dbf9fb6@109.205.181.30:41656,f1a47d469460fb0a70b12d7739afbc0bf78eadda@78.47.195.69:656,4e0e57bcac8aa2bc3188d5b7845eeee61a61f3f0@194.163.170.165:26656,61d2b313e2adc9d7990944f8ab5a6f9ecf08084f@65.21.122.171:16656,f1c042fca05e4bfb9a6da1cccaa5108a26ea1e0f@65.108.104.167:28656,5f4aee494e44d65f31753d7122f074f27b3ed8a2@95.216.162.25:656,ed9e3ea0d633fa27690f5d4db039403bbb1aeba8@165.22.214.209:26656,61c85d47e1dd86d5a5849450b849078d4d13184b@85.239.244.123:26656,6871aeacd353d66c38b1ebbf3b1ad244fa05e32b@167.86.84.125:26656,c19da021d6bbdeccdd03453a021d7171e6e299d5@173.249.14.30:656,ee812a11525cf7e2de4bd63e66aed8b8de337902@38.242.235.199:41656"
sed -i 's|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/$FOLDER/config/config.toml
SEEDS="6146658ffe2d148524a9fdcc3d701440053442bf@gitopia-testnet.nodejumper.io:30656"
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/$FOLDER/config/config.toml

# Download genesis and addrbook
curl -Ls $GENESIS > $HOME/$FOLDER/config/genesis.json
curl -Ls $ADDRBOOK > $HOME/$FOLDER/config/addrbook.json

# Set Port
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/$FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%" $HOME/$FOLDER/config/app.toml

# Set Config Pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/$FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/$FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/$FOLDER/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/$FOLDER/config/app.toml

# Set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0$DENOM\"/" $HOME/$FOLDER/config/app.toml

# Enable snapshots
 sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = \"2000\"/" $HOME/$FOLDER/config/app.toml
 $BINARY tendermint unsafe-reset-all --home $HOME/$FOLDER --keep-addr-book
 SNAP_NAME=$(curl -s https://snapshots-testnet.nodejumper.io/gitopia-testnet/ | egrep -o ">gitopia-janus-testnet-2_.*\.tar.lz4" | tr -d ">")
 curl https://snapshots-testnet.nodejumper.io/gitopia-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/$FOLDER

# Create Service
sudo tee /etc/systemd/system/$BINARY.service > /dev/null << EOF
[Unit]
Description=$BINARY
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/$FOLDER"
Environment="DAEMON_NAME=$BINARY"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
EOF

# Register And Start Service
sudo systemctl start $BINARY
sudo systemctl daemon-reload
sudo systemctl enable $BINARY

echo -e "\e[1m\e[35mSETUP FINISHED\e[0m"
echo ""
echo -e "CHECK STATUS BINARY : \e[1m\e[35msystemctl status $BINARY\e[0m"
echo -e "CHECK RUNNING LOGS : \e[1m\e[35mjournalctl -fu $BINARY -o cat\e[0m"
echo -e "CHECK LOCAL STATUS : \e[1m\e[35mcurl -s localhost:${PORT}657/status | jq .result.sync_info\e[0m"
echo ""

# End