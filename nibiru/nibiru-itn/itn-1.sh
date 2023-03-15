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
echo ">>> Cosmovisor Automatic Installer for Nibiru Chain | Chain ID : nibiru-itn-1 <<<";
echo -e "\e[0m"

sleep 1

# Variable
SOURCE=nibiru
WALLET=wallet
BINARY=nibid
CHAIN=nibiru-itn-1
FOLDER=.nibid
VERSION=v0.19.2
DENOM=unibi
COSMOVISOR=cosmovisor
REPO=https://github.com/NibiruChain/nibiru.git
GENESIS=https://snapshots.kjnodes.com/nibiru-testnet/genesis.json
ADDRBOOK=https://snapshots.kjnodes.com/nibiru-testnet/addrbook.json
PORT=224

# Set Vars
if [ ! $NODENAME ]; then
	read -p "hello@nodexcapital:~# [ENTER YOUR NODE] > " NODENAME
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
echo -e "SOURCE CODE    : \e[1m\e[35m$REPO\e[0m"
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

# Update
sudo apt update && sudo apt upgrade -y

# Package
sudo apt -q update
sudo apt -qy install curl git jq lz4 build-essential
sudo apt -qy upgrade

# Install GO
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.19.7.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)

# Get mainnet version of MARS

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
sudo ln -s $HOME/$FOLDER/$COSMOVISOR/current/bin/$BINARY /usr/bin/$BINARY

# Init generation
$BINARY config chain-id $CHAIN
$BINARY config keyring-backend test
$BINARY config node tcp://localhost:${PORT}57
$BINARY init $NODENAME --chain-id $CHAIN

# Set peers and seeds
PEERS="d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:39656,dd77acebf8880326ef05d1a6a97e0b1c18a3aad1@194.242.57.186:26656,b402b5605e266dc7844fd20223082d798fee5dec@34.172.227.227:26656,f093208f6cd6bea470cef7cc9dba1d4e12fd8284@38.242.153.85:26656,58c4f92775bc63621513ce145d58f239aec8c510@89.117.49.71:26656,afe25edd4b7515d5f013112166e157e4289177bb@95.217.35.186:46656,c95d317f1ac55d0eadc9f00ad0b14cbfa3a684be@167.172.178.32:26656,0e6ddde469e85dc5a5a45d64bdb64de1243bae93@65.21.7.104:26656,d9e6658501a6e99563916809aef1e978a261211b@149.102.141.140:26656,80c7465c2be002d00fc38c7c998d7450ad117e81@150.109.11.204:26656,3d80a624f658ec2793b63e7294702d4b52c18d70@75.119.134.229:26656,c392c231210000b8c9fd839810f2ea7ad5c3bede@185.209.223.111:26656,6c39e820bd7e8ea5afcf00974688884748c4aad6@5.189.174.145:26656,b1b591b5d577e42f857cfc1dc3b101c51f6e086c@80.85.242.71:26656,a96dcfdede0eac749917a1601a9a8d674e3380d0@149.102.157.139:26656,ead62954a88291828d243d3de081d62e44a0de19@31.220.81.234:26656,86a14d7255628f6199ec82540113c5ea81b5bda3@62.171.138.174:26656,046161f0f5d68d6f03715c6a78370f17dde4d7c6@185.130.113.171:26656,9b3df2d3730ea400834312e4f42f49d82cf5f0ab@144.76.118.130:26656,fa025a45a5c0fd2cc99ad1155a00589cfe6c9154@65.109.14.69:39656,bf7afb1ac763d27a065ad37e98ef1b2d3db76639@82.149.214.198:26656,db5c2eeea0521cf3b3d619e31c6b516a8b8ad829@144.91.127.69:26656,d8c2f902a690620a5393e6c40320623ccc900c98@185.233.192.38:26656,1a4643b6bf26c410b97c486b09c66366c9aaa36e@138.201.248.108:26656,f69080f2d78c9c7fef4bf2df235012734ee90cb9@35.230.146.53:26656,f4ff3881a8915dcbe800090963a58970c34aa094@109.172.45.7:26656,e3bcf7faf6efca24f6d0735bc96f67929a8164d3@164.90.217.176:26656,3fe49874e929fc14a0a1978759f22557ebe9e77d@109.205.183.52:26656,9a0efda9d4bf778a966ae973a59cfb22327e4052@143.110.160.174:26656,26747a3d8ea50b208302427aea75defa49e1a489@185.202.238.111:39656,b6b60748fe86c3e49acc9d36cd9890d04a95c4d2@75.119.139.73:26656,864a55c16e58054b591983afbaee3307aa4bf5dc@84.46.247.163:26656,580bfcd0d933932656e6e167acf59cd4d8492fc3@171.252.227.96:26656,1f2dc763163e36ad19ecf47ffe69db56f21199c5@109.123.243.85:26656,838b877d5110cc01bd6fb6488de47e635470bef0@185.197.194.238:26656,ae6c97b5d4928c936585f060c9e5794d5fa6577e@194.163.183.213:26656,fbfe7d9b7826406cb674e5b9170e1a2af47a898e@91.210.170.188:26656,d88eb958f18940d75add40b51d2a69295ed9e378@5.75.245.162:26656,6fefa7ece2ff81d1c228c31eda72692d9299d8bc@38.242.248.145:26656,6d18fa2a84396cff8616fda03689e856735d1b90@149.102.143.37:26656,63c350ff4e6cc8cd4eb93332b2014473c9db9d8f@83.229.83.167:26656,03f2491233ba3b355ad025da7e25a1ad6c15c704@38.242.201.204:26656,ae99caf00be07e9a5358b775c1f3ce1a2d97d152@38.242.234.37:26656,fb26e0b2ea196136f27d5bb2704b46d12f194495@164.92.202.21:26656,b6db16ab4d2dfd61d0be94df4738ce5f1913de11@212.41.9.98:26656"
SEEDS="a431d3d1b451629a21799963d9eb10d83e261d2c@seed-1.itn-1.nibiru.fi:26656,6a78a2a5f19c93661a493ecbe69afc72b5c54117@seed-2.itn-1.nibiru.fi:26656,3f472746f46493309650e5a033076689996c8881@nibiru-testnet.rpc.kjnodes.com:39659"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/$FOLDER/config/config.toml
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/$FOLDER/config/config.toml

