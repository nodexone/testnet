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
GENESIS=https://snapshots.polkachu.com/testnet-genesis/quasar/genesis.json
ADDRBOOK=https://snapshots.polkachu.com/testnet-addrbook/quasar/addrbook.json
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
PEERS=1cabd0846030da442b347bb17fe02860796d253f@49.12.123.97:16656,a23f002bda10cb90fa441a9f2435802b35164441@38.146.3.203:18256,bffb10a5619be7bfa98919e08f4a6bef4f8f6bf0@135.181.210.186:26656,8937bdacf1f0c8b2d1ffb4606554eaf08bd55df4@5.75.255.107:26656,7ba6ff4db4685f5196590825ca5f1a131886811d@213.202.222.182:29656,bcb8d2b5d5464cddbab9ce2705aae3ad3e38aeac@144.76.67.53:2490,41ee7632f310c035235828ce03c208dbe1e24d7d@38.146.3.204:18256,bba6e85e3d1f1d9c127324e71a982ddd86af9a99@88.99.3.158:18256,4ad7ce03e53f0edb2a1debb2d69ff754a0cbb029@142.132.158.158:23656,1c1043ae487c91209fce8c589a5772a7f3846e7c@136.243.88.91:8080,966acc999443bae0857604a9fce426b5e09a7409@65.108.105.48:18256,177144bed1e280a6f2435d253441e3e4f1699c6d@65.109.85.226:8090,817125f8b186fb465bef146b80e8e17b992307aa@178.239.197.178:26656,8a19aa6e874ed5720aad2e7d02567ec932d92d22@84.201.134.16:26656,3a23a31e1b57f1d631edb7e9b397fe80551cc899@15.235.49.9:26656,7ef67269c8ec37ff8a538a5ae83ca670fd2da686@144.126.135.137:36656,875763b4e1c4f5c2cd9395bf45c4c63eae9aea0f@213.239.217.52:43656,6b758da69ab6f37697ad6857094eb1ead8fb3131@65.109.61.116:28656,99a0695a7358fa520e6fcd46f91492f7cf205d4d@34.175.159.249:26656,47401f4ac3f934afad079ddbe4733e66b58b67da@34.175.244.202:26656,ee199119f12e85dfcf38183d5082890c1145aae6@65.108.66.34:43656,a03b3f70544b32d69f322850ad2d0047973b7358@65.109.92.240:17586,bf7547ac440b049f7f17db65ab2c54befb9182cc@65.108.238.61:14656,695b9dc49a979e4c5986c5ae9a6effc8bc8597f0@185.197.250.151:27656,1112acc7479a8a1afb0777b0b9a39fb1f7e77abd@34.175.69.87:26656,68978b7482fc525ce40b4e7db1a9404e1909446f@65.109.85.221:8090,b35f3493df8c3be232fe75ef7f4d0cb9d0f59668@65.109.70.23:18256,c512c01adb4e88a956918e4f140e44aa408ddd6f@65.21.239.60:25656,a5c50d821d0a10261f6a21f5b62cd496b04618bb@38.104.143.74:26656,f36a9ff85a9f956f345e47c8ce364fc1fcf52d7e@65.108.111.236:55746,a72afd1c7bab7ce5dcbedc532a8ccabf6a3e0ed1@194.163.165.176:46656,1608ddec15a0b46785bf864b8b9666c0421ad55f@65.21.170.3:30656,d81e29ac9898d7957d41ecbf54b9a6c223023fbe@95.217.118.96:26656,c6eb23c2e00e13b800795e9a6acc090744a25218@65.108.13.185:27363,007a06e5df8c5d203cb88bf920b820b8c20944fa@162.19.31.150:55746,979139a41488ea532f0929682ab99659afd5266b@213.239.207.175:43656,b2af6edf123dc263fe5f46b53aaee4cc5ac6014c@65.109.85.170:57656,01ea9968bcacd6276f9f01ca04907953d25c2168@173.212.222.167:31656,5b7f8cc1a8fd8c5bc7331b26872fceb2811325ee@65.109.89.5:37656,4287c77d9807c53a90853c463891daecf8b1cec1@65.109.57.221:27656,eeb4f094eaa62841b4a9a73f0560d6aa1fa87482@65.108.231.124:29656,5265b02d7a5e43275f3383e6385cdc0506b99e1a@65.109.28.177:28656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:48656,c7c43689fe3a74d14d8159f80d070c763cbc5a81@96.234.160.22:26656,dcf78ede935a42361895928d35119ed4789abb9c@65.109.85.225:8090,a98484ac9cb8235bd6a65cdf7648107e3d14dab4@116.202.231.58:48656,136589c157a21094c976f67bcb76bc6327c58b93@65.108.97.58:2686,45242cf33bdebea72f1ef173a0df69bec7640a1e@173.249.50.126:48656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/$FOLDER/config/config.toml
SEEDS="ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@testnet-seeds.polkachu.com:18256"
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