#!/bin/sh

### This is script installs all the items in His Grace's Software Suite.

# Import constants.
. $(dirname $0)/constants.sh

#############
# SET FLAGS #
#############

chrome_os_flag=false
ignore_errors_flag=false
minimal_flag=false

for flag in $@; do
    if [ $flag = "--chrome-os" ]; then
        chrome_os_flag=true
    elif [ $flag = "--ignore-errors" ]; then
        ignore_errors_flag=true
    elif [ $flag = "--minimal" ]; then
        minimal_flag=true
    fi
done

# Throw an error on the first non-zero return code, if appropriate.
if ! $ignore_errors_flag; then
    set -e
fi

##############
# SET UP GIT #
##############

sudo apt install git
git config --global user.name $GIT_USERNAME
git config --global user.email $EMAIL
sh $HGSS_DIR/renew_git_credentials.sh

##########
# BASICS #
##########

# Let's get cracking...
sudo apt update
sudo apt --yes upgrade

# Install Google Chrome.
if $chrome_os_flag; then
    sh $HGSS_DIR/make_chromebook_symlinks.sh
else
    wget https://dl.google.com/linux/direct/$CHROME_DEB
    sudo dpkg -i $CHROME_DEB
    rm $CHROME_DEB
fi

# Install PIP.
sudo apt --yes install python3-pip

# Install the extra plugins for Gedit.
sudo apt --yes install gedit-plugins

# Change the wallpaper.
sudo cp $HGSS_DIR/wallpaper.jpg $WALLPAPER_DEST || true
gsettings set org.gnome.desktop.background picture-uri file:///$WALLPAPER_DEST || true

#####################
# INSTALL OWN REPOS #
#####################

# This is where we're going to install our own repos.
if $minimal_flag; then
    echo "Minimal flag is TRUE. Skipping installing own repos..."
else
    cd $HOME

    if [ ! -d the-seraglio ]; then
        sudo apt --yes install npm
        # Download and install the repo.
        git clone https://github.com/chancellorofpaphos/the-seraglio.git
    fi

    if [ ! -d chancery-b-paphos ]; then
        # Download the repo for Formulary A.
        git clone https://github.com/chancellorofpaphos/chancery-paphos.git
        # Download and install the repo for Formulary B.
        git clone https://github.com/chancellorofpaphos/chancery-b-paphos.git
    fi

    # A sensible precaution.
    cd $HGSS_DIR
fi

#####################
# OTHER THIRD PARTY #
#####################

# Install srm, sfill, etc.
sudo apt --yes install secure-delete

# Install Inkscape.
sudo apt --yes install inkscape

# If using a Chromebook, install some basic utilities.
if $chrome_os_flag; then
    sudo apt --yes install chromium eog nautilus
fi

# That's it!
echo "***** HGSS installed successfully! *****"
