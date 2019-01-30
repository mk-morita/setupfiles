#!/usr/bin/env bash

# ---
# Javaアップデートのタイミングで、バージョン番号の更新が必要
JAVA8_VERSSION="1.8.0_202"
JAVA11_VERSSION="11.0.2"

# ---
CURRENT_DIR=$(pwd)
SCRIPT_DIR=$(cd $(dirname $0);pwd)
cd ${SCRIPT_DIR}

# ---
# install homebrew
hash brew
if [ $? -eq 1 ]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# ---
# install applications
echo "Installing applications..."

## install latest Bash
brew install bash

## install JDK 8
brew tap caskroom/versions
brew cask install java8

## install Open JDK 11
brew cask install java

## install other applications
brew install git
#brew install argon/mas/mas
#brew install rcmdnk/file/brew-file
#brew file init
#cp ${SCRIPT_DIR}/Brewfile ~/.config/brewfile/Brewfile
brew bundle
echo

## install anyenv
if [ -e ~/.anyenv ]; then
  cd ~/.anyenv
  git pull
  cd ${SCRIPT_DIR}
else
  git clone https://github.com/riywo/anyenv ~/.anyenv
  anyenv install --init
fi

# ---
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

if [ ! -e ~/.bash_profile ]; then
  touch ~/.bash_profile
fi

grep "source ~/.bash_base" ~/.bash_profile
if [ $? -eq 1 ]; then
  echo "source ~/.bash_base" >> ~/.bash_profile
fi
exec $SHELL -l

# ---
# setup anyenv
echo "Setup anyenv..."
anyenv install jenv
anyenv install ndenv

# ---
# setup jenv
echo "Setup jenv..."
jenv enable-plugin export  # enable $JAVA_HOME switching
jenv add /Library/Java/JavaVirtualMachines/jdk${JAVA8_VERSSION}.jdk/Contents/Home
jenv add /Library/Java/JavaVirtualMachines/openjdk-${JAVA11_VERSSION}.jdk/Contents/Home
jenv global openjdk64-${JAVA11_VERSSION}  # use JDK11 as globally

# ---
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

# kubectl auto complete settings
K8CTL_AUTOCOMPLETE="$(brew --prefix)/etc/bash_completion.d/kubectl"
if [ ! -f ${K8CTL_AUTOCOMPLETE} ]; then
  rm ${K8CTL_AUTOCOMPLETE}
fi
kubectl completion bash > ${K8CTL_AUTOCOMPLETE}


echo "Done."

exec $SHELL -l
exit 0
