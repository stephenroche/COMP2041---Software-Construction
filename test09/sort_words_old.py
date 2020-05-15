#!/usr/bin/env python3

import sys, re

for line in sys.stdin:
   line = re.sub(r'\s*\n$', '', line)
   words = re.split(r'\s+', line)
   print(' '.join(sorted(words)))
