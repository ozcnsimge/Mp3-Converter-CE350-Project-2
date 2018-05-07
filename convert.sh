#!/bin/bash

function convertFlacToMp3 {

  #Crop the name of the file (without the extension).

  croppedName=$(echo $1 | awk -F\. '{print $1}')

  ffmpeg -i $1 -y -b:a $2 -map_metadata 0 -id3v2_version 3 $croppedName.mp3
}

function convertOggToMp3 {

  #Crop the name of the file (without the extension).

  croppedName=$(echo $1 | awk -F\. '{print $1}')

  # If selected file is ogg, first decrypt to wav and the encryp to mp3.

  ffmpeg -i $1 -y $croppedName.wav

  ffmpeg -i $croppedName.wav -y -vn -ar 44100 -ac 2 -b:a $2 -f mp3 $croppedName.mp3
  # FFREPORT=file=ffreport.log:level=32 ffmpeg -i input output
}


# Display message with option to cancel.

dialog --title "Mp3 Converter" --msgbox "Please press <enter> to see audio files in the current directory or <Esc> to cancel." 10 30

if [ "$?" != "0" ]
then

  # Display an info message.

  dialog --title "Mp3 Converter" --msgbox "Action was canceled at your request." 10 30
else

  #Fetch audio files in the current directory to a list.

  let j=1
  for i in $(ls .)
  do
     if [ $(file $i | grep audio | awk 'BEGIN {FS=":"} {print $1}') ];
     then
       list+=("$(file $i | grep audio | awk 'BEGIN {FS=":"} {print $1}')")
       list+=($j)
       let j++
     fi
  done


  # Display a menu box and assign selection to a variable.

  selectedItem=$(dialog --stdout --title "Mp3 Converter" --menu "Choose a file:" 10 30 3 \ ${list[@]})


  # If selected file is ogg, convert it to mp3.

  if [ $(echo $selectedItem | grep ogg$) ];
  then

     bitrate=$(dialog --stdout --title "Mp3 Converter" --menu "Choose the desired bitrate:" 10 30 3 \ 96k 1 128k 2 160k 3 256k 4 320k 5)

     convertOggToMp3 $selectedItem $bitrate

     if [ "$?" = "0" ]
     then
       dialog --title "Mp3 Converter" --msgbox "File successfully converted. Press <Enter> to exit" 10 30
     fi


  # If selected file is flac, convert it to mp3.

  elif [ $(echo $selectedItem | grep flac$) ];
  then

     bitrate=$(dialog --stdout --title "Mp3 Converter" --menu "Choose the desired bitrate:" 10 30 3 \ 96k 1 128k 2 160k 3 256k 4 320k 5)

     convertFlacToMp3 $selectedItem $bitrate

     if [ "$?" = "0" ]
     then
       dialog --title "Mp3 Converter" --msgbox "File successfully converted. Press <Enter> to exit" 10 30
     fi


  # Display an info box.

  else
    dialog --title "Mp3 Converter" --msgbox "This format is not supported. Press <Enter> to exit" 10 30
  fi
fi
clear
