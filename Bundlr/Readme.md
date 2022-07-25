# The long-awaited testnet from the Bundlr team has started.

![resim](https://img2.teletype.in/files/92/35/92352e64-ee62-4cb0-a078-349ecad2b296.jpeg)


Explorer:
>- https://bundlr.network/explorer

## Hardware Requirements
- Memory: 8GB RAM
- CPU: 2 Core
- Disk: 250 GB SSD Storage
- Bandwidth: 1 Gbps for Download/100 Mbps for Upload

## Installation steps:
You can set up your Bundlr Node in minutes using the automated script below.
```
wget -O Bundlr.sh https://raw.githubusercontent.com/nodesxploit/testnet/main/Bundlr/Bundlr.sh && chmod +x Bundlr.sh && ./Bundlr.sh
```

### Post-Installation Steps
Go to the Arweave site and create a wallet:
https://faucet.arweave.net/

When you open the site, a screen will appear as in the picture, tick the checkbox and click the 'Continue' button.

![resim](https://i.hizliresim.com/dcsodu9.png)

On the second screen, tick the checkbox again and click the 'Download Wallet' button.

![resim](https://i.hizliresim.com/mmypjxp.png)

Click the 'Open Tweet Pop-up' button on the next screen, a window will open for you to tweet, your wallet address will be written there.
Copy your wallet address. Do not tweet.

After that
Go to https://bundlr.network/faucet and paste the wallet address you copied. Then tweet from this site.
Come to the site and paste the link of the tweet you sent.

We successfully downloaded our wallet to our computer and received our coin from the faucet.

What we need to do now is to edit the wallet name we downloaded.

- the name of the file you downloaded looks like this:
`arweave-key-QeKJ_HaxE....................ejQ.json`

Rename this file to `wallet.json`. `AND MUST BACK UP`

Then we put this wallet in the `validator-rust` folder on our server.

**Create Service File**
```
tee $HOME/validator-rust/.env > /dev/null <<EOF
PORT=80
BUNDLER_URL="https://testnet1.bundlr.network"
GW_CONTRACT="RkinCLBlY4L5GZFv8gCFcrygTyd5Xm91CzKlR6qxhKA"
GW_ARWEAVE="https://arweave.testnet1.bundlr.network"
EOF
```

**Start Docker:**

Installation takes about 10 minutes. Therefore, it is recommended to create a screen beforehand in order to prevent connection interruptions.

```
cd ~/validator-rust && docker-compose up -d
```

**Check Logs:**
```
cd ~/validator-rust && docker-compose logs --tail=100 -f
```

**The logs should look like this:**

![resim](https://i.hizliresim.com/cyq2y47.png)

**Launch Validator:**
```
npm i -g @bundlr-network/testnet-cli
```

**Add your validator to the network. Edit the 'youripaddress' part:**
```
testnet-cli join RkinCLBlY4L5GZFv8gCFcrygTyd5Xm91CzKlR6qxhKA -w wallet.json -u "http://youripadress:80" -s 25000000000000
```

**When all transactions are successful, you will receive a message similar to the one below.**

![resim](https://i.hizliresim.com/9a8uzrb.png)



**This much...**

You can check your wallet address from Explorer.
- https://bundlr.network/explorer
