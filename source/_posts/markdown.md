title: Markdown 用法
date: 2015-09-02 13:58:46
categories: Tool
tags: [Markdown]
---
用Hexo搭完Blog，要开始记录一些东西了。下面会一点点的记录自己常用的markdown用法，now begin!

### **多级标题的使用**
#### 用法示例

```
# 一级标题
## 二级标题
### 三级标题
#### 四级标题
##### 五级标题
###### 六级标题
```

#### 实际效果

> # 一级标题
> ## 二级标题
> ### 三级标题
> #### 四级标题
> ##### 五级标题
> ###### 六级标题

<!--more-->
---
### **字体格式的使用**
#### 粗体

```
**这是粗体**
__这也是粗体__
*这是斜体*
_这也是斜体_
```

#### 实际效果

> **这是粗体**
> __这也是粗体__
> *这是斜体*
> _这也是斜体_

---
### **一些特殊的线**

```
---------    分隔线
~~我被删除了~~   删除线
```

#### 实际效果

> 分隔线
>  ---------   
>  删除线
> ~~我被删除了~~  

---
### **代码块**

```
单行的代码使用前后加‘`’： `echo "hello world"`
多行的代码使用前后加‘```’：
\`\`\`
echo "hello world"
echo "hello world again"
\`\`\`
```

#### 实际效果

> `echo "hello world"`
> ```
> echo "hello world"
> echo "hello world again"
> ```

---
### **列表的使用**

```
有序列表直接用序号：
1.我是第一列
2.我是第二列
3.我是第三列
无序列表可以用+，-，*:
+ 我是没顺序的
- 我也是没顺序的
* 我更是没序列的
```

#### 实际效果

> 1.我是第一列
> 2.我是第二列
> 3.我是第三列
> + 我是没顺序的
> - 我也是没顺序的
> * 我更是没序列的

---
### **链接的使用**

```
普通链接可以用：
[链接名称](链接地址 "title")
或者是：
[链接名称][1], 然后在其他地方用[1]: http://www.baidu.com  "baidu" 
图片链接可以用：
![图片名称](/path/to/img.jpg "图片Title")
或者是
![图片名称][1], 然后在其他地方用[1]: /path/to/img.jpg "图片title"
```

#### 实际效果

> [我是google](http://www.google.com "google")
> [我是百度][1]
> 我是图片啦
> ![Tedy](http://img-storage.qiniudn.com/15-9-2/6590323.jpg "tedy")
> ![W图片][2]

 [1]: http://www.baidu.com "baidu"
 [2]: http://img-storage.qiniudn.com/15-9-2/31875068.jpg "W"

---
### **嵌入网易云音乐**

---

### **未完待续**
Lots of knowledge about markdown will be added with my step of learning it and writing with it.....



---

### **END**
这边再加一个脚注：

```
脚注[^Demo]
[^Demo]这是一个脚注
```

#### 实际效果
脚注[^Demo]
[^Demo]: 这是一个脚注

