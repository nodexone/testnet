<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/169664551-39020c2e-fa95-483b-916b-c52ce4cb907c.png">
</p>

# Generate Gentx for Sei Incentivized testnet

## Setting up vars
Here you have to put name of your moniker (validator) that will be visible in explorer
```
NODENAME=<YOUR_MONIKER_NAME_GOES_HERE>
```

Save and import variables into system
```
echo "export NODENAME=$NODENAME" >> $HOME/.bash_profile
echo "export WALLET=wallet" >> $HOME/.bash_profile
echo "export CHAIN_ID=atlantic-1" >> $HOME/.bash_profile
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
git clone https://github.com/sei-protocol/sei-chain.git && cd $HOME/sei-chain
git checkout 1.0.6beta
make install
```

## Config app
```
seid config chain-id $CHAIN_ID
seid config keyring-backend test
```

## Init node
```
seid init $NODENAME --chain-id $CHAIN_ID
```

## Recover or create new wallet for Incentivized testnet
> ! If you are generating new wallet please don't forget to write down your 12-word mnemonic !

Option 1 - generate new wallet
```
seid keys add $WALLET
```

Option 2 - recover existing wallet
```
seid keys add $WALLET --recover
```

## Add genesis account
```
WALLET_ADDRESS=$(seid keys show $WALLET -a)
seid add-genesis-account $WALLET_ADDRESS 10000000usei
```

## Generate gentx
Please fill up `<your_validator_description>`, `<your_email>` and `<your_website>` with your own values
```
seid gentx $WALLET 10000000usei \
--chain-id $CHAIN_ID \
--moniker=$NODENAME \
--commission-max-change-rate=0.01 \
--commission-max-rate=0.20 \
--commission-rate=0.05 \
--details="<your_validator_description>" \
--security-contact="<your_email>" \
--website="<your_website>"
```

## Things you have to backup
- `12 word mnemonic` of your generated wallet
- contents of `$HOME/.sei/config/*`

## Submit PR with Gentx
1. Copy the contents of `$HOME/.sei/config/gentx/gentx-XXXXXXXX.json`
2. Fork https://github.com/sei-protocol/testnet
3. Create a file `gentx-{VALIDATOR_NAME}.json` under the `testnet/sei-incentivized-testnet/gentx` folder in the forked repo, paste the copied text into the file.
4. Create a Pull Request to the main branch of the repository

### Await further instructions!
