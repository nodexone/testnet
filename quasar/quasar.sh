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
echo ">>> Cosmovisor Automatic Installer for Quasar | Chain ID : qsr-questnet-04  <<<";
echo -e "\e[0m"

sleep 1

# Variable
WALLET=wallet
BINARY=quasard
CHAIN=qsr-questnet-04 
FOLDER=.quasarnode
VERSION=0.0.2-alpha-11
DENOM=uqsr
BIN_REPO=https://github.com/quasar-finance/binary-release/raw/main/v0.0.2-alpha-11/quasarnoded-linux-amd64
COSMOVISOR=cosmovisor
GENESIS=https://snapshots.kjnodes.com/quasar-testnet/genesis.json
ADDRBOOK=https://snapshots.kjnodes.com/quasar-testnet/addrbook.json
PORT=53

echo "export WALLET=${WALLET}" >> $HOME/.bash_profile
echo "export BINARY=${BINARY}" >> $HOME/.bash_profile
echo "export DENOM=${DENOM}" >> $HOME/.bash_profile
echo "export CHAIN=${CHAIN}" >> $HOME/.bash_profile
echo "export FOLDER=${FOLDER}" >> $HOME/.bash_profile
echo "export VERSION=${VERSION}" >> $HOME/.bash_profile
echo "export BIN_REPO=${BIN_REPO}" >> $HOME/.bash_profile
echo "export COSMOVISOR=${COSMOVISOR}" >> $HOME/.bash_profile
echo "export REPO=${REPO}" >> $HOME/.bash_profile
echo "export GENESIS=${GENESIS}" >> $HOME/.bash_profile
echo "export ADDRBOOK=${ADDRBOOK}" >> $HOME/.bash_profile
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
#rm -rf $SOURCE
#git clone $REPO
#cd $SOURCE
#git checkout $VERSION
#make build
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0

