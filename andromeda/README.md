<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/andromeda.png">
</p>

# Andromeda Testnet | Chain ID : galileo-3

### Community Documentation:
>- [Validator Setup Instructions](https://nodeist.net/t/Andromeda/)

### Explorer:
>-  https://explorer.nodexcapital.com/andromeda

### Automatic Installer
You can setup your Andromeda fullnode in few minutes by using automated script below.
```
wget -O andromeda.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/andromeda/andromeda.sh && chmod +x andromeda.sh && ./andromeda.sh
```
### Public Endpoint

>- API : https://api.andromeda.nodexcapital.com
>- RPC : https://rpc.andromeda.nodexcapital.com
>- gRPC : https://grpc.andromeda.nodexcapital.com
>- gRPC Web : https://grpc-web.andromeda.nodexcapital.com

### Snapshot (Update every 5 hours)
```
sudo systemctl stop andromedad
cp $HOME/.andromedad/data/priv_validator_state.json $HOME/.andromedad/priv_validator_state.json.backup
rm -rf $HOME/.andromedad/data

curl -L https://snap.nodexcapital.com/quasar/quasar-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.andromedad/
mv $HOME/.andromedad/priv_validator_state.json.backup $HOME/.andromedad/data/priv_validator_state.json

sudo systemctl start andromedad && sudo journalctl -fu andromedad -o cat
```

### State Sync
```
andromedad tendermint unsafe-reset-all --home $HOME/.andromedad --keep-addr-book

SNAP_RPC="https://rpc.andromeda.nodexcapital.com:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.andromedad/config/config.toml

sudo systemctl start andromedad && sudo journalctl -fu andromedad -o cat
```

### Live Peers
```
PEERS=06d4ab2369406136c00a839efc30ea5df9acaf11@10.128.0.44:26656,43d667323445c8f4d450d5d5352f499fa04839a8@192.168.0.237:26656,29a9c5bfb54343d25c89d7119fade8b18201c503@192.168.101.79:26656,6006190d5a3a9686bbcce26abc79c7f3f868f43a@37.252.184.230:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.andromedad/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/andromeda/addrbook.json > $HOME/.andromedad/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/andromeda/genesis.json > $HOME/.andromedad/config/genesis.json
```