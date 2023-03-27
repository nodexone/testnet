<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/humans.png">
</p>

# Humans Testnet | Chain ID : testnet-1 | Custom Port : 230

### Community Documentation:
>- [Validator setup instructions](https://polkachu.com/testnets/humans)

### Explorer:
>-  https://explorer.nodexcapital.com/humans

### Automatic Installer
You can setup your Humans fullnode in few minutes by using automated script below.
```
wget -O humans.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/humans/humans.sh && chmod +x humans.sh && ./humans.sh
```
### Public Endpoint

>- API : https://rest.humans-t.nodexcapital.com
>- RPC : https://rpc.humans-t.nodexcapital.com
>- gRPC : https://grpc.humans-t.nodexcapital.com

### Snapshot (Update every 5 hours)
```
COMING SOON
```

### State Sync
```
COMING SOON
```

### Live Peers
```
PEERS="$(curl -sS https://rpc.humans-t.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.humans/config/config.toml
```
### Addrbook (Update every hour)
```
COMING SOON
```
### Genesis
```
COMING SOON
```