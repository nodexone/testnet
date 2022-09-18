<span tyle="font-size:14px" align="right">NodeX Official Accounts :
<span style="font-size:14px" align="right">
<a href="https://discord.gg/JqQNcwff2e" target="_blank">NodeX Capital Discord</a></span> ⭐ 
<span style="font-size:14px" align="right">
<a href="https://twitter.com/nodexploit/" target="_blank">Twitter</a></span> ⭐ 
<span style="font-size:14px" align="right">
<hr>

<p align="center">
  <img height="100" height="auto" src="https://ping.pub/logo.svg">
</p>

# Set up ping pub for your cosmos chains

## 1. Update packages
```
sudo apt update && sudo apt upgrade -y
```

## 2. Install nginx
```
sudo apt install nginx -y
```

## 3. Install nodejs
```
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### 4. Install yarn
```
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn
```

## 3. Install binaries
```
cd ~
git clone https://github.com/ping-pub/explorer.git
cd explorer
```

## 4. Cleanup predefined chains
```
rm $HOME/explorer/src/chains/mainnet/*
```

## 5. Add testnet chains
```
wget -qO $HOME/explorer/src/chains/mainnet/dws.json https://raw.githubusercontent.com/nodesxploit/testnet/main/chain-explorer/testnet_chains/dws.json
wget -qO $HOME/explorer/src/chains/mainnet/sei.json https://raw.githubusercontent.com/nodesxploit/testnet/main/chain-explorer/testnet_chains/sei.json
wget -qO $HOME/explorer/src/chains/mainnet/uptick.json https://raw.githubusercontent.com/nodesxploit/testnet/main/chain-explorer/testnet_chains/uptick.json
wget -qO $HOME/explorer/src/chains/mainnet/cardchain.json https://raw.githubusercontent.com/nodesxploit/testnet/main/chain-explorer/testnet_chains/cardchain.json
wget -qO $HOME/explorer/src/chains/mainnet/teritori.json https://raw.githubusercontent.com/nodesxploit/testnet/main/chain-explorer/testnet_chains/teritori.json
wget -qO $HOME/explorer/src/chains/mainnet/paloma.json https://raw.githubusercontent.com/nodesxploit/testnet/main/chain-explorer/testnet_chains/paloma.json
wget -qO $HOME/explorer/src/chains/mainnet/aura.json https://raw.githubusercontent.com/nodesxploit/testnet/main/chain-explorer/testnet_chains/aura.json
wget -qO $HOME/explorer/src/chains/mainnet/rebus.json https://raw.githubusercontent.com/nodesxploit/testnet/main/chain-explorer/testnet_chains/rebus.json
```

## 6. Build ping.pub
```
yarn && yarn build
cp -r $HOME/explorer/dist/* /var/www/html
sudo systemctl restart nginx
```
