#!/usr/bin/env python3

import sys

seen = {}
args = []

for arg in sys.argv[1:]:
   if arg not in seen:
      seen[arg] = 1
      args.append(arg)
      
print(' '.join(args))
