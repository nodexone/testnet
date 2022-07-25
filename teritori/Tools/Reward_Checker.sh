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

set -e

wallet="wallet"

echo "Checking validator rewards..."

rewards=$(teritorid query distribution rewards $(teritorid keys show $wallet -a) -o json | jq '.total | to_entries' | jq -r ".[] | select(.value.denom == \"utori\") | .value.amount")
	if [[ -n "$rewards" ]]; then
		rewards_result=$(echo "$rewards / 1000000" | bc)
		
		echo "${rewards_result} tori / ${rewards} utori"
	else
		echo "No rewards"
	fi
	
	echo "Checking validator commission..."
	
	commission=$(teritorid query distribution commission $(teritorid keys show $wallet --bech val -a) -o json | jq '.commission | to_entries' | jq -r ".[] | select(.value.denom == \"utori\") | .value.amount")
		if [[ -n "$commission" ]]; then
			commission_quick=$(echo "$commission / 1000000" | bc)
			
			echo "${commission_quick} tori / ${commission} utori"
		else
			echo "No commissions"
		fi
