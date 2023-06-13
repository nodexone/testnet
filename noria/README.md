<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/bDUAwZhqBb" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://nodexcapital.com" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://noria.network/wp-content/uploads/2023/01/logo2_matte.gif">
</p>

# Noria Testnet | Chain ID : oasis-3 | Custom Port : 224

### Community Documentation :
>- [Validator Setup Instructions](https://services.kjnodes.com/home/testnet/noria)

### Explorer:
>-  https://explorer.nodexcapital.com/noria

### Automatic Installer
You can setup your Noria Network fullnode in few minutes by using automated script below.
```
wget -O noria.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/noria/noria.sh && chmod +x noria.sh && ./noria.sh
```
### Public Endpoint

>- API : https://rest.noria-t.nodexcapital.com
>- RPC : https://rpc.noria-t.nodexcapital.com
>- gRPC : https://grpc.noria-t.nodexcapital.com

### Snapshot (Update every 5 hours)
```
sudo systemctl stop noriad
cp $HOME/.noria/data/priv_validator_state.json $HOME/.noria/priv_validator_state.json.backup
rm -rf $HOME/.noria/data

curl -L https://snap.nodexcapital.com/noria/noria-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.noria

mv $HOME/.noria/priv_validator_state.json.backup $HOME/.noria/data/priv_validator_state.json

sudo systemctl start noriad && sudo journalctl -fu noriad -o cat
```

### State Sync
```
sudo systemctl stop noriad
cp $HOME/.noria/data/priv_validator_state.json $HOME/.noria/priv_validator_state.json.backup
noriad tendermint unsafe-reset-all --home $HOME/.noria

STATE_SYNC_RPC=https://noria-testnet.rpc.kjnodes.com
STATE_SYNC_PEER=d5519e378247dfb61dfe90652d1fe3e2b3005a5b@noria-testnet.rpc.kjnodes.com:16156
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  $HOME/.noria/config/config.toml

mv $HOME/.noria/priv_validator_state.json.backup $HOME/.noria/data/priv_validator_state.json

sudo systemctl start noriad && sudo journalctl -u noriad -f --no-hostname -o cat
```

### Disable State Sync 
After successful synchronization using state sync above, we advise you to disable synchronization with state sync and restart the node
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.noria/config/config.toml
sudo systemctl restart noriad && journalctl -u noriad -f -o cat
```

### Live Peers
```
PEERS="$(curl -sS https://noria-testnet.rpc.kjnodes.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.noria/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/noria/addrbook.json > $HOME/.noria/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/noria/genesis.json > $HOME/.noria/config/genesis.json
```