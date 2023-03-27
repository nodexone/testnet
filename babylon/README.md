<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://nodejumper.io/assets/img/chain/babylon.webp">
</p>

# Babylon Testnet | Chain ID : bbn-test1 | Custom Port : 243

### Community Documentation:
>- [Validator Setup Instructions](https://nodejumper.io/babylon-testnet)

### Explorer:
>-  https://explorer.nodexcapital.com/babylon

### Automatic Installer
You can setup your Babylon fullnode in few minutes by using automated script below.
```
wget -O babylon.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/babylon/babylon.sh && chmod +x babylon.sh && ./babylon.sh
```
### Public Endpoints

>- API : https://rest.babylon-t.nodexcapital.com
>- RPC : https://rpc.babylon-t.nodexcapital.com
>- gRPC : https://grpc.babylon-t.nodexcapital.com

### Snapshot (Update every 5 hours)
```
sudo systemctl stop babylond
cp $HOME/.babylond/data/priv_validator_state.json $HOME/.babylond/priv_validator_state.json.backup
rm -rf $HOME/.babylond/data

curl -L https://snap.nodexcapital.com/babylon/babylon-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.babylond/
mv $HOME/.babylond/priv_validator_state.json.backup $HOME/.babylond/data/priv_validator_state.json

sudo systemctl start babylond && sudo journalctl -fu babylond -o cat
```

### State Sync
```
babylond tendermint unsafe-reset-all --home $HOME/.babylond --keep-addr-book

SNAP_RPC="https://rpc.babylon-t.nodexcapital.com:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.babylond/config/config.toml

sudo systemctl start babylond && sudo journalctl -fu babylond -o cat
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.babylon-t.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.babylond/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/babylon/addrbook.json > $HOME/.babylond/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/babylon/genesis.json > $HOME/.babylond/config/genesis.json
```