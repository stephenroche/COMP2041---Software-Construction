#!/bin/sh

for full_album in "$@"
do
   #echo "full_album = $full_album"

   album=`echo "$full_album" | sed -r 's/^.*\/([^/]+)\/?$/\1/'`
   #echo "album = $album"

   year=`echo "$full_album" | egrep -o '[0-9]+\/?$' | cut -c1-4`
   #echo "year = $year"

   for full_song in "$full_album"/*
   do
      #echo ''
      #echo "full_song = $full_song"
      song=`echo "$full_song" | sed -r 's/^.*\/[0-9]+ - (.+) - .*$/\1/'`
      #echo "song = $song"

      track=`echo "$full_song" | sed -r 's/^.*\/([0-9]+) - .+ - .*$/\1/'`
      #echo "track = $track"

      artist=`echo "$full_song" | sed -r 's/^.* - .+ - (.+)\.mp3$/\1/'`
      #echo "artist = $artist"

      id3 -t "$song" -T "$track" -a "$artist" -A "$album" -y "$year" "$full_song" > /dev/null
   done
done
