<strong><p style="font-size:14px" align="left">Founder :
<a href="https://discord.gg/JqQNcwff2e" target="_blank">NodeX Capital Discord</a></p></strong>
<strong><p style="font-size:14px" align="left">Visit Our Website : 
<a href="https://nodex.codes/" target="_blank">https://nodex.codes</a></p></strong>
<strong><p style="font-size:14px" align="left">Follow Me :
<a href="https://twitter.com/nodexploit/" target="_blank">NodeX Twitter</a></p></strong>
<hr>

<p align="center">
  <img src="https://user-images.githubusercontent.com/44331529/197152847-749c938c-c385-4698-bfa5-3f159297f391.png">
</p>

# nois node setup for testnet — Okp4 Nemeton

Guide Source :
>- [Obajay](https://github.com/obajay/nodes-Guides/tree/main/OKP4)

Explorer:
>-  [Explore](https://explorer.stavr.tech/okp4)


## Usefull tools and references
> To migrate your validator to another machine read [Migrate your validator to another machine](https://github.com/nodesxploit/testnet/blob/main/okp4/migrate_validator.md)

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
wget -O okp4.sh https://raw.githubusercontent.com/nodesxploit/testnet/main/okp4/okp4.sh && chmod +x okp4.sh && ./okp4.sh
```

### Option 2 (manual)
You can follow [manual guide](https://github.com/nodesxploit/testnet/blob/main/okp4/manual_install.md) if you better prefer setting up node manually

## Post installation

When installation is finished please load variables into system
```
source $HOME/.bash_profile
```

Next you have to make sure your validator is syncing blocks. You can use command below to check synchronization status
```
okp4d status 2>&1 | jq .SyncInfo
```

### (OPTIONAL) State Sync
You can state sync your node in minutes by running commands below
```
SNAP_RPC=https://okp4-testnet-rpc.polkachu.com:443
peers="https://okp4-testnet-rpc.polkachu.com:443"
sed -i.bak -e  "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" ~/.okp4d/config/config.toml
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 500)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.okp4d/config/config.toml

okp4d tendermint unsafe-reset-all --home /root/.okp4d --keep-addr-book
systemctl restart okp4d && journalctl -u okp4d -f -o cat
```

### Create wallet
To create new wallet you can use command below. Don’t forget to save the mnemonic
```
okp4d keys add $WALLET
```

(OPTIONAL) To recover your wallet using seed phrase
```
okp4d keys add $WALLET --recover
```

To get current list of wallets
```
okp4d keys list
```

### Save wallet info
Add wallet and valoper address into variables 
```
OKP4D_WALLET_ADDRESS=$(okp4d keys show $WALLET -a)
OKP4D_VALOPER_ADDRESS=$(okp4d keys show $WALLET --bech val -a)
echo 'export OKP4D_WALLET_ADDRESS='${OKP4D_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export OKP4D_VALOPER_ADDRESS='${OKP4D_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

### Fund your wallet
In order to create validator first you need to fund your wallet with testnet tokens.
```
> TBA
```

### Create validator
Before creating validator please make sure that you have at least 1 strd (1 strd is equal to 1000000 unois) and your node is synchronized

To check your wallet balance:
```
okp4d query bank balances $OKP4D_WALLET_ADDRESS
```
> If your wallet does not show any balance than probably your node is still syncing. Please wait until it finish to synchronize and then continue 

To create your validator run command below
```
okp4d tx staking create-validator \
  --amount 100000000uknow \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(okp4d tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id $OKP4D_CHAIN_ID
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

### Check your validator key
```
[[ $(okp4d q staking validator $OKP4D_VALOPER_ADDRESS -oj | jq -r .consensus_pubkey.key) = $(okp4d status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```

### Get list of validators
```
okp4d q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

## Usefull commands
### Service management
Check logs
```
journalctl -fu okp4d -o cat
```

Start service
```
sudo systemctl start okp4d
```

Stop service
```
sudo systemctl stop okp4d
```

Restart service
```
sudo systemctl restart okp4d
```

### Node info
Synchronization info
```
okp4d status 2>&1 | jq .SyncInfo
```

Validator info
```
okp4d status 2>&1 | jq .ValidatorInfo
```

Node info
```
okp4d status 2>&1 | jq .NodeInfo
```

Show node id
```
okp4d tendermint show-node-id
```

### Wallet operations
List of wallets
```
okp4d keys list
```

Recover wallet
```
okp4d keys add $WALLET --recover
```

Delete wallet
```
okp4d keys delete $WALLET
```

Get wallet balance
```
okp4d query bank balances $OKP4D_WALLET_ADDRESS
```

Transfer funds
```
okp4d tx bank send $OKP4D_WALLET_ADDRESS <TO_OKP4D_WALLET_ADDRESS> 10000000unois
```

### Voting
```
okp4d tx gov vote 1 yes --from $WALLET --chain-id=$OKP4D_CHAIN_ID
```

### Staking, Delegation and Rewards
Delegate stake
```
okp4d tx staking delegate $OKP4D_VALOPER_ADDRESS 10000000unois --from=$WALLET --chain-id=$OKP4D_CHAIN_ID --gas=auto
```

Redelegate stake from validator to another validator
```
okp4d tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000unois --from=$WALLET --chain-id=$OKP4D_CHAIN_ID --gas=auto
```

Withdraw all rewards
```
okp4d tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$OKP4D_CHAIN_ID --gas=auto
```

Withdraw rewards with commision
```
okp4d tx distribution withdraw-rewards $OKP4D_VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$OKP4D_CHAIN_ID
```

### Validator management
Edit validator
```
okp4d tx staking edit-validator \
  --moniker=$NODENAME \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=$OKP4D_CHAIN_ID \
  --from=$WALLET
```

Unjail validator
```
okp4d tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$OKP4D_CHAIN_ID \
  --gas=auto
```

### Delete node
This commands will completely remove node from server. Use at your own risk!
```
sudo systemctl stop okp4d && \
sudo systemctl disable okp4d && \
rm /etc/systemd/system/okp4d.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf okp4d && \
rm -rf .okp4d && \
rm -rf $(which okp4d)
```
