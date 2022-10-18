<strong><p style="font-size:14px" align="left">Founder :
<a href="https://discord.gg/JqQNcwff2e" target="_blank">NodeX Capital Discord</a></p></strong>
<strong><p style="font-size:14px" align="left">Visit Our Website : 
<a href="https://nodex.codes/" target="_blank">https://nodex.codes</a></p></strong>
<strong><p style="font-size:14px" align="left">Follow Me :
<a href="https://twitter.com/nodexploit/" target="_blank">NodeX Twitter</a></p></strong>
<hr>

<p align="center">
 <img height="250" height="auto" src="https://user-images.githubusercontent.com/107190154/190568136-14f5a7d8-5b15-46fb-8132-4d38a0779171.gif">
</p>

# Official Links
### [Official Document](https://docs.nulink.org/products/testnet)
### [Nulink Official Website](https://www.nulink.org/)
### [Nulink Official Telegram](https://t.me/NuLinkChannel)

In order to run Nulink Worker testnet you have to open specific port which is 9151 , Now how do you open it ? 


First check if your port are open by using 
- [Yougetsignal](https://www.yougetsignal.com/tools/open-ports/)

If your port are closed we can open it, there is 2 way
### 1.Open throught ufw allow
If your port is closed you can open it in terminal using this command 
```
sudo ufw allow ssh
sudo ufw allow 9151
sudo ufw enable
```
Just press `y` and enter.and check your port

## 2.If your port still closed , we open it via panel
if you are using azure / Google cloud , its pretty common that your port still closed even you already allow them via `ufw`.

### How to open port if you are using azure
You need to open in in the panel
1. First go to your azure panel and click on your machine
2. Go to networking
<img height="250" height="auto" src="https://user-images.githubusercontent.com/34649601/195009179-fc7dde4a-5e4f-4fc2-a98c-a4064287d013.png">
3. Add inbound port
<img height="220" height="auto" src="https://user-images.githubusercontent.com/34649601/195009637-90b22908-b38e-4e1c-bf13-2b7ad26344b7.png">
4. Change Destination port ranges to 9151 then click Add.
<img height="350" height="auto" src="https://user-images.githubusercontent.com/34649601/195009892-3efac651-ccc8-47d4-b655-27b0ca530f6c.png">
5. Check your ports in https://www.yougetsignal.com/tools/open-ports/

### How to open port if you are using Google cloud
You need to open port in panel just like azure but the steps are different
1. First go to your google cloud project then on the left side you will see VPC Network and click Firewall
<img height="350" height="auto" src="https://user-images.githubusercontent.com/34649601/195010456-42ec04fe-559d-4788-9638-080435ba3d43.png">
2. Then create Firewall rule
<img height="350" height="auto" src="https://user-images.githubusercontent.com/34649601/195010642-17a29a6e-4807-46ed-9c39-ff421279929d.png">
3. Add any name you want and follow the settings according to this image
<img height="350" height="auto" src="https://user-images.githubusercontent.com/34649601/195010937-ffe6743b-5b56-4d26-bbaa-4eb7b6f569ba.png">

- `Direction of traffic : Ingress`
- `Action on match : Allow`
- `Targets : All instance in the network`
- `Source filter : IP4`
- `Source IP4 Ranges : 0.0.0.0/0`
- `Check allow specified protocols and ports`
- On TCP input `9151` and any ports you want to open then click Create
4. Check your ports in [Yougetsignal](https://www.yougetsignal.com/tools/open-ports/)