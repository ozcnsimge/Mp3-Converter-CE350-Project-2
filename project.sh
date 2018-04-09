#!/bin/bash

echo list of audio files:

for i in $(ls .)
do
   if [ -n $(file $i | grep [aA]udio | awk 'BEGIN {FS=":"} {print $1}') ];
   then
      asd+=("$(file $i | grep [aA]udio | awk 'BEGIN {FS=":"} {print $1}')")
   fi
done

osascript osaex.scpt ${asd[@]}
