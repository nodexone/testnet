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
PEERS="e26206d0e39515fb07915b28e468729340eb112e@38.242.244.163:26656,78f6683344058d2ee9fe0984b754f76bbed75621@65.109.116.110:26656,0d84b9ecc2145bbdbf7711c100aad967afef6bd2@5.161.65.211:26656,7f8cdf82657d23568c650a87b039539d4b234016@164.68.113.162:30656,1f035d17ad5cc6b1abaf8ed0380fdddff1db929f@85.239.243.215:26656,5eadb035be45a8cb69491324805175b86dd11b6b@65.108.232.182:13656,d5fa9040e182a3a68d1b752dc0f8a7902625e087@188.233.19.216:18656,6691e56c95ca475481f61418c28e11ca2e4469fe@194.146.13.186:26656,bf05df3550272f56495e9d4cf2637dd6554e36a6@38.242.139.242:26656,2b8a63defdcde856b7c4febac9658ad2ef26befb@65.108.9.230:18656,e3c348467a8c88c0f65e2ca8a71875d2a384b8b4@185.16.39.19:60656,d1b61b43b9475e9d509f720415b75c30cb92bfb3@89.117.58.38:26656,76d932d75b5de4c1799f8702b0047a4ab3de1b14@154.53.63.156:30656,78c53aca778b1239158cf4bf6a3aeeb2239501bb@38.242.216.35:40656,2687b608599ef656f343a790f21fb3fb9292668e@194.146.13.187:26656,6d17e0f49bc1856c732f1d439647720ba127aab8@84.46.247.5:26656,ff29ddbb2033dd1eec9c59e72ec242573f9e80b0@77.51.200.79:40656,475831e66548184ac8402e3dd3c9d39bd08b5c68@38.242.139.98:26656,d9516be6f5fffad9d2fa4354126c46ca5a6c9310@154.53.55.128:30656,8675cc6e69c2043a8dc0a854e769c1f135b5f272@23.88.73.158:26656,810fc90b9b64e2b7a79a63e1e783148bff58f764@65.109.84.216:36656,5d35cb6f761cd312a3f9ef927a284a5f500d18a5@95.217.18.86:26656,0108df8793ec07fa82ea202d54b70c603b827ea4@5.9.81.251:656,024981c993824fb347e3b007cbbabec211925bf1@144.91.89.149:30656,ea1af576f728832d90d4fe9944e45743bb270f24@154.12.245.40:30656,93153d3b1e9178f44bbbddf809a8cf7177715c03@37.221.71.67:45656,3db1eb8f5c41b8a551e3edd52e0d6150134d45f4@155.133.22.129:26656,8a650a9761db8abc1096abc3d4a68431600ae835@62.171.149.101:46656,48fe32b3f93472a26854ee6fef69447f62a265ed@199.175.98.109:26656,3209ec925afead6706ac250aae88d1b85a45a2d3@167.86.85.247:30656,4f80d0058101e284b5885f6e66cae85a6f0dc88e@2.58.82.46:40656,7e6bb7063b51a7a5e6433efb8c552e7e0542fc58@217.76.50.67:26656,38c2e79f4d9043aac5fd699d3bd5b8c3bdab0ab2@154.12.241.185:26656,bf706069f24661022c50669b1b4a1aa95cd7766b@188.233.19.197:18656,5ba975533e25b25e84df48bc6aeeed108f78aba4@209.126.2.211:26656,b2d33977b8bca9790df391dd3559e65514f95c0f@194.146.13.253:26656,a04b2fa85b4636dca6e3841396b7eda6a24f22f7@194.195.87.106:26656,8db4b24f6d1ad836b8d0ac7222971cd428ff6ca8@185.182.187.136:40656,8de6c9431267b27c44bb4515659cacadd3956bae@78.25.145.168:40656,ba0abf77c2dec230a7ae06b32d1abf63dbd48642@5.9.82.120:61656,da77231e4a499106b2fa2f0d64e553c2a9e2203b@65.108.199.206:28656,083a713bc0c105a4713a0f42dd164e047cb60c7e@65.108.197.169:13656,d7c675fa2eef507d4e2270c442383a886cade959@207.180.248.230:26656,d9f1a0f399c8db62206edb2be29a313829fc8521@135.181.128.19:26656,9caa4ac64062fa1178a9db93d24209841bbd30ba@199.175.98.110:26656,e374c0d40d3fd948e91e239fe67c9d7a8fff4995@65.108.101.124:13656,2b76e96658f5e5a5130bc96d63f016073579b72d@51.91.215.40:45656,12d2829187ba3627c44944c1ee99218da4328e16@178.63.8.245:60956,dd69612ab963467a13c0ff0c454dd39053a6412d@65.21.144.94:36656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:40656"
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