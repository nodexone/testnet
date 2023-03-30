#
# // Copyright (C) 2023 By NodeX Capital
#

echo -e "\033[0;35m"
echo " ███╗   ██╗ ██████╗ ██████╗ ███████╗██╗  ██╗     ██████╗ █████╗ ██████╗ ██╗████████╗ █████╗ ██╗     ";
echo " ████╗  ██║██╔═══██╗██╔══██╗██╔════╝╚██╗██╔╝    ██╔════╝██╔══██╗██╔══██╗██║╚══██╔══╝██╔══██╗██║     ";
echo " ██╔██╗ ██║██║   ██║██║  ██║█████╗   ╚███╔╝     ██║     ███████║██████╔╝██║   ██║   ███████║██║     ";
echo " ██║╚██╗██║██║   ██║██║  ██║██╔══╝   ██╔██╗     ██║     ██╔══██║██╔═══╝ ██║   ██║   ██╔══██║██║     ";
echo " ██║ ╚████║╚██████╔╝██████╔╝███████╗██╔╝ ██╗    ╚██████╗██║  ██║██║     ██║   ██║   ██║  ██║███████╗";
echo " ╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝     ╚═════╝╚═╝  ╚═╝╚═╝     ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝";
echo ">>> Full & Light Node Automatic Installer for Celestia | Chain ID : blockspacerace-0 <<<";
echo -e "\e[0m"

sleep 1

# Variable
NODE_SOURCE=celestia-app
LIGHT_SOURCE=celestia-node
CHAIN=blockspacerace-0
FOLDER=.celestia-app
NODE_BIN=celestia-appd
NODE_WALLET=wallet
NODE_VER=v0.12.1
LIGHT_BIN=celestia
LIGHT_WALLET=light
LIGHT_VER=v0.8.0
COSMOVISOR=cosmovisor
GENESIS=https://snap.nodexcapital.com/celestia/genesis.json
ADDRBOOK=https://snap.nodexcapital.com/celestia/addrbook.json
NODE_REPO=https://github.com/celestiaorg/celestia-app.git
LIGHT_REPO=https://github.com/celestiaorg/celestia-node.git
DENOM=utia
PORT=223

# Set Vars
if [ ! $NODENAME ]; then
        read -p "hello@nodexcapital:~# [ENTER YOUR NODE] > " NODENAME
        echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi

echo "Verify the information below before proceeding with the installation!"
echo ""
echo -e "NODE NAME      : \e[1m\e[35m$NODENAME\e[0m"
echo -e "CHAIN NAME     : \e[1m\e[35m$CHAIN\e[0m"
echo -e "FULL NODE      : \e[1m\e[35m$NODE_VER\e[0m"
echo -e "LIGHT NODE     : \e[1m\e[35m$LIGHT_WALLET\e[0m"
echo -e "NODE FOLDER    : \e[1m\e[35m$FOLDER\e[0m"
echo -e "NODE DENOM     : \e[1m\e[35m$DENOM\e[0m"
echo -e "NODE ENGINE    : \e[1m\e[35m$COSMOVISOR\e[0m"
echo -e "NODE PORT      : \e[1m\e[35m$PORT\e[0m"
echo -e "NODE REPO      : \e[1m\e[35m$NODE_REPO\e[0m"
echo -e "LIGHT REPO     : \e[1m\e[35m$LIGHT_REPO\e[0m"
echo ""

read -p "Is the above information correct? (y/n) " choice
if [[ $choice == [Yy]* ]]; then

echo "export NODE_SOURCE=${NODE_SOURCE}" >> $HOME/.bash_profile
echo "export LIGHT_SOURCE=${LIGHT_SOURCE}" >> $HOME/.bash_profile
echo "export NODE_WALLET=${NODE_WALLET}" >> $HOME/.bash_profile
echo "export NODE_REPO=${NODE_REPO}" >> $HOME/.bash_profile
echo "export NODE_VER=${NODE_VER}" >> $HOME/.bash_profile
echo "export NODE_BIN=${NODE_BIN}" >> $HOME/.bash_profile
echo "export LIGHT_WALLET=${LIGHT_WALLET}" >> $HOME/.bash_profile
echo "export LIGHT_REPO=${LIGHT_REPO}" >> $HOME/.bash_profile
echo "export LIGHT_VER=${LIGHT_VER}" >> $HOME/.bash_profile
echo "export LIGHT_BIN=${LIGHT_BIN}" >> $HOME/.bash_profile
echo "export DENOM=${DENOM}" >> $HOME/.bash_profile
echo "export CHAIN=${CHAIN}" >> $HOME/.bash_profile
echo "export FOLDER=${FOLDER}" >> $HOME/.bash_profile
echo "export COSMOVISOR=${COSMOVISOR}" >> $HOME/.bash_profile
echo "export GENESIS=${GENESIS}" >> $HOME/.bash_profile
echo "export ADDRBOOK=${ADDRBOOK}" >> $HOME/.bash_profile
echo "export PORT=${PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile

else
    echo "Installation cancelled!"
    exit 1
fi

# Package
sudo apt -q update
sudo apt -qy install curl git jq lz4 build-essential
sudo apt -qy upgrade

# Install GO
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.19.7.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)

# Get testnet version celestia
cd $HOME
rm -rf $NODE_SOURCE
git clone $NODE_REPO
cd $NODE_SOURCE
git checkout $NODE_VER
make build
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0

# Prepare binaries for Cosmovisor
mkdir -p $HOME/$FOLDER/cosmovisor/genesis/bin
mv build/$NODE_BIN $HOME/$FOLDER/cosmovisor/genesis/bin/
rm -rf build

