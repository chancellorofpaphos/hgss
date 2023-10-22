#!/bin/sh

### This code concatenates two video files.

# Constants.
PATH_TO_INPUT_LEFT="left.mp4"
PATH_TO_INPUT_RIGHT="right.mp4"
PATH_TO_LIST="video_list.txt"
PATH_TO_OUTPUT="output.mp4"

# Crash on the first non-zero exit code.
set -e

# Make video list.
rm -f $PATH_TO_LIST
touch $PATH_TO_LIST
echo "file '$PATH_TO_INPUT_LEFT'" >> $PATH_TO_LIST
echo "file '$PATH_TO_INPUT_RIGHT'" >> $PATH_TO_LIST

# Let's get cracking...
ffmpeg -f concat -safe 0 -i $PATH_TO_LIST -c copy $PATH_TO_OUTPUT

# Tidy up.
rm $PATH_TO_LIST
