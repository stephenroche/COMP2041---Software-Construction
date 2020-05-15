#!/bin/sh

file_list=`ls`

for file in *
do
   if echo "$file" | egrep -vq '.jpg$'
   then
      continue
   fi

   core_name=`echo "$file" | sed 's/\.jpg$//'`

   if echo "$file_list" | egrep -q "$core_name\.png"
   then
      echo "$core_name.png already exists"
      #exit 1
   fi

   convert "$file" "$core_name.png" && rm "$file"
done
