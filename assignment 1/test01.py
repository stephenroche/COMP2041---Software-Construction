#!/usr/bin/python3
# put your test script here

# Test for loops & nested functions

arr = [2, '3', "4", r'5']

# Trailing whitespace  -------->
for i in sorted(range(len(arr))):   
   print(arr[i]) # No following dedented line closing loop
