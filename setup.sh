#!/bin/bash
DOTFILES="$(cd $(dirname -- $BASH_SOURCE) && pwd)"
get_os() {
  uname=($(uname -sm))
  arch="${uname[1]}"
  os="${uname[0]}"
  echo $os
  echo $arch
  case $os in
  Darwin)   os=darwin
    flavour=macos
    arch_alt=arch
    ;;
  Linux) os=linux
    if type -p lsb_release &>/dev/null; then
      flavour=$(lsb_release -si)
    elif [ -f /etc/os-release ]; then
      flavour=$(awk -F= '$1 == "NAME" { print $2; exit }' /etc/os-release)
    fi
    if [[ $arch = "x86_64" ]]; then
      arch_alt="amd64"
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

install_homebrew() {
  if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    post_install_config homebrew
  else
    echo "Homebrew already installed"
  fi
}

install_rust() {
  if ! command -v rustup &> /dev/null; then
    if ask "Do you want to install rust"; then
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
      post_install_config rust
    fi
  fi
}

install_golang() {
  GO_VERSION=1.22.2
  if ! command -v go &> /dev/null; then
    if ask "Do you want to install golang"; then
      curl -o $HOME/nutter-tools/go-$GO_VERSION.$os-$arch_alt.tar.gz -L https://golang.org/dl/go$GO_VERSION.$os-$arch_alt.tar.gz
      rm -rf /usr/local/go
      sudo tar -C /usr/local -xzf $HOME/nutter-tools/go-$GO_VERSION.$os-$arch_alt.tar.gz
      rm $HOME/nutter-tools/go-$GO_VERSION.$os-$arch_alt.tar.gz
      post_install_config golang
    fi
  else
    echo "golang already installed"
  fi
}

post_install_config(){
  echo "# THIS FILE AHS BEEN AUTO GENERATED.\nDO NOT EDIT\n\n" >> $HOME/.autozshrc
  if [[ $1 == "htop" ]];then
    echo 'alias top=htop' >> $HOME/.autozshrc
  elif [[ $1 == "homebrew" ]];then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.autozshrc
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ $1 == "fnm" ]];then
    echo 'export PATH=$HOME/.local/share/fnm:$PATH' >> $HOME/.autozshrc
    echo 'eval "$(fnm env --use-on-cd)"' >> $HOME/.autozshrc
  elif [[ $1 == "nvim" ]];then
    echo 'alias vim=nvim' >> $HOME/.autozshrc
    echo 'export EDITOR=nvim' >> $HOME/.autozshrc
    echo '# Ctrl-e open cli in nvim' >> $HOME/.autozshrc
    echo 'autoload edit-command-line' >> $HOME/.autozshrc
    echo 'zle -N edit-command-line' >> $HOME/.autozshrc
    echo 'bindkey "^E" edit-command-line' >> $HOME/.autozshrc
  elif [[ $1 == "bat-extras" ]];then
    if [[ $os == "linux" ]];then
      ln -s /usr/bin/batcat $HOME/nutter-tools/bin/bat
    fi
    echo 'eval "$(batpipe)"' >> $HOME/.autozshrc
  elif [[ $1 == "autojump" ]];then
    if [[ $os == "darwin" ]];then
      echo '[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh' >> $HOME/.autozshrc
    elif [[ $os == "linux" ]];then
      echo '[[ -s /usr/share/autojump/autojump.sh ]] && . /usr/share/autojump/autojump.sh' >> $HOME/.autozshrc
    fi
  elif [[ $1 == "nutter-tools" ]];then
    echo 'export PATH=$HOME/nutter-tools/bin:$PATH' >> $HOME/.autozshrc
  elif [[ $1 == "golang" ]]; then
    echo 'export PATH=$PATH:/usr/local/go/bin' >> $HOME/.autozshrc
  elif [[ $1 == "lazygit" ]]; then
    echo "alias lg=lazygit" >> $HOME/.autozshrc
  elif [[ $1 == "rust" ]]; then
    echo '. $HOME/.cargo/env' >> $HOME/.autozshrc
    . $HOME/.cargo/env
    rustup completions zsh cargo > ~/.zsh/zfunc/_cargo
  fi
}

