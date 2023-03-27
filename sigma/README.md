<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/sge.png">
</p>

# SGE Network Testnet | Chain ID : sge-testnet-1 | Custom Port : 232

### Community Documentation:
>- https://nodeist.net/t/Sge/

### Explorer:
>-  https://explorer.nodexcapital.com/sigma

### Automatic Installer (Mush Using Ubuntu 22)
You can setup your SGE Network fullnode in few minutes by using automated script below.
```
wget -O sge.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/sigma/sge.sh && chmod +x sge.sh && ./sge.sh
```
### Public Endpoint

>- API : https://rest.sge-t.nodexcapital.com
>- RPC : https://rpc.sge-t.nodexcapital.com
>- gRPC : https://grpc.sge-t.nodexcapital.com

### Snapshot (Update every 5 hours)
```
sudo systemctl stop sged
cp $HOME/.sge/data/priv_validator_state.json $HOME/.sge/priv_validator_state.json.backup
rm -rf $HOME/.sge/data

curl -L https://snap.nodexcapital.com/sge/sge-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.sge/
mv $HOME/.sge/priv_validator_state.json.backup $HOME/.sge/data/priv_validator_state.json

sudo systemctl start sged && sudo journalctl -fu sged -o cat
```

### State Sync
```
sudo systemctl stop sged
cp $HOME/.sge/data/priv_validator_state.json $HOME/.sge/priv_validator_state.json.backup
sged tendermint unsafe-reset-all --home $HOME/.sge

STATE_SYNC_RPC=https://rpc-sge.nodeist.net:443
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  $HOME/.sge/config/config.toml

mv $HOME/.sge/priv_validator_state.json.backup $HOME/.sge/data/priv_validator_state.json

sudo systemctl start sged && sudo journalctl -u sged -f --no-hostname -o cat
```

### Disable Sync with State Sync
After successful synchronization, we advise you to disable synchronization with state sync and restart the node
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.sge/config/config.toml
sudo systemctl restart sged && journalctl -u sged -f -o cat
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.sge-t.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.sge/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/sge/addrbook.json > $HOME/.sge/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/sge/genesis.json > $HOME/.sge/config/genesis.json
```