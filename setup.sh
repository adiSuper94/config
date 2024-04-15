#!/bin/bash
install_homebrew() {
  if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "Homebrew already installed"
  fi
}

get_os() {
  case $(uname -s) in
  Darwin)   os=MacOS ;;
  Linux|GNU*)
    if type -p lsb_release &>/dev/null; then
      os=$(lsb_release -si)
    elif [ -f /etc/os-release ]; then
      os=$(awk -F= '$1 == "NAME" { print $2; exit }' /etc/os-release)
    fi
  ;;
  esac

  if [[ $os != "Ubuntu" && $os != "Debian" && $os != "MacOS" ]]; then
    printf '%s\n' "Unknown Linux distribution, aborting..." >&2
    exit 1
  fi
}

## ensure zsh is installed
install_zsh() {
  if ! command -v zsh &> /dev/null; then
    if [[ $os == "MacOS" ]]; then
      brew install zsh
    else
      sudo apt-get update
      sudo apt-get install zsh
    fi
  else
    echo "zsh already installed"
  fi
}

## check if default shell is zsh
default_shell_is_zsh() {
  if [[ $SHELL != $(which zsh) ]]; then
    chsh -s $(which zsh)
  fi
}

get_os
# install homebrew if MacOS
if [[ $os == "MacOS" ]]; then
  install_homebrew
fi
install_zsh
default_shell_is_zsh

# check if  htop, tmux, fzf, ripgrep, bat, bat-extra, exa, autojump, bat-extras is installed, if not then install
if ! command -v htop &> /dev/null; then
  if [[ $os == "MacOS" ]]; then
    brew install htop
  else
    sudo apt-get install htop
  fi
fi

if ! command -v tmux &> /dev/null; then
  if [[ $os == "MacOS" ]]; then
    brew install tmux
  else
    sudo apt-get install tmux
  fi
fi

if ! command -v fzf &> /dev/null; then
  if [[ $os == "MacOS" ]]; then
    brew install fzf
  else
    sudo apt-get install fzf
  fi
fi

if ! command -v rg &> /dev/null; then
  if [[ $os == "MacOS" ]]; then
    brew install ripgrep
  else
    sudo apt-get install ripgrep
  fi
fi

if ! command -v bat &> /dev/null; then
  if [[ $os == "MacOS" ]]; then
    brew install bat
  else
    sudo apt-get install bat
  fi
fi

if ! command -v exa &> /dev/null; then
  if [[ $os == "MacOS" ]]; then
    brew install exa
  else
    sudo apt-get install exa
  fi
fi

if ! command -v autojump &> /dev/null; then
  if [[ $os == "MacOS" ]]; then
    brew install autojump
  else
    sudo apt-get install autojump
  fi
fi

if ! command -v bat-extras &> /dev/null; then
  if [[ $os == "MacOS" ]]; then
    brew install bat-extras
  else
    # install bat-extras from source
  fi
fi

