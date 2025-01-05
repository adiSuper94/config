#!/bin/bash
DOTFILES="$(cd "$(dirname "$0")" && pwd)"

YES=false
UNINSTALL=false

get_os() {
  uname=$(uname -sm)
  read -r os arch <<< "$uname"
  case $os in
  Darwin)   os=darwin
    flavour=macos
    arch_alt=arch
    ;;
  Linux) os=linux
    if type -p lsb_release &>/dev/null; then
      flavour=$(lsb_release -si)
      release=$(lsb_release -sr)
    elif [ -f /etc/os-release ]; then
      flavour=$(awk -F= '$1 == "NAME" { print $2; exit }' /etc/os-release)
    fi
    if [[ $arch = "x86_64" ]]; then
      arch_alt="amd64"
    fi
  ;;
  esac

  echo "------ OS Info ------"
  echo "os: $os"
  echo "arch: $arch"
  echo "flavour: $flavour"
  echo "arch_alt: $arch_alt"
  echo "release: $release"
  echo "---------------------"

  if [[ $os != "linux" && $os != "darwin" ]]; then
    printf '%s\n' "Unknown OS, aborting..." >&2
    exit 1
  fi
  if [[ $flavour != "Ubuntu" && $flavour != "Debian" && $flavour != "macos" ]]; then
    printf '%s\n' "Unknown flavour of Mac/Linux, aborting..." >&2
    exit 1
  fi
}

get_os

post_install_config(){
  if [[ $1 == "htop" ]];then
    echo 'alias top=htop' >> "$HOME/.autozshrc"
  elif [[ $1 == "homebrew" ]];then
    if [[ $os == "darwin" ]]; then
      # shellcheck disable=SC2016
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.autozshrc"
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ $os == "linux" ]]; then
      # shellcheck disable=SC2016
      echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.autozshrc"
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
  elif [[ $1 == "fnm" ]];then
    # shellcheck disable=SC2016
    echo 'eval "$(fnm env --use-on-cd --shell zsh)"' >> "$HOME/.autozshrc"
  elif [[ $1 == "nvim" ]];then
    {
      echo 'alias vim=nvim';
      echo 'export EDITOR=nvim';
      echo '# Ctrl-e open cli in nvim';
      echo 'autoload edit-command-line';
      echo 'zle -N edit-command-line';
      echo 'bindkey "^E" edit-command-line'
    } >> "$HOME/.autozshrc"
  elif [[ $1 == "batman" ]];then
    # shellcheck disable=SC2016
    echo 'eval "$(batpipe)"' >> "$HOME/.autozshrc"
  elif [[ $1 == "autojump" ]];then
      # shellcheck disable=SC2016
      echo '[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh' >> "$HOME/.autozshrc"
  elif [[ $1 == "nutter-tools" ]];then
    # shellcheck disable=SC2016
    echo 'export PATH="$HOME/nutter-tools/bin:$PATH"' >> "$HOME/.autozshrc"
  elif [[ $1 == "golang" ]]; then
    # shellcheck disable=SC2016
    echo 'export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"' >> "$HOME/.autozshrc"
  elif [[ $1 == "lazygit" ]]; then
    echo "alias lg=lazygit" >> "$HOME/.autozshrc"
  elif [[ $1 == "rust" ]]; then
    # shellcheck disable=SC2016
    echo '. "$HOME/.cargo/env"' >> "$HOME/.autozshrc"
    . "$HOME/.cargo/env"
    rustup completions zsh cargo > "$HOME/.zsh/zfunc/_cargo"
  elif [[ $1 == "fzf" ]]; then
    # shellcheck disable=SC2016
    echo 'eval "$(fzf --zsh)"' >> "$HOME/.autozshrc"
    if [[ $os == "darwin" ]]; then
      echo 'bindkey "ç" fzf-cd-widget' >> "$HOME/.autozshrc"
    fi
  elif [[ $1 == "eza" ]]; then
    echo 'alias ls=eza' >> "$HOME/.autozshrc"
  elif [[ $1 == "zoxide" ]]; then
    # shellcheck disable=SC2016
    echo 'eval "$(zoxide init zsh)"' >> "$HOME/.autozshrc"
    echo 'alias j=z' >> "$HOME/.autozshrc"
  elif [[ $1 == "p10k" ]]; then
    # shellcheck disable=SC2016
    echo '. $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme' >> "$HOME/.autozshrc"
  elif [[ $1 == "tmux" ]]; then
    # shellcheck disable=SC2016
    echo '. "$HOME/.config/tmux/tat.sh"' >> "$HOME/.autozshrc"
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

