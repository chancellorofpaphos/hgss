#!/bin/sh

# This code makes some useful Chromebook symbolic links.

# Constants.
DOWNLOADS_SRC="/mnt/chromeos/MyFiles/Downloads"
DOWNLOADS_DST_STEM="$HOME/Downloads"
DOWNLODAS_DST_DIRNAME="chromeos_downloads"

set -e

mkdir $DOWNLOADS_DST_STEM
ln -s $DOWNLOADS_SRC $DOWNLOADS_DST_STEM/$DOWNLOADS_DST_DIRNAME
