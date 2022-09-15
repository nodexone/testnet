#!/bin/bash
exists()
{
  command -v "$1" >/dev/null 2>&1
}

service_exists() {
    local n=$1
    if [[ $(systemctl list-units --all -t service --full --no-legend "$n.service" | sed 's/^\s*//g' | cut -f1 -d' ') == $n.service ]]; then
        return 0
    else
        return 1
    fi
}

if exists curl; then
	echo ''
else
  sudo apt install curl -y < "/dev/null"
fi
bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    . $HOME/.bash_profile
fi
sleep 1 
echo -e "\033[0;35m"
echo "       ::::    :::  ::::::::  :::::::::  :::::::: ::::     ::::  ";
echo "      :+:+:   :+: :+:    :+: :+:    :+: :+:       :+:     :+:    ";
echo "     :+:+:+  +:+ +:+    +:+ +:+    +:+ +:+        +:+   +:+      ";
echo "    +#+ +:+ +#+ +#+    +:+ +#+    +:+ +#++:++#      #+#          ";
echo "   +#+  +#+#+# +#+    +#+ +#+    +#+ +#+        +#+   +#+        ";
echo "  #+#   #+#+# #+#    #+# #+#    #+# #+#       #+#     #+#        ";
echo " ###    ####  ########  #########  ######## ###        ###       ";
echo -e "\e[0m"
sleep 3

function setupVars {
	if [ ! $IRONFISH_WALLET ]; then
		read -p "Enter wallet name: " IRONFISH_WALLET
		echo 'export IRONFISH_WALLET='${IRONFISH_WALLET} >> $HOME/.bash_profile
	fi
	echo -e '\n\e[42mYour wallet name:' $IRONFISH_WALLET '\e[0m\n'
	if [ ! $IRONFISH_NODENAME ]; then
		read -p "Enter node name: " IRONFISH_NODENAME
		echo 'export IRONFISH_NODENAME='${IRONFISH_NODENAME} >> $HOME/.bash_profile
	fi
	echo -e '\n\e[42mYour node name:' $IRONFISH_NODENAME '\e[0m\n'
	if [ ! $IRONFISH_THREADS ]; then
		read -e -p "Enter your threads [-1]: " IRONFISH_THREADS
		echo 'export IRONFISH_THREADS='${IRONFISH_THREADS:--1} >> $HOME/.bash_profile
	fi
	echo -e '\n\e[42mYour threads count:' $IRONFISH_THREADS '\e[0m\n'
#	echo "alias ironfish='yarn --cwd ~/ironfish/ironfish-cli/ start:once'" >> $HOME/.bash_profile && . $HOME/.bash_profile
	echo "alias ironfish='yarn --cwd ~/ironfish/ironfish-cli/ start'" >> $HOME/.bash_profile && . $HOME/.bash_profile
	echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
	. $HOME/.bash_profile
	alias ironfish='yarn --cwd ~/ironfish/ironfish-cli/ start'
	sleep 1
}

function installSnapshot {
	echo -e '\n\e[42mInstalling snapshot...\e[0m\n' && sleep 1
	systemctl stop ironfishd
	rm -rf $HOME/.ironfish/databases/default/
#	wget -qO- https://ironfish.nodes.guru/ironfish_snapshot.tar.gz | tar xvz -C $HOME/.ironfish/databases/
	yarn --cwd ~/ironfish/ironfish-cli/ start chain:download --confirm
	sleep 3
	systemctl restart ironfishd
}

function setupSwap {
	echo -e '\n\e[42mSet up swapfile\e[0m\n'
echo -e '\n\e[42m[Swap] Starting...\e[0m\n'
grep -q "swapfile" /etc/fstab
if [[ ! $? -ne 0 ]]; then
    echo -e '\n\e[42m[Swap] Swap file exist, skip.\e[0m\n'
else
    cd $HOME
    sudo fallocate -l 4G $HOME/swapfile
    sudo dd if=/dev/zero of=swapfile bs=1K count=4M
    sudo chmod 600 $HOME/swapfile
    sudo mkswap $HOME/swapfile
    sudo swapon $HOME/swapfile
    sudo swapon --show
    echo $HOME'/swapfile swap swap defaults 0 0' >> /etc/fstab
    echo -e '\n\e[42m[Swap] Done\e[0m\n'
fi
}

