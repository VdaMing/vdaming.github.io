title: How I create my blog with Hexo on GitHub Pages
date: 2015-08-31 22:07:58
categories: Web
tags: [Hexo, Git] 
---
### Why would me like to create the blog?
一年前，忘了为什么，突然觉的拥有自己的网站是多么酷炫的一件事情，于是二话没说在花生壳搞了个.com域名, 29/年。然后在sina的SAE上建起了自己的第一个blog [Vdamings Blog](http://blog.vdaming.com),是基于wordpress做的。因为SAE上有现成的模板code，点几下鼠标而已很方便，但是使用起来总觉得不是自己想要的那种，可能因为功能太多导致失去了自己想要的简单易用的特性。于是乎有了现在的新的blog，基于Hexo静态架构挂在github上，这下感觉对了，好用了，下面来谈谈该怎么用吧：
> * 日子平淡无奇的过着, 很多美好的事情过去以后只能从脑海里回忆，渐渐忘掉，所以记下来留给明天回忆
> * **我是一个搞技术的，再好的记性比不过烂笔头，学一点及一点，以后用到的时候还能再翻一翻**
> * Blog 真是一个装X利器，你懂的！！！

** 上面全是扯淡，下面开始正题 **
***
### What is Hexo?
官方网站：https://hexo.io/
Source Code: https://github.com/hexojs/hexo/
Hexo is A fast, simple & powerful blog framework as shown on its official website. It has following powerful features:
>  * **Blazing Fast**: It is based on Node.js, and it brings you incredible generating speed. Hundreds of files take only seconds to build.
>  * **Markdown Support**: support the popular text-to-HTML languages. If you don not know it now, please just [Baidu](https://www.baidu.com/s?tn=baidu&wd=markdown) it.
>  * **One-Command Deployment**: you just need know several commands to generate your blog and to deploy it to your GitHub Pages or other sites
>  * **Various Plugins**: it support various plugins which makes it more powerful.
<!--more-->
上面是总结官方的介绍，以及它的官网和source code, 其实在官网或者github上有所有我们安装使用它的介绍，足够能让我们在短时间搞定它，为了节省大家时间，现在总结成一下几点：
1. Hexo 是一套搭建个人博客的工具或者是框架，它能产生网站要用到的静态页面，然后你把产生的文件部署到GitHub page，再然后你的博客就建成了。
2. 安装：本文描述的是在ubuntu上安装的方法
前提必须要安装有Node.js 和 Git, 对于Git的按照请参照另一篇文章[How to use Git and GItHub](http://vdaming.github.io/2015/08/30/How-to-use-Git-and-GItHub/).
安装node.js, 根据hexo官方的建议使用nvm安装：

cURL:
>    $ curl https://raw.github.com/creationix/nvm/master/install.sh | sh

Wget:
>    $ wget -qO- https://raw.github.com/creationix/nvm/master/install.sh | sh

nvm 安装完成后再安装node.js
>    $nvm install 0.12

这样V0.12的最新版本node.js就安装好了。
安装Hexo:
>    $npm install -g hexo-cli

然后初始化一个自己的博客目录
>    $hexo init (folder)
>    $cd (folder)
>    $npm install

大功告成，现在可使用下面的命令在本地查看你的博客了
>    $ hexo new "hello wold"//添加一篇博客
>    $ hexo g //生成文件
>    $ hexo s //在本地打开这个个http server

然后访问 http://127.0.0.1:4000 就能看到自己博客的样子了。至于有很多插件安装，主题配置的方法请参照这篇文章[如何搭建一个独立博客](http://www.jianshu.com/p/05289a4bc8b2)
### What is GitHub pages
本地的博客网站配置完毕以后，要把它部署到公共空间上，GitHub pages就是这样的一个存放静态页面的网站，它提供了300M的免费空间，并且他本身就是存放在GitHub上的，和github一起使用，很是方便。
对于部署页面，需要以下步骤
1. 在GItHub 上注册一个帐号，create 一个空的特殊的repository，特殊在它的名字是xxxx.github.io, xxx可以自己定义。
2. 在Hexo的配置文件中_config.yml中填写部署的参数，在文件的最后补充如下代码
> deploy:
>    type: git
>    repository: https://github.com/VdaMing/vdaming.github.io.git #填上自己创建的repository链接
>    branch: master

3.  用命令部署到github空间
> $hexo d

输入用户名密码，Done! 
现在可以浏览器进入xxxx.github.io玩玩自己的博客吧！

### Write your own blog
但是写的博客要怎么提交呢？
Hexo使用marddown的格式写自己的博客，先使用命令创建一篇新博客：
> $hexo new "new blog"

新的文章产生在blog的安装目录/source/_posts/new-blog.md：
```
title: How I create my blog with Hexo on GitHub Pages
date: 2015-08-31 22:07:58
tags:
---
```

titile是文章的标题，date 写博客的时间， tags是分类，分割线后面写正文，使用markdown格式。写完后重新部署一下就OK了：
`$hexo d`

### **加入Fork me on github**
可以参照国外大神提供的代码，有各种样式和颜色可以选择，具体请参照页面https://github.com/blog/273-github-ribbons
粘贴对应的代码到自己的博客中，例如我用的light的theme可以放到themes/hexo-theme-light/layout/layout.ejs的body标签中，重新部署就OK了!

### **替换googleapis的链接加快网站打开速度**
Hexo中使用的很多前端的库，字体，js等需要从googleapis.com获取,但是国内是不能顺利的打开这个网站的，这样造成了网站打开变慢。所以可以使用国内的站点进行替换就OK了。
具体使用的站点是360网站卫士：http://libs.useso.com/ 和 又拍云： http://jscdn.upai.com/, 只要对生成的文件进行批量替换即可。

### **添加widget的方法**
基于我当前使用的light主题设置新的widget **163music**：
1. 在/themes/hexo-theme-light/layout/_widget/的目录下添加新的163music.ejs文件大致的格式如下
```
<div class="widget tag">
<h3 class="title">音乐分享</h3>
<ul class="entry">
<li>
<iframe frameborder="no" border="0" marginwidth="0" marginheight="0" width=100% height=450 src="http://music.163.com/outchain/player?type=0&id=81623516&auto=1&height=430"></iframe>
</li>
</ul>
</div>
```
 其中的iframe链接是在网易云音乐的歌单生成外链中自动生成的，但是吧width改为了100% 自动填充满。

2. 在/theme/hexo-theme-light/_config.yml中的widgets中加入163music, 重新部署hexo， OK！

### **把自己的域名转到hexo github pages 的站点**
方法已经在github pages中有详细的介绍：https://help.github.com/articles/setting-up-a-custom-domain-with-github-pages/
具体的步骤如下
1. 在/public/目录下添加一个名字为CNAME的文件，内容填上你的域名例如：blog.vdaming.com, 然后用`hexo d` 把新的文件部署到github上.
2. 在自己的域名服务商里设置第三方的NS地址，我使用的godaddy，域名用dnspod的，所以在godaddy域名设置中更新使用dnspod的NS. 然后在dnspod中把blog.vdaming.com设置为你自己的github的地址xxxx.github.io.的CNAME. 搞定，等待CNAME生效即可，大概几分钟就行了，打开blog.vdaming.com， 就能自动装箱github pages的页面了。

### **End**
Hexo还有很多折腾的地方，主题，各种插件，独立域名等等，我也在学习和完善自己blog的过程中，一起学习一起进步。当前正在练习怎么用markdown, 那么fasion的东西一定得Get!



**文章部分内容参照**
[Hexo](https://hexo.io/)
[如何搭建一个独立博客](http://www.jianshu.com/p/05289a4bc8b2)
