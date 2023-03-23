<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://polkachu.com/images/chains/ojo.png">
</p>

# Ojo Testnet | Chain ID : ojo-devnet | Custom Port : 246

### Community Documentation :
>- [Validator Setup Instructions](https://polkachu.com/testnets/ojo)

### Explorer:
>-  https://explorer.nodexcapital.com/ojo

### Automatic Installer (Must Using Ubuntu 22.04)
You can setup your Ojo Network fullnode in few minutes by using automated script below.
```
wget -O ojo.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/ojonetwork/ojo.sh && chmod +x ojo.sh && ./ojo.sh
```
### Public Endpoint

>- API : https://rest.ojo-t.nodexcapital.com
>- RPC : https://rpc.ojo-t.nodexcapital.com
>- gRPC : https://grpc.ojo-t.nodexcapital.com

### Snapshot (Update every 5 hours)
```
sudo systemctl stop ojod
cp $HOME/.ojo/data/priv_validator_state.json $HOME/.ojo/priv_validator_state.json.backup
rm -rf $HOME/.ojo/data

curl -L https://snap.nodexcapital.com/ojo/ojo-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.ojo

mv $HOME/.ojo/priv_validator_state.json.backup $HOME/.ojo/data/priv_validator_state.json

sudo systemctl start ojod && sudo journalctl -fu ojod -o cat
```

### State Sync
```
sudo systemctl stop ojod
cp $HOME/.ojo/data/priv_validator_state.json $HOME/.ojo/priv_validator_state.json.backup
ojod tendermint unsafe-reset-all --home $HOME/.ojo

STATE_SYNC_RPC=https://rpc.ojo-t.nodexcapital.com:443
STATE_SYNC_PEER=d5b2ae8815b09a30ab253957f7eca052dde3101d@rpc.ojo-t.nodexcapital.com:24656
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  $HOME/.ojo/config/config.toml

mv $HOME/.ojo/priv_validator_state.json.backup $HOME/.ojo/data/priv_validator_state.json

sudo systemctl start ojod && sudo journalctl -u ojod -f --no-hostname -o cat
```

### Disable State Sync 
After successful synchronization using state sync above, we advise you to disable synchronization with state sync and restart the node
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.ojo/config/config.toml
sudo systemctl restart ojod && journalctl -u ojod -f -o cat
```

### Live Peers
```
PEERS="cbe534c7d012e9eb4e71a5573aee8acc1adf4bc6@65.108.41.172:28056,b6b4a4c720c4b4a191f0c5583cc298b545c330df@65.109.28.219:21656,408ee86160af26ee7204d220498e80638f7874f4@161.97.109.47:38656,3d11a6c7a5d4b3c5752be0c252c557ed4acc2c30@167.235.57.142:36656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:50656,239caa37cb0f131b01be8151631b649dc700cd97@95.217.200.36:46656,9bcec17faba1b8f6583d37103f20bd9b968ac857@38.146.3.230:21656,cc6174ef7ddc3e853efe3cd15ee760b9a26d6dbb@161.97.79.100:33656,a98484ac9cb8235bd6a65cdf7648107e3d14dab4@116.202.231.58:50656,c37e444f67af17545393ad16930cd68dc7e3fd08@95.216.7.169:61156,ac5089a8789736e2bc3eee0bf79ca04e22202bef@162.55.80.116:29656,ffe2d5ecb614762d5a1723f5f8b00d3feb6eb091@5.9.13.234:26686,0465032114df76df206c9983968f2d229b3a50d6@88.198.32.17:39656,3aeec94e9567c66ad6bb76b496aff6d55fd53d32@65.109.171.22:26656,62fa77951a7c8f323c0499fff716cd86932d8996@65.108.199.36:24214,fb10560d2e3aea7948a375dc87140c156a07acc4@195.201.83.242:17656,3c6384ae2a167912a5ace2f5f8e38afc559715f0@75.119.156.88:26656,2c40b0aedc41b7c1b20c7c243dd5edd698428c41@138.201.85.176:26696,fbeb2b37fe139399d7513219e25afd9eb8f81f4f@65.21.170.3:38656,d6318facf0de085644dcf8ba57bcc1725b6ec515@89.58.59.75:36656,ae3621c022cddc8c05d7640c14147d257746fb74@185.215.166.73:26656,f4663c5df8ee2e2b6e1cc6a9d7ad09687a27e08c@68.183.32.158:26656,e6b70cf272ec33d3915a94c60b68637935643fd3@194.163.167.138:59656,d1c5c6bf4641d1800e931af6858275f08c20706d@23.88.5.169:18656,1879aa588b4d6431bf40543f3a44129dcf60a043@144.91.77.68:50656,b4c7205397045d22fe762c8d2021fa4ce6d7ea1e@162.55.39.159:36656,622e5b7bc26be4edc4a9112ed0c5c8b00aa72721@185.246.84.196:26656,34a4c8433adfc4bf0df7c085ce58ed48664fbdc1@85.10.193.246:31656,b133dde2713a216a017399920419fcb1e084cdb2@136.243.88.91:7330,ed12aee3273baaaf01e357574c1692f12776446d@65.109.117.165:50656,8fbfa810cb666ddef1c9f4405e933ef49138f35a@65.108.199.120:54656,b6c75d1fbdc9c39daaaf52a4c0937b9f06975808@167.235.198.193:26656,4cb932af43e2c64a0277516d96410a05294653de@75.119.148.69:26656,0ea23938eaefffe447eb0126d4951e2ac9c45637@45.140.147.252:26656,02cbe3e13614ae34d847fbab3a03567788e17b84@65.109.122.105:60956,4e007fe2793172797eff893abf91ab685549ee11@65.109.235.2:26656,f63f353c1e8b47b6fe1cbbda91b5a91673c155b3@89.163.132.156:36656,124439d1c16b1ee7ca1a39961f02fadf8539cb81@38.102.85.10:26656,11bb322f6396a1ca67717cf162385ed250503e28@154.12.253.123:36656,affee2f485ca15c68c302ad98e8de41fcd0e71ba@162.19.238.49:26656,d9df87e2e26db62ef4014ce6e8705ee11bda304f@176.124.220.21:4669,9f53e51449968bb2d2faad15dc4220757c4c33cd@213.239.215.77:47656,f6f9a074987ec9ed45f3a53cbd54e0f358a8648f@75.119.159.226:60656,fee808fc235e2f345caaaee1d65f818d710f6433@213.137.237.201:26656,bdd24cab3246503ae261aea82f077ffb66d56ce3@95.216.39.183:28656,978cf9aca38f819fd8189272379fc3c2ae2682a8@213.239.218.210:56656,855fc154f9054ce4055719e09ce6f7f1d0ecd9fb@85.10.198.171:36656,f474a520009496972515f843cdb835fc7d663779@65.109.23.114:21656,50e9bd8647571268df2313df6c46ba9960c9f40e@178.128.88.30:26656,7d6706d7ee674e2b2c38d3eb47d85ec6e376c377@49.12.123.87:56656,b16d876c443850cd358596790411b835d3f1735b@95.214.53.46:35656,67e95aeec46d7c5840f9685ca2b4cd725841b814@16.163.74.176:26636,bd90b71f1f982ebb18857da8cb777883d6ca687e@185.209.223.68:26656,2691bb6b296b951400d871c8d0bd94a3a1cdbd52@65.109.93.152:33656,a654bbc2b27134da4eb1fcc08f07a2c9ea0deec7@51.79.77.103:12656,13b4b70206dc95be5e3ec3c511c0441c4354fc96@91.148.132.72:26656,577606f2072f97a5107bead5b2321302092c1f7d@194.5.152.12:26656,f35a6ea4693d24d3727a8e866acab2a9faa2ddbc@91.223.3.144:26256,0ac9841750afe017b882768b0e29e72b8296d6b0@104.194.8.68:46656,bab2e24e088af1efc88684a83024fa31baad34e5@185.137.122.106:26656,315350f9d96426d4a025dbdecae84ceca64d1638@95.217.40.230:56656,48a295d04bc52f8a061632917ee53e27f40a53f3@86.48.16.205:50656,2223f5bf494729b9e9fdf6693d116d34e9d29755@141.94.193.28:55756,42f9946a8ba6d49832a3ba5324cddffe494723c6@116.202.85.52:2626,4e38368e64b1951439e7d6ac3387dae9dcfef120@94.130.16.254:60956,a3a9014f82cb69fe0494ea3bc49990027d081a5a@65.108.126.35:36656,f12af93f4f59534a022192408c31fdd1d2f1bb0c@38.242.131.92:26656,4764a447ea3518e5017756b42ca5f6442b2f5768@5.161.114.1:26656,af756ed11eed8aa43c5172ffa0453552f633218c@65.108.239.50:2626,5c2a752c9b1952dbed075c56c600c3a79b58c395@95.214.52.139:27226,cd4d7ffdad8bd258cd90c22ec7197c0fdf9f3648@38.242.134.73:27656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.ojo/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/ojo/addrbook.json > $HOME/.ojo/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/ojo/genesis.json > $HOME/.ojo/config/genesis.json
```