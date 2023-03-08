<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://polkachu.com/images/chains/ojo.png">
</p>

# Ojo Testnet | Chain ID : ojo-devnet | Custom Port : 246

### Community Documentation :
>- [Validator Setup Instructions](https://polkachu.com/testnets/ojo)

### Explorer:
>-  https://explorer.nodexcapital.com/ojo

### Ojo Price Feeder Automatic Installer
You can setup your Ojo Price Feeder in few minutes by using automated script below.
```
wget -O ojopf.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/ojonetwork/price-feeder/ojopf.sh && chmod +x ojopf.sh && ./ojopf.sh
```

### Ojo Price Feeder Add Wallet
```
ojod keys add $OJO_PF_WALLET --keyring-backend os
```
### Ojo Price Feeder Show Wallet
```
OJO_PF_ADDRESS=$(echo -e $OJO_PF_PASS | ojod keys show $OJO_PF_WALLET --keyring-backend os -a)
```