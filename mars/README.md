<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/kj89/testnet_manuals/main/pingpub/logos/mars.png">
</p>

# Mars node setup for Mainnet — mars-1

Community documentation:
>- [Validator setup instructions](https://service.kjnodes.com/)

Explorer:
>-  https://explorer.nodexcapital.com/mars-mainnet


### Public Endpoints
RPC Endpoints
>- https://rpc.mainnet-mars.nodexcapital.com
API Endpoints
>- https://api.mainnet-mars.nodexcapital.com
gRPC Endpoints
>- https://grpc.mainnet-mars.nodexcapital.com
gRPC Web Endpoints
>- https://grpc-web.mainnet-mars.nodexcapital.com

### Automatic Installer
You can setup your mars fullnode in few minutes by using automated script below.
```
wget -O mars.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/mars/mars.sh && chmod +x mars.sh && ./mars.sh
```

### Daily Snapshot (updated every 5 hour)
You can catch the latest block faster by using our daily snapshots
```
sudo systemctl stop marsd
cp $HOME/.mars/data/priv_validator_state.json $HOME/.mars/priv_validator_state.json.backup
rm -rf $HOME/.mars/data

curl -L https://snap.nodexcapital.com/mars/mars-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.mars
mv $HOME/.mars/priv_validator_state.json.backup $HOME/.mars/data/priv_validator_state.json

sudo systemctl start marsd && sudo journalctl -fu marsd -o cat
```

### Genesis & Addrbook (updated every hour)
```
curl -Ls https://snap.nodexcapital.com/mars/genesis.json > $HOME/.mars/config/genesis.json
curl -Ls https://snap.nodexcapital.com/mars/addrbook.json > $HOME/.mars/config/addrbook.json
```

### Live Peers
```
PEERS="9cb92702727bc5f3d40154e625b9553a04f4d649@65.109.104.72:18556,8253a88226cb44161f0f7eddb8aa0f022a0cf861@65.108.109.240:3000,e61f11c5b03400d3a99c066f951ed0888a2b64af@65.108.238.103:18556,969af6a39a0f7e8a17b92d90888360ad92248626@65.108.132.107:2000,000f20c009ef4fbae24cde350340c66d203d3fee@65.109.92.148:61356,1616af7456f519a0f2360adcad45d4bb9d39c92d@146.59.85.222:26656,c46be592341987eae20ac681cb08d2abcc02ab9a@137.74.4.20:2000,8987b47ff9e681299e26e609373bf096cce413e0@185.190.140.105:20656,7fa2f4bdbacaf4569621dc76b3e4df4c13b8710e@65.109.71.250:22656, 2707fa9064faa355fc98795361c2d9a3fa7514fc@185.232.69.25:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.mars/config/config.toml
```

### IBC Relayers
```
Coming Soon
```

### State Sync
```
Coming Soon
```