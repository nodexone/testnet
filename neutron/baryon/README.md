<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://avatars.githubusercontent.com/u/108675945?s=200&v=4">
</p>

# Neutron Testnet | Chain ID : baryon-1 | Custom Port : 238

### Official Documentation:
>- [Validator setup instructions](https://docs.neutron.org)

### Explorer:
>-  https://explorer.nodexcapital.com/neutron

### Automatic Installer for baryon-1
You can setup your Baryon fullnode in few minutes by using automated script below.
```
wget -O baryon.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/neutron/baryon/baryon.sh && chmod +x baryon.sh && ./baryon.sh
```

### Automatic Installer for provider
You can setup your Provider fullnode in few minutes by using automated script below.
```
wget -O provider.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/neutron/baryon/provider.sh && chmod +x provider.sh && ./provider.sh
```
### Public Endpoint

>- API : https://rest.neutron-t.nodexcapital.com
>- RPC : https://rpc.neutron-t.nodexcapital.com
>- gRPC : https://grpc.neutron-t.nodexcapital.com

### Snapshot
```
sudo systemctl stop neutrond
cp $HOME/.neutrond/data/priv_validator_state.json $HOME/.neutrond/priv_validator_state.json.backup
rm -rf $HOME/.neutrond/data

curl -L https://snap.nodexcapital.com/neutron/neutron-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.neutrond
mv $HOME/.neutrond/priv_validator_state.json.backup $HOME/.neutrond/data/priv_validator_state.json

sudo systemctl start neutrond && sudo journalctl -u neutrond -f --no-hostname -o cat
```

### State Sync
```
sudo systemctl stop neutrond
cp $HOME/.neutrond/data/priv_validator_state.json $HOME/.neutrond/priv_validator_state.json.backup
neutrond tendermint unsafe-reset-all --home $HOME/.neutrond

STATE_SYNC_RPC=https://rpc.neutrond-t.nodexcapital.com:443
STATE_SYNC_PEER=e2c07e8e6e808fb36cca0fc580e31216772841df@p2p.baryon.ntrn.info:26656
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  $HOME/.neutrond/config/config.toml

mv $HOME/.neutrond/priv_validator_state.json.backup $HOME/.neutrond/data/priv_validator_state.json

sudo systemctl start neutrond && sudo journalctl -u neutrond -f --no-hostname -o cat
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.neutron-t.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.neutrond/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/neutron/addrbook.json > $HOME/.neutrond/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/neutron/genesis.json > $HOME/.neutrond/config/genesis.json
```