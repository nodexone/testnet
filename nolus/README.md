<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/34649601/207593974-32d7cb69-eca9-4096-bc96-246fe7038c88.png">
</p>

# Okp4 node setup for testnet — Okp4 Nemeton

Guide Source :
>- [Elangrr](https://github.com/elangrr/testnet_guide/blob/main/nolus/README.md)

Explorer:
>- https://explorer.nodexcapital.com/nolus


## Usefull tools and references
> To migrate your validator to another machine read [Migrate your validator to another machine](https://github.com/nodexcapital/testnet/blob/main/nolus/migrate_validator.md)

## Hardware Requirements
Like any Cosmos-SDK chain, the hardware requirements are pretty modest.

### Minimum Hardware Requirements
 - 4x CPUs; the faster clock speed the better
 - 8GB RAM
 - 160GB of storage (SSD or NVME)
 - Permanent Internet connection (traffic will be minimal during testnet; 10Mbps will be plenty - for production at least 100Mbps is expected)

### Recommended Hardware Requirements 
 - 8x CPUs; the faster clock speed the better
 - 64GB RAM
 - 1TB of storage (SSD or NVME)
 - Permanent Internet connection (traffic will be minimal during testnet; 10Mbps will be plenty - for production at least 100Mbps is expected)

## Set up your Nolus fullnode
### Option 1 (automatic)
You can setup your nois fullnode in few minutes by using automated script below. It will prompt you to input your validator node name!
```
wget -O nolus.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/nolus/nolus.sh && chmod +x nolus.sh && ./nolus.sh
```

### Option 2 (manual)
You can follow [manual guide](https://github.com/nodexcapital/testnet/blob/main/nolus/manual_install.md) if you better prefer setting up node manually

## Post installation

When installation is finished please load variables into system
```
source $HOME/.bash_profile
```

Next you have to make sure your validator is syncing blocks. You can use command below to check synchronization status
```
nolusd status 2>&1 | jq .SyncInfo
```

### (OPTIONAL) State Sync
You can state sync your node in minutes by running commands below
```
cp $HOME/.nolus/data/priv_validator_state.json $HOME/.nolus/priv_validator_state.json.backup
nolusd tendermint unsafe-reset-all --home $HOME/.nolus
STATE_SYNC_RPC=http://rpc.nolus.ppnv.space:34657
STATE_SYNC_PEER=1a0bb6c35e2663202535d4b849ff06250762d299@rpc.nolus.ppnv.space:35656
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 1000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sed -i.bak -e "s|^enable *=.*|enable = true|" $HOME/.nolus/config/config.toml
sed -i.bak -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  $HOME/.nolus/config/config.toml
sed -i.bak -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  $HOME/.nolus/config/config.toml
sed -i.bak -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  $HOME/.nolus/config/config.toml
sed -i.bak -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  $HOME/.nolus/config/config.toml
mv $HOME/.nolus/priv_validator_state.json.backup $HOME/.nolus/data/priv_validator_state.json
sudo systemctl restart nolusd && journalctl -u nolusd -f --no-hostname -o cat
```

### Create wallet
To create new wallet you can use command below. Don’t forget to save the mnemonic
```
nolusd keys add $WALLET
```

(OPTIONAL) To recover your wallet using seed phrase
```
nolusd keys add $WALLET --recover
```

To get current list of wallets
```
nolusd keys list
```

### Save wallet info
Add wallet and valoper address into variables 
```
NOLUS_WALLET_ADDRESS=$(nolusd keys show $WALLET -a)
NOLUS_VALOPER_ADDRESS=$(nolusd keys show $WALLET --bech val -a)
echo 'export NOLUS_WALLET_ADDRESS='${NOLUS_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export NOLUS_VALOPER_ADDRESS='${NOLUS_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

### Fund your wallet
In order to create validator first you need to fund your wallet with testnet tokens here https://faucet-rila.nolus.io/

### Create validator
Before creating validator please make sure that you have at least 1 NOLUS (1 NOLUS is equal to 1000000unls) and your node is synchronized

To check your wallet balance:
```
nolusd query bank balances $NOLUS_WALLET_ADDRESS
```
> If your wallet does not show any balance than probably your node is still syncing. Please wait until it finish to synchronize and then continue 

To create your validator run command below
```
nolusd tx staking create-validator \
  --amount 100000000unls \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(nolusd tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id nolus-rila
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
sudo ufw allow ${NOLUS_PORT}656,${NOLUS_PORT}660/tcp
sudo ufw enable
```

### Check your validator key
```
[[ $(nolusd q staking validator $NOLUS_VALOPER_ADDRESS -oj | jq -r .consensus_pubkey.key) = $(nolusd status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```

### Get list of validators
```
nolusd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

## Usefull commands
### Service management
Check logs
```
journalctl -fu nolusd -o cat
```

Start service
```
sudo systemctl start nolusd
```

Stop service
```
sudo systemctl stop nolusd
```

Restart service
```
sudo systemctl restart nolusd
```

### Node info
Synchronization info
```
nolusd status 2>&1 | jq .SyncInfo
```

Validator info
```
nolusd status 2>&1 | jq .ValidatorInfo
```

Node info
```
nolusd status 2>&1 | jq .NodeInfo
```

Show node id
```
nolusd tendermint show-node-id
```

### Wallet operations
List of wallets
```
nolusd keys list
```

Recover wallet
```
nolusd keys add $WALLET --recover
```

Delete wallet
```
nolusd keys delete $WALLET
```

Get wallet balance
```
nolusd query bank balances $NOLUS_WALLET_ADDRESS
```

Transfer funds
```
nolusd tx bank send $NOLUS_WALLET_ADDRESS <TO_NOLUS_WALLET_ADDRESS> 10000000unls
```

### Voting
```
nolusd tx gov vote 1 yes --from $WALLET --chain-id=$NOLUS_CHAIN_ID
```

### Staking, Delegation and Rewards
Delegate stake
```
nolusd tx staking delegate $NOLUS_VALOPER_ADDRESS 10000000uknow --from=$WALLET --chain-id=$NOLUS_CHAIN_ID --gas=auto
```

Redelegate stake from validator to another validator
```
nolusd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000unls --from=$WALLET --chain-id=$NOLUS_CHAIN_ID --gas=auto
```

Withdraw all rewards
```
nolusd tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$NOLUS_CHAIN_ID --gas=auto
```

Withdraw rewards with commision
```
nolusd tx distribution withdraw-rewards $NOLUS_VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$NOLUS_CHAIN_ID
```

### Validator management
Edit validator
```
nolusd tx staking edit-validator \
  --moniker=$NODENAME \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=$NOLUS_CHAIN_ID \
  --from=$WALLET
```

Unjail validator
```
nolusd tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$NOLUS_CHAIN_ID \
  --gas=auto
```

### Delete node
This commands will completely remove node from server. Use at your own risk!
```
sudo systemctl stop nolusd && \
sudo systemctl disable nolusd && \
rm /etc/systemd/system/nolusd.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf nolusd && \
rm -rf .nolus && \
rm -rf $(which nolusd)
```
