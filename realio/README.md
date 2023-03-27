<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/realio.png">
</p>

# Realio Network Testnet | Chain ID : realionetwork_3300-1 | Custom Port : 231

### Community Documentation:
>- https://nodeist.net/t/Realio/

### Explorer:
>-  https://explorer.nodexcapital.com/realio

### Automatic Installer
You can setup your Realio Network fullnode in few minutes by using automated script below.
```
wget -O realio.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/realio/realio.sh && chmod +x realio.sh && ./realio.sh
```
### Public Endpoint

>- API : https://rest.realio-t.nodexcapital.com
>- RPC : https://rpc.realio-t.nodexcapital.com
>- gRPC : https://grpc.realio-t.nodexcapital.com
>- Json RPC : https://jsonrpc.realio-t.nodexcapital.com

### Snapshot
```
sudo systemctl stop realio-networkd
cp $HOME/.realio-network/data/priv_validator_state.json $HOME/.realio-network/priv_validator_state.json.backup
rm -rf $HOME/.realio-network/data

curl -L https://snap.nodexcapital.com/realio/realio-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.realio-network

mv $HOME/.realio-network/priv_validator_state.json.backup $HOME/.realio-network/data/priv_validator_state.json

sudo systemctl start realio-networkd && sudo journalctl -fu realio-networkd -o cat
```

### State Sync
```
sudo systemctl stop realio-networkd
cp $HOME/.realio-network/data/priv_validator_state.json $HOME/.realio-network/priv_validator_state.json.backup
realio-networkd tendermint unsafe-reset-all --home $HOME/.realio-network

STATE_SYNC_RPC=https://rpc.realio-t.nodexcapital.com:443
STATE_SYNC_PEER=b0db1d25f10e94c13ba5080268e3f8c58eea6b69@rpc.realio-t.nodexcapital.com:23156
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  $HOME/.realio-network/config/config.toml

mv $HOME/.realio-network/priv_validator_state.json.backup $HOME/.realio-network/data/priv_validator_state.json

sudo systemctl start realio-networkd && sudo journalctl -u realio-networkd -f --no-hostname -o cat
```

### Disable State Sync 
After successful synchronization using state sync above, we advise you to disable synchronization with state sync and restart the node
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.realio-network/config/config.toml
sudo systemctl restart realio-networkd && journalctl -u realio-networkd -f -o cat
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.realio-t.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.realio-network/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/realio/addrbook.json > $HOME/.realio-network/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/realio/genesis.json > $HOME/.realio-network/config/genesis.json
```