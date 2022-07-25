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

wallet="wallet" # your wallet name
current_proposal=$(teritorid q gov proposals -o json | jq -r '.proposals[] | select(.status == "PROPOSAL_STATUS_VOTING_PERIOD") | .proposal_id' | tail -n 1)

echo "Last proposal is: $current_proposal"

while true
do
  last_proposal=$(teritorid q gov proposals -o json | jq -r '.proposals[] | select(.status == "PROPOSAL_STATUS_VOTING_PERIOD") | .proposal_id' | tail -n 1)

  if [[ $current_proposal -lt $last_proposal ]]
  then
    echo "New proposal: $last_proposal"
    echo "Voting NO..."
    teritorid tx gov vote $last_proposal no --from $wallet -y

    current_proposal=$last_proposal
  fi

  sleep 2
done