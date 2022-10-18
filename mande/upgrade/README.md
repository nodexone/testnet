<strong><p style="font-size:14px" align="left">Founder :
<a href="https://discord.gg/JqQNcwff2e" target="_blank">NodeX Capital Discord</a></p></strong>
<strong><p style="font-size:14px" align="left">Visit Our Website : 
<a href="https://nodex.codes/" target="_blank">https://nodex.codes</a></p></strong>
<strong><p style="font-size:14px" align="left">Follow Me :
<a href="https://twitter.com/nodexploit/" target="_blank">NodeX Twitter</a></p></strong>
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