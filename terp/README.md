<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://nodejumper.io/assets/img/chain/gitopia.webp">
</p>

# Terp Network Testnet | Chain ID : athena-3

### Community Documentation:
>- [Validator Setup Instructions](https://nodejumper.io/terpnetwork-testnet/installation)

### Explorer:
>-  https://explorer.nodexcapital.com/terp

### Automatic Installer
You can setup your Terp fullnode in few minutes by using automated script below.
```
wget -O terp.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/terp/terp.sh && chmod +x terp.sh && ./terp.sh
```
### Public Endpoint

>- API : https://rest.terp-t.nodexcapital.com
>- RPC : https://rpc.terp-t.nodexcapital.com
>- gRPC : https://grpc.terp-t.nodexcapital.com

### Snapshot (Update every 5 hours)
```
sudo systemctl stop terpd
cp $HOME/.terp/data/priv_validator_state.json $HOME/.terp/data/priv_validator_state.json.backup
rm -rf $HOME/.terp/data

curl -L https://snap.nodexcapital.com/terp/terp-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.terp

mv $HOME/.terp/data/priv_validator_state.json.backup $HOME/.terp/data/priv_validator_state.json

sudo systemctl start terpd && sudo journalctl -fu terpd -o cat
```

### State Sync
```
systemctl stop terpd
terpd tendermint unsafe-reset-all --home $HOME/.terp --keep-addr-book

SNAP_RPC="https://rpc.terp.nodexcapital.com:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.terp/config/config.toml

sudo systemctl start terpd && sudo journalctl -fu terpd -o cat
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.terp-t.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.terp/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/terp/addrbook.json > $HOME/.terp/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/terp/genesis.json > $HOME/.terp/config/genesis.json
```