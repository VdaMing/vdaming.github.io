title: Install LNMP on ArchLinuxArm
date: 2016-01-03 23:29:53
tags: PHP,Nginx
category: Tool
---
## 安装LNMP
参照网上的[教程](http://blog.csdn.net/spaceship20008/article/details/8456601)，遇到了几点问题:
1. ArchlinuxArm的软件源设定，由于官方的mirror.archlinuxarm.org是访问不到的，所以要更改为国内的镜像站，测试了几个后，最后使用的是中科大的源http://mirrors.ustc.edu.cn/archlinuxarm/ 。需要在/etc/pacman.d/mirrorlist中把原来的server注释掉，把国内的地址加到最后即可，记得地址后面要有跟着`$arch/$repo`以便适应不同的平台。
2. 教程中提到使用`pacman -S php php-cgi php-fpm php-curl php-gd php-mcrypt mysql mysql-clients nginx`即可但是`php-curl`这个包会找不到，然后把它拿掉就可以了，后面再看这个是干嘛的吧。
3. 安装mysql时会提示是安装mariadb还是percona，这两个都是兼容mysql的升级版本，最后选择大家常用的mariadb，至于为什么，以后知道了在补充。

## 配置Nginx
[Nginx文档](http://nginx.org/en/docs/)
> NGINX is an open source web server and reverse proxy that excels at large-scale web integration, application security, and web acceleration
配置文件的路径在/etc/nginx/nginx.conf,配置的每个Directives中的name，parameter在[这里](http://nginx.org/en/docs/)上和官方的wiki上的[Geting started](https://www.nginx.com/resources/wiki/start/)上有很好的介绍,下面贴出目前使用的配置

```
 server {
        listen       80;
        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            root   /usr/share/nginx/html;
            index  index.html index.htm index.php;
        }

        error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   /usr/share/nginx/html;
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        location ~ \.php$ {
            root           /usr/share/nginx/html;
            #fastcgi_pass   127.0.0.1:9000;
            fastcgi_pass   unix:/run/php-fpm/php-fpm.sock;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
            #fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
            fastcgi_param  SCRIPT_NAME      $fastcgi_script_name;
            include        fastcgi_params;
        }

```

## php-fpm配置
[PHP手册](http://php.net/manual/zh/)
首先是php-fpm, php-cgi, cgi, fastcgi的关系是什么，segmental Fault上有个很好的解释[搞不清FastCgi与PHP-fpm之间是个什么样的关系](http://segmentfault.com/q/1010000000256516),总结下来就是: cgi,fastcgi是协议; php-cgi是php的解释器，是实现cgi的程序; php-fpm是fastcgi的实现，是用来管理php-cgi的。那nginx上要能访问php的网页就要通过代理传给php-fpm去调度php-cgi解释php的脚本，然后返回数据给nginx.
1. php-pfm怎么配置的？ 配置文件的路径是/etc/php/php-fpm.conf,具体每个配置项的含义可以参考[这里](http://php.net/manual/zh/install.fpm.php), 目前使用的都是默认配置，其中listen = /run/php-fpm/php-fpm.sock和listen = 127.0.0.1:9000，要选择一个，并且和Nginx中的配置保持一致。
2. 在Nginx的配置中fastcgi的fastcgi_pass 要填入php-fpm.conf中的listen地址， 对于socket的方式要在前面添加`unix:`即`fastcgi_pass   unix:/run/php-fpm/php-fpm.sock`

## 验证php+Nginx
使用`systemctl enable php-fpm.service`添加php-pfm到自启动服务
使用`systemctl enable nginx.service`添加nginx到自启动服务
使用`systemctl start php-fpm.service`启动php-fpm
使用`systemctl start nginx.service`启动nginx
在nginx网站目录添加index.php文件里面填写`<?php phpinfo();?>`,浏览器中访问 http://127.0.0.1/ 和 http://127.0.0.1/index.php 如果显示正确的页面表示设定都OK了！

## MySQL配置
[MySQL 5.7 Reference Manual](http://dev.mysql.com/doc/refman/5.7/en/)
[MySQL on ArchWiki](https://wiki.archlinux.org/index.php/MySQL)
## 未完待续
