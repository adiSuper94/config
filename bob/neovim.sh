#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. "$SCRIPT_DIR/utils.sh"
read -r os arch _arch_alt _flavour _release < <(os_info)

if [[ $os != "linux" ]]; then
  echo "ERROR: This script is for Linux only."
  exit 1
fi

install(){
  nightly="false"
  if [[ "$1" == "nightly" ]]; then
    nightly="true"
  fi
  if ! command -v nvim &> /dev/null; then
    if [[ "$nightly" == "true" ]]; then
      url="https://github.com/neovim/neovim/releases/download/nightly/nvim-${os}-${arch}.tar.gz"
    else
      url="https://github.com/neovim/neovim/releases/latest/download/nvim-${os}-${arch}.tar.gz"
    fi
    printf "Downloading Neovim...%s" "$url"
    curl -o "$HOME/nutter-tools/nvim-${os}-${arch}.tar.gz" -L "$url"
    tar -xvf "$HOME/nutter-tools/nvim-${os}-${arch}.tar.gz" --directory "$HOME"/nutter-tools/
    ln -s "$HOME/nutter-tools/nvim-${os}-${arch}/bin/nvim" "$HOME"/nutter-tools/bin/nvim
    rm "$HOME/nutter-tools/nvim-${os}-${arch}.tar.gz"
  fi
}

uninstall(){
  rm -rf "$HOME/nutter-tools/nvim-${os}-${arch}"
  rm "$HOME/nutter-tools/bin/nvim"
  echo "Neovim uninstalled"
}

case $1 in
  "build"|"install")
    install "$2"
    ;;
  "remove"|"uninstall")
    uninstall
    ;;
  *)
    printf "Unknown command: %s\n" "$@"
    echo "I can only install or uninstall neovim."
    ;;
esac
