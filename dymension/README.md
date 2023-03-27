<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://avatars.githubusercontent.com/u/108229184?s=200&v=4">
</p>

# Dymension Testnet | Chain ID : 35-C | Custom Port : 242

### Official Documentation:
>- [Validator setup instructions](https://docs.dymension.xyz/validators/full-node/run-a-node)

### Explorer:
>-  https://explorer.nodexcapital.com/dymension

### Automatic  (Must Using Ubuntu 22.04)
You can setup your Dymension fullnode in few minutes by using automated script below.
```
wget -O dymension.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/dymension/dymension.sh && chmod +x dymension.sh && ./dymension.sh
```
### Public Endpoint

>- API : https://rest.dymension-t.nodexcapital.com
>- RPC : https://rpc.dymension-t.nodexcapital.com
>- gRPC : https://grpc.dymension-t.nodexcapital.com

### Snapshot (Update every 5 hours)
```
sudo systemctl stop dymd
cp $HOME/.dymension/data/priv_validator_state.json $HOME/.dymension/priv_validator_state.json.backup
rm -rf $HOME/.dymension/data

curl -L https://snapshots.kjnodes.com/dymension-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.dymension
mv $HOME/.dymension/priv_validator_state.json.backup $HOME/.dymension/data/priv_validator_state.json

sudo systemctl start dymd && sudo journalctl -u dymd -f --no-hostname -o cat
```

### State Sync
```
sudo systemctl stop dymd
cp $HOME/.dymension/data/priv_validator_state.json $HOME/.dymension/priv_validator_state.json.backup
dymd tendermint unsafe-reset-all --home $HOME/.dymension

STATE_SYNC_RPC=https://rpc.dymension-t.nodexcapital.com:443
STATE_SYNC_PEER=d5519e378247dfb61dfe90652d1fe3e2b3005a5b@dymension-testnet.rpc.kjnodes.com:46656
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  $HOME/.dymension/config/config.toml

mv $HOME/.dymension/priv_validator_state.json.backup $HOME/.dymension/data/priv_validator_state.json
sudo systemctl start dymd && sudo journalctl -u dymd -f --no-hostname -o cat
```
### Disable State Sync 
After successful synchronization using state sync above, we advise you to disable synchronization with state sync and restart the node
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.dymension/config/config.toml
sudo systemctl restart dymd && journalctl -u dymd -f -o cat

### Live Peers
```
PEERS="$(curl -sS https://rpc.dymension-t.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.dymension/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snapshots.kjnodes.com/dymension-testnet/addrbook.json > $HOME//.dymension/config/addrbook.json
```
### Genesis
```
curl -Ls https://snapshots.kjnodes.com/dymension-testnet/genesis.json > $HOME/.dymension/config/genesis.json
```