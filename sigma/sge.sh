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
echo ">>> Cosmovisor Automatic Installer for SGE Network | Chain ID : sge-testnet-1 <<<";
echo -e "\e[0m"

sleep 1

# Variable
SOURCE=sge
WALLET=wallet
BINARY=sged
CHAIN=sge-testnet-1
FOLDER=.sge
VERSION=v0.0.3
DENOM=usge
COSMOVISOR=cosmovisor
REPO=https://github.com/sge-network/sge
GENESIS=https://snapshots.nodeist.net/t/sge/genesis.json
ADDRBOOK=https://snapshots.nodeist.net/t/sge/addrbook.json
PORT=43


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
echo -e "YOUR NODE NAME : \e[1m\e[35m$NODENAME\e[0m"
echo -e "NODE CHAIN CHAIN  : \e[1m\e[35m$CHAIN\e[0m"
echo -e "NODE PORT      : \e[1m\e[35m$PORT\e[0m"
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

# Get binary

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
PEERS="971643c5b9f9d279cfb7ac1b14accd109231236b@65.108.15.170:26656,59d5ea1fa1f00b0004c2f9a4e4e480a33ddb86ad@159.223.47.239:26656,4a3f59e30cde63d00aed8c3d15bef46b34ec2c7f@50.19.180.153:26656,5331759e82bfb4087c1f1f4f917f0eb91e50a3a6@35.174.81.173:26656,5fa826f6bcac945ef5395c5ea727e0b98dfc0aa0@65.109.92.148:60756,d35d51132a4a8a9ea219c542fab04f8eea4d589c@65.108.205.47:26659,1bedc9234b0f1a2925af825b977fc0b84faa5e9d@35.222.198.228:2516,4bf08e4d92c34ac16fefc808595cdcbab3d088e4@161.97.169.203:26656,aa7da79247bc7f66993adc5bced6396466390ce7@52.22.148.61:26656,c856d937e603d6b6fc6de644e9ed518ed2c1a9c1@75.119.141.169:26656,787794ac9339057d84b07af32f3a83026020c8db@2.58.82.212:26656,12450c4223a2d6dcfbe5e9b9998cb67634cd2465@38.146.3.193:26656,02a055a6d0ead952275d8dfacd22e4b8befc54bf@84.46.252.45:36656,369f42c6739d1b9c27bf71eb8ac7c1f3ab1bb5e7@194.163.175.127:51656,c0f7c9cfe439083233c908cbf941760bbc0d05f8@213.239.215.77:26656,7811408e877dd68732c9307c5b16c3cb18b2dffb@213.239.216.252:26656,822287349f25bf416207a07d6a74724c248fa0bb@65.109.92.241:26656,54bcfe364b1f75bbbc0cc05b178d4cf17ad77705@46.175.149.143:36656,f5a0e38d161382343458414b5641f1023ac254a0@95.217.58.111:26656,d79b994f1a31a59af7fcf89bba512d0c9afdc06d@94.130.219.37:26000,924147ddd0a113db5efd525705db96a186061907@65.108.151.6:2516,5c240add1ea545da7082616d4fb7276371f0bf66@94.250.201.130:26656,d87e0125c9c9c3b58f3f582f3e71f83c2e4ffb0a@44.197.238.2:26656,788bb7ee73c023f70c41360e9014544b12fe23f9@3.15.209.96:26656,a05353fe9ae39dd0edbfa6341634dec781d84a5c@65.108.105.48:17756,8efa579111aa78e4d769a3a534d34486a97304a3@95.217.224.252:26656,9ea4cf71a831811b0a2fc68335231461d689a0cb@2.58.82.231:26656,8efece89a6fe7b1b4063b206a52d7dfca29e40ae@142.132.248.253:22656,95fb63fbf8ac2647fc4e6c9f73fd6db736bb28ed@52.55.235.60:26656,54a8753f7db180701490e7b311286a57a36d7fbd@168.119.124.130:51656,1168931936c638e92ea6d93e2271b3fe5faee6d1@148.113.143.134:26656,790793b309bf9830b9d5583eca1ba2b59b3df7a4@5.196.7.58:26676,413128504de36317e3bf000073aa3165351e0d52@44.197.179.40:26656,6d2cb0adbe78ebe079b444093a954494ff320754@159.223.116.159:51656,da15db084911f8fed2425e61210a49356e160712@23.121.249.57:26656,cfa86646e5eb05e111e7dde27750ff8ebe67d165@89.117.56.126:23956,90c9fd3a50f22620d941f50ac9dc7f1f7f944e4f@161.97.74.88:36656,9f6fbbc82c85266cee8f4a224e981e0cb16c6914@130.185.119.243:26656,7215e1bbeb787e1b5311019067f507778b31b1ae@185.163.127.158:26656,07fc54214e4f162d5d94607c83d2d6e0b256f161@52.44.14.245:26656,ba53d4c995f06e5fb1871cd8b911e61bd93bbc35@23.88.97.57:26656,2f85b562a60aa2e46f3a25b0f0e6303386583128@86.48.0.236:51656,eb61070abccf341053177285c2e0bc4ef8cd7a79@217.13.223.167:46656,8a7d722dba88326ee69fcc23b5b2ac93e36d7ff2@65.108.225.158:17756,540a32db01936e2567089134857ebc0184157254@80.82.215.19:2516,1be82c49c230efaf584223391784c6fadfe6a1f2@109.123.244.56:26646,27f0b281ea7f4c3db01fdb9f4cf7cc910ad240a6@209.34.205.57:26656,63bbd5d4bfdc9de44b6a1759d64eb994bac77388@38.242.151.79:26656,9adb2e3097febc3fc6edeb35291d6c49edb5c682@88.99.164.158:1156,bc8b7ce47f578d263b7f8b2a661f4202806f4e88@194.163.162.155:51656"
SEEDS=""
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
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0$DENOM\"/" $HOME/$FOLDER/config/app.toml

# Enable snapshots
sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = \"2000\"/" $HOME/$FOLDER/config/app.toml
$BINARY tendermint unsafe-reset-all --home $HOME/$FOLDER --keep-addr-book
curl -L https://snap.nodeist.net/t/sge/sge.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/$FOLDER

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
echo -e "CHECK LOCAL STATUS : \e[1m\e[35mcurl -s localhost:${PORT}657/status | jq .result.sync_info\e[0m"
echo ""

# End