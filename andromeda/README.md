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

### Automatic Installer (Must Using Ubuntu 22.04)
You can setup your Andromeda fullnode in few minutes by using automated script below.
```
wget -O andromeda.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/andromeda/andromeda.sh && chmod +x andromeda.sh && ./andromeda.sh
```
### Public Endpoint

>- API : https://api.andromeda-t.nodexcapital.com
>- RPC : https://rpc.andromeda-t.nodexcapital.com
>- gRPC : https://grpc.andromeda-t.nodexcapital.com

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

STATE_SYNC_RPC=https://rpc.andromeda-t.nodexcapital.com:443
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

### Disable State Sync 
After successful synchronization using state sync above, we advise you to disable synchronization with state sync and restart the node
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.andromedad/config/config.toml
sudo systemctl restart andromedad && journalctl -u andromedad -f -o cat

### Live Peers
```
PEERS="8083dd301a7189284bf5b8d40c4cf239360d653a@5.9.122.49:26656,749114faeb62649d94b8ed496efbdcd4a08b2e3e@136.243.93.134:20095,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:47656,ef6ec2cf74e157e3c6056c0469f3ede08b418ec7@144.76.164.139:15656,c5f6021d8da08ff53e90725c0c2a77f8d65f5e03@195.201.195.40:26656,f1d30c5f2d5882823317718eb4455f87ae846d0a@85.239.235.235:30656,334a842f175c2c24c6b11e8bce39c9d3443471ae@38.242.213.79:26656,d78df88bc4a487c140e466a23f549ed90e7ebfb6@161.97.152.157:27656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.andromedad/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/andromeda/addrbook.json > $HOME/.andromedad/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/andromeda/genesis.json > $HOME/.andromedad/config/genesis.json
```