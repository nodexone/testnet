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

## Lava Testnet | Chain ID : lava-testnet-1

### Official Documentation:
>- [Validator setup instructions](https://services.kjnodes.com/home/testnet/lava/installation)

### Explorer:
>-  https://explorer.nodexcapital.com/lava

### Automatic Installer (Must Using Ubuntu 22.04)
You can setup your Lava fullnode in few minutes by using automated script below.
```
wget -O lava.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/lava/lava.sh && chmod +x lava.sh && ./lava.sh
```
### Public Endpoint

>- API : https://api.lava-t.nodexcapital.com
>- RPC : https://rpc.lava-t.nodexcapital.com
>- gRPC : https://grpc.lava-t.nodexcapital.com

### Snapshot (Update every 5 hours)
```
sudo systemctl stop lavad
cp $HOME/.lava/data/priv_validator_state.json $HOME/.lava/priv_validator_state.json.backup
rm -rf $HOME/.lava/data

curl -L https://snapshots.kjnodes.com/lava-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.lava
mv $HOME/.lava/priv_validator_state.json.backup $HOME/.lava/data/priv_validator_state.json

sudo systemctl start lavad && sudo journalctl -u lavad -f --no-hostname -o cat
```

### State Sync
```
Currently lava does not support State sync 😢
```

### Live Peers
```
PEERS="a2afdc48785be73f208af349e78d632b5556cc01@5.75.226.151:26656,944389dd08321247c8ad687d904591a3d73d16c6@173.249.38.130:26656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:44656,ec8065014ed4814b12c884ed528b96f281104528@65.21.131.215:26686,e1383b216c42acc842193c5ac7321ce6c0d73db0@78.47.37.142:26656,3173b2d34ce415ee9a1bf08646d85688bf49e299@5.189.186.222:36656,e8256f9fedf27b6de76c8a13e2db050d0a7bd905@95.216.42.83:26656,c5c98017339ce6d4d5d2a4fd0fb1aaeb966ef0f7@65.108.124.57:36656,370ae92bd28701e0c1d8dc912ccf0d40fe0db3d5@157.90.245.166:26656,8a089094624f27698f365402a059b8b810532805@207.180.229.129:26656,821c9347c927db52138dcd4bb54478fdf17f273e@81.0.218.53:26656,4634ca7cefe997035440df1095915ed255e81296@49.12.189.98:26656,e268a2ce255d51a93e6ec89ee73c233bbaec70f4@49.12.185.46:26656,c0efea9152aed75fcf3022b8af45243818c59d6a@49.12.13.104:26656,07c8a4eea1f6826509d9da5ec7eee7a1a145ab09@20.24.72.210:26656,877fb1670209bc2a347d7755388b677b330e98ea@95.216.9.42:26656,4732ed188fbe7603f81d9f4c825397277bb72217@5.75.235.195:26656,1598a86c04a64d17fa15a07eb201f50c5d760842@75.119.136.106:26656,a753585da65620cd735d790955c548ce2f3f2286@167.86.98.134:26656,9a151159039fd8abce61ddb21e5342605787792b@5.75.228.39:26656,dfa93668152cb6b3a822c987f9c22110a1c2f314@178.18.255.221:26656,4ad3f3731073a016fa0c99118b2a5a2d313928f5@207.180.233.148:26656,61c9667630221059a971a114e48a936f45084d2e@185.209.230.156:26656,ec3a0b0399b19e89e04a1fef5cfafdc0f3d8a1d7@185.209.230.159:26656,3aef9d4925d9c299a77a4209db2be3fd7ded4ad0@94.103.91.148:26656,0c630a0e2afc5e03a32e989a47743d7c09e31337@138.201.173.81:26656,6a55747d1f93e46696f233ac563e28fea24afc47@38.242.237.192:36656,e83c0fdeb2b0e258bb559d657d0907b63635127a@159.69.149.85:26656,bec79fab73dbbe345d8b26cdeeeee4ab83fdf80e@176.9.22.117:35656,474e2436e097c28472a1fe269e1825762fa340d6@38.242.128.19:26656,c83d7b205b2e80bd9a33c13161bd39d520988455@38.242.139.189:26656,ab924e7944c332bd1b52c8733e262bbdd33cb5ac@116.202.165.53:26656,ade02cddf71489b79a2054a7c6ba2cab8a0abb18@185.163.125.232:26656,d5ad7ae6caf54ef20a6dc04d30a55caac6c540c9@5.61.41.138:26656,4e96723af8feb8a515573a7b9391e7bf7d562480@194.163.162.155:26656,1550fe479ee2dcfa35f7dcd2c66f37a50d34b0e3@178.63.132.243:2237,e5f324d671e8bba44cd8eef2cb5b6e46ccf4f95a@65.108.199.120:60756,cba6347ac83120324c34514d383f3e9835ac15e9@5.75.139.114:26656,6f1f1414c63e9ffca9cb59fe4c847580da2020d6@109.123.235.222:10104,fdc3bd914360b1be8ee2e9f4a447223830527497@78.46.36.203:26656,ca1c561ad051d12cf99d8846303f4d31bfe3eb83@159.203.111.26:26656,1b09acd86e1a2db56c72db7848ada3ad581f027a@95.217.109.222:36656,2cb465a7c919321978f89701b4ae07ac505f7ad8@194.163.184.228:26656,5e8d65796d939fc16fa0c955dfbd16c9c519606b@222.71.35.43:26656,ef6e9620807e7e4614fd8e02722f8075ec277544@199.175.98.122:26656,22c51515eea1df09dc872dc8843efb7fc73770b1@199.175.98.102:26656,94bba76f57bc30a6c0afa4ca10cd54d0b247569d@38.242.221.85:26656,db8b1d876480849784569b927a3cc6d27dcc05a1@65.108.229.93:31656,7e68edc23e6c716b3248099dd1f03810a57975ef@65.109.92.150:34656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.lava/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snapshots.kjnodes.com/lava-testnet/addrbook.json > $HOME/.lava/config/addrbook.json
```
### Genesis
```
curl -Ls https://snapshots.kjnodes.com/lava-testnet/genesis.json > $HOME/.lava/config/genesis.json
```