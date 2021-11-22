"""
This code defines a script which sets up Git on this machine and clones the
HGSS repo.

Before you run this script, make sure you have a personal access token at
the path specified below.
"""

# Imports.
import os
import pathlib
import shutil
import subprocess
import sys

# Local constants.
PATH_TO_HOME = str(pathlib.Path.home())
DEFAULT_HGSS_URL = "https://github.com/chancellorofpaphos/hgss.git"
DEFAULT_PATH_TO_GIT_CREDENTIALS = \
    os.path.join(PATH_TO_HOME, ".git-credentials")
DEFAULT_PATH_TO_HGSS = os.path.join(PATH_TO_HOME, "hgss")
DEFAULT_PATH_TO_PAT = \
    os.path.join(PATH_TO_HOME, "personal_access_token.txt")
DEFAULT_USERNAME = "chancellorofpaphos"
DEFAULT_EMAIL = "chancellorofpaphos@protonmail.com"

#############
# FUNCTIONS #
#############

def make_github_credential(pat, username=DEFAULT_USERNAME):
    """ Generate a string for a GitHub credential, given a username and a
    personal access token. """
    result = "https://"+username+":"+pat+"@github.com"
    return result

def set_username_and_email(username=DEFAULT_USERNAME, email=DEFAULT_EMAIL):
    """ Set the global Git username and email. """
    subprocess.run(
        ["git", "config", "--global", "user.name", username],
        check=True
    )
    subprocess.run(
        ["git", "config", "--global", "user.email", email],
        check=True
    )

def set_git_credentials(
        path_to_git_credentials=DEFAULT_PATH_TO_GIT_CREDENTIALS,
        path_to_pat=DEFAULT_PATH_TO_PAT, username=DEFAULT_USERNAME,
        email=DEFAULT_EMAIL):
    """ Set up GIT credentials, if necessary and possible. """
    set_username_and_email(username=username, email=email)
    if os.path.exists(path_to_pat):
        with open(path_to_pat, "r") as pat_file:
            pat = pat_file.read()
            while pat.endswith("\n"):
                pat = pat[:-1]
        credential = make_github_credential(pat)
        with open(path_to_git_credentials, "w") as credentials_file:
            credentials_file.write(credential)
    elif not os.path.exists(path_to_git_credentials):
        print("Error setting up GIT credentials: could not find PAT at "+
              path_to_pat+" or GIT credentials at "+path_to_git_credentials)
        return False
    commands = [
        "git",
        "config",
        "--global",
        "credential.helper",
        "store --file "+path_to_git_credentials
    ]
    subprocess.run(commands, check=True)
    print("GIT credentials set up!")
    return True

def install_git():
    """ Ronseal. """
    subprocess.run(["sudo", "apt", "install", "git"], check=True)

def clone_hgss(parent_path=PATH_TO_HOME, path_to_hgss=DEFAULT_PATH_TO_HGSS,
               hgss_url=DEFAULT_HGSS_URL):
    """ Clone the HGSS repo, moving anything out of the way that may block
    the download. """
    os.chdir(parent_path)
    if os.path.isdir(path_to_hgss):
        shutil.move(path_to_hgss, path_to_hgss+"_")
    subprocess.run(["git", "clone", hgss_url], check=True)

def run_installer(path_to_hgss=DEFAULT_PATH_TO_HGSS, args=[]):
    """ Move into the HGSS folder and run the installer script. """
    os.chdir(path_to_hgss)
    subprocess.run(["sh", "installer"]+args, check=True)

###################
# RUN AND WRAP UP #
###################

def run():
    """ Run this file. """
    install_git()
    set_git_credentials()
    clone_hgss()
    if "--run-installer" in sys.argv:
        run_installer(args=sys.argv)

if __name__ == "__main__":
    run()
