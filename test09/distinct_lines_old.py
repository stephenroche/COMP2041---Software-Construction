#!/usr/bin/env python3

import sys, re

n = int(sys.argv[1])
nDistinct = 0
nRead = 0
seen = {}

for line in sys.stdin:
   line = re.sub(r'\s', '', line.lower())

   if line not in seen:
      nDistinct += 1
      seen[line] = 1
   nRead += 1
   if nDistinct >= n:
      print("%d distinct lines seen after %d lines read." % (nDistinct, nRead))
      sys.exit(1)

print("End of input reached after %d lines read -  %d different lines not seen." % (nRead, n))