function backupWallet {
	echo -e '\n\e[42mPreparing to backup default wallet...\e[0m\n' && sleep 1
	echo -e '\n\e[42mYou can just press enter if you want backup your default wallet\e[0m\n' && sleep 1
	read -e -p "Enter your wallet name [default]: " IRONFISH_WALLET_BACKUP_NAME
	IRONFISH_WALLET_BACKUP_NAME=${IRONFISH_WALLET_BACKUP_NAME:-default}
	cd $HOME/ironfish/ironfish-cli/
	mkdir -p $HOME/.ironfish/keys
#	exportCommand="yarn start:once accounts:export $IRONFISH_WALLET_BACKUP_NAME $HOME/.ironfish/keys/$IRONFISH_WALLET_BACKUP_NAME.json"
	exportCommand="yarn start accounts:export $IRONFISH_WALLET_BACKUP_NAME $HOME/.ironfish/keys/$IRONFISH_WALLET_BACKUP_NAME.json"
	echo $exportCommand
	${exportCommand} &>/dev/null & disown && sleep 5
	echo -e '\n\e[42mYour key file:\e[0m\n' && sleep 1
	walletBkpPath="$HOME/.ironfish/keys/$IRONFISH_WALLET_BACKUP_NAME.json"
	cat $HOME/.ironfish/keys/$IRONFISH_WALLET_BACKUP_NAME.json
	# cnt=0
	# while true; do
		# if [ -f "$walletBkpPath" ]; then
			# cat $HOME/.ironfish/keys/$IRONFISH_WALLET_BACKUP_NAME.json
			# break
		# elif [[ "$cnt" -gt 9 ]]; then
			# echo "10 attempts was done, looks like you dont have wallet with this name"
			# break
		# else
			# echo "Wait for key..."
			# echo "Be sure you input correct wallet name"
			# echo "You can check your wallets by command:"
			# echo -e "\e[7mironfish accounts:list\e[0m"
			# echo -e "Press \e[7mCtrl + C\e[0m for exit\n"
			# sleep 3
			# ((cnt++))
		# fi
	# done
	echo -e "\n\nImport command:"
	echo -e "\e[7mironfish accounts:import $walletBkpPath\e[0m"
	cd $HOME
}

function installDeps {
	echo -e '\n\e[42mPreparing to install\e[0m\n' && sleep 1
	cd $HOME
	sudo apt update
	sudo curl https://sh.rustup.rs -sSf | sh -s -- -y
	. $HOME/.cargo/env
	curl https://deb.nodesource.com/setup_16.x | sudo bash
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
	# sudo apt upgrade -y < "/dev/null"
	sudo apt install curl make clang pkg-config libssl-dev build-essential git jq nodejs -y < "/dev/null"
	sudo npm --force install -g yarn
}

function createConfig {
	mkdir -p $HOME/.ironfish
	echo "{
		\"nodeName\": \"${IRONFISH_NODENAME}\",
		\"blockGraffiti\": \"${IRONFISH_NODENAME}\"
	}" > $HOME/.ironfish/config.json
	systemctl restart ironfishd ironfishd-miner
}

function installSoftware {
	. $HOME/.bash_profile
	. $HOME/.cargo/env
	echo -e '\n\e[42mInstall software\e[0m\n' && sleep 1
	cd $HOME
	git clone https://github.com/iron-fish/ironfish
	cd $HOME/ironfish
	git pull
	# git checkout 45d85b7916b72f7ad263491b0c7fb6916b2edabd
	cargo install --force wasm-pack
	yarn
	cp $HOME/ironfish/ironfish-cli/bin/ironfish /usr/bin
}

