#!/usr/bin/env bash

set -euxo pipefail

SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ ! -z "${PLATFORM}" ]]; then
  echo "Please set PLATFORM to 'linux' or 'mac'"
fi

if [[ $PLATFORM == 'mac' ]]; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew install ansible stow
fi

if [[ $PLATFORM == 'linux' ]]; then
    sudo pacman -S stow ansible yay base-devel git --noconfirm
    yay --aururl "https://aur.tuna.tsinghua.edu.cn" --save
    ansible-galaxy collection install kewlfft.aur   
fi

stow . -t ~/ -d config/common
stow . -t ~/ -d config/${PLATFORM}
stow . -t ~/.config -d config/config/

ansible-playbook ${SOURCE_DIR}/${PLATFORM}/init.yml -v

sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
curl -L https://raw.githubusercontent.com/FelixKratz/dotfiles/master/install_sketchybar.sh | sh

