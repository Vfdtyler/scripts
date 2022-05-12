#!/bin/bash

for i in *.mp4;
do
	if
		ffprobe -v error -select_streams v:0 -show_entries stream=codec_tag_string -of default=noprint_wrappers=1:nokey=1 "$i" | grep hev1 > /dev/null
	then
		mv "$i" "${i%.*} hev1.mp4"
		ffmpeg -i "${i%.*} hev1.mp4" -c:v copy -tag:v hvc1 -c:a copy -c:s copy -map 0 "$i"
		rm "${i%.*} hev1.mp4"
	fi
done