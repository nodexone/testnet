<span tyle="font-size:14px" align="right">NodeX Official Accounts :
<span style="font-size:14px" align="right">
<a href="https://discord.gg/JqQNcwff2e" target="_blank">NodeX Capital Discord</a></span> ⭐ 
<span style="font-size:14px" align="right">
<a href="https://twitter.com/nodexploit/" target="_blank">Twitter</a></span> ⭐ 
<span style="font-size:14px" align="right">
<a href="https://nodex.codes/" target="_blank">Reddit</a></span>⭐
<span style="font-size:14px" align="right">
<a href="https://discord.gg/JqQNcwff2e" target="_blank">Youtube</a></span>⭐
<span style="font-size:14px" align="right">
<a href="https://nodex.codes/" target="_blank">TikTok</a></span> ⭐
<span style="font-size:14px" align="right">
<a href="https://discord.gg/JqQNcwff2e" target="_blank">Instagram</a></span> ⭐
<span style="font-size:14px" align="right">
<a href="https://nodex.codes/" target="_blank">Facebook</a></span>⭐
<hr>


<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/171797060-240af6e2-f423-4bd2-8a72-c4a638eaf15c.png">
</p>

# Masa node setup

Official documentation:
- https://github.com/masa-finance/masa-node-v1.0

## Minimal hardware requirements
- CPU: 1 core
- Memory: 2 GB RAM
- Disk: 20 GB

## Set up your Masa node
### Option 1 (automatic)
You can setup your Masanode in few minutes by using automated script below. It will prompt you to input your node name!
```
wget -O masa.sh https://raw.githubusercontent.com/nodesxploit/testnet/main/masa/masa.sh && chmod +x masa.sh && ./masa.sh
```

### Option 2 (manual)
You can follow [manual guide](https://github.com/nodesxploit/testnet/blob/main/masa/manual_install.md) if you better prefer setting up node manually

## Usefull commands

### Check masa node logs
You have to see blocks comming
```
journalctl -u masad -f | grep "new block"
```

### Get masa node key
!Please make sure you backup your `node key` somewhere safe. Its the only way to restore your node!
```
cat $HOME/masa-node-v1.0/data/geth/nodekey
```

### Get masa enode id
```
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.nodeInfo.enode | sed 's/^.//;s/.$//'
```

### Restart service
```
systemctl restart masad.service
```

### Check eth node status
To check eth node synchronization status first of all you have to open geth
```
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc
```

After that you can use commands below inside geth (eth.syncing should = false and net.peerCount have to be > than 0)
```
# node data directory with configs and keys
admin.datadir
# check if node is connected
net.listening
# show synchronization status
eth.syncing
# node status (difficulty should be equal to current block height)
admin.nodeInfo
# show synchronization percentage
eth.syncing.currentBlock * 100 / eth.syncing.highestBlock
# list of all connected peers (short list)
admin.peers.forEach(function(value){console.log(value.network.remoteAddress+"\t"+value.name)})
# list of all connected peers (long list)
admin.peers
# show connected peer count
net.peerCount
```

_Press CTRL+D to exit_

### Restore node key
To restore masa node key just insert it into _$HOME/masa-node-v1.0/data/geth/nodekey_ and restart service afterwards\
Replace `<YOUR_NODE_KEY>` with your node key and run command below
```
echo <YOUR_NODE_KEY> > $HOME/masa-node-v1.0/data/geth/nodekey
systemctl restart masad.service
```
