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

# Dymension Testnet | Chain ID : 35-C | Custom Port : 242

### Official Documentation:
>- [Validator setup instructions](https://docs.dymension.xyz/validators/full-node/run-a-node)

### Explorer:
>-  https://explorer.nodexcapital.com/dymension

### Automatic  (Must Using Ubuntu 22.04)
You can setup your Dymension fullnode in few minutes by using automated script below.
```
wget -O dymension.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/dymension/dymension.sh && chmod +x dymension.sh && ./dymension.sh
```
### Public Endpoint

>- API : https://rest.dymension-t.nodexcapital.com
>- RPC : https://rpc.dymension-t.nodexcapital.com
>- gRPC : https://grpc.dymension-t.nodexcapital.com

### Snapshot (Update every 5 hours)
```
sudo systemctl stop dymd
cp $HOME/.dymension/data/priv_validator_state.json $HOME/.dymension/priv_validator_state.json.backup
rm -rf $HOME/.dymension/data

curl -L https://snapshots.kjnodes.com/dymension-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.dymension
mv $HOME/.dymension/priv_validator_state.json.backup $HOME/.dymension/data/priv_validator_state.json

sudo systemctl start dymd && sudo journalctl -u dymd -f --no-hostname -o cat
```

### State Sync
```
sudo systemctl stop dymd
cp $HOME/.dymension/data/priv_validator_state.json $HOME/.dymension/priv_validator_state.json.backup
dymd tendermint unsafe-reset-all --home $HOME/.dymension

STATE_SYNC_RPC=https://rpc.dymension-t.nodexcapital.com:443
STATE_SYNC_PEER=d5519e378247dfb61dfe90652d1fe3e2b3005a5b@dymension-testnet.rpc.kjnodes.com:46656
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  $HOME/.dymension/config/config.toml

mv $HOME/.dymension/priv_validator_state.json.backup $HOME/.dymension/data/priv_validator_state.json
sudo systemctl start dymd && sudo journalctl -u dymd -f --no-hostname -o cat
```
### Disable State Sync 
After successful synchronization using state sync above, we advise you to disable synchronization with state sync and restart the node
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.dymension/config/config.toml
sudo systemctl restart dymd && journalctl -u dymd -f -o cat

### Live Peers
```
PEERS="e46b42d50947795f681cf9bfd601ae806e7a8d49@188.34.178.190:46656,547cf669555bd611ba57b37bb0f288793ea4ec49@141.94.138.48:26673,dddc76ca6279ac90b12cf35b39c46a2fc2c2ce52@5.161.78.48:46656,acb69c31cac6140a1a9570e683de5e26dd008cff@51.222.44.116:32656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:46656,56e0f891f8312e239a631aea2f8b0e64c9f7d824@135.181.95.145:36656,88e09de4c713ecb3497f39f6e6c599aea7a10750@65.109.38.111:20556,63d971a42e323f9411ef702d1f268f9862781c1f@194.163.165.176:40656,af97c76448e6a5d7671c6523f38fc48cc7273da7@217.76.59.46:26656,94b63fddfc78230f51aeb7ac34b9fb86bd042a77@146.19.24.43:30585,ae509356c743a12259248fa8df23e42dae885e05@78.46.84.144:26656,7fc44e2651006fb2ddb4a56132e738da2845715f@65.108.6.45:61256,6ebe5856a7617cb9309a923a3935687903d2607d@141.95.97.28:15256,965694b051742c2da0ea66502dd9bfeea38de265@198.244.228.235:26656,8f84d324a2d266e612d06db4a793b0d001ee62a0@38.146.3.200:20556,f433653cef597b3f0dd5f4e3e46c05fd121246bb@95.216.149.50:26656,3c937029e41e3f7b92b8b87d787be0ddc2a3f13c@70.34.214.236:26656,0f1045fd8c81a8ad843cf0f96a73ed34865322a7@3.145.180.81:26656,39794289e20cf80eba0a720eed58e7097e5686c1@136.243.103.53:46656,488a1665d94f257733b04f7b4fbcef058cbb11cd@65.108.199.206:31656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.dymension/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snapshots.kjnodes.com/dymension-testnet/addrbook.json > $HOME//.dymension/config/addrbook.json
```
### Genesis
```
curl -Ls https://snapshots.kjnodes.com/dymension-testnet/genesis.json > $HOME/.dymension/config/genesis.json
```