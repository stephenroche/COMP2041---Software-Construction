#!/bin/sh

for file in *.htm
do
   new_filename="$file"l
   
   if [ ! -e "$new_filename" ]
   then
      mv "$file" "$new_filename"
   else
      echo "$new_filename" exists
      exit 1
   fi
done
