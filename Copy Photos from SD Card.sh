#!/bin/bash

# Define paths
source="/Volumes/EOS_DIGITAL/DCIM/100CANON"
pics_folder="$HOME/Desktop/Pictures"
raw_folder="$HOME/Desktop/Pictures/Raw"

# Create destination directories if they don't exist
mkdir -p "$pics_folder"
mkdir -p "$raw_folder"

# Copy JPEG files
find "$source" -name "*.JPG" -exec cp {} "$pics_folder" \;

# Copy RAW files
find "$source" -name "*.CR2" -exec cp {} "$raw_folder" \;
