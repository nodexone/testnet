<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/34649601/207593974-32d7cb69-eca9-4096-bc96-246fe7038c88.png">
</p>

# Nolus Testnet | Chain ID : nolus-rila

### Official documentation:
>- [Validator setup instructions](https://docs-nolus-protocol.notion.site/Nolus-Protocol-Docs-a0ddfe091cc5456183417a68502705f8)

### Explorer:
>-  https://explorer.nodexcapital.com/nolus

### Automatic Installer
You can setup your Nolus fullnode in few minutes by using automated script below.
```
wget -O nolus.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/nolus/nolus.sh && chmod +x nolus.sh && ./nolus.sh
```
### Public Endpoint

>- API : https://api.nolus.nodexcapital.com
>- RPC : https://rpc.nolus.nodexcapital.com
>- gRPC : https://grpc.nolus.nodexcapital.com
>- gRPC Web : https://grpc-web.nolus.nodexcapital.com

### Snapshot (Update every 5 hours)
```
sudo systemctl stop nolusd
cp $HOME/.nolus/data/priv_validator_state.json $HOME/.nolus/data/priv_validator_state.json.backup
rm -rf $HOME/.nolus/data

curl -L https://snap.nodexcapital.com/nolus/nolus-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.nolus

mv $HOME/.nolus/data/priv_validator_state.json.backup $HOME/.nolus/data/priv_validator_state.json

sudo systemctl start nolusd && sudo journalctl -fu nolusd -o cat
```

### State Sync
```
nolusd tendermint unsafe-reset-all --home $HOME/.nolus --keep-addr-book

SNAP_RPC="https://rpc.nolus.nodexcapital.com:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.nolus/config/config.toml

sudo systemctl start nolusd && sudo journalctl -fu nolusd -o cat
```

### Seed Peers
```
sed -i -e "s|^seeds *=.*|seeds = \"3f472746f46493309650e5a033076689996c8881@nolus-testnet.rpc.kjnodes.com:43659\"|" $HOME/.nolus/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/nolus/addrbook.json > $HOME/.nolus/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/nolus/genesis.json > $HOME/.nolus/config/genesis.json
```