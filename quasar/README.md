<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/kj89/testnet_manuals/main/pingpub/logos/quasar.png">
</p>

# Quasar Testnet | Chain ID : qsr-questnet-04

### Community Documentation:
>- [Validator setup instructions](https://services.kjnodes.com/home/testnet/quasar/installation)

### Explorer:
>-  https://explorer.nodexcapital.com/quasar

### Automatic Installer
You can setup your Quasar fullnode in few minutes by using automated script below.
```
wget -O quasar.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/quasar/quasar.sh && chmod +x quasar.sh && ./quasar.sh
```
### Public Endpoint

>- API : https://api.quasar.nodexcapital.com
>- RPC : https://rpc.quasar.nodexcapital.com
>- gRPC : https://grpc.quasar.nodexcapital.com
>- gRPC Web : https://grpc-web.quasar.nodexcapital.com

### Snapshot (Update every 5 hours)
```
sudo systemctl stop quasard
cp $HOME/.quasarnode/data/priv_validator_state.json $HOME/.quasarnode/priv_validator_state.json.backup
rm -rf $HOME/.quasarnode/data

curl -L https://snap.nodexcapital.com/quasar/quasar-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.quasarnode/
mv $HOME/.quasarnode/priv_validator_state.json.backup $HOME/.quasarnode/data/priv_validator_state.json

sudo systemctl start quasard && sudo journalctl -fu quasard -o cat
```

### State Sync
```
quasard tendermint unsafe-reset-all --home $HOME/.quasarnode --keep-addr-book

SNAP_RPC="https://rpc.quasar.nodexcapital.com:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.quasarnode/config/config.toml

sudo systemctl start quasard && sudo journalctl -fu quasard -o cat
```

### Live Peers
```
PEERS=8a19aa6e874ed5720aad2e7d02567ec932d92d22@141.94.248.63:26656,444b80ce750976df59b88ac2e08d720e1dbbf230@68.183.75.239:26666,20b4f9207cdc9d0310399f848f057621f7251846@222.106.187.13:40606,7ef67269c8ec37ff8a538a5ae83ca670fd2da686@137.184.192.123:26656,19afe579cc0a2b38ca87143f779f45e9a7f18a2f@18.134.191.148:26656,a23f002bda10cb90fa441a9f2435802b35164441@38.146.3.203:18256,bba6e85e3d1f1d9c127324e71a982ddd86af9a99@88.99.3.158:18256,966acc999443bae0857604a9fce426b5e09a7409@65.108.105.48:18256 ,177144bed1e280a6f2435d253441e3e4f1699c6d@65.109.85.226:8090,769ebaa9942375e70cebc21a75a2cfda41049d99@135.181.210.186:26656,8937bdacf1f0c8b2d1ffb4606554eaf08bd55df4@5.75.255.107:26656,99a0695a7358fa520e6fcd46f91492f7cf205d4d@34.175.159.249:26656,47401f4ac3f934afad079ddbe4733e66b58b67da@34.175.244.202:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.quasarnode/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/quasar/addrbook.json > $HOME/.quasarnode/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/quasar/genesis.json > $HOME/.quasarnode/config/genesis.json
```