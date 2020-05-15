#!/usr/bin/env python3

import sys, re
count = 0
target = str.lower(sys.argv[1])

for line in sys.stdin:
   line = str.lower(line)
   words = re.split('[^a-zA-Z]+', line)
   #print(words)
   for word in words:
      if (word == target):
         count = count + 1

print("%s occurred %d times" % (target,count))
