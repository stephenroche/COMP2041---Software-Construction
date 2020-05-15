#!/bin/sh

for c_file in $@
do
   for incl_file in `egrep '^#include +"' "$c_file" | sed -r 's/.*"(.+)".*/\1/'`
   do
      #echo "$incl_file"
      if [ ! -e "$incl_file" ]
      then
         echo "$incl_file included into $c_file does not exist"
      fi
   done 
done
