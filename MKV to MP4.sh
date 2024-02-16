#!/bin/bash

# Accept folder as input, if none, use current working directory
folder=${1:-$(pwd)}

# Ask user if the original mkv file should be deleted
read -p "Do you want to delete the original MKV files after conversion? (y/n): " delete_original

# Find mkv files
for file in "$folder"/*.mkv
do
	# Get filename without extension
	filename=$(basename "$file" .mkv)
	
	# Convert to mp4
	convert-video "$file"
	
	# Get codec tag
	codec_tag=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_tag_string -of csv=p=0 "$filename.mp4")
	
	# If codec tag is hev1, retag with hvc1
	if [ "$codec_tag" = "hev1" ]
	then
		mv "$filename.mp4" "$filename hev1.mp4"
		ffmpeg -i "$filename hev1.mp4" -c:v copy -tag:v hvc1 -c:a copy -c:s copy -map 0 "$filename.mp4"
		rm "$filename hev1.mp4"
	fi
	
	# Delete original MKV file if requested
	if [ "$delete_original" = "y" ]
	then
		rm "$file"
	fi
done