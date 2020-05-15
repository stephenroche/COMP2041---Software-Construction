#!/usr/bin/env python3

import sys

args = {}
for i in range(1, len(sys.argv)):
   if not (sys.argv[i] in args):
      args[sys.argv[i]] = i

line = ' '.join(sorted(args.keys(), key=lambda x: args[x]))

print(line)
