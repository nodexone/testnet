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
echo ">>> Cosmovisor Automatic Installer for Andromeda | Chain ID : galileo-3  <<<";
echo -e "\e[0m"

sleep 1

# Variable
SOURCE=andromedad
WALLET=wallet
BINARY=andromedad 
CHAIN=galileo-3
FOLDER=.andromedad
VERSION=galileo-3-v1.1.0-beta1
DENOM=uandr
COSMOVISOR=cosmovisor
REPO=https://github.com/andromedaprotocol/andromedad.git
GENESIS=https://snapshots.kjnodes.com/andromeda-testnet/genesis.json
ADDRBOOK=https://snapshots.kjnodes.com/andromeda-testnet/addrbook.json
PORT=244

# Set Vars
if [ ! $NODENAME ]; then
        read -p "hello@nodexcapital:~# [ENTER YOUR NODENAME] > " NODENAME
        echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi

echo "Verify the information below before proceeding with the installation!"
echo ""
echo -e "NODE NAME      : \e[1m\e[35m$NODENAME\e[0m"
echo -e "WALLET NAME    : \e[1m\e[35m$WALLET\e[0m"
echo -e "CHAIN NAME     : \e[1m\e[35m$CHAIN\e[0m"
echo -e "NODE VERSION   : \e[1m\e[35m$VERSION\e[0m"
echo -e "NODE FOLDER    : \e[1m\e[35m$FOLDER\e[0m"
echo -e "NODE DENOM     : \e[1m\e[35m$DENOM\e[0m"
echo -e "NODE ENGINE    : \e[1m\e[35m$COSMOVISOR\e[0m"
echo -e "SOURCE CODE    : \e[1m\e[35m$SOURCE\e[0m"
echo -e "NODE PORT      : \e[1m\e[35m$PORT\e[0m"
echo ""

read -p "Is the above information correct? (y/n) " choice
if [[ $choice == [Yy]* ]]; then

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
echo "export PORT=${PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile

else
    echo "Installation cancelled!"
    exit 1
fi

sleep 1

# Define animation function
function animate {
  local pid=$!
  local spin='-\|/'
  local i=0
  while kill -0 $pid 2>/dev/null; do
    i=$(( (i+1) %4 ))
    printf "\r[${spin:$i:1}] $1..."
    sleep 0.1
  done
  printf "\r[✓] $1 Complete\n"
}

# Package
sudo apt -q update >/dev/null 2>&1 &
animate "Update System"

sudo apt -qy install curl git jq lz4 build-essential >/dev/null 2>&1 &
animate "Update Dependencies"

sudo apt -qy upgrade >/dev/null 2>&1 &
animate "Upgrade System"

# Install GO
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.19.5.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local >/dev/null 2>&1 &
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
animate "Install Golang"

# Get testnet version of Andromeda
cd $HOME 
rm -rf $SOURCE
git clone $REPO >/dev/null 2>&1 &
cd $SOURCE >/dev/null 2>&1 &
git checkout $VERSION >/dev/null 2>&1 &
make build >/dev/null 2>&1 &
animate "Building Binary"

go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0 >/dev/null 2>&1 &
animate "Install Cosmovisor"

# Prepare binaries for Cosmovisor
mkdir -p $HOME/$FOLDER/$COSMOVISOR/genesis/bin >/dev/null 2>&1 &
mv build/$BINARY $HOME/$FOLDER/$COSMOVISOR/genesis/bin/ >/dev/null 2>&1 &
rm -rf build
animate "Preparing Binary"

# Create application symlinks
ln -s $HOME/$FOLDER/$COSMOVISOR/genesis $HOME/$FOLDER/$COSMOVISOR/current >/dev/null 2>&1 &
sudo ln -s $HOME/$FOLDER/$COSMOVISOR/current/bin/$BINARY /usr/local/bin/$BINARY >/dev/null 2>&1 &

# Init generation
$BINARY config chain-id $CHAIN >/dev/null 2>&1 &
$BINARY config keyring-backend test >/dev/null 2>&1 &
$BINARY config node tcp://localhost:${PORT}57 >/dev/null 2>&1 &
$BINARY init $NODENAME --chain-id $CHAIN >/dev/null 2>&1 &
animate "Initialization"


# Set peers and seeds
PEERS=""
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.andromedad/config/config.toml >/dev/null 2>&1 &
SEEDS="3f472746f46493309650e5a033076689996c8881@andromeda-testnet.rpc.kjnodes.com:47659"
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/$FOLDER/config/config.toml >/dev/null 2>&1 &
animate "Setting Up Peers & Seeds"

# Download genesis and addrbook
curl -s $GENESIS > $HOME/$FOLDER/config/genesis.json &
animate "Update Genesis"
curl -s $ADDRBOOK > $HOME/$FOLDER/config/addrbook.json &
animate "Update Addrbook"

# Set Port
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}57\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}56\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}60\"%" $HOME/$FOLDER/config/config.toml >/dev/null 2>&1 &
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}17\"%; s%^address = \":8080\"%address = \":${PORT}80\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}90\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}91\"%" $HOME/$FOLDER/config/app.toml >/dev/null 2>&1 &
animate "Mapping Port"

# Set Config Pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/$FOLDER/config/app.toml >/dev/null 2>&1 &
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/$FOLDER/config/app.toml >/dev/null 2>&1 &
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/$FOLDER/config/app.toml >/dev/null 2>&1 &
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/$FOLDER/config/app.toml >/dev/null 2>&1 &
animate "Setting Pruning"

# Set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0$DENOM\"/" $HOME/$FOLDER/config/app.toml >/dev/null 2>&1 &
animate "Setup Gas"

# Enable snapshots
sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = \"2000\"/" $HOME/$FOLDER/config/app.toml >/dev/null 2>&1 &
$BINARY tendermint unsafe-reset-all --home $HOME/$FOLDER --keep-addr-book >/dev/null 2>&1 &
curl -L https://snapshots.kjnodes.com/andromeda-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/$FOLDER >/dev/null 2>&1 &
animate "Downloading Snapshot"


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
animate "Creating Service"

# Register And Start Service
sudo systemctl start $BINARY
sudo systemctl daemon-reload
sudo systemctl enable $BINARY

echo -e "\e[1m\e[35mSETUP FINISHED\e[0m"
echo ""
echo -e "CHECK STATUS BINARY : \e[1m\e[35msystemctl status $BINARY\e[0m"
echo -e "CHECK RUNNING LOGS : \e[1m\e[35mjournalctl -fu $BINARY -o cat\e[0m"
echo -e "CHECK LOCAL STATUS : \e[1m\e[35mcurl -s localhost:${PORT}57/status | jq .result.sync_info\e[0m"
echo ""

# End