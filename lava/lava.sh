#
# // Copyright (C) 2022 Salman Wahib Recoded By NodeX Capital
#

echo -e "\033[0;35m"
echo " ███╗   ██╗ ██████╗ ██████╗ ███████╗██╗  ██╗     ██████╗ █████╗ ██████╗ ██╗████████╗ █████╗ ██╗     ";
echo " ████╗  ██║██╔═══██╗██╔══██╗██╔════╝╚██╗██╔╝    ██╔════╝██╔══██╗██╔══██╗██║╚══██╔══╝██╔══██╗██║     ";
echo " ██╔██╗ ██║██║   ██║██║  ██║█████╗   ╚███╔╝     ██║     ███████║██████╔╝██║   ██║   ███████║██║     ";
echo " ██║╚██╗██║██║   ██║██║  ██║██╔══╝   ██╔██╗     ██║     ██╔══██║██╔═══╝ ██║   ██║   ██╔══██║██║     ";
echo " ██║ ╚████║╚██████╔╝██████╔╝███████╗██╔╝ ██╗    ╚██████╗██║  ██║██║     ██║   ██║   ██║  ██║███████╗";
echo " ╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝     ╚═════╝╚═╝  ╚═╝╚═╝     ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝";
echo ">>> Cosmovisor Automatic Installer for Lava Networks | Chain ID : lava-testnet-1 <<<";
echo -e "\e[0m"

sleep 1

# Variable
SOURCE=lava
WALLET=wallet
BINARY=lavad
CHAIN=lava-testnet-1
FOLDER=.lava
VERSION=v0.5.2
DENOM=ulava
COSMOVISOR=cosmovisor
REPO=https://github.com/lavanet/lava.git
GENESIS=https://snapshots.kjnodes.com/lava-testnet/genesis.json
ADDRBOOK=https://snapshots.kjnodes.com/lava-testnet/addrbook.json
PORT=37

echo "export SOURCE=${SOURCE}" >> $HOME/.bash_profile
echo "export WALLET=${WALLET}" >> $HOME/.bash_profile
echo "export BINARY=${BINARY}" >> $HOME/.bash_profile
echo "export DENOM=${DENOM}" >> $HOME/.bash_profile
echo "export COSMOVISOR=${COSMOVISOR}" >> $HOME/.bash_profile
echo "export CHAIN=${CHAIN}" >> $HOME/.bash_profile
echo "export FOLDER=${FOLDER}" >> $HOME/.bash_profile
echo "export VERSION=${VERSION}" >> $HOME/.bash_profile
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
rm -rf $SOURCE
git clone $REPO
cd $SOURCE
git checkout v0.5.2
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

# Download genesis and addrbook
curl -Ls $GENESIS > $HOME/$FOLDER/config/genesis.json
curl -Ls $ADDRBOOK > $HOME/$FOLDER/config/addrbook.json

