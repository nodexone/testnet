
### Migrate your validator to another machine

### 1. Run a new full node on a new machine
To setup node you can follow guide [Haqq Full Node](https://github.com/nodesxploit/testnet/blob/main/haqq/README.md))

### 2. Confirm that you have the recovery seed phrase information for the active key running on the old machine

#### To backup your key
```
haqqd keys unsafe-export-eth-key validatorkey --keyring-backend file
```
> _This prints the private key

#### To get list of keys
```
haqqd keys list
```

### 3. Recover the active key of the old machine on the new machine

#### This can be done with the mnemonics
```
haqqd keys add wallet --recover
```

### 4. Wait for the new node on the new machine to finish catching-up

#### To check synchronization status
```
haqqd status 2>&1 | jq .SyncInfo
```
> _`catching_up` should be equal to `false`_

### 5. After the new node has caught-up, stop the validator node

> _To prevent double signing, you should stop the validator node before stopping the new full node to ensure the new node is at a greater block height than the validator node_
> _If the new node is behind the old validator node, then you may double-sign blocks_

#### Stop and disable service on OLD MACHINE
```
sudo systemctl stop haqqd
sudo systemctl disable haqqd
```
> _The validator should start missing blocks at this point_

### 6. Stop service on NEW MACHINE
```
sudo systemctl stop haqqd
```

### 7. Move the validator's private key from the old machine to the new machine
#### Private key is located in: `~/.haqqd/config/priv_validator_key.json`

> _After being copied, the key `priv_validator_key.json` should then be removed from the old node's config directory to prevent double-signing if the node were to start back up_
```
sudo mv ~/.haqqd/config/priv_validator_key.json ~/.haqqd/bak_priv_validator_key.json
```

### 8. Start service on a new validator node
```
sudo systemctl start haqqd
```
> _The new node should start signing blocks once caught-up_

### 9. Make sure your validator is not jailed
#### To unjail your validator
```
haqqd tx slashing unjail --from=wallet --chain-id=haqq_53211-1 --gas-prices=auto
```

### 10. After you ensure your validator is producing blocks and is healthy you can shutdown old validator server

