<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/bDUAwZhqBb" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://nodexcapital.com" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://www.zetachain.com/img/logos/zetachain-logo.svg">
</p>

# Zetachain Testnet | Chain ID : athens_7001-1 | Custom Port : 226

### Community Documentation :
>- [Kjnodes Setup Instructions](https://services.kjnodes.com/testnet/zetachain/)

### Explorer:
>-  https://explorer.nodexcapital.com/zetachain

### Automatic Installer
You can setup your Zetachain fullnode in few minutes by using automated script below.
```
wget -O zetachain.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/zetachain/zetachain.sh && chmod +x zetachain.sh && ./zetachain.sh
```
### Public Endpoint

>- API : https://rest.zetachain-t.nodexcapital.com
>- RPC : https://rpc.zetachaind-t.nodexcapital.com
>- gRPC : https://grpc.zetachain-t.nodexcapital.com

### Snapshot
```
sudo systemctl stop zetacored
cp $HOME/.zetacored/data/priv_validator_state.json $HOME/.zetacored/priv_validator_state.json.backup
rm -rf $HOME/.zetacored/data

curl -L https://snap.nodexcapital.com/zetachain/zetachain-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.zetacored

mv $HOME/.zetacored/priv_validator_state.json.backup $HOME/.zetacored/data/priv_validator_state.json

sudo systemctl start zetacored && sudo journalctl -fu zetacored -o cat
```

### State Sync
```
sudo systemctl stop zetacored
cp $HOME/.zetacored/data/priv_validator_state.json $HOME/.zetacored/priv_validator_state.json.backup
zetacored tendermint unsafe-reset-all --home $HOME/.zetacored

STATE_SYNC_RPC=https://zetachain-testnet.rpc.kjnodes.com:443
STATE_SYNC_PEER=d5519e378247dfb61dfe90652d1fe3e2b3005a5b@zetachain-testnet.rpc.kjnodes.com:16056
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  $HOME/.zetacored/config/config.toml

mv $HOME/.zetacored/priv_validator_state.json.backup $HOME/.zetacored/data/priv_validator_state.json

sudo systemctl start zetacored && sudo journalctl -u zetacored -f --no-hostname -o cat
```

### Disable State Sync 
After successful synchronization using state sync above, we advise you to disable synchronization with state sync and restart the node
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.zetacored/config/config.toml
sudo systemctl restart zetacored && journalctl -u zetacored -f -o cat
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.zetachain-t.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.zetacored/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/zetachain/addrbook.json > $HOME/.zetacored/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/zetachain/genesis.json > $HOME/.zetacored/config/genesis.json
```