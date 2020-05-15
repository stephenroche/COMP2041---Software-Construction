#!/usr/bin/env python3

import sys, re

for arg in sys.argv[1:]:
   F = open(arg)
   lines = F.readlines()

   end = len(lines)
   start = end - 10
   if (start < 0):
      start = 0
   for i in range(start, end):
      print(re.sub('\n$', '', lines[i]))
