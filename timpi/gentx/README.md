<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/bDUAwZhqBb" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://nodexcapital.com" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://timpi.io/wp-content/uploads/2023/01/Timpi-white.png">
</p>

# Gentx Creation for Timpi Chain

## Update system and install build tools
```
sudo apt -q update
sudo apt -qy install curl git jq lz4 build-essential
sudo apt -qy upgrade
```

## Install Go
```
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.20.4.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
```

## Download and install binaries
```
git clone https://github.com/Timpi-official/Timpi-ChainTN.git
cd Timpi-ChainTN
cd cmd/TimpiChain
go build
mv TimpiChain $HOME/go/bin/timpid
```

## Config app
```
timpid config chain-id TimpiChainTN
```

## Init node
Replace `<YOUR_MONIKER>` with your validator name
```
timpid init <YOUR_MONIKER> --chain-id TimpiChainTN
```

## Recover or create new wallet for testnet
Option 1 - generate new wallet
```
timpid keys add wallet
```

## Add genesis account
```
WALLET_ADDRESS=$(timpid keys show wallet -a)
timpid add-genesis-account $WALLET_ADDRESS 100000000utimpiTN
```

## Generate gentx
Replace `<YOUR_MONIKER>` with your validator name and fill up the rest of validator details like website, keybase id and contack email address.
```
timpid gentx wallet 1000000utimpiTN  \
--moniker="<YOUR_MONIKER>" \
--identity="<YOUR_KEYBASE_ID>" \
--website="<YOUR_WEBSITE>" \
--details="<YOUR_VALIDATOR_DETAILS>" \
--security-contact="<YOUR_CONTACT_EMAIL>" \
--chain-id TimpiChainTN \
--commission-max-change-rate=0.01 \
--commission-max-rate=0.20 \
--commission-rate=0.05 \
--min-self-delegation=1
```

## Things you have to backup
- `24 word mnemonic` of your generated wallet
- contents of `$HOME/.TimpiChain/config/*`

## Submit timpi gentx
1. Copy the contents of ${HOME}/.TimpiChain/config/gentx/gentx-XXXXXXXX.json.
2. Post the content of the gentx to [Timpi Discord](https://discord.com/channels/946982023245992006/1120589876631445616) with your wallet & your NodeID

### Await further instructions!
