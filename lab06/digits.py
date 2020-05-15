#!/usr/bin/env python3

import sys, re

while 1:
   line = sys.stdin.readline()
   if not line:
      break
   line = re.sub('[0-4]', '<', line)
   line = re.sub('[6-9]', '>', line)
   line = re.sub('\n$', '', line)
   print(line)

