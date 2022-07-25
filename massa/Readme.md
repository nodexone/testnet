### Minimum Hardware Requirements
  - 3x CPU; the higher the clock speed the better
  - 4GB of RAM
  - 100GB Disk
  
  
### Tips
   - You will reach maximum points when you run your node at home or in a location where other Massa nodes are not busy.
   - If you are using a shared server (VPS) internet usage may result in selling rolls.

## Automatic Installation with Single Script
You can set up your defund node in minutes using the automated script below.

```
wget -O Massa.sh https://raw.githubusercontent.com/nodesxploit/testnet/main/massa/massa.sh && chmod +x massa.sh && ./massa.sh
```

## Post-Installation Steps

Create screen
```
screen -S massa
```


Run Node. Set a password where it says `PASSWORD`.
```
cd massa/massa-node

RUST_BACKTRACE=full cargo run --release -- -p PASSWORD |& tee logs.txt
```


Create a new window in Screen.
```
CTRL + A + C 
```


Run the client. Set a password where it says `PASSWORD`.
```
cd massa/massa-client/

cargo run --release -- -p PASSWORD
```
*Logically, we run a node in one window and a client in the other window.*



Go to the window where the client is running and create the wallet. Save the keys given in the output.
```
wallet_generate_secret_key
```


Check wallet, back up wallet address and secret key.
```
wallet_info
```


Paste your wallet address in the testnet-faucet channel on the Massa discord server.
Check your balance. It should be `Final Balance 100`.
```
wallet_info
```


If everything is correct create a roll. edit 'walletaddress'
```
buy_rolls walletaddress 1 0
```


Add your node to the network. In the `secretkey` part, write the secretkey that we just backed up by typing wallet info.
```
node_add_staking_secret_keys secretkey

#sample
#node_add_staking_secret_keys qwoieq123981239asdasd
```


Join the Massa discord server. Click on the 👍 emoji in the testnet-rewards-registration channel or write something in the channel.
The bot will send you a private message, and you will get your discord id from this message.

![Nodeist](https://i.hizliresim.com/7w3sntd.png)



After learning the Discord id, come to the client screen of your node and run the code below.
Edit the 'walletaddress' and 'discordid' sections.

```
node_testnet_rewards_program_ownership_proof walletaddress discordid
```


You will receive a long code in response. copy this code and send it to massa bot who just sent you a private message on discord.
Then send the ip address of your server to the same massa bot.



Check your wallet after a few hours.
```
wallet_info
```

If there is an output like the picture below, you are ready.

![Nodeist](https://i.hizliresim.com/tc4s31r.png)



### Useful Commands
To exit the screen:
```
ctrl+a+d
```

To enter the screen:
```
screen -r massa
```

To navigate between the node and client windows on the screen:
```
ctrl+a+p

#Alternative ctrl+a+a
```

You disconnected from the server and reconnected. You want to enter the screen, but the screen already shows `Attached`.
In this case you need to `Detached` your server first. For this:
```
screen -d massa
```

Good Luck Bro!!
