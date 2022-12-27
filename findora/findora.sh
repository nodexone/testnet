#!/bin/bash

echo -e "\033[0;31m"
echo " ::::    :::  ::::::::  :::::::::  :::::::: ::::     :::: ";
echo " :+:+:   :+: :+:    :+: :+:    :+: :+:       :+:     :+:  ";
echo " :+:+:+  +:+ +:+    +:+ :+:    :+: +:+        +:+   +:+   ";
echo " +#+ +:+ +#+ +#+    +:+ +#+    +:+ +#++:++#      #+#      ";
echo " +#+  +#+#+# +#+    +#+ +#+    +:+ +#+        +#+   +#+   ";
echo " #+#   #+#+# #+#    #+# #+#    #+# #+#       #+#     #+#  ";
echo " ###    ####  ########  #########  ######## ###       ### ";
echo -e "\e[0m"

sleep 2


echo -e "\e[1m\e[32m1. Update & Install docker... \e[0m" && sleep 1
sudo apt update -y && sudo apt install apt-transport-https ca-certificates curl software-properties-common -y && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" && sudo apt install docker-ce -y && sudo usermod -aG docker findora1

echo -e "\e[1m\e[32m1. Configure Install... \e[0m" && sleep 1
USERNAME=$USER
ENV=prod
NAMESPACE=testnet
SERV_URL=https://${ENV}-${NAMESPACE}.${ENV}.findora.org
LIVE_VERSION=$(curl -s https://${ENV}-${NAMESPACE}.${ENV}.findora.org:8668/version | awk -F\  '{print $2}')
FINDORAD_IMG=findoranetwork/findorad:${LIVE_VERSION}
CHECKPOINT_URL=https://${ENV}-${NAMESPACE}-us-west-2-ec2-instance.s3.us-west-2.amazonaws.com/${NAMESPACE}/checkpoint
export ROOT_DIR=/data/findora/${NAMESPACE}
keypath=${ROOT_DIR}/${NAMESPACE}_node.key
FN=${ROOT_DIR}/bin/fn

echo -e "\e[1m\e[32m1. Checking env... \e[0m" && sleep 1
check_env() {
    for i in wget curl; do
        which $i >/dev/null 2>&1
        if [[ 0 -ne $? ]]; then
            echo -e "\n\033[31;01m${i}\033[00m has not been installed properly!\n"
            exit 1
        fi
    done

    if ! [ -f "$keypath" ]; then
        echo -e "No tmp.gen.keypair file detected, generating file and creating to ${NAMESPACE}_node.key"
        fn genkey > tmp.gen.keypair
        cp tmp.gen.keypair /data/findora/${NAMESPACE}/${NAMESPACE}_node.key
    fi
}

echo -e "\e[1m\e[32m1. Setup Binary... \e[0m" && sleep 1
set_binaries() {
    OS=$1
    docker pull ${FINDORAD_IMG} || exit 1
    wget -T 10 https://wiki.findora.org/bin/${OS}/fn || exit 1

    new_path=${ROOT_DIR}/bin

    rm -rf $new_path 2>/dev/null
    mkdir -p $new_path || exit 1
    mv fn $new_path || exit 1
    chmod -R +x ${new_path} || exit 1
}

echo -e "\e[1m\e[32m1. Install fn App... \e[0m" && sleep 1
# Install fn App
wget https://wiki.findora.org/bin/linux/fn
chmod +x fn
sudo mv fn /usr/local/bin/

echo -e "\e[1m\e[32m1. Set permission & directory... \e[0m" && sleep 1
# Make Directories & Set Permissions
sudo mkdir -p /data/findora
sudo chown -R ${USERNAME}:${USERNAME} /data/findora/
mkdir -p /data/findora/${NAMESPACE}/tendermint/data
mkdir -p /data/findora/${NAMESPACE}/tendermint/config

echo -e "\e[1m\e[32m1. Checking files... \e[0m" && sleep 1
# Checkexisting files
if [[ "Linux" == `uname -s` ]]; then
    set_binaries linux
# elif [[ "FreeBSD" == `uname -s` ]]; then
    # set_binaries freebsd
elif [[ "Darwin" == `uname -s` ]]; then
    set_binaries macos
else
    echo "Unsupported system platform!"
    exit 1
fi

echo -e "\e[1m\e[32m1. Config App... \e[0m" && sleep 1
# Config App
node_mnemonic=$(cat ${keypath} | grep 'Mnemonic' | sed 's/^.*Mnemonic:[^ ]* //')
xfr_pubkey="$(cat ${keypath} | grep 'pub_key' | sed 's/[",]//g' | sed 's/ *pub_key: *//')"

