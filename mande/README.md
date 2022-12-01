<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<hr>

<p align="center">
 <img height="250" height="auto" src="https://user-images.githubusercontent.com/34649601/195998836-4f64c191-0a50-4819-a623-a2e9fb84901b.png">
 </p>

# Mande Chain testnet node setup — mande-testnet-1

Official documentation:
>- [Validator setup instructions](https://github.com/obajay/nodes-Guides/tree/main/Mande%20Chain)

Explorer:
>-  https://explorer.stavr.tech/mande-chain/


## Hardware Requirements
Like any Cosmos-SDK chain, the hardware requirements are pretty modest.

### Minimum Hardware Requirements
 - 3x CPUs; the faster clock speed the better
 - 4GB RAM
 - 100GB Disk
 - Permanent Internet connection (traffic will be minimal during testnet; 10Mbps will be plenty - for production at least 100Mbps is expected)

### Recommended Hardware Requirements 
 - 4x CPUs; the faster clock speed the better
 - 8GB RAM
 - 200GB of storage (SSD or NVME)
 - Permanent Internet connection (traffic will be minimal during testnet; 10Mbps will be plenty - for production at least 100Mbps is expected)

## Set up your empower fullnode
### Option 1 (automatic)
You can setup your empower fullnode in few minutes by using automated script below. It will prompt you to input your validator node name!
```
wget -O mande.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/mande/mande.sh && chmod +x mande.sh && ./mande.sh
```

### Option 2 (manual)
You can follow [manual guide](https://github.com/nodexcapital/testnet/blob/main/mande/manual_install.md) if you better prefer setting up node manually

## Post installation

When installation is finished please load variables into system
```
source $HOME/.bash_profile
```

Next you have to make sure your validator is syncing blocks. You can use command below to check synchronization status
```
mande-chaind status 2>&1 | jq .SyncInfo
```

### (OPTIONAL) State Sync
You can state sync your node in minutes by running commands below. Special thanks to `Obajay`
```
SNAP_RPC=http://38.242.199.93:24657
peers="a3e3e20528604b26b792055be84e3fd4de70533b@38.242.199.93:24656"
sed -i.bak -e  "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" ~/.mande-chain/config/config.toml
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 500)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.mande-chain/config/config.toml

mande-chaind tendermint unsafe-reset-all --home /root/.mande-chain --keep-addr-book
systemctl restart mande-chaind && journalctl -u mande-chaind -f -o cat
```

### Create wallet
To create new wallet you can use command below. Don’t forget to save the mnemonic
```
mande-chaind keys add $WALLET
```

(OPTIONAL) To recover your wallet using seed phrase
```
mande-chaind keys add $WALLET --recover
```

To get current list of wallets
```
mande-chaind keys list
```

### Save wallet info
Add wallet and valoper address and load variables into the system
```
MANDE_WALLET_ADDRESS=$(mande-chaind keys show $WALLET -a)
MANDE_VALOPER_ADDRESS=$(mande-chaind keys show $WALLET --bech val -a)
echo 'export MANDE_WALLET_ADDRESS='${MANDE_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export MANDE_VALOPER_ADDRESS='${MANDE_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

### Fund your wallet
Join [Mande Chain discord server](https://discord.gg/JbeFKmgYmH)
In order to create validator first you need to fund your wallet with testnet tokens.

To request a faucet grant:
```
curl -d '{"address":"<MANDE ADDRESS>"}' -H 'Content-Type: application/json' http://35.224.207.121:8080/request
```

### Create validator
Before creating validator please make sure that you have at least 0 Cred and your node is synchronized

To check your wallet balance:
```
mande-chaind query bank balances $MANDE_WALLET_ADDRESS
```
> If your wallet does not show any balance than probably your node is still syncing. Please wait until it finish to synchronize and then continue 

To create your validator run command below
```
mande-chaind tx staking create-validator \
  --amount 0cred \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(mande-chaind tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id $MANDE_CHAIN_ID
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
sudo ufw enable
```


## Usefull commands
### Service management
Check logs
```
journalctl -fu mande-chaind -o cat
```

Start service
```
sudo systemctl start mande-chaind
```

Stop service
```
sudo systemctl stop mande-chaind
```

Restart service
```
sudo systemctl restart mande-chaind
```

### Node info
Synchronization info
```
mande-chaind status 2>&1 | jq .SyncInfo
```

Validator info
```
mande-chaind status 2>&1 | jq .ValidatorInfo
```

Node info
```
mande-chaind status 2>&1 | jq .NodeInfo
```

Show node id
```
mande-chaind tendermint show-node-id
```

### Wallet operations
List of wallets
```
mande-chaind keys list
```

Recover wallet
```
mande-chaind keys add $WALLET --recover
```

Delete wallet
```
mande-chaind keys delete $WALLET
```

Get wallet balance
```
mande-chaind query bank balances $MANDE_WALLET_ADDRESS
```

Transfer funds
```
mande-chaind tx bank send $MANDE_WALLET_ADDRESS <TO_MANDE_WALLET_ADDRESS> 10000000umpwr
```

### Voting
```
mande-chaind tx gov vote 1 yes --from $WALLET --chain-id=$MANDE_CHAIN_ID
```

### Staking, Delegation and Rewards
Delegate stake
```
mande-chaind tx staking delegate $MANDE_VALOPER_ADDRESS 10000000umpwr --from=$WALLET --chain-id=$MANDE_CHAIN_ID --gas=auto
```

Redelegate stake from validator to another validator
```
mande-chaind tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000umpwr --from=$WALLET --chain-id=$MANDE_CHAIN_ID --gas=auto
```

Withdraw all rewards
```
mande-chaind tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$MANDE_CHAIN_ID --gas=auto
```

Withdraw rewards with commision
```
mande-chaind tx distribution withdraw-rewards $MANDE_VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$MANDE_CHAIN_ID
```

### Validator management
Edit validator
```
mande-chaind tx staking edit-validator \
  --moniker=$NODENAME \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=$MANDE_CHAIN_ID \
  --from=$WALLET
```

Unjail validator
```
mande-chaind tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$MANDE_CHAIN_ID \
  --gas=auto
```

### Delete node
This commands will completely remove node from server. Use at your own risk!
```
sudo systemctl stop mande-chaind && \
sudo systemctl disable mande-chaind && \
rm /etc/systemd/system/mande-chaind.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf .mande-chain && \
rm -rf $(which mande-chaind)
```