#!/bin/bash

# Check if a folder is provided as an argument
if [ $# -eq 1 ] && [ -d "$1" ]; then
    # If a folder is provided, change to that directory
    cd "$1" || exit 1
fi

# Find cue file and wav file in the working directory
cue_file=(*.cue)
wav_file=(*.wav)

if [ ${#cue_file[@]} -gt 0 ] && [ ${#wav_file[@]} -gt 0 ]; then
	:
else
	# Prompt for user input
	read -p "Enter the cue file: " cue_file
	read -p "Enter the wav file: " wav_file
fi

# Ask user if wav and Cue files should be deleted after
read -p "Do you want to delete the original wav and Cue files after splitting? (y/n): " delete_original

# Check if cue and wav files exist
if [ ! -f "$cue_file" ] || [ ! -f "$wav_file" ]; then
    echo "Error: Cue file or wav file not found. Please check the file paths."
    exit 1
fi

# Split the wav file
shnsplit -f "$cue_file" -o wav -t "%n %t" "$wav_file"

# Delete original wav and Cue files if user confirms
if [ "$delete_original" == "y" ]
then
	rm "$cue_file"
	rm "$wav_file"
fi

echo "Splitting completed."
