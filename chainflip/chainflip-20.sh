#!/bin/bash
#
# // Copyright (C) 2023 Chainflip Recoded By NodeX Capital
#

echo -e "\033[0;35m"
echo " ███╗   ██╗ ██████╗ ██████╗ ███████╗██╗  ██╗     ██████╗ █████╗ ██████╗ ██╗████████╗ █████╗ ██╗     ";
echo " ████╗  ██║██╔═══██╗██╔══██╗██╔════╝╚██╗██╔╝    ██╔════╝██╔══██╗██╔══██╗██║╚══██╔══╝██╔══██╗██║     ";
echo " ██╔██╗ ██║██║   ██║██║  ██║█████╗   ╚███╔╝     ██║     ███████║██████╔╝██║   ██║   ███████║██║     ";
echo " ██║╚██╗██║██║   ██║██║  ██║██╔══╝   ██╔██╗     ██║     ██╔══██║██╔═══╝ ██║   ██║   ██╔══██║██║     ";
echo " ██║ ╚████║╚██████╔╝██████╔╝███████╗██╔╝ ██╗    ╚██████╗██║  ██║██║     ██║   ██║   ██║  ██║███████╗";
echo " ╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝     ╚═════╝╚═╝  ╚═╝╚═╝     ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝";
echo ">>> Automatic Installer for Chainflip Ubuntu 20.04 <<<";
echo -e "\e[0m"

sleep 1

# Update package
sudo apt update && sudo apt upgrade -y

# Install curl
sudo apt install curl

#Download binary
sudo mkdir -p /etc/apt/keyrings
curl -fsSL repo.chainflip.io/keys/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/chainflip.gpg

# Verify keys
sudo gpg --show-keys /etc/apt/keyrings/chainflip.gpg

# Add chainflip repo's
sudo tee /etc/apt/sources.list.d/chainflip.list > /dev/null << EOF
deb [arch=amd64 signed-by=/etc/apt/keyrings/chainflip.gpg] https://repo.chainflip.io/perseverance/ focal main
EOF

# Installing chainflip package
sudo apt update
sudo apt install -y chainflip-cli chainflip-node chainflip-engine

# Make directory for keys
sudo mkdir -p /etc/chainflip/keys

# Input ethereum private key
if [ ! $PRIVATE_KEY ]; then
    echo ""
    echo "[!] EXAMPLE 9e7107efb0043b430e2cbffcf9xxxxxxxxxxxxxxxxx"
    echo "[!] PRIVATE KEY ON METAMASK"
    echo ""
	read -p "[ENTER YOUR PRIVATE KEY] > " PRIVATE_KEY
	echo 'export PRIVATE_KEY='$PRIVATE_KEY >> $HOME/.bash_profile
fi
    echo -n "$PRIVATE_KEY" >> /etc/chainflip/keys/ethereum_key_file
    echo ""
    echo "YOUR PRIVATE KEY   : $PRIVATE_KEY"
    echo ""

# Create Signing Keys
chainflip-node key generate >> sign_key.txt
echo "[!] YOUR SIGN KEY (BACKUP YOUR SIGN KEY)"
echo ""
cat sign_key.txt
echo ""
if [ ! $SECRET_SEED ]; then
    echo "[!] EXAMPLE 0x3f41c7492053246e899d55991xxxxxxxxxxxxxxxxx"
    echo "[!] SECRET SEED AS SHOWN YOUR SIGN KEY"
    echo ""
	read -p "[ENTER YOUR SECRET SEED] > " SECRET_SEED
	echo 'export SECRET_SEED='$SECRET_SEED >> $HOME/.bash_profile
fi
    echo -n "${SECRET_SEED:2}" | sudo tee /etc/chainflip/keys/signing_key_file
    echo ""
    echo "YOUR SECRET SEED   : $SECRET_SEED"
    echo ""

# Create Node Key
chainflip-node key generate-node-key --file /etc/chainflip/keys/node_key_file
echo "[!] YOUR NODE KEY (BACKUP YOUR NODE KEY)"
echo ""
cat /etc/chainflip/keys/node_key_file
echo ""

# Clean up cache
sudo chmod 600 /etc/chainflip/keys/ethereum_key_file
sudo chmod 600 /etc/chainflip/keys/signing_key_file
sudo chmod 600 /etc/chainflip/keys/node_key_file
history -c

# Create configuration chainflip
sudo mkdir -p /etc/chainflip/config
if [ ! $WSS ]; then
        read -p "[ENTER YOUR WSS ENDPOINTS] > " WSS
fi
if [ ! $HTTPS ]; then
        read -p "[ENTER YOUR HTTPS ENDPOINTS] > " HTTPS
fi

sudo tee /etc/chainflip/config/Settings.toml  > /dev/null << EOF
[node_p2p]
node_key_file = "/etc/chainflip/keys/node_key_file"
ip_address = "$(curl -s ifconfig.me)"
port = "8078"

[state_chain]
ws_endpoint = "ws://127.0.0.1:9944"
signing_key_file = "/etc/chainflip/keys/signing_key_file"

[eth]
# Ethereum RPC endpoints (websocket and http for redundancy).
ws_node_endpoint = "$WSS"
http_node_endpoint = "$HTTPS"

# Ethereum private key file path. This file should contain a hex-encoded private key.
private_key_file = "/etc/chainflip/keys/ethereum_key_file"

[signing]
db_file = "/etc/chainflip/data.db"

[dot]
ws_node_endpoint = "wss://pdot.chainflip.io:443"
EOF

# Create service 
sudo tee /etc/systemd/system/chainflip-node.service > /dev/null <<EOF
[Unit]
Description=Chainflip Validator Node

[Service]
Restart=always
RestartSec=30
Type=simple

ExecStart=/usr/bin/chainflip-node \
  --chain /etc/chainflip/chainspecs/perseverance.json \
  --base-path /etc/chainflip/chaindata \
  --node-key-file /etc/chainflip/keys/node_key_file \
  --validator \
  --state-cache-size 0 \
  --sync warp

StandardOutput=append:/var/log/chainflip-node.log
StandardError=append:/var/log/chainflip-node.log

[Install]
WantedBy=multi-user.target
EOF

# Start chainflip
sudo systemctl daemon-reload
sudo systemctl enable chainflip-node
sudo systemctl start chainflip-node

echo -e "\033[0;35m=============================================================\033[0m"
echo -e "\033[0;35mCONGRATS! CHAINFLIP SETUP FINISHED\033[0m"
echo ""
echo -e "CHECK STATUS CHAINFLIP: \033[1m\033[35msystemctl status chainflip-node\033[0m"
echo -e "CHECK CHAINFLIP LOGS : \033[1m\033[35mtail -f /var/log/chainflip-node.log\033[0m"
echo -e "FURHTER INSTRUCTION CAN BE FOUND HERE :  \033[1m\033[35mhttps://docs.chainflip.io\033[0m"
echo -e "\033[0;35m=============================================================\033[0m"

# End