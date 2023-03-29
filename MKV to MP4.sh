#!/bin/bash

folder_path=${1:-$(pwd)}
cd "$folder_path"
read -r -p "Delete MKV files? [y/N] " response

for i in *.mkv
do
	convert-video "$i"
	if
		ffprobe -v error -select_streams v:0 -show_entries stream=codec_tag_string -of default=noprint_wrappers=1:nokey=1 "${i%.*}.mp4" | grep hev1 > /dev/null
	then
		mv "${i%.*}.mp4" "${i%.*} hev1.mp4"
		ffmpeg -i "${i%.*} hev1.mp4" -c:v copy -tag:v hvc1 -c:a copy -c:s copy -map 0 "${i%.*}.mp4"
		rm "${i%.*} hev1.mp4"
	fi
	if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
	then
		rm "$i"
	fi
done
