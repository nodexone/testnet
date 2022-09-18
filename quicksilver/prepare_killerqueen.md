<span tyle="font-size:14px" align="right">NodeX Official Accounts :
<span style="font-size:14px" align="right">
<a href="https://discord.gg/JqQNcwff2e" target="_blank">NodeX Capital Discord</a></span> ⭐ 
<span style="font-size:14px" align="right">
<a href="https://twitter.com/nodexploit/" target="_blank">Twitter</a></span> ⭐ 
<span style="font-size:14px" align="right">
<hr>


<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/166148846-93575afe-e3ce-4ca5-a3f7-a21e8a8609cb.png">
</p>

# Quicksilver node setup for Testnet — killerqueen-1

#### Quicksilver `killerqueen-1` network will start @ 09:00 UTC on Thursday 23rd June.

First of all please lookup for your submitted gentx data in [genesis file](https://raw.githubusercontent.com/ingenuity-build/testnets/main/killerqueen/genesis.json)
![image](https://user-images.githubusercontent.com/50621007/175129276-9705a6fc-c6ec-4c1e-8944-d1fd0b84732d.png)

If you have found your validator address in genesis, congratulations, you have been selected as genesis validator for `killerqueen-1` testnet and you will receive `100 QCK` tokens at the chain start.

Folks who did not submit a gentx, will be able to call the faucet once. This will give them a decent amount of tokens and will be able to get in the set easily if any genesis validators fail to start.

The first task will involved being up immediately after genesis. Every block missed in the first 100 blocks will reduce the points you can earn for this task so make sure your nodes are set up and ready to rock

## What should I do next?

Please follow the instructions to prepare your validator before 09:00 UTC on Thursday 23rd June
1) Install fresh Ubuntu 20.04 server
2) Use our [guide](https://github.com/nodesxploit/testnet/tree/main/quicksilver) to setup your quicksilver fullnode 
3) Recover your wallet (24-word mnemonic phrase) that we used to create `gentx`
```
quicksilverd keys add $WALLET --recover
```
4) Copy your `priv_validator_key.json` that we used to create `gentx` into `.quicksilverd/config/` directory
5) Restart quicksilver service
```
sudo systemctl restart quicksilverd
```
6) Check service logs
```
journalctl -u quicksilverd -o cat
```
7) You should see output `This node is a validator addr=XXXXXXXXX module=consensus pubKey=XXXXXXXXX`
8) Also output should show that node is waiting for genesis time `Genesis time is in the future. Sleeping until then... genTime=2022-06-23T09:00:00Z`

![image](https://user-images.githubusercontent.com/50621007/175128488-f7981ef5-98fb-4b0d-bfc0-8135a05a847b.png)

If you see this output your node is ready and should start signing blocks when genesis time will ocure.