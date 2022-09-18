<span tyle="font-size:14px" align="right">NodeX Official Accounts :
<span style="font-size:14px" align="right">
<a href="https://discord.gg/JqQNcwff2e" target="_blank">NodeX Capital Discord</a></span> ⭐ 
<span style="font-size:14px" align="right">
<a href="https://twitter.com/nodexploit/" target="_blank">Twitter</a></span> ⭐ 
<span style="font-size:14px" align="right">
<hr>

# Manual Inery node setup
If you want to setup fullnode manually follow the steps below

## Install all apps and tools needed
```
sudo apt-get update && sudo apt install git && sudo apt install screen
```
```

sudo apt-get install -y make bzip2 automake libbz2-dev libssl-dev doxygen graphviz libgmp3-dev \
autotools-dev libicu-dev python2.7 python2.7-dev python3 python3-dev \
autoconf libtool curl zlib1g-dev sudo ruby libusb-1.0-0-dev \
libcurl4-gnutls-dev pkg-config patch llvm-7-dev clang-7 vim-common jq libncurses5
```
## Open Port (im using firewalld)
```
sudo apt-get install firewalld
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --set-default-zone=public
sudo firewall-cmd --zone=public --add-port=22/tcp --permanent
sudo firewall-cmd --zone=public --add-port=8888/tcp --permanent
sudo firewall-cmd --zone=public --add-port=9010/tcp --permanent
sudo firewall-cmd --reload
sudo systemctl restart firewalld
```

## To check firewall
```
sudo systemctl status firewalld
```
## To check if all port already opened
```
sudo firewall-cmd --list-all
```
 
## Installing Nodes

Clone Inery Nodes data from github
```
git clone https://github.com/inery-blockchain/inery-node
```
Go to inery setup folder
```
cd inery-node/inery.setup
```
Change app permission
```
chmod +x ine.py
```
export path to local os environment for inery binaries
```
./ine.py --export
```
refresh path variable
```
cd; source .bashrc; cd -
```

## Create Wallet
Important step! - PLEASE SYNC FIRST BEFORE RUN THIS COMMAND BELOW!!
```
cd;  cline wallet create --file defaultWallet.txt
```
If your wallet has password, you need to unlock it first
```
cline wallet unlock --password YOUR_WALLET_PASSWORD
```
## Import key 
```
cline wallet import --private-key MASTER_PRIVATE_KEY
```
change MASTER_PRIVATE_KEY with your privatekey on Dashboard.

## Register as producer:
```
cline system regproducer ACCOUNT_NAME ACCOUNT_PUBLIC_KEY 0.0.0.0:9010
```
## Approve your account as producer:
```
cline system makeprod approve ACCOUNT_NAME ACCOUNT_NAME
```
 