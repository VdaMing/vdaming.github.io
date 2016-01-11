title: Hello world in Android Studio
date: 2015-09-08 20:38:25
categories: Tool
tags: Android Studio
---

之前写java的小程序或者是android的app都是用的Eclipse, 也有好久没写过android的东西了。现在[google](http://guge.in)在力推Android studio,所以也来体验一把，记录下在ubuntu安装android studio的过程，以及用到的工具。
## Google官方安装要求
```
Linux
    GNOME or KDE desktop
    GNU C Library (glibc) 2.15 or later
    2 GB RAM minimum, 4 GB RAM recommended
    400 MB hard disk space
    At least 1 GB for Android SDK, emulator system images, and caches
    1280 x 800 minimum screen resolution
    Oracle® Java Development Kit (JDK) 7
```
## 安装JDK
从oracle官网下载JDK1.7**[链接](http://www.oracle.com/technetwork/java/javase/archive-139210.html)**,android 官方要求是JDK7，所以选择java SE7 下载[jdk-7u80-linux-i586.tar.gz](http://download.oracle.com/otn/java/jdk/7u80-b15/jdk-7u80-linux-i586.tar.gz)。另外官方下载是需要登录到oracle的，注册个帐号就行了。
### 下载到本地目录，解压，设定环境变量：
```
export JAVA_HOME=/usr/lib/java/jdk1.7.0_80
export JRE_HOME=${JAVA_HOME}/jre 
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=${JAVA_HOME}/bin:$PATH
```
把上面的export环境变量放入到/etc/profile的最后让它开机自动执行。
### 更新默认java命令
有些ubuntu版本默认带有java，我们安装以后要用更新一下系统默认执行的版本：
```
sudo update-alternatives --install /usr/bin/java java /usr/lib/java/jdk1.7.0_80/bin/java 300
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/java/jdk1.7.0_80/bin/javac 300
```
### 测试一下是否安装OK
在命令行使用命令java --verion,查看能否正确显示java的版本信息。
```
vdaming@vdaming-Lenovo-ubuntu:/etc$ java -version
java version "1.7.0_80"
Java(TM) SE Runtime Environment (build 1.7.0_80-b15)
Java HotSpot(TM) Server VM (build 24.80-b11, mixed mode)
```
<!--more-->
## 安装Android Studio
方法有很多，因为GFW的原因，下载都成为了问题，好在国内有很多网站提供原版的下载，很贴心：
AndroidDevTool: http://www.androiddevtools.cn/ 提供了很多android开发用到的SDK，studio, 教程等等非常不错的资源.你可以从上面下载单独的android studio，然后下载SDK， sdk tools, build platform 等等自行安装，避免了应为qiang的原因。
这里介绍从Google上直接下载包含了IDE，SDK TOOLS， android 6.0 platform, 6.0 emulator system image的完整包的安装，qiang的话可以用**lantern**突破，想用的话可以自行baidu.

下载android-studio-ide-141.2178183-linux.zip完以后，解压到你想要安装的目录， 然后运行/studio.sh， OK 搞定！

---

## 你想多了！！！
你会发现第一次启动总是会报错，这是因为GFW的原因，所以你需要在安装目录/bin/idea.properties的最后一句添加disable.android.first.run=true，OK搞定！

## 安装Android SDK
打开SDK manager，又是因为qiang的原因，很多的source都fetching 不到，所以需要把更新的源更换为国内的网站，然后就能顺利更新了，下面是应用andoirdDevTool网站的说明，想要最新的地址请到它的官网：

```
 Android SDK在线更新镜像服务器
    中国科学院开源协会镜像站地址:
       IPV4/IPV6: http://mirrors.opencas.cn 端口：80
       IPV4/IPV6: http://mirrors.opencas.org 端口：80
       IPV4/IPV6: http://mirrors.opencas.ac.cn 端口：80

    上海GDG镜像服务器地址:
       http://sdk.gdgshanghai.com 端口：8000

    北京化工大学镜像服务器地址:
        IPv4: http://ubuntu.buct.edu.cn/ 端口：80
        IPv4: http://ubuntu.buct.cn/ 端口：80
        IPv6: http://ubuntu.buct6.edu.cn/ 端口：80

    大连东软信息学院镜像服务器地址:\
       http://mirrors.neusoft.edu.cn 端口：80

    腾讯Bugly 镜像:
       http://android-mirror.bugly.qq.com 端口：8080
    腾讯镜像使用方法: http://android-mirror.bugly.qq.com:8080/include/usage.html
 使用方法：
   启动 Android SDK Manager ，打开主界面，依次选择『Tools』、『Options...』，弹出『Android SDK Manager - Settings』窗口；在『Android SDK Manager - Settings』窗口中，在『HTTP Proxy Server」和>「HTTP Proxy Port』输入框内填入上面镜像服务器地址(不包含http://，如下图)和端口，并且选中『Force https://... sources to be fetched using http://...』复选框。设置完成后单击『Close』按钮关闭『Android SDK Manager - Settings』窗口返回到主界面；
 依次选择『Packages』、『Reload』。
```

 ![](http://i1.tietuku.com/088503721c181f33.png)


##END
Now i will start to write one new APP to earn money!!!
