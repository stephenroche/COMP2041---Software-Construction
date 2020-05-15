#!/bin/sh

for image in "$@"
do 
   display "$image"
   read -p 'Address to e-mail this image to? ' address
   if [ -z $address ]
   then
      continue
   fi

   read -p 'Message to accompany image? ' message

   echo "message" | mutt -s "check out this sick $image" -e 'set copy=no' -a "$image" -- "$address"
done
