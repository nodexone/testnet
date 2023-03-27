<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/170463282-576375f8-fa1e-4fce-8350-6312b415b50d.png">
</p>

# Celestia Incentivized Testnet | Chain ID : blockspacerace-0 | Custom Port : 001

### Official Documentation:
>- https://docs.celestia.org/nodes/overview

### Explorer:
>- https://explorer.nodexcapital.com/celestia

### Automatic Installer
You can setup your Celestia fullnode in few minutes by using automated script below.
```
wget -O celestia.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/celestia/celestia.sh && chmod +x celestia.sh && ./celestia.sh
```
### Public Endpoint

>- API : https://rest.celestia-t.nodexcapital.com
>- RPC : https://rpc.celestia-t.nodexcapital.com
>- gRPC : https://grpc.celestia-t.nodexcapital.com

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
PEERS="$(curl -sS https://rpc.celestia-t.nodexcapital.com/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.celestia-app/config/config.toml
```
### Addrbook (Update every hour)
```
COMING SOON
```
### Genesis
```
COMING SOON
```