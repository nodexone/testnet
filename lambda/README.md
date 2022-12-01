
<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<hr>

<p align="center">
 <img height="150" height="auto" src="https://docs.lambda.im/lambda-logo.png">
</p>

# Official Links
### [Official Document](https://docs.lambda.im/validators/mainnet.html)
### [Lambda Official Website](https://www.lambda.im/)

## Minimum Requirements 
- 4 or more physical CPU cores
- At least 500GB of SSD disk storage
- At least 32GB of memory (RAM)
- At least 100mbps network bandwidth

# Install Node Guide (Mainnet)

### Update Packages and Depencies
```
sudo apt update && sudo apt upgrade -y
```

Install Depencies
```
sudo apt install curl tar wget tmux htop net-tools clang pkg-config libssl-dev jq build-essential git make ncdu -y
```

### Install GO
```
version="1.19.2" \
&& cd $HOME \
&& wget "https://golang.org/dl/go$version.linux-amd64.tar.gz" \
&& sudo rm -rf /usr/local/go \
&& sudo tar -C /usr/local -xzf "go$version.linux-amd64.tar.gz" \
&& rm "go$version.linux-amd64.tar.gz" \
&& echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile \
&& source $HOME/.bash_profile
```

### Download and install Binaries
```
git clone https://github.com/LambdaIM/lambdavm.git
cd lambdavm
make install
```

### Init
```
lambdavm init <MONIKER> --chain-id lambda_92000-1
```
Replace `<MONIKER>` To your moniker

### Config
```
lambdavm config chain-id lambda_92000-1
```

### Wallet
Create new wallet 
```
lambdavm keys add <WALLET>
```
Recover existing wallet
```
lambdavm keys add <WALLET> --recover
```
Replace `<WALLET>` with whatever wallet name you like

### Set Minimum gas price and timeout commit
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.01ulamb\"/;" $HOME/.lambdavm/config/app.toml
sed -i -e "s/^timeout_commit *=.*/timeout_commit = \"2s\"/" $HOME/.lambdavm/config/config.toml
```

### Pruning (OPTIONAL)
```
pruning="custom" && \
pruning_keep_recent=100 && \
pruning_keep_every=0 && \
pruning_interval=10 && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.lambdavm/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.lambdavm/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.lambdavm/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.lambdavm/config/app.toml
```

### Set Peers
```
peers="2c4f8e193fd10ab3a2bc919b484fd1c78eceffb3@13.213.214.88:26656,b772a0a8a8ee52c12ff0995ebb670a17db930489@54.225.36.85:26656,277b04415ee88113c304cc3970c88542d6d8f5d3@51.79.91.32:26656,a4ad9857ac5efdd75ec94875b19dd2f0bf562bde@47.75.111.113:26656,13e0e58efbb50df4dc5d39263bda1e432fe204f7@13.229.162.168:26656,ed4fd7dafd7df21f7152d38ee729ec33f505793d@54.254.224.222:26656,53e1c5f1783e839b1b1b51ae57ed2f05b9cdb4f3@13.229.27.15:26656,829503936e022119ce5e9cebf23c8e3a694c70f7@34.159.41.156:26656,d475be798a3b8d9eceb56b5cb276ff75d515cb7b@38.242.215.240:26656,d5bc2c509d730b5211f1e2f4cc95ffbbb6eb6944@194.163.164.52:26656,975afec2ce27ef21eea9d512f68eac8487680b09@135.181.72.187:12123,5a7e747884d496aec70495a767431410edb02167@149.102.139.69:26656,7f07d54901170270d7e7568481867535a363a1d5@65.108.129.104:26656,b029580f30c612176c81df200cf724836bba93c5@49.235.92.21:26656,b2cfe9fa02d93f3fa27cdb45272b5dcf3a075985@138.201.141.76:04656,bdeb4b00fe23900b323a3040a30b81e3c8f82803@23.88.69.167:26989"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" ~/.lambdavm/config/config.toml
```

### Set Indexer (OPTIONAL)
```
indexer="null" && sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.lambdavm/config/config.toml
```

### Set Genesis
```
wget https://raw.githubusercontent.com/LambdaIM/mainnet/main/lambda_92000-1/genesis.json
mv genesis.json ~/.lambdavm/config/
```

### Create Service file
```
sudo tee /etc/systemd/system/lambdavm.service > /dev/null <<EOF
[Unit]
Description=lambdavm
After=network-online.target
[Service]
User=$USER
ExecStart=$(which lambdavm) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```

### Start your node
```
sudo systemctl daemon-reload && sudo systemctl enable lambdavm && sudo systemctl restart lambdavm && sudo journalctl -u lambdavm -f -o cat
```

### State-Sync (OPTIONAL)
To Sync your node in minutes
```
SNAP_RPC="https://rpc.lambda.nodestake.top:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sudo systemctl stop lambdavm
lambdavm tendermint unsafe-reset-all --home ~/.lambdavm/

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" ~/.lambdavm/config/config.toml

