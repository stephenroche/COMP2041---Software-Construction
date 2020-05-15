#!/bin/sh

text="`wget -q -O- 'https://en.wikipedia.org/wiki/Triple_J_Hottest_100?action=raw' | cat -n`"

albums=`echo "$text" | sed -nr 's/\| ?style="text-align:center; vertical-align:middle;"\|.{3}\[\[(Triple J Hottest 100, [0-9]{4})\|[0-9]{4}.*$/\1/p'`

#echo "$text" ----------------------------
#echo "$albums"

if [ $# -ne 2 ]
then
   echo failure
   exit 1
fi

mkdir -p "$2"
cd "$2"

for year in {1990..2020}
do
   album_name=`echo "$albums" | egrep "$year" | cut -c8-`
   if [ "$album_name" = '' ]
   then
      continue
   fi
   mkdir -p "$album_name"
   cd "$album_name"
   
   album_line=`echo "$albums" | egrep "$year" | cut -c1-7 | sed 's/ //g'`
   #echo "$album_line"

   for track in {1..10}
   do
      #echo line=$line
      full_song=`echo "$text" | sed -n "$((track + album_line + 1))"p | sed -r 's/"?\[\[([^|\[]+\||)([^|\[]+)\]\]"?/\2/g' | cut -c9- | sed 's/^ //' | sed 's/[^\x00-\x7F][^\x00-\x7F][^\x00-\x7F]/-/g' | sed 's/"//g'`
      #echo "full_song=$full_song"
      title=`echo "$full_song" | sed -r 's/^.* - (.*)$/\1/' | sed {'s/ $//g; s/\//-/g'}`
      #echo "title=$title"
      artist=`echo "$full_song" | sed -r 's/^(.*) - .*$/\1/'`
      #echo "artist=$artist"
      name="$track - $title - $artist".mp3
      #echo "$name"
      cp ../../"$1" "$name"
      #chmod 644 "$name"
   done
   cd .. 
done
