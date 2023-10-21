#!/bin/sh

### This script replaces the stored Git personal access token.

# Import constants.
. $(dirname $0)/constants.sh

# Crash on the first non-zero exit code.
set -e

# Check that the personal access token file exists.
if ! [ -f $PATH_TO_PERSONAL_ACCESS_TOKEN ]; then
    echo "No personal access token file at: $PATH_TO_PERSONAL_ACCESS_TOKEN"
    exit 1
fi

# Let's get cracking...
echo $GIT_CREDENTIAL > $PATH_TO_GIT_CREDENTIALS
git config --global credential.helper store $PATH_TO_GIT_CREDENTIALS
