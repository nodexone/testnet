<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<hr>


# Generate okp4d-nemeton testnet gentx

## Setting up vars
Here you have to put name of your moniker (validator) that will be visible in explorer
```
NODENAME=<YOUR_MONIKER_NAME_GOES_HERE>
```

Save and import variables into system
```
echo "export NODENAME=$NODENAME" >> $HOME/.bash_profile
echo "export WALLET=wallet" >> $HOME/.bash_profile
echo "export CHAIN_ID=okp4-nemeton" >> $HOME/.bash_profile
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
ver="1.19.2"
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
git clone https://github.com/okp4/okp4d.git
cd okp4d
make install
okp4d version
```

## Config app
```
okp4d config chain-id $CHAIN_ID
okp4d config keyring-backend test
```

## Init node
```
okp4d init $NODENAME --chain-id $CHAIN_ID
```

## Recover or create new wallet for testnet
Option 1 - generate new wallet
```
okp4d keys add $WALLET
```

Option 2 - recover existing wallet
```
okp4d keys add $WALLET --recover
```

## Add genesis account
```
WALLET_ADDRESS=$(okp4d keys show $WALLET -a)
okp4d add-genesis-account $WALLET_ADDRESS 1000000uknow
```

## Generate gentx

```
okp4d gentx $WALLET 1000000uknow \
  --chain-id $CHAIN_ID \
  --moniker=$NODENAME \
  --commission-max-change-rate=0.01 \
  --commission-max-rate=1.0 \
  --commission-rate=0.05 \
  --identity="" \
  --website="" \
  --details="" \
  --min-self-delegation "1"
```

## Things you have to backup
- `24 word mnemonic` of your generated wallet
- contents of `$HOME/.okp4d/config/*`

## Submit PR with Gentx
1. Copy the contents of ${HOME}/.okp4d/config/gentx/gentx-XXXXXXXX.json.
2. Fork https://github.com/okp4/networks
3. Create a file `gentx-<VALIDATOR_NAME>.json` under the `chains/nemeton/gentx/` folder in the forked repo, paste the copied text into the file.
4. Create a Pull Request to the main branch of the repository

### Await further instructions!