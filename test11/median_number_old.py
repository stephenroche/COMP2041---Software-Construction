#!/usr/bin/env python3

import sys

#sArgs = sorted(sys.argv[1:])

sArgs = sys.argv[1:]
sArgs.sort(key=int)

#print (int((len(sArgs)-1)/2))
print (sArgs[int((len(sArgs)-1)/2)])
