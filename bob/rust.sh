#!/bin/bash

post_build(){
  mkdir -p "$HOME/.zsh/zfunc"
  rustup completions zsh > "$HOME/.zsh/zfunc/_rustup"
  rustup completions zsh cargo > "$HOME/.zsh/zfunc/_cargo"
  . "$HOME/.cargo/env"
}

install(){
  if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    post_build rust
    echo ""
  else
    rustup update
  fi
  exit 0
}

uninstall(){
  echo "Running 'rustup self uninstall'"
  rustup self uninstall
  rm -f "$HOME/.zsh/zfunc/_rustup" "$HOME/.zsh/zfunc/_cargo"
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
    echo "I can only install or uninstall rustup."
    ;;
esac
