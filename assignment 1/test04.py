#!/usr/bin/python3
# put your test script here

# Test multidimensional lists and dicts

arr = [0,1,2,3]
arr[0] = [4,5,6]

print(arr[0][2])


dic = {}
dic['firstKey'] =  {'one': 1, 'two': 2, 'three': 3}

for key in sorted(dic['firstKey'].keys()):
   print(dic['firstKey'][key])