# Download genesis and addrbook
curl -Ls $GENESIS > $HOME/$FOLDER/config/genesis.json
curl -Ls $ADDRBOOK > $HOME/$FOLDER/config/addrbook.json

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

# Set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025$DENOM\"/" $HOME/$FOLDER/config/app.toml

# Enable snapshots
sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = \"2000\"/" $HOME/$FOLDER/config/app.toml
$BINARY tendermint unsafe-reset-all --home $HOME/$FOLDER --keep-addr-book
curl -L https://snapshots.kjnodes.com/nibiru-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/$FOLDER
[[ -f $HOME/$FOLDER/data/upgrade-info.json ]] && cp $HOME/$FOLDER/data/upgrade-info.json $HOME/$FOLDER/cosmovisor/genesis/upgrade-info.json

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
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/$FOLDER/cosmovisor/current/bin"

[Install]
WantedBy=multi-user.target
EOF

# Register And Start Service
sudo systemctl start $BINARY
sudo systemctl daemon-reload
sudo systemctl enable $BINARY

echo -e "\033[0;35m=============================================================\033[0m"
echo -e "\033[0;35mCONGRATS! SETUP FINISHED\033[0m"
echo ""
echo -e "CHECK STATUS BINARY : \033[1m\033[35msystemctl status $BINARY\033[0m"
echo -e "CHECK RUNNING LOGS : \033[1m\033[35mjournalctl -fu $BINARY -o cat\033[0m"
echo -e "CHECK LOCAL STATUS : \033[1m\033[35mcurl -s localhost:${PORT}57/status | jq .result.sync_info\033[0m"
echo -e "\033[0;35m=============================================================\033[0m"

# End