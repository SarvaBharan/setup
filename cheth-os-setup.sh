# how to run this thingy
# create a file on your mac called setup.sh
# run it from terminal with: sh setup.sh

# Inspired by https://twitter.com/damcclean

#!/bin/bash
set -euo pipefail

echo "Setting up your Mac..."
sudo -v

echo "But first, what's your github username?"
read gitUsername

echo "Oh okay $gitUsername got it! And.. email id?"
read emailId