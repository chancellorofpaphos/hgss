#!/bin/sh

### This script replaces the stored Git personal access token.

# Import constants.
. $(dirname $0)/constants.sh

# Make any non-zero returns throw an error, if appropriate.
if $ignore_errors_flag; then
    set -e
fi

# Let's get cracking...
echo $GIT_CREDENTIAL > $PATH_TO_GIT_CREDENTIALS
git config --global credential.helper store $PATH_TO_GIT_CREDENTIALS