function updateSoftware {
	# if [[ ! `service ironfishd-listener status | grep active` =~ "running" ]]; then
	  # sudo systemctl stop ironfishd-listener
	  # sudo systemctl disable ironfishd-listener
	# fi
	if service_exists ironfishd-listener; then
		sudo systemctl stop ironfishd-listener
		sudo systemctl disable ironfishd-listener
	fi
	if service_exists ironfishd-pool; then
		sudo systemctl stop ironfishd-pool
	fi
	sudo systemctl stop ironfishd ironfishd-miner
	. $HOME/.bash_profile
	. $HOME/.cargo/env
	cp -r $HOME/.ironfish/accounts $HOME/ironfish_accounts_$(date +%s)
	echo -e '\n\e[42mInstall software\e[0m\n' && sleep 1
	# rm -r $HOME/.ironfish
	cd $HOME
	installDeps
	rm -r ironfish
	# git clone https://github.com/iron-fish/ironfish -b staging
	git clone https://github.com/iron-fish/ironfish
	cd $HOME/ironfish
	# git reset --hard
	# git pull origin staging
	cargo install --force wasm-pack
	yarn
}

function updateSoftwareBeta {
	if service_exists ironfishd-listener; then
		sudo systemctl stop ironfishd-listener
		sudo systemctl disable ironfishd-listener
	fi
	sudo systemctl stop ironfishd ironfishd-miner
	. $HOME/.bash_profile
	. $HOME/.cargo/env
	cp -r $HOME/.ironfish/accounts $HOME/ironfish_accounts_$(date +%s)
	echo -e '\n\e[42mInstall software\e[0m\n' && sleep 1
	cd $HOME
	installDeps
	rm -r ironfish
	git clone https://github.com/iron-fish/ironfish -b staging
	cd $HOME/ironfish
	git reset --hard
	git pull origin staging
	cargo install --force wasm-pack
	yarn
}

function installService {
echo -e '\n\e[42mRunning\e[0m\n' && sleep 1
echo -e '\n\e[42mCreating a service\e[0m\n' && sleep 1

echo "[Unit]
Description=IronFish Node
After=network-online.target
[Service]
User=$USER
ExecStart=/usr/bin/yarn --cwd $HOME/ironfish/ironfish-cli/ start start
Restart=always
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
" > $HOME/ironfishd.service
echo "[Unit]
Description=IronFish Miner
After=network-online.target
[Service]
User=$USER
ExecStart=/usr/bin/yarn --cwd $HOME/ironfish/ironfish-cli/ start miners:start -v -t $IRONFISH_THREADS --no-richOutput
Restart=always
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
" > $HOME/ironfishd-miner.service
sudo mv $HOME/ironfishd.service /etc/systemd/system
sudo mv $HOME/ironfishd-miner.service /etc/systemd/system
sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
echo -e '\n\e[42mRunning a service\e[0m\n' && sleep 1
sudo systemctl enable ironfishd ironfishd-miner
sudo systemctl restart ironfishd ironfishd-miner
echo -e '\n\e[42mCheck node status\e[0m\n' && sleep 1
if [[ `service ironfishd status | grep active` =~ "running" ]]; then
  echo -e "Your IronFish node \e[32minstalled and works\e[39m!"
  echo -e "You can check node status by the command \e[7mservice ironfishd status\e[0m"
  echo -e "Press \e[7mQ\e[0m for exit from status menu"
else
  echo -e "Your IronFish node \e[31mwas not installed correctly\e[39m, please reinstall."
fi
if [[ `service ironfishd-miner status | grep active` =~ "running" ]]; then
  echo -e "Your IronFish Miner node \e[32minstalled and works\e[39m!"
  echo -e "You can check node status by the command \e[7mservice ironfishd-miner status\e[0m"
  echo -e "Press \e[7mQ\e[0m for exit from status menu"
else
  echo -e "Your IronFish Miner node \e[31mwas not installed correctly\e[39m, please reinstall."
fi
. $HOME/.bash_profile
}

