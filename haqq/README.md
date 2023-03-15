<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://avatars.githubusercontent.com/u/108229184?s=200&v=4">
</p>

# Haqq Testnet | Chain ID : haqq_54211-3 | Custom Port : 247

### Community Documentation:
>- [Kjnodes Manual Installation](https://services.kjnodes.com/home/testnet/haqq/installation)

### Explorer:
>-  https://explorer.nodexcapital.com/haqq

### Automatic  (Must Using Ubuntu 22.04)
You can setup your Haqq fullnode in few minutes by using automated script below.
```
wget -O haqq.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/haqq/haqq.sh && chmod +x haqq.sh && ./haqq.sh
```
### Public Endpoint

>- API : https://rest.haqq-t.nodexcapital.com
>- RPC : https://rpc.haqq-t.nodexcapital.com
>- gRPC : https://grpc.haqq-t.nodexcapital.com

### Snapshot (Update every 5 hours)
```
sudo systemctl stop haqqd
cp $HOME/.haqqd/data/priv_validator_state.json $HOME/.haqqd/priv_validator_state.json.backup
rm -rf $HOME/.haqqd/data

curl -L https://snapshots.kjnodes.com/haqq-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.haqqd
mv $HOME/.haqqd/priv_validator_state.json.backup $HOME/.haqqd/data/priv_validator_state.json

sudo systemctl start haqqd && sudo journalctl -u haqqd -f --no-hostname -o cat
```

### State Sync
```
STATE_SYNC_RPC=https://haqq-testnet.rpc.kjnodes.com:443
STATE_SYNC_PEER=d5519e378247dfb61dfe90652d1fe3e2b3005a5b@haqq-testnet.rpc.kjnodes.com:35656
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  $HOME/.haqqd/config/config.toml

mv $HOME/.haqqd/priv_validator_state.json.backup $HOME/.haqqd/data/priv_validator_state.json
```
### Disable State Sync 
After successful synchronization using state sync above, we advise you to disable synchronization with state sync and restart the node
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.haqqd/config/config.toml
sudo systemctl restart haqqd && journalctl -u haqqd -f -o cat

### Live Peers
```
PEERS="acba49be707c31a831a3bca9d9d9f7defcc0bd21@142.132.148.174:26656,afa529ce3a5f2effcb21b2ee1bb7fe677476ed76@167.235.7.34:36656,a884387139109784cad9193652b82ef20a85d713@38.242.159.148:26656,29731457774b61da8186b9c764e8f7c1e2465e3e@142.93.36.176:26656,3df5a68b919177179c6dcb0b9c9354fd6bbba1c8@65.109.92.240:20116,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:35656,6771e65c1b30cc514faf5943320fdda480fe9124@95.216.39.183:26656,56158e0f2acf850114e82644afceb565a73b08cc@185.144.99.95:26656,90b1d14fc7393c6b6452ecf8b3cdd078a445a238@65.109.112.178:29656,2d13d679b64e1a574904a140f72815644ec71131@65.21.133.125:30656,b1c07038b5b9b96d6fb35e4bb417af7ed238e733@95.217.35.186:26656,230d299006a432b0f44534ca8a19c8c876c0ccb3@85.10.193.246:26656,23ff658b56fbb8bc73372973a34733ff5d79b435@142.132.202.50:11604,927a323649e7dd8d4c75da6e5edaee439652b46f@65.109.92.241:20116,0629018cef2e53288757381ffdc0b84cbb5931cc@95.216.1.249:26656,8c1ccf59f2a67713041579328097eb6b3e4e66e6@46.38.232.86:11656,073a2d6ef69f04b563e160a0e33eab84ae093aa9@154.26.157.233:35656,24e894d4d8a18276acf6051cccf369a1ce69842d@65.108.151.105:26656,cf5d60d0cdbdeb68caf1993a7422f942d37b56a7@194.163.142.120:35656,afe8c5af90e2eef4a98bc998366e2e780a927599@65.108.126.46:34656,32a8eec046b95e8646ff0810b4596dc7083a0beb@65.108.145.131:26656,eb503dddcc41ba801c646d63cc762de4e9c43aa4@35.228.23.164:26656,b72f2156db8c87e679dc853730746ff40038120c@213.239.215.77:26656,d7ac44bf8f8d760c3df1a8695145021f35feb985@34.88.220.124:26656,6c880870d399f8cce1bf189533a17ccb9b0ce623@52.57.72.228:26656,78e3ef8adf819b479acc13a2f92ab5c0fa350aeb@66.45.231.30:11464,1fefb6b75431482502e125a290deba1e7e539d4e@135.181.148.11:26656,a8546d3ed39e5c5a50d6d72146919e9bb0e12c13@3.77.11.162:26656,59af99085c961a6a5c8dc4bc8b3abffda16ddccb@135.181.38.62:26656,ed145a35b436878c1f1c10634bd18600f3696e17@95.217.181.142:26656,6fad54232f11a0306bd0d942c2ec5f9ba0ae2f1a@34.91.54.209:26656,331ca63236ba05842d561e22c0bcc8582efa60a1@209.126.80.192:26656,48a2a7762a579d25bca95b0a3548b714238dd60b@213.239.216.252:20656,b87827b470b0fa37e6ff5d10703ffbe4b35dec46@149.102.133.3:35656,f93085d78df16bbd16a525683af7f857ce1cd983@188.40.98.169:36656,a6150d39e4725d28a56f41ebf3c6d457c54bd2f1@34.138.250.4:26656,4034efbff7c82e1a2d3908fefd2512552dea63f5@65.109.38.208:26651,45bc6d84ffb3bb725cf78e82205639797c30af67@65.108.199.62:26656,9eb507f9365313dbe7f426050fec9648298f58ee@109.205.183.51:26656,73337217ebaf76420c8c00b565cb1cc5f53414ba@54.93.133.125:26656,90b40d2b773090b82aa7788c2d1937e4fd6d2dc0@65.108.231.124:19656,7f2828e3910a4b165a65e5bfb2465c1e809bad3b@65.108.48.182:26656,1a68f19b58e0c4e99c907a3c43923641a1595c88@149.102.133.29:35656,47a269c3e30f70d8234a2afd8e9055e74129fde0@65.108.129.29:36656,95ac6c40ac2c1cf29f5b4d1d556e2607535313db@65.108.235.209:17656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.haqqd/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snapshots.kjnodes.com/haqq-testnet/addrbook.json > $HOME//.haqqd/config/addrbook.json
```
### Genesis
```
curl -Ls https://snapshots.kjnodes.com/haqq-testnet/genesis.json > $HOME/.haqqd/config/genesis.json
```