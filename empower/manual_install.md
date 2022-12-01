<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/166676803-ee125d04-dfe2-4c92-8f0c-8af357aad691.png">
</p>

# Manual node setup
If you want to setup fullnode manually follow the steps below

## Setting up vars
Here you have to put name of your moniker (validator) that will be visible in explorer
```
NODENAME=<YOUR_MONIKER_NAME_GOES_HERE>
```

Save and import variables into system
```
echo "export NODENAME=$NODENAME" >> $HOME/.bash_profile
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export EMPOWER_CHAIN_ID=altruistic-1" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

## Update packages
```
sudo apt update && sudo apt upgrade -y
```

## Install dependencies
```
sudo apt install curl build-essential git wget jq make gcc tmux -y
```

## Install go
```
if ! [ -x "$(command -v go)" ]; then
  ver="1.18.3"
  cd $HOME
  wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
  rm "go$ver.linux-amd64.tar.gz"
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
  source ~/.bash_profile
fi
```

## Download and build binaries
```
cd $HOME
git clone https://github.com/empowerchain/empowerchain.git
cd empowerchain/chain
make install
empowerd version --long | head
```

## Config app
```
empowerd config chain-id $EMPOWER_CHAIN_ID
empowerd config keyring-backend test
```

## Init app
```
empowerd init $NODENAME --chain-id $EMPOWER_CHAIN_ID
```

## Download genesis and addrbook
```
rm -rf $HOME/.empowerchain/config/genesis.json && cd $HOME/.empowerchain/config && wget https://raw.githubusercontent.com/empowerchain/empowerchain/main/testnets/altruistic-1/genesis.json
empowerd tendermint unsafe-reset-all --home $HOME/.empowerchain
wget -qO $HOME/.empowerchain/config/genesis.json "https://raw.githubusercontent.com/nodexcapital/testnet/main/empower/addrbook.json"
```

## Set seeds and peers
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0umpwr\"/" ~/.empowerchain/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.empowerchain/config/config.toml
external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.empowerchain/config/config.toml

peers="9de92b545638f6baaa7d6d5109a1f7148f093db3@65.108.77.106:26656,4fd5e497563b2e09cfe6f857fb35bdae76c12582@65.108.206.56:26656,fe32c17373fbaa36d9fd86bc1146bfa125bb4f58@5.9.147.185:26656,220fb60b083bc4d443ce2a7a5363f4813dd4aef4@116.202.236.115:26656,225ad85c594d03942a026b90f4dab43f90230ea0@88.99.3.158:26656,2a2932e780a681ddf980594f7eacf5a33081edaf@192.168.147.43:26656,333de3fc2eba7eead24e0c5f53d665662b2ba001@10.132.0.11:26656,4a38efbae54fd1357329bd583186a68ccd6d85f9@94.130.212.252:26656,52450b21f346a4cf76334374c9d8012b2867b842@167.172.246.201:26656,56d05d4ae0e1440ad7c68e52cc841c424d59badd@192.168.1.46:26656,6a675d4f66bfe049321c3861bcfd19bd09fefbde@195.3.223.204:26656,1069820cdd9f5332503166b60dc686703b2dccc5@138.201.141.76:26656,277ff448eec6ec7fa665f68bdb1c9cb1a52ff597@159.69.110.238:26656,3335c9458105cf65546db0fb51b66f751eeb4906@5.189.129.30:26656,bfb56f4cb8361c49a2ac107251f92c0ea5a1c251@192.168.1.177:26656,edc9aa0bbf1fcd7433fcc3650e3f50ab0becc0b5@65.21.170.3:26656,d582bcd8a8f0a20c551098571727726bc75bae74@213.239.217.52:26656,eb182533a12d75fbae1ec32ef1f8fc6b6dd06601@65.109.28.219:26656,b22f0708c6f393bf79acc0a6ca23643fe7d58391@65.21.91.50:26656,e8f6d75ab37bf4f08c018f306416df1e138fd21c@95.217.135.41:26656,ed83872f2781b2bdb282fc2fd790527bcb6ffe9f@192.168.3.17:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.empowerchain/config/config.toml

seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.empowerchain/config/config.toml

sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 100/g' $HOME/.empowerchain/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 100/g' $HOME/.empowerchain/config/config.toml

```

## Disable indexing
```
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.empowerchain/config/config.toml
```

## Config pruning
```
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.empowerchain/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.empowerchain/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.empowerchain/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.empowerchain/config/app.toml
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.empowerchain/config/config.toml
```

## Set minimum gas price
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0umpwr\"/" $HOME/.empowerchain/config/app.toml
```

## Enable prometheus
```
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.empowerchain/config/config.toml
```

## Create service
```
sudo tee /etc/systemd/system/empowerd.service > /dev/null <<EOF
[Unit]
Description=deweb
After=network-online.target

[Service]
User=$USER
ExecStart=$(which empowerd) start --home $HOME/.empowerchain
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

## Register and start services
```
sudo systemctl daemon-reload
sudo systemctl enable empowerd
sudo systemctl restart empowerd && sudo journalctl -u empowerd -f -o cat
```