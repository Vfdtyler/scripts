#!/bin/bash

# Accept folder as input, if none, use current working directory
folder=${1:-$(pwd)}

# Ask user if the original wav files should be deleted
read -p "Do you want to delete the original wav files after conversion? (y/n): " delete_original

cd "$folder"

for file in "$folder"/*.wav
do
    # Extract filename without extension
	filename=$(basename "$file" .wav)
	
	# Convert to MP3
	ffmpeg -i "$file" -q:a 0 -ar 44100 "$filename.mp3"
	
	# Delete original wav file if user confirms
    if [ "$delete_original" == "y" ]
	then
		rm "$file"
	fi
done