<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

# Ironfish Incentivized Testnet - Miner Setup

Official documentation:
- Official manual: https://ironfish.network/docs/onboarding/iron-fish-tutorial
- Explorer: https://explorer.ironfish.network/
- Check you Leaderboard : https://testnet.ironfish.network/leaderboard 

## Recommended hardware requirements
- CPU: 16/8 VCPU
- Memory: 32/16 GB RAM
- Disk: 500 GB SSD Storage (Storage requirements will vary based on various factors (age of the chain, transaction rate, etc)

## Setup $IRON Miner

### Automatic installation
```
wget -q -O ironfish.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/ironfish/ironfish.sh && chmod +x ironfish.sh && sudo /bin/bash ironfish.sh
```
Choose you wanted option (for example option 1 – simply installing the node), enter preferred node name and wait for installation to complete.

## Post installation
The steps below are optional, you only need to start mining to increase your balance, and mining will start as soon as you sync the node. By default, a wallet is created with the `default` name, which used for mining rewards, so you do not need to create a new one.


## Load variables:
```
. $HOME/.bashrc
. $HOME/.bash_profile
```

## Set your node name 
(if you have empty config, you can check that by the command cat $HOME/.ironfish/config.json)

```
ironfish config:set nodeName $IRONFISH_NODENAME
ironfish config:set blockGraffiti $IRONFISH_NODENAME
```
The name you specify here should also be specified when registering in the leaderboard.

## Create wallet
```
ironfish accounts:create $IRONFISH_WALLET
```

## Set created wallet as default wallet:
```
ironfish accounts:use $IRONFISH_WALLET
```

## Check balance:
```
ironfish accounts:balance $IRONFISH_WALLET
```

## Usefull command
Before starting the miner, make sure that your node is synchronized with the network by running the command:
```
ironfish status -f
```
Enable Telemetry
```
ironfish config:set enableTelemetry true
```
Send a transaction using your default account
```
ironfish accounts:pay
```
If you want to send the transaction from another account, you can use the `-f` flag
.
```
ironfish accounts:pay -f MySecondAccount
```
In order to receive a transaction, you just need to tell the sender the public key of your account. If you do not know your public key, run the following command
```
ironfish accounts:publickey
```
To get the public key of your another account running the command
```
ironfish accounts:publickey -a MySecondAccount
```
View the list of accounts on your node
```
ironfish accounts:list
```
Export an account to a file
```
ironfish accounts:export AccountName filename
```
Import an account from a file
```
ironfish accounts:import filename
```
Delete your account
```
ironfish accounts:remove MyAccount
```
You can get information about connection status and errors by running the following command:
```
ironfish peers:list -fe
```
Export keys
```
mkdir -p $HOME/.ironfish/keys
ironfish accounts:export $IRONFISH_WALLET $HOME/.ironfish/keys/$IRONFISH_WALLET.json
```
Import keys
```
ironfish accounts:import PATH_TO_THE_KEY
```
Check ironfish status
```
ironfish status -f
```
Check the node
```
journalctl -u ironfishd -f
```
Check the miner
```
journalctl -u ironfishd-miner -f
```
Stop the node
```
service ironfishd stop
```
Stop the miner
```
service ironfishd-miner stop
```



