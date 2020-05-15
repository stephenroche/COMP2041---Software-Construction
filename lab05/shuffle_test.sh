#!/bin/sh

program='./shuffle.pl'

for i in 0 1 1000
do
   seq $i | sort > ordered0
   seq $i | "$program" > shuffled1
   cat shuffled1 | sort > ordered1
   seq $i | "$program" > shuffled2

   if (! diff ordered0 ordered1 > /dev/null)
   then
      echo "You fucked up the input"
      worked='false'
   fi

   if [ $i -ge 50 ] && (diff shuffled1 shuffled2 > /dev/null)
   then
      echo "Your shuffle isn't random"
      worked='false'
   fi
done

if $worked
then
   echo "Good work :)"
fi

rm ordered* shuffled*
