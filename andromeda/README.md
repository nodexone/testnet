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

### Community Documentation :
>- [Validator Setup Instructions](https://services.kjnodes.com/home/testnet/andromeda)

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

### Snapshot (Update every 5 hours)
```
sudo systemctl stop andromedad
cp $HOME/.andromedad/data/priv_validator_state.json $HOME/.andromedad/priv_validator_state.json.backup
rm -rf $HOME/.andromedad/data

curl -L https://snapshots.kjnodes.com/andromeda-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.andromedad

mv $HOME/.andromedad/priv_validator_state.json.backup $HOME/.andromedad/data/priv_validator_state.json

sudo systemctl start andromedad && sudo journalctl -fu andromedad -o cat
```

### State Sync
```
sudo systemctl stop andromedad
cp $HOME/.andromedad/data/priv_validator_state.json $HOME/.andromedad/priv_validator_state.json.backup
andromedad tendermint unsafe-reset-all --home $HOME/.andromedad

STATE_SYNC_RPC=https://andromeda-testnet.rpc.kjnodes.com:443
STATE_SYNC_PEER=d5519e378247dfb61dfe90652d1fe3e2b3005a5b@andromeda-testnet.rpc.kjnodes.com:47656
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  $HOME/.andromedad/config/config.toml

mv $HOME/.andromedad/priv_validator_state.json.backup $HOME/.andromedad/data/priv_validator_state.json

curl -L https://snapshots.kjnodes.com/andromeda-testnet/wasm_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.andromedad

sudo systemctl start andromedad && sudo journalctl -u andromedad -f --no-hostname -o cat
```

### Live Peers
```
Coming Soon
```
### Addrbook (Update every hour)
```
curl -Ls https://snapshots.kjnodes.com/andromeda-testnet/addrbook.json > $HOME/.andromedad/config/addrbook.json
```
### Genesis
```
curl -Ls https://snapshots.kjnodes.com/andromeda-testnet/genesis.json > $HOME/.andromedad/config/genesis.json
```