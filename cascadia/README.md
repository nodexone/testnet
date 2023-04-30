<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/bDUAwZhqBb" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://nodexcapital.com" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/kj89/cosmos-images/main/logos/cascadia.png">
</p>

# Cascadia Testnet | Chain ID : cascadia_6102-1 | Custom Port : 220

### Community Documentation:
>- [Validator setup instructions](https://services.kjnodes.com/home/testnet/cascadia)

### Explorer:
>-  https://explorer.nodexcapital.com/cascadia

### Automatic Installer
You can setup your cascadia fullnode in few minutes by using automated script below.
```
wget -O cascadia.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/cascadia/cascadia.sh && chmod +x cascadia.sh && ./cascadia.sh
```
### Public Endpoint

>- API : https://rest.cascadia-t.nodexcapital.com
>- RPC : https://rpc.cascadia-t.nodexcapital.com
>- gRPC : https://grpc.cascadia-t.nodexcapital.com

### Snapshot
```
sudo systemctl stop cascadiad
cp $HOME/.cascadiad/data/priv_validator_state.json $HOME/.cascadiad/priv_validator_state.json.backup
rm -rf $HOME/.cascadiad/data

curl -L https://snap.nodexcapital.com/cascadia/cascadia-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.cascadiad/
mv $HOME/.cascadiad/priv_validator_state.json.backup $HOME/.cascadiad/data/priv_validator_state.json

sudo systemctl start cascadiad && sudo journalctl -fu cascadiad -o cat
```

### State Sync
```
cascadiad tendermint unsafe-reset-all --home $HOME/.cascadiad --keep-addr-book

SNAP_RPC="https://rpc.cascadia-t.nodexcapital.com:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.cascadiad/config/config.toml

sudo systemctl start cascadiad && sudo journalctl -fu cascadiad -o cat
```
### Disable State Sync 
After successful synchronization using state sync above, we advise you to disable synchronization with state sync and restart the node
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.cascadiad/config/config.toml
sudo systemctl restart cascadiad && journalctl -u cascadiad -f -o cat
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.cascadia-t.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.cascadiad/config/config.toml
```
### Addrbook
```
curl -Ls https://snap.nodexcapital.com/cascadia/addrbook.json > $HOME/.cascadiad/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/cascadia/genesis.json > $HOME/.cascadiad/config/genesis.json
```