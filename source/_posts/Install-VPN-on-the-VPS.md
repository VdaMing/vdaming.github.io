title: Install VPN on the VPS
date: 2016-01-13 21:28:54
tags: VPN SS PPTP 
category: tool
---
# Install VPN on the VPS
## SS
SS项目地址 https:/github.com/shadowsocks/shadowsocks 已经被清空了，[wiki](https://github.com/shadowsocks/shadowsocks/wiki)还是可以用的。源码还好有人[备份](https://github.com/ziggear/shadowsocks)了.

### 安装SS on ubuntu:

```
apt-get install python-pip
pip install shadowsocks
```
里面包含了client: sslocal和server: ssserver

### 启动SS server
可以写一个json格式的配置文件server和client都可以用，然后用`ssserver -c xxxx.json -d start`
配置如下
```
{
"server":"xx.xx.xx.xx",
"server_port":xxxx,
"local_server":"0.0.0.0",
"local_port":1080,
"password":"xxxxx",
"timeout":600,
"method":"rc4-md5"
}

```

也可以直接用命令行加参数启动: ` ssserver -s xx.xx.xx.xx -p xxx -k xxxx -m rc4-md5 -t 300 -d start`

### 配置client
Ubuntu:
`sslocal -c xxxx.json -d start`, 然后浏览器设置sockv5 代理到本地的1080端口.

Windows:
[客户端软件](https://github.com/shadowsocks/shadowsocks-windows/releases/download/2.5.8/Shadowsocks-2.5.8.zip)

Android:
[google play](https://play.google.com/store/apps/details?id=com.github.shadowsocks)

## PPTP VPN
安装过程主要参考这里： https://help.ubuntu.com/community/PPTPServer

> First we need to install pptp server using apt-get
> 
> `# sudo apt-get install pptpd`
>
> Then we need to configure the pptpd.
>
> `# sudo nano /etc/pptpd.conf`
>
> Add server IP and client IP at the end of the file. You can add like below:
> 
> `localip 192.168.0.1`
> `remoteip 192.168.0.100-200`
> This sets up the PPTP server to use IP 192.168.0.1 while distributing the IP range 192.168.0.100 to 192.168.0.200 to PPTP clients. Change these as you wish as long as they are private IP addresses and do not conflict with IP addresses already used by your server.
> 
> Configure DNS servers to use when clients connect to this PPTP server
> 
> `# sudo nano /etc/ppp/pptpd-options`
> 
> Uncomment the ms-dns and add google like below or OpenDNS
> 
> `ms-dns 8.8.8.8`
> `ms-dns 8.8.4.4`
> 
> Now add a VPN user in /etc/ppp/chap-secrets file.
> 
> `# sudo nano /etc/ppp/chap-secrets`
> 
> The column is username. Second column is server name, you can put “pptpd” in there. Third column is password. The last column is the IP addresses, you can put * to allow all IP.
> 
> `# client        server  secret                  IP addresses`
> `username * myPassword *`
> 
> Finally start your server
> 
> `# /etc/init.d/pptpd restart`
> 
> 
> Setup IP Forwarding
> 
> To enable IPv4 forward. Change /etc/sysctl.conf file, add forward rule below.
> 
> `# sudo nano /etc/sysctl.conf`
> 
> Uncomment the line
> `net.ipv4.ip_forward=1`
> 
> Then reload the configuration
> 
> `sudo sysctl -p`
> 
> `Add forward rule in iptables`
> 
> `# sudo nano /etc/rc.local`
> 
> adding to the bottom just before the exit 0
> 
> `iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -j MASQUERADE`
> `iptables -A FORWARD -p tcp --syn -s 192.168.0.0/24 -j TCPMSS --set-mss 1356`
> 
> This example is using 192.168.0 for its PPTP subnet. The second rule adjusts the MTU size :
> 
> You are done. Just reboot your server and you should be able to connect to using PPTPD and send all your traffic through this server. 

#### 遇到的问题
找问题的原因主要是看client和server的log文件/var/log/syslog
1. logwtmp 版本不对，log中会有显示，需要注释掉/etc/pptpd.conf中的logwtmp
2. ppp0 设备找不到，log中提醒用命令`mknod ppp c 108 0`添加device节点
3. log中提示找不到ppp-generic 模块，是因为很多VPS上kernel没有把ppp相关的模块编译进来比如tun，ppp-generic. 只要让VPS服务商添加一下就OK了


## openVPN
PPTP已经不安全了，所以想到用[openvpn](http://www.openvpn.net/)
