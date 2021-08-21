#!/bin/bash

# http://redsymbol.net/articles/unofficial-bash-strict-mode/ for
# details.

set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
# Update the package listing, so we know what package exist:
apt-get update

# Install security updates:
apt-get -y upgrade

apt-get -y install --no-install-recommends software-properties-common 
apt-add-repository ppa:ansible/ansible -y
apt-get update
apt-get  -y install --no-install-recommends ansible gnupg wget curl openssh-client build-essential libssl-dev libffi-dev python-dev keychain

apt-get clean
# Delete index files we don't need anymore:
rm -rf /var/lib/apt/lists/*