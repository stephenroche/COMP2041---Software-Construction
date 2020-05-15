#!/bin/sh

counter=0

if [ $# -ne 2 ]
then
   echo "Usage: $0 <number of lines> <string>"
   exit 1
fi

if (echo $1 | egrep -q -v '^[0-9]+$')
then
   echo "$0: argument 1 must be a non-negative integer"
   exit 1
fi

while [ $counter -lt $1 ]
do
   echo $2
   counter=$(($counter + 1))
done
