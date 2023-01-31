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
echo ">>> Cosmovisor Automatic Installer for Nois Network | Chain CHAIN : mars-1 <<<";
echo -e "\e[0m"

sleep 1

# Variable
SOURCE=full-node
WALLET=wallet
BINARY=noisd
CHAIN=nois-testnet-003
FOLDER=.noisd
VERSION=nois-testnet-003
DENOM=unois
COSMOVISOR=cosmovisor
REPO=https://github.com/noislabs/full-node.git
GENESIS=https://snapshots.polkachu.com/testnet-genesis/nois/genesis.json
ADDRBOOK=https://snapshots.polkachu.com/testnet-addrbook/nois/addrbook.json
PORT=36


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

# Get Node Version from Nois
cd $HOME
rm -rf $SOURCE
git clone $REPO
cd $SOURCE/$SOURCE
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
PEERS="36da8cca159bd1e39c3dd4a4a46494cec4117329@65.109.39.223:26646,ce41e4eda1be4386b245ac3b4f58e1e7de131c1d@143.110.145.124:26656,3a4c18a6fa4847dc0ee8f23e5ed1a02b0c5a3c16@109.123.251.49:26656,c03268a8251752b9f08aeccd29cf8285d4ba827d@65.21.55.133:26656,aba9b1472b4a2aa3b286d775b3526b6a9f282bcb@164.68.102.10:36656,ada67bc5b22ad7c5c864d9fe75c8df963c4e3d5c@142.132.134.112:26756,537dbba901f04711fcabd52f9e1cfdc7d153c027@167.235.155.190:26656,7bdc3730bfd3e1ec9f612d8185587907f959b193@178.211.139.124:30656,10ae194a5f26cabb994db857097d436393415dfb@162.55.223.152:26656,1e01a08400e5280afba98a5073f92c5b98047b02@78.47.72.196:26656,455ddea1312f3586d2428a1ea957f2b0131d80de@178.18.250.73:26656,74fbcf7545698d624cf8ee5c3a04feb8b2b30ebf@38.242.159.151:26656,b8881f643b68beafb4f13832c315ec073eede95a@167.235.128.100:26656,a76edaf9f19604f66c6693ef6472a8847d4d83f4@167.235.130.12:26656,430b67348feec80f37aef9d6e1e3f5914c54e0ed@65.109.106.91:10656,7b77f2f3887973d512080ca21be127da0c90ed62@136.243.88.91:7040,5552e5f87acef896eb6c64e3855d8e8afcb58573@103.146.22.135:26656,49146457c0db43b3e396a96322dd6c6cf57e5e1d@75.119.144.115:26656,a86ec0f849dceac81fa812059c37bcf0d57ba80e@144.76.30.36:15648,57b3a0f3d9323e766c272103ec57c861898d3ba9@176.126.87.155:26656,74232218f8c153a93177b6918db23ffb742c2d8d@38.242.133.200:30656,4a883ac2ba6a7d8d8d23ba0b6e5c428ca38a1872@95.217.224.252:26656,890ad9bb6cccb344e117c81127f2039267c6ec40@213.136.83.234:30656,6175d5ad7ae1b886e09db10635f0250b0950707f@178.170.40.28:15648,053fcec525488f22ef64063f8071731fe0f2b892@65.109.30.197:22656,6385afb7394062f31638ef8552be0bd351196847@194.163.147.24:26656,e441513a55cc5236031c92f92fa6350cc4b63538@116.203.75.32:26656,759f1888778c0e835927409bc28da6d8e8ef8e8a@95.216.241.112:30656,fb2a195ff1a61323245f21297a7d7bc5fb2b2903@38.146.3.230:17356,4dffa9f0c0fd136a2babb31f673322e9b677f3d1@85.239.243.212:26656,28bf9c439854723dfdb9c39fcb11ae7ab3a2c146@64.5.123.230:26656,17c2f5ed65647260d02e962912d0aa99081c0761@65.109.112.36:28656,b3f9d8d0ea81547eb937e8a31b9e76ca6ebe57e8@88.99.161.162:17656,30c4a61abf0d3d8564c9ec6b05627baa5095aefb@149.102.147.157:10656,4b3f0aaa7065d44becd84bf61a6e821a79aa7ae6@95.216.213.171:29656,4ba9cf593d566d7e9df10ef56a4f3133edbcf493@135.181.119.59:30656,2e41cf48ddc31066177db89c41c87d482754ab95@38.242.158.85:26656,48a03a0eea110b412b5f5120260dc3d5864d64d0@88.99.87.164:26656,2bf8002d0f65c3d86fca31ea0f043d912682c3e0@65.109.70.23:17356,3f3a1dc1ad7356757c1b8f3f85e053ab78d1bb5b@34.88.219.142:16656,14b53c488f1ccb223d93a9dc867718e9535ea72b@65.109.86.236:29656,bcce88d57a7efffad5124e413237bb7d06a7367d@80.254.8.54:26656,91b61b45186b263fe369ba083da40e3e9c755e11@194.163.166.191:26656,143ffb1f817b66531cd836f74669b14dea3253c1@85.239.240.78:26656,e7ad29276771d57f01b0379b2055024b2d795b0f@162.55.215.110:26656,46f181439f966881ce044e61d96822ca31dcaa04@162.55.103.44:26646,72cfe08c81253425998ebc31c798dfd484468fe7@65.109.92.148:36656,c66c1dfc3945b1224fe3ffc22e5f80a9651a8c05@135.181.115.115:28656,b2f45dc8cd9e532e838a64e7f433137e0d4c653b@195.201.197.4:30656,d2d2dd4427bde768bbc2701536942b8f1174877e@65.108.77.106:26899,d5240869f95ddd52e4930439d8df4d17dbd1e568@154.12.228.189:26656,911b5d1cafb49cb4e2a96f996d2e21bf4f5253f5@46.17.47.108:26656,112c8f3bfeeb1f3098dfa50724079b5974572e3e@84.46.252.45:60556,f5971b0e1a004f2237b8f49f28631fe541320e97@89.117.50.54:26656,8b7661181576bf5f2d62d6d9e7109f5cb7f82e16@38.242.198.47:26656,15452c7073f07c7968eae09d912c0959c02a08ce@159.69.241.163:26656,d62d18c485150653d81dbb18cc53bfd7c252d9c7@45.135.92.85:46656,cdba91aaa12cb7179039590e2ba26a9c22fd578e@65.108.69.68:27060,3a96fcc97e2e470c6605a90c41e18377f01242ce@185.9.187.123:36656,7e9493109df3a41a6f8668b8cb64199d708b05dd@65.21.122.171:46656,fdf80fc0718ffa5858df24ca72fe000a97f3bca7@5.161.84.1:26656,2cdd238ef97c5eef03ba9604e84f62977d53d40c@159.69.85.97:26656,221f759295e000ee288fd8cc99f42b5ae8a146c2@116.203.218.83:26656,bceb8f8a96767af80621a7b1b36037b7c20ded25@144.91.113.237:26656,1e8dc478fbb75e27abf3d19ef063e17c95f1b4b4@65.21.243.117:26656,cf1a7c5a9426d898784d2d0bd11cb8da134db147@159.69.209.136:26656,7ea2ddf751659d184f544233808e4f508d80e3f2@161.97.170.126:26656,f7c0a82105152107c0e516056d0672d01a3a8582@88.99.56.200:26656,e404458d4e10704c3ff2e927bbd622fd027a2867@159.69.32.73:26656,035a4018f49d5ca788a40bfe909bc329d6647462@168.119.120.76:26656,0f329b772cfae2c983665adcc4d5a0148d536b81@217.76.62.84:26656,3e21a87d60297450eff2b7b4c1332c3cdc3f3fa0@65.21.239.60:30656,239ac78ab3fd7ce82a2b033343b6ba0b7a3d3a04@65.108.194.40:26456,e102d6c0fc8c2210cb80762339a346a41c490e59@51.195.88.136:15648,2fd09098fe74fb45d1fe1d5aca190df6c9eeefd1@65.108.75.32:30656,88b5d5c5a607c2dd87dd3eb2062a0374bd032d9d@135.181.249.17:26656,a60bad8c42b39e91d3bfd529cbf95de766f24f08@65.108.85.61:26656,976d95adec7f0d7fda4464df019fa538fa0bb4ce@144.76.97.251:32656,a985b80dec068989023f0b8377a936e897a29bc2@95.217.180.108:26656,4f4cbbb89deacb0a1f395050567e96bb70f4a1ff@142.132.152.46:41656,e60f5d43bdb8e0faf5658edb392e47ab74162b98@65.109.112.20:11104,eb79a970941aa801897538ffcd30195131eceac5@38.242.147.10:30656,a345a27ec850dae483dc371cb5d04ad1a551f61e@89.163.219.202:26656,a4dffdd62280efe164634136086c0b1e9aceb2c4@65.108.43.116:56122,380e5b6130602968eaea3a1583bc118a9360001f@144.76.201.43:26056,e81e7508db2dfb1a6f545cc8336d94eeb3da47f7@75.119.131.67:36656,83b5ac9ab3acff1ab9177fc4a14d87906f234fbf@95.217.118.100:29656,fbafee5e74fdde8004ae9abfa6d522cfe4be4a56@217.76.61.255:26656,e51eafc9029f99732d908a75cb3d21e3473c7a8d@65.108.49.185:26656,102895b85acd8e154ac36ff5553ddafcb3cfa991@94.130.175.97:26656,afd9b89b05b676839a705e1090a45ebec198e639@23.88.118.2:26656,e2e2e77ef9a8825c8daeb51c7a62be29b1ba3dd6@208.87.129.144:30656,b53c1a44382323407de26610387543ee486289ee@23.88.58.195:26656,55a379d6339221a65d697fb469a2ed6ca2ab1e6f@94.130.16.254:36656,df787a94b5f153309e3010b151e950f902d4c715@142.132.151.35:15648,349ded9fd597700412d61984662582fc463fc0a9@213.239.215.77:17656,5ff8e950134c47efebcc5ce111aac2da674eb988@65.109.34.133:60656,da81dd66bca4bba509163dbd06b4a6b2e05c2e12@65.108.231.124:21656,1bb3ce99910418e25ac72bc85eeb540b41a69098@135.181.248.188:26656"
SEEDS="ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@testnet-seeds.polkachu.com:17356"
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
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.05$DENOM\"/" $HOME/$FOLDER/config/app.toml

# Enable snapshots
sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = \"2000\"/" $HOME/$FOLDER/config/app.toml
$BINARY tendermint unsafe-reset-all --home $HOME/$FOLDER --keep-addr-book
SNAP_NAME=$(curl -s https://snapshots.polkachu.com/testnet-snapshots/nois/ | egrep -o ">nois*\.tar.lz4" | tr -d ">")
curl -o - -L https://snapshots.polkachu.com/testnet-snapshots/nois/${SNAP_NAME}  | lz4 -c -d - | tar -x -C $HOME/$FOLDER

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