#!/usr/bin/env python3

import sys, re, subprocess

if (sys.argv[1] == "-f"):
   freq = 1
   url = sys.argv[2]
else:
   freq = 0
   url = sys.argv[1]

webpage = subprocess.check_output(["wget", "-q", "-O-", url], universal_newlines=True)

tags = {}

#print(webpage)

webpage = re.sub('\n', ' ', webpage)
webpage = re.sub('<!--.*?-->', '', webpage)

matches = re.findall(r"<(\w.*?)>",webpage)

for i in range(len(matches)):
   matches[i] = re.sub(r" .*" , '', matches[i])
   matches[i] = str.lower(matches[i])
   tags[matches[i]] = tags.get(matches[i],0) + 1

#print(matches)
if freq:
   for tag in sorted(sorted(tags), key=tags.get):
      print("%s %d" % (tag, tags[tag]))
else :
   for tag in sorted(tags):
      print("%s %d" % (tag, tags[tag]))
