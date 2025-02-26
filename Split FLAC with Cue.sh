#!/bin/bash

# Check if a folder is provided as an argument
if [ $# -eq 1 ] && [ -d "$1" ]; then
    # If a folder is provided, change to that directory
    cd "$1" || exit 1
fi

# Find cue file and flac file in the working directory
cue_file=(*.cue)
flac_file=(*.flac)

if [ ${#cue_file[@]} -gt 0 ] && [ ${#flac_file[@]} -gt 0 ]; then
	:
else
	# Prompt for user input
	read -p "Enter the cue file: " cue_file
	read -p "Enter the FLAC file: " flac_file
fi

# Ask user if FLAC and Cue files should be deleted after
read -p "Do you want to delete the original FLAC and Cue files after splitting? (y/n): " delete_original

# Check if cue and FLAC files exist
if [ ! -f "$cue_file" ] || [ ! -f "$flac_file" ]; then
    echo "Error: Cue file or FLAC file not found. Please check the file paths."
    exit 1
fi

# Split the FLAC file
shnsplit -f "$cue_file" -o flac -t "%n %t" "$flac_file"

# Delete original FLAC and Cue files if user confirms
if [ "$delete_original" == "y" ]
then
	rm "$cue_file"
	rm "$flac_file"
fi

echo "Splitting completed."
