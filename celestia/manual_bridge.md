<span tyle="font-size:14px" align="right">NodeX Official Accounts :
<span style="font-size:14px" align="right">
<a href="https://discord.gg/JqQNcwff2e" target="_blank">NodeX Capital Discord</a></span> ⭐ 
<span style="font-size:14px" align="right">
<a href="https://twitter.com/nodexploit/" target="_blank">Twitter</a></span> ⭐ 
<span style="font-size:14px" align="right">
<hr>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/170463282-576375f8-fa1e-4fce-8350-6312b415b50d.png">
</p>

# Install Bridge node
To setup bridge node follow the steps below

## Hardware requirements
The following hardware minimum requirements are recommended for running the bridge node:
- Memory: 8 GB RAM
- CPU: Quad-Core
- Disk: 250 GB SSD Storage
- Bandwidth: 1 Gbps for Download/100 Mbps for Upload

## Update packages
```
sudo apt update && sudo apt upgrade -y
```

## Install dependencies
```
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu -y
```

## Install go
```
ver="1.18.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
```

## Install Celestia Node
```
cd $HOME
rm -rf celestia-node
git clone https://github.com/celestiaorg/celestia-node.git
cd celestia-node/
make install
```

## Initialize bridge node
```
celestia bridge init --core.remote tcp://<validator_node_ip>:26657 --core.grpc tcp://<validator_node_ip>:9090
```

## Create bridge service
```
tee /etc/systemd/system/celestia-bridge.service > /dev/null <<EOF
[Unit]
Description=celestia-bridge Cosmos daemon
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$HOME/go/bin/celestia bridge start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```

## Register and start bridge service
```
sudo systemctl daemon-reload
sudo systemctl enable celestia-bridge
sudo systemctl restart celestia-bridge
```
