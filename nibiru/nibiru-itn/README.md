<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://www.yeksin.net/wp-content/uploads/elementor/thumbs/nibiru-1-pxec4xhz4a2ae7d0zpdst55ws50bo3xhjhozbpn4j2.png">
</p>

# Nibiru  Incentivized Testnet | Chain ID : nibiru-itn-1 | Custom Port : 224

### Official Documentation:
>- [Validator setup instructions](#)

### Explorer:
>-  https://explorer.nodexcapital.com/nibiru-itn

### Automatic  (Must Using Ubuntu 22.04)
You can setup your Nibiru Incentivized Testnet fullnode in few minutes by using automated script below.
```
wget -O itn-1.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/nibiru/nibiru-itn/itn-1.sh && chmod +x itn-1.sh && ./itn-1.sh
```
### Public Endpoint

>- API : https://rest.nibiru-itn.nodexcapital.com
>- RPC : https://rpc.nibiru-itn.nodexcapital.com
>- gRPC : https://grpc.nibiru-itn.nodexcapital.com

### Snapshot (Update every 5 hours)
```
sudo systemctl stop nibid
cp $HOME/.nibid/data/priv_validator_state.json $HOME/.nibid/priv_validator_state.json.backup
rm -rf $HOME/.nibid/data

curl -L https://nibiru-t.service.indonode.net/nibiru-snapshot.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.nibid
mv $HOME/.nibid/priv_validator_state.json.backup $HOME/.nibid/data/priv_validator_state.json

sudo systemctl start nibid && sudo journalctl -u nibid -f --no-hostname -o cat
```

### State Sync
```
sudo systemctl stop nibid
cp $HOME/.nibid/data/priv_validator_state.json $HOME/.nibid/priv_validator_state.json.backup
nibid tendermint unsafe-reset-all --home $HOME/.nibid

STATE_SYNC_RPC=https://rpc.nibid-itn.nodexcapital.com:443
STATE_SYNC_PEER=d5519e378247dfb61dfe90652d1fe3e2b3005a5b@dymension-testnet.rpc.kjnodes.com:46656
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  $HOME/.nibid/config/config.toml

mv $HOME/.nibid/priv_validator_state.json.backup $HOME/.nibid/data/priv_validator_state.json
sudo systemctl start nibid && sudo journalctl -u nibid -f --no-hostname -o cat
```
### Disable State Sync 
After successful synchronization using state sync above, we advise you to disable synchronization with state sync and restart the node
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.nibid/config/config.toml
sudo systemctl restart nibid && journalctl -u nibid -f -o cat

### Live Peers
```
PEERS="$(curl -sS https://rpc.nibiru-t.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.nibid/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://ss-t.nibiru.nodestake.top/addrbook.json > $HOME//.nibid/config/addrbook.json
```
### Genesis
```
curl -Ls https://snapshot.yeksin.net/nibiru/genesis.json > $HOME/.nibid/config/genesis.json
```