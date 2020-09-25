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

    [[ ! -d ~/.ansible/plugins/modules/aur ]] && git clone https://github.com/kewlfft/ansible-aur.git ~/.ansible/plugins/modules/aur
fi

stow . -t ~/ -d config/common
stow . -t ~/ -d config/${PLATFORM}

ansible-playbook ${SOURCE_DIR}/${PLATFORM}/init.yml

sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

