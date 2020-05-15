#!/usr/bin/env python3

import sys, re, glob

target = str.lower(sys.argv[1])
count = {}
nWords = {}

for file in sorted(glob.glob("lyrics/*.txt")):
   #print(file)
   name = re.sub('lyrics/', '', file)
   name = re.sub('\.txt', '', name)
   name = re.sub('_', ' ', name)
   #print(name)

   count[name] = 0
   nWords[name] = 0

   for line in open(file):
      #print(line)
      line = str.lower(line)
      words = re.split('[^a-zA-Z]+', line)
      #print(words)
      for word in words:
         if (word == target):
            count[name] = count[name] + 1
         if word:
            nWords[name] = nWords[name] + 1

   print("%4d/%6d = %.9f %s" % (count[name], nWords[name], count[name]/nWords[name], name));
