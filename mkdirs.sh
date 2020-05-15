#!/bin/sh

count=3

while [ $count -le 9 ]
do
   mkdir "lab0$count"
   count=$((1 + $count))
done
