#!/bin/bash

source="/Users/Tyler/Pictures/iPhone"
output="/Users/Tyler/Dropbox (Maestral)/Tyler Evans/Photos/iPhone"

for file in "$source"/*
do
	ext="${file##*.}"
	model=$(exiftool -model -s3 "$file")
	filetype=$(exiftool -mimetype -s3 "$file")
	
	if [[ $filetype == video/* ]];
	then
		year=$(exiftool -creationdate -s3 -d "%Y" "$file")
		month=$(exiftool -creationdate -s3 -d "%m" "$file")
		date=$(exiftool -creationdate -s3 -d "%Y-%m-%d %H-%M-%S" "$file")
	else
		year=$(exiftool -createdate -s3 -d "%Y" "$file")
		month=$(exiftool -createdate -s3 -d "%m" "$file")
		date=$(exiftool -createdate -s3 -d "%Y-%m-%d %H-%M-%S" "$file")
	fi
	
	# Check if there are multiple files with the same creation date
	duplicate_count=$(ls "$output/$year/$month/$date"* 2>/dev/null | wc -l)
	
	if [[ $model = *"iPhone"* ]]
	then
		mkdir -p "$output/$year/$month"
		
		# Include the counter starting from 2 if there are duplicates
		if [ $duplicate_count -gt 0 ]
		then
			unique_identifier=$((duplicate_count + 1))
			filename="$date $unique_identifier.$ext"
		else
			filename="$date.$ext"
		fi
		
		mv "$file" "$output/$year/$month/$filename"
	fi
done
