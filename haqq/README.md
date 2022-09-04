![haqq](https://user-images.githubusercontent.com/44331529/185350224-62b92bc1-bd4e-4ce7-a56b-0abfc631c95c.png)

# Haqq Incentivized Testnet - Fullnode Guide
Official guide : https://docs.haqq.network/guides/validators/setup.html

Official Wesite : https://islamiccoin.net/

## Minimum Requirements
 - 4 or more physical CPU cores
 - At least 500GB of SSD disk storage
 - At least 32GB of memory (RAM)
 - At least 100mbps network bandwidth

## Option 1 (Automatic)
```
wget -O haqq.sh https://raw.githubusercontent.com/nodesxploit/testnet/main/haqq/haqq.sh && chmod +x haqq.sh && ./haqq.sh
```

### Option 2 (manual)
You can follow [manual guide](https://github.com/nodesxploit/testnet/blob/main/haqq/manual_install.md) if you better prefer setting up node manually

## Post Installation
```
source $HOME/.bash_profile
```

### Check info Sync
Note : You have to synced to the lastest block , check the sync status with this command
```
haqqd status 2>&1 | jq .SyncInfo
```

### State-Sync (Optional)
Sync your node in a minutes
```
SNAP_RPC=78.46.16.236:41657
peers="e15e1867f68011f80f2763e6691c89c923bf2f24@78.46.16.236:41656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.haqqd/config/config.toml

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 500)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.haqqd/config/config.toml
haqqd tendermint unsafe-reset-all --home $HOME/.haqqd
wget -O $HOME/.haqqd/config/addrbook.json "https://raw.githubusercontent.com/obajay/nodes-Guides/main/haqq/addrbook.json"
systemctl restart haqqd && journalctl -u haqqd -f -o cat
```

## Create Wallet
Create validator wallet using this command, Dont forget to save the Mnemonic!
```
haqqd keys add $WALLET --keyring-backend file
```
(OPTIONAL) To recover using your previous saved wallet
```
haqqd keys add $WALLET --recover
```
To get current list of wallet
```
haqqd keys list --keyring-backend file
```
To get private key of validator wallet (SAVE IT SOMEWHERE SAFE!)
```
haqqd keys unsafe-export-eth-key wallet --keyring-backend file
```
## Save wallet Info
```
HAQQD_WALLET_ADDRESS=$(haqqd keys show $WALLET -a)
```
Type your pharse password
```
HAQQD_VALOPER_ADDRESS=$(haqqd keys show $WALLET --bech val -a)
```
Type your pharse password
```
echo 'export HAQQD_WALLET_ADDRESS='${HAQQD_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export HAQQD_VALOPER_ADDRESS='${HAQQD_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```
## Fund your wallet
Connect your Metamask fund account and Your github account to get Testnet token
[FAUCET LINK](https://testedge.haqq.network/)
### FUND ACCOUNT AND VALIDATOR ACCOUNT ARE DIFFERENT!

## Sending your first transaction
After receiving faucet go Import your validator private key to Metamask , to see your validator Private key type `haqqd keys unsafe-export-eth-key wallet --keyring-backend file` , Import to Metamask then send the Faucet from your Fund wallet to your Validator wallet

### Fund the validator
Finally, use the wallet to send however much you need from your fund address to the validator address (you can send all 1024 or choose a different strategy).

## Create Validator
Before creating validator please make sure you have the funds already in your wallet minimum 100 point
To check wallet balance :
```
haqqd query bank balances $HAQQ_WALLET_ADDRESS
```
To create a validator with 1000point delegation use this command below :

```
haqqd tx staking create-validator \
--amount=1000000000000000000aISLM \
--from=wallet \
--commission-max-change-rate="0.10" \
--commission-max-rate="0.20" \
--commission-rate="0.10" \
--min-self-delegation="1" \
--identity=" " \
--details=" " \
--website=" " \
--pubkey=$(haqqd tendermint show-validator) \
--moniker=$NODENAME \
--chain-id=haqq_53211-1 \
-y
```
NOTE 1000000000000000000aISLM = 1ISLM

## Monitoring your validator

Check TX HASH ( Which <txhash> is your txhash from the transaction
```
haqqd query tx <txhash>
```
If the transaction was correct you should instantly become part of the validators set. Check your pubkey first:
```
haqqd tendermint show-validator
```
You will see a key there, you can identify your node among other validators using that key:
```
haqqd query tendermint-validator-set
```
There you will find more info like your VotingPower that should be bigger than 0. Also you can check your VotingPower by running:
```
haqqd status
```

## Migrate your validator
You can follow [Migrate Validator](https://github.com/nodesxploit/testnet/blob/main/haqq/migrate_validator.md) to migrate your node into another machine

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

## Usefull Commands
Check Logs
```
journalctl -fu haqqd -o cat
```
Start Service
```
sudo systemctl start haqqd
```
Stop Service
```
sudo systemctl stop haqqd
```
Restart Service
```
sudo systemctl restart haqqd
```
## Node Information
Synchronization info
```
haqqd status 2>&1 | jq .SyncInfo
```
Validator Info
```
haqqd status 2>&1 | jq .ValidatorInfo
```
Node Info
```
haqqd status 2>&1 | jq .NodeInfo
```

## Staking, Delegation, Withdraw
To delegate to your validator run this command :
 Note : Change <ammount> to your like , for example : 1000000000000000000aISLM is 1 ISLM
```
haqq tx staking delegate <haqq valoper> 1000000000000000000aISLM --from=wallet --chain-id=haqq_53211-1 --gas=auto
```
Change `<haqq valoper>` to your valoper address 

To Withdraw all rewards without commision
```
haqq tx distribution withdraw-all-rewards --from=wallet --chain-id haqq_53211-1 --gas-prices=auto
```
To Withdraw rewards with commision
```
haqqd tx distribution withdraw-rewards <haqq val> --from=wallet --commission --chain-id haqq_53211-1 --gas-prices=auto
```
NOTE: Change `<haqq val>` to your valoper address

To check valoper address run this command :
```
haqqd debug addr <haqq address>
```
  
## Validator Management
Unjail Validator (MAKE SURE YOU ARE SYNCED WITH THE LASTEST NODE , and have 1000 Point Delegation!!)
```
haqqd tx slashing unjail --from=wallet --chain-id=haqq_53211-1 --gas-prices=auto
```
Check if your validator is active: (if the output is non-empty, you are a validator)
```
haqqd query tendermint-validator-set | grep "$(haqqd tendermint show-address)"
```
See the slashing status: (if Jailed until year 1970 means you are not jailed!)
``` 
haqqd query slashing signing-info $(haqqd tendermint show-validator) 
```

##Delete node (do you own risk! backup private_key_validator.json first before delete)
```
sudo systemctl stop haqqd
sudo systemctl disable haqqd
sudo rm /etc/systemd/system/haqq* -rf
sudo rm $(which haqqd) -rf
sudo rm $HOME/.haqqd -rf
sudo rm $HOME/haqq -rf
```

  
