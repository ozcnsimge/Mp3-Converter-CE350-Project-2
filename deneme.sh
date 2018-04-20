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
       list+=("$j")
       list+=("$(file $i | grep [aA]udio | awk 'BEGIN {FS=":"} {print $1}')")
       let j++
     fi
  done

  dialog --title "Mp3 Converter" --menu "Choose a file:" 10 30 3 \ ${list[@]}

  if [ "$?" = "0" ]
    then
    dialog --title "Mp3 Converter" --infobox "Backup in \ process..." 10 30
  else
    # Action failed
    dialog --title "Mp3 Converter" --msgbox "Action failed \ -- Press <Enter>
    to exit" 10 30
  fi
fi
clear
