<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/190717698-486153c1-5d81-4e57-9363-cead70c13cc8.png">
</p>

# Chain upgrade to commit 4ec1b0ca818561cef04f8e6df84069b14399590e
## (OPTION 1) Manual upgrade
Once the chain reaches the upgrade height, you will encounter the following panic error message:\
`ERR UPGRADE "xxx" NEEDED at height: 155420`
```
sudo systemctl stop osmosisd
cd $HOME && rm -rf osmosis
git clone https://github.com/Stride-Labs/osmosis.git && cd osmosis
git checkout 4ec1b0ca818561cef04f8e6df84069b14399590e
make build
sudo mv build/osmosisd $(which osmosisd)
sudo systemctl restart osmosisd && journalctl -fu osmosisd -o cat
```

!!! DO NOT UPGRADE BEFORE CHAIN RECHES THE BLOCK `155420`!!!

### (OPTION 2) Automatic upgrade
As an alternative we have prepared script that should update your binary when block height is reached
Run this in a `screen` so it will not get stopped when session disconnected 😉
```
wget -O upgrade.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/osmosis/upgrade/155420/upgrade.sh && chmod +x upgrade.sh && ./upgrade.sh
```