ask(){
  if [[ $YES = true ]]; then
    return 0
  fi
  read -r -p "$1 [Y/n] " response
  if [[ $response =~ ^[nN]$ ]]; then
    return 1
  elif [[ $response =~ ^[yY]$ ]] || [[ -z $response ]]; then
    return 0
  else
    printf "Invalid response. Please enter y or n\n"
    ask "$1"
  fi
}

install_rust() {
  if ! command -v rustup &> /dev/null; then
    if ask "Do you want to install rust"; then
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
      post_install_config rust
      return 0
    else
      echo "You chose not to install rust"
      return 1
    fi
  fi
  echo "Rust already installed"
  return 0
}

install_golang() {
  GO_VERSION=1.23.4
  if ! command -v go &> /dev/null; then
    if ask "Do you want to install golang"; then
      curl -o "$HOME/nutter-tools/go-$GO_VERSION.$os-$arch_alt.tar.gz" -L "https://golang.org/dl/go$GO_VERSION.$os-$arch_alt.tar.gz"
      rm -rf /usr/local/go
      sudo tar -C /usr/local -xzf "$HOME/nutter-tools/go-$GO_VERSION.$os-$arch_alt.tar.gz"
      rm "$HOME/nutter-tools/go-$GO_VERSION.$os-$arch_alt.tar.gz"
      post_install_config golang
    fi
  else
    echo "golang already installed"
  fi
}

## check if default shell is zsh
ensure_zsh() {
  if [[ $SHELL != *"zsh"* ]]; then
    printf "Current shell is set to %s\n" "$SHELL"
    printf "This script needs to run with zsh as default shell.\n"
    if ask "Do you want to change default shell to zsh"; then
      if ! command -v zsh &> /dev/null; then
          if ask "Do you want to install zsh"; then
            sudo nala install zsh
            printf "Tried installing zsh."
          fi
      fi
      if ! command -v zsh &> /dev/null; then
        printf "Can't find zsh in PATH. Please install zsh and run the script again.\nExiting...\n"
        exit 1
      fi
      chsh -s "$(which zsh)"
      printf "I have tried to set the default shell to zsh.\n"
      printf "You might need to restart the terminal, or even your machine for this to take effect.\n"
      exit 1
    else
      printf "Please change default shell to zsh and run the script again.\n"
      exit 1
    fi
  fi
  return 0
}

## check if last exected command failed
## $1: exit code of last command
## $2: flag to choose if script should exit
check_last_cmd(){
  last_command=$(history | tail -n 1 | sed 's/^[ ]*[0-9]*[ ]*//')
  if [[ $1 -ne 0 ]]; then
    printf "Last command: %s\n Failed with exit code %s\n" "$last_command" "$?"
    if [[ $2 -eq 1 ]]; then
      printf "Exiting...\n"
      exit 1
    fi
    exit 1
  fi
}

install_alacritty(){
  if ! command -v alacritty &> /dev/null; then
    if ! ask "Do you want to install alacritty"; then
      return 1
    fi
  else
    echo "Alacritty is already installed"
    return 0
  fi

  if ! install_rust; then
    printf "Rust is required to install alacritty.\nExiting alacritty installation.\n"
    return 1
  fi
  printf "Rust is installed, proceeding with alacritty installation\n"

  mkdir -p "$HOME"/nutter-tools
  cd "$HOME"/nutter-tools || return 1
  git clone https://github.com/alacritty/alacritty.git
  cd alacritty || exit
  rustup override set stable
  rustup update stable
  if ! ask "Cloned alacritty source under $HOME/nutter-tools. Continue?"; then
    echo "You chose not to install alacritty"
    return 1
  fi
  if [[ $os == "darwin" && $flavour == "macos" ]]; then
    make app
    cp -r target/release/osx/Alacritty.app /Applications/
    printf "Alacritty installed successfully\n"
    return 0
  fi
  printf "Installing alacritty dependencies\n."
  sudo nala install cmake g++ pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 gzip scdoc
  errno=$?
  check_last_cmd $errno 1
  if ! ask "Installed dependencies. Continue with installation?"; then
    echo "You chose not to install alacritty"
    return 1
  fi
  cargo build --release
  errno=$?
  check_last_cmd $errno 1
  if ! ask "Built alacratty binary. Continue the post build setup ?"; then
    printf "Binary build in target. Exiting alacritty installation.\n"
    return 1
  fi
  infocmp alacritty
  errno=$?
  if [[ $errno -ne 0 ]]; then
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
  printf "Alacritty installed successfully\n"
  cd "$DOTFILES" || exit
  return 1
}

