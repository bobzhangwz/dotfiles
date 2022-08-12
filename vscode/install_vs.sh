#!/usr/bin/env bash
# code --list-extensions >> vs_code_extensions_list.txt
set -euxo pipefail

SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p $HOME/.config/Code/User/
cp $SOURCE_DIR/settings.json  $HOME/.config/Code/User/
cat $SOURCE_DIR/vs_code_extensions_list.txt | xargs -n 1 code --install-extension
pip3 install cfn-lint
pip3 install pydot
