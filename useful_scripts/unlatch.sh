#!/bin/sh

### This script decrypts a given file or folder using GnuPG.

# Constants.
ENCRYPTED_EXTENSION=".gpg"

# Crash on first non-zero return code.
set -e

# Process arguments.
if [ $# -eq 0 ]; then
    echo "Usage: sh unlatch.sh path/to/file"
    exit 1
fi
path_to_file_to_decrypt=$1
path_to_target_dir="$(dirname $path_to_file_to_decrypt)"
output_fn=$(basename $path_to_file_to_decrypt $ENCRYPTED_EXTENSION)
path_to_output="$path_to_target_dir/$output_fn"
extension="${output_fn##*\.}"

# Let's get cracking...
echo "Decrypting with GnuPG... (Sometimes this takes a while.)"
gpg --output $path_to_output --decrypt $path_to_file_to_decrypt
if [ $extension = "zip" ]; then
    path_to_original=$(pwd)
    cd $path_to_target_dir
    echo "Unzipping $path_to_output... (Sometimes this takes a while.)"
    unzip -q $output_fn
    srm $output_fn
    cd $path_to_original
fi
srm $path_to_file_to_decrypt
echo "Decryption complete!"