configure_zsh() {
  rm -rf ~/.zsh
  mkdir -p "$HOME"/.zsh/zfunc
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
  git clone https://github.com/olets/zsh-abbr ~/.zsh/zsh-abbr --recurse-submodules --single-branch --branch v6 --depth 1
  git clone https://github.com/Aloxaf/fzf-tab ~/.zsh/fzf-tab

  {
    echo ". ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh";
    echo ". ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
    echo ". ~/.zsh/zsh-abbr/zsh-abbr.zsh";
    echo ". ~/.zsh/fzf-tab/fzf-tab.plugin.zsh";
    echo "zstyle :compinstall filename '~/.zshrc'";
    echo "fpath+=~/.zsh/zfunc";
    echo "fpath+=~/.zsh/zsh-completions/src";
    echo "autoload -Uz compinit";
    echo "compinit -D";
    echo "abbr import-aliases --quiet"
  } >> "$HOME"/.autozshrc

  echo "To recompile zsh-completions run: 'rm -f ~/.zcompdump; compinit'"
  echo ". $HOME/.autozshrc"
  # Add line to $HOME/.zshrc if not already present
  grep -q ".autozshrc" "$HOME/.zshrc" || echo ". $HOME/.autozshrc" >> "$HOME/.zshrc"
}

common_setup(){
  configure_zsh
  install_golang
  install_rust
  install_alacritty
  printf "Installing brave browser\n\n"
  curl -fsS https://dl.brave.com/install.sh | sh
}

minimal_setup_linux(){
  sudo apt-get update
  sudo apt-get -yq install coreutils gcc vim curl zsh ripgrep fzf
  if [ ! -d "$HOME/nutter-tools" ]; then
    mkdir -p "$HOME/nutter-tools/bin"
    post_install_config nutter-tools
  fi
  post_install_config fzf
  configure_zsh

  if ! command -v nvim &> /dev/null; then
    ubuntu_install_neovim
    mkdir -p "$HOME"/.config
    ln -s "$DOTFILES"/nvim "$HOME"/.config/nvim
  fi
}

pretty_exec(){
  printf "Executing:\n%s\n\n" "$1"
  eval "$1"
  printf "\n\n"
}

install_regolith(){
  if ! ask "Do you want to install Regolith"; then
    return 1
  fi
  printf "\nInstalling Regolith\n"
  keyring="/usr/share/keyrings/regolith-archive-keyring.gpg"
  apt_source_file="/etc/apt/sources.list.d/regolith.list"
  curl -s https://regolith-desktop.org/regolith.key | \
    gpg --dearmor | sudo tee $keyring > /dev/null
  printf "tee-ing the following to /etc/apt/sources.list.d/regolith.list :\n"
  case $release in
    "22.04")
      echo deb "[arch=amd64 signed-by=$keyring] \
        https://regolith-desktop.org/release-3_2-ubuntu-jammy-amd64 jammy main" | \
      sudo tee $apt_source_file
      ;;
    "24.04")
      echo deb "[arch=amd64 signed-by=$keyring] \
        https://regolith-desktop.org/release-3_2-ubuntu-noble-amd64 noble main" | \
      sudo tee $apt_source_file
      ;;
  esac
  pretty_exec "sudo nala update"
  pretty_exec "sudo nala install regolith-desktop regolith-session-flashback regolith-look-lascaille regolith-look-gruvbox regolith-look-i3-default"

  printf "Deleting \n\tkeyring: %s\n\tapt source file: %s\n" "$keyring" "$apt_source_file"
  rm -f $keyring
  rm -f $apt_source_file

  printf "\n\n\n"
  return 0
}

