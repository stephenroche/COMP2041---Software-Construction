#!/bin/sh

echo -n "Small files:"

for file in *
do
   if [ -f $file ]
   then
      size=`wc -l $file | cut -d' ' -f1`
      if [ $size -lt 10 ]
      then
         echo -n " $file"
      fi
   fi
done

echo ""

echo -n "Medium-sized files:"

for file in *
do
   if [ -f $file ]
   then
      size=`wc -l $file | cut -d' ' -f1`
      if [ $size -ge 10 -a $size -lt 100 ]
      then
         echo -n " $file"
      fi
   fi
done

echo ""

echo -n "Large files:"

for file in *
do
   if [ -f $file ]
   then
      size=`wc -l $file | cut -d' ' -f1`
      if [ $size -ge 100 ]
      then
         echo -n " $file"
      fi
   fi
done

echo ""

