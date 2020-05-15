#!/usr/bin/env python3

import sys, re

if (len(sys.argv) != 3):
   print("Usage: %s <number of lines> <string>" % sys.argv[0])
   sys.exit()

try:
   n = int(sys.argv[1])
except:
   n = -1

if (n < 0):
   print("%s: argument 1 must be a non-negative integer" % sys.argv[0])

for i in range(n):
   print(sys.argv[2])
