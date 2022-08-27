
## Point Network Testnet Incentivized

## [Official Guide](https://github.com/pointnetwork/point-chain/blob/xnet-triton/VALIDATORS.md)
## [Try Point Network](https://pointnetwork.io/?i=366120433928)
## [Manual Install](https://github.com/elangrr/Point-Network/blob/main/Manual_install.md) , WARNING! The variable are different from official guide and this guide


## Set up your Point fullnode
### Option 1 (automatic)
```
wget -O point.sh https://raw.githubusercontent.com/nodesxploit/testnet/main/point/point.sh && chmod +x point.sh && ./point.sh
```

### Option 2 (manual)
You can follow [manual guide](https://github.com/nodesxploit/testnet/blob/main/point/manual_install.md) if you better prefer setting up node manually

## Post installation

When installation is finished please load variables into system
```
source $HOME/.bash_profile
```

Next you have to make sure your validator is syncing blocks. You can use command below to check synchronization status
```
evmosd status 2>&1 | jq .SyncInfo
```

### (OPTIONAL) State Sync
You can state sync your node in minutes by running commands below
```
N/A
```

### Create wallet
To create new wallet you can use command below. Don’t forget to save the mnemonic
```
evmosd keys add $WALLET
```
(OPTIONAL) To recover your wallet using seed phrase

```
evmosd keys add $WALLET --recover
```
To get current list of wallets
```
evmosd keys list
```

## Save wallet Info
```
EVMOSD_WALLET_ADDRESS=$(EVMOSD keys show $WALLET -a)
EVMOSD_VALOPER_ADDRESS=$(EVMOSD keys show $WALLET --bech val -a)
echo 'export POINT_WALLET_ADDRESS='${POINT_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export POINT_VALOPER_ADDRESS='${POINT_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```
## Fund your wallet
Fill the form with your funds wallet info , NOT VALIDATOR WALLET!!!
[FAUCET FORM](https://pointnetwork.io/testnet-form) , Usually the funds will be sent 24 Hour

## Sending your first transaction
### Add custom network
Now while you're waiting for the node to sync, you need to send funds to your validator address. As mentioned, you should have received an airdrop of 1024 XPOINT if you filled in the form. To see them, you can import the private key into a wallet like Metamask (not a good idea for mainnet security, but ok for testnet tokens).

Then you need to add XNet-Triton into Metamask:
```
Network Title: Point XNet Triton
RPC URL: https://xnet-triton-1.point.space/
Chain ID: 10721
SYMBOL: XPOINT
```
Add the wallet with your 1024 XPOINT
Remember the wallet you sent to us to be funded? In the form? It now has 1024 XPOINT.

Import the wallet with the private key into your wallet (e.g. Metamask), and you should see 1024 XPOINT there. But this is your fund wallet, not validator wallet.

### Find out which address is your validator wallet
Evmos has two wallet formats: Cosmos format, and Ethereum format. Cosmos format starts with evmos prefix, and Ethereum format starts with 0x. Most people don't need to know about Cosmos format, but validators should have a way to change from one to another.

Run 
```
evmosd keys list --keyring-backend file
```
you will see a list of keys attached to your node. Look at the one which has the name `validatorkey`, and note its address (it should be in Cosmos format and start with evmos prefix).

(In most cases it is not needed, but if something goes wrong and if you ever want to import your validator wallet in your Metamask you will need the private key. You can get it with this command: 
```
evmosd keys unsafe-export-eth-key validatorkey --keyring-backend file)
```

Use this tool to convert it to Ethereum format: https://evmos.me/utils/tools

This is your validator address in Ethereum format.

### Fund the validator
Finally, use the wallet to send however much you need from your fund address to the validator address (you can send all 1024 or choose a different strategy).

## Create Validator
Before creating validator please make sure you have the funds already in your wallet minimum 100 point
To check wallet balance :
```
evmosd query bank balances $EVMOSD_WALLET_ADDRESS
```
To create a validator with 1000point delegation use this command below :

```
evmosd tx staking create-validator \
--amount=1000000000000000000000apoint \
--pubkey=$(evmosd tendermint show-validator) \
--moniker=$NODENAME \
--chain-id=point_10721-1 \
--commission-rate="0.10" \
--commission-max-rate="0.20" \
--commission-max-change-rate="0.01" \
--min-self-delegation="1000000000000000000000" \
--gas="400000" \
--gas-prices="0.025apoint" \
--from=validatorkey \
--keyring-backend file
```

## Monitoring your validator

Check TX HASH ( Which <txhash> is your txhash from the transaction
```
evmosd query tx <txhash>
```
If the transaction was correct you should instantly become part of the validators set. Check your pubkey first:
```
evmosd tendermint show-validator
```
You will see a key there, you can identify your node among other validators using that key:
```
evmosd query tendermint-validator-set
```
There you will find more info like your VotingPower that should be bigger than 0. Also you can check your VotingPower by running:
```
evmosd status
```

## Security
To protect you keys please make sure you follow basic security rules

### Set up ssh keys for authentication
Good tutorial on how to set up ssh keys for authentication to your server can be found [here](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-20-04)

### Basic Firewall security
Start by checking the status of ufw.
```
sudo ufw status
```

Sets the default to allow outgoing connections, deny all incoming except ssh and 26656. Limit SSH login attempts
```
sudo ufw default allow outgoing
sudo ufw default deny incoming
sudo ufw allow ssh/tcp
sudo ufw limit ssh/tcp
sudo ufw allow ${STRIDE_PORT}656,${STRIDE_PORT}660/tcp
sudo ufw enable
```

## Useful Commands
Check Logs
```
journalctl -fu evmosd -o cat
```
Start Service
```
sudo systemctl start evmosd
```
Stop Service
```
sudo systemctl stop evmosd
```
Restart Service
```
sudo systemctl restart evmosd
```
## Node Information
Synchronization info
```
evmosd status 2>&1 | jq .SyncInfo
```
Validator Info
```
evmosd status 2>&1 | jq .ValidatorInfo
```
Node Info
```
evmosd status 2>&1 | jq .NodeInfo
```

## Staking, Delegation and Rewards
To delegate to your validator run this command :
 Note : Change <ammount> to your like , for example : 100000000000000000000apoint is 100point
```
evmosd tx staking delegate $(evmosd tendermint show-address) <ammount>apoint --chain-id=point_10721-1 --from=<evmosvaloper> --gas=400000 --gas-prices=0.025apoint 
```
Change `<evmosvaloper>` to your valoper address 
To check valoper address run this command :
```
evmosd debug addr <evmos address>
```
  
## Validator Management
Unjail Validator (MAKE SURE YOU ARE SYNCED WITH THE LASTEST BLOCK!!)
```
evmosd tx slashing unjail --from=<walletname> --chain-id=point_10721-1 --gas-prices=0.025apoint
```
Check if your validator is active: (if the output is non-empty, you are a validator)
```
evmosd query tendermint-validator-set | grep "$(evmosd tendermint show-address)"
```
See the slashing status: (if Jailed until year 1970 means you are not jailed!)
``` 
evmosd query slashing signing-info $(evmosd tendermint show-validator) 
```

## Delete node (do you own risk! backup private_key_validator.json first before delete)
```
sudo systemctl stop evmosd
sudo systemctl disable evmosd
sudo rm /etc/systemd/system/evmos* -rf
sudo rm $(which evmosd) -rf
sudo rm $HOME/.evmosd -rf
sudo rm $HOME/point-chain -rf
```