# Add seeds,gas-prices & peers
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ulava\"/" $HOME/$FOLDER/config/app.toml
peers="602c87226395588e141076abbc967945465bba8e@65.109.68.93:36656,acc3fe0b067e10b55c060b2f740d6193bf15a315@15.204.207.179:26656,e1383b216c42acc842193c5ac7321ce6c0d73db0@78.47.37.142:26656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:44656,5c2a752c9b1952dbed075c56c600c3a79b58c395@185.16.39.172:27066,4732ed188fbe7603f81d9f4c825397277bb72217@5.75.235.195:26656,9a151159039fd8abce61ddb21e5342605787792b@5.75.228.39:26656,a2afdc48785be73f208af349e78d632b5556cc01@5.75.226.151:26656,8a089094624f27698f365402a059b8b810532805@207.180.229.129:26656,821c9347c927db52138dcd4bb54478fdf17f273e@81.0.218.53:26656,4b1dfa6c538de8d13a116bc68205636e42d6fbbd@146.190.82.119:26656,4634ca7cefe997035440df1095915ed255e81296@49.12.189.98:26656,e268a2ce255d51a93e6ec89ee73c233bbaec70f4@49.12.185.46:26656,c0efea9152aed75fcf3022b8af45243818c59d6a@49.12.13.104:26656,54dcc266dc66a79866f55aac1f2ae33a3f4d7f9e@65.109.224.188:26656,3a445bfdbe2d0c8ee82461633aa3af31bc2b4dc0@3.252.219.158:26656,e593c7a9ca61f5616119d6beb5bd8ef5dd28d62d@34.246.190.1:26656,d83043d1e14156d78722877b6f449e93b46ce871@142.132.152.46:44656,6aaa9f0cc400bb4aea1c1fd3d9592e882ea8b614@193.187.129.159:26656,3a0f10539eb8e0f46432564edaf6303bd67c18f3@23.88.71.247:26656,d5ad7ae6caf54ef20a6dc04d30a55caac6c540c9@5.61.41.138:26656,3ec1ce800d88aed4fcf978b594439d64542c9e32@5.161.145.40:26656,ce6db6900c9ca17ab71df9a8616de6466ab92179@95.217.207.236:29456,c5c98017339ce6d4d5d2a4fd0fb1aaeb966ef0f7@65.108.124.57:36656,370ae92bd28701e0c1d8dc912ccf0d40fe0db3d5@157.90.245.166:26656,7197c003295738f1b64f4ab9d6c4df84d937b1ac@138.201.178.139:26656,d53152e10f4de9e968eb98afc0f000343ebb3b02@135.181.115.115:33656,e83c0fdeb2b0e258bb559d657d0907b63635127a@159.69.149.85:26656,c83d7b205b2e80bd9a33c13161bd39d520988455@38.242.139.189:26656,f35a72a6ddf4e5cd045121b177ee54759e68163d@167.86.112.109:26656,cf897bcf8a6c68896049b231fadd43c9ec888701@137.184.77.8:26656,474e2436e097c28472a1fe269e1825762fa340d6@38.242.128.19:26656,8d0f563bc83453d2a2eacee1ed1b77467ef694bd@65.109.221.110:26656,4ad3f3731073a016fa0c99118b2a5a2d313928f5@207.180.233.148:26656,1dc8db6b9b800deded531bfb56ce12defbc98c74@173.249.46.50:26656,1598a86c04a64d17fa15a07eb201f50c5d760842@75.119.136.106:26656,0a94c7f8451841f51bfaf86668edd212f181735f@95.214.55.155:21656,fb498cc17f301930cfd4d3b6e6261148c84e05e7@45.140.147.117:27656,ade02cddf71489b79a2054a7c6ba2cab8a0abb18@185.163.125.232:26656,7a3ff12eda588f85ecb0da71def4bd736d65612f@95.217.224.252:26656,944389dd08321247c8ad687d904591a3d73d16c6@173.249.38.130:26656,2cb465a7c919321978f89701b4ae07ac505f7ad8@194.163.184.228:26656,11d25deba9c655a7312716810e3975fe175ada01@5.161.58.198:26656,3173b2d34ce415ee9a1bf08646d85688bf49e299@5.189.186.222:36656,aebbf38433cc38ed3aad0bb5f2aa567797df78da@46.8.210.144:26756"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/$FOLDER/config/config.toml
seeds="3f472746f46493309650e5a033076689996c8881@lava-testnet.rpc.kjnodes.com:44659"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/$FOLDER/config/config.toml

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


# Set indexer
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/$FOLDER/config/config.toml

# Enable snapshots
sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = \"2000\"/" $HOME/$FOLDER/config/app.toml
$BINARY tendermint unsafe-reset-all --home $HOME/$FOLDER --keep-addr-book
curl -L https://snapshots.kjnodes.com/lava-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/$FOLDER

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
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
EOF


# Register And Start Service
sudo systemctl daemon-reload
sudo systemctl enable $BINARY
sudo systemctl start $BINARY

echo -e "\e[1m\e[35mSETUP FINISHED\e[0m"
echo ""
echo -e "CHECK RUNNING LOGS : \e[1m\e[35mjournalctl -fu $BINARY -o cat\e[0m"
echo -e "CHECK LOCAL STATUS : \e[1m\e[35mcurl -s localhost:${PORT}657/status | jq .result.sync_info\e[0m"
echo ""

# End