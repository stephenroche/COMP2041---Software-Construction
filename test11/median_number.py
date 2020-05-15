#!/usr/bin/env python3

import sys

sArgs = sorted(sys.argv[1:], key=int)

#sArgs = sys.argv[1:]
#sArgs.sort(key=int)

print (sArgs[len(sArgs) // 2])
