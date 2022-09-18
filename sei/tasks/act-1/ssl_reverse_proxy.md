<span tyle="font-size:14px" align="right">NodeX Official Accounts :
<span style="font-size:14px" align="right">
<a href="https://discord.gg/JqQNcwff2e" target="_blank">NodeX Capital Discord</a></span> ⭐ 
<span style="font-size:14px" align="right">
<a href="https://twitter.com/nodexploit/" target="_blank">Twitter</a></span> ⭐ 
<span style="font-size:14px" align="right">
<hr>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/169664551-39020c2e-fa95-483b-916b-c52ce4cb907c.png">
</p>

# Set up ping pub for your cosmos chains

## Set up vars
```
CHAIN_NAME=dws
API_PORT=14317
```

## Update packages
```
sudo apt update && sudo apt upgrade -y
```

## Install nginx and certbot
```
sudo apt install nginx certbot python3-certbot-nginx -y
```

## Cleanup default settings
```
sudo rm -f /etc/nginx/sites-{available,enabled}/default
```

## Set up config
```
sudo tee /etc/nginx/sites-available/${CHAIN_NAME}.api.kjnodes.com.conf > /dev/null <<EOF
server {
        listen 80;
        listen [::]:80;

        server_name ${CHAIN_NAME}.api.kjnodes.com;

        location / {

                add_header Access-Control-Allow-Origin *;
                add_header Access-Control-Max-Age 3600;
                add_header Access-Control-Expose-Headers Content-Length;

                proxy_pass http://127.0.0.1:${API_PORT};
        }
}
EOF
```

## Make a symlink
```
sudo ln -s /etc/nginx/sites-available/${CHAIN_NAME}.api.kjnodes.com.conf /etc/nginx/sites-enabled/${CHAIN_NAME}.api.kjnodes.com.conf
```

## Reload nginx
```
sudo systemctl reload nginx.service
```

## Obtain our certificates
```
sudo certbot --nginx --register-unsafely-without-email
```
