<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/nodexcapital/testnet/main/cosmos-image/lava.png">
</p>

## Lava Testnet | Chain ID : lava-testnet-1 | Custom Port : 235

### Official Documentation:
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

curl -L https://snap.nodexcapital.com/nolus/nolus-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.lava
mv $HOME/.lava/priv_validator_state.json.backup $HOME/.lava/data/priv_validator_state.json

sudo systemctl start lavad && sudo journalctl -u lavad -f --no-hostname -o cat
```

### State Sync
```
Currently lava does not support State sync 😢
```

### Live Peers
```
PEERS="24a2bb2d06343b0f74ed0a6dc1d409ce0d996451@188.40.98.169:27656,14ae45e7f2ff7491cfa686a8fcac7cc095bc38ff@213.239.217.52:39656,5c2a752c9b1952dbed075c56c600c3a79b58c395@185.16.39.172:27066,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:44656,6ba3b6ec03839afffa64c83e18ff80a681f4968d@65.108.194.40:21756,13a9209a4d08803a3becac57de8eb02dd51f8f41@65.109.23.114:19956,80922095c0766aabdaf9e93e9c38c45321347ac0@85.239.237.85:26656,3177033dfc8a88c0b1a4500e2812c74f41e9a32b@94.130.236.21:26656,ac7cefeff026e1c616035a49f3b00c78da63c2e9@18.215.128.248:26656,34271a6f82d755777a3db02be39e575bf4ebd415@65.109.30.197:28656,e593c7a9ca61f5616119d6beb5bd8ef5dd28d62d@34.246.190.1:26656,112fba64a7e5e27b0cf8f02c634334c957891abf@75.119.146.244:28656,7aa9d96f0a3f162385b743ef92a2c6e03a4a1d84@65.108.48.77:20656,eb7832932626c1c636d16e0beb49e0e4498fbd5e@65.108.231.124:20656,3a445bfdbe2d0c8ee82461633aa3af31bc2b4dc0@3.252.219.158:26656,ec8065014ed4814b12c884ed528b96f281104528@65.21.131.215:26686,e06519a36d7c780af9ad2be69616a98445112c7a@80.79.5.171:29656,433be6210ad6350bebebad68ec50d3e0d90cb305@217.13.223.167:60856,c44a02dba51e23ac06b006fb1285988c89051ce7@85.10.198.171:26556,5a469a75fb05eddf2d79fb17063cc59e84d0821a@207.180.236.115:34656,7fb838681ff9855a634c7823de605fb4a5d22eba@65.108.144.202:26656,013f0163d37428ed99eacd8ee84059da5c243981@5.161.132.217:26656,99327e5cf0f31ac3bb1ca8e39cc9f17c823b7ec1@109.236.88.8:26656,6b1d0465b3e2a32b5328e59eb75c38d88233b56f@80.82.215.19:60656,47385d0a7051109de5342e3b27890c4a4b9e0763@65.108.72.233:16656,fa908ede438730a87c02e113a95aac206398706d@207.180.207.68:26656,5e068fccd370b2f2e5ab4240a304323af6385f1f@172.93.110.154:27656,0925c475208d8e338907383ab87a094ad03c478e@65.109.55.186:40656,ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@176.9.82.221:19956,bc2e99e6004bb0b87c72ca10f20cd1617edf70fe@141.94.73.93:56656,e711b6631c3e5bb2f6c389cbc5d422912b05316b@213.239.216.252:33256"
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