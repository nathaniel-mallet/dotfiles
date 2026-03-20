#!/bin/bash

source "$(dirname "$0")/../utils.sh"

## NOTE: This script doesn't install the most basic of dev tools, git. 
# That's because git is already installed by the main `install.sh`installer as a base dependency
install github-cli

