<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/bDUAwZhqBb" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://nodexcapital.com" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://timpi.io/wp-content/uploads/2023/01/Timpi-white.png">
</p>

# Timpi Testnet | Chain ID : TimpiChainTN2 | Custom Port : 225

### Community Documentation :
>- [Nodestake Setup Instructions](https://nodestake.top/timpi)

### Explorer:
>-  https://explorer.nodexcapital.com/timpi

### Automatic Installer
You can setup your Timpi Chain fullnode in few minutes by using automated script below.
```
wget -O timpi.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/timpi/timpi.sh && chmod +x timpi.sh && ./timpi.sh
```
### Public Endpoint

>- API : https://rest.timpi-t.nodexcapital.com
>- RPC : https://rpc.timpi-t.nodexcapital.com
>- gRPC : https://grpc.timpi-t.nodexcapital.com

### Snapshot
```
sudo systemctl stop timpid
cp $HOME/.TimpiChain/data/priv_validator_state.json $HOME/.TimpiChain/priv_validator_state.json.backup
rm -rf $HOME/.TimpiChain/data

curl -L https://snap.nodexcapital.com/timpi/timpi-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.TimpiChain

mv $HOME/.TimpiChain/priv_validator_state.json.backup $HOME/.TimpiChain/data/priv_validator_state.json

sudo systemctl start timpid && sudo journalctl -fu timpid -o cat
```

### State Sync
```
sudo systemctl stop timpid
cp $HOME/.TimpiChain/data/priv_validator_state.json $HOME/.TimpiChain/priv_validator_state.json.backup
timpid tendermint unsafe-reset-all --home $HOME/.TimpiChain

STATE_SYNC_RPC=https://rpc.timpi-t.nodexcapital.com:443
STATE_SYNC_PEER=d5519e378247dfb61dfe90652d1fe3e2b3005a5b@rpc.timpi-t.nodexcapital.com:22556
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  $HOME/.TimpiChain/config/config.toml

mv $HOME/.TimpiChain/priv_validator_state.json.backup $HOME/.TimpiChain/data/priv_validator_state.json

sudo systemctl start timpid && sudo journalctl -u timpid -f --no-hostname -o cat
```

### Disable State Sync 
After successful synchronization using state sync above, we advise you to disable synchronization with state sync and restart the node
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.TimpiChain/config/config.toml
sudo systemctl restart timpid && journalctl -u timpid -f -o cat
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.timpi-t.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.TimpiChain/config/config.toml
```
### Addrbook
```
curl -Ls https://snap.nodexcapital.com/timpi/addrbook.json > $HOME/.TimpiChain/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/timpi/genesis.json > $HOME/.TimpiChain/config/genesis.json
```