<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/bDUAwZhqBb" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://nodexcapital.com" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="100"  src="https://www.routerprotocol.com/_nuxt/img/logoNew.f8de0bf.svg">
</p>

# Router Testnet | Chain ID: router_9601-1 | Custom Port 222

### Community Documentation:
>- [NodeX Emperor Service](https://github.com/nodexcapital/testnet/tree/main/router)

### Explorer:
>- https://explorer.nodexcapital.com/router


### Automatic Installer
You can setup your router fullnode in few minutes by using automated script below.
```
wget -O router.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/router/router.sh && chmod +x router.sh && ./router.sh
```
### Public Endpoint

>- API : https://rest.router-t.nodexcapital.com
>- RPC : https://rpc.router-t.nodexcapital.com

### Snapshot
```
sudo systemctl stop routerd
cp $HOME/.routerd/data/priv_validator_state.json $HOME/.routerd/priv_validator_state.json.backup
rm -rf $HOME/.routerd/data

curl -L https://snap.nodexcapital.com/router/router-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.routerd
mv $HOME/.routerd/priv_validator_state.json.backup $HOME/.routerd/data/priv_validator_state.json

sudo systemctl start routerd && sudo journalctl -u routerd -f --no-hostname -o cat
```

### State Sync
```
After successful synchronization using state sync above, we advise you to disable synchronization with state sync and restart the node
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.routerd/config/config.toml
sudo systemctl restart routerd && journalctl -u routerd -f -o cat
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.router-t.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.routerd/config/config.toml
```
### Addrbook
```
curl -Ls https://snap.nodexcapital.com/router/addrbook.json > $HOME/.routerd/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/router/genesis.json > $HOME/.routerd/config/genesis.json
```