title: How to use Git and GItHub
date: 2015-08-30 22:44:16
categories: Tool
tags: [Git, GitHub] 
---
 1. **Git used locally:**
	 - **Set up git in linux** 
        1. sudo apt-get install git
        2. git config –global user.name “vdaming”//git 用户姓名
        3. git config –global user.email “xxxxxxxx@xxx.com” //用户邮箱
        4. ssh-keygen -t rsa -C "youremail"//输入两次密码后会产生一个本机的SSH key，然后填写到你注册的github账户上（登陆github系统。点击右上角的 Account Settings--->SSH Public keys ---> add another public keys），然后就可以用SSH连接github了        
	 - **Creat a local repository**
        1.  mkdir testGitHub
        2.  git init// 把当前目录init为一个repository,会自动产生一个.git目录
        3.  cd testGitHub && touch README.md
        4.  vim README.md // write something in it
        5.  git add README.md //添加到git暂存区
        6.  git commit -m “log” //改动提交到本地的repository 工作区
        7.  vim README.md //继续更改文件
        8.  git status //查看当前的改动
        9.  git diff //查看具体的改动
        10.  git add README.md && git commit -m “log”//依然用add,commit,提交到repository
        11.  git log//显示所有提交的版本号以及log内容
        12.  git reflog//简短的实现所有提交过的log，版本
        13.  git reset –hard 版本号 或者 git reset –hard HEAD^num, 回退到某个版本或者往前回退num个版本
        14.  git checkout –filename //丢弃当前工作区的某个文件改动（退到还未做add前的最后版本）
        15.  rm file && git commit -m “log” //从repository 删除某个文件
        16.  git checkout –file //rm后未add前时恢复文件
<!--more-->
 2. **How to use GitHub**
 - **From local to remote***   
	 *   Create a repository first in the local as the “**1\. Git used locally**“.
        1.  Create an empty repository in the GitHub.com (easy to do)
        2.  git remote add origin URL// URL is the repository address created in GitHub.com
        3.  git push -u origin master// 把本地的master push 到远程的repository (-u is only used at the first time of push)
    - **From remote to local**
	    1.  create a repository in the GitHub or fork from others’ repository
        2.  git clone URL//the URL of remote, the repository will be added in the local
        3.  git add && git commit && git push origin master //本地修改提交再更新到github
        4.  git remote add upstream URL//URL 为仓库源地址，对于clone fork的仓库，需要考虑sync的问题
    -  **Master and Branch**
	    1.  git branch branch_name// 创建branch
        2.  git checkout branch_name //切换到branch
        3.  git checkout -b branch_name //创建并切换到branch
        4.  git merge branch_name //merge branch 到当前的branch或master
        5.  git checkout -d branch_name //删除branch
    -   **分支管理策略**

        通常合并分支时，git一般使用”Fast forward”模式，在这种模式下，删除分支后，会丢掉分支信息，现在我们来使用带参数 –no-ff来禁用”Fast forward”模式。：

        1.  创建一个dev分支。
        2.  修改readme.txt内容。
        3.  添加到暂存区。
        4.  切换回主分支(master)。
        5.  合并dev分支，使用命令 git merge –no-ff  -m “注释” dev
        6.  查看历史记录
    -   **多人协作工作模式**

        1.  首先，可以试图用git push origin branch-name推送自己的修改.
        2.  如果推送失败，则因为远程分支比你的本地更新早，需要先用git pull试图合并。
        3.  如果合并有冲突，则需要解决冲突，并在本地提交。再用git push origin branch-name推送。

    -   **Note: origin 就是指remote的repository。**

**本文部分内容来自 ：**《推荐！手把手教你使用Git》 [http://blog.jobbole.com/78960/](http://blog.jobbole.com/78960/)

