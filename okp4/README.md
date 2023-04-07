<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/bDUAwZhqBb" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://nodexcapital.com" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="100"  src="https://raw.githubusercontent.com/kj89/cosmos-images/main/logos/okp4.png">
</p>

# Okp4 Testnet | Chain ID: okp4-nemeton-1 | Custom Port 204

### Community Documentation:
>- [Obajay - STAVR](https://github.com/obajay/nodes-Guides/tree/main/OKP4)

### Explorer:
>- https://explorer.nodexcapital.com/okp4


### Automatic Installer
You can setup your okp4 fullnode in few minutes by using automated script below.
```
wget -O okp4.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/okp4/okp4.sh && chmod +x okp4.sh && ./okp4.sh
```
### Public Endpoint

>- API : https://rest.okp4-t.nodexcapital.com
>- RPC : https://rpc.okp4-t.nodexcapital.com
>- gRPC : https://grpc.okp4-t.nodexcapital.com

### Snapshot
```
sudo systemctl stop okp4d
cp $HOME/.okp4d/data/priv_validator_state.json $HOME/.okp4d/priv_validator_state.json.backup
rm -rf $HOME/.okp4d/data

curl -L https://snap.nodexcapital.com/okp4/okp4-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.okp4d
mv $HOME/.okp4d/priv_validator_state.json.backup $HOME/.okp4d/data/priv_validator_state.json

sudo systemctl start okp4d && sudo journalctl -u okp4d -f --no-hostname -o cat
```

### State Sync
```
Coming Soon
```

### Live Peers
```
PEERS="$(curl -sS https://rpc-t.okp4.nodestake.top/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.okp4d/config/config.toml
```
### Addrbook
```
curl -Ls https://snap.nodexcapital.com/okp4/addrbook.json > $HOME/.okp4d/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/okp4/genesis.json > $HOME/.okp4d/config/genesis.json
```