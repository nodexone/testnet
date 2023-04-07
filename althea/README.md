<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/bDUAwZhqBb" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://nodexcapital.com" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/althea.png">
</p>

# Althea Testnet | Chain ID : althea_7357-1 | Custom Port : 218

### Community Documentation:
>- [Pantek Installation](https://github.com/pantex6969/testing/blob/main/althea.sh)

### Explorer:
>-  https://explorer.nodexcapital.com/althea

### Automatic Installer
You can setup your Althea fullnode in few minutes by using automated script below.
```
wget -O althea.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/althea/althea.sh && chmod +x althea.sh && ./althea.sh
```
### Public Endpoint

>- API : https://rest.althea-t.nodexcapital.com
>- RPC : https://rpc.althea-t.nodexcapital.com
>- gRPC : https://grpc.althea-t.nodexcapital.com
>- JsonRPC : https://jsonrpc.althea-t.nodexcapital.com

### Snapshot
```
sudo systemctl stop althea
cp $HOME/.althea/data/priv_validator_state.json $HOME/.althea/priv_validator_state.json.backup
rm -rf $HOME/.althea/data

curl -L https://snap.nodexcapital.com/althea/althea-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.althea/
mv $HOME/.althea/priv_validator_state.json.backup $HOME/.althea/data/priv_validator_state.json

sudo systemctl start althea && sudo journalctl -fu althea -o cat
```

### State Sync
```
sudo systemctl stop althea
cp $HOME/.althea/data/priv_validator_state.json $HOME/.althea/priv_validator_state.json.backup
althea tendermint unsafe-reset-all --home $HOME/.althea

STATE_SYNC_RPC=https://rpc.althea-t.nodexcapital.com:443
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  $HOME/.althea/config/config.toml

mv $HOME/.althea/priv_validator_state.json.backup $HOME/.althea/data/priv_validator_state.json

sudo systemctl start althea && sudo journalctl -u althea -f --no-hostname -o cat
```

### Disable Sync with State Sync
After successful synchronization, we advise you to disable synchronization with state sync and restart the node
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.althea/config/config.toml
sudo systemctl restart althea && journalctl -u althea -f -o cat
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.althea-t.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.althea/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/althea/addrbook.json > $HOME/.althea/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/althea/genesis.json > $HOME/.althea/config/genesis.json
```