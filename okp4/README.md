<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img src="https://user-images.githubusercontent.com/44331529/197152847-749c938c-c385-4698-bfa5-3f159297f391.png">
</p>

# Okp4 Testnet | Chain ID: okp4-nemeton-1 | Custom Port 225

Guide Source :
>- [Obajay - STAVR](https://github.com/obajay/nodes-Guides/tree/main/OKP4)

Explorer:
>- https://explorer.nodexcapital.com/okp4


### Automatic Installer (Must Using Ubuntu 22.04)
You can setup your okp4 fullnode in few minutes by using automated script below.
```
wget -O okp4.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/okp4/okp4.sh && chmod +x okp4.sh && ./okp4.sh
```
### Public Endpoint

>- API : https://rest.okp4-t.nodexcapital.com
>- RPC : https://rpc.okp4-t.nodexcapital.com
>- gRPC : https://grpc.okp4-t.nodexcapital.com

### Snapshot (Update every 5 hours)
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
PEERS="8527f34bd6e542304809386896997d12d80e5e0e@65.108.237.232:29656,42fbb917fca6787bc3ab774865f4bb1ef950f114@65.108.226.26:30656,eef77b5ae1c37f3e5809ff928c329dde906be388@65.108.133.73:21656,9928d19b7663a6fa639eb7c1ee239e671edcbdb2@5.9.147.22:26616,b0b56d944cf1cc569a1e77e0923e075bad94d755@141.95.145.41:28656,8028015d1c6828a0b734f3b108f0853b0e19305e@157.90.176.184:26656,9d1482bc31fb4578a5c7f7f65c4e0aaf2dfc2336@213.239.215.77:36656,540e0e9b33b2d87315fdf7089404671581d36e94@95.217.203.43:26656,8cdeb85dada114c959c36bb59ce258c65ae3a09c@88.198.242.163:36656,874373b78d2cd50e716aa464bf407581d9305655@94.250.201.130:27656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:36656,307fb25cd6998d0d5bd1d947571f6043c6bb4069@65.109.31.114:2280,5c2a752c9b1952dbed075c56c600c3a79b58c395@95.214.55.232:26996,ead118d7cbe51cbabf5a77b69db7255512f41023@88.208.34.134:60656,99f6675049e22a0216af0e2447e7a4c5021874cd@142.132.132.200:28656,fe8bd9375c43a7cc6ef27e62d56af341a62e67c9@95.217.202.49:30656,74349a1cb9479b291866debe2042de8a2e88b850@65.108.233.109:17656,6a66a38bdd5895ec6f1ce18b3430860a30e18e02@142.132.149.118:26656,be9841ace1d71a4c7681918ee39f5e00d8e96a82@213.239.216.252:36656,8bccab4596e8bc162763bad6597d43523e6c32f8@104.194.8.68:26656,7ba5d3721d98efd479b2a3f3b4df6ebd5fd2f119@109.123.243.135:26656,44c4ad482cf8f1d9e7e18968da78bd0349fe853e@5.78.54.193:26656,d1c1b729eff9afe7dfd371f190df6282c82ccfad@65.109.89.5:31656,a490691c2a423573cb93bc23b13967ed9db0e3ff@146.190.44.218:26656,78d923333e39e747c6a7fbfcc822ec6279990556@91.211.251.232:28656,cee007d27c78754ae63ed827e61c8a920192f54b@65.109.93.152:28656,a98484ac9cb8235bd6a65cdf7648107e3d14dab4@116.202.231.58:36656,666c7b5ef2a81e4a3115785c90305d5371e067ed@162.55.234.160:26656,47dfb0e033db2c5d5aa2618c243a9394608f7bc3@213.246.39.63:26656,9f55b6fbf5d246138cc88acfe193ac45aa49c288@31.7.196.148:26656,a855bd9e3b689f3d055811161dd851ce1f7aec74@65.108.141.228:26856,907afed8fb7561b6d9bc6f755c8e4cce52e55080@65.108.72.252:26656,4cbfeff6d88aa4cdb64631a30356a4fb5fb243c6@3.14.129.248:26656,fff0a8c202befd9459ff93783a0e7756da305fe3@38.242.150.63:16656,8ae2fbf7a01c3b9e5601b4fbc42f27f4422f88bd@78.47.126.177:26656,58e2115e34f171739d1d2e9085fdbef78d1201d9@88.99.161.162:36656,14f8949ab0a276d2e55c8fa6255430881978a619@185.192.96.236:26656,2c2b83b7f1023c381afd3d67f326d70de098cb47@142.132.252.16:26656,b7ee6d4cf316f7cd0be86da103f5acc8fa2ded7e@94.130.137.122:29656,069717e7104fccf26e2f7e3be04a82c626fbfe13@51.68.204.169:26643,9b22fb6daec21ec15dcf4107060dd59d63f6df35@162.55.245.219:29656,8633177b18f9031b84beb690293d20dce1d0c20e@121.78.247.252:35656,d57a740d8cfdd92ef61b9afc9359e9bf96e3618f@65.108.78.107:20621,31f30b64f88ebdf8572211f65126dffc81a969ca@65.108.232.248:30656,54585c522153eade8cf2ae2cfe02144d5ac9beeb@75.119.155.249:26656,643988550263605405a7968c38fd11653bf75cd0@38.242.252.104:26656,affaad7c297b627020f63d5bc5b1c1a9d8842f44@152.32.192.192:26656,253b8a7353be38f56a1bcbdb6c8ac359679e5289@195.201.228.51:27656,0d7d6cca849632db16b941d158febbd7e583063a@78.46.215.50:26656,42eb68bfa046b6cafa53de67d9286651aeffff7c@88.99.164.158:10096,153c387f6dbf7a30a046a7b0c08028e8614e0c95@65.109.122.105:46656,9c2e37f0ae9cef769e31decc5aadaad30c04e6c0@94.130.140.145:26656,57f3df8b11c6c9b796c78d2a213b962acfcb7f3c@213.239.207.175:38656,3ed902bed4e1a54ae972f66469f5f7b9f1ba4da8@65.108.230.161:16656,c3db3a07493e8f04d93a9228998ae799fa89877f@5.78.48.118:26656,a6f315461a3ef0b1e25adfbde701515b861b3b62@194.163.178.191:26666,ef295fe0b5a859a44350c90c5400bff4613ba22c@136.243.147.235:33656,413a9269a866cbeb462f352e72e7578e5b395502@65.109.92.240:10096,59513e6626373eb3af4b1c0d10f935aa28683713@84.201.135.7:26656,f74f793a1efa51778fd74d4dbc5a1e88a8c644db@116.202.227.117:36656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.okp4d/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/okp4/addrbook.json > $HOME/.okp4d/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/okp4/genesis.json > $HOME/.okp4d/config/genesis.json
```

<!-- LIVE_PEERS_START -->
<!-- LIVE_PEERS_END -->