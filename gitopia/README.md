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

# Gtiopia Testnet | Chain ID : gitopia-janus-testnet-2 | Custom Port : 227

### Community Documentation:
>- [Validator Setup Instructions](https://nodejumper.io/gitopia-testnet/installation)

### Explorer:
>-  https://explorer.nodexcapital.com/gitopia

### Automatic Installer (Must Using Ubuntu 22.04)
You can setup your Gitopia fullnode in few minutes by using automated script below.
```
wget -O gitopia.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/gitopia/gitopia.sh && chmod +x gitopia.sh && ./gitopia.sh
```
### Public Endpoint

>- API : https://api.gitopia-t.nodexcapital.com
>- RPC : https://rpc.gitopia-t.nodexcapital.com
>- gRPC : https://grpc.gitopia-t.nodexcapital.com

### Snapshot (Update every 5 hours)
```
sudo systemctl stop gitopiad
cp $HOME/.gitopia/data/priv_validator_state.json $HOME/.gitopia/priv_validator_state.json.backup
rm -rf $HOME/.gitopia/data

curl -L https://snapshots.kjnodes.com/gitopia-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.gitopia
mv $HOME/.gitopia/priv_validator_state.json.backup $HOME/.gitopia/data/priv_validator_state.json

sudo systemctl start gitopiad && sudo journalctl -u gitopiad -f --no-hostname -o cat
```

### State Sync
```
sudo systemctl stop gitopiad
cp $HOME/.gitopia/data/priv_validator_state.json $HOME/.gitopia/priv_validator_state.json.backup
gitopiad tendermint unsafe-reset-all --home $HOME/.gitopia

STATE_SYNC_RPC=https://rpc.gitopia-t.nodexcapital.com:443
STATE_SYNC_PEER=d5519e378247dfb61dfe90652d1fe3e2b3005a5b@gitopia-testnet.rpc.kjnodes.com:41656
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  $HOME/.gitopia/config/config.toml

mv $HOME/.gitopia/priv_validator_state.json.backup $HOME/.gitopia/data/priv_validator_state.json

sudo systemctl start gitopiad && sudo journalctl -u gitopiad -f --no-hostname -o cat
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.gitopia-t.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.gitopia/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/gitopia/addrbook.json > $HOME/.gitopia/config/addrbook.json
```
### Genesis
```
curl -Ls https://snaps.nodexcapital.com/gitopia/genesis.json > $HOME/.gitopia/config/genesis.json
```