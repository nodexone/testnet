<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/171904810-664af00a-e78a-4602-b66b-20bfd874fa82.png">
</p>

# Defund Testnet | Chain ID : defund-private-4 | Custom Port : 228

### Official Documentation:
>- [Validator setup instructions](https://github.com/defund-labs/defund/blob/main/testnet/private/validators.md)


### Explorer
>- https://explorer.nodexcapital.com/defund

### Automatic Installer
You can setup your Defund fullnode in few minutes by using automated script below.
```
wget -O defund.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/defund/defund.sh && chmod +x defund.sh && ./defund.sh
```
### Public Endpoint

>- API : https://rest.defund-t.nodexcapital.com
>- RPC : https://rpc.defund-t.nodexcapital.com
>- gRPC : https://grpc.defund-t.nodexcapital.com

### Snapshot (Update every 5 hours)
```
sudo systemctl stop defundd
cp $HOME/.defund/data/priv_validator_state.json $HOME/.defund/priv_validator_state.json.backup
rm -rf $HOME/.defund/data

curl -L https://snapshots.kjnodes.com/defund-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.defund

mv $HOME/.defund/priv_validator_state.json.backup $HOME/.defund/data/priv_validator_state.json

sudo systemctl start defundd && sudo journalctl -fu defundd -o cat
```

### State Sync
```
Currently defund does not support State sync 😢
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.defund-t.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.defund/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snapshots.kjnodes.com/defund-testnet/addrbook.json > $HOME/.defund/config/addrbook.json
```
### Genesis
```
curl -Ls https://snapshots.kjnodes.com/defund-testnet/genesis.json > $HOME/.defund/config/genesis.json
```