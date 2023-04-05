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

function animate {
  local pid=$!
  local delay=0.75
  local spinstr='|/-\'
  while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
    local temp=${spinstr#?}
    printf " [%c] " "$spinstr"
    local spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}

# Update package
echo "Updating package..."
sudo apt -q update > /dev/null 2>&1 &
animate

# Install curl, git, jq, lz4, build-essential
echo "Installing required packages..."
sudo apt -qy install curl git jq lz4 build-essential > /dev/null 2>&1 &
animate

# Upgrade packages
echo "Upgrading packages..."
sudo apt -qy upgrade > /dev/null 2>&1 &
animate

# Print a completion message
echo "Package setup complete!"

#Download binary
echo "Downloading binary..."
sudo mkdir -p /etc/apt/keyrings > /dev/null 2>&1
curl -fsSL repo.chainflip.io/keys/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/chainflip.gpg > /dev/null 2>&1 &
animate

# Verify keys
echo "Verifying the key's authenticity..."
gpg --show-keys /etc/apt/keyrings/chainflip.gpg

read -p "Do you want to continue? (y/n) " backup
    if [[ $backup == [Yy]* ]]; then
        echo "Great, you're all set!"
    else
        echo "Cancel!"
        exit 1
    fi

# Add chainflip repo's
sudo tee /etc/apt/sources.list.d/chainflip.list > /dev/null << EOF
deb [arch=amd64 signed-by=/etc/apt/keyrings/chainflip.gpg] https://repo.chainflip.io/perseverance/ focal main
EOF

# Installing chainflip package
echo "Installing chainflip engine...."
sudo apt install -y chainflip-cli chainflip-node chainflip-engine > /dev/null 2>&1
animate

# Make directory for keys
sudo mkdir /etc/chainflip/keys

# Input ethereum private keys
echo -n "Enter your Ethereum private key:"
read -s ETH_PRIVATE_KEY
echo ""
echo "$ETH_PRIVATE_KEY"
read -p "Is the private keys correct? (y/n) " choice
if [[ $choice == [Yy]* ]]; then
    echo -n "$ETH_PRIVATE_KEY" | sudo tee /etc/chainflip/keys/ethereum_key_file >/dev/null
    echo -e "\033[1m\033[31mPrivate key saved to /etc/chainflip/keys/ethereum_key_file\033[0m"
else
    echo "Installation cancelled!"
    exit 1
fi
sleep 1

# Generate sign keys
chainflip-node key generate
read -p "PLEASE BACKUP BEFORE PROCCEDING! (y/n) " backup
    if [[ $backup == [Yy]* ]]; then
        echo "Great, you're all set!"
    else
        echo "Make sure to backup the values before proceeding!"
        exit 1
    fi
sleep 1

# Load signing keys
echo -n "Enter your Seed: "
read -s SEED
echo ""
echo "$SEED"
read -p "Is the seed keys correct? (y/n) " choice
if [[ $choice == [Yy]* ]]; then
    echo -n "${SEED:2}" | sudo tee /etc/chainflip/keys/signing_key_file >/dev/null
else
    echo "Installation cancelled!"
    exit 1
fi
sleep 1

# Generate node key
sudo chainflip-node key generate-node-key --file /etc/chainflip/keys/node_key_file

# Show up the keys
read -p "Do you want to view your node key file? (y/n) " choice
if [[ $choice == [Yy]* ]]; then
    cat /etc/chainflip/keys/node_key_file
    echo ""
    echo "Make sure to Back Them Up & Copy Your Validator ID."
else
    echo "Okay, no problem. Remember to Back Them Up & Copy Your Validator ID anyway!"
fi

sleep 1

# Clean up cache
sudo chmod 600 /etc/chainflip/keys/ethereum_key_file
sudo chmod 600 /etc/chainflip/keys/signing_key_file
sudo chmod 600 /etc/chainflip/keys/node_key_file
history -c

sleep 1

# Create config engine
sudo mkdir -p /etc/chainflip/config
read -p "Pssst. You will need this account to retrieve the WSS and HTTPS endpoints!" answer
if [[ "$answer" == [yY] || "$answer" == [yY][eE][sS] ]]; then
  echo "Great! Let's continue."
else
  echo "Please create an account with a supported Ethereum client provider before continuing."
  exit 1
fi

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

echo -e "\033[0;35m=============================================================\033[0m"
echo -e "\033[0;35mCONGRATS! CHAINFLIP SETUP FINISHED\033[0m"
echo ""
echo -e "CHECK STATUS : \033[1m\033[35systemctl status chainflip-node\033[0m"
echo -e "CHECK RUNNING LOGS : \033[1m\033[35mtail -f /var/log/chainflip-node.log\033[0m"
echo -e "FURHTER INSTRUCTION CAN BE FOUND HERE :  \033[1m\033[35mhttps://docs.chainflip.io/perseverance-validator-documentation/validator-setup/installation-pt.-2#starting-the-node\033[0m"
echo -e "\033[0;35m=============================================================\033[0m"
