#!/usr/bin/python3
# put your demo script here

# has to be run as $ ./pypl.pl demo01.py > demo01.pl
#                  $ perl demo01.pl

# Performs and prints various calculations involving two numbers

import sys

print("Enter x:", end='\nx = ')
x = float(sys.stdin.readline()) # implemented float()
print("Enter y:", end='\ny = ')
y = float(sys.stdin.readline())

calcs = {}
calcs['sum'] = x + y
calcs['product'] = x * y
calcs['power'] = x ** y
calcs['floor division'] = x // y # floor division (works with negatives)
calcs['sum of squares'] = x ** 2 + y ** 2

print("There are %d calculations:" % len(calcs.keys()))
# string formatting with nested len() and .keys() functions

for key in sorted(calcs.keys()): # sorted(), multiline for loops
   print("The %14s of %.2f and %.2f is %8.2f" % (key, x, y, calcs[key]))
# more complex string formatting and accessing hash values
