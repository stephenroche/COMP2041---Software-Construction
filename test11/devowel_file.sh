#!/bin/sh

file=`cat "$1" | sed 's/[aeiou]//gi'`

echo "$file" > "$1"
