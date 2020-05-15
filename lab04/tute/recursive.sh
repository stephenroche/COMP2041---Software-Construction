#!/bin/sh

if [ $1 -le $2 ]
then
   echo $1
   . ./recursive.sh $(($1 + 1)) $2
   #echo $1
fi
