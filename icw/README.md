<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://github.com/nodexcapital/ChainLogo/blob/a3d7d6d3de92dd5f8bcde441e1829e145385429a/icw.png">
</p>

<p align="center">
 <img height="150" height="auto" src="https://miro.medium.com/fit/c/176/176/0*Fje3iR1h1XcvlRx8">
</p>

# Official Links
### [ICW Chain Official Website](https://www.icwchain.com/)


## Minimum Requirements 
- 4-core CPU 
- 8G memory
- 50G available disk space
- 2M bandwidth.
## Recommended system requirements
- 8-core CPU 
- 16G memory 
- 200G available hard disk space
- 10 M bandwidth.

## Node Install Tutorial

### Depencies 
```
sudo apt update && sudo apt upgrade -y && sudo apt install wget openjdk-8-jdk -y
```

### Download Wallet
```
wget http://8.219.130.70:8002/download/ICW_Wallet.tar
```

### Decompress it
```
tar -xvf ICW_Wallet.tar
```

### Start your wallet and check the status
```
cd ICW_Wallet
./start
./check-status
```
a sucessfull wallet would look like this :

 <img height="400" height="auto" src="https://user-images.githubusercontent.com/34649601/194700746-57d64f33-8fc0-414d-9dad-fe83b42828b7.png">
</p>

Run CMD by typing :
```
./cmd
```
a successfull cmd look like this:

 <img height="400" height="auto" src="https://user-images.githubusercontent.com/34649601/194700888-e358b614-bacb-40da-a353-12a2317941ec.png">
</p>

To check if your node already synced to the latest block insert this command on CMD-Module
```
network info
```

 <img height="300" height="auto" src="https://user-images.githubusercontent.com/34649601/194700959-347549b0-f9c3-4877-a6ae-a5c90d3d21e1.png">
</p>

Synchronization is complete when localBestHeight equals netBestHeight

`Note: The speed of synchronizing the height of the block is related to the network speed
of the machine.`

### Import Your on-chain account 
Once your node is Synced, import your on-chain private key

In CMD-Module type 
```
import <private-key>
```
Example : `import 6d6e510702da8aed3d2a5dc5a3140736b4b392ad44415xxxxxxxxxxxxxxx`

Please enter the password `ICW123456`

### Import your package account
Import your package account private key (NOT ON-CHAIN ACCOUNT !!)
```
import <private-key>
```
Example : `import 5f190d5cd251093539fa3229db4663b04c1a7b236d9874c59xxxxxxxxxxxx`

Please enter the password `ICW123456`


### Create Agent / Validator

To create your agent run the following command in CMD Module

PLEASE MAKE SURE YOUR NODE IS SYNCED! CHECK BY RUNNING `network info` command in CMD Module
```
createagent <agent address> <package address> <commision rate> <deposit>
```
`EXAMPLE`
```
createagent ICWc6Hgbnyu2MnnwGhxxxxxxxxxxxxx ICWc6HgZE1s1mqbdgVTvT5oX4Jxxxxxxxxxxx 10 20000
```
- Agent address (chains) : users
- Package address: provided by the user
- Commission rate :10-100 adjustable.
- Deposit: 20,000 ICW

Then enter password `ICW123456`

Then you will get txhash of successfull transaction
![image](https://user-images.githubusercontent.com/34649601/195807606-f0db0858-3191-4b59-8b97-8db41b226e2d.png)

### Reducing memory usage if you have less than 8GB RAM
`Available memory more than 8G, do not need to perform the following actions`

Change the `xmsMem` parameter from `8000000` to `4000000`
```
cd ICW_Wallet/
sudo nano start
```

Then change `xmsMem` parameter

![image](https://user-images.githubusercontent.com/34649601/195807944-100a6f61-df3b-4887-979f-f28d693b995e.png)
