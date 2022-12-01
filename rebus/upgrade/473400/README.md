<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/182218818-f686aebb-6e48-47e1-96a2-e0d8faf44acb.png">
</p>

# Chain upgrade to commit v0.2.0
## (OPTION 1) Manual upgrade
Once the chain reaches the upgrade height, you will encounter the following panic error message:\
`ERR UPGRADE "xxx" NEEDED at height: 473400`
```
sudo systemctl stop rebusd
cd $HOME && rm -rf rebus.core
git clone https://github.com/rebuschain/rebus.core.git && cd rebus.core
git checkout v0.2.0
make install
sudo systemctl restart rebusd && journalctl -fu rebusd -o cat
```

!!! DO NOT UPGRADE BEFORE CHAIN RECHES THE BLOCK `473400`!!!

### (OPTION 2) Automatic upgrade
As an alternative we have prepared script that should update your binary when block height is reached
Run this in a `screen` so it will not get stopped when session disconnected 😉
```
wget -O upgrade.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/rebus/upgrade/473400/upgrade.sh && chmod +x upgrade.sh && ./upgrade.sh
```
