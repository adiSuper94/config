#!/bin/bash

git_quiet=""
branch="master"
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. "$SCRIPT_DIR/utils.sh"
read -r os _arch _arch_alt flavour _release < <(os_info)
read -r apt install _uninstall update _autoremove < <(get_apt)

deps(){
  if [[ -f "$HOME/.cargo/env" ]]; then
    . "$HOME/.cargo/env"
  fi
  if ! command -v rustup &> /dev/null; then
    printf "Rustup not found. Rust is required to build project. Aborting.\n"
    exit 1
  fi
  case $flavour in
    "ubuntu"|"debian")
    sudo "$apt" "$install" cmake g++ pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 gzip scdoc
      ;;
    "fedora")
    sudo "$apt" "$install" cmake freetype-devel fontconfig-devel libxcb-devel libxkbcommon-devel g++ gzip scdoc
      ;;
    "arch")
    sudo "$apt" "$install" cmake freetype2 fontconfig pkg-config make libxcb libxkbcommon python libxcb gzip scdoc
      ;;
    "macos")
      ;;
    *)
    printf "Unknown OS. Aborting.\n"
    exit 1
      ;;
  esac
  errno=$?
  if [[ $errno -ne 0 ]]; then
    printf "Failed to install dependencies. Aborting.\n"
    exit 1
  fi
  return 0
}

post_build(){
  case $os in
    "linux")
      cd "$HOME"/nutter-tools/alacritty || { echo "Failed to change directory to alacritty" >&2; exit 1; }
      if [[ $(infocmp alacritty) -ne 0 ]]; then
        tic -xe alacritty,alacritty-direct extra/alacritty.info
      fi
      sudo cp target/release/alacritty /usr/local/bin
      sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
      sudo desktop-file-install extra/linux/Alacritty.desktop
      sudo update-desktop-database
      sudo mkdir -p /usr/local/share/man/man1
      sudo mkdir -p /usr/local/share/man/man5
      scdoc < extra/man/alacritty.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
      scdoc < extra/man/alacritty-msg.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null
      scdoc < extra/man/alacritty.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty.5.gz > /dev/null
      scdoc < extra/man/alacritty-bindings.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty-bindings.5.gz > /dev/null
      cp extra/completions/_alacritty ~/.zsh/zfunc
      printf "Alacritty installed successfully\n\n"
      ;;
    "darwin")
      printf "Alacritty installed successfully\n\n"
      ;;
    *)
    printf "Unknown OS. Aborting.\n"
    exit 1
      ;;
  esac
  return 0
}


build(){
  case $os in
    "linux")
      mkdir -p "$HOME"/nutter-tools
      cd "$HOME"/nutter-tools || { echo "ERROR: Failed to create nutter-tools directory" >&2; exit 1; }
      if [[ ! -d alacritty ]]; then
        git clone https://github.com/alacritty/alacritty.git
        git checkout "$git_quiet $branch"
      else
        git stash save "$git_quiet" && git checkout "$branch $git_quiet" && git pull "$git_quiet"
      fi
      cd alacritty || exit
      rustup override set stable
      rustup update stable
      if ! cargo build --release; then
        printf "Failed to build alacritty. Aborting\n"
        exit 1
      fi
      ;;
    "darwin")
      make app
      cp -r target/release/osx/Alacritty.app /Applications/
      ;;
    *)
      printf "ERROR: Unknown OS:%s\n Aborting.\n" "$os"
      exit 1
      ;;
  esac
  return 0
}

install(){
  if [[ -f /usr/local/bin/alacritty ]]; then
    printf "Alacritty is already installed. Aborting.\n"
    exit 1
  fi
  deps
  build
  post_build
  exit 0
}

uninstall(){
  case $os in
    "linux")
      if [[ -f /usr/local/bin/alacritty ]]; then
        sudo rm -f /usr/local/bin/alacritty
      fi
      if [[ -f /usr/share/pixmaps/Alacritty.svg ]]; then
        sudo rm -f /usr/share/pixmaps/Alacritty.svg
      fi
      if [[ -f ~/.zsh/zfunc/_alacritty ]]; then
        rm -f ~/.zsh/zfunc/_alacritty
      fi
      sudo rm -f /usr/local/share/man/man1/alacritty.1.gz
      sudo rm -f /usr/local/share/man/man1/alacritty-msg.1.gz
      sudo rm -f /usr/local/share/man/man5/alacritty.5.gz
      sudo rm -f /usr/local/share/man/man5/alacritty-bindings.5.gz
      ;;
    "darwin")
      if [[ -d /Applications/Alacritty.app ]]; then
        rm -rf /Applications/Alacritty.app
      fi
      ;;
    *)
      printf "Unknown OS. Aborting.\n"
      exit 1
      ;;
  esac
  exit 0
}

case $1 in
  "build"|"install")
    install
    ;;
  "remove"|"uninstall")
    uninstall
    ;;
  *)
    printf "Unknown command: %s\n" "$@"
    echo "I can only install or uninstall alacritty."
    ;;
esac
