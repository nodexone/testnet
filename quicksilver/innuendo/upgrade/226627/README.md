<span tyle="font-size:14px" align="right">NodeX Official Accounts :
<span style="font-size:14px" align="right">
<a href="https://discord.gg/JqQNcwff2e" target="_blank">NodeX Capital Discord</a></span> ⭐ 
<span style="font-size:14px" align="right">
<a href="https://twitter.com/nodexploit/" target="_blank">Twitter</a></span> ⭐ 
<span style="font-size:14px" align="right">
<hr>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/166148846-93575afe-e3ce-4ca5-a3f7-a21e8a8609cb.png">
</p>

# Chain upgrade to commit innuendo1
## (OPTION 1) Manual upgrade
Once the chain reaches the upgrade height, you will encounter the following panic error message:\
`ERR UPGRADE "xxx" NEEDED at height: 226627`
```
sudo systemctl stop quicksilverd
cd $HOME && rm quicksilver -rf
git clone https://github.com/ingenuity-build/quicksilver.git --branch v0.6.6-hotfix.2
cd quicksilver
make build
sudo chmod +x ./build/quicksilverd && sudo mv ./build/quicksilverd /usr/local/bin/quicksilverd
sudo systemctl restart quicksilverd && journalctl -fu quicksilverd -o cat
```

!!! DO NOT UPGRADE BEFORE CHAIN RECHES THE BLOCK `226627`!!!

### (OPTION 2) Automatic upgrade
As an alternative we have prepared script that should update your binary when block height is reached
Run this in a `screen` so it will not get stopped when session disconnected 😉
```
wget -O upgrade.sh https://raw.githubusercontent.com/kj89/testnet_manuals/main/quicksilver/innuendo/upgrade/226627/upgrade.sh && chmod +x upgrade.sh && ./upgrade.sh
```
