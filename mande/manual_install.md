<strong><p style="font-size:14px" align="left">Founder :
<a href="https://discord.gg/JqQNcwff2e" target="_blank">NodeX Capital Discord</a></p></strong>
<strong><p style="font-size:14px" align="left">Visit Our Website : 
<a href="https://nodex.codes/" target="_blank">https://nodex.codes</a></p></strong>
<strong><p style="font-size:14px" align="left">Follow Me :
<a href="https://twitter.com/nodexploit/" target="_blank">NodeX Twitter</a></p></strong>
<hr>

<p align="center">
 <img height="250" height="auto" src="https://user-images.githubusercontent.com/34649601/195998836-4f64c191-0a50-4819-a623-a2e9fb84901b.png">
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
echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export MANDE_CHAIN_ID=mande-testnet-1" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

## Update packages
```
sudo apt update && sudo apt upgrade -y
```

## Install dependencies
```
sudo apt install curl tar wget tmux htop net-tools clang pkg-config libssl-dev jq build-essential git make ncdu -y
```

## Install go
```
ver="1.19" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile && \
go version
```

## Download and build binaries
```
cd $HOME
curl -OL https://github.com/mande-labs/testnet-1/raw/main/mande-chaind
mv mande-chaind /usr/local/bin
chmod 744 /usr/local/bin/mande-chaind
```

## Config app
```
mande-chaind init $MANDE_CHAIN_ID
mande-chaind config keyring-backend test
```

## Init app
```
mande-chaind init $NODENAME --chain-id $MANDE_CHAIN_ID
```

## Download genesis and addrbook
```
wget -O $HOME/.mande-chain/config/genesis.json "https://raw.githubusercontent.com/mande-labs/testnet-1/main/genesis.json"
wget -O $HOME/.mande-chain/config/addrbook.json "https://raw.githubusercontent.com/obajay/nodes-Guides/main/Mande%20Chain/addrbook.json"
```

## Set seeds and peers
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0mand\"/;" ~/.mande-chain/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.mande-chain/config/config.toml
peers="cd3e4f5b7f5680bbd86a96b38bc122aa46668399@34.171.132.212:26656,6780b2648bd2eb6adca2ca92a03a25b216d4f36b@34.170.16.69:26656,a3e3e20528604b26b792055be84e3fd4de70533b@38.242.199.93:24656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.mande-chain/config/config.toml
seeds="cd3e4f5b7f5680bbd86a96b38bc122aa46668399@34.171.132.212:26656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.mande-chain/config/config.toml
```

## Disable indexing
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.mande-chain/config/config.toml
```

## Config pruning
```
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" ~/.mande-chain/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" ~/.mande-chain/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" ~/.mande-chain/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" ~/.mande-chain/config/app.toml
```

## Create service
```
sudo tee /etc/systemd/system/mande-chaind.service > /dev/null <<EOF
[Unit]
Description=mande-chaind
After=network-online.target

[Service]
User=$USER
ExecStart=$(which mande-chaind) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

## Register and start service
```
sudo systemctl daemon-reload
sudo systemctl enable mande-chaind
sudo systemctl restart mande-chaind && sudo journalctl -u mande-chaind -f -o cat
```