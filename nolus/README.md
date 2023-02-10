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
You can setup your planq fullnode in few minutes by using automated script below.
```
wget -O nolus.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/nolus/nolus.sh && chmod +x nolus.sh && ./nolus.sh
```
### Public Endpoint

>- API : https://api.nolus.nodexcapital.com
>- RPC : https://api.nolus.nodexcapital.com
>- gRPC : https://api.nolus.nodexcapital.com
>- gRPC Web : https://api.nolus.nodexcapital.com

### Snapshot (Update every 5 hours)
```
sudo systemctl stop cored
cp $HOME/.core/coreum-testnet-1/data/priv_validator_state.json $HOME/.nolus/priv_validator_state.json.backup
rm -rf $HOME/.core/coreum-testnet-1/data

curl -L https://snap.nodexcapital.com/nolus/nolus-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.nolus
mv $HOME/.core/coreum-testnet-1/priv_validator_state.json.backup $HOME/.nolus/data/priv_validator_state.json

sudo systemctl start cored && sudo journalctl -fu cored -o cat
```

### State Sync
```
cored tendermint unsafe-reset-all --home $HOME/.nolus --keep-addr-book

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

### Live Peers
```
PEERS="69d7028b7b3c40f64ea43208ecdd43e88c797fd6@34.69.126.231:26656,b2978432c0126f28a6be7d62892f8ded1e48d227@34.70.241.13:26656,7c0d4ce5ad561c3453e2e837d85c9745b76f7972@35.238.77.191:26656,0aa5fa2507ada8a555d156920c0b09f0d633b0f9@34.173.227.148:26656,4b8d541efbb343effa1b5079de0b17d2566ac0fd@34.172.70.24:26656,27450dc5adcebc84ccd831b42fcd73cb69970881@35.239.146.40:26656,5add70ec357311d07d10a730b4ec25107399e83c@5.196.7.58:26656,1a3a573c53a4b90ab04eb47d160f4d3d6aa58000@35.233.117.165:26656,abbeb588ad88176a8d7592cd8706ebbf7ef20cfe@185.241.151.197:26656,39a34cd4f1e908a88a726b2444c6a407f67e4229@158.160.59.199:26656,051a07f1018cfdd6c24bebb3094179a6ceda2482@138.201.123.234:26656,cc6d4220633104885b89e2e0545e04b8162d69b5@75.119.134.20:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.nolus/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/coreum/addrbook.json > $HOME/.nolus/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/coreum/genesis.json > $HOME/.nolus/config/genesis.json
```