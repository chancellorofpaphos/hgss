#!/bin/sh

### This script installs all the items in His Grace's Software Suite.

set -e  # Crash on the first non-zero return code.

# Local constants.
STANDARD_PACKAGES="ffmpeg gedit gedit-plugins git inkscape python3 python3-pip secure-delete veracrypt"
HGSS_DIR=$(dirname "$(realpath "$0")")
REPOS_TO_CLONE="chancery-paphos chancery-b-paphos the-seraglio"
WALLPAPER_DST_DIR="/usr/share/backgrounds"
WALLPAPER_DST="$WALLPAPER_DST_DIR/paphos_wallpaper.jpg"
# Colours.
GREEN="$(printf '\033[1;32m')"
YELLOW="$(printf '\033[1;33m')"
RESET="$(printf '\033[0m')"

##########
# BASICS #
##########

# Let's get cracking...
echo "$GREEN Installing HGSS... $RESET"
sudo apt update
sudo apt upgrade --yes

sudo apt install --yes $STANDARD_PACKAGES

# Change the wallpaper.
sudo mkdir -p "$WALLPAPER_DST_DIR"
sudo cp "$HGSS_DIR/wallpaper.jpg" "$WALLPAPER_DST" || true
gsettings set org.gnome.desktop.background picture-uri \
    file:///$WALLPAPER_DST || true

####################
# INSTALL OWN CODE #
####################

original_dir=$(pwd)
cd "$HOME"  # Clone into the home directory.

for repo in $REPOS_TO_CLONE; do
    if [ -d "$repo" ]; then
        echo "$YELLOW Looks like we've already cloned $repo. $RESET"
    else
        git clone git@github.com:chancellorofpaphos/$repo.git
    fi
done

cd "$original_dir"

# That's it!
echo "$GREEN HGSS installed successfully. $RESET"
