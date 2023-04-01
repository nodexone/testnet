<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/bDUAwZhqBb" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://nodexcapital.com" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://polkachu.com/images/chains/ojo.png">
</p>

# Ojo Testnet | Chain ID : ojo-devnet | Custom Port : 216

### Community Documentation :
>- [Validator Setup Instructions](https://polkachu.com/testnets/ojo)

### Explorer:
>-  https://explorer.nodexcapital.com/ojo

### Automatic Installer (Must Using Ubuntu 22.04)
You can setup your Ojo Network fullnode in few minutes by using automated script below.
```
wget -O ojo.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/ojonetwork/ojo.sh && chmod +x ojo.sh && ./ojo.sh
```
### Public Endpoint

>- API : https://rest.ojo-t.nodexcapital.com
>- RPC : https://rpc.ojo-t.nodexcapital.com
>- gRPC : https://grpc.ojo-t.nodexcapital.com

### Snapshot (Update every 5 hours)
```
sudo systemctl stop ojod
cp $HOME/.ojo/data/priv_validator_state.json $HOME/.ojo/priv_validator_state.json.backup
rm -rf $HOME/.ojo/data

curl -L https://snap.nodexcapital.com/ojo/ojo-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.ojo

mv $HOME/.ojo/priv_validator_state.json.backup $HOME/.ojo/data/priv_validator_state.json

sudo systemctl start ojod && sudo journalctl -fu ojod -o cat
```

### State Sync
```
sudo systemctl stop ojod
cp $HOME/.ojo/data/priv_validator_state.json $HOME/.ojo/priv_validator_state.json.backup
ojod tendermint unsafe-reset-all --home $HOME/.ojo

STATE_SYNC_RPC=https://rpc.ojo-t.nodexcapital.com:443
STATE_SYNC_PEER=d5b2ae8815b09a30ab253957f7eca052dde3101d@rpc.ojo-t.nodexcapital.com:24656
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  $HOME/.ojo/config/config.toml

mv $HOME/.ojo/priv_validator_state.json.backup $HOME/.ojo/data/priv_validator_state.json

sudo systemctl start ojod && sudo journalctl -u ojod -f --no-hostname -o cat
```

### Disable State Sync 
After successful synchronization using state sync above, we advise you to disable synchronization with state sync and restart the node
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.ojo/config/config.toml
sudo systemctl restart ojod && journalctl -u ojod -f -o cat
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.ojo-t.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.ojo/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/ojo/addrbook.json > $HOME/.ojo/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/ojo/genesis.json > $HOME/.ojo/config/genesis.json
```