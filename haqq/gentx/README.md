<strong><p style="font-size:14px" align="left">Founder :
<a href="https://discord.gg/JqQNcwff2e" target="_blank">NodeX Capital Discord</a></p></strong>
<strong><p style="font-size:14px" align="left">Visit Our Website : 
<a href="https://nodex.codes/" target="_blank">https://nodex.codes</a></p></strong>
<strong><p style="font-size:14px" align="left">Follow Me :
<a href="https://twitter.com/nodexploit/" target="_blank">NodeX Twitter</a></p></strong>
<strong><p style="font-size:14px" align="left">Motto :
<a>I want to be a useful person in the community✨</a></p></strong>
<hr>

![haqq](https://user-images.githubusercontent.com/104348282/188024190-b43f56d0-2dc6-4e4a-be0e-a7e9f615f751.png)

# Generate Haqq Incentivized Testnet Gentx

### Update Package and Install depencies
```
sudo apt update && sudo apt upgrade -y && \
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

### Install Go 1.18.3 ( One Command )
```
ver="1.18.3"
  cd $HOME
  wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
  rm "go$ver.linux-amd64.tar.gz"
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
  source ~/.bash_profile
  ```
### Install Binary (One Command)
```
cd $HOME && git clone https://github.com/haqq-network/haqq && \
cd haqq && \
make install && \
haqqd version
```

### Init Moniker and Chain ID
```
haqqd init <MONIKER> --chain-id haqq_54211-2 && \
haqqd config chain-id haqq_54211-2
```
Change `<MONIKER>` Whatever you want

### Recover or create new wallet for mainnet
Option 1 - generate new wallet
```
haqqd keys add wallet
```
Option 2 - recover existing wallet
```
haqqd keys add wallet --recover

```

### Add Genesis Account
```
haqqd add-genesis-account wallet 10000000000000000000aISLM
```

### Create Gentx (One Command)
```
haqqd gentx YOURWALLETNAME 10000000000000000000aISLM \
--chain-id=haqq_54211-2 \
--moniker="<YOURMONIKER>" \
--commission-max-change-rate 0.05 \
--commission-max-rate 0.20 \
--commission-rate 0.05 \
--website="" \
--security-contact="" \
--identity="" \
--details=""
```

After Submit command you will have Gentx on `/.haqqd/config/gentx/gentx-xxx.json`

# Submit PR with Gentx
1. Copy the Content on `/.haqqd/config/gentx/gentx-xxx.json`
2. Go to [Validator-Contest Github](https://github.com/haqq-network/validators-contest) and Fork the Repository
3. After fork Create new file under `gentx` folder on forked repo with name `gentx-<moniker>.json` and paste the Copied test into the file
4. Create a Pull Request to the main branch of the repository

# Register to Crew3
1. Go to [Crew3 Haqq](https://haqq-val-contest.crew3.xyz/)
2. Login with Discord Account
3. Submit Gentx PR Link in the quest

## DONT FORGET TO BACKUP MNEMONICS!!
## Wait for Further Instructions
