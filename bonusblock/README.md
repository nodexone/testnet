<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/bDUAwZhqBb" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://nodexcapital.com" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://explorer.sxlzptprjkt.xyz/logos/bonusblock.png">
</p>

# Bonus Block Testnet | Chain ID : blocktopia-01 | Custom Port : 217

### Community Documentation:
>- [Validator setup instructions](https://docs.bonusblock.xyz/validators/full-node/run-a-node)

### Explorer:
>-  https://explorer.nodexcapital.com/bonusblock

### Automatic  (Must Using Ubuntu 22.04)
You can setup your Bonus Block fullnode in few minutes by using automated script below.
```
wget -O bonusblock.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/bonusblock/bonusblock.sh && chmod +x bonusblock.sh && ./bonusblock.sh
```
### Public Endpoint

>- API : https://rest.bonusblock-t.nodexcapital.com
>- RPC : https://rpc.bonusblock-t.nodexcapital.com
>- gRPC : https://grpc.bonusblock-t.nodexcapital.com

### Snapshot (Update every 5 hours)
```
sudo systemctl stop bonus-blockd
cp $HOME/.bonusblock/data/priv_validator_state.json $HOME/.bonusblock/priv_validator_state.json.backup
rm -rf $HOME/.bonusblock/data

curl -L https://snap.nodexcapital.com/bonusblock/bonusblock-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.bonusblock
mv $HOME/.bonusblock/priv_validator_state.json.backup $HOME/.bonusblock/data/priv_validator_state.json

sudo systemctl start bonus-blockd && sudo journalctl -u bonus-blockd -f --no-hostname -o cat
```

### State Sync
```
sudo systemctl stop bonus-blockd
cp $HOME/.bonusblock/data/priv_validator_state.json $HOME/.bonusblock/priv_validator_state.json.backup
bonus-blockd tendermint unsafe-reset-all --home $HOME/.bonusblock

STATE_SYNC_RPC=https://rpc.bonusblock-t.nodexcapital.com:443
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  $HOME/.bonusblock/config/config.toml

mv $HOME/.bonusblock/priv_validator_state.json.backup $HOME/.bonusblock/data/priv_validator_state.json
sudo systemctl start bonus-blockd && sudo journalctl -u bonus-blockd -f --no-hostname -o cat
```
### Disable State Sync 
After successful synchronization using state sync above, we advise you to disable synchronization with state sync and restart the node
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.bonusblock/config/config.toml
sudo systemctl restart bonus-blockd && journalctl -u bonus-blockd -f -o cat
```
PEERS="$(curl -sS https://rpc.bonusblock-t.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.bonusblock/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/bonusblock/addrbook.json > $HOME/.bonusblock/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/bonusblock/genesis.json > $HOME/.bonusblock/config/genesis.json
```