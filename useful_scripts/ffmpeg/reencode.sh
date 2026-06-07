#!/bin/sh

### This script re-encodes a given video file.

set -e

# Constants.
PATH_TO_INPUT="input.mp4"
PATH_TO_OUTPUT="output.mp4"

# Let's get cracking...
ffmpeg \
    -i "$PATH_TO_INPUT" \
    -c:v libx264 \
    -crf 18 \
    -preset slow \
    -c:a copy "$PATH_TO_OUTPUT"
