<strong><p style="font-size:14px" align="left">Founder :
<a href="https://discord.gg/JqQNcwff2e" target="_blank">NodeX Capital Discord</a></p></strong>
<strong><p style="font-size:14px" align="left">Visit Our Website : 
<a href="https://nodex.codes/" target="_blank">https://nodex.codes</a></p></strong>
<strong><p style="font-size:14px" align="left">Follow Me :
<a href="https://twitter.com/nodexploit/" target="_blank">NodeX Twitter</a></p></strong>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/182218818-f686aebb-6e48-47e1-96a2-e0d8faf44acb.png">
</p>

# Chain upgrade to commit v0.0.4
## (OPTION 1) Manual upgrade
Once the chain reaches the upgrade height, you will encounter the following panic error message:\
`ERR UPGRADE "xxx" NEEDED at height: 995737`
```
sudo systemctl stop rebusd
cd $HOME && rm -rf rebus.core
git clone https://github.com/rebuschain/rebus.core.git && cd rebus.core
git checkout v0.0.4
make install
sudo systemctl restart rebusd && journalctl -fu rebusd -o cat
```

!!! DO NOT UPGRADE BEFORE CHAIN RECHES THE BLOCK `995737`!!!

### (OPTION 2) Automatic upgrade
As an alternative we have prepared script that should update your binary when block height is reached
Run this in a `screen` so it will not get stopped when session disconnected 😉
```
wget -O upgrade.sh https://raw.githubusercontent.com/nodesxploit/testnet/main/rebus/upgrade/995737/upgrade.sh && chmod +x upgrade.sh && ./upgrade.sh
```
