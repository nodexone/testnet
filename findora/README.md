<strong><p style="font-size:14px" align="left">Founder :
<a href="https://discord.gg/JqQNcwff2e" target="_blank">NodeX Capital Discord</a></p></strong>
<strong><p style="font-size:14px" align="left">Visit Our Website : 
<a href="https://nodex.codes/" target="_blank">https://nodex.codes</a></p></strong>
<strong><p style="font-size:14px" align="left">Follow Me :
<a href="https://twitter.com/nodexploit/" target="_blank">NodeX Twitter</a></p></strong>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/166676803-ee125d04-dfe2-4c92-8f0c-8af357aad691.png">
</p>

# Findora node setup mainnet/testnet

## Findora Node Scripts
Below is our version of the installer script (findora.sh) and the update version script (update_version.sh). Either script can be easily modified to be run on testnet, simply update the `NAMESPACE` variable at the start of either script.  

### Inroduction
Easy Node's updated findora.sh to create a **brand new server with a brand new wallet** in 1 automatic install. **Do not run this on a server with your existing files or they will be overwritten!!!**  

We made some modifications to add a restart on boot and to also install the current version of `fn` during the script instead of separately.  

### Manual Setup
Install docker and configure your user by follow manual install. If you user isn't `servicefindora` update that to be your username in the following code before running it on your server, Follow [manual guide](https://github.com/nodesxploit/testnet/blob/main/findora/manual_install.md) if you better prefer setting up node manually

### Automatic Install
Restart your shell session after configure manual install above (disconnect and reconnect so your user account has docker group access), then grab the mainnet script and fire away! select 2 option that you wanna install below :

Testnet Automatic
```wget -O findora.sh https://raw.githubusercontent.com/nodesxploit/testnet/main/empower/findora.sh && chmod +x findora.sh && bash -x findora.sh
```
Mainnet Automatic
```
wget -O mainnet.sh https://raw.githubusercontent.com/nodesxploit/testnet/main/empower/upgrade/mainnet.sh && chmod +x mainnet.sh && bash -x mainnet.sh
```

### Update Version
Our version of the script for mainnet. We added the option to restart on reboot.  

To check for updates & restart your mainnet Findora node:
```
wget https://raw.githubusercontent.com/easy-node-one/findora-validator-scripts/main/update_version_mainnet.sh -O update_version.sh && bash -x update_version.sh
```

## Firewall Settings
Below are our configurations for different software firewalls.  

### ufw.sh
Firewall settings for using ufw with Findora for those of you on Contabo or other providers with software firewalls.