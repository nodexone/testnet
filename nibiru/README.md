<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/44331529/199216266-6b0da979-44a2-43e4-b9ef-de3a7c361b17.png">
</p>

# nibiru node setup for Nibiru Testnet

Official documentation:
>- https://nibiru.fi/
>- https://github.com/NibiruChain

Explorer:
>- https://explorer.nodexcapital.com/nibiru/staking

## Usefull tools and references
> To set up monitoring for your validator node navigate to [Set up monitoring and alerting for nibiru validator](https://github.com/nodexcapital/testnet/blob/main/nibiru/monitoring/README.md)
>
> To migrate your validator to another machine read [Migrate your validator to another machine](https://github.com/nodexcapital/testnet/blob/main/nibiru/migrate_validator.md)

## Recommended Hardware Requirements 
 - 4x CPUs; the faster clock speed the better
 - 8GB RAM
 - 100GB of storage (SSD or NVME)
 - Permanent Internet connection (traffic will be minimal during testnet; 10Mbps will be plenty - for production at least 100Mbps is expected)

## Set up your Nibiru fullnode
### Option 1 (automatic)
You can setup your nibiru fullnode in few minutes by using automated script below. It will prompt you to input your validator node name!
```
wget -O nibiru.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/nibiru/nibiru.sh && chmod +x nibiru.sh && ./nibiru.sh
```

### Option 2 (manual)
You can follow [manual guide](https://github.com/nodexcapital/testnet/blob/main/nibiru/manual_install.md) if you better prefer setting up node manually

## Post installation

When installation is finished please load variables into system
```
source $HOME/.bash_profile
```

Next you have to make sure your validator is syncing blocks. You can use command below to check synchronization status
```
nibid status 2>&1 | jq .SyncInfo
```

### (OPTIONAL) Disable and cleanup indexing
```
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.nibid/config/config.toml
sudo systemctl restart nibid
sleep 3
sudo rm -rf $HOME/.nibid/data/tx_index.db
```

### (OPTIONAL) State Sync
You can state sync your node in minutes by running commands below
```
peers="968472e8769e0470fadad79febe51637dd208445@65.108.6.45:60656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.nibid/config/config.toml
SNAP_RPC=https://t-nibiru.rpc.utsa.tech:443
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.nibid/config/config.toml
nibid tendermint unsafe-reset-all --home /root/.nibid --keep-addr-book
systemctl restart nibid && journalctl -u nibid -f -o cat
```

### Create wallet
To create new wallet you can use command below. Don’t forget to save the mnemonic
```
nibid keys add $WALLET
```

(OPTIONAL) To recover your wallet using seed phrase
```
nibid keys add $WALLET --recover
```

To get current list of wallets
```
nibid keys list
```

### Save wallet info
Add wallet and valoper address into variables 
```
NIBIRU_WALLET_ADDRESS=$(nibid keys show $WALLET -a)
NIBIRU_VALOPER_ADDRESS=$(nibid keys show $WALLET --bech val -a)
echo 'export NIBIRU_WALLET_ADDRESS='${NIBIRU_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export NIBIRU_VALOPER_ADDRESS='${NIBIRU_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

### Fund your wallet
In order to create validator first you need to fund your wallet with testnet tokens.
To top up your wallet join [nibiru discord server]() and navigate to:
- **#faucet** to request test tokens

To request a faucet grant:
```
$request <YOUR_WALLET_ADDRESS>
```

To check wallet balance:
```
$balance <YOUR_WALLET_ADDRESS>
```

### Create validator
Before creating validator please make sure that you have at least 1 nibiru (1 nibiru is equal to 10000000 unibi) and your node is synchronized

To check your wallet balance:
```
nibid query bank balances $NIBIRU_WALLET_ADDRESS
```
> If your wallet does not show any balance than probably your node is still syncing. Please wait until it finish to synchronize and then continue 

To create your validator run command below
```
nibid tx staking create-validator \
  --amount 10000000unibi \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(nibid tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id $NIBIRU_CHAIN_ID
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
sudo ufw allow ${NIBIRU_PORT}656,${NIBIRU_PORT}660/tcp
sudo ufw enable
```


## Calculate synchronization time
This script will help you to estimate how much time it will take to fully synchronize your node\
It measures average blocks per minute that are being synchronized for period of 5 minutes and then gives you results
```
wget -O synctime.py https://raw.githubusercontent.com/nodexcapital/testnet/main/nibiru/tools/synctime.py && python3 ./synctime.py
```

### Check your validator key
```
[[ $(nibid q staking validator $NIBIRU_VALOPER_ADDRESS -oj | jq -r .consensus_pubkey.key) = $(nibid status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```

### Get list of validators
```
nibid q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

## Get currently connected peer list with ids
```
curl -sS http://localhost:${NIBIRU_PORT}657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```

## Usefull commands
### Service management
Check logs
```
journalctl -fu nibid -o cat
```

Start service
```
sudo systemctl start nibid
```

Stop service
```
sudo systemctl stop nibid
```

Restart service
```
sudo systemctl restart nibid
```

### Node info
Synchronization info
```
nibid status 2>&1 | jq .SyncInfo
```

Validator info
```
nibid status 2>&1 | jq .ValidatorInfo
```

Node info
```
nibid status 2>&1 | jq .NodeInfo
```

Show node id
```
nibid tendermint show-node-id
```

### Wallet operations
List of wallets
```
nibid keys list
```

Recover wallet
```
nibid keys add $WALLET --recover
```

Delete wallet
```
nibid keys delete $WALLET
```

Get wallet balance
```
nibid query bank balances $NIBIRU_WALLET_ADDRESS
```

Transfer funds
```
nibid tx bank send $NIBIRU_WALLET_ADDRESS <TO_NIBIRU_WALLET_ADDRESS> 10000000unibi
```

### Voting
```
nibid tx gov vote 1 yes --from $WALLET --chain-id=$NIBIRU_CHAIN_ID
```

### Staking, Delegation and Rewards
Delegate stake
```
nibid tx staking delegate $NIBIRU_VALOPER_ADDRESS 10000000unibi --from=$WALLET --chain-id=$NIBIRU_CHAIN_ID --gas=auto
```

Redelegate stake from validator to another validator
```
nibid tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000unibi --from=$WALLET --chain-id=$NIBIRU_CHAIN_ID --gas=auto
```

Withdraw all rewards
```
nibid tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$NIBIRU_CHAIN_ID --gas=auto
```

Withdraw rewards with commision
```
nibid tx distribution withdraw-rewards $NIBIRU_VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$NIBIRU_CHAIN_ID
```

### Validator management
Edit validator
```
nibid tx staking edit-validator \
  --moniker=$NODENAME \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=$NIBIRU_CHAIN_ID \
  --from=$WALLET
```

Unjail validator
```
nibid tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$NIBIRU_CHAIN_ID \
  --gas=auto
```

### Delete node
This commands will completely remove node from server. Use at your own risk!
```
sudo systemctl stop nibid
sudo systemctl disable nibid
sudo rm /etc/systemd/system/nibiru* -rf
sudo rm $(which nibid) -rf
sudo rm $HOME/.nibid* -rf
sudo rm $HOME/nibiru -rf
sed -i '/nibiru_/d' ~/.bash_profile
```
