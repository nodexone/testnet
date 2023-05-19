<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/bDUAwZhqBb" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://nodexcapital.com" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/kj89/cosmos-images/main/logos/composable.png">
</p>



### Community Documentation:
>- [Kjnodes Manual Installation](https://services.kjnodes.com/home/testnet/composable/installation)

### Explorer:
>-  https://explorer.nodexcapital.com/composable

### Automatic Installer
You can setup your composable fullnode in few minutes by using automated script below.
```
wget -O composable.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/composable/composable.sh && chmod +x composable.sh && ./composable.sh
```
### Public Endpoint

>- API : https://rest.composable-t.nodexcapital.com
>- RPC : https://rpc.composable-t.nodexcapital.com
>- gRPC : https://grpc.composable-t.nodexcapital.com

### Snapshot
```
sudo systemctl stop banksyd
cp $HOME/.banksy/data/priv_validator_state.json $HOME/.banksy/priv_validator_state.json.backup
rm -rf $HOME/.banksy/data

curl -L https://snap.nodexcapital.com/composable/composable-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.banksy
mv $HOME/.banksy/priv_validator_state.json.backup $HOME/.banksy/data/priv_validator_state.json

sudo systemctl start banksyd && sudo journalctl -u banksyd -f --no-hostname -o cat
```

### State Sync
```
sudo systemctl stop banksyd
cp $HOME/.banksy/data/priv_validator_state.json $HOME/.banksy/priv_validator_state.json.backup
banksyd tendermint unsafe-reset-all --home $HOME/.banksy

STATE_SYNC_RPC=https://composable-testnet.rpc.kjnodes.com:443
STATE_SYNC_PEER=d5519e378247dfb61dfe90652d1fe3e2b3005a5b@composable-testnet.rpc.kjnodes.com:15956
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 1000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  $HOME/.banksy/config/config.toml

mv $HOME/.banksy/priv_validator_state.json.backup $HOME/.banksy/data/priv_validator_state.json

curl -L https://snapshots.kjnodes.com/composable-testnet/wasm_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.banksy

sudo systemctl start banksyd && sudo journalctl -u banksyd -f --no-hostname -o cat
```

### Disable State Sync
```
Coming Soon
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.composable-t.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.banksy/config/config.toml
```
### Addrbook
```
curl -Ls https://snap.nodexcapital.com/composable/addrbook.json > $HOME/.banksy/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/composable/genesis.json > $HOME/.banksy/config/genesis.json
```