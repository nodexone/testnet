#
# // Copyright (C) NodeX Capital
#

echo -e "\033[0;35m"
echo " ███╗   ██╗ ██████╗ ██████╗ ███████╗██╗  ██╗     ██████╗ █████╗ ██████╗ ██╗████████╗ █████╗ ██╗     ";
echo " ████╗  ██║██╔═══██╗██╔══██╗██╔════╝╚██╗██╔╝    ██╔════╝██╔══██╗██╔══██╗██║╚══██╔══╝██╔══██╗██║     ";
echo " ██╔██╗ ██║██║   ██║██║  ██║█████╗   ╚███╔╝     ██║     ███████║██████╔╝██║   ██║   ███████║██║     ";
echo " ██║╚██╗██║██║   ██║██║  ██║██╔══╝   ██╔██╗     ██║     ██╔══██║██╔═══╝ ██║   ██║   ██╔══██║██║     ";
echo " ██║ ╚████║╚██████╔╝██████╔╝███████╗██╔╝ ██╗    ╚██████╗██║  ██║██║     ██║   ██║   ██║  ██║███████╗";
echo " ╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝     ╚═════╝╚═╝  ╚═╝╚═╝     ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝";
echo ">>> Price Feeder Automatic Installer for Ojo Networks | Chain ID : ojo-devnet <<<";
echo -e "\e[0m"

# variable
OJO_PF_SOUCE=price-feeder
OJO_PF_VERSION=v0.1.1
OJO_PF_REPO=https://github.com/ojo-network/price-feeder
OJO_PF_FOLDER=.ojo-price-feeder
OJO_PF_KEYRING="os"
OJO_VALOPER=$(ojod keys show wallet --bech val -a)
OJO_WALLET=$(ojod keys show wallet -a)
OJO_PF_PORT=24672


# Set Price Feeder Wallet Name
if [ ! $OJO_PF_WALLET ]; then
        read -p "hello@nodexcapital:~# [ENTER PRICE FEEDER WALLET NAME] > " OJO_PF_WALLET
fi

# Set Price Feeder Password
if [ ! $OJO_PF_PASS ]; then
    while true; do
        read -p "hello@nodexcapital:~# [ENTER PASSWORD] > " OJO_PF_PASS
        if [ ${#OJO_PF_PASS} -ge 8 ]; then
            echo "Password must be at least 8 characters!"
        else
            break
        fi
    done
fi


# grab rpc & grpc port
RPC_PORT=$(grep -A 9 "# TCP or UNIX socket address for the RPC server to listen on" ~/.ojo/config/config.toml | grep -oP '(?<=:)[0-9]+') >> $HOME/.bash_profile
GRPC_PORT=$(grep -A 9 "# Address defines the gRPC server address to bind to." ~/.ojo/config/app.toml | grep -oP '(?<=:)[0-9]+') >> $HOME/.bash_profile

echo "Verify the information below before proceeding with the installation!"
echo ""
echo -e "OJO PRICE FEEDER WALLET NAME      : \e[1m\e[35m$OJO_PF_WALLET\e[0m"
echo -e "OJO PRICE FEEDER WALLET PASSWORD  : \e[1m\e[35m$OJO_PF_PASS\e[0m"
echo -e "OJO PRICE FEEDER VERSION          : \e[1m\e[35m$OJO_PF_VERSION\e[0m"
echo -e "OJO RPC PORT                      : \e[1m\e[35m$RPC_PORT\e[0m"
echo -e "OJO gRPC PORT                     : \e[1m\e[35m$GRPC_PORT\e[0m"
echo -e "OJO PRICE FEEDER PORT             : \e[1m\e[35m$OJO_PF_PORT\e[0m"
echo ""

read -p "Is the above information correct? (y/n) " choice
if [[ $choice == [Yy]* ]]; then

export OJO_PF_SOUCE=${OJO_PF_SOUCE}
export OJO_PF_VERSION=${OJO_PF_VERSION}
export OJO_PF_REPO=${OJO_PF_REPO}
export OJO_PF_FOLDER=${OJO_PF_FOLDER}
export OJO_PF_KEYRING=${OJO_PF_KEYRING}
export RPC_PORT=${RPC_PORT}
export GRPC_PORT=${GRPC_PORT}
export OJO_VALOPER=${OJO_VALOPER}
export OJO_WALLET=${OJO_WALLET}
export OJO_PF_PORT=${OJO_PF_PORT}

else
    echo "Installation cancelled!"
    exit 1
fi

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
  printf "\r[✓] $1 Complete!\n"
}

# Package
sudo apt -q update >/dev/null 2>&1 &
animate "Update System"

sudo apt -qy upgrade >/dev/null 2>&1 &
animate "Upgrade System"

# Install GO
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.19.5.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local  >/dev/null 2>&1 &
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile) 
animate "Verify Go"

