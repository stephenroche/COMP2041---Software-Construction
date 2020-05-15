#!/usr/bin/python3
# put your demo script here

# Adapted from exponential_concatenation.py (writen by andrewt@cse.unsw.edu.au)
# Creates a string of size 2^n by concatenation

import sys

if len(sys.argv) != 3:
    sys.stdout.write("Usage: %s <string> <n>\n" % sys.argv[0]) # accessing the name of the program (sys.argv[0])
    sys.exit(1) # implemented exit() function
n = 0
string = sys.argv[1]

while n < int(sys.argv[2]):
    string = string * 2 # string multiplication
    n += 1

print("String of 2^%d = %d %s's created:\n" % (n, len(string)/len(sys.argv[1]), sys.argv[1])) # functions within string formatting
print(string)