echo $node_mnemonic > ${ROOT_DIR}/node.mnemonic || exit 1

$FN setup -S ${SERV_URL} || exit 1
$FN setup -K ${ROOT_DIR}/tendermint/config/priv_validator_key.json || exit 1
$FN setup -O ${ROOT_DIR}/node.mnemonic || exit 1

echo -e "\e[1m\e[32m1. Clean old config... \e[0m" && sleep 1
# clean old data and config files
sudo rm -rf ${ROOT_DIR}/findorad || exit 1
mkdir -p ${ROOT_DIR}/findorad || exit 1

docker run --rm -v ${ROOT_DIR}/tendermint:/root/.tendermint ${FINDORAD_IMG} init --${NAMESPACE} || exit 1

sudo chown -R ${USERNAME}:${USERNAME} ${ROOT_DIR}/tendermint/

echo -e "\e[1m\e[32m1. Obtaining snapshot... \e[0m" && sleep 1
# download latest link and get url
wget -O "${ROOT_DIR}/latest" "https://${ENV}-${NAMESPACE}-us-west-2-chain-data-backup.s3.us-west-2.amazonaws.com/latest"
CHAINDATA_URL=$(cut -d , -f 1 "${ROOT_DIR}/latest")
echo $CHAINDATA_URL

echo -e "\e[1m\e[32m1. Remove old data... \e[0m" && sleep 1
# remove old data 
rm -rf "${ROOT_DIR}/findorad"
rm -rf "${ROOT_DIR}/tendermint/data"
rm -rf "${ROOT_DIR}/tendermint/config/addrbook.json"

wget -O "${ROOT_DIR}/snapshot" "${CHAINDATA_URL}" 
mkdir "${ROOT_DIR}/snapshot_data"
tar zxvf "${ROOT_DIR}/snapshot" -C "${ROOT_DIR}/snapshot_data"
sudo chown -R ${USERNAME}:${USERNAME} /data/findora/${NAMESPACE}/tendermint/data
sudo chown -R ${USERNAME}:${USERNAME} ${ROOT_DIR}/snapshot_data/
mv "${ROOT_DIR}/snapshot_data/data/ledger" "${ROOT_DIR}/findorad"
mv "${ROOT_DIR}/snapshot_data/data/tendermint/mainnet/node0/data" "${ROOT_DIR}/tendermint/data"

rm -rf ${ROOT_DIR}/snapshot_data

#Checkpoint
rm -rf "${ROOT_DIR}/checkpoint.toml"
wget -O "${ROOT_DIR}/checkpoint.toml" "${CHECKPOINT_URL}"

echo -e "\e[1m\e[32m1. Creating node... \e[0m" && sleep 1
# Create local node
docker stop findorad
docker rm findorad
docker run -d \
    -v ${ROOT_DIR}/tendermint:/root/.tendermint \
    -v ${ROOT_DIR}/findorad:/tmp/findora \
    -v ${ROOT_DIR}/checkpoint.toml:/root/checkpoint.toml \
    -p 8669:8669 \
    -p 8668:8668 \
    -p 8667:8667 \
    -p 8545:8545 \
    -p 26657:26657 \
    -e EVM_CHAIN_ID=2153 \
    --name findorad \
    ${FINDORAD_IMG} node \
    --ledger-dir /tmp/findora \
    --checkpoint-file=/root/checkpoint.toml \
    --tendermint-host 0.0.0.0 \
    --tendermint-node-key-config-path="/root/.tendermint/config/priv_validator_key.json" \
    --enable-query-service \
    --enable-eth-api-service

sleep 10

sleep 10

echo '=============== SETUP FINISHED ==================='
# Post Install Stats Report
curl 'http://localhost:26657/status'; echo
curl 'http://localhost:8669/version'; echo
curl 'http://localhost:8668/version'; echo
curl 'http://localhost:8667/version'; echo

echo "Local node initialized, please stake your FRA tokens after syncing is completed."