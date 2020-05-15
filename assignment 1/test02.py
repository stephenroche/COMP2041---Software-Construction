#!/usr/bin/python3
# put your test script here

# Test print()

import sys

sys.stdout.write('0')

print()

print(1)

a = 2
print(a)

print(a+1, end='')

print("\n", end='4\n')

b="5\n"
print(b, end = '')

c=6
print("%d comes next," % c)

print('%.0f after,'%(c+1.1)) # String formatting

d="8 is next"
print("%s,\n%d l@st" % (d, len(d))) # @ is a Perl special character

print('10 te$t finished\n', end='') # $ is also a special character
