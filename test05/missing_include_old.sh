#!/bin/sh

for arg in $@
do
   #echo "$arg"

   for included in `cat "$arg" | sed -rn 's/^.*#include +"(.+)".*$/\1/p'`
   do
      #echo "$included"

      new_included=`echo "$included" | sed 's/\./\\\./g'`
      #echo "$new_included"

      #if ls | egrep "$new_inculded"
      #then
      #   echo "$included included into $arg does not exist"
      #fi

      found=false

      for file in *
      do
         if echo "$file" | egrep -q "^$new_included$"
         then
            found=true
         fi
      done

      if ! "$found"
      then
         echo "$included included into $arg does not exist"
      fi

      #echo ----------
   done
done
