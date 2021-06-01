#!/usr/bin/python3

import sys

if len(sys.argv) != 2:
    print("usage: ./script.py 'url'")
    exit(1)

url = sys.argv[1]
raw_params = url[url.find("?") + 1:]

splitted = [p.split("=") for p in raw_params.split("&")]

subreq_num = 0
for kvpair in splitted:
    if not len(kvpair) == 2:
       continue
    if kvpair[0] == "req":
        subreq_num += 1
        print(f"\n==={kvpair[0]} {subreq_num}:===")
    else:
        print(f"{kvpair[0]}: {kvpair[1]}")
