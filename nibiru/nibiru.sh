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
echo ">>> Cosmovisor Automatic Installer for Nibiru Chain | Chain CHAIN : nibiru-testnet-2 <<<";
echo -e "\e[0m"

sleep 1

# Variable
SOURCE=nibiru
WALLET=wallet
BINARY=nibid
CHAIN=nibiru-testnet-2
FOLDER=.nibid
VERSION=v0.16.3
DENOM=unibi
COSMOVISOR=cosmovisor
REPO=https://github.com/NibiruChain/nibiru.git
GENESIS=https://snapshots.kjnodes.com/nibiru-testnet/genesis.json
ADDRBOOK=https://snapshots.kjnodes.com/nibiru-testnet/addrbook.json
PORT=34


echo "export SOURCE=${SOURCE}" >> $HOME/.bash_profile
echo "export WALLET=${WALLET}" >> $HOME/.bash_profile
echo "export BINARY=${BINARY}" >> $HOME/.bash_profile
echo "export CHAIN=${CHAIN}" >> $HOME/.bash_profile
echo "export FOLDER=${FOLDER}" >> $HOME/.bash_profile
echo "export VERSION=${VERSION}" >> $HOME/.bash_profile
echo "export REPO=${REPO}" >> $HOME/.bash_profile
echo "export DENOM=${DENOM}" >> $HOME/.bash_profile
echo "export COSMOVISOR=${COSMOVISOR}" >> $HOME/.bash_profile
echo "export GENESIS=${GENESIS}" >> $HOME/.bash_profile
echo "export ADDRBOOK=${ADDRBOOK}" >> $HOME/.bash_profile
echo "export PORT=${PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile

# Set Vars
if [ ! $NODENAME ]; then
	read -p "hello@nodexcapital:~# [ENTER YOUR NODE] > " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi
echo ""
echo -e "YOUR NODE NAME : \e[1m\e[31m$NODENAME\e[0m"
echo -e "NODE CHAIN CHAIN  : \e[1m\e[31m$CHAIN\e[0m"
echo -e "NODE PORT      : \e[1m\e[31m$PORT\e[0m"
echo ""

# Update
sudo apt update && sudo apt upgrade -y

# Package
sudo apt -q update
sudo apt -qy install curl git jq lz4 build-essential
sudo apt -qy upgrade

# Install GO
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.19.5.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
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
$BINARY config node tcp://localhost:${PORT}657
$BINARY init $NODENAME --chain-id $CHAIN

