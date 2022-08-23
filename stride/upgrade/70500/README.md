<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/183283696-d1c4192b-f594-45bb-b589-15a5e57a795c.png">
</p>

# Chain upgrade to commit 90859d68d39b53333c303809ee0765add2e59dab
## (OPTION 1) Manual upgrade
Once the chain reaches the upgrade height, you will encounter the following panic error message:\
`ERR UPGRADE "xxx" NEEDED at height: 70500`
```
sudo systemctl stop strided
cd $HOME && rm -rf stride
git clone https://github.com/Stride-Labs/stride.git && cd stride
git checkout 90859d68d39b53333c303809ee0765add2e59dab
make build
sudo mv build/strided $(which strided)
sudo systemctl restart strided && journalctl -fu strided -o cat
```

!!! DO NOT UPGRADE BEFORE CHAIN RECHES THE BLOCK `70500`!!!

### (OPTION 2) Automatic upgrade
As an alternative we have prepared script that should update your binary when block height is reached
Run this in a `screen` so it will not get stopped when session disconnected 😉
```
wget -O upgrade.sh https://raw.githubusercontent.com/nodesxploit/testnet/main/stride/upgrade/70500/upgrade.sh && chmod +x upgrade.sh && ./upgrade.sh
```
