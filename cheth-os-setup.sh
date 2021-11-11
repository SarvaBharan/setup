# how to run this thingy
# create a file on your mac called setup.sh
# run it from terminal with: sh setup.sh

# Inspired by https://twitter.com/damcclean

#!/bin/bash
set -euo pipefail

echo "Setting up your Mac..."
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "But first, what's your github username?"
read gitUsername

echo "Oh okay $gitUsername got it! And.. email id?"
read emailId


# Homebrew - Installation
if test ! $(which brew); then
  echo "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Install Homebrew Packages
cd ~
echo "Installing Homebrew packages"

homebrew_packages=(
  "git"
  "gitmoji"
  "node"
  "n"
  "zsh"
  "zsh-completions"
  "zsh-autosuggestions"
  "zsh-syntax-highlighting"
  "thefuck"
  "tig"
  "awscli"
  "htop"
  "tree"
  "mas"
)

for homebrew_package in "${homebrew_packages[@]}"; do
  brew install "$homebrew_package"
done

# Install Casks
echo "Installing Homebrew cask packages"

homebrew_cask_packages=(
  "caffeine"
  "shiftit"
  "slack"
  "authy"
  "sublime-text"
  "tunnelblick"
  "google-chrome"
  "brave-browser"
  "docker"
  "iterm2"
  "keycastr"
  "loopback"
  "notion"
  "raycast"
  "screenflow"
  "setapp"
  "spotify"
  "tableplus"
  "visual-studio-code"
  "meld"
  "flux"
)

# extras

# apps in mac store
# runcat

# apps in setapp app
# yoink
# cleanmymac

# install n (https://github.com/tj/n)
# make sure you follow steps here to take control of /usr folders

# configure npm permissions to current user 
# http://npm.github.io/installation-setup-docs/installing/a-note-on-permissions.html
sudo chown -R $(whoami) $(npm config get prefix)/{lib/node_modules,bin,share}

# Installing nvm
if test ! $(which nvm); then
  echo "Installing nvm"
  /bin/bash -c "$(curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
)"
fi

for homebrew_cask_package in "${homebrew_cask_packages[@]}"; do
  brew install --cask "$homebrew_cask_package"
done

# configure git
git config --global user.name $gitUsername
git config --global user.email $emailId
gh config set git_protocol "ssh"

# Create projects directory called kitchen
echo "Creating a Kitchen directory"
mkdir -p $HOME/documents/kitchen

# zsh and oh-my-zsh
echo "Adding ZSH"
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z

# zsh configuration
touch ~/.my-zshrc

# aliases	
echo "alias ni='npm i'" >> ~/.my-zshrc
echo "alias ns='npm start'" >> ~/.my-zshrc
echo "alias nb='npm run build'" >> ~/.my-zshrc
echo "alias nd='npm run dev'" >> ~/.my-zshrc
echo "alias c=clear" >> ~/.my-zshrc

# zsh plugins
echo "plugins=(git zsh-completions zsh-z)" >> ~/.my-zshrc
echo "source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.my-zshrc
echo "source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.my-zshrc

# add our zshrc config to the main zshrc config
echo ". ~/.my-zshrc" >> "$HOME/.zshrc"

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Generate SSH key
echo "Generating SSH keys"
ssh-keygen -t rsa

echo "Copied SSH key to clipboard - You can now add it to Github"
pbcopy < ~/.ssh/id_rsa.pub

# Complete
echo "Installation Complete!"