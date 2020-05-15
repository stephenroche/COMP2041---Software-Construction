#!/usr/bin/python3
# put your demo script here

# Echos back whatever you type

import sys

text = []

for line in sys.stdin: # Iterates over sys.stdin
   words = line.split(' ') # Implemented .split()
   words = r' '.join(words) # Words variable changed from a list to a string
   text += words # List concatenation

toPrint = ''.join(text) # .join()

print("You wrote:\n--Start--\n%s--End--\n" % toPrint, end='')
