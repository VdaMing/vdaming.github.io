#########################################################################
# File Name: replace.sh
# Author: vic 
# mail: 840234240@qq.com
# Created Time: 2015年10月18日 星期日 09时42分14秒
#########################################################################
#!/bin/bash
newStr="upcdn.b0.upaiyun.com\/libs\/jquery\/jquery-2.0.3.min.js"
oldStr="ajax.useso.com\/ajax\/libs\/jquery\/2.0.3\/jquery.min.js"
sed -i "s/$oldStr/$newStr/g" `grep 'upcdn.b0.upaiyun.com/libs/jquery/jquery-2.0.3.min.js' -rl *` 

