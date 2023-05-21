<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/bDUAwZhqBb" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://nodexcapital.com" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://wallet-testnet.c4e.io/img/c4elogo-new.de509928.svg">
</p>



### Community Documentation:
>- [NodeX Capital Guide](https://github.com/nodexcapital/tesnet)

### Explorer:
>-  https://explorer.nodexcapital.com/c4e

### Automatic Installer
You can setup your c4e fullnode in few minutes by using automated script below.
```
wget -O c4e.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/chain4energy/c4e.sh && chmod +x c4e.sh && ./c4e.sh
```
### Public Endpoint

>- API : https://rest.c4e-t.nodexcapital.com
>- RPC : https://rpc.c4e-t.nodexcapital.com
>- gRPC : https://grpc.c4e-t.nodexcapital.com

### Snapshot
```
sudo systemctl stop c4ed
cp $HOME/.c4e-chain/data/priv_validator_state.json $HOME/.c4e-chain/priv_validator_state.json.backup
rm -rf $HOME/.c4e-chain/data

curl -L https://snap.nodexcapital.com/c4e/c4e-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.c4e-chain
mv $HOME/.c4e-chain/priv_validator_state.json.backup $HOME/.c4e-chain/data/priv_validator_state.json

sudo systemctl start c4ed && sudo journalctl -u c4ed -f --no-hostname -o cat
```

### State Sync
```
sudo systemctl stop c4ed
cp $HOME/.c4e-chain/data/priv_validator_state.json $HOME/.c4e-chain/priv_validator_state.json.backup
c4ed tendermint unsafe-reset-all --home $HOME/.c4e-chain

STATE_SYNC_RPC=https://rpc.c4e-t.nodexcapital.com
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 1000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  $HOME/.c4e-chain/config/config.toml

mv $HOME/.c4e-chain/priv_validator_state.json.backup $HOME/.c4e-chain/data/priv_validator_state.json

curl -L https://snap.nodexcapital.com/c4e/wasm_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.c4e-chain

sudo systemctl start c4ed && sudo journalctl -u c4ed -f --no-hostname -o cat
```

### Disable State Sync
```
Coming Soon
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.c4e-t.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.c4e-chain/config/config.toml
```
### Addrbook
```
curl -Ls https://snap.nodexcapital.com/c4e/addrbook.json > $HOME/.c4e-chain/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/c4e/genesis.json > $HOME/.c4e-chain/config/genesis.json
```