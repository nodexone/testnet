#
# // Copyright (C) 2023  Salman Wahib Recoded By NodeX Capital
#

echo -e "\033[0;35m"
echo " ███╗   ██╗ ██████╗ ██████╗ ███████╗██╗  ██╗     ██████╗ █████╗ ██████╗ ██╗████████╗ █████╗ ██╗     ";
echo " ████╗  ██║██╔═══██╗██╔══██╗██╔════╝╚██╗██╔╝    ██╔════╝██╔══██╗██╔══██╗██║╚══██╔══╝██╔══██╗██║     ";
echo " ██╔██╗ ██║██║   ██║██║  ██║█████╗   ╚███╔╝     ██║     ███████║██████╔╝██║   ██║   ███████║██║     ";
echo " ██║╚██╗██║██║   ██║██║  ██║██╔══╝   ██╔██╗     ██║     ██╔══██║██╔═══╝ ██║   ██║   ██╔══██║██║     ";
echo " ██║ ╚████║╚██████╔╝██████╔╝███████╗██╔╝ ██╗    ╚██████╗██║  ██║██║     ██║   ██║   ██║  ██║███████╗";
echo " ╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝     ╚═════╝╚═╝  ╚═╝╚═╝     ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝";
echo ">>> Cosmovisor Automatic Installer for Babylon | Chain ID : bbn-test1  <<<";
echo -e "\e[0m"

sleep 1

# Variable
SOURCE=babylon
WALLET=wallet
BINARY=babylond 
CHAIN=bbn-test1
FOLDER=.babylond
VERSION=v0.5.0
DENOM=ubaby
COSMOVISOR=cosmovisor
REPO=https://github.com/babylonchain/babylon.git
#GENESIS=https://raw.githubusercontent.com/sxlzptprjkt/resource/master/testnet/babylon/genesis.json
#ADDRBOOK=https://snapshots1-testnet.nodejumper.io/babylon-testnet/addrbook.json
PORT=243

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

# Get testnet version of Babylon
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

