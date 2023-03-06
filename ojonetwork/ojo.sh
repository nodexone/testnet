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
echo ">>> Cosmovisor Automatic Installer for Ojo Networks | Chain ID : ojo-devnet <<<";
echo -e "\e[0m"

sleep 1

# Variable
SOURCE=ojo
WALLET=wallet
BINARY=ojod
CHAIN=ojo-devnet
FOLDER=.ojo
VERSION=v0.1.2
DENOM=uojo
COSMOVISOR=cosmovisor
REPO=https://github.com/ojo-network/ojo
GENESIS=https://snapshots.polkachu.com/testnet-genesis/ojo/genesis.json
ADDRBOOK=https://snapshots.polkachu.com/testnet-addrbook/ojo/addrbook.json
PORT=246

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
make install
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0

# Prepare binaries for Cosmovisor
mkdir -p $HOME/$FOLDER/$COSMOVISOR/genesis/bin
mv $HOME/go/bin/$BINARY $HOME/$FOLDER/$COSMOVISOR/genesis/bin/
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

PEERS="239caa37cb0f131b01be8151631b649dc700cd97@95.217.200.36:46656,a23cc4cbb09108bc9af380083108262454539aeb@35.215.116.65:26656,b0968b57bcb5e527230ef3cfa3f65d5f1e4647dd@35.212.224.95:26656,8671c2dbbfd918374292e2c760704414d853f5b7@35.215.121.109:26656,62fa77951a7c8f323c0499fff716cd86932d8996@65.108.199.36:24214,b6b4a4c720c4b4a191f0c5583cc298b545c330df@65.109.28.219:21656,2c40b0aedc41b7c1b20c7c243dd5edd698428c41@138.201.85.176:26696,7ee8ece35c778418302ac085817d835b67043871@116.203.245.212:26656,5af3d50dcc231884f3d3da3e3caecb0deef1dc5b@142.132.134.112:25356,9edc978fd53c8718ef0cafe62ed8ae23b4603102@136.243.103.32:36656,3d11a6c7a5d4b3c5752be0c252c557ed4acc2c30@167.235.57.142:36656,2691bb6b296b951400d871c8d0bd94a3a1cdbd52@65.109.93.152:33656,c37e444f67af17545393ad16930cd68dc7e3fd08@95.216.7.169:61156,ffe2d5ecb614762d5a1723f5f8b00d3feb6eb091@5.9.13.234:26686,a98484ac9cb8235bd6a65cdf7648107e3d14dab4@116.202.231.58:50656,cbe534c7d012e9eb4e71a5573aee8acc1adf4bc6@65.108.41.172:28056,9bcec17faba1b8f6583d37103f20bd9b968ac857@38.146.3.230:21656,fbeb2b37fe139399d7513219e25afd9eb8f81f4f@65.21.170.3:38656,ac5089a8789736e2bc3eee0bf79ca04e22202bef@162.55.80.116:29656,1145755896d6a3e9df2f130cc2cbd223cdb206f0@209.145.53.163:29656,e54b02d103f1fcf5189a86abe542670979d2029d@65.109.85.170:58656,311b3a8649a24e4a816284b92f2f3af30ac292d7@51.195.89.114:21156,408ee86160af26ee7204d220498e80638f7874f4@161.97.109.47:38656,bd35cfd5bfbea4c2a63e893860d4f9a7d880957c@213.239.217.52:45656,2223f5bf494729b9e9fdf6693d116d34e9d29755@141.94.193.28:55756,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:50656,7416a65de3cc548a537dbb8bdf93dbd83fe401d2@78.107.234.44:26656,3aeec94e9567c66ad6bb76b496aff6d55fd53d32@65.109.171.22:26656,0465032114df76df206c9983968f2d229b3a50d6@88.198.32.17:39656"
SEEDS="ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@testnet-seeds.polkachu.com:21656"
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
curl -L https://snapshots.polkachu.com/testnet-snapshots/ojo/ojo_301747.tar.lz4 | tar -Ilz4 -xf - -C $HOME/$FOLDER

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