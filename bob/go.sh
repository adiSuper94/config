#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. "$SCRIPT_DIR/utils.sh"
read -r os _arch arch_alt _flavour _release < <(os_info)

install(){
  GO_VERSION=1.23.5
  curl -o "$HOME/nutter-tools/go-$GO_VERSION.$os-$arch_alt.tar.gz" -L "https://golang.org/dl/go$GO_VERSION.$os-$arch_alt.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "$HOME/nutter-tools/go-$GO_VERSION.$os-$arch_alt.tar.gz"
  rm "$HOME/nutter-tools/go-$GO_VERSION.$os-$arch_alt.tar.gz"
  printf "\n\n"
}

uninstall(){
  sudo rm -rf /usr/local/go
  echo "Go uninstalled"
  echo "Remove 'export PATH=\"\$PATH:/usr/local/go/bin:\$HOME/go/bin\"' from $HOME/.autozshrc"
}

case $1 in
  "build"|"install")
    install
    ;;
  "remove"|"uninstall")
    uninstall
    ;;
  *)
    printf "Unknown command: %s\n" "$1"
    echo "I can only install or uninstall golang."
    ;;
esac
