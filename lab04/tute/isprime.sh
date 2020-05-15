#!/bin.sh

for arg in "$@"
do
   for num in "seq 2 $(( $arg - 1 ))"
   do
      if [ $(( $arg % $num )) -eq 0 ]
      then
         echo "$arg is not prime ($num)"
         break
      fi
   done
done
