<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/kj89/testnet_manuals/main/pingpub/logos/quasar.png">
</p>

# Quasar Testnet | Chain ID : qsr-questnet-04

### Community Documentation:
>- [Validator setup instructions](https://services.kjnodes.com/home/testnet/quasar/installation)

### Explorer:
>-  https://explorer.nodexcapital.com/quasar

### Automatic Installer (Must Using Ubuntu 22.04)
You can setup your Quasar fullnode in few minutes by using automated script below.
```
wget -O quasar.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/quasar/quasar.sh && chmod +x quasar.sh && ./quasar.sh
```
### Public Endpoint

>- API : https://api.quasar-t.nodexcapital.com
>- RPC : https://rpc.quasar-t.nodexcapital.com
>- gRPC : https://grpc.quasar-t.nodexcapital.com

### Snapshot (Update every 5 hours)
```
sudo systemctl stop quasard
cp $HOME/.quasarnode/data/priv_validator_state.json $HOME/.quasarnode/priv_validator_state.json.backup
rm -rf $HOME/.quasarnode/data

curl -L https://snap.nodexcapital.com/quasar/quasar-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.quasarnode/
mv $HOME/.quasarnode/priv_validator_state.json.backup $HOME/.quasarnode/data/priv_validator_state.json

sudo systemctl start quasard && sudo journalctl -fu quasard -o cat
```

### State Sync
```
sudo systemctl stop quasard
cp $HOME/.quasarnode/data/priv_validator_state.json $HOME/.quasarnode/priv_validator_state.json.backup
quasard tendermint unsafe-reset-all --home $HOME/.quasarnode

STATE_SYNC_RPC=https://rpc.quasar-t.nodexcapital.com:443
STATE_SYNC_PEER=d5519e378247dfb61dfe90652d1fe3e2b3005a5b@quasar-testnet.rpc.kjnodes.com:48656
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  $HOME/.quasarnode/config/config.toml

mv $HOME/.quasarnode/priv_validator_state.json.backup $HOME/.quasarnode/data/priv_validator_state.json

curl -L https://snapshots.kjnodes.com/quasar-testnet/wasm_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.quasarnode

sudo systemctl start quasard && sudo journalctl -u quasard -f --no-hostname -o cat
```

### Disable Sync with State Sync
After successful synchronization, we advise you to disable synchronization with state sync and restart the node
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.quasarnode/config/config.toml
sudo systemctl restart quasard && journalctl -u quasard -f -o cat
```

### Live Peers
```
PEERS="d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:48656,fdc1babb7ad4d97a911d32b0545220c8ceca57a8@128.199.8.206:53656,11d9e9d25cc78d2a0270a3d5a7e849775b110e64@185.249.225.63:48656,b1197bd0946b3d2d462fcc7548a79e87101d2389@65.108.141.109:38656,5265b02d7a5e43275f3383e6385cdc0506b99e1a@65.109.28.177:28656,3c8afd3c39b7ab28cdb801e45ea4d9249a51e22b@88.99.161.162:20656,18134130ea3156767191d89e9654b0117f54460b@43.156.246.92:26656,881db78e40385d87614cb847c2a19e8ead25b52c@43.159.47.25:26656,966acc999443bae0857604a9fce426b5e09a7409@65.108.105.48:18256,02e9ca11b64c2c6710f9642a79d576d7134ea215@43.159.54.23:26656,45848bc173bddbf7c685938dfada535ee5a1895b@65.109.23.114:18256,b122b1d76f5d676233ebbd0011c2fd7bf5960e53@43.156.10.155:26656,0bc5253d4db2af78fb7c96fa77e5f0734ea10331@43.156.61.70:26656,e339401b40f12aaf9efca323214040f51f3ff4b6@65.109.87.135:18656,d7b332b225b27a0c3338e9bce1e3ef1dd37d0c10@43.156.36.141:26656,dcf78ede935a42361895928d35119ed4789abb9c@65.109.85.225:8090,eea117634dd5e280e94e931ecf5d3f2b462bcd9d@43.156.69.134:26656,ed3bb97860ef0197a00b27127e0aaa9dd7af2817@94.130.177.114:29656,b3299d6ad3ff7452cba7d651d2c678e565fdd281@43.156.72.55:26656,afcfb038b1235a9a41128e73c4ac2bc6838b5f04@129.226.216.213:26656,9e55c6920edce61ea2a7328e437a650e8884f090@209.126.2.83:26656,fafd24c060f625a610d632a314ae916555b3d11a@43.156.98.245:26656,46ab1cfab36eeebc9b073612d69fee1c634b22d4@147.182.244.154:26656,8df102b790607051362abacf34ec671c37d096bf@43.153.203.222:26656,5271226f8a6a0f981720b7f8656cf424db0ce580@129.226.201.224:26656,f79f912153840caf703393d784b94b2e50371c61@43.156.118.199:26656,231b35d147fdd2bc9027106eeef63b448f1f404b@43.156.225.47:26656,01234fe8e5aa29abe6b5d30764f9b50ca5cdeb98@139.180.139.191:26656,c5b0e2e7ac4b16a6bd7619e9335f687028cb1d5e@43.156.137.165:26656,b5fcb5c89e5ec40188be886625acd349df52795a@43.156.137.130:26656,ecaba1301b48b32d8c97bb6a2eef6b9fb27169c0@64.176.45.149:26656,3a5480bfdf27c1b103f0257056b000175e3e1a06@176.124.220.21:26656,e2bfc397cdfd70fd731cb97d568d869b36b97456@43.153.205.74:26656,23b3f4a6d894400664f464613971da60465a4a36@43.156.120.96:26656,b26391f18fe3a4b23f478f04157072907e5df3c5@43.153.205.91:26656,b82edb8acc9f7d486de3b4fcd857d7c588d6956b@43.154.17.254:26656,a23f002bda10cb90fa441a9f2435802b35164441@38.146.3.203:18256,674166550258de01e46207e565598e856aac6f62@43.154.168.128:26656,b35f3493df8c3be232fe75ef7f4d0cb9d0f59668@65.109.70.23:18256,15b2df2c900a0d1a7625ccf9bc15e7c043a9044c@43.154.143.254:26656,bfa59196c109932786885c97ccd7df7dd434d26a@43.156.233.200:26656,7490a9690d82d43f8bcfa257cdf798e8e75a4d46@38.242.130.23:29656,e3b45f7be0b6e109d16458f79a84a434bb85430f@212.118.52.14:29656,4ad7ce03e53f0edb2a1debb2d69ff754a0cbb029@142.132.158.158:23656,7d57a0d05e0a4069cb0e7125a7da9cfd3a397880@108.166.201.96:26656,d21319cfc5fff19810ae8797b4749b50018df365@94.130.36.149:26666,955ee8d360e80a7baecc0ee3ea8afa436a7aee23@43.154.73.226:26656,089763be3736463c507427b37752a0d8d465b8c6@149.102.139.80:29656,c3c648ff7683273d85c0d8e24b823b39587e38e3@178.128.85.30:53656,08f409ee63de194847ea3da6b9c593cdb3f9692d@176.124.220.124:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.quasarnode/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/quasar/addrbook.json > $HOME/.quasarnode/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/quasar/genesis.json > $HOME/.quasarnode/config/genesis.json
```