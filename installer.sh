#!/bin/sh

### This is script installs all the items in His Grace's Software Suite.

# Local constants.
STANDARD_PACKAGES="eog ffmpeg gedit gedit-plugins inkscape python3 python3-pip secure-delete"
CHROME_FRIENDLY_FILE_MANAGER="dolphin"
CHROMEBOOK_ONLY_PACKAGES="$CHROME_FRIENDLY_FILE_MANAGER eog nautilus"
OTHER_THIRD_PARTY=
HGSS_DIR=$(dirname $(realpath $0))
WALLPAPER_DST_DIR="/usr/share/backgrounds"
WALLPAPER_DST="$WALLPAPER_DST_DIR/paphos_wallpaper.jpg"
# Colours.
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
RESET="\e[0m"

#############
# SET FLAGS #
#############

chrome_os_flag=false

for flag in $@; do
    if [ $flag = "--chrome-os" ]; then
        chrome_os_flag=true
    fi
done

set -e  # Crash on the first non-zero return code.

##########
# BASICS #
##########

# Let's get cracking...
echo "$GREEN Installing HGSS... $RESET"
sudo apt update
sudo apt upgrade --yes

sudo apt install --yes $STANDARD_PACKAGES

if $chrome_os_flag; then
    sudo apt install --yes $CHROMEBOOK_ONLY_PACKAGES
fi

# Change the wallpaper.
sudo mkdir -p $WALLPAPER_DST_DIR
sudo cp "$HGSS_DIR/wallpaper.jpg" $WALLPAPER_DST || true
gsettings set org.gnome.desktop.background picture-uri \
    file:///$WALLPAPER_DST || true

####################
# INSTALL OWN CODE #
####################

cd $HOME  # Clone into the home directory.

if [ -d the-seraglio ]; then
    echo "$YELLOW Looks like we've already cloned the Seraglio. $RESET"
else
    git clone git@github.com:chancellorofpaphos/the-seraglio.git
fi

if [ -d chancery-paphos ]; then
    echo "$YELLOW Looks like we've already cloned the Chancery. $RESET"
else
    git clone git@github.com:chancellorofpaphos/chancery-paphos.git
fi

if [ -d chancery-b-paphos ]; then
    echo "$YELLOW Looks like we've already cloned the Chancery, Formulary B. $RESET"
else
    git clone git@github.com:chancellorofpaphos/chancery-b-paphos.git
fi

cd $HGSS_DIR  # A sensible precaution.

# That's it!
echo "$GREEN HGSS installed successfully. $RESET"