# Create application symlinks
ln -s $HOME/$FOLDER/cosmovisor/genesis $HOME/$FOLDER/cosmovisor/current
sudo ln -s $HOME/$FOLDER/cosmovisor/current/bin/$NODE_BIN /usr/local/bin/$NODE_BIN

# Init generation
$NODE_BIN config chain-CHAIN $CHAIN
$NODE_BIN config keyring-backend test
$NODE_BIN config node tcp://localhost:${PORT}57
$NODE_BIN init $NODENAME --chain-id $CHAIN

# Download genesis and addrbook
curl -Ls $GENESIS > $HOME/$FOLDER/config/genesis.json
curl -Ls $ADDRBOOK > $HOME/$FOLDER/config/addrbook.json

# Set Seers and Peers
PEERS="$(curl -sS https://rpc-celestia-itn.sxlzptprjkt.xyz/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
SEEDS="3f472746f46493309650e5a033076689996c8881@celestia-testnet.rpc.kjnodes.com:20659"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.celestia-app/config/config.toml
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/$FOLDER/config/config.toml

# Set Port
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}57\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"tcp://127.0.0.1::${PORT}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}56\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \"tcp://127.0.0.1:${PORT}60\"%" $HOME/$FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://127.0.0.1:${PORT}17\"%; s%^address = \":8080\"%address = \"127.0.0.1::${PORT}80\"%; s%^address = \"0.0.0.0:9090\"%address = \"127.0.0.1:${PORT}90\"%; s%^address = \"0.0.0.0:9091\"%address = \"127.0.0.1:${PORT}91\"%" $HOME/$FOLDER/config/app.toml

# Set Config Pruning
pruning="nothing"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/$FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/$FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/$FOLDER/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/$FOLDER/config/app.toml


# Set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.005$DENOM\"/" $HOME/$FOLDER/config/app.toml

# Set indexer
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/$FOLDER/config/config.toml

# Enable snapshots
sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = \"2000\"/" $HOME/$FOLDER/config/app.toml
$NODE_BIN tendermint unsafe-reset-all --home $HOME/$FOLDER --keep-addr-book
curl -L https://snap.nodexcapital.com/celestia/celestia-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/$FOLDER
[[ -f $HOME/$FOLDER/data/upgrade-info.json ]] && cp $HOME/$FOLDER/data/upgrade-info.json $HOME/$FOLDER/cosmovisor/genesis/upgrade-info.json

# Create Service
sudo tee /etc/systemd/system/$NODE_BIN.service > /dev/null << EOF
[Unit]
Description=$NODE_BIN
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/$FOLDER"
Environment="DAEMON_NAME=$NODE_BIN"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/$FOLDER/cosmovisor/current/bin"

[Install]
WantedBy=multi-user.target
EOF

# Register And Start Service
sudo systemctl daemon-reload
sudo systemctl enable $NODE_BIN

echo "Resting for 10 seconds"
sleep 10
echo "10 seconds are up, installing light node now..."

# Get light node version
git clone $LIGHT_REPO 
cd $LIGHT_SOURCE
git checkout $LIGHT_VER
make build
sudo mv build/$LIGHT_BIN /usr/local/bin
make cel-key
sudo mv cel-key /usr/local/bin

#Add Key
cel-key add $LIGHT_WALLET --node.type light --p2p.network blockspacerace

# Init light node
$LIGHT_BIN light init \
 --keyring.accname $LIGHT_WALLET \
 --core.ip localhost \
 --core.grpc.port ${PORT}90 \
 --gateway \
 --gateway.addr localhost \
 --gateway.port ${PORT}59 \
 --p2p.network blockspacerace

# Create service light node
sudo tee /etc/systemd/system/$LIGHT_BIN.service > /dev/null << EOF
[Unit]
Description=Celestia Light Node
After=network-online.target

[Service]
User=$USER
ExecStart=$(which celestia) light start \\
--keyring.accname $LIGHT_WALLET \\
--core.ip localhost \\
--core.rpc.port ${PORT}57 \\
--core.grpc.port ${PORT}90 \\
--p2p.network blockspacerace \\
--rpc.port ${PORT}58 \\
--gateway \\
--gateway.addr localhost \\
--gateway.port ${PORT}59 \\
--metrics.tls=false \\
--metrics \\
--metrics.endpoint otel.celestia.tools:4318 
Restart=on-failure
RestartSec=10
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable $LIGHT_BIN
sudo systemctl start $LIGHT_BIN
sudo systemctl start $NODE_BIN


echo -e "\033[0;35m=============================================================\033[0m"
echo -e "\033[0;35mCONGRATS! SETUP FULL NODE & LIGHT NODE FINISHED\033[0m"
echo ""
echo -e "CHECK STATUS FULL NODE : \033[1m\033[35msystemctl status $NODE_BIN\033[0m"
echo -e "CHECK LOGS FULL NODE : \033[1m\033[35mjournalctl -fu $NODE_BIN -o cat\033[0m"
echo -e "CHECK STATUS LIGHT NODE : \033[1m\033[35msystemctl status $LIGHT_BIN\033[0m"
echo -e "CHECK LOGS LIGHT NODE : \033[1m\033[35mjournalctl -fu $LIGHT_BIN -o cat\033[0m"
echo -e "CHECK LOCAL STATUS : \033[1m\033[35mcurl -s localhost:${PORT}57/status | jq .result.sync_info\033[0m"
echo -e "\033[0;35m=============================================================\033[0m"

# End