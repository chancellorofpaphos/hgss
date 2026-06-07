#!/bin/sh

set -e

VERACRYPT_VERSION="1.26.24"
VERACRYPT_SOURCEFORGE_BASE="https://sourceforge.net/projects/veracrypt/files/VeraCrypt%20$VERACRYPT_VERSION/Linux"

cleanup_tmp_dir() {
    if [ -n "$TMP_DIR" ] && [ -d "$TMP_DIR" ]; then
        rm -rf "$TMP_DIR"
    fi
}

TMP_DIR=""
trap cleanup_tmp_dir EXIT

os_codename=$(. /etc/os-release; printf '%s' "${VERSION_CODENAME:-}")
architecture=$(dpkg --print-architecture)

case "$os_codename-$architecture" in
    jammy-amd64)
        veracrypt_package="veracrypt-$VERACRYPT_VERSION-Ubuntu-22.04-amd64.deb"
        ;;
    jammy-arm64)
        veracrypt_package="veracrypt-$VERACRYPT_VERSION-Ubuntu-22.04-arm64.deb"
        ;;
    noble-amd64)
        veracrypt_package="veracrypt-$VERACRYPT_VERSION-Ubuntu-24.04-amd64.deb"
        ;;
    noble-arm64)
        veracrypt_package="veracrypt-$VERACRYPT_VERSION-Ubuntu-24.04-arm64.deb"
        ;;
    resolute-amd64)
        veracrypt_package="veracrypt-$VERACRYPT_VERSION-Ubuntu-26.04-amd64.deb"
        ;;
    resolute-arm64)
        veracrypt_package="veracrypt-$VERACRYPT_VERSION-Ubuntu-26.04-arm64.deb"
        ;;
    *)
        echo "VeraCrypt is not packaged for $os_codename on $architecture here."
        exit 1
        ;;
esac

TMP_DIR=$(mktemp -d)
wget -O "$TMP_DIR/$veracrypt_package" \
    "$VERACRYPT_SOURCEFORGE_BASE/$veracrypt_package/download"
sudo apt install --yes "$TMP_DIR/$veracrypt_package"
