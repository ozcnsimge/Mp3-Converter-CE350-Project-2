#!/bin/sh

# Display message with option to cancel
dialog --title "Mp3 Converter" --msgbox "Please press <enter> to see convertable audio files in the current directory or <Esc> to cancel." 10 30
# Return status of non-zero indicates cancel

if [ "$?" != "0" ]
then
  dialog --title "Mp3 Converter" --msgbox "Backup was canceled at your
  request." 10 30
else
  #Fetch audio files to a list
  let j=1
  for i in $(ls .)
  do
     if [ $(file $i | grep [aA]udio | awk 'BEGIN {FS=":"} {print $1}') ];
     then
       list+=("$(file $i | grep [aA]udio | awk 'BEGIN {FS=":"} {print $1}')")
       list+=($j)
       let j++
     fi
  done

  selectedItem=$(dialog --stdout --title "Mp3 Converter" --menu "Choose a file:" 10 30 3 \ ${list[@]})
  itemName=$(echo $selectedItem | awk -F\. '{print $1}')



  if [ "$?" = "0" ]
    then
    dialog --title "Mp3 Converter" --infobox "Backup in \ process..." 10 30

    if [ $(echo $selectedItem | grep ogg$) ];
    then
       echo you chose an ogg file
       ffmpeg -i $selectedItem $itemName.wav
       ffmpeg -i $itemName.wav -vn -ar 44100 -ac 2 -ab 192k -f mp3 $itemName.mp3
    elif [ $(echo $selectedItem | grep flac$) ];
    then
       echo you chose a flac file
       ffmpeg -i $selectedItem -ab 320k -map_metadata 0 -id3v2_version 3 $itemName.mp3
    elif [ $(echo $selectedItem | grep mp3$) ];
    then
       echo you chose an mp3 file
    else
       echo please choose a file
    fi

  else
    # Action failed
    dialog --title "Mp3 Converter" --msgbox "Action failed \ -- Press <Enter>
    to exit" 10 30
  fi
fi
clear
