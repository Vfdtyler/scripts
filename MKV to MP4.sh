#!/bin/bash

# Accept folder as input, if none, use current working directory
folder=${1:-$(pwd)}

# Ask user if the original mkv file should be deleted
read -p "Do you want to delete the original MKV files after conversion? (y/n): " delete_original

# Find mkv files
for file in "$folder"/*.mkv; do
    if [ -e "$file" ]; then
        # Extract filename without extension
		filename_with_ext=$(basename -- "$file")
		filename="${filename_with_ext%.mkv}"

        # Convert to mp4
        convert-video "$file"
		
		# If HEVC file tagged with hev1, retag with hvc1
		if
			ffprobe -v error -select_streams v:0 -show_entries stream=codec_tag_string -of default=noprint_wrappers=1:nokey=1 "$filename.mp4" | grep hev1 > /dev/null
		then
			mv "$filename.mp4" "$filename hev1.mp4"
			ffmpeg -i "$filename hev1.mp4" -c:v copy -tag:v hvc1 -c:a copy -c:s copy -map 0 "$filename.mp4"
			rm "$filename hev1.mp4"
		fi

        # Delete the original mkv file if user confirms
        if [ "$delete_original" == "y" ]; then
            rm "$file"
            echo "Original file '$file' deleted."
        fi
    else
        echo "No MKV files found in the specified directory."
        exit 1
    fi
done

echo "Conversion completed."