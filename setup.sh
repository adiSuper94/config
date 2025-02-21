#!/bin/bash

TAT=false

DOTFILES="$HOME"/dev/config
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. "$SCRIPT_DIR/bob/utils.sh"
read -r os _arch _arch_alt flavour _release < <(os_info)
read -r apt install _uninstall _update _autoremove < <(get_apt)

install_homebrew() {
  if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    grep -q "brew shellenv" "$HOME/.zshenv" || (
      # shellcheck disable=SC2016
      echo "Did not find brew shellenv in .zshenv, adding it" &&
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zshenv"
      eval "$(/opt/homebrew/bin/brew shellenv)"
  )
  else
    echo "Homebrew already installed"
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
            sudo "$apt" "$install" zsh
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

configure_zsh() {
  mkdir -p "$HOME"/.zsh/zfunc
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-completions.git ~/.zsh/zsh-completions
  git clone https://github.com/olets/zsh-abbr ~/.zsh/zsh-abbr --recurse-submodules --single-branch --branch v6 --depth 1
  git clone https://github.com/Aloxaf/fzf-tab ~/.zsh/fzf-tab
  rm -rf ~/powerlevel10k
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

  if [[ $TAT = true ]]; then
    # add this to first line of .zshrc
    printf "# Ensure that sourcing tat is the first line in .zshrc\n . %s/.tat/tat.sh\n" "$HOME" |
      cat - "$HOME/.zshrc" > /tmp/zshrc && mv /tmp/zshrc "$HOME/.zshrc"
  fi
  echo "To recompile zsh-completions run: 'rm -f ~/.zcompdump; compinit'"
}

ubuntu_purge_snap(){
  if ! command -v snap &> /dev/null; then
    printf "Yayy! Loooks like snap is not installed\n"
    return 0
  fi
  if ask "Do you want to remove all snap pakages, and disable snap competely ? This might break ubuntu ui"; then
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
  sudo apt purge snapd
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

os_specific_setup(){
  case $os in
    "linux")
      case $flavour in
        "ubuntu")
          ubuntu_purge_snap
          sudo apt update
          sudo apt install build-essential
          sudo apt install coreutils gcc curl wget unzip clang
          sudo apt install tmux htop jq rofi copyq redshift maim
          sudo apt install fd-find ripgrep eza bat kdiff3 variety
          sudo mv /usr/bin/fdfind /usr/bin/fd
          sudo mv /usr/bin/batcat /usr/bin/bat
          ;;
        "fedora")
          sudo dnf update
          sudo dnf group install development-tools c-development
          sudo dnf install coreutils gcc curl wget unzip clang
          sudo dnf install tmux htop jq rofi copyq redshift maim
          sudo dnf install bat ripgrep fd-find eza kdiff3 variety
          ;;
        *)
          printf "No OS specific setup for %s:%s\n" "$os" "$flavour"
          return 1
          ;;
      esac
      curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
      curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
      ;;
    "darwin")
      printf "Homebrew installation should also trigger Xcode CLI tools installation. Please follow the prompts\n\n"
      install_homebrew
      export HOMEBREW_NO_ENV_HINTS=TRUE
      brew install --quiet  tmux unzip htop jq wget bat bat-extras fnm zoxide fd ripgrep eza neovim
      brew install --cask nikitabobko/tap/aerospace
      brew install --cask kdfiff3
      brew install --cask copyq
    ;;
    *)
      printf "No OS specific setup for %s\n" "$os"
      return 1
      ;;
  esac
}

sym_link(){
  for pkg_config in nvim alacritty i3 tmux rofi regolith3 git helix rofi aerospace; do
    if [[ -d "$HOME"/.config/$pkg_config ]]; then
      if [[ -L "$HOME"/.config/$pkg_config ]]; then
        rm -rf "$HOME"/.config/$pkg_config
      else
        mv "$HOME/.config/$pkg_config" "$HOME/.config/${pkg_config}.bak"
      fi
    fi
    ln -s "$DOTFILES/$pkg_config" "$HOME/.config/$pkg_config"
  done
  rm -f "$HOME/nutter-tools/bin/irg" 2> /dev/null
  rm -f "$HOME/nutter-tools/bin/kbd" 2> /dev/null
  ln -s "$DOTFILES/kutti-scripts/irg" "$HOME/nutter-tools/bin/"
  ln -s "$DOTFILES/kutti-scripts/kbd" "$HOME/nutter-tools/bin/"
}

setup() {
  ensure_zsh
  os_specific_setup
  echo "Setting up basic tools"
  if [ ! -d "$HOME/nutter-tools" ]; then
    mkdir -p "$HOME"/nutter-tools/bin
  fi
  rm -rf ~/.zsh
  configure_zsh
  printf "\nInstalling brave browser\n\n"
  curl -fsS https://dl.brave.com/install.sh | sh
  sym_link
  printf "Basic setup complete\n. Use Bob to install more packages\n"
  exit 0
}
os_info "true"
setup
