#!/bin/sh

# This is a script which installs all the items in His Grace's Software Suite.
# It assumes that the actions performed in the pre-installer, i.e. setting up
# Git, have already been carried out.

# Constants.
PATH_TO_PERSONAL_ACCESS_TOKEN="$HOME/personal_access_token.txt"
PERSONAL_ACCESS_TOKEN=`cat $PATH_TO_PERSONAL_ACCESS_TOKEN`
GIT_USERNAME="chancellorofpaphos"
GIT_CREDENTIAL="https://$GIT_USERNAME:$PERSONAL_ACCESS_TOKEN@github.com"
PATH_TO_GIT_CREDENTIALS="$HOME/.git-credentials"
EMAIL="chancellorofpaphos@protonmail.com"
HGSS_DIR=$(dirname $(realpath $0))
CHROME_DEB="google-chrome-stable_current_amd64.deb"
WALLPAPER_DEST="/usr/share/backgrounds/paphos-wallpaper.jpg"

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

# Make any non-zero returns throw an error, if appropriate.
if [ $ignore_errors_flag = "false" ]; then
    set -e
fi

##############
# SET UP GIT #
##############

sudo apt install git
git config --global user.name $GIT_USERNAME
git config --global user.email $EMAIL
echo $GIT_CREDENTIAL > $PATH_TO_GIT_CREDENTIALS
git config --global credential.helper store $PATH_TO_GIT_CREDENTIALS

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

# Install PIP3 and PyLint.
sudo apt --yes install python3-pip
pip3 install pylint

# Install the extra plugins for Gedit.
sudo apt --yes install gedit-plugins

# Change the wallpaper.
sudo cp $HGSS_DIR/wallpaper.jpg $WALLPAPER_DEST || true
gsettings set org.gnome.desktop.background picture-uri file:///$WALLPAPER_DEST || true

#####################
# INSTALL OWN REPOS #
#####################

# This is where we're going to install our own repos.
cd $HOME

if [ ! -d the-seraglio ] && [ $minimal_flag = "false" ]; then
    sudo apt --yes install npm
    # Download and install the repo.
    git clone https://github.com/chancellorofpaphos/the-seraglio.git
fi

if [ ! -d chancery-b-paphos ] && [ $minimal_flag = "false" ]; then
    # Download the repo for Formulary A.
    git clone https://github.com/chancellorofpaphos/chancery-paphos.git
    # Download and install the repo for Formulary B.
    git clone https://github.com/chancellorofpaphos/chancery-b-paphos.git
fi

# A sensible precaution.
cd $HGSS_DIR

#####################
# OTHER THIRD PARTY #
#####################

# Install Inkscape.
sudo apt --yes install inkscape

# If using a Chromebook, install some basic utilities.
if $chrome_os_flag; then
    sudo apt --yes install chromium
    sudo apt --yes install eog
    sudo apt --yes install nautilus
fi

# That's it!
echo "***** HGSS installed successfully! *****"
