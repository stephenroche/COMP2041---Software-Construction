#!/usr/bin/env python3

import sys, re

lines = []

FILE = open(sys.argv[1])

for line in FILE:
   line = re.sub('[aeiouAEIOU]', '', line)
   lines.append(line)

#write(''.join(lines))

wFILE = open(sys.argv[1], 'w')
wFILE.write(''.join(lines))
