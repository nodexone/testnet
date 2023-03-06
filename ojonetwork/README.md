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

>- API : https://api.ojo-t.nodexcapital.com
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
STATE_SYNC_PEER=ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@testnet-seeds.polkachu.com:21656
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
PEERS="239caa37cb0f131b01be8151631b649dc700cd97@95.217.200.36:46656,cbe534c7d012e9eb4e71a5573aee8acc1adf4bc6@65.108.41.172:28056,2691bb6b296b951400d871c8d0bd94a3a1cdbd52@65.109.93.152:33656,c37e444f67af17545393ad16930cd68dc7e3fd08@95.216.7.169:61156,fbeb2b37fe139399d7513219e25afd9eb8f81f4f@65.21.170.3:38656,0465032114df76df206c9983968f2d229b3a50d6@88.198.32.17:39656,3d11a6c7a5d4b3c5752be0c252c557ed4acc2c30@167.235.57.142:36656,2c40b0aedc41b7c1b20c7c243dd5edd698428c41@138.201.85.176:26696,408ee86160af26ee7204d220498e80638f7874f4@161.97.109.47:38656,9edc978fd53c8718ef0cafe62ed8ae23b4603102@136.243.103.32:36656,ffe2d5ecb614762d5a1723f5f8b00d3feb6eb091@5.9.13.234:26686,5af3d50dcc231884f3d3da3e3caecb0deef1dc5b@142.132.134.112:25356,2223f5bf494729b9e9fdf6693d116d34e9d29755@141.94.193.28:55756,ac5089a8789736e2bc3eee0bf79ca04e22202bef@162.55.80.116:29656,9bcec17faba1b8f6583d37103f20bd9b968ac857@38.146.3.230:21656,1145755896d6a3e9df2f130cc2cbd223cdb206f0@209.145.53.163:29656,a23cc4cbb09108bc9af380083108262454539aeb@35.215.116.65:26656,8671c2dbbfd918374292e2c760704414d853f5b7@35.215.121.109:26656,b0968b57bcb5e527230ef3cfa3f65d5f1e4647dd@35.212.224.95:26656,62fa77951a7c8f323c0499fff716cd86932d8996@65.108.199.36:24214,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:50656,b6b4a4c720c4b4a191f0c5583cc298b545c330df@65.109.28.219:21656,e54b02d103f1fcf5189a86abe542670979d2029d@65.109.85.170:58656,3aeec94e9567c66ad6bb76b496aff6d55fd53d32@65.109.171.22:26656,bd35cfd5bfbea4c2a63e893860d4f9a7d880957c@213.239.217.52:45656,7416a65de3cc548a537dbb8bdf93dbd83fe401d2@78.107.234.44:26656,7ee8ece35c778418302ac085817d835b67043871@116.203.245.212:26656"
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