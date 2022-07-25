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

teritorid query staking validators -o json | \
jq .validators[] | \
jq -s 'sort_by(.tokens) | reverse' | \
jq -r '["Validator", "VP"], ["----------------", "------------"], (.[] | [.description.moniker, (.tokens|tonumber/1000000)]) | @tsv' | \
column -t -s "$(printf '\t')"