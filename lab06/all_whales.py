#!/usr/bin/env python3

import sys, re

nPods = {}
nIndv = {}

while 1:
   line = sys.stdin.readline()
   if not line:
      break

   whale = str.lower(line)
   whale = re.sub('^\d+ +', '', whale)
   whale = re.sub('s?\s*$', '', whale)
   whale = re.sub(' +', ' ', whale)
   nInPod = int(re.sub(' .*', '', line))

   nPods[whale]= nPods.get(whale,0) + 1

   try:
      nIndv[whale] += nInPod
   except:
      nIndv[whale] = nInPod

for whale in sorted(nPods.keys()):
   print("%s observations: %d pods, %d individuals" % (whale, nPods[whale], nIndv[whale]))
