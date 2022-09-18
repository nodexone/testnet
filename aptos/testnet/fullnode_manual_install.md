<span tyle="font-size:14px" align="right">NodeX Official Accounts :
<span style="font-size:14px" align="right">
<a href="https://discord.gg/JqQNcwff2e" target="_blank">NodeX Capital Discord</a></span> ⭐ 
<span style="font-size:14px" align="right">
<a href="https://twitter.com/nodexploit/" target="_blank">Twitter</a></span> ⭐ 
<span style="font-size:14px" align="right">
<hr>

<p align="center">
  <img width="100" height="auto" src="https://user-images.githubusercontent.com/50621007/165930080-4f541b46-1ae3-461c-acc9-de72d7ab93b7.png">
</p>

# Fullnode installation is optional
If you want to install fullnode you have to do it on seperate server

## 1. Update packages
```
sudo apt update && sudo apt upgrade -y
```

## 2. Install docker
```
sudo apt-get install ca-certificates curl gnupg lsb-release -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
```

## 3. Install docker compose
```
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.6.1/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose
sudo chown $USER /var/run/docker.sock
```

## 4. Install fullnode node
### Create directory
```
mkdir ~/testnet && cd ~/testnet
```

### Download config files
```
wget -qO docker-compose.yaml https://raw.githubusercontent.com/aptos-labs/aptos-core/main/docker/compose/aptos-node/docker-compose-fullnode.yaml
wget -qO fullnode.yaml https://raw.githubusercontent.com/aptos-labs/aptos-core/main/docker/compose/aptos-node/fullnode.yaml
```

### Edit fullnode.yaml file to update the IP address for Validator node
Open fullnode.yaml file in nano editor
```
nano fullnode.yaml
```

Change `<Validator IP Address>` to your validator IP

![image](https://user-images.githubusercontent.com/50621007/176867030-599b91ef-f3c5-4097-a19f-c1acd58a1ae2.png)

Press `Ctrl + X` then press `Y` and `Enter` to save changes to file

### Copy the validator-full-node-identity.yaml, genesis.blob and waypoint.txt files from validator node into the same working directory on Fullnode machine

![image](https://user-images.githubusercontent.com/50621007/177649057-250e4b25-c0c4-44ec-9f10-bb80a46ffdac.png)

### Run docker compose
```
docker compose up -d
```

## 5. Connect to your validator node and update your validator config
Change `<YOUR_FULLNODE_IP>` to you fullnode public ip
```
aptos genesis set-validator-configuration \
    --keys-dir ~/$WORKSPACE --local-repository-dir ~/$WORKSPACE \
    --username $NODENAME \
    --validator-host $PUBLIC_IP:6180 \
    --full-node-host <YOUR_FULLNODE_IP>:6182
```

Restart docker compose
```
cd ~/$WORKSPACE
docker compose restart
```

## Useful commands
### Check fullnode node logs
```
docker logs -f testnet-fullnode-1 --tail 50
```

### Check sync status
```
curl 127.0.0.1:9101/metrics 2> /dev/null | grep aptos_state_sync_version | grep type
```

### Restart docker container
```
docker restart testnet-fullnode-1 
```
