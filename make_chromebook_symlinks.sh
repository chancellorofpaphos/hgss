#!/bin/sh

# This code makes some useful Chromebook symbolic links.

# Constants.
DOWNLOADS_SRC="/mnt/chromeos/MyFiles/Downloads"
DOWNLOADS_DST_STEM="$HOME/Downloads"
DOWNLODAS_DST_DIRNAME="chromeos_downloads"
PATH_TO_SIM_LINK="$DOWNLOADS_DST_STEM/$DOWNLOADS_DST_DIRNAME"

set -e

if [ ! -d $DOWNLOADS_DST_STEM ]; then
    mkdir $DOWNLOADS_DST_STEM
fi
if [ ! -d $PATH_TO_SIM_LINK ]; then
    ln -s $DOWNLOADS_SRC $PATH_TO_SIM_LINK
fi
