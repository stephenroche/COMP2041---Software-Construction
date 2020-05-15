#!/bin/sh

while read student
do
   student_no=`echo $student | sed "s/ .*//"`
   mark=`egrep "$student_no" Marks | cut -d' ' -f2`
   name=`echo $student | cut -d' ' -f2-`
   echo $mark $name >> $$.txt
done < Students

sort -k2 $$.txt
rm $$.txt
