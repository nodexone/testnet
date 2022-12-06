<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/166676803-ee125d04-dfe2-4c92-8f0c-8af357aad691.png">
</p>

# Empower testnet node setup — altruistic-1

Official documentation:
>- [Validator setup instructions](https://github.com/obajay/nodes-Guides/tree/main/Empower)

Explorer:
>-  https://testnet.ping.pub/empower


## Hardware Requirements
Like any Cosmos-SDK chain, the hardware requirements are pretty modest.

### Minimum Hardware Requirements
 - 3x CPUs; the faster clock speed the better
 - 4GB RAM
 - 80GB Disk
 - Permanent Internet connection (traffic will be minimal during testnet; 10Mbps will be plenty - for production at least 100Mbps is expected)

### Recommended Hardware Requirements 
 - 4x CPUs; the faster clock speed the better
 - 8GB RAM
 - 200GB of storage (SSD or NVME)
 - Permanent Internet connection (traffic will be minimal during testnet; 10Mbps will be plenty - for production at least 100Mbps is expected)

## Set up your empower fullnode
### Option 1 (automatic)
You can setup your empower fullnode in few minutes by using automated script below. It will prompt you to input your validator node name!
```
wget -O empower.sh https://raw.githubusercontent.com/nodexcapital/testnet/main/empower/empower.sh && chmod +x empower.sh && ./empower.sh
```

### Option 2 (manual)
You can follow [manual guide](https://github.com/nodexcapital/testnet/blob/main/empower/manual_install.md) if you better prefer setting up node manually

## Post installation

When installation is finished please load variables into system
```
source $HOME/.bash_profile
```

Next you have to make sure your validator is syncing blocks. You can use command below to check synchronization status
```
empowerd status 2>&1 | jq .SyncInfo
```

### (OPTIONAL) State Sync
You can state sync your node in minutes by running commands below. Special thanks to `polkachu | polkachu.com#1249`
```
SNAP_RPC="https://empower-testnet-rpc.polkachu.com:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.empower/config/config.toml
empowerd unsafe-reset-all
systemctl restart empowerd && journalctl -fu empowerd -o cat
```

### Create wallet
To create new wallet you can use command below. Don’t forget to save the mnemonic
```
empowerd keys add $WALLET
```

(OPTIONAL) To recover your wallet using seed phrase
```
empowerd keys add $WALLET --recover
```

To get current list of wallets
```
empowerd keys list
```

### Save wallet info
Add wallet and valoper address and load variables into the system
```
EMPOWER_WALLET_ADDRESS=$(empowerd keys show $WALLET -a)
EMPOWER_VALOPER_ADDRESS=$(empowerd keys show $WALLET --bech val -a)
echo 'export EMPOWER_WALLET_ADDRESS='${EMPOWER_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export EMPOWER_VALOPER_ADDRESS='${EMPOWER_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

### Fund your wallet
In order to create validator first you need to fund your wallet with testnet tokens.
To top up your wallet join Empowerchain discord server and navigate to:
- **#faucet** for MPWR tokens

To request a faucet grant:
```
$request <YOUR_WALLET_ADDRESS> altruistic-1
```

### Create validator
Before creating validator please make sure that you have at least 1 mpwr (1 mpwr is equal to 1000000 umpwr) and your node is synchronized

To check your wallet balance:
```
empowerd query bank balances $EMPOWER_WALLET_ADDRESS
```
> If your wallet does not show any balance than probably your node is still syncing. Please wait until it finish to synchronize and then continue 

To create your validator run command below
```
empowerd tx staking create-validator \
  --amount 1000000umpwr \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(empowerd tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id $EMPOWER_CHAIN_ID
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
sudo ufw enable
```


## Usefull commands
### Service management
Check logs
```
journalctl -fu empowerd -o cat
```

Start service
```
sudo systemctl start empowerd
```

Stop service
```
sudo systemctl stop empowerd
```

Restart service
```
sudo systemctl restart empowerd
```

### Node info
Synchronization info
```
empowerd status 2>&1 | jq .SyncInfo
```

Validator info
```
empowerd status 2>&1 | jq .ValidatorInfo
```

Node info
```
empowerd status 2>&1 | jq .NodeInfo
```

Show node id
```
empowerd tendermint show-node-id
```

### Wallet operations
List of wallets
```
empowerd keys list
```

Recover wallet
```
empowerd keys add $WALLET --recover
```

Delete wallet
```
empowerd keys delete $WALLET
```

Get wallet balance
```
empowerd query bank balances $EMPOWER_WALLET_ADDRESS
```

Transfer funds
```
empowerd tx bank send $EMPOWER_WALLET_ADDRESS <TO_empower_WALLET_ADDRESS> 10000000umpwr
```

### Voting
```
empowerd tx gov vote 1 yes --from $WALLET --chain-id=$EMPOWER_CHAIN_ID
```

### Staking, Delegation and Rewards
Delegate stake
```
empowerd tx staking delegate $EMPOWER_VALOPER_ADDRESS 10000000umpwr --from=$WALLET --chain-id=$EMPOWER_CHAIN_ID --gas=auto
```

Redelegate stake from validator to another validator
```
empowerd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000umpwr --from=$WALLET --chain-id=$EMPOWER_CHAIN_ID --gas=auto
```

Withdraw all rewards
```
empowerd tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$EMPOWER_CHAIN_ID --gas=auto
```

Withdraw rewards with commision
```
empowerd tx distribution withdraw-rewards $EMPOWER_VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$EMPOWER_CHAIN_ID
```

### Validator management
Edit validator
```
empowerd tx staking edit-validator \
  --moniker=$NODENAME \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=$EMPOWER_CHAIN_ID \
  --from=$WALLET
```

Unjail validator
```
empowerd tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$EMPOWER_CHAIN_ID \
  --gas=auto
```

### Delete node
This commands will completely remove node from server. Use at your own risk!
```
sudo systemctl stop empowerd
sudo systemctl disable empowerd
sudo rm /etc/systemd/system/empower* -rf
sudo rm $(which empowerd) -rf
sudo rm $HOME/.empower* -rf
sudo rm $HOME/empower -rf
```