ask(){
  read -p "$1 [Y/n] " response
  [ -z "$response" ] || [ "$response" = "Y" ] || [ "$response" = "y" ]
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

## check if default shell is zsh
configure_zsh() {
  if [[ $SHELL != $(which zsh) ]]; then
    chsh -s $(which zsh)
    mkdir -p $HOME/.zsh/zfunc
  fi
  mkdir -p $HOME/.zsh
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
  echo ". ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> $HOME/.autozshrc
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
  echo ". ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> $HOME/.autozshrc
  git clone https://github.com/zsh-users/zsh-completions.git ~/.zsh/zsh-completions

  echo "zstyle :compinstall filename '~/.zshrc'" >> $HOME/.autozshrc
  echo "fpath+=~/.zsh/zfunc" >> $HOME/.autozshrc
  echo "fpath+=~/.zsh/zsh-completions/src" >> $HOME/.autozshrc
  echo "autoload -Uz compinit" >> $HOME/.autozshrc
  echo "compinit -D" >> $HOME/.autozshrc
  echo "RUN  to recompile zsh-completions 'rm -f ~/.zcompdump; compinit'"
  echo ". $HOME/.autozshrc" >> $HOME/.zshrc
}

common_setup(){
  install_fnm
  configure_zsh
  install_golang
  install_rust
}

install_lazygit_on_ubuntu(){
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  mv lazygit $HOME/nutter-tools/bin
  chmod +x $HOME/nutter-tools/bin/lazygit
  rm lazygit.tar.gz
  post_install_config lazygit
}

minimal_setup_linux(){
  sudo apt-get update
  sudo apt-get -yq install coreutils gcc vim curl zsh ripgrep fzf
  if [ ! -d "$HOME/nutter-tools" ]; then
    mkdir -p $HOME/nutter-tools/bin
    post_install_config nutter-tools
  fi
  post_install_config fzf
  configure_zsh

  if ! command -v nvim &> /dev/null; then
    curl -o $HOME/nutter-tools/nvim-linux64.tar.gz -L https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    tar -xvf $HOME/nutter-tools/nvim-linux64.tar.gz --directory $HOME/nutter-tools/
    ln -s $HOME/nutter-tools/nvim-linux64/bin/nvim $HOME/nutter-tools/bin/nvim
    rm $HOME/nutter-tools/nvim-linux64.tar.gz
    post_install_config nvim
    mkdir -p $HOME/.config
    ln -s $DOTFILES/nvim $HOME/.config/nvim
    $HOME/nutter-tools/bin/nvim -es -u init.vim -i NONE -c "PlugInstall" -c "qa"
  fi
  }

ubuntu_setup(){
  sudo apt-get update
  sudo apt-get -y --quiet install coreutils gcc
  # check if  htop, tmux, fzf, ripgrep, bat, bat-extra, exa, autojump, is installed, if not then install
  for pkg in unzip curl zsh htop tmux fzf bat exa autojump; do
    if ! command -v $pkg &> /dev/null; then
      if ask "Do you want to install $pkg"; then
        sudo apt-get install -qy $pkg
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
    $HOME/nutter-tools/bin/nvim -es -u init.vim -i NONE -c "PlugInstall" -c "qa"
  fi
  if ! command -v rg &> /dev/null; then
    sudo apt-get install ripgrep
  fi
  if ! command -v batman &> /dev/null; then
    git clone 'https://github.com/eth-p/bat-extras.git' $HOME/nutter-tools/bat-extras
    cd $HOME/nutter-tools/bat-extras  &&  ./build.sh
    for file in $HOME/nutter-tools/bat-extras/bin/*; do
      ln -s $file $HOME/nutter-tools/bin
    done
    post_install_config bat-extras
  fi
  install_lazygit_on_ubuntu
}

mac_setup(){
  install_homebrew
  # check if  nvim, htop, tmux, fzf, ripgrep, bat, bat-extra, exa, autojump, is installed, if not then install
  for pkg in unzip curl zsh htop tmux fzf bat bat-extras exa autojump lazygit; do
    if ! command -v $pkg &> /dev/null; then
      if ask "Do you want to install $pkg"; then
        brew install $pkg
        post_install_config $pkg
      fi
    fi
  done
  if ! command -v nvim &> /dev/null; then
    brew install neovim
    post_install_config nvim
  fi
  if ! command -v rg &> /dev/null; then
    brew install ripgrep
  fi
  nvim -es -u init.vim -i NONE -c "PlugInstall" -c "qa"
}

sym_link(){
  for pkg_config in nvim alacritty i3 tmux rofi; do
    ln -s $DOTFILES/$pkg_config $HOME/.config/$pkg_config
  done
}

setup() {
  get_os
  if [ ! -d "$HOME/nutter-tools" ]; then
    mkdir -p $HOME/nutter-tools/bin
    post_install_config nutter-tools
  fi
  mkdir -p $HOME/.config
  case $os in
    linux) ubuntu_setup ;;
    darwin) mac_setup ;;
  esac
  common_setup
  sym_link
}

#setup
#minimal_setup_linux
