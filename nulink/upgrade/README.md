<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<hr>

<p align="center">
 <img height="250" height="auto" src="https://user-images.githubusercontent.com/107190154/190568136-14f5a7d8-5b15-46fb-8132-4d38a0779171.gif">
</p>

# Nulink Update Guide

# Official Links
### [Official Document](https://docs.nulink.org/products/testnet)
### [Nulink Official Website](https://www.nulink.org/)
### [Nulink Official Telegram](https://t.me/NuLinkChannel)

## Minimum Requirements 
- 2-4vCPU
- 4GB of Ram
- 30GB SSD

# Pre-Update !!!
First run as Super user and open port
```
sudo su
sudo ufw enable
sudo ufw allow ssh
sudo ufw allow 9151
sudo ufw allow 9152
```
`NOTE : AZURE USER OPEN PORT IN THEIR PANEL !!!`

# There is 2 Case here so please choose your case accordingly!!!

## Case #1
## #1 My Staking account and worker account is available
### If you still have Staking account and worker account simply stop the docker

- Run `docker ps` to see currently running container
```
docker ps
```
- Then 
```
docker kill <containerID>
```
change `<containerID>` with container ID after you run `docker ps` to stop the node

### Then pull the latest nulink image
```
docker pull nulink/nulink:latest
```
  
### Relaunch the worker node
```
docker run --restart on-failure -d \
--name ursula \
-p 9151:9151 \
-v /root/nulink:/code \
-v /root/nulink:/home/circleci/.local/share/nulink \
-e NULINK_KEYSTORE_PASSWORD \
-e NULINK_OPERATOR_ETH_PASSWORD \
nulink/nulink nulink ursula run --no-block-until-read
```
Then everything is done ! You dont have to bond again

## Case #2
### Staking account or worker account is lost
Case #2 Is a little bit tricky since you have to switch port to 9152

If the staking account or the worker account is lost(this means either you can not login your staking account in Metamask or your keystore file in host directory is deleted), then the update procedure is a little bit complex. Here is the suggest way.

### Stop and remove the running node in Docker

- Run `docker ps` to see the containerID
```
docker ps
```
- Kill the running containerID
```
docker kill <containerID>
```
change `<containerID>` with container ID after you run `docker ps` to stop the node

- Remove the running docker node
```
docker rm ursula
```
### Pull latest nulink image
```
 docker pull nulink/nulink:latest
```

### delete the old host directory and create a new host directory 

```
cd /root
rm -rf nulink
```
- make new nulink folder
```
mkdir nulink
```
### Copy the keystore file of the Worker account to the host directory 
```
cp <keystore path> /root/nulink
```
change `<keystore path>` with the keystore path of your key `MY COMMAND EXAMPLE:`


`cp /root/geth-linux-amd64-1.10.24-972007a5/keystore/UTC--2022-09-17T05-27-00.315775527Z--b045627fd6c57577bba32192d8XXXXXXXX /root/nulink`

- Then give permission to `/root/nulink`
```
chmod -R 777 /root/nulink
```

### OPTIONAL !!!! (if you lost the old worker account, you could generate a new one using this simple command then copy the keystore file )
```
wget -O nulink.sh https://raw.githubusercontent.com/elangrr/testnet_guide/main/nulink/nulink.sh && chmod +x nulink.sh && ./nulink.sh
```
You will be asked to enter Keystore password , use simple and strong password that you can remember

### Set Variable
```
export NULINK_KEYSTORE_PASSWORD=<YOUR PASSWORD>


export NULINK_OPERATOR_ETH_PASSWORD=<YOUR PASSWORD>
```
change `<YOUR PASSWORD>` with password you entered earlier just so you can remember it .

### initialize Node Configuration with port 9152 since you lost your account and old url is always bonded
```
docker run -it --rm \
-p 9152:9152 \
-v /root/nulink:/code \
-v /root/nulink:/home/circleci/.local/share/nulink \
-e NULINK_KEYSTORE_PASSWORD \
nulink/nulink nulink ursula init \
--signer keystore:///code/<Path of the secret key file> \
--eth-provider https://data-seed-prebsc-2-s2.binance.org:8545  \
--network horus \
--payment-provider https://data-seed-prebsc-2-s2.binance.org:8545 \
--payment-network bsc_testnet \
--operator-address <YOUR PUBLIC ADDRESS> \
--max-gas-price 100
```
Change `<Path of the secret key file>` With the path of your keystore, Only Copy the name after UTC , `UTC--2022-09-17T05-27-00.315775527Z--b045627fd6c57577bba32192d8e47XXXXXXXX`

Change `<YOUR PUBLIC ADDRESS>` With your public address generated after you Use Auto install script

`MY COMMAND EXCAMPLE!`
```
docker run -it --rm \
-p 9152:9152 \
-v /root/nulink:/code \
-v /root/nulink:/home/circleci/.local/share/nulink \
-e NULINK_KEYSTORE_PASSWORD \
nulink/nulink nulink ursula init \
--signer keystore:///code/UTC--2022-09-17T05-27-00.315775527Z--XXXXXXXXXXXXXXXX \
--eth-provider https://data-seed-prebsc-2-s2.binance.org:8545  \
--network horus \
--payment-provider https://data-seed-prebsc-2-s2.binance.org:8545 \
--payment-network bsc_testnet \
--operator-address 0xB045627Fd6c57577Bba32192d8EXXXXXXXXXXXXXXX \
--max-gas-price 100
```
### Launch the node with new configuration
```
docker run --restart on-failure -d \
--name ursula \
-p 9152:9152 \
-v /root/nulink:/code \
-v /root/nulink:/home/circleci/.local/share/nulink \
-e NULINK_KEYSTORE_PASSWORD \
-e NULINK_OPERATOR_ETH_PASSWORD \
nulink/nulink nulink ursula run \
--rest-port 9152 \
--config-file /home/circleci/.local/share/nulink/ursula.json \
 --no-block-until-ready
```
### Check logs 
To check logs we can use screen to constantly look at the log
```
apt install screen
```
``` 
screen -S log
```
```
docker logs -f ursula
```
Output : 
![image](https://user-images.githubusercontent.com/34649601/190843374-510026ec-7996-483f-a7a1-a42ed800cd82.png)
After that your job to run node is complete now lets go to the next step.

### Bond your worker 
 Scroll down and click `Bond Worker`
![image](https://user-images.githubusercontent.com/34649601/190844089-ab76c8e4-d0f5-4269-958d-7c368347ecea.png)
 Fill the form (PICTURE ONLY EXAMPLE )
- `Worker Adress` Should be your public address
- `Node Url` Should be `https://IP:9152/` for Example `https://123.45.67.890:9152/` ( Make sure to Copy everything ! dont miss any `/` Or else you will get an error Node Offline)
- Click Bond and Approve Transaction in your Metamask

# Final Words
After that your node will appear `Online`, if it still appear to be `Offline` Do not worry it will be `Online` Soon.
## [FEEDBACK FORM (MUST!!)](https://docs.google.com/forms/d/e/1FAIpQLSep0rgPRcMd2kUhz53GYmBoktu-u-8npU2DakmzGpmpCmYZPw/viewform)
Submit feedback regarding to bugs or improvements for nulink services !

If you did not submit form you won't be eligible!

Only good submission on feedback form will get rewards

Thats it! You are done and make sure your node is not shutdown!!