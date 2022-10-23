#!/bin/bash

echo -e "\033[0;35m"
echo " ::::    :::  ::::::::  :::::::::  :::::::: ::::     ::::  :::::::::: :::       ::::::::  ::: :::::::::::    ";
echo " :+:+:   :+: :+:    :+: :+:    :+: :+:       :+:     :+:   :+:    :+: :+:      :+:    :+: :+:     :+:        ";
echo " :+:+:+  +:+ +:+    +:+ :+:    :+: +:+        +:+   +:+    :+:    :+: +:+      +:+    +:+ +:+     +:+        ";
echo " +#+ +:+ +#+ +#+    +:+ +#+    +:+ +#++:++#      #+#       +#++:+:+:+ +#+      +#+    +:+ +#+     +#+        ";
echo " +#+  +#+#+# +#+    +#+ +#+    +:+ +#+        +#+   +#+    +#+        +#+      +#+    +#+ +#+     +#+        ";
echo " #+#   #+#+# #+#    #+# #+#    #+# #+#       #+#     #+#   #+#        #+#      #+#    #+# #+#     #+#        ";
echo " ###    ####  ########  #########  ######## ###       ###  ###        ########  ########  ###     ###        ";
echo -e "\e[0m"


GREEN_COLOR='\033[0;32m'
RED_COLOR='\033[0;31m'
NO_COLOR='\033[0m'
echo -e "$GREEN_COLOR Automatic request faucet NodeX $NO_COLOR\n"
for((;;)); do
            curl -d '{"address":"mande17685rk05kgngmxdacaqehyqf5pufqs6ysvemty"}' -H 'Content-Type: application/json' http://35.224.207.121:8080/request
echo "Success" sleep 1

done