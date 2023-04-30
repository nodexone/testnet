<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/bDUAwZhqBb" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://nodexcapital.com" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/blockx.png">
</p>

# BlockX Testnet | Chain ID : blockx_12345-2 | Custom Port : 212

### Community Documentation:
>- [Validator setup instructions](https://github.com/nodexcapital/testnet/tree/main/blockx)

### Explorer:
>-  https://explorer.nodexcapital.com/blockx

### Automatic Installer
You can setup your BlockX fullnode in few minutes by using automated script below.
```
wget -O blockx.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/blockx/blockx.sh && chmod +x blockx.sh && ./blockx.sh
```
### Public Endpoint

>- API : https://rest.blockx-t.nodexcapital.com
>- RPC : https://rpc.blockx-t.nodexcapital.com
>- gRPC : https://grpc.blockx-t.nodexcapital.com

### Snapshot
```
sudo systemctl stop blockxd
cp $HOME/.blockxd/data/priv_validator_state.json $HOME/.blockxd/priv_validator_state.json.backup
rm -rf $HOME/.blockxd/data

curl -L https://snap.nodexcapital.com/blockx/blockx-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.blockxd/
mv $HOME/.blockxd/priv_validator_state.json.backup $HOME/.blockxd/data/priv_validator_state.json

sudo systemctl start blockxd && sudo journalctl -fu blockxd -o cat
```

### State Sync
```
blockxd tendermint unsafe-reset-all --home $HOME/.blockxd --keep-addr-book

SNAP_RPC="https://rpc.blockx-t.nodexcapital.com:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.blockxd/config/config.toml

sudo systemctl start blockxd && sudo journalctl -fu blockxd -o cat
```
### Disable State Sync 
After successful synchronization using state sync above, we advise you to disable synchronization with state sync and restart the node
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.blockxd/config/config.toml
sudo systemctl restart blockxd && journalctl -u blockxd -f -o cat
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.blockx-t.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.blockxd/config/config.toml
```
### Addrbook
```
curl -Ls https://snap.nodexcapital.com/blockx/addrbook.json > $HOME/.blockxd/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/blockx/genesis.json > $HOME/.blockxd/config/genesis.json
```