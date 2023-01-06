#!/bin/sh

### This code defines some constants used across the scripts.

# Make any non-zero returns throw an error, if appropriate.
if $ignore_errors_flag; then
    set -e
fi

# Misc.
EMAIL="chancellorofpaphos@protonmail.com"
HGSS_DIR=$(dirname $(realpath $0))
CHROME_DEB="google-chrome-stable_current_amd64.deb"
WALLPAPER_DEST="/usr/share/backgrounds/paphos-wallpaper.jpg"

# Git.
PATH_TO_PERSONAL_ACCESS_TOKEN="$HOME/personal_access_token.txt"
PERSONAL_ACCESS_TOKEN=`cat $PATH_TO_PERSONAL_ACCESS_TOKEN`
GIT_USERNAME="chancellorofpaphos"
GIT_CREDENTIAL="https://$GIT_USERNAME:$PERSONAL_ACCESS_TOKEN@github.com"
PATH_TO_GIT_CREDENTIALS="$HOME/.git-credentials"
