#!/usr/bin/env bash

CURRENT_DIR=$(pwd)
SCRIPT_DIR=$(cd $(dirname $0);pwd)
cd ${SCRIPT_DIR}

# install homebrew
hash brew
if [ $? -eq 1 ]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# install applications
echo "Installing applications..."

# install JDK 8
brew tap caskroom/versions
brew cask install java8

# install Open JDK 11
brew cask install java

# install other applications
brew install argon/mas/mas
brew install rcmdnk/file/brew-file
brew file init
cp ${SCRIPT_DIR}/Brewfile ~/.config/brewfile/Brewfile
brew file install --force

# install anyenv
if [ -e ~/.anyenv ]; then
  cd ~/.anyenv
  git pull
  cd ${SCRIPT_DIR}
else
  git clone https://github.com/riywo/anyenv ~/.anyenv
fi

# setup dotfiles
echo "Setup dotfiles..."
if [ -e ~/.bash_base ]; then
  if [ -L ~/.bash_base ]; then
    rm ~/.bash_base
  else
    mv ~/.bash_base ~/.bash_base_bk_$(date "+%Y%m%d")
  fi
fi

if [ -e ~/.bash_alias ]; then
  if [ -L ~/.bash_alias ]; then
    rm ~/.bash_alias
  else
    mv ~/.bash_alias ~/.bash_alias_bk_$(date "+%Y%m%d")
  fi
fi

if [ -e ~/.bash_commandline ]; then
  if [ -L ~/.bash_commandline ]; then
    rm ~/.bash_commandline
  else
    mv ~/.bash_commandline ~/.bash_commandline_bk_$(date "+%Y%m%d")
  fi
fi

ln -s ${SCRIPT_DIR}/.bash_base ~/.bash_base
ln -s ${SCRIPT_DIR}/.bash_alias ~/.bash_alias
ln -s ${SCRIPT_DIR}/.bash_commandline ~/.bash_commandline

if [ ! -e ~/.bash_base ]; then
  touch ~/.bash_base
fi

grep "source ~/.bash_base" ~/.bash_profile
if [ $? -eq 1 ]; then
  echo "source ~/.bash_base" >> ~/.bash_profile
fi
source ~/.bash_profile

# setup anyenv
echo "Setup anyenv..."
anyenv install jenv
anyenv install ndenv

# setup jenv
echo "Setup jenv..."
jenv add /Library/Java/JavaVirtualMachines/openjdk-11.0.1.jdk/Contents/Home
jenv global openjdk64-11.0.1


# docker auto complete settings
echo "Setup docker auto complete command settings..."
if [ -e /usr/local/etc/bash_completion.d/docker ]; then
  rm /usr/local/etc/bash_completion.d/docker
fi

if [ -e /usr/local/etc/bash_completion.d/docker-machine ]; then
  rm /usr/local/etc/bash_completion.d/docker-machine
fi

if [ -e /usr/local/etc/bash_completion.d/docker-compose ]; then
  rm /usr/local/etc/bash_completion.d/docker-compose
fi

ln -s /Applications/Docker.app/Contents/Resources/etc/docker.bash-completion /usr/local/etc/bash_completion.d/docker
ln -s /Applications/Docker.app/Contents/Resources/etc/docker-machine.bash-completion /usr/local/etc/bash_completion.d/docker-machine
ln -s /Applications/Docker.app/Contents/Resources/etc/docker-compose.bash-completion /usr/local/etc/bash_completion.d/docker-compose

echo "Done."

exec $SHELL -l
