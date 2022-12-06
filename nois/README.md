<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/192454529-b8070948-6592-4022-96d9-b2adf7169243.png">
</p>

# nois node setup for testnet — nois-testnet-002

Official documentation:
>- [Validator setup instructions](https://docs.nois.network/use-cases/for-validators)

Explorer:
>-  N/A

## Usefull tools and references
> To set up monitoring for your validator node navigate to [Set up monitoring and alerting for nois validator](https://github.com/nodexcapital/testnet/blob/main/nois/monitoring/README.md)
>
> To migrate your validator to another machine read [Migrate your validator to another machine](https://github.com/nodexcapital/testnet/blob/main/nois/migrate_validator.md)

## Hardware Requirements
Like any Cosmos-SDK chain, the hardware requirements are pretty modest.

### Minimum Hardware Requirements
 - 4x CPUs; the faster clock speed the better
 - 8GB RAM
 - 100GB of storage (SSD or NVME)
 - Permanent Internet connection (traffic will be minimal during testnet; 10Mbps will be plenty - for production at least 100Mbps is expected)

### Recommended Hardware Requirements 
 - 8x CPUs; the faster clock speed the better
 - 64GB RAM
 - 1TB of storage (SSD or NVME)
 - Permanent Internet connection (traffic will be minimal during testnet; 10Mbps will be plenty - for production at least 100Mbps is expected)

## Set up your nois fullnode
### Option 1 (automatic)
You can setup your nois fullnode in few minutes by using automated script below. It will prompt you to input your validator node name!
```
wget -O nois.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/nois/nois.sh && chmod +x nois.sh && ./nois.sh
```

### Option 2 (manual)
You can follow [manual guide](https://github.com/nodexcapital/testnet/blob/main/nois/manual_install.md) if you better prefer setting up node manually

## Post installation

When installation is finished please load variables into system
```
source $HOME/.bash_profile
```

Next you have to make sure your validator is syncing blocks. You can use command below to check synchronization status
```
noisd status 2>&1 | jq .SyncInfo
```

### (OPTIONAL) State Sync
You can state sync your node in minutes by running commands below
```
peers="8073bd66d5fa581c7b3d0a08d0df1fe318d70d99@135.181.35.46:55656"; \
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.noisd/config/config.toml

SNAP_RPC="http://135.181.35.46:55657"; \
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash); \
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" ~/.noisd/config/config.toml

sudo systemctl stop noisd && \
noisd tendermint unsafe-reset-all --home $HOME/.noisd && \
sudo systemctl restart noisd
```

### Create wallet
To create new wallet you can use command below. Don’t forget to save the mnemonic
```
noisd keys add $WALLET
```

(OPTIONAL) To recover your wallet using seed phrase
```
noisd keys add $WALLET --recover
```

To get current list of wallets
```
noisd keys list
```

### Save wallet info
Add wallet and valoper address into variables 
```
NOIS_WALLET_ADDRESS=$(noisd keys show $WALLET -a)
NOIS_VALOPER_ADDRESS=$(noisd keys show $WALLET --bech val -a)
echo 'export NOIS_WALLET_ADDRESS='${NOIS_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export NOIS_VALOPER_ADDRESS='${NOIS_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

### Fund your wallet
In order to create validator first you need to fund your wallet with testnet tokens.
```
curl --header "Content-Type: application/json" \
--request POST \
--data '{"denom":"unois","address":"'$NOIS_WALLET_ADDRESS'"}' \
http://faucet.noislabs.com/credit
```

### Create validator
Before creating validator please make sure that you have at least 1 strd (1 strd is equal to 1000000 unois) and your node is synchronized

To check your wallet balance:
```
noisd query bank balances $NOIS_WALLET_ADDRESS
```
> If your wallet does not show any balance than probably your node is still syncing. Please wait until it finish to synchronize and then continue 

To create your validator run command below
```
noisd tx staking create-validator \
  --amount 100000000unois \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(noisd tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id $NOIS_CHAIN_ID
```

## Security
To protect you keys please make sure you follow basic security rules

### Set up ssh keys for authentication
Good tutorial on how to set up ssh keys for authentication to your server can be found [here](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-20-04)

### Basic Firewall security
Start by checking the status of ufw.
```
sudo ufw status
```

Sets the default to allow outgoing connections, deny all incoming except ssh and 26656. Limit SSH login attempts
```
sudo ufw default allow outgoing
sudo ufw default deny incoming
sudo ufw allow ssh/tcp
sudo ufw limit ssh/tcp
sudo ufw allow ${NOIS_PORT}656,${NOIS_PORT}660/tcp
sudo ufw enable
```

## Monitoring
To monitor and get alerted about your validator health status you can use my guide on [Set up monitoring and alerting for nois validator](https://github.com/nodexcapital/testnet/blob/main/nois/monitoring/README.md)

## Calculate synchronization time
This script will help you to estimate how much time it will take to fully synchronize your node\
It measures average blocks per minute that are being synchronized for period of 5 minutes and then gives you results
```
wget -O synctime.py https://raw.githubusercontent.com/nodexcapital/testnet/main/nois/tools/synctime.py && python3 ./synctime.py
```

### Check your validator key
```
[[ $(noisd q staking validator $NOIS_VALOPER_ADDRESS -oj | jq -r .consensus_pubkey.key) = $(noisd status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```

### Get list of validators
```
noisd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

## Get currently connected peer list with ids
```
curl -sS http://localhost:${NOIS_PORT}657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```

## Usefull commands
### Service management
Check logs
```
journalctl -fu noisd -o cat
```

Start service
```
sudo systemctl start noisd
```

Stop service
```
sudo systemctl stop noisd
```

Restart service
```
sudo systemctl restart noisd
```

### Node info
Synchronization info
```
noisd status 2>&1 | jq .SyncInfo
```

Validator info
```
noisd status 2>&1 | jq .ValidatorInfo
```

Node info
```
noisd status 2>&1 | jq .NodeInfo
```

Show node id
```
noisd tendermint show-node-id
```

### Wallet operations
List of wallets
```
noisd keys list
```

Recover wallet
```
noisd keys add $WALLET --recover
```

Delete wallet
```
noisd keys delete $WALLET
```

Get wallet balance
```
noisd query bank balances $NOIS_WALLET_ADDRESS
```

Transfer funds
```
noisd tx bank send $NOIS_WALLET_ADDRESS <TO_NOIS_WALLET_ADDRESS> 10000000unois
```

### Voting
```
noisd tx gov vote 1 yes --from $WALLET --chain-id=$NOIS_CHAIN_ID
```

### Staking, Delegation and Rewards
Delegate stake
```
noisd tx staking delegate $NOIS_VALOPER_ADDRESS 10000000unois --from=$WALLET --chain-id=$NOIS_CHAIN_ID --gas=auto
```

Redelegate stake from validator to another validator
```
noisd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000unois --from=$WALLET --chain-id=$NOIS_CHAIN_ID --gas=auto
```

Withdraw all rewards
```
noisd tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$NOIS_CHAIN_ID --gas=auto
```

Withdraw rewards with commision
```
noisd tx distribution withdraw-rewards $NOIS_VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$NOIS_CHAIN_ID
```

### Validator management
Edit validator
```
noisd tx staking edit-validator \
  --moniker=$NODENAME \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=$NOIS_CHAIN_ID \
  --from=$WALLET
```

Unjail validator
```
noisd tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$NOIS_CHAIN_ID \
  --gas=auto
```

### Delete node
This commands will completely remove node from server. Use at your own risk!
```
sudo systemctl stop noisd
sudo systemctl disable noisd
sudo rm /etc/systemd/system/nois* -rf
sudo rm $(which noisd) -rf
sudo rm $HOME/.noisd* -rf
sudo rm $HOME/nois -rf
sed -i '/NOIS_/d' ~/.bash_profile
```

### Pruning for state sync node
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="2000"
pruning_interval="50"
snapshot_interval="2000"
snapshot_keep_recent="5"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.noisd/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.noisd/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.noisd/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.noisd/config/app.toml
sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = \"$snapshot_interval\"/" $HOME/.noisd/config/app.toml
sed -i -e "s/^snapshot-keep-recent *=.*/snapshot-keep-recent = \"$snapshot_keep_recent\"/" $HOME/.noisd/config/app.toml
```
