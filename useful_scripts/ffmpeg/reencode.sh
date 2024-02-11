#!/bin/sh

### This script cuts a given video file.

# Constants.
PATH_TO_INPUT="input.mp4"
PATH_TO_OUTPUT="output.mp4"
START="00:00:00"
STOP="00:00:00"

# Let's get cracking...
ffmpeg \
    -i $PATH_TO_INPUT \
    -c:v libx264 \
    -crf 18 \
    -preset slow \
    -c:a copy $PATH_TO_OUTPUT