uninstall_regolith(){
  pretty_exec "sudo nala remove regolith-desktop regolith-session-flashback regolith-look-lascaille regolith-look-gruvbox regolith-look-i3-default"
  pretty_exec "sudo nala autoremove"
}

ubuntu_install_neovim(){
  if ! command -v nvim &> /dev/null; then
    curl -o "$HOME"/nutter-tools/nvim-linux64.tar.gz -L https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    tar -xvf "$HOME"/nutter-tools/nvim-linux64.tar.gz --directory "$HOME"/nutter-tools/
    ln -s "$HOME"/nutter-tools/nvim-linux64/bin/nvim "$HOME"/nutter-tools/bin/nvim
    rm "$HOME"/nutter-tools/nvim-linux64.tar.gz
    post_install_config nvim
  fi
}


declare -A brew_pkgs
brew_pkgs=(
  ["fzf"]="fzf"
  ["tmux"]="tmux"
  ["rg"]="ripgrep"
  ["nvim"]="neovim"
  ["unzip"]="unzip"
  ["htop"]="htop"
  ["bat"]="bat"
  ["batman"]="bat-extras"
  ["eza"]="eza"
  ["zoxide"]="zoxide"
  ["lazygit"]="lazygit"
  ["fnm"]="fnm"
  ["jq"]="jq"
  ["p10k"]="powerlevel10k"
  ["wget"]="wget"
)

install_brew_pkgs(){
  install_homebrew
  export HOMEBREW_NO_ENV_HINTS=TRUE
  # check if  nvim, htop, tmux, fzf, ripgrep, bat, bat-extra, eza, autojump, is installed, if not then install
  for pkg_cmd in "${!brew_pkgs[@]}"; do
    if ! command -v "$pkg_cmd" &> /dev/null; then
      if ask "Do you want to install ${brew_pkgs[$pkg_cmd]}"; then
        brew install --quiet "${brew_pkgs[$pkg_cmd]}"
        post_install_config "$pkg_cmd"
        printf "\n\n\n"
      fi
    else
      echo "${brew_pkgs[$pkg_cmd]} is already installed"
    fi
  done
}

