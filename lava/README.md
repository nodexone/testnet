<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/nodexcapital/testnet/main/cosmos-image/lava.svg">
</p>

## Lava node setup for testnet — lava-testnet-1

Official documentation:
>- [Validator setup instructions](https://docs.lavanet.xyz/testnet/)

Explorer:
>-  https://explorer.nodexcapital.com/lava

### Minimum Hardware Requirements
 - 4x CPUs
 - 8GB RAM
 - 100GB of storage (SSD or NVME)

## Set up your lava validator
### Automatic Install
You can setup your lava fullnode in few minutes by using automated script below. It will prompt you to input your validator node name!
```
N/A
```
### Create wallet
```
lavad keys add $WALLET
```
```
lavad keys add $WALLET --recover
```

### Save wallet info
Add wallet and valoper address into variables 
```
LAVA_WALLET_ADDRESS=$lavad keys show $WALLET -a)
LAVA_VALOPER_ADDRESS=$(lavad keys show $WALLET --bech val -a)
echo 'export LAVA_WALLET_ADDRESS='${LAVA_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export LAVA_VALOPER_ADDRESS='${LAVA_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

### (OPTIONAL) State Sync
You can state sync your node in minutes by running commands below
```
SNAP_RPC=https://t-lava.rpc.utsa.tech:443
peers="433be6210ad6350bebebad68ec50d3e0d90cb305@217.13.223.167:60856"
sed -i.bak -e  "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" ~/.lava/config/config.toml
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 500)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.lava/config/config.toml
lavad tendermint unsafe-reset-all --home /root/.lava --keep-addr-book
sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = \"1500\"/" $HOME/.lava/config/app.toml
systemctl restart lavad && journalctl -u lavad -f -o cat
```

### Create Validator

``` 
lavad tx staking create-validator \
  --amount 1000000ulava \
  --from $WALLET \
  --commission-max-change-rate "0.1" \
  --commission-max-rate "0.2" \
  --commission-rate "0.1" \
  --min-self-delegation "1" \
  --pubkey  $(lavad tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id $LAVA_CHAIN_ID
 ```
 
 ### Validator management
Edit validator
```
lavad tx staking edit-validator \
  --moniker=$NODENAME \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=$LAVA_CHAIN_ID \
  --from=$WALLET
```

Unjail validator
```
lavad tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$LAVA_CHAIN_ID \
  --gas=auto
```
### Delete node
This commands will completely remove node from server. Use at your own risk!
```
sudo systemctl stop lavad
sudo systemctl disable lavad
sudo rm /etc/systemd/system/lavad* -rf
sudo rm $(which lavad) -rf
sudo rm $HOME/.lava* -rf
sudo rm $HOME/GHFkqmTzpdNLDd6T -rf
sed -i '/LAVA_/d' ~/.bash_profile
```
  
