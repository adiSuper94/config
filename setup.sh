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

## check if default shell is zsh
default_shell_is_zsh() {
  if [[ $SHELL != $(which zsh) ]]; then
    chsh -s $(which zsh)
  fi
}


ubuntu_setup(){
  sudo apt-get update
  if [ ! -d "$HOME/nutter-tools" ]; then
    mkdir -p $HOME/nutter-tools/bin
  fi
  # check if  htop, tmux, fzf, ripgrep, bat, bat-extra, exa, autojump, is installed, if not then install
  if ! command -v curl &> /dev/null; then
    sudo apt-get install curl
  fi

  if ! command -v nvim &> /dev/null; then
    curl -o $HOME/nutter-tools/nvim-linux64.tar.gz -L https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    tar -xvf $HOME/nutter-tools/nvim-linux64.tar.gz --directory $HOME/nutter-tools/
    ln -s $HOME/nutter-tools/nvim-linux64/bin/nvim $HOME/nutter-tools/bin/nvim
    rm $HOME/nutter-tools/nvim-linux64.tar.gz
  fi

  if ! command -v zsh &> /dev/null; then
    sudo apt-get install zsh
  fi

  default_shell_is_zsh

  if ! command -v htop &> /dev/null; then
    sudo apt-get install htop
  fi

  if ! command -v tmux &> /dev/null; then
    sudo apt-get install tmux
  fi

  if ! command -v fzf &> /dev/null; then
    sudo apt-get install fzf
  fi

  if ! command -v rg &> /dev/null; then
    sudo apt-get install ripgrep
  fi

  if ! command -v bat &> /dev/null; then
    sudo apt-get install bat
  fi

  if ! command -v bat-extras &> /dev/null; then
    git clone git@github.com:eth-p/bat-extras.git $HOME/nutter-tools/bat-extras
    ln -s $HOME/nutter-tools/bat-extras/bin/* $HOME/nutter-tools/bin
  fi

  if ! command -v exa &> /dev/null; then
    sudo apt-get install exa
  fi

  if ! command -v autojump &> /dev/null; then
    sudo apt-get install autojump
  fi
}

mac_setup(){
  install_homebrew
  # check if  nvim, htop, tmux, fzf, ripgrep, bat, bat-extra, exa, autojump, is installed, if not then install

  if ! command -v nvim &> /dev/null; then
    brew install neovim
  fi

  if ! command -v zsh &> /dev/null; then
    brew install zsh
  fi

  default_shell_is_zsh

  if ! command -v htop &> /dev/null; then
    brew install htop
  fi

  if ! command -v tmux &> /dev/null; then
    brew install tmux
  fi

  if ! command -v fzf &> /dev/null; then
    brew install fzf
  fi

  if ! command -v rg &> /dev/null; then
    brew install ripgrep
  fi

  if ! command -v bat &> /dev/null; then
    brew install bat
  fi

  if ! command -v bat-extras &> /dev/null; then
    brew install bat-extras
  fi

  if ! command -v exa &> /dev/null; then
    brew install exa
  fi

  if ! command -v autojump &> /dev/null; then
    brew install autojump
  fi
}

setup() {
  get_os
  case $os in
    Ubuntu|Debian) ubuntu_setup ;;
    MacOS) mac_setup ;;
  esac
}

setup

