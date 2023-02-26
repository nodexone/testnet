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
echo ">>> Cosmovisor Automatic Installer for Lava Networks | Chain ID : lava-testnet-1 <<<";
echo -e "\e[0m"

sleep 1

# Variable
SOURCE=lava
WALLET=wallet
BINARY=lavad
CHAIN=lava-testnet-1
FOLDER=.lava
VERSION=v0.6.0
DENOM=ulava
COSMOVISOR=cosmovisor
REPO=https://github.com/lavanet/lava.git
GENESIS=https://snapshots.kjnodes.com/lava-testnet/genesis.json
ADDRBOOK=https://snapshots.kjnodes.com/lava-testnet/addrbook.json
PORT=235

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
$BINARY config node tcp://localhost:${PORT}57
$BINARY init $NODENAME --chain-id $CHAIN

# Download genesis and addrbook
curl -Ls $GENESIS > $HOME/$FOLDER/config/genesis.json
curl -Ls $ADDRBOOK > $HOME/$FOLDER/config/addrbook.json

# Add seeds,gas-prices & peers
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ulava\"/" $HOME/$FOLDER/config/app.toml

PEERS="a2afdc48785be73f208af349e78d632b5556cc01@5.75.226.151:26656,944389dd08321247c8ad687d904591a3d73d16c6@173.249.38.130:26656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:44656,ec8065014ed4814b12c884ed528b96f281104528@65.21.131.215:26686,e1383b216c42acc842193c5ac7321ce6c0d73db0@78.47.37.142:26656,3173b2d34ce415ee9a1bf08646d85688bf49e299@5.189.186.222:36656,e8256f9fedf27b6de76c8a13e2db050d0a7bd905@95.216.42.83:26656,c5c98017339ce6d4d5d2a4fd0fb1aaeb966ef0f7@65.108.124.57:36656,370ae92bd28701e0c1d8dc912ccf0d40fe0db3d5@157.90.245.166:26656,8a089094624f27698f365402a059b8b810532805@207.180.229.129:26656,821c9347c927db52138dcd4bb54478fdf17f273e@81.0.218.53:26656,4634ca7cefe997035440df1095915ed255e81296@49.12.189.98:26656,e268a2ce255d51a93e6ec89ee73c233bbaec70f4@49.12.185.46:26656,c0efea9152aed75fcf3022b8af45243818c59d6a@49.12.13.104:26656,07c8a4eea1f6826509d9da5ec7eee7a1a145ab09@20.24.72.210:26656,877fb1670209bc2a347d7755388b677b330e98ea@95.216.9.42:26656,4732ed188fbe7603f81d9f4c825397277bb72217@5.75.235.195:26656,1598a86c04a64d17fa15a07eb201f50c5d760842@75.119.136.106:26656,a753585da65620cd735d790955c548ce2f3f2286@167.86.98.134:26656,9a151159039fd8abce61ddb21e5342605787792b@5.75.228.39:26656,dfa93668152cb6b3a822c987f9c22110a1c2f314@178.18.255.221:26656,4ad3f3731073a016fa0c99118b2a5a2d313928f5@207.180.233.148:26656,61c9667630221059a971a114e48a936f45084d2e@185.209.230.156:26656,ec3a0b0399b19e89e04a1fef5cfafdc0f3d8a1d7@185.209.230.159:26656,3aef9d4925d9c299a77a4209db2be3fd7ded4ad0@94.103.91.148:26656,0c630a0e2afc5e03a32e989a47743d7c09e31337@138.201.173.81:26656,6a55747d1f93e46696f233ac563e28fea24afc47@38.242.237.192:36656,e83c0fdeb2b0e258bb559d657d0907b63635127a@159.69.149.85:26656,bec79fab73dbbe345d8b26cdeeeee4ab83fdf80e@176.9.22.117:35656,474e2436e097c28472a1fe269e1825762fa340d6@38.242.128.19:26656,c83d7b205b2e80bd9a33c13161bd39d520988455@38.242.139.189:26656,ab924e7944c332bd1b52c8733e262bbdd33cb5ac@116.202.165.53:26656,ade02cddf71489b79a2054a7c6ba2cab8a0abb18@185.163.125.232:26656,d5ad7ae6caf54ef20a6dc04d30a55caac6c540c9@5.61.41.138:26656,4e96723af8feb8a515573a7b9391e7bf7d562480@194.163.162.155:26656,1550fe479ee2dcfa35f7dcd2c66f37a50d34b0e3@178.63.132.243:2237,e5f324d671e8bba44cd8eef2cb5b6e46ccf4f95a@65.108.199.120:60756,cba6347ac83120324c34514d383f3e9835ac15e9@5.75.139.114:26656,6f1f1414c63e9ffca9cb59fe4c847580da2020d6@109.123.235.222:10104,fdc3bd914360b1be8ee2e9f4a447223830527497@78.46.36.203:26656,ca1c561ad051d12cf99d8846303f4d31bfe3eb83@159.203.111.26:26656,1b09acd86e1a2db56c72db7848ada3ad581f027a@95.217.109.222:36656,2cb465a7c919321978f89701b4ae07ac505f7ad8@194.163.184.228:26656,5e8d65796d939fc16fa0c955dfbd16c9c519606b@222.71.35.43:26656,ef6e9620807e7e4614fd8e02722f8075ec277544@199.175.98.122:26656,22c51515eea1df09dc872dc8843efb7fc73770b1@199.175.98.102:26656,94bba76f57bc30a6c0afa4ca10cd54d0b247569d@38.242.221.85:26656,db8b1d876480849784569b927a3cc6d27dcc05a1@65.108.229.93:31656,7e68edc23e6c716b3248099dd1f03810a57975ef@65.109.92.150:34656"
SEEDS="3f472746f46493309650e5a033076689996c8881@lava-testnet.rpc.kjnodes.com:44659"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/$FOLDER/config/config.toml
sed -i.bak -e "s/^seeds =.*/seeds = \"$SEEDS\"/" $HOME/$FOLDER/config/config.toml

# Set Port
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}57\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}56\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}60\"%" $HOME/$FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}17\"%; s%^address = \":8080\"%address = \":${PORT}80\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}90\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}91\"%" $HOME/$FOLDER/config/app.toml

# Set Config Pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/$FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/$FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/$FOLDER/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/$FOLDER/config/app.toml

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
echo -e "CHECK STATUS BINARY : \e[1m\e[35msystemctl status $BINARY\e[0m"
echo -e "CHECK RUNNING LOGS : \e[1m\e[35mjournalctl -fu $BINARY -o cat\e[0m"
echo -e "CHECK LOCAL STATUS : \e[1m\e[35mcurl -s localhost:${PORT}57/status | jq .result.sync_info\e[0m"
echo ""

# End