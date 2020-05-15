#!/bin/sh

for image in "$@"
do 
   date=`stat -c %y "$image" | egrep -o '^[^.]+'`
   convert -gravity south -pointsize 36 -draw "text 0,10 '$date'" "$image" temp.jpg && mv -f temp.jpg "$image"

   touch -d "$date" "$image"
done