# Prepare binaries for Cosmovisor
mkdir -p $HOME/$FOLDER/$COSMOVISOR/genesis/bin
wget -O $HOME/$FOLDER/$COSMOVISOR/genesis/bin/$BINARY $BIN_REPO
chmod +x $HOME/$FOLDER/cosmovisor/genesis/bin/*

# Create application symlinks
ln -s $HOME/$FOLDER/$COSMOVISOR/genesis $HOME/$FOLDER/$COSMOVISOR/current
sudo ln -s $HOME/$FOLDER/$COSMOVISOR/current/bin/$BINARY /usr/local/bin/$BINARY

# Init generation
$BINARY config chain-id $CHAIN
$BINARY config keyring-backend test
$BINARY config node tcp://localhost:${PORT}657
$BINARY init $NODENAME --chain-id $CHAIN

# Set peers and seeds
peers="d9f8b98c0de96320b16cc696eb5adbc54b4da84c@154.38.161.212:29656,875763b4e1c4f5c2cd9395bf45c4c63eae9aea0f@213.239.217.52:43656,7ba6ff4db4685f5196590825ca5f1a131886811d@213.202.222.182:29656,4287c77d9807c53a90853c463891daecf8b1cec1@65.109.57.221:27656,1608ddec15a0b46785bf864b8b9666c0421ad55f@65.21.170.3:30656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:48656,503bab8685d4219b76b3a487f3c74cc5dbeeeb94@212.23.222.220:26556,45848bc173bddbf7c685938dfada535ee5a1895b@65.109.23.114:18256,b2f0b655bcbec1dc0d2bf593d227d4c2e65441c9@38.242.230.118:14656,1c1043ae487c91209fce8c589a5772a7f3846e7c@136.243.88.91:8080,c944ff2c220d8f30a399cae9580dce8319ebf052@95.217.236.79:38656,a83250aa10bba0b2898a1806cdbe27e658e1ba54@95.217.216.88:38656,8937bdacf1f0c8b2d1ffb4606554eaf08bd55df4@5.75.255.107:26656,41ee7632f310c035235828ce03c208dbe1e24d7d@38.146.3.204:18256,eeb4f094eaa62841b4a9a73f0560d6aa1fa87482@65.108.231.124:29656,70addf3b7b4d749ca66f5d6e58c7084dd0e3dee8@47.147.226.228:56656,5b7f8cc1a8fd8c5bc7331b26872fceb2811325ee@65.109.89.5:37656,1112acc7479a8a1afb0777b0b9a39fb1f7e77abd@34.175.69.87:26656,c7c43689fe3a74d14d8159f80d070c763cbc5a81@96.234.160.22:26656,a03b3f70544b32d69f322850ad2d0047973b7358@65.109.92.240:17586,de7e1a830178b127c7f598f8d7fa44900a448dd8@65.108.3.234:38656,9ad3b058f1dd84a87102ada4471343dea4f40ed6@188.34.178.184:48656,4af94fb30d0ce753e0b7733dcd410e37ebdb2ff9@185.209.31.45:26656,fa76aa585cbe520508edb02ec627667128bf928c@65.109.117.23:48656,d0fbe3a97ca99cbc83978aa3940838ec380bb536@154.26.130.167:38656,c6eb23c2e00e13b800795e9a6acc090744a25218@65.108.13.185:27363,1cabd0846030da442b347bb17fe02860796d253f@49.12.123.97:16656,7ef67269c8ec37ff8a538a5ae83ca670fd2da686@144.126.135.137:36656,1c27b299a87c48d995850b4c2e0fd44784bbe607@185.144.99.32:26656,ef07672d05fa2c5c180fdc4d91828a1600025df2@88.198.34.195:26656,3c8afd3c39b7ab28cdb801e45ea4d9249a51e22b@88.99.161.162:20656,966acc999443bae0857604a9fce426b5e09a7409@65.108.105.48:18256,ffbdfbd451d35af7a557eee36829244096b66911@65.108.141.109:37656,b35f3493df8c3be232fe75ef7f4d0cb9d0f59668@65.109.70.23:18256,de6aa5fb331bd8d16acdf5b1d4cae9d1eb6753d7@142.132.248.253:10556,1e0b25de6a634b693d1812584880882f43648dae@95.217.211.81:38656,4ad7ce03e53f0edb2a1debb2d69ff754a0cbb029@142.132.158.158:23656,f36a9ff85a9f956f345e47c8ce364fc1fcf52d7e@65.108.111.236:55746,136589c157a21094c976f67bcb76bc6327c58b93@65.108.97.58:2686,a23f002bda10cb90fa441a9f2435802b35164441@38.146.3.203:18256,7024c82e744c3ca0f331270f3b4dea6cdae4b770@138.201.248.108:45656,44522b08f3b2a2048ef88a47bfadde39647b47fe@95.214.53.187:46656,73cdc5d46ec444a5ea78caf69628995bcd769380@65.109.87.88:26616,08e7f2b6dcb630cb53b907018d7e9916922ecb21@137.184.160.32:2686,596474521decfc6894f6632d8aa87663c1b4104c@213.239.215.165:45656,3f8a9c71fa1a6008e8b5e10ef949e921f92cefba@185.219.142.32:05656,5066dbc8df3696b9ffa8d92a80a7acbbccfa7c17@165.22.111.218:53656,82ab69d8c046c7eb34532c43d2b31b8d11e99880@144.76.30.36:15661,ead98bd83daf1c4a68b3b78a3c3cd28d0637ddcd@178.128.85.30:53656,fdc1babb7ad4d97a911d32b0545220c8ceca57a8@128.199.8.206:53656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/$FOLDER/config/config.toml
SEEDS="3f472746f46493309650e5a033076689996c8881@quasar-testnet.rpc.kjnodes.com:48659"
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
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025$DENOM\"/" $HOME/$FOLDER/config/app.toml

# Enable snapshots
sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = \"2000\"/" $HOME/$FOLDER/config/app.toml
$BINARY tendermint unsafe-reset-all --home $HOME/$FOLDER --keep-addr-book
curl -L https://snapshots.kjnodes.com/quasar-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/$FOLDER

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