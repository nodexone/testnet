<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/bDUAwZhqBb" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://nodexcapital.com" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://nodejumper.io/assets/img/chain/lava.webp">
</p>

## Lava Testnet | Chain ID : lava-testnet-1 | Custom Port : 211

### Community Documentation:
>- [Kjnode Manual Installation](https://services.kjnodes.com/home/testnet/lava/installation)

### Explorer:
>-  https://explorer.nodexcapital.com/lava

### Automatic Installer (Must Using Ubuntu 22.04)
You can setup your Lava fullnode in few minutes by using automated script below.
```
wget -O lava.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/lava/lava.sh && chmod +x lava.sh && ./lava.sh
```
### Public Endpoint

>- API : https://rest.lava-t.nodexcapital.com
>- RPC : https://rpc.lava-t.nodexcapital.com
>- gRPC : https://grpc.lava-t.nodexcapital.com

### Snapshot (Update every 5 hours)
```
sudo systemctl stop lavad
cp $HOME/.lava/data/priv_validator_state.json $HOME/.lava/priv_validator_state.json.backup
rm -rf $HOME/.lava/data

curl -L https://snap.nodexcapital.com/lava/lava-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.lava
mv $HOME/.lava/priv_validator_state.json.backup $HOME/.lava/data/priv_validator_state.json

sudo systemctl start lavad && sudo journalctl -u lavad -f --no-hostname -o cat
```

### State Sync
```
Currently lava does not support State sync 😢
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.lava-t.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.lava/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/nolus/addrbook.json > $HOME/.lava/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/nolus/genesis.json > $HOME/.lava/config/genesis.json
```