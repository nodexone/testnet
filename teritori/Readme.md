# Teritori Installation Guide
## Hardware Requirements
Like any Cosmos-SDK chain, the hardware requirements are pretty modest.

### Minimum Hardware Requirements
  - 3x CPU; the higher the clock speed the better
  - 4GB of RAM
  - 80GB Disk
  - Persistent Internet connection (traffic will be minimum 10Mbps during testnet - at least 100Mbps expected for production)

### Recommended Hardware Requirements
  - 4x CPU; the higher the clock speed the better
  - 8GB of RAM
  - 200 GB storage (SSD or NVME)
  - Persistent Internet connection (traffic will be minimum 10Mbps during testnet - at least 100Mbps expected for production)

Official documentation:
>- [Validator setup instructions](https://github.com/TERITORI/teritori-chain/blob/main/testnet/teritori-testnet-v2/README.md)

Explorer:
>- https://teritori.explorers.guru/

## Teritori Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Teritori fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O teritori.sh https://raw.githubusercontent.com/nodesxploit/testnet/main/teritori/teritori.sh && chmod +x teritori.sh && ./teritori.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
teritorid status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
teritorid keys add $TERITORI_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
teritorid keys add $TERITORI_WALLET --recover
```

To get the current wallet list:
```
teritorid keys list
```

### Save Wallet Information
Add Wallet Address:
```
TERITORI_WALLET_ADDRESS=$(teritorid keys show $TERITORI_WALLET -a)
TERITORI_VALOPER_ADDRESS=$(teritorid keys show $TERITORI_WALLET --bech val -a)
echo 'export TERITORI_WALLET_ADDRESS='${TERITORI_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export TERITORI_VALOPER_ADDRESS='${TERITORI_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 tori (1 tori equals 1000000 utori) and your node is in sync.

To check your wallet balance:
```
teritorid query bank balances $TERITORI_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
teritorid tx staking create-validator \
  --amount 1000000utori \
  --from $TERITORI_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(teritorid tendermint show-validator) \
  --moniker $TERITORI_NODENAME \
  --chain-id $TERITORI_ID \
  --fees 250utori
```



## Useful Commands Below

### Service Management
Check Logs:
```
journalctl -fu teritorid -o cat
```

Start Service:
```
systemctl start teritorid
```

Stop Service:
```
systemctl stop teritorid
```

Restart Service:
```
systemctl restart teritorid
```

### Node Information
Sync Information:
```
teritorid status 2>&1 | jq .SyncInfo
```

Validator Information:
```
teritorid status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
teritorid status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
teritorid tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
teritorid keys list
```

Recover wallet using Mnemonic:
```
teritorid keys add $TERITORI_WALLET --recover
```

Wallet Delete:
```
teritorid keys delete $TERITORI_WALLET
```

Show Wallet Balance:
```
teritorid query bank balances $TERITORI_WALLET_ADDRESS
```

Transfer Funds to other wallet:
```
teritorid tx bank send $TERITORI_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000utori
```

### Voting
```
teritorid tx gov vote 1 yes --from $TERITORI_WALLET --chain-id=$TERITORI_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
teritorid tx staking delegate $TERITORI_VALOPER_ADDRESS 10000000utori --from=$TERITORI_WALLET --chain-id=$TERITORI_ID --gas=auto --fees 250utori
```

Redelegate from validator to another validator:
```
teritorid tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000utori --from=$TERITORI_WALLET --chain-id=$TERITORI_ID --gas=auto --fees 250utori
```

Withdraw all rewards:
```
teritorid tx distribution withdraw-all-rewards --from=$TERITORI_WALLET --chain-id=$TERITORI_ID --gas=auto --fees 250utori
```

Withdraw rewards with commission:
```
teritorid tx distribution withdraw-rewards $TERITORI_VALOPER_ADDRESS --from=$TERITORI_WALLET --commission --chain-id=$TERITORI_ID
```

### Validator Management
Change Validator Name:
```
teritorid tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$TERITORI_ID \
--from=$TERITORI_WALLET
```

Get Out Of Jail(Unjail): 
```
teritorid tx slashing unjail \
  --broadcast-mode=block \
  --from=$TERITORI_WALLET \
  --chain-id=$TERITORI_ID \
  --gas=auto --fees 250utori
```

To Delete Node Completely:
```
sudo systemctl stop teritorid
sudo systemctl disable teritorid
sudo rm /etc/systemd/system/teritori* -rf
sudo rm $(which teritorid) -rf
sudo rm $HOME/.teritori* -rf
sudo rm $HOME/teritori-chain -rf
sed -i '/TERITORI_/d' ~/.bash_profile
```
  