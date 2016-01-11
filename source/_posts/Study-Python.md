title: Study Python
date: 2015-09-26 23:00:18
categories: Tool
tags: Python
---
# 学习Python
**学习材料:**
[Python教程](http://www.liaoxuefeng.com/wiki/001374738125095c955c1e6d8bb493182103fac9270762a000)

# **python**
Cpython
python xxx.py

print 'Hello %d' % 1+2 

input=raw_input('please input the value:')
```
#!/usr/bin/env python
# -*- coding: utf-8 -*-
```
if __name__ == __main__:
	main()

list and tuple

# **条件判断和循环**
while i < 1 :
	
if i < 1 :

else:

for i in range(min,max):


# **整型和字符串**
int(str)
str(int)


# module
```
import httplib
conn = httplib.HTTPconnection(ip, port, timeout=20);
conn.request("GET", "/index.html");
res  = conn.getresponse();
print res.status
print res.reason
conn.close();
```

```
import threading
class myThread(threading.Thread):
	globalArg = 0;
	def __init__(self,arg1):
		threading.Thread(self);
		self.arg1 = arg1;

	def run():
		print "thred is running";

thread1 = myThread(arg1);
thread1.start();
```
