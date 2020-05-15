#!/usr/bin/env python3

import sys, re

whale = sys.argv[1]
nPods = 0
nIndv = 0

while 1:
   line = sys.stdin.readline()
   if not line:
      break
   if (re.search(whale, line)):
      nPods += 1
      nIndv += int(re.sub(' .*', '', line))

print("%s observations: %d pods, %d individuals" % (whale, nPods, nIndv))
