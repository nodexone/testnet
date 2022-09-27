<strong><p style="font-size:14px" align="left">Founder :
<a href="https://discord.gg/JqQNcwff2e" target="_blank">NodeX Capital Discord</a></p></strong>
<strong><p style="font-size:14px" align="left">Visit Our Website : 
<a href="https://nodex.codes/" target="_blank">https://nodex.codes</a></p></strong>
<strong><p style="font-size:14px" align="left">Follow Me :
<a href="https://twitter.com/nodexploit/" target="_blank">NodeX Twitter</a></p></strong>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/179568169-a81fb8a8-12d2-4865-aa91-3dba7649d54e.png">
</p>

# Generate teritori mainnet gentx

## Setting up vars
Here you have to put name of your moniker (validator) that will be visible in explorer
```
NODENAME=<YOUR_MONIKER_NAME_GOES_HERE>
```

Save and import variables into system
```
echo "export NODENAME=$NODENAME" >> $HOME/.bash_profile
echo "export WALLET=wallet" >> $HOME/.bash_profile
echo "export CHAIN_ID=teritori-1" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

## Update packages
```
sudo apt update && sudo apt upgrade -y
```

## Install dependencies
```
sudo apt-get install make build-essential gcc git jq chrony -y
```

## Install go
```
ver="1.18.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
```

## Download and install binaries
```
cd $HOME
git clone https://github.com/TERITORI/teritori-chain
cd teritori-chain
git checkout mainnet
make install
```

## Config app
```
teritorid config chain-id $CHAIN_ID
teritorid config keyring-backend test
```

## Init node
```
teritorid init $NODENAME --chain-id $CHAIN_ID
```

## Recover or create new wallet for mainnet
Option 1 - generate new wallet
```
teritorid keys add $WALLET
```

Option 2 - recover existing wallet
```
teritorid keys add $WALLET --recover
```

## Add genesis account
```
WALLET_ADDRESS=$(teritorid keys show $WALLET -a)
teritorid add-genesis-account $WALLET_ADDRESS 10000000utori
```

## Generate gentx
```
teritorid gentx $WALLET 10000000utori \
--moniker=$NODENAME \
--min-self-delegation="1000000" \
--commission-max-change-rate=0.01 \
--commission-max-rate=1.0 \
--commission-rate=0.05 \
--website="" \
--identity= \
--security-contact="" \
--details="" \
--chain-id $CHAIN_ID
```

## Things you have to backup
- `24 word mnemonic` of your generated wallet
- contents of `$HOME/.teritorid/config/*`

## Submit PR with Gentx
1. Copy the contents of ${HOME}/.teritorid/config/gentx/gentx-XXXXXXXX.json.
2. Fork https://github.com/TERITORI/teritori-mainnet-genesis
3. Create a file `<VALIDATOR_NAME>.json` under the `mainnet/teritori-1/gentx/` folder in the forked repo, paste the copied text into the file.
4. Create a Pull Request to the main branch of the repository

### Await further instructions!
