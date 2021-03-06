#!/bin/bash

set -e

function install {

# install brew and its packages
source ./setup/brew.sh
source ./setup/xcode.sh
source ./brew-bundle.sh

# bash-it / terminal
source ./setup/bash-it.sh
source ./setup/custom-bash-it-plugins.sh
source ./setup/iterm2.sh
source ./setup/vim.sh
source ./setup/jarg.sh

# ruby setup
source ./setup/ruby.sh
source ./setup/bundler.sh
source ./setup/uaac.sh

# git setup
source ./setup/git-config.sh
source ./setup/git-duet.sh
source ./setup/git-hooks.sh

# ide prefs
source ./setup/ide-prefs.sh

source ./setup/keyboard.sh
source ./setup/dock.sh
source ./setup/spectacle.sh

# daemons to launch databases at startup
source ./setup/mysql.sh
source ./setup/postgres.sh

# Golang setup
source ./setup/go.sh

# Depends on existence of GOPATH, created earlier on
source ./clone-repos.sh

source ./setup/cats.sh

source ./setup/fly.sh

source ./setup/cron.sh

source ./setup/misc.sh

# Instal CLI cf-httpie plugin
source ./setup/httpie.sh

source ./setup/snyk.sh

# Add gem dependencies for CAPI-Workspace
bundle

# Index capi.land links in Spotlight
./setup/capi-land-links.rb
echo "Please set your computer name using \"./setup/system-name.sh <name>\" if you have not already. Thanks!"
}



function open_picklecat() {
  open http://dn.ht/picklecat/
}

trap '{ case $? in
   0) echo "Success!" ;;
   *) open_picklecat ; exit 0;;
 esac ; }' EXIT

install
