#!/usr/bin/env python3

import sys, re

for line in sys.stdin:
   words = re.findall(r'\S+', line)
   print(' '.join(sorted(words)))
