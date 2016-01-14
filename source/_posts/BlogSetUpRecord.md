title: Blog建设经历
date: 2015-11-01 01:08:08
tags: Hexo
---
## 2015.10.31
### 更改博客主题从[light](https://hexo.io/hexo-theme-light)改为[yelee](https://github.com/MOxFIVE/hexo-theme-yelee)

## 2016.01.12
### Create branch in git to store the blog source code
1. 在github上新建一个branch，名字为blogSourceCode.
2. Clone 最新的仓库到本地： `git clone https://github.com/VdaMing/vdaming.github.io.git`
3. Clone下来后默认在master分支，用 `git checkout blogSourceCode` 切换到新建的分支 
4. 使用 `git rm ./` 删除到分支中所有的文件, 将原来的blog的sourcecode放到新建分支的目录下，#更改.gitignore忽略.deply*文件和public目录,删除theme下面.git文件夹#.然后用`git add ./` 把修改后的文件填到暂存区，然后使用 `git commit -m xx` 提交，再把改动用 `git push origin blogSourceCode` 更新到github上.
5. 再其它的环境下就可以直接clone到最新的code，然后要安装hexo和必须的插件，可以直接运行script下面的脚本完成安装，就可以写新的blog了。写完后用git push 到github上即可.写之前可以用`git pull origin blogSourceCode`更新下code.
