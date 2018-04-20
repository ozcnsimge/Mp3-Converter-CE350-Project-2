#!/bin/bash

for i in $(ls .)
do
   if [ -n $(file $i | grep [aA]udio | awk 'BEGIN {FS=":"} {print $1}') ];
   then
      asd+=("$(file $i | grep [aA]udio | awk 'BEGIN {FS=":"} {print $1}')")
   fi
done

selectedItem=$(osascript osaex.scpt ${asd[@]})

if [ $(echo $selectedItem | grep ogg$) ];
then
   echo you chose an ogg file
   ffmpeg -i $selectedItem $selectedItem.wav
   ffmpeg -i $selectedItem.wav -vn -ar 44100 -ac 2 -ab 192k -f mp3 $selectedItem.mp3
elif [ $(echo $selectedItem | grep flac$) ];
then
   echo you chose a flac file
   ffmpeg -i $selectedItem -ab 320k -map_metadata 0 -id3v2_version 3 $selectedItem.mp3
elif [ $(echo $selectedItem | grep mp3$) ];
then
   echo you chose an mp3 file
else
   echo please choose a file
fi
