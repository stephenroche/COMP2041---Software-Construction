#!/bin/sh

wget -q -O- "http://www.handbook.unsw.edu.au/vbook2017/brCoursesByAtoZ.jsp?StudyLevel=Undergraduate&descr=All" "http://www.handbook.unsw.edu.au/vbook2017/brCoursesByAtoZ.jsp?StudyLevel=Postgraduate&descr=All" | sed -r -n 's/^.*\/([A-Z]{4}[0-9]{4})\.html\">(.*[^ ]) *<\/A>.*$/\1 \2/p' | sort | uniq | egrep "^$1"

#text=`wget -q -O- "http://www.handbook.unsw.edu.au/vbook2017/brCoursesByAtoZ.jsp?StudyLevel=Undergraduate&descr=All" "http://www.handbook.unsw.edu.au/vbook2017/brCoursesByAtoZ.jsp?StudyLevel=Postgraduate&descr=All" `

#echo "$text" | sed -r -n 's/^.*\/([A-Z]{4}[0-9]{4})\.html\">(.*[^ ]) *<\/A>.*$/\1 \2/p' | sort | uniq | egrep "^$1"
