title: Play with RaspberryPi
date: 2015-09-20 17:11:35
categories: Tool
tags: RaspberryPi
---
## GPIO硬件对应图
![Raspberry gpio 图](http://i4.tietuku.com/560a99a9a616174c.png)

## 在ubuntu上把树梅派系统写入SD卡
[最新系统镜像文件](http://downloads.raspberrypi.org/raspbian_latest  “树梅派官网”)
1. 查看SD卡的对应的设备名称
` df -h `
2. 先把SD卡的各个分区卸载
` umount /media/vdaming/xxxx `
3. 用dd把下载解压好的系统镜像写入SD卡
` sudo dd bs=4M if=xxxxx.img of=/dev/sdb ` 

##备份树梅派系统
1. SD卡插到linux PC上，先查看存储设备路径
` sudo fdisk -h `
` mount `
` df -h `
2. 卸载SD卡
` umount /dev/sdx1 `
` umount /dev/sdx2 ` 
3. 备份
` sudo dd if=/dev/sdx | gzip > rpi_backup_img.gz `

## 在windows上把树梅派系统写入SD卡
可以是用软件[Win32DiskImager](http://sourceforge.net/projects/win32diskimager/files/Archive/win32diskimager-v0.9-binary.zip/download) 轻松搞定，或者使用[USB Image Tool](http://www.alexpage.de/usb-image-tool/download/), 具体使用就不再介绍了。

## 配置raspberrypi
插上SD卡，启动树梅派，远程SSH登录(pi/raspberry)上去，使用命令`sudo raspi-config`配置相关的参数比如: timezone, lang, overlock....  然后reboot， 配置为国内的软件源，然后apt-get update, 然后安装自己常用的工具比如vim, vnc...
### 国内的软件源地址
中山大学
Raspbian http://mirror.sysu.edu.cn/raspbian/raspbian/
中国科学技术大学
Raspbian http://mirrors.ustc.edu.cn/raspbian/raspbian/
清华大学
Raspbian http://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian/
华中科技大学
Raspbian http://mirrors.hustunique.com/raspbian/raspbian/
Arch Linux ARM http://mirrors.hustunique.com/archlinuxarm/
大连东软信息学院源（北方用户）
Raspbian http://mirrors.neusoft.edu.cn/raspbian/raspbian/
重庆大学源（中西部用户）
Raspbian http://mirrors.cqu.edu.cn/Raspbian/raspbian/

<!-- more -->

### 没有显示器怎么办
在raspberry上安装tightvncserver:

```
sudo apt-get install tightvncserver
#设置密码
vncpasswd
#启动vnc server
sudo vncserver
```

在PC (ubuntu)上安装vnc viewer:

```
sudo apt-get install vncviewer
#链接server
vncviwer 
```

启动vncviwer后输入IP和终端号和密码成功登入。。如图
![图片1](http://i1.tietuku.com/e8439990d4c9ede4.png)


### 视频采集

[Camkit](https://git.oschina.net/andyspider/Camkit)
这个开源的camera组件提供了图像的采集，编码，转换，打包，发送功能的API，而且提供了一个例子程序，能够实现所有的过程并可以远程VLC 观看，关键是它是利用GPU实现编码转换的过程不会占用很多CPU，而且利用了H.264硬解,具体可以参考作者的介绍


[Media-Streamer](http://sourceforge.net/projects/mjpg-streamer/)
同样很赞的一个开源图像采集和转换工具，可以下载sourceCode，按照介绍编译，然后运行脚本start.sh, 就能够在本地建立一个实时图像的http server，提供了VLC，streamer，javascript的实时视频播放方式。具体的安装步骤请参考树梅派实验室的好文： http://shumeipai.nxez.com/2013/10/04/raspberry-pi-mjpg-streamer-network-monitoring.html


#End

树梅派还有很多拓展的功能，主要是基于linux的mini server，开源的好东西数不胜数，也为我们这些爱折腾的家伙提供很多材料，希望自己以后也能为开源做出一点点贡献，加油！！！
