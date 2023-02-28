<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://discord.gg/nodexcapital" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/34649601/207593974-32d7cb69-eca9-4096-bc96-246fe7038c88.png">
</p>

# Nolus Monitoring - NodeX Capital

Setting Up Monitoring : Grafana & Prometheus
Download Script and save as file monitoring-stack.sh

```
#!/bin/bash
PROMETHEUS_CHECKSUM="3f558531c6a575d8372b576b7e76578a98e2744da6b89982ea7021b6f000cddd"
PROMETHEUS_USER="prometheus"
PROMETHEUS_VERSION="2.36.2"
PROMETHEUS_ARCH="linux-amd64"
PROMETHEUS_URL="https://github.com/prometheus/prometheus/releases/download/"

OPTIONS=$1
MONITORING=$2


function help(){
echo "monitoring-stack [deploy|uninstall] [grafana|prometheus]"
}

function env:load(){
if ! [ -f /etc/profile.d/user-env.sh ]
then
cat > /etc/profile.d/user-env.sh <<EOF
#!/bin/env
export PATH="$PATH:/usr/local/bin"
EOF
source /etc/profile.d/user-env.sh
else
source /etc/profile.d/user-env.sh
fi
}

function prometheus:deploy(){
check_user_prometheus=`id ${PROMETHEUS_USER}` 
if [ $? -eq 1 ]
then
    useradd --no-create-home --shell /bin/false ${PROMETHEUS_USER}
fi
[ -d /etc/prometheus ] && echo "Directory Exist" || mkdir  -p /etc/prometheus && chown ${PROMETHEUS_USER}:${PROMETHEUS_USER} /etc/prometheus;
[ -d /var/lib/prometheus ] &&  echo "Directory Exist" || mkdir /var/lib/prometheus && chown ${PROMETHEUS_USER}:${PROMETHEUS_USER} /var/lib/prometheus;

if ! [ -f /usr/local/bin/prometheus ] && ! [ -f /usr/local/bin/promtool ] 
then
  if [ -f /opt/${PROMETHEUS_USER}-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}.tar.gz ]
  then 
     echo "FilePrometheus Exist"
  else
     wget -c ${PROMETHEUS_URL}/v${PROMETHEUS_VERSION}/${PROMETHEUS_USER}-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}.tar.gz  -O /opt/${PROMETHEUS_USER}-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}.tar.gz 
  fi
  check_prometheus_checksum=`sha256sum /opt/${PROMETHEUS_USER}-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}.tar.gz | awk '{print $1}'`
  if [ "${PROMETHEUS_CHECKSUM}" == "${check_prometheus_checksum}" ]
  then
    tar xvf  /opt/${PROMETHEUS_USER}-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}.tar.gz -C /opt/
    cp /opt/${PROMETHEUS_USER}-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}/prometheus /usr/local/bin/
    cp /opt/${PROMETHEUS_USER}-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}/promtool /usr/local/bin/
    cp -r /opt/${PROMETHEUS_USER}-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}/consoles /etc/prometheus/ && chown -R prometheus:prometheus /etc/prometheus/consoles 
    cp -r /opt/${PROMETHEUS_USER}-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}/console_libraries /etc/prometheus/ && chown -R prometheus:prometheus /etc/prometheus/console_libraries
    cp -r /opt/${PROMETHEUS_USER}-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}/prometheus.yml /etc/prometheus/ && chown -R prometheus:prometheus /etc/prometheus/prometheus.yml
  else 
    echo "Checksumming Failed, File Integrity ${PROMETHEUS_USER}-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}.tar.gz not match"    
  fi
fi 


if ! [ -f /etc/systemd/system/prometheus.service ]
then
cat >/etc/systemd/system/prometheus.service<<EOF
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target
[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
--config.file /etc/prometheus/prometheus.yml \
--storage.tsdb.path /var/lib/prometheus/ \
--web.console.templates=/etc/prometheus/consoles \
--web.console.libraries=/etc/prometheus/console_libraries
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
fi


systemctl start prometheus
systemctl enable prometheus
systemctl status prometheus
}


function prometheus:uninstall(){
systemctl stop prometheus
systemctl disable prometheus

userdel ${PROMETHEUS_USER}
rm /usr/local/bin/prometheus
rm /usr/local/bin/promtool
rm /etc/systemd/system/prometheus.service
rm /etc/profile.d/user-env.sh
rm -rf /etc/prometheus/
rm -rf /var/lib/prometheus/
rm -rf /opt/${PROMETHEUS_USER}-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}
rm -rf /opt/${PROMETHEUS_USER}-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}.tar.gz
}

function grafana:deploy(){
curl https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" > /etc/apt/sources.list.d/grafana.list
apt update
apt install grafana -y
systemctl start grafana-server
systemctl enable grafana-server
}

function grafana:uninstall(){
systemctl disable grafana-server
systemctl stop grafana-server
apt purge grafana
}

check_os=`cat /etc/os-release  | grep "NAME=\"Ubuntu\"" | wc -l`

if [ ${check_os} -eq 1 ]
then
    env:load;
    case "${OPTIONS}" in
  deploy)
         if [ "${MONITORING}" == "prometheus" ]
         then
              prometheus:deploy;
  elif [ "${MONITORING}" == "grafana" ]
  then
       grafana:deploy;
  else
       help;
  fi
  ;;
         uninstall)
         if [ "${MONITORING}" == "prometheus" ]
         then
              prometheus:uninstall;
         elif [ "${MONITORING}" == "grafana" ]
  then
              grafana:uninstall;
         else
              help;
         fi
         ;;
         *)
       help;
  ;;
    esac
else
   echo "Make sure your OS is Ubuntu"
fi 
```
### How To Use?
Install Grafana & Prometheus
```
bash monitoring-stack.sh grafana
bash monitoring-stack.sh prometheus
```
### Start Services
```
systemctl start grafana-server prometheus
systemctl status grafana-server prometheus
systemctl restart grafana-server prometheus
```
# Install Grafana Renderer
Grafana Renderer is plugin for render content and can send to media notification

### Install NodeJS
```
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - &&\
sudo apt-get install -y nodejs
Install Yarn

curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
   echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
   sudo apt-get update && sudo apt-get install yarn
```
### Install Grafana Renderer

```
wget https://github.com/grafana/grafana-image-renderer/archive/refs/heads/master.zip
unzip master.zip -d /opt/
mkdir -p /opt/grafana-plugin
mv /opt/grafana-image-renderer-master /opt/grafana-plugin/
Build & Create Service

yarn install --pure-lockfile
yarn run build
cat > /etc/systemd/system/grafana-render.service<<EOF
[Unit]
Description=Grafana instance
Documentation=http://docs.grafana.org
Wants=network-online.target
After=network-online.target
After=postgresql.service mariadb.service mysql.service

[Service]
User=grafana
Group=grafana
Type=simple
ExecStart=/usr/bin/node /opt/grafana-plugin/grafana-image-renderer-master/build/app.js server --port=8081

[Install]
WantedBy=multi-user.target
EOF
Register & Start Grafana Renderer

systemctl daemon-reload
systemctl start grafana-render
Install Plugin & Add in /etc/grafana/grafana.ini

grafana-cli plugins install grafana-image-renderer
[rendering]
server_url = http://localhost:8081/render
callback_url = http://localhost:3000/
```
### Restart Grafana
```
systemctl restart grafana-server
```

# Setting Prometheus Config