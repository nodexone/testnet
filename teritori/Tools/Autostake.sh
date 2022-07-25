#!/bin/bash
echo "=========================================="
echo -e "\033[0;35m"
echo "       ::::    :::  ::::::::  :::::::::  :::::::: ::::     ::::  ";
echo "      :+:+:   :+: :+:    :+: :+:    :+: :+:       :+:     :+:    ";
echo "     :+:+:+  +:+ +:+    +:+ +:+    +:+ +:+        +:+   +:+      ";
echo "    +#+ +:+ +#+ +#+    +:+ +#+    +:+ +#++:++#      #+#          ";
echo "   +#+  +#+#+# +#+    +#+ +#+    +#+ +#+        +#+   +#+        ";
echo "  #+#   #+#+# #+#    #+# #+#    #+# #+#       #+#     #+#        ";
echo " ###    ####  ########  #########  ######## ###        ###       ";
echo -e "\e[0m"
echo "=========================================="                                     


sleep 2

############ SET PROPERTIES #########

ADDRESS="walletadress"
VALIDATOR="valoperadress"
KEY_NAME="walletname"
PASS="walletpass"
CHAIN_ID="chainid"
GAS_VALUE="auto"
#FEE_VALUE=""

############ AUTO DELEGATION #########

# Withdraw
while :
do
	echo $PASS | teritorid tx distribution withdraw-rewards "${VALIDATOR}"  --from "${KEY_NAME}" --commission --chain-id=${CHAIN_ID} --gas="${GAS_VALUE}" -y
	
	sleep 20s
	
	AVAILABLE_COIN=$(teritorid query bank balances ${ADDRESS} --output json | jq -r '.balances | map(select(.denom == "utori")) | .[].amount' | tr -cd [:digit:])
	KEEP_FOR_FEES=100000
	AMOUNT=$(($AVAILABLE_COIN - $KEEP_FOR_FEES))
	AMOUNT_FINAL=$AMOUNT"utori"
	
	
	# Delegate
	echo $PASS | teritorid tx staking delegate "${VALIDATOR}" "${AMOUNT_FINAL}" --from "${KEY_NAME}" --chain-id=${CHAIN_ID} -y
	date
	sleep 90s
done;
