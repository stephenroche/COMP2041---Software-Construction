#!/bin/sh

for file in *
do
   if echo "$file" | egrep -vq '.htm$'
   then
      continue
   fi

   #echo "$file"

   core=`echo "$file" | sed 's/\.htm$//'`

   #echo "$core"

   if echo * | egrep -q "$core.html"
   then
      echo "$core.html exists"
      exit 1
   fi

   mv "$core.htm" "$core.html"

done
