#!/bin/sh

### This script encrypts a given file using GnuPG.

# Crash on first non-zero return code.
set -e

# Process arguments.
if [ $# -eq 0 ]; then
    echo "Usage: sh latch.sh path/to/file"
    exit 1
fi
path_to_file_to_encrypt=$1
if ! [ -f $path_to_file_to_encrypt ]; then
    echo "No such file: $path_to_file_to_encrypt"
    exit 1
fi

# Let's get cracking...
echo "Encrypting with GnuPG... (Sometimes this takes a while.)"
gpg --no-symkey-cache --symmetric $path_to_file_to_encrypt
echo "Encryption complete!"
echo "Now delete the unencrypted file with: srm $path_to_file_to_encrypt"
