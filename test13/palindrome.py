#!/usr/bin/env python3

import sys, re

string = sys.argv[1].lower()
string = re.sub('\W', '', string)
rstring = string[::-1]


if (string == rstring):
	print("True")
else:
	print("False")
