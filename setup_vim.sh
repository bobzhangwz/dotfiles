#!/usr/bin/env bash

set -euxo pipefail
asdf plugin add nodejs
asdf plugin add yarn
asdf plugin add scala
asdf plugin add java
asdf install java openjdk-11
asdf install java adoptopenjdk-8.0.252+9.1
asdf install scala 2.13.3
asdf install yarn latest
asdf global yarn latest

asdf install nodejs lts
asdf global nodejs lts
npm install -g eslint-cli
npm install -g js-beautify
npm install -g vscode-html-languageserver-bin
npm i -g bash-language-server \
  javascript-typescript-langserver \
  purescript-language-server \
  vue-language-server \
  typescript-language-server \
  vscode-css-languageserver-bin \
  neovim

coursier bootstrap \
  --java-opt -Xss4m \
  --java-opt -Xms100m \
  --java-opt -Dmetals.client=emacs \
  org.scalameta:metals_2.12:0.10.9 \
  -r bintray:scalacenter/releases \
  -r sonatype:snapshots \
  -o /usr/local/bin/metals-emacs -f

