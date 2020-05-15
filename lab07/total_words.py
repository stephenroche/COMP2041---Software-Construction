#!/usr/bin/env python3

import sys, re
count = 0

for line in sys.stdin:
   words = re.split('[^a-zA-Z]+', line)
   #print(words)
   for word in words:
      if word:
         count = count + 1

print("%s words" % count)
