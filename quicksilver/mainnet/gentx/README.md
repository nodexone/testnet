<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/166148846-93575afe-e3ce-4ca5-a3f7-a21e8a8609cb.png">
</p>

# Generate quicksilver mainnet Gentx

## Setting up vars
Here you have to put name of your moniker (validator) that will be visible in explorer
```
NODENAME=<YOUR_MONIKER_NAME_GOES_HERE>
```

Save and import variables into system
```
echo "export NODENAME=$NODENAME" >> $HOME/.bash_profile
echo "export WALLET=wallet" >> $HOME/.bash_profile
echo "export CHAIN_ID=quicksilver-1" >> $HOME/.bash_profile
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
git clone https://github.com/ingenuity-build/quicksilver && cd quicksilver
git fetch origin --tags
git checkout v1.0.0
make install
```

## Config app
```
quicksilverd config chain-id $CHAIN_ID
quicksilverd config keyring-backend test
```

## Init node
```
quicksilverd init $NODENAME --chain-id $CHAIN_ID
```

## Recover or create new wallet for mainnet
Option 1 - generate new wallet
```
quicksilverd keys add $WALLET
```

Option 2 - recover existing wallet
```
quicksilverd keys add $WALLET --recover
```

## Add genesis account
```
WALLET_ADDRESS=$(quicksilverd keys show $WALLET -a)
quicksilverd add-genesis-account $WALLET_ADDRESS 51000000uqck
```

## Generate gentx
```
quicksilverd gentx $WALLET 50000000uqck \
--chain-id $CHAIN_ID \
--moniker=$NODENAME \
--commission-max-change-rate=0.01 \
--commission-max-rate=0.20 \
--commission-rate=0.05 \
--identity=1C5ACD2EEF363C3A \
--website="http://kjnodes.com" \
--details="Providing professional staking services with high performance and availability"
```

## Things you have to backup
- `12 word mnemonic` of your generated wallet
- contents of `$HOME/.quicksilver/config/*`

## Submit PR with Gentx
1. Copy the contents of ${HOME}/.quicksilverd/config/gentx/gentx-XXXXXXXX.json.
2. Fork https://github.com/ingenuity-build/mainnet
3. Create a file <VALIDATOR_NAME>.json under the `gentxs` folder in the forked repo, paste the copied text into the file.
4. Create a Pull Request to the main branch of the repository

### Await further instructions!