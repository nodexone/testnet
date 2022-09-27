<strong><p style="font-size:14px" align="left">Founder :
<a href="https://discord.gg/JqQNcwff2e" target="_blank">NodeX Capital Discord</a></p></strong>
<strong><p style="font-size:14px" align="left">Visit Our Website : 
<a href="https://nodex.codes/" target="_blank">https://nodex.codes</a></p></strong>
<strong><p style="font-size:14px" align="left">Follow Me :
<a href="https://twitter.com/nodexploit/" target="_blank">NodeX Twitter</a></p></strong>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/184189788-a617676f-fae9-43b4-89d3-e3ab779946f7.png">
</p>

# Chain upgrade to commit v1.7.0
## (OPTION 1) Manual upgrade
Once the chain reaches the upgrade height, you will encounter the following panic error message:\
`ERR UPGRADE "xxx" NEEDED at height: 3608063`
```
sudo systemctl stop gravityd
cd $HOME
rm gravity-bin -rf
mkdir gravity-bin && cd gravity-bin
wget -O gravityd https://github.com/Gravity-Bridge/Gravity-Bridge/releases/download/v1.7.0/gravity-linux-amd64
wget -O gbt https://github.com/Gravity-Bridge/Gravity-Bridge/releases/download/v1.7.0/gbt
chmod +x *
sudo mv * /usr/bin/
sudo systemctl restart gravityd
sudo systemctl restart orchestrator
```

!!! DO NOT UPGRADE BEFORE CHAIN RECHES THE BLOCK `3608063`!!!

### (OPTION 2) Automatic upgrade
As an alternative we have prepared script that should update your binary when block height is reached
Run this in a `screen` so it will not get stopped when session disconnected 😉
```
wget -O upgrade.sh https://raw.githubusercontent.com/nodesxploit/testnet/main/gravity/upgrade/3608063/upgrade.sh && chmod +x upgrade.sh && ./upgrade.sh
```
