title: 让minidlna支持rmvb格式
date: 2015-12-24 21:46:31
tags:
---

##转载自: http://segmentfault.com/a/1190000003024886

最近想倒腾个DLNA Server，可惜minidlna不支持rmvb，郁闷，ffmpeg早就支持rmvb了，没办法，自己动手改代码吧！

```
tar zxvf minidlna-1.1.3.tar.gz
sudo apt-get install build-essential libexif-dev libjpeg-dev libid3tag0-dev libFLAC-dev libvorbis-dev libsqlite3-dev libavformat-dev
```
metadata.c

```
    else if( strncmp(ctx->iformatctx->name, "matroska", 8) == 0 )
    xasprintf(&amp;m.mime, "video/x-matroska");
    else if( strcmp(ctx->iformatctx->name, "flv") == 0 )
    xasprintf(&m.mime, "video/x-flv");
```

之后添加

```
    else if( strcmp(ctx->iformat->name, "rm") == 0 )
    xasprintf(&amp;m.mime, "video/x-pn-realvideo");
    else if( strcmp(ctx->iformat->name, "rmvb") == 0 )
    xasprintf(&m.mime, "video/x-pn-realvideo");
```

upnpglobalvars.h

```
"http-get:*:application/ogg:*"
```

修改为:

```
    "http-get:*:application/ogg:*,"\
    "http-get:*:video/x-pn-realvideo:*"
```

utils.c

```
    ends_with(file, ".flv") || ends_with(file, ".xvid")  ||
```

之后添加:

```
    ends_with(file, ".rm")  || ends_with(file, ".rmvb")  ||
```

随后编译安装

```
./autogen.sh
#如果提示You must have autoconf installed to compile minidlna.
sudo apt-get install autoconf
#如果提示You must have automake installed to compile minidlna.
sudo apt-get install automake
#需要关闭本地语言包, 如果不加--disable-nls会出现各种文件找不到如: mv: cannot stat `t-da.gmo': No such file or directory
./configure --disable-nls
make
sudo make install

配置文件和1.0.24差不多:

cp minidlna.conf /usr/local/sbin/minidlna.conf

启动方式和1.0.24有很大差异:

#第一次启动使用-d –v选项看有没有出错
sudo /usr/local/sbin/minidlnad -d -v -f /usr/local/sbin/minidlna.conf
#没出错就ctrl+c 结束进程, 然后正常启动
sudo /usr/local/sbin/minidlnad -f /usr/local/sbin/minidlna.conf
#如果需要刷新列表使用-R参数
sudo /usr/local/sbin/minidlnad –R -f /usr/local/sbin/minidlna.conf
```

说到底就是几句代码的事情，ffmpeg本身就是支持rmvb，但是minidlna居然没有加上这个支持。

