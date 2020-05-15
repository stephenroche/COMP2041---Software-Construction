#!/usr/bin/env python3

import sys, re

for line in sys.stdin:
   words = re.split('\s+', line)
   out = []

   for word in words:
      count = {}
      lword = word.lower()

      for letter in lword:
         n = count[letter] = count.get(letter, 0) + 1

      toPrint = 1

      for letter in count.keys():
         if count[letter] != n:
            toPrint = 0

      if toPrint:
         out.append(word)

   print(' '.join(out))
