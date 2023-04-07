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
echo ">>> Automatic Installer for Chainflip <<<";
echo -e "\e[0m"

sleep 1

# Update package
echo "Updating package..."
sudo apt update

# Install curl
echo "Installing required packages..."
sudo apt install curl

# Upgrade packages
echo "Upgrading packages..."
sudo apt upgrade

#Download binary
echo "Downloading binary..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL repo.chainflip.io/keys/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/chainflip.gpg

# Verify keys
echo "Verifying the key's authenticity..."
echo -e "\033[0;35m$(gpg --show-keys /etc/apt/keyrings/chainflip.gpg)\033[0m"

# Add chainflip repo's
sudo tee /etc/apt/sources.list.d/chainflip.list > /dev/null << EOF
deb [arch=amd64 signed-by=/etc/apt/keyrings/chainflip.gpg] https://repo.chainflip.io/perseverance/ focal main
EOF

# Installing chainflip package
echo "Installing chainflip engine...."
sudo apt install -y chainflip-cli chainflip-node chainflip-engine


# Make directory for keys
sudo mkdir /etc/chainflip/keys

# Input ethereum private key
echo -ne "Paste your ethereum private key and press [ENTER]: "
read -rs ETH_PRIVATE_KEY
echo -n "$ETH_PRIVATE_KEY" | sudo tee /etc/chainflip/keys/ethereum_key_file >/dev/null
echo -e "\033[0;35mPrivate key saved to /etc/chainflip/keys/ethereum_key_file\033[0m"

sleep 1

# Generate sign keys
echo -e "\033[0;35m$(chainflip-node key generate)\033[0m"
read -p "PLEASE BACKUP BEFORE PROCCEDING! (y/n) " backup
    if [[ $backup == [Yy]* ]]; then
        echo "Great, you're all set!"
    else
        echo "Make sure to backup the values before proceeding!"
        exit 1
    fi
sleep 1

# Load signing keys
echo -ne "Paste your seed key and press [ENTER]: "
read -rs SEED
echo ""
echo -e "\033[0;35m$SEED\033[0m"
read -p "Is the seed keys correct? (y/n) " choice
if [[ $choice == [Yy]* ]]; then
    echo -n "${SEED:2}" | sudo tee /etc/chainflip/keys/signing_key_file >/dev/null
else
    echo "Installation cancelled!"
    exit 1
fi
sleep 1

# Generate node key
echo -e "Generate node key...."
sudo chainflip-node key generate-node-key --file /etc/chainflip/keys/node_key_file | sed 's/.*/\o033[35m&\o033[0m/'

# Show up the keys
read -p "Do you want to view your node key file? (y/n) " choice
if [[ $choice == [Yy]* ]]; then
    echo -e "\033[0;35m$(cat /etc/chainflip/keys/node_key_file)\033[0m"
    echo "Make sure to backup & copy your validator ID."
else
    echo "Okay, no problem. Remember to backup & copy your validator ID anyway!"
fi

sleep 1

# Clean up cache
sudo chmod 600 /etc/chainflip/keys/ethereum_key_file
sudo chmod 600 /etc/chainflip/keys/signing_key_file
sudo chmod 600 /etc/chainflip/keys/node_key_file
history -c

sleep 1

# Create config engine
read -p "You will need an account to retrieve the WSS and HTTPS endpoints. Do you want to continue? (y/n) " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
  echo "Great! Let's continue."
else
  echo "Please create an account with a supported Ethereum client provider before continuing."
  exit 1
fi
sudo mkdir -p /etc/chainflip/config

sleep 2

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

# Start chainflip
sudo systemctl start chainflip-node

echo -e "\033[0;35m=============================================================\033[0m"
echo -e "\033[0;35mCONGRATS! CHAINFLIP SETUP FINISHED\033[0m"
echo ""
echo -e "CHECK STATUS CHAINFLIP: \033[1m\033[35msystemctl status chainflip-node\033[0m"
echo -e "CHECK CHAINFLIP LOGS : \033[1m\033[35mtail -f /var/log/chainflip-node.log\033[0m"
echo -e "FURHTER INSTRUCTION CAN BE FOUND HERE :  \033[1m\033[35mhttps://docs.chainflip.io\033[0m"
echo -e "\033[0;35m=============================================================\033[0m"
