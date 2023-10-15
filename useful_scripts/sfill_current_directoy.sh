#!/bin/sh

### This script completely wipes all free space on this drive.

# Get sudo.
echo "I'm going to need superuser privileges for this bit..."
sudo echo "Superuser privileges: activate!"

# Check that we really want to do this.
echo "This script will scrub all free space IN THE CURRENT DIRECTORY."
printf "Are you sure you want to proceed? (y/n)"
read answer

if [ "$answer" != "${answer#[Yy]}" ] ;then 
    echo Yes
else
    echo No
fi

# Let's get cracking...
echo "Running sfill... This may take a while..."
sudo sfill .
