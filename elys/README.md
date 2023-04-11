<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/bDUAwZhqBb" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://nodexcapital.com" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://polkachu.com/images/chains/elys.png">
</p>



### Community Documentation:
>- [Polkachu Manual Installation](https://polkachu.com/testnets/elys)

### Explorer:
>-  https://explorer.nodexcapital.com/elys

### Automatic Installer
You can setup your Elys fullnode in few minutes by using automated script below.
```
wget -O elys.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/elys/elys.sh && chmod +x elys.sh && ./elys.sh
```
### Public Endpoint

>- API : https://rest.elys-t.nodexcapital.com
>- RPC : https://rpc.elys-t.nodexcapital.com
>- gRPC : https://grpc.elys-t.nodexcapital.com

### Snapshot (Update every 5 hours)
```
sudo systemctl stop elysd
cp $HOME/.elys/data/priv_validator_state.json $HOME/.elys/priv_validator_state.json.backup
rm -rf $HOME/.elys/data

curl -L https://snap.nodexcapital.com/elys/elys-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.elys
mv $HOME/.elys/priv_validator_state.json.backup $HOME/.elys/data/priv_validator_state.json

sudo systemctl start elysd && sudo journalctl -u elysd -f --no-hostname -o cat
```

### State Sync
```
😢
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.elys-t.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.elys/config/config.toml
```
### Addrbook
```
curl -Ls https://snap.nodexcapital.com/elys/addrbook.json > $HOME/.elys/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/elys/genesis.json > $HOME/.elys/config/genesis.json
```