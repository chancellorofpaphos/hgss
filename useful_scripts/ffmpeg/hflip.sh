#!/bin/sh

### This script flips a given video file horizontally.

set -e

# Constants.
PATH_TO_INPUT="input.mp4"
PATH_TO_OUTPUT="output.mp4"

# Let's get cracking...
ffmpeg -i "$PATH_TO_INPUT" -vf hflip -c:a copy "$PATH_TO_OUTPUT"
