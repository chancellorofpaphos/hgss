"""
This code defines a script which sets the Git credentials for this machine.
"""

# Local imports.
from pre_installer import set_git_credentials

###################
# RUN AND WRAP UP #
###################

def run():
    """ Run this file. """
    set_git_credentials()

if __name__ == "__main__":
    run()
