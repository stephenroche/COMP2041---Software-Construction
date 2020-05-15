#!/usr/bin/python3
# put your demo script here

# Sorts arguments lexicographically

import sys

sys.argv.pop(0)
sortedArgs = []

while len(sys.argv) > 0:
   next = -1
   for i in range(len(sys.argv)):
      if next == -1 or sys.argv[i] < sys.argv[next]: # String comparison
         next = i

   # Add the next 'smallest' argument to the sorted list
   sortedArgs.append(sys.argv.pop(next)) # Nested functions, pop() with argument

print(r'Lexicographically sorted arguments:') # Raw strings

print(r', '.join(sortedArgs)) # Raw string, .join()