# Set peers and seeds
PEERS="ae402a0391c131494def0b171bfbc80776d8c3b7@209.126.8.192:26656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:39656,27311ac38a48db15fd4f0959d1948a8d25bc512f@43.155.108.250:26657,82ff5277d6385a2e9cab7048d8df5f6757d02a8f@43.154.33.200:26657,3299c1e21ffe818f13ae0c8c0968449dcf356611@86.48.26.76:26657,5a868d18a5046b715ee726a45b680a68f92bafcb@149.102.136.149:27656,d7185d6b0d6a7dbe8c45e1fddfa0165dfdba01c0@38.242.150.132:39656,92845d4150aaf87fc1a6f4a53d8fe545ae44fc9d@86.48.16.205:39656,3939da5da8d8a31e6af2cb6d7bdcb222ff2487eb@65.109.14.69:39656,e55d8746ad30e0d11ebe0aa3792c46713375edcc@135.181.2.104:26656,02f7c72a7b0f6c25c69d3a852540c3d59b55ead4@43.154.64.150:26657,50e5bed9efde45f2601e7a63d12d3c8d81e6e7d6@167.86.124.2:26656,08c10c775c86e9752741e993f6e89563413018e6@43.134.165.29:26657,82dde0f3c283ca231849376696d08c39c3d458ce@173.82.203.187:26657,c1d90ca59915ee94cd615304bfac8ddb9bdf2e76@43.156.25.107:26657,7bbe4afc59fbfff5e6c3189c8ef73a1c6ac3f067@80.82.215.23:26656,55773ecd03044a5126e68ea943338c6086cfbad3@43.134.174.55:26657,557f12a322097084cbe1f0c3528b0048b0b91cbc@62.141.44.70:26656,3500e228e18001372f08bcd0920281096ef80ddb@43.155.105.2:26657,5c2a752c9b1952dbed075c56c600c3a79b58c395@195.3.220.140:27046,fe95705d3de436dcef390c5ed7cd44d500c32738@185.135.137.254:26656,656465577c4a24380265725e17bffcd13816d6bc@84.46.246.196:26656,2f194c30648649e0d8b311f68fdd0baa58896445@161.97.136.141:26656,434408eac21cec429edc2deacfc90ca717593b21@109.123.242.87:26656,99b57896e917866956f9f078f67f95d6fd6a05e8@161.97.92.139:26656,5767cde760985a14aba0daeec694ecdae6f787e9@154.53.36.184:26657,e634fbf8800f76cb911d03e665f2e573188147c0@154.53.32.30:26657,a73626491bde964dadf51920a4be234f19ef66eb@34.83.246.177:26656,f04329d75a8874a55dd8456d46e093595ed7653d@194.195.87.106:46656,d2b6baed49aa475eb6ec5958bfbca30a61363b86@154.53.52.212:26657,b57a9c1e7c0f597c9ef6a47cc361094f95a22b84@192.9.134.157:27656,4e4b24d16f7a0da6466478a0c2dee6e3feb02960@46.228.199.29:26656,7b48063c94fc1a131da7254c9b018e0e88c5fe1a@84.46.240.85:26656,ea9612751ee711aca59abe0e82e7a1bfdb9c0499@90.188.88.233:26656,dcb1fb6b92cf96ba993e2d2feae246a02ba2760a@80.65.211.227:26656,e4cd8235602d3f01713b296013106455e165b459@5.78.44.65:26656,3733d4854ca7167e49b9c3c0b9c8f080ec387440@185.215.167.133:26656,78763633b96d442fe64c65606a9a034490d29db9@38.242.153.243:26656,e4ea6ffd9ec8ca5db91506e0429613628f0f61ee@155.133.22.115:26656,2067e672ef241d6364c10b43eec2abc26e36b607@31.187.74.3:26656,82194e13aefec84d36c507e14acbd818a320098d@45.77.8.217:26656,c859c2b1edfaf67ea274726bc0978ef55ebd051a@94.131.111.156:26656,694ef36622642377aec8847df309d1dec708cb28@195.201.197.4:38656,1a580a740df28b3369450567300440811699ccbb@2.58.82.148:26656,7e03768c74d8720852bc807b30c523338d31a458@65.109.198.250:26656,5eecfdf089428a5a8e52d05d18aae1ad8503d14c@65.108.141.109:19656"
SEEDS="3f472746f46493309650e5a033076689996c8881@nibiru-testnet.rpc.kjnodes.com:39659"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/$FOLDER/config/config.toml
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
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025$DENOM\"/" $HOME/$FOLDER/config/app.toml

# Enable snapshots
sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = \"2000\"/" $HOME/$FOLDER/config/app.toml
$BINARY tendermint unsafe-reset-all --home $HOME/$FOLDER --keep-addr-book
curl -L https://snapshots.kjnodes.com/nibiru-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/$FOLDER

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

echo -e "\e[1m\e[31mSETUP FINISHED\e[0m"
echo ""
echo -e "CHECK STATUS BINARY : \e[1m\e[31msystemctl status $BINARY\e[0m"
echo -e "CHECK RUNNING LOGS : \e[1m\e[31mjournalctl -fu $BINARY -o cat\e[0m"
echo -e "CHECK LOCAL STATUS : \e[1m\e[31mcurl -s localhost:${PORT}657/status | jq .result.sync_info\e[0m"
echo ""

# End