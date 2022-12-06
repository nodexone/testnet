<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/166676803-ee125d04-dfe2-4c92-8f0c-8af357aad691.png">
</p>

# Manual node setup for findora testnet
If you want to setup fullnode manually follow the steps below

## Update packages
```
sudo apt update -y
```

## Install dependencies
```
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
```

## Download docker
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

## Download docker repository
```
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
```

## Install docker
```
sudo apt install docker-ce -y
```

## Grant access
```
sudo usermod -aG docker <your moniker/usernmae>
```

## Configure Install
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

## Checking env
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

## Setup Binary
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

## Install fn App
wget https://wiki.findora.org/bin/linux/fn
chmod +x fn
sudo mv fn /usr/local/bin/


## Make Directories & Set Permissions
sudo mkdir -p /data/findora
sudo chown -R ${USERNAME}:${USERNAME} /data/findora/
mkdir -p /data/findora/${NAMESPACE}/tendermint/data
mkdir -p /data/findora/${NAMESPACE}/tendermint/config


## Checkexisting files
if [[ "Linux" == `uname -s` ]]; then
    set_binaries linux
elif [[ "Darwin" == `uname -s` ]]; then
    set_binaries macos
else
    echo "Unsupported system platform!"
    exit 1
fi


## Config App
node_mnemonic=$(cat ${keypath} | grep 'Mnemonic' | sed 's/^.*Mnemonic:[^ ]* //')
xfr_pubkey="$(cat ${keypath} | grep 'pub_key' | sed 's/[",]//g' | sed 's/ *pub_key: *//')"

echo $node_mnemonic > ${ROOT_DIR}/node.mnemonic || exit 1

$FN setup -S ${SERV_URL} || exit 1
$FN setup -K ${ROOT_DIR}/tendermint/config/priv_validator_key.json || exit 1
$FN setup -O ${ROOT_DIR}/node.mnemonic || exit 1

## clean old data and config files
sudo rm -rf ${ROOT_DIR}/findorad || exit 1
mkdir -p ${ROOT_DIR}/findorad || exit 1

docker run --rm -v ${ROOT_DIR}/tendermint:/root/.tendermint ${FINDORAD_IMG} init --${NAMESPACE} || exit 1

sudo chown -R ${USERNAME}:${USERNAME} ${ROOT_DIR}/tendermint/


## download latest link and get url
wget -O "${ROOT_DIR}/latest" "https://${ENV}-${NAMESPACE}-us-west-2-chain-data-backup.s3.us-west-2.amazonaws.com/latest"
CHAINDATA_URL=$(cut -d , -f 1 "${ROOT_DIR}/latest")
echo $CHAINDATA_URL


## remove old data 
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

## Checkpoint
rm -rf "${ROOT_DIR}/checkpoint.toml"
wget -O "${ROOT_DIR}/checkpoint.toml" "${CHECKPOINT_URL}"

## Create local node
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