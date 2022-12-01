<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<hr>


<p align="center">
  <img height="300" height="auto" src="https://user-images.githubusercontent.com/38981255/198820722-9f95bc3c-2963-4bda-8886-33c6ce89b13b.PNG">
</p>

# Deinfra Testnet phase 1 - Manual Install

## Update package
```
sudo apt update && sudo apt upgrade -y
```

## Installing dependencies
```
sudo apt install curl build-essential git wget jq make gcc tmux -y
```

## Get IP Address
```
GET_IP=$(curl -s ifconfig.me)
echo "export GET_IP=${GET_IP}" >> $HOME/.bash_profile
```

## Install Docker
```
sudo apt update -y && sudo apt install apt-transport-https ca-certificates curl software-properties-common -y && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin && sudo apt install docker-compose
```

## Install docker image
```
docker run -d -p 44000:44000 --name tpnode thepowerio/tpnode
```

## Sign Ip
```
curl http://$GET_IP:44000/api/node/status | jq
```

