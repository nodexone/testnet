<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<hr>

<p align="center">
 <img height="250" height="auto" src="https://user-images.githubusercontent.com/34649601/195998836-4f64c191-0a50-4819-a623-a2e9fb84901b.png">
 </p>

# Manual update Mande Chain
Once the chain reaches the upgrade height, you will encounter the following panic error message:\
```
sudo systemctl stop mande-chaind
git clone https://github.com/mande-labs/testnet-1/raw/main/mande-chaind
mv mande-chaind /usr/local/bin
chmod 744 /usr/local/bin/mande-chaind
```

### Download genesis file
```
wget -O $HOME/.mande-chain/config/genesis.json "https://raw.githubusercontent.com/mande-labs/testnet-1/main/genesis.json"
```

### Download addrbook
```
wget -O $HOME/.mande-chain/config/addrbook.json "https://raw.githubusercontent.com/obajay/nodes-Guides/main/Mande%20Chain/addrbook.json"
```
### Restart System
```
sudo systemctl daemon-reload
sudo systemctl enable mande-chaind
sudo systemctl restart mande-chaind && sudo journalctl -u mande-chaind -f -o cat
```