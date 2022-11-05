#!/bin/bash

read -r -p "Delete FLAC files? [y/N] " response

for i in *.flac
do
	ffmpeg -i "$i" -q:a 0 -ar 44100 "${i%.*}.mp3"
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
	rm "$i"
fi
done