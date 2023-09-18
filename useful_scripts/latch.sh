#!/bin/sh

### This script encrypts a given file or folder using GnuPG.

# Crash on first non-zero return code.
set -e

# Process arguments.
if [ $# -eq 0 ]; then
    echo "Usage: sh latch.sh path/to/file-or-folder"
    exit 1
fi
path_to_file_to_encrypt=$1
if [ -d $path_to_file_to_encrypt ]; then
    orginal_dir=$(pwd)
    path_to_target_dir=$(dirname $path_to_file_to_encrypt)
    cd $path_to_target_dir
    to_zip_dirname=$(basename $path_to_file_to_encrypt)
    zipped_filename="${to_zip_dirname%/}.zip"
    echo "Zipping $to_zip_dirname... (Sometimes this takes a while.)"
    zip --move --quiet --recurse-paths $zipped_filename $to_zip_dirname
    path_to_file_to_encrypt="$path_to_target_dir/$zipped_filename"
elif ! [ -f $path_to_file_to_encrypt ]; then
    echo "No such file: $path_to_file_to_encrypt"
    exit 1
fi

# Let's get cracking...
echo "Encrypting with GnuPG... (Sometimes this takes a while.)"
gpg --no-symkey-cache --symmetric $path_to_file_to_encrypt
srm $path_to_file_to_encrypt
echo "Encryption complete!"