# function installListener {
	# wget -O $HOME/ironfish_restarter.sh https://api.nodes.guru/ironfish_restarter.sh
	# chmod +x $HOME/ironfish_restarter.sh
	# echo -e '\n\e[42mCreating a listener service\e[0m\n' && sleep 1
	# echo "[Unit]
	# Description=IronFish Listener
	# After=network-online.target
	# [Service]
	# User=$USER
	# ExecStart=/bin/bash $HOME/ironfish_restarter.sh
	# Restart=always
	# RestartSec=10
	# LimitNOFILE=10000
	# [Install]
	# WantedBy=multi-user.target
	# " > $HOME/ironfishd-listener.service
	# sudo mv $HOME/ironfishd-listener.service /etc/systemd/system
	# echo -e '\n\e[42mRunning a listener service\e[0m\n' && sleep 1
	# sudo systemctl daemon-reload
	# sudo systemctl enable ironfishd-listener
	# sudo systemctl restart ironfishd-listener
	# if [[ `service ironfishd-miner status | grep active` =~ "running" ]]; then
	  # echo -e "Your IronFish listener \e[32minstalled and works\e[39m!"
	  # echo -e "You can check listener status by the command \e[7mservice ironfishd-listener status\e[0m"
	  # echo -e "Press \e[7mQ\e[0m for exit from status menu"
	# else
	  # echo -e "Your IronFish listener \e[31mwas not installed correctly\e[39m, please reinstall."
	# fi
# }

function deleteIronfish {
	sudo systemctl disable ironfishd ironfishd-miner ironfishd-listener
	sudo systemctl stop ironfishd ironfishd-miner ironfishd-listener
	sudo rm -r $HOME/ironfish
}

PS3='Please enter your choice (input your option number and press enter): '
# options=("Setup vars" "Install" "Upgrade" "Upgrade (beta)" "Backup wallet" "Install snapshot" "Delete" "Quit")
options=("Install" "Upgrade" "Upgrade (beta)" "Backup wallet" "Install snapshot" "Delete" "Quit")
#options=("Install" "Upgrade" "Upgrade (beta)" "Backup wallet" "Delete" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        # "Setup vars")
            # echo -e '\n\e[42mYou choose setup vars...\e[0m\n' && sleep 1
			# setupVars
			# break
            # ;;
        "Install")
            echo -e '\n\e[42mYou choose install...\e[0m\n' && sleep 1
			setupVars
			setupSwap
			installDeps
			installSoftware
			installService
			createConfig
			#installListener
			break
            ;;
        "Upgrade")
            echo -e '\n\e[33mYou choose upgrade...\e[0m\n' && sleep 1
			setupVars
			updateSoftware
			installService
			#installListener
			echo -e '\n\e[33mYour node was upgraded!\e[0m\n' && sleep 1
			break
            ;;
        "Upgrade (beta)")
            echo -e '\n\e[33mYou choose upgrade (beta)...\e[0m\n' && sleep 1
			setupVars
			updateSoftwareBeta
			installService
			echo -e '\n\e[33mYour node was upgraded!\e[0m\n' && sleep 1
			break
            ;;
        # "Install listener")
            # echo -e '\n\e[93mYou choose install listener...\e[0m\n' && sleep 1
			# installListener
			# echo -e '\n\e[93mIronfish listener was installed!\e[0m\n' && sleep 1
			# break
            # ;;
		"Backup wallet")
			echo -e '\n\e[33mYou choose backup wallet...\e[0m\n' && sleep 1
			backupWallet
			echo -e '\n\e[33mYour wallet was saved in $HOME/.ironfish/keys folder!\e[0m\n' && sleep 1
			break
            ;;
		 "Install snapshot")
			 echo -e '\n\e[33mYou choose install snapshot...\e[0m\n' && sleep 1
			 installSnapshot
			 echo -e '\n\e[33mSnapshot was installed, node was started.\e[0m\n' && sleep 1
			 break
             ;;
		"Delete")
            echo -e '\n\e[31mYou choose delete...\e[0m\n' && sleep 1
			deleteIronfish
			echo -e '\n\e[42mIronfish was deleted!\e[0m\n' && sleep 1
			break
            ;;
        "Quit")
            break
            ;;
        *) echo -e "\e[91minvalid option $REPLY\e[0m";;
    esac
done