uninstall_brew_pkgs(){
  if [[ ! -d /opt/homebrew ]] && [[ ! -d /home/linuxbrew ]]; then
      printf "Homebrew is not installed, so no packages to uninstall\n"
      return 0;
  fi
  if [[ $os == "darwin" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ $os == "linux" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
  for pkg_cmd in "${!brew_pkgs[@]}"; do
    if command -v "$pkg_cmd" &> /dev/null; then
      if ask "Do you want to uninstall ${brew_pkgs[$pkg_cmd]}"; then
        brew uninstall "${brew_pkgs[$pkg_cmd]}"
        printf "\n\n\n"
      fi
    else
      echo "${brew_pkgs[$pkg_cmd]} is not installed"
    fi
  done
  brew autoremove
  return 0
}

ubuntu_purge_snap(){
  if ! command -v snap &> /dev/null; then
    printf "Yayy! Loooks like snap is not installed\n"
    exit 0
  fi
  if ask "Do you want to remove all snap pakages, and disable snap competely ?"; then
    echo "Removing all Snap packages ..."
  else
    echo "You chose not to remove Snap packages. Exiting ..."
    return 1
  fi
  while true; do
    snap_packages=$(snap list 2> /dev/null| awk 'NR>1 {print $1}')
    if [[ -z "$snap_packages" ]]; then
      echo "All Snap packages have been removed."
      break
    fi
    # Try to remove each package
    for snap_package in $snap_packages; do
      echo "Attempting to remove Snap package: $snap_package"
      sudo snap remove --purge "$snap_package" || echo "Failed to remove $snap_package. Will retry."
    done
  done
  sudo systemctl stop snapd
  sudo systemctl disable snapd
  sudo systemctl mask snapd
  sudo apt-get -yq purge snapd
  sudo apt-mark hold snapd
  sudo rm -rf ~/snap
  sudo rm -rf /snap
  sudo rm -rf /var/snap
  sudo rm -rf /var/lib/snapd
  echo "Blocking Snap installation ..."
  sudo cat <<EOF | sudo tee /etc/apt/preferences.d/nosnap.pref
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF
  printf "Congratulations! You have Thanos snapped 🫰 Snap out of existence.\n\n"
}

## Fonts name map, for nerd fonts
## Key is the name of the font folder in nerd-fonts repo
## Find values by guessing, or https://gist.github.com/davidteren/898f2dcccd42d9f8680ec69a3a5d350e
declare -A fonts=(
  # BitstreamVeraSansMono
  # CodeNewRoman
  # DroidSansMono
  # ["FiraCode"]="fira-code"
  # ["FiraMono"]="fira-mono"
  # ["GeistMono"]="geist-mono"
  # Gohu
  # Go-Mono
  # Hack
  # Hasklig
  # Hermit
  ["JetBrainsMono"]="jetbrains-mono"
  # Meslo
  # Noto
  # Overpass
  # ProggyClean
  # RobotoMono
  # SourceCodePro
  # SpaceMono
  # ["Hasklig"]="hasklug"
  # ["Lilex"]="lilex"
  # ["Ubuntu"]="ubuntu"
  # ["UbuntuMono"]="ubuntu-mono"
  # ["UbuntuSans"]="ubuntu-sans"
)

ubuntu_install_fonts(){
  version='3.3.0'
  fonts_dir="$HOME/.local/share/fonts"
  if [[ ! -d "$fonts_dir" ]]; then
      mkdir -p "$fonts_dir"
  fi
  for font_name in "${!fonts[@]}"; do
    if [[ $UNINSTALL = true ]]; then
      find "$fonts_dir" -name "'*${font_name}*'" -delete
      continue
    else
      zip_file="${font_name}.zip"
      download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/${zip_file}"
      echo "Downloading $download_url"
      wget "$download_url"
      unzip "$zip_file" "*.ttf" -d "$fonts_dir"
      rm "$zip_file"
      continue
    fi
  done
  find "$fonts_dir" -name '*Windows Compatible*' -delete
  find "$fonts_dir" -name '*NLNerdFont*' -delete
  find "$fonts_dir" -name '*NerdFontPropo*' -delete
  find "$fonts_dir" -name '*NerdFontMono*' -delete
  fc-cache -fv
}

macos_install_fonts(){
  for font_name in "${!fonts[@]}"; do
    if [[ $UNINSTALL = true ]]; then
      brew uninstall --cask "font-${fonts[$font_name]}-nerd-font"
    else
      brew install --cask "font-${fonts[$font_name]}-nerd-font"
    fi
  done
}
## Function to install fonts
## This function will clone the NerdFonts repo and install the fonts
## It will also uninstall the fonts if the UNINSTALL flag is set
install_fonts(){
  if [[ $UNINSTALL = true ]]; then
    printf "\n\nUninstalling fonts\n"
  else
    printf "\n\nInstalling fonts\n"
  fi
  printf "This script will install/uninstall the following fonts: %s\n" "${fonts[@]}"
  if ! ask "Do you want to continue?"; then
    return 1
  fi
  case $os in
    linux) ubuntu_install_fonts ;;
    darwin) macos_install_fonts ;;
  esac
}

ubuntu_setup(){
  printf "This script will install bunch of packages and tools that I use on my system\n\n"
  printf "Going to install nala package manager, it is a front end to apt-get. \nIt has a better signal to noise ratio than using plain apt/apt-get\n\n"
  if  ! ask "Do you want to continue?"; then
    exit 1
  fi
  pretty_exec "sudo apt-get -qqy update"
  pretty_exec "sudo apt-get -qqy install nala"

  printf "\n\nInstalling the following important packages:\n\tcoreutils, gcc, curl, wget, build-essential\n"
  if ! ask "Do you want to continue."; then
    exit 1
  fi
  pretty_exec "sudo nala install coreutils gcc curl wget build-essential"
  install_regolith
  install_brew_pkgs
  ubuntu_purge_snap
}

