#!/bin/sh

### This code concatenates two video files.

# Constants.
PATH_TO_INPUT_LEFT="left.mp4"
PATH_TO_INPUT_RIGHT="right.mp4"
PATH_TO_OUTPUT="output.mp4"

# Crash on the first non-zero exit code.
set -e

PATH_TO_LIST=$(mktemp)
trap 'rm -f "$PATH_TO_LIST"' EXIT

# Make video list.
printf "file '%s'\n" "$PATH_TO_INPUT_LEFT" >> "$PATH_TO_LIST"
printf "file '%s'\n" "$PATH_TO_INPUT_RIGHT" >> "$PATH_TO_LIST"

# Let's get cracking...
ffmpeg -f concat -safe 0 -i "$PATH_TO_LIST" -c copy "$PATH_TO_OUTPUT"
