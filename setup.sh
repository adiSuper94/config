#!/bin/bash
install_homebrew() {
  if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "Homebrew already installed"
  fi
}

ask(){
  read -p "$1 [Y/n] " response
  [-z "$response"] || [ "$response="Y" ] || [ "$response="y" ]
}

install_fnm() {
  if ! command -v fnm &> /dev/null; then
    if ask "Do you want to install fnm"; then
      curl -fsSL https://fnm.vercel.app/install | bash
    fi
  else
    echo "fnm already installed"
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
    mkdir -p $HOME/.zsh/zfunc
  fi
}


ubuntu_setup(){
  sudo apt-get update
  sudo apt-get insatll coreutils

  if [ ! -d "$HOME/nutter-tools" ]; then
    mkdir -p $HOME/nutter-tools/bin
  fi
  # check if  htop, tmux, fzf, ripgrep, bat, bat-extra, exa, autojump, is installed, if not then install
  for pkg in unzip curl zsh htop tmux fzf bat exa autojump; do
    if ! command -v $pkg &> /dev/null; then
      if ask "Do you want to install $pkg"; then
        sudo apt-get install $pkg
      fi
    fi
  done

  if ! command -v nvim &> /dev/null; then
    curl -o $HOME/nutter-tools/nvim-linux64.tar.gz -L https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    tar -xvf $HOME/nutter-tools/nvim-linux64.tar.gz --directory $HOME/nutter-tools/
    ln -s $HOME/nutter-tools/nvim-linux64/bin/nvim $HOME/nutter-tools/bin/nvim
    rm $HOME/nutter-tools/nvim-linux64.tar.gz
  fi

  default_shell_is_zsh

  if ! command -v rg &> /dev/null; then
    sudo apt-get install ripgrep
  fi

  if ! command -v bat-extras &> /dev/null; then
    git clone git@github.com:eth-p/bat-extras.git $HOME/nutter-tools/bat-extras
    ln -s $HOME/nutter-tools/bat-extras/bin/* $HOME/nutter-tools/bin
  fi

}

mac_setup(){
  install_homebrew
  # check if  nvim, htop, tmux, fzf, ripgrep, bat, bat-extra, exa, autojump, is installed, if not then install
  for pkg in unzip curl zsh htop tmux fzf bat bat-extras exa autojump; do
    if ! command -v $pkg &> /dev/null; then
      if ask "Do you want to install $pkg"; then
        brew install $pkg
      fi
    fi
  done

  default_shell_is_zsh

  if ! command -v nvim &> /dev/null; then
    brew install neovim
  fi
  if ! command -v rg &> /dev/null; then
    brew install ripgrep
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

