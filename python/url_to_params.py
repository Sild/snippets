#!/usr/bin/python3

import sys

if len(sys.argv) != 2:
    print("usage: ./script.py 'url'")
    exit(1)

url = sys.argv[1]
raw_params = url[url.find("?") + 1:]

splitted = [p.split("=") for p in raw_params.split("&")]
kv_params = {p[0]:p[1] for p in splitted if len(p) == 2}
for p in splitted:
    if len(p) != 2:
        print("fail to parse param:", p)       

for k, v in kv_params.items():
    print(k, ": ", v)