# Get testnet version of Ojo Price Feeder
cd $HOME
git clone $OJO_PF_REPO  >/dev/null 2>&1 &
cd $OJO_PF_SOUCE
git checkout $OJO_PF_VERSION  >/dev/null 2>&1 &
make build  >/dev/null 2>&1 &
sudo mv build/$OJO_PF_SOUCE /usr/local/bin
rm $HOME/$OJO_PF_FOLDER -rf
animate "Building Binary"

# Prepare Price Feeder Directory
mkdir $HOME/$OJO_PF_FOLDER
mv price-feeder.example.toml $HOME/$OJO_PF_FOLDER/config.toml

# Withdraw Commision
# ojod tx distribution withdraw-rewards $(ojod keys show wallet --bech val -a) --commission --from wallet --chain-id ojo-devnet --gas-adjustment 1.4 --gas auto --gas-prices 0uojo -y

# Make a Price Feeder Wallet
read -p "⚠️ Before proceeding with the installation, you must create a wallet and save the mnemonic phrase! Have you done this? (y/n) " yn

if [[ $yn =~ ^[Yy]$ ]]; then
  echo "Please make sure to backup your mnemonic phrase before continuing with the installation!"

# Create Price Feeder Wallet
  ojod keys add $OJO_PF_WALLET --keyring-backend $OJO_PF_KEYRING
  sleep 10

else
  echo "Installation cancelled!"
  exit 1
fi


# Setup Vars Price Feeder Wallet
OJO_PF_ADDRESS=$(echo -e $OJO_PF_PASS | ojod keys show $OJO_PF_WALLET --keyring-backend os -a)
echo "export OJO_PF_ADDRESS=${OJO_PF_ADDRESS}" >> $HOME/.bash_profile

# Send 1 OJO to Price Feeder Wallet
ojod tx bank send wallet $OJO_PF_ADDRESS 1000000uojo --from wallet --chain-id ojo-devnet --gas-adjustment 1.4 --gas auto --gas-prices 0uojo -y

# Oracle Tx Delegate
ojod tx oracle delegate-feed-consent $OJO_WALLET $OJO_PF_ADDRESS --from wallet --gas-adjustment 1.4 --gas auto --gas-prices 0uojo -y

# Feeder Delegation
ojod q oracle feeder-delegation $OJO_VALOPER

# Set Price Feeder Config
sed -i "s/^listen_addr *=.*/listen_addr = \"0.0.0.0:${OJO_PF_PORT}\"/;\
s/^address *=.*/address = \"$OJO_PF_ADDRESS\"/;\
s/^chain_id *=.*/chain_id = \"ojo-devnet\"/;\
s/^validator *=.*/validator = \"$OJO_VALOPER\"/;\
s/^backend *=.*/backend = \"$OJO_PF_KEYRING\"/;\
s|^dir *=.*|dir = \"$HOME/.ojo\"|;\
s|^grpc_endpoint *=.*|grpc_endpoint = \"localhost:${GRPC_PORT}\"|;\
s|^tmrpc_endpoint *=.*|tmrpc_endpoint = \"http://localhost:${RPC_PORT}\"|;\
s|^global-labels *=.*|global-labels = [[\"chain_id\", \"ojo-devnet\"]]|;\
s|^service-name *=.*|service-name = \"ojo-price-feeder\"|;" $HOME/$OJO_PF_FOLDER/config.toml


# Create Price Feeder Service
sudo tee /etc/systemd/system/ojo-price-feeder.service > /dev/null <<EOF
[Unit]
Description=Ojo Price Feeder
After=network-online.target

[Service]
User=$USER
ExecStart=$(which price-feeder) $HOME/$OJO_PF_FOLDER/config.toml
Restart=on-failure
RestartSec=30
LimitNOFILE=65535
Environment="PRICE_FEEDER_PASS=$OJO_PF_PASS"

[Install]
WantedBy=multi-user.target
EOF

# Register & start service
sudo systemctl daemon-reload
sudo systemctl enable ojo-price-feeder
sudo systemctl restart ojo-price-feeder

echo -e "\e[1m\e[35mPRICE FEEDER SETUP FINISHED\e[0m"
echo ""
echo -e "CHECK STATUS BINARY : \e[1m\e[35msystemctl status ojo-price-feeder\e[0m"
echo -e "CHECK RUNNING LOGS : \e[1m\e[35mjournalctl -fu ojo-price-feeder -o cat\e[0m"
echo ""

# End