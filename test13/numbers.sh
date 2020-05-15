#!/bin/sh

start=$1
end=$2

cat /dev/null > "$3"

while [ $start -le $end ]
do
   echo "$start" >> "$3"
   start=$(($start + 1))
done
