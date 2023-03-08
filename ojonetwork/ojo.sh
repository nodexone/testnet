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
GENESIS=https://snapshots.kjnodes.com/ojo-testnet/genesis.json
ADDRBOOK=https://snapshots.kjnodes.com/ojo-testnet/addrbook.json
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

# Get testnet version of Ojo
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
PEERS="5af3d50dcc231884f3d3da3e3caecb0deef1dc5b@142.132.134.112:25356,c43c0b1197f60cde53cb94b18d05a8d64d71a72a@162.55.245.219:50656,2c40b0aedc41b7c1b20c7c243dd5edd698428c41@138.201.85.176:26696,7d6706d7ee674e2b2c38d3eb47d85ec6e376c377@49.12.123.87:56656,3832f6d02addadfe4acfbd1a87ccc009642a348e@195.46.165.3:26656,3de750927e66b01bb566c1c189beeb43b7cde73f@213.239.216.252:47656,ffe2d5ecb614762d5a1723f5f8b00d3feb6eb091@5.9.13.234:26686,0465032114df76df206c9983968f2d229b3a50d6@88.198.32.17:39656,b6b4a4c720c4b4a191f0c5583cc298b545c330df@65.109.28.219:21656,9dc1f555bd37d6840237f32a2cd4d79ba1c80cb5@65.108.227.112:31656,a3a9014f82cb69fe0494ea3bc49990027d081a5a@65.108.126.35:36656,f474a520009496972515f843cdb835fc7d663779@65.109.23.114:21656,239caa37cb0f131b01be8151631b649dc700cd97@95.217.200.36:46656,13b4b70206dc95be5e3ec3c511c0441c4354fc96@91.148.132.72:26656,7416a65de3cc548a537dbb8bdf93dbd83fe401d2@78.107.234.44:26656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:50656,b133dde2713a216a017399920419fcb1e084cdb2@136.243.88.91:7330,d5b2ae8815b09a30ab253957f7eca052dde3101d@65.108.9.164:24656,1145755896d6a3e9df2f130cc2cbd223cdb206f0@209.145.53.163:29656,fbeb2b37fe139399d7513219e25afd9eb8f81f4f@65.21.170.3:38656,8671c2dbbfd918374292e2c760704414d853f5b7@35.215.121.109:26656,315350f9d96426d4a025dbdecae84ceca64d1638@95.217.40.230:56656,124439d1c16b1ee7ca1a39961f02fadf8539cb81@38.102.85.10:26656,52c0f3b75686533f43d9addf36fe7408a7fca5e9@65.108.43.58:27675,bef511f2c5244e6603bd74295e2dffb126d04f41@158.101.208.86:26656,f6d6e625759814e157457a5889961e02dba26ba6@65.109.92.240:37096,9edc978fd53c8718ef0cafe62ed8ae23b4603102@136.243.103.32:36656,9bcec17faba1b8f6583d37103f20bd9b968ac857@38.146.3.230:21656,ac5089a8789736e2bc3eee0bf79ca04e22202bef@162.55.80.116:29656,a152e79211b74f1de2fbf32da2e5e6f062b2ae56@23.121.249.57:26656,cd4d7ffdad8bd258cd90c22ec7197c0fdf9f3648@38.242.134.73:27656,567b2c55ec74f07ed24a3f286922b199d62f3d8c@81.0.219.36:36656,cb706ebe1d7a1f1d3e281bf46a78d84251f50810@95.216.14.72:26656,3ae9b1f545cb78a361971259cbeff41341fabb3c@65.108.97.58:2626,8fbfa810cb666ddef1c9f4405e933ef49138f35a@65.108.199.120:54656,bf834f428aed19dd1937d66327cb6244d7722b0d@65.108.201.189:26676,3c8b9cf60b33bdd8b41db6d8af1009e91e14afc8@5.78.67.243:26656,34a4c8433adfc4bf0df7c085ce58ed48664fbdc1@85.10.193.246:31656,3c6384ae2a167912a5ace2f5f8e38afc559715f0@75.119.156.88:26656,340f0623e9338a5c93baf2d8a8825718a86d3e8b@195.3.223.196:26656,323d4309091003ea96ec3076b8bf4dc319c71345@109.205.182.137:26656,11bb322f6396a1ca67717cf162385ed250503e28@154.12.253.123:36656,dc19e5d986ea79e70180cfbee7789de9cd79e14e@95.217.57.232:56656,5c2a752c9b1952dbed075c56c600c3a79b58c395@195.3.220.136:27226,0ccc4bd8386fbec1421e3c19c24124eeb00b3293@46.101.144.90:28656,0d4dc8d9e80df99fdf7fbb0e44fbe55e0f8dde28@65.108.205.47:14756,c0ee71c74858b339787320596b805ed631c48ebb@213.133.100.172:27433,3a9c8c2c04e6ef9fbc4e5a276724cedba252516c@185.246.86.50:26656,4c735cd1a6eda031866beb6ac5440c4a645dee57@45.94.58.246:34656,c2f1a2474219cdd314e271429b415732261ebaa3@148.251.19.197:26666,4764a447ea3518e5017756b42ca5f6442b2f5768@5.161.114.1:26656,b0968b57bcb5e527230ef3cfa3f65d5f1e4647dd@35.212.224.95:26656,dacdb802de389deb5ccf9100e049209f55f62854@188.40.98.169:29656,8036aed2d37890ddf245e7288b4fc724a301d728@65.109.117.23:50656,3a2c9a7631c26006a5d1943c004ab2da8c04d7b7@5.161.201.79:26656,d2beb0153f6ee3d2a5a90f96848c71bff2b25eb0@65.109.90.171:36656,d6b0791afd2d41c47bce8c152174b40c230988ba@138.201.225.104:47756,7186f24ace7f4f2606f56f750c2684d387dc39ac@65.108.231.124:12656,a4d48a69d1dcece4cb6a836322a0ab54e39f8816@65.109.88.180:10656,1e2a49792b0e0686827ec0fbc101a9ad709e0f28@88.210.9.78:26656"
SEEDS="3f472746f46493309650e5a033076689996c8881@ojo-testnet.rpc.kjnodes.com:50659"
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
curl -L https://snapshots.kjnodes.com/ojo-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/$FOLDER

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