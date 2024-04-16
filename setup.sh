#!/bin/bash
install_homebrew() {
  if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "Homebrew already installed"
  fi
}

post_install_config(){
  echo "# $1 BEGIN\n" >> $HOME/.autozshrc
  if [[ $1 == "htop" ]];then
    echo 'alais top=htop' >> $HOME/.autozshrc
  elif [[ $1 == "homebrew" ]];then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.autozshrc
  elif [[ $1 == "fnm" ]];then
    echo 'eval "$(fnm env --use-on-cd)"' >> $HOME/.autozshrc
  elif [[ $1 == "nvim" ]];then
    echo 'alias vim=nvim' >> $HOME/.autozshrc
    echo 'export EDITOR=nvim' >> $HOME/.autozshrc
    echo '# Ctrl-e open cli in nvim' >> $HOME/.autozshrc
    echo 'autoload edit-command-line' >> $HOME/.autozshrc
    echo 'zle -N edit-command-line' >> $HOME/.autozshrc
    echo 'bindkey "^E" edit-command-line' >> $HOME/.autozshrc
  elif [[ $1 == "bat-extras" ]];then
    echo 'eval "$(batpipe)"' >> $HOME/.autozshrc
  elif [[ $1 == "autojump" ]];then
    if [[ $os == "MacOS" ]];then
      echo '[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh' >> $HOME/.autozshrc
    elif [[ $os == "Ubuntu" ]];then
      echo '[[ -s /usr/share/autojump/autojump.sh ]] && . /usr/share/autojump/autojump.sh' >> $HOME/.autozshrc
    fi
  elif [[ $1 == "nutter-tools" ]];then
    echo 'export PATH=$HOME/nutter-tools/bin:$PATH' >> $HOME/.autozshrc
  elif [[ $1 == "golang" ]]; then
    echo "export PATH=$PATH:/usr/local/go/bin" >> $HOME/.autozshrc
  fi
  echo "# $1 SETUP END\n" >> $HOME/.autozshrc
}

ask(){
  read -p "$1 [Y/n] " response
  [-z "$response"] || [ "$response="Y" ] || [ "$response="y" ]
}

install_fnm() {
  if ! command -v fnm &> /dev/null; then
    if ask "Do you want to install fnm"; then
      curl -fsSL https://fnm.vercel.app/install | bash
      post_install_config fnm
    fi
  else
    echo "fnm already installed"
  fi
}

get_os() {
  uname=($(uname -sm))
  arch="${uname[1]}"
  os="${uname[0]}"
  echo $os
  echo $arch
  case $os in
  Darwin)   os=darwin
    flavour=macos
    ;;
  Linux) os=linux
    if type -p lsb_release &>/dev/null; then
      flavour=$(lsb_release -si)
    elif [ -f /etc/os-release ]; then
      flavour=$(awk -F= '$1 == "NAME" { print $2; exit }' /etc/os-release)
    fi
  ;;
  esac

  if [[ $os != "linux" && $os != "darwin" ]]; then
    printf '%s\n' "Unknown OS, aborting..." >&2
    exit 1
  fi
  if [[ $flavour != "Ubuntu" && $flavour != "Debian" && $flavour != "macos" ]]; then
    printf '%s\n' "Unknown flavour of Mac/Linux, aborting..." >&2
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

common_setup(){
  install_fnm
  if [ ! -d "$HOME/nutter-tools" ]; then
    mkdir -p $HOME/nutter-tools/bin
    post_install_config nutter-tools
  fi
}

ubuntu_setup(){
  sudo apt-get update
  sudo apt-get insatll coreutils

  # check if  htop, tmux, fzf, ripgrep, bat, bat-extra, exa, autojump, is installed, if not then install
  for pkg in unzip curl zsh htop tmux fzf bat exa autojump; do
    if ! command -v $pkg &> /dev/null; then
      if ask "Do you want to install $pkg"; then
        sudo apt-get install $pkg
        post_install_config $pkg
      fi
    fi
  done

  if ! command -v nvim &> /dev/null; then
    curl -o $HOME/nutter-tools/nvim-linux64.tar.gz -L https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    tar -xvf $HOME/nutter-tools/nvim-linux64.tar.gz --directory $HOME/nutter-tools/
    ln -s $HOME/nutter-tools/nvim-linux64/bin/nvim $HOME/nutter-tools/bin/nvim
    rm $HOME/nutter-tools/nvim-linux64.tar.gz
    post_install_config nvim
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

install_golang() {
  GO_VERSION=1.22.2
  if ! command -v go &> /dev/null; then
    if ask "Do you want to install golang"; then
      curl -o $HOME/nutter-tools/go-$GO_VERSION.$os-$arch.tar.gz -L https://golang.org/dl/go$GO_VERSION.$os-$arch.tar.gz
      rm -rf /usr/local/go
      sudo tar -C /usr/local -xzf $HOME/nutter-tools/go-$GO_VERSION.$os-$arch.tar.gz
      rm $HOME/nutter-tools/go-$GO_VERSION.$os-$arch.tar.gz
      post_install_config golang
    fi
  else
    echo "golang already installed"
  fi
}

mac_setup(){
  install_homebrew
  # check if  nvim, htop, tmux, fzf, ripgrep, bat, bat-extra, exa, autojump, is installed, if not then install
  for pkg in unzip curl zsh htop tmux fzf bat bat-extras exa autojump; do
    if ! command -v $pkg &> /dev/null; then
      if ask "Do you want to install $pkg"; then
        brew install $pkg
        post_install_config $pkg
      fi
    fi
  done

  default_shell_is_zsh

  if ! command -v nvim &> /dev/null; then
    brew install neovim
    post_install_config nvim
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

#setup
# get_os