ubuntu_unsetup(){
  uninstall_regolith
  uninstall_brew_pkgs
}

macos_setup(){
  install_brew_pkgs
  brew install --cask ghostty
}

macos_unsetup(){
  uninstall_brew_pkgs
  brew uninstall --cask ghostty
}

sym_link(){
  for pkg_config in nvim alacritty i3 tmux rofi regolith3 ghostty git helix rofi; do
    if [[ -d "$HOME"/.config/$pkg_config ]]; then
      if [[ -L "$HOME"/.config/$pkg_config ]]; then
        rm -rf "$HOME"/.config/$pkg_config
      else
        mv "$HOME"/.config/$pkg_config "$HOME"/.config/$pkg_config.bak
      fi
    fi
    ln -s "$DOTFILES"/$pkg_config "$HOME"/.config/$pkg_config
  done
}

setup() {
  ensure_zsh
  rm -f "$HOME"/.autozshrc
  printf "# THIS FILE HAS BEEN AUTO GENERATED. DO NOT EDIT MANUALLY\n\n" >> "$HOME/.autozshrc"
  if [ ! -d "$HOME/nutter-tools" ]; then
    mkdir -p "$HOME"/nutter-tools/bin
    post_install_config nutter-tools
  fi
  mkdir -p "$HOME"/.config
  case $os in
    linux) ubuntu_setup ;;
    darwin) macos_setup ;;
  esac
  common_setup
  sym_link
  install_fonts
}

unsetup() {
  UNINSTALL=true
  printf "Uninstalling all the packages and tools installed by this script\n"
  case $os in
    linux) ubuntu_unsetup ;;
    darwin) macos_unsetup ;;
  esac
  install_fonts
}

ubuntu_bootstrap(){
  printf "installing git and zsh\n"
  pretty_exec "sudo apt-get -qqy update"
  pretty_exec "sudo apt-get -qqy install zsh git"
  if [[ $SHELL != *"zsh"* ]]; then
    sudo chsh -s "$(which zsh)"
  fi
}

macos_bootstrap(){
  printf "Homebrew installation should also trigger Xcode CLI tools installation. Please follow the prompts\n\n"
  install_homebrew
}

bootstrap(){
  printf "This script will setup the system with my dotfiles and install the necessary packages and tools\n\n"
  if [[ $1 = "fonts" ]]; then
    install_fonts
    exit 0
  fi
  if [[ $UNINSTALL = true ]]; then
    unsetup
    exit 0
  fi
  DOTFILES="$HOME"/dev/config
  if [[ -d "$DOTFILES" ]]; then
    printf "Looks like, config repo already cloned to %s/dev/config. Continuing with setup\n\n" "$HOME"
    setup
    exit 0
  fi
  case $os in
    linux) ubuntu_bootstrap ;;
    darwin) macos_bootstrap ;;
    *)
      printf "Unknown OS, aborting...\n"
      exit 1
      ;;
  esac
  mkdir -p "$DOTFILES"
  printf "Cloning config repo to %s/dev/config\n" "$HOME"
  git clone https://github.com/adisuper94/config.git "$DOTFILES"
  cd "$DOTFILES" || exit 1
  setup
}

ARGS=$(getopt -o yhu --long yes,help,uninstall -- "$@")
eval set -- "$ARGS"
while true; do
  case "$1" in
    -y|--yes)
      YES=true
      shift
      ;;
    -h|--help)
      printf "Usage: setup.sh [-y|--yes] [-h|--help] [-u|--uninstall]\n"
      printf "Options:\n"
      printf "\t-y, --yes\n\t\t Automatic yes to prompts; assume 'yes' as answer to all prompts and run non-interactively\n"
      printf "\t-h, --help\n\t\t Display this help message and exit\n"
      printf "\t-u, --uninstall\n\t\t Uninstall all the packages and tools installed by this script\n"
      exit 0
      ;;
    -u|--uninstall)
      UNINSTALL=true
      exit 0
      ;;
    --)
      shift
      break
      ;;
  esac
done

bootstrap "$@"

# setup
# uninstall_regolith
# uninstall_brew_pkgs