# Set peers and seeds
PEERS="88bed747abef320552d84d02947d0dd2b6d9c71c@babylon-testnet.nodejumper.io:44656,539bbebeb0d13ac22db640b102235f7e4f00856d@104.244.208.243:20656,a4f76dddb6bdb195a0e49be82a3fd789d98631df@65.109.85.170:55656,af6104a6cc151aa645f933ea28cba1d5b0f7dbfd@213.239.216.252:41656,2c06e6d7ae970824dd3da1ac352c6f2fa6bb9f4b@38.242.241.126:26656,c48276582fbd884a57bd481d2b5c1503c7b73e92@54.224.66.12:26656,b531acac8945962606025db892d86bb0bf0872af@3.93.71.208:26656,ed9df3c70f5905307867d4817b95a1839fdf1655@154.53.56.176:27656,cd9d96f554e7298a8d1f1a94489f7a51520f01ff@142.132.152.46:47656,e3f9ccbfc86011bb2bd6c2756b2c8b8dc4c8eb97@54.81.138.3:26656,d54157138c8b26d8eabf4b0d9e01b2b5d9e38267@54.234.206.250:26656,617b10a9ea1c97b8230ccb70e1fb4ecef1b46601@18.212.224.149:26656,b82a215dd0eec07ad2e5e451fc97f2bd6ce61140@92.100.157.81:26656,1400847b76e57c13e49ff1bfbcce7e71865dde7f@65.109.92.240:17896,ad3684076dc5c514bd4ba847203b2c1900d48ead@82.65.197.168:26656,57561b59f971773e19dbb0635203d6909c3e3dbe@27.72.126.82:26656,ca7bffa119704c7666a7ae10e7d17e5a2f857071@65.109.106.179:20656,c15ea9cfa8928886c2d2a573bc20f14871168b22@185.242.112.143:16655,1d0c78d6945ac4007dafef2a130e532c07b806d2@65.108.105.48:20656,322113757332da320c929bc444eb89c326c7b1d7@219.100.163.45:46656,49cdcda3061fd1b467c6a5c29f56b85653e807f2@94.131.106.139:26656,42dd05c43fa9e51cfabc6a2ab0afa9044b123cc6@34.201.34.29:26656,b4ccb4af8c4e226e5844065197dfbe013690758b@65.108.233.220:14656,f136d7e7788c8e9c9c4784703f158029ffdb70b5@65.108.200.248:55706,5fd378bc1490dfd582fb6d32de3c02e743047811@195.14.6.2:26656,b10105846b4f9086b9f9245df4841a4bb7c6ba7b@65.108.197.169:14656,b2c3a12aba7cbfa34cdb45a5b6f133fb7f251817@65.109.85.225:4310,c2bc08c7b0292f7072b1530ffc03ebf69563f518@95.216.39.183:27656,6b119389edad95d8aa29d4c95be15ed4612149d3@185.215.165.0:46656,b068b6464f706e53c8cdbbbdf964477f9a589c6a@65.108.237.233:31656,c2abdd62b87e83d4ca9cf5427e3d9dd71f53cc6d@148.113.159.123:36656,59145b3a427f5bb50fc54c0125a54b31bc580f6d@185.188.249.17:26656,0100cbf147f512b81cd01268463bd71ab3e55138@65.109.85.226:4310,7cf424ff2939501d9ab9296889e5ab66c826527a@65.109.85.221:4310,c4c473143dc8b1a26cf62074572e501b6444aed8@193.203.15.130:26656,a5fabac19c732bf7d814cf22e7ffc23113dc9606@34.238.169.221:26656,03ce5e1b5be3c9a81517d415f65378943996c864@18.207.168.204:26656,b53302c8887d4bd57799992592a2280987d3f213@95.217.144.107:20656,a8051774e809d8dc14673bb245abc0fc48a3f684@5.9.122.49:14656,87b3d99aaa2134815fd8ce389011407c6d4ddd8f@42.117.66.62:26656,c1406917c620090ae59f7301c7b3c9d1864d91cb@85.10.192.146:26656,c07d98676bfbf8fa28bbca82532a3a4841930500@185.246.86.63:26666,3c1ea2ec5ffb8a91649e375d3513774bf47853c1@65.109.92.148:61556,5c2a752c9b1952dbed075c56c600c3a79b58c395@195.3.220.135:27116"
sed -i 's|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/$FOLDER/config/config.toml
SEEDS="03ce5e1b5be3c9a81517d415f65378943996c864@18.207.168.204:26656,a5fabac19c732bf7d814cf22e7ffc23113dc9606@34.238.169.221:26656"
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/$FOLDER/config/config.toml

# Download genesis and addrbook
touch $HOME/$FOLDER/config/genesis.json

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
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0$DENOM\"/" $HOME/$FOLDER/config/app.toml

# Enable snapshots
 sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = \"2000\"/" $HOME/$FOLDER/config/app.toml

# Set key name
sed -i 's|^key-name *=.*|key-name = "val-key"|g' $HOME/$FOLDER/config/app.toml

# Set checkpoint tag
sed -i 's|^checkpoint-tag *=.*|checkpoint-tag = "bbn0"|g' $HOME/$FOLDER/config/app.toml

# Set timeout commit
sed -i 's|^timeout_commit *=.*|timeout_commit = "10s"|g' $HOME/$FOLDER/config/config.toml

# State Sync
cp $HOME/$FOLDER/data/priv_validator_state.json $HOME/$FOLDER/priv_validator_state.json.backup
$BINARY tendermint unsafe-reset-all --home $HOME/$FOLDER --keep-addr-book

SNAP_RPC="https://rpc-babylon.sxlzptprjkt.xyz:443"
STATESYNC_PEERS="4ffd7f9202c58df4afec210f22da732023e476c8@46.101.144.90:24656"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/$FOLDER/config/config.toml
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$STATESYNC_PEERS\"|" $HOME/$FOLDER/config/config.toml

mv $HOME/$FOLDER/priv_validator_state.json.backup $HOME/$FOLDER/data/priv_validator_state.json

mv $HOME/$FOLDER/priv_validator_state.json.backup $HOME/$FOLDER/data/priv_validator_state.json

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
echo -e "CHECK LOCAL STATUS : \e[1m\e[35mcurl -s localhost:${PORT}57/status | jq .result.sync_info\e[0m"
echo ""

# End