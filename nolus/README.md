<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/34649601/207593974-32d7cb69-eca9-4096-bc96-246fe7038c88.png">
</p>

# Nolus Testnet | Chain ID : nolus-rila | Custom Port : 229

### Official documentation:
>- [Validator setup instructions](https://docs-nolus-protocol.notion.site/Nolus-Protocol-Docs-a0ddfe091cc5456183417a68502705f8)

### Explorer:
>-  https://explorer.nodexcapital.com/nolus


### Automatic Installer (Non Cosmovisor)
You can setup your Nolus fullnode in few minutes by using automated script below.
```
wget -O nolus.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/nolus/nolus.sh && chmod +x nolus.sh && ./nolus.sh
```

### Automatic Installer (Cosmovisor)
You can setup your Nolus fullnode in few minutes by using automated script below.
```
wget -O nolus-cosmovisor.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/nolus/nolus-cosmovisor.sh && chmod +x nolus-cosmovisor.sh && ./nolus-cosmovisor.sh
```
### Public Endpoint

>- API : https://rest.nolus-t.nodexcapital.com
>- RPC : https://rpc.nolus-t.nodexcapital.com
>- gRPC : https://grpc.nolus-t.nodexcapital.com

### Snapshot (Update every 5 hours)
```
sudo systemctl stop nolusd
cp $HOME/.nolus/data/priv_validator_state.json $HOME/.nolus/data/priv_validator_state.json.backup
rm -rf $HOME/.nolus/data

curl -L https://snap.nodexcapital.com/nolus/nolus-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.nolus

mv $HOME/.nolus/data/priv_validator_state.json.backup $HOME/.nolus/data/priv_validator_state.json

sudo systemctl start nolusd && sudo journalctl -fu nolusd -o cat
```

### State Sync
```
nolusd tendermint unsafe-reset-all --home $HOME/.nolus --keep-addr-book

SNAP_RPC="https://rpc.nolus-t.nodexcapital.com:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.nolus/config/config.toml

curl -L https://snap.nodexcapital.com/nolus/wasm.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.nolus

sudo systemctl start nolusd && sudo journalctl -fu nolusd -o cat
```

### Live Peers

```
PEERS="5bd7453b792b0b1fc99900e91de0bad7afe04707@94.130.142.94:26656,f75a8f871fd13b42494f38b331863609d4f78b37@194.163.189.98:26656,7a1fc4d1cc0ffec7db6a2a15496136e62561b162@161.97.146.108:26656,32600634c623952e36ebf2c14fd1a0f91e890078@38.242.222.153:26656,ca83b6457bfce88d892646b6afb51165ec3e94d4@135.181.183.93:22656,785789b6574c45b8cfefff08344fdfeda345c7e1@135.125.5.34:55666,c3eeb6117374834beaa674cb7a8769dc6ac9f672@135.181.33.188:37656,8b0b427b4567a7a66f05fab1146ee97b52ad7958@93.189.30.119:26656,fa0a2fe57c2ab28aee6cc0be4eddbc68d6587a75@95.217.165.189:26656,3413989cce29fa5913eb149cbdee4ea5ee02b579@194.34.232.124:55656,646d17dc6126bfe79eaeb2b95964323f198c9d3c@65.109.53.60:28656,1cb8223111a5fb8a631d73aa3bcd7abd2ef41ba7@45.87.104.84:1184,60c57c5b7215c84260249768cf66ae550142af9f@141.98.169.25:26656,33f4b7f56b6708526f0638162f020394de0ce5e9@65.21.229.33:28656,17cc34fc4a5c91e67bc7e11b9c15cad10dd11336@138.201.221.94:26656,7c2ea36064077da73d0ad5b60d8ef215acbee50b@161.97.79.100:36656,f000cd749de3af6d4d8d21e310ee69a61a66ebdb@138.201.204.5:34656,2c0ff6e5f30189559ad336a1eb17ae48fcacc8ee@95.216.14.58:61456,f72ad216891e59cdc663958f55d2916e87c03c35@138.201.253.157:26666,a98484ac9cb8235bd6a65cdf7648107e3d14dab4@116.202.231.58:43656,6949192822982ed977aa0fc4f9e27984856daeb6@116.203.97.25:26656,dba152eadb37e427969c2bd8b6a31e930879f571@152.70.188.61:26656,236a2626ad46bb671b200883b6105350310372ef@135.181.81.65:37656,73290354a81324fca070cef5158b272925f102a2@65.109.92.235:11006,2fc6d24d1d77c34427ce7cbb24de5ee4d4debe7c@161.97.108.208:26656,3577f8c3aa36c31b7ef2990e8521698786c8754c@65.21.226.230:29656,cd67fc6e6c306dbb863f381c926135d6b97fe685@65.109.85.155:41656,69be36de05cb5f8e14c92e66c28df7ae786050c0@161.97.145.13:21656,73176af073e4f89609db7aa4ec3561ce1b98d308@85.10.193.246:32656,e56396a2249230c9869895c80764b32e087babac@185.202.223.124:41656,c4c5e1301afc9c9b36792bdcd6a74355c42cf0b4@91.107.232.163:26656,356a17fda44d7694cf8c3bf7a82491adea8536a9@38.242.228.69:26656,99152c473858f5930f7bc3021208c686294a2375@149.102.143.145:28656,8d85b69ea7175ce0cf6ec7badae239339d6525db@81.0.218.59:26656,1aed1013bdf53933c03498171660e5bda4c61103@135.181.158.36:26656,8c06f4542b77a25eae06daf0a5e6c803f7c20520@161.97.164.133:26656,84e1980896a01bc466f17c3c2f50dce1b33acd10@38.242.244.199:26656,829c12b4db70fa7ba332f993db33e26371db17b7@95.216.241.112:35656,1a0bb6c35e2663202535d4b849ff06250762d299@213.239.216.252:35656,acd39ab5b00e5611df296b2e6fb4f6a44a32513f@23.88.5.169:21656,8089ad7527be4d7823afc2cbaa1f3729506190d9@185.205.246.155:26656,19b3c383c93d1001d4da934f1f22b83c403c6056@217.76.62.106:26656,647c0cefcd470b6d92b03b3511a0a4defe2a30dd@135.181.208.169:31656,f0f48327e14e6918a2fad2c795429dd6c3856236@88.99.161.162:43656,1bbd48476637ee19900872f4c1b783bcaf5e4bac@167.235.132.251:26656,c694500a79594c695bc9e59221d07b16029225bb@85.190.246.119:26656,8cf5b590bb5791ffeab8a16b5ca5875651ea2a43@78.24.219.64:26656,93b90db2cb18bfa490c7dc4dddd0720ec9cfcfb5@212.24.101.2:26656,38d59fd3a6ff0047f368bbf5437ade8a76777d63@173.249.45.161:26656,2e146ac9281e3797cbe1ad053e5ce6046b972c15@65.109.140.29:37656,fb94493b7744f7bcde0f9eb3e1657a137264cde4@95.216.171.110:26656,15cd61c8528611d1192ee06578cd6f5054645a0e@46.101.115.206:55666,a9b6b11476d41eead8f91d0615def16b7f26c579@135.181.192.135:37656,de612f6c77689072fddb192b57dcef8b23997afa@207.244.248.145:37656,ba2539d2e69326c80b586c45f5746cae7f7024ac@31.220.82.52:26656,6b14535ff005667f324f8439a55a21ee2f170d12@95.217.211.81:26656,1c50df97e155afa50189f48daf41be046c7fe682@85.10.202.135:32656,78e20362744b6056ab437bf46a6b09df6a728c9c@217.79.178.10:35656,ce6a67a084a25c189ed92522f1a0f6c44ec7cc3a@116.202.227.117:43656,a2b9541d3c3e738c418a72ab5972c8d2b6cff8ce@65.108.54.167:26656,7461cfbaf641b7435fcd679ac0c8cc7dcb92cef4@65.108.208.155:39656,e8473dede42e7f0d4668a24d909a5708c5a04a3e@65.108.78.116:11656,c8c6249b27b4a34aac554d12b0107cc6421098ef@65.108.126.35:24656,22acc593150fc38f9b1a2dc93cdc05e22566e7f6@213.239.207.165:29856,ac86c1678e20a87bf2f036741932910869726337@135.181.222.185:15656,5b7092ce1624e8a23a5d90897c4c5231fb7b1238@185.245.183.172:16656,1825de8cabc89fddea10f1cf9d65eda46b0cc7a1@5.9.121.55:41956,18ad67754e68f87df7801c010fca9e0e4744a21d@80.76.43.63:26656,b04b320e306ccd38b3da4d5ebc8099ceff452c65@178.63.8.245:61456,4c70dbb030c7b38e8f16999787074ed5ae33ba0a@94.250.202.17:26656,5142425b05c825f2a143ce7e4dc3315c347bffa8@95.216.172.203:43656,8c431676468dbfb80e22cc4bfd3b7ef881a1198e@185.185.82.61:26656,3a0ca1d94b199af43ae28d32572dda8c5cc723d0@15.235.114.158:26656,87e0efe332fdc4b0c2a76d18761a936509762067@212.41.9.98:36656,0d1a0ef6bf4520f98c03c88d71636b3a665f701d@213.202.247.178:26656,90422b8d40906967098a4010318344114e135d84@183.182.125.23:26656,6d76e4e0f73efa4e693b9d32934b09a025c6aa62@38.242.128.166:26656,367fb20ca2380ebbb73eb19b772564383b0f37ee@65.21.123.172:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.nolus/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/nolus/addrbook.json > $HOME/.nolus/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/nolus/genesis.json > $HOME/.nolus/config/genesis.json
```