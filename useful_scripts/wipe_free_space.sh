#!/bin/sh

### This script completely wipes all free space on this drive.

# Crash on first non-zero return code.
set -e

# Process arguments.
if [ $# -eq 0 ]; then
    echo "Usage: sh wipe_free_space.sh path/to/folder"
    exit 1
fi
path_to_folder_to_scrub=$1

# Get sudo.
echo "I'm going to need superuser privileges for this bit..."
sudo echo "Superuser privileges: activate!"

# Let's get cracking...
echo "Running sfill... (Don't panic if this takes FOREVER.)"
sudo sfill $path_to_folder_to_scrub