more ~/.lambdavm/config/config.toml | grep 'rpc_servers'
more ~/.lambdavm/config/config.toml | grep 'trust_height'
more ~/.lambdavm/config/config.toml | grep 'trust_hash'

sudo systemctl restart lambdavm
journalctl -u lambdavm -f -o cat
```

### Create validator
After your node is synced , Create your mainnet validator with 20k LAMB
```
lambdavm tx staking create-validator \
  --amount=20000000000000000000000ulamb \
  --pubkey=$(lambdavm tendermint show-validator) \
  --moniker="<Moniker>" \
  --chain-id=lambda_92000-1 \
  --commission-rate="0.05" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="1000000" \
  --gas="300000" \
  --gas-prices="0.025ulamb" \
  --from=<wallet> \
  --identity="" \
  --website="" \
  --details="" \
  --broadcast-mode block -y
```
Replace `<Moniker>` With your moniker and replace `<wallet>` with your wallet name

### Explorer
- Official Explorer : https://app.lambda.im/staking
- Alternative : https://explorer.nodestake.top/lambda/

## Usefull commands
### Service management
Check logs
```
journalctl -fu lambdavm -o cat
```

Start service
```
sudo systemctl start lambdavm
```

Stop service
```
sudo systemctl stop lambdavm
```

Restart service
```
sudo systemctl restart lambdavm
```

### Node info
Synchronization info
```
lambdavm status 2>&1 | jq .SyncInfo
```

Validator info
```
lambdavm status 2>&1 | jq .ValidatorInfo
```

Node info
```
lambdavm status 2>&1 | jq .NodeInfo
```

Show node id
```
lambdavm tendermint show-node-id
```

### Wallet operations
List of wallets
```
lambdavm keys list
```

Recover wallet
```
lambdavm keys add <wallet> --recover
```

Delete wallet
```
lambdavm keys delete <wallet>
```

Get wallet balance
```
lambdavm query bank balances <address>
```

Transfer funds
```
lambdavm tx bank send <FROM ADDRESS> <TO_LAMBDA_WALLET_ADDRESS> 10000000ulamb
```

### Voting
```
lambdavm tx gov vote 1 yes --from <wallet> --chain-id=lambda_92000-1
```

### Staking, Delegation and Rewards
Delegate stake
```
lambdavm tx staking delegate <lambda valoper> 10000000ulamb --from=<wallet> --chain-id=lambda_92000-1 --gas=auto
```

Redelegate stake from validator to another validator
```
lambdavm tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ulamb --from=<wallet> --chain-id=lambda_92000-1 --gas=auto
```

Withdraw all rewards
```
lambdavm tx distribution withdraw-all-rewards --from=<wallet> --chain-id=lambda_92000-1 --gas=auto
```

Withdraw rewards with commision
```
lambdavm tx distribution withdraw-rewards <lambda valoper> --from=<wallet> --commission --chain-id=lambda_92000-1
```

### Validator management
Edit validator
```
lambdavm tx staking edit-validator \
  --moniker=<moniker> \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=lambda_92000-1 \
  --from=<wallet>
```

Unjail validator
```
lambdavm tx slashing unjail \
  --broadcast-mode=block \
  --from=<wallet> \
  --chain-id=lambda_92000-1 \
  --gas=auto
```

### Delete node
This commands will completely remove node from server. Use at your own risk!
```
sudo systemctl stop lambdavm
sudo systemctl disable lambdavm
sudo rm /etc/systemd/system/lambdavm* -rf
sudo rm $(which lambdavm) -rf
sudo rm $HOME/.lambdavm* -rf
sudo rm $HOME/lambdavm -rf
sed -i '/LAMBDAVM_/d' ~/.bash_profile
```

