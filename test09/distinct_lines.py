#!/usr/bin/env python3

import sys, re

maxd = int(sys.argv[1])
seen = {}
nread = 0

for line in sys.stdin:
   nread += 1
   line = re.sub('\s+', '', line.lower())
   seen[line] = 1
   ndist = len(seen.keys())
   if (ndist >= maxd):
      print("%d distinct lines seen after %d lines read." % (maxd, nread))
      sys.exit()
      
print("End of input reached after %d lines read - %2d different lines not seen." % (nread, maxd))
