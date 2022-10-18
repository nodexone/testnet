#!/usr/bin/env bash

echo -e "\033[0;35m"
echo " ::::    :::  ::::::::  :::::::::  :::::::: ::::     ::::  :::::::::: :::       ::::::::  ::: :::::::::::    ";
echo " :+:+:   :+: :+:    :+: :+:    :+: :+:       :+:     :+:   :+:    :+: :+:      :+:    :+: :+:     :+:        ";
echo " :+:+:+  +:+ +:+    +:+ :+:    :+: +:+        +:+   +:+    :+:    :+: +:+      +:+    +:+ +:+     +:+        ";
echo " +#+ +:+ +#+ +#+    +:+ +#+    +:+ +#++:++#      #+#       +#++:+:+:+ +#+      +#+    +:+ +#+     +#+        ";
echo " +#+  +#+#+# +#+    +#+ +#+    +:+ +#+        +#+   +#+    +#+        +#+      +#+    +#+ +#+     +#+        ";
echo " #+#   #+#+# #+#    #+# #+#    #+# #+#       #+#     #+#   #+#        #+#      #+#    #+# #+#     #+#        ";
echo " ###    ####  ########  #########  ######## ###       ###  ###        ########  ########  ###     ###        ";
echo -e "\e[0m"

sleep 2

echo -e "\e[1m\e[32m1. Configure Install... \e[0m" && sleep 1
set -ex
ENV=prod
NAMESPACE=mainnet
LIVE_VERSION=$(curl -s https://${ENV}-${NAMESPACE}.${ENV}.findora.org:8668/version | awk -F\  '{print $2}')
FINDORAD_IMG=findoranetwork/findorad:${LIVE_VERSION}

export ROOT_DIR=/data/findora/${NAMESPACE}

echo -e "\e[1m\e[32m1. Remove Addrbook... \e[0m" && sleep 1
# remove the exist addrbook file
rm -rf "${ROOT_DIR}/tendermint/config/addrbook.json"

echo -e "\e[1m\e[32m1. Creating node... \e[0m" && sleep 1
# Run local node
docker stop findorad || exit 1
docker rm findorad || exit 1
rm -rf "${ROOT_DIR}/tendermint/config/addrbook.json"
docker run -d \
    -v ${ROOT_DIR}/tendermint:/root/.tendermint \
    -v ${ROOT_DIR}/findorad:/tmp/findora \
    -p 8669:8669 \
    -p 8668:8668 \
    -p 8667:8667 \
    -p 8545:8545 \
    -p 26657:26657 \
    -e EVM_CHAIN_ID=2152 \
    --name findorad \
    ${FINDORAD_IMG} node \
    --ledger-dir /tmp/findora \
    --tendermint-host 0.0.0.0 \
    --tendermint-node-key-config-path="/root/.tendermint/config/priv_validator_key.json" \
    --enable-query-service \
    --enable-eth-api-service

sleep 10

echo '=============== SETUP FINISHED ==================='
curl 'http://localhost:26657/status'; echo
curl 'http://localhost:8669/version'; echo
curl 'http://localhost:8668/version'; echo
curl 'http://localhost:8667/version'; echo

echo "Local node initialized, please stake your FRA tokens after syncing is completed."